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
private class testVO{
	private int program_id;
	private String title;
	private String start_date;
	private String end_date;
	private String flag;
	private String program_time;
}

private class testVOMapper implements RowMapper<testVO> {
    public testVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	testVO vo = new testVO();
        vo.program_id 	= rs.getInt("PROGRAM_ID");
        vo.title 		= rs.getString("TITLE");
        vo.start_date	= rs.getString("START_DATE");
        vo.end_date 	= rs.getString("END_DATE");
        vo.flag 		= rs.getString("FLAG");
        vo.program_time	= rs.getString("PROGRAM_TIME");
        return vo;
    }
}

public String numberFormat(String val){
	if(Integer.parseInt(val) < 10){
		val = "0" + val;
	}
	return val;
}
public String numberFormat(int val){
	String strVal = "";
	if(val < 10){
		strVal = "0" + Integer.toString(val);
	}else{
		strVal = Integer.toString(val);
	}
	return strVal;
}
public List<String> getDates(String start_date, String end_date, List<String> dupCheck, String strSDay, String strEDay) throws ParseException{
	List<String> list = new ArrayList<String>();					//날짜를 담을 리스트
	Calendar cal = Calendar.getInstance();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");		
	String nowDate = start_date;									//현재날짜 변수(첫 날짜를 정한다)
	String nextDate = "";
	Date dateSDay = sdf.parse(strSDay);
	Date dateEDay = sdf.parse(strEDay);
	
	if(dateSDay.compareTo(sdf.parse(start_date)) >= 0){
		if(!dupCheck.contains(strSDay)){
			list.add(strSDay);										//해당 달의 1일보다 시작시간이 이를 경우 해당 달 1일을 리스트에 추가한다	
		}
	}else{
		if(!dupCheck.contains(start_date)){
			list.add(start_date);									//해당 달의 1일보다 시작시간이 느릴 경우 시작시간을 리스트에 추가한다
		}
	}
	while(true){
		Date date = new Date(); 
	    date = sdf.parse(nowDate);									//현재날짜 문자열을 날짜형식으로 변경
	    cal.setTime(date);											//현재날짜를 cal 변수의 날짜로 세팅
		cal.add(Calendar.DATE, 1);									//현재날짜에 1일을 더한다
		nextDate= sdf.format(cal.getTime());						//1일을 더한 날짜를 변수에 문자열로 담는다

		if(!dupCheck.contains(nextDate)){
			if(dateSDay.compareTo(cal.getTime()) == -1 && dateEDay.compareTo(cal.getTime()) >= 0){
				list.add(nextDate);									//해당 달의 1일~말일 사이의 날짜일 경우 1일을 더한 날짜를 리스트에 담는다
			}
		}
		
		if(nextDate.equals(end_date)){								//1일을 더한 날짜가 종료날짜와 같다면 반복문을 벗어난다
			break;
		}else{														//아닐경우 현재날짜 변수에 1일더한 날짜를 넣는다
			nowDate = nextDate;
		}
	}
	return list;
}
%>

<%
Calendar cal 		= Calendar.getInstance();
String year 		= request.getParameter("year")==null?Integer.toString(cal.get(Calendar.YEAR)):request.getParameter("year");   		//파라미터가 없으면 현재날짜 가져오기
String month 		= request.getParameter("month")==null?Integer.toString(cal.get(Calendar.MONTH)+1):request.getParameter("month"); 
int currentYear 	= Integer.parseInt(year);
int currentMonth 	= Integer.parseInt(month) - 1;
cal 				= Calendar.getInstance();
cal.set(currentYear, currentMonth, 1);
int startNum 		= cal.get(Calendar.DAY_OF_WEEK);   		// 선택 월의 시작요일을 구한다.
int lastNum 		= cal.getActualMaximum(Calendar.DATE);	// 선택 월의 마지막 날짜를 구한다. (2월인경우 28 또는 29일, 나머지는 30일과 31일)
cal.set(Calendar.DATE, lastNum);      						// Calendar 객체의 날짜를 마지막 날짜로 변경한다.
int weekNum 		= cal.get(Calendar.WEEK_OF_MONTH);   	// 마지막 날짜가 속한 주가 선택 월의 몇째 주인지 확인한다. 이렇게 하면 선택 월에 주가 몇번 있는지 확인할 수 있다.
int calCnt 			= weekNum * 7;         					// 반복횟수를 정한다
int dayVal 			= 1;            						// 날짜를 출력할 변수
int dayValCheck 	= 1;

