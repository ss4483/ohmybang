# 오마방 (OhMyBang) https://ohmybang.com/

## Introduction
밥 한 끼를 먹거나, 옷 한개를 살 때도 '리뷰'를 보고 사는데, 짧아도 반년 길면 2년 이상 거주할 집은 '리뷰'없이 계약을 할까? 하는 고민에서 시작한 프로젝트입니다.<br>그래서 고민 끝에 나온 '살 집을 찾는 사람에게 집주인도 모르는, 살아본 사람만 아는 하우스 리뷰가 담긴 웹 플랫폼' 오마방입니다.

## Deployment Environment
- AWS Lightsail CentOS 7
- Server Nginx, Passenger
- DB Mysql 5.7
- Ruby On Rails v5.2.6 (ruby v2.6.1)

## Gems
- [devise](https://github.com/heartcombo/devise) : 각종 인증 관리를 편리하게 도와주는 gem
- [figaro](https://github.com/laserlemon/figaro) : 환경변수관리를 도와주는 gem
- [rest-client](https://github.com/rest-client/rest-client) :  http 통신을 기반한 REST API를 편하게 사용하기위한 gem
- [kaminari](https://github.com/kaminari/kaminari) : pagination을 편리하게 해주는 gem
- import : pg결제 연동을 위한 gem
- [data-confirm-modal](https://github.com/ifad/data-confirm-modal) : html tag 내의 data-confirm을 브라우저 내장 confirm()이 아니ㅣ라 Bootstrap의  modal 컴포넌트로 띄워주는 gem
- activerecord-diff : 두개의 ActiveRecord를 편하게 비교하기 위한 gem
- [chart-js-rails](https://github.com/coderbydesign/chart-js-rails) : 데이터를 그래프로 표시하기 위한 gem
- [smarter_csv](https://github.com/tilo/smarter_csv) : csv파일을 편리하게 사용하기 위한 gem
- [jquery-gem](https://github.com/rails/jquery-rails) : html의 클라이언트 사이드 조작을 도와주는 javascript 라이브러리

## APIs
- [다음 - 우편번호서비스 API](https://postcode.map.daum.net/guide)<br>우편번호 찾기 api
- [네이버 - Maps](https://www.ncloud.com/product/applicationService/maps)<br>일반지도, 항공뷰, 마커, 클러스터링, 도형그리기
- [V WORLD - 2D 데이터API 2.0 레퍼런스](https://www.vworld.kr/dev/v4dv_2ddataguide2_s001.do)<br>우리나라 '시/도', '시/군/구', '읍/면/동' 데이터
- [행정안전부 - 도로명 주소 API](https://www.juso.go.kr/addrlink/devAddrLinkRequestGuide.do?menu=roadApi)<br>최신 도로명 주소 검색
- [한국토지주택공사 - 공공임대 주택 단지정보 조회 서비스](https://www.data.go.kr/data/15058476/openapi.do)<br>준공일자, 세대수, 면적, 기본 임대보증금, 기본 월 임대료 등 공공임대주택의 기본 정보
- [행정안전부 - 연령별 인구현황(CSV 파일데이터)](https://jumin.mois.go.kr/)<br>해당하는 지역의 남녀별, 연령별 인구
- [국토교통부 - 실거래가 정보(CSV 파일데이터)](https://www.data.go.kr/data/3050988/fileData.do)<br>실제 거래 보증금, 월세 등의 정보

