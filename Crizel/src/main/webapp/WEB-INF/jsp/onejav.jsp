<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<title>
ONEJAV
</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<style type="text/css">
</style>
<script>
function allNewTap(){
	$("input:checkbox[name='select']:checked").each(function(){
	    window.open($(this).val(), "_blank");
	});
}

function allCheck(){
	if($("#allCheck").is(":checked")){
		$("input:checkbox[name=select]").prop("checked", "true");
	}else{
		$("input:checkbox[name=select]").removeAttr("checked");
	}
}
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">
	<div class="search center">
		<button type="button" onclick="allNewTap()">전체 다운</button>
	</div>
	<table class="tbl_type01">
	<colgroup>
		<col width="20%">
		<col width="80%">
		<col>
	</colgroup>
		<tr>
			<th><input type="checkbox" id="allCheck" onclick="allCheck()"></th>
			<th>사진</th>
		</tr>
	<c:forEach items="${list}" var="ob">
		<tr>
			<td>
				<input type="checkbox" name="select" value="${ob.addr}">
			</td>
			<td>
				<a href="${ob.addr}" target="_blank">
					<img src="${ob.img}"> 
				</a>  
			</td>
		</tr>
	</c:forEach>
	</table>
	<div class="search center">
		<button type="button" onclick="allNewTap()">전체 다운</button>
	</div>
</div>
</body>
</html>