<%
/**
*   PURPOSE :   심화 프로그램 insert popup page
*   CREATE  :   20180130_tue    Ko
*   MODIFY  :   20180226 LJH 클래스 수정
**/
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>심화프로그램 추가</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />

		<style type="text/css">
			input[type="number"] {border:1px solid #bfbfbf; vertical-align:middle; line-height:18px; padding:5px; box-sizing: border-box;}
		</style>

		<!-- link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css"/ -->
		<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
		<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
		<script>
		$.datepicker.regional['kr'] = {
			    closeText: '닫기', // 닫기 버튼 텍스트 변경
			    currentText: '오늘', // 오늘 텍스트 변경
			    monthNames: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
			    monthNamesShort: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
			    dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'], // 요일 텍스트 설정
			    dayNamesShort: ['일','월','화','수','목','금','토'], // 요일 텍스트 축약 설정
			    dayNamesMin: ['일','월','화','수','목','금','토'] // 요일 최소 축약 텍스트 설정
			};
		$.datepicker.setDefaults($.datepicker.regional['kr']);

		$(function() {
				//시작일
				$('#appstr_date').datepicker({
	                dateFormat: "yy-mm-dd",             // 날짜의 형식
	                changeMonth: true,
	                minDate: 0,                       // 선택할수있는 최소날짜, ( 0 : 오늘 이전 날짜 선택 불가)
	                onClose: function( selectedDate ) {
	                    // 시작일(fromDate) datepicker가 닫힐때
	                    // 종료일(toDate)의 선택할수있는 최소 날짜(minDate)를 선택한 시작일로 지정
	                    $("#append_date").datepicker( "option", "minDate", selectedDate );

	                    $("#prostr_date").datepicker( "option", "minDate", selectedDate );		//프로그램 시작 날짜는 모집날짜 이후로
	                    $("#proend_date").datepicker( "option", "minDate", selectedDate );
	                }
	            });
	            //종료일
	            $('#append_date').datepicker({
	                dateFormat: "yy-mm-dd",
	                changeMonth: true,
	                onClose: function( selectedDate ) {
	                    // 종료일(toDate) datepicker가 닫힐때
	                    // 시작일(fromDate)의 선택할수있는 최대 날짜(maxDate)를 선택한 종료일로 지정
	                    $("#appstr_date").datepicker( "option", "maxDate", selectedDate );

	                    $("#prostr_date").datepicker( "option", "minDate", selectedDate );
	                    $("#proend_date").datepicker( "option", "minDate", selectedDate );
	                }
	            });

	            //시작일
	            $('#prostr_date').datepicker({
	                dateFormat: "yy-mm-dd",             // 날짜의 형식
	                changeMonth: true,
	                minDate: 0,
	                onClose: function( selectedDate ) {
	                    $("#proend_date").datepicker( "option", "minDate", selectedDate );
	                }
	            });
	            //종료일
	            $('#proend_date').datepicker({
	                dateFormat: "yy-mm-dd",
	                changeMonth: true,
	                onClose: function( selectedDate ) {
	                    $("#prostr_date").datepicker( "option", "maxDate", selectedDate );
	                }
	            });

			  //$( "#appstr_date" ).datepicker({dateFormat: 'yy-mm-dd'});
			  //$( "#append_date" ).datepicker({dateFormat: 'yy-mm-dd'});
			  //$( "#prostr_date" ).datepicker({dateFormat: 'yy-mm-dd'});
			  //$( "#proend_date" ).datepicker({dateFormat: 'yy-mm-dd'});
		});
</script>
</head>
<body>
<%!
private class ArtVO{
	public int pro_no;
	public String pro_cat;
	public String pro_cat_nm;
	public String pro_name;
	public String pro_tch_name;
	public String pro_tch_tel;
	public String pro_memo;
	public String appstr_date;
	public String append_date;
	public String prostr_date;
	public String proend_date;
	public int curr_per;
	public int max_per;
	public String reg_id;
	public String reg_ip;
	public String reg_date;
	public String mod_date;
	public String show_flag;
	public String del_flag;
	public String ob_employee;
	public String ob_student;
	public String ob_citizen;
	public String pro_time;

	private int artcode_no;
	private String code_tbl;
	private String code_col;
	private String code_name;
	private String code_val1;
	private String code_val2;
	private String code_val3;
	private int order1;
	private int order2;
	private int order3;
}

private class ArtVOMapper implements RowMapper<ArtVO> {
    public ArtVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ArtVO vo = new ArtVO();
        vo.pro_no			= rs.getInt("PRO_NO");
        vo.pro_cat			= rs.getString("PRO_CAT");
        vo.pro_cat_nm		= rs.getString("PRO_CAT_NM");
        vo.pro_name			= rs.getString("PRO_NAME");
        vo.pro_tch_name		= rs.getString("PRO_TCH_NAME");
        vo.pro_tch_tel		= rs.getString("PRO_TCH_TEL");
        vo.pro_memo			= rs.getString("PRO_MEMO");
        vo.appstr_date		= rs.getString("APPSTR_DATE");
        vo.append_date		= rs.getString("APPEND_DATE");
        vo.prostr_date		= rs.getString("PROSTR_DATE");
        vo.proend_date		= rs.getString("PROEND_DATE");
        vo.curr_per			= rs.getInt("CURR_PER");
        vo.max_per			= rs.getInt("MAX_PER");
        vo.reg_id			= rs.getString("REG_ID");
        vo.reg_ip			= rs.getString("REG_IP");
        vo.reg_date			= rs.getString("REG_DATE");
        vo.mod_date			= rs.getString("MOD_DATE");
        vo.show_flag		= rs.getString("SHOW_FLAG");
        vo.del_flag			= rs.getString("DEL_FLAG");
        vo.ob_employee		= rs.getString("OB_EMPLOYEE");
        vo.ob_student		= rs.getString("OB_STUDENT");
        vo.ob_citizen		= rs.getString("OB_CITIZEN");
        vo.pro_time 		= rs.getString("PRO_TIME");

        return vo;
    }
}

