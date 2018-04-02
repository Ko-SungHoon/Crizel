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
String user_id 			= parseNull(request.getParameter("user_id"));
String user_phone 		= "";
String dept_tel 		= "";
String msg 				= "";
String school_name  	= "";
String reserve_type 	= "";
String reserve_type2	= "";
String refund_price		= parseNull(request.getParameter("refund_price"));
String refund_account	= "";

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	//환불완료날짜 입력
	key = 0;
	sql = new StringBuffer();
	sql.append("UPDATE RESERVE_USER SET RESERVE_REFUND = 'Y'		");
	sql.append("WHERE USER_ID = ?  									");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, user_id);
	result = pstmt.executeUpdate();	
	if(result>0){
		sqlMapClient.commitTransaction();
	}
	if(pstmt!=null) pstmt.close();
	
	//문자전송을 위한 정보찾기
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT RU.USER_PHONE, RS.ACCOUNT, RU.TOTAL_PRICE, RU.USER_NAME, RS.SCHOOL_NAME, RU.RESERVE_TYPE, RU.REFUND_ACCOUNT, RS.DEPT_TEL  ");
	sql.append("FROM RESERVE_USER RU LEFT JOIN RESERVE_SCHOOL RS ON RU.SCHOOL_ID = RS.SCHOOL_ID  ");
	sql.append("WHERE USER_ID = ?  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, user_id);
	rs = pstmt.executeQuery();	
	if(rs.next()){
		user_phone 		= parseNull(rs.getString("USER_PHONE"));
		dept_tel 		= parseNull(rs.getString("DEPT_TEL"));
		refund_account 	= parseNull(rs.getString("REFUND_ACCOUNT")); 
		school_name		= parseNull(rs.getString("SCHOOL_NAME")); 
	}
	if(pstmt!=null) pstmt.close();
	
	//문자전송을 위한 정보찾기2
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT *																	\n");
	sql.append("FROM RESERVE_ROOM															\n");
	sql.append("WHERE ROOM_ID = (SELECT MAX(ROOM_ID) FROM RESERVE_USER WHERE USER_ID = ?)	\n");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, user_id);
	rs = pstmt.executeQuery();	
	if(rs.next()){
		reserve_type = parseNull(rs.getString("RESERVE_TYPE"));
		reserve_type2 = parseNull(rs.getString("RESERVE_TYPE2"));
	}
	if(pstmt!=null) pstmt.close();
	
	
	if("".equals(reserve_type2)){
		msg += "[" + school_name + " " + reserve_type + " 예약취소]" + refund_account + "로 " + refund_price + "원 환불예정입니다.";
	}else{
		msg += "[" + school_name + " " + reserve_type2 + " 예약취소]" + refund_account + "로 " + refund_price + "원 환불예정입니다.";
	}
	 
	key = 0;
	sql = new StringBuffer();
	sql.append("INSERT INTO SC_TRAN(TR_NUM ,TR_SENDDATE , TR_SENDSTAT ,TR_MSGTYPE ,TR_PHONE ,TR_CALLBACK , TR_MSG)  ");
	sql.append("VALUES (SC_TRAN_SEQ.NEXTVAL, SYSDATE, '0', '0', ?, ?, ?)  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, user_phone);
	pstmt.setString(++key, "055"+dept_tel);
	pstmt.setString(++key, msg);
	result = pstmt.executeUpdate();
	if(pstmt!=null) pstmt.close();
	
	
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
	if(result>0){
		out.println("<script type=\"text/javascript\">");
		out.println("alert('정상적으로 처리되었습니다.');");
		out.println("location.replace('/index.gne?menuCd=DOM_000001201007002002&user_id="+ user_id +"');");
		//out.println("location.replace('/index.gne?menuCd=DOM_000000106007002001&user_id="+ user_id +"');");		//테스트서버
		out.println("</script>");
	}
}

%>