<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.io.IOException,java.io.InputStreamReader,java.io.UnsupportedEncodingException,java.net.URL,java.util.Calendar " %>
<%@page import="org.json.simple.JSONArray,org.json.simple.JSONObject,org.json.simple.JSONValue " %>
<%@page import="javax.servlet.ServletContext" %>
<!DOCTYPE html>
<html>
<head>
<%@include file="/WEB-INF/jsp/header.jsp" %>
<style type="text/css">
</style>
<script src="/js/main.js"></script>

<script type="text/javascript" src="/pluginfree/js/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="/pluginfree/jsp/nppfs.script.jsp"></script>
<script type="text/javascript" src="/pluginfree/js/nppfs-1.9.0.js" charset="utf-8"></script>

<script type="text/javascript">
jQuery(document).ready(function(){	
	npPfsCtrl.isInstall({
		success : function(){
			npPfsCtrl.hideLoading();
			//$("#nos-install").html("설치됨");
			//alert("보안프로그램이 설치되어 있습니다.");
		},
		fail : function(){
			npPfsCtrl.hideLoading();
			//alert("보안프로그램의 설치가 필요합니다.");	
		}
	});
	//npPfsStartup("", true, true, false, false, "npkencrypt", "on");
});

</script>

<title>Crizel</title>
</head>
<!-- <body style="background: url('/img/bg03.jpg');"> -->
<body>
<%@include file="/WEB-INF/jsp/menu.jsp" %>

<div class="content">
	<ul class="bookMark">
		<li>
			<a href="/list.do">
				<img src="/img/video.png" />
			</a>
		</li>
		<li>
			<a href="/girls.do">
				<img src="/img/nana.jpg" />
			</a>
		</li>
		<li>
			<a href="/comic.do">
				<img src="/img/liverpool.jpg" />
			</a>
		</li>
	</ul>
	
	<div id="spinner">
		<vue-simple-spinner
		    size="big" message="로딩중..."
		    v-show="loading"
		></vue-simple-spinner>
	</div>
	
	<table class="tbl_main" id="mainMovie" v-if="records">
		<colgroup>
			<col width="15%">
			<col width="85%">
		</colgroup>
		<tr>
			<th colspan="3"><a href="http://www.cgv.co.kr/theaters/?theaterCode=0081" target="_blank"> {{ records.boxOfficeResult.boxofficeType }} </a></th>
		</tr>
		<tr v-for="(record, index) in records.boxOfficeResult.weeklyBoxOfficeList">
			<td>
				{{ record.rnum }}
			</td>
			<td>
				<a :href="'http://movie.naver.com/movie/search/result.nhn?query='+record.movieNm+'&section=all&ie=utf8'" target="_blank" >
					{{ record.movieNm }}
				</a>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<div id="saramin"></div>
			</td>
		</tr>
	</table>
	
	
	
	<%-- 
	
	<%!
	public String strFormat(int value){
		String strValue = "";
		if(value < 10){
			strValue = "0" + Integer.toString(value);
		}else{
			strValue = Integer.toString(value);
		}
		return strValue;
	}	
	%>
	<%
	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.DATE, -7);
	String date = strFormat(cal.get(Calendar.YEAR))+strFormat(cal.get(Calendar.MONTH))+strFormat(cal.get(Calendar.DATE));
	URL url = new URL("http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchWeeklyBoxOfficeList.json?"
			+ "key=af6cbec63ac47906095794b914d659e7&targetDt="+date);
	InputStreamReader isr = new InputStreamReader(url.openConnection().getInputStream(), "UTF-8");
	JSONObject object = (JSONObject) JSONValue.parse(isr);
	/* Object로 받을 경우 */
	JSONObject head = (JSONObject) object.get("boxOfficeResult");
	%>

	<table class="tbl_main">
		<colgroup>
			<col width="10%">
			<col width="50%">
			<col width="40%">
		</colgroup>
		<tr>
			<th colspan="3"><%=head.get("boxofficeType").toString() %> _ <a href="http://www.cgv.co.kr/theaters/?theaterCode=0081" target="_blank">진주 CGV</a></th>
		</tr>
	<%
	/* Array로 받을 경우 */
	//JSONArray bodyArray = (JSONArray) head.get("dailyBoxOfficeList");
	JSONArray bodyArray = (JSONArray) head.get("weeklyBoxOfficeList");
	for (int i = 0; i < bodyArray.size(); i++) {
		JSONObject data = (JSONObject) bodyArray.get(i);
	%>
		<tr>
			<td><%=data.get("rank").toString()%></td>
			<td class="left"><%=data.get("movieNm").toString()%></td>
	<%
		if(i == 0){
	%>
			<td rowspan="<%=bodyArray.size()%>">
				<div id="saramin"></div>
			</td>
	<%
	} 
	%>
		</tr>
	<%
	}
	%>
	</table>
	
	 --%>
	
	
</div>
</body>
</html>