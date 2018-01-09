<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<style type="text/css">
</style>
<style type="text/css">
table{
  width: 60%; 
  margin:auto; 
  text-align: center;
  padding:0;
  border-collapse: collapse;
 }
 td,th{
  border: 1px solid black;
 }
.sun{color:red;}
.sat{color:blue;}
</style>
<title>Crizel</title>
</head>
<body>
<%@include file="util.jsp" %>
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
	Calendar cal = Calendar.getInstance();
	String year = request.getParameter("year") == null ? Integer.toString(cal.get(Calendar.YEAR)) : request.getParameter("year"); //파라미터가 없으면 현재날짜 가져오기
	String month = request.getParameter("month") == null ? Integer.toString(cal.get(Calendar.MONTH) + 1) : request.getParameter("month");
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
	
	String nowY = Integer.toString(cal.get(Calendar.YEAR));
	String nowM = cal.get(Calendar.MONTH) + 1 < 10 ?"0" + Integer.toString(cal.get(Calendar.MONTH) + 1) : Integer.toString(cal.get(Calendar.MONTH) + 1);
	String nowD = "";
	String nowDate = nowY + "-" + nowM;
	
	String date_value = parseNull(request.getParameter("date_value"));

	List<Map<String, Object>> dataList = null;
	List<Map<String, Object>> dataList2 = null;
	
	List<Map<String, Object>> dateList3 = null;
	List<String> timeUseList = new ArrayList<String>();
	
	List<Map<String,Object>> dateList2 = null;
	List<String> timeDateList = new ArrayList<String>();
	List<String> timeList = new ArrayList<String>();
	String thisDate = "";
	int timeListCnt = 0;
	
	
	String allTime[] = new String[12];
	
	Map<String,Object> typeAmap = null;
	List<Map<String,Object>> typeA = new ArrayList<Map<String,Object>>();
	Map<String,Object> typeBmap = null;
	List<Map<String,Object>> typeB = new ArrayList<Map<String,Object>>();
	List<String> typeBlist = new ArrayList<String>();
	List<String> useY = new ArrayList<String>();
	List<String> useN = new ArrayList<String>();
	List<String> useW = new ArrayList<String>();
	
	List<String> dateList = new ArrayList<String>();
	
	String time[] = {"0600", "0630", "0700", "0730", "0800", "0830", "0900", "0930", "1000", "1030", "1100", "1130", "1200", "1230", "1300", "1330"
			, "1400", "1430", "1500", "1530", "1600", "1630", "1700", "1730", "1800", "1830", "1900", "1930", "2000", "2030", "2100", "2130"
			, "2200", "2230", "2300", "2330", "2400"};
	List<String> typeAtime = new ArrayList<String>();
	
	int timeCnt1 = 0;
	int timeCnt2 = 0;
	
	String date_id = "";

	boolean allDate = false;

	try {
		sql = new StringBuffer();
		sql.append("SELECT * FROM RESERVE_DATE WHERE RESERVE_TYPE = 'A'	");		//항시개방 개방시간
		pstmt = conn.prepareStatement(sql.toString());
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
		sql.append("SELECT * FROM RESERVE_DATE WHERE RESERVE_TYPE = 'B'	");		//특정일개방 날짜 및 개방시간
		pstmt = conn.prepareStatement(sql.toString());
		rs = pstmt.executeQuery();
		dataList = getResultMapRows(rs);
		if(rs!=null)rs.close();
		if(pstmt!=null)pstmt.close();
		
		
		for(int k=startNum; k<=lastNum; k++){
			typeAmap = new HashMap<String, Object>();
			nowD = k<10?"0"+Integer.toString(k):Integer.toString(k);
			typeAmap.put("date_value", nowDate+"-"+nowD);
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
		
		for(int i=0; i<dataList.size(); i++){
			Map<String,Object> map = dataList.get(i);
			for(int k=startNum; k<=lastNum; k++){
				nowD = k<10?"0"+Integer.toString(k):Integer.toString(k);
				if(isInDuration(map.get("DATE_START").toString(), map.get("DATE_END").toString(), nowDate + "-" + nowD)){
					typeBmap = new HashMap<String, Object>();
					typeBmap.put("date_value", nowDate+"-"+nowD);
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
					typeBlist.add(nowDate+"-"+nowD);
					typeB.add(typeBmap);
				}
			}
		}
		
		
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
					sql.append("SELECT * FROM RESERVE_USE WHERE DATE_VALUE = ?	");		
					pstmt = conn.prepareStatement(sql.toString());
					pstmt.setString(1, ob.get("date_value").toString());
					rs = pstmt.executeQuery();
					while(rs.next()){
						timeCnt2 = 0;
						for(int i=0; i<time.length; i++){
							if(Integer.parseInt(rs.getString("TIME_START")) <= Integer.parseInt(time[i]) && 
								Integer.parseInt(rs.getString("TIME_END")) >= Integer.parseInt(time[i])){
								timeCnt2++;
							}
						}
						
						if(timeCnt1 == timeCnt2){
							useY.add(ob.get("date_value").toString());
						}else{
							useW.add(ob.get("date_value").toString());
						}
						
					}
					if(rs!=null)rs.close();
					if(pstmt!=null)pstmt.close();
					
					if(!dateList.contains(ob.get("date_value").toString())){
						useW.add(ob.get("date_value").toString());
					}
				}
			}
		}
		
		/********************************************B 타입*************************************************************/
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
			
			if(typeBlist.contains(ob.get("date_value").toString())){
				sql = new StringBuffer();
				sql.append("SELECT * FROM RESERVE_USE WHERE DATE_VALUE = ?	");		
				pstmt = conn.prepareStatement(sql.toString());
				pstmt.setString(1, ob.get("date_value").toString());
				rs = pstmt.executeQuery();
				while(rs.next()){
					timeCnt2 = 0;
					for(int i=0; i<time.length; i++){
						if(Integer.parseInt(rs.getString("TIME_START")) <= Integer.parseInt(time[i]) && 
							Integer.parseInt(rs.getString("TIME_END")) >= Integer.parseInt(time[i])){
							timeCnt2++;
						}
					}
					
					if(timeCnt1 == timeCnt2){
						useY.add(ob.get("date_value").toString());
					}else{
						useW.add(ob.get("date_value").toString());
					}
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
		
		sql = new StringBuffer();
		sql.append("SELECT DATE_START, DATE_END , TIME_START_A, TIME_END_A, TIME_START_A2, TIME_END_A2, TIME_START_B, TIME_END_B, TIME_START_B2, TIME_END_B2, TIME_START_C, TIME_END_C, TIME_START_C2, TIME_END_C2  ");
		sql.append("FROM RESERVE_DATE  ");		
		sql.append("WHERE DATE_START <= ? AND DATE_END >= ?  ");		
		sql.append("GROUP BY DATE_START, DATE_END, TIME_START_A, TIME_END_A, TIME_START_A2, TIME_END_A2, TIME_START_B, TIME_END_B, TIME_START_B2, TIME_END_B2, TIME_START_C, TIME_END_C, TIME_START_C2, TIME_END_C2  ");		
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, date_value);
		pstmt.setString(2, date_value);
		rs = pstmt.executeQuery();
		dateList2 = getResultMapRows(rs);
		if(rs!=null)rs.close();
		if(pstmt!=null)pstmt.close();
		
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
		
		
		sql = new StringBuffer();
		sql.append("SELECT *  ");
		sql.append("FROM RESERVE_USE  ");		
		sql.append("WHERE DATE_VALUE = ?  ");		
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, date_value);
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

	} catch (Exception e) {
		out.println("에러 : " + e.toString());
	} finally {
		if(conn!=null)conn.close();
		if(rs!=null)rs.close();
		if(pstmt!=null)pstmt.close();
	}
	
	
