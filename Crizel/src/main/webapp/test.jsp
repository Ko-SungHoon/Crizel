<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>TEST</title>
</head>
<body>
<form action="/test2.do" method="post" enctype="multipart/form-data">
	<input type="text" id="test" name="test" required>
	<input type="file" id="uploadFile" name="uploadFile">
	<input type="submit" value="전송">
</form>
</body>
</html>