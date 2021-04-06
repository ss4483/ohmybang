class ViewersController < ApplicationController
  include ViewersHelper
  # skip_before_action :verify_authenticity_token, only: [:create]
  # before_action :authenticate_user!, except: [:create]
  before_action :authenticate_user!

  def index
    @first_items = @items[:first]
    @sec_items = @items[:sec]
  end

  def use
    if current_user.viewer_histories.map(&:review_id).include?(params[:id].to_i)
      # 이미 구매한 리뷰입니다.
      flash[:danger] = "이미 구매한 리뷰입니다."
      redirect_back(fallback_location: root_path)
    else
      if current_user_viewer > 0
        viewer = current_user.viewers.where("exp_date >= #{Date.current} OR exp_date IS NULL").where.not(count: 0).order("exp_date ASC").take

        viewer_history = ViewerHistory.create(viewer_count: 1, memo: "사용", user_id: current_user.id, review_id: params[:id], date_of_use: Time.now, viewer: viewer)
        viewer.update_columns(count: viewer.count - 1)
        # viewer.viewer_histories << viewer_history

        review = Review.find(params[:id])
        review_user = review.user
        if (!review_user.nil?)
          point = 
            review_user.points.find_by(exp_date: ((Date.current + 1.year).end_of_month)) || 
            Point.new(exp_date: ((Date.current + 1.year).end_of_month), user: review_user)
            # review_user.points.find_by(exp_date: Date.new(Date.current.year + 4, 12, 31)) || 
            # Point.new(exp_date: Date.new(Date.current.year + 4, 12, 31), user: review_user)
          
          if viewer.free == "t"
            point.pt = point.pt || 0
            point.save
            PointHistory.create(pt: 0, memo: "리뷰 조회", user: review_user, review: review, point: point)
          else
            point.pt = @items[:first][:increase_pt] + (point.pt || 0)
            point.save
            PointHistory.create(pt: @items[:first][:increase_pt], memo: "리뷰 조회", user: review_user, review: review, point: point)
          end
        else 
          PointHistory.create(pt: @increase_pt, memo: "탈퇴한 회원의 리뷰 조회", user: User.find_by(role: "manager"), review: review, point: point)
        end
        review.update_columns(editable: "f") unless ViewerHistory.find_by(review_id: review.id).nil?
        # debugger
        redirect_to "/reviews/#{review.id}"
      else
        flash[:danger] = "리뷰 이용권이 없습니다.\n리뷰 이용권을 구매해주세요."
        redirect_back(fallback_location: root_path)
      end
    end
  end


  def new
    kind = params[:kind]
    items = @items[:"#{kind}"]
    if params[:type].to_i == items[:type_1][:amount]
      @item_hash = {
        kind: kind,
        amount: items[:type_1][:amount],
        price: items[:type_1][:price]
      }
    elsif params[:type].to_i == items[:type_2][:amount]
      @item_hash = {
        kind: kind,
        amount: items[:type_2][:amount],
        price: items[:type_2][:price]
      }
    elsif params[:type].to_i == items[:type_3][:amount]
      @item_hash = {
        kind: kind,
        amount: items[:type_3][:amount],
        price: items[:type_3][:price]
      }
    else 
      flash[:danger] = "잘못 된 접근입니다."
      redirect_back(fallback_location: root_path)
    end
    @item = Struct.new(*@item_hash.keys).new(*@item_hash.values)
  end

  def create
    imp_uid = params[:imp_uid] # post ajax request로부터 imp_uid확인
    merchant_uid = params[:merchant_uid]
    paid_amount = params[:paid_amount].to_i # 결제되었어야 하는 금액 조회. 가맹점에서는 merchant_uid기준으로 관리
  
    payment_result = Iamport.payment(imp_uid)  # imp_uid로 아임포트로부터 결제정보 조회
    
    
    kind = params[:item_kind] 
    items = @items[:"#{kind}"]
    item_price = 
      if params[:item_type].to_i == items[:type_1][:amount]
        items[:type_1][:price]
      elsif params[:item_type].to_i == items[:type_2][:amount]
        items[:type_2][:price]
      elsif params[:item_type].to_i == items[:type_3][:amount]
        items[:type_3][:price]
      end

    price = item_price * params[:item_count].to_i
    
    @viewer = 
      if kind == "first"
        Viewer.new
      elsif kind == "sec"
        SecViewer.new
      end
    if payment_result.parsed_response["response"]["status"] == 'paid' && payment_result.parsed_response["response"]["amount"] == price && (price == paid_amount)
      # 결제까지 성공적으로 완료
      @viewer.user = current_user
      @viewer.count =  params[:item_type].to_i * params[:item_count].to_i
      @viewer.item_type = params[:item_type]
      @viewer.item_price = item_price
      @viewer.item_count = params[:item_count]
      @viewer.price = price
      @viewer.free = "f"
      # @viewer.exp_date = Date.new(Date.current.year + 4, 12, 31)
      @viewer.exp_date = ((Date.current + 1.year).end_of_month)
      
      @viewer.imp_uid = payment_result.parsed_response["response"]["imp_uid"]
      @viewer.merchant_uid = merchant_uid
      @viewer.receipt_url = payment_result.parsed_response["response"]["receipt_url"]
      
      @viewer.save
  
      flash[:success] = "구매에 성공하였습니다."
      render json: { result: 'success' }
    else 
      # 결제실패 처리
      body = {
        imp_uid: imp_uid,
        merchant_uid: merchant_uid,
        amount: paid_amount
      }
      Iamport.cancel(body)

      flash[:danger] = "구매에 실패하여 결제를 취소합니다.\n다시 시도해주세요."
      render json: { result: 'fail' }
    end

  end

  def payment_mobile 
    # {"item_type"=>"10",
    #   "item_count"=>"1",
    #   "item_price"=>"15000",
    #   "paid_amount"=>"15000",
    #   "item_kind"=>"first",
    #   "referer"=>"undefinedimp_uid=imp_406379783568",
    #   "merchant_uid"=>"merchant_first_10_1590755379615",
    #   "imp_success"=>"false",
    #   "error_msg"=>"사용자가 결제를 취소하셨습니다"}
    if params["imp_success"] == "true"
      imp_uid = params[:imp_uid] # post ajax request로부터 imp_uid확인
      merchant_uid = params[:merchant_uid]
      paid_amount = params[:paid_amount].to_i # 결제되었어야 하는 금액 조회. 가맹점에서는 merchant_uid기준으로 관리
    
      payment_result = Iamport.payment(imp_uid)  # imp_uid로 아임포트로부터 결제정보 조회

      kind = params[:item_kind] 
      items = @items[:"#{kind}"]
      item_price = 
        if params[:item_type].to_i == items[:type_1][:amount]
          items[:type_1][:price]
        elsif params[:item_type].to_i == items[:type_2][:amount]
          items[:type_2][:price]
        elsif params[:item_type].to_i == items[:type_3][:amount]
          items[:type_3][:price]
        end

      price = item_price * params[:item_count].to_i
      
      @viewer = 
        if kind == "first"
          Viewer.new
        elsif kind == "sec"
          SecViewer.new
        end
      if payment_result.parsed_response["response"]["status"] == 'paid' && payment_result.parsed_response["response"]["amount"] == price && (price == paid_amount)
        # 결제까지 성공적으로 완료
        @viewer.user = current_user
        @viewer.count =  params[:item_type].to_i * params[:item_count].to_i
        @viewer.item_type = params[:item_type]
        @viewer.item_price = item_price
        @viewer.item_count = params[:item_count]
        @viewer.price = price
        @viewer.free = "f"
        # @viewer.exp_date = Date.new(Date.current.year + 4, 12, 31)
        @viewer.exp_date = ((Date.current + 1.year).end_of_month)
        
        @viewer.imp_uid = payment_result.parsed_response["response"]["imp_uid"]
        @viewer.merchant_uid = merchant_uid
        @viewer.receipt_url = payment_result.parsed_response["response"]["receipt_url"]
        
        @viewer.save
      

        redirect_url = ""
        if params[:referer].match(/(\/reviews\/)\d+/)
          redirect_url = params[:referer]
        else
          redirect_url = "/mypage/viewers";
        end

        redirect_to redirect_url, flash: { success: "구매에 성공하였습니다." }



      else 
        # 결제실패 처리
        body = {
          imp_uid: imp_uid,
          merchant_uid: merchant_uid,
          amount: paid_amount
        }
        Iamport.cancel(body)

        redirect_back(fallback_location: root_path, flash: { danger: "구매에 실패하여 결제를 취소합니다.\n다시 시도해주세요." })

      end
    else 
      redirect_back(fallback_location: root_path, flash: { danger: "구매에 실패하여 결제를 취소합니다.\n다시 시도해주세요." })
    end
  end

  def delete
    viewer = Viewer.find(params[:id])
    if viewer.created_at + 7.days >= Time.now
      if viewer.count == viewer.item_type * viewer.item_count
        #  전액 환불
        body = {
          reason: params[:reason],
          imp_uid: viewer.imp_uid,
          merchant_uid: viewer.merchant_uid
          # amount: paid_amount # 누락이면 전체 취소
        }
        Iamport.cancel(body)

        viewer_history = ViewerHistory.create(viewer_count: viewer.count, memo: "환불", user_id: current_user.id, date_of_use: Time.now, viewer: viewer)
        viewer.update_columns(count: 0)

        flash[:success] = "정상적으로 환불되었습니다."
        render json: { result: '정상적으로 환불되었습니다.' }
      else 
        flash[:success] = "사용된 이용권은 고객센터로 문의해주세요."
        render json: { result: '사용된 이용권은 고객센터로 문의해주세요.' }
      end
    else 
      flash[:success] = "구매 후 7일이 지나면 환불이 불가능합니다."
      render json: { result: '구매 후 7일이 지나면 환불이 불가능합니다.' }
    end
  end

  
end
