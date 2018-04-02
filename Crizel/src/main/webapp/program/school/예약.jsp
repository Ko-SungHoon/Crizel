<%@ include file="/program/class/UtilClass.jsp" %>
<%@page import="java.text.DecimalFormat" %>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="java.text.ParseException"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%try{ %>
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
	
	public String day_of_week;
	
	public int price_1;
	public int price_2;
	public int price_3;
	
	public int option_id;
	public String option_title;
	public int option_price;
	public String option_price_unit;
	
	
}

private class ReserveList implements RowMapper<ReserveVO> {
    public ReserveVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ReserveVO vo 	= new ReserveVO();
    	String column 	= "";
    	for(int i=1; i<=rs.getMetaData().getColumnCount(); i++){		// 컬럼의 총 갯수만큼 반복하며 컬럼명과 같은 변수명에 데이터 입력
    		column = rs.getMetaData().getColumnLabel(i);
			if("RESERVE_TYPE".equals(column)){			vo.reserve_type			=	parseNull(rs.getString("RESERVE_TYPE"));		}		
			else if("RESERVE_TYPE2".equals(column)){	vo.reserve_type2		=	parseNull(rs.getString("RESERVE_TYPE2"));		}	
			else if("TIME_A".equals(column)){			vo.time_a				=	rs.getInt("TIME_A");							}
			else if("TIME_B".equals(column)){			vo.time_b				=	rs.getInt("TIME_B");							}
			else if("TIME_C".equals(column)){			vo.time_c				=	rs.getInt("TIME_C");							}
			else if("DATE_START".equals(column)){		vo.date_start			=	parseNull(rs.getString("DATE_START"));			}
			else if("DATE_END".equals(column)){			vo.date_end				=	parseNull(rs.getString("DATE_END"));			}
			else if("TIME_BAN_A".equals(column)){		vo.time_ban_a			=	rs.getInt("TIME_BAN_A");						}
			else if("TIME_BAN_B".equals(column)){		vo.time_ban_b			=	rs.getInt("TIME_BAN_B");						}
			else if("TIME_BAN_C".equals(column)){		vo.time_ban_c			=	rs.getInt("TIME_BAN_C");						}
			else if("DATE_VALUE".equals(column)){		vo.date_value			=	parseNull(rs.getString("DATE_VALUE"));			}
			else if("CNT".equals(column)){				vo.cnt					=	rs.getInt("CNT") + rs.getInt("CNT2");			}
			else if("DAY_OF_WEEK".equals(column)){		vo.day_of_week			=	parseNull(rs.getString("DAY_OF_WEEK"));			}
			else if("TIME_START_A".equals(column)){		vo.time_start_a			=	parseNull(rs.getString("TIME_START_A"));		}
			else if("TIME_END_A".equals(column)){		vo.time_end_a			=	parseNull(rs.getString("TIME_END_A"));			}
			else if("TIME_START_A2".equals(column)){	vo.time_start_a2		=	parseNull(rs.getString("TIME_START_A2"));		}
			else if("TIME_END_A2".equals(column)){		vo.time_end_a2			=	parseNull(rs.getString("TIME_END_A2"));			}
			else if("TIME_START_B".equals(column)){		vo.time_start_b			=	parseNull(rs.getString("TIME_START_B"));		}
			else if("TIME_END_B".equals(column)){		vo.time_end_b			=	parseNull(rs.getString("TIME_END_B"));			}
			else if("TIME_START_B2".equals(column)){	vo.time_start_b2		=	parseNull(rs.getString("TIME_START_B2"));		}
			else if("TIME_END_B2".equals(column)){		vo.time_end_b2			=	parseNull(rs.getString("TIME_END_B2"));			}
			else if("TIME_START_C".equals(column)){		vo.time_start_c			=	parseNull(rs.getString("TIME_START_C"));		}
			else if("TIME_END_C".equals(column)){		vo.time_end_c			=	parseNull(rs.getString("TIME_END_C"));			}
			else if("TIME_START_C2".equals(column)){	vo.time_start_c2		=	parseNull(rs.getString("TIME_START_C2"));		}
			else if("TIME_END_C2".equals(column)){		vo.time_end_c2			=	parseNull(rs.getString("TIME_END_C2"));			}
			else if("TIME_START".equals(column)){		vo.time_start			=	parseNull(rs.getString("TIME_START"));			}
			else if("TIME_END".equals(column)){			vo.time_end				=	parseNull(rs.getString("TIME_END"));			}
			else if("OPTION_ID".equals(column)){		vo.option_id			=	rs.getInt("OPTION_ID");							}
			else if("OPTION_TITLE".equals(column)){		vo.option_title			=	parseNull(rs.getString("OPTION_TITLE"));		}
			else if("OPTION_PRICE".equals(column)){		vo.option_price			=	rs.getInt("OPTION_PRICE");						}
			else if("OPTION_PRICE_UNIT".equals(column)){vo.option_price_unit	=	parseNull(rs.getString("OPTION_PRICE_UNIT"));	}
			else if("PRICE_1".equals(column)){			vo.price_1				=	rs.getInt("PRICE_1");							}
			else if("PRICE_2".equals(column)){			vo.price_2				=	rs.getInt("PRICE_2");							}
			else if("PRICE_3".equals(column)){			vo.price_3				=	rs.getInt("PRICE_3");							}
		}
        return vo;
    }
    public String parseNull(String value){
    	value = value==null?"":value;
    	return value;
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
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

String listPage		= "DOM_000000118001001000";

String menuCd		= request.getParameter("menuCd");

String adminCheck = "";
if("GRP_000009".equals(sm.getGroupId()) || sm.isRole("ROLE_000006") || sm.isRoleSym() ){
	adminCheck = "Y";
}


String school_id 			= parseNull(request.getParameter("school_id"));
String room_id 				= parseNull(request.getParameter("room_id"));
String dayValue 			= parseNull(request.getParameter("dayValue"));
String date_start			= parseNull(request.getParameter("date_start"), dayValue);
String date_end				= parseNull(request.getParameter("date_end"), dayValue);
String school_name 			= "";
String reserve_type			= parseNull(request.getParameter("reserve_type"));
String reserve_type2		= parseNull(request.getParameter("reserve_type2"));
int reserve_number			= 0;
int countVal				= Integer.parseInt(parseNull(request.getParameter("countVal"), "1"));

String date_id					= "";
String useAbleCheck				= "";
String strDayVal 				= "";
int time_ban_a					= 0;
int time_ban_b					= 0;
int time_ban_c					= 0;

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

StringBuffer sql 					= null;
List<ReserveVO> reserveTypeList		= null;
List<ReserveVO> reserveType2List	= null;
ReserveVO timeCnt					= null;
List<ReserveVO> timeBanCnt			= null;
List<ReserveVO> useTimeList			= null;
Map<String,Object> useTimeMap		= new HashMap<String,Object>();
List<ReserveVO> toDayTimeList		= null;
List<ReserveVO> toDayTimeBanList	= null;
List<ReserveVO> toDayTimeUseList	= null;
List<ReserveVO> optionList			= null;
List<ReserveVO> priceList			= null;



// 학교명
sql = new StringBuffer();
sql.append("SELECT 	SCHOOL_NAME			");
sql.append("FROM RESERVE_SCHOOL			");
sql.append("WHERE SCHOOL_ID = ?			");
school_name = jdbcTemplate.queryForObject(sql.toString(), String.class, new Object[]{school_id});

//ROOM_ID 찾기
if(!"".equals(reserve_type)){
	sql = new StringBuffer();
	sql.append("SELECT MIN(ROOM_ID)					");
	sql.append("FROM RESERVE_ROOM					");
	sql.append("WHERE SCHOOL_ID = ?					");
	if("".equals(reserve_type2)){
		sql.append("AND RESERVE_TYPE = ?			");
		room_id = jdbcTemplate.queryForObject(sql.toString(), String.class, new Object[]{school_id, reserve_type});
	}else{
		sql.append("AND RESERVE_TYPE2 = ?			");
		room_id = jdbcTemplate.queryForObject(sql.toString(), String.class, new Object[]{school_id, reserve_type2});
	}
}

// 시설명
sql = new StringBuffer();
sql.append("SELECT 	RESERVE_TYPE		");
sql.append("FROM RESERVE_ROOM			");
sql.append("WHERE ROOM_ID = ?			");
reserve_type = parseNull(jdbcTemplate.queryForObject(sql.toString(), String.class, new Object[]{room_id}));

// 기타시설명
sql = new StringBuffer();
sql.append("SELECT 	RESERVE_TYPE2		");
sql.append("FROM RESERVE_ROOM			");
sql.append("WHERE ROOM_ID = ?			");
try{
	reserve_type2 = parseNull(jdbcTemplate.queryForObject(sql.toString(), String.class, new Object[]{room_id}));
}catch(Exception e){
	reserve_type2 = "";
}

// 시설리스트
sql = new StringBuffer();
sql.append("SELECT RESERVE_TYPE																			");
sql.append("FROM RESERVE_ROOM 																			");
sql.append("WHERE SCHOOL_ID = ?																			");
sql.append("GROUP BY RESERVE_TYPE																		");
sql.append("ORDER BY DECODE(RESERVE_TYPE, '강당', 1, '운동장', 2, '교실', 3, '기타시설', 4) 					");
reserveTypeList = jdbcTemplate.query(sql.toString(), new ReserveList(), new Object[]{school_id});

// 기타시설리스트
sql = new StringBuffer();
sql.append("SELECT RESERVE_TYPE2														");
sql.append("FROM RESERVE_ROOM															");
sql.append("WHERE SCHOOL_ID = ?															");
sql.append("	AND RESERVE_TYPE2 IS NOT NULL											");
sql.append("ORDER BY RESERVE_TYPE2														");
reserveType2List = jdbcTemplate.query(sql.toString(), new ReserveList(), new Object[]{school_id});

//시설 수
sql = new StringBuffer();
sql.append("SELECT RESERVE_NUMBER									");
sql.append("FROM RESERVE_ROOM										");
sql.append("WHERE ROOM_ID = ?										");
reserve_number = jdbcTemplate.queryForObject(sql.toString(), Integer.class, new Object[]{room_id});

//달력 출력 START---
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
		timeCnt = jdbcTemplate.queryForObject(sql.toString(), new ReserveList(), new Object[]{date_id});
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
	timeBanCnt = jdbcTemplate.query(sql.toString(), new ReserveList(),
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
	useTimeList = jdbcTemplate.query(sql.toString(), new ReserveList(), new Object[]{date_id, first_day, last_day});
	
	if(useTimeList != null && useTimeList.size() > 0){
		for(ReserveVO ob : useTimeList){
			useTimeMap.put(ob.date_value, ob.cnt);
		}
	}
	
	
	// 달력 출력 --- END
	
	// 선택한 날짜 개방 리스트
	sql = new StringBuffer();
	sql.append("SELECT																	");
	sql.append("	CASE																");
	sql.append("		WHEN 	TO_CHAR(TO_DATE(?), 'DAY') = '월요일' OR					");
	sql.append("				TO_CHAR(TO_DATE(?), 'DAY') = '화요일' OR					");
	sql.append("				TO_CHAR(TO_DATE(?), 'DAY') = '수요일' OR 					");
	sql.append("				TO_CHAR(TO_DATE(?), 'DAY') = '목요일' OR 					");
	sql.append("				TO_CHAR(TO_DATE(?), 'DAY') = '금요일' 					");
	sql.append("		THEN '평일'														");
	sql.append("		WHEN 	TO_CHAR(TO_DATE(?), 'DAY') = '토요일'	 					");
	sql.append("			THEN '토'													");
	sql.append("		WHEN 	TO_CHAR(TO_DATE(?), 'DAY') = '일요일'						");
	sql.append("			THEN '일'													");
	sql.append("	END AS DAY_OF_WEEK,													");
	sql.append("	TIME_START_A,														");
	sql.append("	TIME_END_A,															");
	sql.append("	TIME_START_A2,														");
	sql.append("	TIME_END_A2,														");
	sql.append("	TIME_START_B,														");
	sql.append("	TIME_END_B,															");
	sql.append("	TIME_START_B2,														");
	sql.append("	TIME_END_B2,														");
	sql.append("	TIME_START_C,														");
	sql.append("	TIME_END_C,															");
	sql.append("	TIME_START_C2,														");
	sql.append("	TIME_END_C2															");
	sql.append("FROM RESERVE_DATE														");
	sql.append("WHERE ROOM_ID = ? AND DATE_ID = ?										");
	toDayTimeList = jdbcTemplate.query(sql.toString(), new ReserveList(), 
			new Object[]{
		date_start,
		date_start,
		date_start,
		date_start,
		date_start,
		date_start,
		date_start,
		room_id, 
		date_id});
	
	// 선택한 날짜 개방불가 리스트
	sql = new StringBuffer();
	sql.append("SELECT																	");
	sql.append("	CASE																");
	sql.append("		WHEN 	TO_CHAR(TO_DATE(?), 'DAY') = '월요일' OR					");
	sql.append("				TO_CHAR(TO_DATE(?), 'DAY') = '화요일' OR					");
	sql.append("				TO_CHAR(TO_DATE(?), 'DAY') = '수요일' OR 					");
	sql.append("				TO_CHAR(TO_DATE(?), 'DAY') = '목요일' OR 					");
	sql.append("				TO_CHAR(TO_DATE(?), 'DAY') = '금요일' 					");
	sql.append("		THEN '평일'														");
	sql.append("		WHEN 	TO_CHAR(TO_DATE(?), 'DAY') = '토요일'	 					");
	sql.append("			THEN '토'													");
	sql.append("		WHEN 	TO_CHAR(TO_DATE(?), 'DAY') = '일요일'						");
	sql.append("			THEN '일'													");
	sql.append("	END AS DAY_OF_WEEK,													");
	sql.append("	TIME_START_A,														");
	sql.append("	TIME_END_A,															");
	sql.append("	TIME_START_A2,														");
	sql.append("	TIME_END_A2,														");
	sql.append("	TIME_START_B,														");
	sql.append("	TIME_END_B,															");
	sql.append("	TIME_START_B2,														");
	sql.append("	TIME_END_B2,														");
	sql.append("	TIME_START_C,														");
	sql.append("	TIME_END_C,															");
	sql.append("	TIME_START_C2,														");
	sql.append("	TIME_END_C2															");
	sql.append("FROM RESERVE_BAN														");
	sql.append("WHERE ROOM_ID = ? AND DATE_START <= ? AND DATE_END >= ?					");
	toDayTimeBanList = jdbcTemplate.query(sql.toString(), new ReserveList(), 
			new Object[]{
				date_start,
				date_start,
				date_start,
				date_start,
				date_start,
				date_start,
				date_start,
				room_id, 
				date_start,
				date_start});
	
	// 선택한 날짜 사용중 리스트
	sql = new StringBuffer();
	sql.append("SELECT TIME_START, TIME_END					");
	sql.append("FROM RESERVE_USE							");
	sql.append("WHERE ROOM_ID = ? AND DATE_VALUE = ?		");
	toDayTimeUseList = jdbcTemplate.query(sql.toString(), new ReserveList(), new Object[]{room_id, date_start});
	
	// 옵션 리스트
	sql = new StringBuffer();
	sql.append("SELECT 					");
	sql.append("	OPTION_ID,			");
	sql.append("	OPTION_TITLE,		");
	sql.append("	OPTION_PRICE,		");
	sql.append("	OPTION_PRICE_UNIT	");
	sql.append("FROM RESERVE_OPTION		");
	sql.append("WHERE ROOM_ID = ?		");
	optionList = jdbcTemplate.query(sql.toString(), new ReserveList(), new Object[]{room_id});
	
	// 가격 리스트
	sql = new StringBuffer();
	sql.append("SELECT 																								");
	sql.append("	CASE 																							");
	sql.append(" 		WHEN RESERVE_TYPE = '교실' OR RESERVE_TYPE = '강당' OR RESERVE_TYPE = '운동장' 					");
	sql.append(" 		THEN TO_CHAR((SELECT PRICE_1 FROM RESERVE_PRICE WHERE RESERVE_TYPE = A.RESERVE_TYPE AND		");
	sql.append(" 			AREA_TYPE = (SELECT AREA_TYPE FROM RESERVE_SCHOOL WHERE SCHOOL_ID = A.SCHOOL_ID)))		");
	sql.append(" 		WHEN RESERVE_TYPE = '기타시설'																	");
	sql.append(" 		THEN A.ETC_PRICE1																			");
	sql.append(" 	END AS PRICE_1,																					");
	sql.append("	CASE 																							");
	sql.append(" 		WHEN RESERVE_TYPE = '교실' OR RESERVE_TYPE = '강당' OR RESERVE_TYPE = '운동장' 					");
	sql.append(" 		THEN TO_CHAR((SELECT PRICE_2 FROM RESERVE_PRICE WHERE RESERVE_TYPE = A.RESERVE_TYPE AND		");
	sql.append(" 			AREA_TYPE = (SELECT AREA_TYPE FROM RESERVE_SCHOOL WHERE SCHOOL_ID = A.SCHOOL_ID)))		");
	sql.append(" 		WHEN RESERVE_TYPE = '기타시설'																	");
	sql.append(" 		THEN A.ETC_PRICE2																			");
	sql.append(" 	END AS PRICE_2,																					");
	sql.append("	CASE 																							");
	sql.append(" 		WHEN RESERVE_TYPE = '교실' OR RESERVE_TYPE = '강당' OR RESERVE_TYPE = '운동장' 					");
	sql.append(" 		THEN TO_CHAR((SELECT PRICE_3 FROM RESERVE_PRICE WHERE RESERVE_TYPE = A.RESERVE_TYPE AND		");
	sql.append(" 			AREA_TYPE = (SELECT AREA_TYPE FROM RESERVE_SCHOOL WHERE SCHOOL_ID = A.SCHOOL_ID)))		");
	sql.append(" 		WHEN RESERVE_TYPE = '기타시설'																	");
	sql.append(" 		THEN A.ETC_PRICE3																			");
	sql.append("	END AS PRICE_3																					");
	sql.append("FROM RESERVE_ROOM A																					");
	sql.append("WHERE ROOM_ID = ?																					");
	priceList = jdbcTemplate.query(sql.toString(), new ReserveList(), new Object[]{room_id});

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
	
	//시작일
	$('#date_start').datepicker({
		dateFormat: "yy-mm-dd",   // 날짜의 형식
		onClose: function( selectedDate ) {    
		// 시작일(fromDate) datepicker가 닫힐때
		// 종료일(toDate)의 선택할수있는 최소 날짜(minDate)를 선택한 시작일로 지정
		$("#date_end").datepicker( "option", "minDate", selectedDate );
		}                
	});
	//종료일
	$('#date_end').datepicker({
		 dateFormat: "yy-mm-dd",
		 changeMonth: true,
		 //minDate: 0, // 오늘 이전 날짜 선택 불가
		  onClose: function( selectedDate ) {
		   // 종료일(toDate) datepicker가 닫힐때
		   // 시작일(fromDate)의 선택할수있는 최대 날짜(maxDate)를 선택한 종료일로 지정 
		   $("#date_start").datepicker( "option", "maxDate", selectedDate );
		   }                
	});
	
	 /*  $( "#date_start" ).datepicker({
	    dateFormat: 'yy-mm-dd'
	  });
	  $( "#date_end" ).datepicker({
	    dateFormat: 'yy-mm-dd'
	  }); */
});

