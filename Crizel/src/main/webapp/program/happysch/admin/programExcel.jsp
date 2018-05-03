<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@page import="org.apache.poi.hssf.usermodel.*" %>
<%@page import="org.apache.poi.hssf.util.*" %>
<%@page import="java.io.*" %>
<meta charset="UTF-8">


<%!
    /** 학교 연계 **/
    private class ProSchData {
        int req_no;
        String pro_cat_nm;
        String pro_name;
        int max_per;
        String req_date;
        String req_sch_id;
        String req_sch_nm;
        String sch_mng_nm;
        int req_per;
        String req_aft_flag;
        String apply_flag;
        
        //program
        int pro_no;
        
        //index
        int rnum;

        //total
        int req_total_per;
        int req_hold_cnt;
        int req_cancel_self_cnt;
        int req_cancel_admin_cnt;
        int req_apply_cnt;
    }
    //program
    private class ProSchList implements RowMapper<ProSchData> {
        public ProSchData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProSchData data   =   new ProSchData();
            
            //request
            data.req_no         =   rs.getInt("REQ_NO");
            data.pro_cat_nm     =   rs.getString("PRO_CAT_NM");
            data.pro_name       =   rs.getString("PRO_NAME");
            data.max_per        =   rs.getInt("MAX_PER");
            data.req_date       =   rs.getString("REQ_DATE");
            data.req_sch_id     =   rs.getString("REQ_SCH_ID");
            data.req_sch_nm     =   rs.getString("REQ_SCH_NM");
            data.sch_mng_nm     =   rs.getString("SCH_MNG_NM");
            data.req_per        =   rs.getInt("REQ_PER");
            data.req_aft_flag   =   rs.getString("REQ_AFT_FLAG");
            data.apply_flag     =   rs.getString("APPLY_FLAG");
            
            //program
            data.pro_no         =   rs.getInt("PRO_NO");
            
            return data;
        }
    }
    //total program
    private class ProSchTotal implements RowMapper<ProSchData> {
        public ProSchData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProSchData data   =   new ProSchData();

            data.pro_cat_nm             =   rs.getString("PRO_CAT_NM");
            data.pro_name               =   rs.getString("PRO_NAME");
            data.req_total_per          =   rs.getInt("REQ_TOTAL_PER");
            data.req_hold_cnt           =   rs.getInt("REQ_HOLD_CNT");
            data.req_cancel_self_cnt    =   rs.getInt("REQ_CANCEL_SELF_CNT");
            data.req_cancel_admin_cnt   =   rs.getInt("REQ_CANCEL_ADMIN_CNT");
            data.req_apply_cnt          =   rs.getInt("REQ_APPLY_CNT");

            return data;
        }
    }
    /** END 학교 연계 **/
    /** 지역민 평생교육 프로그램 **/
    private class ProLocalData {
        //program
        int pro_cat_no;
        int pro_no;
        String pro_cat_nm;
        String pro_name;
        String pro_tch_name;
        String pro_tch_tel;
        String pro_memo;
        String appStr_date;
        String appEnd_date;
        String proStr_date;
        String proEnd_date;
        int curr_per;
        int max_per;
        String reg_id;
        String reg_ip;
        String reg_date;
        String mod_date;
        String show_flag;
        String del_flag;
        String ob_employee;
        String ob_student;
        String ob_citizen;
        String pro_time;
        
        //request
        int req_no;
        String req_user_id;
        String req_group;
        String req_user_nm;
        int req_per;
        String apply_flag;

        //index
        int rnum;
        
        //total
        int req_total_per;
        int req_hold_cnt;
        int req_cancel_self_cnt;
        int req_cancel_admin_cnt;
        int req_apply_cnt;
    }
    //program
    private class ProLocalList implements RowMapper<ProLocalData> {
        public ProLocalData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProLocalData data    =   new ProLocalData();
            
            //data.pro_cat_no     =   rs.getInt("PRO_CAT_NO");
            data.pro_no         =   rs.getInt("PRO_NO");
            data.pro_cat_nm     =   rs.getString("PRO_CAT_NM");
            data.pro_name       =   rs.getString("PRO_NAME");
            data.pro_tch_name   =   rs.getString("PRO_TCH_NAME");
            data.pro_tch_tel    =   rs.getString("PRO_TCH_TEL");
            data.pro_memo       =   rs.getString("PRO_MEMO");
            data.appStr_date    =   rs.getString("APPSTR_DATE");
            data.appEnd_date    =   rs.getString("APPEND_DATE");
            data.proStr_date    =   rs.getString("PROSTR_DATE");
            data.proEnd_date    =   rs.getString("PROEND_DATE");
            data.curr_per       =   rs.getInt("CURR_PER");
            data.max_per        =   rs.getInt("MAX_PER");
            data.reg_id         =   rs.getString("REG_ID");
            data.reg_ip         =   rs.getString("REG_IP");
            data.reg_date       =   rs.getString("REG_DATE");
            data.mod_date       =   rs.getString("MOD_DATE");
            data.show_flag      =   rs.getString("SHOW_FLAG");
            data.del_flag       =   rs.getString("DEL_FLAG");
            data.ob_employee    =   rs.getString("OB_EMPLOYEE");
            data.ob_student     =   rs.getString("OB_STUDENT");
            data.ob_citizen     =   rs.getString("OB_CITIZEN");
            data.pro_time       =   rs.getString("PRO_TIME");

            //request
            data.req_user_id    =   rs.getString("REQ_USER_ID");
            data.req_group      =   rs.getString("REQ_GROUP");
            data.req_user_nm    =   rs.getString("REQ_USER_NM");
            data.req_per        =   rs.getInt("REQ_PER");
            data.apply_flag     =   rs.getString("APPLY_FLAG");
            
            return data;
        }
    }

    private class ProCatLocalList implements RowMapper<ProLocalData> {
        public ProLocalData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProLocalData data    =   new ProLocalData();
            
            data.pro_no         =   rs.getInt("PRO_NO");
            data.pro_name       =   rs.getString("PRO_NAME");
            
            return data;
        }
    }

    //total program
    private class ProLocalTotal implements RowMapper<ProLocalData> {
        public ProLocalData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProLocalData data   =   new ProLocalData();

            data.pro_cat_nm             =   rs.getString("PRO_CAT_NM");
            data.pro_name               =   rs.getString("PRO_NAME");
            data.req_total_per          =   rs.getInt("REQ_TOTAL_PER");
            data.req_hold_cnt           =   rs.getInt("REQ_HOLD_CNT");
            data.req_cancel_self_cnt    =   rs.getInt("REQ_CANCEL_SELF_CNT");
            data.req_cancel_admin_cnt   =   rs.getInt("REQ_CANCEL_ADMIN_CNT");
            data.req_apply_cnt          =   rs.getInt("REQ_APPLY_CNT");

            return data;
        }
    }
    /** END 지역민 평생교육 프로그램 **/

    /** 주제별마을학교 프로그램 **/
    private class ProTownData {
        //program
        int pro_cat_no;
        int pro_no;
        String pro_cat_nm;
        String pro_name;
        String pro_tch_name;
        String pro_tch_tel;
        String pro_memo;
        String appStr_date;
        String appEnd_date;
        String proStr_date;
        String proEnd_date;
        int curr_per;
        int max_per;
        String reg_id;
        String reg_ip;
        String reg_date;
        String mod_date;
        String show_flag;
        String del_flag;
        String ob_employee;
        String ob_student;
        String ob_citizen;
        String pro_time;
        
        //request
        int req_no;
        String req_user_id;
        String req_group;
        String req_user_nm;
        int req_per;
        String apply_flag;

        //index
        int rnum;
        
        //total
        int req_total_per;
        int req_hold_cnt;
        int req_cancel_self_cnt;
        int req_cancel_admin_cnt;
        int req_apply_cnt;
    }
    //program
    private class ProTownList implements RowMapper<ProTownData> {
        public ProTownData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProTownData data    =   new ProTownData();
            
            //data.pro_cat_no     =   rs.getInt("PRO_CAT_NO");
            data.pro_no         =   rs.getInt("PRO_NO");
            data.pro_cat_nm     =   rs.getString("PRO_CAT_NM");
            data.pro_name       =   rs.getString("PRO_NAME");
            data.pro_tch_name   =   rs.getString("PRO_TCH_NAME");
            data.pro_tch_tel    =   rs.getString("PRO_TCH_TEL");
            data.pro_memo       =   rs.getString("PRO_MEMO");
            data.appStr_date    =   rs.getString("APPSTR_DATE");
            data.appEnd_date    =   rs.getString("APPEND_DATE");
            data.proStr_date    =   rs.getString("PROSTR_DATE");
            data.proEnd_date    =   rs.getString("PROEND_DATE");
            data.curr_per       =   rs.getInt("CURR_PER");
            data.max_per        =   rs.getInt("MAX_PER");
            data.reg_id         =   rs.getString("REG_ID");
            data.reg_ip         =   rs.getString("REG_IP");
            data.reg_date       =   rs.getString("REG_DATE");
            data.mod_date       =   rs.getString("MOD_DATE");
            data.show_flag      =   rs.getString("SHOW_FLAG");
            data.del_flag       =   rs.getString("DEL_FLAG");
            data.ob_employee    =   rs.getString("OB_EMPLOYEE");
            data.ob_student     =   rs.getString("OB_STUDENT");
            data.ob_citizen     =   rs.getString("OB_CITIZEN");
            data.pro_time       =   rs.getString("PRO_TIME");

            //request
            data.req_user_id    =   rs.getString("REQ_USER_ID");
            data.req_group      =   rs.getString("REQ_GROUP");
            data.req_user_nm    =   rs.getString("REQ_USER_NM");
            data.req_per        =   rs.getInt("REQ_PER");
            data.apply_flag     =   rs.getString("APPLY_FLAG");
            
            return data;
        }
    }

    private class ProCatTownList implements RowMapper<ProTownData> {
        public ProTownData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProTownData data    =   new ProTownData();
            
            data.pro_no         =   rs.getInt("PRO_NO");
            data.pro_name       =   rs.getString("PRO_NAME");
            
            return data;
        }
    }

    //total program
    private class ProTownTotal implements RowMapper<ProTownData> {
        public ProTownData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProTownData data   =   new ProTownData();

            data.pro_cat_nm             =   rs.getString("PRO_CAT_NM");
            data.pro_name               =   rs.getString("PRO_NAME");
            data.req_total_per          =   rs.getInt("REQ_TOTAL_PER");
            data.req_hold_cnt           =   rs.getInt("REQ_HOLD_CNT");
            data.req_cancel_self_cnt    =   rs.getInt("REQ_CANCEL_SELF_CNT");
            data.req_cancel_admin_cnt   =   rs.getInt("REQ_CANCEL_ADMIN_CNT");
            data.req_apply_cnt          =   rs.getInt("REQ_APPLY_CNT");

            return data;
        }
    }
    /** END 주제별마을학교 프로그램 **/
    
    private String addZero (int num) {
        String ret_str  =   null;
        if (num < 10) {ret_str  =   "0" + Integer.toString(num);}
        else {ret_str   =   Integer.toString(num);}
        return ret_str;
    }

    //flag function
    private String applyText (String flag) {
        String returnText   =   "승인대기";
        if (flag.equals("Y")) {
            returnText  =   "<span class=\"fb red\">승인완료</span>";
        } else if (flag.equals("N")) {
            returnText  =   "<span class=\"fb blue\">승인대기</span>";
        } else if (flag.equals("A")) {
            returnText  =   "<span class=\"fb\">관리자 취소</span>";
        } else if (flag.equals("C")) {
            returnText  =   "<span class=\"fb\">직접취소</span>";
        } else {
            returnText  =   "<span class=\"fb red\">오류</span>";
        }
        return returnText;
    }

	private String aftText (String aftFlag) {
        String returnText   =   "전일";
        if (aftFlag.equals("M")) {
            returnText  =   "<span class='badge bg-am'>오전</span>";
        } else if (aftFlag.equals("F")) {
            returnText  =   "<span class='badge bg-pm'>오후</span>";
        } else if (aftFlag.equals("D")) {
            returnText  =   "<span class='badge bg-day'>전일</span>";
        }
        return returnText;
    }

