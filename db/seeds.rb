
# User DB 
user_csv = SmarterCSV.process("#{Rails.root}/public/db/users.csv", headers: true, converters: :all, header_converters: :symbol)
user_csv.each do |row|
  user_hash = row.to_hash
  user = User.new(user_hash.each { |k, v| user_hash[k] = nil if (v == 'NULL') } )
  user.save!(validate: false)
end

# Notice DB
notice_csv = SmarterCSV.process("#{Rails.root}/public/db/notices.csv", headers: true, converters: :all, header_converters: :symbol)
notice_csv.each do |row|
  notice_hash = row.to_hash
  notice = Notice.new(notice_hash.each { |k, v| notice_hash[k] = nil if (v == 'NULL') } )
  notice.save!(validate: false)
end

# req_address DB
req_address_csv = SmarterCSV.process("#{Rails.root}/public/db/req_addresses.csv", headers: true, converters: :all, header_converters: :symbol)
req_address_csv.each do |row|
  req_address = ReqAddress.new(row.to_hash)
  req_address.save!(validate: false)
end

# req_comment DB
req_comment_csv = SmarterCSV.process("#{Rails.root}/public/db/req_comments.csv", headers: true, converters: :all, header_converters: :symbol)
req_comment_csv.each do |row|
  req_comment = ReqComment.new(row.to_hash)
  req_comment.save!(validate: false)
end


# review DB
review_csv = SmarterCSV.process("#{Rails.root}/public/db/reviews.csv", headers: true, converters: :all, header_converters: :symbol)
review_item_csv = SmarterCSV.process("#{Rails.root}/public/db/review_items.csv", headers: true, converters: :all, header_converters: :symbol)
review_img_csv = SmarterCSV.process("#{Rails.root}/public/db/review_imgs.csv", headers: true, converters: :all, header_converters: :symbol)
review_video_csv = SmarterCSV.process("#{Rails.root}/public/db/review_videos.csv", headers: true, converters: :all, header_converters: :symbol)
review_imp_img_csv = SmarterCSV.process("#{Rails.root}/public/db/review_imp_imgs.csv", headers: true, converters: :all, header_converters: :symbol)
recently_contract_csv = SmarterCSV.process("#{Rails.root}/public/db/recently_contracts.csv", headers: true, converters: :all, header_converters: :symbol)


review_csv.each do |row|
  review_hash = row.to_hash
  review_hash.each { |k, v| review_hash[k] = nil if (v == 'NULL') }
  # 메인 이미지 없음...
  review_hash[:main_img_name] = nil
  review_hash[:main_img] = nil
  review_hash[:main_img_content_type] = nil
  
  review = Review.new(review_hash)
  review.save!(validate: false)

  # review_item DB
  review_items = review_item_csv.select { |x| x[:review_id] == review.id }
  review_items.each do |item_row| 
    review_item = ReviewItem.new(item_row)
    review_item.save!(validate: false)

    # review_img DB
    review_imgs = review_img_csv.select { |x| x[:review_item_id] == review_item.id }
    review_imgs.each do |review_img_row|
      review_img_row[:file] = File.read("#{Rails.root}/public/db/imgs/#{review_img_row[:id]}:#{review_img_row[:tag] == '환기/냄새' ? '환기:냄새' : review_img_row[:tag]}:#{review_item.id}:#{review.id}.#{review_img_row[:id] == 83 ? 'gif' : 'jpg'}")
      review_img = ReviewImg.new(review_img_row)
      review_img.save!(validate: false)
    end
    # review_video DB
    review_videos = review_video_csv.select { |x| x[:review_item_id] == review_item.id }
    review_videos.each do |review_video_row|
      review_video_row[:file] = File.read("#{Rails.root}/public/db/videos/#{review_video_row[:id]}:#{review_video_row[:tag]}:#{review_item.id}:#{review.id}.mp4")
      review_video = ReviewVideo.new(review_video_row)
      review_video.save!(validate: false)
    end
  end

  review_imp_imgs = review_imp_img_csv.select { |x| x[:review_id] == review.id }
  review_imp_imgs.each do |review_imp_img_row| 
    review_imp_img_row[:file] = File.read("#{Rails.root}/public/db/imp_imgs/#{review_imp_img_row[:id]}:#{review_imp_img_row[:tag]}:#{review.id}.jpg")
    review_img = ReviewImpImg.new(review_imp_img_row)
    review_img.save!(validate: false)
  end

  recently_contracts = recently_contract_csv.select { |x| x[:review_id] == review.id }
  recently_contracts.each do |recently_contract_row|
    recently_contract = RecentlyContract.new(recently_contract_row)
    recently_contract.save!(validate: false)
  end
