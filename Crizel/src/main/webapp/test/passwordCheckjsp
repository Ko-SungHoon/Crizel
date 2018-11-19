<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>TEST</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
function idConfirm(){
	var idConfirm = false;
	var str = $("#id").val();
	var strlen = str.length;
	var check1 = false;
	var check2 = false;
	var check3 = false;
	var check4 = false;
	var cnt = 0;
	
	if(str.match(/[a-z]/g)) {	// 소문자 검증
		var check1 = true;
	}
	if(str.match(/[0-9]/g)) {	// 숫자 검증
		var check2 = true;
	}
	if(str.match(/[A-Z]/g)) {	// 대문자 검증
		var check3 = true;
	}
	if(str.match(/_/g)) {	// 특수문자(_) 검증
		var check4 = true;
	}
	
	if(check1){cnt++;}
	if(check2){cnt++;}
	if(check3){cnt++;}
	if(check4){cnt++;}
	
	if(str.match(/[^a-z\w\s]/g) && !check4) {	//특수문자 검증
		cnt = 0;
	}
	
	
	if(strlen>0){
		if(strlen>=3 && strlen<=20){
			if(cnt>=1){
				idConfirm = true;
			}else{
				idConfirm = false;
			}
		}else{
			idConfirm = false;
		}
	}else{
		idConfirm = false;
	}
	
	
	if(!idConfirm){
		alert("3글자 이상 20글자이하 영대/영소/숫자/특수문자(_)로 입력해 주십시오.");
	}else{
		alert("id : " + str + "\nconfirm : " + idConfirm + "\ncheck4 : " + check4);
	}
	
	
	return idConfirm;
}
</script>
<style type="text/css">
div{width:100%;}
ul{
	width:30%;
	border-top: 2px solid #333;
    border-bottom: 1px solid #dedede;
    font-size: 11px;
    text-align: center;
    color: #888;
    margin: auto;}
li{ float: left;
    width: 29.3%;
    padding: 15px 2%;
    display: block;
    margin: 0 auto;
    min-height: 218px;}    
a{	width: 100%;
	text-decoration: none;
    color: #333;}   
img{width: 100%;
    height: 140px;
}    
</style>
</head>
<body>
<div>
	<ul>
		<li><a><img src="/img/video.png" /></a></li>
		<li><a><img src="/img/mans.jpg" /></a></li>
		<li><a><img src="/img/onejav.png" /></a></li>
		<li><a><img src="/img/mars.png" /></a></li>
	</ul>
</div>
<input type="text" id="id" name="id">
<input type="button" onclick="idConfirm();" value="확인">
</body>
</html>