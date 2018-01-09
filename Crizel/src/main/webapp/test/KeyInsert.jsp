<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<%@include file="/WEB-INF/jsp/header.jsp" %>
<title>키 테스트</title>
<style type="text/css">
</style>
</head>
<body onkeydown='on_key_down()'>
<span onclick="clickTest()">아무 키나 입력해보세요.</span>
<br>char <input type='text' id='keychar' />
<br>keycode <input type='text' id='keycode' />
<br>Alt키 <input type='checkbox' id='altkey' />
<br>Ctrl키 <input type='checkbox' id='ctrlkey' />
<br>Shift키 <input type='checkbox' id='shiftkey' />
</body>
<script>
var i = 0;

function clickTest(){	
	i++;
	alert("TEST : " + i);
	
	if(i<5){
		clickTest();
	}
}

function on_key_down() {
	var keycode = event.keyCode;
	if ( keycode == 8 // 백스페이스 
		|| keycode == 116 // F5
	) event.returnValue = false; // 브라우저 기능 키 무효화
	document.getElementById('keychar').value = String.fromCharCode( keycode );
	document.getElementById('keycode').value = keycode;
	document.getElementById('altkey').checked = event.altKey;
	document.getElementById('ctrlkey').checked = event.ctrlKey;
	document.getElementById('shiftkey').checked = event.shiftKey;
}	
</script>
</body>
</html>