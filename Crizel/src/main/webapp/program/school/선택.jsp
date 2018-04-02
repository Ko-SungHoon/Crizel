<%@ include file="/program/class/UtilClass.jsp" %>
<%@ page import="java.text.ParseException"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.text.DateFormat"%>
<%@ page import="java.util.Date"%>
<%
try{
%>
<%!
private class ReserveVO{
	//reserve_school
	public int school_id;
	public String school_name;
	public String school_area;
	public String school_addr;
	public String school_tel;
	public String school_url;
	public String charge_dept;
	public String dept_tel;
	public String charge_name;
	public String charge_phone;
	public String account;
	public String area_type;
	public String charge_id;
	public String school_approval;
	public String sch_approval_date;
	public String charge_name2;
	
	//reserve_room
	public int room_id;
	public String reserve_type;
	public String reserve_type2;
	public int reserve_number;
	public String reserve_area;
	public int reserve_max;
	public String reserve_etc;
	public String reserve_notice;
	public String save_img;
	public String real_img;
	public String directory;
	public String reserve_use;
	public String etc_price1;
	public String etc_price2;
	public String etc_price3;
	
	//reserve_date
	public int date_id;
	public String date_start;
	public String date_end;
	public String time_start_a;
	public String time_end_a;
	public String time_start_a2;
	public String time_end_a2;
	public String time_start_b;
	public String time_end_b;
	public String time_start_b2;
	public String time_end_b2;
	public String time_start_c;
	public String time_end_c;
	public String time_start_c2;
	public String time_end_c2;
	public String register_date;
	public String reserve_group;
	public String reserve_ban;
	public String open_comment;
	
	//reserve_use;
	public int use_id;
	public int user_id;
	public String date_value;
	public String time_start;
	public String time_end;
	public int long_id;
	
	public int time_a;
	public int time_b;
	public int time_c;
	
	public int time_ban_a;
	public int time_ban_b;
	public int time_ban_c;
	
	public int cnt;
	
	
}

private class SchoolInfo implements RowMapper<ReserveVO> {
    public ReserveVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ReserveVO vo = new ReserveVO();
        vo.school_name			=	rs.getString("SCHOOL_NAME")==null?"":rs.getString("SCHOOL_NAME");
        vo.school_addr			=	rs.getString("SCHOOL_ADDR")==null?"":rs.getString("SCHOOL_ADDR");
        vo.school_tel			=	rs.getString("SCHOOL_TEL")==null?"":rs.getString("SCHOOL_TEL");
        vo.school_url			=	rs.getString("SCHOOL_URL")==null?"":rs.getString("SCHOOL_URL");
        vo.charge_dept			=	rs.getString("CHARGE_DEPT")==null?"":rs.getString("CHARGE_DEPT");
        vo.dept_tel				=	rs.getString("DEPT_TEL")==null?"":rs.getString("DEPT_TEL");
        vo.charge_name			=	rs.getString("CHARGE_NAME")==null?"":rs.getString("CHARGE_NAME");
        return vo;
    }
}

private class RoomList implements RowMapper<ReserveVO> {
    public ReserveVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ReserveVO vo = new ReserveVO();
    	vo.room_id				=	rs.getInt("ROOM_ID");
        vo.reserve_type			=	rs.getString("RESERVE_TYPE")==null?"":rs.getString("RESERVE_TYPE");
        return vo;
    }
}

private class RoomInfo implements RowMapper<ReserveVO> {
    public ReserveVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ReserveVO vo = new ReserveVO();
    	vo.directory				=	rs.getString("DIRECTORY")==null?"":rs.getString("DIRECTORY");
        vo.save_img					=	rs.getString("SAVE_IMG")==null?"":rs.getString("SAVE_IMG");
        vo.reserve_area				=	rs.getString("RESERVE_AREA")==null?"":rs.getString("RESERVE_AREA");
        vo.reserve_number			=	rs.getInt("RESERVE_NUMBER");
        vo.reserve_max				=	rs.getInt("RESERVE_MAX");
        
        return vo;
    }
}

private class TimeList implements RowMapper<ReserveVO> {
    public ReserveVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ReserveVO vo = new ReserveVO();
    	vo.date_start				=	rs.getString("date_start")==null?"":rs.getString("date_start");
        vo.date_end					=	rs.getString("date_end")==null?"":rs.getString("date_end");
        vo.time_start_a				=	rs.getString("time_start_a")==null?"":rs.getString("time_start_a");
        vo.time_end_a				=	rs.getString("time_end_a")==null?"":rs.getString("time_end_a");
        vo.time_start_a2			=	rs.getString("time_start_a2")==null?"":rs.getString("time_start_a2");
        vo.time_end_a2				=	rs.getString("time_end_a2")==null?"":rs.getString("time_end_a2");
        vo.time_start_b				=	rs.getString("time_start_b")==null?"":rs.getString("time_start_b");
        vo.time_end_b				=	rs.getString("time_end_b")==null?"":rs.getString("time_end_b");
        vo.time_start_b2			=	rs.getString("time_start_b2")==null?"":rs.getString("time_start_b2");
        vo.time_end_b2				=	rs.getString("time_end_b2")==null?"":rs.getString("time_end_b2");
        vo.time_start_c				=	rs.getString("time_start_c")==null?"":rs.getString("time_start_c");
        vo.time_end_c				=	rs.getString("time_end_c")==null?"":rs.getString("time_end_c");
        vo.time_start_c2			=	rs.getString("time_start_c2")==null?"":rs.getString("time_start_c2");
        vo.time_end_c2				=	rs.getString("time_end_c2")==null?"":rs.getString("time_end_c2");
        
