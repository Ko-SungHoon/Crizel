<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<script>
	$(function() {
		$("#boardUpdateSubmit").click(
				function() {
					if ($.trim($("#title").val()) == "") {
						alert("제목을 입력하여주십시오");
					} else if ($.trim($("#content").val()) == "") {
						alert("내용을 입력하여주십시오");
					} else {
						$("#updateForm").attr("post", "/boardUpdate.do").submit();
					}
				});
		$(".boardFileDel")
				.click(
						function() {
							var save_name = $(this).attr("id");
							var str = {
								"save_name" : save_name,
							};

							$
									.ajax({
										type : "POST",
										url : "/boardFileDel.do",
										contentType : "application/x-www-form-urlencoded; charset=utf-8",
										data : str,
										datatype : "text",
										success : function(data) {
											location.reload();
										},
										error : function(e) {
											location.reload();
										}
									});

						});

	});
</script>
<title>Update</title>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp" />

	<div class="content">
			<form id="updateForm" action="/boardUpdate.do"
				enctype="multipart/form-data" method="POST">
				<input type="hidden" id="b_id" name="b_id"
					value="${list.b_id}">
				<table class="tbl_type01">
					<tr>
						<th>제목</th>
						<td><input type="text" id="title" name="title" value="${list.title}"></td>
					</tr>
					<tr>
						<th>작성자</th>
						<td><input type="text" id="user_nick" name="user_nick" value="${list.user_nick}"></td>
					</tr>
					<tr>
						<th>내용</th>
						<td><textarea name="content" id="content" style="width: 80%; height: 150px;">${list.content}</textarea></td>
					</tr>
					<tr>
						<th rowspan="3">첨부파일</th>
						<td class="boardFile"><c:choose>
								<c:when test="${fn:length(file)>0 && file.get(0).real_name ne null}">
									${file.get(0).real_name} 
									<a class="boardFileDel" id="${file.get(0).save_name}">[파일삭제]</a>
								</c:when>
								<c:otherwise>
									<input type="file" id="file" name="file">
								</c:otherwise>
							</c:choose></td>

					</tr>
					<tr>
						<td class="boardFile"><c:choose>
								<c:when
									test="${fn:length(file)>1 && file.get(1).real_name ne null}">
									${file.get(1).real_name} 
									<a class="boardFileDel" id="${file.get(1).save_name}">[파일삭제]</a>
								</c:when>
								<c:otherwise>
									<input type="file" id="file" name="file">
								</c:otherwise>
							</c:choose></td>
					</tr>
					<tr>
						<td class="boardFile"><c:choose>
								<c:when
									test="${fn:length(file)>2 && file.get(2).real_name ne null}">
									${file.get(2).real_name} 
									<a class="boardFileDel" id="${file.get(2).save_name}">[파일삭제]</a>
								</c:when>
								<c:otherwise>
									<input type="file" id="file" name="file">
								</c:otherwise>
							</c:choose></td>
					</tr>
					<tr>
						<td colspan="2"><input type="button" id="boardUpdateSubmit"
							value="수정"></td>
					</tr>


				</table>
			</form>
	</div>



</body>
</html>