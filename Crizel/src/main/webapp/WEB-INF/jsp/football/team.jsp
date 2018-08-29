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
		<ul>
			<c:choose>
				<c:when test="${teamList ne null}">
					<c:forEach items="${teamList}" var="ob">
						<li>
							${ob.team_name} 
							<a href="/football/player.do?team_no=${ob.team_no}">[선수]</a>
							<a href="/football/teamInsertPage.do?team_no=${ob.team_no}">[수정]</a>
						</li>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<li>등록된 팀이 없습니다.</li>
				</c:otherwise>
			</c:choose>
		</ul>
		<a href="/football/teamInsertPage.do">추가/삭제</a>
	</div>
</div>
</body>
</html>