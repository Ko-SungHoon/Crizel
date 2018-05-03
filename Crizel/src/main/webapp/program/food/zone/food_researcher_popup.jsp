<%
/**
*   PURPOSE :   조사자 등록 팝업
*   CREATE  :   20180321_wed    Ko
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

/************************** 접근 허용 체크 - 시작 **************************/
SessionManager sessionManager = new SessionManager(request);
String sessionId = sessionManager.getId();
if(sessionId == null || "".equals(sessionId)) {
	alertParentUrl(out, "관리자 로그인이 필요합니다.", adminLoginUrl);
	if(true) return;
}

String roleId= null;
String[] allowIp = null;
Connection conn = null;
try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	// 접속한 관리자 회원의 권한 롤
	roleId= getRoleId(sqlMapClient, conn, sessionId);
	
	// 관리자 접근 허용된 IP 배열
	allowIp = getAllowIpArrays(sqlMapClient, conn);
} catch (Exception e) {
	sqlMapClient.endTransaction();
	alertBack(out, "트랜잭션 오류가 발생했습니다.");
} finally {
	sqlMapClient.endTransaction();
}

// 권한정보 체크
boolean isAdmin = sessionManager.isRole(roleId);

// 접근허용 IP 체크
String thisIp = request.getRemoteAddr();
boolean isAllowIp = isAllowIp(thisIp, allowIp);

/** Method 및 Referer 정보 **/
String getMethod = parseNull(request.getMethod());
String getReferer = parseNull(request.getHeader("referer"));

if(!isAdmin) {
	alertBack(out, "해당 사용자("+sessionId+")는 접근 권한이 없습니다.");
	if(true) return;
}
if(!isAllowIp) {
	alertBack(out, "해당 IP("+thisIp+")는 접근 권한이 없습니다.");
	if(true) return;
}
/************************** 접근 허용 체크 - 종료 **************************/

String pageTitle = "조사자 등록";
%>

