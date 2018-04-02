<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

Calendar cal 			= Calendar.getInstance();
String y 				= Integer.toString(cal.get(Calendar.YEAR));
String m 				= Integer.toString(cal.get(Calendar.MONTH)+1);
String d 				= Integer.toString(cal.get(Calendar.DATE));
String codeDate 		= "";
y 						= y.substring(2,4);
if(Integer.parseInt(m) < 10){
	m = "0" + m;
}
if(Integer.parseInt(d) < 10){
	d = "0" + d;
}
codeDate 				= y+m+d;

Connection conn 		= null;
PreparedStatement pstmt = null;
ResultSet rs 			= null;
StringBuffer sql 		= null;

int key 				= 0;
int result 				= 0;

List<Map<String, Object>> dataList = null;
List<String> date_id_list = new ArrayList<String>();

String school_id 		= parseNull(request.getParameter("school_id"), "1");			//학교번호
String room_id 			= parseNull(request.getParameter("room_id"), "18");				//시설번호
String user_id 			= parseNull(request.getParameter("user_id"));					//예약자번호
String user_name 		= parseNull(request.getParameter("user_name"));					//예약자명
String user_phone 		= parseNull(request.getParameter("user_phone"));				//예약자 휴대폰번호
String organ_name 		= parseNull(request.getParameter("organ_name"));				//예약단체
String reserve_man 		= parseNull(request.getParameter("reserve_man"));				//예약인원
String total_price 		= parseNull(request.getParameter("total_price"));				//예약금액
String use_type 		= parseNull(request.getParameter("use_type"));					//사용유형
String use_purpose 		= parseNull(request.getParameter("use_purpose"));				//사용목적
String reserve_type 	= parseNull(request.getParameter("reserve_type"));				//시설명
String reserve_type2 	= parseNull(request.getParameter("reserve_type2"));				//기타시설명
String count 			= parseNull(request.getParameter("count"), "1");				//시설사용 수
String user_account 	= parseNull(request.getParameter("user_account"));				//계좌번호
String reserve_code 	= parseNull(request.getParameter("reserve_code"));				//예약고유번호
String charge_phone 	= "";															//담당자 휴대폰번호
String msg 				= "";															//sms 텍스트
String user_option 		= "";															//사용옵션
String dept_tel 		= "";															//담당부서번호
String option[] 		= request.getParameterValues("optionVal");						//사용옵션 이름
String date_value 		= "";															//reserve_user의 user_date_value에 저장할 값
String time_value[] 	= request.getParameterValues("time_value");						//사용시간
//String time_value[] 	= {"0000", "0630"};

String date_start 		= parseNull(request.getParameter("date_start"), "2017-12-06");	//사용시작일
String date_end 		= parseNull(request.getParameter("date_end"), "2017-12-08");	//사용종료일

String inputStartDate 	= date_start;													//사용시작일과
String inputEndDate 	= date_end;														//사용종료일 사이의
SimpleDateFormat sdf 	= new SimpleDateFormat("yyyy-MM-dd");							//날짜들을 구하여
Date startDate 			= sdf.parse(inputStartDate);									//dates 리스트에 저장
Date endDate 			= sdf.parse(inputEndDate);
ArrayList<String> dates = new ArrayList<String>();
Date currentDate 		= startDate;
while (currentDate.compareTo(endDate) <= 0) {
    dates.add(sdf.format(currentDate));			//날짜 저장
    Calendar c = Calendar.getInstance();
    c.setTime(currentDate);
    c.add(Calendar.DAY_OF_MONTH, 1);			//+1일
    currentDate = c.getTime();
}
total_price 			= total_price.replaceAll("\\,", "");							//금액의 콤마(,) 제거

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	
	//예약자번호 구하기
	sql = new StringBuffer();
	sql.append("SELECT NVL(MAX(USER_ID)+1, 1) AS USER_ID FROM RESERVE_USER		 ");
	pstmt = conn.prepareStatement(sql.toString());
	rs = pstmt.executeQuery();
	if(rs.next()){
		user_id = rs.getString("USER_ID");
	}
	if(pstmt!=null) pstmt.close();
	
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
	
	if(date_start.equals(date_end)){
		date_value = date_start;
	}else{
		date_value = date_start + " ~ " + date_end;
	}
	
	key = 0;
	//예약자 정보 입력
	sql = new StringBuffer();
	sql.append("INSERT INTO RESERVE_USER(USER_ID, SCHOOL_ID, ROOM_ID, USER_ACCOUNT, USER_NAME, USER_PHONE, ORGAN_NAME, RESERVE_TYPE, RESERVE_TYPE2,  ");
	sql.append(" 	 RESERVE_MAN, TOTAL_PRICE, USE_TYPE, USE_PURPOSE, RESERVE_APPROVAL, RESERVE_REFUND, RESERVE_DELETE, RESERVE_REGISTER, RESERVE_CODE, APPROVAL_DATE, USER_DATE_VALUE, USER_TIME_START, USER_TIME_END, USER_OPTION) ");
	sql.append("VALUES(USER_ID_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, ?, SYSDATE,? ,?, ?, ?) ");
	pstmt = conn.prepareStatement(sql.toString());
	//pstmt.setString(++key, user_id);
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
	pstmt.setString(++key, date_value);
	pstmt.setString(++key, time_value[0]);
	pstmt.setString(++key, time_value[1]);
	pstmt.setString(++key, user_option);
	result = pstmt.executeUpdate();
	if(result > 0){
		for(String date : dates){
			date_id_list = new ArrayList<String>();
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
			pstmt.setString(++key, date);
			pstmt.setString(++key, room_id);
			pstmt.setString(++key, date);
			pstmt.setString(++key, date);
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
				pstmt.setString(++key, date);
				pstmt.setString(++key, room_id);
				pstmt.setString(++key, count);
				rs = pstmt.executeQuery();
				while(rs.next()){
					date_id_list.add(rs.getString("DATE_ID"));
				}
				if(pstmt!=null) pstmt.close();
			}
			
			sql = new StringBuffer();
			sql.append("INSERT INTO RESERVE_USE (USE_ID, DATE_ID, SCHOOL_ID, ROOM_ID, USER_ID, DATE_VALUE, TIME_START, TIME_END, REGISTER_DATE)  ");
			sql.append("VALUES(USE_ID_SEQ.NEXTVAL, ?, ?, ?, USER_ID_SEQ.CURRVAL, ?, ?, ?, SYSDATE ) ");
			pstmt = conn.prepareStatement(sql.toString());
			for(int k=0; k<date_id_list.size(); k++){
				key = 0;
				pstmt.setString(++key, date_id_list.get(k));
				pstmt.setString(++key, school_id);
				pstmt.setString(++key, room_id);
				//pstmt.setString(++key, user_id);
				pstmt.setString(++key, date);
				pstmt.setString(++key, time_value[0]);
				pstmt.setString(++key, time_value[1]);
				pstmt.addBatch();				
			}
			int[] useCnt 	=   pstmt.executeBatch();
			result      	=   useCnt.length;
		}
	}
	if(pstmt!=null) pstmt.close();

	if("".equals(reserve_type2)){
		msg = "[" + reserve_type + " " + date_value + "]예약신청이 접수되었습니다. 홈페이지에서 확인바랍니다.";
	}else{
		msg = "[" + reserve_type2 + " " + date_value + "]예약신청이 접수되었습니다. 홈페이지에서 확인바랍니다.";
	}
	

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