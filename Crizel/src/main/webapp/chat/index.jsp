<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="/chat/jquery-1.11.3.min.js"></script>
<script src="/chat/chat.js"></script>
<link href="/chat/chat.css" rel="stylesheet" type="text/css" />
</head>
<body>
<div class="chat_content">
	<div class="chat_data">
	
	</div>
</div>
<div class="chat_input">
<form onsubmit="chat('write')" method="post" id="postForm">
	<input type="hidden" id="reg_ip" name="reg_ip" value="<%=request.getRemoteAddr()%>">
	<input type="text" id="nick_name" name="nick_name" placeholder="닉네임">
	<input type="text" id="content" name="content" onKeyDown="if(event.keyCode == 13){chat('write');}">
	<button type="button" onclick="chat('write')">보내기</button>
</form>
	
</div>
</body>
</html>