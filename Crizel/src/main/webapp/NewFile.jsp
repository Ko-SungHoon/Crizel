<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>
<%
  String lectList = "index.lib?contentsSid=119";
  String lectWrite = "index.lib?contentsSid=121";
  String lectRead = "index.lib?contentsSid=120";
  String lectModify = "index.lib?contentsSid=122";

  String rgstAction = "index.lib?contentsSid=134";

  String banList = "index.lib?contentsSid=206";
%>

    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/jquery.form/4.2.2/jquery.form.min.js"></script>

    <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">
    <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>

    <script type="text/javascript" src="//cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
    <script type="text/javascript" src="//cdn.jsdelivr.net/jquery.validation/1.16.0/additional-methods.min.js"></script>
    <style type="text/css">
      .ui-dialog .ui-dialog-content {padding: 0;}
      label.error {font-size:12px; color:#FF0000; }

      .ui-progressbar {
        position: relative;
      }
    </style>

<div id="mr_contents">

</div>

<div id="dialogLectureRegister" class="layer_wrap" title="강좌 접수" style="display:none">
  <form name="frmLectRegister" action="<%= rgstAction %>" method="post" onsubmit="return checkRegisterTel(this);">
    <input type="hidden" name="rgstmode" value="REGISTER">
    <input type="hidden" name="lectno">
    <div class="layer_container">
      <div class="layer_head">수강신청</div>
      <a href="javascript:closeRegisterDialog();" class="first_close layer_close"><img src="<%= request.getContextPath() %>/images/common/lnb_btn_close3.png" alt="닫기"></a>
      <div class="layercon">
      <% if(EgovUserDetailsHelper.isRole("ROLE_ADMIN") ) { %>
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
          <button type="button" class="last_close layer_close" onclick="$('#dialogLectureRegister').dialog('close')">취소</button>
        <p>
      <% } else if(EgovUserDetailsHelper.isRole("ROLE_USER")) { %>
        <div class="form">
          <p class="txt">수강신청을 진행하시겠습니까?</p>
          <p class="txt">확인을 클릭하면 바로 수강신청 처리됩니다.</p>
          <input type="hidden" name="rgstmethod" value="ONLINE">
          <p class="mt_10">
          <label for="usertel_st">연락처 : </label>
          <input type="text" name="usertel1" size="3" maxlength="3" title="전화번호 앞자리" id="usertel_st">-
          <input type="text" name="usertel2" size="4" maxlength="4" title="전화번호 중간자리">-
          <input type="text" name="usertel3" size="4" maxlength="4" title="전화번호 뒷자리">
          </p>
        </div>
        <p class="close_area">
          <button type="submit" class="last_close layer_close">확인</button>
          <button type="button" class="last_close layer_close" onclick="$('#dialogLectureRegister').dialog('close')">취소</button>
        <p>
      <% } else  { %>
        <p class="form">
          로그인을 해야 수강신청을 할 수 있습니다.
        </p>
        <p class="close_area">
          <button type="button" class="last_close layer_close" onclick="location.href='<%= request.getContextPath() %>/index.lib?menuCd=DOM_000000217001000000&return=' + location.href ">로그인</button>
          <button type="button" class="last_close layer_close" onclick="$('#dialogLectureRegister').dialog('close')">취소</button>
        </p>
      <% } %>
      </div>
    </div>
  </form>
</div>

<div id="dialogLectureRegisterResult" class="layer_wrap" title="강좌 접수 결과" style="display:none">
  <div class="layer_head">수강 신청 결과</div>
  <a href="javascript:;" class="first_close layer_close"><img src="<%= request.getContextPath() %>/images/common/lnb_btn_close3.png" alt="닫기" onclick="location.reload();"></a>
  <div class="layercon">
    <% if(EgovUserDetailsHelper.isRole("ROLE_ADMIN") ) { %>
    <p class="form">
      <span class="result"></span>
    </p>
    <p class="close_area">
      <button type="submit" class="last_close" onclick="location.reload();">확인</button>
    <p>
	<% } else if(EgovUserDetailsHelper.isRole("ROLE_USER") ) { %>
    <p class="form">
      <span class="result"></span>
      <br>
      ※수강신청 내역은 "내 도서관" 메뉴에서 확인 할 수 있습니다.
    </p>
    <p class="close_area">
      <button type="button" class="last_close" onclick="location.href='<%= request.getContextPath() %>/index.lib?menuCd=DOM_000000206002001000'" style="width:140px;">내도서관 가기</button>
      <button type="submit" class="last_close" onclick="location.reload();">확인</button>
    <p>
	<% } %>
  </div>
</div>

<div id="dialogUploading" class="layer_wrap" title="강좌 등록중" style="display:none">
  <div class="layer_container">
    <div class="layer_head">강좌 등록</div>
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
    $('#dialogLectureRegister').dialog('close');
  }

  $(function(){
    var originalTitle=document.title;

    function hashChange(){
      var hashSplit = location.hash.slice(1).split("/");
      switch( hashSplit[0] ) {
	      case 'lect' :
          if( hashSplit[2] == 'modify' ) loadLectModify( hashSplit[1] );
          else loadLectRead( hashSplit[1] );
          break;
  	    case 'page' :
      		loadLectList( hashSplit[1] );
      		break;
        case 'ban' :
          loadLectBanList();
          break;
  	    default :
      		loadLectList('');
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

//    $("#mr_contents").load("<%= lectList %>&dummy=" + getTimestamp(), function() {
//      window.scrollTo(0,0);
//    });

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
          width: 350
        }).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();

        $("#dialogUploading").dialog({
          autoOpen: false,
          modal: true,
          width: 200
        }).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();

      	$("#dialogLectureRegisterResult").dialog({
          autoOpen: false,
          modal: true,
          width: 480,
          height: 'auto'
        }).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();

        $(window).resize(function (){
          // width값을 가져오기
          var width_size = window.outerWidth;
          if (width_size <= 480) {
            $("#dialogLectureRegisterResult").dialog({width: '90%'}).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();
          }else{
            $("#dialogLectureRegisterResult").dialog({width: 480}).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();
          }
        })
        var width_size = window.outerWidth;
        if (width_size <= 480) {
          $("#dialogLectureRegisterResult").dialog({
            autoOpen: false,
            modal: true,
            width: '90%',
            height: 'auto'
          }).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();
        }

        $( "#progressbar" ).progressbar({value: false});

  <% if(EgovUserDetailsHelper.isRole("ROLE_ADMIN") ) { %>
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

  function openDialogLectureRegister(lectno) {
    $("#dialogLectureRegister").find("input[name='lectno']").val(lectno);

  <% if(EgovUserDetailsHelper.isRole("ROLE_ADMIN") ) { %>
  
  <% } else if(EgovUserDetailsHelper.isRole("ROLE_USER")) { %>
	var tel = "<%= (EgovUserDetailsHelper.getLoginVO().getHtel() == null ) ? "" : EgovUserDetailsHelper.getLoginVO().getHtel() %>".split("-");
	$("#dialogLectureRegister").find("input[name='usertel1']").val(tel[0]);
	$("#dialogLectureRegister").find("input[name='usertel2']").val(tel[1]);
	$("#dialogLectureRegister").find("input[name='usertel3']").val(tel[2]);
  <% } %>


    $("#dialogLectureRegister").dialog("open");
  }

  function loadLectWrite() {
    $("#mr_contents").load("<%= lectWrite %>&dummy=" + getTimestamp(), function() {
      window.scrollTo(0,0);
    });
  }

  function loadLectBanList() {
    $("#mr_contents").load("<%= banList %>&dummy=" + getTimestamp(), function() {
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

  function jumpPage(currPage) {
    document.formPage.currPage.value = currPage;
//    loadLectList( $("form[name='formPage']").serialize());
    location.hash = "page/" + $("form[name='formPage']").serialize();
  }

  function lectSearch(frm) {
    document.formPage.currPage.value = 1;
    document.formPage.course.value = frm.course.value;
    document.formPage.where.value = frm.where.value;
    document.formPage.keyword.value = frm.keyword.value;

    location.hash = "page/" + $("form[name='formPage']").serialize();
    return false;
  }

  function checkRegisterTel(frm) {
  	if( frm.usertel1.value == '' || frm.usertel2.value == '' || frm.usertel3.value == '') {
	    alert('강좌 안내를 위해 연락처는 필수 입력하셔야 합니다.');
      return false;
    } else {
    	return true;
    }
  }

</script>                                                                                                                                                                                                                                                                                                                                                                                                   