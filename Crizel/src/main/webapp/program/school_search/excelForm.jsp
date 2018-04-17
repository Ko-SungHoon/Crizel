<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>RFC관리자 > 학교찾기 > 학교등록</title>
	<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
  <script type='text/javascript' src='/js/jquery.js'></script>

<%
SessionManager sm = new SessionManager(request);

%>

<script type="text/javascript">
//<![CDATA[
$(document).ready(function($) {
    window.fn_doSubmitForm = function(frm) {
    	if (confirm("등록하시겠습니까")){
    		if($("#uploadfile").val() == ""){
    			alert("첨부파일을 선택하여 주십시오.");
        		return false;
        	}else{
        		return true;
        	}
    	}else{
    		return false;
    	}
    };
});


function excel(){
	location.href="excel.jsp";
}
//]]>
</script>
<style>
  .topbox2 .txtdeco_b {margin-bottom:15px; font-size:14px;}
  .inputbox label {display:inline-block; width:80px; padding-top:5px; font-weight:bold;}
  form div {margin-bottom:15px;}
  div.btn_area {margin-top:20px !important;}
</style>
</head>
<body>
<div id="right_view">
  <div id="content">
    <form name="minwonForm" method="post" action="actionWae.jsp" enctype="multipart/form-data" onsubmit="javascript:return fn_doSubmitForm(this);">
      <fieldset>
        <legend>학교찾기 일괄등록하기</legend>
      	<input type="hidden" name="writer" id="writer" value="<%=sm.getName()%>">
          <div class="topbox2">
            <p class="txtdeco_b"><span class="red">&#9888;</span> 아래의 [샘플파일]로 받은 엑셀 파일을 수정하여 업로드하시기 바랍니다.</p>
            <p class="inputbox"><label for="sample">샘플파일 :</label> 
            <input value="샘플파일" id="sample" type="button" onclick="location.href='/program/down.jsp?path=/upload_data/school_search&filename=sample.xls'" class="btn small edge mako">
            </p>
            <p class="inputbox"><label for="sample">백업파일 :</label>
            <input value="엑셀다운로드" id="sample" type="button" onclick="excel()" class="btn small edge mako"> 
            </p>
            
            
          </div>
          <div class="topbox1">
            <p class="inputbox">
              <label for="uploadfile">첨부파일 :</label><input type="file" name="uploadfile" id="uploadfile" style="width:260px" class="txt" />
            </p>
          </div>
          <div class="btn_area txt_c">
            <button type="submit" class="btn medium edge darkMblue">등록</button>
          </div>
        </fieldset>
    </form>
  </div>
</div>
</body>
</html>
