module ReviewsHelper
  require 'csv'
  def options_for_years
    [['2015년', 2015], ['2016년', 2016], ['2017년', 2017], ['2018년', 2018], ['2019년', 2019]]
  end
  def review_tags
    {
      "채광": "lighting" ,
      "환기/냄새": "smell",
      "벌레": "bug",
      "파손": "damage",
      "방음": "soundproof",
      "누수": "leak",
      "외풍": "draft",
      "곰팡이": "mold",
      "수압": "pressure",
      "수온": "temp",
      "배수": "drain",
      "치안상태": "security",
      "분리수거": "recycle",
      "주차장": "parking",
      "응대": "service",
      "수리 및 보완": "repair",
      "혜택": "benefits",
      "보증금 반환 만족도": "deposit"
    }
  end
  
  def check_imp_type(review, value)
    review.review_imp_imgs.pluck(:tag).first == value
  end


  def review_room_img(review)
    if review.main_img.blank?
      room = if review.room == "원룸"
          "room_01.jpg"
        elsif review.room == "투/쓰리룸"
          "room_02.jpg"
        elsif review.room == "오피스텔"
          "room_03.jpg"
        elsif review.room == "아파트"
          "room_04.jpg"
        end
      return image_url(room)
    else 
      return "/images/reviews/#{review.main_img_name}"
    end
  end

  def review_title(review)
    return review.bd_nm.blank?? "#{review.emd_nm} #{review.room}" : review.bd_nm
  end


  def review_is_recommend(is_recommend)
    return image_url(is_recommend == "t" ? "good.png" : "bad.png")
  end

  def checkRentalHouse(review)

    review.update_columns(
      style_nm: [],
      suply_prvuse_ar: [],
      suply_cmnuse_ar: [],
      bass_rent_gtn: [],
      bass_mt_rntchrg: [],
      bass_cnvrs_gtn_lmt: []
    )

    @brtcCode = brtcCode(review.si_nm)
    @signguCode = signguCode("#{review.si_nm} #{review.sgg_nm}")
    pageNo = 1
    totalPageNo = 1
    # 전체페이지 반복으로 변경
    # 한개만인지 한개 이상인지 확인해보기
    rentalHouseList = JSON.parse( RestClient::Request.execute(
      method:  :get, 
      url:     "https://data.myhome.go.kr/rentalHouseList?serviceKey=#{ENV["RENTAL-HOUSE-LIST-DATA-KEY"]}&brtcCode=#{@brtcCode}&signguCode=#{@signguCode}&numOfRows=100&pageNo=#{pageNo}&",
    ))
    @totalCount = rentalHouseList["hsmpList"][0]["totalCount"]
    totalPageNo = (@totalCount/100.0).ceil()

    while pageNo <= totalPageNo
      # 2페이지 이상 불러오기
      if pageNo > 1
        rentalHouseList = JSON.parse( RestClient::Request.execute(
          method:  :get, 
          url:     "https://data.myhome.go.kr/rentalHouseList?serviceKey=#{ENV["RENTAL-HOUSE-LIST-DATA-KEY"]}&brtcCode=#{@brtcCode}&signguCode=#{@signguCode}&numOfRows=100&pageNo=#{pageNo}&",
        ) )
      end
      @rentalHouse = rentalHouseList["hsmpList"].select {|rh| rh["rnAdres"] == review.address }
      
      @rentalHouse.each do |rh|
        if pageNo == 1
          review.update_columns(
            is_rental_house: 't',
            instt_nm: 
              "#{rh["insttNm"].blank? ? nil : rh["insttNm"]}",# :string # 기관 명 ex) SH공사
            compet_de: 
              "#{rh["competDe"].blank? ? nil : rh["competDe"]}",# :date # 준공 일자	ex) 20170807
            hshld_co: 
              "#{rh["hshldCo"].blank? ? nil : rh["hshldCo"]}",# :integer # 세대 수	ex) 192
            suply_ty_nm: 
              "#{rh["suplyTyNm"].blank? ? nil : rh["suplyTyNm"]}",# :string # 공급 유형 명 ex) 50년임대
            house_ty_nm: 
              "#{rh["houseTyNm"].blank? ? nil : rh["houseTyNm"]}",# :string # 주택 유형 명 ex) 아파트
            heat_mthd_detail_nm: 
              "#{rh["heatMthdDetailNm"].blank? ? nil : rh["heatMthdDetailNm"]}",# :string # 난방 방식	 ex) 개별난방
            buld_stle_nm: 
              "#{rh["buldStleNm"].blank? ? nil : rh["buldStleNm"]}",# :string  # 건물 형태 ex) 복도식
            elvtr_instl_at_nm: 
              "#{rh["elvtrInstlAtNm"].blank? ? nil : rh["elvtrInstlAtNm"]}",# :string # 승강기 설치여부	ex) 전체동 설치
            parkng_co: 
              "#{rh["parkngCo"].blank? ? nil : rh["parkngCo"]}",# :integer # 주차수 ex) 183
          )
        end
        review.style_nm << (rh["styleNm"].blank? ? '' : rh["styleNm"]) # 형 명
        review.suply_prvuse_ar << (rh["suplyPrvuseAr"].blank? ? '' : rh["suplyPrvuseAr"]) # 공급 전용 면적 (단위 : ㎡)
        review.suply_cmnuse_ar << (rh["suplyCmnuseAr"].blank? ? '' : rh["suplyCmnuseAr"]) # 공급 전용 면적 (단위 : ㎡) ex) 21.7274
        review.bass_rent_gtn << (rh["bassRentGtn"].blank? ? '' : rh["bassRentGtn"])  # 기본 임대보증금(단위 : 원) ex) 34700000
        review.bass_mt_rntchrg << (rh["bassMtRntchrg"].blank? ? '' : rh["bassMtRntchrg"]) # :integer # 기본 월임대료(단위 : 원) ex) 149500
        review.bass_cnvrs_gtn_lmt << (rh["bassCnvrsGtnLmt"].blank? ? '' : rh["bassCnvrsGtnLmt"]) # :integer # 기본 전환보증금(단위 : 원) ex) 0
        review.save
      end
      # @rentalHouse = rentalHouseList["hsmpList"][0]
      pageNo += 1
    end
    
  end

  def brtcCode(brtc)
    csv_text = File.read("#{Rails.root}/public/csv/brtc_signgu_code.csv")
    csv_table = CSV.new(csv_text, headers: true, converters: :all, header_converters: :symbol)

    row = csv_table.find { |row| row[:name] == brtc }
  
    return row[:brtc_code]
  end

  def signguCode(brtc_signgu)
    csv_text = File.read("#{Rails.root}/public/csv/brtc_signgu_code.csv")
    csv_table = CSV.new(csv_text, headers: true, converters: :all, header_converters: :symbol)
    row = csv_table.find { |row| row[:name] == brtc_signgu }
    return row[:signgu_code]
  end

  def rentalHouseName
    { 
      "instt_nm": "기관 명",
      "compet_de": "준공 일자",
      "hshld_co": "세대 수",
      "suply_ty_nm": "공급 유형 명",
      "style_nm": "형 명",
      "suply_prvuse_ar": "공급 전용 면적", # (단위 : ㎡)
      "suply_cmnuse_ar": "공급 전용 면적", # (단위 : ㎡)
      "house_ty_nm": "주택 유형 명",
      "heat_mthd_detail_nm": "난방 방식",
      "buld_stle_nm": "건물 형태",
      "elvtr_instl_at_nm": "승강기 설치여부",
      "parkng_co": "주차수 ",
      "bass_rent_gtn": "기본 임대보증금", # (단위 : 원)
      "bass_mt_rntchrg": "기본 월임대료", # (단위 : 원)
      "bass_cnvrs_gtn_lmt": "기본 전환보증금" # (단위 : 원)
    }
  end 
end
