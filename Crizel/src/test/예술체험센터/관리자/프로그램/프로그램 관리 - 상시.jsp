<%
/**
*   PURPOSE :   프로그램 관리 - 상시
*   CREATE  :   20180130_tue    Ko
*   MODIFY  :   ....
**/
%>

<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%!
private class ArtVO{
	public int pro_no;
	public String pro_cat;
	public String pro_cat_nm;
	public String pro_name;
	public String pro_memo;
	public String pro_year;
	public String reg_id;
	public String reg_ip;
	public String reg_date;
	public String mod_date;
	public String show_flag;
	public String del_flag;
	public int max_per;
	public String aft_flag;
	public String pro_tch_nm;
	
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

private class ArtVOMapper implements RowMapper<ArtVO> {
    public ArtVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ArtVO vo = new ArtVO();
        vo.pro_no			= rs.getInt("PRO_NO");
        vo.pro_cat			= rs.getString("PRO_CAT");
        vo.pro_cat_nm 		= rs.getString("PRO_CAT_NM");
        vo.pro_name			= rs.getString("PRO_NAME");
        vo.pro_memo 		= rs.getString("PRO_MEMO");
        vo.pro_year 		= rs.getString("PRO_YEAR");
        vo.reg_id			= rs.getString("REG_ID");
        vo.reg_ip			= rs.getString("REG_IP");
        vo.reg_date 		= rs.getString("REG_DATE");
        vo.mod_date 		= rs.getString("MOD_DATE");
        vo.show_flag 		= rs.getString("SHOW_FLAG");
        vo.del_flag 		= rs.getString("DEL_FLAG");
        vo.max_per 			= rs.getInt("MAX_PER");
        vo.aft_flag 		= rs.getString("AFT_FLAG");
        vo.pro_tch_nm 		= rs.getString("PRO_TCH_NM");
        return vo;
    }
}

