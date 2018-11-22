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
<%!
public List<Map<String,Object>> getList(ResultSet rs) throws Exception{
	/** ResultSet의  MetaData를 가져온다. **/
	ResultSetMetaData metaData = rs.getMetaData();
	/** ResultSet의 Column의 갯수를 가져온다. **/
	int sizeOfColumn = metaData.getColumnCount();
	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
	Map<String, Object> map = null;
	String column = "";
	/** rs의 내용을 돌려준다 **/
	while (rs.next()) {
		/** 내부에서 map을 초기화 **/
		map = new HashMap<String, Object>();
		/** Column의 갯수만큼 회전 **/
		for (int indexOfcolumn = 0; indexOfcolumn < sizeOfColumn; indexOfcolumn++){
			column = metaData.getColumnName(indexOfcolumn + 1);
			/** map에 값을 입력 map.put(columnName, columnName으로 getString) **/
			map.put(column, parseNull(rs.getString(column)));
		}
		/** list에 저장 **/
		list.add(map);
	}
	return list;
}
public String parseNull(String val){
	if(val == null){
		val = "";
	}
	return val;
}
public String getString(Map<String,Object> map, String key){
	String val = "";
	if(map!=null && map.get(key)!=null){
		val = map.get(key).toString();
	}
	return val;
}
%>
 <%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8"); 
 
  String DB_URL = "jdbc:oracle:thin:@localhost:1521:xe";
  String DB_USER = "edu";
  String DB_PASSWORD = "1234";
  Class.forName("oracle.jdbc.driver.OracleDriver");
  Connection conn = null;
  PreparedStatement pstmt = null;
  ResultSet rs = null;
  String sql = "";
  List<Map<String,Object>> dataList = null;
  Map<String,Object> map = null;
  String column[] = null;
  int key = 0;
  int result = 0;

  try { 
	conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);  
   	String name="";
   	sql = new String();
   	sql += "SELECT * FROM ANI ORDER BY ANI_ID";
   	pstmt = conn.prepareStatement(sql);
   	rs = pstmt.executeQuery();
   	dataList = getList(rs);
   	
   	column = new String[]{"ANI_ID", "TITLE", "ANI_TIME", "DAY", "KEYWORD", "SITE", "LAST_TITLE", "DIRECTORY"};
   	if(dataList!=null && dataList.size()>0){
   		for(int i=0; i<dataList.size(); i++){
   			Map<String,Object> ob = dataList.get(i);
   			out.println(column[0] + " : " + getString(ob, column[0]) + "&nbsp;&nbsp;&nbsp; ");
   			out.println(column[1] + " : " + getString(ob, column[1]) + "&nbsp;&nbsp;&nbsp; ");
   			out.println(column[2] + " : " + getString(ob, column[2]) + "&nbsp;&nbsp;&nbsp; ");
   			out.println(column[3] + " : " + getString(ob, column[3]) + "&nbsp;&nbsp;&nbsp; ");
   			out.println(column[4] + " : " + getString(ob, column[4]) + "&nbsp;&nbsp;&nbsp; ");
   			out.println(column[5] + " : " + getString(ob, column[5]) + "&nbsp;&nbsp;&nbsp; ");
   			out.println(column[6] + " : " + getString(ob, column[6]) + "&nbsp;&nbsp;&nbsp; ");
   			out.println(column[7] + " : " + getString(ob, column[7]) + "<br>");
   		}
   	}
   	
   	if(conn!=null){conn.close();}
   	if(pstmt!=null){pstmt.close();}
   	
   	DB_URL = "jdbc:mysql://localhost:3306/crizel";
    DB_USER = "edu";
    DB_PASSWORD = "1234";
    Class.forName("com.mysql.jdbc.Driver");
    conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD); 
    
    sql = new String();
   	sql += "INSERT INTO ANI VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
   	pstmt = conn.prepareStatement(sql);
   	for(int i=0; i<dataList.size(); i++){
   		key = 0;
   		Map<String,Object> ob = dataList.get(i);
   		for(int j=0; j<column.length; j++){
   			pstmt.setString(++key, getString(ob, column[j]));
   		}
   		pstmt.addBatch();	
   	}
   	int[] useCnt 	=   pstmt.executeBatch();
   	result = useCnt.length;
   	
   	out.println("결과 : " + result);
	
   	
   	if(conn!=null){conn.close();}
   	if(pstmt!=null){pstmt.close();}
   	
   
  } catch (Exception e) {
   	out.println(e.toString());
  }finally{
	if(conn!=null){conn.close();}
	if(pstmt!=null){pstmt.close();}
  }
  
%>
</body>
</html>