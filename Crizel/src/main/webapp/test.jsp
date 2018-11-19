<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<title>JSP</title>
<body>
 <%
  String DB_URL = "jdbc:oracle:thin:@58.239.232.166:1521:ksis";
  String DB_USER = "rfc3";
  String DB_PASSWORD = "tkfkdgo";
  Class.forName("oracle.jdbc.driver.OracleDriver");
  Connection conn = null;
  PreparedStatement pstmt = null;
  ResultSet rs = null;
  String sql = "";
  List<Map<String,Object>> dataList = null;
  Map<String,Object> map = null;

  try { 
	conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);  
   	String name="";
   	sql+=("SELECT * FROM RFC_COMTNBBSDATA WHERE BOARD_ID = 'BBS_0000011' ORDER BY DATA_SID");
   	pstmt = conn.prepareStatement(sql);
   	rs = pstmt.executeQuery();

   	dataList = new ArrayList<Map<String,Object>>();
   	while (rs.next()) {
   		map = new HashMap<String,Object>();
   		map.put("DATA_TITLE", rs.getString("DATA_TITLE"));
   		map.put("REGISTER_DATE", rs.getString("REGISTER_DATE"));
   	 	dataList.add(map);
   	}
   
  } catch (Exception e) {
   	out.println(e.toString());
  }finally{
   	conn.close();
   	pstmt.close();
  }
  
%>
<style>
.photoList{display:none;}
</style>
<script>
function test(){
	
}
</script>
<a href="javascript:test();">사진보기</a>
<ul class="photoList">
<%
if(dataList!=null && dataList.size()>0){
	for(Map<String,Object> ob : dataList){
%>
	<li><%=ob.get("DATA_TITLE")%> ~ <%=ob.get("REGISTER_DATE")%></li>
<%
	}
}
%>
</ul>  
</body>
</html>