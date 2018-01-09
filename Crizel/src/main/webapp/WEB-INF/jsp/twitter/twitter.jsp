<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>Twitter</title>
<style type="text/css">
</style>
</head>
<body>
	<!-- 메뉴 페이지 -->
	<jsp:include page="/WEB-INF/jsp/menu.jsp"/>

	<div class="content">
			<ul class="nameList">
				<li>
					<a href="/twitter.do?name=1">전체</a>
				</li>
				<c:forEach items="${list}" var="ob">
					<li>
						<a href="/twitter.do?name=${ob.name}">${ob.name}</a>
					</li>
				</c:forEach>
			</ul>

			<c:forEach items="${twitter}" var="ob">
				<img src="${ob}" class="twitter">
			</c:forEach>
	</div>
</body>
</html>