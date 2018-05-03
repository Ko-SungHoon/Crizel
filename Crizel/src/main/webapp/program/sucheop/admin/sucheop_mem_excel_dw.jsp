<%
/**
*	PURPOSE	:	교육수첩 교원 리스트 excel 다운 jsp
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

String fileName = "교원 자료";
fileName = URLEncoder.encode(fileName, "UTF-8");
fileName = fileName.replaceAll("\\+", "%20");

// create a small spreadsheet
HSSFWorkbook wb = new HSSFWorkbook();
HSSFSheet sheet = wb.createSheet();
HSSFRow row = sheet.createRow(0);
HSSFCell cell = row.createCell(0);

row = sheet.createRow(0);
cell = row.createCell(0);
cell.setCellValue("교원 번호");
cell = row.createCell(1);
cell.setCellValue("교원 이름(필수)");
cell = row.createCell(2);
cell.setCellValue("교원 소속기관(필수)");
cell = row.createCell(3);
cell.setCellValue("직위(필수)");
cell = row.createCell(4);
cell.setCellValue("급수");
cell = row.createCell(5);
cell.setCellValue("사무실 전화");
cell = row.createCell(6);
cell.setCellValue("휴대전화");
cell = row.createCell(7);
cell.setCellValue("통합로그인 ID");
cell = row.createCell(8);
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
	sql_str     =   "SELECT ";
    sql_str     +=  "   ROWNUM AS RNUM ";
    sql_str     +=  "   , (SELECT SUBSTR(SYS_CONNECT_BY_PATH(G.GROUP_NM, '-'), 2)";
    sql_str     +=  "   FROM NOTE_GROUP_LIST G";
    sql_str     +=  "   WHERE G.GROUP_SEQ = (SELECT D.GROUP_SEQ FROM NOTE_GROUP_LIST D WHERE D.GROUP_SEQ = A.GROUP_LIST_SEQ)";
    sql_str     +=  "   START WITH G.PARENT_SEQ = '-1'";
    sql_str     +=  "   CONNECT BY PRIOR G.GROUP_SEQ = G.PARENT_SEQ";
    sql_str     +=  "   ) AS GROUP_NAME ";
    sql_str     +=  "   , TO_CHAR(TO_DATE(A.REG_DT||A.REG_HMS,'YYYYMMDDHH24MISS'), 'YYYY-MM-DD HH24:MI:SS') AS MEM_REG";
    sql_str     +=  "   , TO_CHAR(TO_DATE(A.MODIFY_DT||A.MODIFY_HMS,'YYYYMMDDHH24MISS'), 'YYYY-MM-DD HH24:MI:SS') AS MODIFY_REG";
    sql_str     +=  "   , A.*";
    sql_str     +=  "FROM NOTE_GROUP_MEM A";

	sql.append(sql_str);

	pstmt = conn.prepareStatement(sql.toString());
	rs = pstmt.executeQuery();
	int count = 1;
	while(rs.next()){
		row = sheet.createRow(rowCnt++);
		cell = row.createCell(0);
		cell.setCellValue(rs.getString("MEM_SEQ"));
		cell = row.createCell(1);
		cell.setCellValue(rs.getString("MEM_NM"));
		cell = row.createCell(2);
		cell.setCellValue(rs.getString("GROUP_NAME"));
		cell = row.createCell(3);
		cell.setCellValue(rs.getString("MEM_GRADE"));
		cell = row.createCell(4);
		cell.setCellValue(rs.getString("MEM_LEVEL"));
		cell = row.createCell(5);
		cell.setCellValue(rs.getString("MEM_TEL"));
		cell = row.createCell(6);
		cell.setCellValue(rs.getString("MEM_MOBILE"));
		cell = row.createCell(7);
		cell.setCellValue(rs.getString("MEM_SSO_ID"));
		cell = row.createCell(8);
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