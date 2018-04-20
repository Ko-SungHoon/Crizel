<%@ page import="egovframework.rfc3.user.web.SessionManager"%>
<%
/**
*   PURPOSE :   조사가격조회 엑셀 다운로드 jsp
*   CREATE  :   20180419_thur   JI
*   MODIFY  :   ...
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.*" %>
<%@ page import="java.io.*" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>
<%
    
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String fileName = "조사가격조회";
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

/** Cell Title Setting **/
row = sheet.createRow(0);
cell = row.createCell(0);
cell.setCellValue("조사번호");
cell.setCellStyle(headCellStyle);
cell = row.createCell(1);
cell.setCellValue("품목구분");
cell.setCellStyle(headCellStyle);
cell = row.createCell(2);
cell.setCellValue("권역");
cell.setCellStyle(headCellStyle);
cell = row.createCell(3);
cell.setCellValue("조사명");
cell.setCellStyle(headCellStyle);
cell = row.createCell(4);
cell.setCellValue("식품코드");
cell.setCellStyle(headCellStyle);
cell = row.createCell(5);
cell.setCellValue("식품명");
cell.setCellStyle(headCellStyle);
cell = row.createCell(6);
cell.setCellValue("상세 식품명");
cell.setCellStyle(headCellStyle);
cell = row.createCell(7);
cell.setCellValue("식품설명");
cell.setCellStyle(headCellStyle);
cell = row.createCell(8);
cell.setCellValue("단위");
cell.setCellStyle(headCellStyle);
cell = row.createCell(9);
cell.setCellValue("비계절");
cell.setCellStyle(headCellStyle);
cell = row.createCell(10);
cell.setCellValue("비유통");
cell.setCellStyle(headCellStyle);
cell = row.createCell(11);
cell.setCellValue("최저가");
cell.setCellStyle(headCellStyle);
cell = row.createCell(12);
cell.setCellValue("평균가");
cell.setCellStyle(headCellStyle);
cell = row.createCell(13);
cell.setCellValue("중앙가");
cell.setCellStyle(headCellStyle);
cell = row.createCell(14);
cell.setCellValue("세권역 통합평균가");
cell.setCellStyle(headCellStyle);
cell = row.createCell(15);
cell.setCellValue("조사자");
cell.setCellStyle(headCellStyle);
cell = row.createCell(16);
cell.setCellValue("소속");
cell.setCellStyle(headCellStyle);
cell = row.createCell(17);
cell.setCellValue("조사가1");
cell.setCellStyle(headCellStyle);
cell = row.createCell(18);
cell.setCellValue("조사가2");
cell.setCellStyle(headCellStyle);
cell = row.createCell(19);
cell.setCellValue("조사가3");
cell.setCellStyle(headCellStyle);
cell = row.createCell(20);
cell.setCellValue("조사처1");
cell.setCellStyle(headCellStyle);
cell = row.createCell(21);
cell.setCellValue("조사처2");
cell.setCellStyle(headCellStyle);
cell = row.createCell(22);
cell.setCellValue("조사처3");
cell.setCellStyle(headCellStyle);
cell = row.createCell(23);
cell.setCellValue("브랜드1");
cell.setCellStyle(headCellStyle);
cell = row.createCell(24);
cell.setCellValue("브랜드2");
cell.setCellStyle(headCellStyle);
cell = row.createCell(25);
cell.setCellValue("브랜드3");
cell.setCellStyle(headCellStyle);
cell = row.createCell(26);
cell.setCellValue("조사날짜");
cell.setCellStyle(headCellStyle);

//parameter
int rowCnt = 1;
int rowCnt2 = 1;

StringBuffer sql 	= 	null;
String sqlWhere		=	"";
int resultCnt 		=	0;
int cnt				= 	0;

List<FoodVO> zoneList	=	null;
List<FoodVO> cateList	=	null;
List<FoodVO> searchList	=	null;
List<String> setWhere	=	new ArrayList<String>();
FoodVO vo				= null;
HashMap<Integer, String> valMap	=	null;
HashMap<Integer, String> locMap	=	null;
HashMap<Integer, String> comMap	=	null;
int valMapCnt	=	0;
int minVal		=	0;
int minNo		=	0;
int maxVal		=	0;
int maxNo		=	0;

