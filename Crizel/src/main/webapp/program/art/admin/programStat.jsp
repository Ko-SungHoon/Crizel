<%
/**
*   PURPOSE :   프로그램 통계 관리
*   CREATE  :   20180227_tue    JI
*   MODIFY  :   20180223 LJH 마크업, 클래스 수정
**/
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ page import="org.springframework.jdbc.core.*" %>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
    
<%/*************************************** 프로그램 파트 ****************************************/%>
<%!
    //category
    private class ProCatCode {
        int artcode_no;
        String code_tbl;
        String code_col;
        String code_name;
        String code_val1;
        String code_val2;
        String code_val3;
    }
    //category list
    private class ProCatList implements RowMapper<ProCatCode> {
        public ProCatCode mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProCatCode cate =   new ProCatCode();
            cate.artcode_no =   rs.getInt("ARTCODE_NO");
            cate.code_tbl   =   rs.getString("CODE_TBL");
            cate.code_col   =   rs.getString("CODE_COL");
            cate.code_name  =   rs.getString("CODE_NAME");
            cate.code_val1  =   rs.getString("CODE_VAL1");
            cate.code_val2  =   rs.getString("CODE_VAL2");
            cate.code_val3  =   rs.getString("CODE_VAL3");
            
            return cate;
        }
    }
    
    private class ProAlwayData {
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
    private class ProAlwayList implements RowMapper<ProAlwayData> {
        public ProAlwayData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProAlwayData data   =   new ProAlwayData();
            
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
            
            //index
            data.rnum           =   rs.getInt("RNUM");
            
            return data;
        }
    }
    //total program
    private class ProAlwayTotal implements RowMapper<ProAlwayData> {
        public ProAlwayData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProAlwayData data   =   new ProAlwayData();

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
    //search3 cat pro_list
    private class ProCatAlwayList implements RowMapper<ProAlwayData> {
        public ProAlwayData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProAlwayData data   =   new ProAlwayData();
            
            data.pro_no         =   rs.getInt("PRO_NO");
            data.pro_name       =   rs.getString("PRO_NAME");
            
            return data;
        }
    }

    //request
    private class ReqAlwayList implements RowMapper<ProAlwayData> {
        public ProAlwayData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProAlwayData data   =   new ProAlwayData();
            
            return data;
        }
    }

    private class ProDeepData {
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
    private class ProDeepList implements RowMapper<ProDeepData> {
        public ProDeepData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProDeepData data    =   new ProDeepData();
            
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

            //index
            data.rnum           =   rs.getInt("RNUM");
            
            return data;
        }
    }

    private class ProCatDeepList implements RowMapper<ProDeepData> {
        public ProDeepData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProDeepData data    =   new ProDeepData();
            
            data.pro_no         =   rs.getInt("PRO_NO");
            data.pro_name       =   rs.getString("PRO_NAME");
            
            return data;
        }
    }

    //total program
    private class ProDeepTotal implements RowMapper<ProDeepData> {
        public ProDeepData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProDeepData data   =   new ProDeepData();

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
/************************** 접근 허용 체크 - 시작 **************************/
SessionManager sessionManager = new SessionManager(request);
String sessionId = sessionManager.getId();
if(sessionId == null || "".equals(sessionId)) {
	alertParentUrl(out, "관리자 로그인이 필요합니다.", adminLoginUrl);
	if(true) return;
}

String roleId= null;
String[] allowIp = null;
Connection conn = null;
try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	// 접속한 관리자 회원의 권한 롤
	roleId= getRoleId(sqlMapClient, conn, sessionId);
	
	// 관리자 접근 허용된 IP 배열
	allowIp = getAllowIpArrays(sqlMapClient, conn);
} catch (Exception e) {
	sqlMapClient.endTransaction();
	alertBack(out, "트랜잭션 오류가 발생했습니다.");
} finally {
	sqlMapClient.endTransaction();
}

// 권한정보 체크
boolean isAdmin = sessionManager.isRole(roleId);

// 접근허용 IP 체크
String thisIp = request.getRemoteAddr();
boolean isAllowIp = isAllowIp(thisIp, allowIp);

/** Method 및 Referer 정보 **/
String getMethod = parseNull(request.getMethod());
String getReferer = parseNull(request.getHeader("referer"));

