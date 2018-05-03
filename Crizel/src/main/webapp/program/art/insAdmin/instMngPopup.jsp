<%
/**
*   PURPOSE :   악기 승인관리 popup page
*   CREATE  :   20180201_thur    Ko
*   MODIFY  :   20180223 LJH 마크업, 클래스 수정
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
		<title>악기 신청관리</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
		<style type="text/css">
			input[type="number"] {border:1px solid #bfbfbf; vertical-align:middle; line-height:18px; padding:5px; box-sizing: border-box;}
		</style>
</head>
<body>
<%!
private class InsVO{
	public int req_no;
	public String req_id;
	public String req_group;
	public String req_mng_nm;
	public String req_mng_tel;
	public String req_mng_mail;
	public int req_inst_cnt;
	public String req_memo;
	public String reg_ip;
	public String reg_date;
	public String show_flag;
	public String apply_flag;
	public String apply_date;

	public String inst_cat;
	public String inst_cat_nm;
	public int inst_no;
	public String inst_nm;
	public int inst_req_cnt;

	public String inst_name;
	public String inst_memo;
	public int curr_cnt;
	public int max_cnt;
	public String inst_size;
	public String inst_model;
	public String inst_pic;
	public String inst_lca;
	public String reg_id;
	public String mod_date;
	public String del_flag;

	public int artcode_no;
	public String code_tbl;
	public String code_col;
	public String code_name;
	public String code_val1;
	public String code_val2;
	public String code_val3;
	public int order1;
	public int order2;
	public int order3;
}

private class InsVOMapper implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
    	vo.req_no			= rs.getInt("REQ_NO");
    	vo.req_id			= rs.getString("REQ_ID");
    	vo.req_group		= rs.getString("REQ_GROUP");
    	vo.req_mng_nm		= rs.getString("REQ_MNG_NM");
    	vo.req_mng_tel		= rs.getString("REQ_MNG_TEL");
    	vo.req_mng_mail		= rs.getString("REQ_MNG_MAIL");
    	vo.req_inst_cnt		= rs.getInt("REQ_INST_CNT");
    	vo.req_memo			= rs.getString("REQ_MEMO");
    	vo.reg_ip			= rs.getString("REG_IP");
    	vo.reg_date			= rs.getString("REG_DATE");
    	vo.show_flag		= rs.getString("SHOW_FLAG");
    	vo.apply_flag		= rs.getString("APPLY_FLAG");
    	vo.apply_date		= rs.getString("APPLY_DATE");
        return vo;
    }
}

private class InsVOMapper2 implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
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

private class InsVOMapper3 implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
    	vo.inst_no			= rs.getInt("inst_no");
    	vo.inst_name		= rs.getString("inst_name");
        return vo;
    }
}

private class InsVOMapper4 implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
    	vo.inst_no			= rs.getInt("INST_NO");
    	vo.inst_cat_nm		= rs.getString("INST_CAT_NM");
    	vo.inst_nm		= rs.getString("INST_NM");
    	vo.inst_req_cnt		= rs.getInt("INST_REQ_CNT");
    	vo.req_inst_cnt		= rs.getInt("REQ_INST_CNT");
    	vo.max_cnt			= rs.getInt("MAX_CNT");
    	vo.curr_cnt			= rs.getInt("CURR_CNT");

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

String mode 	= parseNull(request.getParameter("mode"), "insert");
String req_no 	= parseNull(request.getParameter("req_no"));

StringBuffer sql 		= null;
List<InsVO> list 		= null;
List<InsVO> list2 		= null;
List<InsVO> list3 		= null;
InsVO vo			 	= new InsVO();

try{
	if(!"".equals(req_no)){
		sql = new StringBuffer();
		sql.append("SELECT															");
		sql.append("	A.REQ_NO,													");
		sql.append("	A.REQ_ID,													");
		sql.append("	A.REQ_GROUP,												");
		sql.append("	A.REQ_MNG_NM,												");
		sql.append("	A.REQ_MNG_TEL,												");
		sql.append("	A.REQ_MNG_MAIL,												");
		sql.append("	A.REQ_INST_CNT,												");
		sql.append("	A.REQ_MEMO,													");
		sql.append("	A.REG_IP,													");
		sql.append("	A.REG_DATE,													");
		sql.append("	A.SHOW_FLAG,												");
		sql.append("	A.APPLY_FLAG,												");
		sql.append("	A.APPLY_DATE												");
		sql.append("FROM ART_INST_REQ A 											");
		sql.append("WHERE A.REQ_NO = ?												");
		vo = jdbcTemplate.queryForObject(
					sql.toString(),
					new InsVOMapper(),
					new Object[]{req_no}
				);


		sql = new StringBuffer();
		sql.append("SELECT B.INST_NO, B.INST_CAT_NM, B.INST_NM, A.REQ_INST_CNT, B.INST_REQ_CNT, C.MAX_CNT, C.CURR_CNT	");
		sql.append("FROM ART_INST_REQ A LEFT JOIN ART_INST_REQ_CNT B 													");
		sql.append("ON A.REQ_NO = B.REQ_NO 																				");
		sql.append("LEFT JOIN ART_INST_MNG C 																			");
		sql.append("ON B.INST_NO = C.INST_NO 																			");
		sql.append("WHERE A.REQ_NO = ? 																					");
		list3 = jdbcTemplate.query(
					sql.toString(),
					new Object[]{req_no},
					new InsVOMapper4()
				);
	}

	sql = new StringBuffer();
	sql.append("SELECT *								");
	sql.append("FROM ART_PRO_CODE						");
	sql.append("WHERE CODE_NAME = 'ART_INST_MNG' 		");
	sql.append("ORDER BY ORDER1, ARTCODE_NO	 			");
	list = jdbcTemplate.query(
				sql.toString(),
				new InsVOMapper2()
			);

	if(!"".equals(req_no)){
		sql = new StringBuffer();
		sql.append("SELECT *													");
		sql.append("FROM ART_INST_MNG											");
		sql.append("WHERE INST_NO IN (SELECT INST_NO							");
		sql.append("				 FROM ART_INST_REQ_CNT 						");
		sql.append("				 WHERE REQ_NO = ? GROUP BY INST_NO)			");
		sql.append("ORDER BY INST_NAME				");
		list2 = jdbcTemplate.query(
					sql.toString(),
					new InsVOMapper3(),
					new Object[]{req_no}
				);
	}
}catch(Exception e){
	out.println(e.toString());
}

%>
<script>
function insertSubmit(){
	var msg;
	var addr;

	if($("#mode").val() == "insert"){
		msg 	= "등록";
	}else{
		msg 	= "수정";
	}

	if(confirm(msg+"하시겠습니까?")){
		return true;
	}else{
		return false;
	}
}

function instSelect(inst_cat_nm, cnt){
	var htmlVal = "";

	$.ajax({
		type : "POST",
		url : "instNmSelect.jsp",
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		data : {
			inst_cat_nm : inst_cat_nm
		},
		datatype : "json",
		success : function(data) {
			htmlVal += "<option value=''>선택</option>";
			$.each(JSON.parse(data), function(i, val) {									//ajax로 받아온 json 데이터를 html로 구성한다
				htmlVal += "<option value='"+ val.inst_no +"'>";
				htmlVal += val.inst_name;
				htmlVal += "</option>";
			});
			$("#curr_cnt_"+cnt).val("0");
			$("#max_cnt_"+cnt).val("0");
			$("#now_cnt_"+cnt).val("0");
			$("#inst_no_"+cnt).html(htmlVal);		//프로그램 리스트 출력
		},
		error:function(request,status,error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}
function instGetCnt(inst_no, cnt){
	var curr_cnt = 0;
	var max_cnt = 0;
	var now_cnt = 0;
	$.ajax({
		type : "POST",
		url : "instGetCnt.jsp",
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		data : {
			inst_no : inst_no
		},
		datatype : "json",
		success : function(data) {
			$.each(JSON.parse(data), function(i, val) {									//ajax로 받아온 json 데이터를 html로 구성한다
				curr_cnt = val.curr_cnt;
				max_cnt = val.max_cnt;
				now_cnt = val.now_cnt;
			});
			//$("#curr_cnt_"+cnt).val(curr_cnt);
			$("#curr_cnt_"+cnt).val(max_cnt-curr_cnt);		//남은량 이기에 최대-현재 계산을 한다
			$("#max_cnt_"+cnt).val(max_cnt);
			$("#now_cnt_"+cnt).val(now_cnt);
		},
		error:function(request,status,error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}

function addSelect(){
	var cnt = $("#addBlock #countBox").length;
	var html = "";

	html += '<table id="selectBlock_'+cnt+'" class="bbs_list2 th-c td-l magB5"><colgroup><col style="width:19%"><col /><col style="width:19%"><col /><col style="width:19%"><col /></colgroup>';
	html += '<tr><th scope="row">악기 선택</th><td colspan="5">';
	html += '<input type="hidden" id="countBox" >';
	html += '<select id="inst_cat_nm_'+cnt+'" name="inst_cat_nm" onchange="instSelect(this.value, '+cnt+')" required>';
	html += '<option value="">분류선택</option>';
	html += '<%if(list!=null && list.size()>0){for(InsVO ob : list){%>	';
	html += '<option value="<%=ob.code_val1%>"><%=ob.code_val1 %></option>	';
	html += ' <%}}%>';
	html += '</select> ';
	html += '<select id="inst_no_'+cnt+'" name="inst_no" onchange="instGetCnt(this.value, '+cnt+')"  required>';
	html += '<option value="">악기선택</option>';
	html += '</select>';
	html += '</td></tr>';
	html += '<tr><th scope="row">대여량</th>';
	html += '<td><input type="text" id="req_inst_cnt_'+cnt+'" name="req_inst_cnt" class="w_60 txt_c" value="" required></td>';
	html += '<th scope="row">남은량</th>';
	html += '<td><input type="text" id="curr_cnt_'+cnt+'" name="curr_cnt" value="" class="w_60 txt_c" readonly></td>';
	html += '<th scope="row">총량</th>';
	html += '<td><input type="text" id="max_cnt_'+cnt+'" name="max_cnt" value="" class="w_60 txt_c" readonly></td></tr>';
	html += '<tr><td colspan="6"><button type="button" class="btn edge small mako" onclick="addSelect()">+ 추가</button>';
	html += '<button type="button" class="btn small edge white" onclick="removeSelect('+cnt+')">- 삭제</button></td></tr>';
	html += '</table>';

	$("#addBlock").append(html);
}

function removeSelect(cnt){
	$("#selectBlock_"+cnt).remove();
}

$(function(){
	$('#max_cnt').keyup(function(){this.value = this.value.replace(/[^0-9]/g,'');});
	$('#curr_cnt').keyup(function(){this.value = this.value.replace(/[^0-9]/g,'');});
	$('#req_mng_tel').keyup(function(){this.value = this.value.replace(/[^0-9]/g,'');});
});
</script>

<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>악기 신청관리</strong></p>
  </div>
</div>
<!-- S : #content -->
	<div id="content">
		<div>
			<form action="instMngAction.jsp" method="post" id="insertForm" name="insertForm" onsubmit="return insertSubmit();">
				<fieldset>
				<input type="hidden" id="mode" name="mode" value="<%=mode%>">
				<input type="hidden" id="reg_id" name="reg_id" value="<%=sm.getId()%>">
				<input type="hidden" id="reg_ip" name="reg_ip" value="<%=request.getRemoteAddr()%>">
				<input type="hidden" id="req_no" name="req_no" value="<%=vo.req_no%>">
				<input type="hidden" id="apply_flag" name="apply_flag" value="<%=vo.apply_flag%>">
					<legend>분류관리</legend>
					<table class="bbs_list2 td-l">
						<colgroup>
							<col style="width:25%" />
							<col  />
						</colgroup>
						<tbody>
						<%if(!"".equals(req_no) && list3!=null && list3.size()>0){ %>
						<tr>
							<th>
								<label for="inst_cat_nm_0">악기 분류/<br>악기선택/<br>악기총량</label>
							</th>
							<td>
	                <div id="addBlock">
		                <table class="bbs_list2 th-c td-l magB5" id="selectBlock_0"><!-- 악기 추가 테이블 -->
	                    <colgroup>
	                        <col style="width:19%">
	                        <col />
	                        <col style="width:19%">
	                        <col />
	                        <col style="width:19%">
	                        <col />
	                    </colgroup>
		                <%
		                for(int i=0; i<list3.size(); i++){
		                    InsVO vo2 = list3.get(i);
		                %>
		                  <tr>
                      <th scope="row">악기 선택</th>
                      <td colspan="5">
                          <input type="hidden" id="countBox" >
                          <select id="inst_cat_nm_<%=i%>" name="inst_cat_nm" onchange="instSelect(this.value, <%=i%>)" required>
                          <option value="">분류선택</option>
                          <%
                          if(list!=null && list.size()>0){
                          for(InsVO ob : list){
                          %>
                              <option value="<%=ob.code_val1%>" <%if(ob.code_val1.equals(vo2.inst_cat_nm)){%> selected="selected" <%}%> ><%=ob.code_val1 %></option>
                          <%
                          }
                          }
                          %>
                          </select>

                          <select id="inst_no_<%=i%>" name="inst_no" onchange="instGetCnt(this.value, <%=i%>)"  required>
                              <option value="">악기선택</option>
                          <%
                          if(list2!=null && list2.size()>0){
                          for(InsVO ob : list2){
                          %>
                              <option value="<%=ob.inst_no%>" <%if(ob.inst_name.equals(vo2.inst_nm)){%> selected="selected" <%}%> ><%=ob.inst_name %></option>
                          <%
                              }
                          }
                          %>
                          </select>
                        </td>
		                  </tr>
											<tr>
	                        <th scope="row">대여량</th>
	                        <td>
	                        	<input type="text" id="req_inst_cnt_<%=i%>" name="req_inst_cnt" class="w_60 txt_c"
	                        	<%if(vo2.req_inst_cnt > 0){%>value="<%=parseNull(Integer.toString(vo2.inst_req_cnt))%>"
	                        	<%}else{ %>                                            	value="0"
	                        	<%} %>
	                        	 required>
	                        </td>
	                        <th scope="row">남은량</th>
	                        <td><input type="text" id="curr_cnt_<%=i%>" name="curr_cnt" class="w_60 txt_c" value="<%=vo2.max_cnt - vo2.curr_cnt%>" readonly></td>
	                        <th scope="row">총량</th>
	                        <td><input type="text" id="max_cnt_<%=i%>" name="max_cnt" class="w_60 txt_c" value="<%=vo2.max_cnt%>" readonly></td>
	                    </tr>
	                    <tr>
	                    	<td colspan="6">
	                    		<button type="button" onclick="addSelect()" class="btn edge small mako">+ 추가</button>
	                    	</td>
	                    </tr>
									<%}%>

								</table><!-- ./악기 추가 table-->
								</div>
							</td>
						</tr>
						<%} %>

						<%if("".equals(req_no)){ %>
						<tr>
							<th>
								<label for="inst_cat_nm_0">악기 분류/<br>악기선택/<br>악기총량</label>
							</th>
							<td>
							    <div id="addBlock">
                      <table class="bbs_list2 th-c td-l magB5"><!-- 악기 추가 테이블 -->
                          <colgroup>
                              <col style="width:19%">
                              <col />
                              <col style="width:19%">
                              <col />
                              <col style="width:19%">
                              <col />
                          </colgroup>
                          <tr>
                              <th scope="row">악기 선택</th>
                              <td colspan="5">
                                  <input type="hidden" id="countBox" >
                                  <select id="inst_cat_nm_0" name="inst_cat_nm" onchange="instSelect(this.value, 0)" required>
                                  <option value="">분류선택</option>
                                  <%
                                  if(list!=null && list.size()>0){
                                  for(InsVO ob : list){
                                  %>
                                      <option value="<%=ob.code_val1%>" <%if(ob.code_val1.equals(vo.inst_cat_nm)){%> selected="selected" <%}%> ><%=ob.code_val1 %></option>
                                  <%
                                  }
                                  }
                                  %>
                                  </select>

                                  <select id="inst_no_0" name="inst_no" onchange="instGetCnt(this.value, 0)"  required>
                                      <option value="">악기선택</option>
                                  <%
                                  if(list2!=null && list2.size()>0){
                                  for(InsVO ob : list2){
                                  %>
                                      <option value="<%=ob.inst_no%>" <%if(ob.inst_name.equals(vo.inst_nm)){%> selected="selected" <%}%> ><%=ob.inst_name %></option>
                                  <%
                                  }
                                  }
                                  %>
                                  </select>
                              </td>
                          </tr>
                          <tr>
                              <th scope="row">대여량</th>
                              <td><input type="text" id="req_inst_cnt_0" name="req_inst_cnt" class="w_60 txt_c" value="<%=parseNull(Integer.toString(vo.req_inst_cnt))%>" required></td>
                              <th scope="row">남은량</th>
                              <td><input type="text" id="curr_cnt_0" name="curr_cnt" class="w_60 txt_c" value="<%=vo.curr_cnt%>" readonly></td>
                              <th scope="row">총량</th>
                              <td><input type="text" id="max_cnt_0" name="max_cnt" class="w_60 txt_c" value="<%=vo.max_cnt%>" readonly></td>
                              <tr>
                              	<td colspan="6">
                              		<button type="button" onclick="addSelect()" class="btn edge small mako">+ 추가</button>
                              	</td>
                              </tr>
                          </tr>
                      </table>
                  </div>
							</td>
						</tr>
						<%} %>
						<tr>
							<th>
								<label for="req_group">단체명/대리인</label>
							</th>
							<td>
								<input type="text" id="req_group" name="req_group" value="<%=parseNull(vo.req_group)%>" required>
							</td>
						</tr>
						<tr>
							<th>
								<label for="req_id">신청자 아이디</label>
							</th>
							<td>
								<input type="text" id="req_id" name="req_id" value="<%=parseNull(vo.req_id)%>" required>
							</td>
						</tr>
						<tr>
							<th>
								<label for="req_mng_tel">신청자 연락처</label>
							</th>
							<td>
								<input type="text" id="req_mng_tel" name="req_mng_tel" value="<%=parseNull(vo.req_mng_tel)%>" required>
							</td>
						</tr>
						<tr>
							<th>
								<label for="req_mng_mail">신청자 이메일</label>
							</th>
							<td>
								<input type="text" id="req_mng_mail" name="req_mng_mail" class="wps_70" value="<%=parseNull(vo.req_mng_mail)%>" required>
							</td>
						</tr>
						<tr>
							<th>
								<label for="req_mng_nm">신청자명</label>
							</th>
							<td>
								<input type="text" id="req_mng_nm" name="req_mng_nm" value="<%=parseNull(vo.req_mng_nm)%>" required>
							</td>
						</tr>
						<tr>
							<th>
								<label for="req_memo">신청동기</label>
							</th>
							<td>
								<textarea class="wps_90 h150" id="req_memo" name="req_memo" required><%=parseNull(vo.req_memo)%></textarea>
							</td>
						</tr>
						</tbody>
					</table>
					<p class="txt_c">
						<button type="submit" class="btn medium edge darkMblue w_100">
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
<!-- // E : #content -->

</body>
</html>
