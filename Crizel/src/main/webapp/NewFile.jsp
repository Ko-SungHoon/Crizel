<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>OpenApi</title>
</head>
<%
/**
*   PURPOSE :   OpenApi Test
*   CREATE  :   20180417_tue    KO
**/
%>

<%!
private class ApiVO{
	public String program_id;
	public String title;
	public String start_date;
	public String end_date;
	public String flag;
	public String program_time;
}

private class ApiList implements RowMapper<ApiVO> {
    public ApiVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ApiVO vo = new ApiVO();
    	
    	vo.program_id			= parseNull(rs.getString("PROGRAM_ID"));
    	vo.title				= parseNull(rs.getString("TITLE"));
    	vo.start_date			= parseNull(rs.getString("START_DATE"));
    	vo.end_date				= parseNull(rs.getString("END_DATE"));
    	vo.flag					= parseNull(rs.getString("FLAG"));
    	vo.program_time			= parseNull(rs.getString("PROGRAM_TIME"));
    	
        return vo;
    }

	public String parseNull(String val){
		if(val==null){val="";}	
		return val;
	}
}
%>
<%
String sql 					= new String();
List<ApiVO> list 			= null;

try{
	sql = new String();
	sql += "SELECT * 						\n";
	sql += "FROM TEST			 			\n";
	sql += "ORDER BY PROGRAM_ID	 			\n";
	list = jdbcTemplate.query(sql, new ApiList());
	
	JSONArray arr = new JSONArray();
	for(ApiVO ob : list){
		JSONObject obj = new JSONObject();
		obj.put("title", ob.title);
		obj.put("program_name", ob.program_time);
		obj.put("start_date", ob.start_date);
		obj.put("end_date", ob.end_date);
		arr.add(obj);
	}
	

}catch(Exception e){
	out.println(e.toString());
}

%>