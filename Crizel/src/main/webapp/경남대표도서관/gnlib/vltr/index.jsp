<%@page contentType="text/html;charset=utf-8"%>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>

<%
  String vltrIndex = "vltr.jsp?c=1";
  String vltrList = "vltr-list.jsp?c=1";
//  String vltrReqWrite = "vltr-req-write.jsp?c=1";
  String vltrAdminAction = "vltr-admin-action.jsp?c=1";
  String vltrAdminRequestList = "vltr-admin-request-list.jsp?c=1";
  String vltrUserRequestAction = "vltr-user-req-action.jsp?c=1";
  String vltrUserMyRequestList = "vltr-user-my-request-list.jsp?c=1";

  String[] timelist = {"09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00"};
  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
  String yyyyMMdd = sdf.format(Calendar.getInstance().getTime());
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <!-- 대표도서관 메타태그 -->
  <meta charset="utf-8">
  <meta http-equiv="content-Script-Type" content="text/javascript">
  <meta http-equiv="content-Style-Type" content="text/css">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
  <meta name="format-detection" content="telephone=no">
  <meta name="title" content="경상남도대표도서관">
  <meta name="keywords" content="경상남도대표도서관,도서관,경상남도">
  <meta name="description" content="경상남도대표도서관 홈페이지입니다.">

  <!-- 대표도서관 CSS -->
  <link href="../css_32.css?201121" rel="stylesheet" type="text/css" />
  <link href="../css_34.css?201121" rel="stylesheet" type="text/css" />
  <link href="../css_33.css?201121" rel="stylesheet" type="text/css" />
  <link href="../css_36.css?201121" rel="stylesheet" type="text/css" />

  <link rel="Shortcut Icon" href="/images/favicon.ico"><!-- // favicon -->
  <title>경상남도대표도서관</title>

  <script src="//ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
  <script src="//cdnjs.cloudflare.com/ajax/libs/jquery.form/4.2.2/jquery.form.min.js" integrity="sha384-FzT3vTVGXqf7wRfy8k4BiyzvbNfeYjK+frTVqZeNDFl8woCbF0CYG6g2fMEFFo/i" crossorigin="anonymous"></script>

  <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">
  <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>

  <script type="text/javascript" src="//cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>

  <script src="//dmaps.daum.net/map_js_init/postcode.v2.js"></script>

</head>
<body>

<div id="mr_contents">

  <div class="con">

    <div class="box2">
      <p>자원봉사 신청 안내</p>

      <p>자원봉사 신청 안내 설명 내용. (아래의 내용을 포함)</p>

      <p>신청내용</p>

      <p>봉사시간</p>

      <p>봉사활동 내용</p>

      <p>신청방법 및 문의</p>

      <p>기타</p>
    </div>

    <!-- 버튼 영역 -->
    <div class="btn_area center">
        <button type="button" class="btn medium color1 openlayer" onclick="loadVltr()">자원봉사 신청</button>
        <button type="button" class="btn medium white" onclick="loadVltrMyRequest()">신청 확인 / 취소</button>
    </div>
    <!-- //버튼 영역 끝 -->
  </div>

  <div id="divMyRequest"></div>

</div>


<!-- 시작: 자원봉사 시간 등록 -->
<div id="dialogVltrAdminForm" style="display:none">
  <form name="frmVltrAdmin" action="<%= vltrAdminAction %>" method="post">
    <input type="hidden" name="vltrmode">
    <input type="hidden" name="vltrno">
    <input type="hidden" name="vltrdate" value="<%= yyyyMMdd %>">
    <div class="board">
      <table class="board_write">
        <caption>자원봉사 시간 등록 항목입니다.</caption>
        <tbody>
          <tr class="topline">
            <th>시간</th>
            <td>
              <select name="vltrtime1">
                <% for(String time : timelist) { %>
                <option value="<%= time %>"><%= time %></option>
                <% } %>
              </select>
              ~
              <select name="vltrtime2">
                <% for(String time : timelist) { %>
                <option value="<%= time %>"><%= time %></option>
                <% } %>
              </select>
            </td>
          </tr>
          <tr>
            <th>장소</th>
            <td><input type="text" name="vltrloc"></td>
          </tr>
          <tr>
            <th>인원</th>
            <td><select name="vltrcnt">
            <%  for(int i=1; i<=30; i++) { %>
              <option value="<%= i %>"><%= i %>명</option>
            <%  } %>
            </select></td>
          </tr>
        </tbody>
      </table>
      <div align="right">
        <button type="submit" class="btn_type1 btn_type_s color2">저장</button>
        <button type="button" class="btn_type1 btn_type_s" onclick="$('#dialogVltrAdminForm').dialog('close')">취소</button>
      </div>
    </div>
  </form>
