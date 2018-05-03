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

String teacher_id   = parseNull(request.getParameter("teacher_id"));
String teacher_nm   = parseNull(request.getParameter("teacher_nm"));
String category_gb  = parseNull(request.getParameter("category_gb"));
String target_gb    = parseNull(request.getParameter("target_gb"));
String hp_no        = parseNull(request.getParameter("hp_no"));
String advice_yn    = parseNull(request.getParameter("advice_yn"));
String reg_id       = sessionManager.getId();
String mod_id       = sessionManager.getId();
String command 		= parseNull(request.getParameter("command"));
String chk_obj 		= parseNull(request.getParameter("chk_obj"));	//선택삭제할 값 모음

int key = 0;
int result = 0;

List<Map<String, Object>> dataList = null;


try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	
	if("insert".equals(command)){
		int teacherCnt = 0;
		
		//학교정보 입력
		key = 0;
		sql = new StringBuffer();
		sql.append("SELECT COUNT(*) CNT FROM ADVICE_TEACHER WHERE 1=1 ");
		sql.append("AND TEACHER_ID = '"+teacher_id+"' ");	
		pstmt = conn.prepareStatement(sql.toString());
		rs = pstmt.executeQuery();	
		if(rs.next()){
			teacherCnt = rs.getInt("CNT");
		}
		
		if(teacherCnt == 0){
			sql = new StringBuffer();
			sql.append("INSERT INTO ADVICE_TEACHER ");
			sql.append("(   ");
			sql.append("        TEACHER_ID     \n");
			sql.append("      , TEACHER_NM     \n");
			sql.append("      , CATEGORY_GB    \n");
			sql.append("      , TARGET_GB      \n");
			sql.append("      , HP_NO          \n");
			sql.append("      , ADVICE_YN      \n");
			sql.append("      , ADVICE_ST_DT   \n");
			sql.append("      , ADVICE_ED_DT   \n");
			sql.append("      , REG_DT         \n");
			sql.append("      , REG_ID         \n");
			sql.append("      , MOD_DT         \n");
			sql.append("      , MOD_ID         \n");
			sql.append("      , REG_HMS         \n");
			sql.append("      , MOD_HMS         \n");
			sql.append(")   ");
			sql.append(" VALUES ");
			sql.append("(   ");
			sql.append("        ?     \n");
			sql.append("      , ?   \n");
			sql.append("      , ?   \n");
			sql.append("      , ?   \n");
			sql.append("      , ?   \n");
			sql.append("      , ?   \n");
			sql.append("      , ''   \n");
			sql.append("      , ''   \n");
			sql.append("      , TO_CHAR(SYSDATE,'YYYYMMDD')   \n");
			sql.append("      , ?   \n");
			sql.append("      , TO_CHAR(SYSDATE,'YYYYMMDD')   \n");
			sql.append("      , ?   \n");
			sql.append("      , TO_CHAR(SYSDATE,'HH24MISS')   \n");
			sql.append("      , TO_CHAR(SYSDATE,'HH24MISS')   \n");
			sql.append(")   ");
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(++key, teacher_id  );
			pstmt.setString(++key, teacher_nm  );
			pstmt.setString(++key, category_gb );
			pstmt.setString(++key, target_gb   );
			pstmt.setString(++key, hp_no       );
			pstmt.setString(++key, advice_yn   );
			pstmt.setString(++key, reg_id      );
			pstmt.setString(++key, mod_id      );
			
			result = pstmt.executeUpdate();
			if(result > 0){
				sqlMapClient.commitTransaction();
			}
		}else{	//아이디 중복체크
			out.println("<script type=\"text/javascript\">");
			out.println("alert('이미 존재하는 아이디입니다.');");
			out.println("location.href='insertForm.jsp'");
			out.println("</script>");
		}
		
	}else if("update".equals(command)){
		key = 0;
		//학교정보 수정
		sql = new StringBuffer();
		sql.append("UPDATE ADVICE_TEACHER SET  ");
		sql.append("        TEACHER_NM  = ?   \n");
		sql.append("      , CATEGORY_GB = ?   \n");
		sql.append("      , TARGET_GB   = ?   \n");
		sql.append("      , HP_NO       = ?   \n");
		sql.append("      , ADVICE_YN   = ?   \n");
		sql.append("      , MOD_DT      = TO_CHAR(SYSDATE,'YYYYMMDD')   \n");
		sql.append("      , MOD_ID      = ?   \n");
		sql.append("      , MOD_HMS      = TO_CHAR(SYSDATE,'HH24MISS')   \n");
		sql.append("WHERE TEACHER_ID = ? ");
		pstmt = conn.prepareStatement(sql.toString());
		
		pstmt.setString(++key, teacher_nm  );
		pstmt.setString(++key, category_gb );
		pstmt.setString(++key, target_gb   );
		pstmt.setString(++key, hp_no       );
		pstmt.setString(++key, advice_yn   );
		pstmt.setString(++key, mod_id      );
		pstmt.setString(++key, teacher_id      );
		
		result = pstmt.executeUpdate();
		if(result > 0){
			sqlMapClient.commitTransaction();
		}
	}else if("delete".equals(command)){
		String[] idArr = chk_obj.split(",");	//선택값 파싱
		
		for(int i=0;i<idArr.length;i++){
			sql = new StringBuffer();
			sql.append(" DELETE FROM ADVICE_TEACHER ");
			sql.append("WHERE TEACHER_ID = '"+idArr[i]+"' ");
			
			pstmt = conn.prepareStatement(sql.toString());
			result = pstmt.executeUpdate();
		}
		
		if(result > 0){
			sqlMapClient.commitTransaction();
		}
	}else if("board_delete".equals(command)){
		/**
		*	PURPOSE	:	게시물 삭제 에서 로그 삭제로 변경
		*	CREATE	:	20171030_mon	JI
		*	MODIFY	:	....
		*/
		String[] idArr = chk_obj.split(",");	//선택값 파싱
		
		for(int i=0;i<idArr.length;i++){
			sql = new StringBuffer();
			sql.append(" DELETE FROM ADVICE_BOARD_LOG ");
			sql.append("WHERE REF_ID = '"+idArr[i]+"' ");
			
			pstmt = conn.prepareStatement(sql.toString());
			result = pstmt.executeUpdate();
		}
		/** END */
		
		if(result > 0){
			sqlMapClient.commitTransaction();
		}
	}
	
} catch (Exception e) {
	e.printStackTrace();
	sqlMapClient.endTransaction();
	alertBack(out, "처리중 오류가 발생하였습니다."+e.getMessage()); 
	//out.print(e.getMessage());
	
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
	if("delete".equals(command)){
		if(result>0){
			out.println("<script type=\"text/javascript\">");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.href='./list.jsp'");
			out.println("</script>");
		}else{
			out.println("<script type=\"text/javascript\">");
			out.println("alert('처리 중 오류가 발생하였습니다.');");
			out.println("location.href='./list.jsp'");
			out.println("</script>");
		}
	}else if("board_delete".equals(command)){
		if(result>0){
			out.println("<script type=\"text/javascript\">");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.href='./advice_log.jsp'");
			out.println("</script>");
		}else{
			out.println("<script type=\"text/javascript\">");
			out.println("alert('처리 중 오류가 발생하였습니다.');");
			out.println("location.href='./advice_log.jsp'");
			out.println("</script>");
		}
	}else{
		if(result>0){
			out.println("<script type=\"text/javascript\">");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("opener.location.reload();");
			out.println("window.close();");
			out.println("</script>");
		}else{
			out.println("<script type=\"text/javascript\">");
			out.println("alert('처리 중 오류가 발생하였습니다.');");
			out.println("opener.location.reload();");
			out.println("window.close();");
			out.println("</script>");
		}
		
	}
	 
}

%>