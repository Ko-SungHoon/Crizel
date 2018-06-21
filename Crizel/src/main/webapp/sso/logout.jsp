<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="agentInfo.jsp"%>
<%
    /**
     * logout - SSO 전체 로그아웃을 진행
     *      기존 업무의 로그아웃처리를 먼저 진행 후 호출 합니다
     */

    // TODO - 업무 시스템 로그아웃 로직 처리

    try {
        session.invalidate();
    } catch (Exception e) {};

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
</head>
<body>
<form name="sendForm" method="post" action="<%=AUTH_LOGOUT_PAGE%>">
    <input type="hidden" name="agentId" value="<%=agentId%>" />
</form>

<script>
    var sendForm = document.sendForm;
    sendForm.submit();
</script>
</body>
</html>