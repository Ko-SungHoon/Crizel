<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

String charge_id = parseNull(request.getParameter("charge_id"));

int num = 0;
int key = 0;
int result = 0;
String resultVal = "N";


try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	//rfc내 아이디의 이름찾기
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT * FROM RFC_COMTNMANAGER WHERE EMPLYR_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, charge_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		resultVal = rs.getString("EMPLYR_NM");
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
<%=resultVal%>

