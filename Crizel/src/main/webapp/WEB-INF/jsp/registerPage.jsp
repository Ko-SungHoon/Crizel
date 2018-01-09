<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>Crizel</title>
<script>
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp" />

	<div class="content">
			<form action="/register.do" method="post" id="registerForm">
				<input type="text" style="display:none">
				<input type="password" style="display:none">
				<table class="tbl_type02">
					<tr>
						<td>아이디</td>
						<td><input type="text" name="re_id" id="re_id" autoComplete="off" required></td>
					</tr>
					<tr>
						<td>패스워드</td>
						<td><input type="password" name="re_pw" id="re_pw" autocomplete="new-password"></td>
					</tr>
					<tr>
						<td>이름</td>
						<td><input type="text" name="name" id="name" autocomplete="off" required></td>
					</tr>
					<tr>
						<td>이메일</td>
						<td><input type="text" name="email" id="email" autocomplete="off"></td>
					</tr>
					<tr>
						<td>연락처</td>
						<td><input type="text" name="phone" id="phone" autocomplete="off"></td>
					</tr>
					<tr>
						<td>닉네임</td>
						<td><input type="text" name="nick" id="nick" autocomplete="off"></td>
					</tr>
					<tr>
						<td colspan="2"><input type="button" id="registerSubmit" value="추가"></td>
					</tr>
				</table>
			</form>
	</div>



</body>
</html>