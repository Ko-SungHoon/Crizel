<%
/**
*   PURPOSE :   식품 변경 기록 팝업
*   CREATE  :   20180423_mon    JI
*   CREATE  :   ...
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ page import="org.springframework.jdbc.core.*" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

String pageTitle = "변경기록 보기";

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
    </head>
            
    <script>
        
    </script>
<body>
<%

String item_no 		=   parseNull(request.getParameter("item_no"));

StringBuffer sql 	=   null;
List<FoodVO> logVO	=   null;

try{

    sql =   new StringBuffer();
    sql.append(" SELECT                                                                                 ");
    sql.append("    ITEM.ITEM_NO                                                                        ");
    sql.append("    , ITEM.CAT_NO                                                                       ");
    sql.append("    , ITEM.FOOD_CODE                                                                    ");
    sql.append("    , ITEM.FOOD_CAT_INDEX                                                               ");
    sql.append("    , (SELECT CAT_NM FROM FOOD_ST_CAT WHERE CAT_NO = ITEM.CAT_NO) AS CAT_NM             ");
    sql.append("    , ( SELECT SUBSTR( XMLAGG(                                                          ");
    sql.append("        XMLELEMENT(COL ,',', NM_FOOD) ORDER BY NM_FOOD).EXTRACT('//text()'              ");
    sql.append("    ).GETSTRINGVAL(),2) NM_FOOD                                                         ");
    sql.append("    FROM FOOD_ST_NM                                                                     ");
    sql.append("    WHERE NM_NO IN (FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5)) AS NM_FOOD  ");
    sql.append("    , ( SELECT SUBSTR( XMLAGG(                                                          ");
    sql.append("        XMLELEMENT(COL,',',DT_NM) ORDER BY DT_NM).EXTRACT('//text()'                    ");
    sql.append("    ).GETSTRINGVAL(),2) DT_NM                                                           ");
    sql.append("    FROM FOOD_ST_DT_NM                                                                  ");
    sql.append("    WHERE DT_NO IN (FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5               ");
    sql.append("        , FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10)) AS DT_NM             ");
    sql.append("    , ( SELECT SUBSTR( XMLAGG(                                                          ");
    sql.append("        XMLELEMENT(COL ,',', EX_NM) ORDER BY EX_NM).EXTRACT('//text()'                  ");
    sql.append("    ).GETSTRINGVAL(),2) EX_NM                                                           ");
    sql.append("    FROM FOOD_ST_EXPL                                                                   ");
    sql.append("    WHERE EX_NO IN (FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5               ");
    sql.append("        , FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10                        ");
    sql.append("        , FOOD_EP_11, FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15                    ");
    sql.append("        , FOOD_EP_16, FOOD_EP_17, FOOD_EP_18, FOOD_EP_19, FOOD_EP_20                    ");
    sql.append("        , FOOD_EP_21, FOOD_EP_22, FOOD_EP_23, FOOD_EP_24, FOOD_EP_25)) AS EX_NM         ");
    sql.append("    , (SELECT UNIT_NM FROM FOOD_ST_UNIT WHERE UNIT_NO = ITEM.FOOD_UNIT) AS UNIT_NM      ");
    sql.append("    , TO_CHAR(ITEM.REG_DATE, 'YYYY-MM-DD') AS REG_DATE                                  ");

    sql.append(" FROM FOOD_ST_ITEM_LOG ITEM                                                             ");
    sql.append(" WHERE ITEM_NO = ?                                                                      ");
    try {
        logVO   =   jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{item_no});
    }catch(Exception e){
        logVO   =   null;
    }

}catch(Exception e){
	out.println(e.toString());
}

%>
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong><%=pageTitle%></strong></p>
  </div>
</div>
<!-- S : #content -->
<div id="content">

    <p class="clearfix"> </p>
	<table class="bbs_list">
		<caption><%=pageTitle%> 테이블</caption>
		<colgroup>
			<col style="width: 6.7%">
			<col style="width: 6.7%">
			<col style="width: 6.7%">
			<col style="width: 6.7%">
			<col style="width: 6.7%">
			<col style="width: 6.7%">
			<col>
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
				<th scope="col">식품설명</th>
				<th scope="col">단위</th>
				<th scope="col">등록일</th>
			</tr>
		</thead>
		<tbody>
            <%if (logVO != null && logVO.size() > 0) {
                for(FoodVO vo: logVO) {%>
                    <tr>
                        <td><%=vo.item_no %></td>
                        <td><%=vo.cat_nm %></td>
                        <td><%=vo.cat_nm %>-<%=vo.food_cat_index%></td>
                        <td><%=vo.food_code %></td>
                        <td><%=vo.nm_food %></td>
                        <td><%=vo.dt_nm %></td>
                        <td><%=vo.ex_nm %></td>
                        <td><%=vo.unit_nm %></td>
                        <td><%=vo.reg_date %></td>
                    </tr>
                <%}
            }/*END IF*/else {%>
            <tr>
                <td colspan="9">변경기록 정보가 없습니다.</td>
            </tr>
            <%}
            %>
        </tbody>
    </table>

</div>
	<!-- //E : #content -->
</body>
</html>