<%@ include file="/program/class/UtilClass.jsp" %>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="org.jsoup.select.Elements"%>
<%@page import="org.jsoup.Jsoup"%>
<%@page import="org.jsoup.nodes.Document"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>TEST</title>
</head>
<body>
<%!
class BanVO {
	public String year;
	public String month;
	public String day;
	public String name;
}
public List<BanVO> getVO(String year){
	String json 		= "";
	List<BanVO> banList	= new ArrayList<BanVO>();
	BanVO vo			= new BanVO();
	try {
		Document document = Jsoup.connect("https://apis.sktelecom.com/v1/eventday/days?month=&year="+year+"&type=h&day=")
				.userAgent("Mozilla")
				.ignoreContentType(true)
				.header("TDCProjectKey", "61816f66-5e21-42aa-9d76-eed601aa42d5")
				.header("referer", "https://developers.sktelecom.com/projects/project_53742147/services/EventDay/Analytics/")
				.header("Accept", "application/json")
				.get();
		Elements elem = document.select("body");

		for (org.jsoup.nodes.Element e : elem) {
	    	json += e.text();
		}
	    
	    JSONParser parser = new JSONParser();
	    Object obj = parser.parse( json );
	    JSONObject jsonObj = (JSONObject) obj;
	    
	    JSONArray jsonArr = (JSONArray) jsonObj.get("results");
	    
	    for (int i = 0; i < jsonArr.size(); i++) {
			JSONObject data = (JSONObject) jsonArr.get(i);
			vo = new BanVO();
			vo.year 	= data.get("year").toString();
			vo.month 	= data.get("month").toString();
			vo.day 		= data.get("day").toString();
			vo.name 	= data.get("name").toString();
			banList.add(vo);
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	return banList;
}
%>

<%
Calendar cal 			= Calendar.getInstance();
List<String> yearList 	= new ArrayList<String>();
List<BanVO> list = new ArrayList<BanVO>(); 
int banno = 0;

StringBuffer sql 		= null;
Connection conn 		= null;
PreparedStatement pstmt = null;
int result = 0;

for(int i=1; i<=6; i++){	// 5년 후 까지 년도 저장
	yearList.add(Integer.toString(cal.get(Calendar.YEAR)+i));		
}

for(String ob : yearList){	// 5년 후 까지의 공휴일 저장
	list.addAll(getVO(ob));		
}

try{
	sqlMapClient.startTransaction();
    conn    =   sqlMapClient.getCurrentConnection();
	
	sql = new StringBuffer();
	sql.append("SELECT NVL(MAX(BANNO)+1,1) FROM ART_BAN_TABLE");
	banno = jdbcTemplate.queryForObject(
				sql.toString(),
				Integer.class
			);
	sql = new StringBuffer();
	sql.append("MERGE INTO ART_BAN_TABLE USING DUAL						");
	sql.append("	ON (BAN_DATE = ?)									");
	sql.append("WHEN NOT MATCHED THEN									");		
	sql.append("	INSERT(BANNO, YEAR, BAN_NM, BAN_DATE, BAN_ETC)		");	
	sql.append("	VALUES(?, ?, ?, ?, '')								");
	
	pstmt   =   conn.prepareStatement(sql.toString());
	
	for(BanVO ob2 : list){	//	공휴일을 DB에 저장
		pstmt.setString(1, ob2.year + "-" + ob2.month + "-" + ob2.day);
		pstmt.setInt(2, banno++);
		pstmt.setString(3, ob2.year);
		pstmt.setString(4, ob2.name);
		pstmt.setString(5, ob2.year + "-" + ob2.month + "-" + ob2.day);
	    pstmt.addBatch();
	}
	int[] batchCount 	=   pstmt.executeBatch();
	result      		=   batchCount.length;
	if(conn!=null){conn.close();}
	if(pstmt!=null){pstmt.close();}
	
	/* if(result > 0){
		out.println("<script>");
		out.println("alert('공휴일이 정상적으로 저장되었습니다.');");
		out.println("history.go(-1);");
		out.println("</script>");
	}else{
		out.println("<script>");
		out.println("alert('공휴일이 정상적으로 저장되지 않았습니다(이미 모든 공휴일이 저장되어있음).');");
		out.println("history.go(-1);");
		out.println("</script>");
	} */
}catch(Exception e){	
	if(conn!=null){conn.close();}
	if(pstmt!=null){pstmt.close();}
	sqlMapClient.endTransaction();
	
	/* out.println(e.toString());
	out.println("<script>");
	out.println("alert('처리중 오류가 발생하였습니다.');");
	out.println("history.go(-1);");
	out.println("</script>"); */
}
%>
</body>
</html>