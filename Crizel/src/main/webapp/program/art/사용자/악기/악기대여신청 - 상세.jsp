<%
/**
*   PURPOSE :   악기 대여신청 - 상세
*   CREATE  :   20180207_wed    Ko
*   MODIFY  :   20180222 LJH 마크업, css클래스 수정
**/
%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*"%>
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
    	vo.inst_nm			= rs.getString("INST_NM");
    	vo.inst_req_cnt		= rs.getInt("INST_REQ_CNT");
    	vo.req_inst_cnt		= rs.getInt("REQ_INST_CNT");
    	vo.max_cnt			= rs.getInt("MAX_CNT");
    	vo.curr_cnt			= rs.getInt("CURR_CNT");

        return vo;
    }
}
%>

<%
String listPage 	= "DOM_000002001003003000";		//악기대여신청 - 목록
//String listPage 	= "DOM_000000126003003000";		//테스트서버

String writePage 	= "DOM_000002001003003001";		//악기대여신청 - 등록/수정
//String writePage 	= "DOM_000000126003003001";		//테스트서버


StringBuffer sql		= null;
List<InsVO> list 		= null;
List<InsVO> list2 		= null;
List<InsVO> list3 		= null;
InsVO vo			 	= new InsVO();
String search1		= parseNull(request.getParameter("search1"));		//승인상태
String search2		= parseNull(request.getParameter("search2"));		//악기명,신청자명
String keyword		= parseNull(request.getParameter("keyword"));
String getId 		= sm.getId();
String mode 		= parseNull(request.getParameter("mode"), "clientInsert");
String req_no 		= parseNull(request.getParameter("req_no"));

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
	function updateSubmit() {
		location.href = "/index.gne?menuCd=<%=writePage%>&mode=update&req_no=<%=req_no%>";	
	}

	function cancelSubmit() {
		if(confirm("신청을 취소하시겠습니까?")){
			$("#mode").val("apply");
			$("#apply_flag").val("C");
			$("#pageType").val("client");
			$("#postForm").attr("action", "/program/art/insAdmin/instMngAction.jsp").submit();
		}else{
			return false;
		}
	}

	function listSubmit() {
		location.href = "/index.gne?menuCd=<%=listPage%>";	
	}

	function applySubmit(req_no, apply_flag, inst_no){
		var msg;

		if(apply_flag == "Y"){
			msg = "악기대여 신청을 승인하시겠습니까?";
		}else if(apply_flag == "A"){
			msg = "악기대여 신청을 취소하시겠습니까?";
		}else if(apply_flag == "R"){
			msg = "악기대여 상태를 반납으로 변경하시겠습니까?";
		}

		if(confirm(msg)){
			location.href="/program/art/insAdmin/instMngAction.jsp?mode=apply&req_no="+req_no+"&apply_flag="+apply_flag+"&inst_no="+inst_no+"&pageType=client";
		}else{
			return false;
		}
	}
