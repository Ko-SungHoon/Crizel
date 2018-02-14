<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<title>Nyaa</title>
<style type="text/css">
</style>
<script>
</script>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">
<div class="search center">
	<form action="/nyaa.do" method="get">
		<select id="type" name="type">
			<option value="1_0" <c:if test="${type eq '1_0'}"> selected </c:if>>VIDEO</option>
			<option value="2_0" <c:if test="${type eq '2_0'}"> selected </c:if>>AUDIO</option>
			<option value="4_0" <c:if test="${type eq '4_0'}"> selected </c:if>>LIVE</option>
			<option value="5_0" <c:if test="${type eq '5_0'}"> selected </c:if>>PICTURE</option>
		</select>
		<input type="text" id="keyword" name="keyword" value="${keyword}">
		<button>검색</button>
	</form>
</div>
<table class="tbl_type01">
<thead>
	<tr>
		<th>제목</th>
		<th>사이즈</th>
	</tr>
</thead>
<tbody>
	<c:forEach items="${nyaaList}" var="ob">
	<tr>
		<td>
			<a href="${ob.link}">${ob.title}</a>
		</td>
		<td>
			${ob.size}
		</td>
	</tr>
	</c:forEach>
</tbody>
</table>
</div>
</body>
</html>