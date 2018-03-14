<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>Comic</title>
<script>
function list(addr){
	addr = encodeURIComponent(addr); 
	$("postForm").attr("action", "");
}

function comicView(addr){
	$.ajax({
		type : "POST",
		url : "/comicView.do",
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		data : {addr:addr},
		beforeSend:function(){
	        $('.wrap-loading').css('display', '');
	    },
	    complete:function(){
	        $('.wrap-loading').css('display', 'none');
	    }
	});
}

function comicDown(addr, type){
	$.ajax({
		type : "POST",
		url : "/comicDown.do",
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		data : {addr:addr, type:type},
		beforeSend:function(){
	        $('.wrap-loading').css('display', '');
	    },
	    complete:function(){
	        $('.wrap-loading').css('display', 'none');
	        alert("다운로드 완료");
	    }
	});
}

function goView(addr, title, list){
	
	$.ajax({
		type : "POST",
		url : "/comicViewCheck.do",
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		data : {title:title, addr:list},
		success : function(data) {
			location.reload();
			window.open(addr, '_blank'); 
 		},
 		error : function(request,status,error) {
 			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
 			alert("에러발생");
 		}
	});
}
</script>
<style type="text/css" >
.wrap-loading{ /*화면 전체를 어둡게 합니다.*/
    position: fixed;
    left:0;
    right:0;
    top:0;
    bottom:0;
    background: black; /*not in ie */
    filter: progid:DXImageTransform.Microsoft.Gradient(startColorstr='#20000000', endColorstr='#20000000');    /* ie */
}
.wrap-loading img{ /*로딩 이미지*/
	margin: 60px auto auto auto;
	display: block;
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp" />
	<div class="wrap-loading" style="display: none;">
    	<img src="/img/nowloading.jpg" />
	</div>
	<div class="content">
		<c:if test="${type eq null}">
			<table class="tbl_type01">
			<c:forEach items="${comicList}" var="ob">
				<tr>
					<td>
						<a href="/comic.do?type=B&list=${ob.addr}" >${ob.title}</a>
					</td>
					<td>
						<a href="javascript:comicDown('${ob.addr}', 'A');">[다운]</a>
					</td>
				</tr>
			</c:forEach>
			</table>
		</c:if>
		<div class="search">
			<form action="/comic.do" method="post" id="postForm">
				<input type="hidden" name="type" id="type" value="A">
				<input type="text" name="keyword" id="keyword" value="${keyword}">
				<span onclick="$('#postForm').submit();">검색</span>
				<a href="comicInsertPage.do">추가/삭제</a>
			</form>
		</div>
		
		<c:if test="${type eq 'A' or type eq 'B'}">
			<table class="tbl_type01">
			<colgroup>
			<col width="70%">
			<col width="20%">
			<col width="10%">
			</colgroup>
			<c:forEach items="${comic}" var="ob">
				<tr>
					<c:choose>
						<c:when test="${type eq 'A'}">
						<td>
							<a href="/comic.do?type=B&list=${ob.addr}&title=${ob.title}">${ob.title}</a>
						</td>
						<td>
							<a href="javascript:comicDown('${ob.addr}', 'A');">[다운]</a>
						</td>
						</c:when>
						<c:when test="${type eq 'B'}">
						<td>
							<a href="javascript:goView('${ob.addr}', '${ob.title}', '${list}')">${ob.title}</a>
						</td>
						<td>
							<c:forEach items="${comicViewList}" var="ob2">
								<c:if test="${ob.title eq ob2.title }">
									<span class="red">${ob2.register_date}</span>
								</c:if>
							</c:forEach>
						</td>
						<td>
							<a href="javascript:comicDown('${ob.addr}', 'B');">[다운]</a>
							<%-- <a href="javascript:comicView('${ob.addr}');">${ob.title}</a> --%>
						</td>
						</c:when>
					</c:choose>
				</tr>
			</c:forEach>
			</table>
		</c:if>
		
		<%-- <c:if test="${type eq 'C'}">
			<ul class="girlsList">
			<c:forEach items="${comic}" var="ob">
				<li>
					<img src="${ob.img}">
				<li>
			</c:forEach>
			</ul>
		</c:if> --%>
	</div>
</body>
</html>