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
	<div class="football_menu">
		<ul>
			<li><a href="/football/team.do">팀</a></li>
			<li><a href="/football/result.do">일정 및 결과</a></li>
		</ul>
	</div>
	<div class="football_last">
	<c:choose>
		<c:when test="${lastGame ne null}">
			<c:choose>
				<c:when test="${lastGame.home_yn eq 'Y'}">
					${lastGame.team_name} ${lastGame.our_score} - ${lastGame.opponent_score} ${lastGame.team_name2} 
				</c:when>
				<c:otherwise>
					${lastGame.team_name2} ${lastGame.opponent_score} - ${lastGame.our_score} ${lastGame.team_name} 
				</c:otherwise>
			</c:choose>
		</c:when>
		<c:otherwise>
			최근 경기가 없습니다.
		</c:otherwise>
	</c:choose>
	</div>
</div>
</body>
</html>