end


# viewers
# viewer_histories
# sec_viewers
# point_histories



# User.create(email: "ss4483@carryculture.co.kr", password: "12341234", password_confirmation: "12341234", role: "manager")
# User.create(email: "chan306@carryculture.co.kr", password: "12341234", password_confirmation: "12341234", role: "manager")
# User.create(email: "dxxn07@carryculture.co.kr", password: "12341234", password_confirmation: "12341234", role: "manager")
# User.create(email: "test1@naver.com", password: "12341234", password_confirmation: "12341234")
# User.create(email: "test2@naver.com", password: "12341234", password_confirmation: "12341234")
# User.create(email: "test@naver.com", password: "12341234", password_confirmation: "12341234", role: "manager")

# sample = Review.new
# sample.user = User.find(1)
# sample.address = "오마방시 오마방구 오마방길"
# sample.detail_address = "101호"
# sample.extra_address = ""
# sample.bd_nm = "오마방 원룸"
# sample.si_nm = "오마방도"
# sample.sgg_nm = "오마방시"
# sample.emd_nm = "오마방동"
# sample.lat = 0
# sample.long = 0
# sample.room = "원룸"
# sample.start_year = 2017
# sample.end_year = 2019
# sample.floor = "지상층"
# sample.is_recommend = "t"
# sample.loan_1 = "t"
# sample.pet = "강아지"
# sample.hourly_seasonal_txt = "오마방 원룸 올라가는 길이 급경사가 있거든요. 사진처럼 언덕이 좀 많이 가팔라요.
# 근데 여기가 겨울에 눈도 잘 내리는 곳인데 꽁꽁 얼어 있는 경우가 많아서 정말 조심하셔야 될 거예요...
# 저도 몇 번 넘어졌다는..;;
# 아시는 분은 다 아시겠지만, 오마방 원룸이 야구장 근처에 있는데 저는 야구를 좋아하지 않아서 한 번도 안 가봤거든 요. 가끔 행사나 경기 늦게 끝날 때가 있는데 중요한 시험이나 일정이 있을 경우 정말 스트레스 받죠...이 정도로 소리 가 크게 들릴 줄은 몰랐어요.
# 예전에 기찻길 근처에서도 살아봤는데, 그 소리보다 훨씬 크더라구요...ᅲ
# 그게 2년 전 일인데, 지금은 개선됐을지 모르겠네요."
# sample.short_comment = "이 집은 제가 다시 입주한다 해도 좋을 정도로 기분좋게 살다가 갑니다."
# sample.long_comment = "나름 정성들여서 작성한 건데 꼭 되움이 되면 좋겠습니다!!
# 그리고, 중소기업 청년전세자금 대출이 가능한 집이라 혹시 생각해두고 계신 분은 집주인분께 잘 말씀드리면, 아마 잘 해주실 거예요ᄒᄒ
# 제가 살았을 때는 반려동물은 집주인 분이 절대로 안 된다고 해서...이건 좀 안타까웠습니다... 독립하면 꿈이었는데ᅲ 지금 사라졌는지는 모르겠는데, 앞에 오마방 중화반점이 대학생분들 학생증 제출하면 30%할인 해주거든요ᄏᄏ 오마방 세탁방도 학생증 제출하고 회원가입하면 20%정도 할인해줬어요!
# 참고하셔요!!"
# sample.status = "sample"
# sample.save

