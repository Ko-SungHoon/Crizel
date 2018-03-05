<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<title>VIDEO
</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<style type="text/css">
</style>
<script>
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">
	<video class="videoView" controls>
	  <source src="/videoView.do?fileValue=${fileValue}" type="video/mp4">
	  <source src="/videoView.do?fileValue=${fileValue}" type="video/avi">
	  Your browser does not support HTML5 video.
	</video>
</div>
</body>
</html>