<%
/**
*   PURPOSE :   분류명 중복체크
*   CREATE  :   20180222_thur    Ko
*   MODIFY  :   ....
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="org.json.simple.JSONArray" %>
<%@page import="org.json.simple.JSONObject" %>
<%!
private class InsVO{
	public int cnt;
}

private class Cnt implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
    	vo.cnt			= rs.getInt("CNT");
        return vo;
    }
}
%>
<%
String type			 	= parseNull(request.getParameter("type"), "sch");
String code_val1	 	= parseNull(request.getParameter("code_val1"));

StringBuffer sql		= null;
Object[] setObj 		= null;
int cnt	 				= 0;

String code_name		=	null;
if ("sch".equals(type)) {
	code_name	=	"HAPPY_PRO_SCH";
} else if ("local".equals(type)) {
	code_name	=	"HAPPY_PRO_LOCAL";
} else if ("town".equals(type)) {
	code_name	=	"HAPPY_PRO_TOWN";
}

try{
	sql = new StringBuffer();
	sql.append("SELECT COUNT(*) AS CNT					");
	sql.append("FROM HAPPY_PRO_CODE						");
	sql.append("WHERE CODE_VAL1 = ?	AND CODE_NAME = ?	");
	cnt = jdbcTemplate.queryForObject(
				sql.toString(), 
				new Object[]{code_val1, code_name},
				Integer.class
			);
	if(cnt == 0){
		out.println("ok");
	}else{
		out.println("no");
	}
	
	
	
}catch(Exception e){
	out.println(e.toString());
}
%>
