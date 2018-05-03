<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 업무분장</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />


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

String command = parseNull(request.getParameter("command"));		//COMMAND
String teacher_id = parseNull(request.getParameter("teacher_id"));
String teacher_nm   = parseNull(request.getParameter("teacher_nm"));
String category_gb  = parseNull(request.getParameter("category_gb"));
String target_gb    = parseNull(request.getParameter("target_gb"));
String hp_no        = parseNull(request.getParameter("hp_no"));
String advice_yn    = parseNull(request.getParameter("advice_yn"));
String advice_st_dt = parseNull(request.getParameter("advice_st_dt"));
String advice_ed_dt = parseNull(request.getParameter("advice_ed_dt"));
String reg_dt       = parseNull(request.getParameter("reg_dt"));
String reg_id       = parseNull(request.getParameter("reg_id"));
String mod_dt       = parseNull(request.getParameter("mod_dt"));
String mod_id       = parseNull(request.getParameter("mod_id"));

Paging paging = new Paging();

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	if(!StringUtils.isEmpty(teacher_id)){
		//상담교사 수정(수정시)
		sql = new StringBuffer();
		sql.append("SELECT ");
			sql.append("  TEACHER_ID     \n");
			sql.append(", TEACHER_NM    \n");
			sql.append(", CATEGORY_GB   \n");
			sql.append(", TARGET_GB     \n");
			sql.append(", HP_NO         \n");
			sql.append(", ADVICE_YN     \n");
			sql.append(", ADVICE_ST_DT  \n");
			sql.append(", ADVICE_ED_DT  \n");
			sql.append(", REG_DT        \n");
			sql.append(", REG_ID        \n");
			sql.append(", MOD_DT        \n");
			sql.append(", MOD_ID        \n");
		sql.append("FROM ADVICE_TEACHER  ");
		sql.append("WHERE TEACHER_ID = ?  ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, teacher_id);
		rs = pstmt.executeQuery();	
		while(rs.next()){
			teacher_nm    = rs.getString("TEACHER_NM");
			category_gb   = rs.getString("CATEGORY_GB");
			target_gb     = rs.getString("TARGET_GB");
			hp_no         = rs.getString("HP_NO");
			advice_yn     = rs.getString("ADVICE_YN");
			advice_st_dt  = rs.getString("ADVICE_ST_DT");
			advice_ed_dt  = rs.getString("ADVICE_ED_DT");
			reg_dt        = rs.getString("REG_DT");
			reg_id        = rs.getString("REG_ID");
			mod_dt        = rs.getString("MOD_DT");
			mod_id        = rs.getString("MOD_ID");
		}
	}
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

// 저장하기
function postForm(){
	
	if($.trim($("#category_gb").val()) == ""){
		alert("분류를 선택하여 주십시오");
		$("#category_gb").focus();
		return false;
	}
	
	if($.trim($("#target_gb").val()) == ""){
		alert("대상을 선택하여 주십시오");
		$("#target_gb").focus();
		return false;
	}
	
	if($.trim($("#teacher_nm").val()) == ""){
		alert("이름을 입력하여 주십시오");
		$("#teacher_nm").focus();
		return false;
	}
	if($.trim($("#teacher_id").val()) == ""){
		alert("아이디를 입력하여 주십시오");
		$("#teacher_id").focus();
		return false;
	}
	
	$("#postForm").attr("action","/program/advice/admin/teacher_register.jsp");
	$("#postForm").submit();
}


</script>

<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>상담교사관리</strong></p>
  </div>
	<div id="content">
		<div class="listArea">
			<form action="" method="post" id="postForm">
			<input type="hidden" name="command" id="command" value="<%=command%>">
			
				<fieldset>
					<legend>상담교사관리</legend>
					<table class="bbs_list">
						<colgroup>
						<col width="25%"/>
						<col width="25%"/>
						<col width="25%"/>
						<col width="25%"/>
						</colgroup>
						<tr>
							<th>분류</th>
							<td >
								<select name="category_gb" id="category_gb" for="category_gb" value="<%=category_gb%>" >
									<option <%if("A01".equals(category_gb)){ %>selected="selected"<% } %> value="A01">진로</option>
									<option <%if("A02".equals(category_gb)){ %>selected="selected"<% } %> value="A02">진학</option>
								</select>
							</td>
							<th>대상</th>
							<td >
								<select name="target_gb" id="target_gb" for="target_gb" value="<%=target_gb%>">
									<option <%if("B01".equals(target_gb)){ %>selected="selected"<% } %> value="B01">초등</option>
									<option <%if("B02".equals(target_gb)){ %>selected="selected"<% } %> value="B02">중등</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>이름</th>
							<td >
								<input type="text" id="teacher_nm" name="teacher_nm" for="teacher_nm" value="<%=teacher_nm %>" />
							</td>
							<th>아이디</th>
							<td >
								<input type="text" id="teacher_id" name="teacher_id" for="teacher_id" <%if("update".equals(command)){%>readonly="readonly"<%} %>  value="<%=teacher_id %>" />
							</td>
						</tr>
						<tr>
							<th>휴대폰</th>
							<td >
								<input type="text" id=hp_no name="hp_no" for="hp_no" value="<%=hp_no %>" />
							</td>
							<td colspan="2">
								*숫자만 기입해주세요.
							</td>
						</tr>
						<tr>
							<th>상담원적용</th>
							<td colspan="3">
								<input type="radio" id="radio1" name="advice_yn" value="Y" checked="checked" />적용
								<input type="radio" id="radio2" name="advice_yn" value="N" <%if("N".equals(advice_yn)){%>checked="checked"<%} %>  />적용안함
							</td>
						</tr>
					</table>
					<button type="button" onclick="postForm()" class="btn small edge mako">저장</button>
				</fieldset>
			</form>
		</div>		
	</div>
	<!-- // content -->
</div>
</body>
</html>