function reserveTypeChange(){
	if($("#postForm #reserve_type").val() != "기타시설"){
		$("#postForm #reserve_type2").remove();
	}
	
	$("#postForm #room_id").remove();
	$("#postForm #price_1").remove();
	$("#postForm #price_2").remove();
	$("#postForm #price_3").remove();
	$("#postForm #total_price").remove();
	$("#postForm #use_type").remove();
	$("#postForm #user_name").remove();
	$("#postForm #organ_name").remove();
	$("#postForm #user_phone").remove();
	$("#postForm #reserve_man").remove();
	$("#postForm #use_purpose").remove();
	
	$("#postForm").attr("/index.gne");
	$("#postForm").attr("method", "get");
	$("#postForm").submit();
}

function reserve(dayValue){
	$("#postForm #date_start").val(dayValue);
	$("#postForm #date_end").val(dayValue);
	reserveTypeChange();
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
<form id="postForm" class="booking">
<input type="hidden" id="menuCd" name="menuCd" value="<%=menuCd%>">
<input type="hidden" id="school_id" name="school_id" value="<%=school_id%>">
<input type="hidden" id="room_id" name="room_id" value="<%=room_id%>">
<input type="hidden" name="year" id="year" value="<%=year%>">
<input type="hidden" name="month" id="month" value="<%=month%>">
<input type="hidden" name="nowDate" id="nowDate" value="<%=nowDate%>">
<section class="sec1 topbox1 school_info">
	<h3><%=school_name%></h3>
	<p class="kind mag0">
		<label>시설명
			<select id="reserve_type" name="reserve_type" onchange="reserveTypeChange()">
				<%if(reserveTypeList!=null && reserveTypeList.size()>0){ 
					for(ReserveVO ob : reserveTypeList){%>
					<option value="<%=ob.reserve_type%>" <%if(reserve_type.equals(ob.reserve_type)){%> selected <%}%> ><%=ob.reserve_type%></option>
				<%	}
				} %>
			</select>
		</label>
	</p>
	<%if(!"".equals(reserve_type2)){%>
	<p class="kind">
		<label>기타시설 명
		<select id="reserve_type2" name="reserve_type2" onchange="reserveTypeChange()">
			<%if(reserveType2List!=null && reserveType2List.size()>0){ 
				for(ReserveVO ob : reserveType2List){%>
				<option value="<%=ob.reserve_type2%>" <%if(ob.reserve_type2.equals(reserve_type2)){%> selected <%}%> ><%=ob.reserve_type2%></option>
			<%	}
			} %>
		</select>
	</label>
	<%}%>
	<p class="kind">
		<label>
			사용시설 수
			<select name="countVal" id="countVal" onchange="reserveTypeChange()">
			<%for(int i=1; i<=reserve_number; i++){%>
				<option value="<%=i%>" <%if(countVal == i){%> selected <%}%>><%=i%></option>
			<%}%>
			</select>
		</label>
	</p>
</section>

<section class="sec2 topbox2">
	<h3 class="title">사용일자</h3>
	<!-- <span class="red subscript">* 날짜 다중선택이 가능합니다.</span> -->
		<div class="datesel item col-5 mo-col-12">
			<ul id="calDay" class="type03">
				<li>
					시작날짜 : <input type="text" name="date_start" id="date_start" readonly="readonly" value="<%=date_start%>">
				</li>
				<li>
					종료날짜 : <input type="text" name="date_end" id="date_end" readonly="readonly" value="<%=date_end%>"> 
				</li>
			</ul>
			<ul id="checkDiv">
			</ul>
		</div>
		<div class="cal item col-7 mo-col-12">
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
			   				<a href="javascript:reserve('<%=dayValue%>');" class="day" title="예약가능">
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
		</div>
		<div class="clr"> </div>
</section>
<!-- // 달력 끝 -->



<!-- 예약시간 선택 -->
<section class="sec3 topbox3">
	<h3 class="title"> 예약시간 선택</h3>
	<span class="red subscript">* 시작시간과 종료시간을 선택하세요.</span>
	<div class="time_sel">
		<%
		String time[] = {"0000", "0030", "0100", "0130", "0200", "0230", "0300", "0330", "0400", "0430", "0500", "0530"
				, "0600", "0630", "0700", "0730", "0800", "0830", "0900", "0930", "1000", "1030", "1100", "1130", "1200", "1230", "1300", "1330"
				, "1400", "1430", "1500", "1530", "1600", "1630", "1700", "1730", "1800", "1830", "1900", "1930", "2000", "2030", "2100", "2130"
				, "2200", "2230", "2300", "2330", "2400"};
		
		String timeUseAbleCheck = "N";
		
		for(String ob : time){
			timeUseAbleCheck = "N";
			for(ReserveVO ob2 : toDayTimeList){
				if("평일".equals(ob2.day_of_week)){
					if(!"".equals(ob2.time_start_a)){
						if(Integer.parseInt(ob2.time_start_a) <= Integer.parseInt(ob) &&
								Integer.parseInt(ob2.time_end_a) >= Integer.parseInt(ob)){
							timeUseAbleCheck = "Y";
							break;
						}
					}
					if(!"".equals(ob2.time_start_a2)){
						if(Integer.parseInt(ob2.time_start_a2) <= Integer.parseInt(ob) &&
								Integer.parseInt(ob2.time_end_a2) >= Integer.parseInt(ob)){
							timeUseAbleCheck = "Y";
							break;
						}
					}
				}else if("토".equals(ob2.day_of_week)){
					if(!"".equals(ob2.time_start_b)){
						if(Integer.parseInt(ob2.time_start_b) <= Integer.parseInt(ob) &&
								Integer.parseInt(ob2.time_end_b) >= Integer.parseInt(ob)){
							timeUseAbleCheck = "Y";
							break;
						}
					}
					if(!"".equals(ob2.time_start_b2)){
						if(Integer.parseInt(ob2.time_start_b2) <= Integer.parseInt(ob) &&
								Integer.parseInt(ob2.time_end_b2) >= Integer.parseInt(ob)){
							timeUseAbleCheck = "Y";
							break;
						}
					}
				}else if("일".equals(ob2.day_of_week)){
					if(!"".equals(ob2.time_start_c)){
						if(Integer.parseInt(ob2.time_start_c) <= Integer.parseInt(ob) &&
								Integer.parseInt(ob2.time_end_c) >= Integer.parseInt(ob)){
							timeUseAbleCheck = "Y";
							break;
						}
					}
					if(!"".equals(ob2.time_start_c2)){
						if(Integer.parseInt(ob2.time_start_c2) <= Integer.parseInt(ob) &&
								Integer.parseInt(ob2.time_end_c2) >= Integer.parseInt(ob)){
							timeUseAbleCheck = "Y";
							break;
						}
					}
				}
			}
			
			for(ReserveVO ob2 : toDayTimeBanList){
				if("평일".equals(ob2.day_of_week)){
					if(!"".equals(ob2.time_start_a)){
						if(Integer.parseInt(ob2.time_start_a) <= Integer.parseInt(ob) &&
								Integer.parseInt(ob2.time_end_a) >= Integer.parseInt(ob)){
							timeUseAbleCheck = "N";
							break;
						}
					}
					if(!"".equals(ob2.time_start_a2)){
						if(Integer.parseInt(ob2.time_start_a2) <= Integer.parseInt(ob) &&
								Integer.parseInt(ob2.time_end_a2) >= Integer.parseInt(ob)){
							timeUseAbleCheck = "N";
							break;
						}
					}
				}else if("토".equals(ob2.day_of_week)){
					if(!"".equals(ob2.time_start_b)){
						if(Integer.parseInt(ob2.time_start_b) <= Integer.parseInt(ob) &&
								Integer.parseInt(ob2.time_end_b) >= Integer.parseInt(ob)){
							timeUseAbleCheck = "N";
							break;
						}
					}
					if(!"".equals(ob2.time_start_b2)){
						if(Integer.parseInt(ob2.time_start_b2) <= Integer.parseInt(ob) &&
								Integer.parseInt(ob2.time_end_b2) >= Integer.parseInt(ob)){
							timeUseAbleCheck = "N";
							break;
						}
					}
				}else if("일".equals(ob2.day_of_week)){
					if(!"".equals(ob2.time_start_c)){
						if(Integer.parseInt(ob2.time_start_c) <= Integer.parseInt(ob) &&
								Integer.parseInt(ob2.time_end_c) >= Integer.parseInt(ob)){
							timeUseAbleCheck = "N";
							break;
						}
					}
					if(!"".equals(ob2.time_start_c2)){
						if(Integer.parseInt(ob2.time_start_c2) <= Integer.parseInt(ob) &&
								Integer.parseInt(ob2.time_end_c2) >= Integer.parseInt(ob)){
							timeUseAbleCheck = "N";
							break;
						}
					}
				}
			}
			
			for(ReserveVO ob2 : toDayTimeUseList){
				if(	(Integer.parseInt(ob2.time_start) <= Integer.parseInt(ob) &&
						Integer.parseInt(ob2.time_end) >= Integer.parseInt(ob))	){
					timeUseAbleCheck = "U";
					break;
				}
			}
			
			if("Y".equals(timeUseAbleCheck)){
		%>
			<label class="able">
				<input type="checkbox" value="<%=ob%>" class="time_value" id="" name="time_value"> <%=timeSet(ob)%>
			</label>
		<%	}else if("U".equals(timeUseAbleCheck)){%>
			<label class="disabled">
				<input type="checkbox" class="time_value" name="time_value" id="" value="<%=ob%>" disabled="disabled" > <%=timeSet(ob)%>
				<span class="on">사용중</span>
			</label>
		<%	}else if("N".equals(timeUseAbleCheck)){%>
		<label class="disabled">
			<input type="checkbox" class="time_value" name="time_value" id="" value="<%=ob%>" disabled="disabled"> <%=timeSet(ob)%>
		</label>
		<%	}
		} %>
		
		<script>
		function dateCheck(){
			
		}
		
		function cal_price(){
			if($("input[name=time_value]:checked").length == 2){
				var first = $("input[name=time_value]:checked").eq(0).val();
				var last = $("input[name=time_value]:checked").eq(1).val();
				var cnt;
				var price;
				
				if(first.substring(2,4) == '30'){	first 	= first.substring(0,2)	+ "50";}
				if(last.substring(2,4) 	== '30'){	last 	= last.substring(0,2) 	+ "50";}
				
				cnt = (last - first)/50;
				cnt = cnt/2;
				
				if(cnt<=2){
					price = $("#price_1").val(); 
				}else if(cnt>2 && cnt <=4){
					price = $("#price_2").val(); 
				}else if(cnt >4){
					price = $("#price_3").val(); 
				}
				
				$("#total_price").val(price);
				$("#total_price2").text(moneySet(price));
			}else{
				$("#total_price").val("0");
				$("#total_price2").text("0");
			}
		}
		function moneySet(x) {return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");}	// 금액에 콤마 붙여줌
		
		
		$("input[name=time_value]").click(function(){
			var cnt 		= $("input[name=time_value]:checked").length;
			var first;
			var last;
			var room_id 	= $("#room_id").val();
			var count 		= $("#count").val();
			var date_value 	= $("#date_start").val();
			
			if(cnt>2){
				alert("시작시간과 종료시간만 체크해 주시기 바랍니다.");
				$(this).prop("checked", false);
			}else{
				first = $("input[name=time_value]:checked").eq(0).val();
				last = $("input[name=time_value]:checked").eq(1).val();
				
				$.ajax({
					url : '/program/school_reserve/timeCheck.jsp',
					data : {
						room_id 	: room_id,
						count 		: count,
						first		: first,
						last		: last,
						date_value  : date_value
					},
					success : function(data) {
						var returnVal = data.trim();
						if(returnVal == "Y") {
							alert("예약 불가");
							$(".time_value").removeAttr("checked");
							cal_price();
						}else if(returnVal == "N"){
							cal_price();
						}else{
							$(".time_value").removeAttr("checked");
							alert("예약 불가");
							cal_price();
						}
					},
					error : function(e) {
						alert("에러발생");
						$(".time_value").removeAttr("checked");
						cal_price();
					}
				});
			}
		});
		
		</script>

		<div class="clr"> </div>
		<div class="c magT20">
				<button type="button" class="btn edge small wps_30 mako" onclick="timeCheck()">예약가능시간 확인</button>
		</div>
	</div>
</section>

<!-- 옵션선택 -->
<section class="sec4 topbox2">
	<h3 class="title">옵션선택</h3>
	<div class="topbox3">
	<%
	if(optionList!=null && optionList.size()>0){
		String optionMsg = "";
		for(ReserveVO ob : optionList){
			if("₩".equals(ob.option_price_unit)){
				optionMsg = "(사용금액에서 " + ob.option_price + "원이 가산됩니다.)";
			}else{
				optionMsg = "(사용금액에서 " + ob.option_price + "%가 가산됩니다.)";
			}
	%>
		<label>
			<input type="checkbox" name="option" value="<%=ob.option_price%>" id="" class=""><%=ob.option_title%> 사용 <%=optionMsg%>
		</label>
		<label>
			<input type="checkbox" name="optionVal" value="<%=ob.option_title%>" id="optionVal_" style="display: none;">
		</label>
	<%
		}
	}
	%>
				
	</div>
</section>
<!-- 사용금액 -->
<section class="sec5 topbox2">
	<h3 class="title">사용금액</h3>
	<%
	for(ReserveVO ob : priceList){
	%>
		<input type="hidden" name="price_1" id="price_1" value="<%=ob.price_1%>">
		<input type="hidden" name="price_2" id="price_2" value="<%=ob.price_2%>">
		<input type="hidden" name="price_3" id="price_3" value="<%=ob.price_3%>">
	<%
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
				<td>
					<label>
						<span class="mo_tit"><span class="red">&#42;</span> 예약자명</span>
						<input type="text" class="wps_80" name="user_name" id="user_name" value=""> 
					</label>
				</td>
				<th scope="row">사용단체명</th>
				<td>
					<label>
						<span class="mo_tit">사용단체명</span><input type="text" class="wps_100" name="organ_name" id="organ_name">
					</label> 
				</td>
			</tr>
			<tr>
				<th scope="row">
					<span class="red">&#42;</span> 휴대폰번호
				</th>
				<td>
					<label>
						<span class="mo_tit"><span class="red">&#42;</span> 휴대폰번호</span>
						<input type="text" class="wps_80" name="user_phone" id="user_phone">
					</label>
					<p class="fontsmall magT5">&#8251; 진행상태를 문자로 알려드립니다. 연락가능한 휴대전화번호를 <u class="red">숫자만</u> 정확히 기재하세요.</p>
				</td>
				<th scope="row">
					<label><span class="red">&#42;</span> 사용인원</label>
				</th>
				<td>
					<label for="reserve_man">
						<span class="mo_tit"><span class="red">&#42;</span> 사용인원</span>
						<input type="text" class="wps_80" name="reserve_man" id="reserve_man">
					</label>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="red">&#42;</span> 사용목적</th>
				<td colspan="3">
					<label>
						<span class="mo_tit"><span class="red">&#42;</span> 사용목적</span>
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
	<textarea name="" cols="" rows="" id="policy" class="wps_95 h050 list_select mT10">1. 개인정보의 수집 목적 우리 기관은 개인정보를 다음의 목적을 위해 처리합니다. 처리한 개인정보는 다음의 목적 이외의 용도로는 사용되지 않으며, 이용목적이 변경될 시에는 별도 공지를 할 예정입니다.
- 학교 시설 예약 신청 및 확인

※ 개인정보 수집 및 이용에 대하여 동의를 원하지 않을 경우 동의를 거부할 수 있으며, 본 서비스 이용 시 일부 메뉴 사용에 제한이 있을 수 있음을 알려드립니다.

2. 수집하는 개인정보의 항목
우리 기관은 본 서비스에서 아래와 같은 개인정보를 수집하고 있습니다.
- 예약자명, 전화번호

3. 개인정보의 보유 및 이용기간
이용자의 개인정보는 2년간 보유되며 기간이 만료되면 지체 없이 파기됩니다.
	</textarea>
	</label>
	<p class="r magT10"><label><input name="pInfoChk" type="checkbox" value="Y"> 개인정보 수집 및 이용에 대한 안내를 이해하였으며 동의합니다.</label></p>
</section>

<div class="c magT30">
	<button type="button" class="btn edge medium darkMblue" onclick="formPost()">예약하기</button>
	<button type="button" class="btn edge medium white" onclick="location.href='/index.gne?menuCd=<%=listPage%>'">취소하기</button>	
</div>
</form>
<%}catch(Exception e){out.println(e.toString());}%>