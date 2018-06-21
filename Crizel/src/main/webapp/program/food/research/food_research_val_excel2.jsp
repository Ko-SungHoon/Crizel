<%@ page import="egovframework.rfc3.user.web.SessionManager"%>
<%
/**
*   PURPOSE :   조사가격조회 엑셀 다운로드 jsp
*   CREATE  :   20180419_thur   JI
*   MODIFY  :   20180425_wed	KO	최저가 삭제 및 비교그룹 추가
*   MODIFY  :   20180510_fri	JI  선택 조사 조사식품만 조회 엑셀 다운
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.*" %>
<%@ page import="java.io.*" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>
<%!
	private String moneyComma (String money) {
		DecimalFormat df	=	new DecimalFormat("#,###");
		String rtnMoney	=	null;
		if (money != null && !"-".equals(money.trim())) {
			rtnMoney	=	df.format(Integer.parseInt(money));
			return rtnMoney;
		} else {
			return money;
		}
	}
%>
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
//cell.setCellValue("최저가");
cell.setCellValue("비교그룹");
cell.setCellStyle(headCellStyle);
cell = row.createCell(12);
cell.setCellValue("평균가");
cell.setCellStyle(headCellStyle);
cell = row.createCell(13);
cell.setCellValue("중앙가");
cell.setCellStyle(headCellStyle);
cell = row.createCell(14);
cell.setCellValue("권역 통합평균가");
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
String rsch_no		= 	parseNull(request.getParameter("rsch_no"));

String[] keyCateOp	=	{"title", "detail"};
String[] keyCateTxt =	{"조사명", "식품설명"};

try{
    //권역 목록
    sql		=	new StringBuffer();
    sql.append(" SELECT  				\n");
    sql.append(" ZONE_NO,  				\n");
    sql.append(" ZONE_NM				\n");
    sql.append(" FROM FOOD_ZONE  		\n");
    sql.append(" WHERE SHOW_FLAG = 'Y'  \n");
    zoneList	=	jdbcTemplate.query(sql.toString(), new FoodList());
    
  
    //카테고리 목록
    sql		=	new StringBuffer();
    sql.append(" SELECT  				\n");
    sql.append(" CAT_NO,  				\n");
    sql.append(" CAT_NM  				\n");
    sql.append(" FROM FOOD_ST_CAT  		\n");
    sql.append(" WHERE SHOW_FLAG = 'Y'  \n");
    cateList	=	jdbcTemplate.query(sql.toString(), new FoodList());
    
  //검색 조건
  		setWhere = new ArrayList<String>();
  		sqlWhere =	new String();
  		sqlWhere += "WHERE 1=1						\n";
  		sqlWhere += "AND RSCHTB.SHOW_FLAG = 'Y'		\n";
  		sqlWhere += "AND VAL.STS_FLAG = 'Y'			\n";
  		if(!"".equals(srchSdate) && !"".equals(srchEdate)){
  			sqlWhere += "AND ((RSCHTB.STR_DATE >= TO_DATE(?, 'YY/MM/DD') AND RSCHTB.STR_DATE <= TO_DATE(?, 'YY/MM/DD'))		\n";
  			sqlWhere += "	 OR (RSCHTB.END_DATE >= TO_DATE(?, 'YY/MM/DD') AND RSCHTB.END_DATE <= TO_DATE(?, 'YY/MM/DD')))	\n";
  			setWhere.add(srchSdate);
  			setWhere.add(srchEdate);
  			setWhere.add(srchSdate);
  			setWhere.add(srchEdate);
  		}
  		if(!"".equals(rsch_no)){
  			sqlWhere += "AND VAL.RSCH_NO = ?	\n";
  			setWhere.add(rsch_no);
  		}
  		if(!"".equals(zoneType)){
  			sqlWhere += "AND ZONE.ZONE_NO = ?	\n";
  			setWhere.add(zoneType);
  		}
  		if(!"".equals(foodItem)){
  			sqlWhere += "AND CAT.CAT_NO = ?		\n";
  			setWhere.add(foodItem);
  		}
  		if(!"".equals(foodName)){
  			sqlWhere += "AND ( SELECT SUBSTR( XMLAGG(  																							\n";																				
  			sqlWhere += "                    XMLELEMENT(COL ,',', NM_FOOD) ORDER BY NM_FOOD).EXTRACT('//text()' 								\n";								
  			sqlWhere += "                ).GETSTRINGVAL(),2) NM_FOOD 																			\n";									
  			sqlWhere += "  FROM FOOD_ST_NM 																										\n";											
  			sqlWhere += "  WHERE NM_NO IN (ITEM.FOOD_NM_1, ITEM.FOOD_NM_2, ITEM.FOOD_NM_3, ITEM.FOOD_NM_4, ITEM.FOOD_NM_5)) LIKE '%'||?||'%'	\n";
  			setWhere.add(foodName);
  		}
  		if(!"".equals(keywordCate)){
  			if("title".equals(keywordCate)){
  				sqlWhere += "AND RSCHTB.RSCH_NM LIKE '%'||?||'%'			\n";
  			}else if("detail".equals(keywordCate)){	
  				sqlWhere += "AND ( SELECT SUBSTR( XMLAGG(																							\n";																					  
  				sqlWhere += "                        XMLELEMENT(COL ,',', EX_NM) ORDER BY EX_NM).EXTRACT('//text()'									\n";										 
  				sqlWhere += "                    ).GETSTRINGVAL(),2) EX_NM																			\n";															 
  				sqlWhere += "      FROM FOOD_ST_EXPL																								\n";																					
  				sqlWhere += "      WHERE EX_NO IN (ITEM.FOOD_EP_1, ITEM.FOOD_EP_2, ITEM.FOOD_EP_3, ITEM.FOOD_EP_4, ITEM.FOOD_EP_5					\n";										
  				sqlWhere += "     		, ITEM.FOOD_EP_6, ITEM.FOOD_EP_7, ITEM.FOOD_EP_8, ITEM.FOOD_EP_9, ITEM.FOOD_EP_10							\n";										
  				sqlWhere += "         	, ITEM.FOOD_EP_11, ITEM.FOOD_EP_12, ITEM.FOOD_EP_13, ITEM.FOOD_EP_14, ITEM.FOOD_EP_15						\n";									
  				sqlWhere += "        	, ITEM.FOOD_EP_16, ITEM.FOOD_EP_17, ITEM.FOOD_EP_18, ITEM.FOOD_EP_19, ITEM.FOOD_EP_20						\n";									
  				sqlWhere += "         	, ITEM.FOOD_EP_21, ITEM.FOOD_EP_22, ITEM.FOOD_EP_23, ITEM.FOOD_EP_24, ITEM.FOOD_EP_25)) LIKE '%'||?||'%'	\n";
  			}
  			setWhere.add(keywordInp);
  		}
  		
  		sql = new StringBuffer();
  		sql.append("  SELECT																													\n"); 
		sql.append("    ROWNUM AS RNUM, A.*																										\n");
		sql.append("    , DECODE(AVR_VAL, NULL																									\n");
		sql.append("        , 'N'																												\n");
		sql.append("        , CASE																												\n");
		sql.append("            WHEN (SELECT MAX(AVR_VAL)																						\n"); 
		sql.append("                FROM FOOD_RSCH_VAL																							\n"); 
		sql.append("                WHERE RSCH_NO = A.RSCH_NO AND ITEM_NO = A.ITEM_NO)															\n"); 
		sql.append("                - (SELECT MIN(AVR_VAL)																						\n"); 
		sql.append("                   FROM FOOD_RSCH_VAL																						\n"); 
		sql.append("                   WHERE RSCH_NO = A.RSCH_NO AND ITEM_NO = A.ITEM_NO)														\n");
		sql.append("                <= (SELECT MAX(AVR_VAL)																						\n"); 
		sql.append("                    FROM FOOD_RSCH_VAL																						\n"); 
		sql.append("                    WHERE RSCH_NO = A.RSCH_NO AND ITEM_NO = A.ITEM_NO) * 0.3 THEN 'N'										\n");
		sql.append("            ELSE 'Y'																										\n");
		sql.append("          END																												\n");
		sql.append("        ) AS RCH_BACK																										\n");
		sql.append("  FROM(																														\n");
		sql.append("    SELECT																													\n"); 
		sql.append("      VAL.RSCH_VAL_NO    																									\n");
		sql.append("      , VAL.RSCH_NO																											\n");
		sql.append("      , VAL.ITEM_NO																											\n");
		sql.append("      , (CAT.CAT_NM || '-' || ITEM.FOOD_CAT_INDEX) AS CAT_NM																\n");
		sql.append("      , ZONE.ZONE_NM																										\n");
		sql.append("      , ITEM.FOOD_CODE																										\n");
		sql.append("      , RSCHTB.RSCH_NM																										\n");
		sql.append("      , ( SELECT SUBSTR( XMLAGG(																							\n");  																									
		sql.append("                            XMLELEMENT(COL ,',', NM_FOOD) ORDER BY NM_FOOD).EXTRACT('//text()'								\n"); 										
		sql.append("                        ).GETSTRINGVAL(),2) NM_FOOD																			\n"); 																				
		sql.append("          FROM FOOD_ST_NM																									\n"); 																											
		sql.append("          WHERE NM_NO IN (ITEM.FOOD_NM_1, ITEM.FOOD_NM_2, ITEM.FOOD_NM_3, ITEM.FOOD_NM_4, ITEM.FOOD_NM_5)) AS NM_FOOD		\n");								 
		sql.append("      , ( SELECT SUBSTR( XMLAGG(																							\n");																									  
		sql.append("                            XMLELEMENT(COL,',',DT_NM) ORDER BY DT_NM).EXTRACT('//text()'									\n");											 
		sql.append("                        ).GETSTRINGVAL(),2) DT_NM																			\n");																					 
		sql.append("          FROM FOOD_ST_DT_NM																								\n");																										 
		sql.append("          WHERE DT_NO IN (ITEM.FOOD_DT_1, ITEM.FOOD_DT_2, ITEM.FOOD_DT_3, ITEM.FOOD_DT_4, ITEM.FOOD_DT_5					\n");											
		sql.append("                        , ITEM.FOOD_DT_6, ITEM.FOOD_DT_7, ITEM.FOOD_DT_8, ITEM.FOOD_DT_9, ITEM.FOOD_DT_10)) AS DT_NM		\n");
		sql.append("      , ( SELECT SUBSTR( XMLAGG(																							\n");																									  
		sql.append("                            XMLELEMENT(COL ,',', EX_NM) ORDER BY EX_NM).EXTRACT('//text()'									\n");											 
		sql.append("                        ).GETSTRINGVAL(),2) EX_NM																			\n");																					 
		sql.append("          FROM FOOD_ST_EXPL																									\n");																											
		sql.append("          WHERE EX_NO IN (ITEM.FOOD_EP_1, ITEM.FOOD_EP_2, ITEM.FOOD_EP_3, ITEM.FOOD_EP_4, ITEM.FOOD_EP_5					\n");											
		sql.append("                        , ITEM.FOOD_EP_6, ITEM.FOOD_EP_7, ITEM.FOOD_EP_8, ITEM.FOOD_EP_9, ITEM.FOOD_EP_10					\n");											
		sql.append("                        , ITEM.FOOD_EP_11, ITEM.FOOD_EP_12, ITEM.FOOD_EP_13, ITEM.FOOD_EP_14, ITEM.FOOD_EP_15				\n");										
		sql.append("                        , ITEM.FOOD_EP_16, ITEM.FOOD_EP_17, ITEM.FOOD_EP_18, ITEM.FOOD_EP_19, ITEM.FOOD_EP_20				\n");										
		sql.append("                        , ITEM.FOOD_EP_21, ITEM.FOOD_EP_22, ITEM.FOOD_EP_23, ITEM.FOOD_EP_24, ITEM.FOOD_EP_25)) AS EX_NM	\n");
		sql.append("      , (SELECT UNIT_NM FROM FOOD_ST_UNIT WHERE UNIT_NO = ITEM.FOOD_UNIT) AS UNIT_NM										\n");     
		sql.append("      , VAL.NON_SEASON																										\n");
		sql.append("      , VAL.NON_DISTRI																										\n");
		sql.append("      , PRE.ITEM_COMP_VAL																									\n");
		sql.append("      , PRE.ITEM_COMP_NO																									\n");
		sql.append("      , TRUNC(VAL.AVR_VAL+9, -1) AS AVR_VAL																					\n");
		sql.append("      , TRUNC(VAL.CENTER_VAL+9, -1) AS CENTER_VAL																			\n");
		sql.append("      , TRUNC((SELECT ROUND(AVG(AVR_VAL), 0) FROM FOOD_RSCH_VAL WHERE RSCH_NO = VAL.RSCH_NO AND ITEM_NO = VAL.ITEM_NO)+9, -1) AS ZONE_AVR_VAL	\n");
		sql.append("      , (SELECT SCH_NM FROM FOOD_SCH_TB WHERE SCH_NO = VAL.SCH_NO) AS SCH_NM		\n");
		sql.append("      , (SELECT NU_NM FROM FOOD_SCH_NU WHERE NU_NO = VAL.NU_NO) AS NU_NM			\n");
		sql.append("      , (SELECT TEAM_NM FROM FOOD_TEAM WHERE TEAM_NO = VAL.TEAM_NO) AS TEAM_NM		\n");
		sql.append("      , VAL.RSCH_VAL1		\n");
		sql.append("      , VAL.RSCH_VAL2		\n");
		sql.append("      , VAL.RSCH_VAL3		\n");
		sql.append("      , VAL.RSCH_VAL4		\n");
		sql.append("      , VAL.RSCH_VAL5		\n");
		sql.append("      , VAL.RSCH_LOC1		\n");
		sql.append("      , VAL.RSCH_LOC2		\n");
		sql.append("      , VAL.RSCH_LOC3		\n");
		sql.append("      , VAL.RSCH_LOC4		\n");
		sql.append("      , VAL.RSCH_LOC5		\n");
		sql.append("      , VAL.RSCH_COM1		\n");
		sql.append("      , VAL.RSCH_COM2		\n");
		sql.append("      , VAL.RSCH_COM3		\n");
		sql.append("      , VAL.RSCH_COM4		\n");
		sql.append("      , VAL.RSCH_COM5		\n");
		sql.append("      , VAL.RSCH_REASON		\n");
		sql.append("      , VAL.REG_DATE		\n");
		sql.append("      , VAL.RSCH_DATE		\n");
		sql.append("    FROM FOOD_RSCH_VAL VAL LEFT JOIN FOOD_ST_CAT CAT ON VAL.CAT_NO = CAT.CAT_NO					\n");
		sql.append("                           LEFT JOIN FOOD_ST_ITEM ITEM ON VAL.ITEM_NO = ITEM.ITEM_NO			\n");
		sql.append("                           LEFT JOIN FOOD_ZONE ZONE ON VAL.ZONE_NO = ZONE.ZONE_NO				\n");
		sql.append("                           LEFT JOIN FOOD_RSCH_TB RSCHTB ON VAL.RSCH_NO = RSCHTB.RSCH_NO		\n");
		sql.append("                           LEFT JOIN FOOD_ITEM_PRE PRE ON VAL.ITEM_NO = PRE.ITEM_NO				\n");
		sql.append(sqlWhere);
		sql.append(" 	ORDER BY RSCHTB.RSCH_NO DESC, VAL.ITEM_NO, VAL.RSCH_VAL_NO									\n");
		sql.append(") A																								\n");

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
            //cell    =   row.createCell(11); cell.setCellValue(vo.low_val); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(11); cell.setCellValue(vo.item_comp_no); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(12); cell.setCellValue(moneyComma(parseNull(vo.avr_val, " - "))); cell.setCellStyle(cellStyle);
            cell    =   row.createCell(13); cell.setCellValue(moneyComma(parseNull(vo.center_val, " - "))); cell.setCellStyle(cellStyle);
            /* if ("3".equals(vo.zone_avr_cnt)) {
                cell    =   row.createCell(14); cell.setCellValue(moneyComma(parseNull(vo.zone_avr_val, " - "))); cell.setCellStyle(cellStyle);
            } else {
                cell    =   row.createCell(14); cell.setCellValue("-"); cell.setCellStyle(cellStyle);
            } */
            cell    =   row.createCell(14); cell.setCellValue(moneyComma(parseNull(vo.zone_avr_val, " - "))); cell.setCellStyle(cellStyle);
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
                    int cellCnt = 0;
                    for (int j = 1; j <= valMap.size(); j++) {
                        if (j != minNo && j != maxNo) {
                        	if(cellCnt == 0){
                        		cell    =   row.createCell(17); cell.setCellValue(moneyComma(valMap.get(j))); cell.setCellStyle(cellStyle);
                        	}else if(cellCnt == 1){
                        		cell    =   row.createCell(18); cell.setCellValue(moneyComma(valMap.get(j))); cell.setCellStyle(cellStyle);
                        	}else{
                        		cell    =   row.createCell(19); cell.setCellValue(moneyComma(valMap.get(j))); cell.setCellStyle(cellStyle);
                        	}
                        	cellCnt++;
                        }
                    }
                //가격이 3개 일 경우
                } else if (valMapCnt == 3) {
                	int cellCnt = 0;
                    for (int j = 1; j <= valMap.size(); j++) {
                        if (!"-".equals(valMap.get(j))) {
                        	if(cellCnt == 0){
                        		cell    =   row.createCell(17); cell.setCellValue(moneyComma(valMap.get(j))); cell.setCellStyle(cellStyle);
                        	}else if(cellCnt == 1){
                        		cell    =   row.createCell(18); cell.setCellValue(moneyComma(valMap.get(j))); cell.setCellStyle(cellStyle);
                        	}else{
                        		cell    =   row.createCell(19); cell.setCellValue(moneyComma(valMap.get(j))); cell.setCellStyle(cellStyle);
                        	}
                        	cellCnt++;
                        }
                    }
                //가격이 1개일 경우... 혹시 모르니...
                } else if (valMapCnt == 1) {
                    for (int j = 1; j <= valMap.size(); j++) {
                        if (!"-".equals(valMap.get(j))) {
                            cell    =   row.createCell(17); cell.setCellValue(moneyComma(valMap.get(j))); cell.setCellStyle(cellStyle);
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