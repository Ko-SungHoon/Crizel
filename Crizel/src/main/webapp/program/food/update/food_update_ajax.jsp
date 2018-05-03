<%
/**
*   PURPOSE :   업데이트요청 팝업 모달 html 코딩
*   CREATE	:   20180411_wed   JI
*   MODIFY	:   ...
*/
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%

response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

String nm_food		= parseNull(request.getParameter("nm_food"));   //검색할 식품명

//list
StringBuffer sql 		= null;
List<FoodVO> foodList 	= null;


try{

    sql = new StringBuffer();
	sql.append(" SELECT	* FROM (					                                                    ");
	sql.append(" SELECT								                                                    ");
	sql.append("    A.S_ITEM_NO, 					                                                    ");
	sql.append("    B.ITEM_NO, 					                                                        ");
	sql.append("    B.CAT_NO, 					                                                        ");
	sql.append("    (SELECT UNIT_NM				                                                        ");
	sql.append("    FROM FOOD_ST_UNIT			                                                        ");
	sql.append("    WHERE UNIT_NO = B.FOOD_UNIT) AS UNIT_NM,    		                                ");
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
    sql.append("    B.FOOD_CODE                                                                         ");

	sql.append(" FROM FOOD_ITEM_PRE A LEFT JOIN FOOD_ST_ITEM B	                                        ");
	sql.append(" ON A.ITEM_NO = B.ITEM_NO )                   	                                        ");
	sql.append(" WHERE NM_FOOD LIKE '%'||?||'%'             	                                        ");

    try {
        foodList    =   jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{nm_food});
    }catch(Exception e){
        foodList    =   null;
    }

}catch(Exception e){
	out.println(e.toString());
}

%>


<%if (foodList != null && foodList.size() > 0) {
    for (FoodVO vo : foodList) {
%>
<tr>
    <td><%=vo.nm_food %></td>
    <td><%=vo.dt_nm %></td>
    <td><%=vo.food_code %></td>
    <td>
        <button type="button" class="btn small mako selFood" 
            onclick="selFood('<%=vo.s_item_no %>', '<%=vo.cat_no %>', '<%=vo.item_no %>', '<%=vo.nm_food %>', '<%=vo.dt_nm %>', '<%=vo.ex_nm %>', '<%=vo.food_code %>', '<%=vo.unit_nm %>')">
            선택
        </button>
    </td>
</tr>

<%}//END FOR
}/*END IF*/ else {%>
<tr>
    <td colspan="4">검색된 식품이 없습니다.</td>
</tr>
<%}%>