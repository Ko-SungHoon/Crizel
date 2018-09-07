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
	location.href="/directoryDownload.do?directory="+encodeURIComponent(directory)+"&filename="+encodeURIComponent(filename)+"&check=content";
}
function viewPage(path, name, type){
	var fileValue =  encodeURIComponent(path + "/" + name);
	location.href="/videoViewPage.do?fileValue=" + fileValue + "&type=" + type;
}

function AllViewPage(path){
	var path = encodeURIComponent(path + "/");
	location.href="/videoViewPage.do?path="+path+"&type=image";
}

function selectDown(){
	var url;
	var directory = $("#path").val();
	var filename;
	$("input:checkbox[name='select']:checked").each(function(){
		filename = $(this).val();
		url = "/directoryDownload.do?directory="+encodeURIComponent(directory)+"&filename="+encodeURIComponent(filename)+"&check=content";
	    window.open(url, "_blank");
	});
}

function allCheck(){
	if($("#allCheck").is(":checked")){
		$("input:checkbox[name=select]").prop("checked", "true");
	}else{
		$("input:checkbox[name=select]").removeAttr("checked");
	}
}


</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">
	<div class="search">
		<form action="/directory.do" method="get">
			<select id="path" name="path">
				<option value="C:/">C:/</option>
				<option value="D:/">D:/</option>
				<option value="E:/">E:/</option>
				<option value="F:/">F:/</option>
			</select>
			<button>디렉토리 바로가기</button>
		</form>
	</div>
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
	
	
	<div class="search center">
		<button type="button" onclick="AllViewPage('${path}')">이미지 전체 보기</button>
		<button type="button" onclick="selectDown()">선택 다운로드</button>
	</div>
	
	<table class="tbl_type01">
		<tr>
			<th>
				<input type="checkbox" id="allCheck" onclick="allCheck()">
				<input type="hidden" id="path" value="${path}">
			</th>
			<th>
				파일
			</th>
		</tr>
		<c:forEach items="${directory.file}" var="ob" varStatus="status">
		<tr>
			<td>
				<input type="checkbox" name="select" id="${status.index}" value="${ob}">
			</td>
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