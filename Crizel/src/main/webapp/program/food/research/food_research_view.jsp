<%
/**
*   PURPOSE :   조사자(팀장) 관리 - 상세페이지
*   CREATE  :   20180319_mon    Ko
*   MODIFY  :   20180405_thur	JI	구성 변경 및 영양사 반복문 추가
*   MODIFY  :   20180406_fri	JI	조사자일 경우와 조사팀장일 경우의 조사식품 리스트 출력 구분하기
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
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String pageTitle = "조사자, 조사팀장 상세보기";

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

StringBuffer sql 		=	null;
FoodVO foodVO	 		=	null;	//학교 정보
List<FoodVO> nuList 	=	null;	//영양사 리스트
int rschTotalFood		=	0;		//조사식품 수
List<FoodVO> foodList 	=	null;	//조사식품 리스트

try{

	//학교, 영양사 정보 출력
	sql =	new StringBuffer();
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
	sql.append("	A.CAT_NO,										");
	sql.append("	A.TEAM_NO,										");
	sql.append("	A.JO_NO,										");
	sql.append("	A.AREA_NO,										");
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
		foodVO	=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{sch_no}).get(0);
		nuList	=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{sch_no});
	}catch(Exception e){
		foodVO = null;
	}

	//조사팀장 일 경우
	if ("T".equals(foodVO.sch_grade)) {

		//전체 식품 수 출력
		sql =	new StringBuffer();
		sql.append("SELECT NVL(COUNT(RSCH_ITEM_NO), 0) 					");
		sql.append("FROM FOOD_RSCH_ITEM				 					");
		sql.append("WHERE SCH_NO IN (SELECT SCH_NO	 					");
		sql.append("	SELECT SCH_NO	 								");
		sql.append("	FROM FOOD_SCH_TB	 							");
		sql.append("	WHERE JO_NO = ?				 					");
		try{
			rschTotalFood	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class, new Object[]{foodVO.jo_no});
		}catch(Exception e){
			rschTotalFood	=	0;
		}

	//조사자 일 경우
	} else {

		//전체 식품 수 출력
		sql =	new StringBuffer();
		sql.append("SELECT NVL(COUNT(RSCH_ITEM_NO), 0) 					");
		sql.append("FROM FOOD_RSCH_ITEM				 					");
		sql.append("WHERE SCH_NO = ?				 					");
		try{
			rschTotalFood	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class, new Object[]{sch_no});
		}catch(Exception e){
			rschTotalFood	=	0;
		}

		//전체 식품 리스트 출력
		sql	=	new StringBuffer();
		sql.append("SELECT 													                                ");
		sql.append("	A.RSCH_ITEM_NO,										                                ");
		sql.append("    C.ITEM_NO,                                                                          ");
		sql.append("    (SELECT CAT_NM FROM FOOD_ST_CAT                                                     ");
		sql.append("    WHERE CAT_NO = C.CAT_NO) AS CAT_NM,                                                 ");
		sql.append("    C.FOOD_CAT_INDEX,                                                                   ");
		sql.append("    C.FOOD_CODE,                                                                        ");
		sql.append("    (SELECT SUBSTR(XMLAGG(                                                              ");
		sql.append("        XMLELEMENT(COL ,',', NM_FOOD) ORDER BY NM_FOOD).EXTRACT('//text()'              ");
		sql.append("    ).GETSTRINGVAL(),2) NM_FOOD                                                         ");
		sql.append("    FROM FOOD_ST_NM                                                                     ");
		sql.append("    WHERE NM_NO IN (FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5)) AS NM_FOOD, ");
		sql.append("    (SELECT SUBSTR( XMLAGG(                                                             ");
		sql.append("        XMLELEMENT(COL ,',', DT_NM) ORDER BY DT_NM).EXTRACT('//text()'                  ");
		sql.append("        ).GETSTRINGVAL(),2) DT_NM                                                       ");
		sql.append("    FROM FOOD_ST_DT_NM                                                                  ");
		sql.append("    WHERE DT_NO IN (FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5,              ");
		sql.append("    FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10)) AS DT_NM,                  ");
		sql.append("    (SELECT SUBSTR( XMLAGG(                                                             ");
		sql.append("        XMLELEMENT(COL,',', EX_NM) ORDER BY EX_NM).EXTRACT('//text()'                   ");
		sql.append("        ).GETSTRINGVAL(),2) EX_NM                                                       ");
		sql.append("    FROM FOOD_ST_EXPL                                                                   ");
		sql.append("    WHERE EX_NO IN (FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5,              ");
		sql.append("    FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10, FOOD_EP_11,                 ");
		sql.append("    FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15, FOOD_EP_16, FOOD_EP_17,             ");
		sql.append("    FOOD_EP_18, FOOD_EP_19, FOOD_EP_20, FOOD_EP_21, FOOD_EP_22, FOOD_EP_23,             ");
		sql.append("    FOOD_EP_24, FOOD_EP_25)) AS EX_NM,                                                  ");
		sql.append("    B.ITEM_COMP_NO,                                                                     ");
		sql.append("    B.ITEM_COMP_VAL,                                                                    ");

		sql.append("	(SELECT SUBSTR( XMLAGG(																");
		sql.append("		XMLELEMENT(COL,',', SCH_NM) ORDER BY SCH_NM).EXTRACT('//text()'					");
		sql.append("		).GETSTRINGVAL(),2) SCH_NM														");
		sql.append("	FROM FOOD_SCH_TB																	");
		sql.append("	WHERE SCH_NO IN																		");
		sql.append("	(SELECT SCH_NO FROM FOOD_RSCH_ITEM WHERE ITEM_NO = C.ITEM_NO)) AS SCH_NM			");
		
		sql.append("FROM FOOD_RSCH_ITEM A LEFT JOIN FOOD_ITEM_PRE B			                                ");
		sql.append("	ON A.ITEM_NO = B.ITEM_NO LEFT JOIN FOOD_ST_ITEM C	                                ");
		sql.append("	ON A.ITEM_NO = C.ITEM_NO 							                                ");
		sql.append("WHERE A.SCH_NO = ?										                                ");
		try {
			foodList		=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{sch_no});
		}catch(Exception e) {
			foodList		=	null;
		}

	}


}catch(Exception e){
	out.println(e.toString());
}

%>
<script>
	//조사식품 추가 popup
	function addFood(sch_id) {
		if (confirm("조사식품을 추가 하시겠습니까?")) {
			newWin("food_research_popup.jsp?sch_id=" + sch_id, 'PRINTVIEW', '1000', '740');
		}
	}

	//조사식품 삭제 popup
	function delFood(item_no) {
		var send_url	=	"food_research_item_act.jsp";
		var params		=	{mode:"del", sch_no:"<%=sch_no %>", item_no:item_no};
		post_to_url(send_url, params, "post");
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

	function post_to_url(path, params, method) {
        method = method || "post";  //method 부분은 입력안하면 자동으로 post가 된다.
        var form = document.createElement("form");
        form.setAttribute("method", method);
        form.setAttribute("action", path);
        //input type hidden name(key) value(params[key]);
        for(var key in params) {
            var hiddenField = document.createElement("input");
            hiddenField.setAttribute("type", "hidden");
            hiddenField.setAttribute("name", key);
            hiddenField.setAttribute("value", params[key]);
            form.appendChild(hiddenField);
        }
        document.body.appendChild(form);
        form.submit();
    }

	$(function(){
		//조사식품 삭제
		$(".selItem").click(function (){
			var index	=	$(".selItem").index(this);
			var rsch_item_no	=	$(".selItem").eq(index).data("value");
			var item_no			=	$(".nm_food").eq(index).data("value");
			var item_comp_no	=	$(".comp_val").eq(index).data("value");
			var nm_food			=	$(".nm_food").eq(index).text().trim();
			if (item_comp_no > 0) {
				if (confirm("비교조사 그룹 조사식품 삭제는\n동일한 그룹 조사식품도 삭제됩니다.\n삭제하시겠습니까?")) {
					delFood(item_no);
				}
			} else {
				if (confirm(nm_food + " 을(를) 삭제하시겠습니까?")) {
					delFood(item_no);
				}
			}
		});
	});

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
                            <td>
                            	<%=foodVO.sch_id%>
                   	        </td>
                            <th scope="row"><label for="sch_nm">학교명</label></th>
                            <td>
                            	<%=foodVO.sch_nm%>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="sch_type">학교단위</label></th>
                            <td>
                            	<%=outSchType(foodVO.sch_type) %>
							</td>
                            <th scope="row"><label for="sch_found">설립구분</label></th>
                            <td>
                            	<%=outSchFound(foodVO.sch_found) %>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="sch_addr">학교주소</label></th>
                            <td>
                            	<%=foodVO.sch_area %> &nbsp;
                            	<%=foodVO.sch_addr %>
                            </td>
                            <th scope="row"><label for="sch_tel">급식소 연락처</label></th>
                            <td><%=telSet(foodVO.sch_tel)%></td>
                        </tr>
						<tr>
                            <th scope="row"><label for="sch_addr">등급</label></th>
                            <td><label for="sch_gradeR"><%=outSchGrade(foodVO.sch_grade) %></label></td>
							<th scope="row"><label for="zone_no">권역/품목/팀/조</label></th>
                            <td>
                            	<%=foodVO.zone_nm %> / <%=foodVO.team_nm %>
							</td>
                        </tr>
						<tr>
							<th></th><th></th><th></th><th></th>
						</tr>
						<%/** 영양사 반복문 **/%>
						<%if (nuList != null && nuList.size() > 0) {
							for (FoodVO vo : nuList) {%>
                        <tr>
                            <th scope="row"><label for="nu_nm">영양(교)사 명</label></th>
                            <td><%=vo.nu_nm%></td>
                            <th scope="row"><label for="nu_tel">휴대전화</label></th>
                            <td><%=telSet(vo.nu_tel) %></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="nu_mail">영양사 이메일</label></th>
                            <td><%= vo.nu_mail%></td>
                            <th></th>
							<td></td>
                        </tr>
						<%}/*END FOR*/
						}/*END IF*/%>
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
 
	    <section>
			<h2 class="tit">조사식품</h2>
			<div class="f_r">
			<%if ("T".equals(foodVO.sch_grade)) {} else {%>
				<button type="button" class="btn small edge darkMblue" onclick="addFood('<%=foodVO.sch_id %>');">+</button>
			<%}%>
			</div>
			<p class="f_l magT10">
				<strong>총  조사식품 <span><%=rschTotalFood %></span> 건</strong>
			</p>

			<p class="clearfix"></p>
			<table class="bbs_list">
				<caption>조사식품 리스트</caption>
				<colgroup>
					<col style="width: 5%">
					<col style="width: 5%">
					<col style="width: 5%">
					<col style="width: 10%">
					<col style="width: 10%">
					<col>
					<col style="width: 10%">
					<col style="width: 15%">
					<col style="width: 5%">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">품목</th>
						<th scope="col">구분</th>
						<th scope="col">식품코드</th>
						<th scope="col">식품명</th>
						<th scope="col">상세식품명</th>
						<th scope="col">식품설명</th>
						<th scope="col">비교조사</th>
						<th scope="col">조사참여학교</th>
						<th scope="col">삭제</th>
					</tr>
				</thead>
				<tbody>
					<%if (foodList != null && foodList.size() > 0) {
						for (FoodVO vo : foodList) {%>
					<tr>
						<td><%=vo.cat_nm %></td>
						<td><%=vo.cat_nm %>-<%=vo.food_cat_index %></td>
						<td><%=vo.food_code %></td>
						<td><span class="nm_food" data-value="<%=vo.item_no %>"><%=vo.nm_food%></span></td>
						<td><%=vo.dt_nm %></td>
						<td><%=vo.ex_nm %></td>
						<td><span class="comp_val" data-value="<%=vo.item_comp_no %>">
                            <%if(vo.item_comp_no != null && vo.item_comp_no.length() > 0) {%>비교 <%=vo.item_comp_no%> / <%=vo.item_comp_val%><%}%>
                        </span></td>
						<td><%=vo.sch_nm %></td>
						<td>
							<%if ("T".equals(foodVO.sch_grade)) {} else {%>
							<button type="button" class="btn small edge mako selItem" data-value="<%=vo.rsch_item_no %>">-</button>
							<%}%>
						</td>
					</tr>
					<%}/*END FOR*/
					}/*END IF*/else {%>
					<tr>
						<td colspan="9">조사식품이 없습니다.</td>			
					</tr>
					<%}%>
				</tbodt>
			</table>
	    </section>
	</div>
<!-- // E : #content -->
</body>
</html>
