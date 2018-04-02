<%
/**
*   PURPOSE :   조사자(팀장) 관리 - 상세페이지
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
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String pageTitle = "조사자(팀장) 상세보기";
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
SessionManager sessionManager = new SessionManager(request);

String sch_no = parseNull(request.getParameter("sch_no"));

StringBuffer sql 		= null;
FoodVO foodVO	 		= null;

try{
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
	sql.append("	B.NU_MAIL, 										");
	sql.append("	(	SELECT ZONE_NM 								");
	sql.append("		FROM FOOD_ZONE								");
	sql.append("		WHERE ZONE_NO = A.ZONE_NO	) AS ZONE_NM,	");
	sql.append("	(	SELECT TEAM_NM 								");
	sql.append("		FROM FOOD_TEAM								");
	sql.append("		WHERE TEAM_NO = A.TEAM_NO	) AS TEAM_NM	");
	sql.append("FROM FOOD_SCH_TB A LEFT JOIN FOOD_SCH_NU B			");
	sql.append("ON A.SCH_NO = B.SCH_NO								");
	sql.append("WHERE A.SCH_NO = ?									");
	try{
		foodVO = jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{sch_no}).get(0);
	}catch(Exception e){
		foodVO = null;
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
		<section>
			<form action="temp_research_action.jsp" method="post" onsubmit="return submitForm();">
			<input type="hidden" id="sch_org_sid" name="sch_org_sid">
			<input type="hidden" id="sch_gen" name="sch_gen">
                <h2 class="tit"><%=pageTitle%></h2>
                <table class="bbs_list2">
					<caption><%=pageTitle%></caption>
                    <colgroup>
                        <col style="width:20%">
                        <col style="width:30%">
                        <col style="width:20%">
                        <col style="width:30%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><label for="sch_id">학교아이디</label></th>
                            <td colspan="3">
                            	<%=foodVO.sch_id%>
                   	        </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="sch_nm">학교명</label></th>
                            <td>
                            	<%=foodVO.sch_nm%>
                            </td>
                            <th scope="row"><label for="sch_type">학교단위</label></th>
                            <td>
                            <%=outSchType(foodVO.sch_type) %>
							</td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="sch_addr">학교주소</label></th>
                            <td>
                            	<%=foodVO.sch_area %> &nbsp;
                            	<%=foodVO.sch_addr %>
                            </td>
                            <th scope="row"><label for="sch_found">설립구분</label></th>
                            <td>
                            	<%=outSchFound(foodVO.sch_found) %>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="nu_nm">영양사 성명</label></th>
                            <td><%=foodVO.nu_nm%></td>
                            <th scope="row"><label for="sch_tel">학교 연락처</label></th>
                            <td><%=telSet(foodVO.sch_tel)%></td>
                            
                        </tr>
                        <tr>
                            <th scope="row"><label for="nu_tel">영양사 연락처</label></th>
                            <td><%=telSet(foodVO.nu_tel) %></td>
                            <th scope="row"><label for="sch_gradeR">직위</label></th>
                            <td>
                            <%=outSchGrade(foodVO.sch_grade) %>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="nu_mail">영양사 이메일</label></th>
                            <td><%=foodVO.nu_mail%></td>
                            <th scope="row"><label for="zone_no">권역 / 팀</label></th>
                            <td>
                            	<%=foodVO.zone_nm %> / <%=foodVO.team_nm %>
							</td>
                        </tr>
                    </tbody>
                </table>
                <p class="btn_area txt_c">
                	<button type="button" class="btn medium edge mako" 
					onclick="location.href='temp_research_form.jsp?sch_no=<%=foodVO.sch_no%>'" >수정</button>
					<button type="button" class="btn medium edge darkMblue" onclick="location.href='food_research_list.jsp'">
						목록
					</button>
				</p>
			</form>
       </section>
	</div>
<!-- // E : #content -->
</body>
</html>
