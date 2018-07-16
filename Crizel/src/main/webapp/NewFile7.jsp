<%@page import="java.io.OutputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.BufferedOutputStream"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<form action="/test.do" method="post">
	<textarea cols="20" rows="30" name="text"></textarea>
	<input type="submit" value="고고씽">
</form>
</body>
</html>