<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

Calendar cal = Calendar.getInstance();
String y = Integer.toString(cal.get(Calendar.YEAR));
String m = Integer.toString(cal.get(Calendar.MONTH)+1);
String d = Integer.toString(cal.get(Calendar.DATE));
String codeDate = "";
y = y.substring(2,4);
if(Integer.parseInt(m) < 10){
	m = "0" + m;
}
if(Integer.parseInt(d) < 10){
	d = "0" + d;
}
codeDate = y+m+d;

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

int key = 0;
int result = 0;

List<Map<String, Object>> dataList = null;
List<String> date_id_list = new ArrayList<String>();

String school_id = parseNull(request.getParameter("school_id"));
String time_id = parseNull(request.getParameter("time_id"));
String room_id = parseNull(request.getParameter("room_id"));
String reserve_group = parseNull(request.getParameter("reserve_group"));
String reserve_date = parseNull(request.getParameter("reserve_date"));
String date_type = parseNull(request.getParameter("date_type"));
String time_use = parseNull(request.getParameter("time_use"));
String time_ban = parseNull(request.getParameter("time_ban"));
String user_id = parseNull(request.getParameter("user_id"));
String user_name = parseNull(request.getParameter("user_name"));
String user_phone = parseNull(request.getParameter("user_phone"));
String organ_name = parseNull(request.getParameter("organ_name"));
String reserve_man = parseNull(request.getParameter("reserve_man"));
String total_price = parseNull(request.getParameter("total_price"));
String use_type = parseNull(request.getParameter("use_type"));
String use_purpose = parseNull(request.getParameter("use_purpose"));
String reserve_type = parseNull(request.getParameter("reserve_type"));
String reserve_type2 = parseNull(request.getParameter("reserve_type2"));
String reserve_number = parseNull(request.getParameter("reserve_number"));
String reserve_time[] = request.getParameterValues("reserve_time");
String count = parseNull(request.getParameter("count"));
String date[] = request.getParameterValues("date");
String user_account = parseNull(request.getParameter("user_account"));
String reserve_code = parseNull(request.getParameter("reserve_code"));
String charge_phone = "";
String msg = "";
String user_option = "";
String dept_tel = "";

String option[] = request.getParameterValues("optionVal");
String date_value[] = request.getParameterValues("date_value");
String time_value[] = request.getParameterValues("time_value");
String date_id[] = request.getParameterValues("date_id");

total_price = total_price.replaceAll("\\,", "");

