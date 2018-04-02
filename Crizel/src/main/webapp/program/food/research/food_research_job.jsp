<%
/**
*   PURPOSE :   월별 조사 항목 및 개시
*   CREATE  :   20180320_tue    JI
*   MODIFY  :   조사내용 수정 script function 작성 20180320_tue    JI
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ page import="org.springframework.jdbc.core.*" %>
<%@ include file="/program/food/food_util.jsp" %>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

SessionManager sessionManager = new SessionManager(request);
String pageTitle = "월별 조사 항목 및 개시";

%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > <%=pageTitle%></title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
        <script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
        <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script>
</script>
</head>

<body>
<%
Calendar cal 	= Calendar.getInstance();
int year 		= cal.get(Calendar.YEAR);
int month 		= cal.get(Calendar.MONTH)+1;
int date		= cal.get(Calendar.DATE);

String yearStr 	= Integer.toString(cal.get(Calendar.YEAR));
String monthStr = month<10 	? "0" + Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1);
String dateStr	= date<10 	? "0" + Integer.toString(cal.get(Calendar.DATE)) 	: Integer.toString(cal.get(Calendar.DATE));

String search1 = parseNull(request.getParameter("search1"));	// 미조사식품
String search2 = parseNull(request.getParameter("search2"));	// 이상조사
String search3 = parseNull(request.getParameter("search3"));	// 권역
String search4 = parseNull(request.getParameter("search4"));	// 팀
String search5 = parseNull(request.getParameter("search5"));	// 구분
String search6 = parseNull(request.getParameter("search6"));	// 년도

StringBuffer sql = null;

int result = 0;

try{
	
}catch(Exception e){
	out.println(e.toString());
}
%>
<script>
    
    function newWin(url, title, w, h){
        var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
        var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

        var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
        var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

        var left = ((width / 2) - (w / 2)) + dualScreenLeft;
        var top = ((height / 2) - (h / 2)) + dualScreenTop;
        var newWindow = window.open(url, title, 'scrollbars=yes, resizable=yes, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
    }
    function updatePopup(upd_no, upd_flag, sts_flag){
    	var url = "?upd_no="+upd_no+"&upd_flag="+upd_flag+"&sts_flag="+sts_flag
    	newWin("food_update_popup.jsp"+url, 'PRINTVIEW', '1000', '740');
    }

    //조사 내용 수정 function
    function researchMod (type) {
        var url =   "/program/food/research/research_popup.jsp?mode=" + type;
        if (type == "mod") {
            if (confirm("조사내용을 수정하시겠습니까?\n조사내용을 수정하시면, 지금까지 조사한 내용이 사라집니다.\n조사를 처음부터 다시 시작해야 합니다.")) {
                newWin(url, "PRINTVIEW", "1000", "740");
            }
        } else {
            if (confirm("조사개시를 시작하시겠습니까?")) {
                newWin(url, "PRINTVIEW", "1000", "740");
            }
        }
    }

</script>

<div id="right_view">
		<div class="top_view">
				<p class="location"><strong><%=pageTitle %></strong></p>
				<p class="loc_admin">
                    <a href="/iam/main/index.sko?lang=en_US" target="_top" class="white">ENGLISH</a> <span class="yellow">[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span>님 안녕하세요.
                    <a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
                </p>
		</div>
</div>
<!-- S : #content -->
<div id="content">
	<h2 class="tit"><%=pageTitle%></h2>
	
	<h2 class="tit"><%=year%>년 <%=month%>월 조사기간입니다.</h2>
	<span>D-5</span>
	<span>조사품목 150/300 완료</span>
	<button type="button" class="btn small edge mako" onclick="researchMod('mod');">조사내용수정</button>
	<button type="button" class="btn small edge mako" >조사완료</button>
	<div class="searchBox magB20">
		<form id="searchForm" method="get" class="topbox2">
			<fieldset>
				<input type="checkbox" id="search1" name="search1">미조사 식품 보기
				<input type="checkbox" id="search2" name="search2">이상 조사 보기
				<select id="search3" name="search3">
					<option value="">권역 선택</option>
				</select>
				<select id="search4" name="search4">
					<option value="">팀 선택</option>
				</select>
				<select id="search5" name="search5">
					<option value="">구분 선택</option>
				</select>
				<button class="btn small edge mako" onclick="searchSubmit();">조회</button>
			</fieldset>
		</form>
	</div>
	
	<table class="bbs_list">
		<caption><%=pageTitle%> 테이블</caption>
		<colgroup>
			<col style="width: 5.2%">
			<col style="width: 5.2%">
			<col style="width: 5.2%">
			<col style="width: 5.2%">
			<col style="width: 5.2%">
			<col style="width: 5.2%">
			<col style="width: 5.2%">
			<col style="width: 5.2%">
			<col >
			<col style="width: 5.2%">
			<col style="width: 5.2%">
			<col style="width: 5.2%">
			<col style="width: 5.2%">
			<col style="width: 5.2%">
			<col style="width: 5.2%">
			<col style="width: 5.2%">
			<col style="width: 5.2%">
			<col style="width: 5.2%">
			<col style="width: 5.2%">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">식품 조사번호</th>
				<th scope="col">구분</th>	
				<th scope="col">식품코드</th>
				<th scope="col">식품명</th>
				<th scope="col">상세 식품명</th>
				<th scope="col">식품설명</th>
				<th scope="col">단위</th>
				<th scope="col">권역/팀</th>
				<th scope="col">학교/조사자</th>
				<th scope="col">조사가1</th>
				<th scope="col">조사가2</th>
				<th scope="col">조사가3</th>
				<th scope="col">조사가4</th>
				<th scope="col">조사가5</th>
				<th scope="col">조사처1 더보기</th>
				<th scope="col">견적업체 더보기</th>
				<th scope="col">사유</th>
				<th scope="col">팀장확인</th>
				<th scope="col">승인/반려</th>
			</tr>
		</thead>
		<tbody>
		<tr>
			<td>123</td>
			<td>농산물-1</td>
			<td>040001</td>
			<td>강남콩</td>
			<td>생것</td>
			<td>국산</td>
			<td>kg</td>
			<td>중부 1팀</td>
			<td>마산고등학교/영양사</td>
			<td>1,000</td>
			<td>1,000</td>
			<td>1,000</td>
			<td>1,000</td>
			<td>1,000</td>
			<td>마트</td>
			<td>푸르밀</td>
			<td></td>
			<td>확인</td>
			<td>승인/반려</td>
		</tr>
		<tr>
			<td>854</td>
			<td>농산물-2</td>
			<td>040064</td>
			<td>강남콩</td>
			<td>말린것</td>
			<td>국산</td>
			<td>kg</td>
			<td>서부 1팀</td>
			<td>창원고등학교/영양사</td>
			<td>1,000</td>
			<td>1,000</td>
			<td>1,000</td>
			<td>1,000</td>
			<td>1,000</td>
			<td>마트</td>
			<td>노래밀</td>
			<td>더보기</td>
			<td>미확인</td>
			<td>승인/반려</td>
		</tr>
		<tr>
			<td colspan="19">데이터가 없습니다.</td>
		</tr>
		</tbody>
	</table>


	
	<div class="searchBox magB20">
		<form id="searchForm" method="get" class="topbox2">
			<fieldset>
				<select id="search6" name="search6">
					<option value="">년도 선택</option>
					<option value="2018" <%if("2018".equals(search6)){out.println("selected");}%>>2018년</option>
					<option value="2017" <%if("2017".equals(search6)){out.println("selected");}%>>2017년</option>
					<option value="2016" <%if("2016".equals(search6)){out.println("selected");}%>>2016년</option>
				</select>
				<button class="btn small edge mako" onclick="searchSubmit();">조회</button>
				<div class="f_r">
					<button type="button" class="btn small edge mako" onclick="researchMod('new');">조사개시</button>
				</div>
			</fieldset>
		</form>
	</div>


	<h2 class="tit">2018년 조사 수 3 건</h2>
	<table class="bbs_list">
		<caption><%=pageTitle%> 테이블</caption>
		<colgroup>
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">조사번호</th>
				<th scope="col">년도</th>	
				<th scope="col">조사월</th>
				<th scope="col">조사명</th>
				<th scope="col">조사완료 여부</th>
				<th scope="col">개시일</th>
				<th scope="col">완료일</th>
				<th scope="col">조사항목 수</th>
				<th scope="col">미조사 수</th>
				<th scope="col">조사완료 수</th>
			</tr>
		</thead>
		<tbody>
		<tr>
			<td>1</td>
			<td>2018년</td>
			<td>1월</td>
			<td>2018년 1월 조사</td>
			<td>최종 완료</td>
			<td>20180101</td>
			<td>20180110</td>
			<td>1024</td>
			<td>10</td>
			<td>1014</td>
		</tr>
		<tr>
			<td>2</td>
			<td>2018년</td>
			<td>2월</td>
			<td>2018년 2월 조사</td>
			<td>최종 완료</td>
			<td>20180201</td>
			<td>20180210</td>
			<td>1024</td>
			<td>10</td>
			<td>1014</td>
		</tr>
		<tr>
			<td>3</td>
			<td>2018년</td>
			<td>3월</td>
			<td>2018년 3월 조사</td>
			<td>최종 완료</td>
			<td>20180301</td>
			<td>20180310</td>
			<td>1024</td>
			<td>10</td>
			<td>1014</td>
		</tr>
		<tr>
			<td colspan="10">데이터가 없습니다.</td>
		</tr>
		</tbody>
	</table>
</div>
<!-- // E : #content -->  
</body>
    
</html>