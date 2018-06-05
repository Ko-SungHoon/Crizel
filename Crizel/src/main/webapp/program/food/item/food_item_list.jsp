<%
/**
*   PURPOSE :   품목관리
*   CREATE  :   20180322_thur   Ko
*   MODIFY  :   20180420_fri    JI  품목별 리스트 호출
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

String pageTitle = "품목관리";
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
String keyword  =   parseNull(request.getParameter("keyword"));
String search1  =   parseNull(request.getParameter("search1"));

String cat_no   =   parseNull(request.getParameter("cat_no"));

StringBuffer sql 			=	null;
List<FoodVO> catList		=	null;
List<FoodVO> itemList		=	null;
int itemListCnt				=	0;

Paging paging = new Paging();
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
Object[] setObj		= null;
List<String> setList	= new ArrayList<String>();

int pre_item_cnt    =   0;
int total_item_cnt  =   0;

//조사개시 중인 조사번호
int rsch_no	=	0;

try{
	//조사개시 중인 조사번호 가져오기
	sql	=	new StringBuffer();
	sql.append(" SELECT RSCH_NO			");
	sql.append(" FROM FOOD_RSCH_TB		");
	sql.append(" WHERE SHOW_FLAG = 'Y'	");
	sql.append(" 	AND STS_FLAG = 'N'	");
	try{
		rsch_no	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class);
	}catch(Exception e){
		rsch_no	=	0;
	}

	if("".equals(cat_no)){
		sql = new StringBuffer();
		sql.append("SELECT MIN(CAT_NO) AS CAT_NO	");
		sql.append("FROM FOOD_ST_CAT				");
		sql.append("WHERE SHOW_FLAG = 'Y'			");
		sql.append("ORDER BY CAT_NO, CAT_NM			");
		try{
			cat_no = jdbcTemplate.queryForObject(sql.toString(), String.class);
		}catch(Exception e){
			cat_no = "";
		}
	}
	
    sql =   new StringBuffer();
	sql.append("SELECT FOOD_ST_CAT.*                    ");
	sql.append("FROM FOOD_ST_CAT						");
	sql.append("WHERE SHOW_FLAG = 'Y'					");
	sql.append("ORDER BY CAT_NO, CAT_NM					");
	catList = jdbcTemplate.query(sql.toString(), new FoodList());

    //공개 식품 cnt & total cnt
    sql =   new StringBuffer();
    sql.append(" SELECT                         ");
    sql.append("    NVL(COUNT(S_ITEM_NO), 0)    ");
    sql.append(" FROM FOOD_ITEM_PRE             ");
    sql.append(" WHERE SHOW_FLAG = 'Y'          ");
    pre_item_cnt    =   jdbcTemplate.queryForObject(sql.toString(), Integer.class);

    sql =   new StringBuffer();
    sql.append(" SELECT                         ");
    sql.append("    NVL(COUNT(ITEM_NO), 0)      ");
    sql.append(" FROM FOOD_ST_ITEM              ");
    sql.append(" WHERE SHOW_FLAG = 'Y'          ");
    total_item_cnt  =   jdbcTemplate.queryForObject(sql.toString(), Integer.class);

    sql = new StringBuffer();
    sql.append(" SELECT COUNT(*)																				");
    sql.append(" FROM(																							");
    sql.append(" SELECT																							");
    sql.append("	  PRE.ITEM_NO																				");
    sql.append("	, ITEM.CAT_NO   																			");
    sql.append("	, ITEM.FOOD_CODE																			");
    sql.append("	, ITEM.FOOD_CAT_INDEX																		");
    sql.append("	, (SELECT CAT_NM FROM FOOD_ST_CAT WHERE CAT_NO = ITEM.CAT_NO) AS CAT_NM						");
    sql.append("	, ( SELECT SUBSTR( XMLAGG(  																");
    sql.append("							XMLELEMENT(COL ,',', NM_FOOD) ORDER BY NM_FOOD).EXTRACT('//text()' 	");
    sql.append("	).GETSTRINGVAL(),2) NM_FOOD 																");
    sql.append("	FROM FOOD_ST_NM 																			");
    sql.append("	WHERE NM_NO IN (FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5)) AS NM_FOOD      	");
    sql.append("	, ( SELECT SUBSTR( XMLAGG(  																");
    sql.append("	    					XMLELEMENT(COL,',',DT_NM) ORDER BY DT_NM).EXTRACT('//text()' 		");
    sql.append("	).GETSTRINGVAL(),2) DT_NM 																	");
    sql.append("	FROM FOOD_ST_DT_NM 																			");
    sql.append("	WHERE DT_NO IN (FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5						");
    sql.append("	, FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10)) AS DT_NM							");
    sql.append("	, ( SELECT SUBSTR( XMLAGG(  																");
    sql.append("	    					XMLELEMENT(COL ,',', EX_NM) ORDER BY EX_NM).EXTRACT('//text()' 		");
    sql.append("	).GETSTRINGVAL(),2) EX_NM 																	");
    sql.append("	FROM FOOD_ST_EXPL																			");
    sql.append("	WHERE EX_NO IN (FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5						");
    sql.append("	, FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10									");
    sql.append("	, FOOD_EP_11, FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15								");
    sql.append("	, FOOD_EP_16, FOOD_EP_17, FOOD_EP_18, FOOD_EP_19, FOOD_EP_20								");
    sql.append("	, FOOD_EP_21, FOOD_EP_22, FOOD_EP_23, FOOD_EP_24, FOOD_EP_25)) AS EX_NM						");
    sql.append("	, (SELECT UNIT_NM FROM FOOD_ST_UNIT WHERE UNIT_NO = ITEM.FOOD_UNIT) AS UNIT_NM				");
    sql.append("	, TO_CHAR(PRE.REG_DATE, 'YYYY-MM-DD') AS REG_DATE											");
    sql.append("	, TO_CHAR(PRE.MOD_DATE, 'YYYY-MM-DD') AS MOD_DATE											");
    sql.append("	, PRE.SHOW_FLAG																				");
    sql.append("	, (SELECT REG_IP FROM FOOD_UP_FILE WHERE FILE_NO = PRE.FILE_NO) REG_IP						");
    sql.append("	, (SELECT REG_ID FROM FOOD_UP_FILE WHERE FILE_NO = PRE.FILE_NO) REG_ID						");

    sql.append("	FROM FOOD_ITEM_PRE PRE LEFT JOIN FOOD_ST_ITEM ITEM ON PRE.ITEM_NO = ITEM.ITEM_NO			");
    sql.append(")A WHERE A.SHOW_FLAG = 'Y'																	");
    sql.append("    AND A.CAT_NO = ?                                                                            ");
    paging.setParams("cat_no", cat_no);
    setList.add(cat_no);
    if(!"".equals(search1)){
    	if("nm_food".equals(search1)){
    		sql.append("AND A.NM_FOOD LIKE '%'||?||'%'															");
    	}else if("dt_nm".equals(search1)){
    		sql.append("AND A.DT_NM LIKE '%'||?||'%'															");
    	}else if("ex_nm".equals(search1)){
    		sql.append("AND A.EX_NM LIKE '%'||?||'%'															");
    	}

    	paging.setParams("search1", search1);
    	paging.setParams("keyword", keyword);
    	
    	setList.add(keyword);
    }
    setObj = new Object[setList.size()];
    for(int i=0; i<setList.size(); i++){
    	setObj[i] = setList.get(i);
    }
    
    totalCount = jdbcTemplate.queryForObject(sql.toString(), Integer.class, setObj);
    
    paging.setPageNo(Integer.parseInt(pageNo));
	paging.setTotalCount(totalCount);
	paging.setPageSize(10);
	paging.makePaging();
    
    sql = new StringBuffer();
	sql.append("SELECT * FROM(																                    ");
	sql.append("	SELECT ROWNUM AS RNUM, A.* FROM (										                    ");
    sql.append("    SELECT																						");
    sql.append("	  PRE.ITEM_NO																				");
    sql.append("	, PRE.S_ITEM_NO																				");
    sql.append("	, ITEM.CAT_NO																				");
    sql.append("	, ITEM.FOOD_CODE																			");
    sql.append("	, ITEM.FOOD_CAT_INDEX																		");
    sql.append("	, (SELECT CAT_NM FROM FOOD_ST_CAT WHERE CAT_NO = ITEM.CAT_NO) AS CAT_NM						");
    sql.append("	, ( SELECT SUBSTR( XMLAGG(  																");
    sql.append("							XMLELEMENT(COL ,',', NM_FOOD) ORDER BY NM_FOOD).EXTRACT('//text()' 	");
    sql.append("	).GETSTRINGVAL(),2) NM_FOOD 																");
    sql.append("	FROM FOOD_ST_NM 																			");
    sql.append("	WHERE NM_NO IN (FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5)) AS NM_FOOD      	");
    sql.append("	, ( SELECT SUBSTR( XMLAGG(  																");
    sql.append("	    					XMLELEMENT(COL,',',DT_NM) ORDER BY DT_NM).EXTRACT('//text()' 		");
    sql.append("	).GETSTRINGVAL(),2) DT_NM 																	");
    sql.append("	FROM FOOD_ST_DT_NM 																			");
    sql.append("	WHERE DT_NO IN (FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5						");
    sql.append("	, FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10)) AS DT_NM							");
    sql.append("	, ( SELECT SUBSTR( XMLAGG(  																");
    sql.append("	    					XMLELEMENT(COL ,',', EX_NM) ORDER BY EX_NM).EXTRACT('//text()' 		");
    sql.append("	).GETSTRINGVAL(),2) EX_NM 																	");
    sql.append("	FROM FOOD_ST_EXPL																			");
    sql.append("	WHERE EX_NO IN (FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5						");
    sql.append("	, FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10									");
    sql.append("	, FOOD_EP_11, FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15								");
    sql.append("	, FOOD_EP_16, FOOD_EP_17, FOOD_EP_18, FOOD_EP_19, FOOD_EP_20								");
    sql.append("	, FOOD_EP_21, FOOD_EP_22, FOOD_EP_23, FOOD_EP_24, FOOD_EP_25)) AS EX_NM						");
    sql.append("	, (SELECT UNIT_NM FROM FOOD_ST_UNIT WHERE UNIT_NO = ITEM.FOOD_UNIT) AS UNIT_NM				");
    sql.append("	, TO_CHAR(PRE.REG_DATE, 'YYYY-MM-DD') AS REG_DATE											");
    sql.append("	, TO_CHAR(PRE.MOD_DATE, 'YYYY-MM-DD') AS MOD_DATE											");
	sql.append(" 	, PRE.ITEM_COMP_NO																			");
	sql.append(" 	, PRE.ITEM_COMP_VAL																			");
    sql.append("	, PRE.SHOW_FLAG																				");
    sql.append("	, (SELECT REG_IP FROM FOOD_UP_FILE WHERE FILE_NO = PRE.FILE_NO) REG_IP						");
    sql.append("	, (SELECT REG_ID FROM FOOD_UP_FILE WHERE FILE_NO = PRE.FILE_NO) REG_ID						");
    sql.append("	, (SELECT NVL(COUNT(ITEM_NO), 0) FROM FOOD_ST_ITEM_LOG WHERE ITEM_NO = ITEM.ITEM_NO) LOG_CNT");

    sql.append("	FROM FOOD_ITEM_PRE PRE LEFT JOIN FOOD_ST_ITEM ITEM ON PRE.ITEM_NO = ITEM.ITEM_NO			");
    sql.append("	ORDER BY PRE.ITEM_NO																		");
    sql.append("	) A WHERE ROWNUM <= " + paging.getEndRowNo() + "											");
    sql.append("      AND A.SHOW_FLAG = 'Y' AND A.CAT_NO = ?                                                    ");
    if(!"".equals(search1)){
    	if("nm_food".equals(search1)){
    		sql.append("AND A.NM_FOOD LIKE '%'||?||'%'															");
    	}else if("dt_nm".equals(search1)){
    		sql.append("AND A.DT_NM LIKE '%'||?||'%'															");
    	}else if("ex_nm".equals(search1)){
    		sql.append("AND A.EX_NM LIKE '%'||?||'%'															");
    	}
    }
	sql.append(") WHERE RNUM > " + paging.getStartRowNo() + " 													");
    itemList = jdbcTemplate.query(sql.toString(), new FoodList(), setObj);
    
	//노출 되는 item cnt

	sql	=	new StringBuffer();
	sql.append("SELECT COUNT(*) FROM (																			");
	sql.append("	SELECT 																						");
	sql.append("		PRE.ITEM_NO																				");
	sql.append("		, ITEM.CAT_NO																			");
	sql.append("		, PRE.SHOW_FLAG																			");
	sql.append("	, ( SELECT SUBSTR( XMLAGG(  																");
    sql.append("							XMLELEMENT(COL ,',', NM_FOOD) ORDER BY NM_FOOD).EXTRACT('//text()' 	");
    sql.append("	).GETSTRINGVAL(),2) NM_FOOD 																");
    sql.append("	FROM FOOD_ST_NM 																			");
    sql.append("	WHERE NM_NO IN (FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5)) AS NM_FOOD      	");
    sql.append("	, ( SELECT SUBSTR( XMLAGG(  																");
    sql.append("	    					XMLELEMENT(COL,',',DT_NM) ORDER BY DT_NM).EXTRACT('//text()' 		");
    sql.append("	).GETSTRINGVAL(),2) DT_NM 																	");
    sql.append("	FROM FOOD_ST_DT_NM 																			");
    sql.append("	WHERE DT_NO IN (FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5						");
    sql.append("	, FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10)) AS DT_NM							");
    sql.append("	, ( SELECT SUBSTR( XMLAGG(  																");
    sql.append("	    					XMLELEMENT(COL ,',', EX_NM) ORDER BY EX_NM).EXTRACT('//text()' 		");
    sql.append("	).GETSTRINGVAL(),2) EX_NM 																	");
    sql.append("	FROM FOOD_ST_EXPL																			");
    sql.append("	WHERE EX_NO IN (FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5						");
    sql.append("	, FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10									");
    sql.append("	, FOOD_EP_11, FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15								");
    sql.append("	, FOOD_EP_16, FOOD_EP_17, FOOD_EP_18, FOOD_EP_19, FOOD_EP_20								");
    sql.append("	, FOOD_EP_21, FOOD_EP_22, FOOD_EP_23, FOOD_EP_24, FOOD_EP_25)) AS EX_NM						");
	sql.append("	FROM FOOD_ITEM_PRE PRE LEFT JOIN FOOD_ST_ITEM ITEM ON PRE.ITEM_NO = ITEM.ITEM_NO			");
	sql.append(") A																								");
	sql.append("WHERE A.SHOW_FLAG = 'Y' AND A.CAT_NO = ?														");
	if(!"".equals(search1)){
    	if("nm_food".equals(search1)){
    		sql.append("AND A.NM_FOOD LIKE '%'||?||'%'															");
    	}else if("dt_nm".equals(search1)){
    		sql.append("AND A.DT_NM LIKE '%'||?||'%'															");
    	}else if("ex_nm".equals(search1)){
    		sql.append("AND A.EX_NM LIKE '%'||?||'%'															");
    	}
    }
	itemListCnt	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class, setObj);

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

    function catPopup(){
        <%if(rsch_no > 0) {%>
			alert("조사개시 중에는 식품구분수정이 불가합니다.");
			return false;
		<%}else{%>
            newWin("food_cat_popup.jsp", 'PRINTVIEW', '1000', '740');
        <%}%>
    }
    function unitPopup(){
        <%if(rsch_no > 0) {%>
			alert("조사개시 중에는 단위수정이 불가합니다.");
			return false;
		<%}else{%>
            newWin("food_unit_popup.jsp", 'PRINTVIEW', '1000', '740');
        <%}%>
    }
    function itemPopup(){
        <%if(rsch_no > 0) {%>
			alert("조사개시 중에는 식품추가가 불가합니다.");
			return false;
		<%}else{%>
            newWin("food_item_popup.jsp", 'PRINTVIEW', '1000', '740');
        <%}%>
    }
    function updatePopup(item_no){
        <%if(rsch_no > 0) {%>
			alert("조사개시 중에는 식품수정이 불가합니다.");
			return false;
		<%}else{%>
            newWin("food_item_popup.jsp?item_no="+item_no, 'PRINTVIEW', '1000', '740');
        <%}%>
    }
    
    //excel up
    function upExcel() {
        <%if(rsch_no > 0) {%>
			alert("조사개시 중에는 식품 변경이 불가합니다.");
			return false;
		<%}else{%>
            if (confirm("식품 엑셀을 업로드 하시겠습니까?\n식품 데이터 변경으로 공개식품의 변경이 생길 수 있습니다.")) {
                $("#food_file").click();
            }
            return;
        <%}%>
    }
    
    //excel down
	function downExcel(){
    	$("#searchForm").attr("action", "food_down_excel.jsp");
    	$("#searchForm").submit();
    }

    function setFile () {
        //파일 검증
        var fileName    =   $("#food_file").val().split("\\")[$("#food_file").val().split("\\").length -1];
        var fileExtName =   $("#food_file").val().split(".")[$("#food_file").val().split(".").length -1];
        fileExtName     =   fileExtName.toLowerCase();
        if ($.inArray(fileExtName, ['xls'/* , 'xlsx' */]) == -1) {
            alert ("xls 형식의 엑셀 파일만 등록이 가능합니다.");
            $(this).val("");
            return;
        }
        
        $("#food_excel_form").attr("action", "./food_up_excel.jsp");
        $("#food_excel_form").submit();
    }
    
    function excelSample(){
    	location.href="/program/down.jsp?path=/upload_data/food/sample&filename=research_sample.xls";
    }

    function showLog (item_no) {
        var open_url    =   "/program/food/item/food_item_log_popup.jsp?item_no=" + item_no;
        var open_title  =   "변경기록 보기";
        newWin(open_url, open_title, 1100, 900);
    }
    
    function searchSubmit(){
    	$("#searchForm").attr("action", "");
    	$("#searchForm").attr("method", "get");
    	$("#searchForm").submit();
    }

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
	<div class="btn_area">
		<p class="boxin">
            <%for(FoodVO cat : catList) {%>
                <button type="button" class="btn medium <% if(cat_no.equals(cat.cat_no)) {%>mako<%;}else{%>white<%;} %>" data-value="<%=cat.cat_no %>" onclick="location.href='food_item_list.jsp?cat_no=<%=cat.cat_no %>'"><%=cat.cat_nm %></button>
            <%}%>
		</p>
		<span>공개 식품 <%=pre_item_cnt %>/<%=total_item_cnt %></span>
		<p class="boxin f_r">
            <form id="food_excel_form" enctype="multipart/form-data" method="post" class="txt_r">
                <input type="file" id="food_file" name="food_file" value="" onchange="setFile()" style="display: none;">
                <button type="button" class="btn small edge mako" onclick="excelSample();">엑셀 샘플</button>
                <button type="button" id="excel_up" class="btn small edge mako" onclick="upExcel()">엑셀업로드</button>
                <button type="button" id="excel_down" class="btn small edge mako" onclick="downExcel()">엑셀다운로드</button>
                <button type="button" class="btn small edge green" onclick="itemPopup()">식품추가</button>
                <button type="button" class="btn small edge green" onclick="unitPopup()">단위수정</button>
                <button type="button" class="btn small edge green" onclick="catPopup()">식품구분수정</button>
            </form>
		</p>
	</div>
	
	<div class="searchBox magB20">
		<form id="searchForm" method="get" class="topbox2">
			<fieldset>
				<input type="hidden" id="cat_no" name="cat_no" value="<%=cat_no%>">
				<select id="search1" name="search1">
					<option value="">검색분류 선택</option>
					<option value="nm_food" <%if("nm_food".equals(search1)){out.println("selected");}%>>식품명</option>
					<option value="dt_nm" <%if("dt_nm".equals(search1)){out.println("selected");}%>>상세식품명</option>
					<option value="ex_nm" <%if("ex_nm".equals(search1)){out.println("selected");}%>>식품설명</option>
				</select>
				<input type="text" id="keyword" name="keyword" value="<%=keyword%>">
				<button class="btn small edge mako" onclick="searchSubmit();">검색하기</button>
			</fieldset>
		</form>
	</div>
	<div class="f_r">
		<!-- <button type="button" class="btn small edge darkMblue" onclick="">추가</button> -->
	</div>
	<p class="clearfix"> </p>
	<p class="f_l magT10">
		<strong>총 <span><%=itemListCnt%></span> 식품
		</strong> [ Page <%=pageNo %>/<%=paging.getFinalPageNo() %>]
	</p>
	<table class="bbs_list">
		<caption><%=pageTitle%> 테이블</caption>
		<colgroup>
			<col style="width: 6.7%">
			<col style="width: 6.7%">
			<col style="width: 6.7%">
			<col style="width: 6.7%">
			<col style="width: 6.7%">
			<col style="width: 6.7%">
			<%--<col style="width: 6.7%">--%>
			<col>
			<col style="width: 5%">
			<col style="width: 5%">
			<col style="width: 6.7%">
			<col style="width: 6.7%">
			<%--<col style="width: 6.7%">--%>
			<%--<col style="width: 5%">--%>
			<col style="width: 6.7%">
			<col style="width: 6.7%">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">식품번호</th>
				<th scope="col">구분</th>
				<th scope="col">연번</th>
				<th scope="col">식품코드</th>
				<th scope="col">식품명</th>
				<th scope="col">상세식품명</th>
				<%--<th scope="col">규격</th>--%>
				<th scope="col">식품설명</th>
				<th scope="col">단위</th>
				<th scope="col">비교그룹</th>
				<th scope="col">등록일</th>
				<th scope="col">수정일</th>
				<%--<th scope="col">등록ID</th>--%>
				<%--<th scope="col">공개여부</th>--%>
				<th scope="col">수정</th>
				<th scope="col">변경기록</th>
			</tr>
		</thead>
		<tbody>	
		<%
		if(itemList!=null && itemList.size()>0){
			for(FoodVO ob : itemList){
		%>
			<tr>
				<td><%=ob.s_item_no %></td>
				<td><%=ob.cat_nm%></td>
				<td><%=ob.cat_nm%>-<%=ob.food_cat_index%></td>
				<td><%=ob.food_code%></td>
				<td><%=ob.nm_food %></td>
				<td><%=ob.dt_nm %></td>
				<%--<td></td>--%>
				<td><%=ob.ex_nm %></td>
				<td><%=ob.unit_nm %></td>
				<td><%=ob.item_comp_no%>-<%=ob.item_comp_val %></td>
				<td><%=ob.reg_date %></td>
				<td><%=ob.mod_date %></td>
				<%--<td><%=ob.reg_id %></td>--%>
				<%--<td><%=ob.show_flag %></td>--%>
				<td>
					<button class="btn small edge green" type="button" onclick="updatePopup('<%=ob.item_no %>')">수정</button>
				</td>
				<td>
                    <%if(Integer.parseInt(ob.log_cnt) > 0) {%>
                    <a href="javascript:showLog('<%=ob.item_no %>');" data-value="<%=ob.item_no %>">변경기록 보기</a>
                    <%} else {%>-<%}%>
                </td>
			</tr>
		<%
			}
		}else{
		%>
		<tr>
			<td colspan="15">데이터가 없습니다.</td>
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
</div>
<!-- // E : #content -->
</body>
</html>
