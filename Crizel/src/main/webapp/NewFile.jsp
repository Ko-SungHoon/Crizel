<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="org.springframework.jdbc.core.RowMapper"%>
<%@page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
String ip = request.getRemoteAddr();

if("112.163.77.52".equals(ip)){
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="/jquery/js/jquery-1.11.2.min.js"></script>
</head>
<body>
<%!
private class TestVO{
	public String[] col;
	
	public String tname;
}

private class TestList implements RowMapper<TestVO> {
    public TestVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	TestVO vo = new TestVO();
		int idx = 1;
		if(rs!=null){
			vo.col = new String[rs.getMetaData().getColumnCount()];
			for(int i=0; i<rs.getMetaData().getColumnCount(); i++){
				vo.col[i] = rs.getString(idx++);
			}
		}
        return vo;
    }
}

public String parseNull(String val){
	if(val == null){
		val = "";
	}
	return val;
}
%>
<%

WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(request.getSession().getServletContext());
DataSource dataSource = (DataSource) context.getBean("dataSource");
JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

String sql 				= new String();
Object[] setObj			= null;
List<String> setList	= new ArrayList<String>();
int result 				= 0;

List<TestVO> list 	= null;


String search1		= parseNull(request.getParameter("search1"));


try{
	sql = new String();
	sql += "SELECT TNAME 					";
	sql += "FROM TAB 						";
	sql += "WHERE 1=1						";
	if(!"".equals(search1)){
		sql += "AND TNAME LIKE '%'||?||'%'	";
		setList.add(search1);
	}

	setObj = new Object[setList.size()];
	for(int i=0; i<setList.size(); i++){
		setObj[i] = setList.get(i);
	}
	
	list = jdbcTemplate.query(sql, new TestList(), setObj);
	
	if(list!=null && list.size()>0){
		for(TestVO ob : list){
			out.println(ob.col[0] + "<br>");
		}
	}else{
		out.println("비어있음");
	}
	
}catch(Exception e){
	out.println(e.toString());
}
%>
<script>
function formSubmit(){
	$("#postForm").attr("action", "");
	$("#postForm").attr("method", "get");
	$("#postForm").submit();
}
</script>
<form id="postForm">
	<input type="text" id="search1" name="search1" value="<%=search1%>">
	<button type="button" onclick="formSubmit()">검색</button>
</form>
</body>
</html>

<%
}
%>
