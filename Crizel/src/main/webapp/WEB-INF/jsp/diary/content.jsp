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
<jsp:include page="/WEB-INF/jsp/header.jsp" />
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
	<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<%
String day = request.getParameter("day")==null?"":request.getParameter("day");
String year = "";
String month = "";
if(!"".equals(day)){
	year = day.split("-")[0];
	month = day.split("-")[1];
}
%>
<div class="content">
<form id="postForm" method="post">
<input type="hidden" name="day" id="day" value="${day}">
<input type="hidden" name="diary_id" id="diary_id" value="${content.diary_id}">
	<table class="tbl_type01">
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
		<tr>
			<td colspan="2">
				<a class="btn01" href="/diary.do?year=<%=year%>&month=<%=month%>">목록</a>
				<c:if test="${content eq null}">
					<span class="btn01" id="insertPage">일기쓰기</span>
				</c:if>
				<c:if test="${content ne null}">
					<span class="btn01" id="diary_update">수정</span>
					<span class="btn01" id="diary_delete">삭제</span>
				</c:if>	
			</td>
		</tr>
	</table>
</form>
</div>
</body>
</html>