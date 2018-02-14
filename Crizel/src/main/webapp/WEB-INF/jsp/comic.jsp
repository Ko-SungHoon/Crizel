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
			<table class="tbl_type01">
				<tr>
					<td>
						<a href="/comic.do?type=B&list=/b/manga/60371" >장난을 잘 치는 타카기양</a>
					</td>
					<td>
						<a href="javascript:comicDown('/b/manga/60371', 'A');">[다운]</a>
					</td>
				</tr>
				<tr>
					<td>
						<a href="/comic.do?type=B&list=/b/manga/229679">장난을 잘 치는 (전)타카기양</a>
					</td>
					<td>
						<a href="javascript:comicDown('/b/manga/229679', 'A');">[다운]</a>
					</td>
				</tr>
				<tr>
					<td>
						<a href="/comic.do?type=B&list=/b/manga/65484">원펀맨</a>
					</td>
					<td>
						<a href="javascript:comicDown('/b/manga/65484', 'A');">[다운]</a>	
					</td>
				</tr>
				<tr>
					<td>
						<a href="/comic.do?type=B&list=/b/manga/139743">갸루와 오타쿠는 서로 이해할 수 없어</a>
					</td>
					<td>
						<a href="javascript:comicDown('/b/manga/139743', 'A');">[다운]</a>
					</td>
				</tr>
				<tr>
					<td>
						<a href="/comic.do?type=B&list=/b/manga/84591">전생했더니 슬라임이었던 건에 대하여</a>
					</td>
					<td>
						<a href="javascript:comicDown('/b/manga/84591', 'A');">[다운]</a>
					</td>
				</tr>
				<tr>
					<td>
						<a href="/comic.do?type=B&list=/b/manga/153107">전생했더니 슬라임이었던 건에 대하여 - 외전</a>
					</td>
					<td>
						<a href="javascript:comicDown('/b/manga/153107', 'A');">[다운]</a>
					</td>
				</tr>
				<tr>
					<td>
						<a href="/comic.do?type=B&list=/b/manga/164545">장래적으로 죽어줘</a>
					</td>
					<td>
						<a href="javascript:comicDown('/b/manga/164545', 'A');">[다운]</a>
					</td>
				</tr>
				<tr>
					<td>
						<a href="/comic.do?type=B&list=/b/manga/156005">나는 너를 울리고싶어</a>
					</td>
					<td>
						<a href="javascript:comicDown('/b/manga/156005', 'A');">[다운]</a>
					</td>
				</tr>
				<tr>
					<td>
						<a href="/comic.do?type=B&list=/b/manga/173116">나에게 천사가 내려왔다</a>
					</td>
					<td>
						<a href="javascript:comicDown('/b/manga/173116', 'A');">[다운]</a>
					</td>
				</tr>
				<tr>
					<td>
						<a href="/comic.do?type=B&list=/b/manga/164536">우리 메이드가 너무 짜증나</a>
					</td>
					<td>
						<a href="javascript:comicDown('/b/manga/164536', 'A');">[다운]</a>
					</td>
				</tr>
				<tr>
					<td>
						<a href="/comic.do?type=B&list=/b/manga/151772">우리 딸을 위해서라면 나는 어쩌면 마왕을 쓰러뜨릴 수 있을지 모른다</a>
					</td>
					<td>
						<a href="javascript:comicDown('/b/manga/151772', 'A');">[다운]</a>
					</td>
				</tr>
				<tr>
					<td>
						<a href="/comic.do?type=B&list=/b/manga/260684">오빠는 끝</a>
					</td>
					<td>
						<a href="javascript:comicDown('/b/manga/260684', 'A');">[다운]</a>
					</td>
				</tr>
			</table>
		</c:if>
		<div class="search">
			<form action="/comic.do" method="post" id="postForm">
				<input type="hidden" name="type" id="type" value="A">
				<input type="text" name="keyword" id="keyword" value="${keyword}">
				<span onclick="$('#postForm').submit();">검색</span>
			</form>
		</div>
		
		<c:if test="${type eq 'A' or type eq 'B'}">
			<table class="tbl_type01">
			<c:forEach items="${comic}" var="ob">
				<tr>
					<c:choose>
						<c:when test="${type eq 'A'}">
						<td>
							<a href="/comic.do?type=B&list=${ob.addr}">${ob.title}</a>
						</td>
						<td>
							<a href="javascript:comicDown('${ob.addr}', 'A');">[다운]</a>
						</td>
						</c:when>
						<c:when test="${type eq 'B'}">
						<td>
							<a href="${ob.addr}">${ob.title}</a>
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