Object[] setObject 		= 	null;

//parameter
FoodVO foodVO		=	new FoodVO();
String srchSdate	=	parseNull(request.getParameter("srchSdate"));
String srchEdate	=	parseNull(request.getParameter("srchEdate"));
String zoneType		=	parseNull(request.getParameter("zoneType"));
String foodItem		=	parseNull(request.getParameter("foodItem"));
String foodName		=	parseNull(request.getParameter("foodName"));
String keywordCate 	=	parseNull(request.getParameter("keywordCate"));
String keywordInp	=	parseNull(request.getParameter("keywordInp"));

String[] keyCateOp	=	{"title", "detail"};
String[] keyCateTxt =	{"조사명", "식품설명"};

//검색어 where
if(!"".equals(keywordInp)){
    
    //제목 where
    if("title".equals(keywordCate))	{
        sqlWhere	+=	" AND TB.RSCH_NM LIKE '%' ||?|| '%' 	\n";
        setWhere.add(keywordInp);
    }
    
    //식품 상세설명 where
    else if("detail".equals(keywordCate)){
        sqlWhere	+=	" AND (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', EX_NM)			\n";
        sqlWhere	+=	" ORDER BY EX_NM).EXTRACT('//text()').GETSTRINGVAL(), 2)		\n";
        sqlWhere	+=	" EX_NM															\n";
        sqlWhere	+=	" FROM FOOD_ST_EXPL												\n";
        sqlWhere	+=	" WHERE EX_NO IN(												\n";
        sqlWhere	+=	" FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5,		\n";
        sqlWhere	+=	" FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10, 		\n";
        sqlWhere	+=	" FOOD_EP_11, FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15,	\n";
        sqlWhere	+=	" FOOD_EP_16, FOOD_EP_17, FOOD_EP_18, FOOD_EP_19, FOOD_EP_20,	\n";
        sqlWhere	+=	" FOOD_EP_21, FOOD_EP_22, FOOD_EP_23, FOOD_EP_24, FOOD_EP_25))	\n";
        sqlWhere	+=	" LIKE '%' ||?|| '%'											\n";
        setWhere.add(keywordInp);
    }
}

//날짜검색

if(!"".equals(srchSdate) && !"".equals(srchEdate)){
    sqlWhere	+=	" AND ((TB.STR_DATE >= TO_DATE(?, 'YY/MM/DD') AND TB.STR_DATE <= TO_DATE(?, 'YY/MM/DD')) 	\n";
    sqlWhere	+=	" OR (TB.END_DATE >= TO_DATE(?, 'YY/MM/DD') AND TB.END_DATE <= TO_DATE(?, 'YY/MM/DD'))) 	\n";
    
    setWhere.add(srchSdate);
    setWhere.add(srchEdate);
    setWhere.add(srchSdate);
    setWhere.add(srchEdate);
}

