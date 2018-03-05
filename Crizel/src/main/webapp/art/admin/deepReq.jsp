<%
/**
*   PURPOSE :   승인대기 및 취소 - 심화
*   CREATE  :   20180130_tue    Ko
*   MODIFY  :   20180223 LJH 마크업, 클래스 수정
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>

<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 승인대기 및 취소 - 심화</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
<script>
</script>
</head>
<body>
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
	public int max_per;
	public int curr_per;

    public String pro_sts_flag;
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
        vo.max_per          = rs.getInt("MAX_PER");
        vo.curr_per         = rs.getInt("CURR_PER");

        vo.pro_sts_flag     = rs.getString("PRO_STS_FLAG");

        return vo;
    }
}

//승인 여부
private String reqFlag (String req_flag, String sts_flag, int per_remain) {
    String retStr   =   null;
    if (!("PE".equals(sts_flag))) {
        if ("Y".equals(req_flag)) {
            retStr  =   "<span class='fb red'>승인완료</span>";
        } else if ("AC".equals(req_flag)) {
            retStr  =   "<span class='fb red'>관리자 취소</span>";
        } else if ("C".equals(req_flag)) {
            retStr  =   "<span class='fb red'>직접 취소</span>";
        } else {
            if (per_remain < 0) {
                retStr  =   "<span class='red'>승인불가</span>";
            } else retStr  =   "<span class='blue'>승인대기</span>";
        }
    } else {
        retStr  =   "<span>프로그램 종료</span>";
    }
    return retStr;
}

//승인 여부 버튼
private String reqFlag (String req_flag, String sts_flag, int per_remain, int req_no) {
    String retStr   =   null;
    if (!("PE".equals(sts_flag))) {
        if ("Y".equals(req_flag)) {
            retStr  =   "<button class=\"btn small edge white\" type=\"button\" onclick=\"cancelSubmit('"+ req_no +"')\">취소</button>";
        } else if ("AC".equals(req_flag)) {
            retStr  =   "<button class=\"btn small edge green\" type=\"button\" onclick=\"approvalSubmit('"+ req_no +"')\">승인</button>";
        } else if ("C".equals(req_flag)) {
            retStr  =   "<button class=\"btn small edge green\" type=\"button\" onclick=\"approvalSubmit('"+ req_no +"')\">승인</button>";
        } else {
            if (per_remain < 0) {
                retStr  =   "-";
            } else retStr  =   "<button class=\"btn small edge green\" type=\"button\" onclick=\"approvalSubmit('"+ req_no +"')\">승인</button>";
        }
    } else {
        retStr  =   "<span>-</span>";
    }
    return retStr;
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
sql.append("			B.PRO_NAME,					 						");
sql.append("			B.MAX_PER,					 						");
sql.append("			B.CURR_PER,					 						");

sql.append("			(CASE  					 					       	");
sql.append("			WHEN SYSDATE > B.PROEND_DATE THEN 'PE'  			");
sql.append("			WHEN SYSDATE > B.APPEND_DATE OR  					");
sql.append("			B.MAX_PER <= (SELECT NVL(SUM(REQ_PER), 0) FROM (SELECT * FROM ART_REQ_DEEP WHERE APPLY_FLAG = 'Y' AND SHOW_FLAG = 'Y' AND DEL_FLAG != 'Y') WHERE PRO_NO = A.PRO_NO)  ");
sql.append("			THEN 'AE'  					 						");
sql.append("			WHEN SYSDATE < B.APPSTR_DATE THEN 'N'  	     		");
sql.append("			ELSE 'Y'  					 						");
sql.append("			END) AS PRO_STS_FLAG     	 						");

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
	var addr = "/program/art/client/programDeepReqAction.jsp?mode=app&req_no="+req_no;
	location.href=addr;
    return;
}

function cancelSubmit(req_no){
	var addr = "/program/art/client/programDeepReqAction.jsp?mode=can&canAdmin=A&req_no="+req_no;
	location.href=addr;
    return;
}

</script>
<div id="right_view">
		<div class="top_view">
				<p class="location"><strong>프로그램 운영 > 승인대기 및 취소(심화)</strong></p>
		</div>
</div>
<!-- S : #content -->
	<div id="content">
		<div class="btn_area">
			<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/alwaysReq.jsp'">승인대기 및 취소 - 상시</button>
			<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/alwaysMng.jsp'">프로그램 관리 - 상시</button>
			<button type="button" class="btn medium mako" onclick="location.href='/program/art/admin/deepReq.jsp'">승인대기 및 취소 - 심화</button>
			<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/deepMng.jsp'">프로그램 관리 - 심화</button>
			<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/programStat.jsp'">통계관리</button>
		</div>
		<div class="searchBox magT20 magB20">
			<form id="searchForm" method="get" class="topbox2">
				<fieldset>
				<input type="hidden" id="menuCd" name="menuCd" value="<%=menuCd%>">
					<!-- <label for="search1">년도</label> -->
					<select id="search1" name="search1">
						<option value="">선택</option>
						<option value="pro_cat_nm"  <%if("pro_cat_nm".equals(search1)){%> selected="selected" <%}%>>분류명</option>
						<option value="req_user_nm" <%if("req_user_nm".equals(search1)){%> selected="selected" <%}%>>담당자명</option>
					</select>
					<!-- <label for="keyword">검색어</label> -->
					<input type="text" id="keyword" name="keyword" value="<%=keyword%>">
					<button class="btn small edge mako" onclick="searchSubmit();">검색하기</button>
				</fieldset>
			</form>
		</div>

		<p>
			<strong>총 <span><%=totalCount%></span> 건
			</strong> [ Page <%=pageNo %>/<%=paging.getFinalPageNo() %>]
		</p>
		<table class="bbs_list">
			<caption>심화프로그램 승인대기 및 취소 테이블</caption>
			<colgroup>
			</colgroup>
			<thead>
				<tr>
					<th scope="col">순서</th>
					<th scope="col">분류</th>
					<th scope="col">프로그램명</th>
					<th scope="col">정원</th>
					<th scope="col">현원</th>
					<th scope="col">신청원</th>
					<th scope="col">신청자명</th>
					<th scope="col">신청자 연락처</th>
					<th scope="col">신청일</th>
					<th scope="col">승인상태</th>
					<th scope="col">승인/취소</th>
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
					<td><%=ob.max_per %></td>
					<td><%=ob.curr_per %></td>
					<td><%=ob.req_per %></td>
					<td><%=ob.req_user_nm %></td>
					<td><%=ob.req_user_tel %></td>
					<td><%=ob.reg_date %></td>
					<td><%=reqFlag(ob.apply_flag, ob.pro_sts_flag, (ob.max_per - (ob.curr_per + ob.req_per))) %></td>
					<td><%=reqFlag(ob.apply_flag, ob.pro_sts_flag, (ob.max_per - (ob.curr_per + ob.req_per)), ob.req_no) %></td>
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
		<div class="page_area">
			<%=paging.getHtml() %>
		</div>
		<% } %>
	</div>
</div>
</body>
</html>
