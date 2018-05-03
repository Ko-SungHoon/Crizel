<%
/**
*   PURPOSE :   CMS 페이지 SMS Log list page
*   CREATE  :   2017.....   free
*   MODIFY  :   1)  페이지 변환 시 검색 조건 초기화 문제로 paging.setParam 추가   20171204_mon    JI
*/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="egovframework.rfc3.common.util.EgovDateUtil"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > SMS전송내역</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
<script>
</script>
</head>
<body>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

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

//Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
List<Map<String, Object>> dataList = null;

//SessionManager sessionManager = new SessionManager(request);

String tran_pr         = parseNull(request.getParameter("tran_pr"));
String tran_refkey     = parseNull(request.getParameter("tran_refkey"));
String tran_id         = parseNull(request.getParameter("tran_id"));
String tran_phone      = parseNull(request.getParameter("tran_phone"));
String tran_callback   = parseNull(request.getParameter("tran_callback"));
String tran_status     = parseNull(request.getParameter("tran_status"));
String tran_date       = parseNull(request.getParameter("tran_date"));
String tran_rsltdate   = parseNull(request.getParameter("tran_rsltdate"));
String tran_reportdate = parseNull(request.getParameter("tran_reportdate"));
String tran_rslt       = parseNull(request.getParameter("tran_rslt"));
String tran_net        = parseNull(request.getParameter("tran_net"));
String tran_msg        = parseNull(request.getParameter("tran_msg"));
String tran_etc1       = parseNull(request.getParameter("tran_etc1"));
String tran_etc2       = parseNull(request.getParameter("tran_etc2"));
String tran_etc3       = parseNull(request.getParameter("tran_etc3"));
String tran_etc4       = parseNull(request.getParameter("tran_etc4"));
String tran_type       = parseNull(request.getParameter("tran_type"));



