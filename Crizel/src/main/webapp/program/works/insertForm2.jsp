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

Calendar cal = Calendar.getInstance();
SimpleDateFormat dfhm        = new SimpleDateFormat("yyyyMMdd");
cal = Calendar.getInstance();
String today = dfhm.format(cal.getTime());

response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

//Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
List<Map<String, Object>> officeList1 = null;
String in_office_cd = parseNull(request.getParameter("in_office_cd"));



try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

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
	alertBack(out, "처리중 오류가 발생하였습니다.");
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

	if($.trim($("#in_office_cd").val()) == ""){
		alert("부서를 선택해 주세요.");
		$("#in_office_cd").focus();
		return false;
	}
	
	if($("#dt1").val().length != 8){
		alert("년월일 형식이 잘못됐습니다.\n 20170101형식");		
		return false;
	}
	
	if(confirm("기존 부서데이터는 모두 삭제됩니다.\n진행하시겠습니까?")){
		//alert($("#in_office_cd option:selected").text());
		$("#in_office_nm").val($("#in_office_cd option:selected").text());
		//$("#postForm").attr("action","/index.gne?menuCd=DOM_000000117002000000");		//테스트서버
		$("#postForm").attr("action","/index.gne?menuCd=DOM_000000106018000000");
		$("#postForm").submit();	
	}
	
}

// 3레벨 부서 변경
function chngOffice(){
	if($.trim($("#in_office_cd").val()) == ""){
		return false;
	}
	//alert("TTTTTTTTTT");
	$("#in_office_nm").val($("#in_office_cd option:selected").text());
	$("#postForm").attr("action","./insertForm2.jsp?in_office_cd="+$("#in_office_cd").val());
	$("#postForm").submit();
}

</script>
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>업무분장관리</strong></p>
  </div>
	<div id="content">
		<div class="listArea">
			<form action="./insertForm2.jsp" method="post" id="postForm" enctype="multipart/form-data">
				<input type="hidden" id="in_office_nm" name="in_office_nm" value="" />
				<input type="hidden" id="dt_office_nm" name="dt_office_nm" value="" />
				<fieldset>
					<legend>업무분장관리</legend>
					<table class="bbs_list2">
						<colgroup>
						<col class="wps_25"/>
						<col class="wps_25"/>
						<col class="wps_25"/>
						<col class="wps_25"/>
						</colgroup>
						<tbody>
						<tr>
							<th scope="row">다운로드</th>
							<td colspan="3">
								<a href="./temp.xls">샘플 다운로드</a>
							</td>
						</tr>
						<tr>
							<th scope="row">백업 다운로드</th>
							<td colspan="3">
								<a href="./excel4.jsp">백업 다운로드</a>
							</td>
						</tr>
						<tr>
							<th scope="row">부서</th>
							<td colspan="3">
								<select name="in_office_cd" id="in_office_cd" for="in_office_cd" onchange="chngOffice();" >
									<option value="">선택</option>
									<%
									if(officeList1 != null && officeList1.size() > 0){
										for(int i=0; i<officeList1.size(); i++){
											Map<String,Object> map = officeList1.get(i);
											String a_office_id        = parseNull((String)map.get("OFFICE_CD"));
											String a_office_nm        = parseNull((String)map.get("OFFICE_NM"));
											%>
											<option <%if(a_office_id.equals(in_office_cd)){ %>selected="selected"<%} %> value="<%=a_office_id%>"><%=a_office_nm %></option>
											<%
										}
									}
									%>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">등록기준일</th>
							<td colspan="3">
								<input type="text" id="dt1" name="dt1" value="<%=today%>" />형식:YYYYMMDD
							</td>
						</tr>
						<tr>
							<th scope="row">파일등록</th>
							<td colspan="3">
								<input type="file" name="upload" id="upload" title="첨부파일">
							</td>
						</tr>
						</tbody>
					</table>
					<p class="txt_c">
						<button type="button" onclick="postForm();" class="btn medium edge mako">등록</button>
					</p>
				</fieldset>
			</form>
		</div>
	</div>
	<!-- // content -->
</div>
</body>
</html>
