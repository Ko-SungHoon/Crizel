<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@include file="agentInfo.jsp"%>
<%
    session.invalidate();
    String sendUrl = AUTHORIZATION_URL + "logout.html";
    System.out.println("logout");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <META HTTP-EQUIV="Content-Type"  CONTENT="text/html; charset=utf-8">
        <META HTTP-EQUIV="Pragma" CONTENT ="no-cache">
    <META HTTP-EQUIV="Cache-control" CONTENT="no-cache">
    </head>
<body>
<form name="sendForm" method="post">
    <input type="hidden" name="agentId" value="<%=agentId%>" />
</form>
<script>
    var sendUrl = "<%=sendUrl%>";
    var sendForm = document.sendForm;
    sendForm.action = sendUrl;
    sendForm.submit();
</script>

</body>
</html>