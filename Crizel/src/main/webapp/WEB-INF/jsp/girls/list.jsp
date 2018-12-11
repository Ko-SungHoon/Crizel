<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/include/header.jsp"/>
<title>
<c:choose>
	<c:when test="${name eq ''}">
		사진
	</c:when>
	<c:otherwise>
		${name}
	</c:otherwise>
</c:choose>
</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
function girlsDownload(url, name, name2){
	if(name ==  ""){
		name = name2;
	}
	location.href="/girlsDownload.do?url="+url+"&name="+encodeURIComponent(name);
}
</script>
</head>
<body>
<%@include file="/WEB-INF/jsp/include/menu.jsp" %>
<div class="content">
<script>
function allNewTap(){
	<c:forEach items="${nameList}" var="ob">
		window.open('/girls.do?name=${ob.name}', "_blank");
	</c:forEach>
}
</script>
	<c:if test="${girlsList eq null}">
	<div class="board">
		<table class="tbl_type01 textCenter">
			<tr>
				<td>
					<a href="javascript:allNewTap()">모두 새 탭</a>
				</td>
			</tr>
		<c:forEach items="${nameList}" var="ob">
			<tr>
				<td>
					<a href="/girls.do?name=${ob.name}">${ob.name}</a>
				</td>
			</tr>
		</c:forEach>
		</table>
		</div>
	</c:if>
	
	<c:if test="${girlsList ne null}">
		<ul class="ul_type01">
			<c:forEach items="${girlsInfo}" var="ob">
				<li><a href="${ob.addr}" target="blank">[${ob.type}] ${ob.name}</a></li>
			</c:forEach>
		</ul>
		<ul class="ul_type01">
		<c:forEach items="${girlsList}" var="ob">
			<li>
				<img src="${ob}" onclick="girlsDownload('${ob}', '${name}', '${nameList[0].name}')">
			<li>
		</c:forEach>
		</ul>
	</c:if>
	
</div>
</body>
</html>