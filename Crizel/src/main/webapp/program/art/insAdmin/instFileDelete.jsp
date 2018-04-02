<%
/**
*   PURPOSE :   악기 파일 삭제 action page
*   CREATE  :   20180201_thur    Ko
*   MODIFY  :   ....
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%
String inst_no	 	= parseNull(request.getParameter("inst_no"));

StringBuffer sql	= null;
Object[] setObj 		= null;
int result 				= 0;

try{
	sql = new StringBuffer();
	sql.append("UPDATE ART_INST_MNG						");
	sql.append("	SET	INST_PIC 	= ''				");
	sql.append("WHERE INST_NO 		= ?					");
	
	setObj = new Object[]{
							inst_no
						};
	
	result = jdbcTemplate.update(
				sql.toString(), 
				setObj
			);
}catch(Exception e){
	out.println(e.toString());
}finally{
	if(result>0){
		out.println("success");
	}
}
%>
