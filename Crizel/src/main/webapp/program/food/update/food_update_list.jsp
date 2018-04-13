<%
/**
*   PURPOSE :   업데이트 요청관리
*   CREATE  :   20180323_fri    Ko
*   MODIFY  :   20180410_tue    JI
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
String pageTitle = "업데이트 요청관리";
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
StringBuffer sql	=	null;
//검색 form
String search1		=	parseNull(request.getParameter("search1"));	//검색어 분류
String keyword		=	parseNull(request.getParameter("keyword"));	//검색어
String rftData		=	parseNull(request.getParameter("rftData"));	//checkbox
//where
Object[] setObj         = null;
List<String> setList	= new ArrayList<String>();
//출력 List
List<FoodVO> updateList 	= null;

//set the paging
Paging paging = new Paging();
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;

try{
	//totalCount
	sql	=	new StringBuffer();
	sql.append(" SELECT COUNT(*) FROM (														");
	sql.append(" SELECT 																	");
	sql.append(" 	(SELECT SUBSTR(XMLAGG(													");
	sql.append(" 		XMLELEMENT(COL ,',', NM_FOOD) ORDER BY NM_FOOD).EXTRACT('//text()'	");
	sql.append(" 	).GETSTRINGVAL(),2) NM_FOOD												");
	sql.append(" 	FROM FOOD_ST_NM															");
	sql.append(" 	WHERE NM_NO IN (FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5))	");
	sql.append(" 	AS NM_FOOD,																");
	sql.append(" 	(SELECT SUBSTR( XMLAGG(													");
	sql.append(" 	XMLELEMENT(COL ,',', DT_NM) ORDER BY DT_NM).EXTRACT('//text()'			");
	sql.append(" 	).GETSTRINGVAL(),2) DT_NM												");
	sql.append(" 	FROM FOOD_ST_DT_NM														");
	sql.append(" 	WHERE DT_NO IN (FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5,	");
	sql.append(" 	FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10)) AS DT_NM,		");
	sql.append(" 	(SELECT SUBSTR( XMLAGG(													");
	sql.append(" 		XMLELEMENT(COL,',', EX_NM) ORDER BY EX_NM).EXTRACT('//text()'		");
	sql.append(" 		).GETSTRINGVAL(),2) EX_NM											");
	sql.append(" 	FROM FOOD_ST_EXPL														");
	sql.append(" 	WHERE EX_NO IN (FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5,	");
	sql.append(" 	FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10, FOOD_EP_11,		");
	sql.append(" 	FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15, FOOD_EP_16, FOOD_EP_17,	");
	sql.append(" 	FOOD_EP_18, FOOD_EP_19, FOOD_EP_20, FOOD_EP_21, FOOD_EP_22, FOOD_EP_23,	");
	sql.append(" 	FOOD_EP_24, FOOD_EP_25)) AS EX_NM										");

	sql.append(" FROM FOOD_UPDATE A LEFT JOIN 												");
	sql.append(" (SELECT * FROM FOOD_ITEM_PRE WHERE SHOW_FLAG = 'Y') B						");
	sql.append(" ON A.S_ITEM_NO = B.S_ITEM_NO LEFT JOIN FOOD_ST_ITEM C						");
	sql.append(" ON B.ITEM_NO = C.ITEM_NO													");
	sql.append(" WHERE 1=1																	");

	if(!"".equals(search1) && !"".equals(keyword) ){
		if("nm_food".equals(search1)){
			sql.append(" AND NM_FOOD LIKE '%'||?||'%'										");
		}else if("dt_nm".equals(search1)){
			sql.append(" AND DT_NM LIKE '%'||?||'%'											");
		}else if("ex_nm".equals(search1)){
			sql.append(" AND EX_NM LIKE '%'||?||'%'											");
		}
		setList.add(keyword);
		paging.setParams("search1", search1);
		paging.setParams("keyword", keyword);
	}
	if("on".equals(rftData)){
		sql.append(" AND A.STS_FLAG IN ('Y', 'N', 'R', 'A')									");
	}else {
		sql.append(" AND A.STS_FLAG IN ('Y', 'N', 'R') 	        							");
	}
	sql.append(")																			");

	setObj = new Object[setList.size()];
	for(int i=0; i<setList.size(); i++){
		setObj[i] = setList.get(i);
	}

	try{
		totalCount	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class, setObj);
	}catch(Exception e){
		totalCount	=	0;
	}

	//페이징 set
    paging.setTotalCount(totalCount);
    paging.setPageNo(Integer.parseInt(pageNo));
    paging.setPageSize(10);
    paging.makePaging();

	//request update list
	sql	=	new StringBuffer();
	sql.append(" SELECT * FROM(																");
	sql.append("	SELECT ROWNUM AS RNUM, C.* FROM (										");

	sql.append("    SELECT																	");
	sql.append("    A.UPD_NO,																");
	sql.append("    A.SCH_NO,																");
	sql.append("    A.NU_NO,																");
	sql.append("    (SELECT NU_NM FROM FOOD_SCH_NU                                     		");
	sql.append("    WHERE NU_NO = A.NU_NO) AS NU_NM, 		                                ");
	sql.append("    A.N_ITEM_CODE,															");
	sql.append("    A.N_ITEM_NM,															");
	sql.append("    A.N_ITEM_DT_NM,															");
	sql.append("    A.N_ITEM_EXPL,															");
	sql.append("    A.N_ITEM_UNIT,															");
	sql.append("    C.FOOD_UNIT,															");
	sql.append("    (SELECT UNIT_NM FROM FOOD_ST_UNIT                                 		");
	sql.append("    WHERE UNIT_NO = C.FOOD_UNIT) AS UNIT_NM,	                            ");
	sql.append("    A.UPD_FLAG,																");
	sql.append("    A.UPD_REASON,															");
	sql.append("    A.STS_FLAG,																");
	sql.append("    A.RJC_REASON,															");
	sql.append("    A.REG_DATE,																");
	sql.append("    A.RJC_DATE,																");
	sql.append("    A.MOD_DATE,																");
	sql.append("    A.STS_DATE,																");
	sql.append("    A.SHOW_FLAG,															");
	sql.append("    C.ITEM_NO,                                                              ");
	sql.append("    C.FOOD_CODE,                                                            ");
	sql.append("    C.FOOD_CAT_INDEX,                                                       ");
	sql.append("    C.CAT_NO,																");
	sql.append("    (SELECT CAT_NM FROM FOOD_ST_CAT                                         ");
	sql.append("    WHERE CAT_NO = A.N_CAT_NO) AS CAT_NM,                                   ");
	sql.append("    D.ZONE_NO,                               							    ");
	sql.append("    (SELECT ZONE_NM FROM FOOD_ZONE                                     		");
	sql.append("    WHERE ZONE_NO = D.ZONE_NO) AS ZONE_NM,                                  ");
	sql.append("    D.TEAM_NO,                               							    ");
	sql.append("    (SELECT TEAM_NM FROM FOOD_TEAM                                     		");
	sql.append("    WHERE TEAM_NO = D.TEAM_NO) AS TEAM_NM,                                  ");
	sql.append("    D.SCH_NM,                               							    ");
	sql.append("    D.SCH_TEL,                               							    ");

	sql.append(" 	(SELECT SUBSTR(XMLAGG(													");
	sql.append(" 		XMLELEMENT(COL ,',', NM_FOOD) ORDER BY NM_FOOD).EXTRACT('//text()'	");
	sql.append(" 	).GETSTRINGVAL(),2) NM_FOOD												");
	sql.append(" 	FROM FOOD_ST_NM															");
	sql.append(" 	WHERE NM_NO IN (FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5))	");
	sql.append(" 	AS NM_FOOD,																");
	sql.append(" 	(SELECT SUBSTR( XMLAGG(													");
	sql.append(" 	XMLELEMENT(COL ,',', DT_NM) ORDER BY DT_NM).EXTRACT('//text()'			");
	sql.append(" 	).GETSTRINGVAL(),2) DT_NM												");
	sql.append(" 	FROM FOOD_ST_DT_NM														");
	sql.append(" 	WHERE DT_NO IN (FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5,	");
	sql.append(" 	FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10)) AS DT_NM,		");
	sql.append(" 	(SELECT SUBSTR( XMLAGG(													");
	sql.append(" 		XMLELEMENT(COL,',', EX_NM) ORDER BY EX_NM).EXTRACT('//text()'		");
	sql.append(" 		).GETSTRINGVAL(),2) EX_NM											");
	sql.append(" 	FROM FOOD_ST_EXPL														");
	sql.append(" 	WHERE EX_NO IN (FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5,	");
	sql.append(" 	FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10, FOOD_EP_11,		");
	sql.append(" 	FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15, FOOD_EP_16, FOOD_EP_17,	");
	sql.append(" 	FOOD_EP_18, FOOD_EP_19, FOOD_EP_20, FOOD_EP_21, FOOD_EP_22, FOOD_EP_23,	");
	sql.append(" 	FOOD_EP_24, FOOD_EP_25)) AS EX_NM										");

	sql.append(" FROM (SELECT * FROM FOOD_UPDATE WHERE SHOW_FLAG = 'Y') A LEFT JOIN 		");
	sql.append(" (SELECT * FROM FOOD_ITEM_PRE WHERE SHOW_FLAG = 'Y') B						");
	sql.append(" ON A.S_ITEM_NO = B.S_ITEM_NO LEFT JOIN FOOD_ST_ITEM C						");
	sql.append(" ON B.ITEM_NO = C.ITEM_NO LEFT JOIN FOOD_SCH_TB D							");
	sql.append(" ON A.SCH_NO = D.SCH_NO														");
	sql.append(" WHERE 1=1																	");

	if(!"".equals(search1) && !"".equals(keyword) ){
		if("nm_food".equals(search1)){
			sql.append(" AND NM_FOOD LIKE '%'||?||'%'										");
		}else if("dt_nm".equals(search1)){
			sql.append(" AND DT_NM LIKE '%'||?||'%'											");
		}else if("ex_nm".equals(search1)){
			sql.append(" AND EX_NM LIKE '%'||?||'%'											");
		}
	}

	//반영완료 보기 checkbox
	if("on".equals(rftData)){
		sql.append(" AND A.STS_FLAG IN ('Y', 'N', 'R', 'A')									");
	}else {
		sql.append(" AND A.STS_FLAG IN ('N', 'R', 'Y') 	        							");
	}

	sql.append(" ORDER BY DECODE(A.STS_FLAG, 'N', 1, 'Y', 2), UPD_NO						");
	sql.append("	) C WHERE ROWNUM <= ").append(paging.getEndRowNo()).append("			");
	sql.append(" ) WHERE RNUM > ").append(paging.getStartRowNo()).append(" 					");

	try{
		updateList	=	jdbcTemplate.query(sql.toString(), new FoodList(), setObj);
	}catch(Exception e){
		updateList	=	null;
	}

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

	function updateAction (upd_no) {
		location.href	=	"food_update_act.jsp?mode=acc"+"&upd_no="+upd_no;
	}

    function updatePopup(rft_type, upd_no, upd_flag, sts_flag){
    	var url = "?upd_no="+upd_no+"&upd_flag="+upd_flag+"&sts_flag="+sts_flag+"&rft_type="+rft_type
    	newWin("food_update_popup.jsp"+url, 'PRINTVIEW', '1000', '740');
    }

	$(function () {
		$("#rftData").click(function (){
			$("#searchForm").attr("action", "./food_update_list.jsp");
       		$("#searchForm").submit();
			return;
		});
	});

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
				<input type="checkbox" id="rftData" name="rftData" <%if("on".equals(rftData)){out.println("checked");}else{out.println("");}%> >
				<label for="rftData">반영처리 보이기</label>
			</fieldset>
		</form>
	</div>

	<p class="clearfix"> </p>

	<p class="f_l magT10">
		<strong>총 <span><%=totalCount%></span> 건
		</strong> [ Page <%=pageNo %>/<%=paging.getFinalPageNo() %>]
	</p>

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
				<th scope="col">소속</th>
				<th scope="col">연락처</th>
				<th scope="col">요청구분</th>
				<th scope="col">사유</th>
				<th scope="col">요청일</th>
				<th scope="col">요청처리일</th>
				<th scope="col">상태</th>
				<th scope="col">비고</th>
			</tr>
		</thead>
		<tbody>
		<%if (updateList != null && updateList.size() > 0) {
			for(FoodVO vo : updateList) {%>
			<tr>
				<td rowspan="2"><%=vo.cat_nm %>-<%=vo.food_cat_index %></td>
            <td>기존</td>
            <td><%=parseNull(vo.food_code, "-") %></td>
            <td><%=parseNull(vo.nm_food, "-") %></td>
            <td><span class="wid_ndetail"><%=parseNull(vo.dt_nm, "-") %></span></td>
            <td><span class="wid_expl"><%=parseNull(vo.ex_nm, "-") %></span></td>
            <td><%=parseNull(vo.unit_nm, "-") %></td>
            <td rowspan="2"><%=vo.nu_nm %></td>
            <td rowspan="2"><%=vo.zone_nm %></td>
            <td rowspan="2"><span class="wid_school"><%=vo.sch_nm %></span></td>
            <td rowspan="2"><span class="wid_tel"><%=vo.sch_tel %></span></td>
            <td rowspan="2"><%=outUpdFlag(vo.upd_flag) %></td>
            <td rowspan="2"><%=vo.upd_reason %></td>
            <td rowspan="2"><%=vo.reg_date %></td>
            <td rowspan="2"><%if(vo.sts_date != null && vo.sts_date.length() > 0) {out.println(vo.sts_date);} else {out.println("-");}%></td>
            <td rowspan="2"><%=outUpdStsFlag(vo.sts_flag) %></td>
				<td rowspan="2">
					<%if("N".equals(vo.sts_flag)){%>
					<button class="btn small edge green" type="button" onclick="updateAction('<%=vo.upd_no %>')">접수처리</button>
					<%}else if("Y".equals(vo.sts_flag)) {%>
					<button class="btn small edge green" type="button" onclick="updatePopup('A','<%=vo.upd_no %>', '<%=vo.upd_flag %>','<%=vo.sts_flag %>')">반영처리</button>
					<button class="btn small edge mako" type="button" onclick="updatePopup('R','<%=vo.upd_no %>', '<%=vo.upd_flag %>','<%=vo.sts_flag %>')">미반영처리</button>
					<%}else if("R".equals(vo.sts_flag)) {%>
					<span>미반영</span>
					<%}else if("A".equals(vo.sts_flag)) {%>
					<span>반영</span>
					<%}%>
				</td>
			</tr>
			<tr class="up_change">
				<td>변경</td>
				<td><%=parseNull(vo.n_item_code, "-") %></td>
				<td><%=parseNull(vo.n_item_nm, "-")  %></td>
				<td><span class="wid_ndetail"><%=parseNull(vo.n_item_dt_nm, "-")  %></span></td>
				<td><span class="wid_expl"><%=parseNull(vo.n_item_expl, "-") %></span></td>
				<td><%=parseNull(vo.n_item_unit, "-")  %></td>
			</tr>
			<%}/*END FOR*/%>
		<%} else {%>
		<tr>
			<td colspan="17">데이터가 없습니다.</td>
		</tr>
		<%}%>
		</tbody>
	</table>
</div>

<% if(paging.getTotalCount() > 0) { %>
	<div class="page_area">
		<%=paging.getHtml() %>
	</div>
<% } %>

</body>
</html>
