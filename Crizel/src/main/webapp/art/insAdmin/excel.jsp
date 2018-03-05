<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@page import="org.apache.poi.hssf.usermodel.*" %>
<%@page import="org.apache.poi.hssf.util.*" %>
<%@page import="java.io.*" %>
<meta charset="UTF-8">
<%!
private class InsVO{
	public int req_no;
	public String req_id;
	public String req_group;
	public String req_mng_nm;
	public String req_mng_tel;
	public int req_inst_cnt;
	public String req_memo;
	public String reg_ip;
	public String reg_date;
	public String show_flag;
	public String apply_flag;
	public String apply_date;
	
	public int count;
	
	public String inst_cat;
	public String inst_cat_nm;
	public int inst_no;
	public String inst_nm;
	public int inst_req_cnt;
	
	public String inst_name;
	public int max_cnt;
	public int curr_cnt;
	public int rowspan;
	
	public int artcode_no;
	public String code_tbl;
	public String code_col;
	public String code_name;
	public String code_val1;
	public String code_val2;
	public String code_val3;
	public int order1;
	public int order2;
	public int order3;
}
	
private class InsVOMapper implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
    	vo.req_no			= rs.getInt("REQ_NO");	
    	vo.req_id			= rs.getString("REQ_ID");	
    	vo.req_group		= rs.getString("REQ_GROUP");	
    	vo.req_mng_nm		= rs.getString("REQ_MNG_NM");	
    	vo.req_mng_tel		= rs.getString("REQ_MNG_TEL");	
    	vo.req_inst_cnt		= rs.getInt("REQ_INST_CNT");	
    	vo.req_memo			= rs.getString("REQ_MEMO");	
    	vo.reg_ip			= rs.getString("REG_IP");	
    	vo.reg_date			= rs.getString("REG_DATE");	
    	vo.show_flag		= rs.getString("SHOW_FLAG");
    	vo.apply_flag		= rs.getString("APPLY_FLAG");
    	vo.apply_date		= rs.getString("APPLY_DATE");
    	
    	vo.count			= rs.getInt("COUNT");
    	
    	vo.inst_cat			= rs.getString("INST_CAT");	
    	vo.inst_cat_nm		= rs.getString("INST_CAT_NM");	
    	vo.inst_no			= rs.getInt("INST_NO");	
    	vo.inst_nm			= rs.getString("INST_NM");	
    	vo.inst_req_cnt		= rs.getInt("INST_REQ_CNT");	
        return vo;
    }
}

private class TotalList implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
    	vo.inst_cat_nm		= rs.getString("INST_CAT_NM");	
    	vo.inst_name		= rs.getString("INST_NAME");	
    	vo.max_cnt			= rs.getInt("MAX_CNT");	
    	vo.curr_cnt 		= rs.getInt("CURR_CNT");
    	vo.rowspan 			= rs.getInt("ROWSPAN");
        return vo;
    }
}
%>

<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String fileName = "악기 통계관리";
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
cell = row.createCell(0);
cell.setCellValue("순서");
cell.setCellStyle(headCellStyle);
cell = row.createCell(1);
cell.setCellValue("분류");
cell.setCellStyle(headCellStyle);
cell = row.createCell(2);
cell.setCellValue("악기명");
cell.setCellStyle(headCellStyle);
cell = row.createCell(3);
cell.setCellValue("대여수");
cell.setCellStyle(headCellStyle);
cell = row.createCell(4);
cell.setCellValue("아이디");
cell.setCellStyle(headCellStyle);
cell = row.createCell(5);
cell.setCellValue("신청자명");
cell.setCellStyle(headCellStyle);
cell = row.createCell(6);
cell.setCellValue("신청일");
cell.setCellStyle(headCellStyle);
cell = row.createCell(8);
cell.setCellValue("분류");
cell.setCellStyle(headCellStyle);
cell = row.createCell(9);
cell.setCellValue("악기명");
cell.setCellStyle(headCellStyle);
cell = row.createCell(10);
cell.setCellValue("대여량/총량");
cell.setCellStyle(headCellStyle);

int rowCnt = 1;
int rowCnt2 = 1;

String search1		= parseNull(request.getParameter("search1"));
String search2		= parseNull(request.getParameter("search2"));
String search3		= parseNull(request.getParameter("search3"));
String keyword		= parseNull(request.getParameter("keyword"));
String start_date	= parseNull(request.getParameter("start_date"));
String end_date		= parseNull(request.getParameter("end_date"));

StringBuffer sql 		= new StringBuffer();
List<InsVO> list 		= null;
List<InsVO> totalList 	= null;
int num = 0;

Object[] setObj		= null;
List<String> setList	= new ArrayList<String>();

