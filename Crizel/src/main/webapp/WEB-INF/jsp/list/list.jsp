<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<title>List</title>
<script>
$(function(){
	if($("#dayCheck").val() == "월"){
		$(".mon").addClass("on");
	}else if($("#dayCheck").val() == "화"){
		$(".tue").addClass("on");
	}else if($("#dayCheck").val() == "수"){
		$(".wed").addClass("on");
	}else if($("#dayCheck").val() == "목"){
		$(".thu").addClass("on");
	}else if($("#dayCheck").val() == "금"){
		$(".fri").addClass("on");
	}else if($("#dayCheck").val() == "토"){
		$(".sat").addClass("on");
	}else if($("#dayCheck").val() == "일"){
		$(".sun").addClass("on");
	}
});
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">
	<input type="hidden" value="${day}" id="dayCheck">
	<div class="search center">
		<form action="/listDetail.do" method="get">
			<input type="hidden" id="type" name="type" value="video">
			<input type="text" name="keyword" id="keyword">
			<button>검색</button>
		</form>
	</div>
	<table class="tbl_type01">
		<colgroup>
			<col style="width:14.285%" />
			<col style="width:14.285%" />
			<col style="width:14.285%" />
			<col style="width:14.285%" />
			<col style="width:14.285%" />
			<col style="width:14.285%" />
			<col style="width:14.285%" />
		</colgroup>
		<thead>
		<tr>
			<th scope="col" ><a href="/list.do?day=월" class="mon">월</a></th>
			<th scope="col" ><a href="/list.do?day=화" class="tue">화</a></th>
			<th scope="col" ><a href="/list.do?day=수" class="wed">수</a></th>
			<th scope="col" ><a href="/list.do?day=목" class="thu">목</a></th>
			<th scope="col" ><a href="/list.do?day=금" class="fri">금</a></th>
			<th scope="col" ><a href="/list.do?day=토" class="sat">토</a></th>
			<th scope="col" ><a href="/list.do?day=일" class="sun">일</a></th>
		</tr>
		</thead>
		<c:if test="${list ne null}">
			<c:forEach items="${list}" var="ob">
				<tr>
					<td>
						<span class="ani_time">${ob.ani_time}</span>
					</td>
					<td colspan="5">
						<a href="/listDetail.do?keyword=${ob.keyword}&type=video&site=${ob.site}" class="ani_title">${ob.title}</a>
						<%-- <c:choose>
							<c:when test="${ob.site eq 'ohys'}">
								<a href="/listDetail.do?keyword=${ob.keyword}&type=video&site=${ob.site}" class="ani_title">${ob.title}</a>
							</c:when>
							<c:otherwise>
								<a href="http://leopard-raws.org/?search=${ob.keyword}" class="ani_title">${ob.title}</a>							
							</c:otherwise>
						</c:choose> --%>
					</td>
					<td>
						<a href="/aniDelete.do?ani_id=${ob.ani_id}&day=${ob.day}" class="ani_del">삭제</a>	
					</td>
				</tr>
			</c:forEach>
		</c:if>
		<c:if test="${listDetail ne null}">
			<c:forEach items="${listDetail}" var="ob">
				<tr>
					<td colspan="9">	
						<a href="${ob.link}"> ${ob.title} </a>
					</td>
				</tr>
			</c:forEach>
		</c:if>
	</table>
</div>
</body>
</html>