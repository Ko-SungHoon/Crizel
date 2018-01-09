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
<%@include file="util.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>TEST</title>
<script type="text/javascript" src="/js/jquery-1.11.3.min.js"></script>
</head>
<script>
document.title = "title change test";
</script>
<body>
<%

List<Map<String,Object>> list = null;
try{
	/* int insert = jdbcTemplate.update(
			"INSERT INTO INSTA(NAME, ADDR) VALUES(?, ?)",
			new Object[]{"테스트", "http://www.naver.com"}
	); */
		
	jdbcTemplate.update("delete from insta where name like '%테스트%'");
	
	list = jdbcTemplate.queryForList(
			/* "select * from insta where name in(?, ?)",
			new Object[]{"나나", "설현"} */
			"select * from insta"
			);
	int size = jdbcTemplate.queryForObject(
				"SELECT COUNT(*) FROM INSTA",
				Integer.class
			);
	
	String sql = "";
	sql += "MERGE INTO TEST2 A		";
	sql += "	USING(				";
	sql += "		SELECT *		";
	sql += "		FROM TEST		";
	sql += "	) B					";
	sql += "ON(A.ID = B.ID)			";
	sql += "WHEN NOT MATCHED THEN	";
	sql += "INSERT(A.ID)			";
	sql += "VALUES(B.ID)			";
	
	int b = jdbcTemplate.update(sql);
	
	out.println("b : " +b + "<br>");
	
	out.println(size + "<br>");
}catch(Exception e){
	out.println(e.toString());
}

for(Map<String,Object> ob : list){
	out.println("<a href='" + ob.get("ADDR").toString() + "' style='color:black;'>" + ob.get("NAME").toString() + "</a><br>");
}
%>



</body>
</html>