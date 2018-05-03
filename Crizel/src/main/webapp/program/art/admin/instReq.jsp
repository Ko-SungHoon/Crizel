<%
/**
*   PURPOSE :   신청 관리
*   CREATE  :   20180201_thur    Ko
*   MODIFY  :   20180223 LJH 클래스수정
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
/************************** 접근 허용 체크 - 시작 **************************/
SessionManager sessionManager = new SessionManager(request);
String sessionId = sessionManager.getId();
if(sessionId == null || "".equals(sessionId)) {
	alertParentUrl(out, "관리자 로그인이 필요합니다.", adminLoginUrl);
	if(true) return;
}

String roleId= null;
String[] allowIp = null;
Connection conn = null;
try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	// 접속한 관리자 회원의 권한 롤
	roleId= getRoleId(sqlMapClient, conn, sessionId);
	
	// 관리자 접근 허용된 IP 배열
	allowIp = getAllowIpArrays(sqlMapClient, conn);
} catch (Exception e) {
	sqlMapClient.endTransaction();
	alertBack(out, "트랜잭션 오류가 발생했습니다.");
} finally {
	sqlMapClient.endTransaction();
}

// 권한정보 체크
boolean isAdmin = sessionManager.isRole(roleId);

// 접근허용 IP 체크
String thisIp = request.getRemoteAddr();
boolean isAllowIp = isAllowIp(thisIp, allowIp);

/** Method 및 Referer 정보 **/
String getMethod = parseNull(request.getMethod());
String getReferer = parseNull(request.getHeader("referer"));

if(!isAdmin) {
	alertBack(out, "해당 사용자("+sessionId+")는 접근 권한이 없습니다.");
	if(true) return;
}
if(!isAllowIp) {
	alertBack(out, "해당 IP("+thisIp+")는 접근 권한이 없습니다.");
	if(true) return;
}
/************************** 접근 허용 체크 - 종료 **************************/

//SessionManager sessionManager = new SessionManager(request);
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

Object[] setObj		= null;
List<String> setList	= new ArrayList<String>();

