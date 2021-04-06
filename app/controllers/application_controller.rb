class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_variables
  protect_from_forgery with: :exception


  def set_variables
    @items = { 
      first: { 
        type_1: { amount: 1, price: 2000, discount: 0 }, 
        type_2: { amount: 10, price: 15000, discount: 25 },
        type_3: { amount: 30, price: 36000, discount: 40 },
        increase_pt: 960
      },
      sec: {
        type_1: { amount: 1, price: 1500, discount: 0 }, 
        type_2: { amount: 10, price: 9000, discount: 40 },
        type_3: { amount: 30, price: 22500, discount: 50 }, 
        increase_pt: 600
      }
      
    }

    # Point
    @minimum_pt = 1000 # 환전 최소 포인트 
    @fees = 500 # 수수료
    @increase_pt = 450
    @increase_sec_pt = 450
    
    @imp_status = ["심사 중", "반려", "완료"]
    @status = ["미작성", "임시저장", "등록신청", "등록반려", "등록완료", "수정신청", "수정반려"]
  end
  
  def videos
    response.set_header("X-Content-Type-Options", false)
    if params[:model] == "review" 
      @reivew_video = ReviewVideo.find_by(name: params[:name])
      if @reivew_video.review.status == "sample"
        # send_data @reivew_video.file, type: @reivew_video.content_type, disposition: 'inline', filename: @reivew_video.name
        byte_range_response(request, response, @reivew_video)
      elsif current_user.role == "manager" || @reivew_video.review.user == current_user || ViewerHistory.find_by(review_id: @reivew_video.review_id, user_id: current_user.id).present?
        # send_data @reivew_video.file, type: @reivew_video.content_type, disposition: 'inline', filename: @reivew_video.name
        byte_range_response(request, response, @reivew_video)
      else 
        redirect_to '/500'
      end
    end
  end

  def upload_videos
    response.set_header("X-Content-Type-Options", false)
    if params[:model] == "review" 
      @reivew_video = ReviewVideo.find_by(name: params[:name])
      if @reivew_video.review.status == "sample"
        send_data @reivew_video.file, type: @reivew_video.content_type, disposition: 'inline', filename: @reivew_video.name
      elsif current_user.role == "manager" || @reivew_video.review.user == current_user
        send_data @reivew_video.file, type: @reivew_video.content_type, disposition: 'inline', filename: @reivew_video.name
      else 
        redirect_to '/500'
      end
    end
  end
  
  def images
    response.set_header("X-Content-Type-Options", false)
    if params[:model] == "review" 
      @reivew_img = ReviewImg.find_by(name: params[:name])
      if @reivew_img.review.status == "sample"
        send_data @reivew_img.file, type: @reivew_img.content_type, disposition: 'inline', filename: @reivew_img.name
      elsif current_user.role == "manager" || @reivew_img.review.user == current_user || ViewerHistory.find_by(review_id: @reivew_img.review_id, user_id: current_user.id).present?
        send_data @reivew_img.file, type: @reivew_img.content_type, disposition: 'inline', filename: @reivew_img.name
      else 
        redirect_to '/500'
      end
    elsif params[:model] == "reviews"
      @review_main = Review.find_by(main_img_name: params[:name])
      send_data @review_main.main_img, type: @review_main.main_img_content_type, disposition: 'inline', filename: @review_main.main_img_name
    elsif params[:model] == "owner" 
      @owner_comment_img = OwnerCommentImg.find_by(name: params[:name])
      send_data @owner_comment_img.file, type: @owner_comment_img.content_type, disposition: 'inline', filename: @owner_comment_img.name
    end
  end

  def imp_images
    response.set_header("X-Content-Type-Options", false)
    if params[:model] == "review" 
      @reivew_img = ReviewImpImg.find_by(name: params[:name])
      if current_user.role == "manager" || @reivew_img.review.user == current_user
        send_data @reivew_img.file, type: @reivew_img.content_type, disposition: 'inline', filename: @reivew_img.name
      else 
        render '/500'
      end
    elsif params[:model] == "owner"
      @reivew_img = OwnerCommentImpImg.find_by(name: params[:name])
      if current_user.role == "manager" || @reivew_img.owner_comment.user == current_user
        send_data @reivew_img.file, type: @reivew_img.content_type, disposition: 'inline', filename: @reivew_img.name
      else 
        render '/500'
      end
    elsif params[:model] == "exchange"
      @reivew_img = ExchangeImpImg.find_by(name: params[:name])
      if current_user.role == "manager" || @reivew_img.exchange.user == current_user
        send_data @reivew_img.file, type: @reivew_img.content_type, disposition: 'inline', filename: @reivew_img.name
      else 
        render '/500'
      end
    end
  end
  
  def check_manager
    unless current_user.role == 'manager'
      flash[:danger] = "잘 못된 접근입니다."
      redirect_to '/'
    end
  end

  private
  def byte_range_response (request, response, content)
    file_begin = 0
    file_size = content.file.bytesize
    file_end = file_size - 1

    status_code = '206 Partial Content'
    # match = request.headers['Range'].match(/bytes=(\d+)-(\d*)/)
    if request.headers['Range']
      match = request.headers['Range'].match(/bytes=(\d+)-(\d*)/)

      file_begin = match[1]
      file_end = match[2] if match[2] && !match[2].empty?
    end
    content_length = file_end.to_i - file_begin.to_i + 1
    response.header['Content-Range'] = 'bytes ' + file_begin.to_s + '-' + file_end.to_s + '/' + file_size.to_s
    response.header['Content-Length'] = content_length.to_s
    response.header['Cache-Control'] = 'public, must-revalidate, max-age=0'
    response.header['Pragma'] = 'no-cache'
    response.header['Accept-Ranges']= 'bytes'
    response.header['Content-Transfer-Encoding'] = 'binary'
    send_data get_partial_content(content, content_length, file_begin.to_i), type: 'application/octet-stream', status: status_code
  end

  def get_partial_content(content, content_length, offset)
    test_file = Tempfile.new([content.name])
    test_file.binmode
    test_file.write(content.file)
    test_file.rewind
    partial_content = IO.binread(test_file.path, content_length, offset)
    test_file.close
    test_file.unlink
    partial_content
  end

  
  protected

  # def configure_permitted_parameters
  #     devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:email, :password, :is_promotion)}
  #     devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:email, :password, :current_password, :is_promotion)}
  # end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
    devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  end
end
