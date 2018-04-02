<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<title>
TORRENT
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

function getPage(addr){
	location.href = "/torrent.do?addr=" + encodeURIComponent(addr); 
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
	<table class="tbl_type01">
	<c:forEach items="${list}" var="ob">
		<tr>
			<td>
				<a href="${ob.magnet}">${ob.text} ${ob.time}</a>  
			</td>
		</tr>
	</c:forEach>
	</table>
	<div class="paging">
		<a href="javascript:getPage('https://manstorrent.com/bbs/board.php?bo_table=javcensored&page=1')">1</a>
		<a href="javascript:getPage('https://manstorrent.com/bbs/board.php?bo_table=javcensored&page=2')">2</a>
		<a href="javascript:getPage('https://manstorrent.com/bbs/board.php?bo_table=javcensored&page=3')">3</a>
		<a href="javascript:getPage('https://manstorrent.com/bbs/board.php?bo_table=javcensored&page=4')">4</a>
		<a href="javascript:getPage('https://manstorrent.com/bbs/board.php?bo_table=javcensored&page=5')">5</a>
		<a href="javascript:getPage('https://manstorrent.com/bbs/board.php?bo_table=javcensored&page=6')">6</a>
	</div>
</div>
</body>
</html>