<%@page import="egovframework.rfc3.user.web.SessionManager"%>
<%
/**
*   PURPOSE :   조사자 엑셀 다운로드
*   CREATE  :   20180423_mon    KO
*   MODIFY  :   ...
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@page import="org.apache.poi.hssf.usermodel.*" %>
<%@page import="org.apache.poi.hssf.util.*" %>
<%@page import="java.io.*" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>
<%
    
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

SessionManager sessionManager = new SessionManager(request);

String fileName = "조사자 목록";
fileName = URLEncoder.encode(fileName, "UTF-8");
fileName = fileName.replaceAll("\\+", "%20");

// create a small spreadsheet
HSSFWorkbook wb = new HSSFWorkbook();
HSSFSheet sheet = wb.createSheet();
HSSFRow row = sheet.createRow(0);
HSSFCell cell = row.createCell(0);

HSSFFont font = wb.createFont();
font.setFontHeightInPoints((short)13);
font.setBoldweight((short)font.BOLDWEIGHT_BOLD);

HSSFCellStyle headCellStyle = wb.createCellStyle();			
headCellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
headCellStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
headCellStyle.setBottomBorderColor(HSSFColor.BLACK.index);
headCellStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
headCellStyle.setLeftBorderColor(HSSFColor.BLACK.index);
headCellStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
headCellStyle.setRightBorderColor(HSSFColor.BLACK.index);
headCellStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
headCellStyle.setTopBorderColor(HSSFColor.BLACK.index);
headCellStyle.setAlignment (HSSFCellStyle.ALIGN_CENTER);
headCellStyle.setVerticalAlignment (HSSFCellStyle.VERTICAL_CENTER);
headCellStyle.setWrapText(true);
headCellStyle.setFont(font);
headCellStyle.setFillForegroundColor(HSSFColor.LEMON_CHIFFON.index);  
headCellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

HSSFCellStyle cellStyle = wb.createCellStyle();
cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
cellStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
cellStyle.setBottomBorderColor(HSSFColor.BLACK.index);
cellStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
cellStyle.setLeftBorderColor(HSSFColor.BLACK.index);
cellStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
cellStyle.setRightBorderColor(HSSFColor.BLACK.index);
cellStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
cellStyle.setTopBorderColor(HSSFColor.BLACK.index);
cellStyle.setAlignment (HSSFCellStyle.ALIGN_CENTER);
cellStyle.setVerticalAlignment (HSSFCellStyle.VERTICAL_CENTER);
cellStyle.setWrapText(true);

row = sheet.createRow(0);
cell = row.createCell(0); cell.setCellValue("기관/학교"); 		cell.setCellStyle(headCellStyle);
cell = row.createCell(1); cell.setCellValue("권역"); 			cell.setCellStyle(headCellStyle);
cell = row.createCell(2); cell.setCellValue("품목"); 			cell.setCellStyle(headCellStyle);
cell = row.createCell(3); cell.setCellValue("팀"); 			cell.setCellStyle(headCellStyle);
cell = row.createCell(4); cell.setCellValue("조"); 			cell.setCellStyle(headCellStyle);
cell = row.createCell(5); cell.setCellValue("지역"); 			cell.setCellStyle(headCellStyle);
cell = row.createCell(6); cell.setCellValue("조사 식품 수"); 	cell.setCellStyle(headCellStyle);
cell = row.createCell(7); cell.setCellValue("학교/기관명"); 	cell.setCellStyle(headCellStyle);
cell = row.createCell(8); cell.setCellValue("조사자/조사팀장");	cell.setCellStyle(headCellStyle);
cell = row.createCell(9); cell.setCellValue("영양사명"); 		cell.setCellStyle(headCellStyle);
cell = row.createCell(10); cell.setCellValue("등록일"); 		cell.setCellStyle(headCellStyle);
cell = row.createCell(11); cell.setCellValue("승인여부"); 		cell.setCellStyle(headCellStyle);
cell = row.createCell(12); cell.setCellValue("승인일시"); 		cell.setCellStyle(headCellStyle);

int rowCnt = 1;
int rowCnt2 = 1;

String searchSch	= parseNull(request.getParameter("searchSch"), "sch");   //권역
String whereSchType	= " AND A.SCH_TYPE NOT IN ('Z', 'Y', 'X', 'V')		";
if ("ang".equals(searchSch)) {
	whereSchType	= " AND A.SCH_TYPE IN ('Z', 'Y', 'X', 'V')		";
}
String search0		= parseNull(request.getParameter("search0"));   //권역
String search2		= parseNull(request.getParameter("search2"));   //팀
String search3		= parseNull(request.getParameter("search3"));   //조사자/조사팀장 여부
String search1		= parseNull(request.getParameter("search1"));   //검색 선택 분류
String keyword		= parseNull(request.getParameter("keyword"));   //검색어

StringBuffer sql   	 	= null;
Object[] setObj         = null;
List<String> setList	= new ArrayList<String>();
List<FoodVO> foodList 	= null;
FoodVO vo				= null; 
int num = 0;

try{
	sql = new StringBuffer();
	sql.append(" SELECT														");
	sql.append("	A.SCH_NO,												");
	sql.append("	A.SCH_ORG_SID,											");
	sql.append("	A.SCH_TYPE,												");
	sql.append("	A.SCH_ID,												");
	sql.append("	A.SCH_NM,												");
	sql.append("	A.SCH_TEL,												");
	sql.append("	A.SCH_FAX,												");
	sql.append("	A.SCH_AREA,												");
	sql.append("	A.SCH_POST,												");
	sql.append("	A.SCH_ADDR,												");
	sql.append("	A.SCH_FOUND,											");
	sql.append("	A.SCH_URL,												");
	sql.append("	A.SCH_GEN,												");
	sql.append("	A.SHOW_FLAG,											");
	sql.append("	TO_CHAR(A.REG_DATE, 'YYYY-MM-DD') AS REG_DATE,			");
	sql.append("	A.ZONE_NO,												");
	sql.append("	A.CAT_NO,												");
	sql.append("	A.TEAM_NO,												");
	sql.append("	A.SCH_GRADE,											");
	sql.append("	A.SCH_LV,												");
	sql.append("	A.SCH_PW,												");
	sql.append("	A.SCH_APP_FLAG,											");
	sql.append("	A.APP_DATE,												");
	sql.append("	A.ETC1,													");
	sql.append("	A.ETC2,													");
	sql.append("	A.ETC3,													");
	sql.append("	B.NU_NO,												");
	sql.append("	B.NU_NM,												");
	sql.append("	B.NU_TEL,												");
	sql.append("	B.NU_MAIL, 												");
	sql.append("	(	SELECT ZONE_NM 										");
	sql.append("		FROM FOOD_ZONE										");
	sql.append("		WHERE ZONE_NO = A.ZONE_NO	) AS ZONE_NM,			");
	sql.append("	(	SELECT CAT_NM 										");
	sql.append("		FROM FOOD_ST_CAT									");
	sql.append("		WHERE CAT_NO = A.CAT_NO	) AS CAT_NM,				");
	sql.append("	(	SELECT TEAM_NM 										");
	sql.append("		FROM FOOD_TEAM										");
	sql.append("		WHERE TEAM_NO = A.TEAM_NO	) AS TEAM_NM,			");
	sql.append("	(	SELECT JO_NM 										");
	sql.append("		FROM FOOD_JO										");
	sql.append("		WHERE JO_NO = A.JO_NO	) AS JO_NM,					");
    sql.append("	(	SELECT AREA_NM 										");
	sql.append("		FROM FOOD_AREA										");
	sql.append("		WHERE AREA_NO = A.AREA_NO	) AS AREA_NM,			");
	sql.append("	(	SELECT NVL(COUNT(RSCH_ITEM_NO), 0)					");
	sql.append("		FROM FOOD_RSCH_ITEM									");
	sql.append("		WHERE SCH_NO = A.SCH_NO	) AS RSCH_ITEM_CNT			");
	sql.append(" FROM FOOD_SCH_TB A LEFT JOIN FOOD_SCH_NU B					");
	sql.append(" ON A.SCH_NO = B.SCH_NO										");
	sql.append(" WHERE (B.SHOW_FLAG = 'Y'									");
	sql.append(" 	OR A.SCH_NO IN (SELECT A.SCH_NO														");
	sql.append("        			FROM FOOD_SCH_TB A LEFT JOIN FOOD_SCH_NU B ON A.SCH_NO = B.SCH_NO	");
	sql.append("         		 	GROUP BY A.SCH_NO, B.NU_NO											");
	sql.append("         		 	HAVING NVL(B.NU_NO,0) = 0))											");
	sql.append(whereSchType);
	
	if(!"".equals(search0)){
		sql.append(" AND A.ZONE_NO = ?										");
		setList.add(search0);
	}
	if(!"".equals(search1) && !"".equals(keyword) ) {
		if("sch_nm".equals(search1)) {
			sql.append(" AND A.SCH_NM LIKE '%'||?||'%'						");
		}else if("nu_nm".equals(search1)) {
			sql.append(" AND B.NU_NM LIKE '%'||?||'%'						");
		}
		setList.add(keyword);
	}
	if(!"".equals(search2)){
		sql.append(" AND A.TEAM_NO = ?										");
		setList.add(search2);
	}
	if(!"".equals(search3)){
		sql.append(" AND A.SCH_GRADE = ?									");
		setList.add(search3);
	}
	
	sql.append(" ORDER BY DECODE(A.SCH_APP_FLAG, 'N', 1, 'Y', 2), SCH_NM		");
	
	setObj = new Object[setList.size()];
	for(int i=0; i<setList.size(); i++){
		setObj[i] = setList.get(i);
	}

	foodList = jdbcTemplate.query(sql.toString(), new FoodList(), setObj);
    
	for (int i = 0; i < foodList.size(); i++) {
	    row = sheet.createRow(rowCnt++);
	    row.setHeight((short)500); //1000 = 행높이 50  
	    if (i < foodList.size()) {
	        vo    	=   foodList.get(i);
	        if("ang".equals(searchSch)){searchSch="기관";}else{searchSch="학교";}
	        
	        cell    =   row.createCell(0); cell.setCellValue(searchSch); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(1); cell.setCellValue(vo.zone_nm); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(2); cell.setCellValue(vo.cat_nm); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(3); cell.setCellValue(vo.team_nm); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(4); cell.setCellValue(vo.jo_nm); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(5); cell.setCellValue(vo.area_nm); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(6); cell.setCellValue(vo.rsch_item_cnt); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(7); cell.setCellValue(vo.sch_nm); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(8); cell.setCellValue(outSchGrade(vo.sch_grade)); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(9); cell.setCellValue(vo.nu_nm); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(10); cell.setCellValue(vo.reg_date); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(11); cell.setCellValue(vo.sch_app_flag); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(12); cell.setCellValue(vo.app_date); cell.setCellStyle(cellStyle);
	    }
	}
	
	for (short j=0; j<13; j++){
	    sheet.autoSizeColumn(j);
	    sheet.setColumnWidth(j, (sheet.getColumnWidth(j))+(short)1024);	// 1024 = 열너비 3.14
	}
	
} catch (Exception e) {
	out.println(e.toString());
} finally {
	
}



// write it as an excel attachment
ByteArrayOutputStream outByteStream = new ByteArrayOutputStream();
wb.write(outByteStream);
byte [] outArray = outByteStream.toByteArray();
response.setContentType("application/ms-excel");
response.setContentLength(outArray.length);
response.setHeader("Expires:", "0"); // eliminates browser caching
response.setHeader("Content-Disposition", "attachment; filename=" + fileName + ".xls");
OutputStream outStream = response.getOutputStream();
outStream.write(outArray);
outStream.flush();
    
%>