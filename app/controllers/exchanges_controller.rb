class ExchangesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_point
  def new
    if current_user.merchant_uid.nil?
      render 'personal_check'
    end

    @exchange = Exchange.new(user: current_user)
  end
  def edit
    @exchange = Exchange.find(params[:id])
  end
  def create
    @exchange = Exchange.new 
    @exchange.status = "환전신청"

    @exchange.pt = params[:point]
    @exchange.actual_money = @exchange.pt - @fees

    @exchange.phone = params[:buyer_phone]

    @exchange.account_holder = params[:account_holder]
    @exchange.bank = params[:bank]
    @exchange.account_number = params[:account_number]

    @exchange.user = current_user
    
    @exchange.save
    

    params[:imp_imgs].each_with_index do |item, index|
      ExchangeImpImg.create(tag: "user",
        name: rand(36**20).to_s(36),
        content_type: item.content_type,
        file: item.read,
        exchange: @exchange)
    end
    
    ExchangeConfirm.create(status: "환전신청", exchange: @exchange)

    flash[:info] = '정상적으로 환전신청 되었습니다.'
    render json: { result: "ok", redirect_to: "/mypage/reviews" }
  end

  def update
    @exchange = Exchange.find(params[:id])
    if @exchange.user == current_user
      if @exchange.status == "환전반려"
        @exchange.status = "환전신청"
        @exchange.pt = params[:point]
        @exchange.actual_money = @exchange.pt - @fees
        @exchange.phone = params[:buyer_phone]
        @exchange.account_holder = params[:account_holder]
        @exchange.bank = params[:bank]
        @exchange.account_number = params[:account_number]
        @exchange.save
        

        params[:imp_imgs].each_with_index do |item, index|
          ExchangeImpImg.create(tag: "user",
            name: rand(36**20).to_s(36),
            content_type: item.content_type,
            file: item.read,
            exchange: @exchange)
        end

        remove_imp_img_ids = @exchange.exchange_imp_imgs.map(&:id)
        if params[:"imp_imgs"].present?
          params[:"imp_imgs"].each_with_index do |item, index|
            imp_img = @exchange.exchange_imp_imgs.find_by(name: item.original_filename)
            if imp_img.nil?
              ExchangeImpImg.create(tag: "user",
                name: rand(36**20).to_s(36),
                content_type: item.content_type,
                file: item.read,
                review: @review)
            else 
              remove_imp_img_ids.delete(imp_img.id)
            end
          end
        end 
        ExchangeImpImg.where(id: remove_imp_img_ids).destroy_all if !remove_imp_img_ids.empty?

        ExchangeConfirm.create(status: "환전신청", exchange: @exchange)

        flash[:info] = '정상적으로 환전신청 되었습니다.'
        render json: { result: "ok", redirect_to: "/mypage/reviews" }

      else 
        flash[:danger] = '수정이 불가능한 상태입니다.'
        render json: { result: "error", redirect_to: root_path }
      end
    else
      flash[:danger] = '권한이 없습니다.'
      render json: { result: "error", redirect_to: root_path }
    end
  end

  def certifications
    url = "https://api.iamport.kr/certifications/#{params[:imp_uid]}"
    result = HTTParty.get(url, headers: { "Authorization" => Iamport.token })
    
    current_user.update_columns(name: result.parsed_response["response"]["name"], imp_uid: params[:imp_uid], merchant_uid: params[:merchant_uid])
  end

  private
  def check_point
    @available_pt = current_user.points.map(&:pt).inject(0, :+)  
    if @available_pt < @minimum_pt || current_user.exchanges.where(status: "환전신청").present?
      flash[:danger] = "최소 포인트(#{@minimum_pt})가 부족하거나 이미 환전신청 중입니다."
      redirect_back(fallback_location: root_path)
    end 
  end
end