# ReviewItem.create(tag: "채광", score: 5, comment: "집을 구할때 가장 신경쓰는 부분이 채광과 외풍인데 정남향에 고층건물이 주변에 없어 햇빛이 너무 잘 들어요! 여름엔 너무 아침 일찍부터 잠이 깰 정도라 암막커튼이 필수입니당", review: sample)
# ReviewItem.create(tag: "환기/냄새", score: 5, comment: "화장실 배수 냄새가 가끔 올라오긴 하는데 심할 정도는 아니에요. 창문이 크다 보니 집안 환기도 충분했습니다~!", review: sample)
# ReviewItem.create(tag: "벌레", score: 3, comment: "바퀴벌레나 개미 같은 벌레는 한번도 본 적이 없는데ㅠ 거미가 자주 나와요; 저는 벌레 별로 무서워하지 않아서 눈에 보이면 그냥 잡아서 밖으로 보내거나 변기에 내렸는데 아니신 분들은 조금 힘드실 수도 있어요.. 사진같은 친구들이 일주일에 한번정도는 나타났던거 같아요ㅎㅎ..", review: sample)
# ReviewItem.create(tag: "파손", score: 3, comment: "집 컨디션은 좋은 편이에요~ 저도 집을 깨끗히 쓰는 편이라 처음 들어갈때랑 크게 다른 점 없이 나왔었네요 반년정도 밖에 안됐으니까 크게 다르지 않을거 같은데 다만 침대 옆 서랍장을 치우면 사진처럼 벽지가 찢어진 부분이 있어요 혹시 모르니까 확인해 두세용", review: sample)
# ReviewItem.create(tag: "방음", score: 3, comment: " 출근 시간대에는 어떤지 모르지만 밤에는 괜찮았어요 방음이 완벽한건 아닌데 생활소음? 정도라 지내는데 거슬릴 정도로 느껴본적은 없어요", review: sample)
# ReviewItem.create(tag: "누수", score: 5, review: sample)
# ReviewItem.create(tag: "외풍", score: 1, comment: "위에 말했듯이 집에서 가장 중요하게 생각하는게 채광과 외풍인데 창문이 커서 그런지 외풍이 좀 있는 편이였어요ㅠㅠ 커튼을 두꺼운걸 달아서 잘때는 바람을 최대한 차단했습니다.", review: sample)
# ReviewItem.create(tag: "곰팡이", score: 1, comment: "처음에 입주했을 때는 겨울이었고 도배가 새로 되있는 상태여서 곰팡이가 없었는데, 여름 장마철이 되니까 창문쪽 벽에 사진처럼 곰팡이가 생겼어요ㅠ 근데 집주인분께 말씀드리니 장마철에 간혹 이렇다고 심각해지면 업체 불러주신다고 하셨는데 귀찮아서 그냥 살았어요..ㅎㅎ", review: sample)
# ReviewItem.create(tag: "수압", score: 5, comment: "세면대나 싱크대, 변기 수압은 충분했구요~ 샤워기는 개인적으로 쓰는 샤워기 헤드가 있어서 교체해서 썼었는데 괜찮았어요", review: sample)
# ReviewItem.create(tag: "수온", score: 5, comment: "제가 살아보니까, 보일러 켜놓고 3분? 정도만 지나도 바로 온수가 나오는 게 정말 좋더라고요ᄒᄒ(물론 싱크대도 마 찬가지!)
#   제가 전에 살았던 집에서는 아침이나 저녁에 이제 사람들 샤워 많이 하는 시간대에는 심한 경우 20분이 지나야 미지 근한 물이 나왔었는데...ᅲᅲ 아무튼 시간대에 상관없이 수온이 잘 나와서 매우 매우 맘에 들어요~", review: sample)
# ReviewItem.create(tag: "배수", score: 5, review: sample)

