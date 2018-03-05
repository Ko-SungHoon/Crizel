<%@page import="org.springframework.jdbc.core.simple.SimpleJdbcTemplate"%>
<%@page import="org.springframework.jdbc.core.namedparam.SqlParameterSourceUtils"%>
<%@page import="org.springframework.jdbc.core.namedparam.SqlParameterSource"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@include file="util.jsp"%>
<%!
class Crizel{
	public int program_id;
	public String title;
	public String start_date;
	public String end_date;
	public String flag;
	public String program_time;
}

public void setVO(){
	
}
%>
<%
List<Crizel> crizels = new ArrayList<Crizel>();
Crizel vo = null;
vo = new Crizel();
vo.program_id 	= 3;
vo.title		= "3";
vo.start_date	= "2017-03-05";
vo.end_date		= "flag";
vo.flag			= "3";
vo.program_time	= "07:00~0900";
crizels.add(vo);

vo = new Crizel();
vo.program_id 	= 4;
vo.title		= "4";
vo.start_date	= "2017-03-05";
vo.end_date		= "flag";
vo.flag			= "4";
vo.program_time	= "07:00~0900";
crizels.add(vo);

vo = new Crizel();
vo.program_id 	= 5;
vo.title		= "5";
vo.start_date	= "2017-03-05";
vo.end_date		= "flag";
vo.flag			= "5";
vo.program_time	= "07:00~0900";
crizels.add(vo);

List<Object[]> batch = new ArrayList<Object[]>();
for (Crizel crizel : crizels) {
    Object[] values = new Object[] {
    		crizel.program_id,
    		crizel.title,
    		crizel.start_date,
    		crizel.end_date,
    		crizel.flag,
    		crizel.program_time
    	};
    batch.add(values);
}

StringBuffer sql = null;
try{
	sql = new StringBuffer();
	sql.append("INSERT INTO TEST(			");
	sql.append("	PROGRAM_ID,				");
	sql.append("	TITLE,					");
	sql.append("	START_DATE,				");
	sql.append("	END_DATE,				");
	sql.append("	FLAG,					");
	sql.append("	PROGRAM_TIME			");
	sql.append("	)						");
	sql.append("	VALUES(					");
	sql.append("	?,						");
	sql.append("	?,						");
	sql.append("	?,						");
	sql.append("	?,						");
	sql.append("	?,						");
	sql.append("	?						");
	sql.append("	)						");

	int[] updateCounts = jdbcTemplate.batchUpdate(
			sql.toString(), 
			batch
		);
	
	out.println(updateCounts);
}catch(Exception e){
	out.println("오류 : " + e.toString() + "<br>");
}

%>
</body>
</html>