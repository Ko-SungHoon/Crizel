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
<%@include file="/WEB-INF/jsp/header.jsp" %>
<style type="text/css">
</style>
<script src="/js/main.js"></script>
<script>
$(function(){
	var app = new Vue({
		  el: '#app',
		  data: {
		    message: 'a',
		    message2: 'b',
		    message3: 'c'
		  }
		});
});

</script>
<title>Crizel</title>
</head>
<body>
<%@include file="/WEB-INF/jsp/menu.jsp" %>
<div class="content">
<div id="app" v-if="message == 'a' && (message2 == 'q' || message3 == 'w')">
  {{ message }} , {{message2}}
</div>
tt
</div>
</body>
</html>