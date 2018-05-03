<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 학교관리 - 사립</title>
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

//Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
List<Map<String, Object>> dataList = null;

//SessionManager sessionManager = new SessionManager(request);

String school_id			= parseNull(request.getParameter("school_id"));
String school_name 			= parseNull(request.getParameter("school_name"));
String school_area 			= parseNull(request.getParameter("school_area"));
String school_addr 			= parseNull(request.getParameter("school_addr"));
String school_tel  			= parseNull(request.getParameter("school_tel"));
String school_url 			= parseNull(request.getParameter("school_url"));
String charge_dept 			= parseNull(request.getParameter("charge_dept"));
String dept_tel 			= parseNull(request.getParameter("dept_tel"));
String charge_name 			= parseNull(request.getParameter("charge_name"));
String charge_phone 		= parseNull(request.getParameter("charge_phone"));
String account 				= parseNull(request.getParameter("account"));
String area_type 			= parseNull(request.getParameter("area_type"));
String charge_id 			= parseNull(request.getParameter("charge_id"));
String school_approval 		= parseNull(request.getParameter("school_approval"));
String sch_approval_date 	= parseNull(request.getParameter("sch_approval_date"));
String charge_name2 		= "";
String school_type	 		= parseNull(request.getParameter("school_type"));

String search1 = parseNull(request.getParameter("search1"));
String search2 = parseNull(request.getParameter("search2"));
String search3 = parseNull(request.getParameter("search3"));
String keyword = parseNull(request.getParameter("keyword"));

String areaArr[] = {"창원시","김해시","진주시","양산시", "거제시" ,"통영시","사천시","밀양시","함안군","거창군","창녕군","고성군"
		,"하동군","합천군","남해군","함양군","산청군","의령군"};

int num = 0;
int key = 0;

Paging paging = new Paging();
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;



