<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@page import="org.apache.poi.hssf.usermodel.*" %>
<%@page import="java.io.*" %>
<meta charset="UTF-8">
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String fileName = "상담선생님";
fileName = URLEncoder.encode(fileName, "UTF-8");
fileName = fileName.replaceAll("\\+", "%20");

// create a small spreadsheet
HSSFWorkbook wb = new HSSFWorkbook();
HSSFSheet sheet = wb.createSheet();
HSSFRow row = sheet.createRow(0);
HSSFCell cell = row.createCell(0);

row = sheet.createRow(0);
cell = row.createCell(0);
cell.setCellValue("분류");
cell = row.createCell(1);
cell.setCellValue("대상");
cell = row.createCell(2);
cell.setCellValue("상담교사명");
cell = row.createCell(3);
cell.setCellValue("아이디");
cell = row.createCell(4);
cell.setCellValue("휴대폰");
cell = row.createCell(5);
cell.setCellValue("상담원적용");
cell = row.createCell(6);
cell.setCellValue("등록일");

int rowCnt = 1;

PreparedStatement pstmt = null;
ResultSet rs = null;
Connection conn = null;
StringBuffer sql = new StringBuffer();

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	
	sql = new StringBuffer();
	sql.append(" SELECT                                      \n");
	sql.append("     TEACHER_ID                              \n");
	sql.append("   , TEACHER_NM                              \n");
	sql.append("   , CASE WHEN CATEGORY_GB = 'A01' THEN '진로' \n");
	sql.append("          WHEN CATEGORY_GB = 'A02' THEN '진학' \n");
	sql.append("     END CATEGORY_GB                         \n");
	sql.append("   , CASE WHEN TARGET_GB = 'B01' THEN '초등'   \n");
	sql.append("          WHEN TARGET_GB = 'B02' THEN '중등'   \n");
	sql.append("     END TARGET_GB                           \n");
	sql.append("   , SUBSTR(HP_NO,1,3)||'-'||SUBSTR(HP_NO,4,4)||'-'||SUBSTR(HP_NO,8,4) AS HP_NO \n");
	sql.append("   , CASE WHEN ADVICE_YN = 'Y' THEN '적용' WHEN ADVICE_YN = 'N' THEN '적용안함' END ADVICE_YN \n");
	sql.append("   , ADVICE_ST_DT                            \n");
	sql.append("   , ADVICE_ED_DT                            \n");
	sql.append("   , SUBSTR(REG_DT,1,4)||'-'||SUBSTR(REG_DT,5,2)||'-'||SUBSTR(REG_DT,7,2) AS REG_DT \n");
	sql.append("   , REG_ID                                  \n");
	sql.append("   , MOD_DT                                  \n");
	sql.append("   , MOD_ID                                  \n");
	sql.append(" FROM ADVICE_TEACHER  WHERE 1=1                       \n");
	sql.append("		ORDER BY ADVICE_YN,REG_DT,REG_HMS DESC ");
	pstmt = conn.prepareStatement(sql.toString());
	rs = pstmt.executeQuery();
	while(rs.next()){
		row = sheet.createRow(rowCnt++);
		cell = row.createCell(0);
		cell.setCellValue(rs.getString("CATEGORY_GB"));
		cell = row.createCell(1);
		cell.setCellValue(rs.getString("TARGET_GB"));
		cell = row.createCell(2);
		cell.setCellValue(rs.getString("TEACHER_NM"));
		cell = row.createCell(3);
		cell.setCellValue(rs.getString("TEACHER_ID"));
		cell = row.createCell(4);
		cell.setCellValue(rs.getString("HP_NO"));
		cell = row.createCell(5);
		cell.setCellValue(rs.getString("ADVICE_YN"));
		cell = row.createCell(6);
		cell.setCellValue(rs.getString("REG_DT"));

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