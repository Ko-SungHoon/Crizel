<%@page import="com.ibatis.sqlmap.engine.mapping.statement.ExecuteListener"%>
<%@page import="org.json.simple.JSONObject"%>
<%
/**
*	PURPOSE	:	상시 프로그램 오전/오후 목록
*	CREATE	:	20180531 thur	KO
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

Connection conn =   null;
PreparedStatement pstmt = null;
ResultSet rs    =   null;
StringBuffer sql=   null;
String sql_str  =   null;

String req_date     =	parseNull(request.getParameter("req_date"));
String aft_flag     =	parseNull(request.getParameter("aft_flag"));

String html 		= 	"";

try {
    sqlMapClient.startTransaction();
    conn    =   sqlMapClient.getCurrentConnection();
    sql_str = new String();
    sql_str += "SELECT 																									";
    sql_str += "  A.*  																									";
    sql_str += "  , (SELECT COUNT(*)  																					";
    sql_str += "     FROM ART_REQ_ALWAY B LEFT JOIN ART_REQ_ALWAY_CNT C ON B.REQ_NO = C.REQ_NO  						";
    sql_str += "     WHERE C.PRO_NO = A.PRO_NO AND B.REQ_DATE = ? AND B.APPLY_FLAG IN ('Y', 'N')) AS CNT				";
    sql_str += "FROM ART_PRO_ALWAY A 																					";
    sql_str += "WHERE PRO_TYPE = 'NEW' AND AFT_FLAG = ?  																";
    sql_str += "ORDER BY PRO_NAME 																						";
    pstmt	=	conn.prepareStatement(sql_str);
    pstmt.setString(1, req_date);
    pstmt.setString(2, aft_flag);
    rs = pstmt.executeQuery();
    
   	while(rs.next()){
    	html += "<li>";
    	if(rs.getInt("CNT")>=3){
    		html += "<span title='마감'>";
        	html += rs.getString("PRO_NAME");
        	html += "</span>";
    	}else{
    		html += "<a href=\"javascript:proNoSelect('"+rs.getString("PRO_NO")+"', '"+rs.getString("AFT_FLAG")+"');\">";
        	html += rs.getString("PRO_NAME");
        	html += "</a>";
    	}
    	
    	html += "</li>";
    }
    out.println(html);
    
} catch (Exception e) {
	if(pstmt != null){pstmt.close();}
	if(rs != null){rs.close();}
	if(conn != null){conn.close();}
	sqlMapClient.endTransaction();
    e.printStackTrace();
    alertBack(out, "처리중 오류가 발생하였습니다. "+e.getMessage()); 
} finally {
    if (rs != null) try { rs.close(); } catch (SQLException se) {}
    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
    if (conn != null) try { conn.close(); } catch (SQLException se) {}
    sqlMapClient.endTransaction();
}
%>
