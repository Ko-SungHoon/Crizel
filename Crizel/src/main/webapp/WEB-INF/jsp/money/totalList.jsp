<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>Money</title>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp" />

	<div class="moneyContent">
		<table class="tbl_type02">
			<c:forEach items="${list}" var="ob">
				<tr>
					<td>${ob.item}</td>
					<td>${ob.price}원</td>
				</tr>

			</c:forEach>
		</table>

	</div>
</body>
</html>