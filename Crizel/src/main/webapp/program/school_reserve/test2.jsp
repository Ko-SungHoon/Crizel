<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ page import="java.text.ParseException"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%!
public boolean strContain(String arr[], String value){		//배열 중 해당 문자가 있는지 확인해서 true, false로 리턴
	boolean bool = false;
	for(String ob : arr){
		if(value.equals(ob)){
			bool = true;
			break;
		}
	}
	return bool;
}
%>
  	  	
<%!
public boolean isInDuration(String startDay, String endDay, String evalDay) throws ParseException {		//시작,종료날짜에 특정날짜가 포함되는지 true, false로 리턴
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
<%!
public String getDateDay2(String date, String dateType) throws Exception {
    String day = "" ;
    SimpleDateFormat dateFormat = new SimpleDateFormat(dateType) ;
    Date nDate = dateFormat.parse(date) ;
    Calendar cal = Calendar.getInstance() ;
    cal.setTime(nDate);
    int dayNum = cal.get(Calendar.DAY_OF_WEEK) ;
    switch(dayNum){
        case 1: day = "일"; break ;
        case 2 : case 3 : case 4 : case 5 : case 6: day = "평일"; break ;
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

String school_id = parseNull(request.getParameter("school_id"),"564");
String reserve_type = parseNull(request.getParameter("reserve_type"), "강당");
String reserve_type2 = parseNull(request.getParameter("reserve_type2"), "");
String count = parseNull(request.getParameter("count"), "1");

String room_id = "";
//String date_id = "";
List<String> date_id = new ArrayList<String>();
String total_price = "";
	
int dateCnt1 = 0;		//시작날짜, 종료날짜 사이의 날짜 갯수
int dateCnt2 = 0;		//시작날짜, 종료날짜 사이 선택한 요일을 포함하는 날짜의 갯수

String date_start = parseNull(request.getParameter("date_start"),"2018-05-20");
String date_end = parseNull(request.getParameter("date_end"),"2018-05-20");
String time_start = parseNull(request.getParameter("time_start"),"0900");
String time_end = parseNull(request.getParameter("time_end"),"1300");

String inputStartDate = date_start;
String inputEndDate = date_end;
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
Date startDate = sdf.parse(inputStartDate);
Date endDate = sdf.parse(inputEndDate);
ArrayList<String> dates = new ArrayList<String>();
Date currentDate = startDate;
while (currentDate.compareTo(endDate) <= 0) {
    dates.add(sdf.format(currentDate));			//날짜 저장
    Calendar c = Calendar.getInstance();
    c.setTime(currentDate);
    c.add(Calendar.DAY_OF_MONTH, 1);			//+1일
    currentDate = c.getTime();
}

String dateDay[] = new String[dates.size()];
int dateDayIndex = 0;
for (String date : dates) {
	dateDay[dateDayIndex++] = getDateDay(date, "yyyy-MM-dd");
}

total_price = total_price.replaceAll("\\,", "");

List<String> date_id_list = new ArrayList<String>();		//여유있는 date_id 리스트(사용시간이 가장 적은)
boolean date_id_list_check = false;							//date_id를 찾기 위한 boolean 변수

String allTimeCheck_1 = "N";
String allTimeCheck_2 = "N";
String allTimeCheck_3 = "N";

boolean chk1 = false;
boolean chk2 = false;
boolean chk3 = false;

boolean banCheck1 = false;			//특정일 사용불가 리스트 확인용 변수
boolean banCheck2 = false;
boolean banCheck3 = false;		

boolean dateCheck = false;
boolean useCheck = false;
boolean totalBanCheck = false;

int useAbleCnt = 0;
int dateCheckCnt = 0;
int useCheckCnt = 0;
int totalBanCheckCnt = 0;

String returnVal = "";

String dateDay_1 = "";
String dateDay_2 = "";
String dateDay_3 = "";
for(String ob : dateDay){
	if("월".equals(ob) || "화".equals(ob) || "수".equals(ob) || "목".equals(ob) || "금".equals(ob)){
		dateDay_1 = "Y";
	}else if("토".equals(ob)){
		dateDay_2 = "Y";
	}else if("일".equals(ob)){
		dateDay_3 = "Y";
	}
}

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
  		
 	//room_id 확인
 	key = 0;
  	sql = new StringBuffer();
  	sql.append("SELECT * FROM RESERVE_ROOM WHERE SCHOOL_ID = ? AND RESERVE_TYPE = ? ");
  	if(!"".equals(reserve_type2)){
		sql.append("AND RESERVE_TYPE2 = ?");			//기타시설일 경우
	}
  	pstmt = conn.prepareStatement(sql.toString());
  	pstmt.setString(++key, school_id);
  	pstmt.setString(++key, reserve_type);
  	if(!"".equals(reserve_type2)){
		pstmt.setString(++key, reserve_type2);
	}
  	rs = pstmt.executeQuery();
  	if(rs.next()){
  		room_id = parseNull(rs.getString("ROOM_ID"));
  	}
  	if(pstmt!=null) pstmt.close();
  	
  	
  	if(!"".equals(room_id)){
  		//특정일개방 날짜 확인
  		sql = new StringBuffer();
  		sql.append("SELECT * FROM RESERVE_DATE WHERE ROOM_ID = ? AND DATE_START <= ? AND DATE_END >= ?		 ");	
  		pstmt = conn.prepareStatement(sql.toString());
  		pstmt.setString(1, room_id);
  		pstmt.setString(2, date_start);
  		pstmt.setString(3, date_end);
  		rs = pstmt.executeQuery();
  		while(rs.next()){
  			date_id.add(rs.getString("DATE_ID"));
  		}
  		if(pstmt!=null) pstmt.close();
  		
  		if(date_id.size() == 0){
  			//개방됬는지 확인(항시개방이 있는지 확인)
 	  		sql = new StringBuffer();
 	  		sql.append("SELECT DATE_ID FROM RESERVE_DATE WHERE RESERVE_TYPE = 'A' AND ROOM_ID = ?  ");	
 	  		pstmt = conn.prepareStatement(sql.toString());
 	  		pstmt.setString(1, room_id);
 	  		rs = pstmt.executeQuery();
 	  		if(rs.next()){
 	  			date_id.add(rs.getString("DATE_ID"));
 	  		}
 	  		if(pstmt!=null) pstmt.close();
  		}
  		
  		
  		if(date_id.size() > 0){	
  			for(String dateId : date_id){		//개방 조건이 여러개 일 수 있기때문에 반복한다
  			//요일별 확인
  	  			key = 0;
  	  	  		sql = new StringBuffer();
  	  	  		sql.append("SELECT    																																");
  	  	  		sql.append("TIME_START_A, TIME_START_A2, TIME_END_A, TIME_END_A2,																					");
  	  	  		sql.append("TIME_START_B, TIME_START_B2, TIME_END_B, TIME_END_B2,																					");
  	  	 	 	sql.append("TIME_START_C, TIME_START_C2, TIME_END_C, TIME_END_C2,																					");
  				sql.append("DECODE(TIME_START_A, NULL, 'N',																											");
  				sql.append("	DECODE(TIME_START_A2, NULL,		  																									");
  				sql.append("		CASE  WHEN TIME_START_A <= ? AND TIME_END_A >= ? THEN 'Y' ELSE 'N' END ,														");
  				sql.append("		DECODE(TIME_END_A,TIME_START_A2,																								");
  				sql.append("			CASE WHEN TIME_START_A <= ? AND TIME_END_A2 >= ? THEN 'Y' ELSE 'N' END ,		  											");
  				sql.append("			CASE WHEN ((TIME_START_A <= ? AND TIME_END_A >= ?) OR (TIME_START_A2 <= ? AND TIME_END_A2 >= ?))  THEN 'Y'  ELSE 'N' END	");
  				sql.append("		)		  																														");
  				sql.append("	)		  																															");
  				sql.append(") AS CASE1,		  																														");
  				sql.append("DECODE(TIME_START_B, NULL, 'N',		  																									");	
  				sql.append("	DECODE(TIME_START_B2, NULL,		  																									");
  				sql.append("		CASE  WHEN TIME_START_B <= ? AND TIME_END_B >= ? THEN 'Y' ELSE 'N' END ,		  												");
  				sql.append("		DECODE(TIME_END_B,TIME_START_B2,		  																						");
  				sql.append("			CASE WHEN TIME_START_B <= ? AND TIME_END_B2 >= ? THEN 'Y' ELSE 'N' END ,		  											");
  				sql.append("			CASE WHEN ((TIME_START_B <= ? AND TIME_END_B >= ?) OR (TIME_START_B2 <= ? AND TIME_END_B2 >= ?))  THEN 'Y'  ELSE 'N' END	");
  				sql.append("		)		  																														");
  				sql.append("	)		  																															");
  				sql.append(") AS CASE2,		  																														");
  				sql.append("DECODE(TIME_START_C, NULL, 'N',		  																									");	
  				sql.append("	DECODE(TIME_START_C2, NULL,		  																									");
  				sql.append("		CASE  WHEN TIME_START_C <= ? AND TIME_END_C >= ? THEN 'Y' ELSE 'N' END ,		  												");
  				sql.append("		DECODE(TIME_END_C,TIME_START_C2,		  																						");
  				sql.append("			CASE WHEN TIME_START_C <= ? AND TIME_END_C2 >= ? THEN 'Y' ELSE 'N' END ,		  											");
  				sql.append("			CASE WHEN ((TIME_START_C <= ? AND TIME_END_C >= ?) OR (TIME_START_C2 <= ? AND TIME_END_C2 >= ?))  THEN 'Y'  ELSE 'N' END	");
  				sql.append("		)		  																														");
  				sql.append("	)		  																															");
  				sql.append(") AS CASE3		  																														");
  	  	  		sql.append("FROM RESERVE_DATE WHERE DATE_ID = ?  																									");	
  	  	  		pstmt = conn.prepareStatement(sql.toString());
  				pstmt.setString(++key, time_start);
  				pstmt.setString(++key, time_end);
  				pstmt.setString(++key, time_start);
  				pstmt.setString(++key, time_end);
  				pstmt.setString(++key, time_start);
  				pstmt.setString(++key, time_end);
  				pstmt.setString(++key, time_start);
  				pstmt.setString(++key, time_end);
  				pstmt.setString(++key, time_start);
  				pstmt.setString(++key, time_end);
  				pstmt.setString(++key, time_start);
  				pstmt.setString(++key, time_end);
  				pstmt.setString(++key, time_start);
  				pstmt.setString(++key, time_end);
  				pstmt.setString(++key, time_start);
  				pstmt.setString(++key, time_end);
  				pstmt.setString(++key, time_start);
  				pstmt.setString(++key, time_end);
  				pstmt.setString(++key, time_start);
  				pstmt.setString(++key, time_end);
  				pstmt.setString(++key, time_start);
  				pstmt.setString(++key, time_end);
  				pstmt.setString(++key, time_start);
  				pstmt.setString(++key, time_end);
  	  	  		pstmt.setString(++key, dateId);
  	  	  		rs = pstmt.executeQuery();
  	  	  		if(rs.next()){
  	  	  			if("Y".equals(rs.getString("CASE1")) || "Y".equals(rs.getString("CASE2")) || "Y".equals(rs.getString("CASE3"))){
  	  	  				useAbleCnt++;				//case1~3 중 하나라도 Y 이면 카운트 증가
  	  	  			}
  	  	  			allTimeCheck_1 = rs.getString("CASE1");
  	  	  			allTimeCheck_2 = rs.getString("CASE2");
  	  	  			allTimeCheck_3 = rs.getString("CASE3");
  	  	  		}
  	  	  		
  	  	  		//특정일 개방불가 여부 체크
  	  	  		key = 0;
  	  	  		sql = new StringBuffer();
  		  		sql.append("SELECT																															");
  		  		sql.append("DECODE(TIME_START_A, NULL, 'N',  																								");
  		  		sql.append("	CASE WHEN ((TIME_START_A >= ? AND TIME_START_A <= ?) OR (TIME_START_A <= ? AND TIME_END_A2 >= ?)) THEN 'Y' ELSE 'N' END		");
  		  		sql.append(") AS CASE1,		 																												");
  		  		sql.append("DECODE(TIME_START_B, NULL, 'N',  																								");
  		  		sql.append("	CASE WHEN ((TIME_START_B >= ? AND TIME_START_B <= ?) OR (TIME_START_B <= ? AND TIME_END_B2 >= ?)) THEN 'Y' ELSE 'N' END		");
  		  		sql.append(") AS CASE2,		 																												");
  		  		sql.append("DECODE(TIME_START_C, NULL, 'N',  																								");
  		  		sql.append("	CASE WHEN ((TIME_START_C >= ? AND TIME_START_C <= ?) OR (TIME_START_C <= ? AND TIME_END_C2 >= ?)) THEN 'Y' ELSE 'N' END		");
  		  		sql.append(") AS CASE3		 																												");
  		  		sql.append("FROM RESERVE_BAN WHERE ROOM_ID = ? AND ((DATE_START >= ? AND DATE_START <= ?) OR (DATE_START <= ? AND DATE_END >= ?)) 			");
  		  		pstmt = conn.prepareStatement(sql.toString());
  		  		pstmt.setString(++key, time_start);
  		  		pstmt.setString(++key, time_end);
  		  		pstmt.setString(++key, time_start);
  		  		pstmt.setString(++key, time_start);
  		  		pstmt.setString(++key, time_start);
  		  		pstmt.setString(++key, time_end);
  		  		pstmt.setString(++key, time_start);
  		  		pstmt.setString(++key, time_start);
  		  		pstmt.setString(++key, time_start);
  		  		pstmt.setString(++key, time_end);
  		  		pstmt.setString(++key, time_start);
  		  		pstmt.setString(++key, time_start);
  		  		pstmt.setString(++key, room_id);
  		  		pstmt.setString(++key, date_start);
  		  		pstmt.setString(++key, date_end);
  		  		pstmt.setString(++key, date_start);
  		 		pstmt.setString(++key, date_start);
  	  	  		rs = pstmt.executeQuery();
  	  	  		if(rs.next()){
  	  	  			banCheck1 = "Y".equals(rs.getString("CASE1"))?true:false;
  	  	  			banCheck2 = "Y".equals(rs.getString("CASE2"))?true:false;
  	  	  			banCheck3 = "Y".equals(rs.getString("CASE3"))?true:false;	
  	  	  		}
  	  	  		
  		  	  	if("Y".equals(dateDay_1) && "Y".equals(allTimeCheck_1)){			//평일선택여부 + 평일에 개방되어있는지 여부
  		  			chk1 = true;
  		  		}else if("".equals(dateDay_1)){
  		  			chk1 = true;
  		  		}else{
  		  			chk1 = false;
  		  		}
  		  		
  				if("Y".equals(dateDay_2) && "Y".equals(allTimeCheck_2)){			//토요일선택여부 + 토요일에 개방되어있는지 여부
  					chk2 = true;		
  				}else if("".equals(dateDay_2)){
  		  			chk2 = true;
  		  		}else{
  		  			chk2 = false;
  		  		}
  				
  				if("Y".equals(dateDay_3) && "Y".equals(allTimeCheck_3)){			//일요일선택여부 + 일요일에 개방되어있는지 여부
  					chk3 = true;	
  				}else if("".equals(dateDay_3)){
  		  			chk3 = true;
  		  		}else{
  		  			chk3 = false;
  		  		}
  		  		
  		  		if(chk1 && chk2 && chk3){				
  		  			dateCheck = true;
  		  			dateCheckCnt++;
  		  		}
  		  		
  		  		if(!banCheck1 && !banCheck2 && !banCheck3){			//평일,토요일,일요일 모두 해당하는 데이터가 없어야한다
					totalBanCheck = true;
				}else{
					totalBanCheckCnt++;
				}
  		  		
  		  		boolean check = false;
  		  	    
  		  	    for (String date : dates) {
  		  			for(String ob : dateDay){
  		  				if(ob.equals(getDateDay(date,"yyyy-MM-dd"))){
  		  					check = true;
  		  				}				
  		  			}
  		  			if(check){
  		  				check = false;
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
  		  					date_id_list_check = true;
  		  				}
  		  				
  		  				if(!date_id_list_check){		//특정일 개방에서 date_id가 안나왔을 떄 (항시개방일 시)
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
  		  				}
  		  				if(date_id_list != null && date_id_list.size() > 0){
  		  					for(int i=0; i<date_id_list.size(); i++){
  		  						//사용중인 시간이 있는지 확인
  					  			key = 0;
  				  		  		sql = new StringBuffer();
  				  		  		sql.append("SELECT *																					");
  				  		  		sql.append("FROM RESERVE_USE																			");
  				  		  		sql.append("WHERE ((TIME_START >= ? AND TIME_START <= ?) OR (TIME_START <= ? AND TIME_END >= ?))		");
  				  		  		sql.append("AND ROOM_ID = ? AND DATE_VALUE = ?	AND DATE_ID = ?											");
  				  		  		pstmt = conn.prepareStatement(sql.toString());
  				  		  		pstmt.setString(++key, time_start);
  				  		  		pstmt.setString(++key, time_end);
  				  		  		pstmt.setString(++key, time_start);
  				  		  		pstmt.setString(++key, time_start);
  				  		  		pstmt.setString(++key, room_id);
  				  		  		pstmt.setString(++key, date);
  				  		  		pstmt.setString(++key, date_id_list.get(i));
  				  		  		rs = pstmt.executeQuery();
  				  		  		while(rs.next()){
  				  		  			if(isInDuration(date_start, date_end, rs.getString("DATE_VALUE"))){
  				  		  		 		useCheck = true;
  				  		  		 		useCheckCnt++;
  				  		  	  		}
  				  		  		}
  		  	  				}
  		  				}
  		  			}
  		  	    }
  			}
  		}
  		
  		out.println(useAbleCnt + "<br>");
  		out.println(totalBanCheckCnt + "<br>");
  		out.println(count + "<br>");
  		out.println(useCheckCnt + "<br>");
  		
  		if(useAbleCnt > 0 && dateCheckCnt == useAbleCnt && totalBanCheckCnt <= 0 && (Integer.parseInt(count)<=useCheckCnt || useCheckCnt <= 0) && !useCheck){
  			returnVal = "Y";
  		}else{
  			returnVal = "N";
  		}
  		
  		/* if(dateCheck && !useCheck && totalBanCheck){
  			returnVal = "Y";
  		}else{
  			returnVal = "N";
  		} */
  		
  		
  	}else{
  		returnVal = "N";
  	}
  	
	out.println(returnVal);
    
	
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
	
 	
}

%>