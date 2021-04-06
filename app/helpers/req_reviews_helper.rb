module ReqReviewsHelper
  def req_review(req_address) 
    Review.where(status: "등록완료", 
                si_nm: req_address.si_nm, 
                sgg_nm: req_address.sgg_nm, 
                emd_nm: req_address.emd_nm)
  end
  def req_review_count(req_address)
    req_review(req_address).count
  end 
end
