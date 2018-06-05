<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@include file="/WEB-INF/jsp/header.jsp" %>
<title>Insert title here</title>
<script>
$(function(){
	abc("1");
});

function abc(number){
	$.ajax({
		type 			:	"post"
		, url			:	"NewFile6.jsp"
		, contentType	:	"application/x-www-form-urlencoded; charset=utf-8"
		, data			:	{	
			number : number
		}
		, datatype		:	"html"
		, success		: function(data){
			$("#test").html(data.trim());
		}
		
	});
}
</script>
</head>
<body>
<div id="test">

</div>
<input type="text">
<a href="javascript:abc('2')">2번</a>
</body>
</html>