# ReviewItem.create(tag: "치안상태", score: 5, comment: "오마방 원룸에서 도보로 1분 이내에 오마방 경찰서도 있구요.
# 여성 안심귀가 서비스도 이용되는 지역이라 새벽귀가도 큰 문제없어요!
# 또, 밤에도 주위가 상대적으로 밝은편이고, 새벽에도 유동인구가 많아서 크게 치안문제로 스트레스는 안받았어요. 제가 대학교 때문에 처음 혼자 사는 거라, 부모님이 치안문제를 제일 걱정 하셨는데 주위 환경 보시면 아시겠지만, 대학로에서 어느정도 떨어져 있어서 그런지 고성방가도 없고 좋습니다!", review: sample)
# ReviewItem.create(tag: "분리수거", score: 1, comment: "사진 보시면 아시겠지만, 페트병을 넣어야 되는 곳에 음식물 쓰레기를 묶어서 버리는 분도 있고, 참 개선돼야 될 부 분이 많은 거 같아요. 1년 전 오마방 원룸에 입주했을 때만 해도 이렇게 더럽지는 않았는데, 어느 순간 몇 분이 안 지 켜서 그런지, 훨씬 많이 지저분해진 거 같아서 참으로 안타깝네요...
# 지금은 나아졌기를 바랍니다...", review: sample)
# ReviewItem.create(tag: "주차장", score: 1, comment: "주차장은 최대 8대가 주차할 수 있도록 되어 있었습니다.
#   근데 오마방 원룸에 그때 당시 12대의 차량 이용자가 있었거든요. 분명히 입주 전에는 주차장 이용 충분히 가능하다 고 부동산 중개사님께서 그러셨는데, 집주인분께서는 나는 그런 말을 한적 없다고 하셔서 중개인분께 그 말 믿고 계 약했는데 주차장이 없다.라고 해도 죄송합니다만 말씀하셔서... 하...
#   이 부분 때문에 그 당시 스트레스를 많이 받았습니다. 이 부분 꼭 물어보시고 입주하시길 바랍니다. 지금은 확장되었 을라나...
#   또, 간혹 오마방 원룸 입주자도 아닌데, 안그래도 없는 주차장 이용하는 사람들 꽤 있었거든요. 근데 그걸 잡아낼 수 있는 좀 쉬운 방법이 있으면 좋았을 걸 이라 생각됩니다.
#   아 참고로 8대 주차구역 중에 장애인 주차장도 1곳 있었습니다.", review: sample)
# ReviewItem.create(tag: "응대", score: 5, comment: "제가 전에 살았던 원룸 집주인분은 거의 평일에는 통화가 안 되셨거든요. 물론 바쁘셨겠지만...
#   근데 오마방 원룸 주인분은 늦어도 2일 안에 카톡이나 문자나 전화로 답변해주셔서 답답한 건 없었습니다.", review: sample)
# ReviewItem.create(tag: "수리 및 보완", score: 5, comment: "2018년 10월 즈음에 보일러가 고장 났는데, 꽤나 신속하게 교체해주셔서 그 점이 제일 생각나요~
#   또, 다른 친구들 원룸에서는 형광등이나 수도 고장 나면 자부담해야 된다고 하는데, 오마방 집주인분은 비용 청구하면 다시 원금 주셔서 너무 감사했어요..ᅲᅲ", review: sample)
# ReviewItem.create(tag: "혜택", score: 5, comment: "제가 살았을 때는 1년 월세 비용 선금으로 지불하면 30%까지 할인해주셨고요. 제가 퇴거하기 전에 제 친구를 여기 소 개해줘서 그 친구가 지금 살고 있거든요.
#   그래서 소개비 인가? 그걸로 고맙다고 한 달 월세 환급해주셨어요 ᄒᄒ 대박대박", review: sample)
# ReviewItem.create(tag: "보증금 반환 만족도", score: 1, comment: "제가 살았을 때는 오마방 원룸 보증금이 1000만원이었는데, 반환 날짜가 19년 12월이었어요. 근데 집주인 분이 해외 여행을 가셔서 2주가 넘어서야 보증금을 돌려받았습니다.
#   워낙에 집주인 분이 평상시에 잘해주셔서 큰 의심은 안 했지만, 그래도 저한테는 정말 큰돈이라 정말 조마조마했어요. 집주인분도 충분히 미안하다고 하셨지만, 앞으로 이런 일이 서로 간에 없으면 더 좋을 거 같아요.", review: sample)
  
  

