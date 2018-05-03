<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
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

String command     = parseNull(request.getParameter("command"));		//COMMAND
String e_seq       = parseNull(request.getParameter("e_seq"));	    	//SEQ
String standard_dt = parseNull(request.getParameter("standard_dt"));	//기준일자
String office_dp   = parseNull(request.getParameter("office_dp"));	    //조직레벨
List<Map<String, Object>> officeList1 = null;

String u_e_seq           = "";
String u_emplyr_nm       = "";
String u_position_nm     = "";
String u_office_cd       = "";
String u_office_nm       = "";
String u_office_pt_memo  = "";
String u_office_tel      = "";
String u_agent_id        = "";
String u_agen_nm         = "";
String u_standard_dt     = "";
String u_reg_dt          = "";
String u_reg_id          = "";
String u_mod_dt          = "";
String u_mod_id          = "";
String u_sort_order      = "";
String u_office_dp       = "";



try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	if("update".equals(command) || !"".equals(parseNull(e_seq))){
		//상담교사 수정(수정시)
		sql = new StringBuffer();
		sql.append("SELECT ");
		sql.append("       E_SEQ           \n");
		sql.append("     , EMPLYR_NM       \n");
		sql.append("     , POSITION_NM     \n");
		sql.append("     , OFFICE_CD       \n");
		sql.append("     , OFFICE_NM       \n");
		sql.append("     , OFFICE_PT_MEMO  \n");
		sql.append("     , OFFICE_TEL      \n");
		sql.append("     , AGENT_ID        \n");
		sql.append("     , AGEN_NM         \n");
		sql.append("     , STANDARD_DT     \n");
		sql.append("     , REG_DT          \n");
		sql.append("     , REG_ID          \n");
		sql.append("     , MOD_DT          \n");
		sql.append("     , MOD_ID          \n");
		sql.append("     , SORT_ORDER      \n");
		sql.append("     , OFFICE_DP       \n");
		sql.append("FROM DIVISION_WORK  ");
		sql.append("WHERE E_SEQ       = ?  ");
		sql.append("AND   STANDARD_DT = ?  ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(1, e_seq);
		pstmt.setString(2, standard_dt);

		rs = pstmt.executeQuery();
		while(rs.next()){
			u_e_seq          = rs.getString("E_SEQ");
			u_emplyr_nm      = rs.getString("EMPLYR_NM");
			u_position_nm    = rs.getString("POSITION_NM");
			u_office_cd      = rs.getString("OFFICE_CD");
			u_office_nm      = rs.getString("OFFICE_NM");
			u_office_pt_memo = rs.getString("OFFICE_PT_MEMO");
			u_office_tel     = rs.getString("OFFICE_TEL");
			u_agent_id       = rs.getString("AGENT_ID");
			u_agen_nm        = rs.getString("AGEN_NM");
			u_standard_dt    = rs.getString("STANDARD_DT");
			u_reg_dt         = rs.getString("REG_DT");
			u_reg_id         = rs.getString("REG_ID");
			u_mod_dt         = rs.getString("MOD_DT");
			u_mod_id         = rs.getString("MOD_ID");
			u_sort_order     = rs.getString("SORT_ORDER");
			u_office_dp      = rs.getString("OFFICE_DP");
		}
	}

	/* 3레벨 부서리스트 */
	sql = new StringBuffer();
	sql.append("  SELECT                          \n");
	sql.append("    OFFICE_CD                     \n");
	sql.append("  , OFFICE_NM                     \n");
	sql.append("  FROM RFC_COMTCOFFICE            \n");
	sql.append("  WHERE OFFICE_DP = 3             \n");
	sql.append("  AND OFFICE_NM NOT LIKE '%폐지%'   \n");
	sql.append("  ORDER BY OFFICE_SORT_IX         \n");
	pstmt = conn.prepareStatement(sql.toString());
	rs = pstmt.executeQuery();
	officeList1 = getResultMapRows(rs);


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

	if($.trim($("#in_office_cd").val()) == "" ){
		alert("조직정보를 선택하여 주십시오");
		$("#in_office_cd").focus();
		return false;
	}

	if($.trim($("#emplyr_nm").val()) == ""){
		alert("이름을 입력하여 주십시오");
		$("#emplyr_nm").focus();
		return false;
	}


	$("#postForm").attr("action","./workAct.jsp");
	$("#postForm").submit();
}


</script>

<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>업무분장관리</strong></p>
  </div>
	<div id="content">
		<div class="listArea">
			<form action="" method="post" id="postForm">
				<input type="hidden" name="command" id="command" value="<%=command%>">
				<input type="hidden" id="e_seq" name="e_seq" value="<%=e_seq %>" />
				<fieldset>
					<legend>업무분장관리</legend>
					<table class="bbs_list2">
						<colgroup>
						<col class="wps_20"/>
						<col />
						<col class="wps_20"/>
						<col />
						</colgroup>
						<tr>
							<th scope="row">과,부서명</th>
							<td >
								<%if("insert".equals(command) || "3".equals(u_office_dp)){ %>
										<select name="in_office_cd" id="in_office_cd" for="in_office_cd" onchange="chngOffice();" >
											<option value="">선택없음</option>
											<%
											if(officeList1 != null && officeList1.size() > 0){
												for(int i=0; i<officeList1.size(); i++){
													Map<String,Object> map = officeList1.get(i);
													String a_office_id        = parseNull((String)map.get("OFFICE_CD"));
													String a_office_nm        = parseNull((String)map.get("OFFICE_NM"));
													%>
													<option <%if(a_office_id.equals(u_office_cd)){ %>selected="selected"<%} %> value="<%=a_office_id%>"><%=a_office_nm %></option>
													<%
												}
											}
											%>
										</select>
								<%} %>
								<input type="text" id="in_office_nm" name="in_office_nm" for="in_office_nm" value="<%=u_office_nm %>" />
							</td>
							<th scope="row">직위,직급</th>
							<td >
								<input type="text" id="position_nm" name="position_nm" for="position_nm" value="<%=u_position_nm %>" />
							</td>
						</tr>
						<tr>
							<th scope="row">이름</th>
							<td colspan="3">
								<input type="text" id="emplyr_nm" name="emplyr_nm" for="emplyr_nm" value="<%=u_emplyr_nm %>" />
							</td>
						</tr>
						<tr>
							<th scope="row">업무대행자</th>
							<td >
								<input type="text" id="agen_nm" name="agen_nm" for="agen_nm" value="<%=u_agen_nm %>" />
							</td>
							<th scope="row">전화번호</th>
							<td >
								<input type="text" id="office_tel" name="office_tel" for="office_tel" value="<%=u_office_tel %>" />
							</td>
						</tr>
						<tr>
							<th scope="row">기준일자</th>
							<td >
								<input type="text" id="standard_dt" name="standard_dt" for="standard_dt" value="<%=u_standard_dt %>" />
								형식:YYYYMMDD
							</td>
							<th scope="row">출력순서</th>
							<td >
								<input type="text" id="sort_order" name="sort_order" for="sort_order" value="<%=u_sort_order %>" />
							</td>
						</tr>
						<tr>
							<th scope="row">담당업무</th>
							<td colspan="3">
								<textarea rows="10" cols="80" id="office_pt_memo" name="office_pt_memo" class="wps_90"><%=u_office_pt_memo %></textarea>
							</td>
						</tr>
					</table>
					<p class="txt_c">
						<button type="button" onclick="postForm()" class="btn medium edge mako">저장</button>
					</p>
				</fieldset>
			</form>
		</div>
	</div>
	<!-- // content -->
</div>
</body>
</html>
