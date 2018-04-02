<%
/**
*   PURPOSE :   수시프로그램 승인
*   CREATE  :   20180223_fri    Ko
*   MODIFY  :   ....
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="org.json.simple.JSONArray" %>
<%@page import="org.json.simple.JSONObject" %>
<%
String data_sid	 	= parseNull(request.getParameter("data_sid"));
String state	 	= parseNull(request.getParameter("state"));

StringBuffer sql 	= null;
int cnt 			= 0;
String result		= "";
try{
	sql = new StringBuffer();
	sql.append("UPDATE RFC_COMTNBBSDATA			\n");
	sql.append("SET TMP_FIELD2 = ?				\n");
	sql.append("WHERE DATA_SID = ?				\n");
	cnt = jdbcTemplate.update(
			sql.toString(), 
			new Object[]{state, data_sid}
		); 
	
	if(cnt>0){
		result = "ok";
	}
	
	out.println(result);
	
}catch(Exception e){
	out.println(e.toString());
}
%>
