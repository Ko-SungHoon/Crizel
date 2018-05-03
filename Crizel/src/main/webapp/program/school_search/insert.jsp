<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>RFC관리자 > 학교찾기 > 학교등록</title>
	<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
	<script type='text/javascript' src='/js/jquery.js'></script>
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
	
	SessionManager sm = new SessionManager(request);

	response.setCharacterEncoding("UTF-8");
	request.setCharacterEncoding("UTF-8");


	//Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	StringBuffer sql = null;

	String command = parseNull(request.getParameter("command"));
	String sid = parseNull(request.getParameter("sid"));
	String code = parseNull(request.getParameter("code"));
	String title =  parseNull(request.getParameter("title"));
	String addr =  parseNull(request.getParameter("addr"));
	String url =  parseNull(request.getParameter("url"));
	String tel = parseNull(request.getParameter("tel"));
	String fax = parseNull(request.getParameter("fax"));
	String area_type = parseNull(request.getParameter("area_type"));
	String coedu = parseNull(request.getParameter("coedu"));
	String cate1 =  parseNull(request.getParameter("cate1"));
	String cate2 =  parseNull(request.getParameter("cate2"));
	String post = parseNull(request.getParameter("post"));
	
	int result = 0;

	try {
		sqlMapClient.startTransaction();
		conn = sqlMapClient.getCurrentConnection();

		if("update".equals(command)){
			sql=new StringBuffer();
			sql.append("SELECT * FROM SCHOOL_SEARCH WHERE SID = ?  ");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, sid);
			rs = pstmt.executeQuery();

			if(rs.next()){
				code = parseNull(rs.getString("CODE"));
				title = parseNull(rs.getString("TITLE"));
				addr = parseNull(rs.getString("ADDR"));
				url = parseNull(rs.getString("URL"));
				tel = parseNull(rs.getString("TEL"));
				fax = parseNull(rs.getString("FAX"));
				area_type = parseNull(rs.getString("area_type"));
				coedu = parseNull(rs.getString("COEDU"));
				cate1 = parseNull(rs.getString("CATE1"));
				cate2 = parseNull(rs.getString("CATE2"));
			}

		}


	} catch (Exception e) {
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
	function insert(){
		if(confirm("등록하시겠습니까")){
			if($.trim($("#title").val()) == ""){
				alert("학교명을 입력해주시기 바랍니다.");
				$("#title").focus();
				return false;
			}else{
				return true;
			}
		}else{
			return false;
		}
	}
	</script>
	<style>
		table td {text-align:left !important;}
		table textarea {width:80%; height:100px;}
		table #addr {width:60%; min-width:260px;}
		table #title, table #writer, table #area_type, table #coedu, table #tel, table #fax, table #email , table #url, table #addr, table #code{width:80%; min-width:170px;}
	</style>
</head>
<body>
<div id="right_view">
	<div class="top_view">
    <p class="location">학교찾기 &gt; <strong>학교등록</strong></p>
  </div>
	<div id="content">
		<form action="action.jsp" id="insertForm" onsubmit="return insert();">
			<fieldset>
			<input type="hidden" name="command" value="<%=command %>">
			<input type="hidden" name="sid" value="<%=sid%>">
		  <table class="bbs_list2">
				<colgroup>
					<col style="width:18%" />
					<col />
					<col style="width:18%" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><label for="title"><span class="red">*</span> 학교명</label></th>
						<td><input type="text" name="title" id="title" value="<%=title%>" class=""></td>
						<th scope="row"><label for="cate1">학교형태</label></th>
						<td>
						<%
						String cate2_arr[] = {"국립", "사립", "공립"};
						%>
							<input type="text" name="cate1" id="cate1" value="<%=cate1%>">
							<select name="cate2" id="cate2">
								<option value="">설립구분</option>
								<%for(int i=0; i<cate2_arr.length; i++){
								%>
									<option value="<%=cate2_arr[i]%>"><%=cate2_arr[i]%></option>
								<%
								}
								%>
							</select>
					 	</td>
					</tr>
					<tr>
						<th scope="row"><lable for="area_type">지역구분</label></th>
						<td><input type="text" name="area_type" id="area_type" value="<%=area_type%>"></td>
						<th scope="row"><label for="coedu">남여공학</label></th>
						<td><input type="text" name="coedu" id="coedu" value="<%=coedu%>"></td>
					</tr>
					<tr>
						<th scope="row"><label for="tel">학교 전화번호</label></th>
						<td><input type="text" name="tel" id="tel" value="<%=tel%>"></td>
						<th scope="row"><label for="fax">학교 팩스번호</label></th>
						<td><input type="text" name="fax" id="fax" value="<%=fax%>"></td>
					</tr>
					<tr>
						<th scope="row"><label for="url">학교 홈페이지</label></th>
						<td><input type="text" name="url" id="url" value="<%=url%>"></td>
						<th scope="row"><label for="post">우편번호</label></th>
						<td><input type="text" name="post" id="post" value="<%=post%>"></td>
					</tr>
					<tr>
						<th scope="row"><label for="addr">학교 주소</label></th>
						<td><input type="text" name="addr" id="addr" value="<%=addr%>"></td>
						<th scope="row"><label for="code">학교코드</label></th>
						<td><input type="text" name="code" id="code" value="<%=code%>"></td>
					</tr>
				</tbody>
			</table>
			<div class="btn_area txt_c">
				<button class="btn edge small mako">확인</button>
				<button type="button" onclick="location.href='list.jsp'" class="btn edge small white">취소</button>
			</div>
		</fieldset>
		</form>
	</div>
	<!-- //content -->
</div>
</body>
</html>
