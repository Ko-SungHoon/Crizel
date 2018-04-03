<%
/**
*   PURPOSE :   조수정 팝업
*   CREATE  :   20180403_tue    Ko
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

String pageTitle = "조 추가/수정";
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

String zone_no				= parseNull(request.getParameter("zone_no"));
StringBuffer sql 			= null;
List<FoodVO> list 			= null;
List<FoodVO> zoneList		= null;

try{
	sql = new StringBuffer();
	sql.append("SELECT *								");
	sql.append("FROM FOOD_ZONE							");
	sql.append("WHERE SHOW_FLAG = 'Y' 					");
	sql.append("ORDER BY ZONE_NM						");
	zoneList = jdbcTemplate.query(sql.toString(), new FoodList());
	
	if(!"".equals(zone_no)){
		sql = new StringBuffer();
		sql.append("SELECT *								");
		sql.append("FROM FOOD_TEAM							");
		sql.append("WHERE SHOW_FLAG = 'Y' AND ZONE_NO = ?	");
		sql.append("ORDER BY ORDER1							");
		list = jdbcTemplate.query(sql.toString(), new FoodList(), zone_no);
	}
	
}catch(Exception e){
	out.println(e.toString());
}

%>
<script>
function teamDel(team_no, zone_no){
	if(confirm("팀 삭제시 해당 팀의 조사자는 소속이 사라집니다.\n팀을 삭제하시겠습니까?")){
		location.href="food_zone_act.jsp?mode=teamDelete&team_no="+team_no+"&zone_no="+zone_no;
	}else{
		return false;
	}
}

function updateSubmit(){
	if(confirm("팀을 수정하시겠습니까?")){
		$("#updateForm").attr("action", "food_zone_act.jsp");
		$("#updateForm").attr("method", "post");
		$("#updateForm #mode").val("teamUpdate");
		return true;
	}else{
		return false;
	}
}

function teamInsert(){
	if(confirm("팀을 추가하시겠습니까?")){
		$("#insertForm").attr("action","food_zone_act.jsp");
		$("#insertForm").attr("method","post");
		$("#insertForm #mode").val("teamInsert");
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
		<form id="insertForm" onsubmit="return teamInsert();">
			<fieldset>
				<input type="hidden" id="mode" name="mode">
				<input type="hidden" id="zone_no" name="zone_no" value="<%=zone_no%>">
				<legend><%=pageTitle%> 입력테이블</legend>
				<table class="bbs_list2">
					<colgroup>
						<col style="width:20%">
						<col style="width:20%">
						<col style="width:20%">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">권역</th>
							<td>
								<select id="zone_no" name="zone_no" required onchange="zoneChange(this.value)">
									<option value="">권역선택</option>
								<%
								if(zoneList!=null && zoneList.size()>0){
									for(FoodVO ob : zoneList){
								%>
									<option value="<%=ob.zone_no%>" 
									<%if(zone_no.equals(ob.zone_no)){out.println("selected");}%>><%=ob.zone_nm %></option>
								<%
									}
								}
								%>
								</select>
							</td>
							<th scope="row">팀입력</th>
							<td>
								<input type="text" id="team_nm" name="team_nm" value="" required>
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
				<input type="hidden" id="zone_no" name="zone_no" value="<%=zone_no%>">
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
						<th scope="row">순서</th>
						<th scope="row">팀명 수정</th>
						<th scope="row">팀삭제</th>
					</tr>
					</thead>
					<tbody>
					<%
					if(list!=null && list.size()>0){
					for(FoodVO ob : list){
					%>
					<tr>
						<td>
							<input type="text" name="order1_arr" class="wps_90" value="<%=ob.order1%>" required>
						</td>
						<td>
							<input type="hidden" name="team_no_arr" value="<%=ob.team_no%>">
							<input type="text" name="team_nm_arr" class="wps_90" value="<%=ob.team_nm%>" required>
						</td>
						<td>
							<a class="btn edge small red" href="javascript:teamDel('<%=ob.team_no%>', '<%=zone_no%>')">삭제</a>
						</td>
					</tr>
					<%
					}
					}else{
					%>
					<tr>
						<td colspan="3">등록된 팀이 없습니다.</td>
					</tr>
					<%	
					}
					%>

					</tbody>
				</table>
				<p class="btn_area txt_c">
				<%
				if(list!=null && list.size()>0){
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
