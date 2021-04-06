class MypageController < ApplicationController
  before_action :authenticate_user!
  def reviews
    @reviews = current_user.reviews.where.not(status: [nil, "수정신청", "수정반려"]).order("created_at DESC").page(params[:page])

    @point_histories = current_user.point_histories.order("created_at DESC").page(params[:history_page]).per(5)
    
    current_exchanges = current_user.exchanges
    # 현재 포인트
    @available_pt = current_user.points.where("pt > 0 AND exp_date > ?", Date.current).map(&:pt).inject(0, :+)  
    # 누적 포인트
    @cumulative_points = current_user.point_histories.where.not("memo LIKE ?", "환전%").map(&:pt).inject(0, :+)
    # 환전한 포인트
    @exchanged_points = current_exchanges.where(status: "환전완료").map(&:pt).inject(0, :+).to_i
    # 누적 환전 금액
    @exchanged_money = current_exchanges.where(status: "환전완료").map(&:actual_money).inject(0, :+).to_i

    @exchanges = current_user.exchanges.order("created_at DESC").page(params[:ex_page]).per(5)
  end
  
  def owner_comments
    @comments = current_user.owner_comments.where.not(status: nil).order("created_at DESC").page(params[:page])
  end

  def viewers
    @review_histories = Review.where(id: current_user.histories)
    # @viewers = current_user.viewers.order("created_at DESC").page(params[:page])
    @viewers = Kaminari.paginate_array((current_user.viewers + current_user.sec_viewers).sort_by(&:created_at)).page(params[:page])
  end

end
