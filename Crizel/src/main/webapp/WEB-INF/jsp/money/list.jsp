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
		<c:set var="daySum" value="0" />
		<div class="moneyRemote">
			<form action="/main.do">
				<input type="hidden" name="id" value="${login.id}">
				<select name="y">
					<option value="2017">2017</option>
					<option value="2016">2016</option>
					<option value="2015">2015</option>
					<option value="2014">2014</option>
				</select>년 <select name="m">
					<c:set var="i" value="1" />
					<c:forEach begin="1" end="12">
						<c:choose>
							<c:when test="${i eq month}">
								<option value="${i}" selected="selected">${i}</option>
							</c:when>
							<c:otherwise>
								<option value="${i}">${i}</option>
							</c:otherwise>
						</c:choose>
						
						<c:set var="i" value="${i+1}" />
					</c:forEach>
				</select>월 <input type="submit" value="이동" class="btn06">
			</form>
	
			<p style="text-align: center;">${year}년${month}월
				${day}일 ${dayofweek}요일</p>
		</div>
		
			<c:if test="${list ne null}">	
			<table class="tbl_type02">
				<c:forEach items="${list}" var="ob" varStatus="status">
				<tr>
					<td>${ob.item}</td>
					<td>${ob.price}원 </td>
					<td><a href="/delete.do?money_id=${ob.money_id}&year=${year}&month=${month-1}&day2=${day}&id=${login.id}">삭제</a>
						<c:set var="daySum" value="${daySum + ob.price}" />
					</td>
				</tr>				
				</c:forEach>
				<tr>
					<td colspan="3">
						<span>합계 : ${daySum} 원</span>
					</td>
				</tr>
			</table>
		</c:if>
		<form action="/insert.do">
			<input type="hidden" name="id" value="${login.id}">
			<input type="hidden" name="day"	value="${year}.${month}.${day}"> 
			<input type="hidden" name="year" value="${year}"> 
			<input type="hidden" name="month" value="${month-1}"> 
			<input type="hidden" name="day2" value="${day}"> 
			<table class="tbl_type02">
				<tr>
					<th style="width: 25%">항목</th>
					<td><input type="text" name="item"></td>
					<td>ex)시외버스</td>
				</tr>
				<tr>
					<th style="width: 25%">가격</th>
					<td><input type="text" name="price"></td>
					<td>ex)5200</td>
				</tr>
				<tr>
					<td colspan="3"><input type="submit" value="추가"></td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>