</div>
<!-- 끝: 자원봉사 시간 등록 -->

<!-- 시작: 자원봉사 신청 폼 -->
<div id="divVltrRequestForm" style="display:none;">
  <form name="frmVltrRequest" action="<%= vltrUserRequestAction %>">
    <input type="hidden" name="vltreqmode" value="REQUEST">
    <input type="hidden" name="vltrno">
    <input type="hidden" name="vltrdate">
    <div class="board">
      <table class="board_write">
        <caption>자원봉사 신청 등록 항목입니다.</caption>
        <colgroup>
          <col style="width:20%;">
          <col style="width:30%;">
          <col style="width:20%;">
          <col style="width:30%;">
        </colgroup>
        <tbody>
          <tr class="topline">
            <th scope="row"><span class="c_red">*</span>신청일시</th>
            <td colspan="3">날짜: <span id="vltrWorkVltrdate"></span>, 시간: <span id="vltrWorkVltrtime1"></span>~ <span id="vltrWorkVltrtime2"></span>, 장소: <span id="vltrWorkVltrloc"></span></td>
          </tr>
          <tr>
            <th scope="row"><span class="c_red">*</span>성명</th>
            <td><%= EgovUserDetailsHelper.getName() %></td>
            <th scope="row">
              <span class="c_red">*</span><label for="birthday">생년월일</label>
            </th>
            <td>
              <input type="text" name="birthday" id="birthday" style="width:90%;">
            </td>
          </tr>
          <tr>
            <th scope="row">
              <span class="c_red">*</span><label for="email">이메일</label>
            </th>
            <td colspan="3">
              <input type="text" name="email" id="email" style="width:90%;" value="<%= EgovUserDetailsHelper.getEmail() %>">
            </td>
          </tr>
          <tr>
            <th scope="row">
              <span class="c_red">*</span><label for="tel">전화번호</label>
            </th>
            <td colspan="3">
              <input type="text" name="tel1" size="2" maxlength="3"> -
              <input type="text" name="tel2" size="3" maxlength="4"> -
              <input type="text" name="tel3" size="3" maxlength="4">
            </td>
          </tr>
          <tr>
            <th scope="row">
              <span class="c_red">*</span><label for="phone">휴대전화번호</label>
            </th>
            <td colspan="3">
              <input type="text" name="hp1" size="2" maxlength="3"> -
              <input type="text" name="hp2" size="3" maxlength="4"> -
              <input type="text" name="hp3" size="3" maxlength="4">
            </td>
          </tr>
          <tr>
            <th scope="row"><span class="c_red">*</span>주소</th>
            <td colspan="3">
              <div class="tb_bo">
                <label class="blind" for="zipcd">우편번호</label>
                <input name="zipcd" id="zipcd" type="text" class="postCode" readonly>
                <button type="button" class="btn_type1 btn_type_s1" onclick="openPostWin()">우편번호 검색</a>
              </div>
              <div class="tb_bo">
                <label class="blind" for="addr1">주소</label>
                <input name="addr1" id="addr1" type="text" style="width: 90%;" readonly>
              </div>
              <div class="input_mo">
                <label class="blind" for="addr2">주소</label>
                <input name="addr2" id="addr2" type="text" style="width: 90%;">
              </div>
            </td>
          </tr>
          <tr>
            <th scope="row">
              <label for="schlnm">학교명</label>
            </th>
            <td>
              <input type="text" name="schlnm" id="schlnm" style="width:90%;">
            </td>
            <th scope="row">
              <label for="schlgrd">학년 / 반</label>
            </th>
            <td>
              <input type="text" name="schlgrd" id="schlgrd" style="width:90%;">
            </td>
          </tr>
        </tbody>
      </table>

      <!-- 버튼 영역 -->
      <div class="btn_area center">
        <button type="submit" class="btn medium color1 openlayer">신청하기</button>
        <button type="button" class="btn medium" id="btnVltreqClose">취소</button>
      </div>
      <!-- //버튼 영역 끝 -->
    </div>
  </form>
</div>
<!-- 끝: 자원봉사 신청 폼 -->

