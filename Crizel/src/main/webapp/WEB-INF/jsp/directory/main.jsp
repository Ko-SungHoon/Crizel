<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<title>DIRECTORY
</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<style type="text/css">

</style>
<script>
function fileDown(directory, filename){
	location.href="/download.do?directory="+encodeURIComponent(directory)+"&filename="+encodeURIComponent(filename)+"&check=content";
}
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">
	<table class="tbl_type01">
		<tr>
			<th>
				디렉토리
			</th>
		</tr>
		<c:forEach items="${directory.folder}" var="ob">
		<tr>
			<td>
				<a href="/directory.do?path=${ob.path}">${ob.name}</a>
			</td>
		</tr>
		</c:forEach>
	</table>
	
	<table class="tbl_type01">
		<tr>
			<th>
				파일
			</th>
		</tr>
		<c:forEach items="${directory.file}" var="ob">
		<tr>
			<td>
				<a href="javascript:fileDown('${path}','${ob}')">${ob}</a>
			</td>
		</tr>
		</c:forEach>
	</table>
</div>
</body>
</html>