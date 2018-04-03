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
function getPage(addr){
	location.href = "/torrent.do?addr=" + encodeURIComponent(addr); 
}
function allNewTap(){
	$("input:checkbox[name='select']:checked").each(function(){
	    window.open($(this).val(), "_blank");
	});
}

function allCheck(){
	if($("#allCheck").is(":checked")){
		$("input:checkbox[name=select]").attr("checked", "checked");
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
		<col width="5%">
		<col width="95%">
	</colgroup>
		<tr>
			<th><input type="checkbox" id="allCheck" onclick="allCheck()"></th>
			<th>주소</th>
		</tr>
	<c:forEach items="${list}" var="ob">
		<tr>
			<td>
				<input type="checkbox" name="select" value="${ob.magnet}">
			</td>
			<td>
				<a href="${ob.magnet}" target="_blank">${ob.text} ${ob.time}</a>  
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