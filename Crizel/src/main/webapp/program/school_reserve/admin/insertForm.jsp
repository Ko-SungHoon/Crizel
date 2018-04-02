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

String school_id 			= parseNull(request.getParameter("school_id"));
String school_name 			= parseNull(request.getParameter("school_name"));
String school_area 			= parseNull(request.getParameter("school_area"));
String school_addr 			= parseNull(request.getParameter("school_addr"));
String school_tel  			= parseNull(request.getParameter("school_tel"));
String school_url 			= parseNull(request.getParameter("school_url"));
String charge_dept 			= parseNull(request.getParameter("charge_dept"));
String dept_tel 			= parseNull(request.getParameter("dept_tel"));
String charge_name 			= parseNull(request.getParameter("charge_name"));
String charge_name2 		= parseNull(request.getParameter("charge_name2"));
String charge_phone 		= parseNull(request.getParameter("charge_phone"));
String account 				= parseNull(request.getParameter("account"));
String area_type 			= parseNull(request.getParameter("area_type"));
String charge_id 			= parseNull(request.getParameter("charge_id"));
String school_approval 		= parseNull(request.getParameter("school_approval"));
String sch_approval_date 	= parseNull(request.getParameter("sch_approval_date"));
String command 				= parseNull(request.getParameter("command"));
String school_type 			= parseNull(request.getParameter("school_type"));
String sch_type				= parseNull(request.getParameter("sch_type"));

String search1 = parseNull(request.getParameter("search1"));
String keyword = parseNull(request.getParameter("keyword"));

int num = 0;
int key = 0;

Paging paging = new Paging();
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;

String areaArr[] = {"창원시","김해시","진주시","양산시", "거제시" ,"통영시","사천시","밀양시","함안군","거창군","창녕군","고성군"
		,"하동군","합천군","남해군","함양군","산청군","의령군"};

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	//학교정보(수정시)
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT SCHOOL_ID, SCHOOL_NAME, SCHOOL_AREA, SCHOOL_ADDR, SCHOOL_TEL, SCHOOL_URL, CHARGE_DEPT, DEPT_TEL, CHARGE_NAME, CHARGE_NAME2 ");
	sql.append(", CHARGE_PHONE, ACCOUNT, AREA_TYPE, CHARGE_ID, TO_CHAR(SCH_APPROVAL_DATE, 'yyyy-MM-dd') SCH_APPROVAL_DATE, SCHOOL_APPROVAL, SCHOOL_TYPE ");
	sql.append("FROM RESERVE_SCHOOL  ");
	sql.append("WHERE SCHOOL_ID = ?  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	rs = pstmt.executeQuery();
	while(rs.next()){
		school_name 		= rs.getString("SCHOOL_NAME");
		school_area 		= rs.getString("SCHOOL_AREA");
		school_addr 		= rs.getString("SCHOOL_ADDR");
		school_tel 			= rs.getString("SCHOOL_TEL");
		school_url 			= rs.getString("SCHOOL_URL");
		charge_dept 		= rs.getString("CHARGE_DEPT");
		dept_tel 			= rs.getString("DEPT_TEL");
		charge_name 		= rs.getString("CHARGE_NAME");
		charge_name2 		= rs.getString("CHARGE_NAME2");
		charge_phone 		= rs.getString("CHARGE_PHONE");
		account				= rs.getString("ACCOUNT");
		area_type 			= rs.getString("AREA_TYPE");
		charge_id 			= rs.getString("CHARGE_ID");
		school_approval 	= rs.getString("SCHOOL_APPROVAL");
		sch_approval_date 	= rs.getString("SCH_APPROVAL_DATE");
		school_type 		= rs.getString("SCHOOL_TYPE");
	}
	if(pstmt!=null) pstmt.close();
	if(rs!=null) rs.close();
	
	
	//아이디 이름이 없을 경우 찾는다
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT * FROM RFC_COMTNMANAGER WHERE EMPLYR_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, charge_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		charge_name2 = rs.getString("EMPLYR_NM");
	}
	if(pstmt!=null) pstmt.close();
	if(rs!=null) rs.close();


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
function postForm(command){
	if(command == "insert"){
		$("#command").val("insert");
	}else if(command == "update"){
		$("#command").val("update");
	}
	
	if($.trim($("#charge_name2").val()) == ""){
		alert("아이디 이름 조회를 해주십시오.");
		return false;
	}else if($.trim($("#school_name").val()) == ""){
		alert("학교명을 입력하여 주십시오");
		$("#school_name").focus();
		return false;
	}else if($.trim($("#school_addr").val()) == ""){
		alert("주소를 입력하여 주십시오");
		$("#school_addr").focus();
		return false;
	}else if($.trim($("#charge_name").val()) == ""){
		alert("담당자명을 입력하여 주십시오");
		$("#charge_name").focus();
		return false;
	}else if($.trim($("#charge_id").val()) == ""){
		alert("담당자 아이디를 입력하여 주십시오");
		$("#charge_id").focus();
		return false;
	}else if($.trim($("#charge_phone").val()) == ""){
		alert("담당자 전화번호를 입력하여 주십시오");
		$("#charge_phone").focus();
		return false;
	}else if($('input[name="area_type"]:checked').length == 0){
		alert("지역구분을 선택하여 주십시오");
		return false;
	}else if($('input[name="school_type"]:checked').length == 0){
		alert("공립/사립 구분을 선택하여 주십시오");
		return false;
	}else{
		$("#postForm").attr("action","/program/school_reserve/school_register.jsp");
		$("#postForm").submit();
	}
}

