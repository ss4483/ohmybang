/** 휴대폰 번호 설정 **/
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

  var item_kind = $('.item_kind').val();
  var item_type = $('.item_type').text(); // 1, 10, 30
  var item_price = $(".item_price").text().replace(/,/g, '');
  var item_count = $(".item_count").val();
  var viewer_price = $(".viewer_price").last().text().replace(/,/g, '');

  var phone = $('#buyer_phone').val();
  var email = $("#buyer_email").val();
  var item_name = $(".item_name").val();

  var reg_phone = /^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$/;
  var current_time = new Date().getTime();
  // if ($('#policy1').is(":checked")) {
    if ((reg_phone.test(phone)) && (item_type == "1" || item_type == "10" || item_type == "30")) {
      // phone = phone.replace(/-/gi, '');
      // var isMobile = false; //initiate as false
      // device detection
      // if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|ipad|iris|kindle|Android|Silk|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(navigator.userAgent) 
      //     || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(navigator.userAgent.substr(0,4))) { 
      //   isMobile = true;
      // }

      IMP.request_pay({   
        pg : 'danal_tpay',
        escrow: false,
        merchant_uid: 'merchant_' + item_kind + '_'  + item_type + '_' + new Date().getTime(),
        name: 'Oh My Bang - ' + item_name + ' 이용권 구매',
        amount: viewer_price,
        buyer_email: email,
        buyer_tel: phone,
        digital: true,
        biz_num: "7624300288", // 사업자등록번호
        display : {
          card_quota: [2, 3],
        },
        custom_data: { item_type: item_type, item_count: item_count, item_price: item_price, item_kind: item_kind }
      },
        function(rsp) {
          var msg = '';
          var redirect_url = '';
          if (rsp.success) {
            jQuery.ajax({
              url: "/viewers/create", 
              type: 'POST',
              dataType: 'json',
              data: {
                authenticity_token: authen_token,
                imp_uid: rsp.imp_uid,
                merchant_uid: rsp.merchant_uid,
                paid_amount: rsp.paid_amount,
                item_type: item_type, 
                item_count: item_count, 
                item_price: item_price,
                item_kind: item_kind
              }
            }).done(function(data) {
              if ( data.result == 'success' ) {
                msg = '결제가 완료되었습니다.';
                // msg += '\n고유ID : ' + rsp.imp_uid;
                // msg += '\n상점 거래ID : ' + rsp.merchant_uid;
                msg += '\n결제 금액 : ' + rsp.paid_amount;
                // reviews/:id 일 경우 전페이지 아닐경우 mypage/viewers
                if (reg_url.test(referer)) {
                  redirect_url = referer;
                } else {
                  redirect_url = "/mypage/viewers";
                }
              } else {
                msg = '오류가 발생하여 결제를 자동 취소 하였습니다. 다시 시도 해주세요.';
                redirect_url = '/viewers'
              }
              alert(msg);
              location.replace(redirect_url);
            });
          } else {
            // msg = '결제에 실패하였습니다.';
            // msg += '\n' + rsp.error_msg;
            msg = rsp.error_msg;
            // redirect_url = '/viewers'
            alert(msg);
            location.reload(true);
            // location.replace(redirect_url);
          }
        }
      );
    

    } else {
      alert("이메일 또는 휴대폰 번호를 다시 확인해주세요.");
    } 
  // } else {
  //   alert("약관에 동의해주세요");
  // }
  
}



function cancelPay(id) {
  var result = confirm("정말 환불 하시겠습니까?");
  if(result) {
    jQuery.ajax({
      url: "/viewers/" + id, 
      "type": "DELETE",
      "contentType": "application/json",
      "data": JSON.stringify({
        "reason": "결제 환불", // 환불사유
      }),
      "dataType": "json",
      success : function(data) {
        alert(data.result);
        location.reload(true);  
      }
    });
  }
}

function secCancelPay(id) {
  var result = confirm("정말 환불 하시겠습니까?");
  if(result){
    jQuery.ajax({
      url: "/sec_viewers/" + id, 
      "type": "DELETE",
      "contentType": "application/json",
      "data": JSON.stringify({
        "reason": "결제 환불", // 환불사유
      }),
      "dataType": "json",
      success : function(data) {
        alert(data.result);
        location.reload(true);  
      }
    });

  }
}


function certification() {
  event.preventDefault();
  IMP.certification({
    merchant_uid : 'merchant_' + new Date().getTime() //본인인증과 연관된 가맹점 내부 주문번호가 있다면 넘겨주세요
  }, function(rsp) {
    if ( rsp.success ) {
      // 인증성공
      // console.log(rsp.imp_uid);
      // console.log(rsp.merchant_uid);
      
      $.ajax({
      type : 'POST',
      url : '/certifications/confirm',
      dataType : 'json',
      data : {
        imp_uid : rsp.imp_uid,
        merchant_uid: rsp.merchant_uid
      }
    }).done(function(rsp) {
      // 이후 Business Logic 처리하시면 됩니다.
      location.reload(true);  
    });
          
    } else {
      // 인증취소 또는 인증실패
        var msg = '인증에 실패하였습니다.';
        msg += '에러내용 : ' + rsp.error_msg;

        alert(msg);
    }
  });
}
