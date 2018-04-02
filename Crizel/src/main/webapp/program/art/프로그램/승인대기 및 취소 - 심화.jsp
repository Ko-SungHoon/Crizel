<%
/**
*   PURPOSE :   승인대기 및 취소 - 심화
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
	public String req_user_id;
	public String req_user_nm;
	public String req_user_tel;
	public String req_user_mail;
	public String reg_date;
	public String mod_date;
	public String reg_ip;
	public String apply_flag;
	public int req_per;
	public String req_group;
	public String req_mot;
	public String show_flag;
	public String del_flag;
	
	public String pro_cat_nm;
	public String pro_name;
}
	
private class ArtVOMapper implements RowMapper<ArtVO> {
    public ArtVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ArtVO vo = new ArtVO();
    	vo.req_no			= rs.getInt("REQ_NO");
    	vo.pro_no			= rs.getInt("PRO_NO");
    	vo.req_user_id		= rs.getString("REQ_USER_ID");
    	vo.req_user_nm		= rs.getString("REQ_USER_NM");
    	vo.req_user_tel		= rs.getString("REQ_USER_TEL");
    	vo.req_user_mail	= rs.getString("REQ_USER_MAIL");
    	vo.reg_date			= rs.getString("REG_DATE");
    	vo.mod_date			= rs.getString("MOD_DATE");
    	vo.reg_ip			= rs.getString("REG_IP");
    	vo.apply_flag		= rs.getString("APPLY_FLAG");
    	vo.req_per			= rs.getInt("REQ_PER");
    	vo.req_group		= rs.getString("REQ_GROUP");
    	vo.req_mot			= rs.getString("REQ_MOT");
    	vo.show_flag		= rs.getString("SHOW_FLAG");
    	vo.del_flag			= rs.getString("DEL_FLAG");
        
        vo.pro_cat_nm		= rs.getString("PRO_CAT_NM");
        vo.pro_name			= rs.getString("PRO_NAME");
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

Object[] setObj		= null;
List<String> setList	= new ArrayList<String>();

sql = new StringBuffer();
sql.append("		SELECT	COUNT(*) CNT		 							");
sql.append("		FROM ART_REQ_DEEP A LEFT JOIN ART_PRO_DEEP B			");
sql.append("		ON A.PRO_NO = B.PRO_NO									");
sql.append("		WHERE 1=1					 							");
if(!"".equals(search1) && !"".equals(keyword)){
	if("pro_cat_nm".equals(search1)){
		sql.append("	AND B.PRO_CAT_NM LIKE '%'||?||'%'					");
		setList.add(keyword);
	}else if("req_user_nm".equals(search1)){
		sql.append("	AND A.REQ_USER_NM LIKE '%'||?||'%'					");
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
sql.append("			A.REQ_USER_ID,			 							");
sql.append("			A.REQ_USER_NM,			 							");
sql.append("			A.REQ_USER_TEL,			 							");
sql.append("			A.REQ_USER_MAIL,			 						");
sql.append("			A.REG_DATE,			 								");
sql.append("			A.MOD_DATE,			 								");
sql.append("			A.REG_IP,			 								");
sql.append("			A.APPLY_FLAG,			 							");
sql.append("			A.REQ_PER,			 								");
sql.append("			A.REQ_GROUP,			 							");
sql.append("			A.REQ_MOT,			 								");
sql.append("			A.SHOW_FLAG,			 							");
sql.append("			A.DEL_FLAG,			 								");
sql.append("			B.PRO_CAT_NM,				 						");
sql.append("			B.PRO_NAME					 						");
sql.append("		FROM ART_REQ_DEEP A LEFT JOIN ART_PRO_DEEP B			");
sql.append("		ON A.PRO_NO = B.PRO_NO									");
sql.append("		WHERE 1=1					 							");
if(!"".equals(search1) && !"".equals(keyword)){
	if("pro_cat_nm".equals(search1)){
		sql.append("	AND B.PRO_CAT_NM LIKE '%'||?||'%'					");
	}else if("req_user_nm".equals(search1)){
		sql.append("	AND A.REQ_USER_NM LIKE '%'||?||'%'					");
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
		addr = "/program/art/admin/programDCodePopup.jsp";
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
					<option value="pro_cat_nm"  <%if("pro_cat_nm".equals(search1)){%> selected="selected" <%}%>>분류명</option>
					<option value="req_user_nm" <%if("req_user_nm".equals(search1)){%> selected="selected" <%}%>>담당자명</option>
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
		<caption>심화프로그램 승인대기 및 취소 테이블</caption>
		<colgroup>
		</colgroup>
		<thead>
			<tr>
				<th scope="col">순서</th>
				<th scope="col">분류</th>
				<th scope="col">프로그램명</th>
				<th scope="col">신청자명</th>
				<th scope="col">신청자 연락처</th>
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
				<td><%=ob.req_user_nm %></td>
				<td><%=ob.req_user_tel %></td>
				<td><%=ob.reg_date %></td>
				<td>
					<button type="button" onclick="approvalSubmit('<%=ob.req_no%>')">승인</button>
					<button type="button" onclick="cancelSubmit('<%=ob.req_no%>')">취소</button>
				</td>
			</tr>
			<%
			}
			}else{
			%>
			<tr>
				<td colspan="8">등록된 게시물이 없습니다.</td>
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