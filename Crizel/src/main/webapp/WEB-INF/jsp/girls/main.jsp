<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
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
<style type="text/css">
</style>
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
	<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">
<script>
function allNewTap(){
	<c:forEach items="${nameList}" var="ob">
		window.open('/girls.do?name=${ob.name}', "_blank");
	</c:forEach>
}
</script>
	<c:if test="${girlsList eq null}">
		<table class="tbl_type01">
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
	</c:if>
	
	<c:if test="${girlsList ne null}">
		<div style="text-align: center;">	
			<a href="${girlsInfo.addr}" target="_blank">${girlsInfo.name}</a>
		</div>
		<ul class="ul_type03">
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