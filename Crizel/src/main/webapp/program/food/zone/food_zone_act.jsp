<%
/**
*   PURPOSE :   권역 - 액션
*   CREATE  :   20180321_wed    Ko
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

String mode		= parseNull(request.getParameter("mode"));

String sch_no	= parseNull(request.getParameter("sch_no"));

String zone_no	= parseNull(request.getParameter("zone_no"), "0");
String zone_nm	= parseNull(request.getParameter("zone_nm"));
String[] zone_no_arr = request.getParameterValues("zone_no_arr");
String[] zone_nm_arr = request.getParameterValues("zone_nm_arr");

String team_no = parseNull(request.getParameter("team_no"), "0");
String team_nm = parseNull(request.getParameter("team_nm"));
String[] order1_arr = request.getParameterValues("order1_arr");
String[] team_no_arr = request.getParameterValues("team_no_arr");
String[] team_nm_arr = request.getParameterValues("team_nm_arr");

StringBuffer sql 	= null;
int result 			= 0;

try{
	if("zoneInsert".equals(mode)){
		sql = new StringBuffer();
		sql.append("INSERT INTO FOOD_ZONE(ZONE_NO, ZONE_NM, REG_DATE, MOD_DATE, SHOW_FLAG)		");
		sql.append("VALUES(																		");
		sql.append("	(SELECT NVL(MAX(ZONE_NO)+1,1) FROM FOOD_ZONE),							");	// ZONE_ID
		sql.append("	?,																		");	// ZONE_NM
		sql.append("	SYSDATE,																");	// REG_DATE
		sql.append("	SYSDATE,																");	// MOD_DATE
		sql.append("	'Y'																		");	// SHOW_FLAG
		sql.append(")																			");
		result = jdbcTemplate.update(sql.toString(), zone_nm);
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_zone_list.jsp');");
			out.println("</script>");
		}
		
	}else if("zoneDelete".equals(mode)){
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_ZONE SET 	");
		sql.append("	SHOW_FLAG = 'N'		");
		sql.append("WHERE ZONE_NO = ?	 	");
		result = jdbcTemplate.update(sql.toString(), zone_no);
		
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_TEAM SET 	");
		sql.append("	SHOW_FLAG = 'N'		");
		sql.append("WHERE ZONE_NO = ?	 	");
		result = jdbcTemplate.update(sql.toString(), zone_no);
		
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_SCH_TB SET 	");
		sql.append("	  ZONE_NO = 0		");
		sql.append("	, TEAM_NO = 0		");
		sql.append("WHERE ZONE_NO = ?	 	");
		result = jdbcTemplate.update(sql.toString(), zone_no);
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_zone_popup.jsp');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}
	}else if("zoneUpdate".equals(mode)){
		List<Object[]> batch = new ArrayList<Object[]>();
		if(zone_no_arr!=null){
			for(int i=0; i<zone_no_arr.length; i++){
				Object[] value = new Object[]{
						zone_nm_arr[i],
						zone_no_arr[i]	
				};
				batch.add(value);
			}
		}
		
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_ZONE SET");
		sql.append("	ZONE_NM = ?		");
		sql.append("WHERE ZONE_NO = ?	");
		int[] batchResult = jdbcTemplate.batchUpdate(sql.toString(), batch);
		result = batchResult.length;
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			//out.println("location.replace('food_zone_popup.jsp');");
			out.println("window.close();");
			out.println("opener.location.reload();");
			out.println("</script>");
		}
	}else if("teamInsert".equals(mode)){
		sql = new StringBuffer();
		sql.append("INSERT INTO FOOD_TEAM(	TEAM_NO, ZONE_NO, TEAM_NM, REG_DATE, MOD_DATE,					");
		sql.append("						SHOW_FLAG, ORDER1, ORDER2, ORDER3	)							");
		sql.append("VALUES(																					");
		sql.append("	(SELECT NVL(MAX(TEAM_NO)+1,1) FROM FOOD_TEAM),										");	// TEAM_NO
		sql.append("	?,																					");	// ZONE_NO
		sql.append("	?,																					");	// TEAM_NM
		sql.append("	SYSDATE,																			");	// REG_DATE
		sql.append("	SYSDATE,																			");	// MOD_DATE
		sql.append("	'Y',																				");	// SHOW_FLAG
		sql.append("	(SELECT NVL(MAX(ORDER1)+1,1) FROM FOOD_TEAM WHERE ZONE_NO = ? AND SHOW_FLAG = 'Y'),	");	// ORDER1
		sql.append("	0,																					");	// ORDER2
		sql.append("	0																					");	// ORDER3
		sql.append(")																						");
		result = jdbcTemplate.update(sql.toString(), zone_no, team_nm, zone_no);
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_team_popup.jsp?zone_no="+zone_no+"');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}
		
	}else if("teamUpdate".equals(mode)){
		List<Object[]> batch = new ArrayList<Object[]>();
		if(team_no_arr!=null){
			for(int i=0; i<team_no_arr.length; i++){
				Object[] value = new Object[]{
						team_nm_arr[i],
						order1_arr[i],
						team_no_arr[i]
				};
				batch.add(value);
			}
		}
		
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_TEAM SET		");
		sql.append("	TEAM_NM 	= ?,		");
		sql.append("	ORDER1 		= ?,		");
		sql.append("	MOD_DATE	= SYSDATE	");
		sql.append("WHERE TEAM_NO = ?			");
		int[] batchResult = jdbcTemplate.batchUpdate(sql.toString(), batch);
		result = batchResult.length;
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			//out.println("location.replace('food_team_popup.jsp?zone_no="+zone_no+"');");
			out.println("window.close();");
			out.println("opener.location.reload();");
			out.println("</script>");
		}
	}else if("teamDelete".equals(mode)){
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_TEAM SET 	");
		sql.append("	SHOW_FLAG = 'N'		");
		sql.append("WHERE TEAM_NO = ?	 	");
		result = jdbcTemplate.update(sql.toString(), team_no);
		
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_SCH_TB SET 	");
		sql.append("	TEAM_NO = 0			");
		sql.append("WHERE TEAM_NO = ?	 	");
		result = jdbcTemplate.update(sql.toString(), team_no);
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_team_popup.jsp?zone_no="+zone_no+"');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}
	}else if("teamApply".equals(mode)){
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_SCH_TB SET 	");
		sql.append("	 ZONE_NO = ?		");
		sql.append("	,TEAM_NO = ?		");
		sql.append("WHERE SCH_NO = ?	 	");
		result = jdbcTemplate.update(sql.toString(), zone_no, team_no, sch_no);
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_researcher_popup.jsp?zone_no="+zone_no+"');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}
	}else if("disapproval".equals(mode)){
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_SCH_TB SET 	");
		sql.append("	 ZONE_NO = 0		");
		sql.append("	,TEAM_NO = 0		");
		sql.append("WHERE SCH_NO = ?	 	");
		result = jdbcTemplate.update(sql.toString(), sch_no);
		
		team_no = "0".equals(team_no)?"":team_no;
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_zone_list.jsp?zone_no="+zone_no+"&team_no="+team_no+"');");
			out.println("</script>");
		}
	}
	
}catch(Exception e){
	out.println(e.toString());
}

%>