<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@page import="org.apache.poi.hssf.usermodel.*" %>
<%@page import="java.io.*" %>
<meta charset="UTF-8">
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String fileName = "업무분장_백업";
fileName = URLEncoder.encode(fileName, "UTF-8");
fileName = fileName.replaceAll("\\+", "%20");

// create a small spreadsheet
HSSFWorkbook wb = new HSSFWorkbook();
HSSFSheet sheet = wb.createSheet();
HSSFRow row = sheet.createRow(0);
HSSFCell cell = row.createCell(0);
row = sheet.createRow(0);
cell = row.createCell(0);
cell.setCellValue("이름");
cell = row.createCell(1);
cell.setCellValue("부서");
cell = row.createCell(2);
cell.setCellValue("직급");
cell = row.createCell(3);
cell.setCellValue("업무소개");
cell = row.createCell(4);
cell.setCellValue("전화번호");
cell = row.createCell(5);
cell.setCellValue("업무자대행이름");

int rowCnt = 1;

PreparedStatement pstmt = null;
ResultSet rs = null;
Connection conn = null;
StringBuffer sql = new StringBuffer();

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	
	sql = new StringBuffer();
	sql.append(" SELECT * \n");
	sql.append(" FROM DIVISION_WORK \n");
	sql.append(" ORDER BY OFFICE_DP,OFFICE_CD,SORT_ORDER ASC \n");
	pstmt = conn.prepareStatement(sql.toString());
	rs = pstmt.executeQuery();
	while(rs.next()){
		row = sheet.createRow(rowCnt++);
		cell = row.createCell(0);
		cell.setCellValue(rs.getString("EMPLYR_NM"));
		cell = row.createCell(1);
		cell.setCellValue(rs.getString("OFFICE_NM"));
		cell = row.createCell(2);
		cell.setCellValue(rs.getString("POSITION_NM"));
		cell = row.createCell(3);
		cell.setCellValue(rs.getString("OFFICE_PT_MEMO"));
		cell = row.createCell(4);
		cell.setCellValue(rs.getString("OFFICE_TEL"));
		cell = row.createCell(5);
        if (rs.getString("AGEN_NM") != null && rs.getString("AGEN_NM").length() > 0) {
		  cell.setCellValue(rs.getString("AGEN_NM").replace("<br>","\r\n"));  
        } else {
            cell.setCellValue(rs.getString("AGEN_NM"));
        }

	}

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