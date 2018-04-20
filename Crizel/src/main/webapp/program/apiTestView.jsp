<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp"%>	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
<script>
$(function(){
	$.ajax({
		type : "POST",
		//url : "NewFile.jsp",
		url : "http://www.k-sis.com:8088/program/apiTest.jsp",
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		datatype : "json",
		success : function(data) {
			var html = "";
			$.each(JSON.parse(data), function(i, val) {									//ajax로 받아온 json 데이터를 html로 구성한다
				/* html += val.title + " ";
				html += val.program_time + " ";
				html += val.start_date + " ";
				html += val.end_date + "<br>"; */
				
				html += val.school_name + " ";
				html += val.charge_name + "<br>";
			});
			$("#test").html(html);
		},
		error:function(request,status,error){
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