<!DOCTYPE html>
<html lang="ko">
	<head>
		<title><%=pageTitle%></title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
		<style type="text/css">
			input[type="number"] {border:1px solid #bfbfbf; vertical-align:middle; line-height:18px; padding:5px; box-sizing: border-box;}
		</style>
</head>
<body>
<%

String zone_no				= parseNull(request.getParameter("zone_no"));
StringBuffer sql 			= null;
List<FoodVO> list			= null;
List<FoodVO> zoneList		= null;
List<FoodVO> teamList		= null;

Paging paging = new Paging();
paging.setPageSize(20);
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
int cnt = 0;
int num = 0;

try{
	// 조사자 리스트 카운트
	sql = new StringBuffer();
	sql.append("SELECT COUNT(*)																");
	sql.append("FROM FOOD_SCH_TB A  LEFT JOIN FOOD_SCH_NU B ON A.SCH_NO = B.SCH_NO			");
	sql.append("					LEFT JOIN FOOD_ZONE C ON A.ZONE_NO = C.ZONE_NO			");
	sql.append("					LEFT JOIN FOOD_TEAM D ON A.TEAM_NO = D.TEAM_NO			");
	sql.append("WHERE A.TEAM_NO = 0 AND A.SCH_APP_FLAG = 'Y'								");
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
	sql.append("WHERE A.TEAM_NO = 0	AND A.SCH_APP_FLAG = 'Y'								");
	sql.append("ORDER BY D.ORDER1															");
	sql.append("	) C WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" 			");
	sql.append(") WHERE RNUM > ").append(paging.getStartRowNo()).append(" 					");
	list = jdbcTemplate.query(sql.toString(), new FoodList());
	
	sql = new StringBuffer();
	sql.append("SELECT * 								");
	sql.append("FROM FOOD_ZONE							");
	sql.append("WHERE 	SHOW_FLAG = 'Y' 				");
	sql.append("ORDER BY ZONE_NM						");
	zoneList = jdbcTemplate.query(sql.toString(), new FoodList());
	
	sql = new StringBuffer();
	sql.append("SELECT * 								");
	sql.append("FROM FOOD_TEAM							");
	sql.append("WHERE 	SHOW_FLAG = 'Y' 				");
	sql.append("ORDER BY ZONE_NO, ORDER1, TEAM_NM		");
	teamList = jdbcTemplate.query(sql.toString(), new FoodList());
	
}catch(Exception e){
	out.println(e.toString());
}

%>
<script>
function researcherApply(sch_no){
	var zone_no = $("#zone_no_"+sch_no).val();
	var team_no = $("#team_no_"+sch_no).val();
	if(confirm("팀을 적용하시겠습니까?")){
		location.href="food_zone_act.jsp?mode=teamApply&sch_no="+sch_no+"&team_no="+team_no+"&zone_no="+zone_no;
	}else{
		return false;
	}
}

function teamSelect(value, sch_no){
	var zone_no = value;
	$.ajax({
		type : "POST",
		url : "/program/food/research/team_list.jsp",
		data : {"zone_no" : zone_no},
		async : false,
		success : function(data){
			$("#team_no_"+sch_no).html(data.trim());
		},
		error : function(request, status, error){
		}
	}); 
}

</script>
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong><%=pageTitle%></strong></p>
  </div>
</div>
<!-- S : #content -->
<div id="content">
	<div>
		<form id="updateForm" onsubmit="return updateSubmit();">
			<fieldset>
				<input type="hidden" id="mode" name="mode">
				<legend><%=pageTitle%></legend>
				<table class="bbs_list2 td-c">
					<caption><%=pageTitle%> 입력폼</caption>
					<colgroup>
						<col style="width:10%" />
						<col />
						<col style="width:15%" />
						<col style="width:15%" />
						<col style="width:15%" />
						<col style="width:10%" />
					</colgroup>
					<thead>
					<tr>
						<th scope="row">순서</th>
						<th scope="row">학교명(ID)</th>
						<th scope="row">영양사</th>
						<th scope="row">권역</th>
						<th scope="row">팀</th>
						<th scope="row">비고</th>
					</tr>
					</thead>
					<tbody>
					<%
					if(list!=null && list.size()>0){
						for(FoodVO ob : list){
					%>
						<tr>
							<td><%=ob.rnum%></td>
							<td><%=ob.sch_nm%>(<%=ob.sch_id%>)</td>
							<td><%=ob.nu_nm%></td>
							<td>
								<select id="zone_no_<%=ob.sch_no%>" name="zone_no" onchange="teamSelect(this.value, '<%=ob.sch_no%>')">
									<option value="">권역선택</option>
								<%
								if(zoneList!=null && zoneList.size()>0){
									for(FoodVO ob2 : zoneList){
								%>	
									<option value="<%=ob2.zone_no%>"
									<%if(ob.zone_no.equals(ob2.zone_no)){out.println("selected");}%>><%=ob2.zone_nm %></option>
								<%
									}
								}
								%>
								</select>
							</td>
							<td>
								<select id="team_no_<%=ob.sch_no%>" name="team_no" required>
									<option value="0">팀선택</option>
								<%
								if(teamList!=null && teamList.size()>0){
									for(FoodVO ob2 : teamList){
										if(ob.zone_no.equals(ob2.zone_no)){
								%>
									<option value="<%=ob2.team_no%>"><%=ob2.team_nm %></option>
								<%			
										}
									}
								}
								%>
								</select>
							</td>
							<td>
								<button type="button" class="btn small edge mako" 
								onclick="researcherApply('<%=ob.sch_no%>');">적용</button>
							</td>
						</tr>
					<%	
						}
					}else{
					%>
						<tr>
							<td colspan="6">미등록자가 없습니다.</td>
						</tr>
					<%
					}
					%>
						
					</tbody>
				</table>
				<% if(paging.getTotalCount() > 0) { %>
				<div class="page_area">
					<%=paging.getHtml() %>
				</div>
				<% } %>
				<p class="btn_area txt_c">
					<button type="button" class="btn medium edge mako" onclick="window.close();">닫기</button>
				</p>
			</fieldset>
		</form>
	</div>
</div>
	<!-- //E : #content -->
</body>
</html>
