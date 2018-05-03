<%
/**
*   PURPOSE :   교육수첩 / 유저 휴대폰 확인 로그 페이지
*   CREATE  :   20171201_fri    JI
*   MODIFY  :   ....
**/
%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>

<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 휴대폰확인로그</title>
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

//SessionManager sessionManager = new SessionManager(request);

//Connection conn         =   null;
PreparedStatement pstmt =   null;
ResultSet rs            =   null;
StringBuffer sql        =   null;
String sql_str	        =	"";
int key                 =   0;
int result              =   0;
List<Map<String, Object>> dataList = null;

/* note_file_log columns variables */
String row_num          =       "";
String log_seq          =       "";
String cert_mobile_id   =       "";
String cert_mobile_num  =       "";
String search_group     =       "";
String search_mem       =       "";
String chk_datetime     =       "";
String view_url         =       "";
String view_title       =       "";
String cert_name        =       "";
String ip_addr          =       "";
/* END */

int num = 0;

Paging paging = new Paging();
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
int cnt=0;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
    
    sql			=	new StringBuffer();
	sql_str		=	"SELECT COUNT(*) AS CNT FROM NOTE_MVIEW_LOG";
    sql.append(sql_str);
	pstmt		=	conn.prepareStatement(sql.toString());
    rs			=	pstmt.executeQuery();
    if (rs.next()) {
        totalCount  =   rs.getInt("CNT");
    }
    
    paging.setPageNo(Integer.parseInt(pageNo));
	paging.setTotalCount(totalCount);
	paging.setPageSize(10);
	paging.setPageBlock(10);
    
    sql			=	new StringBuffer();
	sql_str		=	"SELECT * FROM ( ";
	sql_str		+=	" SELECT ROWNUM AS NUM, A.* FROM ( ";
	sql_str		+=	" SELECT TO_CHAR(TO_DATE(CHK_DATETIME, 'YYYYMMDDHH24MISS'), 'YYYY-MM-DD HH24:MI:SS') AS CHK_DATE, NOTE_MVIEW_LOG.* ";
	sql_str		+=	" FROM NOTE_MVIEW_LOG ORDER BY CHK_DATETIME DESC ";
    sql_str		+=	" ) A WHERE ROWNUM <= " + paging.getEndRowNo();
	sql_str		+=	" ) WHERE NUM > " + paging.getStartRowNo();
	sql.append(sql_str);
	pstmt		=	conn.prepareStatement(sql.toString());
	rs			=	pstmt.executeQuery();
    dataList	=	getResultMapRows(rs);
    
} catch (Exception e) {
	out.println(e.toString());
	e.printStackTrace();
	sqlMapClient.endTransaction();
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
}
%>
    
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>휴대폰확인로그</strong></p>
      <p class="location" style="float:right; margin-right:20px;">
        <span><a href="/iam/main/index.sko?lang=en_US" target="_top" class="last co_yellow">ENGLISH</a>[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span>님 안녕하세요.
        <a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
    </p>
  </div>
	<div id="content">
		<div class="searchBox">
			<form action="./sucheop_file_log.jsp" method="post" id="searchForm">
				<fieldset>
					<input type="hidden" name="pageNo" id="pageNo" value="<%=pageNo%>">
				</fieldset>
			</form>
		</div>

		<div class="listArea">
			<form action="" method="post" id="postForm">
				<fieldset>
					<legend>상담로그 목록 결과</legend>
					<table class="bbs_list">
						<colgroup>
						<col width=""/>
						<col width=""/>
						<col width=""/>
						<col width=""/>
						<col width=""/>
						<col width=""/>
						<col width=""/>
						<col width=""/>
						<col width=""/>
						</colgroup>
						<thead>
							<tr>
								<th scope="col">번호</th>
                                <th scope="col">구분</th>
                                <th scope="col">확인자</th>
                                <th scope="col">ID(관리자 ID 만)</th>
                                <th scope="col">확인일시</th>
                                <th scope="col">접속 IP</th>
                                <th scope="col">기관 검색어</th>
                                <th scope="col">성명 검색어<br>/<br>확인 교원명</th>
                                <th scope="col">접속 URL</th>
							</tr>
						</thead>
						<tbody>
						<%
						if(dataList != null && dataList.size() > 0){							
							for(int i=0; i<dataList.size(); i++){
								Map<String,Object> map = dataList.get(i);
								row_num             =   parseNull((String)map.get("NUM"));
                                log_seq             =   parseNull((String)map.get("LOG_SEQ"));
                                cert_mobile_id      =   parseNull((String)map.get("CERT_MOBILE_ID"));
                                if (cert_mobile_id.length() > 63) {
                                    cert_mobile_id  =   "일반 유저";
                                }
                                cert_mobile_num     =   parseNull((String)map.get("CERT_MOBILE_NUM"));
                                search_group        =   parseNull((String)map.get("SEARCH_GROUP"));
                                search_mem          =   parseNull((String)map.get("SEARCH_MEM"));
                                chk_datetime        =   parseNull((String)map.get("CHK_DATE"));
                                view_url            =   parseNull((String)map.get("VIEW_URL"));
                                view_title          =   parseNull((String)map.get("VIEW_TITLE"));
                                cert_name           =   parseNull((String)map.get("CERT_NAME"));
                                ip_addr             =   parseNull((String)map.get("IP_ADDR"));
						%>
							<tr>
								<td><%=row_num %></td>
								<td><%=view_title %></td>
								<td><%=cert_name %></td>
								<td><%=cert_mobile_id %></td>
								<td><%=chk_datetime %></td>
								<td><%=ip_addr %></td>
								<td><%=search_group %></td>
								<td><%=search_mem %></td>
								<td><a href='<%=view_url %>' target="_blank"><%=view_url %></a></td>
							</tr>
						<%
							}
						}else{
						%>
							<tr>
								<td colspan="11">데이터가 없습니다.</td>
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