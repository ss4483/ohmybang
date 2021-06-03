
class StaticsController < ApplicationController
 
  def intro
  end
  def index_2
    # @req_addresses = ReqAddress.order("updated_at DESC").limit(10)
    @req_comments = ReqComment.order("updated_at DESC").limit(5)
    # @reviews = Review.where(status: "등록완료").last(9)
    @reviews = Review.daily_picks
    @notices = Notice.order("created_at DESC").limit(4)
  end

  def index_3
    @req_comments = ReqComment.order("updated_at DESC").limit(5)
    @req_comment = ReqComment.order("updated_at DESC").first
    @notices = Notice.order("created_at DESC").limit(3)
    @reviews = Review.daily_picks
  end

end
