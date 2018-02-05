<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="org.json.simple.JSONArray" %>
<%@page import="org.json.simple.JSONObject" %>
<%@include file="util.jsp"%>
<%!
private class testVO{
	private int program_id;
	private String title;
	private String start_date;
	private String end_date;
	private String flag;
	private String program_time;
}

private class testVOMapper implements RowMapper<testVO> {
    public testVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	testVO vo = new testVO();
        vo.program_id 	= rs.getInt("PROGRAM_ID");
        vo.title 		= rs.getString("TITLE");
        vo.start_date	= rs.getString("START_DATE");
        vo.end_date 	= rs.getString("END_DATE");
        vo.flag 		= rs.getString("FLAG");
        vo.program_time	= rs.getString("PROGRAM_TIME");
        return vo;
    }
}

public String numberFormat(String val){
	if(Integer.parseInt(val) < 10){
		val = "0" + val;
	}
	return val;
}
public String numberFormat(int val){
	String strVal = "";
	if(val < 10){
		strVal = "0" + Integer.toString(val);
	}else{
		strVal = Integer.toString(val);
	}
	return strVal;
}
%>
<%
StringBuffer sql 	= null;
List<testVO> list 	= null;
Object setObj[] 	= null;

String dayVal 		= parseNull(request.getParameter("dayVal"));
String flag			= parseNull(request.getParameter("flag"));

try{
	sql = new StringBuffer();
	sql.append("SELECT *											");
	sql.append("FROM TEST											");
	sql.append("WHERE START_DATE <= ? AND END_DATE >= ? 			");
	if(!"".equals(flag)){
		sql.append("AND FLAG = ?				 					");
	}
	
	if("".equals(flag)){
		setObj = new Object[]{dayVal, dayVal};	
	}else{
		setObj = new Object[]{dayVal, dayVal, flag};
	}
	
	list = jdbcTemplate.query(
				sql.toString(), 
				new testVOMapper(),
				setObj
			);
	
	JSONArray arr = new JSONArray();
	for(testVO ob : list){
		JSONObject obj = new JSONObject();
		obj.put("program_id", ob.program_id);
		obj.put("title", ob.title);
		obj.put("flag", ob.flag);
		obj.put("program_time", ob.program_time);
		arr.add(obj);
	}
	out.print(arr);
}catch(Exception e){
	out.println(e.toString());
}
%>

