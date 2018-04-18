<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
$(function(){
	$.ajax({
		type:     "POST",
	    data:     {"test" : "TEST"},
	    url:      "NewFile.jsp",
	    dataType: "json",
		contentType : "application/json; charset=utf-8",
	    async:    false,
		success : function(data) {
			var html = "";
			$.each(JSON.parse(data), function(i, val) {									//ajax로 받아온 json 데이터를 html로 구성한다
				html += "프로그램명 : " + val.title + " <br>";
				html += "시작일 : " + val.start_date + " <br>";
				html += "종료일 : " + val.end_date + " <br>";
				html += "시간 : " + val.program_time + " <br><br>";
			});
			$("#test").html(html);
		},
		error:function(request,status,error){
			$("#test").html(error);
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
});

</script>
</head>
<body>

<img src="http://www.k-sis.com:8088/img/food/logo.png">


<div id="test">

</div>

</body>
</html>