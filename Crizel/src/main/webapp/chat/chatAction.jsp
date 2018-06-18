<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String nick_name 	= request.getParameter("nick_name")==null?"":request.getParameter("nick_name");
	String content		= request.getParameter("content")==null?"":request.getParameter("content");
	String reg_ip		= request.getParameter("reg_ip")==null?"":request.getParameter("reg_ip");
	String mode			= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String DB_URL 		= "jdbc:oracle:thin:@58.239.232.166:1521:ksis";
	String DB_USER 		= "ksis_hp";
	String DB_PASSWORD 	= "ksis0717";
	Class.forName("oracle.jdbc.driver.OracleDriver");
	Connection conn 	= null;
	conn 				= DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);  
	PreparedStatement pstmt 			= null;
	ResultSet rs 						= null;
	int result							= 0;
	String sql 							= "";
	List<Map<String,Object>> dataList 	= null;
	Map<String,Object> map				= null;
	
	String html = "";
	
	try { 
		if("write".equals(mode)){
			sql = new String();
			sql += "INSERT INTO CHAT(CHAT_NO, NICK_NAME, CONTENT, REG_IP, REG_DATE)			";
			sql += "VALUES((SELECT NVL(MAX(CHAT_NO)+1,1) FROM CHAT), ?, ?, ?, SYSDATE)		";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, nick_name);
			pstmt.setString(2, content);
			pstmt.setString(3, reg_ip);
			result = pstmt.executeUpdate();
		}
		
	sql = new String();
	sql += "SELECT * FROM CHAT ORDER BY CHAT_NO	";
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();
	dataList = new ArrayList<Map<String,Object>>();
	while (rs.next()) {
		map = new HashMap<String,Object>();
		map.put("CHAT_NO"	, rs.getString("CHAT_NO"));
		map.put("NICK_NAME"	, rs.getString("NICK_NAME"));
		map.put("CONTENT"	, rs.getString("CONTENT"));
		map.put("REG_IP"	, rs.getString("REG_IP"));
		map.put("REG_DATE"	, rs.getString("REG_DATE"));
		dataList.add(map);
	}
	
	if(dataList!=null && dataList.size() > 0){
		for(Map<String,Object> ob : dataList){
			html += ob.get("NICK_NAME") + " : " + ob.get("CONTENT") + "<br>";
		}
	}
	
	out.println(html);
	 
	} catch (Exception e) {
		System.out.println(e.toString());
		out.println(e.toString());
	}finally{
		conn.close();
	}
 %>
 
 <%!
 public String parseNull(String str){
	 
	 return str;
 }
 %>