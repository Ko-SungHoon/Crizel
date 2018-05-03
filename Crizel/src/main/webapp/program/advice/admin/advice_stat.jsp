<%
/**
*	상담현황 통계
*/

%>

<%@page import="com.ibm.icu.util.SimpleTimeZone"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 상담현황 통계</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
		<link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css"/>
		<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script>
$(function() {
    $("#search_st_dt").datepicker({
		showButtonPanel: true,
		buttonImageOnly: true,
		currentText: '오늘 날짜',
		closeText: '닫기',
		dateFormat: "yymmdd",
		monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        dayNamesMin: ['일','월','화','수','목','금','토'],
		changeMonth: true, //월변경가능
        changeYear: true, //년변경가능
		showMonthAfterYear: true, //년 뒤에 월 표시
		showOn: "both",
		buttonImage: '${pageContext.request.contextPath}/jquery/icon_calendar.gif',
	    buttonImageOnly: true
     });

    $("#search_ed_dt").datepicker({
		showButtonPanel: true,
		buttonImageOnly: true,
		currentText: '오늘 날짜',
		closeText: '닫기',
		dateFormat: "yymmdd",
		monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        dayNamesMin: ['일','월','화','수','목','금','토'],
		changeMonth: true, //월변경가능
        changeYear: true, //년변경가능
		showMonthAfterYear: true, //년 뒤에 월 표시
		showOn: "both",
		buttonImage: '${pageContext.request.contextPath}/jquery/icon_calendar.gif',
	    buttonImageOnly: true
     });


    $('img.ui-datepicker-trigger').css({'cursor':'pointer', 'margin-left':'-22px', 'margin-top':'1px'});
});
</script>
</head>
<body>
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

SimpleDateFormat dfhm1        = new SimpleDateFormat("yyyyMMdd");
Calendar cal = Calendar.getInstance();
cal.add(Calendar.YEAR, -10);
String prevday = dfhm1.format(cal.getTime());

SimpleDateFormat dfhm        = new SimpleDateFormat("yyyyMMdd");
cal = Calendar.getInstance();
String today = dfhm.format(cal.getTime());

//SessionManager sessionManager = new SessionManager(request);

response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

//Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
List<Map<String, Object>> dataList = null;


String teacher_id       = parseNull(request.getParameter("teacher_id"));
String teacher_nm       = parseNull(request.getParameter("teacher_nm"));
String teacher_view     = parseNull(request.getParameter("teacher_view"));
String category_gb      = parseNull(request.getParameter("category_gb"));
String target_gb        = parseNull(request.getParameter("target_gb"));
String wait_cnt         = parseNull(request.getParameter("wait_cnt"));
String succ_cnt         = parseNull(request.getParameter("succ_cnt"));
String cancel_cnt       = parseNull(request.getParameter("cancel_cnt"));
String total_cnt        = parseNull(request.getParameter("total_cnt"));
/**
*	PURPOSE	:	본인삭제(상담대기중) cnt 와 본인삭제(상담완료) cnt
*	CREATE	:	20171101_fri	JI
*/
String del_hold_cnt		= parseNull(request.getParameter("del_hold_cnt"));	//본인삭제(상담대기중) cnt
String del_comp_cnt		= parseNull(request.getParameter("del_comp_cnt"));	//본인삭제(상담완료) cnt


String search_st_dt = parseNull(request.getParameter("search_st_dt"),prevday);	//검색시작일자
String search_ed_dt = parseNull(request.getParameter("search_ed_dt"),today);		//검색종료일자
String search_category_gb = parseNull(request.getParameter("search_category_gb"));	//분류 A01 = 진로 , A02 = 진학
String search_target_gb = parseNull(request.getParameter("search_target_gb"));		//대상 B01 = 초등 , B02 = 중등
String search_gb = parseNull(request.getParameter("search_gb")); //검색구분
String search_keyword = parseNull(request.getParameter("search_keyword")); //검색어

int num = 0;


Paging paging = new Paging();
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
int cnt=0;



