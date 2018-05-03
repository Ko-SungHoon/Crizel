<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
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
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;


String room_id = parseNull(request.getParameter("room_id"),"2919");
String count = parseNull(request.getParameter("count"),"1");
String first = parseNull(request.getParameter("first"), "0900");
String last = parseNull(request.getParameter("last"), "1700");
String date_value = parseNull(request.getParameter("date_value"), "2018-05-22");

List<Map<String, Object>> dataList = null;
List<Map<String, Object>> banList = null;
List<String> timeBanList = new ArrayList<String>();
List<String> date_id_list = new ArrayList<String>();
int key = 0;
int result = 0;

int valCnt = 0;

String returnVal = "Y";

String time[] = {"0000", "0030", "0100", "0130", "0200", "0230", "0300", "0330", "0400", "0430", "0500", "0530"
		, "0600", "0630", "0700", "0730", "0800", "0830", "0900", "0930", "1000", "1030", "1100", "1130", "1200", "1230", "1300", "1330"
		, "1400", "1430", "1500", "1530", "1600", "1630", "1700", "1730", "1800", "1830", "1900", "1930", "2000", "2030", "2100", "2130"
		, "2200", "2230", "2300", "2330", "2400"};

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
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
	pstmt.setString(++key, date_value);
	pstmt.setString(++key, room_id);
	pstmt.setString(++key, date_value);
	pstmt.setString(++key, date_value);
	pstmt.setString(++key, count);
	rs = pstmt.executeQuery();
	while(rs.next()){
		date_id_list.add(rs.getString("DATE_ID"));
	}
	
	
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
		pstmt.setString(++key, date_value);
		pstmt.setString(++key, room_id);
		pstmt.setString(++key, count);
		rs = pstmt.executeQuery();
		while(rs.next()){
			date_id_list.add(rs.getString("DATE_ID"));
		}
		
	}
	
	for(int i=0; i<date_id_list.size(); i++){
		sql = new StringBuffer();
		sql.append("SELECT * FROM RESERVE_USE  ");
		sql.append("WHERE DATE_ID = ? AND ((TIME_START >= ? AND TIME_START <= ?) OR (TIME_START <= ? AND TIME_END >= ?)) AND DATE_VALUE = ? ");
		pstmt = conn.prepareStatement(sql.toString());
		key = 0;
		pstmt.setString(++key, date_id_list.get(i));
		pstmt.setString(++key, first);
		pstmt.setString(++key, last);
		pstmt.setString(++key, first);
		pstmt.setString(++key, first);
		pstmt.setString(++key, date_value);
		rs = pstmt.executeQuery();
		while(rs.next()){
			valCnt++;
		}
		if(rs!=null)rs.close();
		if(pstmt!=null)pstmt.close();
	}
	
	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_BAN  ");
	sql.append("WHERE ROOM_ID = ? AND (DATE_START <= ? AND DATE_END >= ?) ");
	pstmt = conn.prepareStatement(sql.toString());
	key = 0;
	pstmt.setString(++key, room_id);
	pstmt.setString(++key, date_value);
	pstmt.setString(++key, date_value);
	rs = pstmt.executeQuery();
	banList = getResultMapRows(rs);
	if(rs!=null)rs.close();
	if(pstmt!=null)pstmt.close();
	
	if(banList !=null && banList.size()>0 ){
		for(int i=0; i<banList.size(); i++){
			Map<String,Object> map = banList.get(i);
			out.println("TEST");
			for(int k=0; k<time.length; k++){
				if("평일".equals(getDateDay(date_value, "yyyy-MM-dd"))){
					if(map.get("TIME_START_A") != null && !"".equals(map.get("TIME_START_A").toString())){
						if(Integer.parseInt(map.get("TIME_START_A").toString()) <= Integer.parseInt(time[k]) && 
							Integer.parseInt(map.get("TIME_END_A").toString()) >= Integer.parseInt(time[k])){
							timeBanList.add(time[k]);
						}
					}
					if(map.get("TIME_START_A2") != null && !"".equals(map.get("TIME_START_A2").toString())){
						if(Integer.parseInt(map.get("TIME_START_A2").toString()) <= Integer.parseInt(time[k]) && 
							Integer.parseInt(map.get("TIME_END_A2").toString()) >= Integer.parseInt(time[k])){
							timeBanList.add(time[k]);
						}
					}
					
				}else if("토".equals(getDateDay(date_value, "yyyy-MM-dd"))){
					if(map.get("TIME_START_B") != null && !"".equals(map.get("TIME_START_B").toString())){
						if(Integer.parseInt(map.get("TIME_START_B").toString()) <= Integer.parseInt(time[k]) && 
							Integer.parseInt(map.get("TIME_END_B").toString()) >= Integer.parseInt(time[k])){
							timeBanList.add(time[k]);
						}
					}
					
					if(map.get("TIME_START_B2") != null && !"".equals(map.get("TIME_START_B2").toString())){
						if(Integer.parseInt(map.get("TIME_START_B2").toString()) <= Integer.parseInt(time[k]) && 
							Integer.parseInt(map.get("TIME_END_B2").toString()) >= Integer.parseInt(time[k])){
							timeBanList.add(time[k]);
						}
					}
				}else if("일".equals(getDateDay(date_value, "yyyy-MM-dd"))){
					if(map.get("TIME_START_C") != null && !"".equals(map.get("TIME_START_C").toString())){
						if(Integer.parseInt(map.get("TIME_START_C").toString()) <= Integer.parseInt(time[k]) && 
							Integer.parseInt(map.get("TIME_END_C").toString()) >= Integer.parseInt(time[k])){
							timeBanList.add(time[k]);
						}
					}
					
					if(map.get("TIME_START_C2") != null && !"".equals(map.get("TIME_START_C2").toString())){
						if(Integer.parseInt(map.get("TIME_START_C2").toString()) <= Integer.parseInt(time[k]) && 
							Integer.parseInt(map.get("TIME_END_C2").toString()) >= Integer.parseInt(time[k])){
							timeBanList.add(time[k]);
						}
					}
				}
			}
		}
	}
	
	for(String ob : timeBanList){
		if(Integer.parseInt(first) <= Integer.parseInt(ob) && Integer.parseInt(last) >= Integer.parseInt(ob)){
			valCnt++;
		}
	} 
	
	if(Integer.parseInt(count) > valCnt){
		returnVal = "N";						//N이 사용 가능 (기본 Y)
	}
	%>
	<%=returnVal %>
	
	<%

} catch (Exception e) {
	out.println(e.getMessage());
	sqlMapClient.endTransaction();
} finally {
	if(conn!=null)conn.close();
	if(rs!=null)rs.close();
	if(pstmt!=null)pstmt.close();
	sqlMapClient.endTransaction();
	
}
%>