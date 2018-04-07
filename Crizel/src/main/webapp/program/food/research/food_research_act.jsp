<%
/**
*   PURPOSE :   월별조사항목개시 - 액션
*   CREATE  :   20180405_thur    KO
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

String mode		= parseNull(request.getParameter("mode"));

int rsch_no				= Integer.parseInt(parseNull(request.getParameter("rsch_no"), "0"));
String rsch_nm 			= parseNull(request.getParameter("rsch_nm"));
String rsch_year 		= parseNull(request.getParameter("rsch_year"));
String rsch_month 		= parseNull(request.getParameter("rsch_month"));
String str_date 		= parseNull(request.getParameter("str_date"));
String mid_date 		= parseNull(request.getParameter("mid_date"));
String end_date 		= parseNull(request.getParameter("end_date"));
String[] cat_nm_arr 	= request.getParameterValues("cat_nm");					//	조사할 구분 
String[] team_no_arr	= request.getParameterValues("team_no");				// 	조사할 팀
int rsch_val_no 		= 0;
SessionManager sessionManager = new SessionManager(request);

String regIp = request.getRemoteAddr();
String regId = sessionManager.getId();

String returnPage 	= "food_research_job.jsp";

StringBuffer sql 			= null;
List<Object[]> batch 		= null;
Object[] value				= null;
int result 					= 0;
int cnt						= 0;

List<FoodVO> rschItemList = null;

try{
	if("researchStart".equals(mode)){
		// 조사가 진행중일 경우
		sql = new StringBuffer();
		sql.append("SELECT COUNT(*) AS CNT		");
		sql.append("FROM FOOD_RSCH_TB			");
		sql.append("WHERE STS_FLAG = 'N'		");
		cnt = jdbcTemplate.queryForObject(sql.toString(), Integer.class);
		if(cnt>0){
			out.println("<script>");
			out.println("alert('조사가 진행중입니다.');");
			out.println("opener.location.reload();");
			out.println("window.close();");
			out.println("</script>");
			return;
		}
		
		sql = new StringBuffer();
		sql.append("SELECT NVL(MAX(RSCH_NO)+1,1) AS RSCH_NO		");
		sql.append("FROM FOOD_RSCH_TB							");
		rsch_no = jdbcTemplate.queryForObject(sql.toString(), Integer.class);
		
		sql = new StringBuffer();
		sql.append("INSERT INTO FOOD_RSCH_TB(RSCH_NO, RSCH_NM, RSCH_YEAR, RSCH_MONTH		");
		sql.append("          , STR_DATE, MID_DATE, END_DATE, REG_ID, REG_IP				");
		sql.append("          , REG_DATE, MOD_DATE, SHOW_FLAG, STS_FLAG)					");
		sql.append("VALUES(																	");
		sql.append("    ?  																	");		// RSCH_NO
		sql.append("  , ?																	");		// RSCH_NM
		sql.append("  , ?, ?																");		// RSCH_YEAR, RSCH_MONTH
		sql.append("  , ?, ?, ?																");		// STR_DATE, MID_DATE, END_DATE
		sql.append("  , ? ,?																");		// REG_ID, REG_IP
		sql.append("  , SYSDATE, SYSDATE													");		// REG_DATE, MID_DATE
		sql.append("  , 'Y', 'N'															");		// SHOW_FLAG, STS_FLAG
		sql.append(")																		");
		result = jdbcTemplate.update(sql.toString(), 
					  rsch_no
					, rsch_nm
					, rsch_year, rsch_month
					, str_date, mid_date, end_date
					, regId, regId
				);
		
		if(cat_nm_arr!=null && cat_nm_arr.length>0){
			sql = new StringBuffer();
			sql.append("INSERT INTO FOOD_RSCH_CAT(RSCH_NO, CAT_NO)						");
			sql.append("VALUES(?, (SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ?)	) 	");
			batch = new ArrayList<Object[]>();
				for(String ob : cat_nm_arr){
					value = new Object[]{
							  rsch_no
							, ob
					};
					batch.add(value);
				}
			jdbcTemplate.batchUpdate(sql.toString(), batch);
		}
		
		if(team_no_arr!=null && team_no_arr.length>0){
			// 배정된 조사 팀
			sql = new StringBuffer();
			sql.append("INSERT INTO FOOD_RSCH_TEAM(RSCH_NO, TEAM_NO)	");
			sql.append("VALUES(?, ?)									");
			batch = new ArrayList<Object[]>();
			for(String ob : team_no_arr){
				value = new Object[]{
						  rsch_no
						, ob
				};
				batch.add(value);
			}
			jdbcTemplate.batchUpdate(sql.toString(), batch);
		}
		
		sql = new StringBuffer();
		sql.append("SELECT 																			");
		sql.append("  RSCH_ITEM_NO																	");
		sql.append("  , ITEM_NO																		");
		sql.append("  , SCH_NO																		");
		sql.append("  , NU_NO																		");
		sql.append("  , (SELECT TEAM_NO FROM FOOD_SCH_TB WHERE SCH_NO = A.SCH_NO) AS TEAM_NO		");
		sql.append("  , (SELECT CAT_NM FROM FOOD_ST_CAT WHERE CAT_NO = 								");
		sql.append("  		 (SELECT CAT_NO FROM FOOD_ST_ITEM WHERE ITEM_NO = A.ITEM_NO)) AS CAT_NM	");
		sql.append("  , FILE_NO																		");
		sql.append("  , REG_YEAR																	");
		sql.append("  , REG_MON																		");
		sql.append("FROM FOOD_RSCH_ITEM A															");
		sql.append("ORDER BY RSCH_ITEM_NO															");
		rschItemList = jdbcTemplate.query(sql.toString(), new FoodList());
		
		if(rschItemList!=null && rschItemList.size()>0){
			sql = new StringBuffer();
			sql.append("SELECT NVL(MAX(RSCH_VAL_NO)+1,1) FROM FOOD_RSCH_VAL		");
			rsch_val_no = jdbcTemplate.queryForObject(sql.toString(), Integer.class);
			 
			sql = new StringBuffer();
			sql.append("INSERT INTO FOOD_RSCH_VAL(		");
			sql.append("			  RSCH_VAL_NO		");
			sql.append("			, RSCH_NO			");
			sql.append("			, ITEM_NO			");
			sql.append("			, SCH_NO			");
			sql.append("			, CAT_NO			");
			sql.append("			, REG_DATE			");
			sql.append("		)						");
			sql.append("VALUES(							");
			sql.append("		?						");
			sql.append("		, ?						");
			sql.append("		, ?						");
			sql.append("		, ?						");
			sql.append("		, (SELECT CAT_NO 		");
			sql.append("		   FROM FOOD_ST_CAT 	");
			sql.append("		   WHERE CAT_NM = ?)	");
			sql.append("		, SYSDATE				");
			sql.append("		)						");
			batch = new ArrayList<Object[]>();
			boolean catCheck 	= false;
			boolean teamCheck 	= false;
			for(FoodVO ob : rschItemList){
				catCheck 	= false;
				teamCheck 	= false;
				
				for(String ob2 : cat_nm_arr){
					if(ob.cat_nm.equals(ob2)){
						catCheck = true;
					}
				}
				for(String ob2 : team_no_arr){
					if(ob.team_no.equals(ob2)){
						teamCheck = true;
					}
				}
				if(teamCheck && catCheck){
					value = new Object[]{
							rsch_val_no++
							, rsch_no
							, ob.item_no
							, ob.sch_no
							, ob.cat_nm.split("-")[0].trim()
					};
					batch.add(value);
				}
			}
			
			jdbcTemplate.batchUpdate(sql.toString(), batch);
			
		}

		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("opener.location.reload();");
			out.println("window.close();");
			out.println("</script>");
		}else{
			out.println("<script>alert('처리 중 오류가 발생하였습니다..');opener.location.reload();window.close();</script>");
		}
	}else if("researchUpdate".equals(mode)){
		
		// 조사내용 수정 시 기존 데이터는 삭제처리
		sql = new StringBuffer();
		sql.append("DELETE FROM FOOD_RSCH_TEAM WHERE RSCH_NO = ?	 ");
		jdbcTemplate.update(sql.toString(), rsch_no);
		sql = new StringBuffer();
		sql.append("DELETE FROM FOOD_RSCH_CAT WHERE RSCH_NO = ?	 	");
		jdbcTemplate.update(sql.toString(), rsch_no);
		sql = new StringBuffer();
		sql.append("DELETE FROM FOOD_RSCH_VAL WHERE RSCH_NO = ?	 	");
		jdbcTemplate.update(sql.toString(), rsch_no);
		
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_RSCH_TB SET RSCH_NM 	= ?						");
		sql.append("					,	RSCH_YEAR 	= ?						");
		sql.append("					,	RSCH_MONTH 	= ?						");
		sql.append("					,	STR_DATE 	= ?						");
		sql.append("					,	MID_DATE 	= ?						");
		sql.append("					,	END_DATE 	= ?						");
		sql.append("					,	REG_ID 		= ?						");
		sql.append("					,	REG_IP 		= ?						");
		sql.append("					,	REG_DATE 	= SYSDATE				");
		sql.append("					,	MOD_DATE 	= SYSDATE				");
		sql.append("					,	SHOW_FLAG 	= 'Y'					");
		sql.append("					,	STS_FLAG 	= 'N'					");
		sql.append("WHERE RSCH_NO = ?											");
		result = jdbcTemplate.update(sql.toString(), 
					  rsch_nm
					, rsch_year, rsch_month
					, str_date, mid_date, end_date
					, regId, regIp
					, rsch_no
				);
		
		if(cat_nm_arr!=null && cat_nm_arr.length>0){
			sql = new StringBuffer();
			sql.append("INSERT INTO FOOD_RSCH_CAT(RSCH_NO, CAT_NO)						");
			sql.append("VALUES(?, (SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ?)	) 	");
			batch = new ArrayList<Object[]>();
				for(String ob : cat_nm_arr){
					value = new Object[]{
							  rsch_no
							, ob
					};
					batch.add(value);
				}
			jdbcTemplate.batchUpdate(sql.toString(), batch);
		}
		
		if(team_no_arr!=null && team_no_arr.length>0){
			// 배정된 조사 팀
			sql = new StringBuffer();
			sql.append("INSERT INTO FOOD_RSCH_TEAM(RSCH_NO, TEAM_NO)	");
			sql.append("VALUES(?, ?)									");
			batch = new ArrayList<Object[]>();
			for(String ob : team_no_arr){
				value = new Object[]{
						  rsch_no
						, ob
				};
				batch.add(value);
			}
			jdbcTemplate.batchUpdate(sql.toString(), batch);
		}
		
		sql = new StringBuffer();
		sql.append("SELECT 																			");
		sql.append("  RSCH_ITEM_NO																	");
		sql.append("  , ITEM_NO																		");
		sql.append("  , SCH_NO																		");
		sql.append("  , NU_NO																		");
		sql.append("  , (SELECT TEAM_NO FROM FOOD_SCH_TB WHERE SCH_NO = A.SCH_NO) AS TEAM_NO		");
		sql.append("  , (SELECT CAT_NM FROM FOOD_ST_CAT WHERE CAT_NO = 								");
		sql.append("  		 (SELECT CAT_NO FROM FOOD_ST_ITEM WHERE ITEM_NO = A.ITEM_NO)) AS CAT_NM	");
		sql.append("  , FILE_NO																		");
		sql.append("  , REG_YEAR																	");
		sql.append("  , REG_MON																		");
		sql.append("FROM FOOD_RSCH_ITEM A															");
		sql.append("ORDER BY RSCH_ITEM_NO															");
		rschItemList = jdbcTemplate.query(sql.toString(), new FoodList());
		
		if(rschItemList!=null && rschItemList.size()>0){
			sql = new StringBuffer();
			sql.append("SELECT NVL(MAX(RSCH_VAL_NO)+1,1) FROM FOOD_RSCH_VAL		");
			rsch_val_no = jdbcTemplate.queryForObject(sql.toString(), Integer.class);
			
			sql = new StringBuffer();
			sql.append("INSERT INTO FOOD_RSCH_VAL(		");
			sql.append("			  RSCH_VAL_NO		");
			sql.append("			, RSCH_NO			");
			sql.append("			, ITEM_NO			");
			sql.append("			, SCH_NO			");
			sql.append("			, CAT_NO			");
			sql.append("			, REG_DATE			");
			sql.append("		)						");
			sql.append("VALUES(							");
			sql.append("		?						");
			sql.append("		, ?						");
			sql.append("		, ?						");
			sql.append("		, ?						");
			sql.append("		, (SELECT CAT_NO 		");
			sql.append("		   FROM FOOD_ST_CAT 	");
			sql.append("		   WHERE CAT_NM = ?)	");
			sql.append("		, SYSDATE				");
			sql.append("		)						");
			batch = new ArrayList<Object[]>();
			boolean catCheck 	= false;
			boolean teamCheck 	= false;
			for(FoodVO ob : rschItemList){
				catCheck 	= false;
				teamCheck 	= false;
				
				for(String ob2 : cat_nm_arr){
					if(ob.cat_nm.equals(ob2)){
						catCheck = true;
					}
				}
				for(String ob2 : team_no_arr){
					if(ob.team_no.equals(ob2)){
						teamCheck = true;
					}
				}
				if(teamCheck && catCheck){
					value = new Object[]{
							rsch_val_no++
							, rsch_no
							, ob.item_no
							, ob.sch_no
							, ob.cat_nm.split("-")[0].trim()
					};
					batch.add(value);
				}
			}
			
			jdbcTemplate.batchUpdate(sql.toString(), batch);
			
		}
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("opener.location.reload();");
			out.println("window.close();");
			out.println("</script>");
		}else{
			out.println("<script>alert('처리 중 오류가 발생하였습니다.');opener.location.reload();window.close();</script>");
		}
	}else if("researchCom".equals(mode)){
		// 조사 완료
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_RSCH_TB SET STS_FLAG = 'Y'			");
		sql.append("WHERE RSCH_NO = ?								");
		result = jdbcTemplate.update(sql.toString(), rsch_no);
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('" + returnPage + "');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}else{
			out.println("<script>alert('처리 중 오류가 발생하였습니다.');location.replace('" + returnPage + "');</script>");
		}
	}else if("researchCan".equals(mode)){
		// 조사 취소
		sql = new StringBuffer();
		sql.append("DELETE FROM FOOD_RSCH_TEAM WHERE RSCH_NO = ?	 ");
		jdbcTemplate.update(sql.toString(), rsch_no);
		sql = new StringBuffer();
		sql.append("DELETE FROM FOOD_RSCH_CAT WHERE RSCH_NO = ?	 	");
		jdbcTemplate.update(sql.toString(), rsch_no);
		sql = new StringBuffer();
		sql.append("DELETE FROM FOOD_RSCH_VAL WHERE RSCH_NO = ?	 	");
		jdbcTemplate.update(sql.toString(), rsch_no);
		sql = new StringBuffer();
		sql.append("DELETE FROM FOOD_RSCH_TB WHERE RSCH_NO = ?	 	");
		result = jdbcTemplate.update(sql.toString(), rsch_no);
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('" + returnPage + "');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}else{
			out.println("<script>alert('처리 중 오류가 발생하였습니다.');location.replace('" + returnPage + "');</script>");
		}
	}
	
}catch(Exception e){
	
	if("researchStart".equals(mode) || "researchUpdate".equals(mode)){
		out.println("<script>alert('처리 중 오류가 발생하였습니다.');opener.location.reload();window.close();</script>");
	}else{
		out.println("<script>alert('처리 중 오류가 발생하였습니다.');location.replace('" + returnPage + "');</script>");
	}
	out.println(e.toString());
}

%>