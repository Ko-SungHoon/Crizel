<%
/**
*   PURPOSE :   악기 승인관리 popup page
*   CREATE  :   20180201_thur    Ko
*   MODIFY  :   ....
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
	public int req_inst_cnt;
	public String req_memo;
	public String reg_ip;
	public String reg_date;
	public String show_flag;
	
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
    	vo.req_inst_cnt		= rs.getInt("REQ_INST_CNT");
    	vo.req_memo			= rs.getString("REQ_MEMO");
    	vo.reg_ip			= rs.getString("REG_IP");
    	vo.reg_date			= rs.getString("REG_DATE");
    	vo.show_flag		= rs.getString("SHOW_FLAG");
    	
    	vo.req_no			= rs.getInt("REQ_NO");
    	vo.inst_cat			= rs.getString("INST_CAT");
    	vo.inst_cat_nm		= rs.getString("INST_CAT_NM");
    	vo.inst_no			= rs.getInt("INST_NO");
    	vo.inst_nm			= rs.getString("INST_NM");
    	vo.inst_req_cnt		= rs.getInt("INST_REQ_CNT");
    	
    	vo.curr_cnt			= rs.getInt("CURR_CNT"); 
    	vo.max_cnt			= rs.getInt("MAX_CNT");
    	
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


%>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

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
		sql.append("	A.REQ_INST_CNT,												");
		sql.append("	A.REQ_MEMO,													");
		sql.append("	A.REG_IP,													");
		sql.append("	A.REG_DATE,													");
		sql.append("	A.SHOW_FLAG,												");
		sql.append("	B.INST_CAT,													");
		sql.append("	B.INST_CAT_NM,												");
		sql.append("	B.INST_NO,													");
		sql.append("	B.INST_NM,													");
		sql.append("	B.INST_REQ_CNT,												");
		sql.append("	(SELECT CURR_CNT 											");
		sql.append("	 FROM ART_INST_MNG 											");
		sql.append("	 WHERE INST_NO = (SELECT INST_NO 							");
		sql.append("					  FROM ART_INST_REQ_CNT 					");
		sql.append("					  WHERE REQ_NO = B.REQ_NO)) CURR_CNT,		");
		sql.append("	(SELECT MAX_CNT 											");
		sql.append("	 FROM ART_INST_MNG 											");
		sql.append("	 WHERE INST_NO = (SELECT INST_NO 							");
		sql.append("					  FROM ART_INST_REQ_CNT 					");
		sql.append("					  WHERE REQ_NO = B.REQ_NO)) MAX_CNT			");
		sql.append("FROM ART_INST_REQ A LEFT JOIN ART_INST_REQ_CNT B				");
		sql.append("ON A.REQ_NO = B.REQ_NO											");
		sql.append("WHERE A.REQ_NO = ").append(req_no).append("						");
		vo = jdbcTemplate.queryForObject(
					sql.toString(), 
					new InsVOMapper()
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
		sql.append("WHERE INST_NO = (SELECT INST_NO								");
		sql.append("				 FROM ART_INST_REQ_CNT 						");
		sql.append("				 WHERE REQ_NO = ").append(req_no).append(")	");
		sql.append("ORDER BY INST_NAME				");
		list2 = jdbcTemplate.query(
					sql.toString(), 
					new InsVOMapper3()
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

function instSelect(inst_cat_nm){
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
			$("#curr_cnt").val("0");
			$("#max_cnt").val("0");
			$("#now_cnt").val("0");
			$("#inst_no").html(htmlVal);		//프로그램 리스트 출력
		},
		error:function(request,status,error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}
function instGetCnt(inst_no){
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
			$("#curr_cnt").val(curr_cnt);
			$("#max_cnt").val(max_cnt);
			$("#now_cnt").val(now_cnt);
		},
		error:function(request,status,error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
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
	<div id="content">
		<div class="listArea">
			<form action="instMngAction.jsp" method="post" id="insertForm" name="insertForm" onsubmit="return insertSubmit();">
				<fieldset>
				<input type="hidden" id="mode" name="mode" value="<%=mode%>">
				<input type="hidden" id="reg_id" name="reg_id" value="<%=sm.getId()%>">
				<input type="hidden" id="reg_ip" name="reg_ip" value="<%=request.getRemoteAddr()%>">
				<input type="hidden" id="req_no" name="req_no" value="<%=vo.req_no%>">
					<legend>분류관리</legend>
					<table class="bbs_list2">
						<colgroup>
							<col width="30%" />
							<col width="70%" />
						</colgroup>
						<tbody style="text-align: center; vertical-align: middle;">
						<tr>
							<th>
								<label for="inst_cat_nm">악기 분류</label>
							</th>
							<td>
								<select id="inst_cat_nm" name="inst_cat_nm" onchange="instSelect(this.value)" required>
								<option value="">선택</option>
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
							</td>
						</tr>
						<tr>
							<th>
								<label for="inst_nm">악기 선택</label>
							</th>
							<td>
								<select id="inst_no" name="inst_no" onchange="instGetCnt(this.value)"  required>
									<option value="">선택</option>
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
							<th>
								<label for="req_group">그룹명</label>
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
								<label for="req_mng_nm">신청자명</label>
							</th>
							<td>
								<input type="text" id="req_mng_nm" name="req_mng_nm" value="<%=parseNull(vo.req_mng_nm)%>" required>
							</td>
						</tr>
						<tr>
							<th>
								<label for="req_inst_cnt">악기총량</label>
							</th>
							<td>
								<ul>
									<li>총량 <input type="text" id="max_cnt" name="max_cnt" value="<%=vo.max_cnt%>" readonly></li>
									<li>현재 대여량 <input type="text" id="curr_cnt" name="curr_cnt" value="<%=vo.curr_cnt%>" readonly></li>
									<li>추가대여 가능량 : <input type="text" id="now_cnt" name="now_cnt" value="<%=vo.max_cnt - vo.curr_cnt %>" readonly></li>
									<li><input type="text" id="req_inst_cnt" name="req_inst_cnt" value="<%=parseNull(Integer.toString(vo.req_inst_cnt))%>" required></li>
								</ul>
								 
							</td>
						</tr>
						<tr>
							<th>
								<label for="req_memo">신청동기</label>
							</th>
							<td>
								<textarea rows="20" cols="100" id="req_memo" name="req_memo" required><%=parseNull(vo.req_memo)%></textarea>
							</td>
						</tr>
						</tbody>
					</table>
					<p class="txt_c">
						<button type="submit" class="btn medium edge mako">
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