%>
<a href="test.jsp">등록</a>

<table>
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
			for (int i = 0; i <= calCnt; i++) {

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
					
					nowD = j<10?"0"+Integer.toString(j):Integer.toString(j);
					if(useY.contains(nowDate+"-"+nowD)){
						out.println("<span>예약완료" + j + "</span>");	
					}else if(useW.contains(nowDate+"-"+nowD)){
						out.println("<span>예약가능<a href='test4.jsp?date_value="+ nowDate+"-"+nowD +"'>" + j + "</span>");	
					}else{
						out.println("<span>예약불가" + j + "</span>");	
					}
					//out.println("<span>" + j + "</span>");	
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
<form action="test5.jsp" method="post">
<%
int timeCnt = 0;
boolean timeBanCheck = false;
boolean timeUseCheck = false;
for(String ob : time){
	for(int i=0; i<timeList.size(); i++){
		if(ob.equals(timeList.get(i))){
			timeUseCheck = true;
		}
	}
	for(int i=0; i<timeUseList.size(); i++){
		if(ob.equals(timeUseList.get(i))){
			timeBanCheck = true;
		}
	}
	
	if(timeUseCheck){
		timeUseCheck = false;
		if(timeBanCheck){
			timeBanCheck = false;
		%>
		<input type="checkbox" name="time_value" value="<%=ob%>" disabled="disabled"> <%=timeSet(ob)%> 사용중
		<%	
		}else{
		%>
		<input type="checkbox" name="time_value" value="<%=ob%>" > <%=timeSet(ob)%> 사용가능
		<%
		}
	}else{
%>
<input type="checkbox" name="time_value" value="<%=ob%>" disabled="disabled"> <%=timeSet(ob)%>
<%	
	}
}
%>
</form>

</body>
</html>