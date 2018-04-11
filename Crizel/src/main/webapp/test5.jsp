<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>
<%@page import="org.springframework.context.ApplicationContext" %>
<%@page import="org.springframework.jdbc.core.JdbcTemplate" %>
<%@page import="org.springframework.context.support.FileSystemXmlApplicationContext" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Map" %>
<%@page import="org.springframework.jdbc.core.*" %>
<%@include file="util.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>TEST</title>
<script type="text/javascript" src="/js/jquery-1.11.3.min.js"></script>
</head>
<body>
<%!
public class TestVO{
	String test1;
	String test2;
}

public class TestList implements RowMapper<TestVO> {
    public TestVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	TestVO vo 	= new TestVO();
    	String column 	= "";
    	for(int i=1; i<=rs.getMetaData().getColumnCount(); i++){		// 컬럼의 총 갯수만큼 반복하며 컬럼명과 같은 변수명에 데이터 입력
    		column = rs.getMetaData().getColumnLabel(i);
    		if("TEST1".equals(column)){					vo.test1				=	parseNull(rs.getString("TEST1"));			}
    		if("TEST2".equals(column)){					vo.test2				=	parseNull(rs.getString("TEST2"));			}
    	}
        return vo;
    }
    public String parseNull(String value){
    	value = value==null?"":value;
    	return value;
    }
}
%>
<%

String sql 				= new String();
List<Object[]> batch	= null;
Object[] value			= null;
int result 				= 0;
List<TestVO> list	 	= null;
int test1 				= 0;

String[] a = {"a", "b", "c", "d", "e", "f", "g", "H", "I", "A", "B", "C"};

sql = new String();
sql += "SELECT NVL(MAX(TEST1)+1,1) FROM TEST3		";
test1 = jdbcTemplate.queryForObject(sql, Integer.class);

if(a!=null && a.length>0){
	sql = new String();
	sql += "MERGE INTO TEST3 USING DUAL						";
	sql += "	ON(TEST2 = ?)								";
	sql += "	WHEN NOT MATCHED THEN						";
	sql += "	INSERT(TEST1, TEST2)						";
	sql += "	VALUES(TEST3_SEQ.NEXTVAL, ?)				";	
	batch = new ArrayList<Object[]>();
	for(String ob : a){
		value = new Object[]{
				ob				
				, ob
		};
		batch.add(value);
	}
	result = jdbcTemplate.batchUpdate(sql, batch).length;
	
	out.println("결과 : " + result + "<br>");
}


sql = new String();
sql += "SELECT * FROM TEST3	ORDER BY TEST1	";
list = jdbcTemplate.query(sql, new TestList());

if(list!=null && list.size()>0){
	for(TestVO ob : list){
		out.println("TEST1 : " + ob.test1 + "<br>");	
		out.println("TEST2 : " + ob.test2 + "<br><br>");
	}
}

%>
</body>
</html>

