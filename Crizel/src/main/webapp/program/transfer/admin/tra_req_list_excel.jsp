<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@page import="org.apache.poi.hssf.usermodel.*" %>
<%@page import="org.apache.poi.hssf.util.*" %>
<%@page import="java.io.*" %>
<meta charset="UTF-8">

<%!

    private class TransferData {
        String kind;
        String schName;
        String stName;
        String stGrade;
        String receiptYear;
        String receiptNum;
        String stClass;
        String applyDate;
        String applyTime;
        String stateCd;
        String transferNo;
    }

    private class TransferList implements RowMapper<TransferData> {
        public TransferData mapRow(ResultSet rs, int rowNum) throws SQLException {
            TransferData data   =   new TransferData();

            data.kind           =   rs.getString("KIND");
            data.schName        =   rs.getString("SCHNAME");
            data.stName         =   rs.getString("STNAME");
            data.stGrade        =   rs.getString("STGRADE");
            data.receiptYear    =   rs.getString("RECEIPTYEAR");
            data.receiptNum     =   rs.getString("RECEIPTNUM");
            data.stClass        =   rs.getString("STCLASS");
            data.applyDate      =   rs.getString("APPLYDATE");
            data.applyTime      =   rs.getString("APPLYTIME");
            data.stateCd        =   rs.getString("STATECD");
            data.transferNo     =   rs.getString("TRANSFERNO");

            return data;
        }
    }

    //typeSearchDetail	정리
    public String searchTypeDetail (String stateCd) {
        String retString    =   "민원인 결재 대기";
        if ("PAID".equals(stateCd)) {
            retString   =   "재적학교 접수 대기중";
        } else if ("SCH_RECEIPT".equals(stateCd)) {
            retString   =   "재적학교 접수 후 처리중";
        } else if ("SCH_APPROVAL".equals(stateCd)) {
            retString   =   "접수대기";
        } else if ("TR_F_RECEIPT".equals(stateCd)) {
            retString   =   "처리중";
        } else if ("TR_F_APPROVAL".equals(stateCd)) {
            retString   =   "최종 승인자 승인 대기중";
        } else if ("TR_L_APPROVAL".equals(stateCd)) {
            retString   =   "최종 처리 완료";
        } else if ("MW_CANCEL".equals(stateCd)) {
            retString   =   "민원인에 의한 취소";
        } else if ("SYS_CANCEL".equals(stateCd)) {
            retString   =   "시스템에 의한 자동 취소";
        } else if ("SCH_CANCEL".equals(stateCd)) {
            retString   =   "재적 학교 담당자에 의한 자동 취소";
        } else if ("TR_CANCEL".equals(stateCd)) {
            retString   =   "도교육청 담당자에 의한 취소";
        } else if ("APPLY".equals(stateCd)) {
            retString   =   "민원인 결재 대기";
        }

        return retString;
    }

    public String searchType (String stateCd) {
        String retString    =   "미리보기";
        if ("SCH_APPROVAL".equals(stateCd)) {
            retString   =   "접수대기";
        } else if ("TR_F_RECEIPT".equals(stateCd)) {
            retString   =   "처리중";
        } else if ("TR_F_APPROVAL".equals(stateCd) || "TR_L_APPROVAL".equals(stateCd)) {
            retString   =   "승인완료";
        } else if ("MW_CANCEL".equals(stateCd) || "SYS_CANCEL".equals(stateCd) || "SCH_CANCEL".equals(stateCd) || "TR_CANCEL".equals(stateCd)) {
            retString   =   "취소";
        } else if ("APPLY".equals(stateCd) || "PAID".equals(stateCd) || "SCH_RECEIPT".equals(stateCd)) {
            retString   =   "미리보기";
        }
        return retString;
    }

    public String transKind (String kind) {
        String retString    =   "";
        if ("OFFLINE_VISIT".equals(kind)) {
            retString   =   "방문신청";
        } else if ("OFFLINE_FAX".equals(kind)) {
            retString   =   "팩스신청";
        }
        return retString;
    }

%>

<%
    
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String fileName = "전입학 배정원서 목록 출력";
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
/** Cell Style Setting **/
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
/** Cell Style Setting **/

