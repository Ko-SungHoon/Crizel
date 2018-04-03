<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<title>Insert title here</title>
<script type="text/javascript">
function test(){
	$("input:checkbox[name='select']:checked").each(function(){
	    alert($(this).val());
	});
}

function test2(){
	if($("#allCheck").is(":checked")){
		$("input:checkbox[name=select]").attr("checked", "checked");
	}else{
		$("input:checkbox[name=select]").removeAttr("checked");
	}
	
	
	
}
</script>
</head>
<body>
<input type="checkbox" id="allCheck" onclick="test2()">
<input type="checkbox" name="select" value="a">
<input type="checkbox" name="select" value="b">
<input type="checkbox" name="select" value="c">
<input type="checkbox" name="select" value="d">
<input type="checkbox" name="select" value="e">
<input type="checkbox" name="select" value="f">
<button type="button" onclick="test()">ㄱㄱ</button>
</body>
</html>