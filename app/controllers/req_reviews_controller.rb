class ReqReviewsController < ApplicationController
  def index
    @req_addresses = ReqAddress.order("updated_at DESC")

    if params[:search]
      @req_addresses = 
        @req_addresses.joins(:req_comments)
                      .where("si_nm LIKE ? OR 
                              sgg_nm LIKE ? OR 
                              emd_nm LIKE ? OR
                              req_comments.content LIKE ?", 
                              "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%").uniq                   
    end

    unless @req_addresses.kind_of?(Array)
      @req_addresses = @req_addresses.page(params[:page]).per(10)
    else
      @req_addresses = Kaminari.paginate_array(@req_addresses).page(params[:page]).per(10)
    end
  end

  def create
    if params[:sgg_nm].present?
      @req_address = ReqAddress.find_or_create_by(
        si_nm: params[:si_nm], 
        sgg_nm: params[:sgg_nm],
        emd_nm: params[:emd_nm]
      )
      
      @req_comment = ReqComment.new
      @req_comment.content = params[:content]
      # @req_comment.address = params[:address]
      @req_comment.password = params[:password]
      @req_comment.password_confirmation = params[:password]
      @req_comment.client_ip = request.remote_ip
      @req_comment.req_address = @req_address 
      @req_comment.save
      
      @req_address.touch

      flash[:info] = "정상적으로 \"작성\" 되었습니다."
    else 
      flash[:danger] = "주소가 비어있습니다.\n다시 확인해주세요"
    end
    redirect_back(fallback_location: root_path)
  end

  def delete
    @req_comment = ReqComment.find(params[:id])
    if @req_comment.authenticate(params[:password]) 
      @req_address = @req_comment.req_address
      @req_comment.delete
      flash[:info] = "정상적으로 \"삭제\" 되었습니다."

      if @req_address.req_comments.empty?
        @req_address.delete
      else 
        @req_address.update_columns(updated_at: @req_address.req_comments.last.updated_at) 
      end
    elsif user_signed_in?
      if current_user.role == "manager"
        @req_address = @req_comment.req_address
        @req_comment.delete
        flash[:info] = "정상적으로 \"삭제\" 되었습니다."
  
        if @req_address.req_comments.empty?
          @req_address.delete
        else 
          @req_address.update_columns(updated_at: @req_address.req_comments.last.updated_at) 
        end
      else 
        flash[:danger] = "비밀번호가 틀렸습니다."
      end
    else
      flash[:danger] = "비밀번호가 틀렸습니다."
    end
    # req_address.req_comments 없으면 req_address 지우기
    redirect_back(fallback_location: root_path)
  end

  def search_si
    si = JSON.parse( RestClient::Request.execute(
      method:  :get, 
      url:     "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_C_ADSIDO_INFO&key=#{ENV["VWORLD-KEY"]}&domain=#{ENV["VWORLD-DOMAIN"]}&attrFilter=ctprvn_cd:%3E:0&geometry=false&size=40",
      headers: { Accept: "application/json" }
    ) )

    render json: si["response"]["result"]["featureCollection"]["features"]
  end
  def search_sgg
    sgg = JSON.parse( RestClient::Request.execute(
      method:  :get, 
      url:  "https://api.vworld.kr/req/data?service=data&request=GetFeature&geometry=false&size=1000&data=LT_C_ADSIGG_INFO&key=#{ENV["VWORLD-KEY"]}&domain=#{ENV["VWORLD-DOMAIN"]}&attrFilter=full_nm:like:#{URI::encode(params[:si].force_encoding('UTF-8'))}",
      headers: { Accept: "application/json" }
    ) )
    render json: sgg["response"]["result"]["featureCollection"]["features"]
  end
  def search_emd
    emd = JSON.parse( RestClient::Request.execute(
      method:  :get, 
      url:  "https://api.vworld.kr/req/data?service=data&request=GetFeature&geometry=false&size=1000&data=LT_C_ADEMD_INFO&key=#{ENV["VWORLD-KEY"]}&domain=#{ENV["VWORLD-DOMAIN"]}&attrFilter=full_nm:like:#{URI::encode("#{params[:si]} #{params[:sgg]}".force_encoding('UTF-8'))}",
      headers: { Accept: "application/json" }
    ) )
    render json: emd["response"]["result"]["featureCollection"]["features"]
  end
end