try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	//학교 카운트
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT COUNT(*) CNT FROM RESERVE_SCHOOL WHERE 1=1 		");
	sql.append("AND SCHOOL_TYPE = 'PRIVATE' 								");
	if(!"".equals(keyword)){
		if("title".equals(search1)){
			sql.append("AND SCHOOL_NAME LIKE '%'||?||'%' ");
			paging.setParams("keyword", keyword);
		}else{
			sql.append("AND CHARGE_ID LIKE '%'||?||'%' ");
			paging.setParams("keyword", keyword);
		}
		
	}
	if(!"".equals(search2)){
		sql.append("AND SCHOOL_APPROVAL = ? ");
		paging.setParams("search2", search2);
	}
	if(!"".equals(search3)){
		sql.append("AND SCHOOL_AREA = ? ");
		paging.setParams("search3", search3);
	}

	pstmt = conn.prepareStatement(sql.toString());
	if(!"".equals(keyword)){
		pstmt.setString(++key, keyword);
	}
	if(!"".equals(search2)){
		pstmt.setString(++key, search2);
	}
	if(!"".equals(search3)){
		pstmt.setString(++key, search3);
	}

	rs = pstmt.executeQuery();
	if(rs.next()){
		totalCount = rs.getInt("CNT");
	}

	paging.setPageNo(Integer.parseInt(pageNo));
	paging.setTotalCount(totalCount);
	paging.setPageSize(10);
	paging.setPageBlock(10);


	//학교목록
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT * FROM ( \n");
	sql.append("	SELECT ROWNUM AS RNUM, A.* FROM ( \n");
	sql.append("		SELECT SCHOOL_ID, SCHOOL_NAME, SCHOOL_AREA, SCHOOL_ADDR, SCHOOL_TEL, SCHOOL_URL, CHARGE_DEPT, DEPT_TEL, CHARGE_NAME, CHARGE_NAME2 ");
	sql.append("		, CHARGE_PHONE, ACCOUNT, AREA_TYPE, CHARGE_ID, TO_CHAR(SCH_APPROVAL_DATE, 'yyyy-MM-dd') SCH_APPROVAL_DATE, SCHOOL_TYPE ");
	sql.append("		, CASE WHEN SCHOOL_APPROVAL = 'Y' THEN '승인완료' ");
	sql.append("		       WHEN SCHOOL_APPROVAL = 'W' THEN '승인대기' ");
	sql.append("			   WHEN SCHOOL_APPROVAL = 'N' THEN '승인취소' ");
	sql.append("		       END SCHOOL_APPROVAL ");
	sql.append("		FROM RESERVE_SCHOOL WHERE 1=1 					");
	sql.append("AND SCHOOL_TYPE = 'PRIVATE' 								");
	if(!"".equals(keyword)){
		if("title".equals(search1)){
			sql.append("AND SCHOOL_NAME LIKE '%'||?||'%' ");
			paging.setParams("keyword", keyword);
		}else{
			sql.append("AND CHARGE_ID LIKE '%'||?||'%' ");
			paging.setParams("keyword", keyword);
		}
	}
	if(!"".equals(search2)){
		sql.append("AND SCHOOL_APPROVAL = ? ");
		paging.setParams("search2", search2);
	}
	if(!"".equals(search3)){
		sql.append("AND SCHOOL_AREA = ? ");
		paging.setParams("search3", search3);
	}
	sql.append("		ORDER BY DECODE(SCHOOL_APPROVAL, '승인대기', 1, '승인완료', 2), SCHOOL_NAME ");
	sql.append("	) A WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" \n");
	sql.append(") WHERE RNUM > ").append(paging.getStartRowNo()).append(" \n");
	pstmt = conn.prepareStatement(sql.toString());
	if(!"".equals(keyword)){
		pstmt.setString(++key, keyword);
	}
	if(!"".equals(search2)){
		pstmt.setString(++key, search2);
	}
	if(!"".equals(search3)){
		pstmt.setString(++key, search3);
	}

	rs = pstmt.executeQuery();
	dataList = getResultMapRows(rs);


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
$(function(){
	$("#allCheck").click(function(){
		if($(this).is(":checked")){
			$("input[name=selCheck").prop("checked", "checked");
		}else{
			$("input[name=selCheck").removeAttr("checked");
		}
	});
});
function postForm(reserve_type){
	$("#postForm").submit();
}
function search(){
	if($.trim($("#search1").val()) == "" && $.trim($("#search2").val()) != "" ){
		alert("연도를 선택하여 주시기 바랍니다.");
		return false;
	}
	$("#postForm").submit();
}
function schDel(school_id){
	if(confirm("학교정보를 삭제할시 모든 정보가 삭제됩니다.\n삭제하시겠습니까?")){
		location.href="delAction.jsp?school_id="+school_id+"&school_type=PRIVATE";
	}else{
		return false;
	}

}
function selChange(){
	var length = $("input[name=selCheck]:checked").length;
	if(length > 0){
		if(confirm("상태를 변경하시겠습니까?")){
			$("#school_approval").val($("#allChange").val());
			$("#postForm").attr("action", "/program/school_reserve/admin/approvalAction2.jsp?school_type=PRIVATE");
			$("#postForm").submit();
		}else{
			return false;
		}
	}else{
		alert("변경할 데이터를 선택하여주시기 바랍니다.");
		return false;
	}
}
</script>
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>학교관리 - 사립</strong></p>
      <p class="location" style="float:right; margin-right:20px;">
		<span><a href="/iam/main/index.sko?lang=en_US" target="_top" class="last co_yellow">ENGLISH</a>[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span>님 안녕하세요.
		<a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
  	</p>
  </div>
	<div id="content">
		<div class="searchBox">
			<form action="" method="post" id="searchForm">
				<fieldset>
					<legend>검색하기</legend>
					<input type="hidden" name="pageNo" id="pageNo" value="<%=pageNo%>">
					<select name="search3" id="search3">
						<option value="">지역 선택</option>
						<%for(String ob : areaArr){ %>
						<option value="<%=ob%>" <%if(ob.equals(search3)){%> selected <%}%>><%=ob%></option>
						<%} %>
					</select>
					<select name="search2" id="search2">
						<option value=""  >승인상태</option>
						<option value="W" <%if("W".equals(search2)){%> selected <%}%> >승인대기</option>
						<option value="Y" <%if("Y".equals(search2)){%> selected <%}%> >승인완료</option>
						<option value="N" <%if("N".equals(search2)){%> selected <%}%> >승인취소</option>
					</select>
					<select name="search1" id="search1">
						<option value="title" <%if("title".equals(search1)){%> selected <%}%> >학교명</option>
						<option value="id" <%if("id".equals(search1)){%> selected <%}%> >아이디</option>
					</select>
					<input type="text" name="keyword" id="keyword" value="<%=keyword%>">
					<input type="submit" value="검색하기" class="btn small edge mako">
					<div class="btn_area txt_r magT20">
						<p class="f_l boxin">
							<label for="allChange">학교 승인상태</label>
							<select name="allChange" id="allChange">
								<option value="W">승인대기</option>
								<option value="Y" >승인완료</option>
								<option value="N" >승인취소</option>
							</select>
							<button type="button" class="btn small edge green" onclick="selChange();">일괄변경</button>
						</p>

						<!-- <button type="button" class="btn medium edge darkMblue" onclick="new_win2('priceForm.jsp','group_form','1000','800','yes','yes','yes');" >시설금액관리</button> -->
						<button type="button" class="btn medium edge darkMblue" onclick="new_win2('insertForm.jsp?command=insert&sch_type=private','group_form','1000','800','yes','yes','yes');" >학교등록</button>
					</div>
				</fieldset>
			</form>
		</div>

		<div class="listArea">
			<form action="" method="post" id="postForm">
			<input type="hidden" name="school_approval" id="school_approval" value="">
				<fieldset>
					<legend>학교관리 목록 결과</legend>
					<table class="bbs_list wordbr">
						<colgroup>
						<col width="3%"/>
						<col width="5%"/>
						<col width="5%"/>
						<col width="6%"/>
						<col />
						<col width="9%"/>
						<col width="9%"/>
						<col width="8%"/>
						<col width="10%"/>
						<col width="8%"/>
						<col width="8%"/>
						<col width="5%"/>
						<col width="5%"/>
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><input type="checkbox" name="allCheck" id="allCheck"></th>
								<th scope="col">번호</th>
								<th scope="col">지역</th>
								<th scope="col">시,군 구분</th>
								<th scope="col">학교명</th>
								<th scope="col">아이디 이름</th>
								<th scope="col">아이디</th>
								<th scope="col">담당자명</th>
								<th scope="col">담당자 전화번호</th>
								<th scope="col">상태</th>
								<th scope="col">승인날짜</th>
								<th scope="col">정보수정</th>
								<th scope="col">삭제</th>
							</tr>
						</thead>
						<tbody>
						<%
						if(dataList != null && dataList.size() > 0){
							num = paging.getRowNo();
							for(int i=0; i<dataList.size(); i++){
								Map<String,Object> map = dataList.get(i);
								school_id 			= parseNull(map.get("SCHOOL_ID").toString());
								school_area 		= parseNull(map.get("SCHOOL_AREA").toString());
								school_name 		= parseNull(map.get("SCHOOL_NAME").toString());
								charge_id 			= parseNull(map.get("CHARGE_ID").toString());
								school_approval 	= parseNull(map.get("SCHOOL_APPROVAL").toString());
								sch_approval_date 	= parseNull(map.get("SCH_APPROVAL_DATE").toString());
								area_type 			= parseNull(map.get("AREA_TYPE").toString());
								charge_name 		= parseNull(map.get("CHARGE_NAME").toString());
								charge_name2 		= parseNull(map.get("CHARGE_NAME2").toString());
								charge_phone 		= parseNull(map.get("CHARGE_PHONE").toString());
								school_type 		= parseNull(map.get("SCHOOL_TYPE").toString());
								
								if("N".equals(area_type)){
									area_type = "시지역";
								}else{
									area_type = "군,읍,면 지역";
								}
								
								school_type = "PUBLIC".equals(school_type)?"공립":"사립";
						%>
							<tr>
								<td><input type="checkbox" name="selCheck" id="selCheck" value="<%=school_id%>"></td>
								<td><%=num-- %></td>
								<td><%=school_area %></td>
								<td><%=area_type %></td>
								<td><%=school_name %></td>
								<td><%=charge_name2%></td>
								<td><%=charge_id %></td>
								<td><%=charge_name %></td>
								<td><%=telSet(charge_phone)%></td>
								<td><%=school_approval %></td>
								<td><%=sch_approval_date %></td>
								<td><a onclick="new_win2('insertForm.jsp?school_id=<%=school_id%>&command=update','group_form','1000','800','yes','yes','yes');" class="btn edge small mako">수정</a></td>
								<td><a onclick="schDel('<%=school_id%>')" class="btn edge small white" >삭제</a></td>
							</tr>
						<%
							}
						}else{
						%>
							<tr>
								<td colspan="13">데이터가 없습니다.</td>
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
