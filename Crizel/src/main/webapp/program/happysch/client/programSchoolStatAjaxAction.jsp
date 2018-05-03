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

<%!
    
    private String addZero (int num) {
        String ret_str  =   null;
        if (num < 10) {ret_str  =   "0" + Integer.toString(num);}
        else {ret_str   =   Integer.toString(num);}
        return ret_str;
    }
    
%>
    
<%

response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

SessionManager sessionManager   =   new SessionManager(request);
/*
if (sessionManager.getName().trim().equals("") || sessionManager.getId().trim().equals("") || sessionManager.getName().trim().length() < 1 || sessionManager.getId().trim().length() < 1) {
	out.println("s_f");    //session 없음
	return;
}
*/

Connection conn =   null;
PreparedStatement pstmt = null;
ResultSet rs    =   null;
StringBuffer sql=   null;
String sql_str  =   null;

List<Map<String, Object>> retList   =   null;

String al_deep  =   parseNull(request.getParameter("al_deep"), "sch");
String pro_cat  =   parseNull(request.getParameter("pro_cat"), "-1");

String return_str   =   "";

Calendar cal = Calendar.getInstance();

String str_year     =   Integer.toString(cal.get(Calendar.YEAR));

try {
    
    sqlMapClient.startTransaction();
    conn    =   sqlMapClient.getCurrentConnection();
    
    if (Integer.parseInt(pro_cat) < 0) {
    
        sql     =   new StringBuffer();
        sql_str =   " SELECT * FROM HAPPY_PRO_CODE ";
        sql_str +=  " WHERE CODE_TBL = 'HAPPY_PRO_"+ al_deep.toUpperCase() +"' AND CODE_COL = 'PRO_CAT_NM' ";
        sql_str +=  " ORDER BY ORDER1 ";
        sql.append(sql_str);
        pstmt	=	conn.prepareStatement(sql.toString());
        rs		=	pstmt.executeQuery();
        retList =   getResultMapRows(rs);
        for (int i = 0; i < retList.size(); i++) {
            Map<String, Object> map	=	retList.get(i);
            return_str  +=  "<option value=" + parseNull((String)map.get("ARTCODE_NO")) + " >"+ parseNull((String)map.get("CODE_VAL1")) +"</option>";
        }
    
    } else {
        
        sql     =   new StringBuffer();
        sql_str =   " SELECT B.ARTCODE_NO AS PRO_CAT_NO, A.* ";
        sql_str +=  " FROM HAPPY_PRO_"+ al_deep.toUpperCase() +" A JOIN HAPPY_PRO_CODE B ";
        sql_str +=  " ON A.PRO_CAT = B.CODE_TBL AND A.PRO_CAT_NM = B.CODE_VAL1 ";
        if ("alway".equals(al_deep)) {
            sql_str +=  " WHERE A.PRO_YEAR BETWEEN "+str_year+" AND "+str_year+" ";
        } else {
            sql_str +=  " WHERE A.REG_DATE BETWEEN '"+ str_year +"-01-01' AND '"+ str_year +"-12-31' ";
        }
        sql_str +=  " AND B.ARTCODE_NO = ? ";
        sql_str +=  " ORDER BY A.REG_DATE DESC ";
        sql.append(sql_str);
        pstmt	=	conn.prepareStatement(sql.toString());
        pstmt.setString(1, pro_cat);
        rs		=	pstmt.executeQuery();
        retList =   getResultMapRows(rs);
        for (int i = 0; i < retList.size(); i++) {
            Map<String, Object> map	=	retList.get(i);
            return_str  +=  "<option value=\""+ parseNull((String)map.get("PRO_NO")) +"\" >"+ parseNull((String)map.get("PRO_NAME")) +"</option>";
        }
        
    }
    
    
} catch (Exception e) {
    e.printStackTrace();
    alertBack(out, "처리중 오류가 발생하였습니다. "+e.getMessage());
    
    return_str  =   "f";
} finally {

    if (rs != null) try { rs.close(); } catch (SQLException se) {}
    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
    if (conn != null) try { conn.close(); } catch (SQLException se) {}
    sqlMapClient.endTransaction();

    out.println(return_str);
}
%>