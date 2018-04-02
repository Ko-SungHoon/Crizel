<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.iam.manager.ViewManager" %>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@page import="java.util.Enumeration"%>
<%@page import="java.text.DateFormat"%> 
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@ page import="java.io.File, java.io.IOException, com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>

<%
	request.setCharacterEncoding("UTF-8");

	String school_id = parseNull(request.getParameter("school_id"));
	String room_id = parseNull(request.getParameter("room_id"));
	String date_id = parseNull(request.getParameter("date_id"));
	
	/** DB Process **/
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	StringBuffer sql = null;
	int key = 0;
	int result = 0;
	
	try {
		sqlMapClient.startTransaction();
		conn = sqlMapClient.getCurrentConnection();
		
		//시간 테이블 데이터 삭제
		sql = new StringBuffer();
		sql.append("DELETE FROM RESERVE_DATE WHERE DATE_ID = ?  ");
		pstmt = conn.prepareStatement(sql.toString());
		key = 0;
		pstmt.setString(++key, date_id);
		result = pstmt.executeUpdate();
		
			
	} catch (Exception e) {
		%>
			<%=e.toString()%>
		<%
		
		sqlMapClient.endTransaction();
		/*out.println("<script type=\"text/javascript\">");
		out.println("alert('Exception Error_1 : 처리중 오류가 발생하였습니다.');");
		out.println("history.go(-1);");
		out.println("</script>");
		*/
	} finally {
		if (rs != null) try { rs.close(); } catch (SQLException se) {}
		if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
		if (conn != null) try { conn.close(); } catch (SQLException se) {}
		sqlMapClient.endTransaction();
		if(result > 0){
			out.println("<script type=\"text/javascript\">");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('/index.gne?menuCd=DOM_000001201007001003&school_id=" + school_id + "&room_id="+room_id+"');");
			//out.println("location.replace('/index.gne?menuCd=DOM_000000106007001001&school_id=" + school_id + "&room_id="+room_id+"');");	//테스트서버
			out.println("</script>");
		}
	}
	
%>
