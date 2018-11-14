<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/include/header.jsp" />
<title>Update</title>
<script>
</script>
</head>
<body>
<%@include file="/WEB-INF/jsp/include/menu.jsp" %>
	<div class="content">
		<div class="insert">
			<form action="/aniUpdate.do" method="post">
				<input type="hidden" name="ani_id" value="${list.ani_id}">
				<table>
					<tr>
						<th>날짜</th>
						<td><select name="day" id="day">
							<c:choose>
								<c:when test="${list.day eq '월' }"><option value="월" selected="selected">월</option></c:when>
								<c:otherwise><option value="월">월</option></c:otherwise>
							</c:choose>
							<c:choose>
								<c:when test="${list.day eq '화' }"><option value="화	" selected="selected">화</option></c:when>
								<c:otherwise><option value="화">화</option></c:otherwise>
							</c:choose>
							<c:choose>
								<c:when test="${list.day eq '수' }"><option value="수" selected="selected">수</option></c:when>
								<c:otherwise><option value="수">수</option></c:otherwise>
							</c:choose>
							<c:choose>
								<c:when test="${list.day eq '목' }"><option value="목" selected="selected">목</option></c:when>
								<c:otherwise><option value="목">목</option></c:otherwise>
							</c:choose>
							<c:choose>
								<c:when test="${list.day eq '금' }"><option value="금" selected="selected">금</option></c:when>
								<c:otherwise><option value="금">금</option></c:otherwise>
							</c:choose>
							<c:choose>
								<c:when test="${list.day eq '토' }"><option value="토" selected="selected">토</option></c:when>
								<c:otherwise><option value="토">토</option></c:otherwise>
							</c:choose>
							<c:choose>
								<c:when test="${list.day eq '일' }"><option value="일" selected="selected">일</option></c:when>
								<c:otherwise><option value="일">일</option></c:otherwise>
							</c:choose>
						</select></td>
					</tr>
					<tr>
						<th>시간</th>
						<td><input type="text" name="ani_time" value="${list.ani_time}"></td>
					</tr>
					<tr>
						<th>제목</th>
						<td><input type="text" name="title" value="${list.title}"></td>
					</tr>
					<tr>
						<th>키워드</th>
						<td><input type="text" name="keyword" value="${list.keyword}"></td>
					</tr>
					<tr>
						<th>오토타이틀</th>
						<td><input type="text" name="autoTitle" value="${list.autoTitle}"></td>
					</tr>
					<tr>
						<th>챕터</th>
						<td><input type="text" name="chapter" value="${list.chapter}"></td>
					</tr>
					<tr>
						<td colspan="2"><input type="submit" value="수정"></td>
					</tr>
				</table>
			</form>
		</div>
	</div>


</body>
</html>