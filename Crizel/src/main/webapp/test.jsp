<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<form action="" method="post">
<input type="text" name="aa"><br>
<%=request.getParameter("aa")==null?"":request.getParameter("aa") %>
</form>
</body>
</html>