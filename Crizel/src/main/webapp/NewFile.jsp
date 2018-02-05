<%
/**
*   PURPOSE :   상시프로그램 insert action page
*   CREATE  :   201801230_tue    Ko
*   MODIFY  :   ....
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="util.jsp"%>
<%@ page import ="org.jsoup.Jsoup"%>
<%@ page import ="org.jsoup.nodes.Document"%>
<%@ page import ="org.jsoup.select.Elements"%>	
<%@ page import ="org.json.simple.JSONArray"%>	
<%@ page import ="org.json.simple.JSONObject"%>	
<%@ page import ="org.json.simple.parser.JSONParser"%>	
<%!
class BanVO{
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
String DB_URL = "jdbc:oracle:thin:@localhost:1521:xe";
String DB_USER = "edu";
String DB_PASSWORD = "1234";
Class.forName("oracle.jdbc.driver.OracleDriver");
Connection conn = null;
conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
PreparedStatement pstmt = null;
PreparedStatement pstmt2 = null;
ResultSet rs = null;
StringBuffer sql = null;



String mode				= parseNull(request.getParameter("mode"));

Object[] setObj 		= null;
int result 				= 0;
int count 				= 0;
	String pro_cat_nm 	= parseNull(request.getParameter("pro_cat_nm"));
	String pro_year 	= parseNull(request.getParameter("pro_year"));
	String pro_name 	= parseNull(request.getParameter("pro_name"));
	String aft_flag 	= parseNull(request.getParameter("aft_flag"));
	String max_per 		= parseNull(request.getParameter("max_per"));
	String show_flag 	= parseNull(request.getParameter("show_flag"));
	String pro_memo 	= parseNull(request.getParameter("pro_memo"));
	String reg_id	 	= parseNull(request.getParameter("reg_id"));
	String reg_ip	 	= parseNull(request.getParameter("reg_ip"));
	String pro_tch_nm	= parseNull(request.getParameter("pro_tch_nm"));
	
	pro_year = "2018";
	
int banno = 0;
try{
    List<BanVO> banList = getVO(pro_year);
	if(banList!=null && banList.size()>0){
		sql = new StringBuffer();
		sql.append("SELECT NVL(MAX(BANNO)+1,1) FROM ART_BAN_TABLE");
		banno = jdbcTemplate.queryForObject(
					sql.toString(),
					Integer.class
				);
		
		sql = new StringBuffer();
		sql.append("INSERT INTO ART_BAN_TABLE(				");
		sql.append("	BANNO,								");
		sql.append("	YEAR,								");
		sql.append("	BAN_NM,								");
		sql.append("	BAN_DATE,							");
		sql.append("	BAN_ETC								");
		sql.append(")										");
		sql.append("VALUES(									");
		sql.append("	?,									");
		sql.append("	?,									");
		sql.append("	?,									");
		sql.append("	?,									");
		sql.append("	''									");
		sql.append(")										");
		pstmt   =   conn.prepareStatement(sql.toString());
		
		for(BanVO ob : banList){
			pstmt.setInt(1, banno++);
			pstmt.setString(2, pro_year);
			pstmt.setString(3, ob.name);
			pstmt.setString(4, ob.year + "-" + ob.month + "-" + ob.day);
            pstmt.addBatch();
		}
		
		int[] batchCount 	=   pstmt.executeBatch();
		result      		=   batchCount.length;
	}
	
	if(result > 0){
		out.println("성공");
	}
       
	if(conn!=null){conn.close();}
	if(pstmt!=null){pstmt.close();}
}catch(Exception e){
	out.println(e.toString());
}finally{
	if(conn!=null){conn.close();}
	if(pstmt!=null){pstmt.close();}
}
%>
