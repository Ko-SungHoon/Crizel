<%
/**
*   PURPOSE :   승인대기 및 취소 - 상시
*   CREATE  :   20180130_tue    Ko
*   MODIFY  :   ....
**/
%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%!
private class ArtVO{
	public int req_no;
	public int pro_no;
	public String req_sch_id;
	public String sch_mng_nm;
	public String sch_mng_tel;
	public String sch_mng_mail;
	public String reg_date;
	public String mod_date;
	public String reg_ip;
	public String apply_flag;
	public int req_cnt;
	public String req_date;
	public String req_aft_flag;
	public String req_sch_nm;
	public String req_sch_grade;
	public String req_sch_group;
	
	public String pro_cat_nm;
	public String pro_name;
}
	
private class ArtVOMapper implements RowMapper<ArtVO> {
    public ArtVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ArtVO vo = new ArtVO();
        vo.req_no			= rs.getInt("REQ_NO");	
        vo.pro_no			= rs.getInt("PRO_NO");	
        vo.req_sch_id		= rs.getString("REQ_SCH_ID");
        vo.sch_mng_nm		= rs.getString("SCH_MNG_NM");
        vo.sch_mng_tel		= rs.getString("SCH_MNG_TEL");
        vo.sch_mng_mail		= rs.getString("SCH_MNG_MAIL");
        vo.reg_date			= rs.getString("REG_DATE");
        vo.mod_date			= rs.getString("MOD_DATE");
        vo.reg_ip			= rs.getString("REG_IP");
        vo.apply_flag		= rs.getString("APPLY_FLAG");
        vo.req_cnt			= rs.getInt("REQ_CNT");	
        vo.req_date			= rs.getString("REQ_DATE");
        vo.req_aft_flag		= rs.getString("REQ_AFT_FLAG");
        vo.req_sch_nm		= rs.getString("REQ_SCH_NM");
        vo.req_sch_grade	= rs.getString("REQ_SCH_GRADE");
        vo.req_sch_group	= rs.getString("REQ_SCH_GROUP");
        
        vo.pro_cat_nm		= rs.getString("PRO_CAT_NM");
        vo.pro_name			= rs.getString("pro_name");
        return vo;
    }
}
%>
<%
StringBuffer sql	= null;
List<ArtVO> list 	= null;
String search1		= parseNull(request.getParameter("search1"));
String keyword		= parseNull(request.getParameter("keyword"));
String menuCd		= parseNull(request.getParameter("menuCd"));

Paging paging = new Paging();
paging.setPageSize(20);
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
int cnt=0;
int num = 0;

Object[] setObj			= null;
List<String> setList	= new ArrayList<String>();

sql = new StringBuffer();
sql.append("		SELECT	COUNT(*) CNT		 							");
sql.append("		FROM ART_REQ_ALWAY A LEFT JOIN ART_PRO_ALWAY B			");
sql.append("		ON A.PRO_NO = B.PRO_NO									");
sql.append("		WHERE 1=1					 							");
if(!"".equals(search1) && !"".equals(keyword)){
	if("pro_cat_nm".equals(search1)){
		sql.append("	AND B.PRO_CAT_NM LIKE '%'||?||'%'					");
		setList.add(keyword);
	}else if("sch_mng_nm".equals(search1)){
		sql.append("	AND A.SCH_MNG_NM LIKE '%'||?||'%'					");
		setList.add(keyword);
	}else{
		sql.append("	AND A.REQ_SCH_NM LIKE '%'||?||'%'					");
		setList.add(keyword);
	}
paging.setParams("search1", search1);
paging.setParams("keyword", keyword);
}

setObj = new Object[setList.size()];
for(int i=0; i<setList.size(); i++){
	setObj[i] = setList.get(i);
}

totalCount = jdbcTemplate.queryForObject(
		sql.toString(),
		Integer.class,
		setObj
	);

paging.setPageNo(Integer.parseInt(pageNo));
paging.setTotalCount(totalCount);

