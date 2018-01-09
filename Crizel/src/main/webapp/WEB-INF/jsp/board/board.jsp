<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>Board</title>
<script>
$(function(){
	$('#insert').click(function(){
		if($("#idSession").val() != ""){
			location.href="/boardInsertPage.do";
		}else{
			alert("로그인이 필요한 페이지 입니다.");
			modal.style.display = "block";
		}
	});	
});
</script>
</head>
<body>
<input type="hidden" id="idSession" value="${login.id}">
<input type="hidden" id="nameSession" value="${login.name}">
<input type="hidden" id="nickSession" value="${login.nick}">
	<jsp:include page="/WEB-INF/jsp/menu.jsp" />
	<div class="content"> 
			<table class="tbl_type01">
				<thead>
					<tr>
						<td style="width:10%">번호</td>
						<td style="width:50%">제목</td>
						<td style="width:20%">작성자</td>
						<td style="width:20%">작성일</td>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list}" var="ob">
					<c:if test="${ob.title ne null}">
						<tr>
							<td>${ob.rnum}</td>
							<td class="l">
								<c:if test="${ob.b_level ne '0' }">
								&nbsp;&nbsp;ㄴ 
								</c:if>
								<a href="/boardContent.do?b_id=${ob.b_id}&pageParam=${page}">${ob.title}</a>
							</td>
							<td>${ob.user_nick}</td>
							<td>${ob.register_date}</td>
						</tr>
					</c:if>	
					</c:forEach>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="4">						
							<c:if test="${totalCount>0}">
								<a href="/board.do?pageParam=1"> 처음 </a>
								
								<a href="/board.do?pageParam=${pre}"> 이전 </a>
	
								<c:forEach begin="${startPage}" end="${endPage}"
									varStatus="i">
									<a href="/board.do?pageParam=${i.index}">${i.index}</a>
								</c:forEach>
								
								<a href="/board.do?pageParam=${next}"> 다음 </a>
								<a href="/board.do?pageParam=${totalPage}"> 끝 </a>
							</c:if>	
							<input type="button" id="insert" value="글쓰기" style="float: right;">	
						</td>
					</tr>
				</tfoot>
			</table>
	</div>

</body>
</html>