%>
    
<%
    
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String fileName = "프로그램 통계관리";
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
cell.setCellValue("순서");
cell.setCellStyle(headCellStyle);
cell = row.createCell(1);
cell.setCellValue("분류");
cell.setCellStyle(headCellStyle);
cell = row.createCell(2);
cell.setCellValue("프로그램명");
cell.setCellStyle(headCellStyle);
cell = row.createCell(3);
cell.setCellValue("정원");
cell.setCellStyle(headCellStyle);
cell = row.createCell(4);
cell.setCellValue("신청일");
cell.setCellStyle(headCellStyle);
cell = row.createCell(5);
cell.setCellValue("신청시간");
cell.setCellStyle(headCellStyle);
cell = row.createCell(6);
cell.setCellValue("신청ID");
cell.setCellStyle(headCellStyle);
cell = row.createCell(7);
cell.setCellValue("이름(학교)");
cell.setCellStyle(headCellStyle);
cell = row.createCell(8);
cell.setCellValue("신청자명/그룹명");
cell.setCellStyle(headCellStyle);
cell = row.createCell(9);
cell.setCellValue("신청인원");
cell.setCellStyle(headCellStyle);
cell = row.createCell(10);
cell.setCellValue("최종상태");
cell.setCellStyle(headCellStyle);

