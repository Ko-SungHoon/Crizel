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
	String date_start = parseNull(request.getParameter("date_start"));
	String date_end = parseNull(request.getParameter("date_end"));
	String reserve_time[] = request.getParameterValues("reserve_time");
	String ban_comment = parseNull(request.getParameter("ban_comment"));
	String all_time = parseNull(request.getParameter("all_time"));
	
	boolean dupCheck = false;
	
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
		
		if("Y".equals(all_time)){
			reserve_time[0] = "0000";
			reserve_time[1] = "2400";
			reserve_time[2] = "0000";
			reserve_time[3] = "2400";
			reserve_time[4] = "0000";
			reserve_time[5] = "2400";
			reserve_time[6] = "0000";
			reserve_time[7] = "2400";
			reserve_time[8] = "0000";
			reserve_time[9] = "2400";
			reserve_time[10] = "0000";
			reserve_time[11] = "2400";
		}
		
		sql = new StringBuffer();
		sql.append("SELECT * FROM RESERVE_BAN   ");
		sql.append("WHERE ROOM_ID = ?  ");
		sql.append("AND ((DATE_START >= ? AND DATE_START <= ?) OR (DATE_START <= ? AND DATE_END >= ?))  ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, room_id);
		pstmt.setString(2, date_start);
		pstmt.setString(3, date_end);
		pstmt.setString(4, date_start);
		pstmt.setString(5, date_start);
		rs = pstmt.executeQuery();	
		if(rs.next()){
			dupCheck = true;	
		}
		
		if("".equals(reserve_time[0]) && !"".equals(reserve_time[2])){
			reserve_time[0] = reserve_time[2];
			reserve_time[2] = "";
			reserve_time[1] = reserve_time[3];
			reserve_time[3] = "";
		}
		if("".equals(reserve_time[4]) && !"".equals(reserve_time[6])){
			reserve_time[4] = reserve_time[6];
			reserve_time[6] = "";
			reserve_time[5] = reserve_time[7];
			reserve_time[7] = "";
		}
		if("".equals(reserve_time[8]) && !"".equals(reserve_time[10])){
			reserve_time[8] = reserve_time[10];
			reserve_time[10] = "";
			reserve_time[9] = reserve_time[11];
			reserve_time[11] = "";
		}
		
		
		if(!dupCheck){
			//개방불가 테이블 데이터 입력
			sql = new StringBuffer();
			sql.append("INSERT INTO RESERVE_BAN(BAN_ID, SCHOOL_ID, ROOM_ID, DATE_START, DATE_END, TIME_START_A, TIME_END_A, TIME_START_A2, TIME_END_A2  ");
			sql.append(", TIME_START_B, TIME_END_B, TIME_START_B2, TIME_END_B2, TIME_START_C, TIME_END_C, TIME_START_C2, TIME_END_C2  ");
			sql.append(", REGISTER_DATE, ALL_TIME, BAN_COMMENT)  ");
			sql.append("VALUES(BAN_ID_SEQ.NEXTVAL,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, ?, ? ) ");
			pstmt = conn.prepareStatement(sql.toString());
			key = 0;
			pstmt.setString(++key, school_id);
			pstmt.setString(++key, room_id);
			pstmt.setString(++key, date_start);
			pstmt.setString(++key, date_end);
			pstmt.setString(++key, reserve_time[0]);
			pstmt.setString(++key, reserve_time[1]);
			pstmt.setString(++key, reserve_time[2]);
			pstmt.setString(++key, reserve_time[3]);
			pstmt.setString(++key, reserve_time[4]);
			pstmt.setString(++key, reserve_time[5]);
			pstmt.setString(++key, reserve_time[6]);
			pstmt.setString(++key, reserve_time[7]);
			pstmt.setString(++key, reserve_time[8]);
			pstmt.setString(++key, reserve_time[9]);
			pstmt.setString(++key, reserve_time[10]);
			pstmt.setString(++key, reserve_time[11]);
			pstmt.setString(++key, all_time);
			pstmt.setString(++key, ban_comment);
			result = pstmt.executeUpdate();
			if(pstmt!=null)pstmt.close();
		}else{
			out.println("<script>alert('선택한 날짜는 이미 등록되어있습니다.');history.go(-1)</script>");
		}
			
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
			out.println("location.replace('/index.gne?menuCd=DOM_000001201007001003&school_id=" + school_id + "&room_id="+room_id+"&openType=B');");
			//out.println("location.replace('/index.gne?menuCd=DOM_000000106007001005&school_id=" + school_id + "&room_id="+room_id+"');");		//테스트서버
			out.println("</script>");
		}
	}
	
%>


<%!
public String getDateDay(String date, String dateType) throws Exception {
    String day = "" ;
    SimpleDateFormat dateFormat = new SimpleDateFormat(dateType) ;
    Date nDate = dateFormat.parse(date) ;
    Calendar cal = Calendar.getInstance() ;
    cal.setTime(nDate);
    int dayNum = cal.get(Calendar.DAY_OF_WEEK) ;
    switch(dayNum){
        case 1: day = "일"; break ;
        case 2: day = "평일"; break ;
        case 3: day = "평일"; break ;
        case 4: day = "평일"; break ;
        case 5: day = "평일"; break ;
        case 6: day = "평일"; break ;
        case 7: day = "토"; break ;
    }
    return day ;
}
%>