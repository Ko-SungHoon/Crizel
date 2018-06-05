<%@page contentType="text/html;charset=utf-8"%>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>

<%
  String lectList = "lect-list.jsp?c=1";      // "index.lib?contentsSid=119";
  String lectWrite = "lect-write.jsp?c=1";    // "index.lib?contentsSid=121";
  String lectRead = "lect-view.jsp?c=1";      // "index.lib?contentsSid=120";
  String lectModify = "lect-modify.jsp?c=1";  // "index.lib?contentsSid=122";

  String rgstAction = "rgst-action.jsp?c=1";
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
    <link href="../css_32.css" rel="stylesheet" type="text/css" />
    <link href="../css_34.css" rel="stylesheet" type="text/css" />
    <link href="../css_33.css" rel="stylesheet" type="text/css" />
    <link href="../css_36.css" rel="stylesheet" type="text/css" />

    <link rel="Shortcut Icon" href="/images/favicon.ico"><!-- // favicon -->
    <title>경상남도대표도서관</title>

    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/jquery.form/4.2.2/jquery.form.min.js" integrity="sha384-FzT3vTVGXqf7wRfy8k4BiyzvbNfeYjK+frTVqZeNDFl8woCbF0CYG6g2fMEFFo/i" crossorigin="anonymous"></script>

    <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">
    <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>

    <script type="text/javascript" src="//cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
</head>
<body>


    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/jquery.form/4.2.2/jquery.form.min.js" integrity="sha384-FzT3vTVGXqf7wRfy8k4BiyzvbNfeYjK+frTVqZeNDFl8woCbF0CYG6g2fMEFFo/i" crossorigin="anonymous"></script>

    <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">
    <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>

    <script type="text/javascript" src="//cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>

    <style type="text/css">
      .ui-dialog .ui-dialog-content {padding: 0;}
       label.error {font-size:12px; color:#FF0000; }
    </style>

<%= EgovUserDetailsHelper.getAuthorities() %>
<div id="mr_contents"></div>


<div id="dialogLectureRegister" class="layer_wrap" title="강좌 접수" style="display:none">
  <form name="frmLectRegister" action="<%= rgstAction %>" method="post">
    <input type="hidden" name="rgstmode" value="REGISTER">
    <input type="hidden" name="lectno">
    <div class="layer_container">
      <div class="layer_head">수강신청</div>
      <a href="javascript:$('#dialogLectureRegister').dialog('close')" class="first_close layer_close"><img src="<%= request.getContextPath() %>/images/common/lnb_btn_close3.png" alt="닫기"></a>
      <div class="layercon">
      <% if(EgovUserDetailsHelper.isRole("ROLE_USER") ) { %>
        <p class="form">
          수강신청을 진행하시겠습니까?<br>
          확인을 클릭하면 바로 수강신청 처리됩니다.<br>
          <% if(EgovUserDetailsHelper.isRole("ROLE_ADMIN") ) { %>
          <label style="float:none;"><input type="radio" name="rgstmethod" value="VISIT">방문접수</label>
          <label style="float:none;"><input type="radio" name="rgstmethod" value="TEL" checked>전화접수</label>
          <% } else { %>
          <input type="hidden" name="rgstmethod" value="ONLINE">
          <% } %>
          <br>
          연락처 : 
          <input type="text" name="usertel1" size="3" maxlength="3">-
          <input type="text" name="usertel2" size="4" maxlength="4">-
          <input type="text" name="usertel3" size="4" maxlength="4">
        </p>
        <p class="close_area">
          <button type="submit" class="last_close layer_close">확인</button>
          <button type="button" class="last_close layer_close" onclick="$('#dialogLectureRegister').dialog('close')">취소</button>
        <p>
      <% } else { %>
        <p class="form">
          로그인을 해야 수강신청을 할 수 있습니다.
        </p>
        <p class="close_area">
          <button type="button" class="last_close layer_close">로그인</button>
          <button type="button" class="last_close layer_close" onclick="$('#dialogLectureRegister').dialog('close')">취소</button>
        </p>
      <% } %>
      </div>
    </div>
  </form>
</div>


<div id="dialogLectureRegisterResult" class="layer_wrap" title="강좌 접수 결과" style="display:none">
  <div class="layer_head">수강 신청 결과</div>
  <a href="javascript:$('#dialogLectureRegisterResult').dialog('close')" class="first_close layer_close"><img src="<%= request.getContextPath() %>/images/common/lnb_btn_close3.png" alt="닫기"></a>
  <div class="layercon">
    <p class="form">
      <span class="result"></span>
      <br>
      ※수강신청 내역은 "내 도서관" 메뉴에서 확인 할 수 있습니다.
    </p>
    <p class="close_area">
      <button type="button" class="last_close" onclick="location.href='<%= request.getContextPath() %>/index.lib?menuCd=DOM_000000206002001000'">내 도서관 가기</button>
      <button type="submit" class="last_close" onclick="$('#dialogLectureRegisterResult').dialog('close')">확인</button>
    <p>
  </div>
</div>

<script language="javascript">
  function getTimestamp() {
    return (new Date()).getTime();
  }

  $(function(){
    $("#mr_contents").load("<%= lectList %>&dummy=" + getTimestamp(), function() {
      window.scrollTo(0,0);
    });

    $("form[name='frmLectRegister']").ajaxForm({
      beforeSubmit: function(arr, $form, options) {
        return true;
      },
      success: function(response,status){
        $("#dialogLectureRegister").dialog("close");
        $("#dialogLectureRegisterResult").find("span.result").html(response);
        $("#dialogLectureRegisterResult").dialog("open");
      },
      error: function(response, status){
        alert("오류가 발생하였습니다. 입력값을 다시 확인하십시오.");
      }
    });


    $("#dialogLectureRegister").dialog({
      autoOpen: false,
      modal: true,
      width: 400
    }).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();

    $("#dialogLectureRegisterResult").dialog({
      autoOpen: false,
      modal: true,
      width: 550,
      height: 240
    }).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();


  });

  function openDialogLectureRegister(lectno) {
    $("#dialogLectureRegister").find("input[name='lectno']").val(lectno);
    $("#dialogLectureRegister").dialog("open");
  }

  function loadLectWrite() {
    $("#mr_contents").load("<%= lectWrite %>&dummy=" + getTimestamp(), function() {
      window.scrollTo(0,0);
    });
  }

  function loadLectModify(lectno) {
    $("#mr_contents").load("<%= lectModify %>&dummy=" + getTimestamp() + "&lectno=" + lectno, function() {
      window.scrollTo(0,0);
    });
  }

  function loadLectList(queryString) {
    $("#mr_contents").load("<%= lectList %>&dummy=" + getTimestamp() + "&" + queryString, function() {
      window.scrollTo(0,0);
    });
  }

  function loadLectRead(lectno) {
    $("#mr_contents").load("<%= lectRead %>&dummy=" + getTimestamp() + "&lectno=" + lectno, function() {
      window.scrollTo(0,0);
    });
  }
</script>


</body>
</html>