cell = row.createCell(12);
cell.setCellValue("분류");
cell.setCellStyle(headCellStyle);
cell = row.createCell(13);
cell.setCellValue("프로그램명");
cell.setCellStyle(headCellStyle);
cell = row.createCell(14);
cell.setCellValue("신청인원");
cell.setCellStyle(headCellStyle);
cell = row.createCell(15);
cell.setCellValue("승인대기");
cell.setCellStyle(headCellStyle);
cell = row.createCell(16);
cell.setCellValue("직접취소");
cell.setCellStyle(headCellStyle);
cell = row.createCell(17);
cell.setCellValue("관리자취소");
cell.setCellStyle(headCellStyle);
cell = row.createCell(18);
cell.setCellValue("승인");
cell.setCellStyle(headCellStyle);
/** Cell Title Setting **/

int rowCnt = 1;
int rowCnt2 = 1;

StringBuffer sql    =   null;
String sql_str      =   null;
String where_str    =   null;
Object[] setObj		=   null;
List<ProSchData> schPro     =   null;
List<ProSchData> schList    =   null;
List<ProSchData> schTotal   =   null;
List<ProLocalData> localPro       =   null;
List<ProLocalData> localList      =   null;
List<ProLocalData> localTotal     =   null;
List<ProTownData> townPro       =   null;
List<ProTownData> townList      =   null;
List<ProTownData> townTotal     =   null;

