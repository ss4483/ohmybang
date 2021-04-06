class NoticesController < ApplicationController
  def index
    if params[:type] == "notice"
      @notices = Notice.where(post_type: "공지")
    elsif params[:type] == "event"
      @notices = Notice.where(post_type: "이벤트")
    else
      @notices = Notice.where.not(post_type: "당첨발표")
    end

    @notices = @notices.order("created_at DESC").page(params[:page]).per(10)

  end
end
