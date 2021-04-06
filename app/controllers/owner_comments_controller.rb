class OwnerCommentsController < ApplicationController
  require 'rest-client'
  require 'uri'
  before_action :authenticate_user!, only: [:create, :new, :edit, :update, :show, 
    :use_viewer, :viewer, :buy_viewer, :edit_content]
  before_action :set_owner_comment, only: [:show, :edit, :update, :destroy, :edit_content]

  def show
    unless (current_user.role == 'manager' || @owner_comment.user == current_user)
      flash[:danger] = "잘 못된 접근입니다."
      redirect_to '/'
    end
  end

  def edit_content
    if (current_user.role == 'manager' || @owner_comment.user == current_user)  && @owner_comment.status == "수정신청"
      @edit_owner_comment = @owner_comment.edit_owner_comment

    else
      flash[:danger] = "잘 못된 접근입니다."
      redirect_to '/'
    end
  end

  def new
    if current_user.owner_comments.where(status: "임시저장").empty?
      @owner_comment = OwnerComment.new
      @imp_check = true
    else
      flash[:danger] = '임시저장 중인 코맨트가 있습니다.'
      redirect_to "/mypage/owner_comments"
    end
  end
  
  def edit
    if @owner_comment.user == current_user
      @imp_check = 
          if @owner_comment.original.nil?
            OwnerCommentConfirm.where(owner_comment: @owner_comment, status: "등록완료").count == 0
          else
            OwnerCommentConfirm.where(owner_comment: @owner_comment.original, status: "등록완료").count == 0
          end
      if @owner_comment.status == "등록신청" || @owner_comment.status == "수정신청" 
        flash[:danger] = '등록신청 중에는 수정이 불가능합니다.'
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:danger] = '권한이 없습니다.'
      redirect_back(fallback_location: root_path)
    end
  end

  def create
    @owner_comment = OwnerComment.new
    @owner_comment.user = current_user

    @owner_comment.address = params[:owner_comment][:address]
    @owner_comment.detail_address = params[:owner_comment][:detail_address].gsub(/\s+/, "")
    @owner_comment.extra_address = params[:owner_comment][:extra_address]
    @owner_comment.bd_nm = params[:owner_comment][:bd_nm]
    @owner_comment.si_nm = params[:owner_comment][:si_nm]
    @owner_comment.sgg_nm = params[:owner_comment][:sgg_nm]
    @owner_comment.emd_nm = params[:owner_comment][:emd_nm]

    if params[:owner_comment][:address].present?
      sample_review = Review.find_by(address: params[:address])
      if sample_review.nil?
        geocoding = get_geocoding(@owner_comment.address)
          
        @owner_comment.lat = geocoding["addresses"][0]["y"]
        @owner_comment.long = geocoding["addresses"][0]["x"] 
      else
        @owner_comment.lat = sample_review.lat
        @owner_comment.long = sample_review.long
      end
    end

    @owner_comment.room = params[:owner_comment][:room]
    @owner_comment.hidden_camera = params[:owner_comment][:hidden_camera]
    @owner_comment.contact_time = params[:owner_comment][:contact_time]
    @owner_comment.contact_method = params[:owner_comment][:contact_method]

    @owner_comment.long_term_txt = params[:owner_comment][:long_term_txt]

    @owner_comment.remodeling_date = params[:owner_comment][:remodeling_date]
    @owner_comment.remodeling_txt = params[:owner_comment][:remodeling_txt]

    @owner_comment.intro_txt = params[:owner_comment][:intro_txt]
    @owner_comment.save

    if params[:"imp_imgs"].present?
      params[:"imp_imgs"].each_with_index do |item, index|
        OwnerCommentImpImg.create(tag: "owner",
          name: rand(36**20).to_s(36),
          content_type: item.content_type,
          file: item.read,
          owner_comment: @owner_comment)
      end
    end

    if params[:"remodeling_before_imgs"].present?
      params[:"remodeling_before_imgs"].each_with_index do |item, index|
        OwnerCommentImg.create(tag: "리모델링 전",
          name: rand(36**20).to_s(36),
          content_type: item.content_type,
          file: item.read,
          owner_comment: @owner_comment)
      end
    end
    if params[:"remodeling_after_imgs"].present?
      params[:"remodeling_after_imgs"].each_with_index do |item, index|
        OwnerCommentImg.create(tag: "리모델링 후",
          name: rand(36**20).to_s(36),
          content_type: item.content_type,
          file: item.read,
          owner_comment: @owner_comment)
      end
    end
    if params[:"intro_imgs"].present?
      params[:"intro_imgs"].each_with_index do |item, index|
        OwnerCommentImg.create(tag: "소개 및 장점",
          name: rand(36**20).to_s(36),
          content_type: item.content_type,
          file: item.read,
          owner_comment: @owner_comment)
      end
    end
    

    if params[:temporary]
      @owner_comment.update_columns(status: "임시저장")

      flash[:info] = '임시저장 되었습니다.'
      render json: { result: "ok", redirect_to: "/mypage/owner_comments" }
    else
      owner_comment_confirm = OwnerCommentConfirm.new
      owner_comment_confirm.status = "등록신청"
      owner_comment_confirm.owner_comment = @owner_comment
      owner_comment_confirm.save
      
      @owner_comment.update_columns(status: "등록신청") 

      flash[:info] = '정상적으로 신청하였습니다.'
      render json: { result: "ok", redirect_to: "/mypage/owner_comments" }
    end
  end

  def update 
    if @owner_comment.user == current_user
      if @owner_comment.status == "등록완료"
        @edit_owner_comment = OwnerComment.new
        @edit_owner_comment.user = current_user

        @edit_owner_comment.address = @owner_comment.address
        @edit_owner_comment.detail_address = @owner_comment.detail_address
        @edit_owner_comment.extra_address = @owner_comment.extra_address
        @edit_owner_comment.bd_nm = @owner_comment.bd_nm
        @edit_owner_comment.si_nm = @owner_comment.si_nm
        @edit_owner_comment.sgg_nm = @owner_comment.sgg_nm
        @edit_owner_comment.emd_nm = @owner_comment.emd_nm
        @edit_owner_comment.lat = @owner_comment.lat
        @edit_owner_comment.long = @owner_comment.long
        @edit_owner_comment.room = @owner_comment.room


        @edit_owner_comment.hidden_camera = params[:owner_comment][:hidden_camera]
        @edit_owner_comment.contact_time = params[:owner_comment][:contact_time]
        @edit_owner_comment.contact_method = params[:owner_comment][:contact_method]
        @edit_owner_comment.long_term_txt = params[:owner_comment][:long_term_txt]
        @edit_owner_comment.remodeling_date = params[:owner_comment][:remodeling_date]
        @edit_owner_comment.remodeling_txt = params[:owner_comment][:remodeling_txt]
        @edit_owner_comment.intro_txt = params[:owner_comment][:intro_txt]
        @edit_owner_comment.original = @owner_comment
        @edit_owner_comment.save

        @owner_comment.status = "수정신청"
        @owner_comment.save 


        if params[:"remodeling_before_imgs"].present?
          params[:"remodeling_before_imgs"].each_with_index do |item, index|
            OwnerCommentImg.create(tag: "리모델링 전",
              name: rand(36**20).to_s(36),
              content_type: item.content_type,
              file: item.read,
              owner_comment: @edit_owner_comment)
          end
        end
        if params[:"remodeling_after_imgs"].present?
          params[:"remodeling_after_imgs"].each_with_index do |item, index|
            OwnerCommentImg.create(tag: "리모델링 후",
              name: rand(36**20).to_s(36),
              content_type: item.content_type,
              file: item.read,
              owner_comment: @edit_owner_comment)
          end
        end
        if params[:"intro_imgs"].present?
          params[:"intro_imgs"].each_with_index do |item, index|
            OwnerCommentImg.create(tag: "소개 및 장점",
              name: rand(36**20).to_s(36),
              content_type: item.content_type,
              file: item.read,
              owner_comment: @edit_owner_comment)
          end
        end

        owner_comment_confirm = OwnerCommentConfirm.new
        owner_comment_confirm.status = "수정신청"
        owner_comment_confirm.owner_comment =  @owner_comment
        owner_comment_confirm.save

        flash[:info] = '정상적으로 수정하였습니다.'
        render json: { result: "ok", redirect_to: "/mypage/owner_comments" }
      elsif @owner_comment.status == "임시저장" ||  @owner_comment.status == "등록반려" || @owner_comment.status == "수정반려" || @owner_comment.status.nil?
        if @owner_comment.status == "임시저장" ||  @owner_comment.status == "등록반려"
          @owner_comment.detail_address = params[:owner_comment][:detail_address].gsub(/\s+/, "")
          @owner_comment.extra_address = params[:owner_comment][:extra_address]
          @owner_comment.bd_nm = params[:owner_comment][:bd_nm]
          @owner_comment.si_nm = params[:owner_comment][:si_nm]
          @owner_comment.sgg_nm = params[:owner_comment][:sgg_nm]
          @owner_comment.emd_nm = params[:owner_comment][:emd_nm]
          if @owner_comment.address != params[:owner_comment][:address]
            if params[:owner_comment][:address].present?
              sample_review = Review.find_by(address: params[:owner_comment][:address])
              if sample_review.nil?
                @owner_comment.address = params[:owner_comment][:address]
                geocoding = get_geocoding(@owner_comment.address)
                  
                @owner_comment.lat = geocoding["addresses"][0]["y"]
                @owner_comment.long = geocoding["addresses"][0]["x"] 
              else
                @owner_comment.lat = sample_review.lat
                @owner_comment.long = sample_review.long
              end
            end
          end
          @owner_comment.room = params[:owner_comment][:room]
        end
        
        @owner_comment.hidden_camera = params[:owner_comment][:hidden_camera]
        @owner_comment.contact_time = params[:owner_comment][:contact_time]
        @owner_comment.contact_method = params[:owner_comment][:contact_method]

        @owner_comment.long_term_txt = params[:owner_comment][:long_term_txt]

        @owner_comment.remodeling_date = params[:owner_comment][:remodeling_date]
        @owner_comment.remodeling_txt = params[:owner_comment][:remodeling_txt]


        @owner_comment.intro_txt = params[:owner_comment][:intro_txt]
        @owner_comment.save
        
        remove_remodeling_before_img_ids = @owner_comment.owner_comment_imgs.where(tag: "리모델링 전").map(&:id)
        if params[:"remodeling_before_imgs"].present?
          params[:"remodeling_before_imgs"].each_with_index do |item, index|
            img = @owner_comment.owner_comment_imgs.where(tag: "리모델링 전", name: item.original_filename).take
            if img.nil?
              OwnerCommentImg.create(tag: "리모델링 전",
                name: rand(36**20).to_s(36),
                content_type: item.content_type,
                file: item.read,
                owner_comment: @owner_comment)
            else 
              remove_remodeling_before_img_ids.delete(img.id)
            end
          end
        end 
        OwnerCommentImg.where(id: remove_remodeling_before_img_ids).destroy_all if !remove_remodeling_before_img_ids.empty?

        remove_remodeling_after_img_ids = @owner_comment.owner_comment_imgs.where(tag: "리모델링 후").map(&:id)
        if params[:"remodeling_after_imgs"].present?
          params[:"remodeling_after_imgs"].each_with_index do |item, index|
            img = @owner_comment.owner_comment_imgs.where(tag: "리모델링 후", name: item.original_filename).take
            if img.nil?
              OwnerCommentImg.create(tag: "리모델링 후",
                name: rand(36**20).to_s(36),
                content_type: item.content_type,
                file: item.read,
                owner_comment: @owner_comment)
            else 
              remove_remodeling_after_img_ids.delete(img.id)
            end
          end
        end 
        OwnerCommentImg.where(id: remove_remodeling_after_img_ids).destroy_all if !remove_remodeling_after_img_ids.empty?

        remove_intro_img_ids = @owner_comment.owner_comment_imgs.where(tag: "소개 및 장점").map(&:id)
        if params[:"intro_imgs"].present?
          params[:"intro_imgs"].each_with_index do |item, index|
            img = @owner_comment.owner_comment_imgs.where(tag: "소개 및 장점", name: item.original_filename).take
            if img.nil?
              OwnerCommentImg.create(tag: "소개 및 장점",
                name: rand(36**20).to_s(36),
                content_type: item.content_type,
                file: item.read,
                owner_comment: @owner_comment)
            else 
              remove_intro_img_ids.delete(img.id)
            end
          end
        end 
        OwnerCommentImg.where(id: remove_intro_img_ids).destroy_all if !remove_intro_img_ids.empty?

        if params[:temporary]
          remove_imp_img_ids = @owner_comment.owner_comment_imp_imgs.map(&:id)
          if params[:"imp_imgs"].present?
            params[:"imp_imgs"].each_with_index do |item, index|
              imp_img = @owner_comment.owner_comment_imp_imgs.find_by(name: item.original_filename)
              if imp_img.nil?
                OwnerCommentImpImg.create(tag: "owner",
                  name: rand(36**20).to_s(36),
                  content_type: item.content_type,
                  file: item.read,
                  owner_comment: @owner_comment)
              else 
                remove_imp_img_ids.delete(imp_img.id)
              end
            end
          end 
          OwnerCommentImpImg.where(id: remove_imp_img_ids).destroy_all if !remove_imp_img_ids.empty?
  
          @owner_comment.update_columns(status: "임시저장")
          flash[:info] = '임시저장 되었습니다.'
          render json: { result: "ok", redirect_to: "/mypage/owner_comments" }
        else
          if @owner_comment.status.nil?
            owner_comment_confirm = OwnerCommentConfirm.new
            owner_comment_confirm.status = "수정신청"
            owner_comment_confirm.owner_comment = @owner_comment.original
            owner_comment_confirm.save

            @owner_comment.original.update_columns(status: "수정신청") 

            flash[:info] = '정상적으로 신청하였습니다.'
          
            render json: { result: "ok", redirect_to: "/owner_comments/#{@owner_comment.original.id}/edit_content" }
          else
            remove_imp_img_ids = @owner_comment.owner_comment_imp_imgs.map(&:id)
            if params[:"imp_imgs"].present?
              params[:"imp_imgs"].each_with_index do |item, index|
                imp_img = @owner_comment.owner_comment_imp_imgs.find_by(name: item.original_filename)
                if imp_img.nil?
                  OwnerCommentImpImg.create(tag: "owner",
                    name: rand(36**20).to_s(36),
                    content_type: item.content_type,
                    file: item.read,
                    owner_comment: @owner_comment)
                else 
                  remove_imp_img_ids.delete(imp_img.id)
                end
              end
            end 
            OwnerCommentImpImg.where(id: remove_imp_img_ids).destroy_all if !remove_imp_img_ids.empty?
    
            owner_comment_confirm = OwnerCommentConfirm.new
            owner_comment_confirm.status = "등록신청"
            owner_comment_confirm.owner_comment = @owner_comment
            owner_comment_confirm.save
            
            @owner_comment.update_columns(status: "등록신청") 

            flash[:info] = '정상적으로 신청하였습니다.'
          
            render json: { result: "ok", redirect_to: "/owner_comments/#{@owner_comment.id}" }
          end
        end
      else 
        flash[:danger] = '등록심사 중에는 수정이 불가능합니다.'
        render json: { result: "error", redirect_to: root_path }
      end
    else
      flash[:danger] = '권한이 없습니다.'
      render json: { result: "error", redirect_to: root_path }
    end
  end


  def check_address
    @reviews = Review.where(status: "등록완료", address: params[:address])

    render json: @reviews.map(&:detail_address).uniq
  end

  private
  def set_owner_comment
    @owner_comment = OwnerComment.find params[:id]
  end
  
  # lat, long 검색
  def get_geocoding(address)
    JSON.parse( RestClient::Request.execute(
      method:  :get, 
      url:     "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=#{URI::encode( address.force_encoding('UTF-8'))}",
      headers: { Accept: "application/json", "X-NCP-APIGW-API-KEY-ID": ENV["X-NCP-APIGW-API-KEY-ID"], "X-NCP-APIGW-API-KEY": ENV["X-NCP-APIGW-API-KEY"]}
    ) )
  end
end