private class ArtVOMapper2 implements RowMapper<ArtVO> {
    public ArtVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ArtVO vo = new ArtVO();
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
Calendar cal = Calendar.getInstance();
String year 		= parseNull(request.getParameter("year"));
String code_val1 	= parseNull(request.getParameter("code_val1"));
String menuCd		= parseNull(request.getParameter("menuCd"));

StringBuffer sql 				= null;
List<ArtVO> list 	= null;
List<ArtVO> list2 		= null;

Paging paging = new Paging();
paging.setPageSize(20);
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
int cnt=0;
int num = 0;

Object[] setObj		= null;
List<String> setList	= new ArrayList<String>();

sql = new StringBuffer();
sql.append("		SELECT	COUNT(*) CNT		 		");
sql.append("		FROM ART_PRO_ALWAY		 			");
sql.append("		WHERE DEL_FLAG = 'N'		 		");
if(!"".equals(year)){
sql.append("		AND PRO_YEAR = ?					");
paging.setParams("year", year);
setList.add(year);
}
if(!"".equals(code_val1)){
sql.append("		AND PRO_CAT_NM = ?					");
paging.setParams("code_val1", code_val1);
setList.add(code_val1);
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
sql.append("SELECT * FROM(												");
sql.append("	SELECT ROWNUM AS RNUM, A.* FROM (						");
sql.append("		SELECT	PRO_NO,		 								");
sql.append("				PRO_CAT,		 							");
sql.append("				PRO_CAT_NM,		 							");
sql.append("				PRO_NAME,		 							");
sql.append("				PRO_MEMO,		 							");
sql.append("				PRO_YEAR,		 							");
sql.append("				REG_ID,		 								");
sql.append("				REG_IP,		 								");
sql.append("				REG_DATE,		 							");
sql.append("				MOD_DATE,		 							");
sql.append("				SHOW_FLAG,		 							");
sql.append("				DEL_FLAG,		 							");
sql.append("				MAX_PER,		 							");
sql.append("				AFT_FLAG,		 							");
sql.append("				PRO_TCH_NM		 							");
sql.append("		FROM ART_PRO_ALWAY		 							");
sql.append("		WHERE DEL_FLAG = 'N'		 						");
if(!"".equals(year)){
sql.append("		AND PRO_YEAR = ?					");
paging.setParams("year", year);
}
if(!"".equals(code_val1)){
sql.append("		AND PRO_CAT_NM = ?					");
paging.setParams("code_val1", code_val1);
}
sql.append("		ORDER BY PRO_NO DESC		 			");
sql.append("	) A WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" \n");
sql.append(") WHERE RNUM >= ").append(paging.getStartRowNo()).append(" \n");

list = jdbcTemplate.query(
			sql.toString(), 
			new ArtVOMapper(),
			setObj
		);


sql = new StringBuffer();
sql.append("SELECT *								");
sql.append("FROM ART_PRO_CODE						");
sql.append("WHERE CODE_NAME = 'ART_PRO_ALWAY' 		");
sql.append("ORDER BY ORDER1, ARTCODE_NO	 			");
list2 = jdbcTemplate.query(
			sql.toString(), 
			new ArtVOMapper2()
		);


num = paging.getRowNo();
%>
<script>
function searchSubmit(){
	$("#searchForm").attr("action", "").submit();
}

function newWin(url, title, w, h){
	var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
    var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;
 
    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
 
    var left = ((width / 2) - (w / 2)) + dualScreenLeft;
    var top = ((height / 2) - (h / 2)) + dualScreenTop;
    var newWindow = window.open(url, title, 'scrollbars=yes, resizable=yes, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
 
}

function getPopup(type){
	var addr;
	if(type == "artcode"){
		addr = "/program/art/admin/programCodePopup.jsp?type=alway";
	}else if( type == "insert"){
		addr = "/program/art/admin/programAlwaysInsertPopup.jsp";
	}
	newWin(addr, 'PRINTVIEW', '1000', '740');
	//window.open(addr,"PRINTVIEW","width=1000px,height=740px, status=yes, scrollbars=yes, resizable=yes");
}

function updateSubmit(pro_no){
	var addr = "/program/art/admin/programAlwaysInsertPopup.jsp?mode=update&pro_no="+pro_no;
	newWin(addr, 'PRINTVIEW', '1000', '740');
	//window.open(addr,"PRINTVIEW","width=1000px,height=740px, status=yes, scrollbars=yes, resizable=yes");
}

function deleteSubmit(pro_no){
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
				<label for="year">년도</label> 
				<select id="year" name="year">
					<option value="">년도</option>
				<%
					for(int i=cal.get(Calendar.YEAR); i>=2017; i--){
				%>
					<option value="<%=i%>" <%if(Integer.toString(i).equals(year)){%> selected="selected" <%}%>><%=i%>년</option>
				<%
					}
				%>
				</select>
				<label for="code_val1">분류</label> 
				<select id="code_val1" name="code_val1">
					<option value="">분류</option>
					<%
					for(ArtVO ob : list2){						
					%>	
						<option value="<%=ob.code_val1%>" <%if(ob.code_val1.equals(code_val1)){%> selected="selected" <%}%> ><%=ob.code_val1 %></option>
					<%
					}
					%>
				</select>
				<button onclick="searchSubmit();">검색하기</button>
			</fieldset>
		</form>
	</div>
	<div class="search">
		<button onclick="getPopup('artcode');">분류관리</button>
		<button onclick="getPopup('insert');">상시추가</button>
	</div>
	<p>
		<strong>총 <span><%=totalCount%></span> 건
		</strong> [ Page <%=pageNo %>/<%=paging.getFinalPageNo() %>]
	</p>
	<table class="tb_board">
		<caption>상시프로그램 관리 테이블</caption>
		<colgroup>
		</colgroup>
		<thead>
			<tr>
				<th scope="col">순서</th>
				<th scope="col">분류</th>
				<th scope="col">년도</th>
				<th scope="col">프로그램명</th>
				<th scope="col">등록일시</th>
				<th scope="col">정원</th>
				<th scope="col">노출여부</th>
				<th scope="col" class="rfc_bbs_list_last">수정/삭제</th>
			</tr>
		</thead>
		<tbody>
			<%
			if(list!=null && list.size()>0){
			for(ArtVO ob : list){ %>
			<tr>
				<td><%=num--%></td>
				<td><%=ob.pro_cat_nm%></td>
				<td><%=ob.pro_year %></td>
				<td><%=ob.pro_name %></td>
				<td><%=ob.reg_date %></td>
				<td><%=ob.max_per %></td>
				<td><%=ob.show_flag %></td>
				<td>
					<button type="button" onclick="updateSubmit('<%=ob.pro_no%>')">수정</button>
					<button type="button" onclick="deleteSubmit('<%=ob.pro_no%>')">삭제</button>
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