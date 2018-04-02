<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>

<%
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

String user_id = parseNull(request.getParameter("user_id"));
String reserve_date[] = request.getParameterValues("reserve_date");
String returnVal = "";
int key = 0;
int result = 0;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	
	sql = new StringBuffer();
	sql.append("INSERT INTO RESERVE_DATE_DEL(USER_ID, RESERVE_DATE, APPROVAL) ");
	sql.append("VALUES(?, ?, 'W') ");
	pstmt = conn.prepareStatement(sql.toString());
	for(String ob : reserve_date){
		key = 0;
		pstmt.setString(++key, user_id);
		pstmt.setString(++key, ob);
		pstmt.addBatch();
	}
	
	int[] count = pstmt.executeBatch();
	result = count.length;
	
	if(result>0){
		sqlMapClient.commitTransaction();
		returnVal = "Y";
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
<%=returnVal%>