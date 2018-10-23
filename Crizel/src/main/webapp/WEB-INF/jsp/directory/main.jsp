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
		<form action="/directory.do" method="get" id="postForm">
			<select id="path" name="path" onchange="$('#postForm').submit();">
				<option value="C:/" <c:if test="${path2 eq 'C'}">selected</c:if>>C:/</option>
				<option value="D:/" <c:if test="${path2 eq 'D'}">selected</c:if>>D:/</option>
				<option value="E:/" <c:if test="${path2 eq 'E'}">selected</c:if>>E:/</option>
				<option value="F:/" <c:if test="${path2 eq 'F'}">selected</c:if>>F:/</option>
			</select>
			<input type="hidden" id="path" value="${path}">
			<input type="checkbox" id="allCheck" onclick="allCheck()"><label for="allCheck">파일 전체 선택</label> 
			<button type="button" onclick="AllViewPage('${path}')">이미지 전체 보기</button>
			<button type="button" onclick="selectDown()">선택 다운로드</button>
		</form>
	</div>
	<div class="directory" style="width: 100%;">
	
		<c:set var="addPath" value="" />
		<c:forEach items="${pathArray}" var="ob" varStatus="status">
			<c:choose>
				<c:when test="${status.index eq 0 }">
					<c:set var="addPath" value="${ob}" />
				</c:when>
				<c:otherwise>
					<c:set var="addPath" value="${addPath}/${ob}" />
				</c:otherwise>
			</c:choose>
			<a href="javascript:changeDirectory('${addPath}')">${ob}</a> > 
		</c:forEach>
		
		<ul style="list-style: none; width: 80%; margin:auto;">
			<c:forEach items="${directory.folder}" var="ob">
			<li style="display: inline-block; text-align: center;">
				<a href="javascript:changeDirectory('${ob.path}')"  title="${ob.name}" alt="${ob.name}">
					<img src="/img/folder.png" style="width:120px;"><br>
					<span style="display:block; overflow:hidden; text-overflow:ellipsis; white-space: nowrap; width:120px;">${ob.name}</span>
				</a>
			</li>
			</c:forEach>
		</ul>
		
		<ul style="list-style: none; width: 80%; margin:auto;">
			<c:forEach items="${directory.file}" var="ob">
			<li style="display: inline-block; text-align: center;">
				<a href="javascript:fileDown('${path}','${ob.name}')"  title="${ob.name}" alt="${ob.name}">
					<img src="/img/${ob.type}.png" style="width:120px;">
					<br>
					<input type="checkbox" name="select" id="${status.index}" value="${ob.name}">
					<span style="display:block; overflow:hidden; text-overflow:ellipsis; white-space: nowrap; width:120px;">${ob.name}</span>
					<c:if test="${ob.type eq 'video'}">	
						<button type="button" onclick="viewPage('${path}','${ob.name}', 'video');">보기</button>
					</c:if>
					<c:if test="${ob.type eq 'img'}">
						<button type="button" onclick="viewPage('${path}','${ob.name}', 'image');">보기</button>
					</c:if>
				</a>
			</li>
			</c:forEach>	
		</ul>
	</div>
</div>
</body>
</html>