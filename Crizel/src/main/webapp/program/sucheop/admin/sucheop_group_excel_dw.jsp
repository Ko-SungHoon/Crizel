<%
/**
*	PURPOSE	:	교육수첩 조직도 excel 다운 jsp
*	CREATE	:	20171109_thur	JI
*	MODIFY	:	....
*/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@page import="org.apache.poi.hssf.usermodel.*" %>
<%@page import="java.io.*" %>
<meta charset="UTF-8">
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String fileName = "조직도 자료";
fileName = URLEncoder.encode(fileName, "UTF-8");
fileName = fileName.replaceAll("\\+", "%20");

// create a small spreadsheet
HSSFWorkbook wb = new HSSFWorkbook();
HSSFSheet sheet = wb.createSheet();
HSSFRow row = sheet.createRow(0);
HSSFCell cell = row.createCell(0);

row = sheet.createRow(0);
cell = row.createCell(0);
cell.setCellValue("기관 번호");
cell = row.createCell(1);
cell.setCellValue("기관 이름(필수)");
cell = row.createCell(2);
cell.setCellValue("기관 레벨(필수)");
cell = row.createCell(3);
cell.setCellValue("차상위 기관명\n(1레벨 제외 필수)");
cell = row.createCell(4);
cell.setCellValue("학교정보 여부 \n N=기관, Y=학교 \n K=유치원 \n(필수)");
cell = row.createCell(5);
cell.setCellValue("기관 주소");
cell = row.createCell(6);
cell.setCellValue("대표 전화");
cell = row.createCell(7);
cell.setCellValue("야간직통");
cell = row.createCell(8);
cell.setCellValue("야간직통2");
cell = row.createCell(9);
cell.setCellValue("fax");
cell = row.createCell(10);
cell.setCellValue("기관 url");
cell = row.createCell(11);
cell.setCellValue("알리미 url");
cell = row.createCell(12);
cell.setCellValue("노출여부(필수)");

int rowCnt = 1;

PreparedStatement pstmt	=	null;
ResultSet rs			=	null;
Connection conn			=	null;
StringBuffer sql		=	new StringBuffer();
String	sql_str			=	"";

try {
	sqlMapClient.startTransaction();
	conn	=	sqlMapClient.getCurrentConnection();	
	
	sql		=	new StringBuffer();
	sql_str	+=	"SELECT A.* ";
	sql_str	+=	" , CASE WHEN A.PARENT_SEQ = -1 THEN NULL ELSE (SELECT B.GROUP_NM FROM NOTE_GROUP_LIST B WHERE GROUP_SEQ = A.PARENT_SEQ) END AS PAREANT_NM ";
	sql_str	+=	"	, TO_CHAR(TO_DATE(A.REG_DT||A.REG_HMS,'YYYYMMDDHH24MISS'), 'YYYY-MM-DD HH24:MI:SS') AS GROUP_REG ";
	sql_str	+=	"	, TO_CHAR(TO_DATE(A.MODIFY_DT||A.MODIFY_HMS,'YYYYMMDDHH24MISS'), 'YYYY-MM-DD HH24:MI:SS') AS GROUP_MODIFY ";
	sql_str	+=	" FROM NOTE_GROUP_LIST A ";
	sql_str	+=	" START WITH A.PARENT_SEQ = -1 ";
	sql_str	+=	" CONNECT BY PRIOR A.GROUP_SEQ	=	A.PARENT_SEQ";

	sql.append(sql_str);

	pstmt = conn.prepareStatement(sql.toString());
	rs = pstmt.executeQuery();
	int count = 1;
	while(rs.next()){
		row = sheet.createRow(rowCnt++);
		cell = row.createCell(0);
		cell.setCellValue(rs.getString("GROUP_SEQ"));
		cell = row.createCell(1);
		cell.setCellValue(rs.getString("GROUP_NM"));
		cell = row.createCell(2);
		cell.setCellValue(rs.getString("GROUP_LV"));
		cell = row.createCell(3);
		cell.setCellValue(rs.getString("PAREANT_NM"));
		cell = row.createCell(4);
		cell.setCellValue(rs.getString("SCHOOL_FLAG"));
		cell = row.createCell(5);
		cell.setCellValue(rs.getString("ADDR"));
		cell = row.createCell(6);
		cell.setCellValue(rs.getString("TEL1"));
		cell = row.createCell(7);
		cell.setCellValue(rs.getString("TEL2"));
		cell = row.createCell(8);
		cell.setCellValue(rs.getString("TEL3"));
		cell = row.createCell(9);
		cell.setCellValue(rs.getString("FAX"));
		cell = row.createCell(10);
		cell.setCellValue(rs.getString("URL"));
		cell = row.createCell(11);
		cell.setCellValue(rs.getString("ALIMI"));
		cell = row.createCell(12);
		cell.setCellValue(rs.getString("SHOW_FLAG"));
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