        return vo;
    }
}

private class TimeCnt implements RowMapper<ReserveVO> {
    public ReserveVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ReserveVO vo = new ReserveVO();
    	vo.time_a				=	rs.getInt("TIME_A");
    	vo.time_b				=	rs.getInt("TIME_B");
    	vo.time_c				=	rs.getInt("TIME_C");
        return vo;
    }
}

private class TimeBanCnt implements RowMapper<ReserveVO> {
    public ReserveVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ReserveVO vo = new ReserveVO();
    	vo.date_start				=	rs.getString("DATE_START");
    	vo.date_end					=	rs.getString("DATE_END");
    	vo.time_ban_a				=	rs.getInt("TIME_BAN_A");
    	vo.time_ban_b				=	rs.getInt("TIME_BAN_B");
    	vo.time_ban_c				=	rs.getInt("TIME_BAN_C");
        return vo;
    }
}

private class UseTimeList implements RowMapper<ReserveVO> {
    public ReserveVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ReserveVO vo = new ReserveVO();
    	vo.date_value			=	rs.getString("DATE_VALUE")==null?"":rs.getString("DATE_VALUE");
        vo.cnt					=	rs.getInt("CNT") + rs.getInt("CNT2");
        return vo;
    }
}

public String nextDate(String date) throws ParseException {
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	Calendar c = Calendar.getInstance();
	Date d = sdf.parse(date);
	c.setTime(d);
	c.add(Calendar.DATE,3);
	date = sdf.format(c.getTime());
	return date;
}
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
String listPage 				= "DOM_000000118001001000";		//테스트서버
String infoPage					= "DOM_000000118001002000";		//테스트서버
String reservePage				= "DOM_000000118001003000";		//테스트서버
String loginPage				= "DOM_000000101001000000";		//테스트서버

String adminCheck = "";

if("GRP_000009".equals(sm.getGroupId()) || sm.isRole("ROLE_000006") || sm.isRoleSym() ){
	adminCheck = "Y";
}

String menuCd					= parseNull(request.getParameter("menuCd"));
String school_id 				= parseNull(request.getParameter("school_id"));
String room_id 					= parseNull(request.getParameter("room_id"));
String search_reserve_date		= parseNull(request.getParameter("reserve_date"));
String search_school_area		= parseNull(request.getParameter("school_area"));
String search_school_name		= parseNull(request.getParameter("school_name"));
String[] search_reserve_type	= request.getParameterValues("reserve_type");
String date_id					= "";
String useAbleCheck				= "";
String strDayVal 				= "";
String dayValue 				= "";
int time_ban_a					= 0;
int time_ban_b					= 0;
int time_ban_c					= 0;

StringBuffer sql 				= null;
ReserveVO schoolInfo 			= null;
List<ReserveVO> roomList 		= null;
ReserveVO roomInfo				= null;
List<ReserveVO> timeList1		= null;
List<ReserveVO> timeList2		= null;
List<ReserveVO> timeList3		= null;
ReserveVO timeCnt				= null;
List<ReserveVO> timeBanCnt		= null;
List<ReserveVO> useTimeList		= null;
Map<String,Object> useTimeMap	= new HashMap<String,Object>();

Calendar cal 		= Calendar.getInstance();
String year 		= request.getParameter("year")==null?Integer.toString(cal.get(Calendar.YEAR)):request.getParameter("year");   //파라미터가 없으면 현재날짜 가져오기
String month 		= request.getParameter("month")==null?Integer.toString(cal.get(Calendar.MONTH)+1):request.getParameter("month");
String day 			= Integer.toString(cal.get(Calendar.DATE));
int currentYear 	= Integer.parseInt(year);
int currentMonth 	= Integer.parseInt(month) - 1;
String nowDate 		= Integer.toString(cal.get(Calendar.YEAR)) + "-" + Integer.toString(cal.get(Calendar.MONTH)+1);
String nowDateFull	= Integer.toString(cal.get(Calendar.YEAR)) + "-" + Integer.toString(cal.get(Calendar.MONTH)+1) + "-" + Integer.toString(cal.get(Calendar.DATE));
cal 				= Calendar.getInstance();
cal.set(currentYear, currentMonth, 1);
int startNum 		= cal.get(Calendar.DAY_OF_WEEK);   			// 선택 월의 시작요일을 구한다.
int lastNum 		= cal.getActualMaximum(Calendar.DATE);  	// 선택 월의 마지막 날짜를 구한다. (2월인경우 28 또는 29일, 나머지는 30일과 31일)
cal.set(Calendar.DATE, lastNum);      							// Calendar 객체의 날짜를 마지막 날짜로 변경한다.
int weekNum 		= cal.get(Calendar.WEEK_OF_MONTH);			// 마지막 날짜가 속한 주가 선택 월의 몇째 주인지 확인한다. 이렇게 하면 선택 월에 주가 몇번 있는지 확인할 수 있다.
int calCnt 			= weekNum * 7;        						// 반복횟수를 정한다
int dayVal 			= 1;            							// 날짜를 출력할 변수
int dayValCheck 	= 0;

String strYear 		= year;											// 연도 문자열
String strMonth 	= Integer.parseInt(month)<10?"0"+month:month;	// 월 문자열
String strDay 		= Integer.toString(lastNum);					// 월 마지막 일 문자열
String strNowDay  	= Integer.parseInt(day)<10?"0"+day:day;			// 현재 일 문자열
String strDate		= strYear + "-" + strMonth + "-" + strNowDay;

