<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 학교등록</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />


<script>
</script>
</head>
<body>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

//강당 (시 지역)
String price_1_0 = parseNull(request.getParameter("price_1_0"));
String price_2_1 = parseNull(request.getParameter("price_2_1"));
String price_3_2 = parseNull(request.getParameter("price_3_2"));
//교실(시 지역)
String price_1_3 = parseNull(request.getParameter("price_1_3"));
String price_2_4 = parseNull(request.getParameter("price_2_4"));
String price_3_5 = parseNull(request.getParameter("price_3_5"));
//운동장(시 지역)
String price_1_6 = parseNull(request.getParameter("price_1_6"));
String price_2_7 = parseNull(request.getParameter("price_2_7"));
String price_3_8 = parseNull(request.getParameter("price_3_8"));

//강당
String price_1_9 = parseNull(request.getParameter("price_1_9"));
String price_2_10 = parseNull(request.getParameter("price_2_10"));
String price_3_11 = parseNull(request.getParameter("price_3_11"));
//교실
String price_1_12 = parseNull(request.getParameter("price_1_12"));
String price_2_13 = parseNull(request.getParameter("price_2_13"));
String price_3_14 = parseNull(request.getParameter("price_3_14"));
//운동장
String price_1_15 = parseNull(request.getParameter("price_1_15"));
String price_2_16 = parseNull(request.getParameter("price_2_16"));
String price_3_17 = parseNull(request.getParameter("price_3_17"));


int num = 0;
int key = 0;
int result = 0;


try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	key = 0;
	sql = new StringBuffer();
	sql.append("UPDATE RESERVE_PRICE SET PRICE_1 = ?, PRICE_2 = ?, PRICE_3 = ? WHERE AREA_TYPE = 'N' AND RESERVE_TYPE = '강당' ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, price_1_0);
	pstmt.setString(++key, price_2_1);
	pstmt.setString(++key, price_3_2);
	result = pstmt.executeUpdate();
	
	key = 0;
	sql = new StringBuffer();
	sql.append("UPDATE RESERVE_PRICE SET PRICE_1 = ?, PRICE_2 = ?, PRICE_3 = ? WHERE AREA_TYPE = 'N' AND RESERVE_TYPE = '교실' ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, price_1_3);
	pstmt.setString(++key, price_2_4);
	pstmt.setString(++key, price_3_5);
	result = pstmt.executeUpdate();
	
	key = 0;
	sql = new StringBuffer();
	sql.append("UPDATE RESERVE_PRICE SET PRICE_1 = ?, PRICE_2 = ?, PRICE_3 = ? WHERE AREA_TYPE = 'N' AND RESERVE_TYPE = '운동장' ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, price_1_6);
	pstmt.setString(++key, price_2_7);
	pstmt.setString(++key, price_3_8);
	result = pstmt.executeUpdate();
	
	key = 0;
	sql = new StringBuffer();
	sql.append("UPDATE RESERVE_PRICE SET PRICE_1 = ?, PRICE_2 = ?, PRICE_3 = ? WHERE AREA_TYPE = 'Y' AND RESERVE_TYPE = '강당' ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, price_1_9);
	pstmt.setString(++key, price_2_10);
	pstmt.setString(++key, price_3_11);
	result = pstmt.executeUpdate();
	
	key = 0;
	sql = new StringBuffer();
	sql.append("UPDATE RESERVE_PRICE SET PRICE_1 = ?, PRICE_2 = ?, PRICE_3 = ? WHERE AREA_TYPE = 'Y' AND RESERVE_TYPE = '교실' ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, price_1_12);
	pstmt.setString(++key, price_2_13);
	pstmt.setString(++key, price_3_14);
	result = pstmt.executeUpdate();
	
	key = 0;
	sql = new StringBuffer();
	sql.append("UPDATE RESERVE_PRICE SET PRICE_1 = ?, PRICE_2 = ?, PRICE_3 = ? WHERE AREA_TYPE = 'Y' AND RESERVE_TYPE = '운동장' ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, price_1_15);
	pstmt.setString(++key, price_2_16);
	pstmt.setString(++key, price_3_17);
	result = pstmt.executeUpdate();
	
	if(result > 0){
		sqlMapClient.commitTransaction();
	}
	
	
	
} catch (Exception e) {
	%>
	<%=e.toString() %>
	<%
	e.printStackTrace();
	sqlMapClient.endTransaction();
	//alertBack(out, "처리중 오류가 발생하였습니다."); 
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
	
	if(result > 0){
		out.println("<script type=\"text/javascript\">");
		out.println("alert('정상적으로 처리되었습니다.');");
		out.println("location.replace('/program/school_reserve/admin/priceForm.jsp');");
		out.println("</script>");
	}
}

%>
</body>
</html>
