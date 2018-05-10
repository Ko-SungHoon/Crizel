<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@include file="/WEB-INF/jsp/header.jsp" %>
<meta charset="UTF-8">
<title>Insert title here</title>

<script>
$(function(){
	$("#req_mot").keyup(function(){
		var length = $(this).val().length;
		if(length>250){
			alert("작성 가능한 글자 수를 초과하였습니다. 250자까지 입력 가능합니다");
			$(this).val($(this).val().substring(0,250));
			return false;
		}
	});
});
</script>
</head>
<body>
<textarea rows="10" cols="10" id="req_mot"></textarea>
</body>
</html>