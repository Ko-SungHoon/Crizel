<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<style type="text/css">
</style>
<title>Crizel</title>
</head>
<body>
<%@include file="util.jsp" %>

<%
	String date_start = parseNull(request.getParameter("date_start"));
	String date_end = parseNull(request.getParameter("date_end"));
	String reserve_time[] = request.getParameterValues("reserve_time");
	String reserve_type = "";
	
	if("".equals(date_start)){
		reserve_type = "A";
	}else{
		reserve_type = "B";
	}
	
	List<Map<String, Object>> dataList = null;
	int key = 0;
	int result = 0;

	try {
		sql = new StringBuffer();
		sql.append("INSERT INTO RESERVE_DATE(DATE_ID, DATE_START, DATE_END, TIME_START_A, TIME_END_A, TIME_START_A2, TIME_END_A2  ");
		sql.append(", TIME_START_B, TIME_END_B, TIME_START_B2, TIME_END_B2, TIME_START_C, TIME_END_C, TIME_START_C2, TIME_END_C2, REGISTER_DATE, RESERVE_TYPE)  ");
		sql.append("VALUES((SELECT NVL(MAX(DATE_ID)+1,1) FROM RESERVE_DATE ), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, ? ) ");
		pstmt = conn.prepareStatement(sql.toString());
		key = 0;
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
		pstmt.setString(++key, reserve_type);
		result = pstmt.executeUpdate();

	} catch (Exception e) {
		out.println(e.getMessage());
	} finally {
		if(conn!=null)conn.close();
		if(rs!=null)rs.close();
		if(pstmt!=null)pstmt.close();
		
		if(result>0){
			out.println("<script>alert('성공'); history.go(-1);</script>");
		}
	}
%>
</body>
</html>