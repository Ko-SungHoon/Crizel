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

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
List<Map<String, Object>> dataList = null;
List<Map<String, Object>> yearList = null;
List<Map<String, Object>> totalList = null;

String user_account 		= "";
String school_id 			= parseNull(request.getParameter("school_id"));
String school_area 			= parseNull(request.getParameter("school_area"));
String school_name 			= parseNull(request.getParameter("school_name"));
String use_cnt 				= parseNull(request.getParameter("use_cnt"));
String total_price 			= parseNull(request.getParameter("total_price"));
String year 				= "";
String month 				= "";
String total_total_price 	= parseNull(request.getParameter("total_total_price"));
int total_cnt_1 = 0;
int total_cnt_2 = 0;
int total_cnt_3 = 0;
int total_cnt_4 = 0;

int total_sum = 0;


DecimalFormat df = new DecimalFormat("#,###");

String search1 = parseNull(request.getParameter("search1"));
String search2 = parseNull(request.getParameter("search2"));
String search3 = parseNull(request.getParameter("search3"));
String search4 = parseNull(request.getParameter("search4"));
String keyword = parseNull(request.getParameter("keyword"));


if(!"".equals(search1)){
	keyword = search1;
}
if(!"".equals(search2)){
	keyword = search1 + "-" + search2;
}

int num = 0;
int key = 0;

int rowCnt = 0;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	//통계 총합
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT SUM(TOTAL_PRICE) TOTAL_PRICE   ");
	sql.append("FROM RESERVE_USER WHERE APPROVAL_DATE IS NOT NULL AND RESERVE_APPROVAL = 'C'  ");
	if(!"".equals(keyword)){
		sql.append("AND TO_CHAR(APPROVAL_DATE, 'yyyy-MM-dd') LIKE '%'||?||'%' ");
	}
	if(!"".equals(search4)){
		sql.append("AND SCHOOL_ID IN ((SELECT SCHOOL_ID FROM RESERVE_SCHOOL WHERE SCHOOL_TYPE = ?)) ");
	}
	
	pstmt = conn.prepareStatement(sql.toString());
	if(!"".equals(keyword)){
		pstmt.setString(++key, keyword);
	}
	if(!"".equals(search4)){
		pstmt.setString(++key, search4);
	}
	
	
	rs = pstmt.executeQuery();	
	if(rs.next()){
		total_total_price = rs.getString("TOTAL_PRICE");
	}
	
	//통계 총합 리스트
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT RU.RESERVE_TYPE, COUNT(RU.RESERVE_TYPE) TOTAL_CNT   ");
	sql.append("FROM RESERVE_USER RU LEFT JOIN RESERVE_SCHOOL RS ON RU.SCHOOL_ID=RS.SCHOOL_ID   ");
	sql.append("WHERE RU.APPROVAL_DATE IS NOT NULL AND RU.RESERVE_APPROVAL = 'C'    ");
	
	if(!"".equals(keyword)){
		sql.append("AND TO_CHAR(RU.APPROVAL_DATE, 'yyyy-MM-dd') LIKE '%'||?||'%' ");
	}
	
	if(!"".equals(search3)){
		sql.append("AND SCHOOL_AREA = ? ");
	}
	if(!"".equals(search4)){
		sql.append("AND RS.SCHOOL_TYPE = ? ");
	}
	
	sql.append("GROUP BY RU.RESERVE_TYPE     ");
	sql.append("ORDER BY RU.RESERVE_TYPE  ");
	
	pstmt = conn.prepareStatement(sql.toString());
	
	if(!"".equals(keyword)){
		pstmt.setString(++key, keyword);
	}
	if(!"".equals(search3)){
		pstmt.setString(++key, search3);
	}
	if(!"".equals(search4)){
		pstmt.setString(++key, search4);
	}
	
	rs = pstmt.executeQuery();	
	while(rs.next()){
		if("강당".equals(rs.getString("RESERVE_TYPE"))){
			total_cnt_1 = rs.getInt("TOTAL_CNT");
		}else if("교실".equals(rs.getString("RESERVE_TYPE"))){
			total_cnt_2 = rs.getInt("TOTAL_CNT");
		}else if("기타시설".equals(rs.getString("RESERVE_TYPE"))){
			total_cnt_3 = rs.getInt("TOTAL_CNT");
		}else if("운동장".equals(rs.getString("RESERVE_TYPE"))){
			total_cnt_4 = rs.getInt("TOTAL_CNT");
		}
		total_sum += rs.getInt("TOTAL_CNT");
	}
	
	//통계목록
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT RS.SCHOOL_ID, RS.SCHOOL_AREA, RS.SCHOOL_NAME   ");
	sql.append(",(SELECT COUNT(*) FROM RESERVE_USER WHERE RESERVE_TYPE = '강당' AND SCHOOL_ID = RS.SCHOOL_ID AND RESERVE_APPROVAL = 'C') RESERVE_TYPE1  ");
	sql.append(",(SELECT COUNT(*) FROM RESERVE_USER WHERE RESERVE_TYPE = '교실' AND SCHOOL_ID = RS.SCHOOL_ID AND RESERVE_APPROVAL = 'C') RESERVE_TYPE2  ");
	sql.append(",(SELECT COUNT(*) FROM RESERVE_USER WHERE RESERVE_TYPE = '기타시설' AND SCHOOL_ID = RS.SCHOOL_ID AND RESERVE_APPROVAL = 'C') RESERVE_TYPE3  ");
	sql.append(",(SELECT COUNT(*) FROM RESERVE_USER WHERE RESERVE_TYPE = '운동장' AND SCHOOL_ID = RS.SCHOOL_ID AND RESERVE_APPROVAL = 'C') RESERVE_TYPE4  ");
	sql.append(",(SELECT COUNT(*) FROM RESERVE_USER WHERE SCHOOL_ID = RS.SCHOOL_ID AND RESERVE_APPROVAL = 'C') RESERVE_TYPE5  ");
	sql.append(", SUM(RU.TOTAL_PRICE) TOTAL_PRICE  ");
	
	sql.append("FROM RESERVE_SCHOOL RS LEFT JOIN RESERVE_USER RU ON RS.SCHOOL_ID = RU.SCHOOL_ID WHERE 1=1 AND RU.RESERVE_APPROVAL = 'C'  ");
	
	if(!"".equals(keyword)){
		sql.append("AND TO_CHAR(APPROVAL_DATE, 'yyyy-MM-dd') LIKE '%'||?||'%' ");
	}
	if(!"".equals(search3)){
		sql.append("AND SCHOOL_AREA = ? ");
	}
	if(!"".equals(search4)){
		sql.append("AND SCHOOL_TYPE = ? ");
	}
	
	sql.append("GROUP BY RS.SCHOOL_ID, RS.SCHOOL_AREA, RS.SCHOOL_NAME ");
	sql.append("ORDER BY RS.SCHOOL_NAME  ");
	pstmt = conn.prepareStatement(sql.toString());
	
	if(!"".equals(keyword)){
		pstmt.setString(++key, keyword);
	}
	if(!"".equals(search3)){
		pstmt.setString(++key, search3);
	}
	if(!"".equals(search4)){
		pstmt.setString(++key, search4);
	}
	
	rs = pstmt.executeQuery();	
	dataList = getResultMapRows(rs);
	
	//년도 리스트
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT TO_CHAR(APPROVAL_DATE, 'yyyy') year   ");
	sql.append("FROM RESERVE_USER    ");
	sql.append("WHERE APPROVAL_DATE IS NOT NULL   ");
	sql.append("GROUP BY TO_CHAR(APPROVAL_DATE, 'yyyy') ");
	sql.append("ORDER BY TO_CHAR(APPROVAL_DATE, 'yyyy') ");
	pstmt = conn.prepareStatement(sql.toString());
	rs = pstmt.executeQuery();	
	yearList = getResultMapRows(rs);

	if(!"".equals(total_total_price) && total_total_price !=null){
		total_total_price = df.format(Integer.parseInt(total_total_price));
	}else{
		total_total_price = "0";
	}
	

	
} catch (Exception e) {
	out.println(e.toString());
	e.printStackTrace();
	sqlMapClient.endTransaction();
	//alertBack(out, "처리중 오류가 발생하였습니다."); 
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
}


