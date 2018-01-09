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
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<title>Crizel</title>
</head>
<body>
<%@include file="util.jsp" %>

<%
	List<Map<String, Object>> dataList = null;

	try {
		sql = new StringBuffer();
		sql.append("SELECT * FROM INSTA");
		pstmt = conn.prepareStatement(sql.toString());
		rs = pstmt.executeQuery();
		dataList = getResultMapRows(rs);

	} catch (Exception e) {
		out.println(e.getMessage());
	} finally {
		if(conn!=null)conn.close();
		if(rs!=null)rs.close();
		if(pstmt!=null)pstmt.close();
	}
%>

<script>
function postFormSubmit(){
	$("#postForm").submit();
}
</script>
<a href="test3.jsp">목록</a>
<form action="test2.jsp" method="post" id="postForm">
날짜 : <input type="text" name="date_start" value="2017-09-05"> ~ <input type="text" name="date_end" value="2017-10-15"><br>
평일 : <input type="text" name="reserve_time" id="time_start" value="0700"> ~ <input type="text" name="reserve_time" id="time_end" value="0900">, 
	<input type="text" name="reserve_time" id="time_start2"> ~ <input type="text" name="reserve_time" id="time_end2"><br>
토요일 : <input type="text" name="reserve_time" id="time_start3"> ~ <input type="text" name="reserve_time" id="time_end3">
	<input type="text" name="reserve_time" id="time_start4"> ~ <input type="text" name="reserve_time" id="time_end4"><br>
일요일 : <input type="text" name="reserve_time" id="time_start5" value="0700"> ~ <input type="text" name="reserve_time" id="time_end5" value="0900">
	<input type="text" name="reserve_time" id="time_start6"> ~ <input type="text" name="reserve_time" id="time_end6"><br>
시설 수 : <input type="text" name="reserve_group" id="reserve_group" value="3"> <br>


<input type="button" value="TEST" onclick="postFormSubmit()">
</form>
</body>
</html>