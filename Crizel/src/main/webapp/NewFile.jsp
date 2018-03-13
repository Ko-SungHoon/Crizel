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
<style>
table{width: 60%; margin:auto; text-align: center; padding:0; border-collapse: collapse;}
td,th{ border: 1px solid black;}
.sat{color:blue;}
.sun{color:red;}
.use{display: block; background: #A4FFFF; cursor: pointer;}
.use.on{background: #5CD1E5;}
table ul{list-style: none;}
table ul li{list-style: none;}
</style>
<script>
	function programView(e, dayVal, flag){	//e:this로 자신을 선택하기 위한 변수, dayVal : 달력에서 선택한 날짜 변수, flag : 오전/오후/전일반 구분
		var htmlVal = "";
		
		if(dayVal == ""){					//오전/오후/전일반 버튼을 클릭할 때는 날짜변수가 비어있으므로 input에 저장되어있는 날짜를 변수에 담아준다
			dayVal = $("#dayVal").val();
		}else{
			$("#dayVal").val(dayVal);		//달력을 클릭하여 해당 날짜를 input에 저장한다
			
			$(".use").removeClass("on");	//지금 클릭한 날짜 외의 span에 on 클래스를 제거한다
			$(e).addClass("on");			//클릭한 날짜의 span에 on 클래스를 추가한다
		}
		
		$.ajax({
			type : "POST",
			url : "/test2.jsp",
			//contentType : "application/x-www-form-urlencoded; charset=utf-8",
			contentType : "application/x-json; charset=utf-8",
			data : {
				dayVal 	: dayVal,
				flag	: flag
			},
			datatype : "json",
			success : function(data) {
				$.each(JSON.parse(data), function(i, val) {									//ajax로 받아온 json 데이터를 html로 구성한다
					htmlVal += "<li><span>프로그램 명 : " + val.title +  "</span>";
					htmlVal += "<ul>";
					htmlVal += "<li><span>프로그램 시간 : " + val.program_time + "</span></li>";
					htmlVal += "</ul>";	
					htmlVal += "</li>";
				});
				$(".selectedDate").text(dayVal);		//선택한 날짜 출력
				$(".programView").html(htmlVal);		//프로그램 리스트 출력
			},
			error:function(request,status,error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}
</script>
<script type="text/javascript" src="/js/jquery-1.11.3.min.js"></script>
</head>
<body>
<%!
private class CrizelVO{
	public int g_id;
	public String name;
	public String addr;
	public String type;
	public String tag1;
	public String tag2;
}
%>
<%
StringBuffer sql 		= null;
List<CrizelVO> list 	= null;
String name				= null;
ResultSet rs			= null;

try{
	sql = new StringBuffer();
	sql.append("SELECT *		");
	sql.append("FROM GIRLS		");
	sql.append("ORDER BY NAME	");
	list = jdbcTemplate.query(sql.toString(), 
			new RowMapper<CrizelVO>(){
				public CrizelVO mapRow(ResultSet rs, int rowNum) throws SQLException {
					CrizelVO vo = new CrizelVO();
		            vo.g_id = rs.getInt("G_ID");
		            vo.name	= rs.getString("NAME")==null?"":rs.getString("NAME");
		            vo.addr	= rs.getString("ADDR")==null?"":rs.getString("ADDR");
		            vo.type	= rs.getString("TYPE")==null?"":rs.getString("TYPE");
		            vo.tag1	= rs.getString("TAG1")==null?"":rs.getString("TAG1");
		            vo.tag2	= rs.getString("TAG2")==null?"":rs.getString("TAG2");
		            return vo;
		        }
			}
		);
	
	sql = new StringBuffer();
	sql.append("SELECT NAME		");
	sql.append("FROM GIRLS		");
	sql.append("WHERE NAME = ?	");
	try{
		name = jdbcTemplate.queryForObject(sql.toString(),String.class,	new Object[]{"경리"});
	}catch(Exception e){
		name = "";
	}
	
	
}catch(Exception e){
	out.println(e.toString());
}
%>
<%=name%> <br><br>
<%
for(CrizelVO ob : list){
%>
	이름 : <%=ob.name%><br>
	타입 : <%=ob.type%><br>
	주소 : <%=ob.addr%><br><br>
<%
}
%>

</body>
</html>


