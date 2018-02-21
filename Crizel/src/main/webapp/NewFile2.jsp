<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP</title>
<%@include file="/WEB-INF/jsp/header.jsp" %>
<style type="text/css">
.center{margin: auto; display: block; text-align: center; vertical-align: middle;}
.dialog{background: green}
.dialog .btn{width: 100%; text-align: right;}
</style>
<script>
$(function (){
	$.fn.modal = function (customoptions) {
		return this.each(function () {
			if(typeof customoptions === 'object'){
				
			}else if(typeof customoptions === 'string'){
				
			}else{
				
			}
		});
	}	
});

function test(){
	location.hash="TEST";
}
function openDialog(){
	
}

function closeDialog(){
	$(".dialog").dialog("close");
}

$(function(){
	$(".btnClone").click(function(){
		$(".cloneTest").append($(".clone").eq(0).clone());
	});
	$(".btnDel").click(function(){
		alert($(this).index());
	});	
});


</script>
</head>
<body onload="test()">

<div class="center">
	<button type="button" onclick="openDialog()">모달창 띄우기</button>
</div>

<div class="cloneTest">
	<div class="clone">
		<input type="text" id="test"> <button type="button" class="btnClone">추가</button> <button type="button" class="btnDel">삭제</button>
	</div>
</div>

<div class="dialog" id="dialog">
	<div class="btn">
		<button type="button" onclick="closeDialog()">CLOSE</button>
	</div>
   	<p>다이얼로그 모달창을 띄우는 간단한 방법!!</p>
</div>

<script>
/* $(function(){
	$('.dialog').dialog({
		bgiframe: true,
		autoOpen: false,
	    modal: true,
	    width: "300",
	    height: "500",
	    open: function() {
        	$('.ui-widget-overlay').off('click');
        	$('.ui-widget-overlay').on('click', function() {
                alert("EE");
            })
        }
	}).parents(".ui-dialog").find(".ui-dialog-titlebar").remove();
}); */
</script>


</body>
</html>