StringBuffer sql 		= null;
testVO vo 				= null;
List<testVO> list 		= null;				
List<String> dateList 	= new ArrayList<String>();
Object[] setObj 		= null;

String strYear 	= Integer.toString(currentYear);
String strMonth = Integer.toString(currentMonth+1);
String strSDay 	= strYear + "-" + numberFormat(strMonth) + "-01";
String strEDay 	= strYear + "-" + numberFormat(strMonth) + "-" + Integer.toString(lastNum);

try{
	sql = new StringBuffer();
	sql.append("SELECT *											");
	sql.append("FROM TEST											");
	sql.append("WHERE ((? >= START_DATE AND ? <= END_DATE) OR 		");
	sql.append("	  (? <= START_DATE AND ? >= START_DATE)) 		");
	setObj = new Object[]{strSDay, strSDay, strSDay, strEDay};
	list = jdbcTemplate.query(
				sql.toString(), 
				new testVOMapper(),
				setObj
			);
	
	for(testVO ob : list){
		dateList.addAll(getDates(ob.start_date, ob.end_date, dateList, strSDay, strEDay));
	}
	
}catch(Exception e){
	out.println(e.toString());
}
%>
<script>
function searchSubmit(){
	$("#searchForm").attr("method", "get").attr("action", "").submit();
}
</script>

<table>
	<thead>
		<tr>
			<th colspan="<%=lastNum%>">
				<form id="searchForm" method="post" onchange="searchSubmit()">
					<%
					String[] yearArr = {"2018", "2017", "2016"};
					%>
					<select id="year" name="year">
					<%
						for(String ob : yearArr){
					%>
						<option value="<%=ob%>" <%if(ob.equals(strYear)){%> selected="selected" <%}%>><%=ob%>년</option>
					<%
						}
					%>
					</select>
					
					<%
					String[] monthArr = {"01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"};
					%>
					<select id="month" name="month" onchange="searchSubmit()">
					<%
						for(String ob : monthArr){
					%>
						<option value="<%=ob%>" <%if(ob.equals(numberFormat(strMonth))){%> selected="selected" <%}%>><%=ob%>월</option>		
					<%
						}
					%>
					</select>
				</form>
			</th>
		</tr>
		<tr>
			<th colspan="<%=lastNum%>">
				<%=strYear%>년 <%=numberFormat(strMonth)%>월
			</th>
		</tr>
		<tr>
		<%
		for(int i=1; i<=lastNum; i++){
					dayValCheck++;
		%>
					<td <%if(i==0){out.println("class='sun'");}else if(i==6){out.println("class='sat'");}%>>
		<%
						if(dayValCheck >= startNum && dayVal<=lastNum){
		%>
							<span 
							<%if(dateList.contains(strYear+"-"+numberFormat(strMonth)+"-"+numberFormat(dayVal))){%> class="use" 
							onclick="programView(this, '<%=strYear+"-"+numberFormat(strMonth)+"-"+numberFormat(dayVal)%>', '')" <%}%>>
								<%=dayVal++%>
							</span>
		<%
						}
		%>				
					</td>
		<%
		%>
				
		<% 
		} 
		%>
		</tr>
	</thead>
	<tbody>
	
	</tbody>
</table>

<table>
	<tr>
		<td>
			<input type="hidden" id="dayVal" name="dayVal">
			<span class="selectedDate"></span>
			<ul>
				<li>
					<span onclick="programView(this,'','1')">오전반</span>
					<span onclick="programView(this,'','2')">오후반</span>
					<span onclick="programView(this,'','3')">전일반</span>
				</li>
			</ul>
			<ul class="programView"></ul>
		</td>
	</tr>
</table>


</body>
</html>

