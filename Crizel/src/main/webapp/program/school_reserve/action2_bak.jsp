<%
/**
*   PURPOSE :   장기예약등록 구동 페이지
*   CREATE  :   2017....    고주임
*   MODIFY  :   ....
*/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ page import="java.text.ParseException"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%!
public boolean isInDuration(String startDay, String endDay, String evalDay) throws ParseException {
	boolean result = false; 	 
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	Date beginDate = formatter.parse(startDay);
	Date endDate = formatter.parse(endDay);
	Date evalDate = formatter.parse(evalDay);
	if( (beginDate.compareTo(evalDate))==0 || (endDate.compareTo(evalDate))==0 || (beginDate.before(evalDate) &&endDate.after(evalDate)) ) {
		result = true;
	}
	return result;
}
%>
<%!
public String getDateDay(String date, String dateType) throws Exception {
    String day = "" ;
    SimpleDateFormat dateFormat = new SimpleDateFormat(dateType) ;
    Date nDate = dateFormat.parse(date) ;
    Calendar cal = Calendar.getInstance() ;
    cal.setTime(nDate);
    int dayNum = cal.get(Calendar.DAY_OF_WEEK) ;
    switch(dayNum){
        case 1: day = "일"; break ;
        case 2: day = "월"; break ;
        case 3: day = "화"; break ;
        case 4: day = "수"; break ;
        case 5: day = "목"; break ;
        case 6: day = "금"; break ;
        case 7: day = "토"; break ;
    }
    return day ;
}
%>
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

String school_id = parseNull(request.getParameter("school_id"));
String time_id = parseNull(request.getParameter("time_id"));
String room_id = parseNull(request.getParameter("room_id"));
String reserve_group = parseNull(request.getParameter("reserve_group"));
String reserve_date = parseNull(request.getParameter("reserve_date"));
String date_type = parseNull(request.getParameter("date_type"));
String time_use = parseNull(request.getParameter("time_use"));
String time_ban = parseNull(request.getParameter("time_ban"));
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
String user_account = parseNull(request.getParameter("user_account"));
String reserve_code = parseNull(request.getParameter("reserve_code"));
String charge_phone = "";
String dept_tel = "";
String msg = "";

String date_value[] = request.getParameterValues("date_value");
String time_value[] = request.getParameterValues("time_value");
String date_id = "";

String date_start = parseNull(request.getParameter("date_start"));
String date_end = parseNull(request.getParameter("date_end"));
String time_start[] = request.getParameterValues("time_start");
String time_end[] = request.getParameterValues("time_end");
String dateDay[] = request.getParameterValues("dateDay");
String long_id = "";

List<String> user_id = new ArrayList<String>();

String arr[] = request.getParameterValues("arr");
String arr2[] = new String[7];
List<String[]> list = new ArrayList<String[]>();

List<String> long_date = new ArrayList<String>();

for(String ob : arr){
	long_date.add(ob);
	arr2 = ob.split(",");
	list.add(arr2);
}

