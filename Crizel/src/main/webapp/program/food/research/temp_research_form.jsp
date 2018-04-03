<%
/**
*   PURPOSE :   회원신청 및 수정
*   CREATE  :   20180319_mon    Ko
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
SessionManager sessionManager = new SessionManager(request);

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

StringBuffer sql 		= null;
FoodVO foodVO	 		= new FoodVO();
List<FoodVO> zoneList	= null;
List<FoodVO> teamList	= null;
List<FoodVO> joList		= null;
List<FoodVO> areaList	= null;


try{
	if(!"".equals(sch_no)){
		sql = new StringBuffer();
		sql.append("SELECT												");
		sql.append("	A.SCH_NO,										");
		sql.append("	A.SCH_ORG_SID,									");
		sql.append("	A.SCH_TYPE,										");
		sql.append("	A.SCH_ID,										");
		sql.append("	A.SCH_NM,										");
		sql.append("	A.SCH_TEL,										");
		sql.append("	A.SCH_FAX,										");
		sql.append("	A.SCH_AREA,										");
		sql.append("	A.SCH_POST,										");
		sql.append("	A.SCH_ADDR,										");
		sql.append("	A.SCH_FOUND,									");
		sql.append("	A.SCH_URL,										");
		sql.append("	A.SCH_GEN,										");
		sql.append("	A.SHOW_FLAG,									");
		sql.append("	TO_CHAR(A.REG_DATE, 'YYYY-MM-DD') AS REG_DATE,	");
		sql.append("	A.ZONE_NO,										");
		sql.append("	A.TEAM_NO,										");
		sql.append("	A.SCH_GRADE,									");
		sql.append("	A.SCH_LV,										");
		sql.append("	A.SCH_PW,										");
		sql.append("	A.SCH_APP_FLAG,									");
		sql.append("	A.APP_DATE,										");
		sql.append("	A.ETC1,											");
		sql.append("	A.ETC2,											");
		sql.append("	A.ETC3,											");
		sql.append("	B.NU_NO,										");
		sql.append("	B.NU_NM,										");
		sql.append("	B.NU_TEL,										");
		sql.append("	B.NU_MAIL 										");
		sql.append("FROM FOOD_SCH_TB A LEFT JOIN FOOD_SCH_NU B			");
		sql.append("ON A.SCH_NO = B.SCH_NO								");
		sql.append("WHERE A.SCH_NO = ?									");
		try{
			foodVO = jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{sch_no}).get(0);
		}catch(Exception e){
			foodVO = null;
		}
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
		
		sql = new StringBuffer();
		sql.append("SELECT *				 	");
		sql.append("FROM FOOD_TEAM 			 	");
		sql.append("WHERE 	SHOW_FLAG ='Y'	 	");
		sql.append("	AND ZONE_NO = ?	 		");
		sql.append("ORDER BY ORDER1, TEAM_NM 	");
		teamList = jdbcTemplate.query(sql.toString(), new FoodList(), zone_no);
		
		sql = new StringBuffer();
		sql.append("SELECT * 				");
		sql.append("FROM FOOD_JO			");
		sql.append("WHERE 	ZONE_NO = ? 	");
		sql.append("	AND TEAM_NO = ?		");
		sql.append("ORDER BY ORDER1, JO_NM	");
		joList = jdbcTemplate.query(sql.toString(), new FoodList(), zone_no, team_no);
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

function teamSelect(value){
	var zone_no = value;
	var mode = "team";
	$.ajax({
		type : "POST",
		url : "/program/food/research/team_list.jsp",
		data : {
			"zone_no" : zone_no,
			"mode"	  : mode    
			},
		async : false,
		success : function(data){
			$("#team_no").html(data.trim());
		},
		error : function(request, status, error){
		}
	}); 
}

function joSelect(value){
	var team_no = value;
	var mode = "jo";
	$.ajax({
		type : "POST",
		url : "/program/food/research/team_list.jsp",
		data : {
			"team_no" : team_no,
			"mode"	  : mode    
			},
		async : false,
		success : function(data){
			$("#jo_no").html(data.trim());
		},
		error : function(request, status, error){
		}
	}); 
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
});

function rstPass(sch_no) {
    var mode        =   "reset";
    var sendUrl     =   "temp_research_action.jsp";
    location.href   =   sendUrl + "?sch_no=" + sch_no + "&mode=" + mode;
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
			<form action="temp_research_action.jsp" method="post" onsubmit="return submitForm();">
			<input type="hidden" id="sch_org_sid" name="sch_org_sid" value="<%=foodVO.sch_org_sid%>">
			<input type="hidden" id="sch_gen" name="sch_gen" value="<%=foodVO.sch_gen%>">
			<input type="hidden" id="nu_no" name="nu_no" value="<%=foodVO.nu_no%>">
			<input type="hidden" id="sch_no" name="sch_no" value="<%=foodVO.sch_no%>">
			<%if("".equals(sch_no)){ %>
			<input type="hidden" id="mode" name="mode" value="insert">
			<%}else{ %>
			<input type="hidden" id="mode" name="mode" value="update">
			<%} %>
                <h2 class="tit"><%=pageTitle%></h2>
                <table class="bbs_list2">
					<caption><%=pageTitle%> 정보입력</caption>
                    <colgroup>
                        <col style="width:22%">
                        <col>
                        <col style="width:22%">
                        <col>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><span class="red">*</span><label for="sch_id">학교아이디</label></th>
                            <td colspan="3">
                            	<input type="text" id="sch_id" name="sch_id" value="<%=foodVO.sch_id%>" required
                   	        	onkeyup="javascript:searchSch(this);">
                   	        </td>
                        </tr>
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
                        <tr>
                            <th scope="row"><span class="red">*</span><label for="sch_nm">학교명</label></th>
                            <td>
                            	<input type="text" id="sch_nm" name="sch_nm" value="<%=foodVO.sch_nm %>" required>
                            	<div id="searchDiv" style="position:absolute;"></div>
                            </td>
                            <th scope="row"><span class="red">*</span><label for="sch_type">학교단위</label></th>
                            <td>
								<select id="sch_type" name="sch_type" required>
									<option value="">학교단위</option>
	                                <option value="1" <%if("1".equals(foodVO.sch_type)){out.println("selected");} %>>유치원</option>
	                               	<option value="2" <%if("2".equals(foodVO.sch_type)){out.println("selected");} %>>초등학교</option>
	                               	<option value="3" <%if("3".equals(foodVO.sch_type)){out.println("selected");} %>>중학교</option>
	                               	<option value="4" <%if("4".equals(foodVO.sch_type)){out.println("selected");} %>>고등학교</option>
                                </select>
							</td>
                        </tr>
                        <tr>
                            <th scope="row"><span class="red">*</span><label for="sch_addr">학교주소</label></th>
                            <td>
                            	<input type="text" id="sch_area" name="sch_area" value="<%=foodVO.sch_area%>" required><br>
                            	<input type="text" id="sch_addr" name="sch_addr" value="<%=foodVO.sch_addr %>" required class="wps_100">
                            </td>
                            <th scope="row"><span class="red">*</span><label for="sch_found">설립구분</label></th>
                            <td>
                            	<select id="sch_found" name="sch_found" required>
                            		<option value="">설립구분</option>
	                                <option value="1" <%if("1".equals(foodVO.sch_found)){out.println("selected");} %>>국립</option>
	                               	<option value="2" <%if("2".equals(foodVO.sch_found)){out.println("selected");} %>>공립</option>
	                               	<option value="3" <%if("3".equals(foodVO.sch_found)){out.println("selected");} %>>사립</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><span class="red">*</span><label for="nu_nm">영양사 성명</label></th>
                            <td><input type="text" id="nu_nm" name="nu_nm" value="<%=foodVO.nu_nm %>" required></td>
                            <th scope="row"><span class="red">*</span><label for="sch_tel">학교 연락처</label></th>
                            <td><input type="text" id="sch_tel" name="sch_tel" value="<%=foodVO.sch_tel %>" required></td>
                            
                        </tr>
                        <tr>
                            <th scope="row"><span class="red">*</span><label for="nu_tel">영양사 연락처</label></th>
                            <td><input type="text" id="nu_tel" name="nu_tel" value="<%=foodVO.nu_tel%>" required></td>
                            <th scope="row"><span class="red">*</span><label for="sch_gradeR">직위</label></th>
                            <td>
                            	<input type="radio" id="sch_gradeR" name="sch_grade" value="R" required 
                            		<%if("R".equals(foodVO.sch_grade)){out.println("checked");} %>>
                            		<label for="sch_gradeR">조사자</label>
                            	<input type="radio" id="sch_gradeT" name="sch_grade" value="T" required
                            		<%if("T".equals(foodVO.sch_grade)){out.println("checked");} %>>
                            		<label for="sch_gradeT">조사팀장</label>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><span class="red">*</span><label for="nu_mail">영양사 이메일</label></th>
                            <td><input type="text" id="nu_mail" name="nu_mail" value="<%=foodVO.nu_mail%>" required></td>
                            <th scope="row"><label for="zone_no">권역선택</label></th>
                            <td>
								<select id="zone_no" name="zone_no" onchange="teamSelect(this.value)" >
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
                                <select id="team_no" name="team_no" onchange="joSelect(this.value)">
	                                <option value="">팀선택</option>
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
                                <select id="jo_no" name="jo_no" >
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
                                <select id="area_no" name="area_no" >
	                                <option value="">지역선택</option>
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
                        </tr>
                       <%--  
                        <%
                        if("".equals(sch_no)){
                        %>
                        <tr>
                            <th scope="row"><span class="red">*</span><label for="nu_mail">개인정보동의체크</label></th>
                            <td colspan="3">
                            	<input type="checkbox" id="agree" name="agree" required>
                            	<label for="agree">개인정보동의</label>
							</td>
                        </tr>
                        <%
                        } 
                        %>
                         --%>
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
