class ManagersController < ApplicationController
  require 'rest-client'
  require 'uri'
  before_action :authenticate_user!
  before_action :check_manager

  def reviews
    if !params[:type].present?
      @reviews = Review.where.not(imp_status: @imp_status[2]).order("updated_at DESC").page(params[:page])
    elsif params[:type] == "all"
      @reviews = Review.where.not(status: [nil, "수정신청", "수정반려", "sample"]).order("updated_at DESC").page(params[:page])
    elsif params[:type] == "수정신청"
      @reviews = Review.where(id: Review.where.not(original_id: nil, status: "수정반려").pluck(:original_id)).order("updated_at DESC").page(params[:page])
    elsif params[:type] == "수정반려"
      @reviews = Review.where(id: Review.where.not(original_id: nil, status: "수정신청").pluck(:original_id)).order("updated_at DESC").page(params[:page])
    elsif params[:type].present?
      @reviews = Review.where(status: params[:type]).order("updated_at DESC").page(params[:page])
    else
      @reviews = Review.where(status: "등록신청").order("updated_at DESC").page(params[:page])
    end
    @review_imp_0 = Review.where.not(imp_status: @imp_status[2]).order("updated_at DESC").count
    @review_0 = Review.where.not(status: [nil, "수정신청", "수정반려", "sample"]).count
    @review_1 = Review.where(status: "등록신청").count
    @review_2 = Review.where(status: "수정신청").count
    @review_3 = Review.where(status: "수정반려").count
    @review_4 = Review.where(status: "등록반려").count
    @review_5 = Review.where(status: "임시저장").count
    @review_6 = Review.where(status: "등록완료").count - @review_2 - @review_3
  end

  def owner_comments
    if params[:type].present? && params[:type] == "all"
      @owner_comments = OwnerComment.where.not(status: nil).order("updated_at DESC").page(params[:page])
    elsif params[:type].present?
      @owner_comments = OwnerComment.where(status: params[:type]).order("updated_at DESC").page(params[:page])
    else
      @owner_comments = OwnerComment.where(status: "등록신청").order("updated_at DESC").page(params[:page])
    end

    @count_0 = OwnerComment.where.not(status: nil).count
    @count_1 = OwnerComment.where(status: "등록신청").count
    @count_2 = OwnerComment.where(status: "수정신청").count
    @count_3 = OwnerComment.where(status: "수정반려").count
    @count_4 = OwnerComment.where(status: "등록반려").count
    @count_5 = OwnerComment.where(status: "임시저장").count
    @count_6 = OwnerComment.where(status: "등록완료").count
  end

  def exchanges
    if params[:type].present? && params[:type] == "all"
      @exchanges = Exchange.all.order("updated_at DESC").page(params[:page])
    elsif params[:type].present?
      @exchanges = Exchange.where(status: params[:type]).order("updated_at DESC").page(params[:page])
    else
      @exchanges = Exchange.where(status: "환전신청").order("updated_at DESC").page(params[:page])
    end
  end

  def reviews_edit
    @review = Review.find(params[:id])
  end
  def reviews_update
    @review = Review.find(params[:id])
    if params[:confirm] == "t"
      ReviewConfirm.create( status: @imp_status[2], review: @review, confirm_type: "증빙" ) if @review.imp_status != @imp_status[2]

      if params[:review].present?
        geocoding = get_geocoding(params[:review][:address]) 

        @review.update_columns(
          lat: geocoding["addresses"][0]["y"],
          long: geocoding["addresses"][0]["x"],
          address: params[:review][:address],
          detail_address: params[:review][:detail_address].gsub(/\s+/, ""),
          extra_address: params[:review][:extra_address],
          bd_nm: params[:review][:bd_nm],
          si_nm: params[:review][:si_nm],
          sgg_nm: params[:review][:sgg_nm],
          emd_nm: params[:review][:emd_nm],
          room: params[:review][:room],
          contract_type: params[:contract_type],
          deposit: params[:deposit],
          monthly: params[:monthly],
          area_pyeong: params[:area_pyeong],
          area_square: params[:area_square],
          structure: params[:structure],
          usage: params[:usage],
          floor_detail: params[:floor_detail],
          start_date: params[:start_date],
          end_date: params[:end_date],
          contract_date: params[:contract_date],
          imp_status: @imp_status[2]
        )
      else
        @review.update_columns(imp_status: @imp_status[2])
      end
    elsif params[:confirm] == "f"
      ReviewConfirm.create( status: @imp_status[1], memo: params[:memo], review: @review, confirm_type: "증빙" )
      @review.update_columns(imp_status: @imp_status[1]) 
    end

    # 계약서 && 현재 @review.imp_status == @imp_status[2] && review_confrim.where(confirm_type: "증빙"). @imp_status[2]이 한개 일때 
    # 뷰어 증정
    if @review.review_imp_imgs.pluck(:tag).first == "계약서" && 
        @review.imp_status == @imp_status[2] &&
        ReviewConfirm.where(review: @review, confirm_type: "증빙", status: @imp_status[2]).count == 1
      
      SecViewer.create(
        user: @review.user,
        viewer_type: "이벤트",
        count: 1,
        item_type: 1,
        item_count: 1,
        exp_date: ((Date.current + 1.year).end_of_month),
        free: "t",
        item_price: nil,
        price: nil,
        imp_uid: nil,
        merchant_uid: nil,
        receipt_url: nil
      )
    end

    redirect_to '/managers/reviews'
  end

  # lat, long 검색
  def get_geocoding(address)
    JSON.parse( RestClient::Request.execute(
      method:  :get, 
      url:     "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=#{URI::encode( address.force_encoding('UTF-8'))}",
      headers: { Accept: "application/json", "X-NCP-APIGW-API-KEY-ID": ENV["X-NCP-APIGW-API-KEY-ID"], "X-NCP-APIGW-API-KEY": ENV["X-NCP-APIGW-API-KEY"]}
    ) )
  end

end
