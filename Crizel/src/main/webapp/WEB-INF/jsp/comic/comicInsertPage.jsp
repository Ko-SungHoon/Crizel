<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>insert</title>
<style type="text/css">
</style>
<script>
function formSubmit(){
	var value = $("#addr2").val() + $("#addr").val();
	$("#addr2").val(value);
	return true;
}
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp" />

	<div class="content">
		<form action="/comicInsert.do" method="post" onsubmit="return formSubmit();">
			<table class="tbl_type02">
				<tr>
					<th>제목</th>
					<td><input type="text" name="title" id="title" style="width: 70%;"></td>
				</tr>
				<tr>
					<th>주소</th>
					<td><input type="text" name="addr" id="addr" style="width: 70%;"></td>
				</tr>
				<tr style="display: none;">
					<th>주소2</th>
					<td><input type="text" name="addr2" id="addr2" value="http://marumaru.in"></td>
				</tr>
				<tr>
					<td colspan="2"><input type="submit" value="추가"></td>
				</tr>
			</table>
			
			<ul class="ul_type04">
				<c:forEach items="${comicList}" var="ob">
					<li> 
						<a href="${ob.addr2}" target="blank" class="twitter_name">${ob.title}</a>
						<a href="/comicDelete.do?comic_id=${ob.comic_id}" class="twitter_del">[삭제]</a>
					</li>
				</c:forEach>
			</ul>
		</form>
	</div>



</body>
</html>