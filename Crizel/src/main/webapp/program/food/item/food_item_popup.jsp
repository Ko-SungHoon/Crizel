<%
/**
*   PURPOSE :   식품 팝업
*   CREATE  :   20180327_tue    Ko
*   CREATE  :   최저가 비율, 평균가 비율, 최고/최저 비교 비율 20180327_tue    JI
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

String pageTitle = "식품 등록/수정";

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

String item_no 		= parseNull(request.getParameter("item_no"));

StringBuffer sql 	= null;
FoodVO itemVO		= new FoodVO();

try{
	
	if(!"".equals(item_no)){
		sql = new StringBuffer();
	    sql.append("SELECT																							");
	    sql.append("	  PRE.ITEM_NO																				");
	    sql.append("	, PRE.LOW_RATIO																				");
	    sql.append("	, PRE.AVR_RATIO																				");
	    sql.append("	, PRE.LB_RATIO																				");
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
	    sql.append("	FROM FOOD_ITEM_PRE PRE LEFT JOIN FOOD_ST_ITEM ITEM ON PRE.S_ITEM_NO = ITEM.ITEM_NO			");
	    sql.append("	ORDER BY PRE.ITEM_NO																		");
	    itemVO = jdbcTemplate.query(sql.toString(), new FoodList()).get(0);
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
  </div>
</div>
<!-- S : #content -->
<div id="content">
	<form id="postForm">
		<fieldset>
			<input type="hidden" id="mode" name="mode">
			<legend><%=pageTitle%> 입력테이블</legend>
			<table class="bbs_list2">
				<colgroup>
					<col style="width:20%">
					<col	>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">식품번호</th>
						<td>
							<input type="text" id="item_no" name="item_no" value="<%=itemVO.item_no%>" readonly required>
						</td>
					</tr>
					<tr>
						<th scope="row">품목구분</th>
						<td>
							<input type="text" id="cat_nm" name="cat_nm" value="<%=itemVO.cat_nm%>" required>
						</td>
					</tr>
					<tr>
						<th scope="row">식품코드</th>
						<td>
							<input type="text" id="food_code" name="food_code" value="<%=itemVO.food_code%>" required>
						</td>
					</tr>
					<tr>
						<th scope="row">식품명</th>
						<td>
							<input type="text" id="nm_food" name="nm_food" value="<%=itemVO.nm_food%>" required>
						</td>
					</tr>
					<tr>
						<th scope="row">상세식품명</th>
						<td>
							<input type="text" id="dt_nm" name="dt_nm" value="<%=itemVO.dt_nm%>" required>
						</td>
					</tr>
					<tr>
						<th scope="row">식품설명</th>
						<td>
							<textarea class="wps_60 h080" id="ex_nm" name="ex_nm" readonly required><%=itemVO.ex_nm%></textarea>
						</td>
					</tr>
                    <tr>
						<th scope="row">최저가 비율</th>
						<td>
							<input type="number" class="wps_20" min-value="0" id="low_ratio" name="low_ratio" value="<%=itemVO.low_ratio %>" required>
                            <span>%</span>
						</td>
					</tr>
                    <tr>
						<th scope="row">평균가 비율</th>
						<td>
							<input type="number" class="wps_20" min-value="0" id="avr_ratio" name="avr_ratio" value="<%=itemVO.avr_ratio %>" required>
                            <span>%</span>
						</td>
					</tr>
                    <tr>
						<th scope="row">최저/최고 비율</th>
						<td>
							<input type="number" class="wps_20" min-value="0" id="lb_ratio" name="lb_ratio" value="<%=itemVO.lb_ratio %>" required>
                            <span>%</span>
						</td>
					</tr>
				</tbody>
			</table>
			<p class="btn_area txt_c">
				<button type="button" class="btn medium edge mako" onclick="window.close();">닫기</button>
				<button type="button" class="btn medium edge green">확인</button>
			</p>
		</fieldset>
	</form>
</div>
	<!-- //E : #content -->
</body>
</html>
