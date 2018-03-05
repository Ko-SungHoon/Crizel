<%
/**
*   PURPOSE :   승인대기 및 취소 - 상시
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
		<title>RFC관리자 > 승인대기 및 취소 - 상시</title>
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
	public int rowspan;
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

	public String req_date_over;

	public int req_per;
	public int curr_per;
	public int max_per;
	public String dupl_id;


}

private class ArtVOMapper implements RowMapper<ArtVO> {
    public ArtVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ArtVO vo = new ArtVO();
        vo.req_no			=	rs.getInt("REQ_NO");
        vo.rowspan			=	rs.getInt("ROWSPAN");
        vo.pro_no			=	rs.getInt("PRO_NO");
        vo.req_sch_id		=	rs.getString("REQ_SCH_ID");
        vo.sch_mng_nm		=	rs.getString("SCH_MNG_NM");
        vo.sch_mng_tel		=	rs.getString("SCH_MNG_TEL");
        vo.sch_mng_mail		=	rs.getString("SCH_MNG_MAIL");
        vo.reg_date			=	rs.getString("REG_DATE");
        vo.mod_date			=	rs.getString("MOD_DATE");
        vo.reg_ip			=	rs.getString("REG_IP");
        vo.apply_flag		=	rs.getString("APPLY_FLAG");
        vo.req_cnt			=	rs.getInt("REQ_CNT");
        vo.req_date			=	rs.getString("REQ_DATE");
        vo.req_aft_flag		=	rs.getString("REQ_AFT_FLAG");
        vo.req_sch_nm		=	rs.getString("REQ_SCH_NM");
        vo.req_sch_grade	=	rs.getString("REQ_SCH_GRADE");
        vo.req_sch_group	=	rs.getString("REQ_SCH_GROUP");

        vo.pro_cat_nm		=	rs.getString("PRO_CAT_NM");
        vo.pro_name			=	rs.getString("pro_name");

		vo.req_date_over	=	rs.getString("REQ_DATE_OVER");

		vo.req_per			=	rs.getInt("REQ_PER");
		vo.curr_per			=	rs.getInt("CURR_PER");
		vo.max_per			=	rs.getInt("MAX_PER");
		vo.dupl_id			=	rs.getString("DUPL_ID");

        return vo;
    }
}

	private String applyText (String flag) {
        String returnText   =   "승인대기";
        if (flag.equals("Y")) {
            returnText  =   "<span class=\"fb red\">승인완료</span>";
        } else if (flag.equals("N")) {
            returnText  =   "<span class=\"fb blue\">승인대기</span>";
        } else if (flag.equals("A")) {
            returnText  =   "<span class=\"fb\">관리자 취소</span>";
        } else if (flag.equals("C")) {
            returnText  =   "<span class=\"fb\">직접취소</span>";
        } else {
            returnText  =   "<span class=\"fb red\">오류</span>";
        }
        return returnText;
    }

	private String aftText (String aftFlag) {
        String returnText   =   "전일";
        if (aftFlag.equals("M")) {
            returnText  =   "<span class='badge bg-am'>오전</span>";
        } else if (aftFlag.equals("F")) {
            returnText  =   "<span class='badge bg-pm'>오후</span>";
        } else if (aftFlag.equals("D")) {
            returnText  =   "<span class='badge bg-day'>전일</span>";
        }
        return returnText;
    }
%>
<%
StringBuffer sql	=	null;
List<ArtVO> list 	=	null;
String search1		=	parseNull(request.getParameter("search1"));
String keyword		=	parseNull(request.getParameter("keyword"));
String menuCd		=	parseNull(request.getParameter("menuCd"));

Paging paging = new Paging();
paging.setPageSize(20);
String pageNo	=	parseNull(request.getParameter("pageNo"), "1");
int totalCount	=	0;
int tmpCnt		=	0;
int tmpListNo	=	0;
String tmpProNm	=	"";
boolean tmpPerFlag	=	true;
int cnt			=	0;
int num 		=	0;

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
for(int i=0; i < setList.size(); i++){
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
sql.append("			COUNT(*)OVER(PARTITION BY A.REQ_NO) ROWSPAN,        ");
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
sql.append("			B.PRO_NAME,					 						");
sql.append("			(CASE WHEN  A.REQ_DATE > TO_CHAR(SYSDATE, 'YYYY-MM-DD') THEN 'Y'	");
sql.append("			WHEN A.REQ_DATE <= TO_CHAR(SYSDATE, 'YYYY-MM-DD') THEN 'N' 			");
sql.append("			END) AS REQ_DATE_OVER								");
sql.append("			, NVL(C.REQ_PER, 0) AS REQ_PER						");
sql.append("			, (SELECT NVL(SUM(REQ_AL_CNT.REQ_PER), 0) FROM ART_REQ_ALWAY REQ_AL LEFT JOIN ART_REQ_ALWAY_CNT REQ_AL_CNT ON REQ_AL.REQ_NO = REQ_AL_CNT.REQ_NO WHERE REQ_AL.REQ_DATE = A.REQ_DATE AND REQ_AL.APPLY_FLAG = 'Y' AND REQ_AL.REQ_AFT_FLAG IN ('D', A.REQ_AFT_FLAG) AND REQ_AL_CNT.PRO_NO = C.PRO_NO) AS CURR_PER");
sql.append("			, NVL(B.MAX_PER, 0)	AS MAX_PER						");
sql.append("			, (CASE												");
sql.append("			WHEN (SELECT COUNT(REQ_SCH_ID) FROM ART_REQ_ALWAY WHERE REQ_DATE = A.REQ_DATE AND APPLY_FLAG = 'Y') > 1 THEN 'N'	");
sql.append("			ELSE 'Y' END) AS DUPL_ID							");
sql.append("		FROM ART_REQ_ALWAY A LEFT JOIN ART_REQ_ALWAY_CNT C		");
sql.append("		ON A.REQ_NO = C.REQ_NO LEFT JOIN 						");
sql.append("		(SELECT * FROM ART_PRO_ALWAY WHERE DEL_FLAG != 'Y' AND SHOW_FLAG = 'Y') B		");
sql.append("		ON C.PRO_NO = B.PRO_NO									");
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
sql.append(") WHERE RNUM > ").append(paging.getStartRowNo()).append(" \n");

list = jdbcTemplate.query(
			sql.toString(),
			new ArtVOMapper(),
			setObj
		);

num = paging.getRowNo();
%>
<script>
function searchSubmit() {
	$("#searchForm").attr("action", "").submit();
}
function getPopup(type) {
	var addr;
	if(type == "artcode") {
		addr = "/program/art/admin/programAlwaysCodePopup.jsp";
	}else if( type == "insert") {
		addr = "/program/art/admin/programAlwaysInsertPopup.jsp";
	}
	window.open(addr,"PRINTVIEW","width=1000px,height=740px, status=yes, scrollbars=yes, resizable=yes");
}

function approvalSubmit(req_no) {
	if (confirm("접수번호 "+ req_no +"번을 승인처리 하시겠습니까?")) {
		location.href	=	"/program/art/client/programAlwaysReqAction.jsp?dataType=app&reqNo=" + req_no;
		return;
	} else {
		return false;
	}
}

function cancelSubmit(req_no) {
	if(confirm("접수번호 "+ req_no +"번을 취소처리 하시겠습니까?")) {
		location.href	=	"/program/art/client/programAlwaysReqAction.jsp?dataType=can&canAdmin=A&reqNo=" + req_no;
		return;
	}else{
		return false;
	}
}

</script>

<div id="right_view">
		<div class="top_view">
				<p class="location"><strong>프로그램 운영 > 승인대기 및 취소(상시)</strong></p>
		</div>
</div>
<!-- S : #content -->
	<div id="content">
		<div class="btn_area">
			<button type="button" class="btn medium mako" onclick="location.href='/program/art/admin/alwaysReq.jsp'">승인대기 및 취소 - 상시</button>
			<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/alwaysMng.jsp'">프로그램 관리 - 상시</button>
			<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/deepReq.jsp'">승인대기 및 취소 - 심화</button>
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
					<option value="pro_cat_nm" <%if("pro_cat_nm".equals(search1)){%> selected="selected" <%}%>>분류명</option>
					<option value="sch_mng_nm" <%if("sch_mng_nm".equals(search1)){%> selected="selected" <%}%>>담당자명</option>
					<option value="req_sch_nm" <%if("req_sch_nm".equals(search1)){%> selected="selected" <%}%>>학교명</option>
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
		<caption>상시프로그램 승인대기 및 취소 테이블</caption>
		<colgroup>
			<col style="width:5%"/>
			<col style="width:8%"/>
			<col style="width:4%"/>
			<col />
			<col style="width:4%"/>
			<col style="width:4%"/>
			<col style="width:4%"/>
			<col style="width:10%"/>
			<col style="width:8%"/>
			<col style="width:8%"/>
			<col style="width:10%"/>
			<col style="width:5%"/>
			<col style="width:5%"/>
		</colgroup>
		<thead>
			<tr>
				<th scope="col">접수번호</th>
				<th scope="col">신청일</th>
				<th scope="col">분류</th>
				<th scope="col">프로그램명</th>
				<th scope="col">정원</th>
				<th scope="col">현원</th>
				<th scope="col">신청원</th>
				<th scope="col">아이디/학교명</th>
				<th scope="col">담당자명</th>
				<th scope="col">담당자 연락처</th>
				<th scope="col">접수일</th>
				<th scope="col">승인상태</th>
				<th scope="col">관리자<br>승인/취소</th>
			</tr>
		</thead>
		<tbody>
			<%
			if(list!=null && list.size()>0){
			for(ArtVO ob : list) {
			%>
			<tr>
                <%if (!(ob.req_no == tmpListNo)) { %>
				<td rowspan="<%=ob.rowspan %>"><%=ob.req_no %></td>
				<td rowspan="<%=ob.rowspan %>"><a href="javascript:;" class="fb"><%=ob.req_date %></a></td>
				<td rowspan="<%=ob.rowspan %>"><%=aftText(ob.req_aft_flag)%></td>
                <%}%>
				<td align="left"><%
					/*for(ArtVO proNm : list) {
						if (tmpListNo == proNm.req_no && tmpProNm.equals("")) {
							tmpProNm	=	"<span>" + proNm.pro_name + "</span>/" + proNm.req_per + "/" + proNm.curr_per + "/" + proNm.max_per;
						} else if (tmpListNo == proNm.req_no && tmpProNm.length() > 1) {
							tmpProNm	+=	"<br>" + "<span>" + proNm.pro_name + "</span>/" + proNm.req_per + "/" + proNm.curr_per + "/" + proNm.max_per;
						}
						//정원을 초과할 경우가 1개라도 발생할 경우 false 저장
						if (tmpListNo == proNm.req_no && (proNm.max_per < proNm.req_per + proNm.curr_per)) {
							tmpPerFlag	=	false;
						}
					}//END FOR
					out.println(tmpProNm);*/
                    out.println(ob.pro_name);
				%></td>
                <td><%=ob.max_per %></td>
                <td><%=ob.curr_per %></td>
                <td><%=ob.req_per %></td>
            <%if (!(ob.req_no == tmpListNo)) { %>
				<%/*이미 아이디 2개 등록된 신청일 경우 빨간색 표시*/%>
				<td rowspan="<%=ob.rowspan %>"><span <%if("N".equals(ob.dupl_id)) out.println("class='red'"); %>><%=ob.req_sch_id %></span> / <%=ob.req_sch_nm %></td>
				<td rowspan="<%=ob.rowspan %>"><%=ob.sch_mng_nm %></td>
				<td rowspan="<%=ob.rowspan %>"><%=ob.sch_mng_tel %></td>
				<td rowspan="<%=ob.rowspan %>"><%=ob.reg_date %></td>
				<td rowspan="<%=ob.rowspan %>"><%=applyText(ob.apply_flag) %></td>
				<td rowspan="<%=ob.rowspan %>">
					<%
					//승인 버튼 활성화 여부 중요!!!!
					if (ob.req_date_over.equals("Y")) {
						if("N".equals(ob.apply_flag)) {
							//승인 아이디 2개와 인원 여부 확인
							if ("Y".equals(ob.dupl_id) && tmpPerFlag) {
						%><button type="button" class="btn small edge green" onclick="approvalSubmit('<%=ob.req_no%>')">승인</button><%
							} else {
						%><span class="red">승인불가</span><%
							}
						} else if("Y".equals(ob.apply_flag)) {
						%><button type="button" class="btn small edge white" onclick="cancelSubmit('<%=ob.req_no%>')">취소</button><%
						} else if("A".equals(ob.apply_flag)) {		//관리자 취소
						%>관리자 취소<%
							if ("Y".equals(ob.dupl_id) && tmpPerFlag) {
						%><button type="button" class="btn small edge green" onclick="approvalSubmit('<%=ob.req_no%>')">승인</button><%
							} else {
						%><span class="red">승인불가</span><%
							}
						} else if("C".equals(ob.apply_flag)) {		//사용자 취소
						%><%--사용자 취소--%><%
							if ("Y".equals(ob.dupl_id) && tmpPerFlag) {
						%><button type="button" class="btn small edge green" onclick="approvalSubmit('<%=ob.req_no%>')">승인</button><%
							} else {
						%><span class="red">승인불가</span><%
							}
						}
					} else {
						out.println("기간초과");
					}
					%>
				</td>
            <%}%>
			</tr>
			<%
                if (!(ob.req_no == tmpListNo)) {
					tmpListNo	=	ob.req_no;
					tmpProNm	=	"";
					tmpPerFlag	=	true;
                }//END IF
			}//END FOR
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
<!-- // E : #content -->
</body>
</html>
