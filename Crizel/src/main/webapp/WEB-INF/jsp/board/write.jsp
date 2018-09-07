<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<title>BOARD</title>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">	
	<form action="/boardWriteAction.do" method="post" enctype="multipart/form-data">
		<input type="hidden" id="b_no" name="b_no" value="${boardInfo.b_no}">
		<input type="hidden" id="parent_b_no" name="parent_b_no" value="${boardInfo.parent_b_no}">
		<input type="hidden" id="b_level" name="b_level" value="${boardInfo.b_level}">
		<input type="hidden" id="user_id" name="user_id" value="${boardInfo.user_id}">
		<table class="tbl_type01">
			<colgroup>
				<col width="30%">
				<col>
			</colgroup>
			<tr>
				<th>제목</th>
				<td><input type="text" id="title" name="title" value="${boardInfo.title}" required></td>
			</tr>
			<tr>
				<th>작성자</th>
				<td><input type="text" id="user_nick" name="user_nick" value="${boardInfo.user_nick}" required></td>
			</tr>
			<tr>
				<th>내용</th>
				<td>
					<textarea rows="20" cols="100" id="content" name="content">${boardInfo.content }</textarea>
				</td>
			</tr>			
			<tr>
				<th>첨부파일</th>
				<td>
					<ul>
						<c:forEach items="${fileList }" var="ob">
						<li><a href="javascript:fileDown('${ob.f_no}')">${ob.real_name }</a><a href="javascript:fileDelete('${ob.f_no }')">[삭제]</a></li>	
						</c:forEach>
						<c:forEach begin="1" end="${fileSize }">
						<li><input type="file" name="uploadFile"></li>
						</c:forEach>
					</ul>
				</td>
			</tr>
		</table>
		<div class="search">
			<button>확인</button><button type="button" onclick="history.go(-1)">취소</button>
		</div>
	</form>
</div>
<script>
function fileDown(f_no){
	location.href="/download.do?f_no=" + f_no;
}
function fileDelete(f_no){
	if(confirm("삭제한 파일은 복구할 수 없습니다\n삭제하시겠습니까?")){
		$.ajax({
			type : "POST",
			url : "/fileDelete.do",
			data : { 
				"f_no" : f_no
			},
			dataType : "text",
			async : false,
			success : function(data){
			},
			error:function(request,status,error){
		        $("#errorMsg").html("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		    }
		});
	}
}
</script>
</body>
</html>