String first_day 	= strYear + "-" + strMonth + "-01";
String last_day 	= strYear + "-" + strMonth + "-" + strDay;

try{
	sql = new StringBuffer();
	sql.append("SELECT 							");
	sql.append("	SCHOOL_NAME,				");
	sql.append("	SCHOOL_ADDR,				");
	sql.append("	SCHOOL_TEL,					");
	sql.append("	SCHOOL_URL,					");
	sql.append("	CHARGE_DEPT,				");
	sql.append("	DEPT_TEL,					");
	sql.append("	CHARGE_NAME					");
	sql.append("FROM RESERVE_SCHOOL				");
	sql.append("WHERE SCHOOL_ID = ?				");
	
	try{
		schoolInfo = jdbcTemplate.queryForObject(sql.toString(), new SchoolInfo(), new Object[]{school_id});
	}catch(Exception e){
		schoolInfo = null;
	}
	
	sql = new StringBuffer();
	sql.append("SELECT 																							");
	sql.append("	ROOM_ID, 																					");
	sql.append("	DECODE(RESERVE_TYPE, '기타시설', RESERVE_TYPE2, RESERVE_TYPE) RESERVE_TYPE						");
	sql.append("FROM RESERVE_ROOM																				");
	sql.append("WHERE SCHOOL_ID = ?																				");
	sql.append("ORDER BY DECODE(RESERVE_TYPE, '강당', 1, '운동장', 2, '교실', 3, '기타시설', 4, RESERVE_TYPE2, 5)		");
	
	roomList = jdbcTemplate.query(sql.toString(), new RoomList(), new Object[]{school_id});
	
	int room_id_cnt = 0;
	if("".equals(room_id)){
		sql = new StringBuffer();
		sql.append("SELECT 	COUNT(*)			");
		sql.append("FROM RESERVE_ROOM			");
		sql.append("WHERE SCHOOL_ID = ?			");
		try{
			room_id_cnt = jdbcTemplate.queryForObject(sql.toString(), Integer.class, new Object[]{school_id});
			
			if(room_id_cnt > 0){
				sql = new StringBuffer();
				sql.append("SELECT	ROOM_ID																						");
				sql.append("FROM( 																								");
				sql.append("	SELECT 																							");
				sql.append("		ROOM_ID 																					");
				sql.append("	FROM RESERVE_ROOM																				");
				sql.append("	WHERE SCHOOL_ID = ?																				");
				sql.append("	ORDER BY DECODE(RESERVE_TYPE, '강당', 1, '운동장', 2, '교실', 3, '기타시설', 4, RESERVE_TYPE2, 5)		");
				sql.append(")		 																							");
				sql.append("WHERE ROWNUM = 1																					");
				room_id = jdbcTemplate.queryForObject(sql.toString(), String.class, new Object[]{school_id});
			}
		}catch(Exception e){
			room_id_cnt = 0;
		}
	}
	
	//시설정보
	sql = new StringBuffer();
	sql.append("SELECT					");
	sql.append("	DIRECTORY,			");
	sql.append("	SAVE_IMG,			");
	sql.append("	RESERVE_AREA,		");
	sql.append("	RESERVE_NUMBER,		");
	sql.append("	RESERVE_MAX,		");
	sql.append("	RESERVE_ETC,		");
	sql.append("	RESERVE_NOTICE  	");
	sql.append("FROM RESERVE_ROOM		");
	sql.append("WHERE ROOM_ID =	?		");
	try{
		roomInfo = jdbcTemplate.queryForObject(sql.toString(), new RoomInfo(), new Object[]{room_id});
	}catch(Exception e){
		roomInfo = null;
	}
	
	
	//항시개방 정보
	sql = new StringBuffer();
	sql.append("SELECT												");
	sql.append("	DATE_START, DATE_END,							");
	sql.append("	TIME_START_A, TIME_END_A,						");
	sql.append("	TIME_START_A2, TIME_END_A2,						");
	sql.append("	TIME_START_B, TIME_END_B,						");
	sql.append("	TIME_START_B2, TIME_END_B2,						");
	sql.append("	TIME_START_C, TIME_END_C,						");
	sql.append("	TIME_START_C2, TIME_END_C2  					");
	sql.append("FROM RESERVE_DATE									");
	sql.append("WHERE ROOM_ID = ? AND								");
	sql.append("	DATE_START IS NULL		  						");
	sql.append("	AND RESERVE_GROUP = 0	  						");
	timeList1 = jdbcTemplate.query(sql.toString(), new TimeList(), new Object[]{room_id});
	
	//특정일 개방 정보
	sql = new StringBuffer();
	sql.append("SELECT												");
	sql.append("	DATE_START, DATE_END,							");
	sql.append("	TIME_START_A, TIME_END_A,						");
	sql.append("	TIME_START_A2, TIME_END_A2,						");
	sql.append("	TIME_START_B, TIME_END_B,						");
	sql.append("	TIME_START_B2, TIME_END_B2,						");
	sql.append("	TIME_START_C, TIME_END_C,						");
	sql.append("	TIME_START_C2, TIME_END_C2  					");
	sql.append("FROM RESERVE_DATE									");
	sql.append("WHERE ROOM_ID = ? AND								");
	sql.append("	DATE_START IS NOT NULL  						");
	sql.append("	AND DATE_END >= TO_CHAR(SYSDATE, 'YYYY-MM-DD')	");
	sql.append("	AND RESERVE_GROUP = 0	  						");
	timeList2 = jdbcTemplate.query(sql.toString(), new TimeList(), new Object[]{room_id});
	
	//개방불가 정보
	sql = new StringBuffer();
	sql.append("SELECT												");
	sql.append("	DATE_START, DATE_END,							");
	sql.append("	TIME_START_A, TIME_END_A,						");
	sql.append("	TIME_START_A2, TIME_END_A2,						");
	sql.append("	TIME_START_B, TIME_END_B,						");
	sql.append("	TIME_START_B2, TIME_END_B2,						");
	sql.append("	TIME_START_C, TIME_END_C,						");
	sql.append("	TIME_START_C2, TIME_END_C2  					");
	sql.append("FROM RESERVE_BAN									");
	sql.append("WHERE ROOM_ID = ? 									");
	sql.append("	AND DATE_END >= TO_CHAR(SYSDATE, 'YYYY-MM-DD')	");
	timeList3 = jdbcTemplate.query(sql.toString(), new TimeList(), new Object[]{room_id});
	
	// 달력 출력 START---
	// 가장 적게 사용된 DATE_ID 구하기
	sql = new StringBuffer();
	sql.append("SELECT DATE_ID														");
	sql.append("FROM(																");
	sql.append("	SELECT 															");
	sql.append("		DATE_ID, 													");
	sql.append("			NVL(													");
	sql.append("				(													");
	sql.append("					SELECT SUM(SUM(TIME_END - TIME_START)) SUM		");
	sql.append("					FROM RESERVE_USE								");
	sql.append("					WHERE DATE_ID = A.DATE_ID AND					");
	sql.append("						DATE_VALUE BETWEEN ? AND ? 					");
	sql.append("					GROUP BY DATE_VALUE								");
	sql.append("				), 0												");
	sql.append("			) AS SUM												");
	sql.append("		FROM RESERVE_DATE A											");
	sql.append("	WHERE ROOM_ID = ?												");
	sql.append("	ORDER BY DATE_START DESC NULLS FIRST, SUM, DATE_ID				");
	sql.append(")																	");
	sql.append("WHERE ROWNUM = 1													");
	try{
		date_id = jdbcTemplate.queryForObject(sql.toString(), String.class, new Object[]{first_day, last_day, room_id});
	}catch(Exception e){
		//가장 적게 사용된 DATE_ID 구하기에서 값이 없을 경우 아무 date_id를 쓴다
		sql = new StringBuffer();
		sql.append("SELECT *													");
		sql.append("FROM(														");
		sql.append("	SELECT DATE_ID											");
		sql.append("	FROM RESERVE_DATE 										");
		sql.append("	WHERE ROOM_ID = ?										");
		sql.append("		AND ((DATE_START <= ? AND DATE_END <= ?) 			");
		sql.append("			OR (DATE_START >= ? AND DATE_END <= ?)			");
		sql.append("			OR (DATE_START >= ? AND DATE_START <= ?)		");
		sql.append("			OR (DATE_START <= ? AND DATE_END >= ?)			");
		sql.append("			OR DATE_START IS NULL							");
		sql.append("		)													");
		sql.append("	ORDER BY DATE_START NULLS FIRST 						");
		sql.append(")															");
		sql.append("WHERE ROWNUM = 1											");
		try{
			date_id = jdbcTemplate.queryForObject(sql.toString(), String.class, 
					new Object[]{
						room_id,
						first_day,
						last_day,
						first_day,
						last_day,
						first_day,
						last_day,
						first_day,
						last_day
						});
		}catch(Exception e2){
			date_id = "1";
		}
	}
	
	//DATE_ID 사용 가능한 갯수
	sql = new StringBuffer();	
	sql.append("SELECT																											");
	sql.append("	NVL((DECODE(SUBSTR(TIME_END_A, 3,4), '00', TIME_END_A,  CONCAT(SUBSTR(TIME_END_A,0,2), '50')) - 			");
	sql.append("		DECODE(SUBSTR(TIME_START_A, 3,4), '00', TIME_START_A,  CONCAT(SUBSTR(TIME_START_A,0,2), '50'))), 		");
	sql.append("	0) + 																										");
	sql.append("	NVL((DECODE(SUBSTR(TIME_END_A2, 3,4), '00', TIME_END_A2,  CONCAT(SUBSTR(TIME_END_A2,0,2), '50')) - 			");
	sql.append("		DECODE(SUBSTR(TIME_START_A2, 3,4), '00', TIME_START_A2,  CONCAT(SUBSTR(TIME_START_A2,0,2), '50'))), 	");
	sql.append("	0) AS TIME_A,																								");
	sql.append("	NVL((DECODE(SUBSTR(TIME_END_B, 3,4), '00', TIME_END_B,  CONCAT(SUBSTR(TIME_END_B,0,2), '50')) - 			");
	sql.append("		DECODE(SUBSTR(TIME_START_B, 3,4), '00', TIME_START_B,  CONCAT(SUBSTR(TIME_START_B,0,2), '50'))),		");
	sql.append("	0) + 																										");
	sql.append("	NVL((DECODE(SUBSTR(TIME_END_B2, 3,4), '00', TIME_END_B2,  CONCAT(SUBSTR(TIME_END_B2,0,2), '50')) - 			");
	sql.append("		DECODE(SUBSTR(TIME_START_B2, 3,4), '00', TIME_START_B2,  CONCAT(SUBSTR(TIME_START_B2,0,2), '50'))), 	");
	sql.append("	0) AS TIME_B,																								");
	sql.append("	NVL((DECODE(SUBSTR(TIME_END_C, 3,4), '00', TIME_END_C,  CONCAT(SUBSTR(TIME_END_C,0,2), '50')) - 			");
	sql.append("		DECODE(SUBSTR(TIME_START_C, 3,4), '00', TIME_START_C,  CONCAT(SUBSTR(TIME_START_C,0,2), '50'))), 		");
	sql.append("	0) + 																										");
	sql.append("	NVL((DECODE(SUBSTR(TIME_END_C2, 3,4), '00', TIME_END_C2,  CONCAT(SUBSTR(TIME_END_C2,0,2), '50')) - 			");
	sql.append("		DECODE(SUBSTR(TIME_START_C2, 3,4), '00', TIME_START_C2,  CONCAT(SUBSTR(TIME_START_C2,0,2), '50'))), 	");
	sql.append("	0) AS TIME_C  																								");
	sql.append("FROM RESERVE_DATE																								");
	sql.append("WHERE DATE_ID = ?																								");
	try{
		timeCnt = jdbcTemplate.queryForObject(sql.toString(), new TimeCnt(), new Object[]{date_id});
	}catch(Exception e){
		timeCnt = null;
	}
	
	//사용불가 카운트
	sql = new StringBuffer();	
	sql.append("SELECT																											");
	sql.append("	DATE_START,																									");
	sql.append("	DATE_END,																									");
	sql.append("	NVL((DECODE(SUBSTR(TIME_END_A, 3,4), '00', TIME_END_A,  CONCAT(SUBSTR(TIME_END_A,0,2), '50')) - 			");
	sql.append("		DECODE(SUBSTR(TIME_START_A, 3,4), '00', TIME_START_A,  CONCAT(SUBSTR(TIME_START_A,0,2), '50'))), 		");
	sql.append("	0) + 																										");
	sql.append("	NVL((DECODE(SUBSTR(TIME_END_A2, 3,4), '00', TIME_END_A2,  CONCAT(SUBSTR(TIME_END_A2,0,2), '50')) - 			");
	sql.append("		DECODE(SUBSTR(TIME_START_A2, 3,4), '00', TIME_START_A2,  CONCAT(SUBSTR(TIME_START_A2,0,2), '50'))), 	");
	sql.append("	0) AS TIME_BAN_A,																							");
	sql.append("	NVL((DECODE(SUBSTR(TIME_END_B, 3,4), '00', TIME_END_B,  CONCAT(SUBSTR(TIME_END_B,0,2), '50')) - 			");
	sql.append("		DECODE(SUBSTR(TIME_START_B, 3,4), '00', TIME_START_B,  CONCAT(SUBSTR(TIME_START_B,0,2), '50'))),		");
	sql.append("	0) + 																										");
	sql.append("	NVL((DECODE(SUBSTR(TIME_END_B2, 3,4), '00', TIME_END_B2,  CONCAT(SUBSTR(TIME_END_B2,0,2), '50')) - 			");
	sql.append("		DECODE(SUBSTR(TIME_START_B2, 3,4), '00', TIME_START_B2,  CONCAT(SUBSTR(TIME_START_B2,0,2), '50'))), 	");
	sql.append("	0) AS TIME_BAN_B,																							");
	sql.append("	NVL((DECODE(SUBSTR(TIME_END_C, 3,4), '00', TIME_END_C,  CONCAT(SUBSTR(TIME_END_C,0,2), '50')) - 			");
	sql.append("		DECODE(SUBSTR(TIME_START_C, 3,4), '00', TIME_START_C,  CONCAT(SUBSTR(TIME_START_C,0,2), '50'))), 		");
	sql.append("	0) + 																										");
	sql.append("	NVL((DECODE(SUBSTR(TIME_END_C2, 3,4), '00', TIME_END_C2,  CONCAT(SUBSTR(TIME_END_C2,0,2), '50')) - 			");
	sql.append("		DECODE(SUBSTR(TIME_START_C2, 3,4), '00', TIME_START_C2,  CONCAT(SUBSTR(TIME_START_C2,0,2), '50'))), 	");
	sql.append("	0) AS TIME_BAN_C  																							");
	sql.append("FROM RESERVE_BAN																								");
	sql.append("WHERE ROOM_ID = ?																								");
	sql.append("		AND ((DATE_START <= ? AND DATE_END <= ?) 																");
	sql.append("			OR (DATE_START >= ? AND DATE_END <= ?)																");
	sql.append("			OR (DATE_START >= ? AND DATE_START <= ?)															");
	sql.append("			OR (DATE_START <= ? AND DATE_END >= ?)																");
	sql.append("		)																										");
	timeBanCnt = jdbcTemplate.query(sql.toString(), new TimeBanCnt(),
			new Object[]{
				room_id,
				first_day,
				last_day,
				first_day,
				last_day,
				first_day,
				last_day,
				first_day,
				last_day
				});
	//사용중인 날짜와 해당 날짜의 사용 값
	sql = new StringBuffer();
	sql.append("SELECT																										");
	sql.append(" 	DATE_VALUE,																								");
	sql.append(" 		SUM(																								");
	sql.append(" 			(																								");
	sql.append(" 				DECODE(SUBSTR(TIME_END, 3,4), '00', TIME_END,  CONCAT(SUBSTR(TIME_END,0,2), '50')) 			");
	sql.append(" 				-																							");
	sql.append(" 				DECODE(SUBSTR(TIME_START, 3,4), '00', TIME_START,  CONCAT(SUBSTR(TIME_START,0,2), '50'))	");
	sql.append(" 			)																								");
	sql.append(" 		) CNT,																								");
	sql.append("	(COUNT(*)-1)*50 AS CNT2																					");
	sql.append("FROM RESERVE_USE																							");
	sql.append("WHERE DATE_ID = ? AND 																						");
	sql.append(" 	DATE_VALUE BETWEEN ? AND ?																				");
	sql.append("GROUP BY DATE_VALUE 																						");
	sql.append("ORDER BY DATE_VALUE 																						");
	useTimeList = jdbcTemplate.query(sql.toString(), new UseTimeList(), new Object[]{date_id, first_day, last_day});
	
	if(useTimeList != null && useTimeList.size() > 0){
		for(ReserveVO ob : useTimeList){
			useTimeMap.put(ob.date_value, ob.cnt);
		}
	}
	
	
	// 달력 출력 --- END
	
}catch(Exception e){
	out.println(e.toString());
}


