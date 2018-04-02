<%@page import="com.ibatis.sqlmap.engine.mapping.statement.ExecuteListener"%>
<%@page import="org.json.simple.JSONObject"%>
<%
/**
*	PURPOSE	:	해봄 / 상시 프로그램 신청 날짜와 시간 확인 action ajax jsp
*	CREATE	:	20180227_tue	JI
*	MODIFY	:	....
*/
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/transfer/admin/crypto.jsp" %>

<%

response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

SessionManager sessionManager   =   new SessionManager(request);

if (sessionManager.getName().trim().equals("") || sessionManager.getId().trim().equals("") || sessionManager.getName().trim().length() < 1 || sessionManager.getId().trim().length() < 1) {
	out.println("s_f");    //session 없음
	return;
}

Connection conn =   null;
PreparedStatement pstmt = null;
ResultSet rs    =   null;
StringBuffer sql=   null;
String sql_str  =   null;

String req_date     =	parseNull(request.getParameter("req_date"));
String aft_flag     =	parseNull(request.getParameter("aft_flag"));
String reg_id       =   sessionManager.getId();
String reg_name     =   sessionManager.getName();

String use_flag     =   null;
String return_str   =   null;

try {
    sqlMapClient.startTransaction();
    conn    =   sqlMapClient.getCurrentConnection();
    
    //schedule sql chk
    sql     =   new StringBuffer();
    sql_str =   " SELECT ";
    sql_str +=  " CASE ";
    sql_str +=  " WHEN (SELECT NVL(COUNT(*), 0) FROM ART_REQ_ALWAY WHERE APPLY_FLAG IN ('Y', 'N') AND REQ_SCH_ID = ? AND REQ_DATE = ?) > 0 THEN 'N' ";
    sql_str +=  " WHEN (SELECT NVL(COUNT(*), 0) FROM ART_REQ_ALWAY WHERE APPLY_FLAG IN ('Y', 'N') AND REQ_DATE = ? GROUP BY REQ_SCH_ID) > 1 THEN 'N' ";
    sql_str +=  " WHEN NVL((SELECT NVL(SUM(MAX_PER), 0) FROM ART_PRO_ALWAY WHERE SHOW_FLAG = 'Y' AND DEL_FLAG != 'Y') ";
    sql_str +=  "     - (SELECT NVL(SUM(REQ_CNT), 0) FROM ART_REQ_ALWAY WHERE APPLY_FLAG = 'Y' AND REQ_DATE = ?), 0) <= 0 THEN 'N' ";
    sql_str +=  " ELSE 'Y' ";
    sql_str +=  " END AS USE_FLAG ";
    sql_str +=  " FROM DUAL ";
    sql.append(sql_str);
    pstmt	=	conn.prepareStatement(sql.toString());
    pstmt.setString(1, reg_id);
    pstmt.setString(2, req_date);
    pstmt.setString(3, req_date);
    pstmt.setString(4, req_date);
    rs		=	pstmt.executeQuery();

    if (rs.next()) {
        use_flag    =   rs.getString("USE_FLAG");
        if ("Y".equals(use_flag)) {
            return_str  =   "1";
        } else {
            return_str  =   "f";
        }

    } else {
        return_str      =   "f";
    }
    
} catch (Exception e) {
    e.printStackTrace();
    alertBack(out, "처리중 오류가 발생하였습니다. "+e.getMessage()); 
} finally {

    if (rs != null) try { rs.close(); } catch (SQLException se) {}
    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
    if (conn != null) try { conn.close(); } catch (SQLException se) {}
    sqlMapClient.endTransaction();

    out.println(return_str);
}
%>
