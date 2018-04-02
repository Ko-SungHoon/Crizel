<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
List<Map<String, Object>> dataList = null;
boolean useCheck = false;


String room_id = request.getParameter("room_id");
int result = 0;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	int n = 0;
	
	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_ROOM WHERE ROOM_ID = ? AND RESERVE_USE = 'Y' ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, room_id);		
	rs = pstmt.executeQuery();	
	if(rs.next()){
		useCheck = true;
	}
	if(useCheck){
		out.println("<script type=\"text/javascript\">");
		out.println("alert('개방중인 시설이 있어 삭제가 불가능합니다.');");
		out.println("location.replace('/index.gne?menuCd=DOM_000001201007001001');");
		//out.println("location.replace('/index.gne?menuCd=DOM_000000106007001001');");		테스트서버
		out.println("</script>");
	}else{
		sql = new StringBuffer();
		sql.append("DELETE FROM RESERVE_ROOM WHERE ROOM_ID = ? ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, room_id);		
		result = pstmt.executeUpdate();	
		
		sql = new StringBuffer();
		sql.append("DELETE FROM RESERVE_DATE WHERE ROOM_ID = ? ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, room_id);		
		result = pstmt.executeUpdate();	
		
		sql = new StringBuffer();
		sql.append("DELETE FROM RESERVE_BAN WHERE ROOM_ID = ? ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, room_id);		
		result = pstmt.executeUpdate();	
		
		sql = new StringBuffer();
		sql.append("DELETE FROM RESERVE_OPTION WHERE ROOM_ID = ?  ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, room_id);		
		result = pstmt.executeUpdate();	
	}
	
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
	
	out.println("<script type=\"text/javascript\">");
	out.println("alert('정상적으로 처리되었습니다.');");
	out.println("location.replace('/index.gne?menuCd=DOM_000001201007001001');");
	//out.println("location.replace('/index.gne?menuCd=DOM_000000106007001001');");		//테스트서버
	out.println("</script>");
}
%>