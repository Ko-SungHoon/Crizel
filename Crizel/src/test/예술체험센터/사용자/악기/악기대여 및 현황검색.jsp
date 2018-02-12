<%
/**
*   PURPOSE :   악기대여 및 현황 검색
*   CREATE  :   20180208_thur    Ko
*   MODIFY  :   ....
**/
%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
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
    	vo.inst_no				= rs.getInt("INST_NO");	
    	vo.inst_cat				= rs.getString("INST_CAT");
    	vo.inst_cat_nm			= rs.getString("INST_CAT_NM");
    	vo.inst_name			= rs.getString("INST_NAME");
    	vo.inst_memo			= rs.getString("INST_MEMO");
    	vo.curr_cnt				= rs.getInt("CURR_CNT");
    	vo.max_cnt				= rs.getInt("MAX_CNT");
    	vo.inst_size			= rs.getString("INST_SIZE");
    	vo.inst_model			= rs.getString("INST_MODEL");
    	vo.inst_pic				= rs.getString("INST_PIC");
    	vo.inst_lca				= rs.getString("INST_LCA");
    	vo.reg_id				= rs.getString("REG_ID");
    	vo.reg_ip				= rs.getString("REG_IP");
    	vo.reg_date				= rs.getString("REG_DATE");
    	vo.mod_date				= rs.getString("MOD_DATE");
   		vo.show_flag			= rs.getString("SHOW_FLAG");
    	vo.del_flag				= rs.getString("DEL_FLAG");
        return vo;
    }
}

private class CodeList implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
   		vo.artcode_no			= rs.getInt("ARTCODE_NO");
    	vo.code_tbl				= rs.getString("CODE_TBL");
    	vo.code_col				= rs.getString("CODE_COL");
   		vo.code_name			= rs.getString("CODE_NAME");
   		vo.code_val1			= rs.getString("CODE_VAL1");
   		vo.code_val2			= rs.getString("CODE_VAL2");
   		vo.code_val3			= rs.getString("CODE_VAL3");
    	vo.order1				= rs.getInt("ORDER1");
    	vo.order2				= rs.getInt("ORDER2");
    	vo.order3				= rs.getInt("ORDER3");
        return vo;
    }
}

%>
<%
StringBuffer sql		= null;
List<InsVO> list 		= null;
List<InsVO> codeList 	= null;
String search1			= parseNull(request.getParameter("search1"));		//분류
String keyword			= parseNull(request.getParameter("keyword"));
String menuCd			= parseNull(request.getParameter("menuCd"));

Paging paging = new Paging();
paging.setPageSize(20);
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
int cnt=0;
int num = 0;

sql = new StringBuffer();
sql.append("SELECT	COUNT(*) CNT		 									");
sql.append("FROM ART_INST_MNG												");
sql.append("WHERE SHOW_FLAG = 'Y' AND DEL_FLAG = 'N'						");
if(!"".equals(search1)){
	sql.append("AND INST_CAT_NM = '").append(search1).append("'				");
paging.setParams("search1", search1);
}
if(!"".equals(keyword)){
	sql.append("AND INST_NAME = '").append(keyword).append("'				");
paging.setParams("keyword", keyword);
}

totalCount = jdbcTemplate.queryForObject(
		sql.toString(),
		Integer.class
	);

paging.setPageNo(Integer.parseInt(pageNo));
paging.setTotalCount(totalCount);