try{
    //권역 목록
    sql		=	new StringBuffer();
    sql.append(" SELECT  				\n");
    sql.append(" ZONE_NO,  				\n");
    sql.append(" ZONE_NM				\n");
    sql.append(" FROM FOOD_ZONE  		\n");
    sql.append(" WHERE SHOW_FLAG = 'Y'  \n");
    zoneList	=	jdbcTemplate.query(sql.toString(), new FoodList());
    
    //권역선택 where
    if(zoneList != null && zoneList.size() > 0 && !"".equals(zoneType)){
        for(int i=0; i<zoneList.size(); i++){
            if(zoneList.get(i).zone_no.equals(zoneType)){
                sqlWhere	+=	" AND SCH.ZONE_NO = ? 			\n";
                setWhere.add(zoneType);
            }
        }
    }

    //카테고리 목록
    sql		=	new StringBuffer();
    sql.append(" SELECT  				\n");
    sql.append(" CAT_NO,  				\n");
    sql.append(" CAT_NM  				\n");
    sql.append(" FROM FOOD_ST_CAT  		\n");
    sql.append(" WHERE SHOW_FLAG = 'Y'  \n");
    cateList	=	jdbcTemplate.query(sql.toString(), new FoodList());
    
    //품목구분 where
    if(cateList != null && cateList.size() > 0){
        if(!"".equals(foodItem)){
            for(int i=0; i<cateList.size(); i++){
                if(cateList.get(i).cat_no.equals(foodItem)){
                    sqlWhere	+=	" AND ITEM.CAT_NO = ? 				\n";
                    setWhere.add(foodItem);
                }
            }
        }
    }
            
    //품목 검색 where
    sqlWhere	+=	" AND (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', NM_FOOD)	\n";
    sqlWhere	+=	" ORDER BY NM_FOOD).EXTRACT('//text()').GETSTRINGVAL(),2)	\n";
    sqlWhere	+=	" NM_FOOD													\n";
    sqlWhere	+=	" FROM FOOD_ST_NM											\n";
    sqlWhere	+=	" WHERE NM_NO IN (											\n";
    sqlWhere	+=	" FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5))	\n";
    sqlWhere	+=	" LIKE '%' ||?|| '%'										\n";
    setWhere.add(foodName);

    //검색목록
    sql		=	new StringBuffer();
    sql.append(" SELECT 														\n");
    sql.append(" VAL.RSCH_VAL_NO,												\n");
    sql.append(" PRE.ITEM_NO,													\n");
    sql.append(" (SELECT CAT_NM	FROM FOOD_ST_CAT								\n");
    sql.append(" WHERE CAT_NO = ITEM.CAT_NO) AS CAT_NM,							\n");

    sql.append(" (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', NM_FOOD)			\n");
    sql.append(" ORDER BY NM_FOOD).EXTRACT('//text()').GETSTRINGVAL(),2)		\n");
    sql.append(" NM_FOOD														\n");
    sql.append(" FROM FOOD_ST_NM												\n");
    sql.append(" WHERE NM_NO IN (												\n");
    sql.append(" FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5))		\n");
    sql.append(" AS NM_FOOD,													\n");

    sql.append(" (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', DT_NM)				\n");
    sql.append(" ORDER BY DT_NM).EXTRACT('//text()').GETSTRINGVAL(), 2)			\n");
    sql.append(" DT_NM															\n");
    sql.append(" FROM FOOD_ST_DT_NM												\n");
    sql.append(" WHERE DT_NO IN(												\n");
    sql.append(" FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5,			\n");
    sql.append(" FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10))		\n");
    sql.append(" AS DT_NM, 														\n");

    sql.append(" (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', EX_NM)				\n");
    sql.append(" ORDER BY EX_NM).EXTRACT('//text()').GETSTRINGVAL(), 2)			\n");
    sql.append(" EX_NM															\n");
    sql.append(" FROM FOOD_ST_EXPL												\n");
    sql.append(" WHERE EX_NO IN(												\n");
    sql.append(" FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5,			\n");
    sql.append(" FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10, 		\n");
    sql.append(" FOOD_EP_11, FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15,	\n");
    sql.append(" FOOD_EP_16, FOOD_EP_17, FOOD_EP_18, FOOD_EP_19, FOOD_EP_20,	\n");
    sql.append(" FOOD_EP_21, FOOD_EP_22, FOOD_EP_23, FOOD_EP_24, FOOD_EP_25))	\n");
    sql.append(" AS EX_NM, 														\n");

    sql.append(" (SELECT UNIT_NM FROM FOOD_ST_UNIT 								\n");
    sql.append(" WHERE UNIT_NO = ITEM.FOOD_UNIT) AS UNIT_NM, 					\n");
    sql.append(" PRE.REG_DATE,													\n");
    sql.append(" PRE.MOD_DATE,													\n");
    sql.append(" PRE.SHOW_FLAG,													\n");
    sql.append(" (SELECT REG_IP FROM FOOD_UP_FILE							 	\n");
    sql.append(" WHERE FILE_NO = PRE.FILE_NO) REG_IP,							\n");
    sql.append(" (SELECT REG_ID FROM FOOD_UP_FILE								\n");
    sql.append(" WHERE FILE_NO = PRE.FILE_NO) REG_ID,							\n");
    sql.append(" PRE.ITEM_GRP_NO,												\n");
    sql.append(" PRE.ITEM_GRP_ORDER,											\n");
    sql.append(" PRE.ITEM_COMP_NO, 												\n");
    sql.append(" PRE.ITEM_COMP_VAL,												\n");
    sql.append(" PRE.LOW_RATIO, 												\n");
    sql.append(" PRE.AVR_RATIO, 												\n");
    sql.append(" PRE.LB_RATIO,	 												\n");
    sql.append(" VAL.LOW_VAL,	 												\n");
    sql.append(" VAL.AVR_VAL,	 												\n");
    sql.append(" VAL.CENTER_VAL, 												\n");
    sql.append(" ( 	SELECT														\n");
    sql.append(" 		AVG(AVR_VAL)											\n");
    sql.append(" 	FROM FOOD_RSCH_VAL											\n");
    sql.append(" 	WHERE RSCH_NO = VAL.RSCH_NO									\n");
    sql.append(" 		AND ITEM_NO = VAL.ITEM_NO								\n");
    sql.append(" ) AS ZONE_AVR_VAL,												\n");
    sql.append(" (SELECT TEAM_NM                                                \n");
    sql.append("   FROM FOOD_TEAM                                               \n");
    sql.append("   WHERE TEAM_NO = VAL.TEAM_NO                                  \n");
    sql.append(" ) AS TEAM_NM,                                                  \n");
    sql.append(" TB.RSCH_NM,	 												\n");
    sql.append(" SCH.SCH_NM,	 												\n");
    sql.append(" SCH.ZONE_NO,	 												\n");
    sql.append(" NU.NU_NM,  	 												\n");
    sql.append(" ZONE.ZONE_NM,	 												\n");
    sql.append(" ITEM.FOOD_CAT_INDEX,											\n");
    sql.append(" ITEM.FOOD_CODE,    											\n");
    sql.append(" VAL.NON_SEASON,												\n");
    sql.append(" VAL.NON_DISTRI,												\n");
    sql.append(" VAL.RSCH_VAL1,													\n");
    sql.append(" VAL.RSCH_VAL2,													\n");
    sql.append(" VAL.RSCH_VAL3,													\n");
    sql.append(" VAL.RSCH_VAL4,													\n");
    sql.append(" VAL.RSCH_VAL5,													\n");
    sql.append(" VAL.RSCH_LOC1,													\n");
    sql.append(" VAL.RSCH_LOC2,													\n");
    sql.append(" VAL.RSCH_LOC3,													\n");
    sql.append(" VAL.RSCH_LOC4,													\n");
    sql.append(" VAL.RSCH_LOC5,													\n");
    sql.append(" VAL.RSCH_COM1,													\n");
    sql.append(" VAL.RSCH_COM2,													\n");
    sql.append(" VAL.RSCH_COM3,													\n");
    sql.append(" VAL.RSCH_COM4,													\n");
    sql.append(" VAL.RSCH_COM5													\n");
    sql.append("    , (                        									\n");
    sql.append("        CASE                                                    \n");
    sql.append("        WHEN (                                                  \n");
    sql.append("            VAL.LOW_VAL / ((SELECT Z.LOW_VAL                    \n");
    sql.append("            FROM (SELECT * FROM FOOD_RSCH_VAL                   \n");
    sql.append("                ORDER BY RSCH_VAL_NO DESC) Z                    \n");
    sql.append("            WHERE Z.RSCH_VAL_NO < VAL.RSCH_VAL_NO               \n");
    sql.append("                AND Z.RSCH_NO < VAL.RSCH_NO                     \n");
    sql.append("                AND Z.ITEM_NO = VAL.ITEM_NO                     \n");
    sql.append("                AND Z.ZONE_NO = VAL.ZONE_NO                     \n");
    sql.append("                AND ROWNUM = 1) + VAL.LOW_VAL) * 100            \n");
    sql.append("        ) IS NULL                                               \n");
    sql.append("        THEN 'Y'                                                \n");
    sql.append("        WHEN (                                                  \n");
    sql.append("            VAL.LOW_VAL / ((SELECT Z.LOW_VAL                    \n");
    sql.append("            FROM (SELECT * FROM FOOD_RSCH_VAL                   \n");
    sql.append("                ORDER BY RSCH_VAL_NO DESC) Z                    \n");
    sql.append("            WHERE Z.RSCH_VAL_NO < VAL.RSCH_VAL_NO               \n");
    sql.append("                AND Z.RSCH_NO < VAL.RSCH_NO                     \n");
    sql.append("                AND Z.ITEM_NO = VAL.ITEM_NO                     \n");
    sql.append("                AND Z.ZONE_NO = VAL.ZONE_NO                     \n");
    sql.append("                AND ROWNUM = 1) + VAL.LOW_VAL) * 100            \n");
    sql.append("        ) < PRE.LOW_RATIO                                       \n");
    sql.append("        THEN 'N'                                                \n");
    sql.append("        ELSE 'Y'                                                \n");
    sql.append("        END                                                     \n");
    sql.append("    ) AS LOW_FLAG            									\n");
    sql.append("    , (															\n");
    sql.append("		CASE			 										\n");
    sql.append("        WHEN (			 										\n");
    sql.append("			VAL.AVR_VAL / ((SELECT Z.LOW_VAL			 		\n");
    sql.append("            FROM (SELECT * FROM FOOD_RSCH_VAL					\n");
    sql.append("            	ORDER BY RSCH_VAL_NO DESC) Z					\n");
    sql.append("            WHERE Z.RSCH_VAL_NO < VAL.RSCH_VAL_NO				\n");
    sql.append("            	AND Z.RSCH_NO < VAL.RSCH_NO						\n");
    sql.append("            	AND Z.ITEM_NO = VAL.ITEM_NO						\n");
    sql.append("            	AND Z.ZONE_NO = VAL.ZONE_NO						\n");
    sql.append("            	AND ROWNUM = 1) + VAL.LOW_VAL) * 100			\n");
    sql.append("            ) IS NULL											\n");
    sql.append("		THEN 'Y'												\n");
    sql.append("        WHEN (													\n");
    sql.append("        	VAL.LOW_VAL / ((SELECT Z.LOW_VAL					\n");
    sql.append("            FROM (SELECT * FROM FOOD_RSCH_VAL					\n");
    sql.append("            	ORDER BY RSCH_VAL_NO DESC) Z					\n");
    sql.append("            WHERE Z.RSCH_VAL_NO < VAL.RSCH_VAL_NO				\n");
    sql.append("            	AND Z.RSCH_NO < VAL.RSCH_NO						\n");
    sql.append("            	AND Z.ITEM_NO = VAL.ITEM_NO						\n");
    sql.append("            	AND ROWNUM = 1) + VAL.LOW_VAL) * 100			\n");
    sql.append("		) < PRE.LOW_RATIO										\n");
    sql.append("        THEN 'N'												\n");
    sql.append("        ELSE 'Y'												\n");
    sql.append("        END														\n");
    sql.append("		) AS AVR_FLAG,											\n");
    sql.append(" VAL.RSCH_DATE													\n");

    sql.append(" FROM FOOD_ITEM_PRE PRE 										\n");
    sql.append(" LEFT JOIN FOOD_ST_ITEM ITEM ON PRE.S_ITEM_NO = ITEM.ITEM_NO	\n");
    sql.append(" LEFT JOIN FOOD_RSCH_VAL VAL ON VAL.ITEM_NO = ITEM.ITEM_NO		\n");
    sql.append(" LEFT JOIN FOOD_RSCH_TB TB ON VAL.RSCH_NO = TB.RSCH_NO			\n");
    sql.append(" LEFT JOIN FOOD_SCH_TB SCH ON VAL.SCH_NO = SCH.SCH_NO			\n");
    sql.append(" LEFT JOIN FOOD_SCH_NU NU ON VAL.NU_NO = NU.NU_NO				\n");
    sql.append(" LEFT JOIN FOOD_ZONE ZONE ON VAL.ZONE_NO = ZONE.ZONE_NO			\n");

    sql.append(" WHERE TB.SHOW_FLAG = 'Y'										\n");
    sql.append(" /*AND VAL.STS_FLAG = 'Y'*/										\n");		
    sql.append(sqlWhere);
    sql.append(" ORDER BY PRE.ITEM_NO											\n");

    if(setWhere != null && setWhere.size() > 0){
        setObject	=	new Object[setWhere.size()];
        for(int i=0; i<setWhere.size(); i++){
            setObject[i]	=	setWhere.get(i);
        }
    }
    
    searchList		=	jdbcTemplate.query(sql.toString(), new FoodList(), setObject);

    for (int i = 0; i < searchList.size(); i++) {

        row = sheet.createRow(rowCnt++);
        if (i < searchList.size()) {

            vo    	=   searchList.get(i);
	        cell    =   row.createCell(0); cell.setCellValue(vo.rsch_val_no); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(1); cell.setCellValue(vo.cat_nm + " - " + vo.food_cat_index); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(2); cell.setCellValue(vo.zone_nm); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(3); cell.setCellValue(vo.rsch_nm); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(4); cell.setCellValue(vo.food_code); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(5); cell.setCellValue(vo.nm_food); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(6); cell.setCellValue(vo.dt_nm); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(7); cell.setCellValue(vo.ex_nm); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(8); cell.setCellValue(vo.unit_nm); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(9); cell.setCellValue(vo.non_season); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(10); cell.setCellValue(vo.non_distri); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(11); cell.setCellValue(vo.low_val); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(12); cell.setCellValue(vo.avr_val); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(13); cell.setCellValue(vo.center_val); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(14); cell.setCellValue(vo.zone_avr_val); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(15); cell.setCellValue(vo.sch_nm +" / "+ vo.nu_nm); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(16); cell.setCellValue(vo.zone_nm +" / "+ vo.team_nm); cell.setCellStyle(cellStyle);
            /*조사가 정렬 출력*/
            valMap  =   null;
            valMap	=	new HashMap<Integer, String>();
            valMap.put(1, parseNull(vo.rsch_val1, "-"));
            valMap.put(2, parseNull(vo.rsch_val2, "-"));
            valMap.put(3, parseNull(vo.rsch_val3, "-"));
            valMap.put(4, parseNull(vo.rsch_val4, "-"));
            valMap.put(5, parseNull(vo.rsch_val5, "-"));
            /*조사처 정렬 출력*/
            locMap  =   null;
            locMap  =   new HashMap<Integer, String>();
            locMap.put(1, parseNull(vo.rsch_loc1, "-"));
            locMap.put(2, parseNull(vo.rsch_loc2, "-"));
            locMap.put(3, parseNull(vo.rsch_loc3, "-"));
            locMap.put(4, parseNull(vo.rsch_loc4, "-"));
            locMap.put(5, parseNull(vo.rsch_loc5, "-"));

            /*브랜드 정렬 출력*/
            comMap  =   null;
            comMap  =   new HashMap<Integer, String>();
            comMap.put(1, parseNull(vo.rsch_com1, "-"));
            comMap.put(2, parseNull(vo.rsch_com2, "-"));
            comMap.put(3, parseNull(vo.rsch_com3, "-"));
            comMap.put(4, parseNull(vo.rsch_com4, "-"));
            comMap.put(5, parseNull(vo.rsch_com5, "-"));
            valMapCnt   =   0;  //초기화
            for (int j = 1; j <= valMap.size(); j++) {
                if (!"-".equals(valMap.get(j))) {valMapCnt++;}
            }
            //가격 유무 여부 확인
            if (valMapCnt > 0) {
                if (valMapCnt == 5) {
                    //5개의 값이 모두 같을 경우 산정하기....
                    int duplCnt	=	0;
                    for (int j = 1; j <= valMap.size(); j++) {
                        if (valMap.get(1).equals(valMap.get(j))) {
                            duplCnt++;
                        }
                    }
                    //최고값 최저값
                    int strNo	=	0;
                    for (int j = 1; j <= valMap.size(); j++) {
                        if (!"-".equals(valMap.get(j)) && strNo == 0) {
                            strNo	=	j;
                            minVal	=	Integer.parseInt(valMap.get(j));
                            maxVal	=	Integer.parseInt(valMap.get(j));
                        }
                        if (!"-".equals(valMap.get(j)) && minVal < Integer.parseInt(valMap.get(j))) {
                            minVal	=	minVal;
                        } else if (!"-".equals(valMap.get(j)) && minVal >= Integer.parseInt(valMap.get(j))) {
                            minVal	=	Integer.parseInt(valMap.get(j));
                            if (duplCnt == valMap.size()) {minNo	=	j - 1;} 
                            else {minNo	=	j;}
                        }
                        if (!"-".equals(valMap.get(j)) && maxVal > Integer.parseInt(valMap.get(j))) {
                            maxVal	=	maxVal;
                        } else if (!"-".equals(valMap.get(j)) && maxVal <= Integer.parseInt(valMap.get(j))) {
                            maxVal	=	Integer.parseInt(valMap.get(j));
                            maxNo	=	j;
                        }
                    }
                    for (int j = 1; j <= valMap.size(); j++) {
                        if (j != minNo && j != maxNo) {
                            cell    =   row.createCell(17); cell.setCellValue(valMap.get(j)); cell.setCellStyle(cellStyle);
                            cell    =   row.createCell(18); cell.setCellValue(valMap.get(j+1)); cell.setCellStyle(cellStyle);
                            cell    =   row.createCell(19); cell.setCellValue(valMap.get(j+2)); cell.setCellStyle(cellStyle);
                            break;
                        }
                    }
                //가격이 3개 일 경우
                } else if (valMapCnt == 3) {
                    for (int j = 1; j <= valMap.size(); j++) {
                        if (!"-".equals(valMap.get(j))) {
                            cell    =   row.createCell(17); cell.setCellValue(valMap.get(j)); cell.setCellStyle(cellStyle);
                            cell    =   row.createCell(18); cell.setCellValue(valMap.get(j+1)); cell.setCellStyle(cellStyle);
                            cell    =   row.createCell(19); cell.setCellValue(valMap.get(j+2)); cell.setCellStyle(cellStyle);
                            break;
                        }
                    }
                //가격이 1개일 경우... 혹시 모르니...
                } else if (valMapCnt == 1) {
                    for (int j = 1; j <= valMap.size(); j++) {
                        if (!"-".equals(valMap.get(j))) {
                            cell    =   row.createCell(17); cell.setCellValue(valMap.get(j)); cell.setCellStyle(cellStyle);
                        }
                    }
                    cell    =   row.createCell(18); cell.setCellValue(" - "); cell.setCellStyle(cellStyle);
                    cell    =   row.createCell(19); cell.setCellValue(" - "); cell.setCellStyle(cellStyle);
                }
            } else {
                cell    =   row.createCell(17); cell.setCellValue(" - "); cell.setCellStyle(cellStyle);
                cell    =   row.createCell(18); cell.setCellValue(" - "); cell.setCellStyle(cellStyle);
                cell    =   row.createCell(19); cell.setCellValue(" - "); cell.setCellStyle(cellStyle);
            }
            //조사처 유무 여부 확인
            if (valMapCnt > 0) {
                if (valMapCnt == 5) {
                    for (int j = 1; j <= locMap.size(); j++) {
                        if (j != minNo && j != maxNo) {
                            cell    =   row.createCell(20); cell.setCellValue(locMap.get(j)); cell.setCellStyle(cellStyle);
                            cell    =   row.createCell(21); cell.setCellValue(locMap.get(j+1)); cell.setCellStyle(cellStyle);
                            cell    =   row.createCell(22); cell.setCellValue(locMap.get(j+2)); cell.setCellStyle(cellStyle);
                            break;
                        }
                    }
                } else if (valMapCnt == 3) {
                    for (int j = 1; j <= locMap.size(); j++) {
                        if (!"-".equals(locMap.get(j))) {
                            cell    =   row.createCell(20); cell.setCellValue(locMap.get(j)); cell.setCellStyle(cellStyle);
                            cell    =   row.createCell(21); cell.setCellValue(locMap.get(j+1)); cell.setCellStyle(cellStyle);
                            cell    =   row.createCell(22); cell.setCellValue(locMap.get(j+2)); cell.setCellStyle(cellStyle);
                            break;
                        }
                    }
                } else if (valMapCnt == 1) {
                    for (int j = 1; j <= locMap.size(); j++) {
                        if (!"-".equals(locMap.get(j))) {
                            cell    =   row.createCell(20); cell.setCellValue(locMap.get(j)); cell.setCellStyle(cellStyle);
                        }
                    }
                    cell    =   row.createCell(21); cell.setCellValue(" - "); cell.setCellStyle(cellStyle);
                    cell    =   row.createCell(22); cell.setCellValue(" - "); cell.setCellStyle(cellStyle);
                }
            } else {
                cell    =   row.createCell(20); cell.setCellValue(" - "); cell.setCellStyle(cellStyle);
                cell    =   row.createCell(21); cell.setCellValue(" - "); cell.setCellStyle(cellStyle);
                cell    =   row.createCell(22); cell.setCellValue(" - "); cell.setCellStyle(cellStyle);
            }
            //브랜드 유무 여부 확인
            if (valMapCnt > 0) {
                if (valMapCnt == 5) {
                    for (int j = 1; j <= comMap.size(); j++) {
                        if (j != minNo && j != maxNo) {
                            cell    =   row.createCell(23); cell.setCellValue(comMap.get(j)); cell.setCellStyle(cellStyle);
                            cell    =   row.createCell(24); cell.setCellValue(comMap.get(j+1)); cell.setCellStyle(cellStyle);
                            cell    =   row.createCell(25); cell.setCellValue(comMap.get(j+2)); cell.setCellStyle(cellStyle);
                            break;
                        }
                    }
                } else if (valMapCnt == 3) {
                    for (int j = 1; j <= comMap.size(); j++) {
                        if (!"-".equals(comMap.get(j))) {
                            cell    =   row.createCell(23); cell.setCellValue(comMap.get(j)); cell.setCellStyle(cellStyle);
                            cell    =   row.createCell(24); cell.setCellValue(comMap.get(j+1)); cell.setCellStyle(cellStyle);
                            cell    =   row.createCell(25); cell.setCellValue(comMap.get(j+2)); cell.setCellStyle(cellStyle);
                            break;
                        }
                    }
                } else if (valMapCnt == 1) {
                    for (int j = 1; j <= comMap.size(); j++) {
                        if (!"-".equals(comMap.get(j))) {
                            cell    =   row.createCell(23); cell.setCellValue(comMap.get(j)); cell.setCellStyle(cellStyle);
                        }
                    }
                    cell    =   row.createCell(24); cell.setCellValue(" - "); cell.setCellStyle(cellStyle);
                    cell    =   row.createCell(25); cell.setCellValue(" - "); cell.setCellStyle(cellStyle);
                }
            } else {
                cell    =   row.createCell(23); cell.setCellValue(" - "); cell.setCellStyle(cellStyle);
                cell    =   row.createCell(24); cell.setCellValue(" - "); cell.setCellStyle(cellStyle);
                cell    =   row.createCell(25); cell.setCellValue(" - "); cell.setCellStyle(cellStyle);
            }
            cell    =   row.createCell(26); cell.setCellValue(vo.rsch_date); cell.setCellStyle(cellStyle);
        }
    }

}catch(Exception e){
    alert(out, e.toString());
}finally{

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