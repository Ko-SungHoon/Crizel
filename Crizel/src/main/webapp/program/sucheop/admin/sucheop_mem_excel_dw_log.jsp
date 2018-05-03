<%
/**
*	PURPOSE	:	ajax 통신을 통한 excel file download log insert
*	CREATE	:	20171215_fri	JI
*	MODIFY	:	....
*/
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>

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

//Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
String sql_str	=	"";
int key                 =   0;
int result              =   0;

String sessionName  =   "";             //로그인 유저 이름
String sessionNum   =   "";             //로그인 유저 phoneNum
//String sessionId    =   "";             //로그인 유저 Id
String lastLogSeq   =   "1";            //NOTE_MVIEW_LOG 마지막 log_seq

sessionName =   parseNull(sessionManager.getName(), "");            //유저 이름
sessionNum  =   parseNull(sessionManager.getUserHomepage(), "");    //유저 phoneNum
sessionId   =   parseNull(sessionManager.getId(), "");              //유저 Id


try {

	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
    
    /**
    *   PURPOSE :   교원관리 페이지 호출 시 "휴대폰 확인 로그 쌓기"
    *   CREATE  :   20171215_fri    JI
    *   MODIFY  :   ....
    **/
    //NOTE_MVIEW_LOG INSERT
    //last log_seq select or log_seq set 1
    sql     =   new StringBuffer();
    sql_str =   "SELECT * FROM (SELECT * FROM NOTE_MVIEW_LOG ORDER BY LOG_SEQ DESC) WHERE ROWNUM = 1";
    sql.append(sql_str);
    pstmt   =   conn.prepareStatement(sql.toString());
    rs      =   pstmt.executeQuery();
    if (rs.next()) {lastLogSeq  =   Integer.toString(rs.getInt("LOG_SEQ") + 1);}

    //INSERT
    sql     =   new StringBuffer();
    sql_str =   "INSERT INTO NOTE_MVIEW_LOG ";
    //sql_str +=  " (LOG_SEQ, CERT_MOBILE_ID, CERT_MOBILE_NUM, SEARCH_GROUP, SEARCH_MEM, CHK_DATETIME, VIEW_URL, VIEW_TITLE, CERT_NAME, IP_ADDR) ";
    sql_str +=  " (LOG_SEQ, CERT_MOBILE_ID, SEARCH_GROUP, SEARCH_MEM, CHK_DATETIME, VIEW_URL, VIEW_TITLE, CERT_NAME, IP_ADDR) ";
    sql_str +=  " VALUES ";
    sql_str +=  " ('"+ lastLogSeq +"'";         //last seq
    sql_str +=  " , '"+ sessionId +"'";         //certification id
    //sql_str +=  " , '"+ sessionNum +"'";      //certification mobile num
    sql_str +=  " , ''";     //group search value
    sql_str +=  " , ''";       //mem search value
    sql_str +=  " , TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') "; //view datetime
    sql_str +=  " , '/program/sucheop/admin/sucheop_mem_excel_dw.jsp' ";    //present url address
    sql_str +=  " , 'RFC 교원 자료 다운' ";       //present url address
    sql_str +=  " , '" + sessionName + "' "; //certification user name
    sql_str +=  " , '" + request.getRemoteAddr() + "' ";    //certification user ipaddr
    sql_str +=  " ) ";
    sql.append(sql_str);
    pstmt   =   conn.prepareStatement(sql.toString());
    result  =   pstmt.executeUpdate();
    
    if (result > 0) {
        sqlMapClient.commitTransaction();
        out.println("1");
    }
    
    /** END **/
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