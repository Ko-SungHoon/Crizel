<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

String listPage = "DOM_000001201007002000";		//시설별 예약현황 목록 
//String listPage = "DOM_000000106007002000";		//테스트서버

String delSel[] = request.getParameterValues("delSel");
int result = 0;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	int n = 0;
	
	for(int i=0; i<delSel.length; i++){
		//예약정보 삭제
		sql = new StringBuffer();
		sql.append("DELETE FROM RESERVE_USER WHERE USER_ID = ? ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, delSel[i]);		
		result = pstmt.executeUpdate();	
		
		if(result > 0){
			sql = new StringBuffer();
			sql.append("DELETE FROM RESERVE_USE WHERE USER_ID = ? ");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, delSel[i]);		
			pstmt.executeUpdate();	
		}
		
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
		out.println("location.replace('/index.gne?menuCd=" + listPage + "');");
		out.println("</script>");
	}
	
}
%>