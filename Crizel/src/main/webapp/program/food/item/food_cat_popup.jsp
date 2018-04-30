<%
/**
*   PURPOSE :   구분 팝업
*   CREATE  :   20180322_thu    Ko
*   MODIFY  :   구분 출력 쿼리 수정 20180323_fri   JI
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

String pageTitle = "구분 추가/수정";

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
<body>
<%
StringBuffer sql 			= null;
List<FoodVO> catList		= null;
List<FoodVO> unitList		= null;

try{
	sql = new StringBuffer();
	sql.append("SELECT FOOD_ST_CAT.*                    ");
	sql.append("FROM FOOD_ST_CAT						");
	sql.append("ORDER BY CAT_NO, CAT_NM					");
	catList = jdbcTemplate.query(sql.toString(), new FoodList());
	
	sql = new StringBuffer();
	sql.append("SELECT *								");
	sql.append("FROM FOOD_ST_UNIT						");
	sql.append("WHERE SHOW_FLAG = 'Y' AND UNIT_TYPE = 'P'  ");
	sql.append("ORDER BY UNIT_NM						");
	unitList = jdbcTemplate.query(sql.toString(), new FoodList());
	
}catch(Exception e){
	out.println(e.toString());
}

%>
<script>
function catDel (flag, cat_no){
    //노출 처리
    if (flag == "Y") {
        if(confirm("구분을 노출 하시겠습니까?")){
            location.href="./food_item_act.jsp?mode=catDelete&show_flag=" + flag + "&cat_no=" + cat_no;
        }else{
            return false;
        }
    //숨김 처리
    } else {
        if(confirm("구분을 숨기시겠습니까?\n소속된 식품이 있을 경우에는 숨김처리가 되지 않습니다.")){
            location.href="./food_item_act.jsp?mode=catDelete&show_flag=" + flag + "&cat_no=" + cat_no;
        }else{
            return false;
        }
    }
}

function updateSubmit(){
	/*if(confirm("구분을 수정하시겠습니까?\n비교 측정 기준을 변경했을 경우 식품 표시에 변경이 생길 수 있습니다.")){
		$("#updateForm").attr("action", "food_zone_act.jsp");
		$("#updateForm").attr("method", "post");
		$("#updateForm #mode").val("teamUpdate");
		return true;
	}else{
		return false;
	}*/
    return false;
}

function catInsert(){
	if(confirm("구분을 추가하시겠습니까?")){
		$("#insertForm").attr("action","food_item_act.jsp");
		$("#insertForm").attr("method","post");
		$("#insertForm #mode").val("catInsert");
		return true;
	}else{
		return false;
	}
}

function zoneChange(zone_no){
	location.href="food_team_popup.jsp?zone_no="+zone_no;
}

$(function(){
	$('#order1').keyup(function(){this.value = this.value.replace(/[^0-9]/g,'');});
    
    //적용 btn
    $(".chgCat").click(function () {
        var index           =   $(".chgCat").index(this);
        var cat_cat_no      =   $(".cat_cat_no").eq(index).text();
        var cat_cat_nm      =   $(".cat_cat_nm").eq(index).val();
        var cat_unit_val    =   $(".cat_unit_val").eq(index).val();
        var cat_unit_no     =   $(".cat_unit_no").eq(index).val();
        location.href       =   "./food_item_act.jsp?mode=catUpdate&cat_no="+cat_cat_no+"&cat_nm="+cat_cat_nm+"&unit_val="+cat_unit_val+"&unit_no="+cat_unit_no;
        return;
    });
});

</script>
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong><%=pageTitle%></strong></p>
  </div>
</div>
<!-- S : #content -->
<div id="content">
	<div>
		<form id="insertForm" onsubmit="return catInsert();">
			<fieldset>
				<input type="hidden" id="mode" name="mode">
				<legend><%=pageTitle%> 입력테이블</legend>
				<table class="bbs_list2">
					<colgroup>
						<col style="width:20%">
						<col style="width:30%">
						<col style="width:20%">
						<col style="width:30%">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">비교 측정 기준</th>
							<td>
								<input type="text" id="unit_val" name="unit_val" required>
								<select id="unit_no" name="unit_no" required>	
									<option value="">단위선택</option>
								<%
								if(unitList!=null && unitList.size()>0){
									for(FoodVO ob : unitList){
								%>
									<option value="<%=ob.unit_no%>"><%=ob.unit_nm%></option>
								<%
									}
								}
								%>
								</select>
							</td>
							<th scope="row">구분명</th>
							<td>
								<input type="text" id="cat_nm" name="cat_nm" value="" required>
								<button class="btn small edge mako">추가</button>
							</td>
						</tr>
					</tbody>
				</table>
			</fieldset>
		</form>
		
		<form id="updateForm" onsubmit="return updateSubmit();">
			<fieldset>
				<input type="hidden" id="mode" name="mode">
				<legend><%=pageTitle%></legend>
				<table class="bbs_list2 td-c">
					<caption><%=pageTitle%> 입력폼</caption>
					<colgroup>
						<col style="width:10%" />
						<col />
						<col style="width:20%" />
					</colgroup>
					<thead>
					<tr>
						<th scope="row">번호</th>
						<th scope="row">구분명</th>
						<%--<th scope="row">비교 측정 기준</th>--%>
						<th scope="row">노출</th>
						<th scope="row">비고</th>
					</tr>
					</thead>
					<tbody>
						<%for(FoodVO cat : catList){%>
                        <tr>
							<td><span class="cat_cat_no"><%=cat.cat_no %></span></td>
                            <td><input type="text" class="cat_cat_nm" name="cat_cat_nm" value="<%=cat.cat_nm %>"></td>
                            <%--<td>
                                <input class="cat_unit_val wps_50" type="number" value="<%=cat.unit_val %>" min="1" required>
                                <select class="cat_unit_no" name="cat_unit_no">
                                    <%for(FoodVO unit : unitList){%>
                                        <option value="<%=unit.unit_no %>" <%if (cat.unit_no.equals(unit.unit_no)) {out.println("selected");}%>><%=unit.unit_nm %></option>
                                    <%}%>
                                </select>
                            </td>--%>
                            <td>
                                <%if ("Y".equals(cat.show_flag)) {%><button class="btn small edge mako" onclick="catDel('N','<%=cat.cat_no %>')">숨김</button><%}
                                else {%><button class="btn small edge mako" onclick="catDel('Y', '<%=cat.cat_no %>')">노출</button><%}%>
                            </td>
                            <td><button class="btn small edge darkMblue">적용</button></td>
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
	<!-- //E : #content -->
</body>
</html>
