<%@ include file="/program/class/UtilClass.jsp" %>
<%@page import="java.text.DecimalFormat" %>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="java.text.ParseException"%>
<%@ page import="java.text.SimpleDateFormat"%>
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
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

String adminCheck = "";

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
int cnt = weekNum * 7;         // 반복횟수를 정한다
int j = 1;            //날짜를 출력할 변수
int useCnt = 0;

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
List<Map<String, Object>> infoList = null;
List<Map<String, Object>> dataList = null;
List<Map<String, Object>> dataList2 = null;
List<Map<String, Object>> groupList = null;
List<Map<String, Object>> dayList = null;
List<Map<String, Object>> dayList2 = null;
List<Map<String, Object>> optionList = null;
List<Map<String, Object>> priceList = null;
List<Map<String, Object>> etcList = null;
List<Map<String, Object>> roomList = null;
List<Map<String, Object>> banList = null;
List<Map<String, Object>> banList2 = null;

String school_id = parseNull(request.getParameter("school_id"));
String school_name = "";
String room_id = parseNull(request.getParameter("room_id"));
String reserve_start = "";
String reserve_end = "";
String count = parseNull(request.getParameter("count"),"1");
String countVal = parseNull(request.getParameter("countVal"));
if(!"".equals(countVal)){
	count = countVal;
}

int size = 0;
int size2 = 0;
int reserve_number = Integer.parseInt(parseNull(request.getParameter("reserve_number")));
String reserve_group = "";
String reserve_type = parseNull(request.getParameter("reserve_type"));
String reserve_type2 = parseNull(request.getParameter("reserve_type2"));
String reserve_date = parseNull(request.getParameter("reserve_date"));
String area_type = parseNull(request.getParameter("area_type"));
String reserve_max = parseNull(request.getParameter("reserve_max"));
String use_reserve_date = "";


boolean reserve_date_check = false;
boolean use_reserve_date_check = false;
boolean use_time_check = false;
String price_1 = "";
String price_2 = "";
String price_3 = "";
String reserve_group_max = "";

String option_title = "";
String option_price = "";
String option_price_unit = "";

String nowY = Integer.toString(cal.get(Calendar.YEAR));
String nowM = cal.get(Calendar.MONTH) + 1 < 10 ?"0" + Integer.toString(cal.get(Calendar.MONTH) + 1) : Integer.toString(cal.get(Calendar.MONTH) + 1);
String nowD = "";

String date_value = parseNull(request.getParameter("date_value"));

List<Map<String, Object>> dateList3 = null;
List<String> timeUseList = new ArrayList<String>();

String useDupCheck = "";

List<Map<String,Object>> dateList2 = null;
List<String> timeDateList = new ArrayList<String>();
String thisDate = "";
int timeListCnt = 0;
int smallNum = 0;
String smallDate_id = "";
String useDate_id = "";
List<String> countDate_id = new ArrayList<String>();

List<Map<String,Object>> timeUseList0 = new ArrayList<Map<String,Object>>();
List<Map<String,Object>> timeUseMapList = new ArrayList<Map<String,Object>>();
Map<String,Object> timeUseMap = null;
String timeUseList0_date_id = "";
int use_size = 0;
int use_cnt = 0;

String allTime[] = new String[12];

List<String> timeList = new ArrayList<String>();
List<String> timeBanList = new ArrayList<String>();
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

String time[] = {"0000", "0030", "0100", "0130", "0200", "0230", "0300", "0330", "0400", "0430", "0500", "0530"
		, "0600", "0630", "0700", "0730", "0800", "0830", "0900", "0930", "1000", "1030", "1100", "1130", "1200", "1230", "1300", "1330"
		, "1400", "1430", "1500", "1530", "1600", "1630", "1700", "1730", "1800", "1830", "1900", "1930", "2000", "2030", "2100", "2130"
		, "2200", "2230", "2300", "2330", "2400"};
List<String> typeAtime = new ArrayList<String>();

int timeCnt1 = 0;
int timeCnt2 = 0;

String date_id = "";
String all_date_id = "";