try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	//학교 카운트
	cnt = 0;
	sql = new StringBuffer();
	sql.append("SELECT COUNT(*) CNT FROM ADVICE_TEACHER WHERE 1=1 ");

	if(!"".equals(parseNull(search_category_gb))){	//분류
		sql.append("AND CATEGORY_GB = ? ");
		paging.setParams("search_category_gb", search_category_gb);
	}

	if(!"".equals(parseNull(search_target_gb))){	//대상
		sql.append("AND TARGET_GB = ? ");
		paging.setParams("search_target_gb", search_target_gb);

	}

	if(!"".equals(parseNull(search_keyword))){
		if("A".equals(search_gb)){	//이름
			sql.append("AND TEACHER_NM LIKE '%'||?||'%' ");
		}else if("B".equals(search_gb)){	//아이디
			sql.append("AND TEACHER_ID LIKE '%'||?||'%' ");
			paging.setParams("search_keyword", search_keyword);
		}
	}


	pstmt = conn.prepareStatement(sql.toString());


	if(!"".equals(parseNull(search_category_gb))){
		++cnt;
		pstmt.setString(cnt, search_category_gb);
	}

	if(!"".equals(parseNull(search_target_gb))){
		++cnt;
		pstmt.setString(cnt, search_target_gb);
	}

	if(!"".equals(parseNull(search_keyword))){
		++cnt;
		pstmt.setString(cnt, search_keyword);
	}

	rs = pstmt.executeQuery();
	if(rs.next()){
		totalCount = rs.getInt("CNT");
	}

	paging.setPageNo(Integer.parseInt(pageNo));
	paging.setTotalCount(totalCount);
	paging.setPageSize(10);
	paging.setPageBlock(10);


	//상담교사 리스트
	cnt = 0;
	sql = new StringBuffer();
	sql.append("SELECT * FROM ( \n");
	sql.append("	SELECT * FROM ( \n");
	sql.append("        SELECT													 \n");
	sql.append("        ROWNUM AS RNUM                                           \n");
	sql.append("        , A.TEACHER_ID                                           \n");
	sql.append("        , A.TEACHER_NM                                           \n");
	sql.append("        , CASE WHEN A.CATEGORY_GB = 'A01' THEN '진로'              \n");
	sql.append("               WHEN A.CATEGORY_GB = 'A02' THEN '진학'              \n");
	sql.append("          END CATEGORY_GB                                        \n");
	sql.append("        , CASE WHEN A.TARGET_GB = 'B01' THEN '초등'                \n");
	sql.append("               WHEN A.TARGET_GB = 'B02' THEN '중등'                \n");
	sql.append("          END TARGET_GB                                          \n");
	sql.append("        , (                                                      \n");
	sql.append("              SELECT                                             \n");
	sql.append("                COUNT(*)                                         \n");
	sql.append("              FROM ADVICE_BOARD_LOG B                                \n");
	sql.append("              WHERE B.BOARD_LVL = 0 AND ADVICE_STS <> 'C'                     \n");
	sql.append("              AND NOTICE_YN = 'N'                                \n");
	sql.append("              AND B.ADVICE_STS = 'A'                             \n");
	sql.append("              AND B.TEACHER_ID = A.TEACHER_ID                    \n");
	if(!"".equals(parseNull(search_st_dt)) && !"".equals(parseNull(search_ed_dt))){	//검색일자
		sql.append("          AND REG_DT >= '"+search_st_dt+"'                   \n");
		sql.append("          AND REG_DT <= '"+search_ed_dt+"'                   \n");
	}
	sql.append("           ) AS WAIT_CNT                                         \n");

	sql.append("        , (                                                      \n");
	sql.append("              SELECT                                             \n");
	sql.append("                COUNT(*)                                         \n");
	sql.append("              FROM ADVICE_BOARD_LOG B                                \n");
	//sql.append("              WHERE B.BOARD_LVL = 1  AND ADVICE_STS <> 'C'       \n");
	sql.append("              WHERE NOTICE_YN = 'N'                                \n");
	sql.append("              AND B.ADVICE_STS = 'B'                             \n");
	sql.append("              AND B.TEACHER_ID = A.TEACHER_ID                    \n");
	if(!"".equals(parseNull(search_st_dt)) && !"".equals(parseNull(search_ed_dt))){	//검색일자
		sql.append("          AND REG_DT >= '"+search_st_dt+"'                   \n");
		sql.append("          AND REG_DT <= '"+search_ed_dt+"'                   \n");
	}
	sql.append("           ) AS SUCC_CNT                                         \n");

	sql.append("        , (                                                      \n");
	sql.append("              SELECT                                             \n");
	sql.append("                COUNT(*)                                         \n");
	sql.append("              FROM ADVICE_BOARD_LOG B                                \n");
	//sql.append("              WHERE B.BOARD_LVL = 1                              \n");
	sql.append("              WHERE NOTICE_YN = 'N'                              \n");
	sql.append("              AND B.ADVICE_STS = 'C'                             \n");
	sql.append("              AND B.TEACHER_ID = A.TEACHER_ID                    \n");
	if(!"".equals(parseNull(search_st_dt)) && !"".equals(parseNull(search_ed_dt))){	//검색일자
		sql.append("          AND REG_DT >= '"+search_st_dt+"'                   \n");
		sql.append("          AND REG_DT <= '"+search_ed_dt+"'                   \n");
	}
	sql.append("           ) AS CANCEL_CNT                                       \n");
	
	/**
	*	PURPOSE	:	본인삭제(상담대기중), 본인삭제(상담완료) 부분 추가
	*	CREATE	:	20171103_fri	JI
	*	MODIFY	:	...
	*/

	sql.append("        , (                                                      \n");
	sql.append("              SELECT                                             \n");
	sql.append("                COUNT(*)                                         \n");
	sql.append("              FROM ADVICE_BOARD_LOG B                                \n");
	sql.append("              WHERE NOTICE_YN = 'N'  AND ADVICE_STS <> 'C'                              \n");
	sql.append("              AND B.ADVICE_STS = 'D'                             \n");
	sql.append("              AND B.TEACHER_ID = A.TEACHER_ID                    \n");
	if(!"".equals(parseNull(search_st_dt)) && !"".equals(parseNull(search_ed_dt))){	//검색일자
		sql.append("          AND REG_DT >= '"+search_st_dt+"'                   \n");
		sql.append("          AND REG_DT <= '"+search_ed_dt+"'                   \n");
	}
	sql.append("           ) AS DEL_HOLD_CNT                                       \n");

	sql.append("        , (                                                      \n");
	sql.append("              SELECT                                             \n");
	sql.append("                COUNT(*)                                         \n");
	sql.append("              FROM ADVICE_BOARD_LOG B                                \n");
	sql.append("              WHERE NOTICE_YN = 'N'  AND ADVICE_STS <> 'C'                              \n");
	sql.append("              AND B.ADVICE_STS = 'E'                             \n");
	sql.append("              AND B.TEACHER_ID = A.TEACHER_ID                    \n");
	if(!"".equals(parseNull(search_st_dt)) && !"".equals(parseNull(search_ed_dt))){	//검색일자
		sql.append("          AND REG_DT >= '"+search_st_dt+"'                   \n");
		sql.append("          AND REG_DT <= '"+search_ed_dt+"'                   \n");
	}
	sql.append("           ) AS DEL_COMP_CNT                                       \n");

	/** END */
	
	sql.append("        , (                                                      \n");
	sql.append("              SELECT                                             \n");
	sql.append("                COUNT(*)                                         \n");
	sql.append("              FROM ADVICE_BOARD_LOG B                                \n");
	sql.append("              WHERE B.BOARD_LVL = 1  AND ADVICE_STS <> 'C'         \n");
	sql.append("              AND NOTICE_YN = 'N'                                \n");
	sql.append("              AND B.TEACHER_ID = A.TEACHER_ID                    \n");
	if(!"".equals(parseNull(search_st_dt)) && !"".equals(parseNull(search_ed_dt))){	//검색일자
		sql.append("          AND REG_DT >= '"+search_st_dt+"'                   \n");
		sql.append("          AND REG_DT <= '"+search_ed_dt+"'                   \n");
	}
	sql.append("           ) AS TOTAL_CNT                                        \n");

	sql.append("        FROM ADVICE_TEACHER A                                    \n");
	sql.append("        WHERE 1=1			                        			 \n");

	if(!"".equals(parseNull(search_category_gb))){	//분류
		sql.append("AND A.CATEGORY_GB = ? ");
		paging.setParams("search_category_gb", search_category_gb);
	}

	if(!"".equals(parseNull(search_target_gb))){	//대상
		sql.append("AND A.TARGET_GB = ? ");
		paging.setParams("search_target_gb", search_target_gb);

	}

	if(!"".equals(parseNull(search_keyword))){
		if("A".equals(search_gb)){	//이름
			sql.append("AND A.TEACHER_NM LIKE '%'||?||'%' ");
		}else if("B".equals(search_gb)){	//아이디
			sql.append("AND A.TEACHER_ID LIKE '%'||?||'%' ");
			paging.setParams("search_keyword", search_keyword);
		}
	}

	sql.append("		ORDER BY A.TEACHER_NM ASC ");
	sql.append("	) A WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" \n");
	sql.append(") WHERE RNUM > ").append(paging.getStartRowNo()).append(" \n");
	pstmt = conn.prepareStatement(sql.toString());

	if(!"".equals(parseNull(search_category_gb))){
		++cnt;
		pstmt.setString(cnt, search_category_gb);
	}

	if(!"".equals(parseNull(search_target_gb))){
		++cnt;
		pstmt.setString(cnt, search_target_gb);
	}

	if(!"".equals(parseNull(search_keyword))){
		++cnt;
		pstmt.setString(cnt, search_keyword);
	}

	rs = pstmt.executeQuery();
	dataList = getResultMapRows(rs);


} catch (Exception e) {
	%>
	<%=e.toString() %>
	<%
	e.printStackTrace();
	sqlMapClient.endTransaction();
	//alertBack(out, "처리중 오류가 발생하였습니다.");
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
}

