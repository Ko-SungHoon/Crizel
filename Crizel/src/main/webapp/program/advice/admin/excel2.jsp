<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@page import="org.apache.poi.hssf.usermodel.*" %>
<%@page import="java.io.*" %>
<meta charset="UTF-8">
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String fileName = "상담로그";
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
cell.setCellValue("상담교사명(아이디)");
cell = row.createCell(3);
cell.setCellValue("학생명(아이디)");
cell = row.createCell(4);
cell.setCellValue("상담글 제목");
cell = row.createCell(5);
cell.setCellValue("상담신청일");
cell = row.createCell(6);
cell.setCellValue("상태변경일");
cell = row.createCell(7);
cell.setCellValue("상담상태");

int rowCnt = 1;

PreparedStatement pstmt = null;
ResultSet rs = null;
Connection conn = null;
StringBuffer sql = new StringBuffer();

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	
	sql = new StringBuffer();
	sql.append(" 		SELECT                                      \n");
	sql.append("					  BOARD_ID                                  ");
	sql.append("					, BOARD_TITLE                               ");
	sql.append("					, BOARD_CONTENT                             ");
	sql.append("					, CASE WHEN CATEGORY = 'A01' THEN '진로'      ");
	sql.append("					       WHEN CATEGORY = 'A02' THEN '진학'        ");
	sql.append("					  END CATEGORY                              ");
	sql.append("					, CASE WHEN GRADE = 'B01' THEN '초등'         ");
	sql.append("						   WHEN GRADE = 'B02' THEN '중등'         ");
	sql.append("					  END GRADE                                 ");

	sql.append("				  	, A.ADVICE_STS AS ADVICE_STS_TAG   \n");
	sql.append("				  	, (SELECT STATUS_NAME FROM ADVICE_STS_RULE F WHERE STATUS_TAG = A.ADVICE_STS) AS ADVICE_STS ");

	sql.append("					, TO_CHAR(TO_DATE(REG_DT||REG_HMS,'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS') AS REG_DT ");
	sql.append("					, A.REG_ID                                    ");
	sql.append("					, A.MOD_DT                                    ");
	sql.append("					, A.MOD_ID                                    ");
	sql.append("					, A.REF_ID                                    ");
	sql.append("					, A.BOARD_LVL                                 ");
	sql.append("					, A.BOARD_DEPT                                ");
	sql.append("					, A.ATTACH_SEQ                                ");
	sql.append("					, A.NOTICE_YN                                 ");
	sql.append("					, A.TEACHER_ID                                ");
	sql.append("					, TO_CHAR(TO_DATE(A.COMPLETE_DT, 'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS') AS COMPLETE_DT ");
	sql.append("					, TEACHER_NM                                ");
	sql.append("					, TEACHER_NM||'('||TEACHER_ID||')' AS TEACHER_VIEW                                ");
	sql.append("					, REG_NM                                ");
	sql.append("					, REG_NM||'('||REG_ID||')' AS REG_VIEW                                ");
	sql.append(" 					, NVL(A.ADVICE_CANCEL, 'N')	AS ADVICE_CANCEL					\n");
	sql.append(" 					, TO_CHAR(TO_DATE(ADVICE_ORG_DATE||ADVICE_ORG_HMS,'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS') AS ADVICE_ORG_DATE	\n");
	sql.append(" 		FROM ADVICE_BOARD_LOG A WHERE NOTICE_YN = 'N' \n");
	sql.append(" 		AND BOARD_LVL = 0							  \n");
	sql.append(" 		AND BOARD_DEPT = 0                            \n");
	sql.append("		ORDER BY BOARD_ID DESC ");
	pstmt = conn.prepareStatement(sql.toString());
	rs = pstmt.executeQuery();
	int count = 1;
	while(rs.next()){
		row = sheet.createRow(rowCnt++);
		cell = row.createCell(0);
		cell.setCellValue(rs.getString("CATEGORY"));
		cell = row.createCell(1);
		cell.setCellValue(rs.getString("GRADE"));
		cell = row.createCell(2);
		cell.setCellValue(rs.getString("TEACHER_VIEW"));
		cell = row.createCell(3);
		cell.setCellValue(rs.getString("REG_VIEW"));
		cell = row.createCell(4);
		cell.setCellValue(rs.getString("BOARD_TITLE"));
		cell = row.createCell(5);
		if (rs.getString("ADVICE_CANCEL").equals("Y")) {
			cell.setCellValue(rs.getString("ADVICE_ORG_DATE"));
		} else {
			cell.setCellValue(rs.getString("REG_DT"));
		}
		cell = row.createCell(6);
		cell.setCellValue(rs.getString("COMPLETE_DT"));
		cell = row.createCell(7);
		cell.setCellValue(rs.getString("ADVICE_STS"));

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