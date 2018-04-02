<%
/**
*   PURPOSE :   업데이트 요청 - 액션
*   CREATE  :   20180323_fri    Ko
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

String mode			= parseNull(request.getParameter("mode"));

String sts_flag		= parseNull(request.getParameter("sts_flag"));

String s_item_no	= parseNull(request.getParameter("s_item_no"));
String cat_nm		= parseNull(request.getParameter("cat_nm"));
String n_item_code	= parseNull(request.getParameter("n_item_code"));
String n_item_nm	= parseNull(request.getParameter("n_item_nm"));
String n_item_dt_nm	= parseNull(request.getParameter("n_item_dt_nm"));
String n_item_expl	= parseNull(request.getParameter("n_item_expl"));
String upd_reason	= parseNull(request.getParameter("upd_reason"));

StringBuffer sql 	= null;
int result 			= 0;

try{
	if("".equals(mode)){
		
	}
	
}catch(Exception e){
	out.println(e.toString());
}

%>