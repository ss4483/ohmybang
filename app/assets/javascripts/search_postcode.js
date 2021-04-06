/** 
 * 우편번호 검색
 *  
 *  [버튼]
 *    <input type="button" onclick="execDaumPostcode()" value="search">
 *  [검색 창 위치]
 *    <div id="wrap" style="">
 *      <img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1" onclick="foldDaumPostcode()" alt="접기 버튼">
 *    </div>
 * 
 * 
 * 주소 : #review_address
 * 상세 주소 : #review_extra_address
 * 시/도 : #review_si_nm
 * 시/군/구 : #review_sgg_nm
 * 읍/면/동 : #review_emd_nm
 * 건물 이름 : #review_bd_nm
 * 나머지 주소 입력 칸(auto focus) : #review_detail_address
 * **/
var element_wrap = document.getElementById('wrap');
function foldDaumPostcode() { element_wrap.style.display = 'none'; }
function execDaumPostcode() {
  var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
  new daum.Postcode({
    oncomplete: function(data) {
      var addr = '';
      var extraAddr = ''; 
      addr = data.roadAddress;
      if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){ extraAddr += data.bname; }
      if(data.buildingName !== '' && data.apartment === 'Y'){
        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
      }
      if(extraAddr !== ''){ extraAddr = ' (' + extraAddr + ')'; }
      
      document.getElementById("review_extra_address").value = extraAddr;
      $('#review_bd_nm').val(data.buildingName);
      $('#review_si_nm').val(data.sido);
      $('#review_sgg_nm').val(data.sigungu);
      $('#review_emd_nm').val(data.bname);

      document.getElementById("review_address").value = addr;
      // document.getElementById("review_detail_address").focus();

      element_wrap.style.display = 'none';
      document.body.scrollTop = currentScroll;
    },
    onresize : function(size) {
      element_wrap.style.height = size.height+'px';
    },
    width : '100%',
    height : '100%',
    shorthand: false
  }).embed(element_wrap);
  element_wrap.style.display = 'block';
}