# Review.create(user_id: 1)
# ViewerHistory.create(viewer: 10, memo: "구매", user_id: 2)

# @long = 126.8494633
# @lat = 37.5652894

# kilometers_per_lat = 111.699
# kilometers_per_long = 110.567


# addresses = [ 
#   { address: "경상북도 경산시 대학로59길 20", detail_address: "201호", extra_address: "(조영동)", bd_nm: "영재원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "조영동" },
#   { address: "경상북도 경산시 대학로59길 20", detail_address: "202호", extra_address: "(조영동)", bd_nm: "영재원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "조영동" },
#   { address: "경상북도 경산시 대학로59길 20", detail_address: "303호", extra_address: "(조영동)", bd_nm: "영재원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "조영동" },
#   { address: "경상북도 경산시 대학로59길 20", detail_address: "301호", extra_address: "(조영동)", bd_nm: "영재원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "조영동" },
#   { address: "경상북도 경산시 대학로59길 20", detail_address: "502호", extra_address: "(조영동)", bd_nm: "영재원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "조영동" },
#   { address: "경상북도 경산시 대학로59길 17", detail_address: "101동403호", extra_address: "(대동)", bd_nm: "진양원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "대동" },
#   { address: "경상북도 경산시 대학로59길 17", detail_address: "101동201호", extra_address: "(대동)", bd_nm: "진양원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "대동" },
#   { address: "경상북도 경산시 대학로59길 17", detail_address: "101동202호", extra_address: "(대동)", bd_nm: "진양원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "대동" },
#   { address: "경상북도 경산시 대학로59길 17", detail_address: "101동302호", extra_address: "(대동)", bd_nm: "진양원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "대동" },
#   { address: "경상북도 경산시 청운1로 3-4", detail_address: "202호", extra_address: "(대동)", bd_nm: "봉성원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "대동" },
#   { address: "경상북도 경산시 대학로59길 22", detail_address: "1동202호", extra_address: "(조영동)", bd_nm: "태양원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "조영동"  },
#   { address: "경상북도 경산시 대학로59길 22", detail_address: "1동102호", extra_address: "(조영동)", bd_nm: "태양원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "조영동"  },
#   { address: "경상북도 경산시 대학로59길 22", detail_address: "1동505호", extra_address: "(조영동)", bd_nm: "태양원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "조영동"  },
#   { address: "경상북도 경산시 대학로59길 30-7", detail_address: "205호", extra_address: "(조영동)", bd_nm: "조은원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "조영동"  },
#   { address: "경상북도 경산시 대학로59길 30-7", detail_address: "503호", extra_address: "(조영동)", bd_nm: "조은원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "조영동"  },
#   { address: "경상북도 경산시 청운1로 31", detail_address: "203호", extra_address: "(조영동)", bd_nm: "조광원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "조영동"  },
#   { address: "경상북도 경산시 청운1로 31", detail_address: "503호", extra_address: "(조영동)", bd_nm: "조광원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "조영동"  },
#   { address: "경상북도 경산시 청운1로 31-2", detail_address: "503호", extra_address: "(조영동)", bd_nm: "성암원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "조영동"  },
#   { address: "경상북도 경산시 청운1로 31-2", detail_address: "203호", extra_address: "(조영동)", bd_nm: "성암원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "조영동"  },
#   { address: "경상북도 경산시 청운1로 31-2", detail_address: "205호", extra_address: "(조영동)", bd_nm: "성암원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "조영동"  },
# ]

# addresses = [ 
#   { address: "경상북도 경산시 대학로59길 20", detail_address: "201호", extra_address: "(조영동)", bd_nm: "영재원룸", si_nm: "경상북도", sgg_nm: "경산시", emd_nm: "조영동" }
# ]

