<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>NICO</title>
<style type="text/css">
</style>
<script>
function viewDetail(addr){
	$("#url").val(addr);
	$("#type").val("B");
	$("#postForm").submit();
}
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp" />
	<div class="content">
		<form id="postForm" action="nico.do" method="post">
			<input type="hidden" name="type" id="type">
			<input type="hidden" name="url" id="url">
			<table class="tbl_type01">
				<thead>
					<tr>
						<th>
							<a href="/nico.do">목록</a><br>
							<a href="http://www.nicovideo.jp/" target="_blank">직접이동</a>
						</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							<c:if test="${type eq 'A'}">
							<table class="tbl_type01">
								<tr>
									<th>
										<input type="text" name="keyword" id="keyword" value="${keyword}">
										<input type="submit" value="검색">
									</th>
								</tr>
								<c:forEach items="${data}" var="ob">
									<tr>
										<td>
											<a href="javascript:viewDetail('${ob.addr}')">${ob.title}</a>
										</td>
									</tr>
								</c:forEach>
								
							</table>
							</c:if>
							
							<c:if test="${type eq 'B'}">
								<%-- <video src="${data}" autoplay="autoplay" controls="controls"></video> --%>
								<iframe src="${data}" id="nicoFrm" style="display: block; width: 640px; height: 360px; margin: auto;">
								</iframe>
							</c:if>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
		
	</div>
</body>
</html>