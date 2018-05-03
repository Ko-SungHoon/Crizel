<%
/**
*   PURPOSE :   조사개시/수정 팝업
*   CREATE  :   20180326_mon    JI
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


String mode         =   parseNull(request.getParameter("mode"), "new");
String rsch_no      =   parseNull(request.getParameter("rsch_no"), "0");
StringBuffer sql    =   null;
String sql_str      =   "";

FoodVO	rschVO				= 	new FoodVO();
List<FoodVO> researchItem   =   null;   // 수정 정보
List<FoodVO> catList		=	null;	// 구분 리스트
List<FoodVO> teamList		= 	null;	// 팀 리스트

String pageTitle    =   "조사개시";
if (mode != null && "mod".equals(mode)) {
    pageTitle       =   "조사개시 수정";
}

try {
    if (mode != null && "mod".equals(mode)) {
        sql     =   new StringBuffer();
        sql_str =   " SELECT * ";
        sql_str +=  " FROM FOOD_RSCH_TB A JOIN FOOD_UP_FILE B ";
        sql_str +=  " ON A.FILE_NO = B.FILE_NO ";
        sql.append(sql_str);
        researchItem    =   jdbcTemplate.query(sql.toString(), new FoodList());
        
    }
    
    // 수정 시 정보
    sql = new StringBuffer();
    sql.append("SELECT  											");
    sql.append("      A.RSCH_NO										");
    sql.append("    , A.RSCH_NM										");
    sql.append("    , A.RSCH_YEAR									");
    sql.append("    , A.RSCH_MONTH									");
    sql.append("    , TO_CHAR(A.STR_DATE, 'YYYYMMDD') AS STR_DATE	");
    sql.append("    , TO_CHAR(A.MID_DATE, 'YYYYMMDD') AS MID_DATE	");
    sql.append("    , TO_CHAR(A.END_DATE, 'YYYYMMDD') AS END_DATE	");
    sql.append("    , A.FILE_NO										");
    sql.append("    , B.FILE_NM										");
    sql.append("    , B.FILE_ORG_NM									");
    sql.append("FROM FOOD_RSCH_TB A LEFT JOIN FOOD_UP_FILE B ON A.FILE_NO = B.FILE_NO	");
    sql.append("WHERE RSCH_NO = ?														");
    try{
    	rschVO = jdbcTemplate.queryForObject(sql.toString(), new FoodList(), rsch_no);
    }catch(Exception e){
    	rschVO = new FoodVO();
    }
    
    sql = new StringBuffer();
    sql.append("SELECT 																						");
    sql.append("    CAT_NO																					");
    sql.append("  , CAT_NM																					");
    sql.append("  , (SELECT COUNT(*) FROM FOOD_RSCH_CAT WHERE CAT_NO = A.CAT_NO AND RSCH_NO = ?) AS CNT		");
    sql.append("FROM FOOD_ST_CAT A																			");
    sql.append("WHERE SHOW_FLAG = 'Y' 																		");
    sql.append("ORDER BY CAT_NM																				");
    catList = jdbcTemplate.query(sql.toString(), new FoodList(), rsch_no);
    
    sql = new StringBuffer();
    sql.append("SELECT  																						");
    sql.append("    TEAM_NO																						");
    sql.append("  , TEAM_NM																						");
    sql.append("  , (SELECT ZONE_NM FROM FOOD_ZONE WHERE ZONE_NO = A.ZONE_NO AND SHOW_FLAG = 'Y') AS ZONE_NM	");
    sql.append("  , (SELECT CAT_NM FROM FOOD_ST_CAT WHERE CAT_NO = A.CAT_NO AND SHOW_FLAG = 'Y') AS CAT_NM		");
    sql.append("  , (SELECT COUNT(*) FROM FOOD_RSCH_TEAM WHERE TEAM_NO = A.TEAM_NO AND RSCH_NO = ?) AS CNT		");
    sql.append("FROM FOOD_TEAM A																				");
    sql.append("WHERE SHOW_FLAG = 'Y' 																			");
    sql.append("ORDER BY ORDER1, TEAM_NM, ZONE_NM																");
    teamList = jdbcTemplate.query(sql.toString(), new FoodList(), rsch_no);
    
    
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
    $(function() {
    	
    	$('#str_date').keyup(function(){this.value=this.value.replace(/[^0-9]/g,'');});
    	$('#str_date').change(function(){this.value=this.value.replace(/[^0-9]/g,'');});
    	$('#mid_date').keyup(function(){this.value=this.value.replace(/[^0-9]/g,'');});
    	$('#mid_date').change(function(){this.value=this.value.replace(/[^0-9]/g,'');});
    	$('#end_date').keyup(function(){this.value=this.value.replace(/[^0-9]/g,'');});
    	$('#end_date').change(function(){this.value=this.value.replace(/[^0-9]/g,'');});
    	
        //오늘 날짜 가져오기
        var today   =   new Date();
        var dd      =   today.getDate();
        var mm      =   today.getMonth() + 1;
        var yyyy    =   today.getFullYear();
        if (dd < 10) {
            dd      =   '0' + dd;
        }
        if (mm < 10) {
            mm      =   '0' + mm;
        }

        today       =   yyyy + mm + dd;

        $.datepicker.regional['ko'] = { // Default regional settings
            closeText: '닫기',
            prevText: '이전달',
            nextText: '다음달',
            currentText: '오늘',
            monthNames: ['1월(JAN)','2월(FEB)','3월(MAR)','4월(APR)','5월(MAY)','6월(JUN)',
            '7월(JUL)','8월(AUG)','9월(SEP)','10월(OCT)','11월(NOV)','12월(DEC)'],
            monthNamesShort: ['1월','2월','3월','4월','5월','6월',
            '7월','8월','9월','10월','11월','12월'],
            dayNames: ['일','월','화','수','목','금','토'],
            dayNamesShort: ['일','월','화','수','목','금','토'],
            dayNamesMin: ['일','월','화','수','목','금','토']
        };

        $.datepicker.setDefaults($.datepicker.regional['ko']);

        $( "#str_date" ).datepicker({
            dateFormat: 'yymmdd',  //데이터 포멧형식
            changeMonth: true,    //달별로 선택 할 수 있다.
            changeYear: true,     //년별로 선택 할 수 있다.
            showOtherMonths: false,  //이번달 달력안에 상/하 빈칸이 있을경우 전달/다음달 일로 채워준다.
            selectOtherMonths: true,
            showButtonPanel: true,  //오늘 날짜로 돌아가는 버튼 및 닫기 버튼을 생성한다.
            minDate: 0,
            onClose: function( selectedDate ) {
                $("#mid_date").datepicker( "option", "minDate", selectedDate );
                $("#end_date").datepicker( "option", "minDate", selectedDate );
            }
        });
        $( "#mid_date" ).datepicker({
             dateFormat: 'yymmdd',  //데이터 포멧형식
             changeMonth: true,    //달별로 선택 할 수 있다.
             changeYear: true,     //년별로 선택 할 수 있다.
             showOtherMonths: false,  //이번달 달력안에 상/하 빈칸이 있을경우 전달/다음달 일로 채워준다.
             selectOtherMonths: true,
             showButtonPanel: true,  //오늘 날짜로 돌아가는 버튼 및 닫기 버튼을 생성한다.
             onClose: function( selectedDate ) {
                $("#str_date").datepicker( "option", "maxDate", selectedDate );
                $("#end_date").datepicker( "option", "minDate", selectedDate );
            }
        });
        $( "#end_date" ).datepicker({
             dateFormat: 'yymmdd',  //데이터 포멧형식
             changeMonth: true,    //달별로 선택 할 수 있다.
             changeYear: true,     //년별로 선택 할 수 있다.
             showOtherMonths: false,  //이번달 달력안에 상/하 빈칸이 있을경우 전달/다음달 일로 채워준다.
             selectOtherMonths: true,
             showButtonPanel: true,  //오늘 날짜로 돌아가는 버튼 및 닫기 버튼을 생성한다.
             onClose: function( selectedDate ) {
                $("#str_date").datepicker( "option", "maxDate", selectedDate );
                $("#mid_date").datepicker( "option", "maxDate", selectedDate );
            }
        });
    });
    
    //form submit
    function researchForm () {
    	var msg;
    	
    	if($("#mode").val() == "new"){
    		msg = "조사개시를 시작하시겠습니까?";
    	}else{
    		msg = "조사내용을 수정하시겠습니까?\n조사내용을 수정하시면, 지금까지 조사한 내용이 사라집니다.\n조사를 처음부터 다시 시작해야 합니다.";
    	}
    	
    	if($("input:checkbox[name=cat_nm]:checked").length == 0){
    		alert("조사 식품구분을 선택하여 주시기 바랍니다.");
    		return false;
    	}
    	
    	if($("input:checkbox[name=team_no]:checked").length == 0){
    		alert("조사팀 배정을 선택하여 주시기 바랍니다.");
    		return false;
    	}
    	
    	if($.trim($("#str_date").val()) == ""){
    		alert("조사 개시일을 선택하여 주시기 바랍니다.");
    		focus($("#str_date").focus());
    		return false;
    	}else if($.trim($("#mid_date").val()) == ""){
    		alert("중간 검토일을 선택하여 주시기 바랍니다.");
    		focus($("#mid_date").focus());
    		return false;
    	}else if($.trim($("#end_date").val()) == ""){
    		alert("조사 종료일을 선택하여 주시기 바랍니다.");
    		focus($("#end_date").focus());
    		return false;
    	}
    	
    	if(confirm(msg)){
    		var year = $("#str_date").val().substring(0,4);
    		var month = $("#str_date").val().substring(4,6);
    		var mode;
    		
    		$("#rsch_year").val(year);
    		$("#rsch_month").val(month);
    		
    		if($("#mode").val() == "new"){
    			mode = "?mode=researchStart";
    		}else{
    			mode = "?mode=researchUpdate";
    		}
    		$("#researchForm").attr("action", "food_research_act.jsp" + mode);
    		$("#researchForm").attr("method", "post");    		
    		return true;
    	}else{
    		return false;
    	}
    }
    
$(function(){
	$("#catAllCheck").click(function(){
		if($("#catAllCheck").is(":checked")){
			$("input:checkbox[name=cat_nm]").prop("checked", "true");
		}else{
			$("input:checkbox[name=cat_nm]").removeAttr("checked");
		}
	});
                  		
	$("#teamAllCheck").click(function(){
		if($("#teamAllCheck").is(":checked")){
			$("input:checkbox[name=team_no]").prop("checked", "true");
		}else{
			$("input:checkbox[name=team_no]").removeAttr("checked");
		}
	});
});
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
		<form id="researchForm" onsubmit="return researchForm();">
            <fieldset>
                <input type="hidden" id="mode" name="mode" value="<%=mode%>">
                <input type="hidden" id="rsch_no" name="rsch_no" value="<%=rsch_no%>">
                <input type="hidden" id="rsch_year" name="rsch_year" value="<%=rschVO.rsch_year%>">
                <input type="hidden" id="rsch_month" name="rsch_month" value="<%=rschVO.rsch_month%>">
                <legend><%=pageTitle%> 테이블</legend>
                <table class="bbs_list2">
                    <colgroup>
                        <col style="width:20%">
                        <col style="width:20%">
                        <col style="width:20%">
                        <col>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">조사개시일</th>
                            <td><input type="text" class="str_date" id="str_date" name="str_date" placeholder="조사 개시일" 
                            	value="<%=rschVO.str_date %>" required readonly></td>
                            <td><input type="text" class="mid_date" id="mid_date" name="mid_date" placeholder="중간 검토일"
                                value="<%=rschVO.mid_date %>" required readonly></td>
                            <td><input type="text" class="end_date" id="end_date" name="end_date" placeholder="조사 종료일" 
                            	value="<%=rschVO.end_date %>" required readonly></td>
                        </tr>
                        <tr>
                            <th scope="row">조사 명</th>
                            <td colspan="3"><input type="text" class="rsch_nm wps_75" id="rsch_nm" name="rsch_nm"
                            				value="<%=rschVO.rsch_nm %>" required></td>
                        </tr>
                        <tr style="height: 300px;">
                        	<td colspan="2">
                        	<input type="checkbox" id="catAllCheck" value="Y"><label for="catAllCheck">전체 선택</label>
                        	<ul style="height: 300px; overflow-y: scroll ">
                        	<%
                        	if(catList!=null && catList.size()>0){
                        		int i=0;
                        		for(FoodVO ob : catList){
                        	%>
                        		<li>
                        			<input type="checkbox" id=cat_nm_<%=i++%> name="cat_nm" value="<%=ob.cat_nm%>"
                        			<%if(!"0".equals(ob.cnt)){out.println("checked");} %>>
                        			<label for="cat_nm_<%=i-1%>"><%=ob.cat_nm%></label>
                        		</li>
                        	<% 
                        		}
                        	}
                        	%>
                        	</ul>
                        	</td>
                        	<td colspan="2">
                        	<input type="checkbox" id="teamAllCheck" value="Y"><label for="teamAllCheck">전체 선택</label>
                        	<ul style="height: 300px; overflow-y: scroll ">
                        	<%
                        	if(teamList!=null && teamList.size()>0){
                        		int i=0;
                        		for(FoodVO ob : teamList){
                        	%>
                        		<li>
                        			<input type="checkbox" id="team_no_<%=i++%>" name="team_no" value="<%=ob.team_no%>"
                        			<%if(!"0".equals(ob.cnt)){out.println("checked");} %>>
                        			<label for="team_no_<%=i-1%>"><%=ob.zone_nm%> <%=ob.cat_nm%> <%=ob.team_nm%></label>
                        		</li>
                        	<%
                        		}
                        	}
                        	%>
                        	</ul>
                        	</td>
                        </tr>
                       <%--  <tr>
                            <th scope="row">
                                조사 파일 등록
                                <input type="hidden" id="file_no" name="file_no" value="">
                            </th>
                            <td colspan="3"><input type="file" class="file_nm wps_75" id="file_nm" name="file_nm"
                            				<%if("new".equals(mode)){out.println("required");} %>></td>
                        </tr> --%>
                    </tbody>
                </table>
                <p class="btn_area txt_c">
                    <button type="submit" class="btn medium edge darkMblue">
                    <%
                    if(mode!=null && "mod".equals(mode)){
                        out.println("조사내용 수정");
                    } else {
                        out.println("조사 개시하기");
                    }
                    %>
                    </button>
					<button type="button" class="btn medium edge mako" onclick="window.close();">닫기</button>
                </p>
            </fieldset>
        </form>
    </div>
</div>

</body>
</html>

