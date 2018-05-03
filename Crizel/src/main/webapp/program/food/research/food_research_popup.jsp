<%
/**
*   PURPOSE :   조사식품 추가 popup
*   CREATE  :   20180406_fri    JI
*   MODIFY  :   ....
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/UtilClass.jsp"%>
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

String pageTitle    =   "조사 식품 추가";

String sch_id       =   parseNull(request.getParameter("sch_id"), "");      //학교 아이디
String keyword		=   parseNull(request.getParameter("keyword"), "");   //식품명 검색어

List<FoodVO> foodList 	=	null;	//조사식품 리스트

if (keyword != null && keyword.length() > 0) {
    try {
        sql =   new StringBuffer();
        sql.append("SELECT                                                                                  ");
        sql.append("    B.ITEM_NO,                                                                          ");
        sql.append("    (SELECT CAT_NM FROM FOOD_ST_CAT                                                     ");
        sql.append("    WHERE CAT_NO = B.CAT_NO) AS CAT_NM,                                                 ");
        sql.append("    B.FOOD_CAT_INDEX,                                                                   ");
        sql.append("    B.FOOD_CODE,                                                                        ");
        sql.append("    (SELECT SUBSTR(XMLAGG(                                                              ");
        sql.append("        XMLELEMENT(COL ,',', NM_FOOD) ORDER BY NM_FOOD).EXTRACT('//text()'              ");
        sql.append("    ).GETSTRINGVAL(),2) NM_FOOD                                                         ");
        sql.append("    FROM FOOD_ST_NM                                                                     ");
        sql.append("    WHERE NM_NO IN (FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5)) AS NM_FOOD, ");
        sql.append("    ( SELECT SUBSTR( XMLAGG(                                                            ");
        sql.append("        XMLELEMENT(COL ,',', DT_NM) ORDER BY DT_NM).EXTRACT('//text()'                  ");
        sql.append("        ).GETSTRINGVAL(),2) DT_NM                                                       ");
        sql.append("    FROM FOOD_ST_DT_NM                                                                  ");
        sql.append("    WHERE DT_NO IN (FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5,              ");
        sql.append("    FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10)) AS DT_NM,                  ");
        sql.append("    ( SELECT SUBSTR( XMLAGG(                                                            ");
        sql.append("        XMLELEMENT(COL,',', EX_NM) ORDER BY EX_NM).EXTRACT('//text()'                   ");
        sql.append("        ).GETSTRINGVAL(),2) EX_NM                                                       ");
        sql.append("    FROM FOOD_ST_EXPL                                                                   ");
        sql.append("    WHERE EX_NO IN (FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5,              ");
        sql.append("    FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10, FOOD_EP_11,                 ");
        sql.append("    FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15, FOOD_EP_16, FOOD_EP_17,             ");
        sql.append("    FOOD_EP_18, FOOD_EP_19, FOOD_EP_20, FOOD_EP_21, FOOD_EP_22, FOOD_EP_23,             ");
        sql.append("    FOOD_EP_24, FOOD_EP_25)) AS EX_NM,                                                  ");
        sql.append("    A.ITEM_COMP_NO,                                                                     ");
        sql.append("    A.ITEM_COMP_VAL                                                                     ");
        
        sql.append("FROM FOOD_ITEM_PRE A LEFT JOIN FOOD_ST_ITEM B       ");
        sql.append("    ON A.ITEM_NO = B.ITEM_NO                        ");
        sql.append("WHERE A.ITEM_NM LIKE '%'||?||'%'                    ");
        sql.append("    AND B.CAT_NO =                                  ");
        sql.append("    (SELECT CAT_NO FROM FOOD_SCH_TB                 ");
        sql.append("    WHERE SCH_ID = ?)                               ");
        sql.append("ORDER BY B.ITEM_NO                                  ");
        
        try {
            foodList		=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{keyword, sch_id});
        }catch(Exception e) {
            foodList		=	null;
        }

    } catch(Exception e) {
        out.println(e.toString());
    }

}//END IF

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
    $(function(){
        $(".selItem").click(function () {
            var index       =   $(".selItem").index(this);
            var item_no     =   $(".item_no").eq(index).text().trim();
            var sch_id      =   $(".selItem").eq(index).data("value");
            var comp_val    =   $(".comp_val").eq(index).data("value");
            var nm_food     =   $(".nm_food").eq(index).text().trim();

            if (comp_val > 0) {
                if (confirm("비교그룹 식품은 같은 비교그룹과 같이 추가됩니다.\n같이 추가 하시겠습니까?")) {
                    addItem(sch_id, item_no);
                }
            } else {
                if (confirm(nm_food + " 을 추가하시겠습니까?")) {
                    addItem(sch_id, item_no);
                }
            }
        });
    });

    //add Item change location
    function addItem (sch_id, item_no) {
        var send_url    =   "food_research_item_act.jsp";
        var params      =   {mode: "add", sch_id: sch_id, item_no: item_no};
        post_to_url(send_url, params, "post");
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
    <div class="searchBox magB20">
        <form action="food_research_popup.jsp" id="searchForm" enctype="multipart/form-data" method="get">
            <input type="hidden" id="sch_id" name="sch_id" value="<%=sch_id%>">
            <input type="text" id="keyword" name="keyword" value="<%=keyword%>" placeholder="검색할 식품명을 입력하세요.">
            <button type="submit" class="btn small edge mako">검색하기</button>
        </form>
    </div>
	<div>
		<form id="researchForm">
            <fieldset>
            	<input type="hidden" name="mode" id="mode">
                <legend><%=pageTitle%> 테이블</legend>
                <table class="bbs_list2">
                    <colgroup>
                        <col style="width:8%">
                        <col style="width:8%">
                        <col style="width:8%">
                        <col style="width:10%">
                        <col style="width:10%">
                        <col>
                        <col style="width:10%">
                        <col style="width:5%">
                    </colgroup>
                    <thead>
                    	<tr>
                    		<th>식품번호</th>
                    		<th>품목</th>
                    		<th>식품코드</th>
                    		<th>식품명</th>
                    		<th>상세식품명</th>
                    		<th>식품설명</th>
                    		<th>비교조사</th>
                    		<th>선택</th>
                    	</tr>
                    </thead>
                    <tbody>
                    <%if(foodList != null && foodList.size() > 0) {
                        for (FoodVO vo : foodList){%>
                        <tr>
                            <td><span class="item_no"><%=vo.item_no%></span></td>
                            <td><%=vo.cat_nm%></td>
                            <td><%=vo.food_code%></td>
                            <td><span class="nm_food"><%=vo.nm_food%></span></td>
                            <td><%=vo.dt_nm%></td>
                            <td><%=vo.ex_nm%></td>
                            <td><span class="comp_val" data-value="<%=vo.item_comp_no %>">
                                <%if(vo.item_comp_no != null && vo.item_comp_no.length() > 0) {%>비교 <%=vo.item_comp_no%> / <%=vo.item_comp_val%><%}%>
                            </span></td>
                            <td><button type="button" class="btn small edge mako selItem" data-value="<%=sch_id %>">선택</button></td>
                        </tr>
                    <%  }//END FOR
                    } else {%>
                    	<tr>
                            <td colspan="8">검색결과가 없습니다.</td>
                    	</tr>
                    <%}%>
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

