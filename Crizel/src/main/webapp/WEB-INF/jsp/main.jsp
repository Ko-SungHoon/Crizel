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
	<div class="mainImage">
		<a href="javascript:goLink();">
			<img src="/img/bg03.jpg">
		</a>
	</div>
	<div class="board">
		<table class="tbl_type01">
			<thead>
				<tr>
					<th><a href="http://www.cgv.co.kr/theaters/?theaterCode=0081" target="_blank">${movieType.boxofficeType}</a></th>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${movieList }" var="ob">
				<tr class="textCenter">
					<td>
						<a href="http://movie.naver.com/movie/search/result.nhn?query=${ob.movieNm}&section=all&ie=utf8" target="_blank">
							${ob.movieNm}
						</a>
					</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
		
		<table class="tbl_type01">
			<colgroup>
				<col style="width:15%;"/>
				<col/>
				<col style="width:15%;"/>
			</colgroup>
			<thead>
				<tr>
					<th>회사명</th>
					<th>업무</th>
					<th>급여</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${saraminList}" var="ob">
				<tr class="textCenter">
					<td><a href="${ob.url}">${ob.name}</a></td>
					<td>${ob.category}</td>
					<td>${ob.salary}</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
	</div>
</div>
</body>
</html>