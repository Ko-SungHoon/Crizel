<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<%@include file="/WEB-INF/jsp/include/header.jsp" %>
<style type="text/css">
</style>
<title>Crizel</title>
</head>
<body>
<%@include file="/WEB-INF/jsp/include/menu.jsp" %>

<div class="content">
	<div class="bookMark">	
		<a href="javascript:goLink();"><img src="/img/liverpool.jpg"></a>
	</div>
	<table class="tbl_main" id="mainMovie">
		<colgroup>
			<col />
		</colgroup>
		<tr>
			<th colspan="3"><a href="http://www.cgv.co.kr/theaters/?theaterCode=0081" target="_blank">${movieType.boxofficeType}</a></th>
		</tr>
		<c:forEach items="${movieList }" var="ob">
		<tr>
			<td>
				<a href="http://movie.naver.com/movie/search/result.nhn?query=${ob.movieNm}&section=all&ie=utf8" target="_blank">
					${ob.movieNm}
				</a>
			</td>
		</tr>
		</c:forEach>
		<tr>
			<td colspan="2">
				<ul class='ul_type01'>
				<c:forEach items="${saraminList}" var="ob">
					<li>
						<ul>
							<li><a href="${ob.url}">${ob.name}</a></li>
							<li>${ob.category}</li>
							<li>${ob.salary}</li>
						</ul>
					</li>
				</c:forEach>
				</ul>
			</td>
		</tr>
	</table>
</div>
</body>
</html>