if(!isAdmin) {
	alertBack(out, "해당 사용자("+sessionId+")는 접근 권한이 없습니다.");
	if(true) return;
}
if(!isAllowIp) {
	alertBack(out, "해당 IP("+thisIp+")는 접근 권한이 없습니다.");
	if(true) return;
}
/************************** 접근 허용 체크 - 종료 **************************/    

StringBuffer sql    =   null;
String sql_str      =   null;
String where_str    =   null;
String where_sub    =   null;
Object[] setObj		=   null;
List<ProCatCode> proCate        =   null;
List<ProAlwayData> alwayPro     =   null;
List<ProAlwayData> alwayList    =   null;
List<ProAlwayData> alwayTotal   =   null;
List<ProDeepData> deepPro       =   null;
List<ProDeepData> deepList      =   null;
List<ProDeepData> deepTotal     =   null;

Calendar cal = Calendar.getInstance();

String str_year     =   Integer.toString(cal.get(Calendar.YEAR));
String end_year     =   Integer.toString(cal.get(Calendar.YEAR));

String start_date	=   parseNull(request.getParameter("start_date"), "");
if (start_date != null && start_date.length() > 5) {str_year   =   start_date.substring(0, 4);}
else {start_date    =   Integer.toString(cal.get(Calendar.YEAR)) + "-01-01";}

String end_date		=   parseNull(request.getParameter("end_date"), "");
if (end_date != null && end_date.length() > 5) {end_year   =   end_date.substring(0, 4);}
else {end_date    =   Integer.toString(cal.get(Calendar.YEAR)) + "-" + addZero(cal.get(Calendar.MONTH) + 4) + "-" + addZero(cal.get(Calendar.DAY_OF_MONTH));}

String search2		=   parseNull(request.getParameter("search2"), "alway");    //상시, 심화
String search3		=   parseNull(request.getParameter("search3"), "-1");       //프로그램분류
String search4		=   parseNull(request.getParameter("search4"), "-1");       //프로그램명
String search1		=   parseNull(request.getParameter("search1"), "-1");       //아이디, 신청자명
String keyword		=   parseNull(request.getParameter("keyword"), "");         //검색어

Paging paging   =   new Paging();
paging.setPageSize(20);
String pageNo   =   parseNull(request.getParameter("pageNo"), "1");
int totalCount  =   0;
int cnt     =   0;
int num     =   0;

/**************** category 상시 심화 확인 ****************/
if ("deep".equals(search2)) {
    //program category
    sql     =   new StringBuffer();
    sql_str =   " SELECT * FROM ART_PRO_CODE ";
    sql_str +=  " WHERE CODE_TBL = 'ART_PRO_DEEP' AND CODE_COL = 'PRO_CAT_NM' ";
    sql_str +=  " ORDER BY ORDER1 ";
    sql.append(sql_str);
    proCate =   jdbcTemplate.query(sql.toString(), new ProCatList());
    
    //program list
    if (Integer.parseInt(search3) > 0) {
        sql     =   new StringBuffer();
        sql_str =   " SELECT B.ARTCODE_NO AS PRO_CAT_NO, A.* ";
        sql_str +=  " FROM ART_PRO_DEEP A JOIN ART_PRO_CODE B ";
        sql_str +=  " ON A.PRO_CAT = B.CODE_TBL AND A.PRO_CAT_NM = B.CODE_VAL1 ";
        sql_str +=  " WHERE A.REG_DATE BETWEEN ? AND ? ";
        sql_str +=  " AND B.ARTCODE_NO = ? ";
        sql_str +=  " ORDER BY A.REG_DATE DESC ";
        sql.append(sql_str);
        deepPro =   jdbcTemplate.query(sql.toString(), new Object[]{start_date, end_date, search3}, new ProCatDeepList());
    }
    
} else {
    //program category
    sql     =   new StringBuffer();
    sql_str =   " SELECT * FROM ART_PRO_CODE ";
    sql_str +=  " WHERE CODE_TBL = 'ART_PRO_ALWAY' AND CODE_COL = 'PRO_CAT_NM' ";
    sql_str +=  " ORDER BY ORDER1 ";
    sql.append(sql_str);
    proCate =   jdbcTemplate.query(sql.toString(), new ProCatList());
    
    //program list
    if (Integer.parseInt(search3) > 0) {
        sql     =   new StringBuffer();
        sql_str =   " SELECT B.ARTCODE_NO AS PRO_CAT_NO, A.* ";
        sql_str +=  " FROM ART_PRO_ALWAY A JOIN ART_PRO_CODE B ";
        sql_str +=  "   ON B.CODE_TBL = A.PRO_CAT AND B.CODE_VAL1 = A.PRO_CAT_NM ";
        sql_str +=  " WHERE A.PRO_YEAR BETWEEN ? AND ? ";
        sql_str +=  " AND B.ARTCODE_NO = ? ";
        sql_str +=  " ORDER BY A.REG_DATE DESC ";
        sql.append(sql_str);
        alwayPro    =   jdbcTemplate.query(sql.toString(), new Object[]{str_year, end_year, search3}, new ProCatAlwayList());
    }
}
/**************** END category 상시 심화 확인 ****************/