/** Cell Title Setting **/
row = sheet.createRow(0);
cell = row.createCell(0);
cell.setCellValue("번호");
cell.setCellStyle(headCellStyle);
cell = row.createCell(1);
cell.setCellValue("신청종류\n(접수번호)");
cell.setCellStyle(headCellStyle);
cell = row.createCell(2);
cell.setCellValue("학교명");
cell.setCellStyle(headCellStyle);
cell = row.createCell(3);
cell.setCellValue("학생이름");
cell.setCellStyle(headCellStyle);
cell = row.createCell(4);
cell.setCellValue("학년");
cell.setCellStyle(headCellStyle);
cell = row.createCell(5);
cell.setCellValue("반");
cell.setCellStyle(headCellStyle);
cell = row.createCell(6);
cell.setCellValue("접수일자");
cell.setCellStyle(headCellStyle);
cell = row.createCell(7);
cell.setCellValue("접수일자");
cell.setCellStyle(headCellStyle);
cell = row.createCell(8);
cell.setCellValue("상태그룹");
cell.setCellStyle(headCellStyle);
cell = row.createCell(9);
cell.setCellValue("상태 상세 설명");
cell.setCellStyle(headCellStyle);
/** Cell Title Setting **/
int rowCnt = 1;

StringBuffer sql    =   null;
String sql_str      =   null;
String where_str    =   null;
Object[] setObj		=   null;
List<TransferData> transferData =   null;

int num = 0;

String selYear  =   request.getParameter("selYear");
String selMonth =   request.getParameter("selMonth");
String comDate  =   selYear + selMonth;

try {

    sql =   new StringBuffer();
    sql.append(" SELECT                                                                 ");
    sql.append(" B.KIND, B.SCHNAME, B.STNAME, B.STGRADE, B.RECEIPTYEAR, B.RECEIPTNUM,   ");
    sql.append(" B.STCLASS, B.APPLYDATE, B.APPLYTIME, C.STATECD, B.TRANSFERNO           ");
    sql.append(" FROM TTRANSFER B, TTRANS_STATE C                                       ");
    sql.append(" WHERE 1=1 AND B.TRANSFERNO = C.TRANSFERNO                              ");
    sql.append(" AND C.ORDERED = 1 AND B.TEMPFLAG = 'N'                                 ");
    sql.append(" AND APPLYDATE BETWEEN '20180301' AND '20180332'                        ");
    sql.append(" ORDER BY APPLYDATE DESC, APPLYTIME DESC                                ");
    try {
        transferData    =   jdbcTemplate.query(sql.toString(), new TransferList()/*, new Object[]{comDate, comDate}*/);
    } catch(Exception e) {
        transferData    =   null;
    }

    int size    =   0;
    TransferData data   =   null;

    size    =   transferData.size();

    for (int i = 0; i < size; i++) {
        row = sheet.createRow(rowCnt++);
        data    =   transferData.get(i);
        cell    =   row.createCell(0);
        cell.setCellValue(data.transferNo);
        cell.setCellStyle(cellStyle);
        cell    =   row.createCell(1);
        cell.setCellValue(transKind(data.kind) + "\n(" + data.receiptYear + data.receiptNum + ")");
        cell.setCellStyle(cellStyle);
        cell    =   row.createCell(2);
        cell.setCellValue(data.schName);
        cell.setCellStyle(cellStyle);
        cell    =   row.createCell(3);
        cell.setCellValue(data.stName);
        cell.setCellStyle(cellStyle);
        cell    =   row.createCell(4);
        cell.setCellValue(data.stGrade);
        cell.setCellStyle(cellStyle);
        cell    =   row.createCell(5);
        cell.setCellValue(data.stClass);
        cell.setCellStyle(cellStyle);
        cell    =   row.createCell(6);
        cell.setCellValue(data.applyDate);
        cell.setCellStyle(cellStyle);
        cell    =   row.createCell(7);
        cell.setCellValue(data.stClass);
        cell.setCellStyle(cellStyle);
        cell    =   row.createCell(8);
        cell.setCellValue(searchType(data.stateCd));
        cell.setCellStyle(cellStyle);
        cell    =   row.createCell(9);
        cell.setCellValue(searchTypeDetail(data.stateCd));
        cell.setCellStyle(cellStyle);
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