boolean allDate = false;
int key = 0;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	int n = 0;

	//시설명으로 room_id 검색
	if(!"".equals(reserve_type)){
		sql = new StringBuffer();
		sql.append("SELECT *  ");
		sql.append("FROM RESERVE_ROOM   ");
		sql.append("WHERE SCHOOL_ID = ? AND RESERVE_TYPE = ?  ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, school_id);
		pstmt.setString(2, reserve_type);
		rs = pstmt.executeQuery();
		if(rs.next()){
			room_id = rs.getString("ROOM_ID");
		}
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
			room_id = rs.getString("ROOM_ID");
		}
	}


	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_DATE WHERE RESERVE_TYPE = 'A' AND ROOM_ID = ? ORDER BY DATE_START	");		//항시개방 개방시간
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, room_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		allTime[0] = parseNull(rs.getString("TIME_START_A"));
		allTime[1] = parseNull(rs.getString("TIME_END_A"));
		allTime[2] = parseNull(rs.getString("TIME_START_A2"));
		allTime[3] = parseNull(rs.getString("TIME_END_A2"));
		allTime[4] = parseNull(rs.getString("TIME_START_B"));
		allTime[5] = parseNull(rs.getString("TIME_END_B"));
		allTime[6] = parseNull(rs.getString("TIME_START_B2"));
		allTime[7] = parseNull(rs.getString("TIME_END_B2"));
		allTime[8] = parseNull(rs.getString("TIME_START_C"));
		allTime[9] = parseNull(rs.getString("TIME_END_C"));
		allTime[10] = parseNull(rs.getString("TIME_START_C2"));
		allTime[11] = parseNull(rs.getString("TIME_END_C2"));
		allDate = true;
	}
	if(rs!=null)rs.close();
	if(pstmt!=null)pstmt.close();

	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_DATE WHERE RESERVE_TYPE = 'B' AND ROOM_ID = ? ORDER BY DATE_ID	");		//특정일개방 날짜 및 개방시간
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, room_id);
	rs = pstmt.executeQuery();
	dataList = getResultMapRows(rs);
	if(rs!=null)rs.close();
	if(pstmt!=null)pstmt.close();

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

				sql = new StringBuffer();
				sql.append("SELECT * FROM RESERVE_USE WHERE DATE_VALUE = ? AND ROOM_ID = ?	");
				pstmt = conn.prepareStatement(sql.toString());
				pstmt.setString(1, ob.get("date_value").toString());
				pstmt.setString(2, room_id);
				rs = pstmt.executeQuery();
				while(rs.next()){
					if(!useDupCheck.equals(ob.get("date_value").toString())){
						timeCnt2 = 0;
					}
					for(int i=0; i<time.length; i++){
						if(Integer.parseInt(rs.getString("TIME_START")) <= Integer.parseInt(time[i]) &&
							Integer.parseInt(rs.getString("TIME_END")) >= Integer.parseInt(time[i])){
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
				if(rs!=null)rs.close();
				if(pstmt!=null)pstmt.close();

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
			sql = new StringBuffer();
			sql.append("SELECT * FROM RESERVE_USE WHERE DATE_VALUE = ? AND ROOM_ID = ? ORDER BY DATE_VALUE	");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, ob.get("date_value").toString());
			pstmt.setString(2, room_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				if(!useDupCheck.equals(ob.get("date_value").toString())){
					timeCnt2 = 0;
				}
				for(int i=0; i<time.length; i++){
					if(Integer.parseInt(rs.getString("TIME_START")) <= Integer.parseInt(time[i]) &&
						Integer.parseInt(rs.getString("TIME_END")) >= Integer.parseInt(time[i])){
						timeCnt2++;
					}
				}

				if(timeCnt1>0 && (timeCnt1 <= timeCnt2)){
					useY.add(ob.get("date_value").toString());
				}else{
					useW.add(ob.get("date_value").toString());
				}

				useDupCheck = ob.get("date_value").toString();

				dateList.add(ob.get("date_value").toString());
			}

			if(rs!=null)rs.close();
			if(pstmt!=null)pstmt.close();

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
	//특정일 개방 date_id 구하기
	sql = new StringBuffer();
	sql.append("SELECT DATE_ID FROM RESERVE_DATE  ");
	sql.append("WHERE DATE_START <= ? AND DATE_END >= ? AND ROOM_ID = ?  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, date_value);
	pstmt.setString(2, date_value);
	pstmt.setString(3, room_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		date_id = parseNull(rs.getString("DATE_ID"));
	}
	if(rs!=null)rs.close();
	if(pstmt!=null)pstmt.close();

	//특정일 개방 사용가능 시간 구하기
	sql = new StringBuffer();
	sql.append("SELECT DATE_START, DATE_END , TIME_START_A, TIME_END_A, TIME_START_A2, TIME_END_A2, TIME_START_B, TIME_END_B, TIME_START_B2, TIME_END_B2, TIME_START_C, TIME_END_C, TIME_START_C2, TIME_END_C2  ");
	sql.append("FROM RESERVE_DATE  ");
	sql.append("WHERE DATE_START <= ? AND DATE_END >= ? AND ROOM_ID = ?  ");
	sql.append("GROUP BY DATE_START, DATE_END, TIME_START_A, TIME_END_A, TIME_START_A2, TIME_END_A2, TIME_START_B, TIME_END_B, TIME_START_B2, TIME_END_B2, TIME_START_C, TIME_END_C, TIME_START_C2, TIME_END_C2  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, date_value);
	pstmt.setString(2, date_value);
	pstmt.setString(3, room_id);
	rs = pstmt.executeQuery();
	dateList2 = getResultMapRows(rs);
	if(rs!=null)rs.close();
	if(pstmt!=null)pstmt.close();

	if(dateList2 !=null && dateList2.size()>0 ){
		for(int i=0; i<dateList2.size(); i++){
			Map<String,Object> map = dateList2.get(i);
			for(int k=0; k<time.length; k++){
				if("평일".equals(getDateDay(date_value, "yyyy-MM-dd"))){
					if(map.get("TIME_START_A") != null && !"".equals(map.get("TIME_START_A"))){
						if(Integer.parseInt(map.get("TIME_START_A").toString()) <= Integer.parseInt(time[k]) &&
							Integer.parseInt(map.get("TIME_END_A").toString()) >= Integer.parseInt(time[k])){
							timeList.add(time[k]);
						}
					}
					if(map.get("TIME_START_A2") != null && !"".equals(map.get("TIME_START_A2"))){
						if(Integer.parseInt(map.get("TIME_START_A2").toString()) <= Integer.parseInt(time[k]) &&
							Integer.parseInt(map.get("TIME_END_A2").toString()) >= Integer.parseInt(time[k])){
							timeList.add(time[k]);
						}
					}

				}else if("토".equals(getDateDay(date_value, "yyyy-MM-dd"))){
					if(map.get("TIME_START_B") != null && !"".equals(map.get("TIME_START_B"))){
						if(Integer.parseInt(map.get("TIME_START_B").toString()) <= Integer.parseInt(time[k]) &&
							Integer.parseInt(map.get("TIME_END_B").toString()) >= Integer.parseInt(time[k])){
							timeList.add(time[k]);
						}
					}

					if(map.get("TIME_START_B2") != null && !"".equals(map.get("TIME_START_B2"))){
						if(Integer.parseInt(map.get("TIME_START_B2").toString()) <= Integer.parseInt(time[k]) &&
							Integer.parseInt(map.get("TIME_END_B2").toString()) >= Integer.parseInt(time[k])){
							timeList.add(time[k]);
						}
					}
				}else if("일".equals(getDateDay(date_value, "yyyy-MM-dd"))){
					if(map.get("TIME_START_C") != null && !"".equals(map.get("TIME_START_C"))){
						if(Integer.parseInt(map.get("TIME_START_C").toString()) <= Integer.parseInt(time[k]) &&
							Integer.parseInt(map.get("TIME_END_C").toString()) >= Integer.parseInt(time[k])){
							timeList.add(time[k]);
						}
					}

					if(map.get("TIME_START_C2") != null && !"".equals(map.get("TIME_START_C2"))){
						if(Integer.parseInt(map.get("TIME_START_C2").toString()) <= Integer.parseInt(time[k]) &&
							Integer.parseInt(map.get("TIME_END_C2").toString()) >= Integer.parseInt(time[k])){
							timeList.add(time[k]);
						}
					}
				}
			}

		}
	}else{
		for(int k=0; k<time.length; k++){
			if("평일".equals(getDateDay(date_value, "yyyy-MM-dd"))){
				if(typeAmap.get("time_start_a") != null && !"".equals(typeAmap.get("time_start_a").toString())){
					if(Integer.parseInt(typeAmap.get("time_start_a").toString()) <= Integer.parseInt(time[k]) &&
						Integer.parseInt(typeAmap.get("time_end_a").toString()) >= Integer.parseInt(time[k])){
						timeList.add(time[k]);
					}
				}
				if(typeAmap.get("time_start_a2") != null && !"".equals(typeAmap.get("time_start_a2").toString())){
					if(Integer.parseInt(typeAmap.get("time_start_a2").toString()) <= Integer.parseInt(time[k]) &&
						Integer.parseInt(typeAmap.get("time_end_a2").toString()) >= Integer.parseInt(time[k])){
						timeList.add(time[k]);
					}
				}
			}else if("토".equals(getDateDay(date_value, "yyyy-MM-dd"))){
				if(typeAmap.get("time_start_b") != null && !"".equals(typeAmap.get("time_start_b").toString())){
					if(Integer.parseInt(typeAmap.get("time_start_b").toString()) <= Integer.parseInt(time[k]) &&
						Integer.parseInt(typeAmap.get("time_end_b").toString()) >= Integer.parseInt(time[k])){
						timeList.add(time[k]);
					}
				}
				if(typeAmap.get("time_start_b2") != null && !"".equals(typeAmap.get("time_start_b2").toString())){
					if(Integer.parseInt(typeAmap.get("time_start_b2").toString()) <= Integer.parseInt(time[k]) &&
						Integer.parseInt(typeAmap.get("time_end_b2").toString()) >= Integer.parseInt(time[k])){
						timeList.add(time[k]);
					}
				}

			}else if("일".equals(getDateDay(date_value, "yyyy-MM-dd"))){
				if(typeAmap.get("time_start_c") != null && !"".equals(typeAmap.get("time_start_c").toString())){
					if(Integer.parseInt(typeAmap.get("time_start_c").toString()) <= Integer.parseInt(time[k]) &&
						Integer.parseInt(typeAmap.get("time_end_c").toString()) >= Integer.parseInt(time[k])){
						timeList.add(time[k]);
					}
				}
				if(typeAmap.get("time_start_c2") != null && !"".equals(typeAmap.get("time_start_c2").toString())){
					if(Integer.parseInt(typeAmap.get("time_start_c2").toString()) <= Integer.parseInt(time[k]) &&
						Integer.parseInt(typeAmap.get("time_end_c2").toString()) >= Integer.parseInt(time[k])){
						timeList.add(time[k]);
					}
				}

			}
		}
	}

	List<String> timeList2 = new ArrayList<String>();

	//해당날짜 사용가능 시간
	sql = new StringBuffer();
	sql.append("SELECT *  ");
	sql.append("FROM RESERVE_DATE  ");
	sql.append("WHERE DATE_START <= ? AND DATE_END >= ? AND ROOM_ID = ? ");
	sql.append("ORDER BY DATE_ID  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, date_value);
	pstmt.setString(2, date_value);
	pstmt.setString(3, room_id);
	rs = pstmt.executeQuery();
	while(rs.next()){
		timeList2 = new ArrayList<String>();
		for(int k=0; k<time.length; k++){
			if("평일".equals(getDateDay(date_value, "yyyy-MM-dd"))){
				if(rs.getString("TIME_START_A") != null && !"".equals(rs.getString("TIME_START_A"))){
					if(Integer.parseInt(rs.getString("TIME_START_A").toString()) <= Integer.parseInt(time[k]) &&
						Integer.parseInt(rs.getString("TIME_END_A").toString()) >= Integer.parseInt(time[k])){
						timeList2.add(time[k]);
					}
				}
				if(rs.getString("TIME_START_A2") != null && !"".equals(rs.getString("TIME_START_A2"))){
					if(Integer.parseInt(rs.getString("TIME_START_A2").toString()) <= Integer.parseInt(time[k]) &&
						Integer.parseInt(rs.getString("TIME_END_A2").toString()) >= Integer.parseInt(time[k])){
						timeList2.add(time[k]);
					}
				}

			}else if("토".equals(getDateDay(date_value, "yyyy-MM-dd"))){
				if(rs.getString("TIME_START_B") != null && !"".equals(rs.getString("TIME_START_B"))){
					if(Integer.parseInt(rs.getString("TIME_START_B").toString()) <= Integer.parseInt(time[k]) &&
						Integer.parseInt(rs.getString("TIME_END_B").toString()) >= Integer.parseInt(time[k])){
						timeList2.add(time[k]);
					}
				}

				if(rs.getString("TIME_START_B2") != null && !"".equals(rs.getString("TIME_START_B2"))){
					if(Integer.parseInt(rs.getString("TIME_START_B2").toString()) <= Integer.parseInt(time[k]) &&
						Integer.parseInt(rs.getString("TIME_END_B2").toString()) >= Integer.parseInt(time[k])){
						timeList2.add(time[k]);
					}
				}
			}else if("일".equals(getDateDay(date_value, "yyyy-MM-dd"))){
				if(rs.getString("TIME_START_C") != null && !"".equals(rs.getString("TIME_START_C"))){
					if(Integer.parseInt(rs.getString("TIME_START_C").toString()) <= Integer.parseInt(time[k]) &&
						Integer.parseInt(rs.getString("TIME_END_C").toString()) >= Integer.parseInt(time[k])){
						timeList2.add(time[k]);
					}
				}

				if(rs.getString("TIME_START_C2") != null && !"".equals(rs.getString("TIME_START_C2"))){
					if(Integer.parseInt(rs.getString("TIME_START_C2").toString()) <= Integer.parseInt(time[k]) &&
						Integer.parseInt(rs.getString("TIME_END_C2").toString()) >= Integer.parseInt(time[k])){
						timeList2.add(time[k]);
					}
				}
			}
		}
	}


	if(allDate){
		key=0;
		sql = new StringBuffer();
		sql.append("SELECT ROWNUM, DATE_ID, CNT FROM (	 ");
		sql.append("	SELECT DATE_ID, (SELECT COUNT(*) FROM RESERVE_USE WHERE DATE_ID = A.DATE_ID AND DATE_VALUE=?) CNT 	 ");
		sql.append("	FROM RESERVE_DATE A 	 ");
		sql.append("	WHERE ROOM_ID = ? AND RESERVE_TYPE = 'A' 	 ");
		sql.append("	ORDER BY CNT, DATE_ID ) 	 ");
		sql.append("WHERE ROWNUM <= ? 	 ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(++key, date_value);
		pstmt.setString(++key, room_id);
		pstmt.setString(++key, count);
	}else{
		key=0;
		sql = new StringBuffer();
		sql.append("SELECT ROWNUM, DATE_ID, CNT FROM (	 ");
		sql.append("	SELECT DATE_ID, (SELECT COUNT(*) FROM RESERVE_USE WHERE DATE_ID = A.DATE_ID AND DATE_VALUE=?) CNT 	 ");
		sql.append("	FROM RESERVE_DATE A 	 ");
		sql.append("	WHERE ROOM_ID = ? AND RESERVE_TYPE = 'B'	 ");
		sql.append("	ORDER BY CNT, DATE_ID ) 	 ");
		sql.append("WHERE ROWNUM <= ? 	 ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(++key, date_value);
		pstmt.setString(++key, room_id);
		pstmt.setString(++key, count);
	}

	rs = pstmt.executeQuery();
	while(rs.next()){
		if(Integer.parseInt(rs.getString("CNT")) == 1){
			useDate_id = rs.getString("date_id");
		}
		countDate_id.add(rs.getString("date_id"));
	}




	//사중중 시간내 가장 적은 시간 쓰는 것 구하기
	sql = new StringBuffer();
	sql.append("SELECT *  ");
	sql.append("FROM RESERVE_USE  ");
	sql.append("WHERE DATE_VALUE = ? AND ROOM_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, date_value);
	pstmt.setString(2, room_id);
	rs = pstmt.executeQuery();
	while(rs.next()){
		use_cnt = 0;
		timeUseMap = new HashMap<String,Object>();
		for(int k=0; k<time.length; k++){
			if(rs.getString("TIME_START") != null && !"".equals(rs.getString("TIME_END"))){
				if(Integer.parseInt(rs.getString("TIME_START").toString()) <= Integer.parseInt(time[k]) &&
					Integer.parseInt(rs.getString("TIME_END").toString()) >= Integer.parseInt(time[k])){
					use_cnt++;
				}
			}
		}
		if(!timeUseList0_date_id.equals(rs.getString("DATE_ID"))){
			use_size = use_cnt;
		}else{
			use_size += use_cnt;
		}

		/* for(Map<String, Object> ob : timeUseMapList ){
			if(ob.get("date_id").equals(rs.getString("date_id"))){
				timeUseMapList.remove(ob);
			}
		}  */

		timeUseMap.put("date_id", rs.getString("date_id"));
		timeUseMap.put("use_size", use_size);
		timeUseMapList.add(timeUseMap);

		timeUseList0_date_id = rs.getString("DATE_ID");

	}

	if(Integer.parseInt(count)>1){
		for(int l=0; l<Integer.parseInt(count); l++){
			//사용중 시간 구하기
			sql = new StringBuffer();
			sql.append("SELECT *  ");
			sql.append("FROM RESERVE_USE  ");
			sql.append("WHERE DATE_VALUE = ? AND DATE_ID = ? AND ROOM_ID = ? ");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, date_value);
			pstmt.setString(2, countDate_id.get(l));
			pstmt.setString(3, room_id);
			rs = pstmt.executeQuery();
			dateList3 = getResultMapRows(rs);
			if(rs!=null)rs.close();
			if(pstmt!=null)pstmt.close();
			for(int i=0; i<dateList3.size(); i++){
				Map<String,Object> map = dateList3.get(i);
				for(int k=0; k<time.length; k++){
					if(map.get("TIME_START") != null && !"".equals(map.get("TIME_END"))){
						if(Integer.parseInt(map.get("TIME_START").toString()) <= Integer.parseInt(time[k]) &&
							Integer.parseInt(map.get("TIME_END").toString()) >= Integer.parseInt(time[k])){
							timeUseList.add(time[k]);
							out.println("<script>console.log('1 : " + time[k] + "');</script>");
						}
					}
				}

			}
			//사용중 시간 구하기(장기예약 포함)
			sql = new StringBuffer();
			sql.append("SELECT *  ");
			sql.append("FROM RESERVE_USE  ");
			sql.append("WHERE DATE_VALUE = ? AND ROOM_ID = ? AND LONG_ID IS NOT NULL");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, date_value);
			pstmt.setString(2, room_id);
			rs = pstmt.executeQuery();
			dateList3 = getResultMapRows(rs);
			if(rs!=null)rs.close();
			if(pstmt!=null)pstmt.close();
			for(int i=0; i<dateList3.size(); i++){
				Map<String,Object> map = dateList3.get(i);
				for(int k=0; k<time.length; k++){
					if(map.get("TIME_START") != null && !"".equals(map.get("TIME_END"))){
						if(Integer.parseInt(map.get("TIME_START").toString()) <= Integer.parseInt(time[k]) &&
							Integer.parseInt(map.get("TIME_END").toString()) >= Integer.parseInt(time[k])){
							timeUseList.add(time[k]);
						}
					}
				}

			}
		}
	}else{
		//사용중 시간 구하기
		sql = new StringBuffer();
		sql.append("SELECT *  ");
		sql.append("FROM RESERVE_USE  ");
		sql.append("WHERE DATE_VALUE = ? AND DATE_ID = ? AND ROOM_ID = ? ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, date_value);
		pstmt.setString(2, useDate_id);
		pstmt.setString(3, room_id);
		rs = pstmt.executeQuery();
		dateList3 = getResultMapRows(rs);
		if(rs!=null)rs.close();
		if(pstmt!=null)pstmt.close();

		for(int i=0; i<dateList3.size(); i++){
			Map<String,Object> map = dateList3.get(i);
			for(int k=0; k<time.length; k++){
				if(map.get("TIME_START") != null && !"".equals(map.get("TIME_END"))){
					if(Integer.parseInt(map.get("TIME_START").toString()) <= Integer.parseInt(time[k]) &&
						Integer.parseInt(map.get("TIME_END").toString()) >= Integer.parseInt(time[k])){
						timeUseList.add(time[k]);
						out.println("<script>console.log('date_id : " + useDate_id + "');</script>");
						out.println("<script>console.log('2 : " + time[k] + "');</script>");
					}
				}
			}

		}

		//사용중 시간 구하기(장기예약 포함)
		sql = new StringBuffer();
		sql.append("SELECT *  ");
		sql.append("FROM RESERVE_USE  ");
		sql.append("WHERE DATE_VALUE = ? AND ROOM_ID = ? AND LONG_ID IS NOT NULL ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, date_value);
		pstmt.setString(2, room_id);
		rs = pstmt.executeQuery();
		dateList3 = getResultMapRows(rs);
		if(rs!=null)rs.close();
		if(pstmt!=null)pstmt.close();

		for(int i=0; i<dateList3.size(); i++){
			Map<String,Object> map = dateList3.get(i);
			for(int k=0; k<time.length; k++){
				if(map.get("TIME_START") != null && !"".equals(map.get("TIME_END"))){
					if(Integer.parseInt(map.get("TIME_START").toString()) <= Integer.parseInt(time[k]) &&
						Integer.parseInt(map.get("TIME_END").toString()) >= Integer.parseInt(time[k])){
						timeUseList.add(time[k]);
					}
				}
			}

		}
	}

	//선택한 시설 정보
	sql = new StringBuffer();
	sql.append("SELECT *  ");
	sql.append("FROM RESERVE_ROOM   ");
	sql.append("WHERE ROOM_ID = ?  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, room_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		reserve_type = rs.getString("RESERVE_TYPE");
		reserve_type2 = rs.getString("RESERVE_TYPE2");
		reserve_max = rs.getString("RESERVE_MAX");
	}


	//시설명 리스트
	sql = new StringBuffer();
	sql.append("SELECT RESERVE_TYPE  ");
	sql.append("FROM RESERVE_ROOM   ");
	sql.append("WHERE SCHOOL_ID = ?   ");
	sql.append("GROUP BY RESERVE_TYPE  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	rs = pstmt.executeQuery();
	roomList = getResultMapRows(rs);



	//기타시설명 리스트
	sql = new StringBuffer();
	sql.append("SELECT RESERVE_TYPE2  ");
	sql.append("FROM RESERVE_ROOM WHERE SCHOOL_ID = ?  AND RESERVE_TYPE2 IS NOT NULL  ");
	sql.append("GROUP BY RESERVE_TYPE2  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	rs = pstmt.executeQuery();
	etcList = getResultMapRows(rs);

	//해당 시설의 옵션 리스트
	sql = new StringBuffer();
	sql.append("SELECT *  ");
	sql.append("FROM RESERVE_OPTION   ");
	sql.append("WHERE ROOM_ID = ?  ");
	sql.append("ORDER BY OPTION_ID ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, room_id);
	rs = pstmt.executeQuery();
	optionList = getResultMapRows(rs);



	//시설 가격
	if("기타시설".equals(reserve_type)){
		sql = new StringBuffer();
		sql.append("SELECT *  ");
		sql.append("FROM RESERVE_ROOM   ");
		sql.append("WHERE ROOM_ID = ?  ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, room_id);
		rs = pstmt.executeQuery();
		priceList = getResultMapRows(rs);


	}else{
		//군읍면인지 확인
		sql = new StringBuffer();
		sql.append("SELECT RS.AREA_TYPE, RS.SCHOOL_NAME  ");
		sql.append("FROM RESERVE_ROOM RR LEFT JOIN RESERVE_SCHOOL RS ON RR.SCHOOL_ID = RS.SCHOOL_ID  ");
		sql.append("WHERE RR.ROOM_ID = ?  ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, room_id);
		rs = pstmt.executeQuery();
		if(rs.next()){
			area_type = rs.getString("AREA_TYPE");
			school_name = rs.getString("SCHOOL_NAME");
		}
		if(pstmt!=null){pstmt.close();}
		

		sql = new StringBuffer();
		sql.append("SELECT RESERVE_TYPE, PRICE_1, PRICE_2, PRICE_3, AREA_TYPE  ");
		sql.append("FROM RESERVE_PRICE WHERE RESERVE_TYPE = ?  ");
		if("N".equals(area_type)){
			sql.append("AND AREA_TYPE = 'N'  ");
		}else if("Y".equals(area_type)){
			sql.append("AND AREA_TYPE = 'Y'  ");
		}
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, reserve_type);
		rs = pstmt.executeQuery();
		priceList = getResultMapRows(rs);
	}

	//사용교실 수 최대 개수
	sql = new StringBuffer();
	sql.append("SELECT RESERVE_NUMBER FROM RESERVE_ROOM WHERE ROOM_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, room_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		reserve_number = Integer.parseInt(rs.getString("RESERVE_NUMBER"));
	}

	//개방불가 리스트
	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_BAN  ");
	sql.append("WHERE ROOM_ID = ? AND DATE_START <= ? AND DATE_END >= ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, room_id);
	pstmt.setString(2, date_value);
	pstmt.setString(3, date_value);
	rs = pstmt.executeQuery();
	banList = getResultMapRows(rs);

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

	if(banList !=null && banList.size()>0 ){
		for(int i=0; i<banList.size(); i++){
			Map<String,Object> map = banList.get(i);
			for(int k=0; k<time.length; k++){
				if("평일".equals(getDateDay(date_value, "yyyy-MM-dd"))){
					if(map.get("TIME_START_A") != null && !"".equals(map.get("TIME_START_A"))){
						if(Integer.parseInt(map.get("TIME_START_A").toString()) <= Integer.parseInt(time[k]) &&
							Integer.parseInt(map.get("TIME_END_A").toString()) >= Integer.parseInt(time[k])){
							timeBanList.add(time[k]);
						}
					}
					if(map.get("TIME_START_A2") != null && !"".equals(map.get("TIME_START_A2"))){
						if(Integer.parseInt(map.get("TIME_START_A2").toString()) <= Integer.parseInt(time[k]) &&
							Integer.parseInt(map.get("TIME_END_A2").toString()) >= Integer.parseInt(time[k])){
							timeBanList.add(time[k]);
						}
					}

				}else if("토".equals(getDateDay(date_value, "yyyy-MM-dd"))){
					if(map.get("TIME_START_B") != null && !"".equals(map.get("TIME_START_B"))){
						if(Integer.parseInt(map.get("TIME_START_B").toString()) <= Integer.parseInt(time[k]) &&
							Integer.parseInt(map.get("TIME_END_B").toString()) >= Integer.parseInt(time[k])){
							timeBanList.add(time[k]);
						}
					}

					if(map.get("TIME_START_B2") != null && !"".equals(map.get("TIME_START_B2"))){
						if(Integer.parseInt(map.get("TIME_START_B2").toString()) <= Integer.parseInt(time[k]) &&
							Integer.parseInt(map.get("TIME_END_B2").toString()) >= Integer.parseInt(time[k])){
							timeBanList.add(time[k]);
						}
					}
				}else if("일".equals(getDateDay(date_value, "yyyy-MM-dd"))){
					if(map.get("TIME_START_C") != null && !"".equals(map.get("TIME_START_C"))){
						if(Integer.parseInt(map.get("TIME_START_C").toString()) <= Integer.parseInt(time[k]) &&
							Integer.parseInt(map.get("TIME_END_C").toString()) >= Integer.parseInt(time[k])){
							timeBanList.add(time[k]);
						}
					}

					if(map.get("TIME_START_C2") != null && !"".equals(map.get("TIME_START_C2"))){
						if(Integer.parseInt(map.get("TIME_START_C2").toString()) <= Integer.parseInt(time[k]) &&
							Integer.parseInt(map.get("TIME_END_C2").toString()) >= Integer.parseInt(time[k])){
							timeBanList.add(time[k]);
						}
					}
				}
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
}

%>
<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
<script>
$(function() {
	var maxDate = "+1M";
	var minDate = $("#date_value").val();
	$.datepicker.regional['kr'] = {
		    closeText: '닫기', // 닫기 버튼 텍스트 변경
		    currentText: '오늘', // 오늘 텍스트 변경
		    monthNames: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
		    monthNamesShort: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
		    dayNames: ['월요일','화요일','수요일','목요일','금요일','토요일','일요일'], // 요일 텍스트 설정
		    minDate: minDate,
		    maxDate: maxDate,
		    dayNamesShort: ['월','화','수','목','금','토','일'], // 요일 텍스트 축약 설정
		    dayNamesMin: ['월','화','수','목','금','토','일'] // 요일 최소 축약 텍스트 설정
		};
	$.datepicker.setDefaults($.datepicker.regional['kr']);
	  $( "#date_start" ).datepicker({
	    dateFormat: 'yy-mm-dd'
	  });
	  $( "#date_end" ).datepicker({
	    dateFormat: 'yy-mm-dd'
	  });
});
</script>

<script>
function countTest(){
	$("#postForm").submit();
}

$(function(){
	$("#date_start").click(function(){
		$("#dayCheck").val("N");
	});
	$("#date_end").click(function(){
		$("#dayCheck").val("N");
	});

	$(".time_value").click(function(){
		$("#dayCheck").val("N");
		if($("#date_start").val() == ""){
			alert("시작날짜를 선택하여 주시기 바랍니다.");
			return false;
		}else if($("#date_end").val() == ""){
			alert("종료날짜를 선택하여 주시기 바랍니다.");
			return false;
		}else{
			var length = $("input[name=time_value]:checked").length;

			if(length > 2){
				alert("시작시간과 종료시간만 체크해 주시기 바랍니다.");
				return false;
			}

			var first;
			var last;
			var cnt = 0;;
			var firstId;
			var lastId;

			$("input[name=time_value]:checked").each(function() {
				if(cnt == 0){
					first = $(this).val();
					firstId = $(this).attr("id");
				}
				last = $(this).val();
				lastId = $(this).attr("id");
				cnt = 1;
			});

			for(var i=parseInt(firstId); i<=parseInt(lastId); i++){
				if($(".time_sel #"+i).prop("disabled")){
					$(".time_value").removeAttr("checked");
					break;
				}
			}


			var room_id = $("#room_id").val();
			var count = $("#count").val();

			if(first!=last){
				var str = {
						"room_id" : room_id,
						"count" : count,
						"first" : first,
						"last" : last,
						"date_value" : $("#postForm #date_value").val()
					}
					$.ajax({
						url : '/program/school_reserve/timeCheck.jsp',
						data : str,
						success : function(data) {
							var returnVal = data.trim();
							if(returnVal == "Y") {
								alert("예약 불가");
								$(".time_value").removeAttr("checked");
								$("#total_price2").html("0");
								$("#total_price").val("0");
							}else if(returnVal =="N"){
								if(first != last){
									cal_price(first, last);
								}
								//alert("예약가능");
							}else{
								$(".time_value").removeAttr("checked");
								$("#total_price2").html("0");
								$("#total_price").val("0");
								//alert("오류발생");
							}
						},
						error : function(e) {
							alert("에러발생");
							$(".time_value").removeAttr("checked");
							$("#total_price2").html("0");
							$("#total_price").val("0");
						}
					});
			}

			if(first==last){
				$("#total_price2").html("0");
				$("#total_price").val("0");
			}
		}

	});

	$(".dateCheck").change(function(){
		var first;
		var last;
		var cnt = 0;;

		$("input[name=time_value]:checked").each(function() {
			if(cnt == 0){
				first = $(this).val();
			}
			last = $(this).val();
			cnt = 1;
		});
		cal_price(first, last);
	});

	$("#dateCheck").click(function(){
		var first;
		var last;
		var cnt = 0;;

		$("input[name=time_value]:checked").each(function() {
			if(cnt == 0){
				first = $(this).val();
			}
			last = $(this).val();
			cnt = 1;
		});
		cal_price(first, last);
		var length = $("input[name=time_value]:checked").length;

		var stDate = new Date($("#date_start").val()) ;
		var endDate = new Date($("#date_end").val()) ;
		var btMs = endDate.getTime() - stDate.getTime() ;
		var btDay = btMs / (1000*60*60*24) ;


		if($("#date_start").val() == ""){
			alert("시작날짜를 선택하여 주시기 바랍니다.");
			return false;
		}else if($("#date_end").val() == ""){
			alert("종료날짜를 선택하여 주시기 바랍니다.");
			return false;
		}else if(btDay>7){
			alert("7일 이상 예약은 불가능합니다.");
			$("#date_end").focus();
			return false;
		}
		else if(first == null){
			alert("시작시간을 선택하여 주시기 바랍니다.");
			return false;
		}else if(length<2){
			alert("종료시간을 선택하여 주시기 바랍니다.");
			return false;
		}
		else{
			var school_id 		= $("#school_id").val();
            var reserve_type 	= $("#reserve_type").val();
            var reserve_type2 	= $("#reserve_type2").val();
            var date_start 		= $("#date_start").val();
            var date_end 		= $("#date_end").val();
            var time_start 		= first;
            var time_end 		= last;
            var count 			= $("#count").val();
            
            console.log("school_id" 	+ school_id + "\n" +            		 
                    "reserve_type"	+ reserve_type + "\n" +
                    "reserve_type2"	+ reserve_type2 + "\n" +
                    "date_start" 	+ date_start + "\n" +
                    "date_end" 		+ date_end + "\n" +
                    "time_start" 	+ time_start + "\n" +
                    "time_end" 		+ time_end + "\n" +
                    "count" 		+ count);

			var str = {
					"school_id" 	: school_id,
                    "reserve_type"	: reserve_type,
                    "reserve_type2"	: reserve_type2,
                    "date_start" 	: date_start,
                    "date_end" 		: date_end,
                    "time_start" 	: time_start,
                    "time_end" 		: time_end,
                    "count" 		: count
			};

			$.ajaxSettings.traditional = true
			$.ajax({
				url : '/program/school_reserve/dateCheck.jsp',
				data : str,
				success : function(data) {
					var returnVal = data.trim();
					if(returnVal == "N") {
						$("#dayCheck").val("N");
						alert("예약 불가");
					}else if(returnVal =="Y"){
						$("#dayCheck").val("Y");
						alert("예약가능");
					}
				},
				error : function(e) {
					alert("에러발생");
				}
			});
		}
	});

	$(".day").click(function(){
		/* var test = $("#calDay").html();
		var cnt = $("#calDay .date").length;
		var id = $(this).attr("id");
		var id2;
		var value;

		for(var i=0; i<cnt; i++){
			id2 = $("#calDay .date").eq(i).val();
			if(id == id2){
				alert("선택한 날짜는 이미 선택되어있습니다");
				return false;
			}
		}

		value = test + "<li><span id='cnt"+cnt+"'><input type='checkbox' class='date'  name='date' value='" + id + "'' style='display:none;' checked='checked' >" + id;
		if(cnt != 0){
			value += "<span onclick='dateDel(\"cnt" + cnt + "\")' class='btn edge small mako'>삭제</span></span></li>";
		}

		$("#calDay").html(value); */
		$("#postForm #date_value").val($(this).attr("id"));
		$("#postForm").attr("action", "");
		$("#postForm").submit();

	});

	$("input[name=option]").click(function(){
		var first;
		var last;
		var cnt = 0;;

		$("input[name=time_value]:checked").each(function() {
			if(cnt == 0){
				first = $(this).val();
			}
			last = $(this).val();
			cnt = 1;
		});

		cal_price(first, last);
	});


	$("#user_phone").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") );} );
	$("#reserve_man").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") );} );
});



function cal_price(first, last){
	var stDate = new Date($("#date_start").val()) ;
	var endDate = new Date($("#date_end").val()) ;
	var btMs = endDate.getTime() - stDate.getTime() ;
	var btDay = btMs / (1000*60*60*24) ;

	var arr = [
			  "0000", "0030", "0100", "0130", "0200", "0230", "0300", "0330", "0400", "0430", "0500", "0530"
	        , "0600", "0630", "0700", "0730", "0800", "0830", "0900", "0930", "1000", "1030", "1100", "1130", "1200"
			, "1230", "1300", "1330", "1400", "1430", "1500", "1530", "1600", "1630", "1700", "1730", "1800", "1830", "1900"
			, "1930", "2000", "2030", "2100", "2130", "2200", "2230", "2300", "2330", "2400"];
	var cnt = 0;
	var dateCnt = 0;
	for(var i=0; i<arr.length; i++){
		if(parseInt(first) <= parseInt(arr[i]) && parseInt(last) >= parseInt(arr[i])){
			cnt++;
		}
	}

	var price;
	var count = $("#count").val();

	if(cnt<=5){
		price = $("#price_1").val();
	}else if(cnt>5 && cnt<=9){
		price = $("#price_2").val();
	}else if(cnt>9){
		price = $("#price_3").val();
	}

	price = parseInt(price) * parseInt(count);
	var addPrice = 0;

	/* $("input[name=date]:checked").each(function() {
		dateCnt++;
	}); */

	dateCnt = btDay+1;

	$("input[name=option]:checked").each(function() {
		if($(this).attr("class") == "unit_a"){
			addPrice += parseInt($(this).val());
		}else{
			addPrice += parseInt(price) * (parseInt($(this).val())/100);
		}

	});

	price = (parseInt(price) + parseInt(addPrice)) * parseInt(dateCnt);

	var cnt = 0;
	$("input[name=time_value]:checked").each(function() {
		cnt++;
	});

	if(cnt==0){
		price = 0;
	}

	price = moneySet(price);

	$("#total_price2").html(price);
	$("#total_price").val(price);

}
function moneySet(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
function dateConfirm(){
	var cnt = 0;
	var id;
	var value = "";

	$("input[name=date_check]:checked").each(function() {
		id = $(this).val();
		value += "<li><span id='cnt"+cnt+"'><input type='checkbox' class='date'  name='date' value='" + id + "' style='display:none;' checked='checked' >" + id;
		if(cnt != 0){
		//value += "<span onclick='dateDel(\"cnt" + cnt + "\")'>삭제</span>";
		}
		value += "</span></li>";
		cnt++;
	});


	$("#postForm #dayCheck").val("Y");
	$("#calDay").html(value);
	$("#checkDiv").html("");
	$("#myModal").css("display", "none");

	var first;
	var last;
	var cnt = 0;;

	$("input[name=time_value]:checked").each(function() {
		if(cnt == 0){
			first = $(this).val();
		}
		last = $(this).val();
		cnt = 1;
	});

	cal_price(first, last);

}

function dateDel(test){
	$("#calDay #"+test).parents("li").remove();
	//$("#calDay #"+test).remove();
}

function formPost(){
		var stDate = new Date($("#date_start").val()) ;
		var endDate = new Date($("#date_end").val()) ;
		var btMs = endDate.getTime() - stDate.getTime() ;
		var btDay = btMs / (1000*60*60*24) ;

		var cnt = btDay+1;
		var cnt2 = 0;
		$("input[name=date]:checked").each(function() {
			cnt++;
		});
		$("input[name=time_value]:checked").each(function() {
			cnt2++;
		});

		for(var i=0; i<$("input[name=option]").length; i++){
			if($("#option_"+i).is(":checked")){
				$("#optionVal_"+i).attr("checked", "checked");
			}else{
				$("#optionVal_"+i).removeAttr("checked");
			}
		}

		if(cnt <= 0){
			alert("날짜를 선택하여 주시기 바랍니다");
			return false;
		}else if(cnt2 <= 0){
			alert("시간을 선택하여 주시기 바랍니다");
			return false;
		}

		if(cnt2 < 2){
			alert("예약 시작시간과 종료시간을 선택하여주시기 바랍니다.");
		}else if(btDay>7){
			alert("7일 이상 예약은 불가능합니다.");
			$("#date_end").focus();
			return false;
		}else if(cnt>1 && $("#dayCheck").val()=="N"){
			alert("예약가능시간 확인을 하여 주시기 바랍니다.");
			return false;
		}else if($.trim($("#user_name").val()) == ""){
			alert("예약자명을 입력하여 주시기 바랍니다.");
			$("#user_name").focus();
			return false;
		}else if($.trim($("#user_phone").val()) == ""){
			$("#user_phone").focus();
			alert("휴대폰번호를 입력하여 주시기 바랍니다.");
			return false;
		}
		else if($.trim($("#reserve_man").val()) == ""){
			$("#reserve_man").focus();
			alert("사용인원을 입력하여 주시기 바랍니다.");
			return false;
		}
		else if(parseInt($("#reserve_man").val()) > parseInt($("#reserve_max").val()) ){
			alert("사용인원이 최대사용인원보다 많습니다.");
			return false;
		}
		else if($.trim($("#use_purpose").val()) == ""){
			$("#use_purpose").focus();
			alert("사용목적을 입력하여 주시기 바랍니다.");
			return false;
		}else if(!$("input[name=pInfoChk]").is(":checked")){
			alert("개인정보 수집 및 이용에 동의하여주시기 바랍니다.");
			return false;
		}else if(!$("input[name=pInfoChk_2]").is(":checked")){
			alert("안전사고책임확약서에 동의하여주시기 바랍니다.");
			return false;
		}else{
			if(confirm("예약하시겠습니까?")){
				$("#postForm").attr("action", "/program/school_reserve/action.jsp");
				$("#postForm").submit();
			}else{
				return false;
			}
		}


}

function move(cate) {
	var year = $("#postForm #year").val();
	var month = $("#postForm #month").val();

	var nowDate;
	nowDate = $("#postForm #nowDate").val().split("-");

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

		$("#postForm #year").val(year);
		$("#postForm #month").val(month);
		$("#postForm").submit();
	}
}
</script>
<!-- 이용자 정보 입력 시작  -->
<form action="" method="post" id="postForm" class="booking">
<input type="hidden" name="adminCheck" id="adminCheck" value="<%=adminCheck%>">
<input type="hidden" name="school_id" id="school_id" value="<%=school_id%>" >
<input type="hidden" name="room_id" id="room_id" value="<%=room_id%>" >
<input type="hidden" name="dayCheck" id="dayCheck" value="N">
<input type="hidden" name="reserve_number" id="reserve_number" value="<%=reserve_number%>">
<input type="hidden" name="reserve_date" id="reserve_date" value="<%=reserve_date%>" >
<input type="hidden" name="date_value" id="date_value" value="<%=date_value%>">
<input type="hidden" name="timeCheck" id="timeCheck" value="N">
<input type="hidden" name="time_first" id="time_first">
<input type="hidden" name="time_last" id="time_last">
<input type="hidden" name="year" id="year" value="<%=year%>">
<input type="hidden" name="month" id="month" value="<%=month%>">
<input type="hidden" name="nowDate" id="nowDate" value="<%=nowDate%>">
<input type="hidden" name="count" id="count" value="<%=count%>">

<%
String user_account = "";
String dupInfo = (String)session.getAttribute("dupInfo")==null?"":(String)session.getAttribute("dupInfo");
String phoneDi = (String)session.getAttribute("phoneDi")==null?"":(String)session.getAttribute("phoneDi");

if("".equals(sm.getId())){
	if(!"".equals(dupInfo)){
		user_account = dupInfo;
	}else if(!"".equals(phoneDi)){
		user_account = phoneDi;
	}

}else{
	user_account = sm.getId();
}

%>
<input type="hidden" name="user_account" id="user_account" value="<%=user_account%>">
<input type="hidden" name="reserve_max" id="reserve_max" value="<%=reserve_max%>">
<section class="sec1 topbox3">
	<h3 class="blind">시설구분</h3>
	<p class="kind"><%=school_name%></p>
	<p class="kind">
		<%-- <label>시설명
			<select id="reserve_type" name="reserve_type" onchange="countTest()">
			<%
			if(roomList != null){
				String reserve_type_2 = "";
				for(int i=0; i<roomList.size(); i++){
					Map<String,Object> map = roomList.get(i);
					reserve_type_2 = map.get("RESERVE_TYPE").toString();
				%>
					<option value="<%=reserve_type_2 %>" <%if(reserve_type_2.equals(reserve_type)){ %>selected="selected" <%}%> ><%=reserve_type_2 %></option>
				<%
				}
			}
			%>
			</select>
		</label> --%>
		<label>시설명
			<select id="reserve_type" name="reserve_type" onchange="countTest()">
				<option value="<%=reserve_type %>"><%=reserve_type %></option>
			</select>
		</label>
	</p>
	<%if("기타시설".equals(reserve_type)){ %>
	<p class="kind">
		<label>기타시설 명
		<select id="reserve_type2" name="reserve_type2" onchange="countTest()">
		<%
		if(etcList != null && etcList.size() > 0){
		String reserve_type2_2 = "";
			for(int i=0; i<etcList.size(); i++){
			Map<String,Object> map = etcList.get(i);
			reserve_type2_2 = map.get("RESERVE_TYPE2").toString();
			%>
				<option value="<%=reserve_type2_2%>"  <%if(reserve_type2_2.equals(reserve_type2)){%> selected="selected" <%}%> ><%=reserve_type2_2%> </option>
			<%}
		} %>
		</select>
	</label>
	<%}else{%>
	<p class="kind">
		<label>
			사용시설 수
			<select name="countVal" id="countVal" onchange="countTest()">
			<%for(int i=1; i<=reserve_number; i++){ %>
				<option value="<%=i%>"  <%if(i == Integer.parseInt(count)){%> selected="selected" <%}%> ><%=i%></option>
			<%} %>
			</select>
		</label>
	</p>
	<%}%>
</section>

<section class="sec2 topbox2">
	<h3 class="title">사용일자</h3>
	<!-- <span class="red subscript">* 날짜 다중선택이 가능합니다.</span> -->
		<div class="datesel item col-5 mo-col-12">
			<ul id="calDay" class="type03">
				<%-- <li>
					<span id="cnt0">
						<label><input type="checkbox" class="date" name="date" value="<%=reserve_date %>" style="display:none;" checked="checked"><%=date_value %></label>
					</span>
				</li> --%>
				<li>
					시작날짜 : <input type="text" name="date_start" id="date_start" class="dateCheck" readonly="readonly" value="<%=date_value%>">
				</li>
				<li>
					종료날짜 : <input type="text" name="date_end" id="date_end" class="dateCheck" readonly="readonly" value="<%=date_value%>">
				</li>
			</ul>
			<ul id="checkDiv">
			</ul>
		</div>
		<div class="cal item col-7 mo-col-12">
			<div class="calbtn">
				<a href="#" class="prem" onclick="move('pre')">&lt; 이전달</a> <span><%=year %>.<%=month %></span> <a href="#" class="nextm" onclick="move('next')">다음달 &gt;</a>
			</div>
			<table class="table_skin01">
				<caption>온라인예약입니다.</caption>
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
			for (int i = 0; i <= cnt; i++) {
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




					/* for(Map<String,Object> ob : banList2){
						for(String ob2 : useW ){
							if(ob.get("date_value").toString().equals(ob2)){
								if("Y".equals(ob.get("all_time").toString())){
									//useW.remove(ob2);
									useN.add(ob2);
								}
							}
						}
					}	 */

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
		</div>
		<div class="clr"> </div>
	<!-- 모달 윈도우  -->
	<div id="myModal" class="modal" style="display: none;">
		<!-- Modal content -->
		<div class="modal_content">
	  	<p class="modal_top">예약가능 시간 확인 <a class="btn_cancel" id="modalClose" style="cursor:pointer;"><img src="/img/school/layer_close2.png" alt="닫기"></a></p>
			<div class="" id="checkDiv">
				<table class="tb_board">
					<caption>선택한 날짜의 예약 가능여부 확인 표입니다.</caption>
					<colgroup>
						<col />
						<col />
						<col />
						<col />
					</colgroup>
					<thead>
						<th scope="col">일자</th>
						<th scope="col">시간</th>
						<th scope="col">가능여부</th>
						<th scope="col">선택</th>
					</thead>
					<tbody>
						<tr>
							<td>2017-09-12</td>
							<td>12:00 ~ 13:00</td>
							<td><span class="green">예약가능</span><!-- span class="red">예약불가능</span--></td>
							<td><label><input type="checkbox" name="date_check" id="check_1" value=""></label></td>
						</tr>
					</tbody>
				</table>
				<div class="c">
					<button type="button" class="btn edge small darkMblue" onclick='dateConfirm()'>확인</button>
				</div>
			</div>
		</div>
	</div>
	<script>
	var modal = document.getElementById('myModal');
	var btn = document.getElementById("myBtn");
	var modalClose = document.getElementById("modalClose");

	function ori_image(path) {
		var path_split = path.split("/");
		path = path_split[0] + "/" + path_split[1] + "/" + path_split[2] + "/" + path_split[3] + "/" + path_split[5];
		$(".modal_content img").eq(1).attr("src", path);
	    modal.style.display = "block";
	}

	modalClose.onclick = function () {
	    modal.style.display = "none";
	}
	window.onclick = function (event) {
	    if (event.target == modal) {
	        modal.style.display = "none";
	    }
	}
</script>
	<!-- //모달 윈도우 끝 -->

</section>
<!-- // 달력 끝 -->

<%
if(countDate_id != null && countDate_id.size() > 0){
	for(int i=0; i<Integer.parseInt(count); i++){
	%>
		<input type="checkbox" name="date_id" checked="checked" value="<%=countDate_id.get(i)%>" style="display: none;">
	<%
	}
}
%>

<!-- 예약시간 선택 -->
<section class="sec3 topbox3">
	<h3 class="title"> 예약시간 선택</h3>
	<span class="red subscript">* 시작시간과 종료시간을 선택하세요.</span>
	<div class="time_sel">
	<%
int timeCnt = 0;
boolean timeBanCheck = false;
boolean timeBanCheck2 = false;
boolean timeUseCheck = false;
int timeId = 0;
for(String ob : time){
	for(int i=0; i<timeList.size(); i++){		//개방중인 시간 구하기
		if(ob.equals(timeList.get(i))){
			timeUseCheck = true;
		}
	}
	for(int i=0; i<timeUseList.size(); i++){	//사용중인 시간 구하기
		if(ob.equals(timeUseList.get(i))){
			timeBanCheck = true;
		}
	}
	for(int i=0; i<timeBanList.size(); i++){	//개방금지된 시간 구하기
		if(ob.equals(timeBanList.get(i))){
			timeBanCheck2 = true;
		}
	}

	if(timeUseCheck){
		timeUseCheck = false;
		if(timeBanCheck){
			timeBanCheck = false;
		%>
		<label class="disabled"><input type="checkbox" class="time_value" name="time_value" id="<%=timeId++%>" value="<%=ob%>" disabled="disabled" >
					<%=timeSet(ob)%> <span class="on">사용중</span></label>
		<%
		}else if(timeBanCheck2){
			timeBanCheck2 = false;
		%>
		<label class="disabled"><input type="checkbox" class="time_value" name="time_value" id="<%=timeId++%>" value="<%=ob%>" disabled="disabled"><%=timeSet(ob)%></label>
		<%
		}else{
		%>
		<label class="able"><input type="checkbox" value="<%=ob%>" class="time_value" id="<%=timeId++%>" name="time_value"><%=timeSet(ob)%></label>
		<%
		}
	}else{
%>
<label class="disabled"><input type="checkbox" class="time_value" name="time_value" id="<%=timeId++%>" value="<%=ob%>" disabled="disabled"><%=timeSet(ob)%></label>
<%
	}
}
%>


		<div class="clr"> </div>
		<div class="c magT20">
				<button type="button" class="btn edge medium mako" id="dateCheck">예약가능시간 확인</button>
		</div>
	</div>
</section>

<!-- 옵션선택 -->
<%
if(optionList != null && optionList.size()>0){
%>
<section class="sec4 topbox2">
	<h3 class="title">옵션선택</h3>
	<div class="topbox3">
		<%
			String option_class = "";
			for(int i=0; i<optionList.size(); i++){
				Map<String,Object> map = optionList.get(i);
				option_title = map.get("OPTION_TITLE").toString();
				option_price = map.get("OPTION_PRICE").toString();
				option_price_unit = map.get("OPTION_PRICE_UNIT").toString();

				if("？".equals(option_price_unit)){
					option_class = "unit_a";
				}else{
					option_class = "unit_b";
				}
		%>
				<label>
					<input type="checkbox" name="option" value="<%=option_price%>" id="option_<%=i%>" class="<%=option_class%>"><%=option_title %> 사용
					<%if("？".equals(option_price_unit)){%>
						(사용금액에서 <%=option_price%>원이 가산됩니다.)
					<%}else{ %>
						(사용금액의 <%=option_price%>%가 가산됩니다.)
					<%}%>
				</label>
				<label><input type="checkbox" name="optionVal" value="<%=option_title%>" id="optionVal_<%=i%>" style="display: none;"></label>
		<%
			}
		%>
	</div>
</section>
<%} %>
<!-- 사용금액 -->
<section class="sec5 topbox2">
	<h3 class="title">사용금액</h3>
	<%
	if(priceList != null){
		if("기타시설".equals(reserve_type)){
			for(int i=0; i<priceList.size(); i++){
				Map<String,Object> map = priceList.get(i);
				price_1 = map.get("ETC_PRICE1").toString();
				price_2 = map.get("ETC_PRICE2").toString();
				price_3 = map.get("ETC_PRICE3").toString();
			%>
			<input type="hidden" name="price_1" id="price_1" value="<%=price_1%>">
			<input type="hidden" name="price_2" id="price_2" value="<%=price_2%>">
			<input type="hidden" name="price_3" id="price_3" value="<%=price_3%>">
			<%
			}
		}else{
			for(int i=0; i<priceList.size(); i++){
				Map<String,Object> map = priceList.get(i);
				price_1 = map.get("PRICE_1").toString();
				price_2 = map.get("PRICE_2").toString();
				price_3 = map.get("PRICE_3").toString();
			%>
			<input type="hidden" name="price_1" id="price_1" value="<%=price_1%>">
			<input type="hidden" name="price_2" id="price_2" value="<%=price_2%>">
			<input type="hidden" name="price_3" id="price_3" value="<%=price_3%>">
			<%
			}
		}
	}
	%>
	<div class="topbox3">
		<span id="total_price2">0</span> 원
		<input type="hidden" name="total_price" id="total_price" value="0">
	</div>
</section>

<!-- 사용유형 -->
<section class="sec6 topbox2">
	<h3 class="title">사용유형</h3>
	<div class="topbox3">
		<label for="useType">
		<select name="use_type" id="useType" class="wps_100">
			<option value="지역주민의 복지증진 및 생활체육 활동">지역주민의 복지증진 및 생활체육 활동</option>
			<option value="공인기관의 어학시험, 자격시험 등 고사장 제공 및 기업체 등의 체육행사 및 기타 활동">공인기관의 어학시험, 자격시험 등 고사장 제공 및 기업체 등의 체육행사 및 기타 활동</option>
		</select>
	</label>
	</div>
</section>

<!-- 예약자 정보 -->
<section class="sec7 topbox1">
	<h3 class="title"> 예약자 정보 </h3>
	<table class="table_skin01 txt_l">
		<caption> 예약자명, 사용단체명, 휴대폰번호, 사용인원, 사용목적 등을 기입하는 예약자 정보 입력표입니다. </caption>
		<colgroup>
			<col class="wps_20" />
			<col />
			<col class="wps_20" />
			<col class="wps_25"/>
		</colgroup>
		<tbody>
			<tr>
				<th scope="row"><span class="red">&#42;</span> 예약자명</th>
				<td><label><span class="mo_tit"><span class="red">&#42;</span> 예약자명</span>
					<input type="text" class="wps_80" name="user_name" id="user_name" value="<%=sm.getName()%>" <%if(!"Y".equals(adminCheck)){%>readonly="readonly"<%}%>>
				</label></td>
				<th scope="row">사용단체명</th>
				<td><label><span class="mo_tit">사용단체명</span><input type="text" class="wps_100" name="organ_name" id="organ_name"></label> </td>
			</tr>
			<tr>
				<th scope="row"><span class="red">&#42;</span> 휴대폰번호</th>
				<td><label><span class="mo_tit"><span class="red">&#42;</span> 휴대폰번호</span><input type="text" class="wps_80" name="user_phone" id="user_phone"></label>
					<p class="fontsmall magT5">&#8251; 진행상태를 문자로 알려드립니다. 연락가능한 휴대전화번호를 <u class="red">숫자만</u> 정확히 기재하세요.</p>
				</td>
				<th scope="row"><span class="red">&#42;</span> 사용인원</label></th>
				<td>
					<label for="reserve_man"><span class="mo_tit"><span class="red">&#42;</span> 사용인원</span>
					<input type="text" class="wps_80" name="reserve_man" id="reserve_man">
					</label>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="red">&#42;</span> 사용목적</th>
				<td colspan="3">
					<label><span class="mo_tit"><span class="red">&#42;</span> 사용목적</span>
					<textarea class="wps_90 h050" name="use_purpose" id="use_purpose"></textarea>
					</label>
				</td>
			</tr>
		</tbody>
	</table>
</section>

<section class="sec8 topbox2">
	<h3 class="title">개인정보 수집 및 이용 동의</h3>
	<label>
	<textarea name="" cols="" rows="" id="policy" class="wps_90 h050 list_select mT10 fsize_90">1. 개인정보의 수집 목적 우리 기관은 개인정보를 다음의 목적을 위해 처리합니다. 처리한 개인정보는 다음의 목적 이외의 용도로는 사용되지 않으며, 이용목적이 변경될 시에는 별도 공지를 할 예정입니다.
- 학교 시설 예약 신청 및 확인

※ 개인정보 수집 및 이용에 대하여 동의를 원하지 않을 경우 동의를 거부할 수 있으며, 본 서비스 이용 시 일부 메뉴 사용에 제한이 있을 수 있음을 알려드립니다.

2. 수집하는 개인정보의 항목
우리 기관은 본 서비스에서 아래와 같은 개인정보를 수집하고 있습니다.
- 예약자명, 전화번호

3. 개인정보의 보유 및 이용기간
이용자의 개인정보는 2년간 보유되며 기간이 만료되면 지체 없이 파기됩니다.
	</textarea>
	</label>
	<p class="magT10"><label><input name="pInfoChk" type="checkbox" value="Y"> 개인정보 수집 및 이용에 대한 안내를 이해하였으며 동의합니다.</label></p>
</section>

<section class="sec8 topbox2">
	<h3 class="title">안전사고책임확약서</h3>
	<label>
	<textarea name="" cols="" rows="" id="policy" class="wps_90 h050 list_select mT10 fsize_90">경상남도 각급학교 내 교통안전을 위한 조례(2016.6.9.)에 의거 귀교의 시설물을 사용 신청함에 있어 신청인(사용자 전원)은 학교 내에서 교통사고 등 안전사고가 발생하지 않도록 주의에 최선을 다할 것이며, 교통사고 등 안전사고 발생시 사고에 대한 민,형사상의 모든 책임을 지고 피해 보상의 의무를 다할 것을 확약하며 시설물 사용 허가를 신청합니다.
	</textarea>
	</label>
	<p class="magT10"><label><input name="pInfoChk_2" type="checkbox" value="Y"> 안전사고책임확약서에 대한 안내를 이해하였으며 동의합니다.</label></p>
</section>



<div class="c magT30">
	<button type="button" class="btn edge medium darkMblue" onclick="formPost()">예약하기</button>
	<button type="button" class="btn edge medium white" onclick="location.href='/index.gne?menuCd=DOM_000001201003001000'">취소하기</button>
</div>
</form>