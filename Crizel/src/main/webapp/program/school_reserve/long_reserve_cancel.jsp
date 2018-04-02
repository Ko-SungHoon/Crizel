<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

int key = 0;
int result = 0;
int result2 = 0;

String user_id = parseNull(request.getParameter("user_id"));
int price = 0;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	
	//장기예약 취소 시 내역이 모두 삭제
	key = 0;
	sql = new StringBuffer();
	sql.append("DELETE FROM RESERVE_USER WHERE USER_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, user_id);
	result = pstmt.executeUpdate();
	if(result>0){
		result2++;
	}
	if(pstmt!=null) pstmt.close();

	key = 0;
	sql = new StringBuffer();
	sql.append("DELETE FROM RESERVE_USE  ");			
	sql.append("WHERE USER_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, user_id);
	result = pstmt.executeUpdate();
	if(result>0){
		result2++;
	}
	if(pstmt!=null)pstmt.close();
	
} catch (Exception e) {
	out.println(e.toString());
	e.printStackTrace();
	sqlMapClient.endTransaction();
	//alertBack(out, "처리중 오류가 발생하였습니다.");
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
	if(result2>0){
		out.println("<script type=\"text/javascript\">");
		out.println("alert('정상적으로 처리되었습니다.');");
		out.println("location.replace('/index.gne?menuCd=DOM_000001201007005002&user_id="+ user_id +"');");
		//out.println("location.replace('/index.gne?menuCd=DOM_000000106007005002&user_id="+ user_id +"');");		//테스트서버
		out.println("</script>");
	}
}

%>