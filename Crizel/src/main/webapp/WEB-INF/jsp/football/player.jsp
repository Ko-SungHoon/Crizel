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
	<div class="football_team_list">
		<a href="/football/playerInsertPage.do">선수등록</a>
		<ul>
			<c:choose>
				<c:when test="${playerList ne null}">
					<c:forEach items="${playerList}" var="ob">
						<li>
							<a href="/football/playerInfo.do?team_no=${team_no}&player_no=${ob.player_no}">[${ob.player_number}] ${ob.player_name}</a> 
						</li>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<li>등록된 선수가 없습니다.</li>
				</c:otherwise>
			</c:choose>
		</ul>
	</div>
</div>
</body>
</html>