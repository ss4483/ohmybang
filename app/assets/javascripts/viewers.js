
function inputPhoneNumber(obj) {
  var number = obj.value.replace(/[^0-9]/g, "");
  var phone = "";

  if(number.length < 4) {
      return number;
  } else if(number.length < 7) {
      phone += number.substr(0, 3);
      phone += "-";
      phone += number.substr(3);
  } else if(number.length < 11) {
      phone += number.substr(0, 3);
      phone += "-";
      phone += number.substr(3, 3);
      phone += "-";
      phone += number.substr(6);
  } else {
      phone += number.substr(0, 3);
      phone += "-";
      phone += number.substr(3, 4);
      phone += "-";
      phone += number.substr(7);
  }
  obj.value = phone;
}


function payment() {
  var referer = $("input[name=referer]").val();
  var reg_url = /(\/reviews\/)\d+/;
  var authen_token = $("meta[name='csrf-token']").attr('content');
  
  var phone = $('#buyer_phone').val();
  var email = $("#buyer_email").val();

  var reg_phone = /^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$/;

  var item_type = $('.item_type').text(); // 1, 10, 30
  var item_price =   $(".item_price").text().replace(/,/g, '');
  var item_count = $(".item_count").val();
  var viewer_price = $(".viewer_price").last().text().replace(/,/g, '');
  var name = $(".item_name").val();
  var item_kind = $('.item_kind').val();
  
  if ($('#agree').is(":checked")) {
    if ((reg_phone.test(phone)) && (item_type == "1" || item_type == "10" || item_type == "30")) {
      var order_id = 'order_' + new Date().getTime();

      //실제 복사하여 사용시에는 모든 주석을 지운 후 사용하세요
      BootPay.request({
        price: viewer_price, //실제 결제되는 가격
        application_id: "5daef4cc5ade160030569a9e",
        name: '오마방 - ' + name + ' 이용권', //결제창에서 보여질 이름
        // pg: 'danal',
        // method:  ['card', 'bank', 'easy'] , //결제수단, 입력하지 않으면 결제수단 선택부터 화면이 시작합니다.
        show_agree_window: 1, // 부트페이 정보 동의 창 보이기 여부
        items: [
          {
            item_name: name + " 이용권 " + item_type + "개", //상품명
            qty: item_count, //수량
            unique: name + "_이용권_"+ item_type, //해당 상품을 구분짓는 primary key
            price: item_price, //상품 단가
            cat1: name + ' 이용권', // 대표 상품의 카테고리 상, 50글자 이내
          }
        ],
        user_info: {
          email: email,
          phone: phone
        },
        order_id: order_id, //고유 주문번호로, 생성하신 값을 보내주셔야 합니다.
        params: {item_type: item_type, item_count: item_count, item_price: item_price},
        // account_expire_at: '2018-05-25', // 가상계좌 입금기간 제한 ( yyyy-mm-dd 포멧으로 입력해주세요. 가상계좌만 적용됩니다. )
        extra: {
          vbank_result: 1 // 가상계좌 사용시 사용, 가상계좌 결과창을 볼지(1), 말지(0), 미설정시 봄(1)
            // quota: '0,2,3' // 결제금액이 5만원 이상시 할부개월 허용범위를 설정할 수 있음, [0(일시불), 2개월, 3개월] 허용, 미설정시 12개월까지 허용
        }
      }).error(function (data) { //결제 진행시 에러가 발생하면 수행됩니다.
        msg = '오류가 발생하여 결제를 자동 취소 하였습니다. 다시 시도 해주세요.';
        alert(msg);
        console.log(data);
      }).cancel(function (data) { //결제가 취소되면 수행됩니다.
        msg = '결제를 취소하였습니다.';
        alert(msg);
        console.log(data);
      }).ready(function (data) {
        // 가상계좌 입금 계좌번호가 발급되면 호출되는 함수입니다.

        console.log(data);
      }).confirm(function (data) { //결제가 실행되기 전에 수행되며, 주로 재고를 확인하는 로직이 들어갑니다.
        BootPay.transactionConfirm(data);
        //주의 - 카드 수기결제일 경우 이 부분이 실행되지 않습니다.
        // console.log(data);
        // var enable = true; // 재고 수량 관리 로직 혹은 다른 처리
        // if (enable) {
        //   BootPay.transactionConfirm(data); // 조건이 맞으면 승인 처리를 한다.
        // } else {
        //   BootPay.removePaymentWindow(); // 조건이 맞지 않으면 결제 창을 닫고 결제를 승인하지 않는다.
        // }
      }).close(function (data) { // 결제창이 닫힐때 수행됩니다. (성공,실패,취소에 상관없이 모두 수행됨)
          // console.log(data);
      }).done(function (data) {
        //결제가 정상적으로 완료되면 수행됩니다
        //비즈니스 로직을 수행하기 전에 결제 유효성 검증을 하시길 추천합니다.
        console.log(data);
        var msg = '';
        var redirect_url = '/';
        
        if (data.status == 1) {
          jQuery.ajax({
            url: "/viewers/create", 
            type: 'POST',
            dataType: 'json',
            data: {
              authenticity_token: authen_token,
              receipt_id: data.receipt_id,
              order_id: data.order_id,
              item_type: item_type, 
              item_count: item_count, 
              item_price: item_price
            }
          }).done(function(ajax_data) {
            if ( ajax_data.result == 'success' ) {
              msg = '결제가 완료되었습니다.';
              // msg += '\n고유ID : ' + rsp.imp_uid;
              // msg += '\n상점 거래ID : ' + rsp.merchant_uid;
              msg += '\n결제 금액 : ' + data.amount;
              // reviews/:id 일 경우 전페이지 아닐경우 mypage/viewers
              // if (reg_url.test(referer)) {
              //   redirect_url = referer;
              // } else {
              //   redirect_url = "/mypage/viewers";
              // }
            } else {
              msg = '오류가 발생하여 결제를 자동 취소 하였습니다. 다시 시도 해주세요.';
              // redirect_url = '/viewers'
            }
            alert(msg);
            location.replace(redirect_url);
          });
        } else {
          // msg = '결제에 실패하였습니다.';
          // msg += '\n' + rsp.error_msg;

          // msg = rsp.error_msg;

          // redirect_url = '/viewers'
          alert(msg);
          location.replace(redirect_url);
        }
        
      });

    } else {
      alert("이메일 또는 휴대폰 번호를 다시 확인해주세요.");
    } 
  } else {
    alert("약관에 동의해주세요");
  }
}