total_price = total_price.replaceAll("\\,", "");
boolean check = false;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	
	String inputStartDate = date_start;
    String inputEndDate = date_end;
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date startDate = sdf.parse(inputStartDate);
    Date endDate = sdf.parse(inputEndDate);
    ArrayList<String> dates = new ArrayList<String>();
    Date currentDate = startDate;
    while (currentDate.compareTo(endDate) <= 0) {
        dates.add(sdf.format(currentDate));
        Calendar c = Calendar.getInstance();
        c.setTime(currentDate);
        c.add(Calendar.DAY_OF_MONTH, 1);
        currentDate = c.getTime();
    }
    
    
    //room_id 확인
  	sql = new StringBuffer();
  	sql.append("SELECT * FROM RESERVE_ROOM WHERE SCHOOL_ID = ? AND RESERVE_TYPE = ? ");
  	pstmt = conn.prepareStatement(sql.toString());
  	pstmt.setString(1, school_id);
  	pstmt.setString(2, reserve_type);
  	rs = pstmt.executeQuery();
  	if(rs.next()){
  		room_id = rs.getString("ROOM_ID");
  	}
  	if(pstmt!=null) pstmt.close();
  	
  	
  	
 	//long_id 확인
  	sql = new StringBuffer();
  	sql.append("SELECT LONG_ID_SEQ.NEXTVAL LONG_ID FROM DUAL ");
  	pstmt = conn.prepareStatement(sql.toString());
  	rs = pstmt.executeQuery();
  	if(rs.next()){
  		long_id = rs.getString("LONG_ID");
  	}
  	if(pstmt!=null) pstmt.close();
    
  	//개방됬는지 확인
	sql = new StringBuffer();
	sql.append("SELECT DATE_ID FROM RESERVE_DATE  ");
	sql.append("WHERE (DATE_START <= ? AND DATE_END >= ?) OR RESERVE_TYPE = 'A' AND ROOM_ID = ?  ");	
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, date_start);
	pstmt.setString(2, date_end);
	pstmt.setString(3, room_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		date_id = rs.getString("DATE_ID");
	}
	if(pstmt!=null) pstmt.close();
	
	
	//예약자번호 구하기
	for(String ob : arr){
		sql = new StringBuffer();
		sql.append("SELECT USER_ID_SEQ.NEXTVAL USER_ID FROM RESERVE_USER ");
		pstmt = conn.prepareStatement(sql.toString());
		rs = pstmt.executeQuery();
		if(rs.next()){
			user_id.add(rs.getString("USER_ID"));
		}
		if(pstmt!=null) pstmt.close();
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
	
	if(!"".equals(room_id) && !"".equals(date_id)){
		for (String date : dates) {
			for(int k=0; k<list.size(); k++){
				String ob[] = list.get(k);
				for(int l=0; l<ob.length; l++){
					String ob2 = ob[l];
					if(ob2.equals(getDateDay(date,"yyyy-MM-dd"))){
						check = true;
					}
				}
				
				if(check){
					check = false;
					sql = new StringBuffer();
					sql.append("INSERT INTO RESERVE_USE (USE_ID, DATE_ID, SCHOOL_ID, ROOM_ID, USER_ID, DATE_VALUE, TIME_START, TIME_END, REGISTER_DATE, LONG_ID)  ");
					sql.append("VALUES(USE_ID_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, SYSDATE, ? ) ");
					pstmt = conn.prepareStatement(sql.toString());
					key = 0;
					pstmt.setString(++key, date_id);
					pstmt.setString(++key, school_id);
					pstmt.setString(++key, room_id);
					pstmt.setString(++key, user_id.get(k));
					pstmt.setString(++key, date);
					pstmt.setString(++key, time_start[k]);
					pstmt.setString(++key, time_end[k]);
					pstmt.setString(++key, long_id);
					result = pstmt.executeUpdate();
					if(pstmt!=null)pstmt.close();
				}
			}
	    }
		
		for(int i=0; i<arr.length; i++){
			key = 0;
			//예약자 정보 입력
			sql = new StringBuffer();
			sql.append("INSERT INTO RESERVE_USER(USER_ID, SCHOOL_ID, ROOM_ID, USER_ACCOUNT, USER_NAME, USER_PHONE, ORGAN_NAME, RESERVE_TYPE, RESERVE_TYPE2,  ");
			sql.append(" RESERVE_MAN, TOTAL_PRICE, USE_TYPE, USE_PURPOSE, RESERVE_APPROVAL, RESERVE_REFUND, RESERVE_DELETE, RESERVE_REGISTER, RESERVE_CODE, LONG_ID, LONG_DATE, APPROVAL_DATE ");
			sql.append(" , USER_TIME_START, USER_TIME_END, USER_DATE_VALUE) ");
			sql.append("VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, ?, ?, ?, SYSDATE, ?, ?, ?) ");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(++key, user_id.get(i));
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
			pstmt.setString(++key, "C");
			pstmt.setString(++key, "N");
			pstmt.setString(++key, "N");
			pstmt.setString(++key, reserve_code);
			pstmt.setString(++key, long_id);
			pstmt.setString(++key, long_date.get(i));
			pstmt.setString(++key, time_start[i]);
			pstmt.setString(++key, time_end[i]);
			pstmt.setString(++key, dates.get(0) + " ~ " + dates.get(dates.size()-1));
			result = pstmt.executeUpdate();
			if(pstmt!=null) pstmt.close();
		}
	}
    
	msg = reserve_type + " 시설이 장기예약 되었습니다.";
	
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
		out.println("location.replace('/index.gne?menuCd=DOM_000001201007005002');");
		//out.println("location.replace('/index.gne?menuCd=DOM_000000106007005002');");		//테스트서버
		out.println("</script>");
	}else{
		out.println("<script type=\"text/javascript\">");
		out.println("alert('처리 중 오류가 발생하였습니다.');");
		out.println("location.replace('/index.gne?menuCd=DOM_000001201007005002');");
		//out.println("location.replace('/index.gne?menuCd=DOM_000000106007005002');");		//테스트서버
		out.println("</script>");
	}
}

%>