%>
<script>
function postForm(reserve_type){
	$("#postForm").submit();
}
function search(){
	if($.trim($("#search1").val()) == "" && $.trim($("#search2").val()) != "" ){
		alert("연도를 선택하여 주시기 바랍니다.");
		return false;
	}
	$("#postForm").submit();
}

//상담선생님 수정
function modify(school_id){
	alert("준비중입니다.");
}

//상담 로그 엑셀다운로드
function excel(){
	$("#searchForm").attr("action","./excel3.jsp");
	$("#searchForm").submit();
}
</script>
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>상담현황 통계</strong></p>
      <p class="location" style="float:right; margin-right:20px;">
		<span><a href="/iam/main/index.sko?lang=en_US" target="_top" class="last co_yellow">ENGLISH</a>[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span>님 안녕하세요.
		<a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
  	</p>
  </div>
	<div id="content">
		<div class="searchBox">
			<form action="./advice_stat.jsp" method="post" id="searchForm">
				<fieldset>
					<legend>검색하기</legend>
					<input type="hidden" name="pageNo" id="pageNo" value="<%=pageNo%>">
					<div class="boxinner">
						<span>
							<label for="search_st_dt">기간</label>
							<input type="text" id="search_st_dt" name="search_st_dt" value="<%=search_st_dt %>" />
							<input type="text" id="search_ed_dt" name="search_ed_dt" value="<%=search_ed_dt %>" />
						</span>
						<span>
							<label for="search_category_gb">분류</label>
							<select name="search_category_gb" id="search_category_gb" for="search_category_gb" value="<%=search_category_gb%>">
								<option value="">전체</option>
								<option <%if("A01".equals(search_category_gb)){ %>selected="selected"<% } %> value="A01">진로</option>
								<option <%if("A02".equals(search_category_gb)){ %>selected="selected"<% } %> value="A02">진학</option>
							</select>
						</span>
						<span>
							<label for="search_target_gb">대상</label>
							<select name="search_target_gb" id="search_target_gb" for="search_target_gb" value="<%=search_target_gb%>">
								<option value="">전체</option>
								<option <%if("B01".equals(search_target_gb)){ %>selected="selected"<% } %> value="B01">초등</option>
								<option <%if("B02".equals(search_target_gb)){ %>selected="selected"<% } %> value="B02">중등</option>
							</select>
							<select name="search_gb" id="search_gb" >
								<option <%if("A".equals(search_gb)){ %>selected="selected"<% } %> value="A">이름</option>
								<option <%if("B".equals(search_gb)){ %>selected="selected"<% } %> value="B">아이디</option>
							</select>
							<input type="text" name="search_keyword" id="search_keyword" value="<%=search_keyword%>">
							<input type="submit" value="검색" class="btn small edge mako">
						</span>
					</div>
				</fieldset>
			</form>
		</div>
		
		<div class="btn_area txt_r magT20">
			<button type="button" onclick="excel();" class="btn medium edge mako">엑셀다운로드</button>
		</div>

		<div class="listArea">
			<form action="" method="post" id="postForm">
				<fieldset>
					<legend>상담현황 통계 결과</legend>
					<table class="bbs_list">
						<colgroup>
						<col class="wps_5"/>
						<col class="wps_5" />
						<col class="wps_5"/>
						<col />
						<col class="wps_10"/>
						<col class="wps_10"/>
						<col class="wps_10"/>
						<col class="wps_10"/>
						</colgroup>
						<thead>
							<tr>
								<th scope="col">번호</th>
								<th scope="col">분류</th>
								<th scope="col">대상</th>
								<th scope="col">상담교사명(아이디)</th>
								<th scope="col">상담대기중</th>
								<th scope="col">상담완료</th>
								<th scope="col">미상담 건수</th>
								<th scope="col">합계</th>
							</tr>
						</thead>
						<tbody>
						<%
						if(dataList != null && dataList.size() > 0){
							num = paging.getRowNo();
							for(int i=0; i<dataList.size(); i++){
								Map<String,Object> map = dataList.get(i);

								teacher_id    = parseNull((String)map.get("TEACHER_ID"));
								teacher_nm    = parseNull((String)map.get("TEACHER_NM"));
								teacher_view  = parseNull((String)map.get("TEACHER_VIEW"));
								category_gb   = parseNull((String)map.get("CATEGORY_GB"));
								target_gb     = parseNull((String)map.get("TARGET_GB"));
								wait_cnt      = parseNull((String)map.get("WAIT_CNT"));		//상담대기중 카운트
								succ_cnt      = parseNull((String)map.get("SUCC_CNT"));		//상담완료 카운트
								cancel_cnt    = parseNull((String)map.get("CANCEL_CNT"));	//상담취소 카운트
								/**
								*	PURPOSE	:	본인삭제(상담대기중) cnt 와 본인삭제(상담완료) cnt
								*	CREATE	:	20171101_fri	JI
								*	MODIFY	:	다시 원본
								*/
								del_hold_cnt	=	parseNull((String)map.get("DEL_HOLD_CNT"));	//본인삭제(상담대기중) cnt
								del_comp_cnt	=	parseNull((String)map.get("DEL_COMP_CNT"));	//본인삭제(상담완료) cnt
								/** END */
								total_cnt     = parseNull((String)map.get("TOTAL_CNT"));	//합계

						%>
							<tr>
								<td><%=num-- %></td>
								<td><%=category_gb %></td>
								<td><%=target_gb %></td>
								<td><%=teacher_nm %>(<%=teacher_id %>)</td>
								<td><%=wait_cnt %></td>
								<td>
									<%
										out.println(Integer.toString(Integer.parseInt(succ_cnt) + Integer.parseInt(del_comp_cnt)));
									%>
								</td>
								<td><%=cancel_cnt %></td>
								<!--<td><%=del_hold_cnt %></td>
								<td><%=del_comp_cnt %></td>-->
								<td>
									
									<%
										/* 합계 변경 혹시나 나중에 수정 요청이 있을 시 변경 예정 */
										//out.println(total_cnt);
										out.println(Integer.toString(Integer.parseInt(wait_cnt) + Integer.parseInt(succ_cnt) + Integer.parseInt(del_comp_cnt) + Integer.parseInt(cancel_cnt)));
									%>
								</td>
							</tr>
						<%
							}
						}else{
						%>
							<tr>
								<td colspan="8">데이터가 없습니다.</td>
							</tr>
						<%
						}
						%>
						</tbody>
					</table>
				</fieldset>
			</form>
		</div>
		<% if(paging.getTotalCount() > 0) { %>
		<div class="page_area">
			<%=paging.getHtml() %>
		</div>
		<% } %>
	</div>
	<!-- // content -->
</div>
</body>
</html>
