<%@page import="egovframework.rfc3.user.web.SessionManager"%>
<%
/**
*   PURPOSE :   조사자(팀장) 엑셀 업로드
*   CREATE  :   20180403_tue    KO
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
	List<String> catDupCheckList 		= null;

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
				
				// DB 데이터 길이보다 글자가 많을 때 오류처리
				if(getException(ob, zoneCell, 50)){out.println("<script>alert('권역명 값이 너무 큽니다');location.replace('"+returnPage+"');</script>"); return;}
				if(getException(ob, catCell, 50)){out.println("<script>alert('품목 값이 너무 큽니다');location.replace('"+returnPage+"');</script>"); return;}
				if(getException(ob, teamCell, 100)){out.println("<script>alert('팀 값이 너무 큽니다');location.replace('"+returnPage+"');</script>"); return;}
				if(getException(ob, joCell, 100)){out.println("<script>alert('조 값이 너무 큽니다');location.replace('"+returnPage+"');</script>"); return;}
				if(getException(ob, areaCell, 128)){out.println("<script>alert('지역 값이 너무 큽니다');location.replace('"+returnPage+"');</script>"); return;}
				if(getException(ob, schCell, 1000)){out.println("<script>alert('학교 값이 너무 큽니다');location.replace('"+returnPage+"');</script>"); return;}
				
				// 모든셀이 빈칸이 아니면서 필수입력값 데이터가 비어있을 경우 오류처리
				if(!(   "".equals(ob.get(zoneCell).toString()) 	&& "".equals(ob.get(catCell).toString())
					&& 	"".equals(ob.get(teamCell).toString()) 	&& "".equals(ob.get(joCell).toString())
					&& 	"".equals(ob.get(areaCell).toString())  && 	"".equals(ob.get(schCell).toString())
					&& 	"".equals(ob.get(gradeCell).toString())	)){
					if("".equals(ob.get(zoneCell).toString())){ out.println("<script>alert('권역 데이터가 비어있습니다.');location.replace('"+returnPage+"');</script>"); return;}
					if("".equals(ob.get(catCell).toString())){out.println("<script>alert('구분 데이터가 비어있습니다.');location.replace('"+returnPage+"');</script>"); return;}
					if("".equals(ob.get(teamCell).toString())){out.println("<script>alert('팀 데이터가 비어있습니다.');location.replace('"+returnPage+"');</script>"); return;}
					if("".equals(ob.get(joCell).toString())){out.println("<script>alert('조 데이터가 비어있습니다.');location.replace('"+returnPage+"');</script>"); return;}
					if("".equals(ob.get(areaCell).toString())){out.println("<script>alert('지역 데이터가 비어있습니다.');location.replace('"+returnPage+"');</script>"); return;}
					if("".equals(ob.get(schCell).toString())){out.println("<script>alert('학교 데이터가 비어있습니다.');location.replace('"+returnPage+"');</script>"); return;}
					if("".equals(ob.get(gradeCell).toString())){out.println("<script>alert('등급 데이터가 비어있습니다.');location.replace('"+returnPage+"');</script>"); return;}
				}
			}
			
		}
				
		if("".equals(regId)){
			out.println("<script>");
			out.println("alert('로그인 후 다시 시도 하십시오.');");
			out.println("location.replace('"+returnPage+"');");
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
		
		
		sql = new StringBuffer();
		
		
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