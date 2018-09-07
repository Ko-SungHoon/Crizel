<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>MHW</title>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp" />
	<div class="content">
		<div class="mhw_menu">
			<ul>
				<li><a href="/mhw/main.do">몬스터</a></li>
				<li><a href="/mhw/equip.do">장비</a></li>
			</ul>
		</div>
		<div class="mhw">
			<a href="/mhw/monsterInsert.do">몬스터 추가</a>
			<ul>
			<c:forEach items="${monster_1}" var="ob">
				<li>
					<a href="/mhw/monsterInfo.do?mhw_no=${ob.mhw_no}">${ob.mhw_name}</a>
				</li>			
			</c:forEach>
			</ul>
			
			<ul>
			<c:forEach items="${monster_2}" var="ob">
				<li>
					<a href="/mhw/monsterInfo.do?mhw_no=${ob.mhw_no}">${ob.mhw_name}</a>
				</li>			
			</c:forEach>
			</ul>
			
			<ul>
			<c:forEach items="${monster_3}" var="ob">
				<li>
					<a href="/mhw/monsterInfo.do?mhw_no=${ob.mhw_no}">${ob.mhw_name}</a>
				</li>			
			</c:forEach>
			</ul>
		</div>
	</div>
</body>
</html>