int num = 0;

Calendar cal = Calendar.getInstance();

String str_year     =   Integer.toString(cal.get(Calendar.YEAR));
String end_year     =   Integer.toString(cal.get(Calendar.YEAR));

String start_date	=   parseNull(request.getParameter("start_date"), "");
if (start_date != null && start_date.length() > 5) {str_year   =   start_date.substring(0, 4);}
else {start_date    =   Integer.toString(cal.get(Calendar.YEAR)) + "-01-01";}

String end_date		=   parseNull(request.getParameter("end_date"), "");
if (end_date != null && end_date.length() > 5) {end_year   =   end_date.substring(0, 4);}
else {end_date    =   Integer.toString(cal.get(Calendar.YEAR)) + "-" + addZero(cal.get(Calendar.MONTH) + 4) + "-" + addZero(cal.get(Calendar.DAY_OF_MONTH));}

String search2		=   parseNull(request.getParameter("search2"), "sch");      //학교연계, 지역민, 주제별마을
String search3		=   parseNull(request.getParameter("search3"), "-1");       //프로그램분류
String search4		=   parseNull(request.getParameter("search4"), "-1");       //프로그램명
String search1		=   parseNull(request.getParameter("search1"), "-1");       //아이디, 신청자명
String keyword		=   parseNull(request.getParameter("keyword"), "");         //검색어

/****** WHERE SETTING *******/
//지역민 평생
if ("local".equals(search2)) {

    where_str   =   " WHERE ";
    where_str   +=  " ARD.REG_DATE BETWEEN '"+start_date+"' AND '"+end_date+"' ";
    if (Integer.parseInt(search3) > 0) {
        where_str   +=  " AND APD.PRO_CAT_NM = (SELECT CODE_VAL1 FROM HAPPY_PRO_CODE WHERE ARTCODE_NO = '"+search3+"' ) ";
    }
    if (Integer.parseInt(search4) > 0) {
        where_str   +=  " AND APD.PRO_NO = "+search4+" ";
    }
    if (keyword != null && keyword.length() > 0) {
        if ("req_id".equals(search1)) {
            where_str   +=  " AND ARD.REQ_USER_ID LIKE '%"+keyword+"%' ";
        } else if ("req_mng_nm".equals(search1)) {
            where_str   +=  " AND ARD.REQ_USER_NM LIKE '%"+keyword+"%' ";
        } else {
            where_str   +=  " AND (ARD.REQ_USER_ID LIKE '%"+keyword+"%' OR ARD.REQ_USER_NM LIKE '%"+keyword+"%') ";
        }
    }

//주제별 마을학교
} else if ("town".equals(search2)) {

    where_str   =   " WHERE ";
    where_str   +=  " ARD.REG_DATE BETWEEN '"+start_date+"' AND '"+end_date+"' ";
    if (Integer.parseInt(search3) > 0) {
        where_str   +=  " AND APD.PRO_CAT_NM = (SELECT CODE_VAL1 FROM HAPPY_PRO_CODE WHERE ARTCODE_NO = '"+search3+"' ) ";
    }
    if (Integer.parseInt(search4) > 0) {
        where_str   +=  " AND APD.PRO_NO = "+search4+" ";
    }
    if (keyword != null && keyword.length() > 0) {
        if ("req_id".equals(search1)) {
            where_str   +=  " AND ARD.REQ_USER_ID LIKE '%"+keyword+"%' ";
        } else if ("req_mng_nm".equals(search1)) {
            where_str   +=  " AND ARD.REQ_USER_NM LIKE '%"+keyword+"%' ";
        } else {
            where_str   +=  " AND (ARD.REQ_USER_ID LIKE '%"+keyword+"%' OR ARD.REQ_USER_NM LIKE '%"+keyword+"%') ";
        }
    }

//학교연계
} else {

    where_str   =   " WHERE ";
    where_str   +=  " ARA.REQ_DATE BETWEEN '"+start_date+"' AND '"+end_date+"' ";
    if (Integer.parseInt(search3) > 0) {
        where_str   +=  " AND APA.PRO_CAT_NM = (SELECT CODE_VAL1 FROM HAPPY_PRO_CODE WHERE ARTCODE_NO = '"+search3+"' ) ";
    }
    if (Integer.parseInt(search4) > 0) {
        where_str   +=  " AND APA.PRO_NO = "+search4+" ";
    }
    if (keyword != null && keyword.length() > 0) {
        if ("req_id".equals(search1)) {
            where_str   +=  " AND ARA.REQ_SCH_ID LIKE '%"+keyword+"%' ";
        } else if ("req_mng_nm".equals(search1)) {
            where_str   +=  " AND ARA.SCH_MNG_NM LIKE '%"+keyword+"%' ";
        } else {
            where_str   +=  " AND (ARA.REQ_SCH_ID LIKE '%"+keyword+"%' OR ARA.SCH_MNG_NM LIKE '%"+keyword+"%') ";
        }
    }

}
/****** END WHERE SETTING *******/

