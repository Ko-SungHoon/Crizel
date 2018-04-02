<%
/**
*   PURPOSE :   업데이트 요청관리
*   CREATE  :   20180323_fri    Ko
*   MODIFY  :   ...
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ page import="org.springframework.jdbc.core.*" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

SessionManager sessionManager = new SessionManager(request);
String pageTitle = "접수요청 리스트";
%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > <%=pageTitle %></title>
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
String keyword = parseNull(request.getParameter("keyword"));
String search1 = parseNull(request.getParameter("search1"));

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

    //

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
	<div class="searchBox magB20">
		<form id="searchForm" method="get" class="topbox2">
			<fieldset>
				<select id="search1" name="search1">
					<option value="">검색분류 선택</option>
					<option value="nm_food" <%if("nm_food".equals(search1)){out.println("selected");}%>>식품명</option>
					<option value="dt_nm" <%if("dt_nm".equals(search1)){out.println("selected");}%>>상세식품명</option>
					<option value="ex_nm" <%if("ex_nm".equals(search1)){out.println("selected");}%>>식품설명</option>
				</select>
				<input type="text" id="keyword" name="keyword" value="<%=keyword%>">
				<button class="btn small edge mako" onclick="searchSubmit();">검색하기</button>
			</fieldset>
		</form>
	</div>
	<p class="clearfix"> </p>
	<table class="bbs_list">
		<caption><%=pageTitle%> 테이블</caption>
		<colgroup>
			<col style="width: 5.8%">
			<col style="width: 5.8%">
			<col style="width: 5.8%">
			<col >
			<col style="width: 5.8%">
			<col style="width: 5.8%">
			<col style="width: 5.8%">
			<col style="width: 5.8%">
			<col style="width: 5.8%">
			<col style="width: 5.8%">
			<col style="width: 5.8%">
			<col style="width: 5.8%">
			<col style="width: 5.8%">
			<col style="width: 5.8%">
			<col style="width: 5.8%">
			<col style="width: 5.8%">
			<col style="width: 5.8%">
		</colgroup>
		<thead>
			<tr>
				<th scope="col" colspan="7">식품정보</th>
				<th scope="col" colspan="4">변경요청자</th>
				<th scope="col" colspan="6">요청사항</th>
			</tr>
			<tr>
				<th scope="col">품목구분</th>
				<th scope="col">기존/변경</th>	
				<th scope="col">식품코드</th>
				<th scope="col">식품명</th>
				<th scope="col">상세식품명</th>
				<th scope="col">식품설명</th>
				<th scope="col">단위</th>
				<th scope="col">성명</th>
				<th scope="col">권역</th>
				<th scope="col">팀</th>
				<th scope="col">연락처</th>
				<th scope="col">내용</th>
				<th scope="col">사유</th>
				<th scope="col">요청일</th>
				<th scope="col">요청처리일</th>
				<th scope="col">상태</th>
				<th scope="col">비고</th>
			</tr>
		</thead>
		<tbody>
		<tr>
			<td>공산품-1</td>
			<td>기존</td>
			<td>170047</td>
			<td>탕수육</td>
			<td>냉동</td>
			<td>국산...더보기</td>
			<td>kg</td>
			<td>김요청</td>
			<td>서부권</td>
			<td>서부1팀</td>
			<td>055-716-0717</td>
			<td>품질내용</td>
			<td>제품설명 수정변경</td>
			<td>20180323</td>
			<td>-</td>
			<td>대기</td>
			<td>
				<button class="btn small edge green" type="button" onclick="updatePopup('1', 'M')">변경</button>
				<button class="btn small edge mako" type="button" onclick="updatePopup('1', 'M', 'R')">반려</button>
			</td>
		</tr>
		<tr>
			<td>공산품-2</td>
			<td>기존</td>
			<td>170048</td>
			<td>깐풍육</td>
			<td>냉동</td>
			<td>국산...더보기</td>
			<td>kg</td>
			<td>김요청</td>
			<td>서부권</td>
			<td>서부1팀</td>
			<td>055-716-0717</td>
			<td>품질내용</td>
			<td>제품설명 수정변경</td>
			<td>20180323</td>
			<td>-</td>
			<td>대기</td>
			<td>
				<button class="btn small edge green" type="button" onclick="updatePopup('1', 'A')">추가</button>
				<button class="btn small edge mako" type="button" onclick="updatePopup('1', 'A', 'R')">반려</button>
			</td>
		</tr>
		<tr>
			<td>공산품-3</td>
			<td>기존</td>
			<td>170049</td>
			<td>떡</td>
			<td>냉동</td>
			<td>국산...더보기</td>
			<td>kg</td>
			<td>김요청</td>
			<td>서부권</td>
			<td>서부1팀</td>
			<td>055-716-0717</td>
			<td>품질내용</td>
			<td>제품설명 수정변경</td>
			<td>20180323</td>
			<td>-</td>
			<td>대기</td>
			<td>
				<button class="btn small edge green" type="button" onclick="updatePopup('1', 'D')">삭제</button>
				<button class="btn small edge mako" type="button" onclick="updatePopup('1', 'D', 'R')">반려</button>
			</td>
		</tr>
		<tr>
			<td>공산품-4</td>
			<td>기존</td>
			<td>170050</td>
			<td>떡</td>
			<td>냉동</td>
			<td>국산...더보기</td>
			<td>kg</td>
			<td>김요청</td>
			<td>서부권</td>
			<td>서부1팀</td>
			<td>055-716-0717</td>
			<td>품질내용</td>
			<td>제품설명 수정변경</td>
			<td>20180323</td>
			<td>-</td>
			<td>반려</td>
			<td>
				-
			</td>
		</tr>
		<tr>
			<td colspan="17">데이터가 없습니다.</td>
		</tr>
		</tbody>
	</table>
</div>
<!-- // E : #content -->
</body>
</html>
