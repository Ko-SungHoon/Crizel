<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

String user_id = parseNull(request.getParameter("user_id"));
String user_name = parseNull(request.getParameter("user_name"));
String organ_name = parseNull(request.getParameter("organ_name"));
String reserve_man = parseNull(request.getParameter("reserve_man"));
String user_phone = parseNull(request.getParameter("user_phone"));
String use_purpose = parseNull(request.getParameter("use_purpose"));

int result = 0;
int key = 0;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	
	key = 0;
	sql = new StringBuffer();
	sql.append("UPDATE RESERVE_USER SET USER_NAME = ?, ORGAN_NAME = ?, RESERVE_MAN = ?, USER_PHONE = ?, USE_PURPOSE = ? WHERE USER_ID = ?  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, user_name);
	pstmt.setString(++key, organ_name);
	pstmt.setString(++key, reserve_man);
	pstmt.setString(++key, user_phone);
	pstmt.setString(++key, use_purpose);
	pstmt.setString(++key, user_id);		
	result = pstmt.executeUpdate();	
	
	if(result > 0){
		sqlMapClient.commitTransaction();
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
	
	if(result>0){
		out.println("<script type=\"text/javascript\">");
		out.println("alert('정상적으로 처리되었습니다.');");
		out.println("location.replace('/index.gne?menuCd=DOM_000001201003002001&user_id="+user_id+"&command=view');");
		out.println("</script>");
	}
}
%>