row = sheet.createRow(rowCnt++);
cell = row.createCell(0);
cell.setCellValue("총 승인금액");
cell = row.createCell(1);
cell.setCellValue(total_total_price);

row = sheet.createRow(rowCnt++);
cell = row.createCell(0);
cell.setCellValue("강당");
cell = row.createCell(1);
cell.setCellValue("교실");
cell = row.createCell(2);
cell.setCellValue("기타시설");
cell = row.createCell(3);
cell.setCellValue("운동장");
cell = row.createCell(4);
cell.setCellValue("시설합계");

row = sheet.createRow(rowCnt++);
cell = row.createCell(0);
cell.setCellValue(total_cnt_1);
cell = row.createCell(1);
cell.setCellValue(total_cnt_2);
cell = row.createCell(2);
cell.setCellValue(total_cnt_3);
cell = row.createCell(3);
cell.setCellValue(total_cnt_4);
cell = row.createCell(4);
cell.setCellValue(total_sum);

row = sheet.createRow(rowCnt++);
cell = row.createCell(0);
cell.setCellValue("지역");
cell = row.createCell(1);
cell.setCellValue("학교명");
cell = row.createCell(2);
cell.setCellValue("강당");
cell = row.createCell(3);
cell.setCellValue("교실");
cell = row.createCell(4);
cell.setCellValue("기타시설");
cell = row.createCell(5);
cell.setCellValue("운동장");
cell = row.createCell(6);
cell.setCellValue("시설합계");
cell = row.createCell(7);
cell.setCellValue("총금액");

if(dataList!=null && dataList.size()>0){
	num = dataList.size();
	for(Map<String, Object> ob : dataList){
		row = sheet.createRow(rowCnt++);
		cell = row.createCell(0);
		cell.setCellValue(ob.get("SCHOOL_AREA").toString());
		cell = row.createCell(1);
		cell.setCellValue(ob.get("SCHOOL_NAME").toString());
		cell = row.createCell(2);
		cell.setCellValue(ob.get("RESERVE_TYPE1").toString());
		cell = row.createCell(3);
		cell.setCellValue(ob.get("RESERVE_TYPE2").toString());
		cell = row.createCell(4);
		cell.setCellValue(ob.get("RESERVE_TYPE3").toString());
		cell = row.createCell(5);
		cell.setCellValue(ob.get("RESERVE_TYPE4").toString());
		cell = row.createCell(6);
		cell.setCellValue(ob.get("RESERVE_TYPE5").toString());
		cell = row.createCell(7);
		cell.setCellValue(ob.get("TOTAL_PRICE").toString());
	}	
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