/****** WHERE SETTING *******/
//심화
if ("deep".equals(search2)) {

    where_str   =   " WHERE ";
    where_str   +=  " ARD.REG_DATE BETWEEN '"+start_date+"' AND '"+end_date+"' ";
    /* subquery where state */
    where_sub   =   " AND A.REQ_DATE BETWEEN '"+start_date+"' AND '"+end_date+"' ";
    
    paging.setParams("start_date", start_date);
    paging.setParams("end_date", end_date);
    if (Integer.parseInt(search3) > 0) {
        where_str   +=  " AND APD.PRO_CAT_NM = (SELECT CODE_VAL1 FROM ART_PRO_CODE WHERE ARTCODE_NO = '"+search3+"' ) ";
        paging.setParams("search3", search3);
    }
    if (Integer.parseInt(search4) > 0) {
        where_str   +=  " AND APD.PRO_NO = "+search4+" ";
        paging.setParams("search4", search4);
    }
    if (keyword != null && keyword.length() > 0) {
        if ("req_id".equals(search1)) {
            where_str   +=  " AND ARD.REQ_USER_ID LIKE '%"+keyword+"%' ";
        } else if ("req_mng_nm".equals(search1)) {
            where_str   +=  " AND ARD.REQ_USER_NM LIKE '%"+keyword+"%' ";
        } else {
            where_str   +=  " AND (ARD.REQ_USER_ID LIKE '%"+keyword+"%' OR ARD.REQ_USER_NM LIKE '%"+keyword+"%') ";
        }
        paging.setParams("search1", search1);
        paging.setParams("keyword", keyword);
    }

//상시
} else {

    where_str   =   " WHERE ";
    where_str   +=  " ARA.REQ_DATE BETWEEN '"+start_date+"' AND '"+end_date+"' ";
    /* subquery where state */
    where_sub   =   " AND A.REQ_DATE BETWEEN '"+start_date+"' AND '"+end_date+"' ";

    paging.setParams("start_date", start_date);
    paging.setParams("end_date", end_date);
    if (Integer.parseInt(search3) > 0) {
        where_str   +=  " AND APA.PRO_CAT_NM = (SELECT CODE_VAL1 FROM ART_PRO_CODE WHERE ARTCODE_NO = '"+search3+"' ) ";
        paging.setParams("search3", search3);
    }
    if (Integer.parseInt(search4) > 0) {
        where_str   +=  " AND APA.PRO_NO = "+search4+" ";
        paging.setParams("search4", search4);
    }
    if (keyword != null && keyword.length() > 0) {
        if ("req_id".equals(search1)) {
            where_str   +=  " AND ARA.REQ_SCH_ID LIKE '%"+keyword+"%' ";
        } else if ("req_mng_nm".equals(search1)) {
            where_str   +=  " AND ARA.SCH_MNG_NM LIKE '%"+keyword+"%' ";
        } else {
            where_str   +=  " AND (ARA.REQ_SCH_ID LIKE '%"+keyword+"%' OR ARA.SCH_MNG_NM LIKE '%"+keyword+"%') ";
        }
        paging.setParams("search1", search1);
        paging.setParams("keyword", keyword);
    }

}

/***************** 프로그램 통계 리스트 호출 *****************/

