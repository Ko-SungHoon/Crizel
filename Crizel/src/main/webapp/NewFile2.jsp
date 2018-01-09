<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="org.jsoup.Jsoup" %>
<%@page import="org.jsoup.nodes.Document" %>
<%@page import="org.jsoup.select.Elements" %>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>PUBG</title>
<style type="text/css">
</style>
<script>
$(function() {
	$("#callTest").click(function() {
		$.ajax({
			type : "POST",
			url : "NewFile3.jsp",
			//contentType : "application/x-www-form-urlencoded; charset=utf-8",
			datatype : "text",
			success : function(data) {
				alert(data.trim());
			},
			error : function(e) {
				alert("에러발생");
			}
		});
	});
});
</script>
</head>
<body>
<span id="callTest">test</span>
</body>
</html>