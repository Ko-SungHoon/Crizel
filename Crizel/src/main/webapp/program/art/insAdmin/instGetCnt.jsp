<%
/**
*   PURPOSE :   악기 신청관리 악기총량, 대여량 불러오기
*   CREATE  :   20180202_fri    Ko
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
	public int curr_cnt;
	public int max_cnt;
	public int now_cnt;
}

private class InsVOMapper implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
    	vo.curr_cnt			= rs.getInt("CURR_CNT");
    	vo.max_cnt			= rs.getInt("MAX_CNT");
    	vo.now_cnt			= rs.getInt("NOW_CNT");
        return vo;
    }
}
%>
<%
String inst_no	 		= parseNull(request.getParameter("inst_no"));

StringBuffer sql		= null;
Object[] setObj 		= null;
List<InsVO> list 		= null;

try{
	sql = new StringBuffer();
	sql.append("SELECT CURR_CNT, MAX_CNT, (MAX_CNT - CURR_CNT) NOW_CNT			");
	sql.append("FROM ART_INST_MNG												");
	sql.append("WHERE INST_NO = ?												");
	setObj = new Object[]{
						inst_no
						};
	list = jdbcTemplate.query(
				sql.toString(), 
				setObj,
				new InsVOMapper()
			); 
	
	JSONArray arr = new JSONArray();
	for(InsVO ob : list){
		JSONObject obj = new JSONObject();
		obj.put("curr_cnt", ob.curr_cnt);
		obj.put("max_cnt", ob.max_cnt);
		obj.put("now_cnt", ob.now_cnt);
		arr.add(obj);
	}
	out.print(arr);
}catch(Exception e){
	out.println(e.toString());
}
%>
