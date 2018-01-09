<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>insert</title>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp" />

	<div class="content">
			<form action="/instaInsert.do" method="post">
				<table class="tbl_type01">
					<tr>
						<th>이름</th>
						<td><input type="text" name="name"></td>
					</tr>
					<tr>
						<th>주소</th>
						<td><input type="text" name="addr"></td>
					</tr>
					<tr>
						<td colspan="2"><input type="submit" value="추가"></td>
					</tr>
				</table>
				<ul class="nameList">
					<c:forEach items="${list}" var="ob">
						<li> <a href="${ob.addr}" target="blank" class="twitter_name">${ob.name}</a>
							<a href="/instaDelete.do?name=${ob.name}" class="twitter_del">[삭제]</a>
						</li>
					</c:forEach>
				</ul>
			</form>
	</div>



</body>
</html>