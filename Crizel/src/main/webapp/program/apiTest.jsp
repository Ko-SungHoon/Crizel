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
<body>
<%
/**
*   PURPOSE :   OpenApi Test
*   CREATE  :   20180417_tue    KO
**/
%>
<%!
private class ApiVO{
	public String school_id;
	public String school_name;
	public String school_area;
	public String school_addr;
	public String school_tel;
	public String school_url;
	public String charge_dept;
	public String dept_tel;
	public String charge_name;
	public String charge_phone;
	public String account;
	public String area_type;
	public String charge_id;
	public String school_approval;
	public String sch_approval_date;
	public String charge_name2;
	public String school_type;
}

private class ApiList implements RowMapper<ApiVO> {
    public ApiVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ApiVO vo = new ApiVO();
    	
    	vo.school_id			= parseNull(rs.getString("school_id"));
    	vo.school_name			= parseNull(rs.getString("school_name"));
    	vo.school_area			= parseNull(rs.getString("school_area"));
    	vo.school_addr			= parseNull(rs.getString("school_addr"));
    	vo.school_tel			= parseNull(rs.getString("school_tel"));
    	vo.school_url			= parseNull(rs.getString("school_url"));
    	vo.charge_dept			= parseNull(rs.getString("charge_dept"));
    	vo.dept_tel				= parseNull(rs.getString("dept_tel"));
    	vo.charge_name			= parseNull(rs.getString("charge_name"));
    	vo.charge_phone			= parseNull(rs.getString("charge_phone"));	
    	vo.account				= parseNull(rs.getString("account"));
    	vo.area_type			= parseNull(rs.getString("area_type"));
    	vo.charge_id			= parseNull(rs.getString("charge_id"));
    	vo.school_approval		= parseNull(rs.getString("school_approval"));
    	vo.sch_approval_date	= parseNull(rs.getString("sch_approval_date"));
    	vo.charge_name2			= parseNull(rs.getString("charge_name2"));
    	vo.school_type			= parseNull(rs.getString("school_type"));
    	
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
	sql += "FROM RESERVE_SCHOOL 			\n";
	sql += "ORDER BY SCHOOL_ID	 			\n";
	list = jdbcTemplate.query(sql, new ApiList());
	
	JSONArray arr = new JSONArray();
	for(ApiVO ob : list){
		JSONObject obj = new JSONObject();
		obj.put("school_name", ob.school_name);
		obj.put("charge_name", ob.charge_name);
		arr.add(obj);
	}
	
	out.println(arr);

}catch(Exception e){
	out.println(e.toString());
}

%>
</body>
</html>