<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.io.BufferedInputStream" %>
<%@page import="java.io.ByteArrayOutputStream" %> 
<%@page import="java.io.FileOutputStream" %>
<%@page import="java.io.IOException" %>
<%@page import="java.io.InputStream" %>
<%@page import="java.net.URL" %>
<%@page import="java.io.File" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP</title>
</head>
<body>
<%!
public boolean isNumber(String str){
	boolean bool = false;
	try{
		Integer.parseInt(str);
		bool = true;
	}catch(Exception e){
		e.printStackTrace();
	}
	return bool;
}
%>

<%
String urlStr = request.getParameter("url");
urlStr = "https://scontent-icn1-1.cdninstagram.com/vp/4f26156f2bbd9e866e3f2a87aab3986f/5A8D196E/t51.2885-15/e15/28153624_177190939675132_6157697391119040512_n.jpg";
String file1 = urlStr.split("/")[urlStr.split("/").length-1];
String file2 = file1.split("[.]")[file1.split("[.]").length-2];
String ext = file1.split("[.]")[file1.split("[.]").length-1];
String name = "경리1";

int num = 0;
while(true){
	num++;
	try{
		File file = new File("E://사진/" + name + "." + ext);
		if(file.exists()){
			if(isNumber(name.substring(name.length()-1))){
				num = Integer.parseInt(name.substring(name.length()-1))+1;
				name = name.substring(0, name.length()-1) + Integer.toString(num);
			}else{
				name = name + Integer.toString(num);
			}
		}else{
			break;
		}
	}catch(Exception e){
		out.println(e.toString());
	}
}

URL url = new URL(urlStr);
InputStream in = new BufferedInputStream(url.openStream());
ByteArrayOutputStream outs = new ByteArrayOutputStream();
byte[] buf = new byte[1024];
int n = 0;
while (-1 != (n = in.read(buf))) {
	outs.write(buf, 0, n);
}
outs.close();	
in.close();
byte[] bytes = outs.toByteArray();

FileOutputStream fos = new FileOutputStream("E://사진/" + name + "." + ext);
fos.write(bytes);
fos.close();
%>
 
</body>
</html>