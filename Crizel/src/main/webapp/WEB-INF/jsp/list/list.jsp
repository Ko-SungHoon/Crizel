<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<title>List</title>
<style type="text/css">
#keyword{width: 30%; margin-right: 15px;}
</style>
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
	
	$("#searchBtn").click(function(){
		var keyword = $("#keyword").val();
		location.href="/listDetail.do?keyword=" + keyword + "&type=video";
	});
});
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">
	<input type="hidden" value="${day}" id="dayCheck">
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
			<td colspan="7">
				<input type="text" name="keyword" id="keyword"><span id="searchBtn">검색</span>
			</td>
		</tr>
		<tr>
			<th scope="col" class="mon" onclick="location.href='/list.do?day=월'"><span>월</span></th>
			<th scope="col" class="tue" onclick="location.href='/list.do?day=화'"><span>화</span></th>
			<th scope="col" class="wed" onclick="location.href='/list.do?day=수'"><span>수</span></th>
			<th scope="col" class="thu" onclick="location.href='/list.do?day=목'"><span>목</span></th>
			<th scope="col" class="fri" onclick="location.href='/list.do?day=금'"><span>금</span></th>
			<th scope="col" class="sat" onclick="location.href='/list.do?day=토'"><span>토</span></th>
			<th scope="col" class="sun" onclick="location.href='/list.do?day=일'"><span>일</span></th>
		</tr>
		</thead>
		<c:if test="${list ne null}">
			<c:forEach items="${list}" var="ob">
				<tr>
					<td>
						<span class="ani_time">${ob.ani_time}</span>
					</td>
					<td colspan="5">
						<c:choose>
							<c:when test="${ob.site eq 'ohys'}">
								<a href="/listDetail.do?keyword=${ob.keyword}&type=video" class="ani_title">${ob.title}</a>
							</c:when>
							<c:otherwise>
								<a href="http://leopard-raws.org/?search=${ob.keyword}" class="ani_title">${ob.title}</a>							
							</c:otherwise>
						</c:choose>
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