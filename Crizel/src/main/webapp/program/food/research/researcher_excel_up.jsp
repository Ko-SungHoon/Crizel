<%@page import="egovframework.rfc3.user.web.SessionManager"%>
<%
/**
*   PURPOSE :   조사자(팀장) 엑셀 업로드
*   CREATE  :   20180403_tue    KO
*	MODIFY  :   batch 방식 변경 20180424_tue    KO
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ page import="java.io.File, java.io.IOException, com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.Enumeration"%>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");

SessionManager sessionManager = new SessionManager(request);

	String root = request.getSession().getServletContext().getRealPath("/");
	String directory = "/upload_data/food/";
	MultipartRequest mr = new MultipartRequest(request, root+directory, 10*1024*1024, "UTF-8", new DefaultFileRenamePolicy());
	
	Enumeration files = mr.getFileNames();
	String fileName = "";
	String realFile = "";
	String saveFile = "";
	String fileExt	= "";
	
	File file = null;
	List<Map<String,Object>> excelList = null;
	
	while(files.hasMoreElements()){
		fileName = (String)files.nextElement();
		file = mr.getFile(fileName);
		realFile = mr.getOriginalFileName(fileName);
		saveFile = mr.getFilesystemName(fileName);
		
		//excelList = getExcelRead(file, 1);
		
		fileExt = realFile.split("\\.")[1];

		if("xls".equals(fileExt)){
			excelList = getExcelRead(file, 2);
		}else if("xlsx".equals(fileExt)){
			//excelList = getExcelRead2(file, 2);
		}
	}
	
	Connection conn 			= null;
	PreparedStatement pstmt 	= null;
	int key						= 0;
	StringBuffer sql 			= null;
	List<Object[]> batch 		= null;
	List<Object> setList 		= null;			
	Object[] value				= null;	
	List<String> itemNoList 	= null;
	int cnt = 0;
	int result = 0;
	
	int cat_no 		= 0;	// cat_no 최대값
	int nm_no		= 0;	// nm_no 최대값
	int dt_no		= 0;	// dt_no 최대값
	int ex_no		= 0;	// ex_no 최대값
	int unit_no		= 0;	// unit_no 최대값
	int item_no 	= 0;	// item_no 최대값
	int item_pre_no = 0;	// item_no 최대값(FOOD_ST_ITEM_PRE)
	
	String[] cat_nm_arr = mr.getParameterValues("cat_nm");				//	조사할 구분 
	String rsch_year 	= parseNull(mr.getParameter("rsch_year"));		// 	조사 년
	String rsch_month 	= parseNull(mr.getParameter("rsch_month"));		//	조사 월
	String str_date 	= parseNull(mr.getParameter("str_date"));		//	조사 시작 년월일
	String mid_date 	= parseNull(mr.getParameter("mid_date"));		//	조사 중간 년월일
	String end_date 	= parseNull(mr.getParameter("end_date"));		//	조사 종료 년월일
	String rsch_nm 		= parseNull(mr.getParameter("rsch_nm"));		//	조사명
	
	String nm_food_str 	= "";	
	String dt_nm_str 	= "";
	String ex_nm_str 	= "";
	
	List<String> schList 	= new ArrayList<String>();
	List<String> areaList	= new ArrayList<String>();
	List<FoodVO> areaList_t	= null;
	int zone_no 		= 0;
	int team_no			= 0;
	int jo_no			= 0;
	String sch_grade 	= "";
	
	//SessionManager sessionManager = new SessionManager(request);
	
	String regIp = request.getRemoteAddr();
	String regId = sessionManager.getId();
	
	String[] nm_food 	= null;
	String[] dt_nm		= null;
	String[] ex_nm		= null;
	
	String returnPage = "food_research_list.jsp";
	
	String zoneCell 	= "cell1";		// 권역 셀	(50byte)
	String catCell		= "cell2";		// 구분 셀 (50 byte)
	String teamCell		= "cell3";		// 팀 셀 (100 byte)
	String joCell		= "cell4";		// 조 셀 (100 byte)
	String areaCell		= "cell6";		// 지역 셀 (128 byte)
	String schCell		= "cell7";		// 학교 셀 (100 byte)
	String gradeCell	= "cell9";		// 등급 셀 
	
	Map<String,Object> catMap 			= null;
	List<Map<String,Object>> catList 	= new ArrayList<Map<String,Object>>();

%>

<%!
public boolean getException(Map<String,Object> ob, String cell, int length){
	byte[] b = ob.get(cell).toString().getBytes();
	if(b.length>length){return true;}
	else{return false;}
}
%>
<%
	try{
		if(excelList!=null && excelList.size()>0){
			for(Map<String,Object> ob : excelList){
				// 학교명을 리스트에 저장
				schList.add(ob.get(schCell).toString().trim());
				areaList.add(ob.get(areaCell).toString().trim());
				
				// DB 데이터 길이보다 글자가 많을 때 오류처리
				if(getException(ob, zoneCell, 50)){out.println("<script>alert('권역명 값이 너무 큽니다');location.replace('"+returnPage+"');</script>"); return;}
				if(getException(ob, catCell, 50)){out.println("<script>alert('품목 값이 너무 큽니다');location.replace('"+returnPage+"');</script>"); return;}
				if(getException(ob, teamCell, 100)){out.println("<script>alert('팀 값이 너무 큽니다');location.replace('"+returnPage+"');</script>"); return;}
				if(getException(ob, joCell, 100)){out.println("<script>alert('조 값이 너무 큽니다');location.replace('"+returnPage+"');</script>"); return;}
				if(getException(ob, areaCell, 128)){out.println("<script>alert('지역 값이 너무 큽니다');location.replace('"+returnPage+"');</script>"); return;}
				if(getException(ob, schCell, 1000)){out.println("<script>alert('학교 값이 너무 큽니다');location.replace('"+returnPage+"');</script>"); return;}
				
				// 모든셀이 빈칸이 아니면서 필수입력값 데이터가 비어있을 경우 오류처리
				if(!(   "".equals(ob.get(zoneCell).toString().trim()) 	&& "".equals(ob.get(catCell).toString().trim())
					&& 	"".equals(ob.get(teamCell).toString().trim()) 	&& "".equals(ob.get(joCell).toString().trim())
					&& 	"".equals(ob.get(areaCell).toString().trim())  && 	"".equals(ob.get(schCell).toString().trim())
					&& 	"".equals(ob.get(gradeCell).toString().trim())	)){
					if("".equals(ob.get(zoneCell).toString().trim())){ out.println("<script>alert('권역 데이터가 비어있습니다.');location.replace('"+returnPage+"');</script>"); return;}
					if("".equals(ob.get(catCell).toString().trim())){out.println("<script>alert('구분 데이터가 비어있습니다.');location.replace('"+returnPage+"');</script>"); return;}
					if("".equals(ob.get(teamCell).toString().trim())){out.println("<script>alert('팀 데이터가 비어있습니다.');location.replace('"+returnPage+"');</script>"); return;}
					if("".equals(ob.get(joCell).toString().trim())){out.println("<script>alert('조 데이터가 비어있습니다.');location.replace('"+returnPage+"');</script>"); return;}
					if("".equals(ob.get(areaCell).toString().trim())){out.println("<script>alert('지역 데이터가 비어있습니다.');location.replace('"+returnPage+"');</script>"); return;}
					if("".equals(ob.get(schCell).toString().trim())){out.println("<script>alert('학교 데이터가 비어있습니다.');location.replace('"+returnPage+"');</script>"); return;}
					if("".equals(ob.get(gradeCell).toString().trim())){out.println("<script>alert('등급 데이터가 비어있습니다.');location.replace('"+returnPage+"');</script>"); return;}
				}
			}
			
			// 학교명이 중복될 경우 오류처리
			for(int i=0; i<schList.size(); i++){
				for(int j=i+1; j<schList.size(); j++){
					if(schList.get(i).equals(schList.get(j)) && areaList.get(i).equals(areaList.get(j))){
						out.println("<script>");
						out.println("alert('학교명이 중복됩니다.\\n"+schList.get(i)+"');");
						out.println("location.replace('"+returnPage+"');");
						out.println("</script>");
						return;
					}
				}
			}
		}
		
		sqlMapClient.startTransaction();
		conn = sqlMapClient.getCurrentConnection();
		
		// FOOD_AREA에 저장된 지역명과 엑셀의 지역명이 일치하는지 확인
		
		sql = new StringBuffer();
		sql.append("SELECT * FROM FOOD_AREA WHERE SHOW_FLAG = 'Y' 	");
		areaList_t = jdbcTemplate.query(sql.toString(), new FoodList());
		
		if(excelList!=null && excelList.size()>0){
			for(Map<String,Object> ob : excelList){
				cnt = 0;
				for(FoodVO ob2 : areaList_t){
					if(ob.get(areaCell).toString().trim().equals(ob2.area_nm)){
						cnt++;
					}
				}
				if(cnt == 0){
					out.println("<script>");
					out.println("alert('지역명을 확인하여 주시기 바랍니다.\\n"+ob.get(areaCell).toString().trim()+"');");
					out.println("location.replace('"+returnPage+"');");
					out.println("</script>");
					sqlMapClient.endTransaction();
					return;
				}
			}
		}
		
		 	
		
		if("".equals(regId)){
			out.println("<script>");
			out.println("alert('로그인 후 다시 시도 하십시오.');");
			out.println("location.replace('"+returnPage+"');");
			out.println("</script>");
		}
		
		// 조사가 진행중일 경우
		sql = new StringBuffer();
		sql.append("SELECT COUNT(*) AS CNT		");
		sql.append("FROM FOOD_RSCH_TB			");
		sql.append("WHERE STS_FLAG = 'N'		");
		cnt = jdbcTemplate.queryForObject(sql.toString(), Integer.class);
		if(cnt>0){
			out.println("<script>");
			out.println("alert('조사가 진행중입니다.');");
			out.println("location.replace('" + returnPage + "');");
			out.println("</script>");
			sqlMapClient.endTransaction();
			return;
		}
		
		// 업로드한 파일 정보 
		sql = new StringBuffer();
		sql.append("INSERT INTO FOOD_UP_FILE(									");
		sql.append("	  FILE_NO												");
		sql.append("	, FILE_NM												");
		sql.append("	, FILE_ORG_NM											");
		sql.append("	, REG_DATE												");
		sql.append("	, MOD_DATE												");
		sql.append("	, REG_IP												");
		sql.append("	, REG_ID												");
		sql.append("	, SUC_FLAG												");
		sql.append("	, FAIL_REASON											");
		sql.append("	, FILE_TYPE												");
		sql.append(")															");
		sql.append("VALUES(														");
		sql.append("	  (SELECT NVL(MAX(FILE_NO)+1, 1) FROM FOOD_UP_FILE)		");	// FILE_NO
		sql.append("	, ?														"); // FILE_NM
		sql.append("	, ?														"); // FILE_ORG_NM
		sql.append("	, SYSDATE												"); // REG_DATE
		sql.append("	, SYSDATE												"); // MOD_DATE
		sql.append("	, ?														"); // REG_IP
		sql.append("	, ?														"); // REG_ID
		sql.append("	, 'Y'													"); // SUC_FLAG
		sql.append("	, ''													"); // FAIL_REASON
		sql.append("	, 'F'													"); // FILE_TYPE
		sql.append(")															");
		result = jdbcTemplate.update(sql.toString(), saveFile, realFile, regIp, regId);
		
		// 권역 추가
		if(excelList!=null && excelList.size()>0){
			sql = new StringBuffer();
			sql.append("SELECT NVL(MAX(ZONE_NO)+1,1) FROM FOOD_ZONE		");
			zone_no = jdbcTemplate.queryForObject(sql.toString(), Integer.class);
		
			sql = new StringBuffer();
			sql.append("MERGE INTO FOOD_ZONE USING DUAL									");
			sql.append("	ON(ZONE_NM = ? AND SHOW_FLAG = 'Y')							");
			sql.append("	WHEN NOT MATCHED THEN										");
			sql.append("	INSERT(ZONE_NO, ZONE_NM, REG_DATE, MOD_DATE, SHOW_FLAG)		");
			sql.append("	VALUES(?, ?, SYSDATE, SYSDATE, 'Y')							");
			pstmt = conn.prepareStatement(sql.toString());
			for(Map<String,Object> ob : excelList){
				key = 0;
				pstmt.setString(++key,  ob.get(zoneCell).toString().trim());
				pstmt.setInt(++key,  zone_no++);
				pstmt.setString(++key,  ob.get(zoneCell).toString().trim());
				pstmt.addBatch();
			}
			pstmt.executeBatch();
			if(pstmt!=null){pstmt.close();}

			/* batch = new ArrayList<Object[]>();
			for(Map<String,Object> ob : excelList){
				value = new Object[]{
						ob.get(zoneCell).toString().trim()
						, zone_no++
						, ob.get(zoneCell).toString().trim()
				};
				batch.add(value);
			}
			jdbcTemplate.batchUpdate(sql.toString(), batch); */
		}
		
		// 품목 추가
		if(excelList!=null && excelList.size()>0){
			sql = new StringBuffer();
			sql.append("SELECT NVL(MAX(CAT_NO)+1,1) FROM FOOD_ST_CAT		");
			cat_no = jdbcTemplate.queryForObject(sql.toString(), Integer.class);
		
			sql = new StringBuffer();
			sql.append("MERGE INTO FOOD_ST_CAT USING DUAL								");
			sql.append("	ON(CAT_NM = ? AND SHOW_FLAG = 'Y')							");
			sql.append("	WHEN NOT MATCHED THEN										");
			sql.append("	INSERT(CAT_NO, CAT_NM, REG_DATE, MOD_DATE, SHOW_FLAG)		");
			sql.append("	VALUES(?, ?, SYSDATE, SYSDATE, 'Y')							");
			pstmt = conn.prepareStatement(sql.toString());
			for(Map<String,Object> ob : excelList){
				key = 0;
				pstmt.setString(++key,  ob.get(catCell).toString().trim());
				pstmt.setInt(++key,  cat_no++);
				pstmt.setString(++key,  ob.get(catCell).toString().trim());
				pstmt.addBatch();
			}
			pstmt.executeBatch();
			if(pstmt!=null){pstmt.close();}

			/* batch = new ArrayList<Object[]>();
			for(Map<String,Object> ob : excelList){
				value = new Object[]{
						ob.get(catCell).toString().trim()
						, cat_no++
						, ob.get(catCell).toString().trim()
				};
				batch.add(value);
			}
			jdbcTemplate.batchUpdate(sql.toString(), batch); */
		}
		
		// 팀 추가
		if(excelList!=null && excelList.size()>0){
			sql = new StringBuffer();
			sql.append("SELECT NVL(MAX(TEAM_NO)+1,1) FROM FOOD_TEAM		");
			team_no = jdbcTemplate.queryForObject(sql.toString(), Integer.class);
		
			sql = new StringBuffer();
			sql.append("MERGE INTO FOOD_TEAM USING DUAL																			");
			sql.append("	ON(TEAM_NM = ? AND SHOW_FLAG = 'Y'																	");
			sql.append("		AND ZONE_NO = (SELECT ZONE_NO FROM FOOD_ZONE WHERE ZONE_NM = ? AND SHOW_FLAG = 'Y')				");
			sql.append("		AND CAT_NO = (SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ? AND SHOW_FLAG = 'Y'))				");
			sql.append("	WHEN NOT MATCHED THEN																				");
			sql.append("	INSERT(TEAM_NO, ZONE_NO, CAT_NO, TEAM_NM, REG_DATE, MOD_DATE, SHOW_FLAG, ORDER1)					");
			sql.append("	VALUES(?																							");
			sql.append("		, (SELECT ZONE_NO FROM FOOD_ZONE WHERE ZONE_NM = ? AND SHOW_FLAG = 'Y')							");
			sql.append("		, (SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ? AND SHOW_FLAG = 'Y')							");
			sql.append("		, ?, SYSDATE, SYSDATE, 'Y'																		");
			sql.append("		, (SELECT NVL(MAX(ORDER1)+1,1) 																	");
			sql.append("			FROM FOOD_TEAM 																				");
			sql.append("			WHERE ZONE_NO = (SELECT ZONE_NO FROM FOOD_ZONE WHERE ZONE_NM = ? AND SHOW_FLAG = 'Y')		");
			sql.append("				AND CAT_NO = (SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ? AND SHOW_FLAG = 'Y')		");
			sql.append("				AND SHOW_FLAG = 'Y')	)																");
			pstmt = conn.prepareStatement(sql.toString());
			for(Map<String,Object> ob : excelList){
				key = 0;
				pstmt.setString(++key,  ob.get(teamCell).toString().trim());
				pstmt.setString(++key,  ob.get(zoneCell).toString().trim());
				pstmt.setString(++key,  ob.get(catCell).toString().trim());
				pstmt.setInt(++key,  team_no++);
				pstmt.setString(++key,  ob.get(zoneCell).toString().trim());
				pstmt.setString(++key,  ob.get(catCell).toString().trim());
				pstmt.setString(++key,  ob.get(teamCell).toString().trim());
				pstmt.setString(++key,  ob.get(zoneCell).toString().trim());
				pstmt.setString(++key,  ob.get(catCell).toString().trim());
				pstmt.addBatch();
			}
			pstmt.executeBatch();
			if(pstmt!=null){pstmt.close();}

			/* batch = new ArrayList<Object[]>();
			for(Map<String,Object> ob : excelList){
				value = new Object[]{
						ob.get(teamCell).toString().trim()
						, ob.get(zoneCell).toString().trim()
						, ob.get(catCell).toString().trim()
						
						, team_no++
						, ob.get(zoneCell).toString().trim()
						, ob.get(catCell).toString().trim()
						, ob.get(teamCell).toString().trim()
						, ob.get(zoneCell).toString().trim()
						, ob.get(catCell).toString().trim()
				};
				batch.add(value);
			}
			jdbcTemplate.batchUpdate(sql.toString(), batch); */
		}
		
		// 조 추가
		if(excelList!=null && excelList.size()>0){
			sql = new StringBuffer();
			sql.append("SELECT NVL(MAX(JO_NO)+1,1) FROM FOOD_JO		");
			jo_no = jdbcTemplate.queryForObject(sql.toString(), Integer.class);
		
			sql = new StringBuffer();
			sql.append("MERGE INTO FOOD_JO USING DUAL																			");
			sql.append("	ON(JO_NM = ?																						");
			sql.append("		AND TEAM_NO = (SELECT TEAM_NO FROM FOOD_TEAM WHERE TEAM_NM = ? AND SHOW_FLAG = 'Y' 				");
			sql.append("    	AND ZONE_NO = (SELECT ZONE_NO FROM FOOD_ZONE WHERE ZONE_NM = ? AND SHOW_FLAG = 'Y') 			");
			sql.append("    	AND CAT_NO = (SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ? AND SHOW_FLAG = 'Y')))			");
			sql.append("	WHEN NOT MATCHED THEN																				");
			sql.append("	INSERT(JO_NO, TEAM_NO, JO_NM, REG_DATE, MOD_DATE, ORDER1)											");
			sql.append("	VALUES(?																							");
			sql.append("		, (SELECT TEAM_NO FROM FOOD_TEAM WHERE TEAM_NM = ? AND SHOW_FLAG = 'Y'							");
			sql.append("				AND ZONE_NO = (SELECT ZONE_NO FROM FOOD_ZONE WHERE ZONE_NM = ? AND SHOW_FLAG = 'Y')		"); 
	        sql.append("        		AND CAT_NO = (SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ? AND SHOW_FLAG = 'Y')) 	");
			sql.append("		, ?, SYSDATE, SYSDATE																			");
			sql.append("		, (SELECT NVL(MAX(ORDER1)+1,1) 																	");
			sql.append("			FROM FOOD_JO																				");
			sql.append("			WHERE TEAM_NO = (SELECT TEAM_NO FROM FOOD_TEAM WHERE TEAM_NM = ? AND SHOW_FLAG = 'Y'		");
			sql.append("				AND ZONE_NO = (SELECT ZONE_NO FROM FOOD_ZONE WHERE ZONE_NM = ? AND SHOW_FLAG = 'Y')		"); 
	        sql.append("        		AND CAT_NO = (SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ? AND SHOW_FLAG = 'Y')) 	");
			sql.append("			)																							");
			sql.append("		)																								");
			pstmt = conn.prepareStatement(sql.toString());
			for(Map<String,Object> ob : excelList){
				key = 0;
				pstmt.setString(++key,  ob.get(joCell).toString().trim());
				pstmt.setString(++key,  ob.get(teamCell).toString().trim());
				pstmt.setString(++key,  ob.get(zoneCell).toString().trim());
				pstmt.setString(++key,  ob.get(catCell).toString().trim());
				pstmt.setInt(++key,  jo_no++);
				pstmt.setString(++key,  ob.get(teamCell).toString().trim());
				pstmt.setString(++key,  ob.get(zoneCell).toString().trim());
				pstmt.setString(++key,  ob.get(catCell).toString().trim());
				pstmt.setString(++key,  ob.get(joCell).toString().trim());
				pstmt.setString(++key,  ob.get(teamCell).toString().trim());
				pstmt.setString(++key,  ob.get(zoneCell).toString().trim());
				pstmt.setString(++key,  ob.get(catCell).toString().trim());
				pstmt.addBatch();
			}
			pstmt.executeBatch();
			if(pstmt!=null){pstmt.close();}

			/* batch = new ArrayList<Object[]>();
			for(Map<String,Object> ob : excelList){
				value = new Object[]{
						ob.get(joCell).toString().trim()
						, ob.get(teamCell).toString().trim()
						, ob.get(zoneCell).toString().trim()
						, ob.get(catCell).toString().trim()
						
						, jo_no++
						
						, ob.get(teamCell).toString().trim()
						, ob.get(zoneCell).toString().trim()
						, ob.get(catCell).toString().trim()
						
						, ob.get(joCell).toString().trim()
						
						, ob.get(teamCell).toString().trim()
						, ob.get(zoneCell).toString().trim()
						, ob.get(catCell).toString().trim()
				};
				batch.add(value);
			}
			jdbcTemplate.batchUpdate(sql.toString(), batch); */
		}
		
		
		// 권역, 품목, 팀, 조 초기화 (엑셀에서 빠진 학교는 팀에서도 빠짐)
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_SCH_TB SET ZONE_NO = NULL, CAT_NO = NULL, TEAM_NO = NULL, JO_NO = NULL		");
		sql.append("WHERE SCH_TYPE NOT IN ('Z', 'Y', 'X', 'V')												");
		jdbcTemplate.update(sql.toString());
		
		// 권역, 품목, 팀, 조 재설정
		sql = new StringBuffer();
		sql.append("MERGE INTO FOOD_SCH_TB USING DUAL																");
		sql.append("	ON(SCH_NM = ? AND AREA_NO = (SELECT AREA_NO FROM FOOD_AREA WHERE AREA_NM = ?))				");
		sql.append("	WHEN MATCHED THEN																			");
		sql.append("	UPDATE SET																					");
		sql.append("		ZONE_NO 	= (SELECT ZONE_NO FROM FOOD_ZONE WHERE ZONE_NM = ? AND SHOW_FLAG = 'Y')		");		
		sql.append("		, CAT_NO 	= (SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ? AND SHOW_FLAG = 'Y')		");
		sql.append("		, TEAM_NO 	= (SELECT TEAM_NO FROM FOOD_TEAM WHERE TEAM_NM = ? AND SHOW_FLAG = 'Y'										");
		sql.append("							AND ZONE_NO = (SELECT ZONE_NO FROM FOOD_ZONE WHERE ZONE_NM = ? AND SHOW_FLAG = 'Y')					"); 
        sql.append("        					AND CAT_NO = (SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ? AND SHOW_FLAG = 'Y')) 				");
		sql.append("		, JO_NO 	= (SELECT JO_NO FROM FOOD_JO WHERE JO_NM = ? 																");
		sql.append("						AND TEAM_NO = (SELECT TEAM_NO FROM FOOD_TEAM WHERE TEAM_NM = ? AND SHOW_FLAG = 'Y' 						");
		sql.append("       							AND ZONE_NO = (SELECT ZONE_NO FROM FOOD_ZONE WHERE ZONE_NM = ? AND SHOW_FLAG = 'Y') 			");
		sql.append("        						AND CAT_NO = (SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ? AND SHOW_FLAG = 'Y')))			");
		sql.append("		, SCH_GRADE = ?																			");
		pstmt = conn.prepareStatement(sql.toString());
		for(Map<String,Object> ob : excelList){
			if("조사자".equals(ob.get(gradeCell).toString().trim())){
				sch_grade = "R";
			}else{
				sch_grade = "T";
			}
			key = 0;
			pstmt.setString(++key,  ob.get(schCell).toString().trim());
			pstmt.setString(++key,  ob.get(areaCell).toString().trim());
			pstmt.setString(++key,  ob.get(zoneCell).toString().trim());
			pstmt.setString(++key,  ob.get(catCell).toString().trim());
			pstmt.setString(++key,  ob.get(teamCell).toString().trim());
			pstmt.setString(++key,  ob.get(zoneCell).toString().trim());
			pstmt.setString(++key,  ob.get(catCell).toString().trim());
			pstmt.setString(++key,  ob.get(joCell).toString().trim());
			pstmt.setString(++key,  ob.get(teamCell).toString().trim());
			pstmt.setString(++key,  ob.get(zoneCell).toString().trim());
			pstmt.setString(++key,  ob.get(catCell).toString().trim());
			pstmt.setString(++key,  sch_grade);
			pstmt.addBatch();
		}
		
		result = pstmt.executeBatch().length;
		if(pstmt!=null){pstmt.close();}

		/* batch = new ArrayList<Object[]>();
		for(Map<String,Object> ob : excelList){
			if("조사자".equals(ob.get(gradeCell).toString().trim())){
				sch_grade = "R";
			}else{
				sch_grade = "T";
			}
			
			value = new Object[]{
				ob.get(schCell).toString().trim()		// 같은 이름의 학교가 있는지 확인
				, ob.get(areaCell).toString().trim()	// 같은 지역의학교가 있는지 확인
				, ob.get(zoneCell).toString().trim()	// 권역 번호 구하기
				, ob.get(catCell).toString().trim()		// 품목 번호 구하기
				
				, ob.get(teamCell).toString().trim()	// 해당 이름에 맞는 팀 번호 구하기
				, ob.get(zoneCell).toString().trim()	// 팀이 속한 권역 구하기
				, ob.get(catCell).toString().trim()		// 팀이 속한 품목 구하기

				, ob.get(joCell).toString().trim()		// 해당 이름에 맞는 조 번호 구하기
				, ob.get(teamCell).toString().trim()	// 조가 속한 팀 구하기
				, ob.get(zoneCell).toString().trim()	// 조가 속한 팀이 속한 권역 구하기
				, ob.get(catCell).toString().trim()		// 조가 속한 팀이 속한 품번 구하기
				
				, sch_grade
			};
			
			batch.add(value);
		}
		
		result = jdbcTemplate.batchUpdate(sql.toString(), batch).length; */
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('" + returnPage + "');");
			out.println("</script>");
		}else{
			out.println("<script>");
			out.println("alert('처리중 오류가 발생하였습니다.');");
			out.println("location.replace('" + returnPage + "');");
			out.println("</script>");
		}
	}catch(Exception e){
		out.println(e.toString());
		if(pstmt!=null){pstmt.close();}
		if(conn!=null){conn.close();}
		sqlMapClient.endTransaction();
	}finally {
		if(pstmt!=null){pstmt.close();}
		if(conn!=null){conn.close();}
		sqlMapClient.endTransaction();
	}
 
%>