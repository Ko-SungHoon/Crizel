<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<title>DIRECTORY
</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<style type="text/css">
</style>
<script>
function changeDirectory(path){
	location.href="/directory.do?path="+encodeURIComponent(path);
}
function fileDown(directory, filename){
	location.href="/download.do?directory="+encodeURIComponent(directory)+"&filename="+encodeURIComponent(filename)+"&check=content";
}
function viewPage(path, name, type){
	var fileValue =  encodeURIComponent(path + "/" + name);
	location.href="/videoViewPage.do?fileValue=" + fileValue + "&type=" + type;
}
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">
	<table class="tbl_type01">
		<tr>
			<th>
				디렉토리
			</th>
		</tr>
		<c:forEach items="${directory.folder}" var="ob">
		<tr>
			<td>
				<a href="javascript:changeDirectory('${ob.path}')">${ob.name}</a>
			</td>
		</tr>
		</c:forEach>
	</table>
	
	<table class="tbl_type01">
		<tr>
			<th>
				파일
			</th>
		</tr>
		<c:forEach items="${directory.file}" var="ob">
		<tr>
			<td>
				<ul>
					<li>
						<a href="javascript:fileDown('${path}','${ob}')">${ob}</a>
					</li>
					
					<c:set var="ext" value="${fn:split(ob, '.')}" />
					
					<c:if test="${ext[fn:length(ext)-1] eq 'ogg'	or ext[fn:length(ext)-1] eq 'OGG'
						or ext[fn:length(ext)-1] eq 'mp4'			or ext[fn:length(ext)-1] eq 'MP4'
						or ext[fn:length(ext)-1] eq 'mkv'			or ext[fn:length(ext)-1] eq 'MKV'
						or ext[fn:length(ext)-1] eq 'webm'			or ext[fn:length(ext)-1] eq 'WEBM'
					}">	
					<li>
						<img src="/img/video.png" style="width:35px; vertical-align: middle"
						onclick="viewPage('${path}','${ob}', 'video')">
					</li>
					</c:if>
					
					<c:if test="${
									ext[fn:length(ext)-1] eq 'jpg'	or ext[fn:length(ext)-1] eq 'JPG'
								or 	ext[fn:length(ext)-1] eq 'png' 	or ext[fn:length(ext)-1] eq 'PNG'
								or 	ext[fn:length(ext)-1] eq 'jpeg' or ext[fn:length(ext)-1] eq 'JPEG'
								or 	ext[fn:length(ext)-1] eq 'bmp'	or ext[fn:length(ext)-1] eq 'BMP'
								or 	ext[fn:length(ext)-1] eq 'gif'	or ext[fn:length(ext)-1] eq 'GIF'
								}">
					<li>
						<img src="/img/img.jpg" style="width:35px; vertical-align: middle"
						onclick="javascript:viewPage('${path}','${ob}', 'image')">
					</li>
					</c:if>
					
				</ul>
			</td>
		</tr>
		</c:forEach>
	</table>
</div>
</body>
</html>