<%
/**
*   PURPOSE :   악기 신청관리
*   CREATE  :   20180201_thur    Ko
*   MODIFY  :   ....
**/
%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
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
    	
    	vo.inst_cat			= rs.getString("INST_CAT");	
    	vo.inst_cat_nm		= rs.getString("INST_CAT_NM");	
    	vo.inst_no			= rs.getInt("INST_NO");	
    	vo.inst_nm			= rs.getString("INST_NM");	
    	vo.inst_req_cnt		= rs.getInt("INST_REQ_CNT");	
        return vo;
    }
}
%>
<%
StringBuffer sql	= null;
List<InsVO> list 	= null;
String search1		= parseNull(request.getParameter("search1"));
String keyword		= parseNull(request.getParameter("keyword"));
String menuCd		= parseNull(request.getParameter("menuCd"));

Paging paging = new Paging();
paging.setPageSize(20);
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
int cnt=0;
int num = 0;

sql = new StringBuffer();
sql.append("		SELECT	COUNT(*) CNT		 							");
sql.append("		FROM ART_INST_REQ A LEFT JOIN ART_INST_REQ_CNT B		");
sql.append("		ON A.REQ_NO = B.REQ_NO									");
sql.append("		WHERE 1=1					 							");
if(!"".equals(search1) && !"".equals(keyword)){
	if("inst_cat_nm".equals(search1)){
		sql.append("	AND B.INST_CAT_NM = '").append(keyword).append("'	");
	}else if("req_mng_nm".equals(search1)){
		sql.append("	AND A.REQ_MNG_NM = '").append(keyword).append("'	");
	}
paging.setParams("search1", search1);
paging.setParams("keyword", keyword);
}

totalCount = jdbcTemplate.queryForObject(
		sql.toString(),
		Integer.class
	);

paging.setPageNo(Integer.parseInt(pageNo));
paging.setTotalCount(totalCount);

