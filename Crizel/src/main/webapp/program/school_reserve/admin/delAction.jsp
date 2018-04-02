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

String school_id 	= parseNull(request.getParameter("school_id"));
String school_type 	= parseNull(request.getParameter("school_type"));

int num = 0;
int key = 0;
int result = 0;


try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	sql = new StringBuffer();
	sql.append("DELETE FROM RESERVE_ROOM WHERE SCHOOL_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	result = pstmt.executeUpdate();
	
	sql = new StringBuffer();
	sql.append("DELETE FROM RESERVE_DATE WHERE SCHOOL_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	result = pstmt.executeUpdate();
	
	sql = new StringBuffer();
	sql.append("DELETE FROM RESERVE_OPTION WHERE ROOM_ID = (SELECT ROOM_ID FROM RESERVE_ROOM WHERE SCHOOL_ID = ?) ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	result = pstmt.executeUpdate();
	
	sql = new StringBuffer();
	sql.append("DELETE FROM RESERVE_USER WHERE SCHOOL_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	result = pstmt.executeUpdate();
	
	sql = new StringBuffer();
	sql.append("DELETE FROM RESERVE_USE WHERE SCHOOL_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	result = pstmt.executeUpdate();
	
	sql = new StringBuffer();
	sql.append("DELETE FROM RESERVE_SCHOOL WHERE SCHOOL_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	result = pstmt.executeUpdate();
	
	if(result > 0){
		sqlMapClient.commitTransaction();
		sqlMapClient.endTransaction();
		out.println("<script type=\"text/javascript\">");
		out.println("alert('정상적으로 처리되었습니다.');");
		if("PUBLIC".equals(school_type)){
			out.println("location.replace('/program/school_reserve/admin/list.jsp');");
		}else{
			out.println("location.replace('/program/school_reserve/admin/list_private.jsp');");
		}
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
