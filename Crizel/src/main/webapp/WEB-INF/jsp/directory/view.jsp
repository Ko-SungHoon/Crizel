<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/include/header.jsp"/>
<title>VIEW
</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<style type="text/css">
</style>
<script>
function imageView(addr){
	var win = window.open("", "_blank", "menubar=no, toolbar=no, status=no, scrollbars=yes, resizable=yes");
	win.document.open("text/html", "replace");
	win.document.write("<img src='" + addr + "'/ style='width:100%;'>");
}
</script>
</head>
<body>
<%@include file="/WEB-INF/jsp/include/menu.jsp" %>
<div class="content">
	<c:if test="${type eq 'video'}">
		<video class="videoView" controls>
		  <source src="/videoView.do?fileValue=${fileValue}&type=video" type="video/mp4">
		  <source src="/videoView.do?fileValue=${fileValue}&type=video" type="video/ogg">
		  <source src="/videoView.do?fileValue=${fileValue}&type=video" type="video/webm">
		  <source src="/videoView.do?fileValue=${fileValue}&type=video" type="video/avi">
		</video>
	</c:if>
	
	<c:if test="${type eq 'image'}">
		<ul class="ul_type01">
		<c:choose>
			<c:when test="${imgList eq null}">
				<li>
					<a href="javascript:imageView('/videoView.do?fileValue=${fileValue}&type=image');">
						<img src="/videoView.do?fileValue=${fileValue}&type=image" style="width: 90%; margin: auto; display: block;">
					</a>
				</li>
			</c:when>
			
			<c:otherwise>
				<c:forEach items="${imgList}" var="ob">
					<li><img src="/videoView.do?fileValue=${ob}&type=image" style="width: 90%; margin: auto; display: block;"></li>
				</c:forEach>
			</c:otherwise>
		</c:choose>
		</ul>
	</c:if>
	
</div>
</body>
</html>