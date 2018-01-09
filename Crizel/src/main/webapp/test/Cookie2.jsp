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
Cookie cookie = new Cookie("cookie_key", "value");
//cookie.setMaxAge(60*60*24*365);            			// 쿠키 유지 기간 - 1년
cookie.setMaxAge(5);
cookie.setPath("/");                       			// 모든 경로에서 접근 가능하도록 
response.addCookie(cookie);                			// 쿠키저장
%>

</body>
</html>