if ("deep".equals(search2)) {
    //페이지 total cnt
    sql     =   new StringBuffer();
    sql_str =   " SELECT COUNT(*) ";
    sql_str +=  " FROM (SELECT * FROM ART_REQ_DEEP ORDER BY REG_DATE DESC) ARD ";
    sql_str +=  " LEFT JOIN ART_PRO_DEEP APD ";
    sql_str +=  " ON APD.PRO_NO = ARD.PRO_NO ";
    sql_str +=  where_str;
    sql.append(sql_str);
    totalCount  =   jdbcTemplate.queryForObject(sql.toString(), Integer.class);

    paging.setPageNo(Integer.parseInt(pageNo));
    paging.setTotalCount(totalCount);

    //심화 프로그램 통계
    sql     =   new StringBuffer();
    sql_str =   " SELECT * FROM ( ";
    sql_str +=  " SELECT ROWNUM AS RNUM, A.* FROM ( ";
    sql_str +=  " SELECT * ";
    sql_str +=  " FROM (SELECT * FROM ART_REQ_DEEP ORDER BY REG_DATE DESC) ARD ";
    sql_str +=  " LEFT JOIN ART_PRO_DEEP APD ";
    sql_str +=  " ON APD.PRO_NO = ARD.PRO_NO ";
    sql_str +=  where_str;
    sql_str +=  " ORDER BY ARD.REQ_NO DESC ";
    sql_str +=  " ) A WHERE ROWNUM <= " + paging.getEndRowNo();
    sql_str +=  " ) WHERE RNUM >= " + paging.getStartRowNo();
    sql.append(sql_str);
    deepList    =   jdbcTemplate.query(sql.toString()/*, new Object[]{str_year, end_year, search3}*/, new ProDeepList());

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
    sql_str +=  "   , (SELECT NVL(SUM(REQ_PER), 0) FROM ART_REQ_DEEP WHERE PRO_NO = APD.PRO_NO) AS REQ_TOTAL_PER ";
    sql_str +=  "   , (SELECT ";
    sql_str +=  "       NVL(COUNT(APPLY_FLAG), 0) ";
    sql_str +=  "       FROM ART_REQ_DEEP WHERE APPLY_FLAG = 'N' AND PRO_NO = APD.PRO_NO) AS REQ_HOLD_CNT ";
    sql_str +=  "   , (SELECT  ";
    sql_str +=  "       NVL(COUNT(APPLY_FLAG), 0) ";
    sql_str +=  "       FROM ART_REQ_DEEP WHERE APPLY_FLAG = 'C' AND PRO_NO = APD.PRO_NO) AS REQ_CANCEL_SELF_CNT ";
    sql_str +=  "   , (SELECT  ";
    sql_str +=  "       NVL(COUNT(APPLY_FLAG), 0) ";
    sql_str +=  "       FROM ART_REQ_DEEP WHERE APPLY_FLAG = 'A' AND PRO_NO = APD.PRO_NO) AS REQ_CANCEL_ADMIN_CNT ";
    sql_str +=  "   , (SELECT  ";
    sql_str +=  "       NVL(COUNT(APPLY_FLAG), 0) ";
    sql_str +=  "       FROM ART_REQ_DEEP WHERE APPLY_FLAG = 'Y' AND PRO_NO = APD.PRO_NO) AS REQ_APPLY_CNT ";
    sql_str +=  " FROM ART_PRO_DEEP APD ";
    sql_str +=  " LEFT JOIN (SELECT * FROM ART_REQ_DEEP ORDER BY REG_DATE DESC) ARD ";
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
    deepTotal  =   jdbcTemplate.query(sql.toString()/*, new Object[]{str_year, end_year, search3}*/, new ProDeepTotal());
    
} else {
    //페이지 total cnt
    sql     =   new StringBuffer();
    sql_str =   " SELECT COUNT(*) FROM ";
    sql_str +=  " (SELECT * FROM ART_REQ_ALWAY ORDER BY REG_DATE DESC) ARA LEFT JOIN ART_REQ_ALWAY_CNT ARAC ";
    sql_str +=  " ON ARA.REQ_NO = ARAC.REQ_NO ";
    sql_str +=  " JOIN ART_PRO_ALWAY APA ";
    sql_str +=  " ON ARAC.PRO_NO = APA.PRO_NO ";
    sql_str +=  where_str;
    sql.append(sql_str);
    totalCount  =   jdbcTemplate.queryForObject(sql.toString(), Integer.class);
    
    paging.setPageNo(Integer.parseInt(pageNo));
    paging.setTotalCount(totalCount);
    
    //상시 프로그램 통계
    sql     =   new StringBuffer();
    sql_str =   " SELECT * FROM ( ";
    sql_str +=  "   SELECT ROWNUM AS RNUM, A.* FROM ( ";
    sql_str +=  "       SELECT ";
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
    sql_str +=  "       FROM (SELECT * FROM ART_REQ_ALWAY ORDER BY REG_DATE DESC) ARA LEFT JOIN ART_REQ_ALWAY_CNT ARAC ";
    sql_str +=  "       ON ARA.REQ_NO = ARAC.REQ_NO ";
    sql_str +=  "       JOIN ART_PRO_ALWAY APA ";
    sql_str +=  "       ON ARAC.PRO_NO = APA.PRO_NO ";
    sql_str +=  where_str;
    sql_str +=  "   ORDER BY ARA.REQ_NO ASC ";
    sql_str +=  " 	) A WHERE ROWNUM <= " + paging.getEndRowNo();
    sql_str +=  " 	 ";
    sql_str +=  " ) WHERE RNUM >= " + paging.getStartRowNo();
    sql.append(sql_str);
    alwayList   =   jdbcTemplate.query(sql.toString()/*, new Object[]{str_year, end_year, search3}*/, new ProAlwayList());
    
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
    sql_str +=  "   , (SELECT NVL(SUM(REQ_PER), 0) FROM ART_REQ_ALWAY_CNT WHERE PRO_NO = APA.PRO_NO) AS REQ_TOTAL_PER ";
    sql_str +=  "   , (SELECT ";
    sql_str +=  "   NVL(COUNT(APPLY_FLAG), 0) ";
    sql_str +=  "   FROM ART_REQ_ALWAY A LEFT JOIN ART_REQ_ALWAY_CNT B ";
    sql_str +=  "   ON A.REQ_NO = B.REQ_NO WHERE A.APPLY_FLAG = 'N' AND B.PRO_NO = APA.PRO_NO "+where_sub+") AS REQ_HOLD_CNT ";
    sql_str +=  "   , (SELECT  ";
    sql_str +=  "   NVL(COUNT(APPLY_FLAG), 0) ";
    sql_str +=  "   FROM ART_REQ_ALWAY A LEFT JOIN ART_REQ_ALWAY_CNT B ";
    sql_str +=  "   ON A.REQ_NO = B.REQ_NO WHERE A.APPLY_FLAG = 'C' AND B.PRO_NO = APA.PRO_NO "+where_sub+") AS REQ_CANCEL_SELF_CNT ";
    sql_str +=  "   , (SELECT ";
    sql_str +=  "   NVL(COUNT(APPLY_FLAG), 0) ";
    sql_str +=  "   FROM ART_REQ_ALWAY A LEFT JOIN ART_REQ_ALWAY_CNT B ";
    sql_str +=  "   ON A.REQ_NO = B.REQ_NO WHERE A.APPLY_FLAG = 'A' AND B.PRO_NO = APA.PRO_NO "+where_sub+") AS REQ_CANCEL_ADMIN_CNT ";
    sql_str +=  "   , (SELECT ";
    sql_str +=  "   NVL(COUNT(APPLY_FLAG), 0) ";
    sql_str +=  "   FROM ART_REQ_ALWAY A LEFT JOIN ART_REQ_ALWAY_CNT B ";
    sql_str +=  "   ON A.REQ_NO = B.REQ_NO WHERE A.APPLY_FLAG = 'Y' AND B.PRO_NO = APA.PRO_NO "+where_sub+") AS REQ_APPLY_CNT ";
    sql_str +=  "    ";
    sql_str +=  "   FROM (SELECT * FROM ART_REQ_ALWAY ORDER BY REG_DATE DESC) ARA LEFT JOIN ART_REQ_ALWAY_CNT ARAC ";
    sql_str +=  "   ON ARA.REQ_NO = ARAC.REQ_NO ";
    sql_str +=  "   JOIN ART_PRO_ALWAY APA ";
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
    alwayTotal  =   jdbcTemplate.query(sql.toString()/*, new Object[]{str_year, end_year, search3}*/, new ProAlwayTotal());
    
}

