<%
/**
*   PURPOSE :   권역 - 액션
*   CREATE  :   20180403_tue    KO
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

String zone_no	= parseNull(request.getParameter("zone_no"));
String cat_no	= parseNull(request.getParameter("cat_no"));
String team_no	= parseNull(request.getParameter("team_no"));

String zone_nm	= parseNull(request.getParameter("zone_nm"));
String cat_nm	= parseNull(request.getParameter("cat_nm"));
String team_nm	= parseNull(request.getParameter("team_nm"));
String jo_nm	= parseNull(request.getParameter("jo_nm"));

String update_type 	= parseNull(request.getParameter("update_type"));
String update_no 	= parseNull(request.getParameter("update_no"));
String update_nm 	= parseNull(request.getParameter("update_nm"));

StringBuffer sql 	= null;
int result 			= 0;
int cnt				= 0;

try{
	if("zoneInsert".equals(mode)){
		// 권역명 중복체크
		sql = new StringBuffer();
		sql.append("SELECT COUNT(*) AS CNT FROM FOOD_ZONE WHERE ZONE_NM = ? AND SHOW_FLAG = 'Y'		");
		cnt = jdbcTemplate.queryForObject(sql.toString(), Integer.class, zone_nm);
		
		if(cnt>0){
			out.println("<script>alert('권역명이 중복되었습니다.');location.replace('food_zone_popup.jsp');</script>");
			return;
		}
		
		// 권역 추가
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
			out.println("location.replace('food_zone_popup.jsp');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}else{
			out.println("<script>alert('처리 중 오류가 발생하였습니다.');location.replace('food_zone_popup.jsp');</script>");
		}
		
	}else if("zoneDelete".equals(mode)){
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_ZONE SET 	");
		sql.append("	SHOW_FLAG = 'N'		");
		sql.append("WHERE ZONE_NO = ?	 	");
		result = jdbcTemplate.update(sql.toString(), update_no);

		// 해당 권역 하위에 팀이 있는지 확인
		sql = new StringBuffer();
		sql.append("SELECT COUNT(*) AS CNT FROM FOOD_TEAM WHERE ZONE_NO = ?		");
		cnt = jdbcTemplate.queryForObject(sql.toString(), Integer.class, update_no);
		
		// 권역 하위에 팀이 있을 경우 하위 팀도 삭제
		if(cnt > 0){
			sql = new StringBuffer();
			sql.append("UPDATE FOOD_TEAM SET 	");
			sql.append("	SHOW_FLAG = 'N'		");
			sql.append("WHERE ZONE_NO = ?	 	");
			result = jdbcTemplate.update(sql.toString(), update_no);
			
			sql = new StringBuffer();
			sql.append("UPDATE FOOD_SCH_TB SET 	");
			sql.append("	  ZONE_NO = 0		");
			sql.append("	, TEAM_NO = 0		");
			sql.append("WHERE ZONE_NO = ?	 	");
			result = jdbcTemplate.update(sql.toString(), update_no);
			
			// 해당 팀 하위에 조가 있는지 확인
			sql = new StringBuffer();
			sql.append("SELECT COUNT(*) AS CNT 					");
			sql.append("FROM FOOD_JO							");
			sql.append("WHERE TEAM_NO IN (SELECT TEAM_NO		"); 
			sql.append("				  FROM FOOD_TEAM 		");
			sql.append("				  WHERE ZONE_NO = ?)	");
			cnt = jdbcTemplate.queryForObject(sql.toString(), Integer.class, update_no);
			
			// 팀 하위에 조가 있을 경우 하위 조도 삭제
			if(cnt>0){
				sql = new StringBuffer();
				sql.append("DELETE FROM FOOD_JO 		");
				sql.append("WHERE TEAM_NO IN (SELECT TEAM_NO		"); 
				sql.append("				  FROM FOOD_TEAM 		");
				sql.append("				  WHERE ZONE_NO = ?)	");
				result = jdbcTemplate.update(sql.toString(), update_no);
			}
		}
		
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_zone_popup.jsp');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}else{
			out.println("<script>alert('처리 중 오류가 발생하였습니다.');location.replace('food_zone_popup.jsp');</script>");
		}
	}else if("zoneUpdate".equals(mode)){
		// 권역명 중복체크
		sql = new StringBuffer();
		sql.append("SELECT COUNT(*) AS CNT FROM FOOD_ZONE WHERE ZONE_NM = ? AND SHOW_FLAG = 'Y'		");
		cnt = jdbcTemplate.queryForObject(sql.toString(), Integer.class, update_nm);
		
		if(cnt>0){
			out.println("<script>alert('권역명이 중복되었습니다.');location.replace('food_zone_popup.jsp');</script>");
			return;
		}
		
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_ZONE SET ZONE_NM = ? WHERE ZONE_NO = ?		");
		result = jdbcTemplate.update(sql.toString(), update_nm, update_no);
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_zone_popup.jsp');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}else{
			out.println("<script>alert('처리 중 오류가 발생하였습니다.');location.replace('food_zone_popup.jsp');</script>");
		}
		
	}else if("teamInsert".equals(mode)){
		// 팀명 중복체크
		sql = new StringBuffer();
		sql.append("SELECT COUNT(*) AS CNT FROM FOOD_TEAM WHERE TEAM_NM = ? AND SHOW_FLAG = 'Y'		");
		sql.append("AND ZONE_NO = ? AND CAT_NO = ?													");
		cnt = jdbcTemplate.queryForObject(sql.toString(), Integer.class, team_nm, zone_no, cat_no);
		
		if(cnt>0){
			out.println("<script>alert('팀명이 중복되었습니다.');location.replace('food_zone_popup.jsp');</script>");
			return;
		}
		
		sql = new StringBuffer();
		sql.append("INSERT INTO FOOD_TEAM(	TEAM_NO, ZONE_NO, CAT_NO, TEAM_NM, REG_DATE, MOD_DATE,			");
		sql.append("						SHOW_FLAG, ORDER1, ORDER2, ORDER3	)							");
		sql.append("VALUES(																					");
		sql.append("	(SELECT NVL(MAX(TEAM_NO)+1,1) FROM FOOD_TEAM),										");	// TEAM_NO
		sql.append("	?,																					");	// ZONE_NO
		sql.append("	?,																					");	// CAT_NO
		sql.append("	?,																					");	// TEAM_NM
		sql.append("	SYSDATE,																			");	// REG_DATE
		sql.append("	SYSDATE,																			");	// MOD_DATE
		sql.append("	'Y',																				");	// SHOW_FLAG
		sql.append("	(SELECT NVL(MAX(ORDER1)+1,1) FROM FOOD_TEAM WHERE ZONE_NO = ? AND SHOW_FLAG = 'Y'),	");	// ORDER1
		sql.append("	0,																					");	// ORDER2
		sql.append("	0																					");	// ORDER3
		sql.append(")																						");
		result = jdbcTemplate.update(sql.toString(), zone_no, cat_no, team_nm, zone_no);
		
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_zone_popup.jsp');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}else{
			out.println("<script>alert('처리 중 오류가 발생하였습니다.');location.replace('food_zone_popup.jsp');</script>");
		}
		
	}else if("teamUpdate".equals(mode)){
		// 팀명 중복체크
		sql = new StringBuffer();
		sql.append("SELECT COUNT(*) AS CNT FROM FOOD_TEAM WHERE TEAM_NM = ?	AND SHOW_FLAG = 'Y'			");
		sql.append("AND ZONE_NO = (SELECT ZONE_NO FROM FOOD_TEAM WHERE TEAM_NO = ?)						");
		cnt = jdbcTemplate.queryForObject(sql.toString(), Integer.class, update_nm, update_no);
		
		if(cnt>0){
			out.println("<script>alert('팀명이 중복되었습니다.');location.replace('food_zone_popup.jsp');</script>");
			return;
		}
		
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_TEAM SET TEAM_NM = ? WHERE TEAM_NO = ?		");
		result = jdbcTemplate.update(sql.toString(), update_nm, update_no);
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_zone_popup.jsp');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}else{
			out.println("<script>alert('처리 중 오류가 발생하였습니다.');location.replace('food_zone_popup.jsp');</script>");
		}
		
	}else if("teamDelete".equals(mode)){
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_TEAM SET 	");
		sql.append("	SHOW_FLAG = 'N'		");
		sql.append("WHERE TEAM_NO = ?	 	");
		result = jdbcTemplate.update(sql.toString(), update_no);
		
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_SCH_TB SET 	");
		sql.append("	TEAM_NO = 0			");
		sql.append("WHERE TEAM_NO = ?	 	");
		result = jdbcTemplate.update(sql.toString(), update_no);
		
		// 해당 팀 하위에 조가 있는지 확인
		sql = new StringBuffer();
		sql.append("SELECT COUNT(*) FROM FOOD_JO WHERE TEAM_NO = ?		");
		cnt = jdbcTemplate.queryForObject(sql.toString(), Integer.class, update_no);
		
		if(cnt>0){
			// 팀 하위에 조가 있을경우 삭제
			sql = new StringBuffer();
			sql.append("DELETE FROM FOOD_JO WHERE TEAM_NO = ?	");
			result = jdbcTemplate.update(sql.toString(), update_no);
		}
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_zone_popup.jsp');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}else{
			out.println("<script>alert('처리 중 오류가 발생하였습니다.');location.replace('food_zone_popup.jsp');</script>");
		}
	}else if("joInsert".equals(mode)){
		// 조명 중복체크
		sql = new StringBuffer();
		sql.append("SELECT COUNT(*) AS CNT FROM FOOD_JO WHERE JO_NM = ? 	");
		sql.append("AND TEAM_NO = ?											");
		cnt = jdbcTemplate.queryForObject(sql.toString(), Integer.class, jo_nm, team_no);
		
		if(cnt>0){
			out.println("<script>alert('조명이 중복되었습니다.');location.replace('food_zone_popup.jsp');</script>");
			return;
		}
		
		sql = new StringBuffer();
		sql.append("INSERT INTO FOOD_JO(	  JO_NO, TEAM_NO, JO_NM, REG_DATE, MOD_DATE						");
		sql.append("						, ORDER1, ORDER2, ORDER3	)									");
		sql.append("VALUES(																					");
		sql.append("	(SELECT NVL(MAX(JO_NO)+1,1) FROM FOOD_JO),											");	// JO_NO
		sql.append("	?,																					");	// TEAM_NO
		sql.append("	?,																					");	// JO_NM
		sql.append("	SYSDATE,																			");	// REG_DATE
		sql.append("	SYSDATE,																			");	// MOD_DATE
		sql.append("	(SELECT NVL(MAX(ORDER1)+1,1) FROM FOOD_JO WHERE TEAM_NO = ?),						");	// ORDER1
		sql.append("	0,																					");	// ORDER2
		sql.append("	0																					");	// ORDER3
		sql.append(")																						");
		result = jdbcTemplate.update(sql.toString(), team_no, jo_nm, team_no);
		
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_zone_popup.jsp');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}else{
			out.println("<script>alert('처리 중 오류가 발생하였습니다.');location.replace('food_zone_popup.jsp');</script>");
		}
		
	}else if("joUpdate".equals(mode)){
		// 조명 중복체크
		sql = new StringBuffer();
		sql.append("SELECT COUNT(*) AS CNT FROM FOOD_JO WHERE JO_NM = ?				");
		sql.append("AND TEAM_NO = (SELECT TEAM_NO FROM FOOD_JO WHERE JO_NO = ?)		");
		cnt = jdbcTemplate.queryForObject(sql.toString(), Integer.class, update_nm, update_no);
		
		if(cnt>0){
			out.println("<script>alert('조명이 중복되었습니다.');location.replace('food_zone_popup.jsp');</script>");
			return;
		}
		
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_JO SET JO_NM = ? WHERE JO_NO = ?		");
		result = jdbcTemplate.update(sql.toString(), update_nm, update_no);
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_zone_popup.jsp');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}else{
			out.println("<script>alert('처리 중 오류가 발생하였습니다.');location.replace('food_zone_popup.jsp');</script>");
		}
	}else if("joDelete".equals(mode)){
		sql = new StringBuffer();
		sql.append("DELETE FROM FOOD_JO WHERE JO_NO = ?		");
		result = jdbcTemplate.update(sql.toString(), update_no);
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_zone_popup.jsp');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}else{
			out.println("<script>alert('처리 중 오류가 발생하였습니다.');location.replace('food_zone_popup.jsp');</script>");
		}
	}
	
}catch(Exception e){
	out.println(e.toString());
}

%>