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
			location.href="/loginPage.do";
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
		<div class="search">	
			<form action="/board.do" method="get" id="searchForm">
				<select id="search1" name="search1">
					<option <c:if test="${search1 eq 'titleContent'}"> selected </c:if> value="titleContent">제목+내용</option>
					<option <c:if test="${search1 eq 'title'}"> selected </c:if> value="title">제목</option>
					<option <c:if test="${search1 eq 'content'}"> selected </c:if> value="content">내용</option>
					<option <c:if test="${search1 eq 'user_nick'}"> selected </c:if> value="user_nick">작성자</option>
				</select>
				<input type="text" id="keyword" name="keyword" value="${keyword}">
				<button>검색</button>
			</form>	
		</div>
			<table class="tbl_type01">
				<thead>
					<tr>
						<th style="width:10%">번호</th>
						<th style="width:50%">제목</th>
						<th style="width:20%">작성자</th>
						<th style="width:20%">작성일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list}" var="ob">
					<c:if test="${ob.title ne null}">
						<tr>
							<td>${ob.rnum}</td>
							<td class="left">
								<a href="/boardContent.do?b_id=${ob.b_id}&pageParam=${page}">
								<c:if test="${ob.b_level ne '0' }">
								&nbsp;&nbsp;ㄴ 
								</c:if>
								${ob.title}</a>
							</td>
							<td>${ob.user_nick}</td>
							<td>${ob.register_date}</td>
						</tr>
					</c:if>	
					</c:forEach>
				</tbody>
			</table>
			<div class="paging">
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
			</div>
	</div>

</body>
</html>