sql = new StringBuffer();
sql.append("SELECT * FROM(													");
sql.append("	SELECT ROWNUM AS RNUM, A.* FROM (							");
sql.append("		SELECT			 										");
sql.append("			A.REQ_NO,			 								");
sql.append("			A.PRO_NO,			 								");
sql.append("			A.REQ_SCH_ID,			 							");
sql.append("			A.SCH_MNG_NM,			 							");
sql.append("			A.SCH_MNG_TEL,			 							");
sql.append("			A.SCH_MNG_MAIL,			 							");
sql.append("			A.REG_DATE,			 								");
sql.append("			A.MOD_DATE,			 								");
sql.append("			A.REG_IP,		 									");
sql.append("			A.APPLY_FLAG,			 							");
sql.append("			A.REQ_CNT,			 								");
sql.append("			A.REQ_DATE,			 								");
sql.append("			A.REQ_AFT_FLAG,			 							");
sql.append("			A.REQ_SCH_NM,			 							");
sql.append("			A.REQ_SCH_GRADE,			 						");
sql.append("			A.REQ_SCH_GROUP,			 						");
sql.append("			B.PRO_CAT_NM,				 						");
sql.append("			B.PRO_NAME					 						");
sql.append("		FROM ART_REQ_ALWAY A LEFT JOIN ART_PRO_ALWAY B			");
sql.append("		ON A.PRO_NO = B.PRO_NO									");
sql.append("		WHERE 1=1					 							");
if(!"".equals(search1) && !"".equals(keyword)){
	if("pro_cat_nm".equals(search1)){
		sql.append("	AND B.PRO_CAT_NM LIKE '%'||?||'%'					");
	}else if("sch_mng_nm".equals(search1)){
		sql.append("	AND A.SCH_MNG_NM LIKE '%'||?||'%'					");
	}else{
		sql.append("	AND A.REQ_SCH_NM LIKE '%'||?||'%'					");
	}
paging.setParams("search1", search1);
paging.setParams("keyword", keyword);
}
sql.append("		ORDER BY A.REQ_NO DESC		 							");
sql.append("	) A WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" \n");
sql.append(") WHERE RNUM >= ").append(paging.getStartRowNo()).append(" \n");

list = jdbcTemplate.query(
			sql.toString(), 
			new ArtVOMapper(),
			setObj
		);

num = paging.getRowNo();
%>
<script>
function searchSubmit(){
	$("#searchForm").attr("action", "").submit();
}
function getPopup(type){
	var addr;
	if(type == "artcode"){
		addr = "/program/art/admin/programAlwaysCodePopup.jsp";
	}else if( type == "insert"){
		addr = "/program/art/admin/programAlwaysInsertPopup.jsp";
	}
	window.open(addr,"PRINTVIEW","width=1000px,height=740px, status=yes, scrollbars=yes, resizable=yes");
}

function approvalSubmit(req_no){
	var addr = "/program/art/admin/programAlwaysInsertPopup.jsp?mode=update&pro_no="+pro_no;
	window.open(addr,"PRINTVIEW","width=1000px,height=740px, status=yes, scrollbars=yes, resizable=yes");
}

function cancelSubmit(req_no){
	if(confirm("프로그램을 삭제하시겠습니까?")){
		location.href="/program/art/admin/programAlwaysInsertAction.jsp?mode=delete&pro_no="+pro_no;
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
				<label for="search1">년도</label> 
				<select id="search1" name="search1">
					<option value="">선택</option>
					<option value="pro_cat_nm" <%if("pro_cat_nm".equals(search1)){%> selected="selected" <%}%>>분류명</option>
					<option value="sch_mng_nm" <%if("sch_mng_nm".equals(search1)){%> selected="selected" <%}%>>담당자명</option>
					<option value="req_sch_nm" <%if("req_sch_nm".equals(search1)){%> selected="selected" <%}%>>학교명</option>
				</select>
				<label for="keyword">검색어</label> 
				<input type="text" id="keyword" name="keyword" value="<%=keyword%>">
				<button onclick="searchSubmit();">검색하기</button>
			</fieldset>
		</form>
	</div>
	<p>
		<strong>총 <span><%=totalCount%></span> 건
		</strong> [ Page <%=pageNo %>/<%=paging.getFinalPageNo() %>]
	</p>
	<table class="tb_board">
		<caption>상시프로그램 승인대기 및 취소 테이블</caption>
		<colgroup>
		</colgroup>
		<thead>
			<tr>
				<th scope="col">순서</th>
				<th scope="col">분류</th>
				<th scope="col">프로그램명</th>
				<th scope="col">학교명</th>
				<th scope="col">담당자명</th>
				<th scope="col">담당자 연락처</th>
				<th scope="col">신청일</th>
				<th scope="col">승인상태</th>
				<th scope="col" class="rfc_bbs_list_last">승인/취소</th>
			</tr>
		</thead>
		<tbody>
			<%
			if(list!=null && list.size()>0){
			for(ArtVO ob : list){ %>
			<tr>
				<td><%=num--%></td>
				<td><%=ob.pro_cat_nm%></td>
				<td><%=ob.pro_name %></td>
				<td><%=ob.req_sch_nm %></td>
				<td><%=ob.sch_mng_nm %></td>
				<td><%=ob.sch_mng_tel %></td>
				<td><%=ob.reg_date %></td>
				<td><%=ob.apply_flag %></td>
				<td>
					<%
					if("N".equals(ob.apply_flag)){
					%>
						<button type="button" onclick="approvalSubmit('<%=ob.req_no%>')">승인</button>
					<%
					}else if("Y".equals(ob.apply_flag)){
					%>
						<button type="button" onclick="cancelSubmit('<%=ob.req_no%>')">취소</button>
					<%	
					}else if("A".equals(ob.apply_flag)){		//관리자 취소
					%>
						관리자 취소
					<%	
					}else if("C".equals(ob.apply_flag)){		//사용자 취소
					%>
						사용자 취소
					<%	
					}
					%>
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