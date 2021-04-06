class ReviewConfirmsController < ApplicationController
  include ReviewsHelper
  
  before_action :authenticate_user!
  before_action :check_manager

  # imp_status, :string, default: "완료"
  # add_column :reviews, :deposit, :integer, default: 0
  # add_column :reviews, :monthly, :integer, default: 0
  # add_column :reviews, :contract_type, :string, default: ""
  # @status = ["미작성", "임시저장", "등록신청", "등록반려", "등록완료", "수정신청", "수정반려"]

  def reject_create
    review = Review.find(params[:review_id])

    review.update_columns(status: @status[3]) 

    review_confirm = ReviewConfirm.new
    review_confirm.memo = params[:memo]
    review_confirm.status = @status[3]
    review_confirm.confirm_type = "리뷰"
    review_confirm.review =  review
    review_confirm.save
    
    flash[:info] = "정상적으로 \"반려\" 되었습니다."
    redirect_back(fallback_location: root_path)
  end
  def confirm_create
    @review = Review.find(params[:review_id])

    @review.update_columns(status: @status[4]) 
    
    # @review.update_columns(editable: "f") unless ViewerHistory.find_by(review_id: review.id).nil?

    @review_confirm = ReviewConfirm.create(
                      status: @status[4],
                      confirm_type: "리뷰", 
                      review: @review
                    )

    # 증빙 이미지 삭제
    # review.review_imp_imgs.destroy_all if ReviewConfirm.where(review: review, status: "등록완료").count == 1

    # 뷰어 증정
    if @review.status == @status[4] && 
      ReviewConfirm.where(review: @review, confirm_type: "리뷰", status: @status[4]).count == 1

      Viewer.create(
        viewer_type: "이벤트",
        user: @review.user,
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
       # @viewer.exp_date = Date.new(Date.current.year + 4, 12, 31)
    
    #  공공임대주택 확인
    checkRentalHouse(@review)

    flash[:info] = "정상적으로 \"완료\" 되었습니다."
    redirect_back(fallback_location: root_path)
  end


  def edit_reject_create
    @review = Review.find(params[:id])

    ReviewConfirm.create( status: @status[6], memo: params[:memo], review: @review, confirm_type: "리뷰" )
    @review.edit_review.update_columns(status: @status[6]) 

    flash[:info] = "정상적으로 \"반려\" 되었습니다."
    redirect_back(fallback_location: root_path)
  end

  def edit_confirm_create
    @review = Review.find(params[:id])

    @edit_review = @review.edit_review

    @review.update_columns(
      main_img_name: @edit_review.main_img_name, 
      main_img: @edit_review.main_img, 
      main_img_content_type: @edit_review.main_img_content_type, 
      room: @edit_review.room, 

      start_year: @edit_review.start_year, 
      end_year: @edit_review.end_year, 
      pet: @edit_review.pet, 
      loan_1: @edit_review.loan_1, 
      elevator: @edit_review.elevator, 
      balcony: @edit_review.balcony,
      is_recommend: @edit_review.is_recommend, 

      hourly_seasonal_txt: @edit_review.hourly_seasonal_txt, 
      short_comment: @edit_review.short_comment, 
      long_comment: @edit_review.long_comment, 

      deposit: @edit_review.deposit, 
      monthly: @edit_review.monthly, 
      contract_type: @edit_review.contract_type, 
      management_fee: @edit_review.management_fee, 
      management_type: @edit_review.management_type, 
      parking: @edit_review.parking, 
      area_pyeong: @edit_review.area_pyeong, 
      area_square: @edit_review.area_square, 
      structure: @edit_review.structure, 
      usage: @edit_review.usage, 
      floor_detail: @edit_review.floor_detail, 

      start_date: @edit_review.start_date, 
      end_date: @edit_review.end_date,
      floor: @edit_review.floor
    )

    review_tags.each do |k, v|
      review_item(@review, k, @edit_review)
    end      

    @edit_review.destroy
    
    ReviewConfirm.create( status: @status[4], review: @review, confirm_type: "리뷰" )
    
    flash[:info] = "정상적으로 \"완료\" 되었습니다."
    redirect_back(fallback_location: root_path)
  end


  # ReviewItem create & update
  def review_item(review, tag, edit_review)
    item = review.review_items.find_by(tag: tag)
    edit_item = edit_review.review_items.find_by(tag: tag)

    item.update_columns(score: edit_item.score, comment: edit_item.comment)
    
    remove_video_ids = item.review_videos.map(&:id)
    remove_img_ids = item.review_imgs.map(&:id)
    
    ReviewVideo.where(id: remove_video_ids).destroy_all if !remove_video_ids.empty?
    ReviewImg.where(id: remove_img_ids).destroy_all if !remove_img_ids.empty?
    
    if edit_item.review_imgs.present?
      edit_item.review_imgs.each do |img|
        ReviewImg.create(tag: tag,
          name: img.name,
          content_type: img.content_type,
          file: img.file,
          review_item: item,
          review: review)
      end
    end
    if edit_item.review_videos.present?
      edit_item.review_videos.each do |img|
        ReviewVideo.create(tag: tag,
          name: img.name,
          content_type: img.content_type,
          file: img.file,
          review_item: item,
          review: review)
      end
    end
  end

end
