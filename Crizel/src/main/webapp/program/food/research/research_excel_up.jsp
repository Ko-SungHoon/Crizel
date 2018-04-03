<%@page import="egovframework.rfc3.user.web.SessionManager"%>
<%
/**
*   PURPOSE :   조사개시 엑셀 업로드
*   CREATE  :   20180402_mon    KO
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

%>

<%!
public boolean getException(Map<String,Object> ob, String cell, int length){
	byte[] b = ob.get(cell).toString().getBytes();
	if(b.length>length){return true;}
	else{return false;}
}

public Map<String,Object> getCatStr(Map<String,Object> ob, String[] cat_nm){
	Map<String,Object> map = new HashMap<String,Object>();
	String val = "";
	if(ob.get(cat_nm[0])!=null && !"".equals(ob.get(cat_nm[0]).toString())){
		val = ob.get(cat_nm[0]).toString();
	}
	
	for(int i=1; i<cat_nm.length; i++){
		if(ob.get(cat_nm[i])!=null && !"".equals(ob.get(cat_nm[i]).toString())){
			val += "," + ob.get(cat_nm[i]).toString();
		}
	}
	
	map.put("cat_nm", ob.get("cell1").toString());
	map.put("sch_nm", val);
	
	return map;
}
%>
<%
	try{
		catDupCheckList = new ArrayList<String>();
		if(excelList!=null && excelList.size()>0){
			byte[] b = null;
			int exceptionCheck = 0;
			boolean continueCheck = false;
			for(Map<String,Object> ob : excelList){
				continueCheck = false;
				
				if(cat_nm_arr!=null && cat_nm_arr.length>0){
					for(String ob2 : cat_nm_arr){
						if(ob.get(catCell).toString().split("-")[0].trim().equals(ob2)){
							continueCheck = true;
						}
					}
				}
				
				if(continueCheck){
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

					// 구분값 중복체크 리스트
					catDupCheckList.add(ob.get(catCell).toString().split("-")[0].trim() + ob.get(catCell).toString().split("-")[1].trim());
					
					// Map에 구분값과 해당 구분값을 기준으로 한 학교를 ',' 를 기준으로 문자열에 저장한 데이터를 넣음
					catMap = new HashMap<String,Object>();
					catMap.putAll(getCatStr(ob, schCell));
					catList.add(catMap);
				}
			}
			
			
			if(catDupCheckList!=null && catDupCheckList.size()>0){
				for(int i=0; i<catDupCheckList.size(); i++){
					for(int j=i+1; j<catDupCheckList.size(); j++){
						if(catDupCheckList.get(i).equals(catDupCheckList.get(j))){
							out.println("<script>alert('구분값이 중복되어 있습니다.');location.replace('food_item_list.jsp');</script>"); return;
						}
					}
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
		
		// 구분,학교명 저장 테이블을 삭제
		sql = new StringBuffer();
		sql.append("DELETE FROM FOOD_RSCH_SCH			");
		jdbcTemplate.update(sql.toString());
		
		// 구분,학교명을 저장
		sql = new StringBuffer();
		sql.append("INSERT INTO FOOD_RSCH_SCH(CAT_NM, SCH_NM)		");
		sql.append("VALUES(?, ?)									");
		batch = new ArrayList<Object[]>();
		if(catList!=null && catList.size()>0){
			for(Map<String,Object> ob : catList){
				String[] sch_nm_split = ob.get("sch_nm").toString().split(",");
				for(int i=0; i<sch_nm_split.length; i++){
					if(!"".equals(sch_nm_split[i].trim())){
						value = new Object[]{
								  ob.get("cat_nm").toString().trim()
							    , sch_nm_split[i].trim()
						};
						batch.add(value);
					}
				}
			}
		}
		jdbcTemplate.batchUpdate(sql.toString(), batch);
		
		
	}catch(Exception e){
		out.println(e.toString());
	}

	out.println("rsch_year : " + rsch_year + "<br>");
	out.println("rsch_month : " + rsch_month + "<br>");
	out.println("str_date : " + str_date + "<br>");
	out.println("mid_date : " + mid_date + "<br>");
	out.println("end_date : " + end_date + "<br>");
	out.println("rsch_nm : " + rsch_nm + "<br>");
	
	for(String ob : cat_nm_arr){
		out.println(ob + "<br>");
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
			out.println(" cell18 : " + ob.get("cell18") + "<br>");
			out.println(" cell20 : " + ob.get("cell20") + "<br>");
			out.println(" cell22 : " + ob.get("cell22") + "<br>");
			out.println(" cell24 : " + ob.get("cell24") + "<br>");
			out.println(" cell26 : " + ob.get("cell26") + "<br>");
			out.println(" cell28 : " + ob.get("cell28") + "<br>");
			out.println(" cell30 : " + ob.get("cell30") + "<br>");
			out.println(" cell32 : " + ob.get("cell32") + "<br>");
			out.println(" cell34 : " + ob.get("cell34") + "<br>");
			out.println(" cell36 : " + ob.get("cell36") + "<br>");
			out.println(" cell38 : " + ob.get("cell38") + "<br>");
			out.println(" cell40 : " + ob.get("cell40") + "<br>");
			out.println(" cell42 : " + ob.get("cell42") + "<br>");
			out.println(" cell44 : " + ob.get("cell44") + "<br>");
			out.println(" cell46 : " + ob.get("cell46") + "<br>");
			out.println(" cell48 : " + ob.get("cell48") + "<br>");
			out.println(" cell50 : " + ob.get("cell50") + "<br>");
			out.println(" cell52 : " + ob.get("cell52") + "<br>");
			out.println(" cell54 : " + ob.get("cell54") + "<br>");
			out.println(" cell56 : " + ob.get("cell56") + "<br>");
			out.println(" cell58 : " + ob.get("cell58") + "<br>");
			out.println(" cell60 : " + ob.get("cell60") + "<br>");
			out.println(" cell62 : " + ob.get("cell62") + "<br>");
			out.println(" cell64 : " + ob.get("cell64") + "<br>");
			out.println(" cell66 : " + ob.get("cell66") + "<br>");
			out.println(" cell68 : " + ob.get("cell68") + "<br>");
			out.println(" cell70 : " + ob.get("cell70") + "<br>");
			out.println(" cell72 : " + ob.get("cell72") + "<br>");
			out.println(" cell74 : " + ob.get("cell74") + "<br>");
			out.println(" cell76 : " + ob.get("cell76") + "<br>");
			out.println(" cell78 : " + ob.get("cell78") + "<br>");
			out.println(" cell80 : " + ob.get("cell80") + "<br>");
		}
	}  */
%>