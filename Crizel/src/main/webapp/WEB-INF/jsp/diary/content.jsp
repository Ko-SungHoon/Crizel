<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<jsp:scriptlet>
    pageContext.setAttribute("cr", "\r");
    pageContext.setAttribute("lf", "\n");
    pageContext.setAttribute("crlf", "\r\n");
</jsp:scriptlet>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/include/header.jsp" />
<title>Diary</title>
<script>
$(function(){
	$("#insertPage").click(function(){
		$("#postForm").attr("action", "/diaryInsertPage.do").submit();
	});
	$("#diary_delete").click(function(){
		if(confirm("삭제하시겠습니까?")){
			$("#postForm").attr("action", "/diaryDelete.do").submit();	
		}
		
	});
	$("#diary_update").click(function(){
		$("#postForm").attr("action", "/diaryInsertPage.do").submit();	
	});
});
</script>

</head>
<body>
<%
String day = request.getParameter("day")==null?"":request.getParameter("day");
String year = "";
String month = "";
if(!"".equals(day)){
	year = day.split("-")[0];
	month = day.split("-")[1];
}
%>
<%@include file="/WEB-INF/jsp/include/menu.jsp" %>
<div class="content">
<form id="postForm" method="post">
<input type="hidden" name="day" id="day" value="${day}">
<input type="hidden" name="diary_id" id="diary_id" value="${content.diary_id}">
	<table class="tbl_type02">
		<colgroup>
			<col style="width:15%;" >
			<col style="width:85%;" >
		</colgroup>
		<tr>
			<th>날짜</th>
			<td>${day}</td>
		</tr>
		<tr>
			<th>내용</th>
			<td class="content">${fn:replace(content.content , crlf, '</br>' )}</td>
		</tr>
	</table>
	<div class="search">
		<button type="button" onclick="location.href='/diary.do?year=<%=year%>&month=<%=month%>'">목록</button>
				<c:if test="${content eq null}">
					<button type="button" id="insertPage">일기쓰기</button>
				</c:if>
				<c:if test="${content ne null}">
					<button type="button" id="diary_update">수정</button>
					<button type="button" id="diary_delete">삭제</button>
				</c:if>	
	</div>
</form>
</div>
</body>
</html>