%>
<script>
function roomChange(room_id){
	$("#changeForm #room_id").val(room_id);
	$("#changeForm").submit();
}
function backList(){
	$("#backListForm").submit();
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
function reserve(school_id, room_id, dayValue){
	var id = "<%=sm.getId()%>";
	
	$("#loginForm #school_id").val(school_id);
	$("#loginForm #room_id").val(room_id);
	$("#loginForm #dayValue").val(dayValue);
	
	if(id == ""){
		$("#loginForm #menuCd").val("<%=loginPage%>");
		
		$("#loginForm").submit();
	}else{
		$("#loginForm #menuCd").val("<%=reservePage%>");
		$("#loginMode").remove();
		$("#forwardUrl").remove();
		$("#returnUrl").remove();
		
		$("#loginForm").submit();
	}
}
</script>
<form action="/index.gne" method="get" id="loginForm">
	<input type="hidden" name="school_id" id="school_id">
	<input type="hidden" name="room_id" id="room_id">
	<input type="hidden" name="dayValue" id="dayValue">
	<input type="hidden" name="menuCd" id="menuCd" value="<%=loginPage%>">
	<input type="hidden" name="loginMode" id="loginMode" value="login">
	<input type="hidden" name="forwardUrl" id="forwardUrl" value="/index.gne?menuCd=<%=reservePage%>">		
	<input type="hidden" name="returnUrl" id="returnUrl" value="/index.gne?menuCd=<%=reservePage%>">	
</form>

<form action="/index.gne" method="get" id="changeForm">
	<input type="hidden" name="school_id" id="school_id" value="<%=school_id%>">
	<input type="hidden" name="room_id" id="room_id" value="<%=room_id%>">
	<input type="hidden" name="menuCd" id="menuCd" value="<%=menuCd%>">
	<input type="hidden" name="year" id="year" value="<%=year%>">
	<input type="hidden" name="month" id="month" value="<%=month%>">
	<input type="hidden" name="nowDate" id="nowDate" value="<%=nowDate%>">
	<input type="hidden" name="adminCheck" id="adminCheck" value="<%=adminCheck%>">
</form>

<form action="/index.gne" method="get" id="backListForm" style="display: none;">
	<input type="hidden" name="menuCd" value="<%=listPage%>">
	<input type="hidden" name="reserve_date" value="<%=search_reserve_date%>">
	<input type="hidden" name="school_area" value="<%=search_school_area%>">
	<input type="hidden" name="school_name" value="<%=search_school_name%>">
	<%
	if(search_reserve_type!=null){
		for(int i=0; i<search_reserve_type.length; i++){ %>
	<input type="checkbox" name="reserve_type" value="<%=search_reserve_type[i]%>" checked>	
	<%	}
	}%>
	
</form>

<!-- 학교정보 -->
<div class="topbox1 mg_b30 school_info">
	<h3><%=schoolInfo.school_name%></h3>
	<h4 class="blind">학교상세정보</h4>
	<ul class="type03 padL14">
		<li>주소 : <%=schoolInfo.school_addr%></li>
		<li>전화번호 : 055-<%=telSet(schoolInfo.school_tel) %></li>
		<li>홈페이지 : <a href="http://<%=schoolInfo.school_url %>" target="_blank"><%=schoolInfo.school_url %></a></li>
	</ul>
	<div class="sch_admin topbox2">
		<h4>학교 시설예약 담당자</h4>
		<span><%=schoolInfo.charge_dept %></span>	<span><%=schoolInfo.charge_name %></span> <span>055-<%=telSet(schoolInfo.dept_tel) %></span>
	</div>
</div>

<%if(!"".equals(room_id)){ %>
<section class="date_select">
	<h3>시설안내</h3>
		<ul class="faci_cate">
			<%for(ReserveVO ob : roomList){ %>
			<li class="tab">
				<a href="#" onclick="roomChange('<%=ob.room_id%>')" <%if(ob.room_id == Integer.parseInt(room_id)){%>class="on"<%}%>  >
					<span><%=ob.reserve_type %></span>
				</a>
			</li>
			<%} %>
		</ul>


<div class="faci_detail topbox2 col-12 magB30">
	<div class="thumb item col-5 mo-col-12">
		<img src="<%=roomInfo.directory%><%=roomInfo.save_img%>" alt="학교시설 이미지입니다." onError="this.onerror=null;this.src='/img/school/noimg.png'">

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
					<td><%=roomInfo.reserve_area %> m&sup2;</td>
					<th scope="row">대여시설 수</th>
					<td><%=roomInfo.reserve_number %> 개</td>
					<th scope="row">이용가능 인원</th>
					<td><%=roomInfo.reserve_max %> 명</td>
				</tr>
				<tr>
					<th scope="row">개방일 및 개방시간 </th>
					<td colspan="5">
						<ul>
							<%
							if(timeList1!=null && timeList1.size()>0){
								for(ReserveVO ob : timeList1){
							%>
								<li>
									<strong>항시개방</strong>		
									<%if(!"".equals(ob.time_start_a)){ %>									
										<span>
											평일 :
											<%=timeSet(ob.time_start_a)%> ~ <%=timeSet(ob.time_end_a) %>
											<%if(!"".equals(ob.time_start_a2)){ %>
											, <%=timeSet(ob.time_start_a2) %> ~ <%=timeSet(ob.time_end_a2) %>
											<%} %>										
										</span>
									<%} %>
									<%if(!"".equals(ob.time_start_b)){ %>	
										<span>
											토요일 : 
											<%=timeSet(ob.time_start_b) %> ~ <%=timeSet(ob.time_end_b) %>
											<%if(!"".equals(ob.time_start_b2)){ %>
											, <%=timeSet(ob.time_start_b2) %> ~ <%=timeSet(ob.time_end_b2) %>
											<%} %>	
										</span>
									<%} %>
									<%if(!"".equals(ob.time_start_c2)){ %>	
										<span>
											일요일 :
											<%=ob.time_start_c %> ~ <%=ob.time_end_c %>
											<%if(!"".equals(ob.time_start_c2)){ %>
											, <%=ob.time_start_c2 %> ~ <%=ob.time_end_c2 %>
											<%} %>	
										</span>
									<%} %>
								</li>
							<%
								}
							}
							%>
							<%
							if(timeList2!=null && timeList2.size()>0){
								for(ReserveVO ob : timeList2){
							%>
								<li>
									<strong><%=ob.date_start%> ~ <%=ob.date_end%></strong>		
									<%if(!"".equals(ob.time_start_a)){ %>									
										<span>
											평일 :
											<%=timeSet(ob.time_start_a)%> ~ <%=timeSet(ob.time_end_a) %>
											<%if(!"".equals(ob.time_start_a2)){ %>
											, <%=timeSet(ob.time_start_a2) %> ~ <%=timeSet(ob.time_end_a2) %>
											<%} %>										
										</span>
									<%} %>
									<%if(!"".equals(ob.time_start_b)){ %>	
										<span>
											토요일 : 
											<%=timeSet(ob.time_start_b) %> ~ <%=timeSet(ob.time_end_b) %>
											<%if(!"".equals(ob.time_start_b2)){ %>
											, <%=timeSet(ob.time_start_b2) %> ~ <%=timeSet(ob.time_end_b2) %>
											<%} %>	
										</span>
									<%} %>
									<%if(!"".equals(ob.time_start_c2)){ %>	
										<span>
											일요일 :
											<%=ob.time_start_c %> ~ <%=ob.time_end_c %>
											<%if(!"".equals(ob.time_start_c2)){ %>
											, <%=ob.time_start_c2 %> ~ <%=ob.time_end_c2 %>
											<%} %>	
										</span>
									<%} %>
								</li>
							<%
								}
							}
							%>
							<%
							if(timeList3!=null && timeList3.size()>0){
								for(ReserveVO ob : timeList3){
							%>
								<li>
									<strong><%=ob.date_start%> ~ <%=ob.date_end%>(개방불가)</strong>		
									<%if(!"".equals(ob.time_start_a)){ %>									
										<span>
											평일 :
											<%=timeSet(ob.time_start_a)%> ~ <%=timeSet(ob.time_end_a) %>
											<%if(!"".equals(ob.time_start_a2)){ %>
											, <%=timeSet(ob.time_start_a2) %> ~ <%=timeSet(ob.time_end_a2) %>
											<%} %>										
										</span>
									<%} %>
									<%if(!"".equals(ob.time_start_b)){ %>	
										<span>
											토요일 : 
											<%=timeSet(ob.time_start_b) %> ~ <%=timeSet(ob.time_end_b) %>
											<%if(!"".equals(ob.time_start_b2)){ %>
											, <%=timeSet(ob.time_start_b2) %> ~ <%=timeSet(ob.time_end_b2) %>
											<%} %>	
										</span>
									<%} %>
									<%if(!"".equals(ob.time_start_c2)){ %>	
										<span>
											일요일 :
											<%=ob.time_start_c %> ~ <%=ob.time_end_c %>
											<%if(!"".equals(ob.time_start_c2)){ %>
											, <%=ob.time_start_c2 %> ~ <%=ob.time_end_c2 %>
											<%} %>	
										</span>
									<%} %>
								</li>
							<%
								}
							}
							%>
						</ul>		
					</td>
				</tr>
				<tr>
					<th scope="row">특이사항</th>
					<td colspan="5"><%=parseNull(roomInfo.reserve_etc).replace("\r\n", "<br>")%></td>
				</tr>
				<tr>
					<th scope="row">주의사항</th>
					<td colspan="5"><%=parseNull(roomInfo.reserve_notice).replace("\r\n", "<br>")%></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="clr"> </div>
</div>

<div class="cal">
	<div class="calbtn">
		<a href="#" class="prem" onclick="move('pre')">&lt; 이전달</a> <span><%=year %>.<%=strMonth %></span> <a href="#" class="nextm" onclick="move('next')">다음달 &gt;</a>
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
			for(int i=0; i<weekNum; i++){
			 %>
				<tr>
			 	<%
				for(int j=0; j<7; j++){
			   		dayValCheck++;
			 	%>
			  		<td <%if(j==0){out.println("class='sun'");}else if(j==6){out.println("class='sat'");}%> >
			   			<%
			   			if(dayValCheck >= startNum && dayVal<=lastNum){
			   			%>
			   				<%
			   				strDayVal 		= dayVal < 10 ? "0" + Integer.toString(dayVal) : Integer.toString(dayVal);
			   				dayValue 		= strYear + "-" + strMonth + "-" + strDayVal;
			   				time_ban_a		= 0;
			   				time_ban_b		= 0;
			   				time_ban_c		= 0;
			   				
			   				// 사용불가 리스트에서 해당 날짜를 골라낸 후 불가 값을 저장한다
			   				if(timeBanCnt != null && timeBanCnt.size() > 0){
			   					for(ReserveVO ob : timeBanCnt){
				   					if(isInDuration(ob.date_start, ob.date_end, dayValue)){
				   						time_ban_a = ob.time_ban_a;
				   						time_ban_b = ob.time_ban_b;
				   						time_ban_c = ob.time_ban_c;
				   					}
				   				}
			   				}
			   				
			   				if("평일".equals(getDateDay(dayValue, "yyyy-MM-dd"))){	// 해당 날짜가 평일,토,일 인지 확인한 후
			   					if(timeCnt.time_a > 0){								// 그 날짜의 개방 개수를 구해서 0 이상이면
			   						useAbleCheck = "Y";								// 체크값을 Y로 변경하여 예약가능으로 바꾼다
			   						if(useTimeMap.get(dayValue) != null){			
			   							if(timeCnt.time_a <= Integer.parseInt(useTimeMap.get(dayValue).toString()) ){	// 개방개수보다 사용개수가 많으면
			   								useAbleCheck = "U";															// 체크값을 U로 변경하여 예약완료로 바꾼다
				   						}
			   						}
			   						if(timeCnt.time_a <= time_ban_a){				// 개방개수보다 사용불가개수가 많으면
			   							useAbleCheck = "N";							// 체크값을 N으로 변경하여 예약불가로 바꾼다
			   						}
			   					}else{
			   						useAbleCheck = "N";		// 체크값을 N으로 변경하여 예약불가로 바꾼다
			   					}
			   				}else if("토".equals(getDateDay(dayValue, "yyyy-MM-dd"))){
			   					if(timeCnt.time_b > 0){
			   						useAbleCheck = "Y";
			   						if(useTimeMap.get(dayValue) != null){
			   							if(timeCnt.time_b <= Integer.parseInt(useTimeMap.get(dayValue).toString()) ){
			   								useAbleCheck = "U";
				   						}
			   						}
			   						if(timeCnt.time_b <= time_ban_b){
			   							useAbleCheck = "N";
			   						}
			   					}else{
			   						useAbleCheck = "N";
			   					}
			   				}else if("일".equals(getDateDay(dayValue, "yyyy-MM-dd"))){
			   					if(timeCnt.time_c > 0){
			   						useAbleCheck = "Y";
			   						if(useTimeMap.get(dayValue) != null){
			   							if(timeCnt.time_c <= Integer.parseInt(useTimeMap.get(dayValue).toString()) ){
			   								useAbleCheck = "U";
				   						}
			   						}
			   						if(timeCnt.time_c <= time_ban_c){
			   							useAbleCheck = "N";
			   						}
			   					}else{
			   						useAbleCheck = "N";
			   					}
			   				}
							
			   				//현재날짜 3일 후 까지는 예약불가로 설정
							SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
							Date day1 = null;
							Date day2 = null;
							try{
								day1 = format.parse(nextDate(nowDateFull));		// 현재날짜  3일 후
								day2 = format.parse(dayValue);				// 달력 날짜
							}catch(ParseException e){
								e.printStackTrace();
							}
							int compare = day1.compareTo(day2);		// 날짜 비교
							if(compare > 0){						// day1 > day2 : compare=1, day1 < day2 : compare=-1	, day1 = day2 : compare=0
								useAbleCheck = "N";
							}
			   				
			   				if("Y".equals(useAbleCheck)){			// 예약이 가능할 떄
			   				%>
			   				<a href="javascript:reserve('<%=school_id%>', '<%=room_id%>', '<%=dayValue%>');" class="day" title="예약가능">
			   					<%=dayVal++%>
			   					<span>예약가능</span>
			   				</a>
			   				<% 
			   				}else if("N".equals(useAbleCheck)){		// 개방을 안했거나 개방불가날짜 일 때
			   				%>
			   				<span class="dayN" title="예약불가"><%=dayVal++%><span>예약불가</span></span>
			   				<%
			   				}else if("U".equals(useAbleCheck)){		// 이미 모두 사용중일때
			   				%>
			   				<span class="dayY" title="예약완료"><%=dayVal++%><span>예약완료</span></span>
			   				<%} %>
			   			<%
			   			}
			   			%>
			  		</td>
				 <%
				  }
				 %>
			 	</tr>
			<% 
			} 
			%>
		</tbody>
	</table>		
	<div class="topbox2 c">시설이 개방되지 않았습니다.</div>
<%}else{ %>
	<div class="topbox2 c">등록한 시설물이 없습니다.</div>
<%} %>
	<div class="c magT15">
		<!-- <button type="button" onclick="postList()" class="btn medium edge mako">목록</button>	 -->
		<button type="button" onclick="backList()" class="btn medium edge mako">목록</button>	<!-- 테스트서버 -->
	</div>
</div>
</section>


<%
}catch(Exception e){
	out.println(e.toString());
}
%>