<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import = "java.text.DateFormat"%>
<%@ page import = "java.text.ParseException"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "java.util.Calendar"%>
<%@ page import = "java.util.Date"%>

<%!public static List<Map<String, Object>> getResultMapRows(ResultSet rs)
		throws Exception {
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
		for (int indexOfcolumn = 0; indexOfcolumn < sizeOfColumn; indexOfcolumn++) {
			column = metaData.getColumnName(indexOfcolumn + 1);
			/** map에 값을 입력 map.put(columnName, columnName으로 getString) **/
			map.put(column, rs.getString(column));
		}
		/** list에 저장 **/
		list.add(map);
	}
	return list;
}%>

<%!
public static String parseNull(String strText) throws Exception {
	String rtnVal = "";
	try {
		if (strText != null) rtnVal = strText;
	} catch (Exception e) {
		return rtnVal;
	}
	return rtnVal;
}
%>

<%!
public String timeSet(String value){
	value = value==null?"":value;
	String val = value.substring(0,2);
	String val2 = value.substring(2,4);
	value = val + ":" + val2;
	return value;
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
ResultSet rs = null;
StringBuffer sql = null;
%>