<%
/**
*   PURPOSE :   권역수정 팝업
*   CREATE  :   20180321_wed    Ko
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

/************************** 접근 허용 체크 - 시작 **************************/
SessionManager sessionManager = new SessionManager(request);
String sessionId = sessionManager.getId();
if(sessionId == null || "".equals(sessionId)) {
	alertParentUrl(out, "관리자 로그인이 필요합니다.", adminLoginUrl);
	if(true) return;
}

String roleId= null;
String[] allowIp = null;
Connection conn = null;
try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	// 접속한 관리자 회원의 권한 롤
	roleId= getRoleId(sqlMapClient, conn, sessionId);
	
	// 관리자 접근 허용된 IP 배열
	allowIp = getAllowIpArrays(sqlMapClient, conn);
} catch (Exception e) {
	sqlMapClient.endTransaction();
	alertBack(out, "트랜잭션 오류가 발생했습니다.");
} finally {
	sqlMapClient.endTransaction();
}

// 권한정보 체크
boolean isAdmin = sessionManager.isRole(roleId);

// 접근허용 IP 체크
String thisIp = request.getRemoteAddr();
boolean isAllowIp = isAllowIp(thisIp, allowIp);

/** Method 및 Referer 정보 **/
String getMethod = parseNull(request.getMethod());
String getReferer = parseNull(request.getHeader("referer"));

if(!isAdmin) {
	alertBack(out, "해당 사용자("+sessionId+")는 접근 권한이 없습니다.");
	if(true) return;
}
if(!isAllowIp) {
	alertBack(out, "해당 IP("+thisIp+")는 접근 권한이 없습니다.");
	if(true) return;
}
/************************** 접근 허용 체크 - 종료 **************************/


String pageTitle = "권역수정";
%>

<!DOCTYPE html>
<html lang="ko">
	<head>
		<title><%=pageTitle%></title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
		<style type="text/css">
			input[type="number"] {border:1px solid #bfbfbf; vertical-align:middle; line-height:18px; padding:5px; box-sizing: border-box;}
		</style>
</head>
<body>
<%

String type					= parseNull(request.getParameter("type"), "alway");
StringBuffer sql 			= null;
List<FoodVO> list 			= null;

try{
	sql = new StringBuffer();
	sql.append("SELECT *					");
	sql.append("FROM FOOD_ZONE				");
	sql.append("WHERE SHOW_FLAG = 'Y'		");
	sql.append("ORDER BY ZONE_NM			");
	list = jdbcTemplate.query(sql.toString(), new FoodList());
}catch(Exception e){
	out.println(e.toString());
}

%>
<script>
function zoneDel(zone_no){
	if(confirm("권역 삭제시 해당 권역의 팀이 모두 삭제되며,\n해당 권역의 조사자는 소속이 사라집니다.\n권역을 삭제하시겠습니까?")){
		location.href="food_zone_act.jsp?mode=zoneDelete&zone_no="+zone_no;
	}else{
		return false;
	}
}

function updateSubmit(){
	if(confirm("권역을 수정하시겠습니까?")){
		$("#updateForm").attr("action", "food_zone_act.jsp");
		$("#updateForm").attr("method", "post");
		$("#mode").val("zoneUpdate");
		return true;
	}else{
		return false;
	}
}
$(function(){
	$('#order1').keyup(function(){this.value = this.value.replace(/[^0-9]/g,'');});
});
</script>
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong><%=pageTitle%></strong></p>
  </div>
</div>
<!-- S : #content -->
<div id="content">
	<div>
		<form id="updateForm" onsubmit="return updateSubmit();">
			<fieldset>
				<input type="hidden" id="mode" name="mode">
				<legend><%=pageTitle%></legend>
				<table class="bbs_list2 td-c">
					<caption><%=pageTitle%> 입력폼입니다.</caption>
					<colgroup>
						<col />
						<col style="width:20%" />
					</colgroup>
					<thead>
					<tr>
						<th scope="row">권역명 수정</th>
						<th scope="row">권역삭제</th>
					</tr>
					</thead>
					<tbody>
					<%
					for(FoodVO ob : list){
					%>
					<tr>
						<td>
							<input type="hidden" name="zone_no_arr" value="<%=ob.zone_no%>">
							<input type="text" name="zone_nm_arr" class="wps_90" value="<%=ob.zone_nm%>" required>
						</td>
						<td>
							<a class="btn edge small red" href="javascript:zoneDel('<%=ob.zone_no%>')">삭제</a>
						</td>
					</tr>
					<%
					}
					%>

					</tbody>
				</table>
				<p class="btn_area txt_c">
					<button type="submit" class="btn medium edge darkMblue">수정</button>
					<button type="button" class="btn medium edge mako" onclick="window.close();">닫기</button>
				</p>
			</fieldset>
		</form>
	</div>
</div>
	<!-- //E : #content -->
</body>
</html>
