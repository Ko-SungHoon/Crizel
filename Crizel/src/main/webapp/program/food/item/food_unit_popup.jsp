<%
/**
*   PURPOSE :   유닛 팝업
*   CREATE  :   20180322_thu    Ko
*   MODIFY  :   출력 정렬 변경 20180323_fri   JI
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

String pageTitle = "단위 추가/수정";
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
List<FoodVO> unitList		= null;

try{
	sql = new StringBuffer();
	sql.append("SELECT *								");
	sql.append("FROM FOOD_ST_UNIT						");
	sql.append("WHERE SHOW_FLAG = 'Y'					");
	sql.append("ORDER BY UNIT_TYPE DESC, UNIT_NO		");      //정렬 변경
	unitList = jdbcTemplate.query(sql.toString(), new FoodList());
	
}catch(Exception e){
	out.println(e.toString());
}

%>
<script>
function unitDel(unit_no){
	if(confirm("단위를 삭제하시겠습니까?")){
		location.href="food_item_act.jsp?mode=unitDelete&unit_no="+unit_no;
	}else{
		return false;
	}
}

function updateSubmit(){
	if(confirm("단위를 수정하시겠습니까?")){
		$("#updateForm").attr("action", "food_item_act.jsp");
		$("#updateForm").attr("method", "post");
		$("#updateForm #mode").val("unitUpdate");
		return true;
	}else{
		return false;
	}
}

function unitInsert(){
	if(confirm("단위를 추가하시겠습니까?")){
		$("#insertForm").attr("action","food_item_act.jsp");
		$("#insertForm").attr("method","post");
		$("#insertForm #mode").val("unitInsert");
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
		<form id="insertForm" onsubmit="return unitInsert();">
			<fieldset>
				<input type="hidden" id="mode" name="mode">
				<legend><%=pageTitle%> 입력테이블</legend>
				<table class="bbs_list2">
					<colgroup>
						<col style="width:20%">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">단위타입</th>
							<td>
								<select id="unit_type" name="unit_type" required>
									<option>타입선택</option>
									<option value="P">화폐</option>
									<option value="F">품목</option>
								</select>
							</td>
							<th scope="row">단위명</th>
							<td>
								<input type="text" id="unit_nm" name="unit_nm" required>
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
						<col style="width:20%" />
						<col />
						<col style="width:20%" />
					</colgroup>
					<thead>
					<tr>
						<th scope="row">단위타입</th>
						<th scope="row">단위명</th>
						<th scope="row">단위삭제</th>
					</tr>
					</thead>
					<tbody>
					<%
					if(unitList!=null && unitList.size()>0){
						for(FoodVO ob : unitList){
					%>
						<tr>
							<td>
                                <%if("P".equals(ob.unit_type)){out.println("화폐");}
                                else{out.println("식품");}%>
							</td>
							<td>
								<input type="hidden" name="unit_no_arr" value="<%=ob.unit_no%>">
								<input type="text" name="unit_nm_arr" value="<%=ob.unit_nm%>" required
                                    <%if("P".equals(ob.unit_type)){out.print("readonly onclick='alert(\"화폐단위는 수정할 수 없습니다.\")'");} %>>
							</td>
							<td>
								<a class="btn edge small red" href="javascript:unitDel('<%=ob.unit_no%>')">삭제</a>
							</td>
						</tr>
					<%
						}
					}else{
					%>
						<tr>
							<td colspan="3">데이터가 없습니다.</td>
						</tr>
					<%} %>
					</tbody>
				</table>
				<p class="btn_area txt_c">
				<%
				if(unitList!=null && unitList.size()>0){
				%>
					<button type="submit" class="btn medium edge darkMblue">수정</button>
				<%				
				}
				%>
					<button type="button" class="btn medium edge mako" onclick="window.close();">닫기</button>
				</p>
			</fieldset>
		</form>
	</div>
</div>
	<!-- //E : #content -->
</body>
</html>
