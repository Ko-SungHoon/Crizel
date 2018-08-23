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
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">
	<input type="hidden" value="${day}" id="dayCheck">
	<div class="search center">
		<form action="/listDetail.do" method="get">
			<c:choose>
				<c:when test="${mode eq 'nyaa'}">
					<button type="button" onclick="location.href='/list.do'">ohys&leopard</button>
					<input type="hidden" id="mode" name="mode" value="nyaa">
					<select id="type" name="type">
						<option value="1_0" <c:if test="${type eq '1_0'}"> selected </c:if>>VIDEO</option>
						<option value="2_0" <c:if test="${type eq '2_0'}"> selected </c:if>>AUDIO</option>
						<option value="4_0" <c:if test="${type eq '4_0'}"> selected </c:if>>LIVE</option>
						<option value="5_0" <c:if test="${type eq '5_0'}"> selected </c:if>>PICTURE</option>
					</select>
				</c:when>
				<c:otherwise>
					<button type="button" onclick="location.href='/list.do?mode=nyaa'">nyaa</button>
					<input type="hidden" id="type" name="type" value="video">
					<select id="site" name="site">
						<option value="ohys">ohys</option>
						<option value="leopard">leopard</option>
					</select>
				</c:otherwise>
			</c:choose>
			<input type="text" name="keyword" id="keyword" value="${keyword}">
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
			<th scope="col" ><a href="/list.do?day=월&mode=${mode}" class="mon">월</a></th>
			<th scope="col" ><a href="/list.do?day=화&mode=${mode}" class="tue">화</a></th>
			<th scope="col" ><a href="/list.do?day=수&mode=${mode}" class="wed">수</a></th>
			<th scope="col" ><a href="/list.do?day=목&mode=${mode}" class="thu">목</a></th>
			<th scope="col" ><a href="/list.do?day=금&mode=${mode}" class="fri">금</a></th>
			<th scope="col" ><a href="/list.do?day=토&mode=${mode}" class="sat">토</a></th>
			<th scope="col" ><a href="/list.do?day=일&mode=${mode}" class="sun">일</a></th>
		</tr>
		</thead>
		<c:if test="${list ne null}">
			<c:forEach items="${list}" var="ob">
				<tr>
					<td>
						<a href="/listInsertPage.do?mode=update&ani_id=${ob.ani_id}">${ob.ani_time}</a>
					</td>
					<td colspan="5">
						<a href="/listDetail.do?keyword=${ob.keyword}&type=${type}&site=${ob.site}&mode=${mode}&ani_id=${ob.ani_id}" class="ani_title">${ob.title}</a>
					</td>
					<td>
						<a href="/aniDelete.do?ani_id=${ob.ani_id}&day=${ob.day}&mode=${mode}" class="ani_del">삭제</a>	
					</td>
				</tr>
			</c:forEach>
		</c:if>
		<c:if test="${listDetail ne null}">
				<tr>
					<th colspan="7"><span id="list_title">${last_title}</span></th>
				</tr>
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