# addresses.each_with_index do |add, i|
#   # if i == 0
#     r = Review.new
#     r.user = User.find(4)
#     r.address = add[:address]
#     r.detail_address = add[:detail_address]
#     r.extra_address = add[:extra_address]
#     r.bd_nm = add[:bd_nm]
#     r.si_nm = add[:si_nm]
#     r.sgg_nm = add[:sgg_nm]
#     r.emd_nm = add[:emd_nm]

#     geocoding = JSON.parse( RestClient::Request.execute(
#       method:  :get, 
#       url:     "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=#{URI::encode(r.address.force_encoding('UTF-8'))}",
#       headers: { Accept: "application/json", "X-NCP-APIGW-API-KEY-ID": ENV["X-NCP-APIGW-API-KEY-ID"], "X-NCP-APIGW-API-KEY": ENV["X-NCP-APIGW-API-KEY"]}
#     ) )

#     r.lat = geocoding["addresses"][0]["y"]
#     r.long = geocoding["addresses"][0]["x"]

#     r.room = "원룸"
#     r.start_year = [2015, 2016, 2017].sample
#     r.end_year = r.start_year + [0, 1, 2].sample
#     r.floor = "지상층"
#     r.is_recommend = ["t", "f"].sample
#     r.loan_1 = ["t", "f"].sample
#     r.pet = ["", "강아지", "고양이"].sample
#     r.hourly_seasonal_txt = "간에 천고에 인생에 하여도 것은 만물은 교향악이다. 풀이 힘차게 인간의 것이다. 인간에 미묘한 보이는 밥을 위하여서. 용감하고 인생의 사랑의 구하기 같이, 얼마나 눈이 그리하였는가? 인간의 피어나는 얼마나 사막이다. 할지니, 밝은 소금이라 이는 우리 맺어, 아름다우냐? 이 그들은 가슴에 그와 못하다 자신과 곳으로 굳세게 말이다. 광야에서 밝은 속에서 가지에 피가 발휘하기 눈이 봄바람이다.
#     품었기 곳이 가치를 끓는다. " if [true, false].sample
#     r.short_comment = "이것은 뼈 품었기 가치를 방황하였으며, 피가 따뜻한 황금시대의 것이다."
#     r.long_comment = "보이는 이것은 행복스럽고 가지에 풀밭에 끝에 예가 인도하겠다는 것이다. 곳으로 소리다.이것은 뼈 품었기 가치를 방황하였으며, 피가 따뜻한 황금시대의 것이다. 원질이 찾아다녀도, 그들을 뿐이다. 간에 천고에 인생에 하여도 것은 만물은 교향악이다. 풀이 힘차게 인간의 것이다. 인간에 미묘한 보이는 밥을 위하여서. 용감하고 인생의 사랑의 구하기 같이, 얼마나 눈이 그리하였는가? 인간의 피어나는 얼마나 사막이다. 할지니, 밝은 소금이라 이는 우리 맺어, 아름다우냐? 이 그들은 가슴에 그와 못하다 자신과 곳으로 굳세게 말이다. 광야에서 밝은 속에서 가지에 피가 발휘하기 눈이 봄바람이다.
#     품었기 곳이 가치를 끓는다. 바이며, 투명하되 있는 때에, 열락의 꽃이 인생을 온갖 얼마나 철환하였는가? 생명을" if [true, false].sample
#     ReviewImpImg.create(tag: "lessee",
#       name: rand(36**20).to_s(36),
#       file: Rails.root.join('public/sample.jpg').read,
#       content_type:"image/jpg",
#       review: r)
#     # r.status = "등록신청"
#     r.status = "등록완료"

#     r.save

