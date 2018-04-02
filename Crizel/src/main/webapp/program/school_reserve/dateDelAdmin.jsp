<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>

<%
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

String user_id = parseNull(request.getParameter("user_id"));
String reserve_date_del[] = request.getParameterValues("reserve_date_del");
String returnVal = "";
int total_price = 0;
int new_total_price = 0;
int oriCnt = 0;								//원래 있던 날짜 일수
int chaCnt = reserve_date_del.length;		//변경할 날짜 일수


int key = 0;
int result = 0;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT COUNT(*) CNT FROM RESERVE_TIME  ");			//원래있던 날짜 일수 구하기
	sql.append("WHERE USER_ID = ? GROUP BY RESERVE_DATE ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, user_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		oriCnt = rs.getInt("CNT");
	}
	if(pstmt!=null) pstmt.close();
	
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT TOTAL_PRICE FROM RESERVE_USER  ");			//가격 구하기
	sql.append("WHERE USER_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, user_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		total_price = rs.getInt("TOTAL_PRICE");
	}
	if(pstmt!=null) pstmt.close();
	
	new_total_price = total_price - (int)(total_price * ((float)chaCnt/oriCnt));
	
	
	
	sql = new StringBuffer();
	sql.append("UPDATE RESERVE_DATE_DEL SET APPROVAL = 'Y' ");		//날짜변경 승인
	sql.append("WHERE USER_ID = ? AND RESERVE_DATE = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	for(String ob : reserve_date_del){
		key = 0;
		pstmt.setString(++key, user_id);
		pstmt.setString(++key, ob);
		pstmt.addBatch();
		pstmt.clearParameters();
	}
	
	int[] count = pstmt.executeBatch();
	result = count.length;
	
	if(result > 0){
		sql = new StringBuffer();
		sql.append("UPDATE RESERVE_TIME SET TIME_USE = 'N', USER_ID = ''  ");
		sql.append("WHERE USER_ID = ? AND RESERVE_DATE = ? ");
		pstmt = conn.prepareStatement(sql.toString());
		for(String ob : reserve_date_del){
			key = 0;
			pstmt.setString(++key, user_id);
			pstmt.setString(++key, ob);
			pstmt.addBatch();
			pstmt.clearParameters();
		}
		count = pstmt.executeBatch();
		result = count.length;
		
		
		sql = new StringBuffer();
		sql.append("UPDATE RESERVE_USER SET TOTAL_PRICE = ? ");			//금액변경
		sql.append("WHERE USER_ID = ? ");
		pstmt = conn.prepareStatement(sql.toString());
		key = 0;
		pstmt.setInt(++key, new_total_price);
		pstmt.setString(++key, user_id);
		result = pstmt.executeUpdate();
		pstmt.clearParameters();
		
		if(result > 0){
			sqlMapClient.commitTransaction();
		}
		
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
		out.println("location.replace('/index.gne?menuCd=DOM_000001201007002002&user_id="+user_id+"');");
		out.println("</script>");
	}
	
}
%>