<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 학교등록</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
<script>
</script>
</head>
<body>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

String user_id = parseNull(request.getParameter("user_id"));
String user_phone = parseNull(request.getParameter("user_phone"));

int num = 0;
int key = 0;
int result = 0;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	sql = new StringBuffer();
	sql.append("UPDATE RESERVE_USER SET USER_PHONE = ? WHERE USER_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, user_phone);
	pstmt.setString(2, user_id);
	result = pstmt.executeUpdate(); 
	
	if(result > 0){
		sqlMapClient.commitTransaction();
		sqlMapClient.endTransaction();
		out.println("<script type=\"text/javascript\">");
		out.println("alert('정상적으로 처리되었습니다.');");
		out.println("location.replace('/index.gne?menuCd=DOM_000001201007002002&user_id="+user_id+"');");
		//out.println("location.replace('/index.gne?menuCd=DOM_000000106007002001&user_id="+user_id+"');");		//테스트서버
		out.println("</script>");
	}
	
} catch (Exception e) {
	%>
	<%=e.toString() %>
	<%
	e.printStackTrace();
	sqlMapClient.endTransaction();
	//alertBack(out, "처리중 오류가 발생하였습니다."); 
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
}

%>
</body>
</html>
