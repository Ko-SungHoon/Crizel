<%
/**
*   PURPOSE :   권역/팀 수정 팝업
*   CREATE  :   20180403_tue    KO
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



StringBuffer sql    =   null;

List<FoodVO> zoneList		=	null;	// 권역 리스트
List<FoodVO> catList		= 	null;	// 품목 리스트
List<FoodVO> teamList		= 	null;	// 팀 리스트
List<FoodVO> joList			=	null;	// 조 리스트

String pageTitle    =   "권역/팀 수정";

try {
	// 권역 리스트
	sql = new StringBuffer();
	sql.append("SELECT * FROM FOOD_ZONE WHERE SHOW_FLAG = 'Y' ORDER BY ZONE_NM		");
	zoneList = jdbcTemplate.query(sql.toString(), new FoodList());
	
	// 품목 리스트
    sql = new StringBuffer();
    sql.append("SELECT * FROM FOOD_ST_CAT WHERE SHOW_FLAG = 'Y' ORDER BY CAT_NM		");
    catList = jdbcTemplate.query(sql.toString(), new FoodList());
    
    // 팀 리스트
    sql = new StringBuffer();
    sql.append("SELECT * FROM FOOD_TEAM WHERE SHOW_FLAG = 'Y' ORDER BY ORDER1, TEAM_NM	");
    teamList = jdbcTemplate.query(sql.toString(), new FoodList());
    
    
    
    
    
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
<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />

<style type="text/css">
    input[type="number"] {border:1px solid #bfbfbf; vertical-align:middle; line-height:18px; padding:5px; box-sizing: border-box;}
</style>

<!-- link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css"/ -->
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
<script>
function catSelect(zone_no){
	$.ajax({
		type : "POST",
		url : "/program/food/research/team_list.jsp",
		data : {
			"zone_no" : zone_no,
			"mode"	  : "cat"    
			},
		async : false,
		success : function(data){
			$("#cat_no").html(data.trim());
			$("#team_no").html("");
			$("#jo_no").html("");
		},
		error : function(request, status, error){
		}
	});
	
	$("#update_title").text("권역명");
	$("#update_type").val("zone");
	$("#update_no").val(zone_no);
	$("#update_nm").val($("#zone_no option:selected").text());
}
function teamSelect(cat_no){
	var zone_no = $("#zone_no").val();
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
			$("#team_no").html(data.trim());
			$("#jo_no").html("");
		},
		error : function(request, status, error){
		}
	});
}
function joSelect(team_no){
	$.ajax({
		type : "POST",
		url : "/program/food/research/team_list.jsp",
		data : {
			"team_no" : team_no,
			"mode"	  : "jo"    
			},
		async : false,
		success : function(data){
			$("#jo_no").html(data.trim());
		},
		error : function(request, status, error){
		}
	});
	
	$("#update_title").text("팀명");
	$("#update_type").val("team");
	$("#update_no").val(team_no);
	$("#update_nm").val($("#team_no option:selected").text());
}
function joUpdate(jo_no){
	$("#update_title").text("조명");
	$("#update_type").val("jo");
	$("#update_no").val(jo_no);
	$("#update_nm").val($("#jo_no option:selected").text());
}
function zoneInsert(){
	var zone_nm = $("#zone_nm").val();

	if(zone_nm == "" || zone_nm == null){alert("권역명을 입력하여주시기 바랍니다."); return;}
	
	if(confirm("권역을 입력하시겠습니까?")){
		$("#researchForm #mode").val("zoneInsert");
		$("#researchForm").attr("action", "food_zone_act.jsp");
		$("#researchForm").attr("method", "post");
		$("#researchForm").submit();
	}else{
		return;
	}
}
function teamInsert(){
	var zone_no = $("#zone_no").val();
	var cat_no = $("#cat_no").val();
	var team_nm = $("#team_nm").val();
	
	if(zone_no == "" || zone_no == null){alert("권역을 선택하여주시기 바랍니다."); return;}
	if(cat_no == "" || cat_no == null){alert("품목을 선택하여주시기 바랍니다."); return;}
	if(team_nm == "" || team_nm == null){alert("팀명을 입력하여주시기 바랍니다."); return;}
	
	if(confirm("팀을 입력하시겠습니까?")){
		$("#researchForm #mode").val("teamInsert");
		$("#researchForm").attr("action", "food_zone_act.jsp");
		$("#researchForm").attr("method", "post");
		$("#researchForm").submit();
	}else{
		return;
	}
}

function joInsert(){
	var zone_no = $("#zone_no").val();
	var cat_no = $("#cat_no").val();
	var team_no = $("#team_no").val();
	var jo_nm = $("#jo_nm").val()
	
	if(zone_no == "" || zone_no == null){alert("권역을 선택하여주시기 바랍니다."); return;}
	if(cat_no == "" || cat_no == null){alert("품목을 선택하여주시기 바랍니다."); return;}
	if(team_no == "" || team_no == null){alert("팀을 선택하여주시기 바랍니다."); return;}
	if(jo_nm == "" || jo_nm == null){alert("조명을 입력하여주시기 바랍니다."); return;}
	
	if(confirm("조를 입력하시겠습니까?")){
		$("#researchForm #mode").val("joInsert");
		$("#researchForm").attr("action", "food_zone_act.jsp");
		$("#researchForm").attr("method", "post");
		$("#researchForm").submit();
	}else{
		return;
	}
	
}
function updateNm(){
	var update_type = $("#update_type").val();
	var update_no = $("#update_no").val();
	var update_nm = $("#update_nm").val();
	
	if(update_no == "" || update_no == null){alert("수정할 항목을 선택하여주시기 바랍니다."); return;}
	if(update_nm == "" || update_nm == null){alert("수정할 이름을 선택하여주시기 바랍니다."); return;}
	
	var check;
	$.ajax({
		type : "POST",
		url : "/program/food/research/food_zone_act.jsp",
		data : {
			"update_no" : update_no,
			"mode"	  : "rschCheck"    
			},
		async : false,
		success : function(data){
			check = data.trim();
		},
		error : function(request, status, error){
		}
	});
	
	if(check == "OK"){
		if(confirm("해당 권역으로 설정된 조사자가 있습니다. 계속 수정하시겠습니까?")){
			
		}else{
			return;
		}
	}
	
	if(confirm("해당 항목의 이름을 수정하시겠습니까?")){
		$("#researchForm #mode").val(update_type + "Update");
   		$("#researchForm").attr("action", "food_zone_act.jsp");
   		$("#researchForm").attr("method", "post");
   		$("#researchForm").submit();
	}else{
		return;
	}
}
function deleteNm(){
	var update_type = $("#update_type").val();
	var update_no = $("#update_no").val();
	
	if(update_no == "" || update_no == null){alert("삭제할 항목을 선택하여주시기 바랍니다."); return;}
	
	if(confirm("해당 항목을 삭제하시겠습니까?")){
		$("#researchForm #mode").val(update_type + "Delete");
   		$("#researchForm").attr("action", "food_zone_act.jsp");
   		$("#researchForm").attr("method", "post");
   		$("#researchForm").submit();
	}else{
		return;
	}
}
</script>
</head>
<body>

<div id="right_view">
	<div class="top_view">
      <p class="location"><strong><%=pageTitle%></strong></p>
  </div>
</div>
          
<!-- S : #content -->
<div id="content">
	<div>
		<form id="researchForm">
            <fieldset>
            	<input type="hidden" name="mode" id="mode">
                <legend><%=pageTitle%> 테이블</legend>
                <table class="bbs_list2">
                    <colgroup>
                        <col style="width:25%">
                        <col style="width:25%">
                        <col style="width:25%">
                        <col style="width:25%">
                        <col>
                    </colgroup>
                    <thead>
                    	<tr>
                    		<th>권역</th>
                    		<th>품목</th>
                    		<th>팀</th>
                    		<th>조</th>
                    	</tr>
                    </thead>
                    <tbody>
                    	<tr>
                    		<td>
                    			<input type="text" name="zone_nm" id="zone_nm" placeholder="권역명을 입력하세요.">
                    			<button type="button" class="btn small darkMblue" onclick="zoneInsert()">+</button>
                    		</td>
                    		<td>
                    		</td>
                    		<td>
                    			<input type="text" name="team_nm" id="team_nm" placeholder="팀명을 입력하세요.">
                    			<button type="button" class="btn small darkMblue" onclick="teamInsert()">+</button>
                    		</td>
                    		<td>
                    			<input type="text" name="jo_nm" id="jo_nm" placeholder="조명을 입력하세요.">
                    			<button type="button" class="btn small darkMblue" onclick="joInsert()">+</button>
                    		</td>
                    	</tr>
                    	<tr>
                    		<td>
                    			<select name="zone_no" id="zone_no" size="150" style="overflow:auto; height:260px;width:230px;" onclick="catSelect(this.value)">
                    			<%
                    			if(zoneList!=null && zoneList.size()>0){
                    				for(FoodVO ob : zoneList){
                    					out.println("<option value='"+ob.zone_no+"'>"+ob.zone_nm+"</option>");
                    				}
                    			}
                    			%>
                    			</select>
                    		</td>
                    		
                    		<td>
                    			<select name="cat_no" id="cat_no" size="150" style="overflow:auto; height:260px;width:230px;" onclick="teamSelect(this.value)">
                    			</select>
                    		</td>
                    		<td>
                    			<select name="team_no" id="team_no" size="150" style="overflow:auto; height:260px;width:230px;" onclick="joSelect(this.value)">
                    			</select>
                    		</td>
                    		<td>
                    			<select name="jo_no" id="jo_no" size="150" style="overflow:auto; height:260px;width:230px;" onclick="joUpdate(this.value)">
                    			</select>
                    		</td>
                    	</tr>
                    	<tr>
                    		<th>
                    			<span id="update_title"></span> 수정
                    		</th>
                    		<td colspan="3">
                    			<input type="hidden" name="update_type" id="update_type">
                    			<input type="hidden" name="update_no" id="update_no">
                    			<input type="text" name="update_nm" id="update_nm" placeholder="수정할 이름을 입력하세요.">
                    			<button type="button" class="btn small darkMblue" onclick="updateNm()">적용</button>
                    			<button type="button" class="btn small red" onclick="deleteNm()">삭제</button>
                    		</td>
                    	</tr>
                    </tbody>
                </table>
                <p class="btn_area txt_c">
					<button type="button" class="btn medium edge mako" onclick="window.close();">닫기</button>
                </p>
            </fieldset>
        </form>
    </div>
</div>

</body>
</html>

