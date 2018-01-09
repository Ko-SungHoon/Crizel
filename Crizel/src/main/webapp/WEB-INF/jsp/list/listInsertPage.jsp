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
				<table class="tbl_type01">
					<tr>
						<th>사이트</th>
						<td>
						<select name="site">
							<option value="ohys">ohys</option>
							<option value="leopard">leopard</option>
						</select>
						</td>
					</tr>
					<tr>
						<th>날짜</th>
						<td>
							<select name="day" id="day">
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
						<td><input type="text" name="ani_time" id="ani_time"></td>
					</tr>
					<tr>
						<th>제목</th>
						<td><input type="text" name="title" id="title"></td>
					</tr>
					<tr>
						<th>키워드</th>
						<td><input type="text" name="keyword" id="keyword"></td>
					</tr>
					<tr>
						<td colspan="2"><input type="submit" value="추가"></td>
					</tr>
				</table>
			</form>
	</div>


</body>
</html>