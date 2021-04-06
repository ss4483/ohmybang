# encoding: utf-8
class ReviewsController < ApplicationController
  include ReviewsHelper

  require 'rest-client'
  require 'uri'
  before_action :authenticate_user!, only: [:create, :new, :edit, :update, :show, 
    :use_viewer, :viewer, :buy_viewer, :edit_content, :edit_review, :update_review, :retouch_review, :retouch_show]
  before_action :set_review, only: [:show, :edit, :update, :destroy, :edit_content, :edit_review, :update_review, :retouch_review, :retouch_show]

  # 리뷰 목록 
  def index
    review = Review.where(imp_status: @imp_status[2], status: @status[4]).sample()
    
    @default_address = (review.nil?)? "서울특별시 강서구 가양동" : review.address
    @default_long = (review.nil?)? 126.8494633 : review.long
    @default_lat = (review.nil?)? 37.5652894 : review.lat 
    @default_si_nm = (review.nil?)? "서울특별시" : review.si_nm

    @address_check = false

    @check = params[:check] || ["원룸", "투/쓰리룸", "오피스텔", "아파트"]
    @detail_address = params[:detail_address].gsub(/\s+/, "") if params[:detail_address].present?
    @kilometers = 1.0
    
    if params[:address].present?
      sample_review = Review.find_by(address: params[:address])
      
      if sample_review.nil?
        geocoding = get_geocoding(params[:address])
        if geocoding["addresses"].empty?
          @address_check = true
          @search_word = params[:address] + " " + params[:detail_address]
          @long = @default_long
          @lat = @default_lat
          params[:address] = @default_address
          params[:si_nm] = @default_si_nm
        else 
          @long = geocoding["addresses"][0]["x"]
          @lat = geocoding["addresses"][0]["y"]
        end
      else 
        @long = sample_review.long
        @lat = sample_review.lat
      end
    else
      @long = @default_long
      @lat = @default_lat
      params[:address] = @default_address
      params[:si_nm] = @default_si_nm
    end

    kilometers_per_lat = 111.699
    kilometers_per_long = 110.567

    min_latitude = @lat.to_f - (@kilometers / kilometers_per_lat)
    max_latitude = @lat.to_f + (@kilometers / kilometers_per_lat)
    min_longitude = @long.to_f - (@kilometers / kilometers_per_long)
    max_longitude = @long.to_f + (@kilometers / kilometers_per_long)

    @matching_reviews = Array.new
    @matching_check = false
    if params[:detail_address].present?
      @matching_check = true
      # detail_address까지 일치하는 리뷰
      matching_reviews_imp_id = Review.where(room: @check).where("imp_status LIKE ? AND address LIKE ? AND detail_address LIKE ?", @imp_status[2], params[:address], "%#{@detail_address}%").where.not(status: "sample", contract_type: "").map(&:id)
      matching_reviews_id = Review.where(room: @check).where("status LIKE ? AND address LIKE ? AND detail_address LIKE ?", @status[4], params[:address], "%#{@detail_address}%").map(&:id)
      matching_reviews_id << matching_reviews_imp_id
      @matching_reviews = Review.where(id: matching_reviews_id.uniq)
      # @matching_reviews = Review.where(room: @check).where("imp_status LIKE ? AND address LIKE ? AND detail_address LIKE ?", @imp_status[2], params[:address], "%#{@detail_address}%").where.not(status: "sample") 
    end

  # imp_status: @imp_status[2] && (status: @status[4] || contract_type: not nil || review.review_imp_imgs.pluck(:tag).first == "계약서" )
  # Review.where(imp_status: @imp_status[2], address: params[:address]).where.not(contract_type: "")
  
    # address만 일치하는 리뷰
    reviews_imp_id = Review.where(imp_status: @imp_status[2], address: params[:address], room: @check).where.not(status: "sample", contract_type: "", id: @matching_reviews.map(&:id)).map(&:id)
    reviews_id = Review.where(imp_status: @imp_status[2], status: @status[4], address: params[:address], room: @check).where.not(id: (@matching_reviews.map(&:id))).map(&:id)
    reviews_id << reviews_imp_id
    @reviews = Review.where(id: reviews_id.uniq).page(params[:page]) 
    # @reviews = Review.where(imp_status: @imp_status[2], address: params[:address], room: @check).where.not(status: "sample", id: @matching_reviews.map(&:id)).page(params[:page]) # address만 일치하는 리뷰

    # address 5km 이내의 리뷰
    nearby_reviews_imp_id = Review.within(1, origin: [@lat, @long]).closest(origin: [@lat, @long]).where(imp_status: @imp_status[2], room: @check).where.not(status: "sample", address: params[:address], contract_type: "").map(&:id)
    nearby_reviews_id = Review.within(1, origin: [@lat, @long]).closest(origin: [@lat, @long]).where(imp_status: @imp_status[2], status: @status[4], room: @check).where.not(status: "sample", address: params[:address]).map(&:id)
    nearby_reviews_id << nearby_reviews_imp_id
    @nearby_reviews = Review.where(id: nearby_reviews_id.uniq).page(params[:nearby_page]).per(20)
    # @nearby_reviews = Review.within(1, origin: [@lat, @long]).closest(origin: [@lat, @long]).where(imp_status: @imp_status[2], room: @check).where.not(status: "sample", address: params[:address]).page(params[:nearby_page]).per(20) # address 5km 이내의 리뷰
    

    @viewer_histories = Array.new
    if user_signed_in?
      @viewer_histories = current_user.viewer_histories.map(&:review_id).compact
    end
    


    # # 전세지수 차트 만들기
    # @house_1_1_row = csv_row(params[:si_nm], "house_1_1.csv")
    # @house_1_2_row = csv_row(params[:si_nm], "house_1_2.csv")
    # @house_1_3_row = csv_row(params[:si_nm], "house_1_3.csv")
    # @house_1_4_row = csv_row(params[:si_nm], "house_1_4.csv")

    # @house_1_1 = csv_chart(@house_1_1_row, "종합주택유형")
    # @house_1_2 = csv_chart(@house_1_2_row, "아파트")
    # @house_1_3 = csv_chart(@house_1_3_row, "연립/다세대")
    # @house_1_4 = csv_chart(@house_1_4_row, "단독주택")

    # @house_1_max = [
    #   @house_1_1_row.drop(1).map {|v| v[1]}.max,
    #   @house_1_2_row.drop(1).map {|v| v[1]}.max,
    #   @house_1_3_row.drop(1).map {|v| v[1]}.max,
    #   @house_1_4_row.drop(1).map {|v| v[1]}.max
    # ].max
    # @house_1_min = [
    #   @house_1_1_row.drop(1).map {|v| v[1]}.min,
    #   @house_1_2_row.drop(1).map {|v| v[1]}.min,
    #   @house_1_3_row.drop(1).map {|v| v[1]}.min,
    #   @house_1_4_row.drop(1).map {|v| v[1]}.min
    # ].min
    # # 월세지수 차트 만들기
    # @house_2_1_row = csv_row(params[:si_nm], "house_2_1.csv")
    # @house_2_2_row = csv_row(params[:si_nm], "house_2_2.csv")
    # @house_2_3_row = csv_row(params[:si_nm], "house_2_3.csv")
    # @house_2_4_row = csv_row(params[:si_nm], "house_2_4.csv")

    # @house_2_1 = csv_chart(@house_2_1_row, "종합주택유형")
    # @house_2_2 = csv_chart(@house_2_2_row, "아파트")
    # @house_2_3 = csv_chart(@house_2_3_row, "연립/다세대")
    # @house_2_4 = csv_chart(@house_2_4_row, "단독주택")

    # @house_2_max = [
    #   @house_2_1_row.drop(1).map {|v| v[1]}.max,
    #   @house_2_2_row.drop(1).map {|v| v[1]}.max,
    #   @house_2_3_row.drop(1).map {|v| v[1]}.max,
    #   @house_2_4_row.drop(1).map {|v| v[1]}.max
    # ].max
    # @house_2_min = [
    #   @house_2_1_row.drop(1).map {|v| v[1]}.min,
    #   @house_2_2_row.drop(1).map {|v| v[1]}.min,
    #   @house_2_3_row.drop(1).map {|v| v[1]}.min,
    #   @house_2_4_row.drop(1).map {|v| v[1]}.min
    # ].min

    # # 평균전세가격 차트 만들기
    # @house_3_1_row = csv_row(params[:si_nm], "house_3_1.csv")
    # @house_3_2_row = csv_row(params[:si_nm], "house_3_2.csv")
    # @house_3_3_row = csv_row(params[:si_nm], "house_3_3.csv")
    # @house_3_4_row = csv_row(params[:si_nm], "house_3_4.csv")

    # @house_3_1 = csv_chart(@house_3_1_row, "종합주택유형")
    # @house_3_2 = csv_chart(@house_3_2_row, "아파트")
    # @house_3_3 = csv_chart(@house_3_3_row, "연립/다세대")
    # @house_3_4 = csv_chart(@house_3_4_row, "단독주택")

    # @house_3_max = [
    #   @house_3_1_row.drop(1).map {|v| v[1]}.max,
    #   @house_3_2_row.drop(1).map {|v| v[1]}.max,
    #   @house_3_3_row.drop(1).map {|v| v[1]}.max,
    #   @house_3_4_row.drop(1).map {|v| v[1]}.max
    # ].max
    # @house_3_min = [
    #   @house_3_1_row.drop(1).map {|v| v[1]}.min,
    #   @house_3_2_row.drop(1).map {|v| v[1]}.min,
    #   @house_3_3_row.drop(1).map {|v| v[1]}.min,
    #   @house_3_4_row.drop(1).map {|v| v[1]}.min
    # ].min
    # @house_3_min = (@house_3_min/100000).floor * 100000

    # # 평균월세가격 차트 만들기
    # @house_4_1_row = csv_row(params[:si_nm], "house_4_1.csv")
    # @house_4_2_row = csv_row(params[:si_nm], "house_4_2.csv")
    # @house_4_3_row = csv_row(params[:si_nm], "house_4_3.csv")
    # @house_4_4_row = csv_row(params[:si_nm], "house_4_4.csv")

    # @house_4_1 = csv_chart(@house_4_1_row, "종합주택유형")
    # @house_4_2 = csv_chart(@house_4_2_row, "아파트")
    # @house_4_3 = csv_chart(@house_4_3_row, "연립/다세대")
    # @house_4_4 = csv_chart(@house_4_4_row, "단독주택")

    # @house_4_max = [
    #   @house_4_1_row.drop(1).map {|v| v[1]}.max,
    #   @house_4_2_row.drop(1).map {|v| v[1]}.max,
    #   @house_4_3_row.drop(1).map {|v| v[1]}.max,
    #   @house_4_4_row.drop(1).map {|v| v[1]}.max
    # ].max
    # @house_4_min = [
    #   @house_4_1_row.drop(1).map {|v| v[1]}.min,
    #   @house_4_2_row.drop(1).map {|v| v[1]}.min,
    #   @house_4_3_row.drop(1).map {|v| v[1]}.min,
    #   @house_4_4_row.drop(1).map {|v| v[1]}.min
    # ].min
    # @house_4_min = 0

    # # 평균월세보증금 차트 만들기
    # @house_5_1_row = csv_row(params[:si_nm], "house_5_1.csv")
    # @house_5_2_row = csv_row(params[:si_nm], "house_5_2.csv")
    # @house_5_3_row = csv_row(params[:si_nm], "house_5_3.csv")
    # @house_5_4_row = csv_row(params[:si_nm], "house_5_4.csv")

    # @house_5_1 = csv_chart(@house_5_1_row, "종합주택유형")
    # @house_5_2 = csv_chart(@house_5_2_row, "아파트")
    # @house_5_3 = csv_chart(@house_5_3_row, "연립/다세대")
    # @house_5_4 = csv_chart(@house_5_4_row, "단독주택")

    # @house_5_max = [
    #   @house_5_1_row.drop(1).map {|v| v[1]}.max,
    #   @house_5_2_row.drop(1).map {|v| v[1]}.max,
    #   @house_5_3_row.drop(1).map {|v| v[1]}.max,
    #   @house_5_4_row.drop(1).map {|v| v[1]}.max
    # ].max
    # @house_5_min = [
    #   @house_5_1_row.drop(1).map {|v| v[1]}.min,
    #   @house_5_2_row.drop(1).map {|v| v[1]}.min,
    #   @house_5_3_row.drop(1).map {|v| v[1]}.min,
    #   @house_5_4_row.drop(1).map {|v| v[1]}.min
    # ].min
    # @house_5_min = (@house_5_min/10000).floor * 10000
  end

  def new
    @review = Review.new
  end
  def create
    if params[:imp_type] == "계약서"
      @review = Review.create(
        user: current_user,
        management_fee: params[:management_fee] == "f" ? -1 : params[:management_fee_price], 
        management_type: params[:management_type],
        parking: params[:parking] == "f" ? -1 : params[:parking_price],
        imp_status: @imp_status[0],
        status: @status[0]
      )
      if params[:imp_imgs_contract].present?
        params[:imp_imgs_contract].each_with_index do |item, index|
          ReviewImpImg.create(tag: "계약서",
            name: rand(36**20).to_s(36),
            content_type: item.content_type,
            file: item.read,
            review: @review)
        end
      end
    elsif params[:imp_type] == "초본"
      @review = Review.create(user: current_user, imp_status: @imp_status[0], status: @status[0])
      if params[:imp_imgs_resident].present?
        params[:imp_imgs_resident].each_with_index do |item, index|
          ReviewImpImg.create(tag: "초본",
            name: rand(36**20).to_s(36),
            content_type: item.content_type,
            file: item.read,
            review: @review)
        end
      end
    end
    ReviewConfirm.create( status: @imp_status[0], review: @review, confirm_type: "증빙" )
    # 리뷰 작성으로
    flash[:info] = '정상적으로 저장하였습니다.'
    render json: { result: "ok", type: "create", redirect_to: "/reviews/#{@review.id}/review" }
  end

  def edit
    if @review.user != current_user || @review.imp_status == @imp_status[0] || @review.imp_status == @imp_status[2]
      flash[:danger] = '권한이 없습니다.'
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    if @review.user != current_user || @review.imp_status == @imp_status[0] || @review.imp_status == @imp_status[2]
      flash[:danger] = '권한이 없습니다.'
      render json: { result: "error", redirect_to: root_path }
    else

      if params[:imp_type] == "계약서" # '계약서' 일 경우
        # review 업데이트
        @review.update_columns( 
          management_fee: params[:management_fee] == "f" ? -1 : params[:management_fee_price], 
          management_type: params[:management_type],
          parking: params[:parking] == "f" ? -1 : params[:parking_price],
          imp_status: @imp_status[0]
        )
        @review.touch
        # 증빙 이미지 업데이트
        remove_imp_img_ids = @review.review_imp_imgs.map(&:id)
        if params[:"imp_imgs_contract"].present?
          params[:"imp_imgs_contract"].each_with_index do |item, index|
            imp_img = @review.review_imp_imgs.find_by(name: item.original_filename)
            if imp_img.nil?
              ReviewImpImg.create(tag: "계약서",
                name: rand(36**20).to_s(36),
                content_type: item.content_type,
                file: item.read,
                review: @review)
            else 
              remove_imp_img_ids.delete(imp_img.id)
            end
          end
        end 
        ReviewImpImg.where(id: remove_imp_img_ids).destroy_all if !remove_imp_img_ids.empty?
      elsif params[:imp_type] == "초본"  # '초본' 일 경우
        # review 업데이트
        @review.update_columns(
          management_fee: nil, management_type: nil, parking: nil,
          imp_status: @imp_status[0]
        )
        @review.touch
        # 증빙 이미지 업데이트
        remove_imp_img_ids = @review.review_imp_imgs.map(&:id)
        if params[:"imp_imgs_resident"].present?
          params[:"imp_imgs_resident"].each_with_index do |item, index|
            imp_img = @review.review_imp_imgs.find_by(name: item.original_filename)
            if imp_img.nil?
              ReviewImpImg.create(tag: "초본",
                name: rand(36**20).to_s(36),
                content_type: item.content_type,
                file: item.read,
                review: @review)
            else 
              remove_imp_img_ids.delete(imp_img.id)
            end
          end
        end 
        ReviewImpImg.where(id: remove_imp_img_ids).destroy_all if !remove_imp_img_ids.empty?
      end
      # review_connfirm 생성
      ReviewConfirm.create( status: @imp_status[0], review: @review, confirm_type: "증빙" )

      # 리뷰 작성으로
      if @review.status == @status[0] || @review.status == @status[1] || @review.status == @status[3]
        flash[:info] = '정상적으로 저장하였습니다.'
        render json: { result: "ok", type: "update", redirect_to: "/reviews/#{@review.id}/review" }
      else 
        flash[:info] = '정상적으로 저장하였습니다.'
        render json: { result: "ok", type: "update", redirect_to: "#" }
      end
    end
  end

  def edit_review
    @edit_review = @review.edit_review
    # if @review.user != current_user || !(@review.status == @status[0] || @review.status == @status[1] || @review.status == @status[3])
    #   flash[:danger] = '권한이 없습니다.'
    #   redirect_back(fallback_location: root_path)
    # end
  end
  def update_review
    if @review.user != current_user || !(@review.status == @status[0] || @review.status == @status[1] || @review.status == @status[3]) || @review.status == "sample"
      flash[:danger] = '권한이 없습니다.'
      redirect_back(fallback_location: root_path)
    else

      # 주소 저장 
      if @review.address != params[:review][:address] || (@review.address.blank? && !params[:review][:address].blank?)
        geocoding = get_geocoding(params[:review][:address])
        @review.update_columns(lat: geocoding["addresses"][0]["y"], long: geocoding["addresses"][0]["x"])
      end
      if params[:main_img].present?
        @review.update_columns(
          main_img_name: rand(36**20).to_s(36),
          main_img: params[:main_img].read,
          main_img_content_type: params[:main_img].content_type
        )
      end
      @review.update_columns(
        address: params[:review][:address],
        detail_address: params[:review][:detail_address].gsub(/\s+/, ""),
        extra_address: params[:review][:extra_address],
        bd_nm: params[:review][:bd_nm],
        si_nm: params[:review][:si_nm],
        sgg_nm: params[:review][:sgg_nm],
        emd_nm: params[:review][:emd_nm],
        room: params[:review][:room],

        start_year: params[:review][:start_year],
        end_year: params[:review][:end_year],
        pet: params[:review][:pet] == "f" ? "" : params[:review][:pet_txt],
        loan_1: params[:review][:loan_1],
        elevator: params[:review][:elevator],
        balcony: params[:review][:balcony],
        is_recommend: params[:review][:is_recommend],
        
        hourly_seasonal_txt: params[:hourly_seasonal_txt],
        short_comment: params[:short_comment],
        long_comment: params[:long_comment]
      )

      review_tags.each do |k, v|
        review_item(@review, k, params[:"item-#{v}"], params[:"item-#{v}-txt"], params[:"#{v}_imgs"])
      end      
      
      if @review.status == "sample"
        redirect_to_url = "/mypage/reviews"
      elsif params[:temporary]
        @review.update_columns(status: @status[1])
        redirect_to_url = "/mypage/reviews"
        ReviewConfirm.create( status: @review.status, review: @review, confirm_type: "리뷰" )
      else
        @review.update_columns(status: @status[2])
        redirect_to_url = "/reviews/#{@review.id}"
        ReviewConfirm.create( status: @review.status, review: @review, confirm_type: "리뷰" )
      end
      @review.touch
      flash[:info] = '정상적으로 저장하였습니다.'
      render json: { result: "ok", type: "update", redirect_to: redirect_to_url }
    end
  end

  def retouch_review
    if @review.user != current_user 
      flash[:danger] = '권한이 없습니다.'
      redirect_back(fallback_location: root_path)
    else

      @retouch_review =
        if @review.edit_review.nil?
          Review.create(user: @review.user, original: @review)
        else
          @review.edit_review
        end

      # 주소 저장 
      if params[:main_img].present?
        @retouch_review.update_columns(
          main_img_name: rand(36**20).to_s(36),
          main_img: params[:main_img].read,
          main_img_content_type: params[:main_img].content_type
        )
      end
      @retouch_review.update_columns(
        lat: @review.lat,
        long: @review.long,
        address: params[:review][:address],
        detail_address: params[:review][:detail_address].gsub(/\s+/, ""),
        extra_address: params[:review][:extra_address],
        bd_nm: params[:review][:bd_nm],
        si_nm: params[:review][:si_nm],
        sgg_nm: params[:review][:sgg_nm],
        emd_nm: params[:review][:emd_nm],
        room: params[:review][:room],

        start_year: params[:review][:start_year],
        end_year: params[:review][:end_year],
        pet: params[:review][:pet] == "f" ? "" : params[:review][:pet_txt],
        loan_1: params[:review][:loan_1],
        elevator: params[:review][:elevator],
        balcony: params[:review][:balcony],
        is_recommend: params[:review][:is_recommend],
        
        hourly_seasonal_txt: params[:hourly_seasonal_txt],
        short_comment: params[:short_comment],
        long_comment: params[:long_comment],

        management_fee: @review.management_fee,
        management_type: @review.management_type,
        parking: @review.parking,

        contract_type: @review.contract_type,
        deposit: @review.deposit,
        monthly: @review.monthly,
        area_pyeong: @review.area_pyeong,
        area_square: @review.area_square,
        structure: @review.structure,
        usage: @review.usage,
        floor_detail: @review.floor_detail,
        start_date: @review.start_date,
        end_date: @review.end_date
      )

      @retouch_review.save

      review_tags.each do |k, v|
        review_item(@retouch_review, k, params[:"item-#{v}"], params[:"item-#{v}-txt"], params[:"#{v}_imgs"])
      end      
      
    
      @retouch_review.update_columns(status: @status[5])
      
      
      redirect_to_url = "/mypage/reviews"
      ReviewConfirm.create( status: @status[5], review: @review, confirm_type: "리뷰" )
      
      flash[:info] = '정상적으로 저장하였습니다.'
      render json: { result: "ok", type: "update", redirect_to: redirect_to_url }
    end
  end

  def show
   
    if (@imp_status[0..1].include?(@review.imp_status) && @status[0..1].include?(@review.status)) ||
      (@review.review_imp_imgs.pluck(:tag).first== "초본" && @status[0..1].include?(@review.status)) ||
      (@review.review_imp_imgs.pluck(:tag).first== "초본" && @status[2..3].include?(@review.status) && !(current_user == @review.user || current_user.role == "manager"))
      flash[:danger] = '잘 못 된 리뷰입니다.'
      redirect_back(fallback_location: root_path)
    else
      # (@review.status == "등록완료" || 
      # (@review.status == "등록신청" && @review.user == current_user) || 
      # (@review.status == "등록신청" && current_user.role == "manager"))
      
      
      
      current_user.histories.insert(0,params[:id]).uniq!
      current_user.update_column(:histories, current_user.histories[0..4])

      @check = current_user.viewer_histories.map(&:review_id).compact.include?(params[:id].to_i)
      @check = (@review.user == current_user || @check || current_user.role == "manager")
      @check_sec = current_user.sec_viewer_histories.map(&:review_id).compact.include?(params[:id].to_i)
      @check_sec = (@review.user == current_user || @check_sec || current_user.role == "manager")
     
      @have_review = @status[2..4].include?(@review.status)
      
      @check_review = ((current_user == @review.user || current_user.role == "manager") &&
                      @have_review) || 
                      @review.status == @status[4] # 작성자 or 관리자 or 등록완료 일때
      
      ###############
      @lat = @review.lat
      @long = @review.long
  
      @reviews = Review.within(1, origin: [@lat, @long]).closest(origin: [@lat, @long]).where(status: "등록완료").where.not(id: @review.id).limit(10)
      ###############

      @owner_comments = OwnerComment.where(status: "등록완료", address: @review.address, detail_address: @review.detail_address)
      
      ###############
      # population
      csv_code_table = SmarterCSV.process("#{Rails.root}/public/csv/house_review/emd_code.csv",  headers: true, converters: :all, header_converters: :symbol)
      si_code = brtcCode(@review.si_nm)
      @emd_row = csv_code_table.detect { |x| x[:"시도명"] == @review.si_nm && x[:"동리명"] == @review.emd_nm }

      csv_population_table = SmarterCSV.process("#{Rails.root}/public/csv/house_review/population/#{si_code}.csv",  headers: true, converters: :all, header_converters: :symbol)
      
      @population = csv_population_table.detect { |x| x[:"행정기관코드"] == @emd_row[:"행정동코드"] }

      @csv_rental_population_table = SmarterCSV.process("#{Rails.root}/public/csv/house_review/population_rental/#{si_code}.csv", headers: true, converters: :all, header_converters: :symbol)
      @rental_population = @csv_rental_population_table.detect { |x| x[:"도로명주소"] == @review.address }
      
      unless @rental_population.nil?
        @rental_female = @rental_population.to_a[7..28].select.each_with_index { |_, i| i.even? }.map { |a| a[1]}
        @rental_male = @rental_population.to_a[7..28].select.each_with_index { |_, i| i.odd? }.map { |a| a[1]}
      end
      ##############
      @recently_contract = @review.recently_contracts.to_a.select{ |a| a.suply_prvuse_ar == @review.area_pyeong }.last


      if @have_review && @check
        score = @review.review_items.map(&:score)
        @average = (score.inject(0.0) { |sum, el| sum + el } / score.size).round(1)
        @average = (@average*2).floor/2.0
        @result = case @average
          when (0..2.4) then "아쉽네요"
          when (2.5..3.4) then "평범해요"
          when (3.5..5) then "최고네요"
        end

        score = @review.review_items.where(tag: ["채광", "환기/냄새", "벌레", "파손", "방음", "누수", "외풍", "곰팡이","수압", "수온", "배수"]).map(&:score)
        @average_1 = (score.inject(0.0) { |sum, el| sum + el } / score.size).round(1)
        score = @review.review_items.where(tag: ["치안상태", "분리수거", "주차장"]).map(&:score)
        @average_2 = (score.inject(0.0) { |sum, el| sum + el } / score.size).round(1)
        
        score = @review.review_items.where(tag: ["응대", "수리 및 보완", "혜택", "보증금 반환 만족도"]).map(&:score)
        @average_3 = (score.inject(0.0) { |sum, el| sum + el } / score.size).round(1)
      
      elsif @have_review
        @average = "none"
        @average_1 = "??"
        @average_2 = "??"
        @average_3 = "??"
      else 
        @average = nil  
      end
    # else 
    #   flash[:danger] = '아직 준비 중인 리뷰 입니다.'
    #   redirect_back(fallback_location: root_path)
    end
  end
  def retouch_show
    # 작성자 & manager 체크 & edit_review.nil
    if @review.edit_review.nil?
      redirect_back(fallback_location: root_path)
    elsif !(@review.user == current_user || current_user.role == "manager")
      redirect_back(fallback_location: root_path)
    else
      @review = @review.edit_review

      @check = true
      @check_sec = true
      
      @owner_comments = OwnerComment.where(status: "등록완료", address: @review.address, detail_address: @review.detail_address)
      
      score = @review.review_items.map(&:score)
      @average = (score.inject(0.0) { |sum, el| sum + el } / score.size).round(1)
      @average = (@average*2).floor/2.0
      @result = case @average
        when (0..2.4) then "아쉽네요"
        when (2.5..3.4) then "평범해요"
        when (3.5..5) then "최고네요"
      end

      score = @review.review_items.where(tag: ["채광", "환기/냄새", "벌레", "파손", "방음", "누수", "외풍", "곰팡이","수압", "수온", "배수"]).map(&:score)
      @average_1 = (score.inject(0.0) { |sum, el| sum + el } / score.size).round(1)
      score = @review.review_items.where(tag: ["치안상태", "분리수거", "주차장"]).map(&:score)
      @average_2 = (score.inject(0.0) { |sum, el| sum + el } / score.size).round(1)
      score = @review.review_items.where(tag: ["응대", "수리 및 보완", "혜택", "보증금 반환 만족도"]).map(&:score)
      @average_3 = (score.inject(0.0) { |sum, el| sum + el } / score.size).round(1)
    end
  end
  
  def sample
    @review = Review.find_by(status: "sample")

    @owner_comments = OwnerComment.where(status: "sample")
    @check = true
    @check_sec = true
    @check_review = true

    if @check
      score = @review.review_items.map(&:score)
      @average = (score.inject(0.0) { |sum, el| sum + el } / score.size).round(1)
      @average = (@average*2).floor/2.0
      @result = case @average
        when (0..2.4) then "아쉽네요"
        when (2.5..3.4) then "평범해요"
        when (3.5..5) then "최고네요"
      end
      score = @review.review_items.where(tag: ["채광", "환기/냄새", "벌레", "파손", "방음", "누수", "외풍", "곰팡이","수압", "수온", "배수"]).map(&:score)
      @average_1 = (score.inject(0.0) { |sum, el| sum + el } / score.size).round(1)
      score = @review.review_items.where(tag: ["치안상태", "분리수거", "주차장"]).map(&:score)
      @average_2 = (score.inject(0.0) { |sum, el| sum + el } / score.size).round(1)
      score = @review.review_items.where(tag: ["응대", "수리 및 보완", "혜택", "보증금 반환 만족도"]).map(&:score)
      @average_3 = (score.inject(0.0) { |sum, el| sum + el } / score.size).round(1)
    end

     ###############
    # population
    csv_code_table = SmarterCSV.process("#{Rails.root}/public/csv/house_review/emd_code.csv",  headers: true, converters: :all, header_converters: :symbol)
    si_code = brtcCode(@review.si_nm)
    @emd_row = csv_code_table.detect { |x| x[:"동리명"] == @review.emd_nm }
    
    csv_population_table = SmarterCSV.process("#{Rails.root}/public/csv/house_review/population/#{si_code}.csv",  headers: true, converters: :all, header_converters: :symbol)
    @population = csv_population_table.detect { |x| x[:"행정기관코드"] == @emd_row[:"행정동코드"] }
    ##############


    render 'reviews/show'
  end

  


  def destroy
    @review.destroy
    redirect_to reviews_url
  end

  # 리뷰 주소 검색
  def search
    @juso = JSON.parse( RestClient::Request.execute(
        method:  :get, 
        url:     "http://www.juso.go.kr/addrlink/addrLinkApi.do?confmKey=#{ENV["JUSO-CONFM-KEY"]}&resultType=json&countPerPage=20&keyword=#{URI::encode(params[:keyword].force_encoding('UTF-8'))}",
        headers: { Accept: "application/json"}
      ))
    # currentPage
    # countPerPage
    render json: @juso
  end


  def check_rental_house
    @review = Review.find(params[:id])
    checkRentalHouse(@review)
    # 행안부 전월세 실거래가 
    @review.recently_contracts.destroy_all
    ['ar', 'or', 'rr', 'sr'].each do |dir|
      (2001..2007).to_a.map(&:to_s).each do |file|
        csv_table = SmarterCSV.process("#{Rails.root}/public/csv/house_review/#{dir}/#{file}.csv", headers: true, converters: :all, header_converters: :symbol)
        csv_rows = csv_table.select { |x| x[:"도로명"] == @review.address.gsub(@review.si_nm, '').gsub(@review.sgg_nm, '').gsub(@review.emd_nm, '').strip }
        csv_rows.each do |r|
          recently_contract = RecentlyContract.new
          recently_contract.review = @review

          recently_contract.contract_type = r[:"전월세구분"] # 전월세구분
          recently_contract.suply_prvuse_ar = r[:"전용면적(㎡)"] # 전용면적

          recently_contract.compet_de = r[:"계약년월"].to_s + format('%02d', r[:"계약일"]) # 계약년월일	ex) 20170807

          recently_contract.floor = r[:"층"]# 층수
          recently_contract.rent_gtn = r[:"보증금(만원)"].to_s.gsub(',', '') #	임대보증금(단위 : 만원) ex) 3470
          recently_contract.mt_rntchrg  = r[:"월세(만원)"].to_s.gsub(',', '') # 월임대료(단위 : 만원) ex) 14

          recently_contract.save
        end
      end
    end
    # 시군구,번지,본번,부번,건물명,전월세구분,전용면적(㎡),계약년월,계약일,보증금(만원),월세(만원),층,건축년도,도로명
    # recently_contracts
    # 전월세구분, 전용면적, 계약년월일, 보증금, 월세, 층수
    redirect_back(fallback_location: root_path)
  end

  private
  def set_review
    @review = Review.find params[:id]
  end

  # ReviewItem create & update
  def review_item(review, tag, score, comment, imgs)
    review_item = review.review_items.find_by(tag: tag)
    if review_item.nil?
      # create
      review_item = ReviewItem.create(tag: tag, score: score, comment: comment, review: review)
      if imgs.present?
        imgs.each do |item|
          if item.content_type.include?("image")
            ReviewImg.create(tag: tag,
              name: rand(36**20).to_s(36),
              content_type: item.content_type,
              file: item.read,
              review_item: review_item,
              review: review)
          else
            ReviewVideo.create(tag: tag,
              name: rand(36**20).to_s(36),
              content_type: item.content_type,
              file: item.read,
              review_item: review_item,
              review: review)
          end
        end
      end
    else
      # update
      review_item.update_columns(score: score, comment: comment) 
      
      remove_video_ids = review_item.review_videos.map(&:id)
      remove_img_ids = review_item.review_imgs.map(&:id)
      
      if imgs.present?
        imgs.each do |item|
          if item.content_type.include?("image")
            img = review_item.review_imgs.find_by(name: item.original_filename)
            if img.nil?
              ReviewImg.create(tag: tag,
                name: rand(36**20).to_s(36),
                content_type: item.content_type,
                file: item.read,          
                review_item: review_item,
                review: review)
            else
              remove_img_ids.delete(img.id)
            end
          else
            video = review_item.review_videos.find_by(name: item.original_filename)
            if video.nil?
              ReviewVideo.create(tag: tag,
                name: rand(36**20).to_s(36),
                content_type: item.content_type,
                file: item.read,
                review_item: review_item,
                review: review)
            else
              remove_video_ids.delete(video.id)
            end
          end
        end
      end
      ReviewVideo.where(id: remove_video_ids).destroy_all if !remove_video_ids.empty?
      ReviewImg.where(id: remove_img_ids).destroy_all if !remove_img_ids.empty?
    end
  end

  # lat, long 검색
  def get_geocoding(address)
    JSON.parse( RestClient::Request.execute(
      method:  :get, 
      url:     "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=#{URI::encode( address.force_encoding('UTF-8'))}",
      headers: { Accept: "application/json", "X-NCP-APIGW-API-KEY-ID": ENV["X-NCP-APIGW-API-KEY-ID"], "X-NCP-APIGW-API-KEY": ENV["X-NCP-APIGW-API-KEY"]}
    ) )
  end



  def csv_row(si_nm, file_name)
    csv_text = File.read("#{Rails.root}/public/csv/#{file_name}")
    csv_table = CSV.new(csv_text, headers: true, converters: :all, header_converters: :symbol)
    csv_row = csv_table.find { |row| row[:location] == si_nm }
  end
  def csv_chart(csv_row, name)
    chart_date = ["2019-07-01","2019-08-01","2019-09-01","2019-10-01","2019-11-01","2019-12-01","2020-01-01","2020-02-01","2020-03-01","2020-04-01","2020-05-01","2020-06-01"]
    result = { name: name, data: { } }
    csv_row.drop(1).each_with_index do |col, i|
      result[:data][:"#{chart_date[i]}"] = col[1]
    end
    return result
  end

end