</script>
<section class="music_rentDetail">
	<form id="postForm" method="post">
		<input type="hidden" id="mode" name="mode" value="<%=mode%>">
		<input type="hidden" id="reg_id" name="reg_id" value="<%=sm.getId()%>">
		<input type="hidden" id="req_id" name="req_id" value="<%=sm.getId()%>">
		<input type="hidden" id="reg_ip" name="reg_ip" value="<%=request.getRemoteAddr()%>">
		<input type="hidden" id="req_no" name="req_no" value="<%=vo.req_no%>">
		<input type="hidden" id="pageType" name="pageType">
		<input type="hidden" id="apply_flag" name="apply_flag">
		<table class="table_skin01 td-l fsize_90">
			<caption>악기대여신청 상세보기 테이블</caption>
			<colgroup>
			<col style="width:0%;">
			<col />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">대여악기명</th>
					<td>
						<label for="inst_cat_nm" class="blind">대여악기명</label>
					<%
					for(int i=0; i<list3.size(); i++){
							InsVO vo2 = list3.get(i);
					%>
						<table class="bbs_list2 mag0 td-c"><!-- 악기 추가 테이블 -->
							<caption>신청한 악기종류와 대여량 </caption>
							<colgroup>
								<col />
								<col style="width:25%">
								<col style="width:25%">
							</colgroup>
								<thead>
									<tr>
										<th scope="col">분류/악기명</th>
										<th scope="col">남은량/총량</th>
										<th scope="col">대여량</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>
											<%=vo2.inst_cat_nm%> 	<input type="hidden" id="inst_cat_nm" name="inst_cat_nm" value="<%=vo2.inst_cat_nm %>"> /
											<%=vo2.inst_nm%>		<input type="hidden" id="inst_no" name="inst_no" value="<%=vo2.inst_no %>">
										</td>
										<td>
											<%=vo2.max_cnt - vo2.curr_cnt%> / <%=vo2.max_cnt %>	<input type="hidden" id="max_cnt" name="max_cnt" value="<%=vo2.max_cnt %>">
										</td>
										<td>
											<%if(vo2.req_inst_cnt > 0){%>
											<%=parseNull(Integer.toString(vo2.inst_req_cnt))%>
											<%}else{ %>
												0
											<%} %>
											<input type="hidden" id="req_inst_cnt" name="req_inst_cnt" value="0">
										</td>
									</tr>
								</tbody>
							</table>
						<%}%>
					</td>
				</tr>
				<tr>
					<th scope="row">신청자명</th>
					<td>
						<label for="req_mng_nm" class="blind">신청자명</label>
						<%=parseNull(vo.req_mng_nm) %>
						<input type="hidden" id="req_mng_nm" name="req_mng_nm" value="<%=parseNull(vo.req_mng_nm) %>">
					</td>
				</tr>
				<tr>
					<th scope="row">단체명/대리인</th>
					<td>
						<label for="req_group" class="blind">단체명/대리인</label>
						<%=parseNull(vo.req_group) %>
						<input type="hidden" id="req_group" name="req_group" value="<%=parseNull(vo.req_group) %>">
					</td>
				</tr>
				<tr>
					<th scope="row">연락처</th>
					<td>
						<label for="req_mng_tel" class="blind">연락처</label>
						<%=telSet(parseNull(vo.req_mng_tel)) %>
						<input type="hidden" id="req_mng_tel" name="req_mng_tel" value="<%=parseNull(vo.req_mng_tel) %>">
					</td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td>
						<label for="req_mng_mail" class="blind">이메일</label>
						<%=parseNull(vo.req_mng_mail) %>
						<input type="hidden" id="req_mng_mail" class="wps_80" name="req_mng_mail" value="<%=parseNull(vo.req_mng_mail) %>">
					</td>
				</tr>
				<tr>
					<th scope="row">내용</th>
					<td>
						<label for="req_memo" class="blind">내용</label>
						<%=parseNull(vo.req_memo).replace("\n", "<br>")%>
						<input type="hidden" id="req_memo" name="req_memo" value="<%=parseNull(vo.req_memo) %>">
					</td>
				</tr>
				<%if("N".equals(vo.apply_flag) || "Y".equals(vo.apply_flag)){ %>
				<tr>
					<th scope="row">신청취소</th>
					<td>
						<label for="req_memo" class="blind">신청취소</label>
						<button type="button" class="btn small edge red" onclick="cancelSubmit()">신청취소</button></td>
				</tr>
				<%} %>
				<%if(cm.isMenuCmsManager(sm)){ %>
				<tr>
					<th scope="row">상태</th>
					<td>
						<%--<label for="apply_flag" class="blind">상태</label>
						<select id="apply_flag" name="apply_flag">
							<option value="N" <%if("N".equals(vo.apply_flag)){%> selected <%}%>>승인대기</option>
							<option value="Y" <%if("Y".equals(vo.apply_flag)){%> selected <%}%>>승인완료</option>
							<option value="A" <%if("A".equals(vo.apply_flag)){%> selected <%}%>>관리자취소</option>
							<option value="C" <%if("C".equals(vo.apply_flag)){%> selected <%}%>>취소</option>
						</select>--%>
						<label for="apply_flag">
						<%
						if("N".equals(vo.apply_flag)){
							out.println("승인대기");
						} else if("Y".equals(vo.apply_flag)){
							out.println("승인완료");
						} else if("A".equals(vo.apply_flag)){
							out.println("관리자취소");
						} else if("C".equals(vo.apply_flag)){
							out.println("취소");
						} else if("R".equals(vo.apply_flag)){
							out.println("반납완료");
						}
						%>
						</label>

						<%
						if("N".equals(vo.apply_flag)){
						%>
							<button type="button" class="btn small edge mako" onclick="applySubmit('<%=vo.req_no%>', 'Y', '<%=vo.inst_no%>')">승인</button>
							<button type="button" class="btn small edge white" onclick="applySubmit('<%=vo.req_no%>', 'A', '')">취소</button>
						<%
						}else if("Y".equals(vo.apply_flag)){
						%>
							<button type="button" class="btn small edge white" onclick="applySubmit('<%=vo.req_no%>', 'A', '')">취소</button>
							<button type="button" class="btn small edge green" onclick="applySubmit('<%=vo.req_no%>', 'R', '')">반납</button>
						<%
						}else if("A".equals(vo.apply_flag)){		//관리자 취소
						%>
							관리자 취소
						<%
						}else if("C".equals(vo.apply_flag)){		//사용자 취소
						%>
							사용자 취소
						<%
						}
						%>
					</td>
				</tr>
				<%} %>
			</tbody>
		</table>
	</form>
	<div class="btn_area c">
		<input type="button" class="btn medium edge white" onclick="listSubmit()" value="목록" title="목록">
		<%if("".equals(parseNull(vo.apply_flag)) || "N".equals(parseNull(vo.apply_flag))){%>
		<input type="submit" class="btn medium edge darkMblue w_100" onclick="updateSubmit()" value="수정" title="수정">
		<%} %>
	</div>
</section>