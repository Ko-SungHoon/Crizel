<%@page import="egovframework.rfc3.user.web.SessionManager"%>
<%
/**
*   PURPOSE :   식품 엑셀 업로드
*   CREATE  :   20180323_fri    JI
*   MODIFY  :   ...
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ page import="java.io.File, java.io.IOException, com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
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
			excelList = getExcelRead(file, 4);
		}else if("xlsx".equals(fileExt)){
			excelList = getExcelRead2(file, 4);
		}
	}
	
	
	StringBuffer sql 			= null;
	List<Object[]> batch 		= null;
	List<Object> setList 		= null;			
	Object[] value				= null;	
	List<String> itemNoList 	= null;
	int key = 0;
	int result = 0;
	
	int cat_no 		= 0;	// cat_no 최대값
	int nm_no		= 0;	// nm_no 최대값
	int dt_no		= 0;	// dt_no 최대값
	int ex_no		= 0;	// ex_no 최대값
	int unit_no		= 0;	// unit_no 최대값
	int item_no 	= 0;	// item_no 최대값
	int item_pre_no = 0;	// item_no 최대값(FOOD_ST_ITEM_PRE)
	
	String nm_food_str 	= "";	
	String dt_nm_str 	= "";
	String ex_nm_str 	= "";
	
	SessionManager sessionManager = new SessionManager(request);
	
	String regIp = request.getRemoteAddr();
	String regId = sessionManager.getId();
	
	String[] nm_food 	= null;
	String[] dt_nm		= null;
	String[] ex_nm		= null;
	
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
			byte[] b = null;
			int exceptionCheck = 0;
			for(Map<String,Object> ob : excelList){
				// DB 데이터 길이보다 글자가 많을 때 오류처리
				if(getException(ob, catCell, 50)){out.println("<script>alert('구분명 값이 너무 큽니다');location.replace('food_item_list.jsp');</script>"); return;}
				if(getException(ob, codeCell, 50)){out.println("<script>alert('식품코드 값이 너무 큽니다');location.replace('food_item_list.jsp');</script>"); return;}
				if(getException(ob, nmCell, 100*5)){out.println("<script>alert('식품명 값이 너무 큽니다');location.replace('food_item_list.jsp');</script>"); return;}
				if(getException(ob, dtCell, 100*10)){out.println("<script>alert('상세식품명 값이 너무 큽니다');location.replace('food_item_list.jsp');</script>"); return;}
				if(getException(ob, exCell, 200*25)){out.println("<script>alert('식품설명 값이 너무 큽니다');location.replace('food_item_list.jsp');</script>"); return;}
				if(getException(ob, unitCell, 20)){out.println("<script>alert('단위 값이 너무 큽니다');location.replace('food_item_list.jsp');</script>"); return;}
				if(getException(ob, compValCell, 2)){out.println("<script>alert('비교 값이 너무 큽니다');location.replace('food_item_list.jsp');</script>"); return;}
				
				// 숫자값이 필요한 데이터가 숫자가 아닐경우 오류처리
				try{if(!"".equals(ob.get(grpNoCell).toString())){exceptionCheck = (int)Float.parseFloat(ob.get(grpNoCell).toString());}}
				catch(Exception e){out.println("<script>alert('그룹번호의 값이 숫자가 아닙니다.');location.replace('food_item_list.jsp');</script>"); return;}
				try{if(!"".equals(ob.get(grpOrderCell).toString())){exceptionCheck = (int)Float.parseFloat(ob.get(grpOrderCell).toString());}}
				catch(Exception e){out.println("<script>alert('그룹순서의 값이 숫자가 아닙니다.');location.replace('food_item_list.jsp');</script>"); return;}
				try{if(!"".equals(ob.get(compNoCell).toString())){exceptionCheck = (int)Float.parseFloat(ob.get(compNoCell).toString());}}
				catch(Exception e){out.println("<script>alert('비교번호의 값이 숫자가 아닙니다.');</script>"); return;}
				try{if(!"".equals(ob.get(lowRatCell).toString())){exceptionCheck = (int)Float.parseFloat(ob.get(lowRatCell).toString());}}
				catch(Exception e){out.println("<script>alert('최저가 비율의 값이 숫자가 아닙니다.');location.replace('food_item_list.jsp');</script>"); return;}
				try{if(!"".equals(ob.get(avrRatCell).toString())){exceptionCheck = (int)Float.parseFloat(ob.get(avrRatCell).toString());}}
				catch(Exception e){out.println("<script>alert('평균가 비율의 값이 숫자가 아닙니다.');location.replace('food_item_list.jsp');</script>"); return;}
				try{if(!"".equals(ob.get(lbRaCell).toString())){exceptionCheck = (int)Float.parseFloat(ob.get(lbRaCell).toString());}}
				catch(Exception e){out.println("<script>alert('최저가/최고가의 값이 숫자가 아닙니다.');location.replace('food_item_list.jsp');</script>"); return;}
				
				// 모든셀이 빈칸이 아니면서 필수입력값 데이터가 비어있을 경우 오류처리
				if(!(   "".equals(ob.get(codeCell).toString()) 	&& "".equals(ob.get(catCell).toString())
					&& 	"".equals(ob.get(nmCell).toString()) 	&& "".equals(ob.get(dtCell).toString())
					&& 	"".equals(ob.get(exCell).toString()) )){
					if("".equals(ob.get(codeCell).toString())){ out.println("<script>alert('식품코드 데이터가 비어있습니다.');location.replace('food_item_list.jsp');</script>"); return;}
					if("".equals(ob.get(catCell).toString())){out.println("<script>alert('구분 데이터가 비어있습니다.');location.replace('food_item_list.jsp');</script>"); return;}
					if("".equals(ob.get(nmCell).toString())){out.println("<script>alert('식품명 데이터가 비어있습니다.');location.replace('food_item_list.jsp');</script>"); return;}
					if("".equals(ob.get(dtCell).toString())){out.println("<script>alert('상세식품명 데이터가 비어있습니다.');location.replace('food_item_list.jsp');</script>"); return;}
					if("".equals(ob.get(exCell).toString())){out.println("<script>alert('식품설명 데이터가 비어있습니다.');location.replace('food_item_list.jsp');</script>"); return;}
					if("".equals(ob.get(grpNoCell).toString())){out.println("<script>alert('그룹번호 데이터가 비어있습니다.');location.replace('food_item_list.jsp');</script>"); return;}
					if("".equals(ob.get(grpOrderCell).toString())){out.println("<script>alert('그룹순서 데이터가 비어있습니다.');location.replace('food_item_list.jsp');</script>"); return;}
					if("".equals(ob.get(lowRatCell).toString())){out.println("<script>alert('최저가 비율 데이터가 비어있습니다.');location.replace('food_item_list.jsp');</script>"); return;}
					if("".equals(ob.get(avrRatCell).toString())){out.println("<script>alert('평균가 비율 데이터가 비어있습니다.');location.replace('food_item_list.jsp');</script>"); return;}
					if("".equals(ob.get(lbRaCell).toString())){out.println("<script>alert('최저가/최고가 비율 데이터가 비어있습니다.');location.replace('food_item_list.jsp');</script>"); return;}
				}
			}
		}
				
		if("".equals(regId)){
			out.println("<script>");
			out.println("alert('로그인 후 다시 시도 하십시오.');");
			out.println("location.replace('food_item_list.jsp');");
			out.println("</script>");
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
	
		
		
		// 구분 데이터 저장
		cat_no = jdbcTemplate.queryForObject("SELECT NVL(MAX(CAT_NO)+1, 1) FROM FOOD_ST_CAT", Integer.class);
		
		sql = new StringBuffer();
		sql.append("MERGE INTO FOOD_ST_CAT USING DUAL														");
		sql.append("	ON(CAT_NM = ?)																		");
		sql.append("	WHEN NOT MATCHED THEN																");
		sql.append("		INSERT(																			");
		sql.append("			CAT_NO, CAT_NM, REG_DATE, MOD_DATE, SHOW_FLAG, UNIT_NO, UNIT_VAL			");
		sql.append("		)																				");
		sql.append("		VALUES(																			");
		sql.append("			  ?, ?, SYSDATE, SYSDATE, 'Y'												");
		sql.append("			, (SELECT UNIT_NO FROM FOOD_ST_UNIT WHERE UNIT_NM = '%'), 50				");
		sql.append("		)																				");
		
		batch = new ArrayList<Object[]>();
		if(excelList!=null && excelList.size()>0){
			for(Map<String,Object> ob : excelList){
				if(ob.get(catCell) != null && !"".equals(ob.get(catCell).toString())){
					value = new Object[]{
							  ob.get(catCell).toString().split("-")[0].trim()
							, cat_no++
						    , ob.get(catCell).toString().split("-")[0].trim()
					};
					batch.add(value);
				}
			}
		}
		int catBatch[] = jdbcTemplate.batchUpdate(sql.toString(), batch); 
		
		
		// 식품명 데이터 저장
		nm_no = jdbcTemplate.queryForObject("SELECT NVL(MAX(NM_NO)+1, 1) FROM FOOD_ST_NM", Integer.class);
		
		sql = new StringBuffer();
		sql.append("MERGE INTO FOOD_ST_NM USING DUAL														");
		sql.append("	ON(NM_FOOD = ?)																		");
		sql.append("	WHEN NOT MATCHED THEN																");
		sql.append("		INSERT(																			");
		sql.append("			NM_NO, CAT_NO, NM_FOOD, SHOW_FLAG, REG_DATE, MOD_DATE						");
		sql.append("		)																				");
		sql.append("		VALUES(																			");
		sql.append("			  ?, (SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ? )						");
		sql.append("			, ?, 'Y', SYSDATE, SYSDATE													");
		sql.append("		)																				");
		batch = new ArrayList<Object[]>();
		if(excelList!=null && excelList.size()>0){
			for(Map<String,Object> ob : excelList){
				if(ob.get(nmCell) != null && !"".equals(ob.get(nmCell).toString())){
					nm_food = ob.get(nmCell).toString().split(",");
					for(String nm_food_value : nm_food){
						value = new Object[]{
								nm_food_value.trim()
								, nm_no++
							    , ob.get(catCell).toString().split("-")[0].trim()
								, nm_food_value.trim()
						};
						batch.add(value);
					}
				}
			}
		}
		int nmBatch[] = jdbcTemplate.batchUpdate(sql.toString(), batch);
		
		
		// 상세식품명 데이터 저장
		dt_no = jdbcTemplate.queryForObject("SELECT NVL(MAX(DT_NO)+1, 1) FROM FOOD_ST_DT_NM", Integer.class);
		
		sql = new StringBuffer();
		sql.append("MERGE INTO FOOD_ST_DT_NM USING DUAL														");
		sql.append("	ON(DT_NM = ?)																		");
		sql.append("	WHEN NOT MATCHED THEN																");
		sql.append("		INSERT(																			");
		sql.append("			DT_NO, CAT_NO, DT_NM, SHOW_FLAG, REG_DATE, MOD_DATE							");
		sql.append("		)																				");
		sql.append("		VALUES(																			");
		sql.append("			  ?, (SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ? )						");
		sql.append("			, ?, 'Y', SYSDATE, SYSDATE													");
		sql.append("		)																				");
		batch = new ArrayList<Object[]>();
		if(excelList!=null && excelList.size()>0){
			for(Map<String,Object> ob : excelList){
				if(ob.get(dtCell) != null && !"".equals(ob.get(dtCell).toString())){
					dt_nm = ob.get(dtCell).toString().split(",");
					for(String dt_nm_value : dt_nm){
						value = new Object[]{
								dt_nm_value.trim()
								, dt_no++
							    , ob.get(catCell).toString().split("-")[0].trim()
								, dt_nm_value.trim()
						};
						batch.add(value);
					}
				}
			}
		}
		int dtBatch[] = jdbcTemplate.batchUpdate(sql.toString(), batch);
		
		
		// 상세설명 데이터 저장
		ex_no = jdbcTemplate.queryForObject("SELECT NVL(MAX(EX_NO)+1, 1) FROM FOOD_ST_EXPL", Integer.class);
		
		sql = new StringBuffer();
		sql.append("MERGE INTO FOOD_ST_EXPL USING DUAL														");
		sql.append("	ON(EX_NM = ?)																		");
		sql.append("	WHEN NOT MATCHED THEN																");
		sql.append("		INSERT(																			");
		sql.append("			EX_NO, CAT_NO, EX_NM, SHOW_FLAG, REG_DATE, MOD_DATE							");
		sql.append("		)																				");
		sql.append("		VALUES(																			");
		sql.append("			  ?, (SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ? )						");
		sql.append("			, ?, 'Y', SYSDATE, SYSDATE													");
		sql.append("		)																				");
		batch = new ArrayList<Object[]>();
		if(excelList!=null && excelList.size()>0){
			for(Map<String,Object> ob : excelList){
				if(!"".equals(ob.get(exCell)) && !"".equals(ob.get(exCell).toString())){
					ex_nm = ob.get(exCell).toString().split(",");
					for(String ex_nm_value : ex_nm){
						if(!"".equals(ex_nm_value)){
							value = new Object[]{
									  ex_nm_value.trim()
									, ex_no++
								    , ob.get(catCell).toString().split("-")[0].trim()
									, ex_nm_value.trim()
							};
							batch.add(value);
						}
					}
				}
			}
		}
		int exBatch[] = jdbcTemplate.batchUpdate(sql.toString(), batch);
		
		
		// 단위 데이터 저장
		unit_no = jdbcTemplate.queryForObject("SELECT NVL(MAX(UNIT_NO)+1, 1) FROM FOOD_ST_UNIT", Integer.class);
		
		sql = new StringBuffer();
		sql.append("MERGE INTO FOOD_ST_UNIT USING DUAL														");
		sql.append("	ON(UNIT_NM = ?)																		");
		sql.append("	WHEN NOT MATCHED THEN																");
		sql.append("		INSERT(																			");
		sql.append("			UNIT_NO, UNIT_NM, UNIT_TYPE, SHOW_FLAG, REG_DATE, MOD_DATE					");
		sql.append("		)																				");
		sql.append("		VALUES(																			");
		sql.append("			  ?, ?, 'F', 'Y', SYSDATE, SYSDATE										");
		sql.append("		)																				");
		batch = new ArrayList<Object[]>();
		if(excelList!=null && excelList.size()>0){
			String unitNmCheck = "";
			for(int i=0; i<excelList.size(); i++){
				Map<String,Object> ob = excelList.get(i);
				if(ob.get(unitCell) != null && !"".equals(ob.get(unitCell).toString())){
					value = new Object[]{
							  ob.get(unitCell)
							, unit_no++
							, ob.get(unitCell)
					};
					batch.add(value);
				}
			}
		}
		int unitBatch[] = jdbcTemplate.batchUpdate(sql.toString(), batch);
		
		
		try{
			// 식품 항목 입력
			// MERGE 조건에 NULL 값은 처리되지 않기에
			// FOOD_NM_1~5, FOOD_DT_1~10, FOOD_EP_1~10의 문자열을 각각 합쳐서 조건문으로 만듬 
			item_no = jdbcTemplate.queryForObject("SELECT NVL(MAX(ITEM_NO)+1, 1) FROM FOOD_ST_ITEM", Integer.class);
			
			sql = new StringBuffer();
			sql.append("MERGE INTO FOOD_ST_ITEM USING DUAL													");
			sql.append("	ON (	FOOD_CODE = ? 															");
			sql.append("		AND (SELECT NM_FOOD FROM FOOD_ST_NM WHERE NM_NO = FOOD_NM_1)  				");
			sql.append("			|| (SELECT NM_FOOD FROM FOOD_ST_NM WHERE NM_NO = FOOD_NM_2)				");
			sql.append("			|| (SELECT NM_FOOD FROM FOOD_ST_NM WHERE NM_NO = FOOD_NM_3)				");
			sql.append("			|| (SELECT NM_FOOD FROM FOOD_ST_NM WHERE NM_NO = FOOD_NM_4)				");
			sql.append("			|| (SELECT NM_FOOD FROM FOOD_ST_NM WHERE NM_NO = FOOD_NM_5) = ?			");
			sql.append("		AND (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_1) 				");
			sql.append("			|| (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_2)			");
			sql.append("			|| (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_3)			");
			sql.append("			|| (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_4)			");
			sql.append("			|| (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_5)			");
			sql.append("			|| (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_6)			");
			sql.append("			|| (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_7)			");
			sql.append("			|| (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_8)			");
			sql.append("			|| (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_9)			");
			sql.append("			|| (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_10) = ?		");
			sql.append("		AND (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_1) 				");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_2)				");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_3)				");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_4)				");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_5)				");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_6)				");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_7)				");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_8)				");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_9)				");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_10)			");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_11)			");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_12)			");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_13)			");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_14)			");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_15)			");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_16)			");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_17)			");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_18)			");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_19)			");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_20)			");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_21)			");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_22)			");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_23)			");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_24)			");
			sql.append("			|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_25)	= ?		");
			sql.append("	)																				");
			sql.append("	WHEN MATCHED THEN															");
			sql.append("		UPDATE SET																");
			sql.append("			  FOOD_UNIT = (SELECT UNIT_NO FROM FOOD_ST_UNIT WHERE UNIT_NM = ?)	");
			sql.append("			, FOOD_DT_1 = (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");
			sql.append("			, FOOD_DT_2 = (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");
			sql.append("			, FOOD_DT_3 = (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");
			sql.append("			, FOOD_DT_4 = (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");
			sql.append("			, FOOD_DT_5 = (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");
			sql.append("			, FOOD_DT_6 = (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");
			sql.append("			, FOOD_DT_7 = (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");
			sql.append("			, FOOD_DT_8 = (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");
			sql.append("			, FOOD_DT_9 = (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");
			sql.append("			, FOOD_DT_10 = (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)	");
			sql.append("			, FOOD_EP_1 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_2 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_3 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_4 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_5 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_6 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_7 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_8 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_9 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_10 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_11 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_12 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_13 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_14 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_15 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_16 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_17 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_18 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_19 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_20 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_21 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_22 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_23 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_24 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, FOOD_EP_25 = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
			sql.append("			, MOD_DATE = SYSDATE												");
			sql.append("			, SHOW_FLAG = 'Y'													");
			sql.append("			, FOOD_CAT_INDEX = ?												");
			sql.append("	WHEN NOT MATCHED THEN														");
			sql.append("	INSERT(																		");
			sql.append("			  ITEM_NO															");
			sql.append("			, CAT_NO															");
			sql.append("			, FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5				");
			sql.append("			, FOOD_UNIT															");
			sql.append("			, FOOD_DT_1 , FOOD_DT_2 , FOOD_DT_3 , FOOD_DT_4 					");
			sql.append("			, FOOD_DT_5 , FOOD_DT_6 , FOOD_DT_7, FOOD_DT_8  					");
			sql.append("			, FOOD_DT_9 , FOOD_DT_10 											");
			sql.append("			, FOOD_EP_1 , FOOD_EP_2 , FOOD_EP_3 , FOOD_EP_4 					");
			sql.append("			, FOOD_EP_5 , FOOD_EP_6 , FOOD_EP_7 , FOOD_EP_8 					");
			sql.append("			, FOOD_EP_9 , FOOD_EP_10 , FOOD_EP_11 , FOOD_EP_12 					");
			sql.append("			, FOOD_EP_13 , FOOD_EP_14 , FOOD_EP_15 , FOOD_EP_16 				");
			sql.append("			, FOOD_EP_17 , FOOD_EP_18 , FOOD_EP_19 , FOOD_EP_20 				");
			sql.append("			, FOOD_EP_21 , FOOD_EP_22 , FOOD_EP_23 , FOOD_EP_24 				");
			sql.append("			, FOOD_EP_25 														");
			sql.append("			, FOOD_CODE 														");
			sql.append("			, REG_DATE	 														");
			sql.append("			, MOD_DATE	 														");
			sql.append("			, SHOW_FLAG	 														");
			sql.append("			, FOOD_CAT_INDEX													");
			sql.append("		)																		");
			sql.append("	VALUES(																		");
			sql.append("			  ? 																");	// ITEM_NO
			sql.append("			, (SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ?)					");	// CAT_NO
			sql.append("			, (SELECT NM_NO FROM FOOD_ST_NM WHERE NM_FOOD = ?)					"); // FOOD_NM_1
			sql.append("			, (SELECT NM_NO FROM FOOD_ST_NM WHERE NM_FOOD = ?)					"); // FOOD_NM_2
			sql.append("			, (SELECT NM_NO FROM FOOD_ST_NM WHERE NM_FOOD = ?)					"); // FOOD_NM_3
			sql.append("			, (SELECT NM_NO FROM FOOD_ST_NM WHERE NM_FOOD = ?)					"); // FOOD_NM_4
			sql.append("			, (SELECT NM_NO FROM FOOD_ST_NM WHERE NM_FOOD = ?)					"); // FOOD_NM_5
			sql.append("			, (SELECT UNIT_NO FROM FOOD_ST_UNIT WHERE UNIT_NM = ?)				");	// FOOD_UNIT
			sql.append("			, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)					");	// FOOD_DT 1
			sql.append("			, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)					");	// FOOD_DT 2
			sql.append("			, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)					");	// FOOD_DT 3
			sql.append("			, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)					");	// FOOD_DT 4
			sql.append("			, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)					");	// FOOD_DT 5
			sql.append("			, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)					");	// FOOD_DT 6
			sql.append("			, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)					");	// FOOD_DT 7
			sql.append("			, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)					");	// FOOD_DT 8
			sql.append("			, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)					");	// FOOD_DT 9
			sql.append("			, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)					");	// FOOD_DT 10
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_1
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_2
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_3
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_4
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_5
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_6
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_7
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_8
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_9
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_10
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_11
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_12
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_13
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_14
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_15
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_16
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_17
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_18
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_19
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_20
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_21
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_22
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_23
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_24
			sql.append("			, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)					");	// FOOD_EP_25
			sql.append("			, ?																	");	// FOOD_CODE
			sql.append("			, SYSDATE															"); // REG_DATE
			sql.append("			, SYSDATE															");	// MODE_DATE
			sql.append("			, 'Y'																");	// SHOW_FLAG
			sql.append("			, ?																	");	// FOOD_CAT_INDEX
			sql.append("		)																		");
			
			batch 		= new ArrayList<Object[]>();
			itemNoList 	= new ArrayList<String>();
			
			if(excelList!=null && excelList.size()>0){
				for(Map<String,Object> ob : excelList){
					setList = new ArrayList<Object>();
					if(ob.get(nmCell)!=null && !"".equals(ob.get(nmCell))){
						nm_food = ob.get(nmCell).toString().split(",");
						dt_nm = ob.get(dtCell).toString().split(",");
						ex_nm = ob.get(exCell).toString().split(",");
						
						nm_food_str = "";
						dt_nm_str = "";
						ex_nm_str = "";
						
						// MERGE 조건문
						setList.add(ob.get(codeCell).toString().split("[.]")[0]);	// FOOD_CODE
						for(int i=0; i<5; i++){										// FOOD_NM_1~5
							if(nm_food.length>i){ nm_food_str += nm_food[i].trim(); }
							else{ nm_food_str +=""; }
						}
						for(int i=0; i<10; i++){									// FOOD_DT_1~10
							if(dt_nm.length>i){ dt_nm_str += dt_nm[i].trim(); }
							else{ dt_nm_str += ""; }
						}
						for(int i=0; i<25; i++){									// FOOD_EP_1~25
							if(ex_nm.length>i){ ex_nm_str += ex_nm[i].trim(); }
							else{ ex_nm_str += ""; }
						}
						
						setList.add(nm_food_str);
						setList.add(dt_nm_str);
						setList.add(ex_nm_str);
						
						// MERGE UPDATE 문
						setList.add(ob.get(unitCell));								// FOOD_UNIT
						for(String ob2 : dt_nm){		setList.add(ob2.trim());	}		// FOOD_DT_1~10
						if(dt_nm.length<10){for(int i=0; i<10-dt_nm.length; i++){setList.add("");}}
						for(String ob2 : ex_nm){		setList.add(ob2.trim());	}		// FOOD_EP_1~25
						if(ex_nm.length<25){for(int i=0; i<25-ex_nm.length; i++){setList.add("");}}
						setList.add(ob.get(catCell).toString().split("-")[1]);
						
						// MERGE INSERT 문
						setList.add(item_no++);										// ITEM_NO
						setList.add(ob.get(catCell).toString().split("-")[0]);		// CAT_NM
						for(String ob2 : nm_food){		setList.add(ob2.trim());	}		// FOOD_NM_1~5
						if(nm_food.length<5){for(int i=0; i<5-nm_food.length; i++){setList.add("");}}
						setList.add(ob.get(unitCell));								// FOOD_UNIT
						for(String ob2 : dt_nm){		setList.add(ob2.trim());	}		// FOOD_DT_1~10
						if(dt_nm.length<10){for(int i=0; i<10-dt_nm.length; i++){setList.add("");}}
						for(String ob2 : ex_nm){		setList.add(ob2.trim());	}		// FOOD_EP_1~25
						if(ex_nm.length<25){for(int i=0; i<25-ex_nm.length; i++){setList.add("");}}
						setList.add(ob.get(codeCell).toString().split("[.]")[0]);
						setList.add(ob.get(catCell).toString().split("-")[1]);
						
						value = new Object[setList.size()];
						for(int i=0; i<setList.size(); i++){
							value[i] = setList.get(i);
						}
						batch.add(value);
						
						itemNoList.add(Integer.toString(item_no-1));	// FOOD_ITEM_PRE의 S_ITEM_NO에 넣을 ITEM_NO 값
					}
				}
			}
			int itemBatch[] = jdbcTemplate.batchUpdate(sql.toString(), batch);
			
			
			
			// FOOD_ITEM_B -> FOOD_ITEM_BB
			sql = new StringBuffer();
			sql.append("DELETE FROM FOOD_ITEM_BB		");
			jdbcTemplate.update(sql.toString());
			
			sql = new StringBuffer();
			sql.append("INSERT INTO FOOD_ITEM_BB		");
			sql.append("SELECT * FROM FOOD_ITEM_B		");
			jdbcTemplate.update(sql.toString());
			
			// FOOD_ITEM_PRE - > FOOD_ITEM_B
			sql = new StringBuffer();
			sql.append("DELETE FROM FOOD_ITEM_B			");
			jdbcTemplate.update(sql.toString());
			
			sql = new StringBuffer();
			sql.append("INSERT INTO FOOD_ITEM_B			");
			sql.append("SELECT * FROM FOOD_ITEM_PRE		");
			jdbcTemplate.update(sql.toString());
			
			
			// FOOD_ITEM_PRE 테이블의 값을 삭제한 후 다시 입력
			sql = new StringBuffer();
			sql.append("DELETE FROM FOOD_ITEM_PRE								");
			jdbcTemplate.update(sql.toString());
			
			sql = new StringBuffer();
			sql.append("SELECT NVL(MAX(ITEM_NO)+1,1) FROM FOOD_ITEM_PRE			");
			item_pre_no = jdbcTemplate.queryForObject(sql.toString(), Integer.class);
			
			sql = new StringBuffer();
			sql.append("INSERT INTO FOOD_ITEM_PRE(								");
			sql.append("	  S_ITEM_NO											");
			sql.append("	, ITEM_NO											");
			sql.append("	, ITEM_NM											");
			sql.append("	, ITEM_GRP_NO										");
			sql.append("	, ITEM_GRP_ORDER									");
			sql.append("	, ITEM_COMP_NO										");
			sql.append("	, ITEM_COMP_VAL										");
			sql.append("	, REG_DATE											");
			sql.append("	, MOD_DATE											");
			sql.append("	, SHOW_FLAG											");
			sql.append("	, FILE_NO											");
			sql.append("	, LOW_RATIO											");
			sql.append("	, AVR_RATIO											");
			sql.append("	, LB_RATIO											");
			sql.append(")														");
			sql.append("VALUES(													");
			sql.append("(SELECT ITEM_NO																	");
			sql.append(" FROM FOOD_ST_ITEM																");
			sql.append(" WHERE FOOD_CODE = ?															");
			sql.append("	AND (SELECT NM_FOOD FROM FOOD_ST_NM WHERE NM_NO = FOOD_NM_1)  				");
			sql.append("		|| (SELECT NM_FOOD FROM FOOD_ST_NM WHERE NM_NO = FOOD_NM_2)				");
			sql.append("		|| (SELECT NM_FOOD FROM FOOD_ST_NM WHERE NM_NO = FOOD_NM_3)				");
			sql.append("		|| (SELECT NM_FOOD FROM FOOD_ST_NM WHERE NM_NO = FOOD_NM_4)				");
			sql.append("		|| (SELECT NM_FOOD FROM FOOD_ST_NM WHERE NM_NO = FOOD_NM_5) = ?			");
			sql.append("	AND (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_1) 				");
			sql.append("		|| (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_2)			");
			sql.append("		|| (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_3)			");
			sql.append("		|| (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_4)			");
			sql.append("		|| (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_5)			");
			sql.append("		|| (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_6)			");
			sql.append("		|| (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_7)			");
			sql.append("		|| (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_8)			");
			sql.append("		|| (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_9)			");
			sql.append("		|| (SELECT DT_NM FROM FOOD_ST_DT_NM WHERE DT_NO = FOOD_DT_10) = ?		");
			sql.append("	AND (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_1) 				");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_2)				");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_3)				");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_4)				");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_5)				");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_6)				");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_7)				");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_8)				");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_9)				");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_10)			");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_11)			");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_12)			");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_13)			");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_14)			");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_15)			");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_16)			");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_17)			");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_18)			");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_19)			");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_20)			");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_21)			");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_22)			");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_23)			");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_24)			");
			sql.append("		|| (SELECT EX_NM FROM FOOD_ST_EXPL WHERE EX_NO = FOOD_EP_25)	= ?		");
			sql.append(")																				");			
			sql.append("	, ?													");	// ITEM_NO
			sql.append("	, ?													");	// ITEM_NM
			sql.append("	, ?													");	// ITEM_GRP_NO
			sql.append("	, ?													");	// ITEM_GRP_ORDER
			sql.append("	, ?													");	// ITEM_COMP_NO
			sql.append("	, ?													");	// ITEM_COMP_VAL
			sql.append("	, SYSDATE											");	// REG_DATE
			sql.append("	, SYSDATE											");	// MOD_DATE
			sql.append("	, 'Y'												");	// SHOW_FLAG
			sql.append("	, ( SELECT FILE_NO									");	// FILE_NO
			sql.append("	 	FROM FOOD_UP_FILE								");
			sql.append("	 	WHERE FILE_NM = ?)								");
			sql.append("	, ?													");	// LOW_RATIO
			sql.append("	, ?													");	// AVR_RATIO
			sql.append("	, ?													");	// LB_RATIO
			sql.append(")														");
			
			batch = new ArrayList<Object[]>();
			
			if(excelList!=null && excelList.size()>0){
				for(Map<String,Object> ob : excelList){
					setList = new ArrayList<Object>();
					if(ob.get(nmCell)!=null && !"".equals(ob.get(nmCell))){
						nm_food = ob.get(nmCell).toString().split(",");
						dt_nm = ob.get(dtCell).toString().split(",");
						ex_nm = ob.get(exCell).toString().split(",");
						
						nm_food_str = "";
						dt_nm_str = "";
						ex_nm_str = "";
						
						// S_ITEM_NO를 구하기 위한 조건문
						setList.add(ob.get(codeCell).toString().split("[.]")[0]);	// FOOD_CODE
						for(int i=0; i<5; i++){										// FOOD_NM_1~5
							if(nm_food.length>i){ nm_food_str += nm_food[i].trim(); }
							else{ nm_food_str +=""; }
						}
						for(int i=0; i<10; i++){									// FOOD_DT_1~10
							if(dt_nm.length>i){ dt_nm_str += dt_nm[i].trim(); }
							else{ dt_nm_str += ""; }
						}
						for(int i=0; i<25; i++){									// FOOD_EP_1~25
							if(ex_nm.length>i){ ex_nm_str += ex_nm[i].trim(); }
							else{ ex_nm_str += ""; }
						}
						
						setList.add(nm_food_str);
						setList.add(dt_nm_str);
						setList.add(ex_nm_str);
						
						setList.add(item_pre_no++);
						setList.add(ob.get(nmCell));
						setList.add(ob.get(grpNoCell));
						setList.add(ob.get(grpOrderCell));
						setList.add(ob.get(compNoCell));
						setList.add(ob.get(compValCell));
						setList.add(saveFile);
						setList.add(ob.get(lowRatCell));
						setList.add(ob.get(avrRatCell));
						setList.add(ob.get(lbRaCell));
						
						value = new Object[setList.size()];
						for(int i=0; i<setList.size(); i++){
							value[i] = setList.get(i);
						}
						batch.add(value);
					}
				}
			}
			int itemPreBatch[] = jdbcTemplate.batchUpdate(sql.toString(), batch);
			
			
			int nullCheck = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM FOOD_ITEM_B", Integer.class);
			
			if(nullCheck == 0 ){
				sql = new StringBuffer();
				sql.append("INSERT INTO FOOD_ITEM_B			");
				sql.append("SELECT * FROM FOOD_ITEM_PRE		");
				jdbcTemplate.update(sql.toString());
			}
			
			if(itemPreBatch.length>0){
				out.println("<script>");
				out.println("alert('정상적으로 처리되었습니다.');");
				out.println("location.replace('food_item_list.jsp');");
				out.println("</script>");
			}
			
		}catch(Exception e){
			// 예외상황 발생 시 FOOD_ITEM_B 데이터를 FOOD_ITEM_PRE에 넣는다
			sql = new StringBuffer();
			sql.append("DELETE FROM FOOD_ITEM_PRE		");
			jdbcTemplate.update(sql.toString());
			
			sql = new StringBuffer();
			sql.append("INSERT INTO FOOD_ITEM_PRE		");
			sql.append("SELECT * FROM FOOD_ITEM_B		");
			jdbcTemplate.update(sql.toString());
			
			String errMsg = "처리 중 오류가 발생하여 데이터가 복원되었습니다.";
			String err = e.toString().substring(e.toString().indexOf("ORA-"), e.toString().indexOf("ORA-") + 9); 
			
			if("ORA-00001".equals(err)){
				errMsg += "\\n※업로드 데이터 중 중복된 데이터가 있습니다.";
			}
			
			out.println("복원에러 : " + e.toString());
			out.println("<script>");
			out.println("alert('" + errMsg + "');");
			out.println("location.replace('food_item_list.jsp');");
			out.println("</script>");
		}
		
	}catch(Exception e){
		out.println(e.toString());
	}
	
	
	/* if(excelList!=null && excelList.size()>0){
		for(Map<String,Object> ob : excelList){
			out.println("<br>");
			out.println(" cell1 : " + ob.get("cell1") + "<br>");
			out.println(" cell2 : " + ob.get("cell2") + "<br>");
			out.println(" cell3 : " + ob.get("cell3") + "<br>");
			out.println(" cell4 : " + ob.get("cell4") + "<br>");
			out.println(" cell5 : " + ob.get("cell5") + "<br>");
			out.println(" cell6 : " + ob.get("cell6") + "<br>");
			out.println(" cell7 : " + ob.get("cell7") + "<br>");
			out.println(" cell8 : " + ob.get("cell8") + "<br>");
			out.println(" cell9 : " + ob.get("cell9") + "<br>");
			out.println(" cell10 : " + ob.get("cell10") + "<br>");
			out.println(" cell11 : " + ob.get("cell11") + "<br>");
			out.println(" cell12 : " + ob.get("cell12") + "<br>");
			out.println(" cell13 : " + ob.get("cell13") + "<br>");
			out.println(" cell14 : " + ob.get("cell14") + "<br>");
			out.println(" cell15 : " + ob.get("cell15") + "<br>");
			out.println(" cell16 : " + ob.get("cell16") + "<br>");
		}
	} */
%>