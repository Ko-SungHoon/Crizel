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

function goView(addr, title, addrB ){
	$.ajax({
		type : "POST",
		url : "/comicViewCheck.do",
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		data : {"title":title, "addr":addrB},
		success : function(data) {
			//location.reload();
			//window.open(addr, '_blank');
			location.href="/comic.do?type=C&addrC="+addr+"&addrB="+addrB;			
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
		<div class="search">
			<form action="/comic.do" method="post" id="postForm">
				<input type="hidden" name="type" id="type" value="A">
				<input type="text" name="keyword" id="keyword" value="${keyword}">
				<span onclick="$('#postForm').submit();">검색</span>
				<a href="comicInsertPage.do">추가/삭제</a>
			</form>
		</div>
		
		<table class="tbl_type01">
		<colgroup>
		<col width="70%">
		<col width="30%">
		</colgroup>
		<!-- DB에 들어있는 목록 -------------------------------------------------------------------->
		<c:if test="${comicList ne null}">
			<c:forEach items="${comicList}" var="ob">
				<tr>
					<td colspan="2">
						<a href="/comic.do?type=B&addrB=${ob.addr}">${ob.title}</a>
					</td>
				</tr>
			</c:forEach>
		</c:if>
		
		<!-- 검색했을때 출력되는 목록 ----------------------------------------------------------------->
		<c:if test="${list ne null}">
			<c:forEach items="${list}" var="ob">
				<tr>
					<td colspan="2">
						<a href="/comic.do?type=B&addrB=${ob.addr}">${ob.title}</a>
					</td>
				</tr>
			</c:forEach>
		</c:if>
		
		<!-- 이미지 출력 ------------------------------------------------------------------------------->
		<c:if test="${imgList ne null}">
			<tr>
				<td colspan="2">
					<ul class="ul_type03">
					<c:forEach items="${imgList}" var="ob">
						<li>
							<img src="/comicView.do?addr=${ob}">
						<li>
					</c:forEach>
					</ul>
				</td>
			</tr>
		</c:if>
		
		<!-- 상세 목록 --------------------------------------------------------------------------->
		<c:if test="${viewList ne null }">
			<c:forEach items="${viewList}" var="ob">
				<tr>
					<td>
						<a href="javascript:goView('${ob.addr}', '${ob.title}', '${addrB}')">${ob.title}</a>
						<%-- <a href="/comic.do?type=C&addr=${ob.addr}">${ob.title}</a> --%>
					</td>
					<td>
						<c:forEach items="${comicViewList}" var="ob2">
							<c:if test="${ob.title eq ob2.title}">
								${ob2.register_date}
							</c:if>
						</c:forEach>
					</td>
				</tr>
			</c:forEach>
		</c:if>
		</table>
	</div>
</body>
</html>