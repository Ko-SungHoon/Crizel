<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@page import="org.apache.poi.hssf.usermodel.*" %>
<%@page import="java.io.*" %>
<meta charset="UTF-8">
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String fileName = "통계";
fileName = URLEncoder.encode(fileName, "UTF-8");
fileName = fileName.replaceAll("\\+", "%20");

// create a small spreadsheet
HSSFWorkbook wb = new HSSFWorkbook();
HSSFSheet sheet = wb.createSheet();
HSSFRow row = sheet.createRow(0);
HSSFCell cell = row.createCell(0);

String user_account = "";
String school_id = parseNull(request.getParameter("school_id"));
String user_id = parseNull(request.getParameter("user_id"));
String school_area = parseNull(request.getParameter("school_area"));
String school_name = parseNull(request.getParameter("school_name"));
String reserve_type = parseNull(request.getParameter("reserve_type"));
String reserve_type2 = parseNull(request.getParameter("reserve_type2"));
String reserve_date = parseNull(request.getParameter("reserve_date"));
String time_value = parseNull(request.getParameter("time_value"));
String reserve_approval = parseNull(request.getParameter("reserve_approval"));
String reserve_delete = parseNull(request.getParameter("reserve_delete"));
String reserve_register = parseNull(request.getParameter("reserve_register"));
String user_name = "";
String use_count = "";
String total_price = parseNull(request.getParameter("total_price"));
String reserve_man = parseNull(request.getParameter("reserve_man"));

String total_use_count = "";
String total_reserve_man = "";
String total_total_price = "";

String search1 = parseNull(request.getParameter("search1"));
String search2 = parseNull(request.getParameter("search2"));
String keyword = parseNull(request.getParameter("keyword"));

row = sheet.createRow(0);
cell = row.createCell(0);
cell.setCellValue("시설명");
cell = row.createCell(1);
cell.setCellValue("이용횟수");
cell = row.createCell(2);
cell.setCellValue("이용인원");
cell = row.createCell(3);
cell.setCellValue("총 금액");

int rowCnt = 1;

PreparedStatement pstmt = null;
ResultSet rs = null;
Connection conn = null;
StringBuffer sql = new StringBuffer();
List<Map<String, Object>> dataList = null;

int key = 0;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT RESERVE_TYPE, RESERVE_TYPE2, COUNT(RESERVE_TYPE) USE_COUNT ,SUM(TOTAL_PRICE) TOTAL_PRICE, SUM(RESERVE_MAN) RESERVE_MAN  ");
	sql.append("FROM RESERVE_USER ");
	sql.append("WHERE SCHOOl_ID = ? AND RESERVE_APPROVAL = 'C' ");
	if(!"".equals(search1)){
		sql.append("AND TO_CHAR(APPROVAL_DATE, 'yyyy-MM-dd') LIKE '%'||?||'%' ");
	}
	sql.append("GROUP BY RESERVE_TYPE, RESERVE_TYPE2  ");
	sql.append("ORDER BY RESERVE_TYPE  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, school_id);
	if(!"".equals(search1)){
		pstmt.setString(++key, keyword);
	}
	rs = pstmt.executeQuery();
	dataList = getResultMapRows(rs);


	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT COUNT(RESERVE_TYPE) USE_COUNT ,SUM(TOTAL_PRICE) TOTAL_PRICE, SUM(RESERVE_MAN) RESERVE_MAN  ");
	sql.append("FROM RESERVE_USER ");
	sql.append("WHERE SCHOOl_ID = ? AND RESERVE_APPROVAL = 'C' ");

	if(!"".equals(search1)){
		sql.append("AND TO_CHAR(APPROVAL_DATE, 'yyyy-MM-dd') LIKE '%'||?||'%' ");
	}

	sql.append("ORDER BY RESERVE_TYPE  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, school_id);
	if(!"".equals(search1)){
		pstmt.setString(++key, keyword);
	}
	rs = pstmt.executeQuery();
	if(rs.next()){
		total_use_count = rs.getString("USE_COUNT");
		total_total_price = rs.getString("TOTAL_PRICE");
		total_reserve_man = rs.getString("RESERVE_MAN");
	}
	
	for(Map<String,Object> ob : dataList){
		row = sheet.createRow(rowCnt++);
		cell = row.createCell(0);
		cell.setCellValue(ob.get("RESERVE_TYPE").toString());
		cell = row.createCell(1);
		cell.setCellValue(ob.get("USE_COUNT").toString());
		cell = row.createCell(2);
		cell.setCellValue(ob.get("RESERVE_MAN").toString());
		cell = row.createCell(3);
		cell.setCellValue(moneySet(ob.get("TOTAL_PRICE").toString()));
	}
	
	row = sheet.createRow(rowCnt++);
	cell = row.createCell(0);
	cell.setCellValue("합계");
	cell = row.createCell(1);
	cell.setCellValue(total_use_count);
	cell = row.createCell(2);
	cell.setCellValue(total_reserve_man);
	cell = row.createCell(3);
	cell.setCellValue(moneySet(total_total_price));

} catch (Exception e) {
	e.printStackTrace();
	sqlMapClient.endTransaction();
	alertBack(out, "처리중 오류가 발생하였습니다.");
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
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