/**************** END 프로그램 통계 리스트 호출 ****************/
%>

<%/*************************************** 퍼블리싱 파트 ****************************************/%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 승인대기 및 취소 - 심화</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
        <script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
        <script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
        <script type="text/javascript" src="/program/excel/common/js/common.js"></script>
    </head>
<body>

    <div id="right_view">
        <div class="top_view">
            <p class="location"><strong>프로그램 운영 > 통계 관리</strong></p>
        </div>
    </div>
    <!-- S : #content -->
	<div id="content">
		<div class="btn_area">
				<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/alwaysReq.jsp'">승인대기 및 취소 - 상시</button>
				<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/alwaysMng.jsp'">프로그램 관리 - 상시</button>
				<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/deepReq.jsp'">승인대기 및 취소 - 심화</button>
				<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/deepMng.jsp'">프로그램 관리 - 심화</button>
				<button type="button" class="btn medium mako" onclick="location.href='/program/art/admin/programStat.jsp'">통계관리</button>
		</div>
		<div class="searchBox magT20 magB20">
			<!-- 개발작업 진행시 검색폼 옵션 및 항목을 수정하시기 바랍니다.-->
			<form action="/program/art/admin/programStat.jsp" onsubmit="return searchSubmit()" id="searchForm" method="get" class="topbox2">
				<fieldset>
                    <label for="start_date">검색분류</label>
					<input type="text" id="start_date" name="start_date" value="<%=start_date %>" readonly> ~
					<input type="text" id="end_date" name="end_date" value="<%=end_date %>" readonly>
					<select id="search2" name="search2" onchange="">
                        <option value="alway" <%if("alway".equals(search2)){out.println("selected");}%>>상시프로그램</option>
                        <option value="deep" <%if("deep".equals(search2)){out.println("selected");}%>>심화프로그램</option>
					</select>
                    <select id="search3" name="search3" onchange="">
                        <option value="-1">프로그램분류</option>
                    <%for(ProCatCode cate : proCate) {%>
                        <option value="<%=cate.artcode_no %>" <%if(cate.artcode_no == Integer.parseInt(search3)){out.println("selected");}%>><%=cate.code_val1 %></option>
                    <%}%>
					</select>
					<select id="search4" name="search4">
						<option value="-1">프로그램명</option>
                    <%if ("deep".equals(search2) && Integer.parseInt(search3) > 0) {
                        for(ProDeepData pro : deepPro) {%>
                        <option value="<%=pro.pro_no %>" <%if(pro.pro_no == Integer.parseInt(search4)){out.println("selected");}%>><%=pro.pro_name %></option>
                    <%}//END FOR
                    } else if ("alway".equals(search2) && Integer.parseInt(search3) > 0) {
                        for(ProAlwayData pro : alwayPro) {%>
                        <option value="<%=pro.pro_no %>" <%if(pro.pro_no == Integer.parseInt(search4)){out.println("selected");}%>><%=pro.pro_name %></option>
                    <%}//END FOR
                    }%>
					</select>
					<!-- <label for="search1">검색분류</label> -->
					<select id="search1" name="search1">
						<option value="">선택</option>
						<option value="req_id" <%if("req_id".equals(search1)){out.println("selected");}%>>아이디</option>
						<option value="req_mng_nm" <%if("req_mng_nm".equals(search1)){out.println("selected");}%>>신청자명</option>
					</select>
					<!-- <label for="keyword">검색어</label> -->
					<input type="text" id="keyword" name="keyword" value="<%=keyword %>">
					<button type="submit" class="btn small edge mako" >검색하기</button>
				</fieldset>
			</form>
		</div>
                        
        <div class="f_r">
			<button type="button" class="btn small edge darkMblue" onclick="excel();">엑셀 다운로드</button>
		</div>
		<p class="f_l magT10">
			<strong>총 <span><%=totalCount%></span> 건
			</strong> [ Page <%=pageNo %>/<%=paging.getFinalPageNo() %>]
		</p>
		<p class="clearfix"> </p>

		<table class="bbs_list">
			<caption>프로그램 통계 테이블</caption>
			<colgroup>
			</colgroup>
			<thead>
				<tr>
					<th scope="col">순서</th>
					<th scope="col">분류</th>
					<th scope="col">프로그램명</th>
					<th scope="col">정원</th>
					<th scope="col">신청일</th>
					<th scope="col">신청시간</th>
					<th scope="col">신청ID<br>/<br>이름(학교)</th>
					<th scope="col">신청자명</th>
					<th scope="col">신청인원</th>
					<th scope="col">최종상태</th>
				</tr>
			</thead>
			<tbody>
                <%
                //프로그램 리스트
                //심화 일때
                if ("deep".equals(search2)) {
                    if (deepList != null && deepList.size() > 0) {
                    for (ProDeepData pro : deepList) {%>
                        <tr>
                            <td><%=pro.rnum %></td>
                            <td><%=pro.pro_cat_nm %></td>
                            <td><%=pro.pro_name %></td>
                            <td><%=pro.max_per %></td>
                            <td><%=pro.reg_date.substring(0, 10) %></td>
                            <td><%=pro.pro_time %></td>
                            <td><%=pro.req_user_id %><br>/<br><%=pro.req_group %></td>
                            <td><%=pro.req_user_nm %></td>
                            <td><%=pro.req_per %></td>
                            <td><%=applyText(pro.apply_flag) %></td>
                        </tr>
                    <%}/*END FOR*/%>
                    <tr>
                        <td class="bg_grey fb">계</td>
                        <td colspan="9" class="bg_grey">
                            <table class="bbs_list2 magB5">
                                <caption>프로그램 통계 계 테이블</caption>
                                <colgroup>
                                    <col style="width:30%"/>
                                    <col />
                                    <col style="width:25%"/>
                                </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col" class="bl_none">분류</th>
                                    <th scope="col">프로그램명</th>
                                    <th scope="col">신청인원</th>
                                    <th scope="col">승인대기</th>
                                    <th scope="col">직접취소</th>
                                    <th scope="col">관리자취소</th>
                                    <th scope="col">승인</th>
                                </tr>
                            </thead>
                            <tbody>
                            <%for(ProDeepData total: deepTotal){ %>
                            <tr>
                                <td><%=total.pro_cat_nm %></td>
                                <td><%=total.pro_name %></td>
                                <td><%=total.req_total_per %></td>
                                <td><%=total.req_hold_cnt %></td>
                                <td><%=total.req_cancel_self_cnt %></td>
                                <td><%=total.req_cancel_admin_cnt %></td>
                                <td><%=total.req_apply_cnt %></td>
                            </tr>
                            <%}/*END FOR*/ %>
                            </tbody>
                            </table>
                        </td>
                    </tr>
                <%} else {/*END IF*/%>
                    <tr><td colspan="10">등록된 게시물이 없습니다.</td></tr>
                <%}/*END ELSE*/
                //상시 일때
                } else {
                    if (alwayList != null && alwayList.size() > 0) {
                    for(ProAlwayData pro : alwayList) {
                    %>
                    <tr>
                        <td><%=pro.rnum %></td>
                        <td><%=pro.pro_cat_nm %></td>
                        <td><%=pro.pro_name %></td>
                        <td><%=pro.max_per %></td>
                        <td><%=pro.req_date %></td>
                        <td><%=aftText(pro.req_aft_flag) %></td>
                        <td><%=pro.req_sch_id %><br>/<br><%=pro.req_sch_nm %></td>
                        <td><%=pro.sch_mng_nm %></td>
                        <td><%=pro.req_per %></td>
                        <td><%=applyText(pro.apply_flag) %></td>
                    </tr>
                    <%}%>
                    <tr>
                        <td class="bg_grey fb">계</td>
                        <td colspan="9" class="bg_grey">
                            <table class="bbs_list2 magB5">
                                <caption>프로그램 통계 계 테이블</caption>
                                <colgroup>
                                    <col style="width:30%"/>
                                    <col />
                                    <col style="width:25%"/>
                                </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col" class="bl_none">분류</th>
                                    <th scope="col">프로그램명</th>
                                    <th scope="col">신청인원</th>
                                    <th scope="col">승인대기</th>
                                    <th scope="col">직접취소</th>
                                    <th scope="col">관리자취소</th>
                                    <th scope="col">승인</th>
                                </tr>
                            </thead>
                            <tbody>
                            <%for(ProAlwayData total : alwayTotal) {%>
                            <tr>
                                <td><%=total.pro_cat_nm %></td>
                                <td><%=total.pro_name %></td>
                                <td><%=total.req_total_per %></td>
                                <td><%=total.req_hold_cnt %></td>
                                <td><%=total.req_cancel_self_cnt %></td>
                                <td><%=total.req_cancel_admin_cnt %></td>
                                <td><%=total.req_apply_cnt %></td>
                            </tr>
                            <%}/*END FOR*/%>
                            </tbody>
                            </table>
                        </td>
                    </tr>
                    <%}/*END IF*/ else {%>
                    <tr><td colspan="10">등록된 게시물이 없습니다.</td></tr>
                    <%}/*END ELSE*/%>
                <%}/*END ELSE*/%>
			</tbody>
		</table>

		<% if(paging.getTotalCount() > 0) { %>
		<div class="page_area">
			<%=paging.getHtml() %>
		</div>
		<% } %>
                        
	</div>
