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
		${nameList[0].name} 
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
	$.ajax({
		type : "POST",
		url : "/girlsDownload.do",
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		data : {
			url : url,
			name : name
		},
		success : function(data) {
			alert("다운로드 완료");
		},
		error:function(request,status,error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">
	<ul class="ul_type02">
		<c:forEach items="${nameList}" var="ob">
			<li>
				<a href="/girls.do?name=${ob.name}">${ob.name}</a>
			</li>
		</c:forEach>
	</ul>
	<ul class="ul_type03">
	<c:forEach items="${girlsList}" var="ob">
		<li>
			<img src="${ob}" onclick="girlsDownload('${ob}', '${name}', '${nameList[0].name}')">
		<li>
	</c:forEach>
	</ul>
</div>
</body>
</html>