private class ArtVOMapper2 implements RowMapper<ArtVO> {
    public ArtVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ArtVO vo = new ArtVO();
        vo.artcode_no		= rs.getInt("ARTCODE_NO");
        vo.code_tbl 		= rs.getString("CODE_TBL");
        vo.code_col			= rs.getString("CODE_COL");
        vo.code_name 		= rs.getString("CODE_NAME");
        vo.code_val1 		= rs.getString("CODE_VAL1");
        vo.code_val2		= rs.getString("CODE_VAL2");
        vo.code_val3		= rs.getString("CODE_VAL3");
        vo.order1 			= rs.getInt("ORDER1");
        vo.order2 			= rs.getInt("ORDER2");
        vo.order3 			= rs.getInt("ORDER3");
        return vo;
    }
}


%>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");
/************************** 접근 허용 체크 - 시작 **************************/
SessionManager sessionManager = new SessionManager(request);
String sessionId = sessionManager.getId();
if(sessionId == null || "".equals(sessionId)) {
	alertParentUrl(out, "관리자 로그인이 필요합니다.", adminLoginUrl);
	if(true) return;
}

String roleId= null;
String[] allowIp = null;
Connection conn = null;
try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	// 접속한 관리자 회원의 권한 롤
	roleId= getRoleId(sqlMapClient, conn, sessionId);
	
	// 관리자 접근 허용된 IP 배열
	allowIp = getAllowIpArrays(sqlMapClient, conn);
} catch (Exception e) {
	sqlMapClient.endTransaction();
	alertBack(out, "트랜잭션 오류가 발생했습니다.");
} finally {
	sqlMapClient.endTransaction();
}

// 권한정보 체크
boolean isAdmin = sessionManager.isRole(roleId);

// 접근허용 IP 체크
String thisIp = request.getRemoteAddr();
boolean isAllowIp = isAllowIp(thisIp, allowIp);

/** Method 및 Referer 정보 **/
String getMethod = parseNull(request.getMethod());
String getReferer = parseNull(request.getHeader("referer"));

if(!isAdmin) {
	alertBack(out, "해당 사용자("+sessionId+")는 접근 권한이 없습니다.");
	if(true) return;
}
if(!isAllowIp) {
	alertBack(out, "해당 IP("+thisIp+")는 접근 권한이 없습니다.");
	if(true) return;
}
/************************** 접근 허용 체크 - 종료 **************************/

