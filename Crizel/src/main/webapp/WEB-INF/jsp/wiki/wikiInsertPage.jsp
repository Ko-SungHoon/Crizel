<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<script>
$(function(){
	$("#submitBtn").click(function(){
		if($.trim($("#wiki_cate_id").val()) == ""){
			alert("카테고리를 선택하여 주시기 바랍니다.");
		}else if($.trim($("#wiki_title").val()) == ""){
			alert("제목을 입력하여 주시기 바랍니다.");
		}else if($.trim($("#wiki_content").val()) == ""){
			alert("내용을 입력하여 주시기 바랍니다.");
		}else{
			if($("#type").val() == "insert"){
				if(confirm("등록하시겠습니까?")){
					$("#postForm").attr("action", "/wikiInsert.do").submit();
				}else{
					return false;
				}		
			}else{
				if(confirm("수정하시겠습니까?")){
					$("#postForm").attr("action", "/wikiUpdate.do").submit();	
				}else{
					return false;
				}
			}
		}
	});
});
</script>
<title>insert</title>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp" />
	<div class="content">
			<form id="postForm" method="POST">
				<input type="hidden" name="type" id="type" value="${type}">
				<c:if test="${type eq 'update'}">
					<input type="hidden" name="wiki_id" id="wiki_id" value="${wikiContent.wiki_id}">
				</c:if>
				<table class="tbl_type01">
					<tr>
						<th>카테고리</th>
						<td>
							<select name="wiki_cate_id" id="wiki_cate_id">
								<c:forEach items="${wikiCateList}" var="ob">
									<option value="${ob.wiki_cate_id}">${ob.wiki_cate_val}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th>제목</th>
						<td><input type="text" id="wiki_title" name="wiki_title" value="${wikiContent.wiki_title}"></td>
					</tr>
					<tr>
						<th>내용</th>
						<td><textarea name="wiki_content" id="wiki_content" style="width: 80%; height: 150px;">${wikiContent.wiki_content}</textarea></td>
					</tr>
					<tr>
						<td colspan="2">
							<c:choose>
								<c:when test="${type eq 'insert'}">
									<span id="submitBtn">등록</span>
								</c:when>
								<c:otherwise>
									<span id="submitBtn">수정</span>	
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</table>
			</form>
		</div>
</body>
</html>