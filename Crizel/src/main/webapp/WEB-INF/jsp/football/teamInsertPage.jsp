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
	<div class="team_info_write">
		<form action="/football/teamInsertAction.do" method="post" id="postForm">
			<c:if test="${teamInfo ne null}">
				<input type="hidden" id="team_no" name="team_no" value="${teamInfo.team_no}">
			</c:if>
			<table>
				<tr>
					<td>팀 명</td>
					<td><input type="text" id="team_name" name="team_name" value="${teamInfo.team_name}" required></td>
				</tr>
			</table>
			<input type="submit" value="등록">
		</form>
	</div>
</div>
</body>
</html>