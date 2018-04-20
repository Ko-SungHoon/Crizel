<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="referrer" content="no-referrer" />
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>Insert title here</title>
<script>
function test(){
	document.location="NewFile3.jsp";
}
</script>
</head>
<body>
<button onclick="test()">go</button>
<a href="NewFile3.jsp">TEST</a>
</body>
</html>