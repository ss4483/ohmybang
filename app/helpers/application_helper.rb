module ApplicationHelper
    
  def full_title(page_title='')
    base_title = "오마방"
    page_title.empty? ? base_title : "#{page_title} - 오마방"
  end
  
  def image(img)
    send_data(img.file,
      filename: img.tag,
      disposition: "inline")
  end

  def room_img(room)
    if room == "원룸"
      return "room_01.jpg"
    elsif room == "투/쓰리룸"
      return "room_02.jpg"
    elsif room == "오피스텔"
      return "room_03.jpg"
    elsif room == "아파트"
      return "room_04.jpg"
    end
  end


  def is_recommend_img(txt)
    if txt == "t"
      return "good.png"
    elsif txt == "f"
      return "bad.png"
    else 
      return ""
    end
  end

  def score_img(score)
    case score
      when (0..2.4) 
        return "under_score.png"
      when (2.5..3.4) 
        return "middle_score.png"
      when (3.5..5)
        return "top_score.png"
      else
        return "what_score.png"
    end
  end

  def owner_score_img(score)
    case score
      when (0..2.4) 
        return "house_owner_under.png"
      when (2.5..3.4) 
        return "house_owner_middle.png"
      when (3.5..5)
        return "house_owner_top.png"
      else
        return "house_owner.png"
    end
  end

  def outside_score_img(score)
    case score
      when (0..2.4) 
        return "outside_the_room_under.png"
      when (2.5..3.4) 
        return "outside_the_room_middle.png"
      when (3.5..5)
        return "outside_the_room_top.png"
      else
        return "outside_the_room.png"
    end
  end

  def inside_score_img(score)
    case score
      when (0..2.4) 
        return "inside_the_room_under.png"
      when (2.5..3.4) 
        return "inside_the_room_middle.png"
      when (3.5..5)
        return "inside_the_room_top.png"
      else
        return "inside_the_room.png"
    end
  end


  def score_color(score)
    case score
      when (0..2.4) 
        return "#F53338"
      when (2.5..3.4) 
        return "#E3A61C"
      when (3.5..5)
        return "#60A233"
      else
        return "black"
    end
  end

  def review_status_color(str)
    if str == "임시저장"
      # return "#17a2b8"; 
      return "black"; 
    elsif str == "등록신청" || str == "환전신청"
      return "#223B65"; 
    elsif str == "등록반려" || str == "환전반려"
      return "#790F15"
      # return "#DB6557"; 
    elsif str == "수정신청"
      return "black"; 
    elsif str == "등록완료" || str == "환전완료"
      # return "#40867E"; 
      return "black"; 
    end
  end

  def write_reviews
    if user_signed_in?
      return "/reviews/new"
    else
      return "/reviews/manual"
    end
  end
end