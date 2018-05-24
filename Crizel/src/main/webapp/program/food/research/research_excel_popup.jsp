<%
/**
*   PURPOSE :   월별조사 엑셀 업로드 팝업
*   CREATE  :   20180405_thur    KO
*   MODIFY  :   ....
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>
<%@ include file="/program/class/PagingClass.jsp"%>
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
Connection conn2 = null;
try {
	sqlMapClient.startTransaction();
	conn2 = sqlMapClient.getCurrentConnection();
	
	// 접속한 관리자 회원의 권한 롤
	roleId= getRoleId(sqlMapClient, conn2, sessionId);
	
	// 관리자 접근 허용된 IP 배열
	allowIp = getAllowIpArrays(sqlMapClient, conn2);
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


String search1 = parseNull(request.getParameter("search1"));
String search2 = parseNull(request.getParameter("search2"));
String search3 = parseNull(request.getParameter("search3"));
String search4 = parseNull(request.getParameter("search4"));

StringBuffer sql    =   null;
Object[] setObj		= null;
List<String> setList	= new ArrayList<String>();

Paging paging 		= new Paging();
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;

List<FoodVO> zoneList		=	null;	// 권역 리스트
List<FoodVO> catList		= 	null;	// 품목 리스트
List<FoodVO> teamList		= 	null;	// 팀 리스트
List<FoodVO> joList			=	null;	// 조 리스트

List<FoodVO> rschList		= 	null;
FoodVO rschVO				=	new FoodVO();

String pageTitle    =   "월별조사 엑셀 업로드";

try {
	// 권역 리스트
	sql = new StringBuffer();
	sql.append("SELECT * FROM FOOD_ZONE WHERE SHOW_FLAG = 'Y' ORDER BY ZONE_NM				");
	zoneList = jdbcTemplate.query(sql.toString(), new FoodList());
	
	// 품목 리스트
    sql = new StringBuffer();
    sql.append("SELECT * FROM FOOD_ST_CAT WHERE SHOW_FLAG = 'Y' ORDER BY CAT_NM				");
    catList = jdbcTemplate.query(sql.toString(), new FoodList());
    
    // 팀 리스트
    sql = new StringBuffer();
    sql.append("SELECT * FROM FOOD_TEAM WHERE SHOW_FLAG = 'Y' AND ZONE_NO = ? AND CAT_NO = ? ORDER BY ORDER1, TEAM_NM		");
    teamList = jdbcTemplate.query(sql.toString(), new FoodList(), search1, search2);
    
 	// 조 리스트
    sql = new StringBuffer();
    sql.append("SELECT * FROM FOOD_JO WHERE TEAM_NO = ? ORDER BY ORDER1, JO_NM								");
    joList = jdbcTemplate.query(sql.toString(), new FoodList(), search4);
    
    // 월별조사 리스트
    sql = new StringBuffer();
    sql.append("SELECT 																														");
    sql.append("    (SELECT ZONE_NM FROM FOOD_ZONE WHERE ZONE_NO = (SELECT ZONE_NO FROM FOOD_SCH_TB WHERE SCH_NO = A.SCH_NO)) ZONE_NM 		");
    sql.append("    , (SELECT CAT_NM FROM FOOD_ST_CAT WHERE CAT_NO = B.CAT_NO) AS CAT_NM 													");
    sql.append("    , B.FOOD_CAT_INDEX 																										");
    sql.append("    , (SELECT TEAM_NM FROM FOOD_TEAM WHERE TEAM_NO = (SELECT TEAM_NO FROM FOOD_SCH_TB WHERE SCH_NO = A.SCH_NO)) TEAM_NM 	");
    sql.append("    , (SELECT JO_NM FROM FOOD_JO WHERE JO_NO = (SELECT JO_NO FROM FOOD_SCH_TB WHERE SCH_NO = A.SCH_NO)) JO_NM 				");
    sql.append("    , B.FOOD_CODE 																					");
	sql.append("    , ( SELECT SUBSTR( XMLAGG( 																		");  
	sql.append("                        XMLELEMENT(COL ,',', NM_FOOD) ORDER BY NM_FOOD).EXTRACT('//text()' 			"); 
	sql.append("                    ).GETSTRINGVAL(),2) NM_FOOD 													"); 
	sql.append("      FROM FOOD_ST_NM 																				"); 
	sql.append("      WHERE NM_NO IN (FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5)) AS NM_FOOD 			");      
	sql.append("    , ( SELECT SUBSTR( XMLAGG( 																		");  
	sql.append("                        XMLELEMENT(COL,',',DT_NM) ORDER BY DT_NM).EXTRACT('//text()' 				"); 
	sql.append("                    ).GETSTRINGVAL(),2) DT_NM 														"); 
	sql.append("      FROM FOOD_ST_DT_NM 																			"); 
	sql.append("      WHERE DT_NO IN (FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5 						");
	sql.append("                    , FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10)) AS DT_NM 			");
	sql.append("    , ( SELECT SUBSTR( XMLAGG( 																		");  
	sql.append("                        XMLELEMENT(COL ,',', EX_NM) ORDER BY EX_NM).EXTRACT('//text()' 				"); 
	sql.append("                    ).GETSTRINGVAL(),2) EX_NM 														"); 
	sql.append("      FROM FOOD_ST_EXPL 																			");
	sql.append("      WHERE EX_NO IN (FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5 						");
	sql.append("                    , FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10 						");
	sql.append("                    , FOOD_EP_11, FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15 					");
	sql.append("                    , FOOD_EP_16, FOOD_EP_17, FOOD_EP_18, FOOD_EP_19, FOOD_EP_20 					");
	sql.append("                    , FOOD_EP_21, FOOD_EP_22, FOOD_EP_23, FOOD_EP_24, FOOD_EP_25)) AS EX_NM 		");
	sql.append("    , (SELECT ITEM_COMP_NO FROM FOOD_ITEM_PRE WHERE ITEM_NO = B.ITEM_NO) AS ITEM_COMP_NO 			");
	sql.append("    , (SELECT ITEM_COMP_VAL FROM FOOD_ITEM_PRE WHERE ITEM_NO = B.ITEM_NO) AS ITEM_COMP_VAL 		");
	sql.append("    , (SELECT SCH_NM FROM FOOD_SCH_TB WHERE SCH_NO = A.SCH_NO) AS SCH_NM 							");
	sql.append("FROM FOOD_RSCH_ITEM A LEFT JOIN FOOD_ST_ITEM B ON A.ITEM_NO = B.ITEM_NO 							");
	sql.append("WHERE 1=1																							");
	if(!"".equals(search1)){
		sql.append("AND (SELECT ZONE_NO FROM FOOD_SCH_TB WHERE SCH_NO = A.SCH_NO) = ?								");
		setList.add(search1);
	}else{
		sql.append("AND 1=2																							");	// 권역, 품목 미선택시 리스트 미출력
	}
	if(!"".equals(search2)){
		sql.append("AND B.CAT_NO = ?																				");
		setList.add(search2);
	}else{
		sql.append("AND 1=2																							");	// 권역, 품목 미선택시 리스트 미출력
	}
	if(!"".equals(search3)){
		sql.append("AND (SELECT TEAM_NO FROM FOOD_SCH_TB WHERE SCH_NO = A.SCH_NO) = ?								");
		setList.add(search3);
	}
	if(!"".equals(search4)){
		sql.append("AND (SELECT JO_NO FROM FOOD_SCH_TB WHERE SCH_NO = A.SCH_NO) = ?									");
		setList.add(search4);
	}
	
	sql.append("ORDER BY RSCH_ITEM_NO 																				");
	
	setObj = new Object[setList.size()];
	for(int i=0; i<setList.size(); i++){
		setObj[i] = setList.get(i);
	}

    rschList = jdbcTemplate.query(sql.toString(), new FoodList(), setObj);
    
   
    
    sql = new StringBuffer();
    sql.append("SELECT 																										");	
    sql.append("    COUNT(*) AS CNT																							");	 
    sql.append("    , TO_CHAR((SELECT REG_DATE FROM FOOD_UP_FILE WHERE FILE_NO = A.FILE_NO), 'YYYY-MM-DD' ) AS REG_DATE		");	
    sql.append("FROM FOOD_RSCH_ITEM A																						");	
    sql.append("GROUP BY FILE_NO																							");	
    try{
    	rschVO = jdbcTemplate.queryForObject(sql.toString(), new FoodList());
    }catch(Exception e){
    	rschVO = new FoodVO();
    }
    
    
} catch(Exception e) {
	out.println(e.toString());
}

%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title><%=pageTitle%></title>
<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
<script type='text/javascript' src='/js/jquery.js'></script>
<script>
function catSelect(zone_no){
	var html = "<option value=''>품목 선택</option>";
	$.ajax({
		type : "POST",
		url : "/program/food/research/team_list.jsp",
		data : {
			"zone_no" : zone_no,
			"mode"	  : "cat"    
			},
		async : false,
		success : function(data){
			html += data.trim();
			$("#search2").html(html);
			$("#search3").html("<option value=''>팀 선택</option>");
			$("#search4").html("<option value=''>조 선택</option>");
		},
		error : function(request, status, error){
		}
	});
}
function teamSelect(cat_no){
	var html = "<option value=''>팀 선택</option>";
	var zone_no = $("#search1").val();
	$.ajax({
		type : "POST",
		url : "/program/food/research/team_list.jsp",
		data : {
			"zone_no" : zone_no,
			"cat_no"  : cat_no,
			"mode"	  : "team"    
			},
		async : false,
		success : function(data){
			html += data.trim();
			$("#search3").html(html);
			$("#search4").html("<option value=''>조 선택</option>");
		},
		error : function(request, status, error){
		}
	});
}
function joSelect(team_no){
	var html = "<option value=''>조 선택</option>";
	$.ajax({
		type : "POST",
		url : "/program/food/research/team_list.jsp",
		data : {
			"team_no" : team_no,
			"mode"	  : "jo"    
			},
		async : false,
		success : function(data){
			html += data.trim();
			$("#search4").html(html);
		},
		error : function(request, status, error){
		}
	});
}

function upExcel() {
    if (confirm("월별조사 엑셀을 업로드 하시겠습니까?")) {
        $("#researcher_file").click();
    }
    return;
}
function setFile () {
    //파일 검증
    var fileName    =   $("#researcher_file").val().split("\\")[$("#researcher_file").val().split("\\").length -1];
    var fileExtName =   $("#researcher_file").val().split(".")[$("#researcher_file").val().split(".").length -1];
    fileExtName     =   fileExtName.toLowerCase();
    if ($.inArray(fileExtName, ['xls'/* , 'xlsx' */]) == -1) {
        alert ("xls 형식의 엑셀 파일만 등록이 가능합니다.");
        $(this).val("");
        return;
    }
    $("#researcher_excel_form").attr("action", "research_excel_up.jsp");
    $("#researcher_excel_form").submit();
}

