
<%
/**
*   PURPOSE :   업데이트 완료처리 팝업
*   CREATE  :   20180323_fri    Ko
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager"%>
<%@ page import="org.springframework.util.StringUtils"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*"%>
<%@ include file="/program/food/food_util.jsp"%>
<%@ include file="/program/food/foodVO.jsp"%>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

String pageTitle = "업데이트 완료처리";

%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title><%=pageTitle%></title>
<script type='text/javascript'
	src='/js/egovframework/rfc3/iam/common.js'></script>
<script type='text/javascript' src='/js/jquery.js'></script>
<link href="/css/egovframework/rfc3/iam/admin_common.css"
	rel="stylesheet" type="text/css" />
<style type="text/css">
input[type="number"] {
	border: 1px solid #bfbfbf;
	vertical-align: middle;
	line-height: 18px;
	padding: 5px;
	box-sizing: border-box;
}
</style>
</head>
<body>
	<%
String upd_no			= parseNull(request.getParameter("upd_no"));
String upd_flag			= parseNull(request.getParameter("upd_flag")); // "A=추가,D=삭제,M=변경"
String sts_flag			= parseNull(request.getParameter("sts_flag")); // "N=대기,Y=완료,R=반려"

StringBuffer sql 		= null;
FoodVO foodVO	 		= new FoodVO();

try{
	
}catch(Exception e){
	out.println(e.toString());
}

%>
	<script>
		function updateSubmit() {
			if (confirm("상태를 수정하시겠습니까?")) {
				$("#updateForm").attr("action", "food_update_act.jsp");
				$("#updateForm").attr("method", "post");
				$("#mode").val("updateApply");
				return true;
			} else {
				return false;
			}
		}
	</script>
	<div id="right_view">
		<div class="top_view">
			<p class="location">
				<strong><%=pageTitle%></strong>
			</p>
		</div>
	</div>
	<!-- S : #content -->
	<div id="content">
		<div>
			<form id="updateForm" onsubmit="return updateSubmit();">
				<fieldset>
					<input type="hidden" id="mode" name="mode">
					<input type="hidden" id="upd_flag" name="upd_flag" value="<%=upd_flag%>">
					<input type="hidden" id="sts_flag" name="sts_flag" value="<%=sts_flag%>">
					<legend><%=pageTitle%></legend>
					<div class="txt_c">
						<h1><%=outUpdFlag(upd_flag)%></h1>
					</div>
					<h2 class="tit">변경 전 정보</h2>
					<table class="bbs_list2 td-c">
						<caption><%=pageTitle%>
							입력폼입니다.
						</caption>
						<colgroup>
							<col style="width: 20%">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row"><label for="s_item_no">식품번호</label></th>
								<td><input type="text" id="s_item_no" name="s_item_no"
									value="<%=foodVO.s_item_no%>" readonly required></td>
							</tr>
							<tr>
								<th scope="row"><label for="cat_nm">품목구분</label></th>
								<td><input type="text" id="cat_nm" name="cat_nm"
									value="<%=foodVO.cat_nm%>" readonly required></td>
							</tr>
							<tr>
								<th scope="row"><label for="food_code">식품코드</label></th>
								<td><input type="text" id="food_code" name="food_code"
									value="<%=foodVO.food_code%>" readonly required></td>
							</tr>
							<tr>
								<th scope="row"><label for="nm_food">식품명</label></th>
								<td><input type="text" id="nm_food" name="nm_food"
									value="<%=foodVO.nm_food%>" readonly required></td>
							</tr>
							<tr>
								<th scope="row"><label for="dt_nm">상세식품명</label></th>
								<td><input type="text" id="dt_nm" name="dt_nm"
									value="<%=foodVO.dt_nm%>" readonly required></td>
							</tr>
							<tr>
								<th scope="row"><label for="ex_nm">식품설명</label></th>
								<td><textarea class="wps_60 h080" id="ex_nm" name="ex_nm"
										readonly required><%=foodVO.ex_nm.replace("\r", "<br>")%></textarea>
								</td>
							</tr>
						</tbody>
					</table>
					<h2 class="tit">변경 요청 정보</h2>
					<table class="bbs_list2 td-c">
						<caption><%=pageTitle%>
							입력폼입니다.
						</caption>
						<colgroup>
							<col style="width: 20%">
							<col>
						</colgroup>
						<tbody>
							<%
								if ("M".equals(upd_flag) || "R".equals(sts_flag)) {
							%>
							<tr>
								<th scope="row"><label for="s_item_no">식품번호</label></th>
								<td><input type="text" id="s_item_no" name="s_item_no"
									value="<%=foodVO.s_item_no%>" readonly 
									<%if(!"R".equals(sts_flag)){out.println("required");}%> ></td>
							</tr>
							<tr>
								<th scope="row"><label for="cat_nm">품목구분</label></th>
								<td><input type="text" id="cat_nm" name="cat_nm"
									value="<%=foodVO.cat_nm%>" readonly 
									<%if(!"R".equals(sts_flag)){out.println("required");}%> ></td>
							</tr>
							<tr>
								<th scope="row"><label for="n_item_code">식품코드</label></th>
								<td><input type="text" id="n_item_code" name="n_item_code"
									value="<%=foodVO.n_item_code%>" 
									<%if(!"R".equals(sts_flag)){out.println("required");}%> ></td>
							</tr>
							<tr>
								<th scope="row"><label for="n_item_nm">식품명</label></th>
								<td><input type="text" id="n_item_nm" name="n_item_nm"
									value="<%=foodVO.n_item_nm%>" readonly 
									<%if(!"R".equals(sts_flag)){out.println("required");}%> ></td>
							</tr>
							<tr>
								<th scope="row"><label for="n_item_dt_nm">상세식품명</label></th>
								<td><input type="text" id="n_item_dt_nm"
									name="n_item_dt_nm" value="<%=foodVO.n_item_dt_nm%>" 
									<%if(!"R".equals(sts_flag)){out.println("required");}%> >
								</td>
							</tr>
							<tr>
								<th scope="row"><label for="n_item_expl">식품설명</label></th>
								<td>
									<textarea class="wps_60 h080" id="n_item_expl" name="n_item_expl" 
									<%if(!"R".equals(sts_flag)){out.println("required");}%> ><%=foodVO.n_item_expl.replace("\r", "<br>")%></textarea>
								</td>
							</tr>
							<%
								}
							%>

							<tr>
								<th scope="row"><label for="upd_reason">사유</label></th>
								<td><textarea class="wps_60 h080" id="upd_reason"
										name="upd_reason"><%=foodVO.upd_reason.replace("\r", "<br>")%></textarea>
								</td>
							</tr>
						</tbody>
					</table>
					<%
						if ("R".equals(sts_flag)) {
					%>
					<h2 class="tit">반려사유</h2>
					<table class="bbs_list2 td-c">
						<caption><%=pageTitle%>
							입력폼입니다.
						</caption>
						<colgroup>
							<col style="width: 20%">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row"><label for="rjc_reason">사유</label></th>
								<td><textarea class="wps_60 h080" id="rjc_reason"
										name="rjc_reason"><%=foodVO.rjc_reason.replace("\r", "<br>")%></textarea>
								</td>
							</tr>
						</tbody>
					</table>
					<%
						}
					%>

					<p class="btn_area txt_c">
						<button class="btn medium edge green">
						<%
						if("R".equals(sts_flag)){out.println("반려");}
						else{out.println("완료");}
						%>
						</button>
						<button type="button" class="btn medium edge mako" onclick="window.close();">닫기</button>
					</p>
				</fieldset>
			</form>
		</div>
	</div>
	<!-- //E : #content -->
</body>
</html>
