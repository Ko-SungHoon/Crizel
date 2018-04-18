<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>Insert title here</title>
<script>
$(function(){
	alert(window.document.referrer);
});

function test(){
	delete window.document.referrer;
    window.document.__defineGetter__('referrer', function () {
        return "http://www.naver.com";
    });
    $("#postForm").attr("action", "https://5siri.com/xe/?module=file&act=procFileDownload&file_srl=6247805&sid=6c4c2fa70132da767539496aad3d35fe&module_srl=2076607");
    $("#postForm").attr("method", "get").submit();
    //window.location.href = addr;
}
</script>
</head>
<body>


</body>
</html>