<%
/**
*   PURPOSE :   프로그램 등록/수정 popup page
*   CREATE  :   20180130_tue    Ko
*   MODIFY  :   20180223 LJH 클래스, 마크업 수정
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>분류관리</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
		<style type="text/css">
			input[type="number"] {border:1px solid #bfbfbf; vertical-align:middle; line-height:18px; padding:5px; box-sizing: border-box;}
		</style>
</head>
<body>
<%!
private class Art_pro_codeVO{
	private int artcode_no;
	private String code_tbl;
	private String code_col;
	private String code_name;
	private String code_val1;
	private String code_val2;
	private String code_val3;
	private int order1;
	private int order2;
	private int order3;
}

private class Art_pro_codeVOMapper implements RowMapper<Art_pro_codeVO> {
    public Art_pro_codeVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	Art_pro_codeVO vo = new Art_pro_codeVO();
        vo.artcode_no		= rs.getInt("ARTCODE_NO");
        vo.code_tbl 		= rs.getString("CODE_TBL");
        vo.code_col			= rs.getString("CODE_COL");
        vo.code_name 		= rs.getString("CODE_NAME");
        vo.code_val1 		= rs.getString("CODE_VAL1");
        vo.code_val2		= rs.getString("CODE_VAL2");
        vo.code_val3		= rs.getString("CODE_VAL3");
        vo.order1 			= rs.getInt("ORDER1");
        vo.order2 			= rs.getInt("ORDER2");
        vo.order3 			= rs.getInt("ORDER3");
        return vo;
    }
}
%>
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
String type					= parseNull(request.getParameter("type"), "alway");
String code_name			= "";

if("alway".equals(type)){
	code_name = "ART_PRO_ALWAY";
}else if("deep".equals(type)){
	code_name = "ART_PRO_DEEP";
}else if("inst".equals(type)){
	code_name = "ART_INST_MNG";
}

StringBuffer sql 			= null;
List<Art_pro_codeVO> list 	= null;

try{
	sql = new StringBuffer();
	sql.append("SELECT *								");
	sql.append("FROM ART_PRO_CODE						");
	sql.append("WHERE CODE_NAME = ?				 		");
	sql.append("ORDER BY ORDER1, ARTCODE_NO	 			");
	list = jdbcTemplate.query(
				sql.toString(),
				new Object[]{code_name},
				new Art_pro_codeVOMapper()
			);
}catch(Exception e){
	out.println(e.toString());
}

%>
<script>
function insertSubmit(){
	var code_val1 = $("#insertForm #code_val1").val();
	var result = false;
	$.ajax({
		type : "POST",
		url : "programCodeDuplicateCheck.jsp",
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		data : {
			code_val1 : code_val1
		},
		datatype : "html",
		success : function(data) {
			if(data.trim() == "ok"){
				if(confirm("분류를 추가하시겠습니까?")){
					$("#insertForm").submit();
				}else{
					return false;
				}
			}else{
				alert("이미 사용중인 이름입니다.");
				return false;
			}
		},
		error:function(request,status,error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}

function codeDel(artcode_no){
	var type = $("#type").val();
	if(confirm("분류를 삭제하시겠습니까?")){
		location.href="programCodeAction.jsp?mode=delete&artcode_no="+artcode_no+"&type="+type;
	}else{
		return false;
	}
}

function updateSubmit(){
	if(confirm("분류를 수정하시겠습니까?")){
		return true;
	}else{
		return false;
	}
}

function duplicateCheck(){
	return result;
}

$(function(){
	$('#order1').keyup(function(){this.value = this.value.replace(/[^0-9]/g,'');});
});
</script>
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>분류관리</strong></p>
  </div>
</div>
<!-- S : #content -->
<div id="content">
	<div>
		<form action="programCodeAction.jsp?mode=insert" method="post" id="insertForm">
			<fieldset>
			<input type="hidden" id="type" name="type" value="<%=type%>">
				<legend>분류입력</legend>
				<table class="bbs_list2">
					<colgroup>
						<col style="width:20%">
						<col  />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">분류입력</th>
							<td>
								<input type="text" id="code_val1" name="code_val1" value="" required>
								<button type="button" class="btn small edge mako" onclick="insertSubmit()">추가</button>
							</td>
						</tr>
					</tbody>
				</table>
			</fieldset>
		</form>

		<form action="programCodeAction.jsp?mode=update" method="post" id="updateForm" onsubmit="return updateSubmit();">
			<fieldset>
				<input type="hidden" id="type" name="type" value="<%=type%>">
				<legend>분류관리</legend>
				<table class="bbs_list2 td-c">
					<caption>악기관리의 분류추가 입력폼입니다.</caption>
					<colgroup>
						<col style="width:30%" />
						<col />
						<col style="width:20%" />
					</colgroup>
					<thead>
					<tr>
						<th scope="row">순서</th>
						<th scope="row">분류명 수정</th>
						<th scope="row">분류삭제</th>
					</tr>
					</thead>
					<tbody>
					<%
					for(Art_pro_codeVO ob : list){
					%>

					<tr>
						<td>
							<input type="hidden" id="artcode_no" name="artcode_no" value="<%=ob.artcode_no%>">
							<input type="text" id="order1" name="order1" class="w_100 txt_c" value="<%=ob.order1%>" required>
						</td>
						<td>
							<input type="text" id="code_val1" name="code_val1" class="wps_90" value="<%=ob.code_val1%>" required>
						</td>
						<td>
							<a class="btn edge small red" href="javascript:codeDel('<%=ob.artcode_no%>')">삭제</a>
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
