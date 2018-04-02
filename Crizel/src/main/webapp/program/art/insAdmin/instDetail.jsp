<%
/**
*   PURPOSE :   악기 상세보기 모달 정보
*   CREATE  :   20180212_mon    Ko
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
	public String inst_name;
	public String inst_cat_nm;
	public String inst_size;
	public String inst_model;
	public int curr_cnt;
	public int max_cnt;
	public String inst_lca;
	public String inst_memo;
	public String inst_pic;
}

private class InsVOMapper implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
    	vo.inst_name		= rs.getString("INST_NAME");
    	vo.inst_cat_nm		= rs.getString("INST_CAT_NM");
    	vo.inst_size		= rs.getString("INST_SIZE");
    	vo.inst_model		= rs.getString("INST_MODEL");
    	vo.curr_cnt			= rs.getInt("CURR_CNT");
    	vo.max_cnt			= rs.getInt("MAX_CNT");
    	vo.inst_lca			= rs.getString("INST_LCA");
    	vo.inst_memo		= rs.getString("INST_MEMO");
    	vo.inst_pic			= rs.getString("INST_PIC");
        return vo;
    }
}
%>
<%
String inst_no	 		= parseNull(request.getParameter("inst_no"));

StringBuffer sql		= null;
Object[] setObj 		= null;
List<InsVO> list 		= null;
InsVO vo				= null;

try{
	sql = new StringBuffer();
	sql.append("SELECT 								");
	sql.append("		INST_NAME, 					");
	sql.append("		INST_CAT_NM, 				");
	sql.append("		INST_SIZE, 					");
	sql.append("		INST_MODEL,					");
	sql.append("		CURR_CNT, 					");
	sql.append("		MAX_CNT, 					");
	sql.append("		INST_LCA, 					");
	sql.append("		INST_MEMO, 					");
	sql.append("		INST_PIC 					");
	sql.append("FROM ART_INST_MNG					");
	sql.append("WHERE INST_NO = ?					");
	setObj = new Object[]{
						inst_no
						};
	vo = jdbcTemplate.queryForObject(
				sql.toString(), 
				setObj,
				new InsVOMapper()
			); 
	
	JSONArray arr = new JSONArray();
	JSONObject obj = new JSONObject();
	obj.put("inst_name", vo.inst_name);
	obj.put("inst_cat_nm", vo.inst_cat_nm);
	obj.put("inst_size", vo.inst_size);
	obj.put("inst_model", vo.inst_model);
	obj.put("curr_cnt", vo.curr_cnt);
	obj.put("max_cnt", vo.max_cnt);
	obj.put("inst_lca", vo.inst_lca);
	obj.put("inst_memo", vo.inst_memo.replace("\n", "<br>"));
	obj.put("inst_pic", vo.inst_pic);
	arr.add(obj);
	out.print(arr);
}catch(Exception e){
	out.println(e.toString());
}
%>
