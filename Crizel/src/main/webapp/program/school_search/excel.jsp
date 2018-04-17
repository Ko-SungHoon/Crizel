<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@page import="org.apache.poi.hssf.usermodel.*" %>
<%@page import="java.io.*" %>
<meta charset="UTF-8">
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String fileName = "학교찾기";
fileName = URLEncoder.encode(fileName, "UTF-8");
fileName = fileName.replaceAll("\\+", "%20");

// create a small spreadsheet
HSSFWorkbook wb = new HSSFWorkbook();
HSSFSheet sheet = wb.createSheet();
HSSFRow row = sheet.createRow(0);
HSSFCell cell = row.createCell(0);


row = sheet.createRow(0);
cell = row.createCell(0);
cell.setCellValue("학교급");
cell = row.createCell(1);
cell.setCellValue("설립구분");
cell = row.createCell(2);
cell.setCellValue("학교명");
cell = row.createCell(3);
cell.setCellValue("학교코드");
cell = row.createCell(4);
cell.setCellValue("지역구분");
cell = row.createCell(5);
cell.setCellValue("남여공학");
cell = row.createCell(6);
cell.setCellValue("우편번호");
cell = row.createCell(7);
cell.setCellValue("주소");
cell = row.createCell(8);
cell.setCellValue("전화번호");
cell = row.createCell(9);
cell.setCellValue("팩스번호");
cell = row.createCell(10);
cell.setCellValue("홈페이지");

int rowCnt = 1;

PreparedStatement pstmt = null;
ResultSet rs = null;
Connection conn = null;
StringBuffer sql = new StringBuffer();

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	
	sql = new StringBuffer();
	sql.append("SELECT * \n");
	sql.append("FROM SCHOOL_SEARCH \n");
	sql.append("ORDER BY TITLE \n");
	pstmt = conn.prepareStatement(sql.toString());
	rs = pstmt.executeQuery();
	while(rs.next()){
		row = sheet.createRow(rowCnt++);
		cell = row.createCell(0);
		cell.setCellValue(rs.getString("CATE1"));
		cell = row.createCell(1);
		cell.setCellValue(rs.getString("CATE2"));
		cell = row.createCell(2);
		cell.setCellValue(rs.getString("TITLE"));
		cell = row.createCell(3);
		cell.setCellValue(rs.getString("CODE"));
		cell = row.createCell(4);
		cell.setCellValue(rs.getString("AREA_TYPE"));
		cell = row.createCell(5);
		cell.setCellValue(rs.getString("COEDU"));
		cell = row.createCell(6);
		cell.setCellValue(rs.getString("POST"));
		cell = row.createCell(7);
		cell.setCellValue(rs.getString("ADDR"));
		cell = row.createCell(8);
		cell.setCellValue(rs.getString("TEL"));
		cell = row.createCell(9);
		cell.setCellValue(rs.getString("FAX"));
		cell = row.createCell(10);
		cell.setCellValue(rs.getString("URL"));
	}
	
	for (short i=0;i<10;i++) //autuSizeColumn after setColumnWidth setting!! 
	{ 
	sheet.autoSizeColumn(i);
	sheet.setColumnWidth(i, (sheet.getColumnWidth(i))+512 ); //이건 자동으로 조절 하면 너무 딱딱해 보여서 자동조정한 사이즈에 (short)512를 추가해 주니 한결 보기 나아졌다.
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