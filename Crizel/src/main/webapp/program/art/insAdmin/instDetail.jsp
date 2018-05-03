<%
/**
*   PURPOSE :   악기 상세보기 모달 정보
*   CREATE  :   20180212_mon    Ko
*   MODIFY  :   ....
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="org.json.simple.JSONArray" %>
<%@page import="org.json.simple.JSONObject" %>
<%!
private class InsVO{
	public String inst_name;
	public String inst_cat_nm;
	public String inst_size;
	public String inst_model;
	public int curr_cnt;
	public int max_cnt;
	public String inst_lca;
	public String inst_memo;
	public String inst_pic;
}

private class InsVOMapper implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
    	vo.inst_name		= rs.getString("INST_NAME");
    	vo.inst_cat_nm		= rs.getString("INST_CAT_NM");
    	vo.inst_size		= rs.getString("INST_SIZE");
    	vo.inst_model		= rs.getString("INST_MODEL");
    	vo.curr_cnt			= rs.getInt("CURR_CNT");
    	vo.max_cnt			= rs.getInt("MAX_CNT");
    	vo.inst_lca			= rs.getString("INST_LCA");
    	vo.inst_memo		= rs.getString("INST_MEMO");
    	vo.inst_pic			= rs.getString("INST_PIC");
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

String inst_no	 		= parseNull(request.getParameter("inst_no"));

StringBuffer sql		= null;
Object[] setObj 		= null;
List<InsVO> list 		= null;
InsVO vo				= null;

try{
	sql = new StringBuffer();
	sql.append("SELECT 								");
	sql.append("		INST_NAME, 					");
	sql.append("		INST_CAT_NM, 				");
	sql.append("		INST_SIZE, 					");
	sql.append("		INST_MODEL,					");
	sql.append("		CURR_CNT, 					");
	sql.append("		MAX_CNT, 					");
	sql.append("		INST_LCA, 					");
	sql.append("		INST_MEMO, 					");
	sql.append("		INST_PIC 					");
	sql.append("FROM ART_INST_MNG					");
	sql.append("WHERE INST_NO = ?					");
	setObj = new Object[]{
						inst_no
						};
	vo = jdbcTemplate.queryForObject(
				sql.toString(), 
				setObj,
				new InsVOMapper()
			); 
	
	JSONArray arr = new JSONArray();
	JSONObject obj = new JSONObject();
	obj.put("inst_name", vo.inst_name);
	obj.put("inst_cat_nm", vo.inst_cat_nm);
	obj.put("inst_size", vo.inst_size);
	obj.put("inst_model", vo.inst_model);
	obj.put("curr_cnt", vo.curr_cnt);
	obj.put("max_cnt", vo.max_cnt);
	obj.put("inst_lca", vo.inst_lca);
	obj.put("inst_memo", vo.inst_memo.replace("\n", "<br>"));
	obj.put("inst_pic", vo.inst_pic);
	arr.add(obj);
	out.print(arr);
}catch(Exception e){
	out.println(e.toString());
}
%>
