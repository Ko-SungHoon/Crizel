<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<title>MUSIC</title>
<style type="text/css">
</style>
<script>
$(function(){
	$(".paging").html('${music.page}');
	var href = $(".paging a").attr("href");
	$(".paging a").attr("href", "#");
	$(".paging a").attr("title", href);
	
	$(".paging a").click(function(){
		var url = "/music.do?url=" + encodeURIComponent($(this).attr("title"));
		$(this).attr("href", url);
	});
});

</script>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">
<ul class="ul_type03">
<c:forEach items="${music.list}" var="ob">
	<li>
		<a href="${ob.href}">
			<img src="${ob.src}" >
		</a>
	</li>
</c:forEach>
</ul>
<div class="paging">

</div>
</div>
</body>
</html>