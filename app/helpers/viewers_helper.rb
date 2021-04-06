module ViewersHelper
  def current_user_viewer
    viewers = current_user.viewers.where("exp_date >= #{Date.current} OR exp_date IS NULL")
    if viewers.empty?
      return 0
    else
      return viewers.map(&:count).inject(0, :+)
    end
  end

  def current_user_sec_viewer
    sec_viewers = current_user.sec_viewers.where("exp_date >= #{Date.current} OR exp_date IS NULL")
    if sec_viewers.empty?
      return 0
    else
      return sec_viewers.map(&:count).inject(0, :+)
    end
  end
  
  def check_cancel(viewer)
    return viewer.created_at + 7.days >= Time.now && viewer.count == viewer.item_type * viewer.item_count
  end

end