$(function(){
	$('input[name="area_type"]').bind('click',function() { $('input[name="area_type"]').not(this).prop("checked", false); });
	$('input[name="school_type"]').bind('click',function() { $('input[name="school_type"]').not(this).prop("checked", false); });
	
	$("#school_tel").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") ); $(this).val($(this).val().substring(0,7));});
	$("#dept_tel").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") ); $(this).val($(this).val().substring(0,7));});
	$("#charge_phone").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") ); });
	
});

function approval( school_id){
	var school_approval = $("#school_approval").val();

	if(confirm("승인상태를 변경하시겠습니까?")){
		var str = {
				"school_id" : school_id,
				"school_approval" : school_approval
			}
			$.ajax({
				url : '/program/school_reserve/admin/approvalAction.jsp',
				data : str,
				success : function(data) {
					var returnVal = data.trim();
					if(returnVal == "Y") {
						alert("승인상태가 변경되었습니다.");
					}else{
						alert("오류발생");
					}
				},
				error : function(e) {
					alert("에러발생");
				}
			});
	}else{
		return false;
	}
}

function nameSearch(){
	var str = {
		"charge_id" : $("#charge_id").val()
	}
	
	$.ajax({
		url : '/program/school_reserve/admin/nameSearch.jsp',
		data : str,
		success : function(data) {
			var returnVal = data.trim();
			if(returnVal == "N") {
				alert("아이디를 확인해주시기 바랍니다.");
			}else{
				$("#charge_name2").val(returnVal);
			}
			
		},
		error : function(e) {
			alert("에러발생");
		}
	});
}
</script>

<script>
/* $(function(){
	schoo_type_msg_fn($("input[name=school_type]:checked").val());
	$("input[name=school_type]").change(function(){
		schoo_type_msg_fn($("input[name=school_type]:checked").val());
	});
});

function schoo_type_msg_fn(school_type){
	var msg;
	if(school_type == 'PUBLIC'){
		msg = '※변경 시 해당 관리자에게 학교 정보가 이관됩니다.';
	}else if(school_type == 'PRIVATE'){
		msg = '※변경 시 해당 관리자에게 학교 정보가 이관됩니다.';
	}
	$("#school_type_msg").html(msg);
} */
</script>

