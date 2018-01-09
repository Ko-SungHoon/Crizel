<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.io.IOException,java.io.InputStreamReader,java.io.UnsupportedEncodingException,java.net.URL,java.util.Calendar " %>
<%@page import="org.json.simple.JSONArray,org.json.simple.JSONObject,org.json.simple.JSONValue " %>
<%@page import="javax.servlet.ServletContext" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<style type="text/css">
</style>
<script type="text/javascript" src="/js/jquery-3.2.1.min.js"></script>
<script>
$(function(){
	var test = function(a, b){
		alert(a + " ~ " + b);
		$("#inputTest").val(parseInt(a)+parseInt(b));
	} 
		
	$("#jsTest").click(function(){
		test.call('', 3, 5);
		
	});
});
</script>
<title>Crizel</title>
</head>
<body>
<%@include file="/WEB-INF/jsp/header.jsp" %>

<span id="jsTest">테스트</span>
<input type="text" id="inputTest">
</body>
</html>