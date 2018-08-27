<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<script>
</script>
<title>insert</title>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp" />

	<div class="content">
			<form id="inserForm" action="/boardInsert.do" enctype="multipart/form-data" method="POST">
				<c:if test="${b_group ne null}">
					<input type="hidden" name="b_group" id="b_group" value="${b_group}">
				</c:if>
				<input type="hidden" name="b_level" id="b_level" value="${b_level}">
				
				<table class="tbl_type02">
					<tr>
						<th>제목</th>
						<td><input type="text" id="title" name="title" required></td>
					</tr>
					<tr>
						<th>작성자</th>
						<td><input type="text" id="user_nick" name="user_nick" value="${login.nick}" required></td>
					</tr>
					<tr>
						<th>내용</th>
						<td><textarea name="content" id="content" style="width: 80%; height: 150px;" required></textarea></td>
					</tr>
					<tr>
						<td colspan="2"><input type="file" id="file" name="file"></td>
					</tr>
					<tr>
						<td colspan="2"><input type="file" id="file" name="file"></td>
					</tr>
					<tr>
						<td colspan="2"><input type="file" id="file" name="file"></td>
					</tr>
				</table>
				<div class="search">
					<input type="submit" id="boardInsertSubmit" value="글쓰기">
				</div>
			</form>
		</div>



</body>
</html>