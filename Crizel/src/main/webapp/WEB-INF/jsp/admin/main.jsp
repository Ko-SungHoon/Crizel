<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<title>Admin</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<style type="text/css">
</style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">
	<div class="search center">
		<a href="/menuInsertPage.do?menu_level=1">1차메뉴 추가</a>
		<a href="/menuInsertPage.do?menu_level=2">2차메뉴 추가</a>
		<a href="/menuInsertPage.do?menu_level=3">3차메뉴 추가</a>
	</div>
	<table class="tbl_type01">	
		<colgroup>
			<col width="40%" />
			<col width="40%" />
			<col width="10%" />
			<col width="10%" />
		</colgroup>
		<tr>
			<th>메뉴명</th>
			<th>메뉴코드</th>
			<th>보이기 여부</th>
			<th>메뉴 타입</th>
		</tr>
		<c:choose>
			<c:when test="${menuList ne null}">
				<c:forEach items="${menuList}" var="ob">
					<tr>
						<td>${ob.menu_title}</td>
						<td>${ob.menu_cd}</td>
						<td>${ob.view_yn}</td>
						<td>${ob.menu_type}</td>
					</tr>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<tr>
					<td colspan="4">데이터가 없습니다.</td>
				</tr>
			</c:otherwise>
		</c:choose>
	</table>
</div>
</body>
</html>