<!-- sample page -->
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
    response.setHeader("P3P","CP='CAO PSA CONi OTR OUR DEM ONL'");
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Expires", "0");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>ISignPlus Web_Agent Sample</title>
</head>
<%-- 	<jsp:forward page="/sso/business.jsp" /> --%>

<frameset rows="*, 0">
    <!-- 로그인 전 /BusinessServlet이 어떤 방식으로든 한번 호출 되어야 한다. -->
    <frame src="/sso/business.jsp" id="main" name="main" scrolling="yes" noresize="noresize" frameborder="0" marginwidth="0" marginheight="0" />
    <!-- 로그인 전 /BusinessServlet이 어떤 방식으로든 한번 호출 되어야 한다. -->
</frameset>
</html>