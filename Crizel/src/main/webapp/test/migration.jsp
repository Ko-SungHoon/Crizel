<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.util.Map"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%!
public static List<Map<String, Object>> getResultMapRows(ResultSet rs) throws Exception {
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
			map.put(column, rs.getString(column)==null?"":rs.getString(column));
		}
		/** list에 저장 **/
		list.add(map);
	}
	return list;
}
%>
<%
String oriSql = "SELECT * FROM ANI ORDER BY ANI_ID	";
String newSql = "INSERT INTO ANI VALUES(			";

String oriUrl = "jdbc:oracle:thin:@localhost:1521:xe";
String oriClass = "oracle.jdbc.driver.OracleDriver";
String oriUser = "edu";
String oriPassword = "1234";

String newUrl = "jdbc:mysql://localhost/crizel";
String newClass = "com.mysql.jdbc.Driver";
String newUser = "edu";
String newPassword = "1234";

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
String sql = "";
List<Map<String,Object>> list = null;
List<String> keyList = null;
int result = 0;
int key = 0;

try { 
	//	1. 원본 DB 접속
	Class.forName(oriClass);
	conn = DriverManager.getConnection(oriUrl, oriUser, oriPassword);
	
	//	2. 원본 데이터를 리스트에 담기
	sql = new String();
	sql += oriSql;
	pstmt = conn.prepareStatement(sql);
   	rs = pstmt.executeQuery();
   	list = getResultMapRows(rs);
   	
   	//	3. 데이터의 키값(컬럼명)을 리스트에 담기
   	keyList = new ArrayList<String>();
   	for(int i=1; i<=rs.getMetaData().getColumnCount(); i++){	
   		keyList.add(rs.getMetaData().getColumnLabel(i));
	}
   	pstmt.close();
   	rs.close();
   	conn.close();
   	
   	
   	//	4. 데이터를 옮길 DB 접속
   	Class.forName(newClass);
   	conn = DriverManager.getConnection(newUrl, newUser, newPassword);
   	
   	//	5. 데이터를 옮겨받을 테이블에 데이터 입력하기
   	sql = new String();
   	sql += newSql;
   	for(int i=0; i<keyList.size(); i++){
   		if(i == 0){
   			sql += "?";	
   		}else{
   			sql += ", ?";
   		}
   	}
   	sql += ")";
   	pstmt = conn.prepareStatement(sql);
   	
   	for(int i=0; i<list.size(); i++){
   		Map<String,Object> ob = list.get(i);
   		key = 0;
   		for(int j=0; j<keyList.size(); j++){
   			pstmt.setString(++key, ob.get(keyList.get(j)).toString());
   		}
   		pstmt.addBatch();
   	}
   	result = pstmt.executeBatch().length;
   	
   	pstmt.close();
   	rs.close();
   	conn.close();
   	
   	out.println("result : " + result + "<br>");
   		
	
}catch(Exception e){
	out.println("ERR : " + e.toString() + "<br>");
}finally{
	pstmt.close();
	rs.close();
	conn.close();
}

%>
</body>
</html>