try {
	sql = new StringBuffer();
	sql.append("		SELECT			 										");
	sql.append("			A.REQ_NO,				 							");
	sql.append("			A.REQ_ID,				 							");
	sql.append("			A.REQ_GROUP,				 						");
	sql.append("			A.REQ_MNG_NM,				 						");
	sql.append("			A.REQ_MNG_TEL,				 						");
	sql.append("			A.REQ_INST_CNT,				 						");
	sql.append("			A.REQ_MEMO,				 							");
	sql.append("			A.REG_IP,				 							");
	sql.append("			A.REG_DATE,				 							");
	sql.append("			A.SHOW_FLAG,				 						");
	sql.append("			A.APPLY_FLAG,				 						");
	sql.append("			A.APPLY_DATE,				 						");
	sql.append("			(SELECT INST_CAT FROM ART_INST_REQ_CNT WHERE REQ_NO 	= A.REQ_NO AND ROWNUM = 1) 	INST_CAT,			");
	sql.append("			(SELECT INST_CAT_NM FROM ART_INST_REQ_CNT WHERE REQ_NO 	= A.REQ_NO AND ROWNUM = 1) 	INST_CAT_NM,		");
	sql.append("			(SELECT INST_NO FROM ART_INST_REQ_CNT WHERE REQ_NO 		= A.REQ_NO AND ROWNUM = 1) 	INST_NO,			");
	/* sql.append("			(SELECT INST_NM FROM ART_INST_REQ_CNT WHERE REQ_NO 		= A.REQ_NO AND ROWNUM = 1) 	INST_NM,			"); */
	sql.append("			(SELECT																									");
	sql.append("					SUBSTR(																							");
	sql.append("							XMLAGG(																					");
	sql.append("									XMLELEMENT(COL ,', ', INST_NM) ORDER BY INST_NM).EXTRACT('//text()'				");
	sql.append("							).GETSTRINGVAL()																		");
	sql.append("					, 2) INST_NM																					");
	sql.append("			FROM ART_INST_REQ_CNT																					");
	sql.append("			WHERE REQ_NO = A.REQ_NO																					");
	sql.append("			GROUP BY REQ_NO) INST_NM,																				");
	sql.append("			(SELECT NVL(SUM(INST_REQ_CNT),0) FROM ART_INST_REQ_CNT WHERE REQ_NO = A.REQ_NO) 	INST_REQ_CNT,		");
	sql.append("			(SELECT NVL(COUNT(*),0) FROM ART_INST_REQ_CNT WHERE REQ_NO = A.REQ_NO) COUNT							");
	sql.append("		FROM ART_INST_REQ A																							");
	sql.append("		WHERE 1=1					 																				");

	if(!"".equals(start_date)){
		sql.append("AND A.REG_DATE >= ?																			");
		setList.add(start_date);
	}
	if(!"".equals(end_date)){
		sql.append("AND A.REG_DATE <= ?																			");
		setList.add(end_date);
	}
	if(!"".equals(search1) && !"".equals(keyword)){
		if("req_id".equals(search1)){
			sql.append("AND REQ_ID LIKE '%'||?||'%'																");
			setList.add(keyword);
		}else if("req_mng_nm".equals(search1)){
			sql.append("AND A.REQ_MNG_NM LIKE '%'||?||'%'														");
			setList.add(keyword);
		}
	}
	if(!"".equals(search2)){
		sql.append("AND A.REQ_NO = (																			");
		sql.append("				SELECT REQ_NO																");
		sql.append("				FROM ART_INST_REQ_CNT														");
		sql.append("				WHERE ROWNUM = 1 AND INST_CAT_NM = ?										");
		sql.append("				)																			");
		setList.add(search2);
	}
	if(!"".equals(search3)){
		sql.append("AND A.REQ_NO = (																			");
		sql.append("				SELECT REQ_NO																");
		sql.append("				FROM ART_INST_REQ_CNT														");
		sql.append("				WHERE ROWNUM = 1 AND INST_NO = ?				");
		sql.append("				)																			");
		setList.add(search3);
	}
	sql.append("ORDER BY A.REQ_NO DESC			 								");
	
	setObj = new Object[setList.size()];
	for(int i=0; i<setList.size(); i++){
		setObj[i] = setList.get(i);
	}

	
	list = jdbcTemplate.query(
			sql.toString(), 
			new InsVOMapper(),
			setObj
		);

	
	setList	= new ArrayList<String>();
	
	sql = new StringBuffer();
	sql.append("SELECT			 																										");
	sql.append("	INST_CAT_NM,		 																								");
	sql.append("	INST_NAME,		 																									");
	sql.append("	MAX_CNT,		 																									");
	sql.append("	CURR_CNT,																											");
	sql.append("	COUNT(*)OVER(PARTITION BY INST_CAT_NM) AS ROWSPAN																	");
	sql.append("FROM ART_INST_MNG																										");
	sql.append("WHERE 1=1					 																							");
	
	if(!"".equals(start_date)){
		sql.append("AND REG_DATE >= ?																									");
		setList.add(start_date);
	}
	if(!"".equals(end_date)){
		sql.append("AND REG_DATE <= ?																									");
		setList.add(end_date);
	}
	if(!"".equals(search1) && !"".equals(keyword)){
		if("req_id".equals(search1)){
			sql.append("AND INST_NO = 	(	SELECT INST_NO 																				");
			sql.append("			   		FROM ART_INST_REQ_CNT ");
			sql.append("					WHERE ROWNUM = 1 AND REQ_NO = (SELECT REQ_NO												");
			sql.append("												   FROM ART_INST_REQ											");
			sql.append("												   WHERE REQ_ID LIKE '%'||?||'%'								");
			sql.append("												   )															");
			sql.append("				)																								");
			setList.add(keyword);
		}else if("req_mng_nm".equals(search1)){
			sql.append("AND INST_NO = 	(	SELECT INST_NO 																				");
			sql.append("					FROM ART_INST_REQ_CNT 																		");
			sql.append("					WHERE ROWNUM = 1 AND REQ_NO =	(	SELECT REQ_NO 											");
			sql.append("														FROM ART_INST_REQ 										");
			sql.append("														WHERE REQ_MNG_NM LIKE '%'||?||'%'						");
			sql.append("													)															");
			sql.append("				)																								");
			setList.add(keyword);
		}
	}
	if(!"".equals(search2)){
		sql.append("AND INST_CAT_NM = ?																									");
		setList.add(search2);
	}
	if(!"".equals(search3)){
		sql.append("AND INST_NO = ?																										");
		setList.add(search3);
	}
	sql.append("ORDER BY INST_CAT_NM, INST_NAME 																						");
	
	setObj = new Object[setList.size()];
	for(int i=0; i<setList.size(); i++){
		setObj[i] = setList.get(i);
	}
	
	totalList = jdbcTemplate.query(
			sql.toString(), 
			new TotalList(),
			setObj
		);

	String inst_cat_nm = "";
	int startPoint = 1;
	int size = 0;
	InsVO ob = null;
	
	if(list.size() > totalList.size()){
		size = list.size();
	}else{
		size = totalList.size();
	}
	
	//for(InsVO ob : list){
	for(int k=0; k<size; k++){
		row = sheet.createRow(rowCnt++);
		if(k<list.size()){
			ob = list.get(k);			
			cell = row.createCell(0);
			cell.setCellValue(++num);
			cell.setCellStyle(cellStyle);
			cell = row.createCell(1);
			cell.setCellValue(ob.inst_cat_nm);
			cell.setCellStyle(cellStyle);
			cell = row.createCell(2);
			cell.setCellValue(ob.inst_nm);
			cell.setCellStyle(cellStyle);
			cell = row.createCell(3);
			cell.setCellValue(ob.inst_req_cnt);
			cell.setCellStyle(cellStyle);
			cell = row.createCell(4);
			cell.setCellValue(ob.req_id);
			cell.setCellStyle(cellStyle);
			cell = row.createCell(5);
			cell.setCellValue(ob.req_mng_nm);
			cell.setCellStyle(cellStyle);
			cell = row.createCell(6);
			cell.setCellValue(ob.reg_date);
			cell.setCellStyle(cellStyle);
			
			for (short i=0; i<=7; i++){
			    sheet.autoSizeColumn(i);
			    sheet.setColumnWidth(i, (sheet.getColumnWidth(i))+(short)1024);
			}
		}
		
		if(rowCnt-1 == rowCnt2){
			InsVO ob2 = totalList.get(rowCnt2-1);
			cell = row.createCell(8);
			cell.setCellValue(ob2.inst_cat_nm);
			cell.setCellStyle(cellStyle);
			if(!inst_cat_nm.equals(ob2.inst_cat_nm)){
				startPoint = rowCnt2;	
			}else{
				sheet.addMergedRegion(new Region(startPoint,(short)8,rowCnt2,(short)8));	
			}
			
			cell = row.createCell(9);
			cell.setCellValue(ob2.inst_name);
			cell.setCellStyle(cellStyle);
			cell = row.createCell(10);
			cell.setCellValue(ob2.curr_cnt + " / " + ob2.max_cnt);
			cell.setCellStyle(cellStyle);
			inst_cat_nm = ob2.inst_cat_nm;
			
			for (short i=8; i<=10; i++){
			    sheet.autoSizeColumn(i);
			    sheet.setColumnWidth(i, (sheet.getColumnWidth(i))+(short)1024);
			}
			
			if(totalList.size()>rowCnt2){
				rowCnt2++;
			}
		}else{
			cell = row.createCell(8);
			cell.setCellValue("");
			cell = row.createCell(9);
			cell.setCellValue("");
			cell = row.createCell(10);
			cell.setCellValue("");
			
			for (short i=8; i<=10; i++){
			    sheet.autoSizeColumn(i);
			    sheet.setColumnWidth(i, (sheet.getColumnWidth(i))+(short)1024);
			}
		}
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