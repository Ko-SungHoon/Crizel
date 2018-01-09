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
		if($.trim($("#wiki_cate_val").val()) == ""){
			alert("카테고리명을 입력하여 주시기 바랍니다.");
			return false;	
		}else{
			if($("#type").val() == "insert"){
				if(confirm("등록하시겠습니까?")){
					$("#postForm").attr("action", "/wikiCateInsert.do").submit();
				}else{
					return false;
				}		
			}else{
				if(confirm("수정하시겠습니까?")){
					$("#postForm").attr("action", "/wikiCateUpdate.do").submit();	
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
				<input type="hidden" name="wiki_cate_id" id="wiki_cate_id" value="${wikiCateContent.wiki_cate_id}">
			</c:if>
			<table class="tbl_type01">
				<tr>
					<th>카테고리명</th>
					<td><input type="text" id="wiki_cate_val" name="wiki_cate_val" value="${wikiCateContent.wiki_cate_val}"></td>
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
			<ul class="nameList">
				<c:forEach items="${wikiCateList}" var="ob">
					<li> 
						<span>${ob.wiki_cate_val}</span>
						<a href="/wikiCateDelete.do?wiki_cate_id=${ob.wiki_cate_id}" class="twitter_del">[삭제]</a>
					</li>
				</c:forEach>
			</ul>
		</form>
	</div>
</body>
</html>