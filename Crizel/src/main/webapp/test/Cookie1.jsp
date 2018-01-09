<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP</title>
<script src="http://code.jquery.com/jquery-1.10.2.js"></script>
</head>
<body>
<%
Cookie[] cookies = request.getCookies();
if(cookies!=null){
	for (int i = 0; i < cookies.length; i++) {
		cookies[i].setMaxAge(0);                 //쿠키 유지기간을 0으로함
		cookies[i].setPath("/");                    //쿠키 접근 경로 지정
		response.addCookie(cookies[i]);      //쿠키저장
		}
}

%>
</body>
</html>