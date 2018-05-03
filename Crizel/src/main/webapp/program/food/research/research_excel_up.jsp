<%@page import="egovframework.rfc3.user.web.SessionManager"%>
<%
/**
*   PURPOSE :   조사개시 엑셀 업로드
*   CREATE  :   20180402_mon    KO
*   MODIFY  :   20180420_fri	KO		품목이 등록되지 않았을 경우 조사품목 생성안되게 수정
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
		
		if(file!=null){
			fileExt = realFile.split("\\.")[realFile.split("\\.").length-1];

			if("xls".equals(fileExt)){
				excelList = getExcelRead(file, 4);
			}else if("xlsx".equals(fileExt)){
				//excelList = getExcelRead2(file, 4);
			}
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
	List<FoodVO> schNmList		= null;
	int result = 0;
	int cnt = 0;
	
	int cat_no 		= 0;	// cat_no 최대값
	int nm_no		= 0;	// nm_no 최대값
	int dt_no		= 0;	// dt_no 최대값
	int ex_no		= 0;	// ex_no 최대값
	int unit_no		= 0;	// unit_no 최대값
	int item_no 	= 0;	// item_no 최대값
	int item_pre_no = 0;	// item_no 최대값(FOOD_ST_ITEM_PRE)
	
	String mode				= parseNull(mr.getParameter("mode"), "new");	// 	new:등록, mod:수정	
	List<FoodVO> cat_nm_arr = null;
	String[] team_no_arr	= mr.getParameterValues("team_no");				// 	조사할 팀
	String rsch_year 		= parseNull(mr.getParameter("rsch_year"));		// 	조사 년
	String rsch_month 		= parseNull(mr.getParameter("rsch_month"));		//	조사 월
	String str_date 		= parseNull(mr.getParameter("str_date"));		//	조사 시작 년월일
	String mid_date 		= parseNull(mr.getParameter("mid_date"));		//	조사 중간 년월일
	String end_date 		= parseNull(mr.getParameter("end_date"));		//	조사 종료 년월일
	String rsch_nm 			= parseNull(mr.getParameter("rsch_nm"));		//	조사명
	int rsch_no				= Integer.parseInt(parseNull(mr.getParameter("rsch_no"), "0"));	//	조사번호
	int rsch_val_no			= 0;
	String file_no			= "";
	int rsch_item_no		= 0;
	
	String nm_food_str 	= "";	
	String dt_nm_str 	= "";
	String ex_nm_str 	= "";
	
	//SessionManager sessionManager = new SessionManager(request);
	
	String regIp = request.getRemoteAddr();
	String regId = sessionManager.getId();
	
	String[] nm_food 	= null;
	String[] dt_nm		= null;
	String[] ex_nm		= null;
	
	String returnPage 	= "research_excel_popup.jsp";
	
	String catCell 		= "cell1";		// 구분 셀	(50byte)
	String codeCell		= "cell2";		// 식품코드 셀 (50 byte)
	String nmCell		= "cell3";		// 식품명 셀 (100 byte)
	String dtCell		= "cell4";		// 상세식품명 셀 (100 byte)
	String exCell		= "cell5";		// 식품설명 셀 (200 byte)
	String unitCell		= "cell6";		// 단위 셀 (20 byte)
	String grpNoCell	= "cell7";		// 그룹번호 셀 
	String grpOrderCell	= "cell8";		// 그룹순서 셀
	String compNoCell	= "cell9";		// 비교번호 셀 
	String compValCell	= "cell10";		// 비교값 셀('A' = 최저 , 'Z' = 최고") ( 2byte)
	String lowRatCell	= "cell11";		// 최저가 비율 셀 
	String avrRatCell	= "cell12";		// 평균가 비율 셀
	String lbRaCell		= "cell13";		// 최저가/최고가 비율 셀
	
	String[] areaCell = {
			  "cell15", "cell17"
			, "cell19", "cell21", "cell23", "cell25", "cell27"
			, "cell29", "cell31", "cell33", "cell35", "cell37"
			, "cell39", "cell41", "cell43", "cell45", "cell47"
			, "cell49", "cell51", "cell53", "cell55", "cell57"
			, "cell59", "cell61", "cell63", "cell65", "cell67"
			, "cell69", "cell71", "cell73", "cell75", "cell77"
			, "cell79", "cell81", "cell83", "cell85", "cell87"
	};
	
	
	String[] schCell = {
			  "cell16", "cell18"
			, "cell20", "cell22", "cell24", "cell26", "cell28"
			, "cell30", "cell32", "cell34", "cell36", "cell38"
			, "cell40", "cell42", "cell44", "cell46", "cell48"
			, "cell50", "cell52", "cell54", "cell56", "cell58"
			, "cell60", "cell62", "cell64", "cell66", "cell68"
			, "cell70", "cell72", "cell74", "cell76", "cell78"
			, "cell80", "cell82", "cell84", "cell86", "cell88"
	};
	
	Map<String,Object> catMap 			= null;
	List<Map<String,Object>> catList 	= new ArrayList<Map<String,Object>>();
	List<String> catDupCheckList 		= null;
	List<FoodVO> rschSchList			= null;
%>

<%!
public boolean getException(Map<String,Object> ob, String cell, int length){
	byte[] b = ob.get(cell).toString().getBytes();
	if(b.length>length){return true;}
	else{return false;}
}

public Map<String,Object> getCatStr(Map<String,Object> ob, String[] cat_nm, String[] area_nm){
	Map<String,Object> map = new HashMap<String,Object>();
	String val 	= "";
	String val2 = "";
	
	// 학교명
	if(ob.get(cat_nm[0])!=null && !"".equals(ob.get(cat_nm[0]).toString())){
		val = ob.get(cat_nm[0]).toString();
	}
	
	for(int i=1; i<cat_nm.length; i++){
		if(ob.get(cat_nm[i])!=null && !"".equals(ob.get(cat_nm[i]).toString())){
			val += "," + ob.get(cat_nm[i]).toString();
		}
	}
	
	// 지역명
	if(ob.get(area_nm[0])!=null && !"".equals(ob.get(area_nm[0]).toString())){
		val2 = ob.get(area_nm[0]).toString();
	}
	for(int i=1; i<area_nm.length; i++){
		if(ob.get(area_nm[i])!=null && !"".equals(ob.get(area_nm[i]).toString())){
			val2 += "," + ob.get(area_nm[i]).toString();
		}
	}
	
	map.put("cat_nm", ob.get("cell1").toString());
	map.put("sch_nm", val);
	map.put("area_nm", val2);
	
	return map;
}
%>
<%
	try{
		catDupCheckList = new ArrayList<String>();
		
		sql = new StringBuffer();
		sql.append("SELECT * FROM FOOD_ST_CAT WHERE SHOW_FLAG = 'Y' ORDER BY CAT_NM		");
		cat_nm_arr = jdbcTemplate.query(sql.toString(), new FoodList());
		
		if(excelList!=null && excelList.size()>0){
			byte[] b = null;
			int exceptionCheck = 0;
			boolean continueCheck = false;
			for(Map<String,Object> ob : excelList){
				continueCheck = false;
				
				if(cat_nm_arr!=null && cat_nm_arr.size()>0){
					for(FoodVO ob2 : cat_nm_arr){
						if(ob.get(catCell).toString().split("-")[0].trim().equals(ob2.cat_nm)){
							continueCheck = true;
						}
					}
				}
				
				if(continueCheck){
					// DB 데이터 길이보다 글자가 많을 때 오류처리
					if(getException(ob, catCell, 50)){out.println("<script>alert('구분명 값이 너무 큽니다');location.replace('" + returnPage + "');</script>"); return;}
					if(getException(ob, codeCell, 50)){out.println("<script>alert('식품코드 값이 너무 큽니다');location.replace('" + returnPage + "');</script>"); return;}
					if(getException(ob, nmCell, 100*5)){out.println("<script>alert('식품명 값이 너무 큽니다');location.replace('" + returnPage + "');</script>"); return;}
					if(getException(ob, dtCell, 100*10)){out.println("<script>alert('상세식품명 값이 너무 큽니다');location.replace('" + returnPage + "');</script>"); return;}
					if(getException(ob, exCell, 200*25)){out.println("<script>alert('식품설명 값이 너무 큽니다');location.replace('" + returnPage + "');</script>"); return;}
					if(getException(ob, unitCell, 20)){out.println("<script>alert('단위 값이 너무 큽니다');location.replace('" + returnPage + "');</script>"); return;}
					if(getException(ob, compValCell, 2)){out.println("<script>alert('비교 값이 너무 큽니다');location.replace('" + returnPage + "');</script>"); return;}
					
					// 숫자값이 필요한 데이터가 숫자가 아닐경우 오류처리
					try{if(!"".equals(ob.get(grpNoCell).toString())){exceptionCheck = (int)Float.parseFloat(ob.get(grpNoCell).toString());}}
					catch(Exception e){out.println("<script>alert('그룹번호의 값이 숫자가 아닙니다.');location.replace('" + returnPage + "');</script>"); return;}
					try{if(!"".equals(ob.get(grpOrderCell).toString())){exceptionCheck = (int)Float.parseFloat(ob.get(grpOrderCell).toString());}}
					catch(Exception e){out.println("<script>alert('그룹순서의 값이 숫자가 아닙니다.');location.replace('" + returnPage + "');</script>"); return;}
					try{if(!"".equals(ob.get(compNoCell).toString())){exceptionCheck = (int)Float.parseFloat(ob.get(compNoCell).toString());}}
					catch(Exception e){out.println("<script>alert('비교번호의 값이 숫자가 아닙니다.');location.replace('" + returnPage + "');</script>"); return;}
					try{if(!"".equals(ob.get(lowRatCell).toString())){exceptionCheck = (int)Float.parseFloat(ob.get(lowRatCell).toString());}}
					catch(Exception e){out.println("<script>alert('최저가 비율의 값이 숫자가 아닙니다.');location.replace('" + returnPage + "');</script>"); return;}
					try{if(!"".equals(ob.get(avrRatCell).toString())){exceptionCheck = (int)Float.parseFloat(ob.get(avrRatCell).toString());}}
					catch(Exception e){out.println("<script>alert('평균가 비율의 값이 숫자가 아닙니다.');location.replace('" + returnPage + "');</script>"); return;}
					try{if(!"".equals(ob.get(lbRaCell).toString())){exceptionCheck = (int)Float.parseFloat(ob.get(lbRaCell).toString());}}
					catch(Exception e){out.println("<script>alert('최저가/최고가의 값이 숫자가 아닙니다.');location.replace('" + returnPage + "');</script>"); return;}
					
					// 모든셀이 빈칸이 아니면서 필수입력값 데이터가 비어있을 경우 오류처리
					if(!(   "".equals(ob.get(codeCell).toString()) 	&& "".equals(ob.get(catCell).toString())
						&& 	"".equals(ob.get(nmCell).toString()) 	&& "".equals(ob.get(dtCell).toString())
						&& 	"".equals(ob.get(exCell).toString()) )){
						if("".equals(ob.get(codeCell).toString())){ out.println("<script>alert('식품코드 데이터가 비어있습니다.');location.replace('" + returnPage + "');</script>"); return;}
						if("".equals(ob.get(catCell).toString())){out.println("<script>alert('구분 데이터가 비어있습니다.');location.replace('" + returnPage + "');</script>"); return;}
						if("".equals(ob.get(nmCell).toString())){out.println("<script>alert('식품명 데이터가 비어있습니다.');location.replace('" + returnPage + "');</script>"); return;}
						if("".equals(ob.get(dtCell).toString())){out.println("<script>alert('상세식품명 데이터가 비어있습니다.');location.replace('" + returnPage + "');</script>"); return;}
						if("".equals(ob.get(exCell).toString())){out.println("<script>alert('식품설명 데이터가 비어있습니다.');location.replace('" + returnPage + "');</script>"); return;}
						if("".equals(ob.get(grpNoCell).toString())){out.println("<script>alert('그룹번호 데이터가 비어있습니다.');location.replace('" + returnPage + "');</script>"); return;}
						if("".equals(ob.get(grpOrderCell).toString())){out.println("<script>alert('그룹순서 데이터가 비어있습니다.');location.replace('" + returnPage + "');</script>"); return;}
						if("".equals(ob.get(lowRatCell).toString())){out.println("<script>alert('최저가 비율 데이터가 비어있습니다.');location.replace('" + returnPage + "');</script>"); return;}
						if("".equals(ob.get(avrRatCell).toString())){out.println("<script>alert('평균가 비율 데이터가 비어있습니다.');location.replace('" + returnPage + "');</script>"); return;}
						if("".equals(ob.get(lbRaCell).toString())){out.println("<script>alert('최저가/최고가 비율 데이터가 비어있습니다.');location.replace('" + returnPage + "');</script>"); return;}
					}

					// 구분값 중복체크 리스트
					catDupCheckList.add(ob.get(catCell).toString().split("-")[0].trim() + ob.get(catCell).toString().split("-")[1].trim());
					
					// Map에 구분값과 해당 구분값을 기준으로 한 학교를 ',' 를 기준으로 문자열에 저장한 데이터를 넣음
					catMap = new HashMap<String,Object>();
					catMap.putAll(getCatStr(ob, schCell, areaCell));
					catList.add(catMap);
				}
			}
			
			
			if(catDupCheckList!=null && catDupCheckList.size()>0){
				for(int i=0; i<catDupCheckList.size(); i++){
					for(int j=i+1; j<catDupCheckList.size(); j++){
						if(catDupCheckList.get(i).equals(catDupCheckList.get(j))){
							out.println("<script>alert('구분값이 중복되어 있습니다.');location.replace('" + returnPage + "');</script>"); return;
						}
					}
				}
			}
		}
				
		if("".equals(regId)){
			out.println("<script>");
			out.println("alert('로그인 후 다시 시도 하십시오.');");
			out.println("location.replace('" + returnPage + "');");
			out.println("</script>");
			return;
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
			return;
		}
		
		sqlMapClient.startTransaction();
		conn = sqlMapClient.getCurrentConnection();
		
		if(file!=null){
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
		}
		
		
		
		// 구분,학교명 저장 테이블을 삭제
		sql = new StringBuffer();
		sql.append("DELETE FROM FOOD_RSCH_SCH			");
		jdbcTemplate.update(sql.toString());
		
		// 구분,학교명을 저장
		sql = new StringBuffer();
		sql.append("INSERT INTO FOOD_RSCH_SCH(CAT_NM, SCH_NM, ITEM_NO, SCH_NO, TEAM_NO)											");
		sql.append("VALUES(   ?, ?																								");
		sql.append("		, (SELECT B.ITEM_NO 																				");
		sql.append("		   FROM FOOD_ITEM_PRE A LEFT JOIN FOOD_ST_ITEM B ON A.S_ITEM_NO = B.ITEM_NO 						");
		sql.append("		   WHERE B.CAT_NO = (SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ? AND SHOW_FLAG = 'Y')			");
		sql.append("		     AND B.FOOD_CAT_INDEX = ?) 																		");
		sql.append("		, (SELECT MIN(SCH_NO) FROM FOOD_SCH_TB WHERE SCH_NM = ? AND SHOW_FLAG = 'Y' AND AREA_NO = (SELECT AREA_NO FROM FOOD_AREA WHERE AREA_NM = ?) )		");
		sql.append("		, (SELECT MIN(TEAM_NO) FROM FOOD_SCH_TB WHERE SCH_NM = ? AND SHOW_FLAG = 'Y' AND AREA_NO = (SELECT AREA_NO FROM FOOD_AREA WHERE AREA_NM = ?)	) )		");
		pstmt = conn.prepareStatement(sql.toString());
		if(catList!=null && catList.size()>0){
			for(Map<String,Object> ob : catList){
				String[] sch_nm_split = ob.get("sch_nm").toString().split(",");
				String[] area_nm_split = ob.get("area_nm").toString().split(",");
				for(int i=0; i<sch_nm_split.length; i++){
					if(!"".equals(sch_nm_split[i].trim())){
						key = 0;
						pstmt.setString(++key,  ob.get("cat_nm").toString().trim());
						pstmt.setString(++key,  sch_nm_split[i].trim());
						pstmt.setString(++key,  ob.get("cat_nm").toString().split("-")[0].trim());
						pstmt.setString(++key,  ob.get("cat_nm").toString().split("-")[1].trim());
						pstmt.setString(++key,  sch_nm_split[i].trim());
						pstmt.setString(++key,  area_nm_split[i].trim());
						pstmt.setString(++key,  sch_nm_split[i].trim());
						pstmt.setString(++key,  area_nm_split[i].trim());
						pstmt.addBatch();
					}
				}
			}
		}
		pstmt.executeBatch();
		if(pstmt!=null){pstmt.close();}

		/* batch = new ArrayList<Object[]>();
		if(catList!=null && catList.size()>0){
			for(Map<String,Object> ob : catList){
				String[] sch_nm_split = ob.get("sch_nm").toString().split(",");
				for(int i=0; i<sch_nm_split.length; i++){
					if(!"".equals(sch_nm_split[i].trim())){
						value = new Object[]{
								  ob.get("cat_nm").toString().trim()
							    , sch_nm_split[i].trim()
							    , ob.get("cat_nm").toString().split("-")[0].trim()
							    , ob.get("cat_nm").toString().split("-")[1].trim()
							    , sch_nm_split[i].trim()
							    , sch_nm_split[i].trim()
						};
						batch.add(value);
					}
				}
			}
		}
		jdbcTemplate.batchUpdate(sql.toString(), batch); */
		
		
		sql = new StringBuffer();
		sql.append("SELECT *					");
		sql.append("FROM FOOD_RSCH_SCH			");
		sql.append("WHERE SCH_NO IS NOT NULL	");
		sql.append("  AND ITEM_NO IS NOT NULL	");
		sql.append("ORDER BY ITEM_NO			");
		rschSchList = jdbcTemplate.query(sql.toString(), new FoodList());
		
		
		// 월별조사 항목 백업 
		sql = new StringBuffer();
		sql.append("INSERT INTO FOOD_RSCH_ITEM_B		");
		sql.append("SELECT * FROM FOOD_RSCH_ITEM		");
		jdbcTemplate.update(sql.toString());
		
		try{
			// 월별조사 항목 삭제
			sql = new StringBuffer();
			sql.append("DELETE FROM FOOD_RSCH_ITEM		");
			jdbcTemplate.update(sql.toString());
			
			// 월별조사 항목 등록
			sql = new StringBuffer();
			sql.append("SELECT NVL(MAX(RSCH_ITEM_NO)+1, 1) AS RSCH_ITEM_NO FROM FOOD_RSCH_ITEM		");
			rsch_item_no = jdbcTemplate.queryForObject(sql.toString(), Integer.class);
			
			sql = new StringBuffer();
			sql.append("INSERT INTO FOOD_RSCH_ITEM( RSCH_ITEM_NO, ITEM_NO, SCH_NO, NU_NO	");
			sql.append("						,	FILE_NO, REG_YEAR, REG_MON)				");
			sql.append("VALUES( ?															");	// RSCH_ITEM_NO
			sql.append("	,	?															"); // ITEM_NO
			sql.append("	,	?															"); // SCH_NO
			sql.append("	,	(SELECT MAX(NU_NO) FROM FOOD_SCH_NU WHERE SCH_NO = ?)		"); // NU_NO
			sql.append("  	,   (SELECT FILE_NO												");	// FILE_NO	
			sql.append("	  	 FROM FOOD_UP_FILE											");
			sql.append("	  	 WHERE FILE_NM = ?)											");
			sql.append("	,	(SELECT TO_CHAR(SYSDATE, 'YYYY') FROM DUAL)					"); // REG_YEAR
			sql.append("	,	(SELECT TO_CHAR(SYSDATE, 'MM') FROM DUAL)					"); // REG_MON
			sql.append(")																	");
			pstmt = conn.prepareStatement(sql.toString());
			if(rschSchList!=null && rschSchList.size()>0){
				for(FoodVO ob : rschSchList){
					key = 0;
					pstmt.setInt(++key,  rsch_item_no++);
					pstmt.setString(++key,  ob.item_no);
					pstmt.setString(++key,  ob.sch_no);
					pstmt.setString(++key,  ob.sch_no);
					pstmt.setString(++key,  saveFile);
					pstmt.addBatch();
				}
			}
			result = pstmt.executeBatch().length;
			if(pstmt!=null){pstmt.close();}

			/* batch = new ArrayList<Object[]>();
			if(rschSchList!=null && rschSchList.size()>0){
				for(FoodVO ob : rschSchList){
					value = new Object[]{
							  rsch_item_no++
						    , ob.item_no
						    , ob.sch_no
						    , ob.sch_no
						    , saveFile
					};
					batch.add(value);
				}
			}
			result = jdbcTemplate.batchUpdate(sql.toString(), batch).length; */
		}catch(Exception e){
			sql = new StringBuffer();
			sql.append("DELETE FROM FOOD_RSCH_ITEM		");
			jdbcTemplate.update(sql.toString());
			
			sql = new StringBuffer();
			sql.append("INSERT INTO FOOD_RSCH_ITEM		");
			sql.append("SELECT * FROM FOOD_RSCH_ITEM_B	");
			jdbcTemplate.update(sql.toString());
		}
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("opener.location.reload()");
			out.println("window.close()");
			out.println("location.replace('" + returnPage + "');");
			out.println("</script>");
		}else{
			out.println("<script>alert('처리 중 오류가 발생하였습니다.\\n엑셀을 확인하여주시기 바랍니다.');location.replace('"+returnPage+"');</script>");
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