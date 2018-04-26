<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.io.File"%>
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
public String parseNull(String val, String defalut){
	if(val == null){
		val = defalut;
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

String type			= parseNull(request.getParameter("type"), "list");
String tname		= parseNull(request.getParameter("tname"));
String search1		= parseNull(request.getParameter("search1"));


try{
	
	if("list".equals(type)){		// 테이블 리스트 출력 *************************************************************************
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
		
	}else if("view".equals(type)){  // 테이블 상세정보 출력 ************************************************************************
		sql = new String();
		sql += "SELECT * 			\n";
		sql += "FROM " + tname	+ "	\n";
		list = jdbcTemplate.query(sql, new TestList());
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

function goView(tname){
	$("#postForm #tname").val(tname);
	$("#postForm #type").val("view");
	$("#postForm").attr("action", "");
	$("#postForm").attr("method", "get");
	$("#postForm").submit();
}
</script>
<form id="postForm">
	<input type="hidden" id="type" name="type" value="<%=type%>">
	<input type="hidden" id="tname" name="tname" value="<%=tname%>">
	<input type="text" id="search1" name="search1" value="<%=search1%>">
	<button type="button" onclick="formSubmit()">검색</button>
</form>

<table>
<%
if("list".equals(type)){
	if(list!=null && list.size()>0){
		for(TestVO ob : list){
	%>
	<tr>
		<td>
			<a href="javascript:goView('<%=ob.col[0]%>')"><%=ob.col[0]%></a>
		</td>
	</tr>
	<%
		}
	}else{
		out.println("데이터가 없습니다.");
	}	
}else if("view".equals(type)){
	if(list!=null && list.size()>0){
		for(int i=0; i<list.size(); i++){
			TestVO ob = list.get(i);
	%>
	<tr>
		<td>
			<%
			for(int j=0; j<ob.col.length; j++){
				out.println(ob.col[j] + " ");
			}
			%>
		</td>
	</tr>
	<%
		}
	}else{
		out.println("데이터가 없습니다.");
	}
}
%>
</table>

<%-- 
<%
String path = request.getParameter("path")==null?"/":request.getParameter("path");
File file = new File(path);
List<Map<String,Object>> directoryList = new ArrayList<Map<String,Object>>();
Map<String,Object> directoryMap = null; 
List<String> fileList = new ArrayList<String>();

if(file.listFiles() != null){
	for(File ob : file.listFiles()){
		if(ob.isDirectory()){
			directoryMap = new HashMap<String,Object>();
			directoryMap.put("name", ob.getName());
			directoryMap.put("path", ob.getPath().replace("\\", "/"));
			directoryList.add(directoryMap);
		}else{
			fileList.add(ob.getName());
		}
	}
}

for(Map<String,Object> ob : directoryList){
	out.println("<a href='http://gnelib.gne.go.kr/lib_src/edu/test.jsp?path="+ob.get("path").toString()+"'>"+ob.get("name").toString()+"</a> <br>");
}

out.println("*********************************************************************************************<br>");

for(String ob : fileList){
	out.println("<a href='/lib_src/edu/test_list.jsp?filename="+ob+"&directory="+path+"'>" + ob + "<br>");
}

%>
 --%>
</body>
</html>

<%
}
%>