sql = new StringBuffer();
sql.append("		SELECT	COUNT(*) CNT		 																									");
sql.append("		FROM ART_INST_REQ A																												");
sql.append("		WHERE 1=1					 																									");
if(!"".equals(search1) && !"".equals(keyword)){
	if("inst_cat_nm".equals(search1)){
		sql.append(" AND A.REQ_NO = (SELECT REQ_NO FROM ART_INST_REQ_CNT WHERE REQ_NO = A.REQ_NO AND INST_CAT_NM LIKE '%'||?||'%' GROUP BY REQ_NO) 	");
		setList.add(keyword);
	}else if("req_mng_nm".equals(search1)){
		sql.append(" AND A.REQ_MNG_NM LIKE '%'||?||'%'																								");
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
sql.append("			A.APPLY_FLAG,				 						");
sql.append("			A.APPLY_DATE,				 						");
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
sql.append("			(SELECT NVL(SUM(INST_REQ_CNT),0) FROM ART_INST_REQ_CNT WHERE REQ_NO = A.REQ_NO) INST_REQ_CNT			");
sql.append("		FROM ART_INST_REQ A																							");
sql.append("		WHERE 1=1					 																				");
if(!"".equals(search1) && !"".equals(keyword)){
	if("inst_cat_nm".equals(search1)){
		sql.append(" AND A.REQ_NO = (SELECT REQ_NO FROM ART_INST_REQ_CNT WHERE REQ_NO = A.REQ_NO AND INST_CAT_NM LIKE '%'||?||'%' GROUP BY REQ_NO) 	");
	}else if("req_mng_nm".equals(search1)){
		sql.append(" AND A.REQ_MNG_NM LIKE '%'||?||'%'																								");
	}
paging.setParams("search1", search1);
paging.setParams("keyword", keyword);
}
sql.append("ORDER BY CASE WHEN A.APPLY_FLAG IN ('N') THEN 0 ELSE 1 END,A.REQ_NO DESC			 								");
sql.append("	) A WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" \n");
sql.append(") WHERE RNUM >= ").append(paging.getStartRowNo()).append(" \n	");

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
function getPopup(type){
	var addr = "/program/art/insAdmin/instMngPopup.jsp";
	newWin(addr, 'PRINTVIEW', '1000', '740');
}

function updateSubmit(req_no){
	var addr = "/program/art/insAdmin/instMngPopup.jsp?mode=update&req_no="+req_no;
	newWin(addr, 'PRINTVIEW', '1000', '740');
	//window.open(addr,"PRINTVIEW","width=1000px,height=740px, status=yes, scrollbars=yes, resizable=yes");
}

function applySubmit(req_no, apply_flag, inst_no){
	var msg;

	if(apply_flag == "Y"){
		msg = "악기대여 신청을 승인하시겠습니까?";
	}else if(apply_flag == "A"){
		msg = "악기대여 신청을 취소하시겠습니까?";
	}else if(apply_flag == "R"){
		msg = "악기대여 상태를 반납으로 변경하시겠습니까?";
	}

	if(confirm(msg)){
		location.href="/program/art/insAdmin/instMngAction.jsp?mode=apply&req_no="+req_no+"&apply_flag="+apply_flag+"&inst_no="+inst_no;
	}else{
		return false;
	}
}

</script>

<div id="right_view">
	<div class="top_view">
		<p class="location"><strong>신청 관리</strong></p>
		<p class="loc_admin">
            <a href="/iam/main/index.sko?lang=en_US" target="_top" class="white">ENGLISH</a> <span class="yellow">[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span>님 안녕하세요.
            <a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
        </p>
	</div>
</div>
<!-- S : #content -->
<div id="content">
	<div class="btn_area">
		<p class="boxin">
			<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/instMng.jsp'">악기 관리</button>
			<button type="button" class="btn medium mako" onclick="location.href='/program/art/admin/instReq.jsp'">신청관리</button>
			<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/instStat.jsp'">통계관리</button>
		</p>
	</div>

	<div class="searchBox magB20">
		<form id="searchForm" method="get" class="topbox2">
			<fieldset>
				<!-- <label for="search1">검색분류</label> -->
				<select id="search1" name="search1">
					<option value="">선택</option>
					<option value="inst_cat_nm" <%if("inst_cat_nm".equals(search1)){%> selected="selected" <%}%>>분류명</option>
					<option value="req_mng_nm" <%if("req_mng_nm".equals(search1)){%> selected="selected" <%}%>>담당자명</option>
				</select>
				<!-- <label for="keyword">검색어</label> -->
				<input type="text" id="keyword" name="keyword" value="<%=keyword%>">
				<button class="btn small edge mako" onclick="searchSubmit();">검색하기</button>
			</fieldset>
		</form>
	</div>

	<div class="f_r">
		<button type="button" class="btn small edge darkMblue" onclick="getPopup('artcode');">신청관리</button>
	</div>
	<p class="f_l magT10">
		<strong>총 <span><%=totalCount%></span> 건
		</strong> [ Page <%=pageNo %>/<%=paging.getFinalPageNo() %>]
	</p>
	<p class="clearfix"> </p>

	<table class="bbs_list">
		<caption>악기 신청관리 테이블</caption>
		<colgroup>
			<col width="5%"/>
			<col width="8%"/>
			<col />
			<col width="7%"/>
			<col width="10%"/>
			<col width="10%"/>
			<col width="10%"/>
			<col width="10%"/>
			<col width="8%"/>
			<col width="8%"/>
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
				<th scope="col">수정</th>
				<th scope="col">승인</th>
			</tr>
		</thead>
		<tbody>
			<%
			if(list!=null && list.size()>0){
			for(InsVO ob : list){ %>
			
			<tr <%if("N".equals(ob.apply_flag)){out.println("class=\"bak-yellow\""); }%> >
				<td><%=num--%></td>
				<td><%=ob.inst_cat_nm%></td>
				<td><%=ob.inst_nm %></td>
				<td><%=ob.inst_req_cnt %></td>
				<td><%=ob.req_id %>/<%=ob.req_mng_nm %></td>
				<td><%=parseNull(ob.req_group)%></td>
				<td><%=telSet(ob.req_mng_tel)%></td>
				<td><%=ob.reg_date %></td>
				<td><button class="btn small edge mako" type="button" onclick="updateSubmit('<%=ob.req_no%>')">수정</button></td>
				<td>
					<%
					if("N".equals(ob.apply_flag)){
					%>
						<button class="btn small edge green" type="button" onclick="applySubmit('<%=ob.req_no%>', 'Y', '<%=ob.inst_no%>')">승인</button>
						<button class="btn small edge white" type="button" onclick="applySubmit('<%=ob.req_no%>', 'A', '')">반려</button>
					<%
					}else if("Y".equals(ob.apply_flag)){
					%>
						<button class="btn small edge green" type="button" onclick="applySubmit('<%=ob.req_no%>', 'R', '')">반납</button>
						<button class="btn small edge white" type="button" onclick="applySubmit('<%=ob.req_no%>', 'A', '')">취소</button>
					<%
					}else if("A".equals(ob.apply_flag)){		//관리자 취소
					%>
						<span class="red">관리자 취소</span>
					<%
					}else if("C".equals(ob.apply_flag)){		//사용자 취소
					%>
						<span class="red">사용자 취소</span>
					<%
					}else if("R".equals(ob.apply_flag)){		//반납
					%>
						<span>반납완료</span>
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
				<td colspan="10">등록된 게시물이 없습니다.</td>
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