String search_year    = parseNull(request.getParameter("search_year"),  EgovDateUtil.getDate(new Date(), "yyyy")) ;	//검색연도
String search_month   = parseNull(request.getParameter("search_month"), EgovDateUtil.getDate(new Date(), "MM"));		//검색월
String search_gb      = parseNull(request.getParameter("search_gb")); //검색구분 A=수신자번호
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
	sql.append("SELECT COUNT(*) CNT FROM SC_LOG_"+search_year+search_month+" WHERE TR_CALLBACK = '0552681187' AND TR_NET <> 'NUL' ");
	/**
    *   PURPOSE :   페이지 변환 시 검색 조건 초기화 문제로 paging.setParam 추가
    *   CREATE  :   20171204_mon    JI
    *   MODIFY  :   ....
    **/
    paging.setParams("search_year", search_year);
    paging.setParams("search_month", search_month);
    /* END */
	
	if(!"".equals(parseNull(search_keyword))){
		if("A".equals(search_gb)){	//수신자
			sql.append("AND TR_PHONE LIKE '%'||?||'%' ");
            paging.setParams("search_gb", search_gb);
		}else if("B".equals(search_gb)){	//메세지내용
			sql.append("AND TR_MSG LIKE '%'||?||'%' ");
		}
        paging.setParams("search_keyword", search_keyword);
	}
    
	pstmt = conn.prepareStatement(sql.toString());
    
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
	sql.append("	SELECT ROWNUM AS RNUM, A.* FROM ( \n");
	
	sql.append(" 		SELECT                                    \n");
	sql.append("             TR_NUM                               \n");
	sql.append("           , TR_PHONE                             \n");
	sql.append("           , TR_CALLBACK                          \n");
	sql.append("           , TO_CHAR(TR_SENDDATE,'YYYY-MM-DD hh24:mi:ss') AS TR_SENDDATE           \n");
	sql.append("           , TO_CHAR(TR_RSLTDATE,'YYYY-MM-DD hh24:mi:ss') AS TR_RSLTDATE           \n");
	sql.append("           , TO_CHAR(TR_REALSENDDATE,'YYYY-MM-DD hh24:mi:ss') AS TR_REALSENDDATE   \n");
	sql.append("           , TR_MSGTYPE                           \n");
	sql.append("           , TR_NET                               \n");
	sql.append("           , TR_MSG                               \n");
	sql.append(" 		FROM SC_LOG_"+search_year+search_month+"  WHERE TR_CALLBACK = '0552681187' AND TR_NET <> 'NUL' \n");
    /**
    *   PURPOSE :   페이지 변환 시 검색 조건 초기화 문제로 paging.setParam 추가
    *   CREATE  :   20171204_mon    JI
    *   MODIFY  :   ....
    **/
    paging.setParams("search_year", search_year);
    paging.setParams("search_month", search_month);
    /* END */
	
	if(!"".equals(parseNull(search_keyword))){
		if("A".equals(search_gb)){	//수신자
			sql.append("AND TR_PHONE LIKE '%'||?||'%' ");
            paging.setParams("search_gb", search_gb);
		}else if("B".equals(search_gb)){	//메세지내용
			sql.append("AND TR_MSG LIKE '%'||?||'%' ");
		}
        paging.setParams("search_keyword", search_keyword);
	}
	
	sql.append("		ORDER BY TR_NUM DESC ");
	sql.append("	) A WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" \n");
	sql.append(") WHERE RNUM > ").append(paging.getStartRowNo()).append(" \n");
	pstmt = conn.prepareStatement(sql.toString());
    
	if(!"".equals(parseNull(search_keyword))){
		++cnt;
		pstmt.setString(cnt, search_keyword);
	}
	
	rs = pstmt.executeQuery();	
	dataList = getResultMapRows(rs);
    
} catch (Exception e) {
    out.println(e.toString());
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
</script>
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>SMS전송내역</strong></p>
      <p class="location" style="float:right; margin-right:20px;">
		<span><a href="/iam/main/index.sko?lang=en_US" target="_top" class="last co_yellow">ENGLISH</a>[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span>님 안녕하세요.
		<a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
  	</p>
  </div>
	<div id="content">
		<div class="searchBox">
			<form action="./sms_log.jsp" method="post" id="searchForm">
				<fieldset>
					<legend>검색하기</legend>
					<input type="hidden" name="pageNo" id="pageNo" value="<%=pageNo%>">
					
					<!-- 분류 -->
					<span>SMS 전송 내역</span>
					
					<select name="search_year" id="search_year" for="search_year" value="<%=search_year%>">
						<option <%if("2015".equals(search_year)){ %>selected="selected"<% } %> value="2015">2015</option>
						<option <%if("2016".equals(search_year)){ %>selected="selected"<% } %> value="2016">2016</option>
						<option <%if("2017".equals(search_year)){ %>selected="selected"<% } %> value="2017">2017</option>
						<option <%if("2018".equals(search_year)){ %>selected="selected"<% } %> value="2018">2018</option>
					</select>
					<select name="search_month" id="search_month" for="search_month" value="<%=search_month%>">
						<option <%if("01".equals(search_month)){ %>selected="selected"<% } %> value="01">01</option>
						<option <%if("02".equals(search_month)){ %>selected="selected"<% } %> value="02">02</option>
						<option <%if("03".equals(search_month)){ %>selected="selected"<% } %> value="03">03</option>
						<option <%if("04".equals(search_month)){ %>selected="selected"<% } %> value="04">04</option>
						<option <%if("05".equals(search_month)){ %>selected="selected"<% } %> value="05">05</option>
						<option <%if("06".equals(search_month)){ %>selected="selected"<% } %> value="06">06</option>
						<option <%if("07".equals(search_month)){ %>selected="selected"<% } %> value="07">07</option>
						<option <%if("08".equals(search_month)){ %>selected="selected"<% } %> value="08">08</option>
						<option <%if("09".equals(search_month)){ %>selected="selected"<% } %> value="09">09</option>
						<option <%if("10".equals(search_month)){ %>selected="selected"<% } %> value="10">10</option>
						<option <%if("11".equals(search_month)){ %>selected="selected"<% } %> value="11">11</option>
						<option <%if("12".equals(search_month)){ %>selected="selected"<% } %> value="12">12</option>
					</select>
					
					<select name="search_gb" id="search_gb" value="">
						<option <%if("A".equals(search_gb)){ %>selected="selected"<% } %> value="A">수신자번호</option>
					</select>
					<input type="text" name="search_keyword" id="search_keyword" value="<%=search_keyword%>">
					<input type="submit" value="검색" class="btn small edge mako">
				</fieldset>
			</form>
		</div>

		<div class="listArea">
			<form action="" method="post" id="postForm">
				<fieldset>
					<legend>상담로그 목록 결과</legend>
					<table class="bbs_list">
						<colgroup>
						<col width="5%"/>
						<col width="8%" />
						<col width="8%"/>
						<col width="8%"/>
						<col width="3%"/>
						<col width="8%"/>
						<col width="8%"/>
						<col width="3%"/>
						<col  />
						<col />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">번호</th>
								<th scope="col">전송일시</th>
								<th scope="col">실전송일시</th>
								<th scope="col">결과수신일시</th>
								<th scope="col">전송결과</th>
								<th scope="col">수신자</th>
								<th scope="col">발신자</th>
								<th scope="col">통신사</th>
								<th scope="col">메세지</th>
							</tr>
						</thead>
						<tbody>
						<%
						if(dataList != null && dataList.size() > 0){
							num = paging.getRowNo();
							for(int i=0; i<dataList.size(); i++){
								Map<String,Object> map = dataList.get(i);
								tran_pr          = parseNull((String)map.get("TR_NUM"));
								tran_phone       = parseNull((String)map.get("TR_PHONE"));
								tran_callback    = parseNull((String)map.get("TR_CALLBACK"));
								tran_date        = parseNull((String)map.get("TR_SENDDATE"));
								tran_rsltdate    = parseNull((String)map.get("TR_RSLTDATE"));
								tran_reportdate  = parseNull((String)map.get("TR_REALSENDDATE"));
								tran_rslt        = parseNull((String)map.get("TR_MSGTYPE"));
								tran_net         = parseNull((String)map.get("TR_NET"));
								tran_msg         = parseNull((String)map.get("TR_MSG"));
								
								
								if("016".equals(tran_net) || "018".equals(tran_net)){
									tran_net = "KT";
								}else if("017".equals(tran_net) || "011".equals(tran_net)){
									tran_net = "SKT";
								}else if("019".equals(tran_net)){
									tran_net = "LG";
								}

						%>
							<tr>
								<td><%=num-- %></td>
								<td><%=tran_date %></td>
								<td><%=tran_rsltdate %></td>
								<td><%=tran_reportdate %></td>
								<td><%=tran_rslt %></td>
								<td><%=tran_phone %></td>
								<td><%=tran_callback %></td>
								<td><%=tran_net %></td>
								<td><%=tran_msg %></td>
							</tr>
						<%
							}
						}else{
						%>
							<tr>
								<td colspan="9">데이터가 없습니다.</td>
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