<div id="dialogVltrRequestResult" class="layer_wrap" style="display:none">
  <div class="layer_container">
    <div class="layer_head">자원봉사신청</div>
    <div class="layercon">
      <p class="form"></p>
      <p class="close_area">
        <button type="button" class="last_close layer_close" onclick="$('#dialogVltrRequestResult').dialog('close')">확인</button>
      <p>
    </div>
  </div>
</div>

<style type="text/css">
  .ui-dialog .ui-dialog-content {padding: 0;}
  label.error {font-size:12px; color:#FF0000; }
</style>

<script language="javascript">
  $(function(){
    $("form[name='frmVltrAdmin']").ajaxForm({
      beforeSubmit: function(arr, $form, options) {
        return true;
      },
      success: function(response,status){
        $("#dialogVltrAdminForm").dialog("close");
        loadVltrList($("form[name='frmVltrAdmin']").find("input[name='vltrdate']").val());
      },
      error: function(response, status){
        alert("오류가 발생하였습니다. 입력값을 다시 확인하십시오.");
      }
    });

    $("form[name='frmVltrRequest']").ajaxForm({
      beforeSubmit: function(arr, $form, options) {
        return $("form[name='frmVltrRequest']").valid();
      },
      success: function(response,status){
        loadVltrList($("form[name='frmVltrRequest']").find("input[name='vltrdate']").val());
        $("#dialogVltrRequestResult").find("p.form").html(response);
        $("#dialogVltrRequestResult").dialog('open');

        $("form[name='frmVltrRequest']").find("input").val("");
        $("#divVltrRequestForm").dialog("close");
      },
      error: function(response, status){
        alert("오류가 발생하였습니다. 입력값을 다시 확인하십시오.");
      }
    });

    $("form[name='frmVltrRequest']").validate({
      debug: false,
      onkeyup: false,
      onfocusout: false,
      rules: {
        birthday: { required: true, number:true , maxlength: 8},
        email: { required: true, maxlength: 100 },
        tel1: { required: true, number:true, maxlength: 3 },
        tel2: { required: true, number:true, maxlength: 4 },
        tel3: { required: true, number:true, maxlength: 4 },
        hp1: { required: true, number:true, maxlength: 3 },
        hp2: { required: true, number:true, maxlength: 4 },
        hp3: { required: true, number:true, maxlength: 4 },
        zipcd: { required: true },
        addr1: { required: true },
        addr2: { required: true, maxlength: 50 },
        schlnm: { maxlength: 50 },
        schlgrd: { maxlength: 50 }
      }, 
      messages: {
        birthday: { required: '필수 입력값 입니다.', maxlength: $.validator.format("생일은 {0} 글자 이상 입력할 수 없습니다.")},
        email: { required: '메일주소는 필수 입력값 입니다.', maxlength: $.validator.format("메일주소는 {0} 글자 이상 입력할 수 없습니다.")},
        tel1: { required: '필수값', number: '숫자만 가능', maxlength: $.validator.format("{0}자 이상 입력할 수 없음")},
        tel2: { required: '필수값', number: '숫자만 가능', maxlength: $.validator.format("{0}자 이상 입력할 수 없음")},
        tel3: { required: '필수값', number: '숫자만 가능', maxlength: $.validator.format("{0}자 이상 입력할 수 없음")},
        hp1: { required: '필수값', number: '숫자만 가능', maxlength: $.validator.format("{0}자 이상 입력할 수 없음")},
        hp2: { required: '필수값', number: '숫자만 가능', maxlength: $.validator.format("{0}자 이상 입력할 수 없음")},
        hp3: { required: '필수값', number: '숫자만 가능', maxlength: $.validator.format("{0}자 이상 입력할 수 없음")},
        zipcd: { required: '필수값' },
        addr1: { required: '필수 입력값 입니다.' },
        addr2: { required: '필수 입력값 입니다.', maxlength: $.validator.format("{0}자 이상 입력할 수 없음") },
        schlnm: { maxlength: $.validator.format("{0} 글자 이상 입력할 수 없습니다.")},
        schlgrd: { maxlength: $.validator.format("{0} 글자 이상 입력할 수 없습니다.")},
      }
    });

    $("#dialogVltrRequestResult").dialog({
      autoOpen: false,
      modal: true,
      width: '500px',
      height: 'auto',
    }).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();


    $("#dialogVltrAdminForm").dialog({
      autoOpen: false,
      modal: true,
      width: '450px',
      height: 'auto',
    }).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();

  
    $("#btnVltreqClose").click(function() {
      $("#divVltrRequestForm").dialog("close");
    });

    $("#divVltrRequestForm").dialog({
      autoOpen: false,
      modal: true,
      width: '800px',
      height: 'auto',
    }).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();

  });

  function getTimestamp() {
    return (new Date()).getTime();
  }

  function loadVltr() {
    $("#mr_contents").load("<%= vltrIndex %>&dummy=" + getTimestamp(), function() {
      window.scrollTo(0,0);
    });
  }

  function loadVltrMyRequest() {
    $("#divMyRequest").load("<%= vltrUserMyRequestList %>&dummy=" + getTimestamp());
  }
  
  function loadVltrList(vltrdate) {
    $("#divVltrList").load("<%= vltrList %>&dumy="+ getTimestamp() +"&vltrdate=" + vltrdate);
  }

  function confirmVltrWorkDelete(vltrno, vltrdate) {
    if( confirm("자원봉사 일정을 삭제 하시겠습니까? 삭제 하시면 지원봉사 신청 목록도 삭제 됩니다.") ) {
      $.ajax({method:'post'
        , url: '<%= vltrAdminAction %>'
        , data: {vltrno : vltrno, vltrmode : 'DELETE'}
      }).done(function(){
        loadVltrList(vltrdate)
      });
    }
  }

  function loadVltrRequestForm(vltrno, vltrdate, vltrtime1, vltrtime2, vltrloc) {
    $("#divVltrRequestForm").find("input[name='vltrno']").val(vltrno);
    $("#divVltrRequestForm").find("input[name='vltrdate']").val(vltrdate);

    $("#vltrWorkVltrdate").text(vltrdate);
    $("#vltrWorkVltrtime1").text(vltrtime1);
    $("#vltrWorkVltrtime2").text(vltrtime2);
    $("#vltrWorkVltrloc").text(vltrloc);

    $("#divVltrRequestForm").dialog("open");
  }

  function openVltrWorkModifyForm(vltrno, vltrdate, vltrtime1, vltrtime2, vltrloc, vltrcnt) {
    $("form[name='frmVltrAdmin']").find("input[name='vltrmode']").val('MODIFY');
    $("form[name='frmVltrAdmin']").find("input[name='vltrno']").val(vltrno);
    $("form[name='frmVltrAdmin']").find("input[name='vltrdate']").val(vltrdate);
    $("form[name='frmVltrAdmin']").find("input[name='vltrtime1']").val(vltrtime1);
    $("form[name='frmVltrAdmin']").find("input[name='vltrtime2']").val(vltrtime2);
    $("form[name='frmVltrAdmin']").find("input[name='vltrloc']").val(vltrloc);
    $("form[name='frmVltrAdmin']").find("select[name='vltrcnt']").val(vltrcnt);
    $("#dialogVltrAdminForm").dialog('open');
  }

  function loadVltrRequestList(vltrno) {
    console.log("loadVltrRequestList");
    $("#divLoadVltrRequestList").load("<%= vltrAdminRequestList %>&dumy="+ getTimestamp() +"&vltrno=" + vltrno);
  }

  function vltrAdminProcess(vltreqno, vltrno, userid, vltrstcd) {
    $.ajax({
      method: 'POST',
      url: '<%= vltrAdminAction %>',
      data: {vltrmode: 'REQUEST_PROCESS', 'vltreqno': vltreqno, 'vltrno': vltrno, 'userid': userid, 'vltrstcd': vltrstcd}
    }).done(function( msg ) {
      loadVltrRequestList(vltrno);
    });
  }

  function formatDate() {
    var d = new Date(),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [year, month, day].join('-');
  }

  function openPostWin() {
    new daum.Postcode({
      oncomplete: function(data) {
        var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
        var extraRoadAddr = ''; // 도로명 조합형 주소 변수

        // 법정동명이 있을 경우 추가한다. (법정리는 제외)
        // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
        if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
            extraRoadAddr += data.bname;
        }
        // 건물명이 있고, 공동주택일 경우 추가한다.
        if(data.buildingName !== '' && data.apartment === 'Y'){
           extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
        }
        // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
        if(extraRoadAddr !== ''){
            extraRoadAddr = ' (' + extraRoadAddr + ')';
        }
        // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
        if(fullRoadAddr !== ''){
            fullRoadAddr += extraRoadAddr;
        }
        $("#zipcd").val(data.zonecode);
        $("#addr1").val(fullRoadAddr);
      }
    }).open();
  }

</script>

</body>
</html>