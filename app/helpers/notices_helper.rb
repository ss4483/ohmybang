module NoticesHelper
  def notice_subtitle(post_type)
    if post_type == "notice"
      "- 공지"
    elsif post_type == "event"
      "- 이벤트"
    end
  end 

  def event_remaining_period(notice)
    if notice.post_type == "공지"
    elsif notice.end_date < Date.today
      "<span class='badge badge-secondary'>종료</span>".html_safe
    elsif notice.start_date > Date.today
      "<span class='badge badge-info'>예정</span>".html_safe
    else
      "<span class='badge badge-success'>#{(notice.end_date - Date.today).to_i} 일 남음</span>".html_safe
    end
  end
end
