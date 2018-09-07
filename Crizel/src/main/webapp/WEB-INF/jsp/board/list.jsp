<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page import="com.crizel.common.CrizelVo" %>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<title>BOARD</title>
<script>
function boardWritePage(){
	var id = $("#getId").val();
	if(id=="underfied" || id == ""){
		alert("로그인이 필요합니다.");
		location.href="/loginPage.do";
	}else{
		location.href="/boardWritePage.do";
	}
}
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">	
	<div class="search center">
		<form action="/board.do" method="get">
			<input type="hidden" id="getId" value="${login.id}">
			<input type="hidden" id="pageNo" name="pageNo" value="${pageNo }">
			<select id="search1" name="search1">
				<option value="TITLE" <c:if test="${param.search1 eq 'TITLE'}"> selected </c:if>>제목</option>
				<option value="CONTENT" <c:if test="${param.search1 eq 'CONTENT'}"> selected </c:if>>내용</option>		
				<option value="TITLE+CONTENT" <c:if test="${param.search1 eq 'TITLE+CONTENT'}"> selected </c:if>>제목+내용</option>		
				<option value="USER_NICK" <c:if test="${param.search1 eq 'USER_NICK'}"> selected </c:if>>작성자</option>	
			</select>
			<input type="text" name="keyword" id="keyword" value="${param.keyword}">
			<button>검색</button>
		</form>
	</div>
	<table class="tbl_type01">
		<colgroup>
			<col width="5%">
			<col>
			<col width="10%">
			<col width="10%">
			<col width="5%">
		</colgroup>
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>작성자</th>
			<th>작성일</th>
			<th>조회수</th>
		</tr>
		<c:choose>
			<c:when test="${fn:length(boardList) > 0}">
			<c:forEach items="${boardList}" var="ob">
			<tr>
				<td>${ob.rnum }</td>
				<td><a href="/boardRead.do?b_no=${ob.b_no}">${ob.title }</a></td>
				<td>${ob.user_nick }</td>
				<td>${ob.register_date }</td>
				<td>${ob.view_count }</td>
			</tr>
			</c:forEach>
			</c:when>
			<c:otherwise>
			<tr>
				<td colspan="5">데이터가 없습니다.</td>
			</tr>
			</c:otherwise>
		</c:choose>
	</table>
	<div class="search">
		<button type="button" onclick="boardWritePage();">글쓰기</button>
	</div>
</div>
</body>
</html>