<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<title>FOOTBALL</title>
</head>
<body>
<div class="content">
	<div class="player_info_write">
		<form action="/football/playerInsertAction.do" method="post" id="postForm">
			<c:if test="${playerInfo ne null}">
				<input type="hidden" id="player_no" name="player_no" value="${playerInfo.player_no}">
			</c:if>
			<input type="hidden" id="team_no" name="team_no" value="${team_no}">
			<table>
				<tr>
					<td>선수명</td>
					<td><input type="text" id="player_name" name="player_name" value="${playerInfo.player_name}" required></td>
				</tr>
				<tr>
					<td>선수명(영어)</td>
					<td><input type="text" id="player_eng_name" name="player_eng_name" value="${playerInfo.player_eng_name}" required></td>
				</tr>
				<tr>
					<td>등번호</td>
					<td><input type="text" id="player_number" name="player_number" value="${playerInfo.player_number}" required></td>
				</tr>
				<tr>
					<td>생일</td>
					<td><input type="text" id="player_birthday" name="player_birthday" value="${playerInfo.player_birthday}" ></td>
				</tr>
				<tr>
					<td>국가</td>
					<td><input type="text" id="player_country" name="player_country" value="${playerInfo.player_country}" ></td>
				</tr>
			</table>
			<input type="submit" value="등록">
		</form>
	</div>
</div>
</body>
</html>