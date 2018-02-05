<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@include file="/WEB-INF/jsp/header.jsp" %>
<title>JSP</title>
<script>
$(function(){
	var id = $("#sendId").val();
	//location.href="http://183.103.204.37:9090?testId="+id;	
});

</script>
</head>
<body>
<form method="post" action="http://183.103.204.37:9090/">
<input type="submit" value="SUBMIT">
<%
request.getSession().setAttribute("testS", "EE");
String test = (String)request.getSession().getAttribute("testS");

String url = URLEncoder.encode("http://183.103.204.37:9090/", "UTF-8");
RequestDispatcher rd = request.getRequestDispatcher(url);
rd.forward(request, response);

%>
<input type="text" id="sendId" value="<%=test%>">
</form>
</body>
</html>