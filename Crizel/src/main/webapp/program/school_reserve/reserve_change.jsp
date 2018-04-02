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

List<Map<String, Object>> dataList = null;

String reserve_change 		= parseNull(request.getParameter("reserve_change"));
String reserve_approval 	= parseNull(request.getParameter("reserve_approval"));
String user_id 				= parseNull(request.getParameter("user_id"));
String reserve_cancel 		= parseNull(request.getParameter("reserve_cancel"));
String user_phone 			= "";
String account 				= "";
String total_price 			= "";
String user_name 			= "";
String school_name 			= "";
String reserve_type 		= "";
String reserve_type2 		= "";
String refund_account 		= "";
String dept_tel 			= "";
String msg 					= "";
String msg2 				= "";
String add_price 			= parseNull(request.getParameter("add_price"),"0");
String add_comment 			= parseNull(request.getParameter("add_comment"));
String long_check 			= parseNull(request.getParameter("long_check"));
String refund_price 		= parseNull(request.getParameter("refund_price"));
int price = 0;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	
	//예약금액 구하기
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_USER WHERE USER_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, user_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		total_price = rs.getString("TOTAL_PRICE");
	}
	if(pstmt!=null) pstmt.close();
	
	
	
	price = Integer.parseInt(total_price) + Integer.parseInt(add_price);
	total_price = Integer.toString(price);
	
	/* if("F".equals(reserve_approval) || "D".equals(reserve_approval)){
		total_price = "0";
	} */
	
	//승인상태 변경
	key = 0;
	sql = new StringBuffer();
	sql.append("UPDATE RESERVE_USER SET RESERVE_APPROVAL = ?, RESERVE_CANCEL = ?, TOTAL_PRICE = ?, APPROVAL_DATE = SYSDATE, ADD_PRICE = ?, ADD_COMMENT = ? ");
	if("F".equals(reserve_approval) || "D".equals(reserve_approval) || "E".equals(reserve_approval)){ 	//예약취소일 경우 취소날짜 입력
		sql.append(", CANCEL_DATE = SYSDATE, ADMIN_CANCEL = 'Y'  ");
	}
	sql.append("WHERE USER_ID = ?  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, reserve_approval);
	pstmt.setString(++key, reserve_cancel);
	pstmt.setString(++key, total_price);
	pstmt.setString(++key, add_price);
	pstmt.setString(++key, add_comment);
	pstmt.setString(++key, user_id);
	result = pstmt.executeUpdate();	
	if(result>0){
		sqlMapClient.commitTransaction();
	}
	if(pstmt!=null) pstmt.close();
	
	//예약취소, 불가일 경우 사용하던 시간을 지움
	if("F".equals(reserve_approval) || "D".equals(reserve_approval) || "E".equals(reserve_approval)){
		sql = new StringBuffer();
		sql.append("DELETE FROM RESERVE_USE  ");			
		sql.append("WHERE USER_ID = ? ");
		pstmt = conn.prepareStatement(sql.toString());
		key = 0;
		pstmt.setString(++key, user_id);
		result = pstmt.executeUpdate();
		if(pstmt!=null) pstmt.close();
	}
	
	
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
		account = parseNull(rs.getString("ACCOUNT"));
		user_phone = parseNull(rs.getString("USER_PHONE"));
		total_price = parseNull(rs.getString("TOTAL_PRICE"));
		user_name = parseNull(rs.getString("USER_NAME"));
		school_name = parseNull(rs.getString("SCHOOL_NAME"));
		refund_account = parseNull(rs.getString("REFUND_ACCOUNT"));
		dept_tel = parseNull(rs.getString("DEPT_TEL"));
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
	
	
	
	if("B".equals(reserve_approval)){
		if("".equals(reserve_type2)){
			msg = "[" + school_name + " " + reserve_type + " 예약] " + account + " , 사용료 " + total_price + "원 입금바랍니다.";
		}else{
			msg = "[" + school_name + " " + reserve_type2 + " 예약] " + account + " , 사용료 " + total_price + "원 입금바랍니다.";
		}
	}else if("C".equals(reserve_approval)){
		msg = "[학교시설물 예약완료] 사용료 입금 및 예약이 완료되었습니다.";
	}else if("D".equals(reserve_approval)){
		msg = "학교 사정으로 시설물 사용이 어렵습니다.다음에 다시 이용해주세요. 감사합니다.";
		/* if(!"".equals(refund_price)){
			msg += " 환불금액 : " + refund_price + " 원";
		} */
	}else if("E".equals(reserve_approval)){
		msg = "[" + school_name + "]" + user_name + "님의 학교시설물 사용료 미납으로 예약이 취소되었습니다." ; 
	}else if("F".equals(reserve_approval)){
		msg = "[" + school_name + "]" + user_name + "님의 시설예약이 취소되었습니다." ; 
		if(!"".equals(refund_price)){
			if("".equals(reserve_type2)){
				msg += "[" + school_name + " " + reserve_type + " 예약취소]" + refund_account + "로 " + refund_price + "원 환불예정입니다.";
			}else{
				msg += "[" + school_name + " " + reserve_type2 + " 예약취소]" + refund_account + "로 " + refund_price + "원 환불예정입니다.";
			}
		}
	}
	
	/* switch(reserve_approval){
		case "B" : msg = "학교시설예약 " + account + " , " + total_price + "원 3일이내 입금바랍니다."; break;
		case "C" : msg = "학교시설예약이 승인완료되었습니다. 당일방문안내."; break;
		case "D" : msg = "시설물사용이 불가능합니다. 불가사유는 홈페이지의 나의예약현황에서 확인바랍니다."; break;
		case "E" : msg = school_name + " 사용료 미입금으로 " + user_name + "님의 시설예약이 취소되었습니다." ; break;
		case "F" : msg = school_name + " 입니다. " + user_name + "님의 시설예약이 취소되었습니다." ; break;
	} */
	 
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
		if("long".equals(long_check)){			//장기예약
			out.println("location.replace('/index.gne?menuCd=DOM_000001201007005002&user_id="+ user_id +"');");
			//out.println("location.replace('/index.gne?menuCd=DOM_000000106007005002&user_id="+ user_id +"');");		//테스트서버
		}else{
			out.println("location.replace('/index.gne?menuCd=DOM_000001201007002002&user_id="+ user_id +"');");
			//out.println("location.replace('/index.gne?menuCd=DOM_000000106007002001&user_id="+ user_id +"');");		//테스트서버
		}
		out.println("</script>");
	}
}

%>