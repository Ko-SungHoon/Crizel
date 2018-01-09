<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>Diary</title>
<script>
$(function(){
	$("#diary_insert").click(function(){
		if($.trim($("#content").val()) == ""){
			alert("내용을 입력하여주시기 바랍니다.");
			return false;
		}else{
			if(confirm("등록하시겠습니까?")){
				$("#postForm").attr("action", "/diaryInsert.do").submit();
			}else{
				return false;
			}
		}
	});
	
	$("#diary_update").click(function(){
		if($.trim($("#content").val()) == ""){
			alert("내용을 입력하여주시기 바랍니다.");
			return false;
		}else{
			if(confirm("수정하시겠습니까?")){
				$("#postForm").attr("action", "/diaryUpdate.do").submit();
			}else{
				return false;
			}
		}
	});
});

</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">
	<form id="postForm" method="post">
		<input type="hidden" name="diary_date" id="diary_date" value="${day}">
		<c:if test="${content ne null}">
			<input type="hidden" name="diary_id" id="diary_id" value="${content.diary_id}">
		</c:if>
		<table class="tbl_type01">
			<tr>
				<th>날짜</th>
				<td>${day}</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>
					<textarea style="width: 80%; height: 150px;" name="content" id="content">${content.content}</textarea>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<c:if test="${content eq null}">
						<span id="diary_insert">등록</span>
					</c:if>
					<c:if test="${content ne null}">
						<span id="diary_update">수정</span>
					</c:if>
				</td>
			</tr>
		</table>
	</form>
</div>
</body>
</html>