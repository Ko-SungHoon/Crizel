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

String school_id = parseNull(request.getParameter("school_id"),"504");
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
String reserve_type = parseNull(request.getParameter("reserve_type"), "강당");
String reserve_type2 = parseNull(request.getParameter("reserve_type2"));
String reserve_number = parseNull(request.getParameter("reserve_number"));
String reserve_time[] = request.getParameterValues("reserve_time");
String count = parseNull(request.getParameter("count"));
String user_account = parseNull(request.getParameter("user_account"));
String reserve_code = parseNull(request.getParameter("reserve_code"));
String charge_phone = "";
String msg = "";

String date_value[] = request.getParameterValues("date_value");
String time_value[] = request.getParameterValues("time_value");
String date_id = "";

String date_start = parseNull(request.getParameter("date_start"),"2017-11-20");
String date_end = parseNull(request.getParameter("date_end"),"2017-11-28");
String time_start = parseNull(request.getParameter("time_start"),"0230");
String time_end = parseNull(request.getParameter("time_end"),"0300");
//String dateDay[] = request.getParameterValues("dateDay");
String dateDay[] = {"목", "금"};

total_price = total_price.replaceAll("\\,", "");

boolean dateCheck = false;
boolean useCheck = false;

String allTimeCheck_1 = "N";
String allTimeCheck_2 = "N";
String allTimeCheck_3 = "N";

