<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");


Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

String sid = request.getParameter("sid")==null?"":request.getParameter("sid");
String delCheck[] = request.getParameterValues("delCheck");

int result = 0;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	if("".equals(sid)){
		sql = new StringBuffer();
		sql.append("DELETE FROM SCHOOL_SEARCH WHERE SID = ? \n");
		pstmt = conn.prepareStatement(sql.toString());
		for(int i=0; i<delCheck.length; i++){
			pstmt.setString(1, delCheck[i]);
			pstmt.addBatch();
		}
	}else{
		sql = new StringBuffer();
		sql.append("DELETE FROM SCHOOL_SEARCH WHERE SID = ? \n");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, sid);
		pstmt.addBatch();
	}
	
	int[] count = pstmt.executeBatch();
	result = count.length;	
	
	if(result > 0){
		sqlMapClient.commitTransaction();
		out.println("<script type=\"text/javascript\">");
		out.println("alert('정상적으로 처리 되었습니다.');");
		out.println("location.replace('list.jsp');");
		out.println("</script>");
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