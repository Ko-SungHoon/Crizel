<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>
<%@page import="org.springframework.context.ApplicationContext" %>
<%@page import="org.springframework.jdbc.core.JdbcTemplate" %>
<%@page import="org.springframework.context.support.FileSystemXmlApplicationContext" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Map" %>
<%@page import="org.springframework.jdbc.core.*" %>
<%@include file="util.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>TEST</title>
<style>
</style>
<script>
</script>
<script type="text/javascript" src="/js/jquery-1.11.3.min.js"></script>
</head>
<body>
<%
StringBuffer sql 				= null;		
List<String> dateList 			= new ArrayList<String>();
Object[] setObj 				= null;
List<Map<String,Object>> list	= null;	

try{
	sql = new StringBuffer();
	sql.append("{CALL ART_ALWAY_CALENDAR(?, ?)}											");
	list = jdbcTemplate.queryForList(
				sql.toString(),
				new Object[]{"2018", "01"}
			);
	
	int a = jdbcTemplate.update(sql.toString(), new Object[]{"2018", "01"});
}catch(Exception e){
	out.println(e.toString());
}
%>
</body>
</html>