<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>

<%
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
List<Map<String, Object>> dataList = null;
List<Map<String, Object>> timeList = null;
List<Map<String, Object>> groupList = null;


String reserve_date[] = request.getParameterValues("reserve_date");
String first = request.getParameter("first")==null?"1500":request.getParameter("first");
String last = request.getParameter("last")==null?"1700":request.getParameter("last");
String room_id = request.getParameter("room_id")==null?"1":request.getParameter("room_id");
String count = request.getParameter("count")==null?"1":request.getParameter("count");
String reserve_number = request.getParameter("reserve_number")==null?"1":request.getParameter("reserve_number");
int totalCount = Integer.parseInt(reserve_number) - Integer.parseInt(count);
int size = 0;
String reserve_group = "";
String returnVal = "Y";
int valCnt = 0;
String html = "";

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	int n = 0;
	
	for(int i=0; i<reserve_date.length; i++){
		sql = new StringBuffer();
		sql.append("SELECT TIME_VALUE, COUNT(*) ");
		sql.append("FROM RESERVE_TIME  ");
		sql.append("WHERE TIME_VALUE BETWEEN ? AND ? AND RESERVE_DATE = ? AND ROOM_ID = ? AND (TIME_USE ='Y' OR TIME_BAN ='Y') ");
		sql.append("GROUP BY TIME_VALUE ");
		sql.append("HAVING COUNT(*) > ? ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, first);
		pstmt.setString(2, last);
		pstmt.setString(3, reserve_date[i]);
		pstmt.setString(4, room_id);
		pstmt.setString(5, Integer.toString(totalCount));
		rs = pstmt.executeQuery();	
		if(rs.next()){	
			html += "<tr><td>" +  reserve_date[i] + "</td><td>" + first +  " ~ " + last + "</td><td><span class='red'>불가능</span></td><td><label><input type='checkbox' name='date_check' id='check_"+ valCnt +"' disabled='disabled' value='"+ reserve_date[i] +"' ></label></td></tr>";
			valCnt++;
		}else{
			if(valCnt == 0){
				html += "<tr><td>" + reserve_date[i] + "</td><td>" + first +  " ~ " + last + "</td><td><span class='green'>가능</span></td><td><label><input type='checkbox' checked='checked' readonly='readonly' name='date_check' id='check_"+ valCnt +"' value='"+ reserve_date[i] +"'></label></td></tr>";
			}else{
				html += "<tr><td>" + reserve_date[i] + "</td><td>" + first +  " ~ " + last + "</td><td><span class='green'>가능</span></td><td><label><input type='checkbox' name='date_check' id='check_"+ valCnt +"' value='"+ reserve_date[i] +"'></label></td></tr>";
			}
			valCnt++;
		}
	}
	
	//html += "<li><span onclick='dateConfirm()'>확인</span></li>";
	
} catch (Exception e) {
	%>
	<%=e.toString() %>
	<%
	/* e.printStackTrace();
	sqlMapClient.endTransaction();
	alertBack(out, "처리중 오류가 발생하였습니다."); */ 
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
}
%>
<%=html%>