
<%
/**
*   PURPOSE :   업데이트 완료처리 팝업
*   CREATE  :   20180323_fri    Ko
*   MODIFY  : 20180423 LJH / table class 수정
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

String pageTitle = "업데이트 반영처리";

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

String rft_type			=	parseNull(request.getParameter("rft_type"));	// A=반영 처리, R=미반영 처리
if ("R".equals(rft_type)) {pageTitle = "업데이트 미반영처리";}
String upd_no			=	parseNull(request.getParameter("upd_no"));	// 업데이트 번호
String upd_flag			=	parseNull(request.getParameter("upd_flag"));	// "A=추가,D=삭제,M=변경"
String sts_flag			=	parseNull(request.getParameter("sts_flag"));	// "N=접수,Y=접수완료,R=미반영,A=반영"

StringBuffer sql 		=	null;
FoodVO foodVO	 		=	new FoodVO();

/*비교 그룹군 여부 확인*/
int item_comp_no	=	0;	//비교그룹 번호

try{

	sql	=	new StringBuffer();
	sql.append(" SELECT																		");
	sql.append(" A.S_ITEM_NO,																");
	sql.append(" A.UPD_NO,																	");
	sql.append(" A.SCH_NO,																	");
	sql.append(" A.NU_NO,																	");
	sql.append(" (SELECT NU_NM FROM FOOD_SCH_NU                                     		");
	sql.append(" WHERE NU_NO = A.NU_NO) AS NU_NM, 		                                	");
	sql.append(" A.N_ITEM_CODE,																");
	sql.append(" A.N_ITEM_NM,																");
	sql.append(" A.N_ITEM_DT_NM,															");
	sql.append(" A.N_ITEM_EXPL,																");
	sql.append(" A.N_ITEM_UNIT,																");
	sql.append(" C.FOOD_UNIT,																");
	sql.append(" (SELECT UNIT_NM FROM FOOD_ST_UNIT                                 			");
	sql.append(" WHERE UNIT_NO = C.FOOD_UNIT) AS UNIT_NM,	                            	");
	sql.append(" A.UPD_FLAG,																");
	sql.append(" A.UPD_REASON,																");
	sql.append(" A.STS_FLAG,																");
	sql.append(" A.RJC_REASON,																");
	sql.append(" A.REG_DATE,																");
	sql.append(" A.RJC_DATE,																");
	sql.append(" A.MOD_DATE,																");
	sql.append(" A.STS_DATE,																");
	sql.append(" A.SHOW_FLAG,																");
	sql.append(" C.ITEM_NO,                                                              	");
	sql.append(" C.FOOD_CODE,                                                            	");
	sql.append(" C.FOOD_CAT_INDEX,                                                       	");
	sql.append(" C.CAT_NO,																	");
	sql.append(" (SELECT CAT_NM FROM FOOD_ST_CAT                                         	");
	sql.append(" WHERE CAT_NO = A.N_CAT_NO) AS CAT_NM,                                   	");
	sql.append(" D.ZONE_NO,                               							    	");
	sql.append(" (SELECT ZONE_NM FROM FOOD_ZONE                                     		");
	sql.append(" WHERE ZONE_NO = D.ZONE_NO) AS ZONE_NM,                                  	");
	sql.append(" D.TEAM_NO,                               							    	");
	sql.append(" (SELECT TEAM_NM FROM FOOD_TEAM                                     		");
	sql.append(" WHERE TEAM_NO = D.TEAM_NO) AS TEAM_NM,                                  	");
	sql.append(" D.SCH_NM,                               							    	");
	sql.append(" D.SCH_TEL,                               							    	");

	sql.append(" (SELECT SUBSTR(XMLAGG(														");
	sql.append(" 	XMLELEMENT(COL ,',', NM_FOOD) ORDER BY NM_FOOD).EXTRACT('//text()'		");
	sql.append(" ).GETSTRINGVAL(),2) NM_FOOD												");
	sql.append(" FROM FOOD_ST_NM															");
	sql.append(" WHERE NM_NO IN (FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5))	");
	sql.append(" AS NM_FOOD,																");
	sql.append(" (SELECT SUBSTR( XMLAGG(													");
	sql.append(" XMLELEMENT(COL ,',', DT_NM) ORDER BY DT_NM).EXTRACT('//text()'				");
	sql.append(" ).GETSTRINGVAL(),2) DT_NM													");
	sql.append(" FROM FOOD_ST_DT_NM															");
	sql.append(" WHERE DT_NO IN (FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5,		");
	sql.append(" FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10)) AS DT_NM,			");
	sql.append(" (SELECT SUBSTR( XMLAGG(													");
	sql.append(" 	XMLELEMENT(COL,',', EX_NM) ORDER BY EX_NM).EXTRACT('//text()'			");
	sql.append(" 	).GETSTRINGVAL(),2) EX_NM												");
	sql.append(" FROM FOOD_ST_EXPL															");
	sql.append(" WHERE EX_NO IN (FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5,		");
	sql.append(" FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10, FOOD_EP_11,		");
	sql.append(" FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15, FOOD_EP_16, FOOD_EP_17,	");
	sql.append(" FOOD_EP_18, FOOD_EP_19, FOOD_EP_20, FOOD_EP_21, FOOD_EP_22, FOOD_EP_23,	");
	sql.append(" FOOD_EP_24, FOOD_EP_25)) AS EX_NM											");

	sql.append(" FROM (SELECT * FROM FOOD_UPDATE WHERE SHOW_FLAG = 'Y') A LEFT JOIN 		");
	sql.append(" (SELECT * FROM FOOD_ITEM_PRE WHERE SHOW_FLAG = 'Y') B						");
	sql.append(" ON A.S_ITEM_NO = B.S_ITEM_NO LEFT JOIN FOOD_ST_ITEM C						");
	sql.append(" ON B.ITEM_NO = C.ITEM_NO LEFT JOIN FOOD_SCH_TB D							");
	sql.append(" ON A.SCH_NO = D.SCH_NO														");
	sql.append(" WHERE 1=1																	");
	sql.append(" 	AND UPD_NO = ?															");

	try {
		foodVO	=	jdbcTemplate.query(sql.toString(),  new FoodList(), new Object[]{upd_no}).get(0);
	}catch(Exception e){
		foodVO	=	null;
	}

	if ("D".equals(upd_flag)) {
		sql	=	new StringBuffer();
		sql.append(" SELECT 									");
		sql.append(" B.ITEM_COMP_NO 							");
		sql.append(" FROM FOOD_UPDATE A JOIN FOOD_ITEM_PRE B	");
		sql.append(" ON A.S_ITEM_NO = B.S_ITEM_NO				");
		sql.append(" WHERE A.UPD_NO = ?							");
		item_comp_no	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class, new Object[]{upd_no});
	}

}catch(Exception e){
	out.println(e.toString());
}

