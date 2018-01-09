<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.io.IOException,java.io.InputStreamReader,java.io.UnsupportedEncodingException,java.net.URL,java.util.Calendar " %>
<%@page import="org.json.simple.JSONArray,org.json.simple.JSONObject,org.json.simple.JSONValue " %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<style type="text/css">
	.highlight {color:yellow;}
</style>

<%
String a = "테스";
%>
<script>
$(function(){
	$('#test2').highlight('<%=a%>'); // 하이라이트(여러개의 검색어라면 단순하게 여러번 사용
});
</script>
<title>Crizel</title>
</head>
<body>


<div id="test2">
<span>
테스트용 텍스트인데 제대로 될지 모르겠다 여튼 테스트임 ㅅㄱ 종길
</span>

</div>
</body>
</html>