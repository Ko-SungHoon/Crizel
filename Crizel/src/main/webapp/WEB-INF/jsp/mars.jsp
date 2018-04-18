<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta name="referrer" content="no-referrer" />
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<title>화성지부</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<style type="text/css">
</style>
<script>
function getView(addr){
	addr = encodeURIComponent(addr);
	location.href="/mars.do?addr="+addr+"&type=view";
}

function getDown(addr){
	location.href="";
}

function clipboardCopy(index){
	$("#addr_"+index).select();
	document.execCommand('copy');
}
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">
	<div class="search center">
		<form id="postForm" action="/mars.do" method="get" onchange="document.getElementById('postForm').submit();">
			<select id="addr" name="addr">
				<option value="https://5siri.com/xe/index.php?mid=korean" 
					<c:if test="${addr eq 'https://5siri.com/xe/index.php?mid=korean' }"> selected </c:if> >게임</option>
				<option value="https://5siri.com/xe/index.php?mid=manko" 
					<c:if test="${addr eq 'https://5siri.com/xe/index.php?mid=manko' }"> selected </c:if> >망가</option>
				<option value="https://5siri.com/xe/index.php?mid=anime" 
					<c:if test="${addr eq 'https://5siri.com/xe/index.php?mid=anime' }"> selected </c:if> >애니메이션</option>
			</select>
		</form>
	</div>
	<c:if test="${list ne null}">
		<table class="tbl_type01">
		<colgroup>
			<col width="85%">
			<col width="15%">
		</colgroup>
		<c:forEach items="${list}" var="ob">
			<tr>
				<td>
					<a href="javascript:getView('${ob.addr}')"><img src="${ob.img}"></a>
				</td>
				<td>
					<a href="${ob.addr}" target="_blank">링크</a>
				</td>
			</tr>
		</c:forEach>
		</table>
	</c:if>
	
	<c:if test="${view ne null}">
		<table class="tbl_type01">
		<colgroup>
			<col width="30%">
			<col width="70%">
		</colgroup>
		<c:forEach items="${view.imgList}" var="ob">
			<tr>
				<td colspan="2">
					<img src="${ob}" style="max-width: 100%;">
				</td>
			</tr>
		</c:forEach>
		<c:forEach items="${view.list}" var="ob" varStatus="status"> 
			<tr>
				<td>
					<a href="${ob.addr}">${ob.text }</a>
				</td>
				<td>
					<input type="text" id="addr_${status.index}" value="${ob.addr}">
					<button type="button" onclick="clipboardCopy('${status.index}')">링크복사</button>
				</td>
			</tr>
		</c:forEach>
		</table>
	</c:if>
	
</div>
</body>
</html>