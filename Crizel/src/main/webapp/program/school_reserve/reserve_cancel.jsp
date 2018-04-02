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
String refund_account 	= parseNull(request.getParameter("refund_account"));
String msg 				= "";
String msg2 			= "";
String school_name 		= "";
String charge_phone 	= "";
String user_name 		= "";
String user_phone 		= "";
String dept_tel 		= "";

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	key = 0;
	//예약취소
	sql = new StringBuffer();
	sql.append("UPDATE RESERVE_USER SET RESERVE_APPROVAL = 'F', REFUND_ACCOUNT = ?, CANCEL_DATE = SYSDATE ");
	sql.append("WHERE USER_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, refund_account);
	pstmt.setString(++key, user_id);
	result = pstmt.executeUpdate();
	if(result > 0){
		sql = new StringBuffer();
		sql.append("DELETE FROM RESERVE_USE  ");			
		sql.append("WHERE USER_ID = ? ");
		pstmt = conn.prepareStatement(sql.toString());
		key = 0;
		pstmt.setString(++key, user_id);
		result = pstmt.executeUpdate();
	}
	if(pstmt!=null) pstmt.close();
	
	//사용자정보 찾기
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_USER WHERE USER_ID = ?  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, user_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		user_name = rs.getString("USER_NAME");
		user_phone = rs.getString("USER_PHONE");
	}
	if(pstmt!=null) pstmt.close();
	
	//학교정보 찾기
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_SCHOOL WHERE SCHOOL_ID = (SELECT SCHOOL_ID FROM RESERVE_USER WHERE USER_ID = ?)  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, user_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		school_name = rs.getString("SCHOOL_NAME");
		charge_phone = rs.getString("CHARGE_PHONE");
		dept_tel = rs.getString("DEPT_TEL");
	}
	if(pstmt!=null) pstmt.close();
	
	//msg = school_name + " 입니다. " + user_name + "님의 시설예약이 취소되었습니다." ;
	
	/* if("".equals(refund_account)){
		msg2 = user_name + " 님이 시설예약을 취소하였습니다.";
	}else{
		msg2 = user_name + " 님이 시설예약을 취소하고 환불을 요청하였습니다.";
	} */
	msg2 = "예약취소 신청이 접수되었습니다. 홈페이지에서 확인바랍니다.";
	
	/* //SMS 전송 - 사용자
	key = 0;
	sql = new StringBuffer();
	sql.append("INSERT INTO SC_TRAN(TR_NUM ,TR_SENDDATE , TR_SENDSTAT ,TR_MSGTYPE ,TR_PHONE ,TR_CALLBACK , TR_MSG)  ");
	sql.append("VALUES (SC_TRAN_SEQ.NEXTVAL, SYSDATE, '0', '0', ?, ?, ?)  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, user_phone);
	pstmt.setString(++key, "055"+dept_tel);
	pstmt.setString(++key, msg);
	result = pstmt.executeUpdate();
	if(pstmt!=null) pstmt.close(); */
	
	//SMS 전송
	key = 0;
	sql = new StringBuffer();
	sql.append("INSERT INTO SC_TRAN(TR_NUM ,TR_SENDDATE , TR_SENDSTAT ,TR_MSGTYPE ,TR_PHONE ,TR_CALLBACK , TR_MSG)  ");
	sql.append("VALUES (SC_TRAN_SEQ.NEXTVAL, SYSDATE, '0', '0', ?, ?, ?)  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, charge_phone);
	pstmt.setString(++key, "055"+dept_tel);
	pstmt.setString(++key, msg2);
	result = pstmt.executeUpdate();
	if(pstmt!=null) pstmt.close();
	
	
	
} catch (Exception e) {
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
		out.println("location.replace('/index.gne?menuCd=DOM_000001201003002000');");
		//out.println("location.replace('/index.gne?menuCd=DOM_000000106003002000');");		//테스트서버
		out.println("</script>");
	}
}

%>