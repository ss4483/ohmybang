class SecViewersController < ApplicationController
  include ViewersHelper
  before_action :authenticate_user!

  def use
    if current_user.sec_viewer_histories.map(&:review_id).include?(params[:id].to_i)
      # 이미 구매한 리뷰입니다.
      flash[:danger] = "이미 구매한 리뷰입니다."
      redirect_back(fallback_location: root_path)
    else
      if current_user_sec_viewer > 0
        viewer = current_user.sec_viewers.where("exp_date >= #{Date.current} OR exp_date IS NULL").where.not(count: 0).order("exp_date ASC").take

        viewer_history = SecViewerHistory.create(viewer_count: 1, memo: "사용", user_id: current_user.id, review_id: params[:id], date_of_use: Time.now, sec_viewer: viewer)
        viewer.update_columns(count: viewer.count - 1)
        # viewer.viewer_histories << viewer_history

        review = Review.find(params[:id])
        review_user = review.user

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
            PointHistory.create(pt: 0, memo: "전/월세금 조회", user: review_user, review: review, point: point)
          else
            point.pt = @items[:sec][:increase_pt] + (point.pt || 0)
            point.save
            PointHistory.create(pt: @items[:sec][:increase_pt], memo: "전/월세금 조회", user: review_user, review: review, point: point)
          end
        else 
          PointHistory.create(pt: @items[:sec][:increase_pt], memo: "탈퇴한 회원의 전/월세금 조회", user: User.find_by(role: "manager"), review: review, point: point)
        end
        review.update_columns(editable: "f") unless SecViewerHistory.find_by(review_id: review.id).nil?
        redirect_to "/reviews/#{review.id}"
      else
        flash[:danger] = "전/월세금 이용권이 없습니다.\n전/월세금 이용권을 구매해주세요."
        redirect_back(fallback_location: root_path)
      end
    end
  end



  def delete
    sec_viewer = SecViewer.find(params[:id])
    if sec_viewer.created_at + 7.days >= Time.now
      if sec_viewer.count == sec_viewer.item_type * sec_viewer.item_count
        body = {
          reason: params[:reason],
          imp_uid: sec_viewer.imp_uid,
          merchant_uid: sec_viewer.merchant_uid,
          # amount: paid_amount # 누락이면 전체 취소
        }
        Iamport.cancel(body)

        viewer_history = SecViewerHistory.create(viewer_count: sec_viewer.count, memo: "환불", user_id: current_user.id, date_of_use: Time.now, sec_viewer: sec_viewer)
        sec_viewer.update_columns(count: 0)

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
