<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="/js/jquery-1.11.3.min.js"></script>
<script>
$(function(){
	$("#area").change(function(){
		alert("TEST");
	});
	
	$('iframe').load(function(){
	     $('iframe').contents().find('textarea#test').bind('change',function(e) {
	        $("#content").html($(this).val());
	     });
	});
	
});
function test(){
	alert($('#frm').contents().find('#test').html());
}

</script>
</head>
<body>
<a href="javascript:test()">TEST</a> <br>
<div id="content">

</div>
<textarea id="area"></textarea>
<br><br>
<iframe id="frm" src="NewFile3.jsp"></iframe>
</body>
</html>