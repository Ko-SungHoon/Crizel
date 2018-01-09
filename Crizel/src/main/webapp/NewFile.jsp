<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<jsp:scriptlet>
    pageContext.setAttribute("cr", "\r");
    pageContext.setAttribute("lf", "\n");
    pageContext.setAttribute("crlf", "\r\n");
</jsp:scriptlet>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>Diary</title>
<script>
$(function(){
	var a = $("a");
	
	for(var i=0; i<a.length; i++){
		if(a.eq(i).attr("target") == "_blank"){
			a.eq(i).attr("title", "새 창 열림");
		}
	}
	
});


</script>
</head>
<body>
${fn:replace("테스트aasdsadsadsad<br>EE" , '<br>', crlf )}

<c:set var="test" value="<span><p style='color:red;'>테스트</p></span><br/>asdfsadfdsaf"/>

${test.replaceAll("<p(\\s[a-zA-Z]*=[^>]*)?(\\s)*>","j1m2g3").replaceAll("</p>","j4m5g6").replaceAll("<br/>",crlf)
.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>","")
 .replaceAll("j1m2g3", "<p>").replaceAll("j4m5g6","</p>")}
 
!!!!!!!!!!!!!



<a href="#" >TEST</a>
<a href="#" >TEST2</a>
<a href="#" >TEST3</a>
<a href="#" target="_blank">TEST4</a>
</body>
</html>
