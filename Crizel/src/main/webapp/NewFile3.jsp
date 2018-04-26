<%@page import="java.io.OutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.io.File"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="org.springframework.jdbc.core.RowMapper"%>
<%@page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
String ip = request.getRemoteAddr();

if("112.163.77.52".equals(ip)){
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="/jquery/js/jquery-1.11.2.min.js"></script>
</head>
<body>
<%
String directory = request.getParameter("directory");
String filename = request.getParameter("filename");			

String realname = filename;
String docName = URLEncoder.encode(realname, "UTF-8").replaceAll("\\+", " ");
//directory = URLEncoder.encode(directory, "UTF-8").replaceAll("\\+", " ");

String filePath = directory + "/" + realname;

try {
	File file = new File(filePath);
	if (!file.exists()) {
		try {
			throw new Exception();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	response.setHeader("Content-Disposition", "attachment;filename=" + docName + ";");
	response.setHeader("Content-Type", "application/octet-stream");
	response.setContentLength((int) file.length());
	response.setHeader("Content-Transfer-Encoding", "binary;");
	response.setHeader("Pragma", "no-cache;");
	response.setHeader("Expires", "-1;");
	int read;
	byte readByte[] = new byte[4096];

	BufferedInputStream fin = new BufferedInputStream(new FileInputStream(file));
	OutputStream outs = response.getOutputStream();

	while ((read = fin.read(readByte, 0, 4096)) != -1) {
		outs.write(readByte, 0, read);
	}

	outs.flush();
	outs.close();
	fin.close();

} catch (java.io.IOException e) {
	if (!e.getClass().getName().equals("org.apache.catalina.connector.ClientAbortException")) {

	}

}
%>

</body>
</html>

<%
}
%>




