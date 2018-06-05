<%@ include file="/program/class/UtilClass.jsp" %>
<%@ page import="java.text.ParseException"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.text.DateFormat"%>
<%@ page import="java.util.Date"%>
<%!
public String nextDate(String date) throws ParseException {
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	Calendar c = Calendar.getInstance();
	Date d = sdf.parse(date);
	c.setTime(d);
	c.add(Calendar.DATE,3);
	date = sdf.format(c.getTime());
	return date;
}
%>
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
        case 2: day = "평일"; break ;
        case 3: day = "평일"; break ;
        case 4: day = "평일"; break ;
        case 5: day = "평일"; break ;
        case 6: day = "평일"; break ;
        case 7: day = "토"; break ;
    }
    return day ;
}
%>

<%
try{
String adminCheck = "";
String school_id = request.getParameter("school_id");
String getId = sm.getId();
Calendar cal = Calendar.getInstance();
String year = request.getParameter("year")==null?Integer.toString(cal.get(Calendar.YEAR)):request.getParameter("year");   //파라미터가 없으면 현재날짜 가져오기
String month = request.getParameter("month")==null?Integer.toString(cal.get(Calendar.MONTH)+1):request.getParameter("month");
String day = "";
String date = "";
String date2 = "";
String nowDate = Integer.toString(cal.get(Calendar.YEAR)) + "-" + Integer.toString(cal.get(Calendar.MONTH)+1);
if(Integer.parseInt(month) < 10){
	if(month.length()<2){
		month = "0" + month;
	}
}
String nowDate2 = year + "-" + month;

String nowYear = "";
String nowMonth = "";
String nowDay = "";

nowYear = Integer.toString(cal.get(Calendar.YEAR));
if(cal.get(Calendar.MONTH)+1 < 10){
	nowMonth = "0" + Integer.toString(cal.get(Calendar.MONTH)+1);
}else{
	nowMonth = Integer.toString(cal.get(Calendar.MONTH)+1);
}
if(cal.get(Calendar.DATE) < 10){
	nowDay = "0" + Integer.toString(cal.get(Calendar.DATE));
}else{
	nowDay = Integer.toString(cal.get(Calendar.DATE));
}

date2 = nowYear + "-" + nowMonth + "-" + nowDay;

int currentYear = Integer.parseInt(year);
int currentMonth = Integer.parseInt(month) - 1;
cal = Calendar.getInstance();
cal.set(currentYear, currentMonth, 1);
int startNum = cal.get(Calendar.DAY_OF_WEEK);   //선택 월의 시작요일을 구한다.
int lastNum = cal.getActualMaximum(Calendar.DATE);  // 선택 월의 마지막 날짜를 구한다. (2월인경우 28 또는 29일, 나머지는 30일과 31일)
cal.set(Calendar.DATE, lastNum);      // Calendar 객체의 날짜를 마지막 날짜로 변경한다.
int weekNum = cal.get(Calendar.WEEK_OF_MONTH);   // 마지막 날짜가 속한 주가 선택 월의 몇째 주인지 확인한다. 이렇게 하면 선택 월에 주가 몇번 있는지 확인할 수 있다.
int calCnt = weekNum * 7;         // 반복횟수를 정한다
int j = 1;            //날짜를 출력할 변수
boolean reserve_date_check = false;
boolean use_reserve_date_check = false;

String banDateYear = nowYear;
String banDateMonth = nowMonth;
String banDateDay1 = startNum<10?"0"+Integer.toString(startNum):Integer.toString(startNum);
String banDateDay2 = lastNum<10?"0"+Integer.toString(lastNum):Integer.toString(lastNum);
String banDateValue = banDateYear + "-" + banDateMonth + "-" + banDateDay1;
String banDateValue2 = banDateYear + "-" + banDateMonth + "-" + banDateDay2;



Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
List<Map<String, Object>> dataList = null;
List<Map<String, Object>> typeList = null;
List<Map<String, Object>> typeList2 = null;
List<Map<String, Object>> dayList = null;
List<Map<String, Object>> dayList2 = null;
List<Map<String, Object>> banList = null;
List<Map<String, Object>> banList2 = null;

List<Map<String, Object>> useList	= null;

String revReserve_date = parseNull(request.getParameter("reserve_date"));
String revSchool_area = parseNull(request.getParameter("school_area"));
String revReserve_type[] = request.getParameterValues("reserve_type");
String revSchool_name = parseNull(request.getParameter("school_name"));

String school_name = "";
String school_area = "";
String school_addr = "";
String school_tel = "";
String school_url = "";
String charge_dept = "";
String dept_tel = "";
String charge_name = "";
String charge_phone = "";
String account = "";
String area_type = "";

String reserve_type = request.getParameter("reserve_type")==null?"":request.getParameter("reserve_type");
String room_id = "";
String reserve_type2 = parseNull(request.getParameter("reserve_type2"));
String reserve_number = "";
String reserve_area = "";
String reserve_max = "";
String reserve_date = "";
String use_reserve_date = "";
String reserve_etc = "";
String reserve_notice = "";
String save_img = "";
String real_img = "";
String directory = "";
String reserve_use = "";

String reserve_start = "";
String reserve_end = "";
String time1_1 = "";
String time1_2 = "";
String time1_3 = "";
String time1_4 = "";
String time2_1 = "";
String time2_2 = "";
String time2_3 = "";
String time2_4 = "";
String time3_1 = "";
String time3_2 = "";
String time3_3 = "";
String time3_4 = "";
String all_open = "";

String useY_date_id = "";

String useDupCheck = "";

List<Map<String, Object>> dataList2 = null;
List<Map<String, Object>> useAbleList = null;
List<Map<String, Object>> useAbleListBan = null;

String allTime[] = new String[12];

Map<String,Object> typeAmap = null;
List<Map<String,Object>> typeA = new ArrayList<Map<String,Object>>();
Map<String,Object> typeBmap = null;
List<Map<String,Object>> typeB = new ArrayList<Map<String,Object>>();
Map<String,Object> typeCmap = null;
List<Map<String,Object>> typeC = new ArrayList<Map<String,Object>>();
List<String> typeBlist = new ArrayList<String>();
List<String> typeClist = new ArrayList<String>();
Map<String,Object> banMap = null;
List<String> useY = new ArrayList<String>();
List<String> useN = new ArrayList<String>();
List<String> useW = new ArrayList<String>();
List<Map<String,Object>> useBan = new ArrayList<Map<String,Object>>();
List<String> dateList = new ArrayList<String>();
String time[] = {"0600", "0630", "0700", "0730", "0800", "0830", "0900", "0930", "1000", "1030", "1100", "1130", "1200", "1230", "1300", "1330"
		, "1400", "1430", "1500", "1530", "1600", "1630", "1700", "1730", "1800", "1830", "1900", "1930", "2000", "2030", "2100", "2130"
		, "2200", "2230", "2300", "2330", "2400"};
List<String> typeAtime = new ArrayList<String>();
int timeCnt1 = 0;
int timeCnt2 = 0;

boolean allDate = false;

int cnt = 0;
int key = 0;

String nowY = Integer.toString(cal.get(Calendar.YEAR));
String nowM = cal.get(Calendar.MONTH) + 1 < 10 ?"0" + Integer.toString(cal.get(Calendar.MONTH) + 1) : Integer.toString(cal.get(Calendar.MONTH) + 1);
String nowD = "";

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	int n = 0;

	//학교정보
	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_SCHOOL WHERE SCHOOL_ID = ?  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		school_name = parseNull(rs.getString("SCHOOL_NAME"));
		school_area = parseNull(rs.getString("SCHOOL_AREA"));
		school_addr = parseNull(rs.getString("SCHOOL_ADDR"));
		school_tel = parseNull(rs.getString("SCHOOL_TEL"));
		school_url = parseNull(rs.getString("SCHOOL_URL"));
		charge_dept = parseNull(rs.getString("CHARGE_DEPT"));
		dept_tel = parseNull(rs.getString("DEPT_TEL"));
		charge_name = parseNull(rs.getString("CHARGE_NAME"));
		charge_phone = parseNull(rs.getString("CHARGE_PHONE"));
		account = parseNull(rs.getString("ACCOUNT"));
		area_type = parseNull(rs.getString("AREA_TYPE"));
	}
	
	


	//시설 종류
	sql = new StringBuffer();
	sql.append("SELECT RESERVE_TYPE FROM RESERVE_ROOM WHERE SCHOOL_ID = ? AND RESERVE_TYPE2 IS NULL GROUP BY RESERVE_TYPE  ");
	sql.append("ORDER BY DECODE(RESERVE_TYPE, '강당', 1, '운동장', 2, '교실', 3, '기타시설', 4)  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	rs = pstmt.executeQuery();
	typeList = getResultMapRows(rs);
	
	//시설 종류2
	sql = new StringBuffer();
	sql.append("SELECT RESERVE_TYPE2 FROM RESERVE_ROOM WHERE SCHOOL_ID = ? AND RESERVE_TYPE2 IS NOT NULL GROUP BY RESERVE_TYPE2  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	rs = pstmt.executeQuery();
	typeList2 = getResultMapRows(rs);
	

	//페이지 처음 방문 시 선택될 시설 선택
	if("".equals(reserve_type)){
		sql = new StringBuffer();
		sql.append("SELECT ROWNUM AS RNUM, A.* FROM (   ");
		sql.append("	SELECT * FROM RESERVE_ROOM WHERE SCHOOL_ID = ? ORDER BY RESERVE_TYPE  ");
		sql.append(")A WHERE ROWNUM = 1  ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, school_id);
		rs = pstmt.executeQuery();
		if(rs.next()){
			reserve_type = parseNull(rs.getString("RESERVE_TYPE"));
		}
		
		

	}

	//시설정보
	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_ROOM WHERE SCHOOL_ID = ? AND RESERVE_TYPE = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	pstmt.setString(2, reserve_type);
	rs = pstmt.executeQuery();
	if(rs.next()){
		reserve_type = parseNull(rs.getString("RESERVE_TYPE"));
		room_id = parseNull(rs.getString("ROOM_ID"));
		if("".equals(reserve_type2)){
			reserve_type2 = parseNull(rs.getString("RESERVE_TYPE2"));
		}
		reserve_number = parseNull(rs.getString("RESERVE_NUMBER"));
		reserve_area = parseNull(rs.getString("RESERVE_AREA"));
		reserve_max = parseNull(rs.getString("RESERVE_MAX"));
		reserve_etc = parseNull(rs.getString("RESERVE_ETC"));
		reserve_notice = parseNull(rs.getString("RESERVE_NOTICE"));
		save_img = parseNull(rs.getString("SAVE_IMG"));
		real_img = parseNull(rs.getString("REAL_IMG"));
		directory = parseNull(rs.getString("DIRECTORY"));
		reserve_use = parseNull(rs.getString("RESERVE_USE"));
	}
	
	//기타 시설명으로 room_id 검색
	if(!"".equals(reserve_type2)){
		sql = new StringBuffer();
		sql.append("SELECT *  ");
		sql.append("FROM RESERVE_ROOM   ");
		sql.append("WHERE SCHOOL_ID = ? AND RESERVE_TYPE2 = ?  ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, school_id);
		pstmt.setString(2, reserve_type2);
		rs = pstmt.executeQuery();
		if(rs.next()){
			reserve_type = parseNull(rs.getString("RESERVE_TYPE"));
			room_id = parseNull(rs.getString("ROOM_ID"));
			reserve_type2 = parseNull(rs.getString("RESERVE_TYPE2"));
			reserve_number = parseNull(rs.getString("RESERVE_NUMBER"));
			reserve_area = parseNull(rs.getString("RESERVE_AREA"));
			reserve_max = parseNull(rs.getString("RESERVE_MAX"));
			reserve_etc = parseNull(rs.getString("RESERVE_ETC"));
			reserve_notice = parseNull(rs.getString("RESERVE_NOTICE"));
			save_img = parseNull(rs.getString("SAVE_IMG"));
			real_img = parseNull(rs.getString("REAL_IMG"));
			directory = parseNull(rs.getString("DIRECTORY"));
			reserve_use = parseNull(rs.getString("RESERVE_USE"));
		}
	}

	//개방날짜 구하기
	if(!"".equals(reserve_type)){
		sql = new StringBuffer();
		sql.append("SELECT DATE_START, DATE_END, (SELECT RESERVE_TYPE FROM RESERVE_DATE WHERE RESERVE_TYPE = 'A' AND ROOM_ID = RD.ROOM_ID GROUP BY RESERVE_TYPE) ALL_OPEN  ");
		sql.append("FROM RESERVE_DATE RD WHERE SCHOOL_ID = ? AND ROOM_ID = ?  ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, school_id);
		pstmt.setString(2, room_id);
		rs = pstmt.executeQuery();
		if(rs.next()){
			reserve_start = parseNull(rs.getString("DATE_START"));
			reserve_end = parseNull(rs.getString("DATE_END"));
			all_open = parseNull(rs.getString("ALL_OPEN"));
		}
		
		

	}

	//개방시간 구하기
	if(!"".equals(reserve_type)){
		sql = new StringBuffer();
		sql.append("SELECT * FROM RESERVE_DATE WHERE SCHOOL_ID = ? AND ROOM_ID = ?  ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, school_id);
		pstmt.setString(2, room_id);
		rs = pstmt.executeQuery();
		while(rs.next()){
			if(rs.getString("TIME_START_A") != null && !"".equals(rs.getString("TIME_START_A"))){
				time1_1 = timeSet(rs.getString("TIME_START_A"));
				time1_2 = timeSet(rs.getString("TIME_END_A"));
			}
			if(rs.getString("TIME_START_A2") != null && !"".equals(rs.getString("TIME_START_A2"))){
				time1_3 = timeSet(rs.getString("TIME_START_A2"));
				time1_4 = timeSet(rs.getString("TIME_END_A2"));
			}
			
			if(rs.getString("TIME_START_B") != null && !"".equals(rs.getString("TIME_START_B"))){
				time2_1 = timeSet(rs.getString("TIME_START_B"));
				time2_2 = timeSet(rs.getString("TIME_END_B"));
			}
			if(rs.getString("TIME_START_B2") != null && !"".equals(rs.getString("TIME_START_B2"))){
				time2_3 = timeSet(rs.getString("TIME_START_B2"));
				time2_4 = timeSet(rs.getString("TIME_END_B2"));
			}
			
			if(rs.getString("TIME_START_C") != null && !"".equals(rs.getString("TIME_START_C"))){
				time3_1 = timeSet(rs.getString("TIME_START_C"));
				time3_2 = timeSet(rs.getString("TIME_END_C"));
			}
			if(rs.getString("TIME_START_C2") != null && !"".equals(rs.getString("TIME_START_C2"))){
				time3_3 = timeSet(rs.getString("TIME_START_C2"));
				time3_4 = timeSet(rs.getString("TIME_END_C2"));
			}
		}

	}
	
	sql = new StringBuffer();
	//sql.append("SELECT * FROM RESERVE_DATE WHERE RESERVE_TYPE = 'A' AND ROOM_ID = ? ORDER BY DATE_START	");		//항시개방 개방시간
	sql.append("SELECT 												");
	sql.append("  TIME_START_A, TIME_END_A							");
	sql.append("  , TIME_START_A2, TIME_END_A2						");
	sql.append("  , TIME_START_B, TIME_END_B						");
	sql.append("  , TIME_START_B2, TIME_END_B2						");
	sql.append("  , TIME_START_C, TIME_END_C						");
	sql.append("  , TIME_START_C2, TIME_END_C2						");
	sql.append("  , (SELECT DATE_ID 								");
	sql.append("    FROM (SELECT ROWNUM, DATE_ID, CNT FROM (		");
	sql.append("      SELECT DATE_ID, (SELECT COUNT(*) FROM RESERVE_USE WHERE DATE_ID = A.DATE_ID AND DATE_VALUE = ?) CNT		");
	sql.append("      FROM RESERVE_DATE A							");
	sql.append("      WHERE ROOM_ID = ? AND RESERVE_TYPE = 'A'		");
	sql.append("      ORDER BY CNT, DATE_ID )						");
	sql.append("    WHERE ROWNUM <= 1)) AS DATE_ID					");
	sql.append("FROM RESERVE_DATE 									");
	sql.append("WHERE RESERVE_TYPE = 'A' AND ROOM_ID = ? 			");
	sql.append("ORDER BY DATE_START									");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, nowDate2+"-"+nowD);
	pstmt.setString(2, room_id);
	pstmt.setString(3, room_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		allTime[0] 		= parseNull(rs.getString("TIME_START_A"));
		allTime[1] 		= parseNull(rs.getString("TIME_END_A"));
		allTime[2] 		= parseNull(rs.getString("TIME_START_A2"));
		allTime[3] 		= parseNull(rs.getString("TIME_END_A2"));
		allTime[4] 		= parseNull(rs.getString("TIME_START_B"));
		allTime[5] 		= parseNull(rs.getString("TIME_END_B"));
		allTime[6] 		= parseNull(rs.getString("TIME_START_B2"));
		allTime[7] 		= parseNull(rs.getString("TIME_END_B2"));
		allTime[8]		= parseNull(rs.getString("TIME_START_C"));
		allTime[9] 		= parseNull(rs.getString("TIME_END_C"));
		allTime[10] 	= parseNull(rs.getString("TIME_START_C2"));
		allTime[11] 	= parseNull(rs.getString("TIME_END_C2"));
		useY_date_id	= parseNull(rs.getString("DATE_ID"));
		allDate 		= true;
	}
	if(rs!=null)rs.close();
	if(pstmt!=null)pstmt.close();
	
	
	// 사용중인 날짜 구하기
	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_USE WHERE DATE_VALUE = ? AND DATE_ID = ?		");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, nowDate2+"-"+nowD);
	pstmt.setString(2, useY_date_id);
	rs = pstmt.executeQuery();
	useList = getResultMapRows(rs);
	if(rs!=null)rs.close();	if(pstmt!=null)pstmt.close();
	
	sql = new StringBuffer();
	sql.append("SELECT * 									");	// 특정일개방 날짜 및 개방시간
	sql.append("FROM RESERVE_DATE 							");											
	sql.append("WHERE RESERVE_TYPE = 'B' AND ROOM_ID = ? 	");		
	sql.append("	AND TO_CHAR(SYSDATE, 'YYYY-MM-DD') <= DATE_END	");
	sql.append("ORDER BY DATE_ID							");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, room_id);
	rs = pstmt.executeQuery();
	dataList = getResultMapRows(rs);
	if(rs!=null)rs.close();
	if(pstmt!=null)pstmt.close();
	out.println(room_id);
	
	for(int k=1; k<=lastNum; k++){							//항시개방 날짜, 시간 저장
		typeAmap = new HashMap<String, Object>();
		nowD = k<10?"0"+Integer.toString(k):Integer.toString(k);
		typeAmap.put("date_value", nowDate2+"-"+nowD);
		typeAmap.put("time_start_a", allTime[0]);
		typeAmap.put("time_end_a", allTime[1]);
		typeAmap.put("time_start_a2", allTime[2]);
		typeAmap.put("time_end_a2", allTime[3]);
		typeAmap.put("time_start_b", allTime[4]);
		typeAmap.put("time_end_b", allTime[5]);
		typeAmap.put("time_start_b2", allTime[6]);
		typeAmap.put("time_end_b2", allTime[7]);
		typeAmap.put("time_start_c", allTime[8]);
		typeAmap.put("time_end_c", allTime[9]);
		typeAmap.put("time_start_c2", allTime[10]);
		typeAmap.put("time_end_c2", allTime[11]);
		typeA.add(typeAmap);
		
	}
	
	for(int i=0; i<dataList.size(); i++){							//특정일 개방 날짜, 시간 저장
		Map<String,Object> map = dataList.get(i);
		for(int k=1; k<=lastNum; k++){
			nowD = k<10?"0"+Integer.toString(k):Integer.toString(k);
			if(map.get("DATE_START") != null && !"".equals(map.get("DATE_START").toString())){
				if(isInDuration(map.get("DATE_START").toString(), map.get("DATE_END").toString(), nowDate2 + "-" + nowD)){
					typeBmap = new HashMap<String, Object>();
					typeBmap.put("date_value", nowDate2+"-"+nowD);
					if(map.get("TIME_START_A") != null)typeBmap.put("time_start_a", parseNull(map.get("TIME_START_A").toString()));
					if(map.get("TIME_END_A") != null)typeBmap.put("time_end_a", parseNull(map.get("TIME_END_A").toString()));
					if(map.get("TIME_START_A2") != null)typeBmap.put("time_start_a2", parseNull(map.get("TIME_START_A2").toString()));
					if(map.get("TIME_END_A2") != null)typeBmap.put("time_end_a2", parseNull(map.get("TIME_END_A2").toString()));
					if(map.get("TIME_START_B") != null)typeBmap.put("time_start_b", parseNull(map.get("TIME_START_B").toString()));
					if(map.get("TIME_END_B") != null)typeBmap.put("time_end_b", parseNull(map.get("TIME_END_B").toString()));
					if(map.get("TIME_START_B2") != null)typeBmap.put("time_start_b2", parseNull(map.get("TIME_START_B2").toString()));
					if(map.get("TIME_END_B2") != null)typeBmap.put("time_end_b2", parseNull(map.get("TIME_END_B2").toString()));
					if(map.get("TIME_START_C") != null)typeBmap.put("time_start_c", parseNull(map.get("TIME_START_C").toString()));
					if(map.get("TIME_END_C") != null)typeBmap.put("time_end_c", parseNull(map.get("TIME_END_C").toString()));
					if(map.get("TIME_START_C2") != null)typeBmap.put("time_start_c2", parseNull(map.get("TIME_START_C2").toString()));
					if(map.get("TIME_END_C2") != null)typeBmap.put("time_end_c2", parseNull(map.get("TIME_END_C2").toString()));
					typeBlist.add(nowDate2+"-"+nowD);
					typeB.add(typeBmap);
				}
			}
		}
	}
	
	/*********************************************항시개방일 때***************************************************/
	if(allDate){		
		for(Map<String,Object> ob : typeA){		
			timeCnt1 = 0;
			
			for(int i=0; i<time.length; i++){
				if("평일".equals(getDateDay(ob.get("date_value").toString(), "yyyy-MM-dd"))){
					if(ob.get("time_start_a") != null && !"".equals(ob.get("time_start_a"))){
						if(Integer.parseInt(ob.get("time_start_a").toString()) <= Integer.parseInt(time[i]) && 
								Integer.parseInt(ob.get("time_end_a").toString()) >= Integer.parseInt(time[i])){
								timeCnt1++;
							}
					}
					
					if(ob.get("time_start_a2") != null && !"".equals(ob.get("time_start_a2"))){
						if(Integer.parseInt(ob.get("time_start_a2").toString()) <= Integer.parseInt(time[i]) && 
								Integer.parseInt(ob.get("time_end_a2").toString()) >= Integer.parseInt(time[i])){
								timeCnt1++;
							}
					}
					
				}else if("토".equals(getDateDay(ob.get("date_value").toString(), "yyyy-MM-dd"))){
					if(ob.get("time_start_b") != null && !"".equals(ob.get("time_start_b"))){
						if(Integer.parseInt(ob.get("time_start_b").toString()) <= Integer.parseInt(time[i]) && 
								Integer.parseInt(ob.get("time_end_b").toString()) >= Integer.parseInt(time[i])){
								timeCnt1++;
							}
					}
					
					if(ob.get("time_start_b2") != null && !"".equals(ob.get("time_start_b2"))){
						if(Integer.parseInt(ob.get("time_start_b2").toString()) <= Integer.parseInt(time[i]) && 
								Integer.parseInt(ob.get("time_end_b2").toString()) >= Integer.parseInt(time[i])){
								timeCnt1++;
							}
					}
				}else if("일".equals(getDateDay(ob.get("date_value").toString(), "yyyy-MM-dd"))){
					if(ob.get("time_start_c") != null && !"".equals(ob.get("time_start_c"))){
						if(Integer.parseInt(ob.get("time_start_c").toString()) <= Integer.parseInt(time[i]) && 
								Integer.parseInt(ob.get("time_end_c").toString()) >= Integer.parseInt(time[i])){
								timeCnt1++;
							}
					}
					
					if(ob.get("time_start_c2") != null && !"".equals(ob.get("time_start_c2"))){
						if(Integer.parseInt(ob.get("time_start_c2").toString()) <= Integer.parseInt(time[i]) && 
								Integer.parseInt(ob.get("time_end_c2").toString()) >= Integer.parseInt(time[i])){
								timeCnt1++;
							}
					}
				}
			}
			if(!typeBlist.contains(ob.get("date_value").toString())){
				if(useList!=null && useList.size()>0){
					for(Map<String,Object> ob2 : useList){
						if(!useDupCheck.equals(ob.get("date_value").toString())){
							timeCnt2 = 0;	
						}	
						for(int i=0; i<time.length; i++){
							if(Integer.parseInt(ob2.get("TIME_START").toString()) <= Integer.parseInt(time[i]) && 
								Integer.parseInt(ob2.get("TIME_END").toString()) >= Integer.parseInt(time[i])){
								timeCnt2++;
							}
						}
						
						if(timeCnt1 <= timeCnt2+1){
							useY.add(ob.get("date_value").toString());
						}else{
							useW.add(ob.get("date_value").toString());
						}
						useDupCheck = ob.get("date_value").toString();		
					}
				}
				
				if(useY.size() <= 0){
					if("평일".equals(getDateDay(ob.get("date_value").toString(), "yyyy-MM-dd"))){
						if(typeAmap.get("time_start_a") != null && !"".equals(typeAmap.get("time_start_a").toString())){
							useW.add(ob.get("date_value").toString());
						}
						if(typeAmap.get("time_start_a2") != null && !"".equals(typeAmap.get("time_start_a2").toString())){						
							useW.add(ob.get("date_value").toString());
						}
					}
					
					if("토".equals(getDateDay(ob.get("date_value").toString(), "yyyy-MM-dd"))){
						if(typeAmap.get("time_start_b") != null && !"".equals(typeAmap.get("time_start_b").toString())){
							useW.add(ob.get("date_value").toString());
						}
						if(typeAmap.get("time_start_b2") != null && !"".equals(typeAmap.get("time_start_b2").toString())){
							useW.add(ob.get("date_value").toString());
						}
					}
					
					if("일".equals(getDateDay(ob.get("date_value").toString(), "yyyy-MM-dd"))){
						if(typeAmap.get("time_start_c") != null && !"".equals(typeAmap.get("time_start_c").toString())){
							useW.add(ob.get("date_value").toString());
						}
						if(typeAmap.get("time_start_c2") != null && !"".equals(typeAmap.get("time_start_c2").toString())){
							useW.add(ob.get("date_value").toString());
						}
					}
					
				}
				
				if(!dateList.contains(ob.get("date_value").toString())){
					if(ob.get("time_start_a") != null && !"".equals(ob.get("time_start_a"))){
						if("평일".equals(getDateDay(ob.get("date_value").toString(), "yyyy-MM-dd"))){
							useW.add(ob.get("date_value").toString());
						}
					}
					if(ob.get("time_start_b") != null && !"".equals(ob.get("time_start_b"))){
						if("토".equals(getDateDay(ob.get("date_value").toString(), "yyyy-MM-dd"))){
							useW.add(ob.get("date_value").toString());
						}
					}
					if(ob.get("time_start_c") != null && !"".equals(ob.get("time_start_c"))){
						if("일".equals(getDateDay(ob.get("date_value").toString(), "yyyy-MM-dd"))){
							useW.add(ob.get("date_value").toString());
						}
					}
					
				}
			}
		}
	}
	
	/********************************************특정일 개방일 때*************************************************************/
	dateList = new ArrayList<String>();
	for(Map<String,Object> ob : typeB){
		timeCnt1 = 0;
		
		for(int i=0; i<time.length; i++){
			if("평일".equals(getDateDay(ob.get("date_value").toString(), "yyyy-MM-dd"))){
				if(ob.get("time_start_a") != null && !"".equals(ob.get("time_start_a"))){
					if(Integer.parseInt(ob.get("time_start_a").toString()) <= Integer.parseInt(time[i]) && 
							Integer.parseInt(ob.get("time_end_a").toString()) >= Integer.parseInt(time[i])){
							timeCnt1++;
						}
				}
				
				if(ob.get("time_start_a2") != null && !"".equals(ob.get("time_start_a2"))){
					if(Integer.parseInt(ob.get("time_start_a2").toString()) <= Integer.parseInt(time[i]) && 
							Integer.parseInt(ob.get("time_end_a2").toString()) >= Integer.parseInt(time[i])){
							timeCnt1++;
						}
				}
				
			}else if("토".equals(getDateDay(ob.get("date_value").toString(), "yyyy-MM-dd"))){
				if(ob.get("time_start_b") != null && !"".equals(ob.get("time_start_b"))){
					if(Integer.parseInt(ob.get("time_start_b").toString()) <= Integer.parseInt(time[i]) && 
							Integer.parseInt(ob.get("time_end_b").toString()) >= Integer.parseInt(time[i])){
							timeCnt1++;
						}
				}
				
				if(ob.get("time_start_b2") != null && !"".equals(ob.get("time_start_b2"))){
					if(Integer.parseInt(ob.get("time_start_b2").toString()) <= Integer.parseInt(time[i]) && 
							Integer.parseInt(ob.get("time_end_b2").toString()) >= Integer.parseInt(time[i])){
							timeCnt1++;
						}
				}
			}else if("일".equals(getDateDay(ob.get("date_value").toString(), "yyyy-MM-dd"))){
				if(ob.get("time_start_c") != null && !"".equals(ob.get("time_start_c"))){
					if(Integer.parseInt(ob.get("time_start_c").toString()) <= Integer.parseInt(time[i]) && 
							Integer.parseInt(ob.get("time_end_c").toString()) >= Integer.parseInt(time[i])){
							timeCnt1++;
						}
				}
				
				if(ob.get("time_start_c2") != null && !"".equals(ob.get("time_start_c2"))){
					if(Integer.parseInt(ob.get("time_start_c2").toString()) <= Integer.parseInt(time[i]) && 
							Integer.parseInt(ob.get("time_end_c2").toString()) >= Integer.parseInt(time[i])){
							timeCnt1++;
						}
				}
			}
		}
		
		useDupCheck = "";
		if(typeBlist.contains(ob.get("date_value").toString())){
			if(useList!=null && useList.size()>0){
				for(Map<String,Object> ob2 : useList){
					if(!useDupCheck.equals(ob.get("date_value").toString())){
						timeCnt2 = 0;	
					}					
					for(int i=0; i<time.length; i++){
						if(Integer.parseInt(ob2.get("TIME_START").toString()) <= Integer.parseInt(time[i]) && 
							Integer.parseInt(ob2.get("TIME_END").toString()) >= Integer.parseInt(time[i])){
							timeCnt2++;
						}
					}
					
					if(timeCnt1 <= timeCnt2+1){
						useY.add(ob.get("date_value").toString());
					}else{
						useW.add(ob.get("date_value").toString());
					}
					useDupCheck = ob.get("date_value").toString();
					dateList.add(ob.get("date_value").toString());
				}
			}
			
			if(!dateList.contains(ob.get("date_value").toString())){
				if(ob.get("time_start_a") != null && !"".equals(ob.get("time_start_a"))){
					if("평일".equals(getDateDay(ob.get("date_value").toString(), "yyyy-MM-dd"))){
						useW.add(ob.get("date_value").toString());
					}
				}
				if(ob.get("time_start_b") != null && !"".equals(ob.get("time_start_b"))){
					if("토".equals(getDateDay(ob.get("date_value").toString(), "yyyy-MM-dd"))){
						useW.add(ob.get("date_value").toString());
					}
				}
				if(ob.get("time_start_c") != null && !"".equals(ob.get("time_start_c"))){
					if("일".equals(getDateDay(ob.get("date_value").toString(), "yyyy-MM-dd"))){
						useW.add(ob.get("date_value").toString());
					}
				}
				
			}
		}
		
	}
	
	/* //개방불가 리스트
		sql = new StringBuffer();
		sql.append("SELECT * FROM RESERVE_BAN  ");
		sql.append("WHERE ROOM_ID = ? ");
		sql.append("AND ((DATE_START >= ? AND DATE_START <= ?)  ");
		sql.append("OR (DATE_START <= ? AND DATE_END >= ?)  ");
		sql.append("OR (DATE_START <= ? AND DATE_END >= ?)  ");
		sql.append("OR (DATE_START >= ? AND DATE_END <= ?))  ");	
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, room_id);
		pstmt.setString(2, banDateValue);
		pstmt.setString(3, banDateValue2);
		pstmt.setString(4, banDateValue);
		pstmt.setString(5, banDateValue2);
		pstmt.setString(6, banDateValue);
		pstmt.setString(7, banDateValue2);
		pstmt.setString(8, banDateValue);
		pstmt.setString(9, banDateValue2);
		rs = pstmt.executeQuery();
		banList = getResultMapRows(rs); */
		
		//개방불가 리스트2 (날짜만 체크)
		sql = new StringBuffer();
		sql.append("SELECT * FROM RESERVE_BAN  ");
		sql.append("WHERE ROOM_ID = ? AND ((DATE_START >= ? AND DATE_START <= ?) OR (DATE_START <= ? AND DATE_END >= ?))  ");	
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, room_id);
		pstmt.setString(2, nowDate2 + "-" + "01");
		pstmt.setString(3, nowDate2 + "-" + Integer.toString(lastNum));
		pstmt.setString(4, nowDate2 + "-" + "01");
		pstmt.setString(5, nowDate2 + "-" + "01");
		rs = pstmt.executeQuery();
		banList2 = getResultMapRows(rs);
	
	
	
	if(banList!=null && banList.size()>0){
		for(int i=0; i<banList.size(); i++){							//특정일 개방불가 날짜, 시간 저장
			Map<String,Object> map = banList.get(i);
			for(int k=1; k<=lastNum; k++){
				nowD = k<10?"0"+Integer.toString(k):Integer.toString(k);
				if(map.get("DATE_START") != null && !"".equals(map.get("DATE_START").toString())){
					if(isInDuration(map.get("DATE_START").toString(), map.get("DATE_END").toString(), nowDate2 + "-" + nowD)){
						typeCmap = new HashMap<String, Object>();
						typeCmap.put("date_value", nowDate2+"-"+nowD);
						if(map.get("TIME_START_A") != null)typeCmap.put("time_start_a", parseNull(map.get("TIME_START_A").toString()));
						if(map.get("TIME_END_A") != null)typeCmap.put("time_end_a", parseNull(map.get("TIME_END_A").toString()));
						if(map.get("TIME_START_A2") != null)typeCmap.put("time_start_a2", parseNull(map.get("TIME_START_A2").toString()));
						if(map.get("TIME_END_A2") != null)typeCmap.put("time_end_a2", parseNull(map.get("TIME_END_A2").toString()));
						if(map.get("TIME_START_B") != null)typeCmap.put("time_start_b", parseNull(map.get("TIME_START_B").toString()));
						if(map.get("TIME_END_B") != null)typeCmap.put("time_end_b", parseNull(map.get("TIME_END_B").toString()));
						if(map.get("TIME_START_B2") != null)typeCmap.put("time_start_b2", parseNull(map.get("TIME_START_B2").toString()));
						if(map.get("TIME_END_B2") != null)typeCmap.put("time_end_b2", parseNull(map.get("TIME_END_B2").toString()));
						if(map.get("TIME_START_C") != null)typeCmap.put("time_start_c", parseNull(map.get("TIME_START_C").toString()));
						if(map.get("TIME_END_C") != null)typeCmap.put("time_end_c", parseNull(map.get("TIME_END_C").toString()));
						if(map.get("TIME_START_C2") != null)typeCmap.put("time_start_c2", parseNull(map.get("TIME_START_C2").toString()));
						if(map.get("TIME_END_C2") != null)typeCmap.put("time_end_c2", parseNull(map.get("TIME_END_C2").toString()));
						if(map.get("ALL_TIME") != null)typeCmap.put("all_time", parseNull(map.get("ALL_TIME").toString()));
						typeClist.add(nowDate2+"-"+nowD);
						typeC.add(typeCmap);
					}
				}
			}
		}
		
		if(typeC!=null && typeC.size()>0){
			for(Map<String,Object> ob : typeC){
				banMap = new HashMap<String,Object>();
				banMap.put("date_value", ob.get("date_value").toString());
				banMap.put("all_time", ob.get("all_time").toString());
				useBan.add(banMap);
			}
		}
	}
	
	String charge_id = "";
	
	//학교 담당자 아이디 
	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_SCHOOL WHERE SCHOOL_ID = ?  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		charge_id = rs.getString("CHARGE_ID");
	}
	
	if(/* "GRP_000009".equals(sm.getGroupId()) ||*/sm.getId().equals(charge_id) || sm.isRoleSym() ){
		adminCheck = "Y";
	}
	
	//개방일 및 개방시간
	sql = new StringBuffer();
	sql.append("SELECT * 	 ");
	sql.append("FROM RESERVE_DATE	 ");
	sql.append("WHERE SCHOOL_ID = ? AND ROOM_ID = ? AND RESERVE_GROUP = 0 AND ((DATE_END >= ? AND RESERVE_TYPE = 'B') OR RESERVE_TYPE = 'A') 	");
	sql.append("ORDER BY RESERVE_TYPE, DATE_START	 ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	pstmt.setString(2, room_id);
	pstmt.setString(3, date2);
	rs = pstmt.executeQuery();
	useAbleList = getResultMapRows(rs);
	
	//개방불가일 및 개방불가시간
	sql = new StringBuffer();
	sql.append("SELECT * 	 ");
	sql.append("FROM RESERVE_BAN	 ");
	sql.append("WHERE SCHOOL_ID = ? AND ROOM_ID = ? AND DATE_END >= ? 	");
	sql.append("ORDER BY DATE_START	 ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	pstmt.setString(2, room_id);
	pstmt.setString(3, date2);
	rs = pstmt.executeQuery();
	useAbleListBan = getResultMapRows(rs);
	

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
}

%>
<script>
function typeChange(reserve_type){
	$("#reserve_type").val(reserve_type);
	$("#reserve_type2").val("");
	$("#changeForm").submit();
}
function typeChange2(reserve_type2){
	$("#reserve_type2").val(reserve_type2);
	$("#reserve_type").val("기타시설");
	$("#changeForm").submit();
}

function move(cate) {
	var year = $("#changeForm #year").val();
	var month = $("#changeForm #month").val();

	var nowDate;
	nowDate = $("#changeForm #nowDate").val().split("-");
	
	if($("#adminCheck").val() != "Y" && cate == "next" && parseInt(nowDate[1])+1 == parseInt(month)){
		alert("다음달은 선택이 불가능합니다");
	}else if(cate == "pre" && (parseInt(nowDate[1])-1 == parseInt(month) || parseInt(nowDate[1]) == parseInt(month) )){
		alert("이전달은 선택이 불가능합니다.");
	}else{
		var max_month = parseInt(month) + 1;
		var min_month = parseInt(month) - 1;

		if (cate == "next") {
			if (max_month > 12) {
				month = 1
				year++;
			} else {
				month++;
			}
		} else {
			if (min_month < 1) {
				month = 12
				year--;
			} else {
				month--;
			}
		}

		$("#changeForm #year").val(year);
		$("#changeForm #month").val(month);
		$("#changeForm").submit();
	}
}

$(function(){
	$(".day").click(function(){
		id = $(this).attr("id");
		$("#date_value").val(id);

		var getId = $("#getId").val();

		if($.trim(getId) == ""){
			/* var addr = "/index.gne?menuCd=DOM_000001201003001002&school_id="+$("#school_id").val();
			addr += "&room_id="+$("#room_id").val();
			addr += "&reserve_type="+encodeURIComponent($("#reserve_type").val());
			addr += "&reserve_type2="+encodeURIComponent($("#reserve_type2").val());
			addr += "&date_value="+$("#date_value").val();
			addr += "&reserve_number="+$("#reserve_number").val();
			addr += "&year="+$("#year").val();
			addr += "&month="+$("#month").val();
			addr += "&nowDate="+$("#nowDate").val();
			$("#returnUrl").val(addr); */
			$("#changeForm").attr("action", "/index.gne?menuCd=DOM_000000103007007000");
			//$("#changeForm").attr("action", "/index.gne?menuCd=DOM_000000101001000000");	//테스트서버 		
		}else{
			$("#changeForm").attr("action", "/index.gne?menuCd=DOM_000001201003001002");	//로그인 되어있을때 경로	*/
			//$("#changeForm").attr("action", "/index.gne?menuCd=DOM_000000106003001002");	//테스트서버 		
		}

		$("#changeForm").submit();
	});
});


</script>
<form action="/index.gne" method="post" id="loginForm">
</form>

<form action="" method="post" id="changeForm">
<input type="hidden" name="adminCheck" id="adminCheck" value="<%=adminCheck%>">
<input type="hidden" name="getId" id="getId" value="<%=getId%>">
<input type="hidden" name="school_id" id="school_id" value="<%=school_id%>" >
<input type="hidden" name="room_id" id="room_id" value="<%=room_id%>">
<input type="hidden" name="reserve_type" id="reserve_type" value="<%=reserve_type%>">
<input type="hidden" name="reserve_type2" id="reserve_type2" value="<%=reserve_type2%>">
<input type="hidden" name="reserve_date" id="reserve_date">
<input type="hidden" name="date_value" id="date_value">
<input type="hidden" name="reserve_number" id="reserve_number" value="<%=reserve_number%>">
<input type="hidden" name="year" id="year" value="<%=year%>">
<input type="hidden" name="month" id="month" value="<%=month%>">
<input type="hidden" name="nowDate" id="nowDate" value="<%=nowDate%>">
<input type="hidden" name="loginMode" id="loginMode" value="login">
<input type="hidden" name="forwardUrl" id="forwardUrl" value="/index.gne?menuCd=DOM_000001201003001000">	
<input type="hidden" name="returnUrl" id="returnUrl" value="/index.gne?menuCd=DOM_000001201003001000">			
<!-- <input type="hidden" name="forwardUrl" id="forwardUrl" value="/index.gne?menuCd=DOM_000000106003001001">		<!-- 테스트서버 -->		
<!-- <input type="hidden" name="returnUrl" id="returnUrl" value="/index.gne?menuCd=DOM_000000106003001001">				<!-- 테스트서버 -->	

<input type="hidden" name="school_name" id="school_name" value="<%=revSchool_name%>">
<input type="hidden" name="school_area" id="school_area" value="<%=revSchool_area%>">

</form>

<!-- 학교정보 -->
<div class="topbox1 mg_b30 school_info">
	<h3><%=school_name %></h3>
	<h4 class="blind">학교상세정보</h4>
	<ul class="type03 padL14">
		<li>주소 : <%=school_addr %></li>
		<li>전화번호 : 055-<%=telSet(school_tel)%></li>
		<li>홈페이지 : <a href="http://<%=school_url %>" target="_blank"><%=school_url %></a></li>
	</ul>
	<div class="sch_admin topbox2">
		<h4>학교 시설예약 담당자</h4>
		<span><%=charge_dept%></span>	<span><%=charge_name %></span> <span>055-<%=telSet(dept_tel)%></span>
	</div>
</div>
<%
if(!"".equals(room_id)){
%>

<section class="date_select">
	<h3>시설안내</h3>
		<ul class="faci_cate">
		<%
		if(typeList != null && typeList.size()>0){
			String reserve_type_li = "";
			for(int i=0; i<typeList.size(); i++){
				Map<String, Object> map = typeList.get(i);
				reserve_type_li = map.get("RESERVE_TYPE").toString();
		%>
			<li class="tab">
				<a href="#" onclick="typeChange('<%=reserve_type_li%>')" <%if(reserve_type_li.equals(reserve_type)){%> class="on" <%}%> >
					<span><%=reserve_type_li%></span>
				</a>
			</li>
		<%
			}
		}
		%>
		<%
		if(typeList2 != null && typeList2.size()>0){
			String reserve_type_li = "";
			for(int i=0; i<typeList2.size(); i++){
				Map<String, Object> map = typeList2.get(i);
				reserve_type_li = map.get("RESERVE_TYPE2").toString();
		%>
			<li class="tab">
				<a href="#" onclick="typeChange2('<%=reserve_type_li%>')" <%if(reserve_type_li.equals(reserve_type2)){%> class="on" <%}%> >
					<span><%=reserve_type_li%></span>
				</a>
			</li>
		<%
			}
		}
		%>
		</ul>


<div class="faci_detail topbox2 col-12 magB30">
	<div class="thumb item col-5 mo-col-12">
		<img src="<%=directory%><%=save_img%>" alt="학교시설 이미지입니다." onError="this.onerror=null;this.src='/img/school/noimg.png'">

	</div>
	<div class="info item col-7 mo-col-12">
		<table class="tbl_gray">
			<caption> 해당학교의 시설물 상세 내용입니다. </caption>
			<colgroup>
				<col class=""/>
				<col class="wps_20" />
				<col class="wps_20"/>
				<col class="wps_20"/>
				<col class="wps_20"/>
				<col class="wps_20"/>
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">면적</th>
					<td><%=reserve_area %> m&sup2;</td>
					<th scope="row">대여시설 수</th>
					<td><%=reserve_number %> 개</td>
					<th scope="row">이용가능 인원</th>
					<td><%=reserve_max%> 명</td>
				</tr>
				<tr>
					<th scope="row">개방일 및 개방시간</th>
					<td colspan="5">
				<%
				if(useAbleList!=null && useAbleList.size()>0){
					boolean dayCheck1 = false;
					boolean dayCheck2 = false;
					boolean dayCheck3 = false;
				%>
						<ul>
						<%
						for(int i=0; i<useAbleList.size(); i++){
							Map<String,Object> map = useAbleList.get(i);
							
							dayCheck1 = false;
							dayCheck2 = false;
							dayCheck3 = false;
							
							String s1=map.get("DATE_START").toString();
							String s2=map.get("DATE_END").toString();
							DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
							try{
								Date d1 = df.parse( s1 );
								Date d2 = df.parse( s2 );
								Calendar c1 = Calendar.getInstance();
								Calendar c2 = Calendar.getInstance();
								//Calendar 타입으로 변경 add()메소드로 1일씩 추가해 주기위해 변경
								c1.setTime( d1 );
								c2.setTime( d2 );
								while( c1.compareTo( c2 ) !=1 ){
									if("평일".equals(getDateDay(sdf.format(c1.getTime()), "yyyy-MM-dd"))){
										dayCheck1 = true;
									}else if("토".equals(getDateDay(sdf.format(c1.getTime()), "yyyy-MM-dd"))){
										dayCheck2 = true;
									}else if("일".equals(getDateDay(sdf.format(c1.getTime()), "yyyy-MM-dd"))){
										dayCheck3 = true;
									}
									
									//시작날짜 + 1 일
									c1.add(Calendar.DATE, 1);
								}
							}catch(ParseException e){
								e.printStackTrace();
							}
						%>
							<li>
								<%if("".equals( parseNull(map.get("DATE_START").toString()))){%>
									<%
									if(!"".equals( parseNull(map.get("TIME_START_A").toString())) ||
										!"".equals( parseNull(map.get("TIME_START_B").toString()))||
										!"".equals( parseNull(map.get("TIME_START_C").toString()))){%>
										<strong>항시개방</strong>												
									<%
										if(!"".equals( parseNull(map.get("TIME_START_A").toString()))){
											dayCheck1 = true;
										}
										if(!"".equals( parseNull(map.get("TIME_START_B").toString()))){
											dayCheck2 = true;
										}
										if(!"".equals( parseNull(map.get("TIME_START_C").toString()))){
											dayCheck3 = true;
										}
									} %>
									
								<%}else{%>
									<strong><%=map.get("DATE_START").toString()%> ~ <%=map.get("DATE_END").toString() %></strong>
								<%}%>
								
								<%if(!"".equals( parseNull(map.get("TIME_START_A").toString())) && dayCheck1){%>
									<span>평일 : <%=timeSet(map.get("TIME_START_A").toString())%> ~ <%=timeSet(map.get("TIME_END_A").toString()) %>
									<%if(!"".equals( parseNull(map.get("TIME_START_A2").toString()))){%>
									, <%=timeSet(map.get("TIME_START_A2").toString())%> ~ <%=timeSet(map.get("TIME_END_A2").toString()) %>
									<%} %>
									</span>
								<%}%>
								
								<%if(!"".equals( parseNull(map.get("TIME_START_B").toString())) && dayCheck2){%>
									<span>토요일 : <%=timeSet(map.get("TIME_START_B").toString())%> ~ <%=timeSet(map.get("TIME_END_B").toString()) %>
									<%if(!"".equals( parseNull(map.get("TIME_START_B2").toString()))){%>
									, <%=timeSet(map.get("TIME_START_B2").toString())%> ~ <%=timeSet(map.get("TIME_END_B2").toString()) %>
									<%} %>
									</span>
								<%}%>
								
								<%if(!"".equals( parseNull(map.get("TIME_START_C").toString())) && dayCheck3){%>
									<span>일요일 : <%=timeSet(map.get("TIME_START_C").toString())%> ~ <%=timeSet(map.get("TIME_END_C").toString()) %>
									<%if(!"".equals( parseNull(map.get("TIME_START_C2").toString()))){%>
									, <%=timeSet(map.get("TIME_START_C2").toString())%> ~ <%=timeSet(map.get("TIME_END_C2").toString()) %>
									<%} %>
									</span>
								<%}%>
								
							</li>
							<%} %>
						
							<%
							for(int i=0; i<useAbleListBan.size(); i++){
								Map<String,Object> map = useAbleListBan.get(i);
								
								dayCheck1 = false;
								dayCheck2 = false;
								dayCheck3 = false;
								
								String s1=map.get("DATE_START").toString();
								String s2=map.get("DATE_END").toString();
								DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
								SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
								try{
									Date d1 = df.parse( s1 );
									Date d2 = df.parse( s2 );
									Calendar c1 = Calendar.getInstance();
									Calendar c2 = Calendar.getInstance();
									//Calendar 타입으로 변경 add()메소드로 1일씩 추가해 주기위해 변경
									c1.setTime( d1 );
									c2.setTime( d2 );
									while( c1.compareTo( c2 ) !=1 ){
										if("평일".equals(getDateDay(sdf.format(c1.getTime()), "yyyy-MM-dd"))){
											dayCheck1 = true;
										}else if("토".equals(getDateDay(sdf.format(c1.getTime()), "yyyy-MM-dd"))){
											dayCheck2 = true;
										}else if("일".equals(getDateDay(sdf.format(c1.getTime()), "yyyy-MM-dd"))){
											dayCheck3 = true;
										}
										//시작날짜 + 1 일
										c1.add(Calendar.DATE, 1);
									}
								}catch(ParseException e){
									e.printStackTrace();
								}
							%>
								<li>
									<%if("".equals( parseNull(map.get("DATE_START").toString()))){%>
										<%if(!"".equals( parseNull(map.get("TIME_START_A").toString())) ||
											!"".equals( parseNull(map.get("TIME_START_B").toString()))||
											!"".equals( parseNull(map.get("TIME_START_C").toString()))){%>
											<strong>항시개방</strong>												
										<%} %>
										
									<%}else{%>
										<strong><%=map.get("DATE_START").toString()%> ~ <%=map.get("DATE_END").toString() %> (개방불가)</strong>
									<%}%>
									
									<%if(!"".equals( parseNull(map.get("TIME_START_A").toString())) && dayCheck1){%>
										<span>평일 : <%=timeSet(map.get("TIME_START_A").toString())%> ~ <%=timeSet(map.get("TIME_END_A").toString()) %>
										<%if(!"".equals( parseNull(map.get("TIME_START_A2").toString()))){%>
										, <%=timeSet(map.get("TIME_START_A2").toString())%> ~ <%=timeSet(map.get("TIME_END_A2").toString()) %>
										<%} %>
										</span>
									<%}%>
									
									<%if(!"".equals( parseNull(map.get("TIME_START_B").toString())) && dayCheck2){%>
										<span>토요일 : <%=timeSet(map.get("TIME_START_B").toString())%> ~ <%=timeSet(map.get("TIME_END_B").toString()) %>
										<%if(!"".equals( parseNull(map.get("TIME_START_B2").toString()))){%>
										, <%=timeSet(map.get("TIME_START_B2").toString())%> ~ <%=timeSet(map.get("TIME_END_B2").toString()) %>
										<%} %>
										</span>
									<%}%>
									
									<%if(!"".equals( parseNull(map.get("TIME_START_C").toString())) && dayCheck3){%>
										<span>일요일 : <%=timeSet(map.get("TIME_START_C").toString())%> ~ <%=timeSet(map.get("TIME_END_C").toString()) %>
										<%if(!"".equals( parseNull(map.get("TIME_START_C2").toString()))){%>
										, <%=timeSet(map.get("TIME_START_C2").toString())%> ~ <%=timeSet(map.get("TIME_END_C2").toString()) %>
										<%} %>
										</span>
									<%}%>
									
								</li>
								<%} %>
							
						</ul>		
				<%
				}
				%>
					
					</td>
				</tr>
				
				<%-- <tr>
					<th scope="row">개방일</th>
					<td colspan="5"><%if("".equals(reserve_start)){%><%
									if("".equals(time1_1) && "".equals(time2_1) && "".equals(time3_1)){%>
									개방안함
									<%}else{%>
									항시개방
									<%}
								}else{%><%=reserve_start %> ~ <%=reserve_end %><%}%></td>
				</tr>
				<tr>
					<th scope="row">개방시간</th>
					<td colspan="5">
					<%if("".equals(time1_1) && "".equals(time2_1) && "".equals(time3_1)){%>
						개방안함
					<%}else{%>
						<ul class="type04">
							<%if(!"".equals(time1_1)){%><li>평일 : <%=time1_1%> ~ <%=time1_2%>
								<%if(!"".equals(time1_3)){ %>
									, <%=time1_3%> ~ <%=time1_4%>
								<%} %>
							 </li><%}%>
							<%if(!"".equals(time2_1)){%><li>토요일 : <%=time2_1%> ~ <%=time2_2%> 
								<%if(!"".equals(time2_3)){ %>
									, <%=time2_3%> ~ <%=time2_4%>
								<%} %>
							</li><%}%>
							<%if(!"".equals(time3_1)){%><li>일요일 : <%=time3_1%> ~ <%=time3_2%> 
								<%if(!"".equals(time3_3)){ %>
									, <%=time3_3%> ~ <%=time3_4%>
								<%} %>
							</li><%}%>
						</ul>
					<%} %>
					</td>
				</tr> --%>
				<tr>
					<th scope="row">특이사항</th>
					<td colspan="5"><%if("".equals(reserve_etc)){%>내용없음<%}else{%><%=reserve_etc.replace("\r\n", "<br>") %><%}%></td>
				</tr>
				<tr>
					<th scope="row">주의사항</th>
					<td colspan="5"><%if("".equals(reserve_notice)){%>내용없음<%}else{%><%=reserve_notice.replace("\r\n", "<br>") %><%}%></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="clr"> </div>
</div>

<%if(!"".equals(reserve_start) || !"".equals(time1_1) || !"".equals(time2_1) || !"".equals(time3_1) ){%>
<div class="cal">
	<div class="calbtn">
		<a href="#" class="prem" onclick="move('pre')">&lt; 이전달</a> <span><%=year %>.<%=month %></span> <a href="#" class="nextm" onclick="move('next')">다음달 &gt;</a>
	</div>
	<table class="table_skin01 wps_100">
		<caption>온라인예약 달력입니다.</caption>
		<colgroup>
			<col style="width:14.285%" />
			<col style="width:14.285%" />
			<col style="width:14.285%" />
			<col style="width:14.285%" />
			<col style="width:14.285%" />
			<col style="width:14.285%" />
			<col style="width:14.285%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col" class="sun">일</th>
				<th scope="col">월</th>
				<th scope="col">화</th>
				<th scope="col">수</th>
				<th scope="col">목</th>
				<th scope="col">금</th>
				<th scope="col" class="sat">토</th>
			</tr>
		</thead>
		<tbody>

			<%
			String day_of_week = "";
			for (int i = 0; i <= calCnt; i++) {
				if(i%7==1){day_of_week = "(일)";}
				else if(i%7==2){day_of_week = "(월)";}
				else if(i%7==3){day_of_week = "(화)";}
				else if(i%7==4){day_of_week = "(수)";}
				else if(i%7==5){day_of_week = "(목)";}
				else if(i%7==6){day_of_week = "(금)";}
				else if(i%7==0){day_of_week = "(토)";}

				if (i % 7 == 1 || i == 0) {
			%>
				<tr>
			<%
				}
				if (i >= startNum && j <= lastNum) {
					if(i%7==1){
						out.println("<td class='sun'>");
					}else if(i%7==0){
						out.println("<td class='sat'>");
					}else{
			%>
					<td>
			<%
					}
					if(j < 10){
						day = "0" + Integer.toString(j);
					}else{
						day = Integer.toString(j);
					}

					/* 현재날짜와 달력날짜 비교 후 지난 날짜는 출력하지 않는다 */

					date = year + "-" + month + "-" + day;
					
					SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
					Date day1 = null;
					Date day2 = null;

					try{
						day1 = format.parse(nextDate(date2));		//현재날짜  3일 후
						day2 = format.parse(date);		//달력 날짜
					}catch(ParseException e){
						e.printStackTrace();
					}
					
					boolean dayOver = false;

					int compare = day1.compareTo(day2);			//날짜 비교
					if(compare <= 0){							//day1 > day2 : compare=1, day1 < day2 : compare=-1	, day1 = day2 : compare=0
						dayOver = true;
					}
					

					nowD = j<10?"0"+Integer.toString(j):Integer.toString(j);
					
					/* for(Map<String,Object> ob : useBan){
						 for(String ob2 : useW){
							if(ob.get("date_value").toString().equals(ob2)){
								if("Y".equals(ob.get("all_time").toString())){
									useW.remove(ob2);
								}
							}
						} 
					} */
					
					for(Map<String,Object> ob : banList2){			
						if(isInDuration(ob.get("DATE_START").toString(), ob.get("DATE_END").toString(), nowDate2 + "-" + nowD)){
							if("Y".equals(ob.get("ALL_TIME").toString())){
								useN.add(nowDate2 + "-" + nowD);
							}
						}
					}	
					
					if(dayOver){
						if(useN.contains(nowDate2+"-"+nowD)){
							%>
							<span class="dayN" id="<%=date%>" title="예약불가"><%=j%><span>예약불가</span></span>
							<%	
						}else{
							if(useY.contains(nowDate2+"-"+nowD)){
								%>
								<span class="dayY" id="<%=date%>" title="예약완료"><%=j%><span>예약완료</span></span>
								<%
							}else if(useW.contains(nowDate2+"-"+nowD)){
								%>
								<a href="javascript:;" class="day" id="<%=date%>" title="예약가능"><%=j%><span>예약가능</span></a>
								<%
							}else{
								%>
								<span class="dayN" id="<%=date%>" title="예약불가"><%=j%><span>예약불가</span></span>
								<%	
							}
						}
					}else{
						%>
						<span class="dayN" id="<%=date%>" title="예약불가"><%=j%><span>예약불가</span></span>
						<%	
					}
					
					
					
			%>
					</td>
			<%
			j++;
			} else {
					if (i != 0) {
			%>
						<td></td>
			<%
					}
			}
			if (i % 7 == 0) {
			%>
				</tr>
			<%
			}
			}
			%>
				</tbody>
			</table>		
		<%}else{
		%>
			<div class="topbox2 c">시설이 개방되지 않았습니다.</div>
		<%
		}


}else{%>
<div class="topbox2 c">등록한 시설물이 없습니다.</div>
<%} %>
	<div class="c magT15">
	<script>
	function postList(){
		$("#changeForm #reserve_date").val('<%=revReserve_date %>');
		$("#changeForm #school_area").val('<%=revSchool_area %>');
		$("#changeForm #school_name").val('<%=revSchool_name %>');
		
		$("#changeForm #reserve_type").remove();				
		<%
		if(revReserve_type!=null){		
		for(String ob : revReserve_type){
		%>
			$("#changeForm").append("<input type='hidden' name='reserve_type' value='<%=ob%>'>");
		<%}}%>
		
		$("#changeForm").attr("action", "/index.gne?menuCd=DOM_000001201003001000").submit();		//실서버
		//$("#changeForm").attr("action", "/index.gne?menuCd=DOM_000000106003001000").submit();		//테스트서버
	}
	</script>
		<!-- <button type="button" onclick="postList()" class="btn medium edge mako">목록</button>	 -->
		<button type="button" onclick="postList()" class="btn medium edge mako">목록</button>	<!-- 테스트서버 -->
	</div>
</div>
</section>

<%}catch(Exception ef){
	out.println(ef.toString());
}%>