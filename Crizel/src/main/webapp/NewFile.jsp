<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>
<%@page import="egovframework.rfc3.iam.manager.ViewManager"%>
<%@page import="egovframework.rfc3.user.web.SessionManager"%>

<%
  String _list = "index.lib?contentsSid=165";
  String _write = "index.lib?contentsSid=167";
  String _view = "index.lib?contentsSid=166";
  String _modify = "index.lib?contentsSid=168";

  String _register = "index.lib?contentsSid=169";
  
  SessionManager sessionManager = new SessionManager(request);
  ViewManager viewManager = new ViewManager(request, response);
  boolean isRole = sessionManager.isRoleAdmin() || viewManager.isGranted(request, "DOM_000000203006000000", "WRITE");
  
  String birthdayYear = EgovUserDetailsHelper.getLoginVO().getBrth()==null?"":EgovUserDetailsHelper.getLoginVO().getBrth();
  if(!"".equals(birthdayYear)){
	  birthdayYear = birthdayYear.substring(0,4);
  }
%>


    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/jquery.form/4.2.2/jquery.form.min.js"></script>

    <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">
    <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>

    <script type="text/javascript" src="//cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
    <script type="text/javascript" src="//cdn.jsdelivr.net/jquery.validation/1.16.0/additional-methods.min.js"></script>
    
    <script>
		$(function(){
			<%-- var id = "<%=EgovUserDetailsHelper.getId()%>";
			var password = btoa("<%=EgovUserDetailsHelper.getPassword()%>");
			$.ajax({
				type : "POST",
				url : "http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/userinfoview?id="+id,
				contentType : "application/json; charset=utf-8",
				datatype : "json",
				success : function(data) {
					var obj = JSON.parse(data);
					var birthday = obj.USER_DATA.BIRTHDAY;
					var birthdayYear = birthday.substring(0,4);
					$("#birthdayYear").val(birthdayYear);
				},
				error : function(e) {
					alert("에러발생");
				}
			}); --%>
		});
	</script>
	
    <style type="text/css">
      .ui-dialog .ui-dialog-content {padding: 0;}
      label.error {font-size:12px; color:#FF0000; }

      .ui-progressbar {position: relative;}
    </style>

<div id="mr_contents"></div>

<div id="dialogStoryRegister" class="layer_wrap" title="접수 신청" style="display:none">
  <form name="frmStoryRegister" action="<%= _register %>" method="post" onsubmit="return checkRegisterTel(this);">
    <input type="hidden" name="rgstmode" value="REGISTER">
    <input type="hidden" id="birthdayYear" value="<%=birthdayYear%>">
    <input type="hidden" name="stno">
    <div class="layer_container">
      <div class="layer_head">접수 신청</div>
      <a href="javascript:closeRegisterDialog();" class="first_close layer_close"><img src="<%= request.getContextPath() %>/images/common/lnb_btn_close3.png" alt="닫기"></a>
      <div class="layercon">
      <% if(isRole) { %>
        <div class="form">
          <p class="mt_10">
            <label style="float:none;"><input type="radio" name="rgstmethod" value="VISIT">방문접수</label>
            <label style="float:none;"><input type="radio" name="rgstmethod" value="TEL" checked>전화접수</label>
          </p>
          <p class="mt_10" style="text-align:left;">
            <label style="float:none;" for="rgst_userid">아이디 :</label> <input type="text" name="userid" id="rgst_userid" size="10">
            <button type="button" id="btnUserInfoSearch" class="btn_type1 btn_type_s color1">검색</button>
          </p>
          <p class="mt_10" style="text-align:left;">
            <label style="float:none;" class="rgst_username" for="rgst_username">&nbsp;이 름&nbsp; :</label> <input type="text" name="username" id="rgst_username" size="10">
          </p>
          <p class="mt_10" style="text-align:left;">
            <label for="usertel_st" style="float:none;">연락처 :</label>
            <input type="text" name="usertel1" size="3" maxlength="3" title="전화번호 앞자리" id="usertel_st">-
            <input type="text" name="usertel2" size="4" maxlength="4" title="전화번호 중간자리">-
            <input type="text" name="usertel3" size="4" maxlength="4" title="전화번호 뒷자리">
          </p>
        </div>
        <p class="close_area">
          <button type="submit" class="last_close layer_close">확인</button>
          <button type="button" class="last_close layer_close" onclick="$('#dialogStoryRegister').dialog('close')">취소</button>
        <p>
      <% } else if(EgovUserDetailsHelper.isRole("ROLE_USER")) { %>
        <div class="form">
          <p class="txt">접수를 진행하시겠습니까?</p>
          <p class="txt">확인을 클릭하면 바로 접수 신청 처리됩니다.</p>
          <% if(isRole) { %>
          <p class="mt_10">
            <label style="float:none;"><input type="radio" name="rgstmethod" value="VISIT">방문접수</label>
            <label style="float:none;"><input type="radio" name="rgstmethod" value="TEL" checked>전화접수</label>
	        </p>
          <% } else { %>
          <input type="hidden" name="rgstmethod" value="ONLINE">
          <% } %>
          <p class="mt_15">
      	  <label for="usertel_st">연락처 : </label>
          <input type="text" name="usertel1" size="3" maxlength="3" title="전화번호 앞자리" id="usertel_st">-
          <input type="text" name="usertel2" size="4" maxlength="4" title="전화번호 중간자리">-
          <input type="text" name="usertel3" size="4" maxlength="4" title="전화번호 뒷자리">
          </p>
        </div>
        <p class="close_area">
          <button type="submit" class="last_close layer_close">확인</button>
          <button type="button" class="last_close layer_close" onclick="$('#dialogStoryRegister').dialog('close')">취소</button>
        <p>
      <% } else { %>
        <p class="form">
          로그인을 해야 접수 할 수 있습니다.
        </p>
        <p class="close_area">
          <button type="button" class="last_close layer_close" onclick="location.href='<%= request.getContextPath() %>/index.lib?menuCd=DOM_000000217001000000&return=' + location.href ">로그인</button>
          <button type="button" class="last_close layer_close" onclick="$('#dialogStoryRegister').dialog('close')">취소</button>
        </p>
      <% } %>
      </div>
    </div>
  </form>
</div>

<div id="dialogStoryRegisterResult" class="layer_wrap" title="강좌 접수 결과" style="display:none">
  <div class="layer_head">접수 신청 결과</div>
  <a href="javascript:;" class="first_close layer_close"><img src="<%= request.getContextPath() %>/images/common/lnb_btn_close3.png" alt="닫기" onclick="location.reload();"></a>
  <div class="layercon">
  <% if(isRole) { %>
    <p class="form">
      <span class="result"></span>
    </p>
    <p class="close_area">
      <button type="button" class="last_close" onclick="location.reload();">확인</button>
    <p>
	<% } else if(EgovUserDetailsHelper.isRole("ROLE_USER") ) { %>
    <p class="form">
      <span class="result"></span>
      <br>
      ※접수 신청 내역은 "내 도서관" 메뉴에서 확인 할 수 있습니다.
    </p>
    <p class="close_area">
      <button type="button" class="last_close" onclick="location.href='<%= request.getContextPath() %>/index.lib?menuCd=DOM_000000206003000000'" style="width:120px;">내도서관 가기</button>
      <button type="button" class="last_close" onclick="location.reload();">확인</button>
    <p>
	<% } %>
  </div>
</div>

<div id="dialogUploading" class="layer_wrap" title="동화구현 등록 중" style="display:none">
  <div class="layer_container">
    <div class="layer_head">동화구현 등록</div>
    <div class="layercon">
      <div style="margin-bottom:20px;">등록중입니다. 잠시만 기다려 주세요.</div>
      <div id="progressbar"></div>
    </div>
</div>
</div>

<script language="javascript">
  function getTimestamp() {
    return (new Date()).getTime();
  }

  function closeRegisterDialog() {
    $('#dialogStoryRegister').dialog('close');
  }

  $(function(){
    var originalTitle=document.title;
    function hashChange(){
      var hashSplit = location.hash.slice(1).split("/");
	  switch( hashSplit[0] ) {
	    case 'story' :
			if( hashSplit[2] == 'modify' ) loadModify( hashSplit[1] );
			else loadRead( hashSplit[1] );
			break;
	    case 'page' :
			loadList( hashSplit[1] );
			break;
	    default :
			loadList('');
	  }
    }

    if ("onhashchange" in window){ // cool browser
        $(window).on('hashchange', hashChange).trigger('hashchange');
    }else{ // lame browser
        var lastHash='';
        setInterval(function(){
            if (lastHash!=location.hash) hashChange();
            lastHash=location.hash;
        },100)
    }

    $("form[name='frmStoryRegister']").ajaxForm({
      beforeSubmit: function(arr, $form, options) {
        return true;
      },
      success: function(response,status){
        $("#dialogStoryRegister").dialog("close");
        $("#dialogStoryRegisterResult").find("span.result").html(response);
        $("#dialogStoryRegisterResult").dialog("open");
      },
      error: function(response, status){
        alert("오류가 발생하였습니다. 입력값을 다시 확인하십시오.");
      }
    });


    $("#dialogStoryRegister").dialog({
      autoOpen: false,
      modal: true,
      width: 350
    }).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();

    $("#dialogStoryRegisterResult").dialog({
      autoOpen: false,
      modal: true,
      width: 480,
      height: 'auto'
    }).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();

    $("#dialogUploading").dialog({
      autoOpen: false,
      modal: true,
      width: 300
    }).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();


$(window).resize(function (){
    // width값을 가져오기
  var width_size = window.outerWidth;
  if (width_size <= 480) {
	$("#dialogStoryRegisterResult").dialog({
    width: '90%'
}).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();
}else{
    $("#dialogStoryRegisterResult").dialog({
      width: 480
    }).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();
}

})
  var width_size = window.outerWidth;
  if (width_size <= 480) {
	$("#dialogStoryRegisterResult").dialog({
    width: '90%'
}).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();
}



    $( "#progressbar" ).progressbar({value: false});
    
    <% if(isRole) { %>
    $("#btnUserInfoSearch").click(function(){
      $("#rgst_username").val("");
      $("input[name='usertel1']").val("");
      $("input[name='usertel2']").val("");
      $("input[name='usertel3']").val("");

      $.getJSON("http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/userinfoview?id=" + $("#rgst_userid").val(), function( data ) {
        var userJson = $.parseJSON(JSON.stringify(data));
        if( userJson["RESULT_INFO"] != "SUCCESS" ) {
          alert("사용자 정보를 찾을 수 없습니다.");
        } else {
          $("#rgst_username").val(userJson["USER_DATA"]["NAME"]);
          var tel = userJson["USER_DATA"]["HANDPHONE"].split("-");
          $("input[name='usertel1']").val(tel[0]);
          $("input[name='usertel2']").val(tel[1]);
          $("input[name='usertel3']").val(tel[2]);
        }
      });
    });
    <% } %>
  });

  function openDialogStoryRegister(stno) {
	var birthdayCheckDt = new Date();
	var birthdayYear_1 = birthdayCheckDt.getFullYear();
	var birthdayYear_2 = $("#birthdayYear").val();
	var age = birthdayYear_1 - birthdayYear_2 + 1;
	if(age<5 || age>8){
		alert('신청연령이 아닙니다. 참여자 본인 아이디로 로그인 하세요.');
		return;
	}
	  
    $("#dialogStoryRegister").find("input[name='stno']").val(stno);

    <% if(EgovUserDetailsHelper.isRole("ROLE_USER")) { %>
    var tel = "<%= (EgovUserDetailsHelper.getLoginVO().getHtel() == null ) ? "" : EgovUserDetailsHelper.getLoginVO().getHtel() %>".split("-");
    $("form[name='frmStoryRegister']").find("input[name='usertel1']").val(tel[0]);
    $("form[name='frmStoryRegister']").find("input[name='usertel2']").val(tel[1]);
    $("form[name='frmStoryRegister']").find("input[name='usertel3']").val(tel[2]);
    <% } %>

    $("#dialogStoryRegister").dialog("open");
  }

  function loadWrite() {
    $("#mr_contents").load("<%= _write %>&dummy=" + getTimestamp(), function() {
      window.scrollTo(0,0);
    });
  }

  function loadModify(stno) {
    $("#mr_contents").load("<%= _modify %>&dummy=" + getTimestamp() + "&stno=" + stno, function() {
      window.scrollTo(0,0);
    });
  }

  function loadList(queryString) {
    $("#mr_contents").load("<%= _list %>&dummy=" + getTimestamp() + "&" + queryString, function() {
      window.scrollTo(0,0);
    });
  }

  function loadRead(stno) {
    $("#mr_contents").load("<%= _view %>&dummy=" + getTimestamp() + "&stno=" + stno, function() {
      window.scrollTo(0,0);
    });
  }

  function jumpPage(currPage) {
    document.formPage.currPage.value = currPage;
    location.hash = "page/" + $("form[name='formPage']").serialize();
  }

  function storySearch(frm) {
    document.formPage.currPage.value = 1;
    document.formPage.where.value = frm.where.value;
    document.formPage.keyword.value = frm.keyword.value;

    location.hash = "page/" + $("form[name='formPage']").serialize();
    return false;
  }

  function checkRegisterTel(frm) {
	if( frm.usertel1.value == '' || frm.usertel2.value == '' || frm.usertel3.value == '') {
	  alert('연락처는 필수 입력하셔야 합니다.');
	  return false;
    } else {
	  return true;
    }
  }

</script>                                                                                                             