function excelSample(){
	location.href="/program/down.jsp?path=/upload_data/food/sample&filename=research_sample.xls";
}
</script>
<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
<style>
	.box_01 {border:2px solid #ccc;padding:15px;margin-bottom: 15px;}
	.type01>li {padding-left:15px; background:url(/img/common/bul_01.png) no-repeat 0 4px;}
</style>
</head>
<body>

<div id="right_view">
	<div class="top_view">
      <p class="location"><strong><%=pageTitle%></strong></p>
  </div>
</div>
          
<!-- S : #content -->
<div id="content">
	<form id="researcher_excel_form" enctype="multipart/form-data" method="post">
		<input type="file" id="researcher_file" name="researcher_file" value="" onchange="setFile()" style="display: none;">
	</form>
	<div class="box_01">
		<ul class="type01 fsize_120">
			<li class="red">※권역, 품목을 검색해야 리스트가 출력됩니다.</li>
			<%if(!"".equals(rschVO.cnt)){ %>
			<li>마지막 등록은 <%=rschVO.reg_date %> 입니다. 총 조사건 수는 <%=rschVO.cnt %>건 입니다.</li>
			<%} %>
		</ul>
	</div>
	<div class="searchBox magB20">
		<form id="searchForm" method="get" class="topbox2">
			<fieldset>
				<select name="search1" id="search1" onchange="catSelect(this.value)">
					<option value="">권역 선택</option>
      			<%
      			if(zoneList!=null && zoneList.size()>0){
      				for(FoodVO ob : zoneList){
      					out.println(printOption(ob.zone_no, ob.zone_nm, search1));
      				}
      			}
      			%>
      			</select>
      			<select name="search2" id="search2" onchange="teamSelect(this.value)">
      				<option value="">품목 선택</option>
      			<%
                if(catList!=null && catList.size()>0){
                	for(FoodVO ob : catList){
                		out.println(printOption(ob.cat_no, ob.cat_nm, search2));
                	}
                }
                %>
                </select>		
                <select name="search3" id="search3" onchange="joSelect(this.value)">
                	<option value="">팀 선택</option>
                <%
                if(teamList!=null && teamList.size()>0){
                	for(FoodVO ob : teamList){
                		out.println(printOption(ob.team_no, ob.team_nm, search3));
                	}
                }
                %>
                </select>
                <select name="search4" id="search4" >
                	<option value="">조 선택</option>
                <%
                if(joList!=null && joList.size()>0){
                	for(FoodVO ob : joList){
                		out.println(printOption(ob.jo_no, ob.jo_nm, search4));
                	}
                }
                %>
                </select>
				<button class="btn small edge mako" >조회</button>
				
				<div class="f_r">
					<button type="button" class="btn small edge mako" onclick="excelSample();">엑셀 샘플</button>
					<button type="button" class="btn small edge mako" onclick="upExcel();">엑셀 업로드</button>
				</div>
			</fieldset>
		</form>
	</div>
	
	<table class="bbs_list">
		<caption><%=pageTitle%> 테이블</caption>
		<colgroup>
			<col style="width: 9%">
			<col style="width: 9%">
			<col style="width: 9%">
			<col style="width: 9%">
			<col style="width: 9%">
			<col style="width: 9%">
			<col style="width: 9%">
			<col style="width: 9%">
			<col >
			<col style="width: 9%">
			<col style="width: 9%">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">권역</th>
				<th scope="col">품목</th>	
				<th scope="col">팀</th>
				<th scope="col">조</th>
				<th scope="col">구분</th>
				<th scope="col">식품코드</th>
				<th scope="col">식품명</th>
				<th scope="col">상세식품명</th>
				<th scope="col">식품설명</th>
				<th scope="col">비교코드</th>
				<th scope="col">조사학교</th>
			</tr>
		</thead>
		<tbody>
		<%
		if(rschList!=null && rschList.size()>0){
			for(FoodVO ob : rschList){
		%>
			<tr>
				<td><%=ob.zone_nm%></td>
				<td><%=ob.cat_nm %></td>
				<td><%=ob.team_nm %></td>
				<td><%=ob.jo_nm %></td>
				<td><%=ob.cat_nm%>-<%=ob.food_cat_index %></td>
				<td><%=ob.food_code %></td>
				<td><%=ob.nm_food %></td>
				<td><%=ob.dt_nm %></td>
				<td><%=ob.ex_nm %></td>
				<td><%=ob.item_comp_no %>/<%=ob.item_comp_val %></td>
				<td><%=ob.sch_nm %></td>
			</tr>
		<%
			}
		}else{
		%>
			<tr>
				<td colspan="11">데이터가 없습니다.</td>			
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

</body>
</html>

