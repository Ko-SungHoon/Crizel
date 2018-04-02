<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

int key = 0;
int result = 0;

List<Map<String, Object>> dataList = null;
String room_id = parseNull(request.getParameter("room_id"));



try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	
	//이미지 삭제
	sql = new StringBuffer();
	sql.append("UPDATE RESERVE_ROOM SET REAL_IMG = '', SAVE_IMG = '', DIRECTORY = '' WHERE ROOM_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, room_id);
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
 	
}

%>

<%=result%>