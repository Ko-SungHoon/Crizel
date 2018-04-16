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
	jQuery("#userAgent").text(navigator.userAgent);

//	uV.dV.dk = ad.jt; // Debug
	
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

	
	
	//document.form1.cardNo1.focus();
	
	/*
	npPfsStartup(document.form1, false, true, true, "enc", "on");
	1. form 양식 : 기본값 DOM Document 상의 첫번째 form
	2. 개인방화벽 사용여부 : 기본값 false
	3. 키보드보안 사용여부 : 기본값 false
	4. 단말정보수집 사용여부 : 기본값 false
	5. 키보드보안 E2E 필드 설정 속성명 : 기본값 "enc"
	6. 키보드보안 E2E 필드 설정 속성값: 기본값 "on"
	부가적인 설정은(예, 설치확인 등) /pluginfree/js/nppfs-1.0.0.js를 수정하여 설정하십시오.
*/
/*
	npPfsStartup(
		document.form2
		, true
		, true
		, true
		, "npkencrypt"
		, "on"
	);
*/
	//URL Rewriting : Cookie가 허용되지 않는 브라우저에서는 다음 구문을 추가하여 쿠키없이도 동작이 가능하도록 처리
<%-- 	uV.dV.Gf = "<%= response.encodeURL("/pluginfree/jsp/nppfs.key.jsp") %>";    // 키발급 경로
	uV.dV.zf = "<%= response.encodeURL("/pluginfree/jsp/nppfs.remove.jsp") %>"; // 키삭제 경로
	uV.dV.zo = "<%= response.encodeURL("/pluginfree/jsp/nppfs.keypad.jsp") %>";  // 마우스입력기 페이지
	uV.dV.eP = "<%= response.encodeURL("/pluginfree/jsp/nppfs.ready.jsp") %>";  // 초기화상태 확인경로 
	uV.dV.Fz = "<%= response.encodeURL("/pluginfree/jsp/nppfs.install.jsp") %>"; // 설치안내 페이지

	uV.dV.de = "<%= response.encodeURL("/pluginfree/jsp/nppfs.session.jsp") %>"; // 세션유지 페이지
	uV.dV.aT = 10; // 세션유지 페이지 만료시간 --%>

	npPfsStartup(document.form1, true, true, false, false, "npkencrypt", "on");
});


/* function decryptKeyCryptData() {
	npPfsCtrl.waitSubmit(function(){
		document.form1.submit();
	});
}

function doDecrypt(){
	npPfsCtrl.waitSubmit(function(){
		document.form2.submit();
	});
} */

</script>

<title>Crizel</title>
</head>
<!-- <body style="background: url('/img/bg03.jpg');"> -->
<body>
<%@include file="/WEB-INF/jsp/menu.jsp" %>


<%-- <table>
	<tr>
 		<th style="text-align:left;font-size:14pt;">접속정보</th>
 	</tr>
	<tr>
 		<td>
			<span id="userAgent"></span>
		</td>
 		<td>
			<span id="nos-install"></span>
		</td>
	</tr>
</table> 

<form name="dummy">
</form>

<div style="margin-bottom:20px; padding:10px; border:1px solid #000;">
<table>
 	<tr>
 		<th style="text-align:left;font-size:14pt;">개인방화벽 테스트</th>
 	</tr>
	<tr>
		<td>
			<input type="button" name="startNos" id="startNos" value="방화벽 시작" onclick="npNCtrl.start();">
			<input type="button" name="stopNos" id="stopNos" value="방화벽 종료" onclick="npNCtrl.stop();">
			
		</td>
	</tr>
</table> 
</div>
<div style="margin-bottom:20px; padding:10px; border:1px solid #000;">

<form name="form1" action="<%= response.encodeURL("decrypt.jsp") %>" method="post" target="resultTarget">
<div id="nppfs-loading-modal" style="display:none;"></div>

	<input type="hidden" name="mode" value="KEYCRYPT" />
	<table width="100%">
		<colgroup>
			<col width="10%"></col>
			<col width="90%"></col>
		</colgroup>
		<tr>
			<th colspan="2" style="text-align:left;font-size:14pt;">키보드보안 테스트</th>
		</tr>
		<tr>
			<td> 미보호 </td>
			<td> <input type="text"     name="NONE_TEXT_2" id="n2" value="" npkencrypt="off" /></td>
		</tr>
		<tr>
			<td> FormOut ID </td>
			<td> <input type="text"     name="NONE_TEXT_4" id="t4" value=""></td>
		</tr>
		<tr>
			<td> FormOut PW </td>
			<td> <input type="password" name="NONE_PASS_4" id="p4" value=""></td>
		</tr>
		<tr>
			<td>E2E Id(Inca):</td>
			<td><input type="text"     name="E2E_TEXT_1" id="t1" style="ime-mode:disabled;" npkencrypt="key" value="" maxlength="14" /> : 14글자</td>
		</tr>
		<tr>
			<td>E2E PW(Inca):</td>
			<td><input type="password" name="E2E_PASS_1" id="p1" style="ime-mode:disabled;" npkencrypt="key" value="" maxlength="16" /> : 16글자</td>
		</tr>
		<tr>
			<td>E2E Card(Inca):</td>
			<td>
				<input type="password" name="cardNo1" id="cardNo1" style="ime-mode:disabled;" npkencrypt="key" value="" maxlength="4" size="4" style="width:20px;" />
				<input type="password" name="cardNo2" id="cardNo2" style="ime-mode:disabled;" npkencrypt="key" value="" maxlength="4" size="4" style="width:20px;" />
				<input type="password" name="cardNo3" id="cardNo3" style="ime-mode:disabled;" npkencrypt="key" value="" maxlength="4" size="4" style="width:20px;" />
				<input type="password" name="cardNo4" id="cardNo4" style="ime-mode:disabled;" npkencrypt="key" value="" maxlength="4" size="4" style="width:20px;" />
			</td>
		</tr>
		<tr>
			<td>E2E Id(Raon):</td>
			<td><input type="text"     name="E2E_RAON_TEXT_1" id="rt2" style="ime-mode:disabled;" enc="key" value="" maxlength="4" /> : 4글자</td>
		</tr>
		<tr>
			<td>E2E PW(Raon):</td>
			<td><input type="password" name="E2E_RAON_PASS_1" id="rp2" style="ime-mode:disabled;" enc="key" value="" maxlength="6" /> : 6글자</td>
		</tr>
		<tr>
			<td colspan="2">
				<input type="button" name="getClientKey" id="getClientKey" value="복호화" onclick="decryptKeyCryptData();">
			</td>
		</tr>
	</table>
</form>
</div>

<div style="margin-bottom:20px; padding:10px; border:1px solid #000;">
	<table width="100%">
	 	<tr>
	 		<th style="text-align:left;font-size:14pt;"> 복호화 테스트</th>
	 	</tr>
		<tr>
			<td>
	<iframe id="resultTarget" name="resultTarget" src="about:blank" style="border:0px solid #000;width:100%;height:300px;"></iframe>
			</td>
		</tr>
	</table>
</div> --%>

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
</div>
</body>
</html>