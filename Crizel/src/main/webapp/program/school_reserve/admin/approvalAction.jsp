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

String school_id = parseNull(request.getParameter("school_id"));
String school_approval = parseNull(request.getParameter("school_approval"));

int num = 0;
int key = 0;
int result = 0;
String resultVal = "N";


try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	//학교정보(수정시)
	key = 0;
	sql = new StringBuffer();
	sql.append("UPDATE RESERVE_SCHOOL SET SCHOOL_APPROVAL = ? ");
	if("Y".equals(school_approval)){
		sql.append(", SCH_APPROVAL_DATE = SYSDATE ");
	}
	sql.append("WHERE SCHOOL_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_approval);
	pstmt.setString(2, school_id);
	result = pstmt.executeUpdate();
	
	if(result > 0){
		resultVal = "Y";
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

