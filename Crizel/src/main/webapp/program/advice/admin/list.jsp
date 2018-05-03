<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 사이버상담</title>
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

String teacher_id   = parseNull(request.getParameter("teacher_id"));
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


String search_category_gb = parseNull(request.getParameter("search_category_gb"));	//분류 A01 = 진로 , A02 = 진학
String search_target_gb = parseNull(request.getParameter("search_target_gb"));		//대상 B01 = 초등 , B02 = 중등
String search_advice_yn = parseNull(request.getParameter("search_advice_yn"));	//상담원적용여부
String search_gb = parseNull(request.getParameter("search_gb")); //검색구분
String search_keyword = parseNull(request.getParameter("search_keyword")); //검색어

int num = 0;


Paging paging = new Paging();
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
int cnt=0;



try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	//학교 카운트
	cnt = 0;
	sql = new StringBuffer();
	sql.append("SELECT COUNT(*) CNT FROM ADVICE_TEACHER WHERE 1=1 ");
	if(!"".equals(parseNull(search_keyword))){
		if("A".equals(search_gb)){	//이름
			sql.append("AND TEACHER_NM LIKE '%'||?||'%' ");
		}else if("B".equals(search_gb)){	//아이디
			sql.append("AND TEACHER_ID LIKE '%'||?||'%' ");
		}else if("C".equals(search_gb)){	//휴대폰
			sql.append("AND HP_NO LIKE '%'||?||'%' ");

		}
		paging.setParams("search_keyword", search_keyword);
	}

	if(!"".equals(parseNull(search_category_gb))){	//분류
		sql.append("AND CATEGORY_GB = ? ");
		paging.setParams("search_category_gb", search_category_gb);
	}

	if(!"".equals(parseNull(search_target_gb))){	//대상
		sql.append("AND TARGET_GB = ? ");
		paging.setParams("search_target_gb", search_target_gb);

	}

	if(!"".equals(parseNull(search_advice_yn))){	//상담원 적용여부
		sql.append("AND ADVICE_YN = ? ");
		paging.setParams("search_advice_yn", search_advice_yn);

	}

	pstmt = conn.prepareStatement(sql.toString());
	if(!"".equals(parseNull(search_keyword))){
		++cnt;
		pstmt.setString(cnt, search_keyword);
	}

	if(!"".equals(parseNull(search_category_gb))){
		++cnt;
		pstmt.setString(cnt, search_category_gb);
	}

	if(!"".equals(parseNull(search_target_gb))){
		++cnt;
		pstmt.setString(cnt, search_target_gb);
	}

	if(!"".equals(parseNull(search_advice_yn))){
		++cnt;
		pstmt.setString(cnt, search_advice_yn);
	}
	rs = pstmt.executeQuery();
	if(rs.next()){
		totalCount = rs.getInt("CNT");
	}

	paging.setPageNo(Integer.parseInt(pageNo));
	paging.setTotalCount(totalCount);
	paging.setPageSize(10);
	paging.setPageBlock(10);


	//상담교사 리스트
	cnt = 0;
	sql = new StringBuffer();
	sql.append("SELECT * FROM ( \n");
	sql.append("	SELECT ROWNUM AS RNUM, A.* FROM ( \n");

	sql.append(" SELECT                                      \n");
	sql.append("     TEACHER_ID                              \n");
	sql.append("   , TEACHER_NM                              \n");
	sql.append("   , CASE WHEN CATEGORY_GB = 'A01' THEN '진로' \n");
	sql.append("          WHEN CATEGORY_GB = 'A02' THEN '진학' \n");
	sql.append("     END CATEGORY_GB                         \n");
	sql.append("   , CASE WHEN TARGET_GB = 'B01' THEN '초등'   \n");
	sql.append("          WHEN TARGET_GB = 'B02' THEN '중등'   \n");
	sql.append("     END TARGET_GB                           \n");
	sql.append("   , SUBSTR(HP_NO,1,3)||'-'||SUBSTR(HP_NO,4,4)||'-'||SUBSTR(HP_NO,8,4) AS HP_NO \n");
	sql.append("   , CASE WHEN ADVICE_YN = 'Y' THEN '적용' WHEN ADVICE_YN = 'N' THEN '적용안함' END ADVICE_YN \n");
	sql.append("   , ADVICE_ST_DT                            \n");
	sql.append("   , ADVICE_ED_DT                            \n");
	sql.append("   , SUBSTR(REG_DT,1,4)||'-'||SUBSTR(REG_DT,5,2)||'-'||SUBSTR(REG_DT,7,2) AS REG_DT \n");
	sql.append("   , REG_ID                                  \n");
	sql.append("   , MOD_DT                                  \n");
	sql.append("   , MOD_ID                                  \n");
	sql.append(" FROM ADVICE_TEACHER  WHERE 1=1                       \n");
	if(!"".equals(parseNull(search_keyword))){
		if("A".equals(search_gb)){	//이름
			sql.append("AND TEACHER_NM LIKE '%'||?||'%' ");
		}else if("B".equals(search_gb)){	//아이디
			sql.append("AND TEACHER_ID LIKE '%'||?||'%' ");
		}else if("C".equals(search_gb)){	//휴대폰
			sql.append("AND HP_NO LIKE '%'||?||'%' ");

		}
		paging.setParams("search_keyword", search_keyword);
	}

	if(!"".equals(parseNull(search_category_gb))){	//분류
		sql.append("AND CATEGORY_GB = ? ");
		paging.setParams("search_category_gb", search_category_gb);
	}

	if(!"".equals(parseNull(search_target_gb))){	//대상
		sql.append("AND TARGET_GB = ? ");
		paging.setParams("search_target_gb", search_target_gb);

	}

	if(!"".equals(parseNull(search_advice_yn))){	//상담원 적용여부
		sql.append("AND ADVICE_YN = ? ");
		paging.setParams("search_advice_yn", search_advice_yn);

	}

	sql.append("		ORDER BY REG_DT DESC,REG_HMS DESC ");
	sql.append("	) A WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" \n");
	sql.append(") WHERE RNUM > ").append(paging.getStartRowNo()).append(" \n");
	pstmt = conn.prepareStatement(sql.toString());

	if(!"".equals(parseNull(search_keyword))){
		++cnt;
		pstmt.setString(cnt, search_keyword);
	}

	if(!"".equals(parseNull(search_category_gb))){
		++cnt;
		pstmt.setString(cnt, search_category_gb);
	}

	if(!"".equals(parseNull(search_target_gb))){
		++cnt;
		pstmt.setString(cnt, search_target_gb);
	}

	if(!"".equals(parseNull(search_advice_yn))){
		++cnt;
		pstmt.setString(cnt, search_advice_yn);
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

$(function(){ //전체선택 체크박스 클릭
	$("#chkAll").click(function(){ 
		//만약 전체 선택 체크박스가 체크된상태일경우 
		if($("#chkAll").prop("checked")) {
			//해당화면에 전체 checkbox들을 체크해준다 
			$("input[type=checkbox]").prop("checked",true); 
			// 전체선택 체크박스가 해제된 경우 
		} else { //해당화면에 모든 checkbox들의 체크를해제시킨다. 
			$("input[type=checkbox]").prop("checked",false); 
		} 
	}) 
})

//선택삭제 호출
function check_delete(){
	if( $(":checkbox[name='chk']:checked").length == 0 ){
    	alert("선택된 데이터가 없습니다.");
    	return;
  	}
	
	if(confirm("삭제하시겠습니까?")){
		 var chked_val = "";
		 $(":checkbox[name='chk']:checked").each(function(pi,po){
		   chked_val += ","+po.value;
		 });
		 if(chked_val!="")chked_val = chked_val.substring(1);
		 
		 $("#chk_obj").val(chked_val);
		 //alert("선택값 : = "+chked_val);
		 
		 $("#searchForm").attr("action","./teacher_register.jsp?command=delete");
	     $("#searchForm").submit();	
	}
}

//상담선생님 수정
function modify(school_id){
	alert("준비중입니다.");
}

//상담 선생님 엑셀다운로드
function excel(){
	location.href="excel1.jsp";
}
</script>
<div id="right_view" class="advice_tch">
	<div class="top_view">
    <p class="location"><strong>상담선생님 관리</strong></p>
	<p class="location" style="float:right; margin-right:20px;">
		<span><a href="/iam/main/index.sko?lang=en_US" target="_top" class="last co_yellow">ENGLISH</a>[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span>님 안녕하세요.
		<a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
  	</p>
  </div>
  
	<div id="content">
		<!-- 검색 조건 영역 -->
		<div class="searchBox">
			<form action="" method="post" id="searchForm">
				<input type="hidden" name="chk_obj" id="chk_obj" value="">	<!-- 삭제할 데이터의 키값 파싱 -->
				
				<fieldset>
					<legend>검색하기</legend>
					<input type="hidden" name="pageNo" id="pageNo" value="<%=pageNo%>">
					<div class="boxinner">
						<span>
							<label for="search_category_gb">분류</label>
							<select name="search_category_gb" id="search_category_gb" for="search_category_gb" value="<%=search_category_gb%>">
								<option value="">전체</option>
								<option <%if("A01".equals(search_category_gb)){ %>selected="selected"<% } %> value="A01">진로</option>
								<option <%if("A02".equals(search_category_gb)){ %>selected="selected"<% } %> value="A02">진학</option>
							</select>
						</span>
						<span><label for="search_target_gb">대상</label>
							<select name="search_target_gb" id="search_target_gb" for="search_target_gb" value="<%=search_target_gb%>">
								<option value="">전체</option>
								<option <%if("B01".equals(search_target_gb)){ %>selected="selected"<% } %> value="B01">초등</option>
								<option <%if("B02".equals(search_target_gb)){ %>selected="selected"<% } %> value="B02">중등</option>
							</select>
						</span>
						<span>
							<label for="search_advice_yn">상담원 적용 여부</label>
							<select name="search_advice_yn" id="search_advice_yn" for="search_advice_yn" value="<%=search_advice_yn%>">
								<option value="">전체</option>
								<option <%if("Y".equals(search_advice_yn)){ %>selected="selected"<% } %> value="Y">적용</option>
								<option <%if("N".equals(search_advice_yn)){ %>selected="selected"<% } %> value="N">적용안함</option>
							</select>
						</span>
						<span>
							<label for="search_gb">검색어</label>
							<select name="search_gb" id="search_gb" >
								<option <%if("A".equals(search_gb)){ %>selected="selected"<% } %> value="A">이름</option>
								<option <%if("B".equals(search_gb)){ %>selected="selected"<% } %> value="B">아이디</option>
								<option <%if("C".equals(search_gb)){ %>selected="selected"<% } %> value="C">휴대폰</option>
							</select>
							<input type="text" name="search_keyword" id="search_keyword" value="<%=search_keyword%>">
							<input type="submit" value="검색" class="btn small edge mako">
						</span>
					</div>
				</fieldset>
			</form>
		</div>
		<!-- //검색 조건 영역 끝 -->

		<div class="btn_area txt_r magT20">
			<button type="button" onclick="check_delete();" class="btn small edge white f_l">선택삭제</button>
			<button type="button" onclick="excel();" class="btn medium edge mako">엑셀다운로드</button>
			<button type="button" class="btn medium edge darkMblue" onclick="new_win2('insertForm.jsp?command=insert','group_form','600','400','yes','yes','yes');" >상담교사등록</button>
		</div>

	<!-- 상담선생님 목록 -->
		<div class="listArea">
			<form action="" method="post" id="postForm">
				<fieldset>
					<legend>상담선생님 목록 결과</legend>
					<table class="bbs_list">
						<colgroup>
							<col style="width:3%" />
							<col class="wps_5"/>
							<col class="wps_5" />
							<col class="wps_5"/>
							<col />
							<col />
							<col />
							<col class="wps_10"/>
							<col class="wps_10"/>
							<col class="wps_5"/>
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><input type="checkbox" name="chkAll" id="chkAll"></th>
								<th scope="col">번호</th>
								<th scope="col">분류</th>
								<th scope="col">대상</th>
								<th scope="col">상담교사명</th>
								<th scope="col">아이디</th>
								<th scope="col">휴대폰</th>
								<th scope="col">상담원적용</th>
								<th scope="col">등록일</th>
								<th scope="col">수정</th>
							</tr>
						</thead>
						<tbody>
						<%
						if(dataList != null && dataList.size() > 0){
							num = paging.getRowNo();
							for(int i=0; i<dataList.size(); i++){
								Map<String,Object> map = dataList.get(i);
								teacher_id   = parseNull((String)map.get("TEACHER_ID"));
								teacher_nm   = parseNull((String)map.get("TEACHER_NM"));
								category_gb  = parseNull((String)map.get("CATEGORY_GB"));
								target_gb    = parseNull((String)map.get("TARGET_GB"));
								hp_no        = parseNull((String)map.get("HP_NO"));
								advice_yn    = parseNull((String)map.get("ADVICE_YN"));
								advice_st_dt = parseNull((String)map.get("ADVICE_ST_DT"));
								advice_ed_dt = parseNull((String)map.get("ADVICE_ED_DT"));
								reg_dt       = parseNull((String)map.get("REG_DT"));
								reg_id       = parseNull((String)map.get("REG_ID"));
								mod_dt       = parseNull((String)map.get("MOD_DT"));
								mod_id       = parseNull((String)map.get("MOD_ID"));

						%>
							<tr>
								<td class="title"><input type="checkbox" id="chk" name="chk" value="<%=teacher_id %>" /></td>
								<td><%=num-- %></td>
								<td><%=category_gb %></td>
								<td><%=target_gb %></td>
								<td><%=teacher_nm %></td>
								<td><%=teacher_id %></td>
								<td><%=hp_no %></td>
								<td><%=advice_yn %></td>
								<td><%=reg_dt %></td>
								<td><a onclick="new_win2('insertForm.jsp?teacher_id=<%=teacher_id%>&command=update','group_form','600','400','yes','yes','yes');" class="btn edge small mako">수정</a></td>
							</tr>
						<%
							}
						}else{
						%>
							<tr>
								<td colspan="9">데이터가 없습니다.</td>
							</tr>
						<%
						}
						%>
						</tbody>
					</table>
				</fieldset>
			</form>
		</div>
		<!-- // 상담선생님 목록 끝 -->

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
