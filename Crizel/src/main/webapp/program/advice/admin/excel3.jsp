<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@page import="org.apache.poi.hssf.usermodel.*" %>
<%@page import="java.io.*" %>
<meta charset="UTF-8">
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String search_st_dt = parseNull(request.getParameter("search_st_dt"),"");	//검색시작일자
String search_ed_dt = parseNull(request.getParameter("search_ed_dt"),"");		//검색종료일자
String search_category_gb = parseNull(request.getParameter("search_category_gb"));	//분류 A01 = 진로 , A02 = 진학
String search_target_gb = parseNull(request.getParameter("search_target_gb"));		//대상 B01 = 초등 , B02 = 중등
String search_gb = parseNull(request.getParameter("search_gb")); //검색구분
String search_keyword = parseNull(request.getParameter("search_keyword")); //검색어

String fileName = "상담통계";
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
cell.setCellValue("상담대기중");
cell = row.createCell(4);
cell.setCellValue("상담완료");
cell = row.createCell(5);
cell.setCellValue("미상담 건수");
cell = row.createCell(6);
cell.setCellValue("합계");

int rowCnt = 1;

PreparedStatement pstmt = null;
ResultSet rs = null;
Connection conn = null;
StringBuffer sql = new StringBuffer();

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	
	sql = new StringBuffer();
	sql.append("        SELECT													 \n");
	sql.append("          A.TEACHER_ID                                           \n");
	sql.append("        , A.TEACHER_NM                                           \n");
	sql.append("        , CASE WHEN A.CATEGORY_GB = 'A01' THEN '진로'              \n");
	sql.append("               WHEN A.CATEGORY_GB = 'A02' THEN '진학'              \n");
	sql.append("          END CATEGORY_GB                                        \n");
	sql.append("        , CASE WHEN A.TARGET_GB = 'B01' THEN '초등'                \n");
	sql.append("               WHEN A.TARGET_GB = 'B02' THEN '중등'                \n");
	sql.append("          END TARGET_GB                                          \n");

	sql.append("        , (                                                      \n");
	sql.append("              SELECT                                             \n");
	sql.append("                COUNT(*)                                         \n");
	sql.append("              FROM ADVICE_BOARD_LOG B                                \n");
	sql.append("              WHERE B.BOARD_LVL = 0                              \n");
	sql.append("              AND NOTICE_YN = 'N'                                \n");
	sql.append("              AND B.ADVICE_STS = 'A'                             \n");
	sql.append("              AND B.TEACHER_ID = A.TEACHER_ID                    \n");
	if(!"".equals(parseNull(search_st_dt)) && !"".equals(parseNull(search_ed_dt))){	//검색일자
		sql.append("          AND REG_DT >= '"+search_st_dt+"'                   \n");
		sql.append("          AND REG_DT <= '"+search_ed_dt+"'                   \n");
	}
	sql.append("           ) AS WAIT_CNT                                         \n");

	sql.append("        , (                                                      \n");
	sql.append("              SELECT                                             \n");
	sql.append("                COUNT(*)                                         \n");
	sql.append("              FROM ADVICE_BOARD_LOG B                            \n");
	sql.append("              WHERE NOTICE_YN = 'N'                              \n");
	sql.append("              AND B.ADVICE_STS = 'B'                             \n");
	sql.append("              AND B.TEACHER_ID = A.TEACHER_ID                    \n");
	if(!"".equals(parseNull(search_st_dt)) && !"".equals(parseNull(search_ed_dt))){	//검색일자
		sql.append("          AND REG_DT >= '"+search_st_dt+"'                   \n");
		sql.append("          AND REG_DT <= '"+search_ed_dt+"'                   \n");
	}
	sql.append("           ) AS SUCC_CNT                                         \n");

	sql.append("        , (                                                      \n");
	sql.append("              SELECT                                             \n");
	sql.append("                COUNT(*)                                         \n");
	sql.append("              FROM ADVICE_BOARD_LOG B                                \n");
	sql.append("              WHERE NOTICE_YN = 'N'                                \n");
	sql.append("              AND B.ADVICE_STS = 'C'                             \n");
	sql.append("              AND B.TEACHER_ID = A.TEACHER_ID                    \n");
	if(!"".equals(parseNull(search_st_dt)) && !"".equals(parseNull(search_ed_dt))){	//검색일자
		sql.append("          AND REG_DT >= '"+search_st_dt+"'                   \n");
		sql.append("          AND REG_DT <= '"+search_ed_dt+"'                   \n");
	}
	sql.append("           ) AS CANCEL_CNT                                       \n");

	sql.append("        , (                                                      \n");
	sql.append("              SELECT                                             \n");
	sql.append("                COUNT(*)                                         \n");
	sql.append("              FROM ADVICE_BOARD_LOG B                                \n");
	sql.append("              WHERE NOTICE_YN = 'N'                                \n");
	sql.append("              AND B.ADVICE_STS = 'E'                             \n");
	sql.append("              AND B.TEACHER_ID = A.TEACHER_ID                    \n");
	if(!"".equals(parseNull(search_st_dt)) && !"".equals(parseNull(search_ed_dt))){	//검색일자
		sql.append("          AND REG_DT >= '"+search_st_dt+"'                   \n");
		sql.append("          AND REG_DT <= '"+search_ed_dt+"'                   \n");
	}
	sql.append("           ) AS DEL_COMP_CNT                                     \n");

	sql.append("        , (                                                      \n");
	sql.append("              SELECT                                             \n");
	sql.append("                COUNT(*)                                         \n");
	sql.append("              FROM ADVICE_BOARD_LOG B                                \n");
	sql.append("              WHERE B.BOARD_LVL = 1                              \n");
	sql.append("              AND NOTICE_YN = 'N'                                \n");
	sql.append("              AND B.TEACHER_ID = A.TEACHER_ID                    \n");
	if(!"".equals(parseNull(search_st_dt)) && !"".equals(parseNull(search_ed_dt))){	//검색일자
		sql.append("          AND REG_DT >= '"+search_st_dt+"'                   \n");
		sql.append("          AND REG_DT <= '"+search_ed_dt+"'                   \n");
	}
	sql.append("           ) AS TOTAL_CNT                                        \n");

	sql.append("        FROM ADVICE_TEACHER A                                    \n");
	sql.append("        WHERE 1=1                                    			 \n");

	if(!"".equals(parseNull(search_category_gb))){	//분류
		sql.append("AND A.CATEGORY_GB = '"+search_category_gb+"' ");
	}

	if(!"".equals(parseNull(search_target_gb))){	//대상
		sql.append("AND A.TARGET_GB = '"+search_target_gb+"' ");

	}

	if(!"".equals(parseNull(search_keyword))){
		if("A".equals(search_gb)){	//이름
			sql.append("AND A.TEACHER_NM LIKE '%'||'"+search_keyword+"'||'%' ");
		}else if("B".equals(search_gb)){	//아이디
			sql.append("AND A.TEACHER_ID LIKE '%'||'"+search_keyword+"'||'%' ");
		}
	}
	sql.append("		ORDER BY A.TEACHER_NM ASC ");

	pstmt = conn.prepareStatement(sql.toString());
	rs = pstmt.executeQuery();
	int count = 1;
	while(rs.next()){
		row = sheet.createRow(rowCnt++);
		cell = row.createCell(0);
		cell.setCellValue(rs.getString("CATEGORY_GB"));
		cell = row.createCell(1);
		cell.setCellValue(rs.getString("TARGET_GB"));
		cell = row.createCell(2);
		cell.setCellValue(rs.getString("TEACHER_NM"));

		cell = row.createCell(3);
		cell.setCellValue(rs.getInt("WAIT_CNT"));
		cell = row.createCell(4);
		cell.setCellValue(rs.getInt("SUCC_CNT") + rs.getInt("DEL_COMP_CNT"));
		//cell.setCellValue(rs.getInt("SUCC_CNT"));
		cell = row.createCell(5);
		cell.setCellValue(rs.getInt("CANCEL_CNT"));

		cell = row.createCell(6);
		cell.setCellValue(rs.getInt("WAIT_CNT") + rs.getInt("SUCC_CNT") + rs.getInt("DEL_COMP_CNT") + rs.getInt("CANCEL_CNT"));
		
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