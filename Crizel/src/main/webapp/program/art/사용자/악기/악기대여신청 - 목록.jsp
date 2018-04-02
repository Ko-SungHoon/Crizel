<%
/**
*   PURPOSE :   악기 대여신청 - 목록
*   CREATE  :   20180206_tue    Ko
*   MODIFY  :   20180222 ljh css클래스 수정
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
	public String apply_flag;
	public String apply_date;

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
    	vo.apply_flag		= rs.getString("APPLY_FLAG");
    	vo.apply_date		= rs.getString("APPLY_DATE");

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
String search1		= parseNull(request.getParameter("search1"));		//승인상태
String search2		= parseNull(request.getParameter("search2"));		//악기명,신청자명
String keyword		= parseNull(request.getParameter("keyword"));
String menuCd		= parseNull(request.getParameter("menuCd"));
boolean readCheck 	= false;		//게시글 보기 권한(자신의 게시글 , 관리자는 읽기 가능)
String getId 		= sm.getId();

//String writePage 	= "DOM_000002001003003001";		//악기대여신청 - 등록/수정
String writePage 	= "DOM_000000126003003001";		//테스트서버

//String viewPage 	= "DOM_000002001003003002";		//악기대여신청 - 상세페이지
String viewPage 	= "DOM_000000126003003002";		//테스트서버

Paging paging = new Paging();
paging.setPageSize(20);
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
int cnt=0;
int num = 0;

Object[] setObj		= null;
List<String> setList	= new ArrayList<String>();

sql = new StringBuffer();
sql.append("SELECT	COUNT(*) CNT		 									");
sql.append("FROM ART_INST_REQ A												");
sql.append("WHERE A.SHOW_FLAG = 'Y'		 									");
if(!cm.isMenuCmsManager(sm)){
sql.append("AND A.REQ_ID = ?												");
setList.add(getId);
}
if(!"".equals(search1)){
	sql.append("AND A.APPLY_FLAG = ?										");
	setList.add(search1);
paging.setParams("search1", search1);
}
if(!"".equals(search2) && !"".equals(keyword)){
	if("inst_nm".equals(search2)){
		sql.append("AND A.REQ_NO = (SELECT REQ_NO FROM ART_INST_REQ_CNT WHERE REQ_NO = A.REQ_NO AND INST_NM LIKE '%'||?||'%' GROUP BY REQ_NO)	");
		setList.add(keyword);
	}else if("req_mng_nm".equals(search2)){
		sql.append("AND A.REQ_MNG_NM LIKE '%'||?||'%'						");
		setList.add(keyword);
	}
paging.setParams("search2", search2);
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
sql.append("			CASE				 								");
sql.append("				WHEN A.APPLY_FLAG = 'N'	THEN '승인대기'			");
sql.append("				WHEN A.APPLY_FLAG = 'Y'	THEN '승인완료'			");
sql.append("				WHEN A.APPLY_FLAG = 'A'	THEN '관리자 취소'			");
sql.append("				WHEN A.APPLY_FLAG = 'C'	THEN '취소'				");
sql.append("				WHEN A.APPLY_FLAG = 'R'	THEN '반납완료'			");
sql.append("			END APPLY_FLAG,										");
sql.append("			A.APPLY_DATE,										");
sql.append("			(SELECT INST_CAT FROM ART_INST_REQ_CNT WHERE REQ_NO 	= A.REQ_NO AND ROWNUM = 1) INST_CAT,			");
sql.append("			(SELECT INST_CAT_NM FROM ART_INST_REQ_CNT WHERE REQ_NO 	= A.REQ_NO AND ROWNUM = 1) INST_CAT_NM,			");
sql.append("			(SELECT INST_NO FROM ART_INST_REQ_CNT WHERE REQ_NO 		= A.REQ_NO AND ROWNUM = 1) INST_NO,				");
/* sql.append("			(SELECT INST_NM FROM ART_INST_REQ_CNT WHERE REQ_NO 		= A.REQ_NO AND ROWNUM = 1) 	INST_NM,			"); */
sql.append("			(SELECT																									");
sql.append("					SUBSTR(																							");
sql.append("							XMLAGG(																					");
sql.append("									XMLELEMENT(COL ,', ', INST_NM) ORDER BY INST_NM).EXTRACT('//text()'				");
sql.append("							).GETSTRINGVAL()																		");
sql.append("					, 2) INST_NM																					");
sql.append("			FROM ART_INST_REQ_CNT																					");
sql.append("			WHERE REQ_NO = A.REQ_NO																					");
sql.append("			GROUP BY REQ_NO) INST_NM,																				");
sql.append("			(SELECT NVL(SUM(INST_REQ_CNT),0) FROM ART_INST_REQ_CNT WHERE REQ_NO = A.REQ_NO) 	INST_REQ_CNT		");
sql.append("		FROM ART_INST_REQ A										");
sql.append("		WHERE A.SHOW_FLAG = 'Y'		 							");
if(!cm.isMenuCmsManager(sm)){
sql.append("AND A.REQ_ID = ?												");
}
if(!"".equals(search1)){
	sql.append("AND A.APPLY_FLAG = ?										");
	paging.setParams("search1", search1);
}
if(!"".equals(search2) && !"".equals(keyword)){
	if("inst_nm".equals(search2)){
		sql.append("AND A.REQ_NO = (SELECT REQ_NO FROM ART_INST_REQ_CNT WHERE REQ_NO = A.REQ_NO AND INST_NM LIKE '%'||?||'%' GROUP BY REQ_NO)	");
	}else if("req_mng_nm".equals(search2)){
		sql.append("AND A.REQ_MNG_NM LIKE '%'||?||'%'						");
	}
paging.setParams("search2", search2);
paging.setParams("keyword", keyword);
}
sql.append("ORDER BY A.REQ_NO DESC			 								");
sql.append("	) A WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" \n");
sql.append(") WHERE RNUM > ").append(paging.getStartRowNo()).append(" \n	");

list = jdbcTemplate.query(
			sql.toString(),
			new InsVOMapper(),
			setObj
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

function insert(){
	location.href="/index.gne?menuCd=<%=writePage%>";		
}

</script>
<section class="board music_rentList">
	<div class="search fsize_90">
		<form id="searchForm" method="get">
			<fieldset>
				<input type="hidden" id="menuCd" name="menuCd" value="<%=menuCd%>">
				<span class="sel1">
					<label for="search1">상태</label>
					<select id="search1" name="search1">
						<option value="">선택</option>
						<option value="N" <%if("N".equals(search1)){%> selected="selected" <%}%>>승인대기</option>
						<option value="Y" <%if("Y".equals(search1)){%> selected="selected" <%}%>>승인완료</option>
						<option value="A" <%if("A".equals(search1)){%> selected="selected" <%}%>>관리자 취소</option>
						<option value="C" <%if("C".equals(search1)){%> selected="selected" <%}%>>취소</option>
					</select>
				</span>
				<span class="sel2">
					<label for="search2">검색분류</label>
					<select id="search2" name="search2">
						<option value="">선택</option>
						<option value="inst_nm" <%if("inst_nm".equals(search2)){%> selected="selected" <%}%>>악기명</option>
						<option value="req_mng_nm" <%if("req_mng_nm".equals(search2)){%> selected="selected" <%}%>>신청자명</option>
					</select>
				</span>
				<span class="srch-box">
					<label for="keyword">검색어</label>
					<input type="text" id="keyword" name="keyword" value="<%=keyword%>">
					<button onclick="searchSubmit();">검색</button>
				</span>
			</fieldset>
		</form>
	</div>
	<p class="fsize_90">
		<strong>총 <span><%=totalCount%></span> 건
		</strong> [ Page <%=pageNo %>/<%=paging.getFinalPageNo() %>]
	</p>
	<table class="tb_board thgrey nohover">
		<caption>악기 대여신청 테이블</caption>
		<colgroup>
			<col style="width:8%" />
			<col style="width:15%" />
			<col style="width:18%" />
			<col />
			<col style="width:15%" />
			<col style="width:12%" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">순서</th>
				<th scope="col">신청일</th>
				<th scope="col">신청자명</th>
				<th scope="col">신청악기명</th>
				<th scope="col">상태<br class="dis_mo" />처리일</th>
				<th scope="col">상태</th>
			</tr>
		</thead>
		<tbody>
			<%
			if(list!=null && list.size()>0){
			for(InsVO ob : list){ %>
			<tr>
				<td><%=num--%></td>
				<td><span class="date"><%=parseNull(ob.reg_date) %></span></td>
				<td><%=parseNull(ob.req_mng_nm) %></td>
				<td>
					<a href="/index.gne?menuCd=<%=viewPage%>&req_no=<%=ob.req_no%>"><strong class="blue"><%=parseNull(ob.inst_nm) %></strong></a>
				</td>
				<td><span class="date"><%=parseNull(ob.apply_date) %></span></td>
				<td><span class="state"><%=parseNull(ob.apply_flag) %></span></td>
			</tr>
			<%
			}
			}else{
			%>
			<tr>
				<td colspan="6">등록된 게시물이 없습니다.</td>
			</tr>
			<%
			}
			%>
		</tbody>
	</table>

	<div class="btn_area mg_0 r">
		<button onclick="insert();" class="btn medium edge darkMblue">대여하기</button>
	</div>

	<% if(paging.getTotalCount() > 0) { %>
	<div class="pageing">
		<%=paging.getHtml("2") %>
	</div>
	<% } %>
</section>