SessionManager sm = new SessionManager(request);

Calendar cal = Calendar.getInstance();
String year 	= parseNull(request.getParameter("year"), Integer.toString(cal.get(Calendar.YEAR)) );
String mode 	= parseNull(request.getParameter("mode"), "insert");
String pro_no 	= parseNull(request.getParameter("pro_no"));

StringBuffer sql 		= null;
List<ArtVO> list 		= null;
ArtVO vo			 	= new ArtVO();
List<ArtVO> list2 		= null;

try{
	if(!"".equals(pro_no)){
		sql = new StringBuffer();
		sql.append("SELECT ART_PRO_DEEP.*						");
		sql.append("FROM ART_PRO_DEEP							");
		sql.append("WHERE PRO_NO = ?							");
		sql.append("ORDER BY PRO_NO DESC		 				");
		vo = jdbcTemplate.queryForObject(
					sql.toString(),
					new ArtVOMapper(),
					new Object[]{pro_no}
				);
	}

	sql = new StringBuffer();
	sql.append("SELECT *								");
	sql.append("FROM ART_PRO_CODE						");
	sql.append("WHERE CODE_NAME = 'ART_PRO_DEEP' 		");
	sql.append("ORDER BY ORDER1, ARTCODE_NO	 			");
	list2 = jdbcTemplate.query(
				sql.toString(),
				new ArtVOMapper2()
			);
}catch(Exception e){
	out.println(e.toString());
}

