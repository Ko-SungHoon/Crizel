<%
/**
*   PURPOSE :   악기 관리
*   CREATE  :   20180201_thur    Ko
*   MODIFY  :   20180223 LJH 클래스, 마크업 수정
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 악기 관리</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
<script>
</script>
</head>
<body>
<%!
private class InsVO{
	public int inst_no;
	public String inst_cat;
	public String inst_cat_nm;
	public String inst_name;
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
String search1 		= parseNull(request.getParameter("search1"));
String keyword	 	= parseNull(request.getParameter("keyword"));
String menuCd		= parseNull(request.getParameter("menuCd"));

StringBuffer sql 		= null;
List<InsVO> list 		= null;
List<InsVO> list2 		= null;

Paging paging = new Paging();
paging.setPageSize(20);
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
int cnt=0;
int num = 0;

Object[] setObj		= null;
List<String> setList	= new ArrayList<String>();

sql = new StringBuffer();
sql.append("		SELECT	COUNT(*) CNT		 				");
sql.append("		FROM ART_INST_MNG		 					");
sql.append("		WHERE DEL_FLAG = 'N'		 				");
if(!"".equals(search1)){
	sql.append("		AND INST_CAT_NM = ?							");
	paging.setParams("search1", search1);
	setList.add(search1);
	if(!"".equals(keyword)){
		sql.append("		AND INST_NAME LIKE '%'||?||'%'			");
		paging.setParams("keyword", keyword);
		setList.add(keyword);
	}
}else{
	if(!"".equals(keyword)){
	sql.append("		AND INST_NAME LIKE '%'||?||'%'				");
	paging.setParams("keyword", keyword);
	setList.add(keyword);
	}
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
sql.append("		SELECT			 									");
sql.append("			INST_NO,			 							");
sql.append("			INST_CAT,			 							");
sql.append("			INST_CAT_NM,			 						");
sql.append("			INST_NAME,			 							");
sql.append("			CURR_CNT,			 							");
sql.append("			MAX_CNT,			 							");
sql.append("			INST_SIZE,			 							");
sql.append("			INST_MODEL,			 							");
sql.append("			INST_PIC,			 							");
sql.append("			INST_LCA,			 							");
sql.append("			REG_ID,			 								");
sql.append("			REG_IP,			 								");
sql.append("			REG_DATE,			 							");
sql.append("			MOD_DATE,			 							");
sql.append("			SHOW_FLAG,			 							");
sql.append("			DEL_FLAG			 							");
sql.append("		FROM ART_INST_MNG		 							");
sql.append("		WHERE DEL_FLAG = 'N'		 						");
if(!"".equals(search1)){
	sql.append("		AND INST_CAT_NM = ?							");
	paging.setParams("search1", search1);
	if(!"".equals(keyword)){
		sql.append("		AND INST_NAME LIKE '%'||?||'%'			");
		paging.setParams("keyword", keyword);
	}
}else{
	if(!"".equals(keyword)){
	sql.append("		AND INST_NAME LIKE '%'||?||'%'				");
	paging.setParams("keyword", keyword);
	}
}
sql.append("		ORDER BY INST_NO DESC		 						");
sql.append("	) A WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" \n");
sql.append(") WHERE RNUM >= ").append(paging.getStartRowNo()).append(" \n");


list = jdbcTemplate.query(
			sql.toString(),
			new InsVOMapper(),
			setObj
		);

sql = new StringBuffer();
sql.append("SELECT *								");
sql.append("FROM ART_PRO_CODE						");
sql.append("WHERE CODE_NAME = 'ART_INST_MNG' 		");
sql.append("ORDER BY ORDER1, ARTCODE_NO	 			");
list2 = jdbcTemplate.query(
			sql.toString(),
			new InsVOMapper2()
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
		addr = "/program/art/admin/programCodePopup.jsp?type=inst";
	}else if( type == "insert"){
		addr = "/program/art/insAdmin/instInsertPopup.jsp";
	}
	newWin(addr, 'PRINTVIEW', '1000', '740');
	//window.open(addr,"PRINTVIEW","width=1000px,height=740px, status=yes, scrollbars=yes, resizable=yes");
}

function updateSubmit(inst_no){
	var addr = "/program/art/insAdmin/instInsertPopup.jsp?mode=update&inst_no="+inst_no;
	newWin(addr, 'PRINTVIEW', '1000', '740');
	//window.open(addr,"PRINTVIEW","width=1000px,height=740px, status=yes, scrollbars=yes, resizable=yes");
}

function deleteSubmit(inst_no){
	if(confirm("프로그램을 삭제하시겠습니까?")){
		location.href="/program/art/insAdmin/instInsertAction.jsp?mode=delete&inst_no="+inst_no;
	}else{
		return false;
	}
}

</script>
<div id="right_view">
		<div class="top_view">
				<p class="location"><strong>악기 관리</strong></p>
		</div>
</div>

<!-- S : #content -->
<div id="content">
	<div class="btn_area">
		<p class="boxin">
			<button type="button" class="btn medium mako" onclick="location.href='/program/art/admin/instMng.jsp'">악기 관리</button>
			<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/instReq.jsp'">신청관리</button>
			<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/instStat.jsp'">통계관리</button>
		</p>
	</div>
	<div class="searchBox magB20">
		<form id="searchForm" method="get" class="topbox2">
			<fieldset>
				<!-- <label for="search1">분류</label> -->
				<select id="search1" name="search1">
					<option value="">분류</option>
					<%
					for(InsVO ob : list2){
					%>
						<option value="<%=ob.code_val1%>" <%if(ob.code_val1.equals(search1)){%> selected="selected" <%}%> ><%=ob.code_val1 %></option>
					<%
					}
					%>
				</select>
				<input type="text" id="keyword" name="keyword" value="<%=keyword%>">
				<button class="btn small edge mako" onclick="searchSubmit();">검색하기</button>
			</fieldset>
		</form>
	</div>
	<div class="f_r">
		<button type="button" class="btn small edge darkMblue" onclick="getPopup('artcode');">분류관리</button>
		<button type="button" class="btn small edge green" onclick="getPopup('insert');">악기추가</button>
	</div>
	<p class="f_l magT10">
		<strong>총 <span><%=totalCount%></span> 건
		</strong> [ Page <%=pageNo %>/<%=paging.getFinalPageNo() %>]
	</p>
	<p class="clearfix"> </p>
	<table class="bbs_list">
		<caption>악기 관리 테이블</caption>
		<colgroup>
			<col style="width: 5%"/>
			<col style="width: 15%"/>
			<col style="width: 35%"/>
			<col style="width: 10%"/>
			<col style="width: 10%"/>
			<col style="width: 10%"/>
			<col style="width: 15%"/>
		</colgroup>
		<thead>
			<tr>
				<th scope="col">순서</th>
				<th scope="col">분류</th>
				<th scope="col">악기명</th>
				<th scope="col">대여 수</th>
				<th scope="col">총량</th>
				<th scope="col">등록일</th>
				<th scope="col">수정/삭제</th>
			</tr>
		</thead>
		<tbody>
			<%
			if(list!=null && list.size()>0){
			for(InsVO ob : list){ %>
			<tr>
				<td><%=num--%></td>
				<td><%=ob.inst_cat_nm%></td>
				<td><%=ob.inst_name %></td>
				<td><%=ob.curr_cnt %></td>
				<td><%=ob.max_cnt %></td>
				<td><%=ob.reg_date %></td>
				<td>
					<%-- <button type="button" onclick="applySubmit('<%=ob.inst_no%>')">적용</button> --%>
					<button type="button" class="btn small edge mako" onclick="updateSubmit('<%=ob.inst_no%>')">수정</button>
					<button type="button" class="btn small edge red" onclick="deleteSubmit('<%=ob.inst_no%>')">삭제</button>
				</td>
			</tr>
			<%
			}
			}else{
			%>
			<tr>
				<td colspan="7">등록된 게시물이 없습니다.</td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>

	<% if(paging.getTotalCount() > 0) { %>
	<div class="page_area">
		<%=paging.getHtml() %>
	</div>
	<% } %>
</div>
<!-- //E : #content -->

</body>
</html>
