<%
/**
*   PURPOSE :   악기 신청관리 악기선택
*   CREATE  :   20180201_thur    Ko
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
	public int inst_no;
	public String inst_name;
}

private class InsVOMapper implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
    	vo.inst_no			= rs.getInt("inst_no");
    	vo.inst_name		= rs.getString("inst_name");
        return vo;
    }
}
%>
<%
String inst_cat_nm	 	= parseNull(request.getParameter("inst_cat_nm"));

StringBuffer sql		= null;
Object[] setObj 		= null;
List<InsVO> list 		= null;

try{
	sql = new StringBuffer();
	sql.append("SELECT *						");
	sql.append("FROM ART_INST_MNG				");
	sql.append("WHERE INST_CAT_NM = ?			");
	sql.append("	AND SHOW_FLAG = 'Y'			");
	sql.append("	AND DEL_FLAG = 'N'			");
	sql.append("ORDER BY INST_NAME				");
	
	setObj = new Object[]{
						inst_cat_nm
						};
	
	list = jdbcTemplate.query(
				sql.toString(), 
				setObj,
				new InsVOMapper()
			); 
	
	JSONArray arr = new JSONArray();
	for(InsVO ob : list){
		JSONObject obj = new JSONObject();
		obj.put("inst_no", ob.inst_no);
		obj.put("inst_name", ob.inst_name);
		arr.add(obj);
	}
	out.print(arr);
}catch(Exception e){
	out.println(e.toString());
}
%>