<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>학교관리</strong></p>
  </div>
	<div id="content">
		<div class="listArea">
			<form action="" method="post" id="postForm">
			<input type="hidden" name="school_id" id="school_id" value="<%=school_id%>">
			<input type="hidden" name="command" id="command">
			<input type="hidden" name="admin_yn" id="admin_yn" value="Y">
				<fieldset>
					<legend>학교정보</legend>
					<h2>아이디 정보</h2>
					<table class="bbs_list2">
						<colgroup>
							<col class="wps_20" />
							<col class="wps_25"/>
							<col class="wps_20" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">아이디 이름</th>
								<td>
									<input type="text" name="charge_name2" id="charge_name2" readonly="readonly" value="<%=charge_name2%>">
								</td>
								<th scope="row">아이디</th>
								<td>
									<input type="text" name="charge_id" id="charge_id" value="<%=charge_id%>">
									<%
									if("insert".equals(command)){
									%>
										<a onclick="nameSearch()" class="btn edge small mako">아이디 이름 조회</a></td>
									<%
									}
									%>
								</td>
							</tr>
						</tbody>
					</table>

					<h2>학교정보 입력</h2>
					<table class="bbs_list2">
						<colgroup>
						<col class="wps_25"/>
						<col />
						</colgroup>
						<%if(!"".equals(school_id)){%>
						<tr>
							<th scope="row">사용승인</th>
							<td colspan="3">
								<select id="school_approval" name="school_approval" >
									<option value="W" <%if("W".equals(school_approval)){%> selected="selected" <%}%>>승인대기</option>
									<option value="Y" <%if("Y".equals(school_approval)){%> selected="selected" <%}%>>승인완료</option>
									<option value="N" <%if("N".equals(school_approval)){%> selected="selected" <%}%>>승인취소</option>
								</select>
								<button type="button" onclick="approval('<%=school_id%>')" class="btn small edge mako">변경</button>
							</td>
						</tr>
						<%}%>
						<tr>
							<th scope="row"><span class="red">*</span>학교명</th>
							<td><input type="text" name="school_name" id="school_name" value="<%=school_name%>"></td>
						</tr>
						<tr>
							<th scope="row"><span class="red">*</span> 주소</th>
							<td>
								<select name="school_area" id="school_area">
									<option value="">지역선택</option>
									<%
									for(int i=0; i<areaArr.length; i++){
									%>
									<option value="<%=areaArr[i] %>" <%if(areaArr[i].equals(school_area)){%> selected="selected" <%}%>><%=areaArr[i] %></option>
									<%
									}
									%>
								</select>
								<input type="text" name="school_addr" id="school_addr" value="<%=school_addr%>">&nbsp;
								<input type="checkbox" name="area_type" id="area_type" value="N" <%if("N".equals(area_type)){%>checked="checked"<%}%> >시지역&nbsp;
								<input type="checkbox" name="area_type" id="area_type" value="Y" <%if("Y".equals(area_type)){%>checked="checked"<%}%> >군,읍,면 지역
							</td>
						</tr>
						<tr>
							<th scope="row">전화번호</th>
							<td><input type="text" name="school_tel" id="school_tel" value="<%=parseNull(school_tel)%>"></td>
						</tr>
						<tr>
							<th scope="row"><span class="red">&#42;</span> 공립/사립</th>
							<td colspan="3"><label for="school_type" class="blind">공립/사립</label>
							<%
							if("insert".equals(command)){
								if("public".equals(sch_type)){
							%>
								<label><input type="checkbox" name="school_type" id="school_type" 
									value="PUBLIC" checked onclick="return false;" >공립</label>
							<%
								}else{
							%>
								<label><input type="checkbox" name="school_type" id="school_type2" 
									value="PRIVATE" checked onclick="return false;"  >사립</label>
							<%	
								}
							}else{
							%>
								<label><input type="checkbox" name="school_type" id="school_type" 
									value="PUBLIC" <%if("PUBLIC".equals(school_type)){%>checked="checked"<%}%> >공립</label>
								<label><input type="checkbox" name="school_type" id="school_type2" 
									value="PRIVATE" <%if("PRIVATE".equals(school_type)){%>checked="checked"<%}%> >사립</label>
								<span id="school_type_msg" class="sub">※변경 시 해당 관리자에게 학교 정보가 이관됩니다.</span>
							<%
							} 
							%>
							</td>
						</tr>
						<tr>
							<th scope="row">홈페이지</th>
							<td><input type="text" name="school_url" id="school_url" value="<%=parseNull(school_url)%>"></td>
						</tr>
						</table>

						<h2>학교시설담당자 정보</h2>
						<table class="bbs_list2">
							<caption>학교시설 담당자 정보 입력표입니다. </caption>
							<colgroup>
								<col class="wps_20"/>
								<col />
								<col class="wps_20"/>
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row"><span class="red">*</span> 담당부서</th>
									<td><input type="text" name="charge_dept" id="charge_dept" value="<%=charge_dept%>"></td>
									<th scope="row"><span class="red">*</span> 부서 전화번호</th>
									<td><input type="text" name="dept_tel" id="dept_tel" value="<%=dept_tel%>"></td>
								</tr>
								<tr>
									<th scope="row"><span class="red">*</span> 담당자명</th>
									<td><input type="text" name="charge_name" id="charge_name" value="<%=charge_name%>"></td>
									<th scope="row"><span class="red">*</span> 휴대폰번호</th>
									<td><input type="text" name="charge_phone" id="charge_phone" value="<%=charge_phone%>"></td>
								</tr>
								<tr>
									<th scope="row"><span class="red">*</span> 납부계좌</th>
									<td colspan="3"><input type="text" name="account" id="account" value="<%=account%>"><br />
										<!-- <label for="bankName">은행명</label> <input type="text" id="bankName" class="wps_15"/><br />
										<label for="bankNum">계좌번호</label> <input type="text" id="bankNum" class="wps_45"/><br />
										<label for="bankNum">예금주명</label> <input type="text" id="bankNum" class="wps_10"/> -->
									</td>
								</tr>
							</tbody>
						</table>
						<div class="txt_c">
							<%if("insert".equals(command)){ %>
							<button type="button" onclick="postForm('insert')" class="btn small edge darkMblue">등록하기</button>
							<%}else{ %>
							<button type="button" onclick="postForm('update')" class="btn small edge darkMblue">수정하기</button>
						<%} %>
						</div>
				</fieldset>
			</form>
		</div>
	</div>
	<!-- // content -->
</div>
</body>
</html>