#     ["채광", "환기/냄새", "벌레","파손","방음","누수","외풍","곰팡이","수압","수온","배수","치안상태","분리수거","주차장","응대","수리 및 보완","혜택","보증금 반환 만족도"].each do |tag|
#       r_item = ReviewItem.new
#       r_item.tag = tag
#       if tag == "보증금 반환 만족도"
#         r_item.score = [1,5].sample
#       else
#         r_item.score = [1,3,5].sample
#       end
#       if r_item.score == 1
#       r_item.comment = "보이는 이것은 행복스럽고 가지에 풀밭에 끝에 예가 인도하겠다는 것이다. 곳으로 소리다.이것은 뼈 품었기 가치를 방황하였으며, 피가 따뜻한 황금시대의 것이다. 원질이 찾아다녀도, 그들을 뿐이다. 간에 천고에 인생에 하여도 것은 만물은 교향악이다. 풀이 힘차게 인간의 것이다. 인간에 미묘한 보이는 밥을 위하여서. 용감하고 인생의 사랑의 구하기 같이, 얼마나 눈이 그리하였는가? 인간의 피어나는 얼마나 사막이다. 할지니, 밝은 소금이라 이는 우리 맺어, 아름다우냐? 이 그들은 가슴에 그와 못하다 자신과 곳으로 굳세게 말이다. 광야에서 밝은 속에서 가지에 피가 발휘하기 눈이 봄바람이다.
#         품었기 곳이 가치를 끓는다. 바이며, 투명하되 있는 때에, 열락의 꽃이 인생을 온갖 얼마나 철환하였는가? 생명을 보이는 풀밭에 듣는다. 두기 살 더운지라 지혜는 열락의 가진 이상은 철환하였는가? 곳으로 천고에 목숨이 영원히 예수는 수 이상을 이것이다. 얼음과 그들의 얼마나 품고 이 날카로우나 현저하게 청춘의 곳으로 사막이다. 대고, 인도하겠다는 같은 위하여서, 물방아 눈이 영락과 품고 칼이다." 
#       else 
#         if [true, false, false].sample
#           r_item.comment = "보이는 이것은 행복스럽고 가지에 풀밭에 끝에 예가 인도하겠다는 것이다. 곳으로 소리다.이것은 뼈 품었기 가치를 방황하였으며, 피가 따뜻한 황금시대의 것이다. 원질이 찾아다녀도, 그들을 뿐이다. 간에 천고에 인생에 하여도 것은 만물은 교향악이다. 풀이 힘차게 인간의 것이다. 인간에 미묘한 보이는 밥을 위하여서. 용감하고 인생의 사랑의 구하기 같이, 얼마나 눈이 그리하였는가? 인간의 피어나는 얼마나 사막이다. 할지니, 밝은 소금이라 이는 우리 맺어, 아름다우냐? 이 그들은 가슴에 그와 못하다 자신과 곳으로 굳세게 말이다. 광야에서 밝은 속에서 가지에 피가 발휘하기 눈이 봄바람이다.
#             품었기 곳이 가치를 끓는다. 바이며, 투명하되 있는 때에, 열락의 꽃이 인생을 온갖 얼마나 철환하였는가? 생명을 보이는 풀밭에 듣는다. 두기 살 더운지라 지혜는 열락의 가진 이상은 철환하였는가? 곳으로 천고에 목숨이 영원히 예수는 수 이상을 이것이다. 얼음과 그들의 얼마나 품고 이 날카로우나 현저하게 청춘의 곳으로 사막이다. 대고, 인도하겠다는 같은 위하여서, 물방아 눈이 영락과 품고 칼이다." 
#         end
#       end
#       r_item.review = r
#       r_item.save

#       if [true, false, false, false, false].sample
#         [1,2,3].sample.times.each do 
#           ReviewImg.create(tag: tag,
#             name: rand(36**20).to_s(36),
#             file: Rails.root.join('public/sample.jpg').read,
#             content_type:"image/jpg",
#             review_item: r_item,
#             review: r)
#         end
#       end
#     end

#     review_confirm = ReviewConfirm.new
#     review_confirm.status = "등록신청"
#     review_confirm.review = r
#     review_confirm.save

#     review_confirm = ReviewConfirm.new
#     review_confirm.status = "등록완료"
#     review_confirm.review = r
#     review_confirm.save

#     r.update_columns(editable: "f")

    
#   # end
# end
