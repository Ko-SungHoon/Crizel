<%
/**
*   PURPOSE :   악기 추가 popup page
*   CREATE  :   20180130_tue    Ko
*   MODIFY  :   20180222 LJH css 클래스 수정
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
		<title>악기 관리</title>
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
	public int inst_no;
	public String inst_cat;
	public String inst_cat_nm;
	public String inst_name;
	public String inst_memo;
	public int curr_cnt;
	public int max_cnt;
	public String inst_size;
	public String inst_model;
	public String inst_pic;
	public String inst_lca;
	public String reg_id;
	public String reg_ip;
	public String reg_date;
	public String mod_date;
	public String show_flag;
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
    	vo.inst_no			= rs.getInt("INST_NO");
    	vo.inst_cat			= rs.getString("INST_CAT");
    	vo.inst_cat_nm		= rs.getString("INST_CAT_NM");
    	vo.inst_name		= rs.getString("INST_NAME");
    	vo.inst_memo		= rs.getString("INST_MEMO");
    	vo.curr_cnt			= rs.getInt("CURR_CNT");
    	vo.max_cnt			= rs.getInt("MAX_CNT");
    	vo.inst_size		= rs.getString("INST_SIZE");
    	vo.inst_model		= rs.getString("INST_MODEL");
    	vo.inst_pic			= rs.getString("INST_PIC");
    	vo.inst_lca			= rs.getString("INST_LCA");
    	vo.reg_id			= rs.getString("REG_ID");
    	vo.reg_ip			= rs.getString("REG_IP");
    	vo.reg_date			= rs.getString("REG_DATE");
    	vo.mod_date			= rs.getString("MOD_DATE");
    	vo.show_flag		= rs.getString("SHOW_FLAG");
    	vo.del_flag			= rs.getString("DEL_FLAG");
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
String inst_no 	= parseNull(request.getParameter("inst_no"));

StringBuffer sql 		= null;
List<InsVO> list 		= null;
InsVO vo			 	= new InsVO();
List<InsVO> list2 		= null;

try{
	if(!"".equals(inst_no)){
		sql = new StringBuffer();
		sql.append("SELECT *									");
		sql.append("FROM ART_INST_MNG							");
		sql.append("WHERE INST_NO = ?							");
		sql.append("ORDER BY INST_NO DESC		 				");
		vo = jdbcTemplate.queryForObject(
					sql.toString(),
					new InsVOMapper(),
					new Object[]{inst_no}
				);
	}

	sql = new StringBuffer();
	sql.append("SELECT *								");
	sql.append("FROM ART_PRO_CODE						");
	sql.append("WHERE CODE_NAME = 'ART_INST_MNG' 		");
	sql.append("ORDER BY ORDER1, ARTCODE_NO	 			");
	list2 = jdbcTemplate.query(
				sql.toString(),
				new InsVOMapper2()
			);

}catch(Exception e){
	out.println(e.toString());
}

%>
<script>
function insertSubmit(){
	var msg;
	var addr;

	if (Number($("#max_cnt").val()) < Number($("#curr_cnt").val())) {
		alert("악기 총량이 대여량 보다 적습니다.");
		$("#max_cnt").focus();
		return false;
	}

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

function fileDelete(inst_no){
	if(confirm("이미지를 삭제하시겠습니까?")){
		$.ajax({
			type : "POST",
			url : "instFileDelete.jsp",
			contentType : "application/x-www-form-urlencoded; charset=utf-8",
			data : {
				inst_no : inst_no
			},
			datatype : "html",
			success : function(data) {
				if(data.trim() == "success"){
					location.reload();
				}
			},
			error:function(request,status,error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}else{
		return false;
	}
}

function fileDown(path, file){
	location.href="/program/down.jsp?path="+ path +"&filename=" + file
}

$(function(){
	$('#max_cnt').keyup(function(){this.value = this.value.replace(/[^0-9]/g,'');});
	$('#curr_cnt').keyup(function(){this.value = this.value.replace(/[^0-9]/g,'');});
});
</script>
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>악기 <%if("insert".equals(mode)){%>추가<%}else{%>수정<%}%></strong></p>
  </div>
	<div id="content">
		<div class="listArea">
			<form action="instInsertAction.jsp" method="post" id="insertForm" name="insertForm" onsubmit="return insertSubmit();" enctype="multipart/form-data">
				<fieldset>
				<input type="hidden" id="mode" name="mode" value="<%=mode%>">
				<input type="hidden" id="reg_id" name="reg_id" value="<%=sm.getId()%>">
				<input type="hidden" id="reg_ip" name="reg_ip" value="<%=request.getRemoteAddr()%>">
				<input type="hidden" id="inst_no" name="inst_no" value="<%=vo.inst_no%>">
					<legend>분류관리</legend>
					<table class="bbs_list2 td-l">
						<colgroup>
							<col style="width:150px;" />
							<col />
						</colgroup>
						<tbody>
						<tr>
							<th scope="row">악기 분류 </th>
							<td>
								<label for="inst_cat_nm" class="blind">악기 분류</label>
								<select id="inst_cat_nm" name="inst_cat_nm">
								<%
								if(list2!=null && list2.size()>0){
								for(InsVO ob : list2){
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
							<th scope="row">악기 규격 </th>
							<td>
								<label for="inst_size" class="blind">악기규격</label>
								<input type="text" id="inst_size" name="inst_size" value="<%=parseNull(vo.inst_size)%>" required>
							</td>
						</tr>
						<tr>
							<th scope="row">악기이미지</th>
							<td>
								<label for="inst_pic" class="blind">악기이미지</label>
								<%if("".equals(parseNull(vo.inst_pic))){ %>
								<input type="file" id="inst_pic" name="inst_pic" required>
								<%}else{
								String 	imgPath = "/";
										imgPath += vo.inst_pic.split("/")[1] + "/";
										imgPath += vo.inst_pic.split("/")[2] + "/";
										imgPath += vo.inst_pic.split("/")[3];

								String 	imgName =  vo.inst_pic.split("/")[4];
								%>
								<input type="hidden" id="inst_pic" name="inst_pic" value="<%=parseNull(vo.inst_pic)%>">
								<p class="magB10">
									<img src="<%=parseNull(vo.inst_pic)%>" alt="악기이미지" style="width:250px; height:150px;">
								</p>
								<p>
									<span onclick="fileDown('<%=imgPath%>', '<%=imgName%>')" style="cursor: pointer;"><%=parseNull(vo.inst_pic.split("/")[4])%></span>
									<span onclick="fileDelete('<%=vo.inst_no%>')" class="btn small edge red">[파일삭제]</span>
								</p>
								<%}%>
							</td>
						</tr>
						<tr>
							<th scope="row">악기모델명</th>
							<td>
								<label for="inst_model" class="blind">악기모델명</label>
								<input type="text" id="inst_model" name="inst_model" value="<%=parseNull(vo.inst_model)%>" required>
							</td>
						</tr>
						<tr>
							<th scope="row">악기명</th>
							<td>
								<label for="inst_name" class="blind">악기명</label>
								<input type="text" id="inst_name" name="inst_name" value="<%=parseNull(vo.inst_name)%>" required>
							</td>
						</tr>
						<tr>
							<th scope="row">악기위치</th>
							<td>
								<label for="inst_lca" class="blind">악기위치</label>
								<input type="text" id="inst_lca" name="inst_lca" value="<%=parseNull(vo.inst_lca)%>" required>
							</td>
						</tr>
						<tr>
							<th scope="row">악기대여량</th>
							<td>
								<label for="curr_cnt" class="blind">악기대여량</label>
								<input type="text" id="curr_cnt" name="curr_cnt" value="<%=parseNull(Integer.toString(vo.curr_cnt))%>" required>
							</td>
						</tr>
						<tr>
							<th scope="row">악기총량</th>
							<td>
								<label for="max_cnt" class="blind">악기총량</label>
								<input type="text" id="max_cnt" name="max_cnt" value="<%=parseNull(Integer.toString(vo.max_cnt))%>" required>
							</td>
						</tr>
						<tr>
							<th scope="row">노출여부</th>
							<td>
								<label for="show_flag" class="blind">노출 여부</label>
								<span class="magR10"><input type="radio" id="show_flag1" name="show_flag" value="Y" <%if("Y".equals(vo.show_flag)){%> checked="checked" <%}%> required><label for="show_flag1">Y</label></span>
								<span><input type="radio" id="show_flag2" name="show_flag" value="N" <%if("N".equals(vo.show_flag)){%> checked="checked" <%}%> required><label for="show_flag2">N</label></span>
							</td>
						</tr>
						<tr>
							<th scope="row">악기 상세 내용</th>
							<td>
								<label for="inst_memo" class="blind">악기 상세 내용</label>
								<textarea class="wps_90 h100" id="inst_memo" name="inst_memo" required><%=parseNull(vo.inst_memo)%></textarea>
							</td>
						</tr>
						</tbody>
					</table>
					<p class="btn_area txt_c">
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
