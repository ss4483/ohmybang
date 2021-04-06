
class StaticsController < ApplicationController
 
  def intro
    # flash[:danger] = '권한이 없습니다.'
    # flash[:info] = '권한이 없습니다.'

    # &resultType=json&countPerPage=20&keyword=#{URI::encode(params[:keyword].force_encoding('UTF-8'))}
    @data = JSON.parse( RestClient::Request.execute(
      method:  :get, 
      url:     "https://data.myhome.go.kr:443/rentalHouseList?serviceKey=#{ENV["RENTAL-HOUSE-LIST-DATA-KEY"]}&brtcCode=11&signguCode=140&numOfRows=10&pageNo=1",
      headers: { Accept: "application/json"}
    ))
    p "https://data.myhome.go.kr:443/rentalHouseList?serviceKey=#{ENV["RENTAL-HOUSE-LIST-DATA-KEY"]}&brtcCode=11&signguCode=140&numOfRows=10&pageNo=1"
    p @data
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
