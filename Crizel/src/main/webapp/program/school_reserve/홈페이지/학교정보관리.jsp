<%
/**
*	PURPOSE	:	학교정보 관리
*	CREATE	:	2017....
*	MODIFY	:	....
*/
%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ include file="/program/class/PagingClass.jsp" %>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>

<!-- <input type="text" id="sample6_postcode" placeholder="우편번호">
<input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
<input type="text" id="sample6_address" placeholder="주소">
<input type="text" id="sample6_address2" placeholder="상세주소">

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
    function sample6_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = ''; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    fullAddr = data.roadAddress;

                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    fullAddr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
                if(data.userSelectedType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('sample6_postcode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('sample6_address').value = fullAddr;

                // 커서를 상세주소 필드로 이동한다.
                document.getElementById('sample6_address2').focus();
            }
        }).open();
    }
</script> -->

<%
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
List<Map<String, Object>> dataList = null;

boolean id_check = false;
boolean id_check2 = false;
boolean approval_check = false;
boolean exist_check = false;
boolean groupCheck = false;

String charge_id 		= parseNull(request.getParameter("charge_id"));
String school_id 		= parseNull(request.getParameter("school_id"));
String school_name 		= parseNull(request.getParameter("school_name"));
String school_area 		= parseNull(request.getParameter("school_area"));
String school_addr 		= parseNull(request.getParameter("school_addr"));
String school_tel 		= parseNull(request.getParameter("school_tel"));
String school_url 		= parseNull(request.getParameter("school_url"));
String charge_dept 		= parseNull(request.getParameter("charge_dept"));
String dept_tel 		= parseNull(request.getParameter("dept_tel"));
String charge_name 		= parseNull(request.getParameter("charge_name"));
String charge_name2 	= parseNull(request.getParameter("charge_name2"));
String charge_phone 	= parseNull(request.getParameter("charge_phone"));
String account 			= parseNull(request.getParameter("account"));
String area_type 		= parseNull(request.getParameter("area_type"));
String command 			= parseNull(request.getParameter("command"));
String school_type 		= parseNull(request.getParameter("school_type"));


int num = 0;
int key = 0;

String areaArr[] = {"창원시","김해시","진주시","양산시", "거제시" ,"통영시","사천시","밀양시","함안군","거창군","창녕군","고성군"
					,"하동군","합천군","남해군","함양군","산청군","의령군"};

if("GRP_000009".equals(sm.getGroupId()) || sm.isRole("ROLE_000002") || sm.isRoleAdmin() || "m_00523".equals(sm.getId()) || "rhzhzh3".equals(sm.getId()) || "gne_ksis00".equals(sm.getId()) ){
	groupCheck = true;
}

if(!"".equals(sm.getId())){
	charge_id = sm.getId();
	id_check2 = true;
}

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	//로그인 한 아이디가 학교정보에 입력되어 있는지 확인 및 학교정보 검색
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_SCHOOL WHERE CHARGE_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, charge_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		id_check 		= true;
		exist_check 	= true;
		school_id 		= rs.getString("SCHOOL_ID");
		school_name 	= rs.getString("SCHOOL_NAME");
		school_area 	= rs.getString("SCHOOL_AREA");
		school_addr 	= rs.getString("SCHOOL_ADDR");
		school_tel 		= rs.getString("SCHOOL_TEL");
		school_url 		= rs.getString("SCHOOL_URL");
		charge_dept 	= rs.getString("CHARGE_DEPT");
		dept_tel 		= rs.getString("DEPT_TEL");
		charge_name 	= rs.getString("CHARGE_NAME");
		charge_phone 	= rs.getString("CHARGE_PHONE");
		account 		= rs.getString("ACCOUNT");
		area_type 		= rs.getString("AREA_TYPE");
		school_type		= rs.getString("SCHOOL_TYPE");
	}
	
	if("".equals(command) && id_check){
		command = "view";
	}
	
	//rfc내 아이디의 이름찾기
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT * FROM RFC_COMTNMANAGER WHERE EMPLYR_ID = ?  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, charge_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		charge_name2 = rs.getString("EMPLYR_NM");
	}
	

	//승인이 됬는지 여부 확인
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_SCHOOL WHERE CHARGE_ID = ? AND SCHOOL_APPROVAL = 'Y' ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, charge_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		approval_check = true;
	}
	if(!exist_check && !approval_check){
		approval_check = true;
	}else if(approval_check){
		approval_check = true;
	}


} catch (Exception e) {
	e.printStackTrace();
	sqlMapClient.endTransaction();
	alertBack(out, "처리중 오류가 발생하였습니다.");
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
}
%>

