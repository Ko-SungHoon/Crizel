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
	if($.trim($("#name").val()) == ""){
		alert("이름을 입력하여주시기 바랍니다.");
		return false;
	}else if($.trim($("#addr").val()) == ""){
		alert("주소를 입력하여주시기 바랍니다.");
		return false;
	}else{
		return true;
	}
}
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp" />

	<div class="content">
		<form action="/girlsInsert.do" method="post" onsubmit="return formSubmit();">
			<table class="tbl_type02">
				<tr>
					<th>타입</th>
					<td>
						<select name="type" id="type">
							<option value="twitter">트위터</option>
							<option value="insta">인스타</option>
							<option value="blog">블로그</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>이름</th>
					<td><input type="text" name="name" id="name"></td>
				</tr>
				<tr>
					<th>주소</th>
					<td><input type="text" name="addr" id="addr"></td>
				</tr>
				<tr>
					<th>태그1</th>
					<td><input type="text" name="tag1" id="tag1"></td>
				</tr>
				<tr>
					<th>태그2</th>
					<td><input type="text" name="tag2" id="tag2"></td>
				</tr>
				<tr>
					<td colspan="2"><input type="submit" value="추가"></td>
				</tr>
			</table>
			
			<table class="tbl_type01">
				<colgroup>
					<col width="80%" />
					<col width="20%" />
				</colgroup>
				<c:forEach items="${girlsList}" var="ob">
					<tr>
						<td>
							<a href="${ob.addr}" target="blank" class="twitter_name">[${ob.type}] ${ob.name}</a>
						</td>
						<td>
							<a href="/girlsDelete.do?g_id=${ob.g_id}" class="twitter_del">[삭제]</a>
						</td>
					</tr>
				</c:forEach>
				
			</table>
		</form>
	</div>



</body>
</html>