<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta name="referrer" content="no-referrer" />
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<title>
ONEJAV
</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<style type="text/css">
</style>
<script>
function allNewTap(){
	$("input:checkbox[name='select']:checked").each(function(){
	    window.open($(this).val(), "_blank");
	});
}

function allCheck(){
	if($("#allCheck").is(":checked")){
		$("input:checkbox[name=select]").prop("checked", "true");
	}else{
		$("input:checkbox[name=select]").removeAttr("checked");
	}
}

function clipboardCopy(index){
	$("#addr_"+index).select();
	document.execCommand('copy');
}

function postFormSubmit(){
	var year = $("#year").val();
	var month = $("#month").val();
	var day = $("#day").val();
	var addr = "http://www.onejav.com/" + year + "/" + month + "/" + day;
	$("#addr").val(addr);
}
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">
	<div class="search center">
		<form id="postForm" action="/onejav.do" method="get" onsubmit="postFormSubmit()">
			<input type="hidden" id="year" value="${year}">
			<input type="hidden" id="addr" name="addr" value="">
			<select id="month">
				<%
				String month = "";
				String paramMonth = (String)request.getAttribute("month")==null?"":(String)request.getAttribute("month");
				for(int i=1; i<=12; i++){
					if(i<10){
						month = "0" + Integer.toString(i);
					}else{
						month = Integer.toString(i);
					}
				%>
					<option value="<%=month%>" <%if(month.equals(paramMonth)){out.println("selected");}%>><%=month%>월</option>
				<%
				}
				%>
			</select>
			<select id="day">
				<%
				String day = "";
				String paramDay = (String)request.getAttribute("day")==null?"":(String)request.getAttribute("day");
				for(int i=1; i<=31; i++){
					if(i<10){
						day = "0" + Integer.toString(i);
					}else{
						day = Integer.toString(i);
					}
				%>
					<option value="<%=day%>" <%if(day.equals(paramDay)){out.println("selected");}%>><%=day%>일</option>
				<%
				}
				%>
			</select>
			<%-- <input type="text" id="addr" name="addr" value="${addr}" placeholder="http://www.onejav.com/"> --%>
			<button>검색</button>
			<!-- <button type="button" onclick="allNewTap()">전체 다운</button> -->
		</form>
	</div>
	<table class="tbl_type01">
	<colgroup>
		<col width="20%">
		<col width="80%">
	</colgroup>
		<tr>
			<!-- <th><input type="checkbox" id="allCheck" onclick="allCheck()"></th> -->
			<th>이름</th>
			<th>사진</th>
		</tr>
	<c:forEach items="${list}" var="ob" varStatus="status">
		<tr>
			<%-- <td>
				<input type="checkbox" name="select" value="${ob.addr}">
			</td> --%>
			<td>
				<a href="${ob.name_link}">${ob.name}</a>
			</td>
			<td>
				<a href="${ob.addr}" target="_blank">
					<img src="${ob.img}" style="max-width: 100%;"> 
				</a> 
			</td>
		</tr>
	</c:forEach>
	</table>
	<!-- <div class="search center">
		<button type="button" onclick="allNewTap()">전체 다운</button>
	</div> -->
</div>
</body>
</html>