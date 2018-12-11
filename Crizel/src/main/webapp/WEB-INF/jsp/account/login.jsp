<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/include/header.jsp" />
<title>Crizel</title>
<script>
</script>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/include/menu.jsp" />

<div class="content">
	<div class="board">
		<form action="/login.do" method="post">
			<input type="hidden" id="referer" name="referer" value="<%=request.getHeader("referer")%>">
			<table class="tbl_type01">
				<tr>
					<td>아이디</td>
					<td><input type="text" name="id" id="id" autoComplete="off" required></td>
				</tr>
				<tr>
					<td>패스워드</td>
					<td><input type="password" name="pw" id="pw" autocomplete="new-password" required></td>
				</tr>
			</table>
			<div class="btnArea">
				<button class="btn_gray">로그인</button>
			</div>
		</form>
	</div>
</div>
</body>
</html>