sql = new StringBuffer();
sql.append("SELECT * FROM(													");
sql.append("	SELECT ROWNUM AS RNUM, A.* FROM (							");
sql.append("		SELECT			 										");
sql.append("			A.REQ_NO,				 							");
sql.append("			A.REQ_ID,				 							");
sql.append("			A.REQ_GROUP,				 						");
sql.append("			A.REQ_MNG_NM,				 						");
sql.append("			A.REQ_MNG_TEL,				 						");
sql.append("			A.REQ_INST_CNT,				 						");
sql.append("			A.REQ_MEMO,				 							");
sql.append("			A.REG_IP,				 							");
sql.append("			A.REG_DATE,				 							");
sql.append("			A.SHOW_FLAG,				 						");
sql.append("			B.INST_CAT,				 							");
sql.append("			B.INST_CAT_NM,				 						");
sql.append("			B.INST_NO,				 							");
sql.append("			B.INST_NM,				 							");
sql.append("			B.INST_REQ_CNT				 						");
sql.append("		FROM ART_INST_REQ A LEFT JOIN ART_INST_REQ_CNT B		");
sql.append("		ON A.REQ_NO = B.REQ_NO									");
sql.append("		WHERE 1=1					 							");
if(!"".equals(search1) && !"".equals(keyword)){
	if("inst_cat_nm".equals(search1)){
		sql.append("	AND B.INST_CAT_NM = '").append(keyword).append("'	");
	}else if("req_mng_nm".equals(search1)){
		sql.append("	AND A.REQ_MNG_NM = '").append(keyword).append("'	");
	}
paging.setParams("search1", search1);
paging.setParams("keyword", keyword);
}
sql.append("ORDER BY A.REQ_NO DESC			 								");
sql.append("	) A WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" \n");
sql.append(") WHERE RNUM >= ").append(paging.getStartRowNo()).append(" \n	");

list = jdbcTemplate.query(
			sql.toString(), 
			new InsVOMapper()
		);

num = paging.getRowNo();
%>
<script>
function newWin(url, title, w, h){
	var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
    var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;
 
    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
 
    var left = ((width / 2) - (w / 2)) + dualScreenLeft;
    var top = ((height / 2) - (h / 2)) + dualScreenTop;
    var newWindow = window.open(url, title, 'scrollbars=yes, resizable=yes, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
 
}

function searchSubmit(){
	$("#searchForm").attr("action", "").submit();
}
function getPopup(type){
	var addr = "/program/art/insAdmin/instMngPopup.jsp";
	newWin(addr, 'PRINTVIEW', '1000', '740');
}

function approvalSubmit(req_no){
	var addr = "/program/art/insAdmin/instMngPopup.jsp?mode=update&req_no="+req_no;
	newWin(addr, 'PRINTVIEW', '1000', '740');
	//window.open(addr,"PRINTVIEW","width=1000px,height=740px, status=yes, scrollbars=yes, resizable=yes");
}

function cancelSubmit(req_no){
	if(confirm("프로그램을 삭제하시겠습니까?")){
		location.href="/program/art/insAdmin/instMngPopup.jsp?mode=delete&req_no="+req_no;
	}else{
		return false;
	}
}

</script>
<section class="board">
	<div class="search" style="text-align: left;">
		<form id="searchForm" method="get">
			<fieldset>
				<input type="hidden" id="menuCd" name="menuCd" value="<%=menuCd%>">
				<label for="search1">검색분류</label> 
				<select id="search1" name="search1">
					<option value="">선택</option>
					<option value="inst_cat_nm" <%if("inst_cat_nm".equals(search1)){%> selected="selected" <%}%>>분류명</option>
					<option value="req_mng_nm" <%if("req_mng_nm".equals(search1)){%> selected="selected" <%}%>>담당자명</option>
				</select>
				<label for="keyword">검색어</label> 
				<input type="text" id="keyword" name="keyword" value="<%=keyword%>">
				<button onclick="searchSubmit();">검색하기</button>
			</fieldset>
		</form>
	</div>
	<div class="search">
		<button onclick="getPopup('artcode');">신청관리</button>
	</div>
	<p>
		<strong>총 <span><%=totalCount%></span> 건
		</strong> [ Page <%=pageNo %>/<%=paging.getFinalPageNo() %>]
	</p>
	<table class="tb_board">
		<caption>악기 신청관리 테이블</caption>
		<colgroup>
		</colgroup>
		<thead>
			<tr>
				<th scope="col">순서</th>
				<th scope="col">분류</th>
				<th scope="col">악기명</th>
				<th scope="col">대여수</th>
				<th scope="col">신청자</th>
				<th scope="col">그룹명</th>
				<th scope="col">연락처</th>
				<th scope="col">등록일</th>
				<th scope="col" class="rfc_bbs_list_last">수정/승인</th>
			</tr>
		</thead>
		<tbody>
			<%
			if(list!=null && list.size()>0){
			for(InsVO ob : list){ %>
			<tr>
				<td><%=num--%></td>
				<td><%=ob.inst_cat_nm%></td>
				<td><%=ob.inst_nm %></td>
				<td><%=ob.inst_req_cnt %></td>
				<td><%=ob.req_id %>/<%=ob.req_mng_nm %></td>
				<td><%=ob.req_group %></td>
				<td><%=telSet(ob.req_mng_tel)%></td>
				<td><%=ob.reg_date %></td>
				<td>
					<button type="button" onclick="approvalSubmit('<%=ob.req_no%>')">수정</button>
					<button type="button" onclick="cancelSubmit('<%=ob.req_no%>')">승인</button>
				</td>
			</tr>
			<%
			}
			}else{
			%>
			<tr>
				<td colspan="9">등록된 게시물이 없습니다.</td>
			</tr>
			<%
			} 
			%>
		</tbody>
	</table>
	
	<% if(paging.getTotalCount() > 0) { %>
	<div class="pageing">
		<%=paging.getHtml("2") %>
	</div>
	<% } %>
</section>