<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.io.IOException,java.io.InputStreamReader,java.io.UnsupportedEncodingException,java.net.URL,java.util.Calendar " %>
<%@page import="org.json.simple.JSONArray,org.json.simple.JSONObject,org.json.simple.JSONValue " %>
<%@page import="javax.servlet.ServletContext" %>
<%@page import="java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<style type="text/css">
.test{list-style: none;}
.test a{color:white;}
</style>
<title>Crizel</title>
</head>
<body>
<%@include file="/WEB-INF/jsp/header.jsp" %>
<script>
function jsonTest(keyword){
	$(".test").html("");
	$.ajax({
		type : "POST",
		url : "/json.do",
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		data : {
			keyword : keyword
		},
		datatype : "json",
		success : function(data) {
			$.each(data, function(i, val) {
				$(".test").append("<li><a href='" + this.addr + "' target='_blank'>" + val.name + "</a></li>");	//val.name 도 되고 this.name 도 된다
			});
		},
		error:function(request,status,error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}	
</script>

<button onclick="javascript:jsonTest('');">JSON 테스트</button>
<ul class="test">

</ul>

<%
Date dt = new Date();
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
if(session.getAttribute("test") == null){
	session.setAttribute("test", "EE");	
}
dt.setTime(session.getCreationTime());
String cre_time = sdf.format(dt);

dt.setTime(session.getLastAccessedTime());
String acc_time = sdf.format(dt);
%>

<%=session.getAttribute("test") %><br>
<%=session.getMaxInactiveInterval() %> <br>
<%=session.getServletContext() %> <br>
<%=session.getCreationTime() %> -> <%=cre_time%> <br>
<%=session.getLastAccessedTime() %> -> <%=acc_time%><br>
</body>
</html>