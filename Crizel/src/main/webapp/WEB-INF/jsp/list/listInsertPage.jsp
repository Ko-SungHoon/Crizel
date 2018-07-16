<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>Insert </title>
<script>
function formSubmit(){
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
			<form action="/listInsert.do" method="post" onsubmit="return formSubmit();">	
				<input type="hidden" id="mode" name="mode" value="${mode}">
				<table class="tbl_type02">
					<tr>
						<th>사이트</th>
						<td>
						<select name="site" required>
							<option value="ohys">ohys</option>
							<option value="leopard">leopard</option>
						</select>
						</td>
					</tr>
					<tr>
						<th>날짜</th>
						<td>
							<select name="day" id="day" required>
								<%
								for(int i=0; i<dayArr.length; i++){
								%>
								<option value="<%=dayArr[i]%>" <%if(dayArr[i].equals(day)){%> selected="selected"<%}%>><%=dayArr[i]%></option>
								<%
								}
								%>
							</select>
						</td>
					</tr>
					<tr>
						<th>시간</th>
						<td><input type="text" name="ani_time" id="ani_time" required></td>
					</tr>
					<tr>
						<th>제목</th>
						<td><input type="text" name="title" id="title" required></td>
					</tr>
					<tr>
						<th>키워드</th>
						<td><input type="text" name="keyword" id="keyword" required></td>
					</tr>
				</table>
				<div class="btn">
					<button>추가</button>
				</div>
			</form>
	</div>


</body>
</html>