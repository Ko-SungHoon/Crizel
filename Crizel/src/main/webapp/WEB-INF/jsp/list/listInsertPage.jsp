<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.crizel.common.CrizelVo" %>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>Insert </title>
<script>
function formSubmit(){
	var mode = $("#mode").val();
	
	if(mode == "insert"){
		$("#postForm").attr("action", "/listInsert.do");
	}else{
		$("#postForm").attr("action", "/listUpdate.do");
	}
	
	
	if($.trim($("#ani_time").val()) == ""){
		alert("시간을 입력하여주시기 바랍니다.");
		return false;
	}else if($.trim($("#title").val()) == ""){
		alert("제목을 입력하여주시기 바랍니다.");
		return false;
	}else if($.trim($("#keyword").val()) == ""){
		alert("키워드를 입력하여주시기 바랍니다.");
		return false;
	}else{
		return true;
	}
}
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp" />
<%
String day = request.getParameter("day")==null?"":request.getParameter("day");
String dayArr[] = {"월", "화", "수", "목", "금", "토", "일"};
%>
	<div class="content">
		<form id="postForm" action="/listInsert.do" method="post" onsubmit="return formSubmit();">	
			<input type="hidden" id="mode" name="mode" value="${mode}">
			<c:if test="${mode eq 'update'}">
				<input type="hidden" id="ani_id" name="ani_id" value="${ani_info.ani_id}">
			</c:if>
			<table class="tbl_type02">
				<tr>
					<th>경로</th>
					<td>
						<input type="text" name="directory" value="${ani_info.directory}">
					</td>
				</tr>
				<tr>
					<th>사이트</th>
					<td>
						<select name="site" required>
							<option value="ohys" <c:if test="${ani_info.site eq 'ohys'}"> selected </c:if>>ohys</option>
							<option value="leopard" <c:if test="${ani_info.site eq 'leopard'}"> selected </c:if>>leopard</option>
						</select>
					</td>
				</tr>
				<%
				CrizelVo vo = (CrizelVo)request.getAttribute("ani_info");
				%>
				<tr>
					<th>날짜</th>
					<td>
						<select name="day" id="day" required>
							<%
							for(int i=0; i<dayArr.length; i++){
							%>
							<option value="<%=dayArr[i]%>" 
								<%
								if(vo!=null && dayArr[i].equals(vo.getDay())){
								%> 
									selected="selected"
								<%	
								}else if(dayArr[i].equals(day)){
								%> 
									selected="selected"
								<%
								}
								%>><%=dayArr[i]%></option>
							<%
							}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<th>시간</th>
					<td><input type="text" name="ani_time" id="ani_time" required value="${ani_info.ani_time}"></td>
				</tr>
				<tr>
					<th>제목</th>
					<td><input type="text" name="title" id="title" required value="${ani_info.title}"></td>
				</tr>
				<tr>
					<th>키워드</th>
					<td><input type="text" name="keyword" id="keyword" required value="${ani_info.keyword}"></td>
				</tr>
			</table>
			<div class="btn">
				<c:choose>
					<c:when test="${mode eq 'insert'}">
						<button>추가</button>
					</c:when>
					<c:otherwise>
						<button>수정</button>
					</c:otherwise>
				</c:choose>
			</div>
		</form>
		<iframe src="http://www.anissia.net/anitime/" style="width: 100%; height: 200px;"></iframe>
		<iframe src="https://nyaa.si/?f=0&c=1_4&q=" style="width: 100%; height: 200px;"></iframe>
	</div>


</body>
</html>