<!-- //E : #content -->
<script>
    /*************** datePicker ***************/
    $.datepicker.regional['kr'] = {
            closeText: '닫기', // 닫기 버튼 텍스트 변경
            currentText: '오늘', // 오늘 텍스트 변경
            monthNames: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
            monthNamesShort: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
            dayNames: ['월요일','화요일','수요일','목요일','금요일','토요일','일요일'], // 요일 텍스트 설정
            dayNamesShort: ['월','화','수','목','금','토','일'], // 요일 텍스트 축약 설정
            dayNamesMin: ['월','화','수','목','금','토','일'] // 요일 최소 축약 텍스트 설정
        };
    $.datepicker.setDefaults($.datepicker.regional['kr']);

    $(function() {
        //시작일
        $('#start_date').datepicker({
           dateFormat: "yy-mm-dd",             // 날짜의 형식
           changeMonth: true,
           //minDate: 0,                       // 선택할수있는 최소날짜, ( 0 : 오늘 이전 날짜 선택 불가)
           onClose: function( selectedDate ) {
               // 시작일(fromDate) datepicker가 닫힐때
               // 종료일(toDate)의 선택할수있는 최소 날짜(minDate)를 선택한 시작일로 지정
               $("#end_date").datepicker( "option", "minDate", selectedDate );
           }
        });
        //종료일
        $('#end_date').datepicker({
            dateFormat: "yy-mm-dd",
            changeMonth: true,
            onClose: function( selectedDate ) {
                // 종료일(toDate) datepicker가 닫힐때
                // 시작일(fromDate)의 선택할수있는 최대 날짜(maxDate)를 선택한 종료일로 지정
                $("#start_date").datepicker( "option", "maxDate", selectedDate );
            }
       });
    });
    /*************** select change ajax ***************/
    //상시, 심화
    $("#search2").change(function () {
        var search2 =   $(this).val();
        $("#search4").html("<option value=\"-1\">프로그램명</option>");
        proSelAjax(search2, "-1");
    });
    //프로그램 분류
    $("#search3").change(function () {
        var search2 =   $("#search2").val();
        var search3 =   $(this).val();
        if (search3 == "-1") {
            $("#search4").html("<option value=\"-1\">프로그램명</option>");
        }
        proSelAjax(search2, search3);
    });
    //send return ajax
    function proSelAjax (al_deep, pro_cat) {
        
        $.ajax({
			type : "POST",
			url : "/program/art/client/programAlwaysStatAjaxAction.jsp",
			data : {"al_deep": al_deep, "pro_cat": pro_cat},
			dataType : "text",
			async : false,
			success : function(data){                
				if (data.trim() == "f") {
                    alert("오류 입니다.");
                } else if (pro_cat == "-1") {
                    $("#search3").html("<option value=\"-1\">프로그램분류</option>" + data.trim());
                    $("#search4").html("<option value=\"-1\">프로그램명</option>");
                } else {
                    $("#search4").html("<option value=\"-1\">프로그램명</option>" + data.trim());
                }
			},
			error : function(request, status, error) {
				alert("code:"+request.status+"\n"+"message:"+request.responseText.trim()+"\n"+"error:"+error);
			}
		});
    }
    /*************** searchSubmit ***************/
    //submit chk function
    function searchSubmit () {
        return true;
    }

    /** call the excel download **/
    function excel() {
        $("#searchForm").attr("method", "post");
        $("#searchForm").attr("action", "/program/art/admin/programExcel.jsp");
        $("#searchForm").submit();
        $("#searchForm").attr("action", "/program/art/admin/programStat.jsp");
    }
</script>
</body>
</html>
