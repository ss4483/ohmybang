class ExchangeConfirmsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_manager

  # 환전 거부
  def reject_create
    req_exc = Exchange.find(params[:req_exc_id])
    req_exc.update_columns(status: "환전반려")
    ExchangeConfirm.create(status: "환전반려", exchange: req_exc, memo: params[:memo])
    flash[:info] = '정상적으로 환전반려 되었습니다.'
    redirect_back(fallback_location: root_path)
  end

  # 환전 수락
  def confirm_create
    req_exc = Exchange.find(params[:req_exc_id]) 
    req_exc_user = req_exc.user
    req_pt = req_exc.pt # 환전 포인트
    points = 
      req_exc_user
        .points
        .where("pt > 0 AND exp_date > ?", Date.current)  # 만료되지 않은 포인트들
        .order(exp_date: "ASC") # 오름차순 정렬
    
    # 만료 되지 않은 포인트들에서 환전 포인트 빼기 
    points.each do |point|
      if point.pt >= req_pt
        point.pt -= req_pt
        req_pt = 0
      else 
        req_pt -= point.pt
        point.pt = 0
      end

      break if req_pt == 0
    end

    
    if req_pt == 0 # 환전포인트가 0 일때
      points.each(&:save)
      point_history = PointHistory.create(pt: req_exc.pt, memo: "환전완료", exchange: req_exc, user: req_exc.user)
      req_exc.update_columns(status: "환전완료")
      
      ExchangeConfirm.create(status: "환전완료", exchange: req_exc)

      flash[:info] = '정상적으로 환전완료 되었습니다.'
      redirect_back(fallback_location: root_path)
    else # 환전포인트가 부족 할 때,
      flash[:danger] = '오류가 발생 되었습니다.\n다시 확인해주세요.'
      redirect_back(fallback_location: root_path)
    end
  end

end
