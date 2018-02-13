
<%
/**
*   PURPOSE :   악기 대여신청 - 상세
*   CREATE  :   20180207_wed    Ko
*   MODIFY  :   ....
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
		sql.append("WHERE A.REQ_NO = ").append(req_no).append("						");
		vo = jdbcTemplate.queryForObject(
					sql.toString(), 
					new InsVOMapper()
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
	function updateSubmit() {
		location.href = "/index.gne?menuCd=DOM_000000126003003001&mode=update&req_no=<%=req_no%>";	// 악기대여 신청 목록_테스트서버
	}
	
	function cancelSubmit() {
		if(confirm("신청을 취소하시겠습니까?")){
			$("#mode").val("apply");
			$("#apply_flag").val("C");
			$("#postForm").attr("action", "/program/art/insAdmin/instMngAction.jsp").submit();
		}else{
			return false;
		}
	}
	
	function listSubmit() {
		location.href = "/index.gne?menuCd=DOM_000000126003003000";	// 악기대여 신청 목록_테스트서버
	}
	
	function applySubmit(req_no, apply_flag, inst_no){
		var msg;
		
		if(apply_flag == "N"){
			msg = "악기대여 신청을 승인하시겠습니까?";
			apply_flag = "Y";
		}else if(apply_flag == "Y"){
			msg = "악기대여 신청을 취소하시겠습니까?";
			apply_flag = "A";
		}
		
		if(confirm(msg)){
			location.href="/program/art/insAdmin/instMngAction.jsp?mode=apply&req_no="+req_no+"&apply_flag="+apply_flag+"&inst_no="+inst_no+"&pageType=client";
		}else{
			return false;
		}
	}
</script>
<section class="board">
	<form id="postForm" method="post">
		<input type="hidden" id="mode" name="mode" value="<%=mode%>">
		<input type="hidden" id="reg_id" name="reg_id" value="<%=sm.getId()%>">
		<input type="hidden" id="req_id" name="req_id" value="<%=sm.getId()%>">
		<input type="hidden" id="reg_ip" name="reg_ip" value="<%=request.getRemoteAddr()%>">
		<input type="hidden" id="req_no" name="req_no" value="<%=vo.req_no%>">
		<table class="board_read02">
			<caption>악기대여신청 상세보기 테이블</caption>
			<colgroup>
			<col style="width: 30%;">
			<col style="width: 70%;">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><label for="inst_cat_nm">대여악기명</label></th>
					<td>
						<table><!-- 악기 추가 테이블 -->
	                         <colgroup>
	                             <col width="10%">
	                             <col width="25%">
	                             <col width="10%">
	                             <col width="25%">
	                             <col width="10%">
	                             <col width="20%">
	                         </colgroup>
                                <%
                                for(int i=0; i<list3.size(); i++){
                                    InsVO vo2 = list3.get(i);
                                %>
                                    <tr>
                                        <th >분류</th>
                                        <td>
                                     		<%=vo2.inst_cat_nm%> 	<input type="hidden" id="inst_cat_nm" name="inst_cat_nm" value="<%=vo2.inst_cat_nm %>">
                                        </td>
                                        <th >악기명</th>
                                        <td >
                                        	<%=vo2.inst_nm%>		<input type="hidden" id="inst_no" name="inst_no" value="<%=vo2.inst_no %>">	
                                        </td>
                                    </tr>
									<tr>
                                        <th>대여량</th>
                                        <td>
                                        	<%if(vo2.req_inst_cnt > 0){%>
												<%=parseNull(Integer.toString(vo2.inst_req_cnt))%> 
	                                      	<%}else{ %>  
	                                      		0                                        
	                                      	<%} %>
	                                      	<input type="hidden" id="req_inst_cnt" name="req_inst_cnt" value="0">	
                                        </td>
                                        <th>남은량</th>
                                        <td><%=vo2.max_cnt - vo2.curr_cnt%></td>
                                        <th>총량</th>
                                        <td><%=vo2.max_cnt %>	<input type="hidden" id="max_cnt" name="max_cnt" value="<%=vo2.max_cnt %>"></td>
                                    </tr>
									<%}%>
								</table>
					</td>
				</tr> 
				<tr>
					<th scope="row"><label for="req_mng_nm">신청자명</label></th>
					<td>
						<%=parseNull(vo.req_mng_nm) %>
						<input type="hidden" id="req_mng_nm" name="req_mng_nm" value="<%=parseNull(vo.req_mng_nm) %>">
					</td>
				</tr> 
				<tr>
					<th scope="row"><label for="req_group">단체명/대리인</label></th>
					<td>
						<%=parseNull(vo.req_group) %>
						<input type="hidden" id="req_group" name="req_group" value="<%=parseNull(vo.req_group) %>">
					</td>
				</tr>
				<tr>
					<th scope="row"><label for="req_mng_tel">연락처</label></th>
					<td>
						<%=telSet(parseNull(vo.req_mng_tel)) %>
						<input type="hidden" id="req_mng_tel" name="req_mng_tel" value="<%=parseNull(vo.req_mng_tel) %>">
					</td>
				</tr>
				<tr>
					<th scope="row"><label for="req_mng_mail">이메일</label></th>
					<td>
						<%=parseNull(vo.req_mng_mail) %>
						<input type="hidden" id="req_mng_mail" name="req_mng_mail" value="<%=parseNull(vo.req_mng_mail) %>">
					</td>
				</tr>
				<tr>
					<th scope="row"><label for="req_memo">내용</label></th>
					<td>
						<%=parseNull(vo.req_memo).replace("\n", "<br>")%>
						<input type="hidden" id="req_memo" name="req_memo" value="<%=parseNull(vo.req_memo) %>">
					</td>
				</tr> 
				<%if("N".equals(vo.apply_flag) || "Y".equals(vo.apply_flag)){ %>
				<tr>
					<th scope="row"><label for="req_memo">신청취소</label></th>
					<td><button type="button" onclick="cancelSubmit()">신청취소</button></td>
				</tr>
				<%} %>
				<%if(cm.isMenuCmsManager(sm)){ %>
				<tr>
					<th scope="row"><label for="apply_flag">상태 </label></th>
					<td>
						<select id="apply_flag" name="apply_flag">
							<option value="N" <%if("N".equals(vo.apply_flag)){%> selected <%}%>>승인대기</option>
							<option value="Y" <%if("Y".equals(vo.apply_flag)){%> selected <%}%>>승인완료</option>
							<option value="A" <%if("A".equals(vo.apply_flag)){%> selected <%}%>>관리자취소</option>
							<option value="C" <%if("C".equals(vo.apply_flag)){%> selected <%}%>>취소</option>
						</select>
						
						<%
						if("N".equals(vo.apply_flag)){
						%>
							<button type="button" onclick="applySubmit('<%=vo.req_no%>', '<%=vo.apply_flag%>', '<%=vo.inst_no%>')">승인</button>
						<%
						}else if("Y".equals(vo.apply_flag)){
						%>
							<button type="button" onclick="applySubmit('<%=vo.req_no%>', '<%=vo.apply_flag%>', '')">취소</button>
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
		<div class="rfc_bbs_btn">
			<input type="image" onclick="listSubmit()"   src="/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_btn_list.gif" alt="목록" title="목록"> 
			<%if("".equals(parseNull(vo.apply_flag)) || "N".equals(parseNull(vo.apply_flag))){%>
			<input type="image" onclick="updateSubmit()" src="/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_btn_modify.gif" alt="수정" title="수정">
			<%} %>
		</div>
</section>