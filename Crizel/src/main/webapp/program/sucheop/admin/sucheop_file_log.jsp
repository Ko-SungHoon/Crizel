<%
/**
*   PURPOSE :   교육수첩 / 교원, 기관 excel 등록 파일 로그 확인
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
		<title>RFC관리자 > 파일등록로그</title>
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
String content_type     =       "";
String row_num          =       "";
String file_seq         =       "";
String file_nm          =       "";
String file_ext_nm      =       "";
String reg_datetime     =       "";
String succ_flag        =       "";
String succ_fail_reason =       "";
String ip_addr          =       "";
String reg_id           =       "";
String file_url         =       "";
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
	sql_str		=	"SELECT COUNT(*) AS CNT FROM NOTE_FILE_LOG";
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
	sql_str		=	" SELECT * FROM ( ";
	sql_str		+=	" SELECT ROWNUM AS NUM, A.* FROM ( ";
	sql_str		+=	" SELECT TO_CHAR(TO_DATE(REG_DATETIME,'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS') AS REG_DATE, NOTE_FILE_LOG.* ";
    sql_str		+=	" FROM NOTE_FILE_LOG ORDER BY REG_DATE DESC ";
	sql_str		+=	" ) A WHERE ROWNUM <=" + paging.getEndRowNo();
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
      <p class="location"><strong>교육수첩 파일로그</strong></p>
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
						<col width="5%"/>
						<!--<col width=""/>-->
						<col width="5%"/>
						<!--<col width=""/>-->
						<col width="15%"/>
						<col width="10%"/>
						<col width="5%"/>
						<!--<col width=""/>-->
						<col width="*"/>
						<!--<col width=""/>-->
						<!--<col width=""/>-->
						</colgroup>
						<thead>
							<tr>
								<th scope="col">번호</th>
                                <th scope="col">분류</th>
								<!--<th scope="col">고유번호</th>-->
								<th scope="col">파일이름</th>
								<!--<th scope="col">파일확장자</th>-->
								<th scope="col">등록날짜시간</th>
								<th scope="col">성공여부</th>
								<th scope="col">실패원인</th>
								<!--<th scope="col">IP ADDR</th>-->
								<!--<th scope="col">등록ID</th>-->
								<!--<th scope="col">파일경로</th>-->
							</tr>
						</thead>
						<tbody>
						<%
						if(dataList != null && dataList.size() > 0){							
							for(int i=0; i<dataList.size(); i++){
								Map<String,Object> map = dataList.get(i);
								
                                content_type        =   parseNull((String)map.get("CONTENT_TYPE"));
                                row_num             =   parseNull((String)map.get("NUM"));
                                file_seq            =   parseNull((String)map.get("FILE_SEQ"));
                                file_nm             =   parseNull((String)map.get("FILE_NM"));
                                file_ext_nm         =   parseNull((String)map.get("FILE_EXT_NM"));
                                reg_datetime        =   parseNull((String)map.get("REG_DATE"));
                                succ_flag           =   parseNull((String)map.get("SUCC_FLAG"));
                                succ_fail_reason    =   parseNull((String)map.get("SUCC_FAIL_REASON"));
                                ip_addr             =   parseNull((String)map.get("IP_ADDR"));
                                reg_id              =   parseNull((String)map.get("REG_ID"));
                                file_url            =   parseNull((String)map.get("FILE_URL"));
						%>
							<tr>
								<td><%=row_num %></td>
								<td><%=content_type %></td>
								<!--<td><%=file_seq %></td>-->
								<td><%=file_nm %></td>
								<!--<td><%=file_ext_nm %></td>-->
								<td><%=reg_datetime %></td>
								<td><%=succ_flag %></td>
								<td><%=succ_fail_reason %></td>
								<!--<td><%=ip_addr %></td>-->
								<!--<td><%=reg_id %></td>-->
								<!--<td><%=file_url %></td>-->
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