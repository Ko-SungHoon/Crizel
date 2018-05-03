<%@page import="egovframework.rfc3.user.web.SessionManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 학교찾기</title>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
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

//Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

String sid = request.getParameter("sid")==null?"":request.getParameter("sid");
String title = "";
String addr = "";
String url = "";
String tel = "";
String fax = "";
String area_type = "";
String coedu = "";
String cate1 = "";
String cate2 = "";
String post = "";

if("".equals(sid)){
%>
<script>
history.go(-1);
</script>
<%
}

List<Map<String, Object>> dataList = null;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	sql = new StringBuffer();
	sql.append("SELECT * FROM SCHOOL_SEARCH WHERE SID = ? \n");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, sid);
	rs = pstmt.executeQuery();
	while(rs.next()){
		title = parseNull(rs.getString("TITLE"));
		addr = parseNull(rs.getString("ADDR"));
		url = parseNull(rs.getString("URL"));
		tel = parseNull(rs.getString("TEL"));
		fax = parseNull(rs.getString("FAX"));
		area_type = parseNull(rs.getString("area_type"));
		coedu = parseNull(rs.getString("COEDU"));
		cate1 = parseNull(rs.getString("CATE1"));
		cate2 = parseNull(rs.getString("CATE2"));
		post = parseNull(rs.getString("POST"));
	}
} catch (Exception e) {
	e.printStackTrace();
	sqlMapClient.endTransaction();
	alertBack(out, "처리중 오류가 발생하였습니다.");
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
}
%>
<%!
public String phoneConvert(String phoneNumber){
	String regEx = "(\\d{3})(\\d{3,4})(\\d{4})";
	return phoneNumber.replaceAll(regEx, "$1-$2-$3");
}
%>
<script>
function oneDel(sid){
if (confirm("삭제 하시겠습니까?")){
	location.href="del.jsp?sid="+sid;
}else{
	return false;
}
}
</script>
<style>
	.bbs_list2 thead th {font-size:14px;}
</style>
</head>
<body>
	<div id="right_view">
		<div class="top_view">
	      <p class="location">학교찾기 &gt; <strong>학교 상세보기</strong></p>
	  </div>
		<div id="content">
			<table class="bbs_list2">
				<caption>학교찾기의 학교 상세 정보표입니다.</caption>
				<colgroup>
					<col style="width:20%" />
					<col style="width:30%" />
					<col style="width:20%" />
					<col style="width:30%" />
				</colgroup>
			<thead>
				<tr>
					<th colspan="4" scope="col"><%=title%></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th scope="row">학교급</th>
					<td><%=cate1 %></td>
					<th scope="row">지역구분</th>
					<td><%=area_type %></td>
					
				</tr>
				<tr>
					<th scope="row">주소</th>
					<td><%if(!"".equals(post)){%> (<%=post%>) <%}%> <%=addr %></td>
					<th scope="row">홈페이지</th>
					<td><a href="<%=url%>" target="_blank"><%=url%></a></td>
				</tr>
				<tr>
					<th scope="row">전화번호</th>
					<td><%=phoneConvert(tel)%></td>
					<th scope="row">팩스번호</th>
					<td><%=phoneConvert(fax) %></td>
				</tr>
				<tr>
					<th scope="row">설립구분</th>
					<td><%=cate2 %></td>
					<th scope="row">남녀공학</th>
					<td><%=coedu %></td>
				</tr>
			</tbody>
			</table>
			<div class="btn_area">
				<button type="button" onclick="location.href='list.jsp'" class="btn edge small mako">목록</button>
				<button type="button" onclick="location.href='insert.jsp?command=update&sid=<%=sid%>'" class="btn edge small darkMblue">수정</button>
				<button type="button" onclick="oneDel('<%=sid%>')" class="btn edge small white">삭제</button>
			</div>
		</div>
	</div>
</body>
</html>
