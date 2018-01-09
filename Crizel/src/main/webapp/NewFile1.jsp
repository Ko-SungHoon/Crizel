<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="org.jsoup.Jsoup" %>
<%@page import="org.jsoup.nodes.Document" %>
<%@page import="org.jsoup.select.Elements" %>
<%@page import="java.io.IOException" %>
<%@page import="java.util.Set" %>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>PUBG</title>
<style type="text/css">
</style>
<script>
</script>
</head>
<body>
<%
String realPath = request.getSession().getServletContext().getRealPath("/");
out.println("1 : " + realPath + "<br>");
%>
<video src="http://pb90.dmc.nico:2809/vod/ht2_nicovideo/nicovideo-sm32447466_2baab28c1513f11ca98d2770b072876282456bde713bb23742712079b0ea6442?ht2_nicovideo=37197268.g8lqik_p1cijl_25br9rwwvt0ty" autoplay="autoplay" controls="controls">
</video>
</body>
</html>