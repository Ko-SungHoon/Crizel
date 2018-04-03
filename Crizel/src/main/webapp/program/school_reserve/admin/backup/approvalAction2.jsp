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

String school_id[] 		= request.getParameterValues("selCheck");
String school_approval 	= parseNull(request.getParameter("school_approval"));
String school_type		= parseNull(request.getParameter("school_type"));

int num = 0;
int key = 0;
int result = 0;

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
	
	for(int i=0; i<school_id.length; i++){
		key = 0;
		pstmt.setString(++key, school_approval);
		pstmt.setString(++key, school_id[i]);
		
		pstmt.addBatch();
	}
	int[] count = pstmt.executeBatch();
	result = count.length;
	
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
	if(result > 0){
		out.println("<script type=\"text/javascript\">");
		out.println("alert('정상적으로 처리되었습니다.');");
		if("PUBLIC".equals(school_type)){
			out.println("location.replace('/program/school_reserve/admin/list.jsp');");
		}else{
			out.println("location.replace('/program/school_reserve/admin/list_private.jsp');");
		}
		
		out.println("</script>");
	}
}

%>