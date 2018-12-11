<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/include/header.jsp"/>
<title>BOARD</title>
</head>
<body>
<%@include file="/WEB-INF/jsp/include/menu.jsp" %>
<div class="content">	
	<table class="tbl_type01">
		<colgroup>
			<col width="30%">
			<col>
		</colgroup>
		<tr>
			<th>제목</th>
			<td>${boardInfo.title}</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td>${boardInfo.user_nick}</td>
		</tr>
		<tr>
			<th>내용</th>
			<td>
				<c:if test="${imgList ne null }">
				<ul class="ul_type01">
				<c:forEach items="${imgList}" var="ob">
					<li><img src="/videoView.do?fileValue=${ob.directory}${ob.save_name }&type=image" style="width: 80%;"></li>
				</c:forEach>
				</ul>
				</c:if>
				${boardInfo.content }
			</td>
		</tr>			
		<tr>
			<th>첨부파일</th>
			<td>
				<ul class="ul_type01">
					<c:forEach items="${fileList }" var="ob">
					<li><a href="javascript:fileDown('${ob.f_no}')">${ob.real_name }</a></li>	
					</c:forEach>
				</ul>
			</td>
		</tr>
	</table>
	<div class="btnArea">
		<c:if test="${login.id eq boardInfo.user_id}">
			<button type="button" class="btn_gray" onclick="boardUpdate('${boardInfo.b_no}');">수정</button>
			<button type="button" class="btn_gray" onclick="boardDelete('${boardInfo.b_no}');">삭제</button>
		</c:if>
		<button type="button" class="btn_gray" onclick="location.href='${listUrl}'">목록</button>
	</div>
</div>
<script>
function boardUpdate(b_no){
	location.href='/boardWritePage.do?b_no=' + b_no;	
}
function boardDelete(b_no){
	if(confirm("삭제하시겠습니까?")){
		location.href='/boardDelete.do?b_no=' + b_no
	}
}
function fileDown(f_no){
	location.href="/download.do?f_no=" + f_no;
}
</script>
</body>
</html>