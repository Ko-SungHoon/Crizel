<%
/**
*	PURPOSE	:	교육수첩 조직도 기관 등록 수행 JSP 파일
*	CREATE	:	20171108_wedns	JI
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

//	고정 parameters
String command	=	parseNull(request.getParameter("command"));

String search_fst_group	=	parseNull(request.getParameter("search_fst_group"));    //1차 기관 선택
String search_snd_group	=	parseNull(request.getParameter("search_snd_group"));    //2차 기관 선택
String search_trd_group	=	parseNull(request.getParameter("search_trd_group"));    //3차 기관 선택
String search_fth_group	=	parseNull(request.getParameter("search_fth_group"));    //4차 기관 선택
String search_fith_group	=	parseNull(request.getParameter("search_fith_group"));    //5차 기관 선택

//parameters
String mem_seq          =   parseNull(request.getParameter("mem_seq"));
String mem_nm           =   parseNull(request.getParameter("mem_nm"));
String mem_grade        =   parseNull(request.getParameter("mem_grade"));
String mem_level        =   parseNull(request.getParameter("mem_level"));
String mem_tel          =   parseNull(request.getParameter("mem_tel"));
String mem_mobile       =   parseNull(request.getParameter("mem_mobile"));
String mem_sso_id       =   parseNull(request.getParameter("mem_sso_id"));
String show_yn          =   parseNull(request.getParameter("show_yn"));

int key = 0;
int result = 0;

List<Map<String, Object>> dataList = null;


try {

	sqlMapClient.startTransaction();
	conn    =   sqlMapClient.getCurrentConnection();
    
    sql     =   new StringBuffer();
    sql_str =   " UPDATE NOTE_GROUP_MEM SET ";
    if (Integer.parseInt(search_fith_group) > 0) {
        sql_str +=  " GROUP_LIST_SEQ = '" + search_fith_group + "' ";
    } else if (Integer.parseInt(search_fth_group) > 0) {
        sql_str +=  " GROUP_LIST_SEQ = '" + search_fth_group + "' ";
    } else if (Integer.parseInt(search_trd_group) > 0) {
        sql_str +=  " GROUP_LIST_SEQ = '" + search_trd_group + "' ";
    } else if (Integer.parseInt(search_snd_group) > 0) {
        sql_str +=  " GROUP_LIST_SEQ = '" + search_snd_group + "' ";
    } else if (Integer.parseInt(search_fst_group) > 0) {
        sql_str +=  " GROUP_LIST_SEQ = '" + search_fst_group + "' ";
    }
    sql_str +=  " , MEM_NM = '" + mem_nm + "'";
    sql_str +=  " , MEM_GRADE = '" + mem_grade + "'";
    sql_str +=  " , MEM_LEVEL = '" + mem_level + "'";
    sql_str +=  " , MEM_TEL = '" + mem_tel + "'";
    sql_str +=  " , MEM_MOBILE = '" + mem_mobile + "'";
    sql_str +=  " , MEM_SSO_ID = '" + mem_sso_id + "'";
    sql_str +=  " , SHOW_FLAG = '" + show_yn + "'";
    sql_str +=  " , MODIFY_DT = TO_CHAR(SYSDATE, 'YYYYMMDD')";
    sql_str +=  " , MODIFY_HMS = TO_CHAR(SYSDATE, 'HH24MISS')";
    sql_str +=  " WHERE MEM_SEQ = '" + mem_seq + "' ";
    
    sql.append(sql_str);
    pstmt	=	conn.prepareStatement(sql.toString());

    result	=	pstmt.executeUpdate();

    if (result > 0) {
        sqlMapClient.commitTransaction();
        out.println("update success");
    }

} catch (Exception e) {

	e.printStackTrace();
	sqlMapClient.endTransaction();
	alertBack(out, "처리중 오류가 발생하였습니다."+e.getMessage()); 

} finally {

	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();

    String outHtml  =   "";
    if (result > 0) {
        outHtml +=  "<script>alert('정상적으로 수정되었습니다.');";
        outHtml +=  "opener.location.reload();window.close();</script>";
        out.println(outHtml);
    } else {
        outHtml +=  "<script>alert('처리 중 오류가 발생하였습니다.');";
        outHtml +=  "history.back();</script>";
        out.println(outHtml);
    }
}

%>