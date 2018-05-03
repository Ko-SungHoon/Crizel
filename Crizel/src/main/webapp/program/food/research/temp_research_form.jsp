<%
/**
*   PURPOSE :   회원신청 및 수정
*   CREATE  :   20180319_mon    KO
*	MODIFY  :   영양사 다중 추가 20180409_mon    KO
*	MODIFY  :   학교/기관 폼 분할 20180411_wed    KO
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>
<%
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

String pageTitle = "조사자 추가/수정";
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
String sch_no 	= parseNull(request.getParameter("sch_no"));
String zone_no 	= "";
String team_no	= "";
String cat_no	= "";
String mode		= "".equals(sch_no)?"insert":"update";

StringBuffer sql 		= null;
FoodVO foodVO	 		= new FoodVO();
List<FoodVO> nuList		= null;
List<FoodVO> zoneList	= null;
List<FoodVO> teamList	= null;
List<FoodVO> joList		= null;
List<FoodVO> areaList	= null;
List<FoodVO> catList	= null;


//학교일 경우 출력할 학교단위
String[] schTypeO	=	{"A", "B", "C", "D", "E", "F", "G", "H", "I"};
String[] schTypeT	=	{"유치원", "초등학교", "중학교", "고등학교", "대안학교", "특수학교", "고등기술학교", "고등공민학교", "외국인학교"};

//기관일 경우 출력할 기관단위
String[] selTypeO	=	{"Z", "Y", "X", "V"};
String[] selTypeT	=	{"도교육청(본청)", "직속기관", "소속기관", "교육지원청"};

String type		= "";
String type2 	= parseNull(request.getParameter("type2"), "S");


try{
	if(!"".equals(sch_no)){
		sql = new StringBuffer();
		sql.append("SELECT												");
		sql.append("	A.SCH_NO, A.SCH_ORG_SID, A.SCH_TYPE, A.SCH_ID,	");
		sql.append("	A.SCH_NM, A.SCH_TEL, A.SCH_FAX, A.SCH_AREA,		");
		sql.append("	A.SCH_POST, A.SCH_ADDR, A.SCH_FOUND, A.SCH_URL,	");
		sql.append("	A.SCH_GEN, A.SHOW_FLAG,							");
		sql.append("	TO_CHAR(A.REG_DATE, 'YYYY-MM-DD') AS REG_DATE,	");
		sql.append("	A.ZONE_NO, A.CAT_NO, A.TEAM_NO, A.JO_NO,		");
		sql.append("	A.AREA_NO, A.SCH_GRADE, A.SCH_LV, A.SCH_PW,		");
		sql.append("	A.SCH_APP_FLAG, A.APP_DATE,						");
		sql.append("	A.ETC1, A.ETC2,	A.ETC3, 						");
		sql.append("	B.NU_NO, B.NU_NM,								");
		sql.append("	B.NU_TEL, B.NU_MAIL								");
		sql.append("FROM FOOD_SCH_TB A LEFT JOIN FOOD_SCH_NU B			");
		sql.append("ON A.SCH_NO = B.SCH_NO								");
		sql.append("WHERE A.SCH_NO = ?									");
		try{
			foodVO = jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{sch_no}).get(0);
		}catch(Exception e){
			foodVO = null;
		}

		if("Z".equals(foodVO.sch_type) || "Y".equals(foodVO.sch_type)
			|| "X".equals(foodVO.sch_type)|| "V".equals(foodVO.sch_type)){
			type = "O";
		}else{
			type = "S";
		}
		
		sql = new StringBuffer();
		sql.append("SELECT *								");
		sql.append("FROM FOOD_SCH_NU						");
		sql.append("WHERE SHOW_FLAG = 'Y' AND SCH_NO = ?	");
		sql.append("ORDER BY NU_NO							");
		nuList = jdbcTemplate.query(sql.toString(), new FoodList(), sch_no);
	}
	
	sql = new StringBuffer();
	sql.append("SELECT *				 ");
	sql.append("FROM FOOD_ZONE 			 ");
	sql.append("WHERE SHOW_FLAG ='Y'	 ");
	sql.append("ORDER BY ZONE_NM 		 ");
	zoneList = jdbcTemplate.query(sql.toString(), new FoodList());
	
	if(foodVO!=null && !"".equals(sch_no)){
		zone_no = foodVO.zone_no;
		team_no = foodVO.team_no;
		cat_no	= foodVO.cat_no;
		
		sql = new StringBuffer();
		sql.append("SELECT * FROM FOOD_ST_CAT WHERE SHOW_FLAG = 'Y' ORDER BY CAT_NM 	");
		catList = jdbcTemplate.query(sql.toString(), new FoodList());
		
		sql = new StringBuffer();
		sql.append("SELECT *				 			");
		sql.append("FROM FOOD_TEAM 			 			");
		sql.append("WHERE 	SHOW_FLAG ='Y'	 			");
		sql.append("	AND ZONE_NO = ? AND CAT_NO = ?	");
		sql.append("ORDER BY ORDER1, TEAM_NM 			");
		teamList = jdbcTemplate.query(sql.toString(), new FoodList(), zone_no, cat_no);
		
		sql = new StringBuffer();
		sql.append("SELECT * 				");
		sql.append("FROM FOOD_JO			");
		sql.append("WHERE 	TEAM_NO = ? 	");
		sql.append("ORDER BY ORDER1, JO_NM	");
		joList = jdbcTemplate.query(sql.toString(), new FoodList(), team_no);
	}
	
	sql = new StringBuffer();
	sql.append("SELECT *					");
	sql.append("FROM FOOD_AREA				");
	sql.append("WHERE SHOW_FLAG = 'Y'		");
	sql.append("ORDER BY AREA_NO			");
	areaList = jdbcTemplate.query(sql.toString(), new FoodList());
	
}catch(Exception e){
	out.println(e.toString());
}

%>
<script>
function submitForm(){
	var mode = $("#mode").val();
	var msg;
	
	if(mode == "insert"){
		msg = "회원신청을 하시겠습니까?";
	}else{
		msg = "회원수정을 하시겠습니까?";
	}
	
	if(confirm(msg)){
		if($("#sch_pw").val() != $("#sch_pw2").val()){
			alert("패스워드 확인값이 틀렸습니다.");
			return false;
		}else{
			return true;
		}
	}else{
		return false;
	}
}
function searchSch(str){
	var sch_id	=	str.value;
	$.ajax({
		type : "POST",
		url : "/program/food/research/school_info.jsp",
		data : {"sch_id" : sch_id},
		async : false,
		success : function(data){
			$("#searchDiv").html(data.trim());
		},
		error : function(request, status, error){
		}
	});
}



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
			$("#cat_no").html(html);
			$("#team_no").html("<option value=''>팀 선택</option>");
			$("#jo_no").html("<option value=''>조 선택</option>");
		},
		error : function(request, status, error){
		}
	});
}
function teamSelect(cat_no){
	var html = "<option value=''>팀 선택</option>";
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
			html += data.trim();
			$("#team_no").html(html);
			$("#jo_no").html("<option value=''>조 선택</option>");
		},
		error : function(request, status, error){
		}
	});
}
function joSelect(team_no){
	if ($('#sch_gradeT').is(":checked")) {
		alert("조사자로 변경됩니다.");
		$('#sch_gradeR').prop("checked", true);
	}
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
			$("#jo_no").html(html);
		},
		error : function(request, status, error){
		}
	});
}

function joChange (jo_no) {
	if ($('#sch_gradeT').is(":checked")) {
		alert("조사자로 변경됩니다.");
		$('#sch_gradeR').prop("checked", true);
	}
	return;
}

function selInput(sch_org_sid, sch_nm, sch_addr, sch_tel, sch_area, found, sch_gen){
	$("#sch_org_sid").val(sch_org_sid);
	$("#sch_nm").val(sch_nm);
	$("#sch_addr").val(sch_addr);
	$("#sch_tel").val(sch_tel);
	$("#sch_area").val(sch_area);
	$("#sch_gen").val(sch_gen);
	searchSch(sch_nm);
}
$(function(){
	$("#ne_tel").change(function(){this.value = this.value.replace(/[^0-9]/g,'');});
	$("#sch_tel").change(function(){this.value = this.value.replace(/[^0-9]/g,'');});
	$('#sch_gradeT').click(function () {
		alert("조사팀장을 선택했습니다. \n죄송합니다. 다른 조사팀장 여부 확인 기능 작업 중입니다.");
	});
});

function rstPass(sch_no) {
	if (confirm("비밀번호를 초기화 하시겠습니까?")) {
		var mode        =   "reset";
		var sendUrl     =   "temp_research_action.jsp";
		location.href   =   sendUrl + "?sch_no=" + sch_no + "&mode=" + mode;
	}
}
</script>
<script>
function nuAdd(){
	var index = $(".nuInsert").length+1;
	var html = "";
	html += "<tr class='nuInsert' id='nuInsert_1_"+index+"'>";
	html += "	<th scope='row'><span class='red'>*</span><label for='nu_nm_"+index+"'>영양사 성명</label></th>";
	html += "	<td><input type='text' id='nu_nm_"+index+"' name='nu_nm' value='' required></td>";
	html += "	<th scope='row'><span class='red'>*</span><label for='nu_tel_"+index+"'>영양사 연락처</label></th>";
	html += "	<td><input type='text' id='nu_tel_"+index+"' name='nu_tel' value='' required>";
	html += "	<div class='f_r'>";
	html += "		<button type='button' class='btn small edge darkMblue' onclick=\"nuRemove('"+index+"')\">-</button>";
	html += "	</div>";
	html += "	</td>";
	html += "</tr>";
	html += "<tr id='nuInsert_2_"+index+"'>";
	html += "	<th scope='row'><span class='red'>*</span><label for='nu_mail_"+index+"'>영양사 이메일</label></th>";
	html += "	<td><input type='text' id='nu_mail_"+index+"' name='nu_mail' value='' required></td>";
	html += "	<th scope='row'></th><td></td>";
	html += "</tr>";
	
	$(".bbs_list2").append(html);
}
function nuRemove(index){
	$("#nuInsert_1_"+index).remove();
	$("#nuInsert_2_"+index).remove();
}
function insertTypeChange(){
	$("#searchForm").attr("action", "");
	$("#searchForm").attr("method", "get");
	$("#searchForm").submit();
}
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
	<section>
		<h2 class="tit"><%=pageTitle%></h2>
        <%
		if("insert".equals(mode)){
		%>
			<form id="searchForm" class="topbox2">
				<select id="type2" name="type2" onchange="insertTypeChange()">
					<option value="S" <%if("S".equals(type2)){out.println("selected");} %>>학교</option>
					<option value="O" <%if("O".equals(type2)){out.println("selected");} %>>기관</option>
				</select>
			</form>
		<%
		}
		%>
		<form action="temp_research_action.jsp" method="post" onsubmit="return submitForm();">
		<input type="hidden" id="sch_org_sid" name="sch_org_sid" value="<%=foodVO.sch_org_sid%>">
		<input type="hidden" id="sch_gen" name="sch_gen" value="<%=foodVO.sch_gen%>">
		<input type="hidden" id="sch_no" name="sch_no" value="<%=foodVO.sch_no%>">
		<%if("".equals(sch_no)){ %>
		<input type="hidden" id="mode" name="mode" value="insert">
		<%}else{ %>
		<input type="hidden" id="mode" name="mode" value="update">
		<%} %>
               <table class="bbs_list2">
				<caption><%=pageTitle%> 정보입력</caption>
                   <colgroup>
                       <col style="width:22%">
                       <col style="width:28%">
                       <col style="width:22%">
                       <col style="width:28%">
                   </colgroup>
                   <tbody>
                       <tr>
                           <th scope="row"><span class="red">*</span><label for="sch_id">아이디</label></th>
                           <td>
                           	<input type="text" id="sch_id" name="sch_id" value="<%=foodVO.sch_id%>" required
                  	        	onkeyup="javascript:searchSch(this);" 
								<%if(sch_no != null && sch_no.length() > 0){out.println("readonly");} %>
							>
                  	        </td>
                           <th scope="row"><span class="red">*</span><label for="sch_nm">기관명</label></th>
                           <td>
                           	<input type="text" id="sch_nm" name="sch_nm" value="<%=foodVO.sch_nm %>" required>
                           	<div id="searchDiv" style="position:absolute;"></div>
                           </td>
                       </tr>
                       <tr>
                           <th scope="row"><span class="red">*</span><label for="sch_type">단위</label></th>
                           <td>
							<select id="sch_type" name="sch_type" required>
								<option value="">단위</option>
							<%
							if("S".equals(type) || ("insert".equals(mode) && "S".equals(type2))){
								for(int i=0; i<schTypeO.length; i++){
									out.println(printOption(schTypeO[i], schTypeT[i], foodVO.sch_type));
								}
							}else{
								for(int i=0; i<selTypeO.length; i++){
									out.println(printOption(selTypeO[i], selTypeT[i], foodVO.sch_type));
								}
							}
							
							%>
                               </select>
						</td>
						<th scope="row"><span class="red">*</span><label for="sch_tel">연락처</label></th>
                           <td><input type="text" id="sch_tel" name="sch_tel" value="<%=foodVO.sch_tel %>" required></td>
                       </tr>
                       <tr>
                           <th scope="row"><span class="red">*</span><label for="sch_addr">주소</label></th>
                           <td>
                           <%
                           if("S".equals(type) || ("insert".equals(mode) && "S".equals(type2))){
                           %>
                           	<input type="hidden" id="sch_area" name="sch_area" value="<%=foodVO.sch_area%>">
                           <%
                           }
                           %>
                           	<input type="text" id="sch_addr" name="sch_addr" value="<%=foodVO.sch_addr %>" required class="wps_100">
                           </td>
                           <th></th><td></td>
                           <%-- <th scope="row"><span class="red">*</span><label for="sch_found">설립구분</label></th>
                           <td>
                           	<select id="sch_found" name="sch_found" required>
                           		<option value="">설립구분</option>
                                <option value="1" <%if("1".equals(foodVO.sch_found)){out.println("selected");} %>>국립</option>
                               	<option value="2" <%if("2".equals(foodVO.sch_found)){out.println("selected");} %>>공립</option>
                               	<option value="3" <%if("3".equals(foodVO.sch_found)){out.println("selected");} %>>사립</option>
                               </select>
                           </td> --%>
                       </tr>
                       <%
                       if("S".equals(type) || ("insert".equals(mode) && "S".equals(type2))){
                       %>
						<tr>
                           <th scope="row"><label for="sch_gradeR">등급</label></th>
                           <td>
                           	<input type="radio" id="sch_gradeR" name="sch_grade" value="R" 
                           		<%if("R".equals(foodVO.sch_grade)){out.println("checked");} %>>
                           		<label for="sch_gradeR">조사자</label>
                           	<input type="radio" id="sch_gradeT" name="sch_grade" value="T" 
                           		<%if("T".equals(foodVO.sch_grade)){out.println("checked");} %>>
                           		<label for="sch_gradeT">조사팀장</label>
                           </td>
						<th scope="row"><label for="sch_gradeR">등록일</label></th>
						<td><%=foodVO.reg_date %></td>
                       </tr>
                       <tr>
						<th scope="row"><span class="red">*</span><label for="area_no">지역선택</label></th>
						<td>
							<select id="area_no" name="area_no" required>
                                <option value="">지역선택 </option>
								<%
								if(areaList!=null && areaList.size()>0){
									for(FoodVO ob : areaList){
								%>
									<option value="<%=ob.area_no%>" 
									<%if(foodVO.area_no.equals(ob.area_no)){out.println("selected");}%>><%=ob.area_nm%></option>
								<%
									}
								}
								%>
							</select>
						</td>
						<th scope="row"><label for="zone_no">권역선택</label></th>
						<td>
							<select id="zone_no" name="zone_no" onchange="catSelect(this.value)" >
								<option value="">권역선택</option>
								<%
								if(zoneList!=null && zoneList.size()>0){
									for(FoodVO ob : zoneList){
										out.println("<option value='" + ob.zone_no + "' ");
										if(ob.zone_no.equals(foodVO.zone_no)){
											out.println("selected");
										}
										out.println(">");
										out.println(ob.zone_nm + "</option>");
									}
								}
								%>
                               </select>
							<select id="cat_no" name="cat_no" onchange="teamSelect(this.value)">
                                <option value="">품목선택</option>
								<%
								if(catList!=null && catList.size()>0){
									for(FoodVO ob : catList){
								%>
									<option value="<%=ob.cat_no%>" 
									<%if(foodVO.cat_no.equals(ob.cat_no)){out.println("selected");}%>><%=ob.cat_nm%></option>
								<%
									}
								}
								%>
                               </select>
						</td>
					</tr>
                       <tr>
                           <th scope="row"><label for="zone_no">팀 선택</label></th>
                           <td>
							<select id="team_no" name="team_no" onchange="joSelect(this.value)">
                                <option value="">팀 선택</option>
                            <%
                            if(teamList!=null && teamList.size()>0){
                            	for(FoodVO ob : teamList){
                            %>
                            	<option value="<%=ob.team_no%>" 
                            	<%if(foodVO.team_no.equals(ob.team_no)){out.println("selected");}%>><%=ob.team_nm%></option>
                            <%
                            	}
                            }
                            %>
                               </select>
						</td>
						<th scope="row"><label for="zone_no">조 선택</label></th>
						<td>
							<select id="jo_no" name="jo_no" onchange="joChange(this.value)">
                                <option value="">조선택</option>
                            <%
                            if(joList!=null && joList.size()>0){
                            	for(FoodVO ob : joList){
                            %>
                            	<option value="<%=ob.jo_no%>" 
                            	<%if(foodVO.jo_no.equals(ob.jo_no)){out.println("selected");}%>><%=ob.jo_nm%></option>
                            <%
                            	}
                            }
                            %>
                               </select>
						</td>
                       </tr>
                       <%
                       }
                       %>
                       <%if("insert".equals(mode)){ %>
					<tr>
                       	<th scope="row"><span class="red">*</span><label for="sch_pw">패스워드</label></th>
                           <td>
                           	<input type="password" id="sch_pw" name="sch_pw" value="" 
                           	<%if("".equals(foodVO.sch_no)){out.println("required");} %> >
                               <button type="button" class="btn small edge darkMblue" onclick="rstPass('<%=foodVO.sch_no %>')">초기화</button>
                           </td>
                           <th scope="row"><span class="red">*</span><label for="sch_pw">패스워드 확인</label></th>
                           <td>
                           	<input type="password" id="sch_pw2" name="sch_pw2" value="" 
							<%if("".equals(foodVO.sch_no)){out.println("required");} %> >
                           </td>
                       </tr>
                       <%}else{ %>
                       <tr>
                       	<th scope="row">패스워드 초기화</th>
                           <td>
                               <button type="button" class="btn small edge darkMblue" onclick="rstPass('<%=foodVO.sch_no %>')">초기화</button>
                           </td>
                       </tr>
                       <%} %>
					<%
					if("S".equals(type) || ("insert".equals(mode) && "S".equals(type2))){
					%>
					<tr>
						<th scope="row" colspan="4">
							영양사 정보
							<div class="f_r">
								<button type="button" class="btn small edge darkMblue" onclick="nuAdd()">+</button>
							</div>
						</th>
					</tr>
					<%
					if("insert".equals(mode)){
					%>
						<tr class="nuInsert" id="nuInsert_1_1">
                            <th scope="row"><span class="red">*</span><label for="nu_nm">영양사 성명</label></th>
                            <td><input type="text" id="nu_nm" name="nu_nm" value="" required></td>
                            <th scope="row"><span class="red">*</span><label for="nu_tel">영양사 연락처</label></th>
                            <td><input type="text" id="nu_tel" name="nu_tel" value="" required>
                            	<div class="f_r">
									<button type="button" class="btn small edge darkMblue" onclick="nuRemove('1')">-</button>
								</div>
                            </td>
                        </tr>
						<tr id="nuInsert_2_1">
							<th scope="row"><span class="red">*</span><label for="nu_mail">영양사 이메일</label></th>
                            <td><input type="text" id="nu_mail" name="nu_mail" value="" required></td>
							<th scope="row"></th><td></td>
						</tr>
					<%
					}else if("update".equals(mode)){
						if(nuList!=null && nuList.size()>0){
							for(int i=0; i<nuList.size(); i++){
								FoodVO nuVO = nuList.get(i);
					%>
						<tr class="nuInsert" id="nuInsert_1_<%=i+1%>">
                            <th scope="row"><span class="red">*</span><label for="nu_nm_<%=i+1%>">영양사 성명</label></th>
                            <td>
                            	<input type="text" id="nu_nm_<%=i+1%>" name="nu_nm" value="<%=nuVO.nu_nm %>" required>
                            	<input type="hidden" id="nu_no_<%=i+1%>" name="nu_no" value="<%=nuVO.nu_no%>">
                            </td>
                            <th scope="row"><span class="red">*</span><label for="nu_tel_<%=i+1%>">영양사 연락처</label></th>
                            <td><input type="text" id="nu_tel_<%=i+1%>" name="nu_tel" value="<%=nuVO.nu_tel%>" required>
                            <%
                            if(i>0){
                            %>
                            	<div class="f_r">
									<button type="button" class="btn small edge darkMblue" onclick="nuRemove('<%=i+1%>')">-</button>
								</div>
							<%} %>
                            </td>
                        </tr>
						<tr id="nuInsert_2_<%=i+1%>">
							<th scope="row"><span class="red">*</span><label for="nu_mail_<%=i+1%>">영양사 이메일</label></th>
                            <td><input type="text" id="nu_mail_<%=i+1%>" name="nu_mail" value="<%=nuVO.nu_mail%>" required></td>
							<th scope="row"></th><td></td>
						</tr>
					<%
							}
						}
					}
					
					}
					%>
                   </tbody>
               </table>
               <p class="btn_area txt_c">
				<%
                   if("".equals(sch_no)){
                   %>
					<button type="submit" class="btn medium edge darkMblue">등록</button>
				<%
                   }else{
				%>
					<button type="submit" class="btn medium edge darkMblue">수정</button>
					<button type="button" class="btn medium edge mako" 
					onclick="location.href='food_research_view.jsp?sch_no=<%=foodVO.sch_no%>'" >취소</button>
				<%} %>
			</p>
		</form>
      </section>
	

</div>
<!-- // E : #content -->
</body>
</html>
