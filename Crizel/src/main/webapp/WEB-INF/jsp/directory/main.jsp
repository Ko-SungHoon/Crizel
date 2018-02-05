<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<title>DIRECTORY
</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<style type="text/css">

</style>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">
	<ul class="ul_type01">
		<c:forEach items="${directory.folder}" var="ob">
			<li><a href="/directory.do?path=${ob.path}">${ob.name}</a></li>
		</c:forEach>
	</ul>
	<ul class="ul_type01">
		<c:forEach items="${directory.file}" var="ob">
			<li><a href="/download.do?directory=${path}/&filename=${ob}&check=content">${ob}</a></li>
		</c:forEach>
	</ul>
</div>
</body>
</html>