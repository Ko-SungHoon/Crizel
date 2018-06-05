<%
/**
*   PURPOSE :   프로그램 관리 - 심화
*   CREATE  :   20180130_tue    Ko
*   MODIFY  :   20180223 LJH 마크업, 클래스 수정
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>

<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 프로그램 관리 - 심화</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
<script>
</script>
</head>
<body>
<%!
private class ArtVO{
	public int pro_no;
	public String pro_cat;
	public String pro_cat_nm;
	public String pro_name;
	public String pro_tch_name;
	public String pro_tch_tel;
	public String pro_memo;
	public String appstr_date;
	public String append_date;
	public String prostr_date;
	public String proend_date;
	public int curr_per;
	public int max_per;
	public String reg_id;
	public String reg_ip;
	public String reg_date;
	public String mod_date;
	public String show_flag;
	public String del_flag;
	public String status;

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
        vo.pro_cat_nm		= rs.getString("PRO_CAT_NM");
        vo.pro_name			= rs.getString("PRO_NAME");
        vo.pro_tch_name		= rs.getString("PRO_TCH_NAME");
        vo.pro_tch_tel		= rs.getString("PRO_TCH_TEL");
        vo.pro_memo			= rs.getString("PRO_MEMO");
        vo.appstr_date		= rs.getString("APPSTR_DATE");
        vo.append_date		= rs.getString("APPEND_DATE");
        vo.prostr_date		= rs.getString("PROSTR_DATE");
        vo.proend_date		= rs.getString("PROEND_DATE");
        vo.curr_per			= rs.getInt("CURR_PER");
        vo.max_per			= rs.getInt("MAX_PER");
        vo.reg_id			= rs.getString("REG_ID");
        vo.reg_ip			= rs.getString("REG_IP");
        vo.reg_date			= rs.getString("REG_DATE");
        vo.mod_date			= rs.getString("MOD_DATE");
        vo.show_flag		= rs.getString("SHOW_FLAG");
        vo.del_flag			= rs.getString("DEL_FLAG");
        vo.status			= rs.getString("STATUS");
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
SessionManager sessionManager = new SessionManager(request);
Calendar cal = Calendar.getInstance();
String year 		= parseNull(request.getParameter("year"));
String code_val1 	= parseNull(request.getParameter("code_val1"));
String keyword		= parseNull(request.getParameter("keyword"));
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
sql.append("		SELECT	COUNT(*) CNT		 								");
sql.append("		FROM ART_PRO_DEEP		 									");
sql.append("		WHERE DEL_FLAG = 'N'		 								");
if(!"".equals(code_val1)){
sql.append("		AND PRO_CAT_NM = ?											");
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
sql.append("SELECT * FROM(																		");
sql.append("	SELECT ROWNUM AS RNUM, A.* FROM (												");
sql.append("		SELECT			 															");
sql.append("			PRO_NO,			 														");
sql.append("			PRO_CAT,			 													");
sql.append("			PRO_CAT_NM,			 													");
sql.append("			PRO_NAME,			 													");
sql.append("			PRO_TCH_NAME,			 												");
sql.append("			PRO_TCH_TEL,			 												");
sql.append("			PRO_MEMO,			 													");
sql.append("			APPSTR_DATE,			 												");
sql.append("			APPEND_DATE,			 												");
sql.append("			PROSTR_DATE,			 												");
sql.append("			PROEND_DATE,			 												");
sql.append("			CURR_PER,			 													");
sql.append("			MAX_PER,			 													");
sql.append("			REG_ID,			 														");
sql.append("			REG_IP,			 														");
sql.append("			REG_DATE,			 													");
sql.append("			MOD_DATE,			 													");
sql.append("			SHOW_FLAG,			 													");
sql.append("			DEL_FLAG,			 													");
sql.append("			CASE	 																");
sql.append("				WHEN TO_CHAR(SYSDATE, 'YYYY-MM-DD') < APPSTR_DATE THEN '준비중'		");
sql.append("				WHEN TO_CHAR(SYSDATE, 'YYYY-MM-DD') >= APPSTR_DATE AND	 			");
sql.append("					TO_CHAR(SYSDATE, 'YYYY-MM-DD') <= APPEND_DATE AND	 			");
sql.append("					MAX_PER > CURR_PER THEN '모집중'	 								");
sql.append("				WHEN TO_CHAR(SYSDATE, 'YYYY-MM-DD') >= APPSTR_DATE AND	 			");
sql.append("					TO_CHAR(SYSDATE, 'YYYY-MM-DD') <= APPEND_DATE AND	 			");
sql.append("					MAX_PER = CURR_PER THEN '모집완료' 	 							");
sql.append("				WHEN TO_CHAR(SYSDATE, 'YYYY-MM-DD') >= PROSTR_DATE AND	 			");
sql.append("					TO_CHAR(SYSDATE, 'YYYY-MM-DD') <= PROEND_DATE		 			");
sql.append("					THEN '프로그램 진행중' 	 											");
sql.append("				WHEN TO_CHAR(SYSDATE, 'YYYY-MM-DD') > PROEND_DATE THEN '프로그램 종료'	");
sql.append("				ELSE '기타'															");
sql.append("			END STATUS																");
sql.append("		FROM ART_PRO_DEEP		 													");
sql.append("		WHERE DEL_FLAG = 'N'		 												");
if(!"".equals(code_val1)){
sql.append("		AND PRO_CAT_NM = ?											");
paging.setParams("code_val1", code_val1);
}
sql.append("		ORDER BY PRO_NO DESC														");
sql.append("	) A WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" 					");
sql.append(") WHERE RNUM > ").append(paging.getStartRowNo()).append(" 							");

list = jdbcTemplate.query(
			sql.toString(),
			new ArtVOMapper(),
			setObj
		);


sql = new StringBuffer();
sql.append("SELECT *								");
sql.append("FROM ART_PRO_CODE						");
sql.append("WHERE CODE_NAME = 'ART_PRO_DEEP' 		");
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
		addr = "/program/art/admin/programCodePopup.jsp?type=deep";
	}else if( type == "insert"){
		addr = "/program/art/admin/programDeepInsertPopup.jsp";
	}
	newWin(addr, 'PRINTVIEW', '1000', '740');
	//window.open(addr,"PRINTVIEW","width=1000px,height=740px, status=yes, scrollbars=yes, resizable=yes");
}

function updateSubmit(pro_no){
	var addr = "/program/art/admin/programDeepInsertPopup.jsp?mode=update&pro_no="+pro_no;
	newWin(addr, 'PRINTVIEW', '1000', '740');
	//window.open(addr,"PRINTVIEW","width=1000px,height=740px, status=yes, scrollbars=yes, resizable=yes");
}

function deleteSubmit(pro_no){
	if(confirm("프로그램을 삭제하시겠습니까?")){
		location.href="/program/art/admin/programDeepInsertAction.jsp?mode=delete&pro_no="+pro_no;
	}else{
		return false;
	}
}
</script>
<div id="right_view">
		<div class="top_view">
				<p class="location"><strong>프로그램 운영 > 프로그램 관리(심화)</strong></p>
				<p class="loc_admin">
                    <a href="/iam/main/index.sko?lang=en_US" target="_top" class="white">ENGLISH</a> <span class="yellow">[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span>님 안녕하세요.
                    <a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
                </p>
		</div>
</div>
<!-- S : #content -->
	<div id="content">
		<div class="btn_area">
			<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/alwaysReq.jsp'">승인대기 및 취소 - 상시</button>
			<%if(sessionManager.isRoleAdmin()){%>
			<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/alwaysMng.jsp'">프로그램 관리 - 상시</button>
			<%} %>
			<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/deepReq.jsp'">승인대기 및 취소 - 심화</button>
			<button type="button" class="btn medium mako" onclick="location.href='/program/art/admin/deepMng.jsp'">프로그램 관리 - 심화</button>
			<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/programStat.jsp'">통계관리</button>
		</div>
		<div class="searchBox magT20 magB20">
			<form id="searchForm" method="get" class="topbox2">
				<fieldset>
					<!-- <label for="code_val1">분류</label> -->
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
					<button class="btn small edge mako" onclick="searchSubmit();">검색하기</button>
				</fieldset>
			</form>
		</div>

		<div class="f_r">
			<button type="button" class="btn small edge darkMblue" onclick="getPopup('artcode');">분류관리</button>
			<button type="button" class="btn small edge green" onclick="getPopup('insert');">심화추가</button>
		</div>
		<p class="f_l magT10">
			<strong>총 <span><%=totalCount%></span> 건
			</strong> [ Page <%=pageNo %>/<%=paging.getFinalPageNo() %>]
		</p>
		<p class="clearfix"></p>

		<table class="bbs_list">
			<caption>심화프로그램 관리 테이블</caption>
			<colgroup>
				<col width="5%"/>
				<col width="10%"/>
				<col width="13%"/>
				<col width="13%"/>
				<col />
				<col width="8%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="5%"/>
				<col width="10%"/>
			</colgroup>
			<thead>
				<tr>
					<th scope="col">순서</th>
					<th scope="col">분류</th>
					<th scope="col">모집기간</th>
					<th scope="col">운행기간</th>
					<th scope="col">프로그램명</th>
					<th scope="col">등록일</th>
					<th scope="col">정원</th>
					<th scope="col">현재상태</th>
					<th scope="col">노출여부</th>
					<th scope="col">수정/삭제</th>
				</tr>
			</thead>
			<tbody>
				<%
				if(list!=null && list.size()>0){
				for(ArtVO ob : list){ %>
				<tr>
					<td><%=num--%></td>
					<td><%=ob.pro_cat_nm%></td>
					<td><%=ob.appstr_date %> ~ <%=ob.append_date %></td>
					<td><%=ob.prostr_date %> ~ <%=ob.proend_date %></td>
					<td><%=ob.pro_name %></td>
					<td><%=ob.reg_date %></td>
					<td><%=ob.max_per %></td>
					<td><%=ob.status %></td>
					<td><%=ob.show_flag %></td>
					<td>
						<button class="btn small edge mako" type="button" onclick="updateSubmit('<%=ob.pro_no%>')">수정</button>
						<button class="btn small edge red" type="button" onclick="deleteSubmit('<%=ob.pro_no%>')">삭제</button>
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
		<div class="page_area">
			<%=paging.getHtml() %>
		</div>
		<% } %>
	</div>
<!-- //E : #content -->
</body>
</html>
