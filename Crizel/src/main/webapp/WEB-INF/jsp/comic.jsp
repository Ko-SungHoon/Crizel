<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>Comic</title>
<style type="text/css">
#keyword{width: 30%; margin-right: 15px;}
#postForm{text-align:center; margin:auto;}
</style>
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
			<!-- <ul class="nameList2">
				<li><a href="http://marumaru.in/b/manga/60371" target="_blank">장난을 잘 치는 타카기양</a></li>
				<li><a href="http://marumaru.in/b/manga/229679" target="_blank">장난을 잘 치는 (전)타카기양</a></li>
				<li><a href="http://marumaru.in/b/manga/65484" target="_blank">원펀맨</a></li>
				<li><a href="http://marumaru.in/b/manga/139743" target="_blank">갸루와 오타쿠는 서로 이해할 수 없어</a></li>
				<li><a href="http://marumaru.in/b/manga/144366" target="_blank">첫 갸루</a></li>
				<li><a href="http://marumaru.in/b/manga/84591" target="_blank">전생했더니 슬라임이었던 건에 대하여</a></li>
				<li><a href="http://marumaru.in/b/manga/153107" target="_blank">전생했더니 슬라임이었던 건에 대하여 - 외전</a></li>
				<li><a href="http://marumaru.in/b/manga/70566" target="_blank">용사가 죽었다</a></li>
				<li><a href="http://marumaru.in/b/manga/81" target="_blank">시노자키양 그러다간 오타쿠가</a></li>
				<li><a href="http://marumaru.in/b/manga/164545" target="_blank">장래적으로 죽어줘</a></li>
				<li><a href="http://marumaru.in/b/manga/156005" target="_blank">나는 너를 울리고싶어</a></li>
				<li><a href="http://marumaru.in/b/manga/173116" target="_blank">나에게 천사가 내려왔다</a></li>
				<li><a href="http://marumaru.in/b/manga/164536" target="_blank">우리 메이드가 너무 짜증나</a></li>
				<li><a href="http://marumaru.in/b/manga/151772" target="_blank">우리 딸을 위해서라면 나는 어쩌면 마왕을 쓰러뜨릴 수 있을지 모른다</a></li>
			</ul> -->
			
			<ul class="nameList2">
				<li>
					<a href="/comic.do?type=B&list=/b/manga/60371" style="display: inline-block;">장난을 잘 치는 타카기양</a>
					<a href="javascript:comicDown('/b/manga/60371', 'A');" style="display: inline-block;">[다운]</a>
				</li>
				<li>
					<a href="/comic.do?type=B&list=/b/manga/229679" style="display: inline-block;">장난을 잘 치는 (전)타카기양</a>
					<a href="javascript:comicDown('/b/manga/229679', 'A');" style="display: inline-block;">[다운]</a>	
				</li>
				<li>
					<a href="/comic.do?type=B&list=/b/manga/65484" style="display: inline-block;">원펀맨</a>
					<a href="javascript:comicDown('/b/manga/65484', 'A');" style="display: inline-block;">[다운]</a>	
				</li>
				<li>
					<a href="/comic.do?type=B&list=/b/manga/139743" style="display: inline-block;">갸루와 오타쿠는 서로 이해할 수 없어</a>
					<a href="javascript:comicDown('/b/manga/139743', 'A');" style="display: inline-block;">[다운]</a>
				</li>
				<li>
					<a href="/comic.do?type=B&list=/b/manga/84591" style="display: inline-block;">전생했더니 슬라임이었던 건에 대하여</a>
					<a href="javascript:comicDown('/b/manga/84591', 'A');" style="display: inline-block;">[다운]</a>
				</li>
				<li>
					<a href="/comic.do?type=B&list=/b/manga/153107" style="display: inline-block;">전생했더니 슬라임이었던 건에 대하여 - 외전</a>
					<a href="javascript:comicDown('/b/manga/153107', 'A');" style="display: inline-block;">[다운]</a>
				</li>
				<li>
					<a href="/comic.do?type=B&list=/b/manga/164545" style="display: inline-block;">장래적으로 죽어줘</a>
					<a href="javascript:comicDown('/b/manga/164545', 'A');" style="display: inline-block;">[다운]</a>
				</li>
				<li>
					<a href="/comic.do?type=B&list=/b/manga/156005" style="display: inline-block;">나는 너를 울리고싶어</a>
					<a href="javascript:comicDown('/b/manga/156005', 'A');" style="display: inline-block;">[다운]</a>
				</li>
				<li>
					<a href="/comic.do?type=B&list=/b/manga/173116" style="display: inline-block;">나에게 천사가 내려왔다</a>
					<a href="javascript:comicDown('/b/manga/173116', 'A');" style="display: inline-block;">[다운]</a>
				</li>
				<li>
					<a href="/comic.do?type=B&list=/b/manga/164536" style="display: inline-block;">우리 메이드가 너무 짜증나</a>
					<a href="javascript:comicDown('/b/manga/164536', 'A');" style="display: inline-block;">[다운]</a>
				</li>
				<li>
					<a href="/comic.do?type=B&list=/b/manga/151772" style="display: inline-block;">우리 딸을 위해서라면 나는 어쩌면 마왕을 쓰러뜨릴 수 있을지 모른다</a>
					<a href="javascript:comicDown('/b/manga/151772', 'A');" style="display: inline-block;">[다운]</a>
				</li>
			</ul>
		</c:if>
		
		<form action="/comic.do" method="post" id="postForm">
			<input type="hidden" name="type" id="type" value="A">
			<input type="text" name="keyword" id="keyword" value="${keyword}">
			<span onclick="$('#postForm').submit();">검색</span>
			
			<c:if test="${type eq 'A' or type eq 'B'}">
				<ul class="nameList2">
				<c:forEach items="${comic}" var="ob">
					<li>
						<c:choose>
							<c:when test="${type eq 'A'}">
								<a href="/comic.do?type=B&list=${ob.addr}" style="display: inline-block;">${ob.title}</a>
								<a href="javascript:comicDown('${ob.addr}', 'A');" style="display: inline-block;">[다운]</a>
							</c:when>
							<c:when test="${type eq 'B'}">
								<a href="${ob.addr}" style="display: inline-block;">${ob.title}</a>
								<a href="javascript:comicDown('${ob.addr}', 'B');" style="display: inline-block;">[다운]</a>
								<%-- <a href="javascript:comicView('${ob.addr}');">${ob.title}</a> --%>
							</c:when>
						</c:choose>
					</li>
				</c:forEach>
				</ul>
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
		</form>
	</div>
</body>
</html>