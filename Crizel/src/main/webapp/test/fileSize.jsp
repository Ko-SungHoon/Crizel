<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP</title>
<jsp:include page="/WEB-INF/jsp/include/header.jsp" />
<script>
$(function(){
	$("input[id=nt_img_real").change(function(){
	    // 필드 채워지면
	    if($(this).val() != ""){
	            // 용량 체크
	            var fileSize = this.files[0].size;
	            var maxSize = 1024 * 1024 * 10;
	            if(fileSize > maxSize){
	                alert("10mb 이하의 이미지 파일을 선택하여 주시기 바랍니다.");
	                $(this).val("");
	            }
	    }
	});
});


</script>
</head>
<body>

<input type="file" id="nt_img_real" name="nt_img_real">

 
</body>
</html>