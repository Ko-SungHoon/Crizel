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
<div class="content">
	
	
	
	<c:if test="${moneyView ne null}">
		<table class="tbl_type01">
		<colgroup>
			<col width="40%"/>
			<col width="40%"/>
			<col width="20%"/>
		</colgroup>
			<c:forEach items="${moneyView}" var="ob">
				<tr>
					<td>${ob.item}</td>
					<td>${ob.price}원</td>
					<td><button type="button" onclick="location.href='moneyDelete.do?money_id=${ob.money_id}&day=${day}'">삭제</button></td>
				</tr>
			</c:forEach>
		</table>
	</c:if>
	
	<form id="insertForm" action="/moneyInsert.do" method="post">
		<input type="hidden" id="day" name="day" value="${day}">
		<table class="tbl_type01">
			<colgroup>
				<col width="50%"/>
				<col width="50%"/>
			</colgroup>
			<tr>
				<th>항목</th>
				<td><input type="text" id="item" name="item" required></td>
			</tr>
			<tr>
				<th>가격</th>
				<td><input type="text" id="price" name="price" required></td>
			</tr>
			<tr>
				<td colspan="2"><button>확인</button></td>
			</tr>
		</table>
		<div class="search center">
			<button type="button" onclick="location.href='/money.do'">목록</button>
		</div>
	</form>
	
	
	
</div>
</body>
</html>