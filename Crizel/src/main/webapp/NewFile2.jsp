<%
/**
*   PURPOSE :   악기 대여신청 - 등록/수정
*   CREATE  :   20180206_tue    Ko
*   MODIFY  :   20180222 ljh 마크업 수정
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
    	vo.inst_nm		= rs.getString("INST_NM");
    	vo.inst_req_cnt		= rs.getInt("INST_REQ_CNT");
    	vo.req_inst_cnt		= rs.getInt("REQ_INST_CNT");
    	vo.max_cnt			= rs.getInt("MAX_CNT");
    	vo.curr_cnt			= rs.getInt("CURR_CNT");

        return vo;
    }
}

private class InstCount implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
    	vo.max_cnt			= rs.getInt("MAX_CNT");
    	vo.curr_cnt			= rs.getInt("CURR_CNT");
        return vo;
    }
}
%>
<%
StringBuffer sql		= null;
List<InsVO> list 		= null;
List<InsVO> list2 		= null;
List<InsVO> list3 		= null;
List<InsVO> instList	= null;

InsVO vo			 	= new InsVO();
InsVO instCount			= null;
String search1		= parseNull(request.getParameter("search1"));
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


	if(!"".equals(search1)){
		sql = new StringBuffer();
		sql.append("SELECT INST_NO, INST_NAME 						");
		sql.append("FROM ART_INST_MNG 								");
		sql.append("WHERE SHOW_FLAG = 'Y' AND DEL_FLAG = 'N'		");
		sql.append("	AND INST_CAT_NM = ?							");
		sql.append("ORDER BY INST_NO DESC							");

		instList = jdbcTemplate.query(
					sql.toString(),
					new Object[]{search1},
					new InsVOMapper3()
				);

		sql = new StringBuffer();
		sql.append("SELECT CURR_CNT, MAX_CNT 						");
		sql.append("FROM ART_INST_MNG 								");
		sql.append("WHERE INST_CAT_NM = ? AND INST_NAME =?	 		");

		instCount = jdbcTemplate.queryForObject(
					sql.toString(),
					new Object[]{search1, keyword},
					new InstCount()
				);
	}
}catch(Exception e){
	out.println(e.toString());
}


%>
<script>
	function instSelect(inst_cat_nm, cnt){
		var htmlVal = "";

		$.ajax({
			type : "POST",
			url : "/program/art/insAdmin/instNmSelect.jsp",
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
			url : "/program/art/insAdmin/instGetCnt.jsp",
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
				$("#curr_cnt_"+cnt).val(curr_cnt);		
				$("#max_cnt_"+cnt).val(max_cnt);
				$("#now_cnt_"+cnt).val(now_cnt);
			},
			error:function(request,status,error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	}

	function insertSubmit() {
		if(confirm("등록하시겠습니까?")){
			$("#postForm").attr("action", "/program/art/insAdmin/instMngAction.jsp");
			return true;
		}else{
			return false;
		}

	}

	function listSubmit() {
		location.href = "/index.gne?menuCd=DOM_000002001003003000";	// 악기대여 신청 목록
		//location.href = "/index.gne?menuCd=DOM_000000126003003000";	// 악기대여 신청 목록_테스트서버
	}

	function addSelect(){
		var cnt = $("#addBlock #countBox").length;
		var html = "";

		html += '<div id="selectBlock_'+cnt+'">';
		html += '<table class="bbs_list2 td-c mag0"><caption>악기별 총량과 잔여량, 대여량 입력표입니다.</caption><colgroup><col /><col style="width:25%"><col style="width:25%"></colgroup>';
		html += '<thead><tr><th scope="col">악기 선택</th><th scope="col">대여수 / 보유수</th><th scope="col">대여량</th></tr></thead>';
		html += '<tbody><tr>';
		html += '<td><input type="hidden" id="countBox" class="blind">';
		html += '<label for="inst_cat_nm_'+cnt+'" class="blind">분류선택</label><select id="inst_cat_nm_'+cnt+'" name="inst_cat_nm" onchange="instSelect(this.value, '+cnt+')" required>';
		html += '<option value="">분류선택</option>';
		html += '<%if(list!=null && list.size()>0){for(InsVO ob : list){%>	';
		html += '<option value="<%=ob.code_val1%>"><%=ob.code_val1 %></option>	';
		html += ' <%}}%>';
		html += '</select> ';
		html += '<label for="inst_no_'+cnt+'" class="blind">악기선택</label><select id="inst_no_'+cnt+'" name="inst_no" onchange="instGetCnt(this.value, '+cnt+')"  required>';
		html += '<option value="">악기선택</option>';
		html += '</select></td>';
		html += '<td><label for="curr_cnt_'+cnt+'" class="blind">대여수</label><input type="text" id="curr_cnt_'+cnt+'" name="curr_cnt" class="w_40" value="" readonly> / <label for="max_cnt_'+cnt+'" class="blind">보유수</label><input type="text" id="max_cnt_'+cnt+'" class="w_40" name="max_cnt" value="" readonly></td>';
		html += '<td><label for="req_inst_cnt_'+cnt+'" class="blind">대여량</label><input type="text" id="req_inst_cnt_'+cnt+'" name="req_inst_cnt" class="w_50" value="" required></td></tr>'
		html += '</tr></tbody>';
		html += '</table>';
		html += '<div class="btn_area magT5 magB10">';
		html += '<button type="button" class="btn small edge mako" onclick="addSelect()">+ 추가</button><button type="button" class="btn small edge white" onclick="removeSelect('+cnt+')">- 삭제</button>';
		html += '</div>';
		html += '</div>';

		$("#addBlock").append(html);
	}

	function removeSelect(cnt){
		$("#selectBlock_"+cnt).remove();
	}

	$(function(){
		$('#req_mng_tel').keyup(function(){this.value = this.value.replace(/[^0-9]/g,'');});
	});
</script>
<section class="music_rentForm">
	<h3 class="blind">악기대여 신청 입력</h3>
	<form id="postForm" method="post" onsubmit="return insertSubmit();">
		<input type="hidden" id="mode" name="mode" value="<%=mode%>">
		<input type="hidden" id="reg_id" name="reg_id" value="<%=sm.getId()%>">
		<input type="hidden" id="req_id" name="req_id" value="<%=sm.getId()%>">
		<input type="hidden" id="reg_ip" name="reg_ip" value="<%=request.getRemoteAddr()%>">
		<input type="hidden" id="req_no" name="req_no" value="<%=vo.req_no%>">
		<input type="hidden" id="pageType" name="pageType" value="client">
		<table class="table_skin01 td-l fsize_90">
			<caption>악기대여신청 등록 테이블</caption>
			<colgroup>
				<col style="width:150px;">
				<col />
			</colgroup>
			<tbody>
				<%if(!"".equals(req_no) && list3!=null && list3.size()>0){ %>		<!-- 수정 -->
						<tr>
							<th scope="row">악기 분류/<br>악기선택/<br>악기총량 </th>
							<td>
								<label for="inst_cat_nm_0" class="dis_mo">악기 분류/악기선택/악기총량</label>
				                <div id="addBlock">
				                <%
						          for(int i=0; i<list3.size(); i++){
						              InsVO vo2 = list3.get(i);
						          %>
								          <table class="bbs_list2 mag0 td-c">	<!-- 악기 추가 테이블 -->
										  <caption>악기별 총량과 잔여량, 대여량 입력표입니다.</caption>
							              <colgroup>
							                  <col />
							                  <col style="width:25%">
							                  <col style="width:25%">
							              </colgroup>
									    <thead>
											<tr>
												<th scope="col">악기선택</th>
												<th scope="col">대여수 / 보유수</th>
												<th scope="col">대여량</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>
													<input type="hidden" id="countBox" class="blind">
													<label for="inst_cat_nm_<%=i%>" class="blind">분류선택</label>
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
													<label for="inst_no_<%=i%>" class="blind">악기선택</label>
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
												<td>
													<label for="curr_cnt_<%=i%>" class="blind">대여수</label>
													<input type="text" id="curr_cnt_<%=i%>" class="w_40" name="curr_cnt" value="<%=vo2.curr_cnt%>" readonly> / 
													<label for="max_cnt_<%=i%>" class="blind">보유수</label>
													<input type="text" id="max_cnt_<%=i%>" class="w_40" name="max_cnt" value="<%=vo2.max_cnt%>" readonly>
												</td>
												<td><label for="req_inst_cnt_<%=i%>" class="blind">대여량</label>
													<input type="text" id="req_inst_cnt_<%=i%>" class="w_50" name="req_inst_cnt"
													<%if(vo2.req_inst_cnt > 0){%>value="<%=parseNull(Integer.toString(vo2.inst_req_cnt))%>"
													<%}else{ %>  value="0"
													<%} %>
													 required>
												</td>
											</tr>
										</tbody>
									</table>
					        		<div class="btn_area magT5 magB10">
										<button type="button" class="btn small edge mako" onclick="addSelect()">+ 추가</button>
									</div>
								<%}%>
								<!-- ./악기 추가 table-->
								</div>
							</td>
						</tr>
						<%} %>

						<%if("".equals(req_no)){ %>		<!-- 등록 -->
						<tr>
							<th scope="row">악기 분류/<br>악기선택/<br>악기총량</th>
							<td>
								<label for="inst_cat_nm_0" class="dis_mo">악기 분류/악기선택/악기총량</label>
							  <div id="addBlock">
                  <table class="bbs_list2 td-c mag0"><!-- 악기 추가 테이블 -->
										<caption>악기별 총량과 잔여량, 대여량 입력표입니다.</caption>
										<colgroup>
		                  <col />
		                  <col style="width:25%">
		                  <col style="width:25%">
			              </colgroup>
										<thead>
											<tr>
												<th scope="col">악기선택</th>
												<th scope="col">대여수 / 보유수</th>
												<th scope="col">대여량</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>
													<input type="hidden" id="countBox" class="blind">
													<label for="inst_cat_nm_0" class="blind">분류선택</label>
													<select id="inst_cat_nm_0" name="inst_cat_nm" onchange="instSelect(this.value, 0)" required>
													<option value="">분류선택</option>
													<%
													if(list!=null && list.size()>0){
													for(InsVO ob : list){
													%>
															<option value="<%=ob.code_val1%>" <%if(ob.code_val1.equals(search1)){%> selected="selected" <%}%> ><%=ob.code_val1 %></option>
													<%
													}
													}
													%>
													</select>

													<label for="inst_no_0" class="blind">악기선택</label>
													<select id="inst_no_0" name="inst_no" onchange="instGetCnt(this.value, 0)"  required>
															<option value="">악기선택</option>
													<%
													if(instList!=null && instList.size()>0){
													for(InsVO ob : instList){
													%>
															<option value="<%=ob.inst_no%>" <%if(ob.inst_name.equals(keyword)){%> selected="selected" <%}%> ><%=ob.inst_name %></option>
													<%
													}
													}
													%>
													</select>
												</td>
												<%
												int currCnt	= 0;
												int maxCnt	= 0;
												if(!"".equals(search1)){
													currCnt	= instCount.curr_cnt;
													maxCnt	= instCount.max_cnt;
												}
												%>
												<td>
													<label for="curr_cnt_0" class="blind">대여수</label>
													<input type="text" id="curr_cnt_0" class="w_40" name="curr_cnt" value="<%=currCnt%>" readonly> /
													<label for="max_cnt_0" class="blind">보유수</label>
													<input type="text" id="max_cnt_0" class="w_40" name="max_cnt" value="<%=maxCnt%>" readonly></td>
												<td><label for="req_inst_cnt_0" class="blind">대여량</label><input type="text" id="req_inst_cnt_0" name="req_inst_cnt" class="w_50" value="0" required></td>
											</tr>
										</tbody>
                  					</table>
									<div class="btn_area magT5 magB10">
										<button type="button" class="btn small edge mako" onclick="addSelect()">+ 추가</button>
									</div>
                				</div>
							</td>
						</tr>
						<%} %>
				<tr>
					<th scope="row"><span class="red">*</span> 신청자명</th>
					<td>
						<label for="req_mng_nm" class="dis_mo"><span class="red">*</span> 신청자명</label>
						<input type="text" id="req_mng_nm" name="req_mng_nm" required value="<%=parseNull(vo.req_mng_nm) %>">
					</td>
				</tr>
				<tr>
					<th scope="row"><span class="red">*</span> 단체명/대리인</th>
					<td>
						<label for="req_group" class="dis_mo"><span class="red">*</span> 단체명/대리인</label>
						<input type="text" id="req_group" name="req_group" required value="<%=parseNull(vo.req_group) %>">
					</td>
				</tr>
				<tr>
					<th scope="row"><span class="red">*</span> 연락처</th>
					<td>
						<label for="req_mng_tel" class="dis_mo"><span class="red">*</span> 연락처</label>
						<input type="text" id="req_mng_tel" name="req_mng_tel" required value="<%=parseNull(vo.req_mng_tel) %>">
						<span class="blue fsize_90">&#8251; '-'를 제외한 숫자만 입력하세요. (예: 05512345678)</span>
					</td>
				</tr>
				<tr>
					<th scope="row"><span class="red">*</span> 이메일</th>
					<td>
						<label for="req_mng_mail" class="dis_mo"><span class="red">*</span> 이메일</label>
						<input type="text" id="req_mng_mail" class="wps_80" name="req_mng_mail" required value="<%=parseNull(vo.req_mng_mail) %>">
					</td>
				</tr>
				<tr>
					<th scope="row">내용</th>
					<td>
						<label for="req_memo" class="dis_mo">내용</label>
						<textarea class="wps_95 h180" id="req_memo" name="req_memo" required><%=parseNull(vo.req_memo)%></textarea>
					</td>
				</tr>
				<%--
				<%if(cm.isMenuCmsManager(sm)){ %>
				<tr>
					<th scope="row"><label for="apply_flag">상태 </label></th>
					<td>
						<select id="apply_flag" name="apply_flag">
							<option value="N" <%if("N".equals(vo.apply_flag)){%> <%}%>>승인대기</option>
							<option value="Y" <%if("Y".equals(vo.apply_flag)){%> <%}%>>승인완료</option>
							<option value="A" <%if("A".equals(vo.apply_flag)){%> <%}%>>관리자취소</option>
							<option value="C" <%if("C".equals(vo.apply_flag)){%> <%}%>>취소</option>
						</select>
					</td>
				</tr>
				<%} %>
				 --%>
			</tbody>
		</table>
	<div class="btn_area c">
		<%if("".equals(parseNull(vo.apply_flag)) || "N".equals(parseNull(vo.apply_flag))){%>
		<input type="submit" class="btn medium darkMblue edge w_100"  value="확인" >
		<%} %>
	</form>
		<input type="button" onclick="listSubmit()" class="btn medium white edge" value="취소">
	</div>

</section>