<%
/**
*   PURPOSE :   권역관리
*   CREATE  :   20180321_wed    Ko
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
SessionManager sessionManager = new SessionManager(request);
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String pageTitle = "권역관리";
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
<%!

%>
<%

StringBuffer sql 				= null;
Object[] setObj         		= null;
List<String> setList			= new ArrayList<String>();
List<FoodVO> zoneCateList 		= null;
List<FoodVO> teamCateList 		= null;
List<FoodVO> researcherListT 	= null;
List<FoodVO> researcherListR 	= null;

List<FoodVO> zoneCnt			= null;
String teamAllCnt				= "";
List<FoodVO> teamCnt			= null;

String zone_no	= parseNull(request.getParameter("zone_no"));
String team_no	= parseNull(request.getParameter("team_no"));

Paging paging = new Paging();
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
int cnt = 0;
int num = 0;


try{
	sql = new StringBuffer();
	sql.append("SELECT * 				");
	sql.append("FROM FOOD_ZONE			");
	sql.append("WHERE SHOW_FLAG = 'Y'	");
	sql.append("ORDER BY ZONE_NM		");
	zoneCateList = jdbcTemplate.query(sql.toString(), new FoodList());
	
	if("".equals(zone_no) && zoneCateList!=null && zoneCateList.size()>0){zone_no = zoneCateList.get(0).zone_no;}
	
	if(!"".equals(zone_no)){
		sql = new StringBuffer();
		sql.append("SELECT * 								");
		sql.append("FROM FOOD_TEAM							");
		sql.append("WHERE 	SHOW_FLAG = 'Y' 				");
		sql.append("		AND ZONE_NO = ?					");
		sql.append("ORDER BY ZONE_NO, ORDER1, TEAM_NM		");
		teamCateList = jdbcTemplate.query(sql.toString(), new FoodList(), zone_no);
		
		//if("".equals(team_no) && teamCateList!=null && teamCateList.size()>0){team_no = teamCateList.get(0).team_no;}
		
		
		// 조사팀장 리스트
		sql = new StringBuffer();
		sql.append("SELECT * FROM(																");
		sql.append("	SELECT ROWNUM AS RNUM, A.* FROM (										");
		sql.append("SELECT																		");
		sql.append("	A.SCH_NO, 	A.SCH_ORG_SID, 	A.SCH_TYPE, A.SCH_ID, 		A.SCH_NM, 		");
		sql.append("	A.SCH_TEL,	A.SCH_FAX,		A.SCH_AREA,	A.SCH_POST,		A.SCH_ADDR,		");
		sql.append("	A.SCH_FOUND,A.SCH_URL,		A.SCH_GEN, 	A.SHOW_FLAG, 					");
		sql.append("	TO_CHAR(A.REG_DATE, 'YYYY-MM-DD') AS REG_DATE,			A.ZONE_NO,		");
		sql.append("	A.TEAM_NO,	A.SCH_GRADE,	A.SCH_LV,	A.SCH_PW,	 	A.SCH_APP_FLAG,	");
		sql.append("	A.APP_DATE,	A.ETC1,			A.ETC2,		A.ETC3,							");
		sql.append("	B.NU_NO,	B.NU_NM,		B.NU_TEL,	B.NU_MAIL,						");
		sql.append("	C.ZONE_NM,	D.TEAM_NM													");
		sql.append("FROM FOOD_SCH_TB A  LEFT JOIN FOOD_SCH_NU B ON A.SCH_NO = B.SCH_NO			");
		sql.append("					LEFT JOIN FOOD_ZONE C ON A.ZONE_NO = C.ZONE_NO			");
		sql.append("					LEFT JOIN FOOD_TEAM D ON A.TEAM_NO = D.TEAM_NO			");
		sql.append("WHERE C.SHOW_FLAG = 'Y'	AND A.SCH_GRADE = 'T'								");
		sql.append("	AND A.TEAM_NO != 0 AND A.ZONE_NO != 0									");
		sql.append("	AND A.ZONE_NO = " + zone_no + " 										");
		if(!"".equals(team_no)){
			sql.append("AND D.TEAM_NO = " + team_no + " 										");
		}
		sql.append("ORDER BY D.ORDER1															");
		sql.append("	)A 																		");
		sql.append(") 																			");
		researcherListT = jdbcTemplate.query(sql.toString(), new FoodList());
		
		
		// 조사자 리스트 카운트
		sql = new StringBuffer();
		sql.append("SELECT COUNT(*)																");
		sql.append("FROM FOOD_SCH_TB A  LEFT JOIN FOOD_SCH_NU B ON A.SCH_NO = B.SCH_NO			");
		sql.append("					LEFT JOIN FOOD_ZONE C ON A.ZONE_NO = C.ZONE_NO			");
		sql.append("					LEFT JOIN FOOD_TEAM D ON A.TEAM_NO = D.TEAM_NO			");
		sql.append("WHERE C.SHOW_FLAG = 'Y'	AND A.SCH_GRADE = 'R'								");
		sql.append("	AND A.TEAM_NO != 0 AND A.ZONE_NO != 0									");
		sql.append("	AND A.ZONE_NO = " + zone_no + " 										");
		if(!"".equals(team_no)){
			sql.append("AND D.TEAM_NO = " + team_no + " 										");
		}
		
		try{
			totalCount = jdbcTemplate.queryForObject(sql.toString(), Integer.class);
		}catch(Exception e){
			totalCount = 0;
		}
		
		paging.setPageNo(Integer.parseInt(pageNo));
		paging.setTotalCount(totalCount);
		paging.setPageSize(15);
		paging.makePaging();
		
		// 조사자 리스트
		sql = new StringBuffer();
		sql.append("SELECT * FROM(																");
		sql.append("	SELECT ROWNUM AS RNUM, C.* FROM (										");
		sql.append("SELECT																		");
		sql.append("	A.SCH_NO, 	A.SCH_ORG_SID, 	A.SCH_TYPE, A.SCH_ID, 		A.SCH_NM, 		");
		sql.append("	A.SCH_TEL,	A.SCH_FAX,		A.SCH_AREA,	A.SCH_POST,		A.SCH_ADDR,		");
		sql.append("	A.SCH_FOUND,A.SCH_URL,		A.SCH_GEN, 	A.SHOW_FLAG, 					");
		sql.append("	TO_CHAR(A.REG_DATE, 'YYYY-MM-DD') AS REG_DATE,			A.ZONE_NO,		");
		sql.append("	A.TEAM_NO,	A.SCH_GRADE,	A.SCH_LV,	A.SCH_PW,	 	A.SCH_APP_FLAG,	");
		sql.append("	A.APP_DATE,	A.ETC1,			A.ETC2,		A.ETC3,							");
		sql.append("	B.NU_NO,	B.NU_NM,		B.NU_TEL,	B.NU_MAIL,						");
		sql.append("	C.ZONE_NM,	D.TEAM_NM													");
		sql.append("FROM FOOD_SCH_TB A  LEFT JOIN FOOD_SCH_NU B ON A.SCH_NO = B.SCH_NO			");
		sql.append("					LEFT JOIN FOOD_ZONE C ON A.ZONE_NO = C.ZONE_NO			");
		sql.append("					LEFT JOIN FOOD_TEAM D ON A.TEAM_NO = D.TEAM_NO			");
		sql.append("WHERE C.SHOW_FLAG = 'Y'	AND A.SCH_GRADE = 'R'								");
		sql.append("	AND A.TEAM_NO != 0 AND A.ZONE_NO != 0									");
		sql.append("	AND A.ZONE_NO = " + zone_no + " 										");
		if(!"".equals(team_no)){
			sql.append("AND D.TEAM_NO = " + team_no + " 										");
		}
		sql.append("ORDER BY D.ORDER1															");
		sql.append("	) C WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" 			");
		sql.append(") WHERE RNUM > ").append(paging.getStartRowNo()).append(" 					");
		researcherListR = jdbcTemplate.query(sql.toString(), new FoodList());
		
		// 권역별 조사자 수
		sql = new StringBuffer();
		sql.append("SELECT A.ZONE_NO, COUNT(*) AS CNT										");
		sql.append("FROM FOOD_SCH_TB A  LEFT JOIN FOOD_SCH_NU B ON A.SCH_NO = B.SCH_NO		");	
		sql.append("LEFT JOIN FOOD_ZONE C ON A.ZONE_NO = C.ZONE_NO							");		
		sql.append("LEFT JOIN FOOD_TEAM D ON A.TEAM_NO = D.TEAM_NO							");	
		sql.append("WHERE C.SHOW_FLAG = 'Y' AND A.TEAM_NO != 0								");
		sql.append("GROUP BY A.ZONE_NO 														");
		zoneCnt = jdbcTemplate.query(sql.toString(), new FoodList());
		
		
		// 팀별 조사자 수 (전체)
		sql = new StringBuffer();
		sql.append("SELECT COUNT(*) AS CNT													");
		sql.append("FROM FOOD_SCH_TB A  LEFT JOIN FOOD_SCH_NU B ON A.SCH_NO = B.SCH_NO		");
		sql.append("					LEFT JOIN FOOD_ZONE C ON A.ZONE_NO = C.ZONE_NO		");		
		sql.append("LEFT JOIN FOOD_TEAM D ON A.TEAM_NO = D.TEAM_NO							");	
		sql.append("WHERE C.SHOW_FLAG = 'Y' AND A.ZONE_NO = ?								");
		sql.append("	AND A.TEAM_NO != 0 AND A.ZONE_NO != 0									");
		try{
			teamAllCnt = jdbcTemplate.queryForObject(sql.toString(), String.class, zone_no);
		}catch(Exception e){
			teamAllCnt = "0";
		}
		
		// 팀별 조사자 수 
		sql = new StringBuffer();
		sql.append("SELECT A.TEAM_NO, COUNT(*) AS CNT										");
		sql.append("FROM FOOD_SCH_TB A  LEFT JOIN FOOD_SCH_NU B ON A.SCH_NO = B.SCH_NO		");	
		sql.append("LEFT JOIN FOOD_ZONE C ON A.ZONE_NO = C.ZONE_NO							");		
		sql.append("LEFT JOIN FOOD_TEAM D ON A.TEAM_NO = D.TEAM_NO							");	
		sql.append("WHERE C.SHOW_FLAG = 'Y' AND A.ZONE_NO = ?								");
		sql.append("	AND A.TEAM_NO != 0 AND A.ZONE_NO != 0								");
		sql.append("GROUP BY A.TEAM_NO 														");
		teamCnt = jdbcTemplate.query(sql.toString(), new FoodList(), zone_no);
	}
	
	
}catch(Exception e){
	out.println(e.toString());
}


%>
<script>
</script>

<div id="right_view">
		<div class="top_view">
				<p class="location"><strong><%=pageTitle%></strong></p>
				<p class="loc_admin">
                    <a href="/iam/main/index.sko?lang=en_US" target="_top" class="white">ENGLISH</a> <span class="yellow">[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span>님 안녕하세요.
                    <a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
                </p>
		</div>
</div>
<!-- S : #content -->
	<div id="content">
	<div class="searchBox magB20">
	</div>
	<div class="f_r">
		<!-- <button type="button" class="btn small edge darkMblue" onclick="">추가</button> -->
	</div>
	
	<script>
	function zoneSelect(zone_no){
		$("#zone_no").val(zone_no);
		$("#team_no").val('');
		$("#postForm").attr("action", "");
		$("#postForm").attr("method", "get");
		$("#postForm").submit();
	}
	
	function teamSelect(team_no){
		$("#team_no").val(team_no);
		$("#postForm").attr("action", "");
		$("#postForm").attr("method", "get");
		$("#postForm").submit();
	}
	
	function newZone(){
		if(confirm("권역을 추가하시겠습니까?")){
			$("#zoneInsForm").attr("action", "food_zone_act.jsp");
			$("#zoneInsForm").attr("method", "post");	
			return true;
		}else{
			return false;
		}
	}
	
	function newWin(url, title, w, h){
		var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
	    var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

	    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
	    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

	    var left = ((width / 2) - (w / 2)) + dualScreenLeft;
	    var top = ((height / 2) - (h / 2)) + dualScreenTop;
	    var newWindow = window.open(url, title, 'scrollbars=yes, resizable=yes, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
	}

	function zonePopup(){newWin("food_zone_popup.jsp", 'PRINTVIEW', '1000', '740');}
	function teamPopup(zone_no){newWin("food_team_popup.jsp?zone_no="+zone_no, 'PRINTVIEW', '1000', '740');}
	function researcherPopup(){newWin("food_researcher_popup.jsp", 'PRINTVIEW', '1000', '740');}
	function detailPopup(sch_no){newWin("food_researcher_detail_popup.jsp?sch_no="+sch_no, 'PRINTVIEW', '1000', '740');}
	
	function disapproval(sch_no, zone_no, team_no, nu_nm){
		if(confirm("'" + nu_nm + "'님의 소속을 해제하시겠습니까?\n소속 해제된 조사자는 조사를 할 수 없습니다.")){
			location.href="food_zone_act.jsp?mode=disapproval&sch_no="+sch_no+"&zone_no="+zone_no+"&team_no="+team_no;
		}else{
			return false;
		}
	}
	</script>
	
	<form id="postForm">
		<input type="hidden" id="zone_no" name="zone_no" value="<%=zone_no%>">
		<input type="hidden" id="team_no" name="team_no" value="<%=team_no%>">
	</form>
	
	<div class="searchBox">
  		<form id="zoneInsForm" onsubmit="return newZone();">
  			<input type="hidden" id="mode" name="mode" value="zoneInsert">
  			<label for="zone_nm" class="blind">권역명</label>
  			<input type="text" name="zone_nm" id="zone_nm" required>
  			<button class="btn small edge mako">권역추가</button>
  			<button class="btn small edge mako" onclick="zonePopup()">권역수정</button>
  		</form>
  	</div>
	
	<div class="btn_area">
		<p class="boxin">
		<%
		if(zoneCateList!=null && zoneCateList.size()>0){
			String zoneButtonClass = "";
			String zoneCntStr = "";
			for(FoodVO ob : zoneCateList){
				zoneCntStr = "0";
				
				if(zone_no.equals(ob.zone_no)){zoneButtonClass = "btn medium mako";}
				else{zoneButtonClass = "btn medium white";}
				
				if(zoneCnt!=null && zoneCnt.size()>0){
					for(FoodVO ob2 : zoneCnt){ if(ob.zone_no.equals(ob2.zone_no)){ zoneCntStr = ob2.cnt; } }
				}
		%>
			<button type="button" onclick="zoneSelect('<%=ob.zone_no %>')" class="<%=zoneButtonClass%>">
				<%=ob.zone_nm%>(<%=zoneCntStr%>명)
			</button>
		<%
			}
		}
		%>
		</p>
	</div> 
	
	<div class="f_r">
		<button type="button" class="btn small edge mako" onclick="teamPopup('<%=zone_no%>');">팀 추가/수정</button>
		<button type="button" class="btn small edge mako" onclick="researcherPopup();">조사자등록</button>
	</div>
	
	<div class="btn_area">
		<%
		String teamButtonClass = "";
		if("".equals(team_no)){teamButtonClass = "btn medium mako";}
		else{teamButtonClass = "btn medium white";}
		%>
		<p class="boxin">
			<button type="button" onclick="teamSelect('')" class="<%=teamButtonClass%>">전체(<%=teamAllCnt%>명)</button>
		<%
		if(teamCateList!=null && teamCateList.size()>0){
			String teamCntStr = "";
			for(FoodVO ob : teamCateList){
				teamCntStr = "0";
				
				if(team_no.equals(ob.team_no)){teamButtonClass = "btn medium mako";}
				else{teamButtonClass = "btn medium white";}
				
				if(teamCnt!=null && teamCnt.size()>0){
					for(FoodVO ob2 : teamCnt){ if(ob.team_no.equals(ob2.team_no)){ teamCntStr = ob2.cnt; } }
				}
				
		%>
			<button type="button" onclick="teamSelect('<%=ob.team_no %>')" class="<%=teamButtonClass%>">
				<%=ob.team_nm %>(<%=teamCntStr%>명)
			</button>
		<%
			}
		}
		%>
		</p>
	</div> 
	
	<h2 class="tit">조사팀장</h2>
	<table class="bbs_list">
		<caption>조사팀장 정보 테이블</caption>
		<colgroup>
			<col style="width: 5%">
			<col>
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 5%">
			<col style="width: 10%">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">순서</th>
				<th scope="col">학교명(ID)</th>
				<th scope="col">학교단위</th>
				<th scope="col">영양사 명</th>
				<th scope="col">영양사 직위</th>
				<th scope="col">영양사 연락처</th>
				<th scope="col">영양사 이메일</th>
				<th scope="col">노출여부</th>
				<th scope="col">소속해제</th>
			</tr>
		</thead>
		<tbody>
		<%
		num = paging.getRowNo();
		if(researcherListT!=null && researcherListT.size()>0){
			for(FoodVO vo : researcherListT){
		%>
			<tr>
				<td><%=vo.rnum%></td>
				<td><a href="javascript: detailPopup('<%=vo.sch_no%>')"><%=vo.sch_nm%>(<%=vo.sch_id%>)</a></td>
				<td><%=outSchType(vo.sch_type)%></td>
				<td><%=vo.nu_nm %></td>
				<td><%=outSchGrade(vo.sch_grade)%></td>
				<td><%=telSet(vo.nu_tel)%></td>
				<td><%=vo.nu_mail%></td>
				<td><%=vo.show_flag%></td>
				<td>
					<button type="button" class="btn small edge mako" 
					onclick="disapproval('<%=vo.sch_no%>', '<%=zone_no%>', '<%=team_no%>', '<%=vo.nu_nm%>')">소속해제</button>
				</td>
			</tr>
		<%
			}
		}else{
		%>	
			<tr>
				<td colspan="9">데이터가 없습니다.</td>			
			</tr>
		<%} %>
		</tbody>
	</table>
<%-- 	
	<p class="f_l magT10">
		<strong>총 <span><%=totalCount%></span> 건
		</strong> [ Page <%=pageNo %>/<%=paging.getFinalPageNo() %>]
	</p>
 --%>	
	<p class="clearfix"> </p>
	<h2 class="tit">조사자</h2>
	<table class="bbs_list">
		<caption>조사팀장 정보 테이블</caption>
		<colgroup>
			<col style="width: 5%">
			<col>
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 5%">
			<col style="width: 10%">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">순서</th>
				<th scope="col">학교명(ID)</th>
				<th scope="col">학교단위</th>
				<th scope="col">영양사 명</th>
				<th scope="col">영양사 직위</th>
				<th scope="col">영양사 연락처</th>
				<th scope="col">영양사 이메일</th>
				<th scope="col">노출여부</th>
				<th scope="col">소속해제</th>
			</tr>
		</thead>
		<tbody>
		<%
		num = paging.getRowNo();
		if(researcherListR!=null && researcherListR.size()>0){
			for(FoodVO vo : researcherListR){
		%>
			<tr>
				<td><%=vo.rnum%></td>
				<td><a href="javascript: detailPopup('<%=vo.sch_no%>')"><%=vo.sch_nm%>(<%=vo.sch_id%>)</a></td>
				<td><%=outSchType(vo.sch_type) %></td>
				<td><%=vo.nu_nm %></td>
				<td><%=outSchGrade(vo.sch_grade)%></td>
				<td><%=telSet(vo.nu_tel)%></td>
				<td><%=vo.nu_mail%></td>
				<td><%=vo.show_flag%></td>
				<td>
					<button type="button" class="btn small edge mako" 
					onclick="disapproval('<%=vo.sch_no%>', '<%=zone_no%>', '<%=team_no%>', '<%=vo.nu_nm%>')">소속해제</button>
				</td>
			</tr>
		<%
			}
		}else{
		%>	
			<tr>
				<td colspan="9">데이터가 없습니다.</td>			
			</tr>
		<%} %>
		</tbody>
	</table>

	<% if(paging.getTotalCount() > 0) { %>
	<div class="page_area">
		<%=paging.getHtml() %>
	</div>
	<% } %>
	
	

</div>
<!-- // E : #content -->
</body>
</html>
