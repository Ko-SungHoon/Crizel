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
	<div class="player_info">
		<table>
			<tr>
				<th>등번호</th>
				<th>이름</th>
				<th>생일</th>
				<th>국가</th>
			</tr>
			<tr>
				<td>${playerInfo.player_number}</td>
				<td>${playerInfo.player_name} (${playerInfo.player_eng_name})</td>
				<td>${playerInfo.player_birthday}</td>
				<td>${playerInfo.player_country}</td>
			</tr>
		</table>		
		<a href="/football/playerInsertPage.do?player_no=${playerInfo.player_no}">수정</a>
	</div>
</div>
</body>
</html>