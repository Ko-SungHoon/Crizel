<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.codehaus.jettison.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>	
<%!
private class ArtVO{
	public String banno;
	public String year;
	public String ban_nm;
	public String ban_date;
	public String ban_date2;
	public String ban_etc;
}

private class ArtVOList implements RowMapper<ArtVO> {
    public ArtVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ArtVO vo = new ArtVO();
    	vo.banno		=	rs.getString("BANNO");
    	vo.year			=	rs.getString("YEAR");
    	vo. ban_nm		=	rs.getString("BAN_NM");
    	vo.ban_date		=	rs.getString("BAN_DATE");
    	vo.ban_date2	=	rs.getString("BAN_DATE2");
    	vo.ban_etc		=	rs.getString("BAN_ETC");
        return vo;
    }
}
%>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

Calendar cal		=	Calendar.getInstance();

String sql 			= 	null;
int result			=	0;
List<ArtVO> list 	= 	null;

String mode			=	parseNull(request.getParameter("mode"));
String banno		=	parseNull(request.getParameter("banno"));
//String bannoArrStr 	= 	parseNull(request.getParameter("banno_arr"));
//String[] banno_arr	= 	bannoArrStr.split(",");
String[] banno_arr	=	request.getParameterValues("banno_arr");
String ban_date		=	parseNull(request.getParameter("ban_date"));
String ban_date2	=	parseNull(request.getParameter("ban_date2"));
String ban_etc		=	parseNull(request.getParameter("ban_etc"));
String year			= 	Integer.toString(cal.get(Calendar.YEAR));
String ban_nm		=	"비활성화";

JSONObject jobj		=	new JSONObject();
JSONArray jarr		=	new JSONArray();

try{
	if("dateList".equals(mode)){
		sql = new String();
		sql += "SELECT *					";
		sql += "FROM HAPPY_BAN_TABLE		";
		sql += "WHERE BAN_NM = '비활성화'		";
		sql += "ORDER BY BAN_DATE			";
		list = jdbcTemplate.query(
					sql.toString()
					, new ArtVOList()
				);
		
		jarr = new JSONArray();
		for(ArtVO ob : list){
			jobj = new JSONObject(); 
			jobj.put("banno", ob.banno);
			jobj.put("year", ob.year);
			jobj.put("ban_nm", ob.ban_nm);
			jobj.put("ban_date", ob.ban_date);
			jobj.put("ban_date2", ob.ban_date2);
			jobj.put("ban_etc", ob.ban_etc);
			jarr.add(jobj);
		}
		out.println(jarr);
	}
	else if("dateInsert".equals(mode)){
		sql = new String();
		sql += "SELECT NVL(COUNT(*), 0)									";
		sql += "FROM HAPPY_BAN_TABLE									";
		sql += "WHERE BAN_DATE = ? AND BAN_DATE2 = ? AND BAN_ETC = ?	";
		try{
			result = jdbcTemplate.queryForObject(sql, Integer.class, ban_date, ban_date2, ban_etc);
		}catch(Exception e){
			result = 0;
		}
		
		if(result > 0){
			out.println("dup");
		}else{
			sql = new String();
			sql += "INSERT INTO HAPPY_BAN_TABLE(BANNO, YEAR, BAN_NM, BAN_DATE, BAN_DATE2, BAN_ETC)	";
			sql += "VALUES((SELECT NVL(MAX(BANNO)+1,1) FROM HAPPY_BAN_TABLE), ?, ?, ?, ?, ?)		";
			result = jdbcTemplate.update(
						sql
						, year
						, ban_nm
						, ban_date
						, ban_date2
						, ban_etc
					);
			if(result > 0){
				out.println("Y");
			}else{
				out.println("N");
			}
		}
	}
	else if("dateDelete".equals(mode)){
		sql = new String();
		sql += "DELETE FROM HAPPY_BAN_TABLE WHERE BANNO = ?		";
		result = jdbcTemplate.update(sql, banno);
		if(result > 0){
			out.println("Y");
		}else{
			out.println("N");
		}
	}
	else if("dateDeleteAll".equals(mode)){
		for(int i=0; i<banno_arr.length; i++){
			sql = new String();
			sql += "DELETE FROM HAPPY_BAN_TABLE WHERE BANNO = ?		";
			result = jdbcTemplate.update(sql, banno_arr[i]);
		}
		if(result > 0){
			out.println("Y");
		}else{
			out.println("N");
		}
	}
	
}catch(Exception e){
	out.println("오류가 발생하였습니다.");
}

%>