module ReviewListsHelper
  def get_path
    fullpath = request.fullpath
    fullpath.slice!(request.path)
    fullpath.empty?? "?" : fullpath 
  end

  def include_loc(loc)
    params[:loc]? params[:loc].include?(loc) : false
  end
  def loc_href(loc)
    params_h = 
      { 
        loc: params[:loc].dup, 
        room: params[:room].dup,
        opt: params[:opt].dup,
        txt: [params[:txt].dup]
      }
    link = "?"
    if loc == "all"
      params_h[:loc] = []
      params_h.each do |k, v|
        link += (v.map {|_v| "#{k}#{"[]" if k != :txt}=#{_v}"}).join('') unless v.nil?
        link += "&" unless v.nil?
      end
      return link.sub("?&", "?").sub("&&", "&")
    elsif include_loc(loc)
      params_h[:loc].delete(loc)
      params_h.each do |k, v|
        link += (v.map {|_v| "#{k}#{"[]" if k != :txt}=#{_v}"}).join('') unless v.nil?
        link += "&" unless v.nil?
      end
      return link.sub("?&", "?").sub("&&", "&")
    else
      (get_path + "&loc[]=#{loc}").sub("?&", "?").sub("&&", "&")
    end
  end

  def include_room(room)
    params[:room]? params[:room].include?(room) : false
  end
  def room_href(room)
    params_h = 
      { 
        loc: params[:loc].dup, 
        room: params[:room].dup,
        opt: params[:opt].dup,
        txt: [params[:txt].dup]
      }
    link = "?"
    if room == "all"
      params_h[:room] = []
      params_h.each do |k, v|
        link += (v.map {|_v| "#{k}#{"[]" if k != :txt}=#{_v}"}).join('') unless v.nil?
        link += "&" unless v.nil?
      end
      return link.sub("?&", "?").sub("&&", "&")
    elsif include_room(room)
      params_h[:room].delete(room)
      params_h.each do |k, v|
        link += (v.map {|_v| "#{k}#{"[]" if k != :txt}=#{_v}"}).join('') unless v.nil?
        link += "&" unless v.nil?
      end
      return link.sub("?&", "?").sub("&&", "&")
    else
      (get_path + "&room[]=#{room}").sub("?&", "?").sub("&&", "&")
    end
  end

  def include_opt(opt)
    params[:opt]? params[:opt].include?(opt) : false
  end
  def opt_href(opt)
    params_h = 
      { 
        loc: params[:loc].dup, 
        room: params[:room].dup,
        opt: params[:opt].dup,
        txt: [params[:txt].dup]
      }
    link = "?"
    if include_opt(opt)
      params_h[:opt].delete(opt)
      params_h.each do |k, v|
        link += (v.map {|_v| "#{k}#{"[]" if k != :txt}=#{_v}"}).join('') unless v.nil?
        link += "&" unless v.nil?
      end
      return link.sub("?&", "?").sub("&&", "&")
    else
      (get_path + "&opt[]=#{opt}").sub("?&", "?").sub("&&", "&")
    end
  end

  def include_txt(txt)
    params[:txt]? (params[:txt] == txt) : false
  end
  def txt_href(txt)
    params_h = 
      { 
        loc: params[:loc].dup, 
        room: params[:room].dup,
        opt: params[:opt].dup,
        txt: [params[:txt].dup]
      }
    link = "?"
    if include_txt(txt)
      params_h[:txt].delete(txt)
      params_h.each do |k, v|
        link += (v.map {|_v| "#{k}#{"[]" if k != :txt}=#{_v}"}).join('') unless v.nil?
        link += "&" unless v.nil?
      end
      return link.sub("?&", "?").sub("&&", "&")
    else
      params_h[:txt] = [txt]
      params_h.each do |k, v|
        link += (v.map {|_v| "#{k}#{"[]" if k != :txt}=#{_v}"}).join('') unless v.nil?
        link += "&" unless v.nil?
      end
      return link.sub("?&", "?").sub("&&", "&")
    end
  end

  def get_params() 
    params_h = { txt: params[:txt].dup, loc: [], room: [], opt: [] }

    # loc[]= params[:loc] room[]=원룸 opt[]=img opt[]=video
    params[:loc].each { |loc| params_h[:loc] << loc } unless params[:loc].nil?
    params[:room].each { |room| params_h[:room] << room } unless params[:room].nil?
    params[:opt].each { |opt| params_h[:opt] << opt } unless params[:opt].nil?

    return params_h
  end
end
