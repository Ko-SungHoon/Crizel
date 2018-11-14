<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<title>Crizel</title>

<style type="text/css">
.bookmark {
	width:20%;
	list-style: none;
	margin: auto;	
}
.bookmark li{line-height: 50px;}
.bookmark li a{display: block;}
.bookmark li a:hover{background: #5496ff;}
</style>
</head>

<body>
	<jsp:include page="/WEB-INF/jsp/include/header.jsp" />
	<div class="content">
		<ul class="nameList3">
			<c:if test="${login.id ne null }">
				<li></li>
			</c:if>
			<li><a href="http://wow.inven.co.kr/">와우인벤</a></li>
			<li><a href="http://lol.inven.co.kr/">롤인벤</a></li>
			<li><a href="/Test.jsp">테스트 페이지</a></li>
			<li><a href="http://www.youtube-audio.com/" target="_blank">유튜브
					mp3 추출</a></li>
			<c:if test="${login.id == 'rhzhzh3' }">
				<li><a href="http://www.anissia.net/anitime/" target="_blank">애니시아</a></li>
				<li><a href="https://torrents.ohys.net/download/" target="_blank">ohys</a></li>
				<li><a href="http://leopard-raws.org/" target="_blank">leopard</a></li>
				<li><a href="https://hentaku.net/poombun.php" target="_blank">검색기</a></li>
				<li><a href="/comic.do">만화</a></li>
			</c:if>
		</ul>
	</div>
</body>
</html>