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
<title>Wiki</title>
<style type="text/css">
.wikiList{width: 15%; display: inline-block; min-height: 800px; float: left;}
.wikiList ul{list-style: none;}
.wikiList a{color:#e3e3e3;}

.wikiContent{width:85%; display: inline-block; min-height: 800px; float: left;}
.wikiContent .wikiBtn{width:80%; text-align: right; display: block; margin: auto; }
.wikiContent .wikiBtn span{display:inline-block; background: #171717; padding: 8px;}
.wikiContent h1{text-align: center;}
</style>
<script>
$(function(){
	$("#wiki_ins").click(function(){
		$("#type").val("insert");
		$("#wiki_id").val(null);
		$("#postForm").attr("action", "/wikiInsertPage.do").submit();
	});
	$("#wiki_upt").click(function(){
		$("#type").val("update");
		$("#postForm").attr("action", "/wikiInsertPage.do").submit();
	});
	$("#wiki_del").click(function(){
		$("#postForm").attr("action", "/wikiDelete.do").submit();
	});
	$("#wiki_cate").click(function(){
		$("#type").val("insert");
		$("#wiki_id").val(null);
		$("#postForm").attr("action", "/wikiCateInsertPage.do").submit();
	});
});
</script>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/menu.jsp" />
<div class="content">
	<div class="wikiList">
		<ul>
			<c:forEach items="${wikiList}" var="ob">
				<li>
					<span>${ob.wiki_cate_val}</span>
					<ul>
						<c:forEach items="${wikiList}" var="ob2">
							<c:if test="${ob.wiki_cate_id eq ob2.wiki_cate_id}">
								<li>
									<a href="/wiki.do?wiki_id=${ob2.wiki_id}">${ob2.wiki_title}</a>	
								</li>
							</c:if>
						</c:forEach>
					</ul>	
				</li>
			</c:forEach>
		</ul>
	</div>
	
	<div class="wikiContent">
		<div class="wikiBtn">
			<span id="wiki_cate">카테고리</span>
			<span id="wiki_ins">등록</span>
			<c:if test="${wikiContent ne null}">
				<span id="wiki_upt">수정</span>
				<span id="wiki_del">삭제</span>
			</c:if>
			
		</div>
		<h1>${wikiContent.wiki_title}</h1>
		${fn:replace(wikiContent.wiki_content , crlf, '</br>' )}
		<form method="post" id="postForm">
			<input type="hidden" name="wiki_id" id="wiki_id" value="${wikiContent.wiki_id}">
			<input type="hidden" name="type" id="type">
			
		</form>
	</div>
	
</div>
</body>
</html>