%>
	<script>
		function updateSubmit() {
			<%if ("R".equals(rft_type)) {%>
			if (confirm("상태를 미반영처리 하시겠습니까?")) {
				if(nullChk($("#rjc_reason").val())) {
					alert("사유를 입력하세요.");
					$("#rjc_reason").focus();
					return false;
				}
			<%} else {%>
			if (confirm("상태를 반영처리 하시겠습니까?")) {
			<%}
				if (item_comp_no > 0) {%>
				if (!confirm("삭제처리 할 식품은 비교그룹군이 있습니다.\n비교그룹군 식품이 모두 삭제처리 됩니다.\n진행하시겠습니까?")) {
					return false;
				}
			<%	}
			%>
				$("#updateForm").attr("action", "food_update_act.jsp");
				$("#updateForm").attr("method", "post");
				return true;
			} else {
				return false;
			}
		}

		function nullChk (value) {
			if (value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length)) {
				return true;
			}else{
				return false;
			}
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
			<%if("M".equals(upd_flag) || "A".equals(upd_flag)){%>
			<span class="red">&#8251; 복수의 내용 입력시 "," 로 구분하세요. (예: 생육, 양념)</span>
			<%}%>
			<form id="updateForm" onsubmit="return updateSubmit();">
				<fieldset>
					<input type="hidden" id="mode" name="mode" value="<%=rft_type %>">
					<input type="hidden" id="upd_no" name="upd_no" value="<%=upd_no %>">
					<input type="hidden" id="upd_flag" name="upd_flag" value="<%=upd_flag %>">
					<input type="hidden" id="sts_flag" name="sts_flag" value="<%=sts_flag %>">
					<legend><%=pageTitle%></legend>
					<div class="txt_c">
						<h1><%=outUpdPopFlag(upd_flag)%></h1>
					</div>
					<%/*변경*/
					if("M".equals(upd_flag)){%>
					<h2 class="tit">변경 전 정보</h2>
					<table class="bbs_list2">
						<caption><%=pageTitle%>
							입력폼입니다.
						</caption>
						<colgroup>
							<col style="width: 20%">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row"><label for="item_no">식품번호</label></th>
								<td><input type="text" id="item_no" name="item_no"
									value="<%=foodVO.item_no%>" readonly required></td>
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
					<table class="bbs_list2">
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
									value="<%=foodVO.s_item_no%>" readonly></td>
							</tr>
							<tr>
								<th scope="row"><label for="cat_nm">품목구분</label></th>
								<td><input type="text" id="cat_nm" name="cat_nm"
									value="<%=foodVO.cat_nm%>" readonly></td>
							</tr>
							<tr>
								<th scope="row"><label for="n_item_nm">식품명</label></th>
								<td><input type="text" id="n_item_nm" name="n_item_nm"
									value="<%=foodVO.n_item_nm%>"></td>
							</tr>
							<tr>
								<th scope="row"><label for="n_item_code">식품코드</label></th>
								<td><input type="text" id="n_item_code" name="n_item_code"
									value="<%=foodVO.n_item_code%>"></td>
							</tr>
							<tr>
								<th scope="row"><label for="n_item_dt_nm">상세식품명</label></th>
								<td><input type="text" id="n_item_dt_nm"
									name="n_item_dt_nm" value="<%=foodVO.n_item_dt_nm%>">
								</td>
							</tr>
							<tr>
								<th scope="row"><label for="n_item_expl">식품설명</label></th>
								<td>
									<textarea class="wps_60 h080" id="n_item_expl" name="n_item_expl">
										<%=foodVO.n_item_expl.replace("\r", "<br>")%>
									</textarea>
								</td>
							</tr>
							<tr>
								<th scope="row"><label for="n_item_unit">단위</label></th>
								<td><input type="text" id="n_item_unit"
									name="n_item_unit" value="<%=foodVO.n_item_unit%>">
								</td>
							</tr>
							<tr>
								<th scope="row"><label for="upd_reason">사유</label></th>
								<td><textarea class="wps_60 h080" id="upd_reason"
										name="upd_reason"><%=foodVO.upd_reason.replace("\r", "<br>")%></textarea>
								</td>
							</tr>
						</tbody>
					</table>
					<%}
					/*추가*/
					else if ("A".equals(upd_flag)) {
					%>
					<h2 class="tit">추가 요청 식품 정보</h2>
					<table class="bbs_list2">
						<caption><%=pageTitle%>
							입력폼입니다.
						</caption>
						<colgroup>
							<col style="width: 20%">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row"><label for="item_no">식품번호</label></th>
								<td><input type="text" id="item_no" name="item_no"
									value="자동으로 추가 됩니다." readonly required></td>
							</tr>
							<tr>
								<th scope="row"><label for="cat_nm">품목구분</label></th>
								<td><input type="text" id="cat_nm" name="cat_nm"
									value="<%=foodVO.cat_nm%>" readonly required></td>
							</tr>
							<tr>
								<th scope="row"><label for="n_item_nm">식품명</label></th>
								<td><input type="text" id="n_item_nm" name="n_item_nm"
									value="<%=foodVO.n_item_nm%>" required></td>
							</tr>
							<tr>
								<th scope="row"><label for="n_item_code">식품코드</label></th>
								<td><input type="text" id="n_item_code" name="n_item_code"
									value="<%=foodVO.n_item_code%>" required></td>
							</tr>
							<tr>
								<th scope="row"><label for="n_item_dt_nm">상세식품명</label></th>
								<td><input type="text" id="n_item_dt_nm"
									name="n_item_dt_nm" value="<%=foodVO.n_item_dt_nm%>" required>
								</td>
							</tr>
							<tr>
								<th scope="row"><label for="n_item_expl">식품설명</label></th>
								<td>
									<textarea class="wps_60 h080" id="n_item_expl"
										name="n_item_expl" required><%=foodVO.n_item_expl.replace("\r", "<br>")%></textarea>
								</td>
							</tr>
							<tr>
								<th scope="row"><label for="n_item_unit">단위</label></th>
								<td><input type="text" id="n_item_unit"
									name="n_item_unit" value="<%=foodVO.n_item_unit%>" required>
								</td>
							</tr>
							<tr>
								<th scope="row"><label for="upd_reason">사유</label></th>
								<td><textarea class="wps_60 h080" id="upd_reason"
									name="upd_reason" required><%=foodVO.upd_reason.replace("\r", "<br>")%></textarea>
								</td>
							</tr>
						</tbody>
					</table>
					<%}
					/*삭제*/
					else if ("D".equals(upd_flag)) {
					%>
					<h2 class="tit">삭제 요청 식품 정보</h2>
					<table class="bbs_list2">
						<caption><%=pageTitle%>
							입력폼입니다.
						</caption>
						<colgroup>
							<col style="width: 20%">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row"><label for="item_no">식품번호</label></th>
								<td><input type="text" id="item_no" name="item_no"
									value="<%=foodVO.item_no%>" readonly required></td>
							</tr>
							<tr>
								<th scope="row"><label for="cat_nm">품목구분</label></th>
								<td><input type="text" id="cat_nm" name="cat_nm"
									value="<%=foodVO.cat_nm%>" readonly required></td>
							</tr>
							<tr>
								<th scope="row"><label for="nm_food">식품명</label></th>
								<td><input type="text" id="nm_food" name="nm_food"
									value="<%=foodVO.nm_food%>" readonly required></td>
							</tr>
							<tr>
								<th scope="row"><label for="food_code">식품코드</label></th>
								<td><input type="text" id="food_code" name="food_code"
									value="<%=foodVO.food_code%>" readonly required></td>
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
							<tr>
								<th scope="row"><label for="upd_reason">사유</label></th>
								<td><textarea class="wps_60 h080" id="upd_reason"
									name="upd_reason" required><%=foodVO.upd_reason.replace("\r", "<br>")%></textarea>
								</td>
							</tr>
						</tbody>
					</table>
					<%}/*END IF(요청 타입별)*/%>
					<%
						if ("R".equals(rft_type)) {
					%>
					<h2 class="tit">반려사유</h2>
					<table class="bbs_list2">
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