%>
<script>
function insertSubmit(){
	var msg;
	var addr;

	if (Number($("#max_per").val()) < Number($("#curr_per").val())) {
		alert("정원이 현원보다 적습니다.");
		$("#max_per").focus();
		return false;
	}

	if($("#mode").val() == "insert"){
		msg 	= "등록";
	}else{
		msg 	= "수정";
	}

	if(confirm(msg+"하시겠습니까?")){
		var form = document.getElementById("insertForm");
		var emp = form.ob_employee.checked;
		var stu = form.ob_student.checked;
		var cit = form.ob_citizen.checked;

		if(!emp && !stu && !cit){
			alert("대상을 최소 한가지 이상 선택하여주시기 바랍니다.");
			return false;
		}else{
			return true;
		}

	}else{
		return false;
	}
}
$(function(){
	$('#max_per').keyup(function(){this.value = this.value.replace(/[^0-9]/g,'');});
});
</script>
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>심화프로그램 <%if("insert".equals(mode)){%>추가<%}else{%>수정<%}%></strong></p>
  </div>
	<div id="content">
		<div class="listArea">
			<form action="programDeepInsertAction.jsp" method="post" id="insertForm" name="insertForm" onsubmit="return insertSubmit();">
				<fieldset>
				<input type="hidden" id="mode" name="mode" value="<%=mode%>">
				<input type="hidden" id="reg_id" name="reg_id" value="<%=sm.getId()%>">
				<input type="hidden" id="reg_ip" name="reg_ip" value="<%=request.getRemoteAddr()%>">
				<input type="hidden" id="pro_no" name="pro_no" value="<%=vo.pro_no%>">
					<legend>분류관리</legend>
					<table class="bbs_list2 td-l">
						<colgroup>
							<col width="30%" />
							<col width="70%" />
						</colgroup>
						<tbody style="text-align: center; vertical-align: middle;">
						<tr>
							<th scope="row">
								프로그램 분류
							</th>
							<td>
								<select id="pro_cat_nm" name="pro_cat_nm">
								<%
								if(list2!=null && list2.size()>0){
								for(ArtVO ob : list2){
								%>
									<option value="<%=ob.code_val1%>" <%if(ob.code_val1.equals(vo.pro_cat_nm)){%> selected="selected" <%}%> ><%=ob.code_val1 %></option>
								<%
								}
								}
								%>
								</select>
							</td>
						</tr>
            <tr>
              <th>
								시간대 설정
							</th>
                <td>
                    <select id="pro_time" name="pro_time">
                        <option value="지정 토요일 (10:00~12:00)" <%if("지정 토요일 (10:00~12:00)".equals(vo.pro_time)){%> selected="selected" <%}%> >지정 토요일 (10:00~12:00)</option>
                        <option value="오전 (10:00~13:00)" <%if("오전 (10:00~13:00)".equals(vo.pro_time)){%> selected="selected" <%}%> >오전 (10:00~13:00)</option>
                        <option value="오후 (14:00~17:00)" <%if("오후 (14:00~17:00)".equals(vo.pro_time)){%> selected="selected" <%}%> >오후 (14:00~17:00)</option>
                    </select>
                </td>
            </tr>
						<tr>
							<th scope="row">
								<label for="appstr_date">모집 시작/종료일</label>
							</th>
							<td>
								<input type="text" id="appstr_date" name="appstr_date" value="<%=parseNull(vo.appstr_date)%>" required readonly"> ~
								<input type="text" id="append_date" name="append_date" value="<%=parseNull(vo.append_date)%>" required readonly>
							</td>
						</tr>
						<tr>
							<th scope="row">
								<label for="appstr_date">프로그램 시작/종료일</label>
							</th>
							<td>
								<input type="text" id="prostr_date" name="prostr_date" value="<%=parseNull(vo.prostr_date)%>" required readonly> ~
								<input type="text" id="proend_date" name="proend_date" value="<%=parseNull(vo.proend_date)%>" required readonly>
							</td>
						</tr>
						<tr>
							<th scope="row">
								<label for="pro_name">프로그램명</label>
							</th>
							<td>
								<input type="text" id="pro_name" name="pro_name" class="wps_70" value="<%=parseNull(vo.pro_name)%>" required>
							</td>
						</tr>
						<tr>
							<th scope="row">
								<label for="pro_tch_name">강사명</label>
							</th>
							<td>
								<input type="text" id="pro_tch_name" name="pro_tch_name" value="<%=parseNull(vo.pro_tch_name)%>" required>
							</td>
						</tr>
						<tr>
							<th scope="row">
								<label for="curr_per">현원</label>
							</th>
							<td>
								<input type="text" id="curr_per" name="curr_per" class="w_100" value="<%=parseNull(Integer.toString(vo.curr_per))%>" readonly>
							</td>
						</tr>
						<tr>
							<th scope="row">
								<label for="max_per">정원</label>
							</th>
							<td>
								<input type="text" id="max_per" name="max_per" class="w_100" value="<%=parseNull(Integer.toString(vo.max_per))%>" required>
							</td>
						</tr>
						<tr>
							<th scope="row">
								<label for="ob_employee">대상</label>
							</th>
							<td>
								<input type="checkbox" id="ob_employee" name="ob_employee" value="Y"
								<%if("Y".equals(vo.ob_employee)){ %> checked <%}%> ><label for="ob_employee">교직원</label>
								<input type="checkbox" id="ob_student" name="ob_student" value="Y"
								<%if("Y".equals(vo.ob_student)){ %> checked <%}%> ><label for="ob_student">학생</label>
								<input type="checkbox" id="ob_citizen" name="ob_citizen" value="Y"
								<%if("Y".equals(vo.ob_citizen)){ %> checked <%}%> ><label for="ob_citizen">시민</label>
							</td>
						</tr>
						<tr>
							<th scope="row">
								노출 여부
							</th>
							<td>
								<input type="radio" id="show_flagY" name="show_flag" value="Y" <%if("Y".equals(vo.show_flag)){%> checked="checked" <%}%> required>
								<label for="show_flagY">Y</label>
								<input type="radio" id="show_flagN" name="show_flag" value="N" <%if("N".equals(vo.show_flag)){%> checked="checked" <%}%> required>
								<label for="show_flagN">N</label>
							</td>
						</tr>
						<tr>
							<th scope="row">
								<label for="pro_memo">프로그램 상세 내용</label>
							</th>
							<td>
								<textarea class="wps_90 h150" id="pro_memo" name="pro_memo" required><%=parseNull(vo.pro_memo)%></textarea>
							</td>
						</tr>
						</tbody>
					</table>
					<p class="txt_c">
						<button type="submit" class="btn medium edge darkMblue">
						<%
						if("insert".equals(mode)){
						%>
							등록
						<%}else{ %>
							수정
						<%} %>
						</button>
						<button type="button" class="btn medium edge mako" onclick="window.close();">닫기</button>
					</p>
				</fieldset>
			</form>
		</div>
	</div>
	<!-- // content -->
</div>
</body>
</html>