<script>
function updatePage(){
	$("#postForm #command").val("update");
	$("#postForm").submit();
}

function postForm(command){
	if(command == "insert"){
		$("#command").val("insert");
	}else if(command == "update"){
		$("#command").val("update");
	}

	var checkCnt = 0;

	var a = $("#school_name").val();
	var a_l = a.length;
	var b = a.replace("학교","");
	var b_l = b.length;

	if(a_l != b_l){
		checkCnt++;
	}else{
		alert("학교명에 '학교' 단어를 포함하여 입력하여주시기 바랍니다.");
		return false;
	}
	
	var school_url_1 = $("#school_url").val().length;
	var school_url_2 = $("#school_url").val().replace("http", "").length;
	
	if(school_url_1 != school_url_2){
		alert("홈페이지 주소의 http:// 문자를 제거하여 주시기 바랍니다.");
		return false;
	}

	if(checkCnt > 0){
		if($.trim($("#school_name").val()) == ""){
			alert("학교명을 입력하여 주십시오");
			$("#school_name").focus();
			return false;
		}else if($.trim($("#school_tel").val()) == ""){
			alert("전화번호를 입력하여 주십시오");
			$("#school_tel").focus();
			return false;
		}else if($.trim($("#school_addr").val()) == ""){
			alert("주소를 입력하여 주십시오");
			$("#school_addr").focus();
			return false;
		}else if($.trim($("#charge_dept").val()) == ""){
			alert("담당부서를 입력하여 주십시오");
			$("#charge_dept").focus();
			return false;
		}else if($.trim($("#dept_tel").val()) == ""){
			alert("부서전화번호를 입력하여 주십시오");
			$("#dept_tel").focus();
			return false;
		}else if($.trim($("#charge_name").val()) == ""){
			alert("담당자명을 입력하여 주십시오");
			$("#charge_name").focus();
			return false;
		}else if($.trim($("#charge_phone").val()) == ""){
			alert("담당자 전화번호를 입력하여 주십시오");
			$("#charge_phone").focus();
			return false;
		}else if($.trim($("#account").val()) == ""){
			alert("입금계좌를 입력하여 주십시오");
			$("#account").focus();
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




}

$(function(){
	$('input[name="area_type"]').bind('click',function() { $('input[name="area_type"]').not(this).prop("checked", false); });
	$('input[name="school_type"]').bind('click',function() { $('input[name="school_type"]').not(this).prop("checked", false); });

	$("#school_tel").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") ); $(this).val($(this).val().substring(0,7));});
	$("#dept_tel").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") ); $(this).val($(this).val().substring(0,7));});
	$("#charge_phone").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") ); });


});
</script>

<script>
$(function(){
	schoo_type_msg_fn($("input[name=school_type]:checked").val());
	$("input[name=school_type]").change(function(){
		schoo_type_msg_fn($("input[name=school_type]:checked").val());
	});
});

function schoo_type_msg_fn(school_type){
	var msg;
	if(school_type == 'PUBLIC'){
		msg = '※변경 시 사립학교 관리자에게 해당 학교 정보가 이관됩니다.';
	}else if(school_type == 'PRIVATE'){
		msg = '※변경 시 공립학교 관리자에게 해당 학교 정보가 이관됩니다.';
	}
	$("#school_type_msg").html(msg);
}
</script>

<%
if(groupCheck){
if(!approval_check){ %>
<div class="topbox1 mabB20 magT20 c">승인대기중입니다. 관리자 승인 완료 후 [관리자 메뉴]를 이용하여 주시기 바랍니다. <br>문의전화 : 도교육청 재정과 268-1483</div>
<%}else{%>

<form action="" method="post" id="postForm" class="school_regit">
<input type="hidden" name="school_id" id="school_id" value="<%=school_id%>">
<input type="hidden" name="charge_id" id="charge_id" value="<%=charge_id%>">
<input type="hidden" name="charge_name2" id="charge_name2" value="<%=charge_name2%>">
<input type="hidden" name="command" id="command" value="<%=command%>">

<section>
	<h3>학교 정보</h3>
	<table class="table_skin01 txt_l">
		<caption> 학교 정보 등록표입니다. </caption>
    <colgroup>
      <col class="wps_15"/>
      <col />
      <col class="wps_15"/>
      <col class="wps_30"/>
    </colgroup>
		<tbody>
			<tr>
				<th scope="row"><span class="red">&#42;</span> 학교명</th>
				<td><label for="school_name" class="blind">학교명</label>
					<%if("view".equals(command)){%>
						<%=school_name%>
					<%}else{%>
						<input type="text" name="school_name" id="school_name" value="<%=school_name%>" class="wps_80">
						<span class="sub">&#8251; 학교명을 정확하게 입력해주세요.<br />예)창원고등학교, 마산여자중학교</span>
					<%}%>
				</td>
				<th scope="row"><span class="red">&#42;</span> 전화번호</th>
				<td><label for="school_tel" class="blind">전화번호</label>
					<%if("view".equals(command)){%>
						<%=telSet("055"+parseNull(school_tel))%>
					<%}else{%>
						055 <input type="text" name="school_tel" id="school_tel" value="<%=parseNull(school_tel)%>" class="wps_80">
						<span class="sub">&#8251; 지역번호를 제외한 숫자만 입력해주세요.</span>
					<%}%>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="red">&#42;</span> 주소</th>
				<td colspan="3">
					<label for="school_area" class="blind">주소</label>
					<p class="addr">
					<%if("view".equals(command)){%>
						경상남도 <%=school_area%> <%=school_addr %> / <%if("N".equals(area_type)){%>시지역<%}else{%>군,읍,면 지역<%}%>
					<%}else{%>
						경상남도
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
						<label><input type="text" name="school_addr" id="school_addr" value="<%=school_addr%>" class="wps_40"></label>
					</p>
					<label><input type="checkbox" name="area_type" id="area_type" value="N" <%if("N".equals(area_type)){%>checked="checked"<%}%> >시지역</label>
					<label><input type="checkbox" name="area_type" id="area_type" value="Y" <%if("Y".equals(area_type)){%>checked="checked"<%}%> >군,읍,면 지역</label>
					<%}%>
						
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="red">&#42;</span> 공립/사립</th>
				<td colspan="3"><label for="school_type" class="blind">공립/사립</label>
					<%if("view".equals(command)){
						school_type = "PUBLIC".equals(school_type)?"공립":"사립";
					%>
						<%=school_type%>
					<%}else{%>
						<label><input type="checkbox" name="school_type" id="school_type" 
						value="PUBLIC" <%if("PUBLIC".equals(school_type)){%>checked="checked"<%}%> >공립</label>
						<label><input type="checkbox" name="school_type" id="school_type2" 
							value="PRIVATE" <%if("PRIVATE".equals(school_type)){%>checked="checked"<%}%> >사립</label>
						<span id="school_type_msg" class="sub"></span>
					<%}%>
				</td>
			</tr>
			<tr>
				<th scope="row">홈페이지</th>
				<td colspan="3"><label for="school_url" class="blind">홈페이지</label>
					<%if("view".equals(command)){%>
						<%=parseNull(school_url)%>
					<%}else{%>
						<input type="text" name="school_url" id="school_url" value="<%=parseNull(school_url)%>" class="wps_80" placeholder="http://">
					<%}%>
					
				</td>
			</tr>
		</tbody>
	</table>
</section>

<section>
	<h3>학교시설 담당자 정보</h3>
	<table class="table_skin01 txt_l">
		<caption> 학교시설 담당자 정보 입력표입니다. </caption>
		<colgroup>
			<col class="wps_15"/>
      <col />
      <col class="wps_15"/>
      <col class="wps_30"/>
		</colgroup>
		<tbody>
			<tr>
				<th scope="row"><span class="red">&#42;</span> 담당부서명</th>
				<td><label for="charge_dept" class="blind">담당부서</label>
					<%if("view".equals(command)){%>
						<%=charge_dept%>
					<%}else{%>
						<input type="text" name="charge_dept" id="charge_dept" value="<%=charge_dept%>" class="wps_90">
					<%}%>	
				</td>
				<th scope="row"><span class="red">&#42;</span> 부서 전화번호</th>
				<td><label for="dept_tel" class="blind">부서 전화번호</label>
					<%if("view".equals(command)){%>
						<%=telSet("055"+dept_tel)%>
					<%}else{%>
						055 <input type="text" name="dept_tel" id="dept_tel" value="<%=dept_tel%>" class="wps_80">
						<span class="sub">&#8251; 숫자만 입력해주세요.</span>
					<%}%>	
					
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="red">&#42;</span> 담당자명</th>
				<td><label for="charge_name" class="blind">담당자명</label>
					<%if("view".equals(command)){%>
						<%=charge_name%>
					<%}else{%>
						<input type="text" name="charge_name" id="charge_name" value="<%=charge_name%>" class="wps_90">
					<%}%>	
				</td>
				<th scope="row"><span class="red">&#42;</span> 휴대폰번호</th>
				<td>
					<label for="charge_phone" class="blind"><span class="red">&#42;</span> 휴대폰번호</label>
					<%if("view".equals(command)){%>
						<%=telSet(charge_phone)%>
					<%}else{%>
						<input type="text" name="charge_phone" id="charge_phone" value="<%=charge_phone%>" class="wps_90">
						<span class="sub">&#8251; 예약 알림을 받을 휴대폰 번호를 숫자만 입력해주세요.</span>
					<%}%>	
					
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="red">&#42;</span> 입금계좌</th>
				<td colspan="3">
					<label for="account" class="blind"><span class="red">&#42;</span> 납부계좌</label>
					<%if("view".equals(command)){%>
						<%=account%>
					<%}else{%>
						<input type="text" name="account" id="account" value="<%=account%>" class="wps_80">
						<span class="sub">&#8251; 입금받을 <strong class="red">은행명과 계좌번호 숫자</strong>만 정확하게 입력해주세요.<br>입력예) 농협 12345678900</span>
					<%}%>	
					
				</td>
			</tr>
		</tbody>
	</table>
</section>

<div class="btn_area c">
	<%
	if("view".equals(command)){
		%>
		<button type="button" onclick="updatePage()" class="btn medium edge darkMblue">수정하기</button>
		<%
	}else{
		if(!id_check){
		%>
		<button type="button" onclick="postForm('insert')" class="btn medium edge darkMblue">등록하기</button>
		<%
		}else{
		%>
		<button type="button" onclick="postForm('update')" class="btn medium edge darkMblue">수정완료</button>
		<%
		}
	}
	%>
</div>

<%}}else{%>
<div class="topbox2 c">학교 관리자만 이용 가능합니다.</div>
<%}%>
</form>