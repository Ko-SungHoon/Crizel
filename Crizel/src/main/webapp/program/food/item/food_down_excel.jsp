<%@page import="egovframework.rfc3.user.web.SessionManager"%>
<%
/**
*   PURPOSE :   식품 엑셀 다운로드
*   CREATE  :   20180323_fri    JI
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

String fileName = "학교급식 거래실례가격조사";
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
cell = row.createCell(0); cell.setCellValue("구분"); 			cell.setCellStyle(headCellStyle);
cell = row.createCell(1); cell.setCellValue("식품코드"); 		cell.setCellStyle(headCellStyle);
cell = row.createCell(2); cell.setCellValue("식품명"); 		cell.setCellStyle(headCellStyle);
cell = row.createCell(3); cell.setCellValue("상세식품명"); 		cell.setCellStyle(headCellStyle);
cell = row.createCell(4); cell.setCellValue("식품설명"); 		cell.setCellStyle(headCellStyle);
cell = row.createCell(5); cell.setCellValue("단위"); 			cell.setCellStyle(headCellStyle);
cell = row.createCell(6); cell.setCellValue("그룹"); 			cell.setCellStyle(headCellStyle);
cell = row.createCell(7); cell.setCellValue("그룹\n순서"); 	cell.setCellStyle(headCellStyle);
cell = row.createCell(8); cell.setCellValue("비교\n부여코드"); 	cell.setCellStyle(headCellStyle);
sheet.addMergedRegion(new CellRangeAddress(
        0, //시작 행번호
        0, //마지막 행번호
        8, //시작 열번호
        9  //마지막 열번호
));
cell = row.createCell(10); cell.setCellValue("전월\n최저가\n비교 비율"); 	cell.setCellStyle(headCellStyle);
cell = row.createCell(11); cell.setCellValue("전월\n평균가\n비교 비율"); 	cell.setCellStyle(headCellStyle);
cell = row.createCell(12); cell.setCellValue("최저가-최고가\n비교 비율"); 	cell.setCellStyle(headCellStyle);

int rowCnt = 1;
int rowCnt2 = 1;

StringBuffer sql   	 	= null;
String sql_str      	= null;
String where_str    	= null;
List<FoodVO> itemList 	= null;
FoodVO vo				= null; 
Object[] setObj			= null;
List<String> setList	= new ArrayList<String>();
int num = 0;

String keyword  =   parseNull(request.getParameter("keyword"));
String search1  =   parseNull(request.getParameter("search1"));
String cat_no   =   parseNull(request.getParameter("cat_no"), "1");

try{
	
	
	sql = new StringBuffer();
	sql.append("	SELECT ROWNUM AS RNUM, A.* FROM (										                    ");
    sql.append("    SELECT																						");
    sql.append("	  PRE.ITEM_NO																				");
    sql.append("	, PRE.S_ITEM_NO																				");
    sql.append("	, ITEM.CAT_NO																				");
    sql.append("	, ITEM.FOOD_CODE																			");
    sql.append("	, ITEM.FOOD_CAT_INDEX																		");
    sql.append("	, (SELECT CAT_NM FROM FOOD_ST_CAT WHERE CAT_NO = ITEM.CAT_NO) AS CAT_NM						");
    sql.append("	, ( SELECT SUBSTR( XMLAGG(  																");
    sql.append("							XMLELEMENT(COL ,',', NM_FOOD) ORDER BY NM_FOOD).EXTRACT('//text()' 	");
    sql.append("	).GETSTRINGVAL(),2) NM_FOOD 																");
    sql.append("	FROM FOOD_ST_NM 																			");
    sql.append("	WHERE NM_NO IN (FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5)) AS NM_FOOD      	");
    sql.append("	, ( SELECT SUBSTR( XMLAGG(  																");
    sql.append("	    					XMLELEMENT(COL,',',DT_NM) ORDER BY DT_NM).EXTRACT('//text()' 		");
    sql.append("	).GETSTRINGVAL(),2) DT_NM 																	");
    sql.append("	FROM FOOD_ST_DT_NM 																			");
    sql.append("	WHERE DT_NO IN (FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5						");
    sql.append("	, FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10)) AS DT_NM							");
    sql.append("	, ( SELECT SUBSTR( XMLAGG(  																");
    sql.append("	    					XMLELEMENT(COL ,',', EX_NM) ORDER BY EX_NM).EXTRACT('//text()' 		");
    sql.append("	).GETSTRINGVAL(),2) EX_NM 																	");
    sql.append("	FROM FOOD_ST_EXPL																			");
    sql.append("	WHERE EX_NO IN (FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5						");
    sql.append("	, FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10									");
    sql.append("	, FOOD_EP_11, FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15								");
    sql.append("	, FOOD_EP_16, FOOD_EP_17, FOOD_EP_18, FOOD_EP_19, FOOD_EP_20								");
    sql.append("	, FOOD_EP_21, FOOD_EP_22, FOOD_EP_23, FOOD_EP_24, FOOD_EP_25)) AS EX_NM						");
    sql.append("	, (SELECT UNIT_NM FROM FOOD_ST_UNIT WHERE UNIT_NO = ITEM.FOOD_UNIT) AS UNIT_NM				");
    sql.append("	, TO_CHAR(PRE.REG_DATE, 'YYYY-MM-DD') AS REG_DATE											");
    sql.append("	, TO_CHAR(PRE.MOD_DATE, 'YYYY-MM-DD') AS MOD_DATE											");
    sql.append("	, PRE.SHOW_FLAG																				");
    sql.append("	, (SELECT REG_IP FROM FOOD_UP_FILE WHERE FILE_NO = PRE.FILE_NO) REG_IP						");
    sql.append("	, (SELECT REG_ID FROM FOOD_UP_FILE WHERE FILE_NO = PRE.FILE_NO) REG_ID						");
    sql.append("	, (SELECT NVL(COUNT(ITEM_NO), 0) FROM FOOD_ST_ITEM_LOG WHERE ITEM_NO = ITEM.ITEM_NO) LOG_CNT");

    sql.append("	FROM FOOD_ITEM_PRE PRE LEFT JOIN FOOD_ST_ITEM ITEM ON PRE.S_ITEM_NO = ITEM.ITEM_NO			");
    sql.append("	ORDER BY PRE.ITEM_NO																		");
    sql.append("	) A WHERE 1=1																				");
    sql.append("        AND A.CAT_NO = ?                                                                        ");
    setList.add(cat_no);
    if(!"".equals(search1)){
    	if("nm_food".equals(search1)){
    		sql.append("AND A.NM_FOOD LIKE '%'||?||'%'															");
    	}else if("dt_nm".equals(search1)){
    		sql.append("AND A.DT_NM LIKE '%'||?||'%'															");
    	}else if("ex_nm".equals(search1)){
    		sql.append("AND A.EX_NM LIKE '%'||?||'%'															");
    	}
    	setList.add(keyword);
    }
    
    setObj = new Object[setList.size()];
    for(int i=0; i<setList.size(); i++){
    	setObj[i] = setList.get(i);
    }
    
    itemList = jdbcTemplate.query(sql.toString(), new FoodList(), setObj);
    
	for (int i = 0; i < itemList.size(); i++) {
	    row = sheet.createRow(rowCnt++);
	    row.setHeight((short)500); //1000 = 행높이 50  
	    if (i < itemList.size()) {
	        vo    	=   itemList.get(i);
	        cell    =   row.createCell(0); cell.setCellValue(vo.cat_nm); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(1); cell.setCellValue(vo.food_code); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(2); cell.setCellValue(vo.nm_food); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(3); cell.setCellValue(vo.dt_nm); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(4); cell.setCellValue(vo.ex_nm); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(5); cell.setCellValue(vo.unit_nm); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(6); cell.setCellValue(vo.item_grp_no); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(7); cell.setCellValue(vo.item_grp_order); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(8); cell.setCellValue(vo.item_comp_no); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(9); cell.setCellValue(vo.item_comp_val); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(10); cell.setCellValue(vo.low_ratio); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(11); cell.setCellValue(vo.avr_ratio); cell.setCellStyle(cellStyle);
	        cell    =   row.createCell(12); cell.setCellValue(vo.lb_ratio); cell.setCellStyle(cellStyle);
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