boolean chk1 = false;
boolean chk2 = false;
boolean chk3 = false;

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
  	sql = new StringBuffer();
  	sql.append("SELECT * FROM RESERVE_ROOM WHERE SCHOOL_ID = ? AND RESERVE_TYPE = ? ");
  	pstmt = conn.prepareStatement(sql.toString());
  	pstmt.setString(1, school_id);
  	pstmt.setString(2, reserve_type);
  	rs = pstmt.executeQuery();
  	if(rs.next()){
  		room_id = parseNull(rs.getString("ROOM_ID"));
  	}
  	
  	
  	if(!"".equals(room_id)){
  		//개방됬는지 확인(항시개방이 있는지 확인)
  		sql = new StringBuffer();
  		sql.append("SELECT DATE_ID FROM RESERVE_DATE WHERE RESERVE_TYPE = 'A' AND ROOM_ID = ?  ");	
  		pstmt = conn.prepareStatement(sql.toString());
  		pstmt.setString(1, room_id);
  		rs = pstmt.executeQuery();
  		if(rs.next()){
  			date_id = rs.getString("DATE_ID");
  		}
  	  	
  		
  		if("".equals(date_id)){			//항시개방이 아닐시 특정일 개방 중에서 선택
  			sql = new StringBuffer();
  	  		sql.append("SELECT DATE_ID FROM RESERVE_DATE WHERE ROOM_ID = ? AND ((DATE_START >= ? AND DATE_START <= ?) OR (DATE_START <= ? AND DATE_END >= ?)) ");	
  	  		pstmt = conn.prepareStatement(sql.toString());
  	  		pstmt.setString(1, room_id);
  	  		pstmt.setString(2, date_start);
  	  		pstmt.setString(3, date_end);
  	  		pstmt.setString(4, date_start);
  	 		pstmt.setString(5, date_start);
  	  		rs = pstmt.executeQuery();
  	  		if(rs.next()){
  	  			date_id = rs.getString("DATE_ID");
  	  		}
  		}
  		
  		
  		if(!"".equals(date_id)){		
  			//요일별 확인
  	  		sql = new StringBuffer();
  	  		sql.append("SELECT * FROM RESERVE_DATE WHERE DATE_ID = ?  ");	
  	  		pstmt = conn.prepareStatement(sql.toString());
  	  		pstmt.setString(1, date_id);
  	  		rs = pstmt.executeQuery();
  	  		if(rs.next()){
  	  			if(!"".equals(parseNull(rs.getString("TIME_START_A")))  ){
  	  				if("Y".equals(dateDay_1)){
	  	  				if(!"".equals(parseNull(rs.getString("TIME_START_A2")))  ){
		  	  				if(rs.getString("TIME_END_A").equals(rs.getString("TIME_START_A2"))){		//첫시간과 두번째 시간이 연속 될 때
		  	  					if(Integer.parseInt(time_start) >= Integer.parseInt(rs.getString("TIME_START_A")) 
			  	  	  				&& Integer.parseInt(time_end) <= Integer.parseInt(rs.getString("TIME_END_A2"))){
			  	  	  					allTimeCheck_1 = "Y";
		  	  	  				}
		  	  				}else{
		  	  					if((Integer.parseInt(time_start) >= Integer.parseInt(rs.getString("TIME_START_A")) 
			  	  	  				&& Integer.parseInt(time_end) <= Integer.parseInt(rs.getString("TIME_END_A"))) ||
				  	  	  			(Integer.parseInt(time_start) >= Integer.parseInt(rs.getString("TIME_START_A2")) 
			  	  	  				&& Integer.parseInt(time_end) <= Integer.parseInt(rs.getString("TIME_END_A2")))
		  	  						){
			  	  	  					allTimeCheck_1 = "Y";
		  	  	  				}
		  	  				}
		  	  			}else{
			  	  			if(Integer.parseInt(time_start) >= Integer.parseInt(rs.getString("TIME_START_A")) 
		  	  	  				&& Integer.parseInt(time_end) <= Integer.parseInt(rs.getString("TIME_END_A"))){
		  	  	  					allTimeCheck_1 = "Y";
	  	  	  				}
		  	  			}
  	  				}
	  	  			
  	  			}
	  	  		if(!"".equals(parseNull(rs.getString("TIME_START_B")))  ){
		  	  		if("Y".equals(dateDay_2)){
			  	  		if(!"".equals(parseNull(rs.getString("TIME_START_B2")))  ){
		  	  				if(rs.getString("TIME_END_B").equals(rs.getString("TIME_START_B2"))){		//첫시간과 두번째 시간이 연속 될 때
		  	  					if(Integer.parseInt(time_start) >= Integer.parseInt(rs.getString("TIME_START_B")) 
			  	  	  				&& Integer.parseInt(time_end) <= Integer.parseInt(rs.getString("TIME_END_B2"))){
			  	  	  					allTimeCheck_2 = "Y";
		  	  	  				}
		  	  				}else{
		  	  					if((Integer.parseInt(time_start) >= Integer.parseInt(rs.getString("TIME_START_B")) 
				  	  	  				&& Integer.parseInt(time_end) <= Integer.parseInt(rs.getString("TIME_END_B"))) ||
					  	  	  			(Integer.parseInt(time_start) >= Integer.parseInt(rs.getString("TIME_START_B2")) 
				  	  	  				&& Integer.parseInt(time_end) <= Integer.parseInt(rs.getString("TIME_END_B2")))
			  	  						){
				  	  	  					allTimeCheck_2 = "Y";
			  	  	  				}
			  	  				}
		  	  			}else{
			  	  			if(Integer.parseInt(time_start) >= Integer.parseInt(rs.getString("TIME_START_B")) 
		  	  	  				&& Integer.parseInt(time_end) <= Integer.parseInt(rs.getString("TIME_END_B"))){
		  	  	  					allTimeCheck_2 = "Y";
			  	  				}
		  	  			}
		  	  		}
	  	  			
	  			}
  	  		
		  	  	if(!"".equals(parseNull(rs.getString("TIME_START_C")))  ){
			  	  	if("Y".equals(dateDay_3)){
				  	  	if(!"".equals(parseNull(rs.getString("TIME_START_C2")))  ){
			  				if(rs.getString("TIME_END_C").equals(rs.getString("TIME_START_C2"))){		//첫시간과 두번째 시간이 연속 될 때
			  					if(Integer.parseInt(time_start) >= Integer.parseInt(rs.getString("TIME_START_C")) 
		  	  	  				&& Integer.parseInt(time_end) <= Integer.parseInt(rs.getString("TIME_END_C2"))){
		  	  	  					allTimeCheck_3 = "Y";
			  	  				}
			  				}else{
		  	  					if((Integer.parseInt(time_start) >= Integer.parseInt(rs.getString("TIME_START_C")) 
				  	  	  				&& Integer.parseInt(time_end) <= Integer.parseInt(rs.getString("TIME_END_C"))) ||
					  	  	  			(Integer.parseInt(time_start) >= Integer.parseInt(rs.getString("TIME_START_C2")) 
				  	  	  				&& Integer.parseInt(time_end) <= Integer.parseInt(rs.getString("TIME_END_C2")))
			  	  						){
				  	  	  					allTimeCheck_3 = "Y";
			  	  	  				}
			  	  				}
			  			}else{
		  	  				if(Integer.parseInt(time_start) >= Integer.parseInt(rs.getString("TIME_START_C")) 
			  	  				&& Integer.parseInt(time_end) <= Integer.parseInt(rs.getString("TIME_END_C"))){
			  	  					allTimeCheck_3 = "Y";
			  				}
			  			}
			  	  	}
				}
  	  		}
  		}
  		
  		if("Y".equals(dateDay_1) && "Y".equals(allTimeCheck_1)){
  			chk1 = true;
  		}else if("".equals(dateDay_1)){
  			chk1 = true;
  		}else{
  			chk1 = false;
  		}
  		
		if("Y".equals(dateDay_2) && "Y".equals(allTimeCheck_2)){
			chk2 = true;		
		}else if("".equals(dateDay_2)){
  			chk2 = true;
  		}else{
  			chk2 = false;
  		}
		
		if("Y".equals(dateDay_3) && "Y".equals(allTimeCheck_3)){
			chk3 = true;	
		}else if("".equals(dateDay_3)){
  			chk3 = true;
  		}else{
  			chk3 = false;
  		}
		
  		/* if("Y".equals(allTimeCheck_1) || "Y".equals(allTimeCheck_2) || "Y".equals(allTimeCheck_3)){
  			dateCheck = true;
  		} */
  		
  		if(chk1 && chk2 && chk3){
  			dateCheck = true;
  		}
  		
  		boolean check = false;
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
  	    
  	    for (String date : dates) {
  			for(String ob : dateDay){
  				if(ob.equals(getDateDay(date,"yyyy-MM-dd"))){
  					check = true;
  				}				
  			}
  			if(check){
  				check = false;
	  			//사용중인 시간이 있는지 확인
  		  		sql = new StringBuffer();
  		  		//sql.append("SELECT * FROM RESERVE_USE WHERE TIME_START <= ? AND TIME_END >= ? AND ROOM_ID = ?  ");
  		  		sql.append("SELECT * FROM RESERVE_USE WHERE ((TIME_START >= ? AND TIME_START <= ?) OR (TIME_START <= ? AND TIME_END >= ?)) AND ROOM_ID = ? AND DATE_VALUE = ?  ");
  		  		pstmt = conn.prepareStatement(sql.toString());
  		  		pstmt.setString(1, time_start);
  		  		pstmt.setString(2, time_end);
  		  		pstmt.setString(3, time_start);
  		  		pstmt.setString(4, time_start);
  		  		pstmt.setString(5, room_id);
  		  		pstmt.setString(6, date);
  		  		rs = pstmt.executeQuery();
  		  		while(rs.next()){
  		  			if(isInDuration(date_start, date_end, rs.getString("DATE_VALUE"))){
  		  				out.println("DATE_ID : " + rs.getString("DATE_ID") + " ");
  		  		  		out.println(date_start + " ~ ");
  		  		  		out.println(date_end + " ~ ");
  		  		 		out.println(rs.getString("DATE_VALUE") + " " +  date  + " <br>");
  		  		 		out.println("시간 : " + rs.getString("TIME_START") + " ~ " + rs.getString("TIME_END") + "<br>");
  		  		 		useCheck = true;
  		  	  		}
  		  		}
  			}
  	    }
  		
  	  out.println(dateCheck + "<br>");
  	    
  		if(dateCheck && !useCheck){
  			returnVal = "Y";
  		}else{
  			returnVal = "N";
  		}
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