<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 학교등록</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />


<script>
</script>
</head>
<body>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
List<Map<String, Object>> dataList = null;
int key = 0;

String area_type = "";
String reserve_type = "";
String price_1 = "";
String price_2 = "";
String price_3 = "";

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	//시설금액
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT AREA_TYPE, RESERVE_TYPE, PRICE_1, PRICE_2, PRICE_3 ");
	sql.append("FROM RESERVE_PRICE ORDER BY AREA_TYPE, RESERVE_TYPE");
	pstmt = conn.prepareStatement(sql.toString());
	rs = pstmt.executeQuery();
	dataList = getResultMapRows(rs);


} catch (Exception e) {
	%>
	<%=e.toString() %>
	<%
	e.printStackTrace();
	sqlMapClient.endTransaction();
	//alertBack(out, "처리중 오류가 발생하였습니다.");
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
}

%>
<script>
function postForm(reserve_type){
	$("#postForm").submit();
}
</script>
<script>
function postForm(){
	if($.trim($("#price_1_0").val()) == ""){
		alert("값을 입력하여 주시기 바랍니다.");
		$("#price_1_0").focus();
	}else if($.trim($("#price_2_1").val()) == ""){
		alert("값을 입력하여 주시기 바랍니다.");
		$("#price_2_1").focus();
	}else if($.trim($("#price_3_2").val()) == ""){
		alert("값을 입력하여 주시기 바랍니다.");
		$("#price_3_2").focus();
	}else if($.trim($("#price_1_3").val()) == ""){
		alert("값을 입력하여 주시기 바랍니다.");
		$("#price_1_3").focus();
	}else if($.trim($("#price_2_4").val()) == ""){
		alert("값을 입력하여 주시기 바랍니다.");
		$("#price_2_4").focus();
	}else if($.trim($("#price_3_5").val()) == ""){
		alert("값을 입력하여 주시기 바랍니다.");
		$("#price_3_5").focus();
	}else if($.trim($("#price_1_6").val()) == ""){
		alert("값을 입력하여 주시기 바랍니다.");
		$("#price_1_6").focus();
	}else if($.trim($("#price_2_7").val()) == ""){
		alert("값을 입력하여 주시기 바랍니다.");
		$("#price_2_7").focus();
	}else if($.trim($("#price_3_8").val()) == ""){
		alert("값을 입력하여 주시기 바랍니다.");
		$("#price_3_8").focus();
	}else if($.trim($("#price_1_9").val()) == ""){
		alert("값을 입력하여 주시기 바랍니다.");
		$("#price_1_9").focus();
	}else if($.trim($("#price_2_10").val()) == ""){
		alert("값을 입력하여 주시기 바랍니다.");
		$("#price_2_10").focus();
	}else if($.trim($("#price_3_11").val()) == ""){
		alert("값을 입력하여 주시기 바랍니다.");
		$("#price_3_11").focus();
	}else if($.trim($("#price_1_12").val()) == ""){
		alert("값을 입력하여 주시기 바랍니다.");
		$("#price_1_12").focus();
	}else if($.trim($("#price_2_13").val()) == ""){
		alert("값을 입력하여 주시기 바랍니다.");
		$("#price_2_13").focus();
	}else if($.trim($("#price_3_14").val()) == ""){
		alert("값을 입력하여 주시기 바랍니다.");
		$("#price_3_14").focus();
	}else if($.trim($("#price_1_15").val()) == ""){
		alert("값을 입력하여 주시기 바랍니다.");
		$("#price_1_15").focus();
	}else if($.trim($("#price_2_16").val()) == ""){
		alert("값을 입력하여 주시기 바랍니다.");
		$("#price_2_16").focus();
	}else if($.trim($("#price_3_17").val()) == ""){
		alert("값을 입력하여 주시기 바랍니다.");
		$("#price_3_17").focus();
	}else{
		$("#postForm").attr("action", "priceAction.jsp");
		$("#postForm").submit();
	}

}
$(function(){
	$(":text").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") );} );
})

</script>

<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>시설금액관리</strong></p>
  </div>
	<div id="content">
		<div class="listArea">
			<form action="" method="post" id="postForm">
				<fieldset>
					<legend>시설금액정보</legend>
					<table class="bbs_list">
						<colgroup>
						<col width="20%"/>
						<col width="20%"/>
						<col width="20%"/>
						<col width="20%"/>
						<col width="20%"/>
						</colgroup>
						<thead>
							<tr>
								<th scope="col">지역별</th>
								<th scope="col">시설별</th>
								<th scope="col">2시간 이하</th>
								<th scope="col">4시간 이하</th>
								<th scope="col">4시간 초과</th>
							</tr>
						</thead>
						<tbody>
						<%
						int rowCnt = 0;
						String rowVal = "";
						String type = "";
						int cnt = 0;
						for(Map<String,Object> ob : dataList){
							if("Y".equals(ob.get("AREA_TYPE").toString())){
								rowVal = "군읍면 지역";
							}else{
								rowVal = "시 지역";
							}

							if("운동장".equals(ob.get("RESERVE_TYPE").toString()))

						%>
							<tr>
							<%if(rowCnt==0 || rowCnt==3){ %>
								<td rowspan="3"><%=rowVal %></td>
							<%} %>
								<td><%=ob.get("RESERVE_TYPE").toString() %></td>
								<td><input type="text" name="price_1_<%=cnt%>" id="price_1_<%=cnt++%>" value="<%=ob.get("PRICE_1").toString() %>"></td>
								<td><input type="text" name="price_2_<%=cnt%>" id="price_2_<%=cnt++%>" value="<%=ob.get("PRICE_2").toString() %>"></td>
								<td><input type="text" name="price_3_<%=cnt%>" id="price_3_<%=cnt++%>" value="<%=ob.get("PRICE_3").toString() %>"></td>
							</tr>
						<%
						rowCnt++;
						}
						%>
						</tbody>
					</table>
					<div class="txt_c">
						<button type="button" onclick="postForm()" class="btn small edge mako">수정하기</button>
					</div>
				</fieldset>
			</form>
		</div>
	</div>
	<!-- // content -->
</div>
</body>
</html>
