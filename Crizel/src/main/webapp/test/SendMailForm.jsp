<%@page import="javax.mail.Transport"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.Session"%>
<%@page import="java.util.Properties"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
.tbl_type01{width:70%; margin:auto; margin-top:100px; text-align: center; border-collapse: collapse; border-spacing: 0;}
.tbl_type01 textarea{width:90%;}
.tbl_type01 input[type=text]{width:90%;}
.tbl_type01 td,th{border: 1px solid black; border-collapse: collapse; border-spacing: 0; line-height: 30px;}
</style>
</head>
<body>
<%
/* 
String fromAddr		= request.getParameter("fromAddr")==null?"":request.getParameter("fromAddr");
String fromName		= request.getParameter("fromName")==null?"":request.getParameter("fromName");
String toAddr		= request.getParameter("toAddr")==null?"":request.getParameter("toAddr");
String toName		= request.getParameter("toName")==null?"":request.getParameter("toName");
String title		= request.getParameter("title")==null?"":request.getParameter("title");
String content		= request.getParameter("content")==null?"":request.getParameter("content");

if(!"".equals(fromAddr)){
	try{
		SendMail sendMail = new SendMail();
		sendMail.sendMail(fromAddr, fromName, toAddr, toName, title, content);
		out.println("<script>alert('메일전송 완료');");
		out.println("location.href='/program/test.jsp';</script>");
	}catch(Exception e){
		out.println("<script>alert('오류발생');</script>");
	}
	
}
 */
%>
<form id="postForm" action="SendMail.jsp" method="post" enctype="multipart/form-data">
<table class="tbl_type01">
	<tbody>
		<tr>
			<th>보내는사람 메일주소</th>
			<td><input type="text" id="fromAddr" name="fromAddr" required value="ksh@k-sis.com"></td>
			<th>보내는사람 이름</th>
			<td><input type="text" id="fromName" name="fromName" required value="고성훈"></td>
		</tr> 
		<tr>
			<th>받는사람 메일주소</th>
			<td><input type="text" id="toAddr" name="toAddr" required value="rhzhzh3@gmail.com"></td>
			<th>받는사람 이름</th>
			<td><input type="text" id="toName" name="toName" required value="고성훈"></td>
		</tr> 
		<tr>
			<th>메일제목</th>
			<td colspan="3"><input type="text" id="title" name="title" required value="메일 테스트"></td>
		</tr>
		<tr>
			<th>메일내용</th>
			<td colspan="3">
				<textarea rows="20" id="content" name="content" required>테스트</textarea>
			</td>
		</tr>
		<tr>
			<th>첨부파일</th>
			<td colspan="3">
				<input type="file" id="uploadFile" name="uploadFile">
				<input type="file" id="uploadFile2" name="uploadFile2">
				<input type="file" id="uploadFile3" name="uploadFile3">
			</td>
		</tr>
	</tbody>
	<tfoot>
		<tr>
			<td colspan="4"><input type="submit" value="메일전송"></td>
		</tr>
	</tfoot>
</table>
</form>
</body>
</html>