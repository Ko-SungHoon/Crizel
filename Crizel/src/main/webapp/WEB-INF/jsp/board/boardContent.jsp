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
$(function(){
	$("#boardDelete").click(function(){
		if($("#idSession").val() != ""){
			location.href="/boardDelete.do?b_id=${list.b_id}";
		}else{
			alert("로그인이 필요한 기능입니다.");
			modal.style.display = "block";
		}
		
	});
	
	$("#boardRep").click(function(){
		if($("#idSession").val() != ""){
			location.href="/boardInsertPage.do?b_level=${list.b_level+1}&b_group=${list.b_group}";
		}else{
			alert("로그인이 필요한 기능입니다.");
			modal.style.display = "block";
		}		
	});
	
	$("#boardUpdate").click(function(){
		if($("#idSession").val() != ""){
			location.href="/boardUpdatePage.do?b_id=${list.b_id}";
		}else{
			alert("로그인이 필요한 기능입니다.");
			modal.style.display = "block";
		}		
	});
	$("#boardList").click(function(){
		location.href="/board.do?pageParam=${page}";
	});
});
</script>
<title>Content</title>
<style type="text/css">
</style> 
</head>
<body>
	<!-- 메뉴 페이지 -->
	<jsp:include page="/WEB-INF/jsp/menu.jsp" />

	<div class="content">
		<input type="hidden" id="idSession" value="${login.id}">
			<table class="tbl_type01">
				<tbody>
					<tr>
						<th style="width:20%">작성자</th>
						<td>${list.user_nick}</td>
					</tr>
					<tr>
						<th style="width:20%">제목</th>
						<td>${list.title}</td>
					</tr>
					<tr>
						<th style="width:20%">내용</th>
						<td>							
							<c:forEach items="${file}" var="ob">
								<c:set var="fileName" value="${fn:split(ob.real_name, '.')}" />		
								<c:if test="${fileName[fn:length(fileName)-1] eq 'jpg'
											or fileName[fn:length(fileName)-1] eq 'png'
											or fileName[fn:length(fileName)-1] eq 'jpeg'
											or fileName[fn:length(fileName)-1] eq 'bmp'
											or fileName[fn:length(fileName)-1] eq 'gif'
										}">	
									<img src="/cc/${ob.directory}${ob.real_name}" style="width: auto; max-width: 100%;">
								</c:if>
							</c:forEach>
							
							${list.content}		
						</td>
					</tr>
					<tr>
						<th style="width:20%">첨부파일</th>
						<td>
							<c:forEach items="${file}" var="ob">
								<a href="/download.do?directory=${ob.directory}&filename=${ob.save_name}&check=board">${ob.save_name}</a><br>
							</c:forEach>
						</td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="2" style="text-align: center;">
							<input type="button" id="boardList" value="목록">
							<c:if test="${list.b_level eq 0}">
								<input type="button" id="boardRep" value="답글">
							</c:if>
							<input type="button" id="boardUpdate" value="수정">
							<input type="button" id="boardDelete" value="삭제">
						</td>
					</tr>
				</tfoot>
				
			</table>
	</div>
</body>
</html>