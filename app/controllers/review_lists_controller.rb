class ReviewListsController < ApplicationController
  def index 
    @reviews = Review.where(status: "등록완료")
    @locations = @reviews.map(&:si_nm).group_by(&:itself).transform_values(&:count)
    @rooms = @reviews.map(&:room).group_by(&:itself).transform_values(&:count)
    
    
    @reviews = @reviews.where(si_nm: params[:loc]) if params[:loc].present?
    @reviews = @reviews.where(room: params[:room]) if params[:room].present?

    @reviews = @reviews.where(id: ReviewImg.select(:review_id).map(&:review_id).uniq) if params[:opt].include?("img") if params[:opt]

    @reviews = @reviews.where(id: ReviewVideo.select(:review_id).map(&:review_id).uniq) if params[:opt].include?("video") if params[:opt]

    

    if params[:txt]
      review_h = ReviewItem.joins(:review).where.not(comment: nil, review_id: 1).where("reviews.status = '등록완료'").select('comment, review_id').group_by(&:review_id)

      review_h.each_with_index do |(k, v), i|
        txt_length = 0
        txt_length += v.map(&:comment).map(&:length).inject(0, :+)
        txt_length += Review.find(k).long_comment.to_s.length
        review_h[k] = txt_length
      end

      review_ids = review_h.select{|k,v| v >= params[:txt].to_i}.keys
      @reviews = @reviews.where(id: review_ids)
    end

    @review_count = @reviews.count
    @reviews = @reviews.page(params[:page]).per(10)

    @viewer_histories = Array.new
    if user_signed_in?
      @viewer_histories = current_user.viewer_histories.map(&:review_id).compact
    end
  end
end
