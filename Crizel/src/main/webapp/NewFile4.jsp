<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%=request.getParameter("test") %>
<form action="" method="get">
<input type="text" id="test" name="test">
<input type="submit" value="go">
</form>

</body>
</html>