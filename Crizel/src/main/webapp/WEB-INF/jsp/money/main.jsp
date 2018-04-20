<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>Money</title>
<script type="text/javascript">
$(function(){
	var year = $("#year").val();
	var month = $("#month").val();
	
	$.ajax({
		type : "POST",
		url : "/moneyCalendar.do",
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		datatype : "html",
		data : {"year" : year, "month" : month},
		success : function(data) {
			var html = "";
			html +="<colgroup>";
			html +="<col width='15%'/>";
			html +="<col width='14%'/>";
			html +="<col width='14%'/>";
			html +="<col width='14%'/>";
			html +="<col width='14%'/>";
			html +="<col width='14%'/>";
			html +="<col width='15%'/>";
			html +="</colgroup>";
			
			html += "<thead>";
			html += "<th class='sun'>일</th>";
			html += "<th>월</th>";
			html += "<th>화</th>";
			html += "<th>수</th>";
			html += "<th>목</th>";
			html += "<th>금</th>";
			html += "<th class='sat'>토</th>";
			html += "</thead>";
			html += data.trim();
			$(".tbl_type01").html(html);
		},
		error:function(request,status,error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
});
</script>
<style type="text/css">
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp" />
	<div class="content">
		<form id="postForm">
			<input type="hidden" id="year" name="year" value="${year}">
			<input type="hidden" id="month" name="month" value="${month}">
			<table class="tbl_type01">
			
			</table>
		</form>
	</div>
</body>
</html>