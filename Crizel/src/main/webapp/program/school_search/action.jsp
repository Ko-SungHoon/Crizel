<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<script type='text/javascript' src='/js/jquery.js'></script>
<%
SessionManager sm = new SessionManager(request);

response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");


Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

String command = parseNull(request.getParameter("command"));
String sid = parseNull(request.getParameter("sid"));
String code =  parseNull(request.getParameter("code"));
String title =  parseNull(request.getParameter("title"));
String addr =  parseNull(request.getParameter("addr"));
String url =  parseNull(request.getParameter("url"));
String tel = parseNull(request.getParameter("tel"));
String fax = parseNull(request.getParameter("fax"));
String area_type = parseNull(request.getParameter("area_type"));
String coedu = parseNull(request.getParameter("coedu"));
String cate1 =  parseNull(request.getParameter("cate1"));
String cate2 =  parseNull(request.getParameter("cate2"));
String post =  parseNull(request.getParameter("post")); 

int result = 0;
int key = 0;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	if("insert".equals(command)){
		sql=new StringBuffer();
		sql.append("SELECT NVL(MAX(SID)+1, 1) CNT FROM SCHOOL_SEARCH");
		pstmt = conn.prepareStatement(sql.toString());
		rs = pstmt.executeQuery();
		if(rs.next()){
			sid = rs.getString("CNT");
		}
		
		sql = new StringBuffer();
		sql.append("INSERT INTO SCHOOL_SEARCH(SID, CODE, TITLE, ADDR, URL, TEL, FAX, AREA_TYPE, COEDU, CATE1, CATE2, POST)   \n");
		sql.append("VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)   \n");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(++key, sid);
		pstmt.setString(++key, code);
		pstmt.setString(++key, title);
		pstmt.setString(++key, addr);
		pstmt.setString(++key, url);
		pstmt.setString(++key, tel);
		pstmt.setString(++key, fax);
		pstmt.setString(++key, area_type);
		pstmt.setString(++key, coedu);
		pstmt.setString(++key, cate1);
		pstmt.setString(++key, cate2);
		pstmt.setString(++key, post);
		result = pstmt.executeUpdate();
		if(result > 0){
			sqlMapClient.commitTransaction();
			out.println("<script type=\"text/javascript\">");
			out.println("alert('정상적으로 처리 되었습니다.');");
			out.println("location.replace('list.jsp');");
			out.println("</script>");
		}
		
	}else if("update".equals(command)){
		sql = new StringBuffer();
		sql.append("UPDATE SCHOOL_SEARCH SET CODE = ?, TITLE = ?, ADDR = ?, URL = ?, TEL=?, FAX=?, AREA_TYPE=?, COEDU=?, CATE1=?, CATE2=?, POST = ?, MODIFY_DATE = SYSDATE   \n");
		sql.append("WHERE SID=?    \n");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(++key, code);
		pstmt.setString(++key, title);
		pstmt.setString(++key, addr);
		pstmt.setString(++key, url);
		pstmt.setString(++key, tel);
		pstmt.setString(++key, fax);
		pstmt.setString(++key, area_type);
		pstmt.setString(++key, coedu);
		pstmt.setString(++key, cate1);
		pstmt.setString(++key, cate2);
		pstmt.setString(++key, post);
		pstmt.setString(++key, sid);
		result = pstmt.executeUpdate();
		if(result > 0){
			sqlMapClient.commitTransaction();
			out.println("<script type=\"text/javascript\">");
			out.println("alert('정상적으로 처리 되었습니다.');");
			out.println("location.replace('list.jsp');");
			out.println("</script>");
		}
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
%>