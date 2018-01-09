<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script>
	function directory(a) {
		var b = document.getElementById("directory").value;

		location.href = "/down.do?directory=" + b + "\\" + a

	}
</script>
<title>Crizel</title>
</head>
<body>
	<div class="header">
		<jsp:include page="/WEB-INF/jsp/header.jsp" />
	</div>

	<div class="content">
		<div class="directory">
			<input type="hidden" id="directory" value="${directory.directory}">
			<c:forEach items="${directory.directoryList}" var="ob">
				<a href="#" onclick="directory('${ob}')" style="text-align: center;
		color:white;
		text-decoration: none;"><input type="hidden"
					id="directoryList" value="${ob}">${ob}</a>
				<hr color="white">
			</c:forEach>
		</div>
		<div class="file">
			<c:forEach items="${directory.FileList}" var="ob">
				<a
					href="/download.do?directory=${directory.directory}&filename=${ob}&check=down">${ob}</a>
				<hr color="white">
			</c:forEach>
		</div>
	</div>

</body>
</html>