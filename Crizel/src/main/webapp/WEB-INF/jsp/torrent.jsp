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
		<col width="10%">
		<col width="70%">
		<col width="20%">
		<col>
	</colgroup>
		<tr>
			<th><input type="checkbox" id="allCheck" onclick="allCheck()"></th>
			<th>사진</th>
			<th>시간</th>
		</tr>
	<c:forEach items="${list}" var="ob">
		<tr>
			<td>
				<input type="checkbox" name="select" value="${ob.magnet}">
			</td>
			<td>
				<a href="${ob.magnet}" target="_blank">
					<img src="${ob.img}">
					<%-- ${ob.text} --%> 
				</a>  
			</td>
			<td>
				${ob.time}
			</td>
		</tr>
	</c:forEach>
	</table>
	<div class="paging">
	<%
	int torrentPage = Integer.parseInt((String)request.getAttribute("page"));
	for(int i=1; i<10; i++){
	%>
		<a href="javascript:getPage('https://manstorrent.com/bbs/board.php?bo_table=javcensored&page=<%=i%>')"
		<%if(i == torrentPage){out.println("style='background:#45bbff; color:white;'");} %>><%=i%></a>
	<%
	}
	%>
	</div>
</div>
</body>
</html>