sql = new StringBuffer();
sql.append("SELECT * FROM(														");
sql.append("	SELECT ROWNUM AS RNUM, A.* FROM (								");
sql.append("		SELECT			 											");
sql.append("			INST_NO	,		 										");
sql.append("			INST_CAT,			 									");
sql.append("			INST_CAT_NM,			 								");
sql.append("			INST_NAME,		 										");
sql.append("			INST_MEMO,		 										");
sql.append("			CURR_CNT,		 										");
sql.append("			MAX_CNT,		 										");
sql.append("			INST_SIZE,		 										");
sql.append("			INST_MODEL,		 										");
sql.append("			INST_PIC,		 										");
sql.append("			INST_LCA,		 										");
sql.append("			REG_ID,		 											");
sql.append("			REG_IP,		 											");
sql.append("			REG_DATE,		 										");
sql.append("			MOD_DATE,		 										");
sql.append("			SHOW_FLAG,		 										");
sql.append("			DEL_FLAG		 										");
sql.append("		FROM ART_INST_MNG											");
sql.append("		WHERE SHOW_FLAG = 'Y' AND DEL_FLAG = 'N'					");
if(!"".equals(search1)){
	sql.append("AND INST_CAT_NM = '").append(search1).append("'					");
paging.setParams("search1", search1);
}
if(!"".equals(keyword)){
	sql.append("AND INST_NAME = '").append(keyword).append("'					");
paging.setParams("keyword", keyword);
}
sql.append("ORDER BY INST_NO				 									");
sql.append("	) A WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" \n");
sql.append(") WHERE RNUM >= ").append(paging.getStartRowNo()).append(" \n		");

list = jdbcTemplate.query(
			sql.toString(), 
			new InsVOMapper()
		);

sql = new StringBuffer();
sql.append("SELECT * FROM ART_PRO_CODE WHERE CODE_TBL = 'ART_INST_MNG' ORDER BY ARTCODE_NO 		");
codeList = jdbcTemplate.query(
			sql.toString(),
			new CodeList()
		);


num = paging.getRowNo();
%>
<script>
function searchSubmit(){
	$("#searchForm").attr("action", "").submit();
}
function goToList(inst_cat_nm, inst_name){
	location.href="/index.gne?menuCd=DOM_000000126003003001&search1="+encodeURIComponent(inst_cat_nm)+"&keyword="+encodeURIComponent(inst_name);
}
</script>
<section class="board">
	<div class="search">
		<form id="searchForm" method="get">
			<fieldset>
				<input type="hidden" id="menuCd" name="menuCd" value="<%=menuCd%>">
				<label for="search1">상태</label> 
				<select id="search1" name="search1">
					<option value="">--분류선택--</option>
                    <%
                    if(codeList!=null && codeList.size()>0){
                    for(InsVO ob : codeList){						
                    %>	
                        <option value="<%=ob.code_val1%>" <%if(ob.code_val1.equals(search1)){%> selected="selected" <%}%> ><%=ob.code_val1 %></option>
                    <%
                    }
                    }
                    %>
				</select>
				<label for="keyword">검색어</label> 
				<input type="text" id="keyword" name="keyword" value="<%=keyword%>" placeholder="악기명 입력">
				<button onclick="searchSubmit();">검색하기</button>
			</fieldset>
		</form>
	</div>
	<p>
		<strong>총 <span><%=totalCount%></span> 건
		</strong> [ Page <%=pageNo %>/<%=paging.getFinalPageNo() %>]
	</p>
	<div>
	<ul class="album">
	<%
	if(list!=null && list.size()>0){
	for(InsVO ob : list){
	%>
		<li>
			<p>
				<img src="<%=ob.inst_pic%>" alt="<%=ob.inst_name%>">
			</p>
			<ul>
				<li class="pro_tit"><a href="#"><%=ob.inst_name %></a></li>
				<li>악기분류 : <%=ob.inst_cat_nm%></li>
				<li>대여수 / 보유수 : <%=ob.curr_cnt%> / <%=ob.max_cnt%></li>
				<li>악기위치  : <%=ob.inst_lca%></li>
				<li><%=ob.inst_memo %></li>
				<li><button type="button" onclick="goToList('<%=ob.inst_cat_nm%>', '<%=ob.inst_name%>')">대여하기</button></li>
			</ul>
		</li>
		
	<%
	}
	}
	%>
	</ul>
</div>
	<div class="clr h020"></div>
	
	<% if(paging.getTotalCount() > 0) { %>
	<div class="pageing">
		<%=paging.getHtml("2") %>
	</div>
	<% } %>
</section>