<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/include/header.jsp"/>
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

function goLink(link, title, ani_id){
	$.ajax({
		type : "POST",
		url : "/lastTitleInsert.do",
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		data : {
			title : title 
			, ani_id : ani_id
		},
		success : function(data) {
			console.log("성공");
			$("#list_title").text(title);
		},
		error:function(request,status,error){
			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
	location.href=link;
}

function allLink(){
	$("input[name=check]").each(function(){
	    window.open($(this).val(), "_blank");
	});
}
</script>
</head>
<body>
<%@include file="/WEB-INF/jsp/include/menu.jsp" %>
<div class="content">
	<input type="hidden" value="${day}" id="dayCheck">
	<div class="btnArea">
		<!-- <form action="/listDetail.do" method="get"> -->
		<form action="https://nyaa.si/?f=0&c=1_4&q=" method="get">
			<input type="text" name="keyword" id="keyword" value="${keyword}">
			<button class="btn_gray">검색</button>
			<button class="btn_gray" type="button" onclick="allLink();">전체 링크</button>
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
			<th><a href="/list.do?day=월&mode=${mode}" class="mon block">월</a></th>
			<th><a href="/list.do?day=화&mode=${mode}" class="tue block">화</a></th>
			<th><a href="/list.do?day=수&mode=${mode}" class="wed block">수</a></th>
			<th><a href="/list.do?day=목&mode=${mode}" class="thu block">목</a></th>
			<th><a href="/list.do?day=금&mode=${mode}" class="fri block">금</a></th>
			<th><a href="/list.do?day=토&mode=${mode}" class="sat block">토</a></th>
			<th><a href="/list.do?day=일&mode=${mode}" class="sun block">일</a></th>
		</tr>
		</thead>
		<c:if test="${list ne null}">
			<c:forEach items="${list}" var="ob">
				<tr class="textCenter">
					<td>
						<a href="/listInsertPage.do?mode=update&ani_id=${ob.ani_id}">${ob.ani_time}</a>
					</td>
					<td colspan="5">
						<%-- <a href="/listDetail.do?keyword=${ob.keyword}&type=${type}&site=${ob.site}&mode=${mode}&ani_id=${ob.ani_id}" class="ani_title">${ob.title}</a> --%>
						<input type="hidden" name="check" value="https://nyaa.si/?f=0&c=1_4&q=${ob.keyword }">
						<a href="https://nyaa.si/?f=0&c=1_4&q=${ob.keyword }">${ob.title }</a>
					</td>
					<td>
						<a href="/aniDelete.do?ani_id=${ob.ani_id}&day=${ob.day}&mode=${mode}" class="ani_del">삭제</a>	
					</td>
				</tr>
			</c:forEach>
		</c:if>
		<c:if test="${listDetail ne null}">
			<c:forEach items="${listDetail}" var="ob">
				<tr>
					<c:choose>
						<c:when test="${mode eq 'nyaa'}">
							<td colspan="6">	
								<a href="javascript:goLink('${ob.link}', '${ob.title}', ${ani_id});"> ${ob.title} </a>
							</td>
							<td colspan="1">
								${ob.pubDate}
							</td>
						</c:when>
						<c:otherwise>
							<td colspan="7">	
								<a href="${ob.link}"> ${ob.title} </a>
							</td>
						</c:otherwise>
					</c:choose>
				</tr>
			</c:forEach>
		</c:if>
	</table>
</div>
</body>
</html>