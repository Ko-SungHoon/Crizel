<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<style type="text/css">
#keyword{width: 30%; margin-right: 15px;}
</style>
<title>Yes24</title>
</head>
<body>
<%@include file="/WEB-INF/jsp/menu.jsp" %>
<table class="tbl_type01">
	<tr>
		<td colspan="3">
			<form action="/yes24.do" method="post" id="postForm">
				<input type="text" name="keyword" id="keyword" value="${keyword}">
				<span onclick="$('#postForm').submit();">검색</span>
			</form>
		</td>
	</tr>
<c:forEach items="${list}" var="ob">
	<tr>
		<td>
			<img src="${ob.img}">
		</td>
		<td>
			<a href="http://www.yes24.com/${ob.addr}">${ob.name}</a> 
		</td>
		<td>
			<span>${ob.price}</span>
		</td>
	</tr>
</c:forEach>
	<tr>
		<td colspan="3">
			<c:forEach items="${page}" var="ob" varStatus="i">
				<c:choose>
					<c:when test="${i.index eq 0}">
						<a href="/yes24.do?keyword=${keyword}&PageNumber=${ob}">[이전]</a>
					</c:when>
					<c:when test="${i.last}">
						<a href="/yes24.do?keyword=${keyword}&PageNumber=${ob}">[다음]</a>
					</c:when>
					<c:otherwise>
						<a href="/yes24.do?keyword=${keyword}&PageNumber=${ob}">${ob}</a>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</td>
	</tr>
</table>

</body>
</html>