boolean dupCheck = false;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	conn2 = sqlMapClient.getCurrentConnection();	
	
	//가장 여유가 있는 date_id 구하기(특정일 개방일 시)
	key=0;
	sql = new StringBuffer();
	sql.append("SELECT ROWNUM, DATE_ID, CNT FROM (	 ");
	sql.append("	SELECT DATE_ID, (SELECT COUNT(*) FROM RESERVE_USE WHERE DATE_ID = A.DATE_ID AND DATE_VALUE=?) CNT 	 ");
	sql.append("	FROM RESERVE_DATE A 	 ");
	sql.append("	WHERE ROOM_ID = ? AND DATE_START <= ? AND DATE_END >= ? 	 ");
	sql.append("	ORDER BY CNT, DATE_ID ) 	 ");
	sql.append("WHERE ROWNUM <= ? 	 ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, date_value[0]);
	pstmt.setString(++key, room_id);
	pstmt.setString(++key, date_value[0]);
	pstmt.setString(++key, date_value[0]);
	pstmt.setString(++key, count);
	rs = pstmt.executeQuery();
	while(rs.next()){
		date_id_list.add(rs.getString("DATE_ID"));
	}
	if(pstmt!=null) pstmt.close();
	
	if(date_id_list.size() == 0){		//특정일 개방에서 date_id가 안나왔을 떄 (항시개방일 시)
		key=0;
		sql = new StringBuffer();
		sql.append("SELECT ROWNUM, DATE_ID, CNT FROM (	 ");
		sql.append("	SELECT DATE_ID, (SELECT COUNT(*) FROM RESERVE_USE WHERE DATE_ID = A.DATE_ID AND DATE_VALUE=?) CNT 	 ");
		sql.append("	FROM RESERVE_DATE A 	 ");
		sql.append("	WHERE ROOM_ID = ? AND RESERVE_TYPE = 'A'	 ");
		sql.append("	ORDER BY CNT, DATE_ID ) 	 ");
		sql.append("WHERE ROWNUM <= ? 	 ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(++key, date_value[0]);
		pstmt.setString(++key, room_id);
		pstmt.setString(++key, count);
		rs = pstmt.executeQuery();
		while(rs.next()){
			date_id_list.add(rs.getString("DATE_ID"));
		}
		if(pstmt!=null) pstmt.close();
	}
	
	//예약자번호 구하기
	sql = new StringBuffer();
	sql.append("SELECT USER_ID_SEQ.NEXTVAL USER_ID FROM RESERVE_USER ");
	pstmt = conn.prepareStatement(sql.toString());
	rs = pstmt.executeQuery();
	if(rs.next()){
		user_id = rs.getString("USER_ID");
	}
	if(pstmt!=null) pstmt.close();
	
	for(int i=0; i<date_value.length; i++){
		for(int k=0; k<date_id_list.size(); k++){
			sql = new StringBuffer();
			sql.append("INSERT INTO RESERVE_USE (USE_ID, DATE_ID, SCHOOL_ID, ROOM_ID, USER_ID, DATE_VALUE, TIME_START, TIME_END, REGISTER_DATE)  ");
			sql.append("VALUES(USE_ID_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, SYSDATE ) ");
			pstmt = conn.prepareStatement(sql.toString());
			key = 0;
			pstmt.setString(++key, date_id_list.get(k));
			pstmt.setString(++key, school_id);
			pstmt.setString(++key, room_id);
			pstmt.setString(++key, user_id);
			pstmt.setString(++key, date_value[i]);
			pstmt.setString(++key, time_value[0]);
			pstmt.setString(++key, time_value[1]);
			result = pstmt.executeUpdate(); 
			if(pstmt!=null) pstmt.close();
		}
	}
	
	//예약코드 생성
	sql = new StringBuffer();
	sql.append("SELECT REPLACE(NVL(TO_CHAR(SUBSTR(MAX(RESERVE_CODE),8)+1,'0000'), '0001'), ' ', '') RESERVE_CODE  ");
	sql.append("FROM RESERVE_USER   ");
	sql.append("WHERE RESERVE_CODE LIKE '%'||?||'%'  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, codeDate);
	rs = pstmt.executeQuery();	
	if(rs.next()){
		reserve_code = codeDate + "-" + rs.getString("RESERVE_CODE");	
	}
	if(pstmt!=null) pstmt.close();
	
	//담당자 정보
	sql = new StringBuffer();
	sql.append("SELECT CHARGE_PHONE, DEPT_TEL  ");
	sql.append("FROM RESERVE_SCHOOL WHERE SCHOOL_ID = ?   ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	rs = pstmt.executeQuery();	
	if(rs.next()){
		charge_phone = rs.getString("CHARGE_PHONE");	
		dept_tel = rs.getString("DEPT_TEL");	
	}
	if(pstmt!=null) pstmt.close();
	 
	
	if(option!=null && option.length > 0){
		for(int i=0; i<option.length; i++){
			if(i == 0){
				user_option += option[i];
			}else{
				user_option += ", " + option[i];
			}
		}
	}
	
	key = 0;
	//예약자 정보 입력
	sql = new StringBuffer();
	sql.append("INSERT INTO RESERVE_USER(USER_ID, SCHOOL_ID, ROOM_ID, USER_ACCOUNT, USER_NAME, USER_PHONE, ORGAN_NAME, RESERVE_TYPE, RESERVE_TYPE2,  ");
	sql.append(" 	 RESERVE_MAN, TOTAL_PRICE, USE_TYPE, USE_PURPOSE, RESERVE_APPROVAL, RESERVE_REFUND, RESERVE_DELETE, RESERVE_REGISTER, RESERVE_CODE, APPROVAL_DATE, USER_DATE_VALUE, USER_TIME_START, USER_TIME_END, USER_OPTION) ");
	sql.append("VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, ?, SYSDATE,? ,?, ?, ?) ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, user_id);
	pstmt.setString(++key, school_id);
	pstmt.setString(++key, room_id);
	pstmt.setString(++key, user_account);
	pstmt.setString(++key, user_name);
	pstmt.setString(++key, user_phone);
	pstmt.setString(++key, organ_name);
	pstmt.setString(++key, reserve_type);
	pstmt.setString(++key, reserve_type2);
	pstmt.setString(++key, reserve_man);
	pstmt.setString(++key, total_price);
	pstmt.setString(++key, use_type);
	pstmt.setString(++key, use_purpose);
	pstmt.setString(++key, "A");
	pstmt.setString(++key, "N");
	pstmt.setString(++key, "N");
	pstmt.setString(++key, reserve_code);
	pstmt.setString(++key, date_value[0]);
	pstmt.setString(++key, time_value[0]);
	pstmt.setString(++key, time_value[1]);
	pstmt.setString(++key, user_option);
	result = pstmt.executeUpdate();
	if(result > 0){
		sqlMapClient.commitTransaction();
	}
	if(pstmt!=null) pstmt.close();

	msg = "예약접수 되었습니다. 홈페이지에서 확인 바랍니다.";

	key = 0;
	sql = new StringBuffer();
	sql.append("INSERT INTO SC_TRAN(TR_NUM ,TR_SENDDATE , TR_SENDSTAT ,TR_MSGTYPE ,TR_PHONE ,TR_CALLBACK , TR_MSG)  ");
	sql.append("VALUES (SC_TRAN_SEQ.NEXTVAL, SYSDATE, '0', '0', ?, ?, ?)  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, charge_phone);
	pstmt.setString(++key, "055"+dept_tel);
	pstmt.setString(++key, msg);
	result = pstmt.executeUpdate();
	if(pstmt!=null) pstmt.close();
} catch (Exception e) {
	%>
	<%=e.toString()%>
	<%
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
		out.println("location.replace('/index.gne?menuCd=DOM_000001201003002000');");
		//out.println("location.replace('/index.gne?menuCd=DOM_000000106003002000');");		//테스트서버
		out.println("</script>");
	}
}
%>