try {

    if ("local".equals(search2)) {
        //지역민 평생 프로그램 통계
        sql     =   new StringBuffer();
        sql_str =   " SELECT * ";
        sql_str +=  " FROM (SELECT * FROM HAPPY_REQ_LOCAL ORDER BY REG_DATE DESC) ARD ";
        sql_str +=  " LEFT JOIN HAPPY_PRO_LOCAL APD ";
        sql_str +=  " ON APD.PRO_NO = ARD.PRO_NO ";
        sql_str +=  where_str;
        sql_str +=  " ORDER BY ARD.REQ_NO DESC ";
        sql.append(sql_str);
        localList    =   jdbcTemplate.query(sql.toString()/*, new Object[]{str_year, end_year, search3}*/, new ProLocalList());

        //total statics
        sql     =   new StringBuffer();
        sql_str =   " SELECT ";
        sql_str +=  " PRO_CAT_NM ";
        sql_str +=  " , PRO_NAME ";
        sql_str +=  " , REQ_TOTAL_PER ";
        sql_str +=  " , REQ_HOLD_CNT ";
        sql_str +=  " , REQ_CANCEL_SELF_CNT ";
        sql_str +=  " , REQ_CANCEL_ADMIN_CNT ";
        sql_str +=  " , REQ_APPLY_CNT ";
        sql_str +=  " FROM (SELECT ";
        sql_str +=  "   APD.PRO_CAT_NM ";
        sql_str +=  "   , APD.PRO_NAME ";
        sql_str +=  "   , (SELECT NVL(SUM(REQ_PER), 0) FROM HAPPY_REQ_LOCAL WHERE PRO_NO = APD.PRO_NO) AS REQ_TOTAL_PER ";
        sql_str +=  "   , (SELECT ";
        sql_str +=  "       NVL(COUNT(APPLY_FLAG), 0) ";
        sql_str +=  "       FROM HAPPY_REQ_LOCAL WHERE APPLY_FLAG = 'N' AND PRO_NO = APD.PRO_NO) AS REQ_HOLD_CNT ";
        sql_str +=  "   , (SELECT  ";
        sql_str +=  "       NVL(COUNT(APPLY_FLAG), 0) ";
        sql_str +=  "       FROM HAPPY_REQ_LOCAL WHERE APPLY_FLAG = 'C' AND PRO_NO = APD.PRO_NO) AS REQ_CANCEL_SELF_CNT ";
        sql_str +=  "   , (SELECT  ";
        sql_str +=  "       NVL(COUNT(APPLY_FLAG), 0) ";
        sql_str +=  "       FROM HAPPY_REQ_LOCAL WHERE APPLY_FLAG = 'A' AND PRO_NO = APD.PRO_NO) AS REQ_CANCEL_ADMIN_CNT ";
        sql_str +=  "   , (SELECT  ";
        sql_str +=  "       NVL(COUNT(APPLY_FLAG), 0) ";
        sql_str +=  "       FROM HAPPY_REQ_LOCAL WHERE APPLY_FLAG = 'Y' AND PRO_NO = APD.PRO_NO) AS REQ_APPLY_CNT ";
        sql_str +=  " FROM HAPPY_PRO_LOCAL APD ";
        sql_str +=  " LEFT JOIN (SELECT * FROM HAPPY_REQ_LOCAL ORDER BY REG_DATE DESC) ARD ";
        sql_str +=  " ON APD.PRO_NO = ARD.PRO_NO ";
        sql_str +=  where_str;
        sql_str +=  " ORDER BY APD.PRO_NO ";
        sql_str +=  " ) ";
        sql_str +=  " GROUP BY ";
        sql_str +=  " PRO_CAT_NM ";
        sql_str +=  " , PRO_NAME ";
        sql_str +=  " , REQ_TOTAL_PER ";
        sql_str +=  " , REQ_HOLD_CNT ";
        sql_str +=  " , REQ_CANCEL_SELF_CNT ";
        sql_str +=  " , REQ_CANCEL_ADMIN_CNT ";
        sql_str +=  " , REQ_APPLY_CNT ";
        sql.append(sql_str);
        localTotal  =   jdbcTemplate.query(sql.toString()/*, new Object[]{str_year, end_year, search3}*/, new ProLocalTotal());
        
        String pro_cat_nm = "";
        int startPoint = 1;
        int size = 0;
        ProLocalData data    =   null;
        ProLocalData total   =   null;

        if(localList.size() > localTotal.size()){
            size = localList.size();
        }else{
            size = localTotal.size();
        }
        
        for (int i = 0; i < size; i++) {
            row = sheet.createRow(rowCnt++);
            if (i < localList.size()) {
                data    =   localList.get(i);
                cell    =   row.createCell(0);
                cell.setCellValue(++num);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(1);
                cell.setCellValue(data.pro_cat_nm);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(2);
                cell.setCellValue(data.pro_name);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(3);
                cell.setCellValue(data.max_per);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(4);
                cell.setCellValue(data.reg_date.substring(0, 10));
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(5);
                cell.setCellValue(data.pro_time);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(6);
                cell.setCellValue(data.req_user_id);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(7);
                cell.setCellValue(data.req_user_nm);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(8);
                cell.setCellValue(data.req_group);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(9);
                cell.setCellValue(data.req_per);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(10);
                cell.setCellValue(data.apply_flag);
                cell.setCellStyle(cellStyle);
            }//END IF
            if (i < localTotal.size()) {
                total   =   localTotal.get(i);
                cell    =   row.createCell(12);
                cell.setCellValue(total.pro_cat_nm);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(13);
                cell.setCellValue(total.pro_name);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(14);
                cell.setCellValue(total.req_total_per);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(15);
                cell.setCellValue(total.req_hold_cnt);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(16);
                cell.setCellValue(total.req_cancel_self_cnt);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(17);
                cell.setCellValue(total.req_cancel_admin_cnt);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(18);
                cell.setCellValue(total.req_apply_cnt);
                cell.setCellStyle(cellStyle);
            }//END IF
        }//END FOR

    } else if ("town".equals(search2)) {
        //지역민 평생 프로그램 통계
        sql     =   new StringBuffer();
        sql_str =   " SELECT * ";
        sql_str +=  " FROM (SELECT * FROM HAPPY_REQ_TOWN ORDER BY REG_DATE DESC) ARD ";
        sql_str +=  " LEFT JOIN HAPPY_PRO_TOWN APD ";
        sql_str +=  " ON APD.PRO_NO = ARD.PRO_NO ";
        sql_str +=  where_str;
        sql_str +=  " ORDER BY ARD.REQ_NO DESC ";
        sql.append(sql_str);
        townList    =   jdbcTemplate.query(sql.toString()/*, new Object[]{str_year, end_year, search3}*/, new ProTownList());

        //total statics
        sql     =   new StringBuffer();
        sql_str =   " SELECT ";
        sql_str +=  " PRO_CAT_NM ";
        sql_str +=  " , PRO_NAME ";
        sql_str +=  " , REQ_TOTAL_PER ";
        sql_str +=  " , REQ_HOLD_CNT ";
        sql_str +=  " , REQ_CANCEL_SELF_CNT ";
        sql_str +=  " , REQ_CANCEL_ADMIN_CNT ";
        sql_str +=  " , REQ_APPLY_CNT ";
        sql_str +=  " FROM (SELECT ";
        sql_str +=  "   APD.PRO_CAT_NM ";
        sql_str +=  "   , APD.PRO_NAME ";
        sql_str +=  "   , (SELECT NVL(SUM(REQ_PER), 0) FROM HAPPY_REQ_TOWN WHERE PRO_NO = APD.PRO_NO) AS REQ_TOTAL_PER ";
        sql_str +=  "   , (SELECT ";
        sql_str +=  "       NVL(COUNT(APPLY_FLAG), 0) ";
        sql_str +=  "       FROM HAPPY_REQ_TOWN WHERE APPLY_FLAG = 'N' AND PRO_NO = APD.PRO_NO) AS REQ_HOLD_CNT ";
        sql_str +=  "   , (SELECT  ";
        sql_str +=  "       NVL(COUNT(APPLY_FLAG), 0) ";
        sql_str +=  "       FROM HAPPY_REQ_TOWN WHERE APPLY_FLAG = 'C' AND PRO_NO = APD.PRO_NO) AS REQ_CANCEL_SELF_CNT ";
        sql_str +=  "   , (SELECT  ";
        sql_str +=  "       NVL(COUNT(APPLY_FLAG), 0) ";
        sql_str +=  "       FROM HAPPY_REQ_TOWN WHERE APPLY_FLAG = 'A' AND PRO_NO = APD.PRO_NO) AS REQ_CANCEL_ADMIN_CNT ";
        sql_str +=  "   , (SELECT  ";
        sql_str +=  "       NVL(COUNT(APPLY_FLAG), 0) ";
        sql_str +=  "       FROM HAPPY_REQ_TOWN WHERE APPLY_FLAG = 'Y' AND PRO_NO = APD.PRO_NO) AS REQ_APPLY_CNT ";
        sql_str +=  " FROM HAPPY_PRO_TOWN APD ";
        sql_str +=  " LEFT JOIN (SELECT * FROM HAPPY_REQ_TOWN ORDER BY REG_DATE DESC) ARD ";
        sql_str +=  " ON APD.PRO_NO = ARD.PRO_NO ";
        sql_str +=  where_str;
        sql_str +=  " ORDER BY APD.PRO_NO ";
        sql_str +=  " ) ";
        sql_str +=  " GROUP BY ";
        sql_str +=  " PRO_CAT_NM ";
        sql_str +=  " , PRO_NAME ";
        sql_str +=  " , REQ_TOTAL_PER ";
        sql_str +=  " , REQ_HOLD_CNT ";
        sql_str +=  " , REQ_CANCEL_SELF_CNT ";
        sql_str +=  " , REQ_CANCEL_ADMIN_CNT ";
        sql_str +=  " , REQ_APPLY_CNT ";
        sql.append(sql_str);
        townTotal  =   jdbcTemplate.query(sql.toString()/*, new Object[]{str_year, end_year, search3}*/, new ProTownTotal());
        
        String pro_cat_nm = "";
        int startPoint = 1;
        int size = 0;
        ProTownData data    =   null;
        ProTownData total   =   null;

        if(townList.size() > townTotal.size()){
            size = townList.size();
        }else{
            size = townTotal.size();
        }

        for (int i = 0; i < size; i++) {
            row = sheet.createRow(rowCnt++);
            if (i < townList.size()) {
                data    =   townList.get(i);
                cell    =   row.createCell(0);
                cell.setCellValue(++num);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(1);
                cell.setCellValue(data.pro_cat_nm);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(2);
                cell.setCellValue(data.pro_name);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(3);
                cell.setCellValue(data.max_per);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(4);
                cell.setCellValue(data.reg_date.substring(0, 10));
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(5);
                cell.setCellValue(data.pro_time);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(6);
                cell.setCellValue(data.req_user_id);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(7);
                cell.setCellValue(data.req_user_nm);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(8);
                cell.setCellValue(data.req_group);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(9);
                cell.setCellValue(data.req_per);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(10);
                cell.setCellValue(data.apply_flag);
                cell.setCellStyle(cellStyle);
            }//END IF
            if (i < townTotal.size()) {
                total   =   townTotal.get(i);
                cell    =   row.createCell(12);
                cell.setCellValue(total.pro_cat_nm);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(13);
                cell.setCellValue(total.pro_name);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(14);
                cell.setCellValue(total.req_total_per);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(15);
                cell.setCellValue(total.req_hold_cnt);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(16);
                cell.setCellValue(total.req_cancel_self_cnt);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(17);
                cell.setCellValue(total.req_cancel_admin_cnt);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(18);
                cell.setCellValue(total.req_apply_cnt);
                cell.setCellStyle(cellStyle);
            }//END IF
        }//END FOR
        
    } else {
        //상시 프로그램 통계
        sql     =   new StringBuffer();
        sql_str =   "       SELECT ";
        sql_str +=  "       ARA.REQ_NO ";
        sql_str +=  "       , APA.PRO_CAT_NM ";
        sql_str +=  "       , ARAC.PRO_NAME ";
        sql_str +=  "       , APA.MAX_PER ";
        sql_str +=  "       , ARA.REQ_DATE ";
        sql_str +=  "       , ARA.REQ_SCH_ID ";
        sql_str +=  "       , ARA.REQ_SCH_NM ";
        sql_str +=  "       , ARA.SCH_MNG_NM ";
        sql_str +=  "       , ARAC.REQ_PER ";
        sql_str +=  "       , ARA.REQ_AFT_FLAG ";
        sql_str +=  "       , ARA.APPLY_FLAG ";
        sql_str +=  "       , ARAC.PRO_NO ";
        sql_str +=  "       FROM (SELECT * FROM HAPPY_REQ_SCH ORDER BY REG_DATE DESC) ARA LEFT JOIN HAPPY_REQ_SCH_CNT ARAC ";
        sql_str +=  "       ON ARA.REQ_NO = ARAC.REQ_NO ";
        sql_str +=  "       JOIN HAPPY_PRO_SCH APA ";
        sql_str +=  "       ON ARAC.PRO_NO = APA.PRO_NO ";
        sql_str +=  where_str;
        sql_str +=  "   ORDER BY ARA.REQ_NO ASC ";
        sql.append(sql_str);
        schList   =   jdbcTemplate.query(sql.toString()/*, new Object[]{str_year, end_year, search3}*/, new ProSchList());

        //total statics
        sql     =   new StringBuffer();
        sql_str =   " SELECT ";
        sql_str +=  "   PRO_CAT_NM ";
        sql_str +=  "   , PRO_NAME ";
        sql_str +=  "   , REQ_TOTAL_PER ";
        sql_str +=  "   , REQ_HOLD_CNT ";
        sql_str +=  "   , REQ_CANCEL_SELF_CNT ";
        sql_str +=  "   , REQ_CANCEL_ADMIN_CNT ";
        sql_str +=  "   , REQ_APPLY_CNT ";
        sql_str +=  "   FROM (SELECT ";
        sql_str +=  "   APA.PRO_CAT_NM ";
        sql_str +=  "   , ARAC.PRO_NAME ";
        sql_str +=  "   , (SELECT NVL(SUM(REQ_PER), 0) FROM HAPPY_REQ_SCH_CNT WHERE PRO_NO = APA.PRO_NO) AS REQ_TOTAL_PER ";
        sql_str +=  "   , (SELECT ";
        sql_str +=  "   NVL(COUNT(APPLY_FLAG), 0) ";
        sql_str +=  "   FROM HAPPY_REQ_SCH A LEFT JOIN HAPPY_REQ_SCH_CNT B ";
        sql_str +=  "   ON A.REQ_NO = B.REQ_NO WHERE A.APPLY_FLAG = 'N' AND B.PRO_NO = APA.PRO_NO) AS REQ_HOLD_CNT ";
        sql_str +=  "   , (SELECT  ";
        sql_str +=  "   NVL(COUNT(APPLY_FLAG), 0) ";
        sql_str +=  "   FROM HAPPY_REQ_SCH A LEFT JOIN HAPPY_REQ_SCH_CNT B ";
        sql_str +=  "   ON A.REQ_NO = B.REQ_NO WHERE A.APPLY_FLAG = 'C' AND B.PRO_NO = APA.PRO_NO) AS REQ_CANCEL_SELF_CNT ";
        sql_str +=  "   , (SELECT ";
        sql_str +=  "   NVL(COUNT(APPLY_FLAG), 0) ";
        sql_str +=  "   FROM HAPPY_REQ_SCH A LEFT JOIN HAPPY_REQ_SCH_CNT B ";
        sql_str +=  "   ON A.REQ_NO = B.REQ_NO WHERE A.APPLY_FLAG = 'A' AND B.PRO_NO = APA.PRO_NO) AS REQ_CANCEL_ADMIN_CNT ";
        sql_str +=  "   , (SELECT ";
        sql_str +=  "   NVL(COUNT(APPLY_FLAG), 0) ";
        sql_str +=  "   FROM HAPPY_REQ_SCH A LEFT JOIN HAPPY_REQ_SCH_CNT B ";
        sql_str +=  "   ON A.REQ_NO = B.REQ_NO WHERE A.APPLY_FLAG = 'Y' AND B.PRO_NO = APA.PRO_NO) AS REQ_APPLY_CNT ";
        sql_str +=  "    ";
        sql_str +=  "   FROM (SELECT * FROM HAPPY_REQ_SCH ORDER BY REG_DATE DESC) ARA LEFT JOIN HAPPY_REQ_SCH_CNT ARAC ";
        sql_str +=  "   ON ARA.REQ_NO = ARAC.REQ_NO ";
        sql_str +=  "   JOIN HAPPY_PRO_SCH APA ";
        sql_str +=  "   ON ARAC.PRO_NO = APA.PRO_NO ";
        sql_str +=  where_str;
        sql_str +=  "   ) ";
        sql_str +=  "   GROUP BY  ";
        sql_str +=  "       PRO_CAT_NM ";
        sql_str +=  "       , PRO_NAME ";
        sql_str +=  "       , REQ_TOTAL_PER ";
        sql_str +=  "       , REQ_HOLD_CNT ";
        sql_str +=  "       , REQ_CANCEL_SELF_CNT ";
        sql_str +=  "       , REQ_CANCEL_ADMIN_CNT ";
        sql_str +=  "       , REQ_APPLY_CNT ";
        sql.append(sql_str);
        schTotal  =   jdbcTemplate.query(sql.toString()/*, new Object[]{str_year, end_year, search3}*/, new ProSchTotal());
        
        String pro_cat_nm = "";
        int startPoint = 1;
        int size = 0;
        ProSchData data   =   null;
        ProSchData total  =   null;

        if(schList.size() > schTotal.size()){
            size = schList.size();
        } else {
            size = schTotal.size();
        }
        
        for (int i = 0; i < size; i++) {
            row = sheet.createRow(rowCnt++);
            if (i < schList.size()) {
                data    =   schList.get(i);
                cell    =   row.createCell(0);
                cell.setCellValue(++num);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(1);
                cell.setCellValue(data.pro_cat_nm);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(2);
                cell.setCellValue(data.pro_name);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(3);
                cell.setCellValue(data.max_per);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(4);
                cell.setCellValue(data.req_date);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(5);
                cell.setCellValue(data.req_sch_id);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(6);
                cell.setCellValue(data.req_sch_nm);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(7);
                cell.setCellValue(data.sch_mng_nm);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(8);
                cell.setCellValue(data.req_per);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(9);
                cell.setCellValue(data.req_aft_flag);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(10);
                cell.setCellValue(data.apply_flag);
                cell.setCellStyle(cellStyle);
            }//END IF
            if (i < schTotal.size()) {
                total   =   schTotal.get(i);
                cell    =   row.createCell(12);
                cell.setCellValue(total.pro_cat_nm);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(13);
                cell.setCellValue(total.pro_name);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(14);
                cell.setCellValue(total.req_total_per);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(15);
                cell.setCellValue(total.req_hold_cnt);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(16);
                cell.setCellValue(total.req_cancel_self_cnt);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(17);
                cell.setCellValue(total.req_cancel_admin_cnt);
                cell.setCellStyle(cellStyle);
                cell    =   row.createCell(18);
                cell.setCellValue(total.req_apply_cnt);
                cell.setCellStyle(cellStyle);
            }//END IF
        }   //END FOR
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