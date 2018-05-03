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
List<Map<String, Object>> officeList = null;
String in_office_cd = parseNull(request.getParameter("in_office_cd"));
String in_office_nm = parseNull(request.getParameter("in_office_nm"));

String e_seq           = parseNull(request.getParameter("e_seq"));
String emplyr_nm       = parseNull(request.getParameter("emplyr_nm"));
String position_nm     = parseNull(request.getParameter("position_nm"));
String office_cd       = parseNull(request.getParameter("office_cd"));
String office_nm       = parseNull(request.getParameter("office_nm"));
String office_pt_memo  = parseNull(request.getParameter("office_pt_memo"));
String office_tel      = parseNull(request.getParameter("office_tel"));
String agent_id        = parseNull(request.getParameter("agent_id"));
String agen_nm         = parseNull(request.getParameter("agen_nm"));
String standard_dt     = parseNull(request.getParameter("standard_dt"));
String reg_dt          = parseNull(request.getParameter("reg_dt"));
String reg_id          = parseNull(request.getParameter("reg_id"));
String mod_dt          = parseNull(request.getParameter("mod_dt"));
String mod_id          = parseNull(request.getParameter("mod_id"));
String office_dp       = parseNull(request.getParameter("office_dp"));
String office_cd_nm       = parseNull(request.getParameter("office_cd_nm"));

String search_gb      = parseNull(request.getParameter("search_gb")); //검색구분 A=부서,B=이름
String search_keyword = parseNull(request.getParameter("search_keyword")); //검색어

int num = 0;


Paging paging = new Paging();
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
int cnt=0;

//SessionManager sessionManager = new SessionManager(request);

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	//학교 카운트
	cnt = 0;
	sql = new StringBuffer();
	sql.append("SELECT COUNT(*) CNT FROM DIVISION_WORK WHERE 1=1 ");

	if(!"".equals(parseNull(in_office_cd))){
		sql.append("AND OFFICE_CD LIKE '%'||?||'%' ");
		paging.setParams("in_office_cd", in_office_cd);
	}

	if(!"".equals(parseNull(search_keyword))){
		if("A".equals(search_gb)){	//부서
			sql.append("AND OFFICE_NM LIKE '%'|| ? ||'%' ");
		}else if("B".equals(search_gb)){	//이름
			sql.append("AND EMPLYR_NM LIKE '%'|| ? ||'%' ");
		}
		paging.setParams("search_gb", search_gb);
		paging.setParams("search_keyword", search_keyword);
	}


	pstmt = conn.prepareStatement(sql.toString());

	if(!"".equals(parseNull(in_office_cd))){
		++cnt;
		pstmt.setString(cnt, in_office_cd);
	}

	if(!"".equals(parseNull(search_keyword))){
		++cnt;
		pstmt.setString(cnt, search_keyword);
	}

	rs = pstmt.executeQuery();
	if(rs.next()){
		totalCount = rs.getInt("CNT");
	}

	paging.setPageNo(Integer.parseInt(pageNo));
	paging.setTotalCount(totalCount);
	paging.setPageSize(10);
	paging.setPageBlock(10);


	//업무분장 리스트
	cnt = 0;
	sql = new StringBuffer();
	sql.append("SELECT * FROM ( \n");
	sql.append("	SELECT ROWNUM AS RNUM, A.* FROM ( \n");

	sql.append(" 		SELECT                                      \n");
	sql.append("             A.E_SEQ                                  \n");
	sql.append("           , A.EMPLYR_NM                              \n");
	sql.append("           , A.POSITION_NM                            \n");
	sql.append("           , A.OFFICE_CD                              \n");
	sql.append("           , (SELECT OFFICE_NM FROM RFC_COMTCOFFICE WHERE OFFICE_CD =  A.OFFICE_CD ) AS OFFICE_CD_NM                              \n");
	sql.append("           , A.OFFICE_NM                              \n");
	sql.append("           , A.OFFICE_PT_MEMO                         \n");
	sql.append("           , A.OFFICE_TEL                             \n");
	sql.append("           , A.AGENT_ID                               \n");
	sql.append("           , A.AGEN_NM                                \n");
	sql.append("           , A.STANDARD_DT                            \n");
	sql.append("           , A.REG_DT                                 \n");
	sql.append("           , A.REG_ID                                 \n");
	sql.append("           , A.MOD_DT                                 \n");
	sql.append("           , A.MOD_ID                                 \n");
	sql.append("           , A.OFFICE_DP                              \n");
	sql.append(" 		FROM DIVISION_WORK A  WHERE 1=1               \n");

	if(!"".equals(parseNull(in_office_cd))){
		sql.append("AND A.OFFICE_CD LIKE '%'||?||'%' ");
		paging.setParams("in_office_cd", in_office_cd);
	}

	if(!"".equals(parseNull(search_keyword))){
		if("A".equals(search_gb)){	//부서
			sql.append("AND A.OFFICE_NM LIKE '%'||?||'%' ");
		}else if("B".equals(search_gb)){	//이름
			sql.append("AND A.EMPLYR_NM LIKE '%'||?||'%' ");
		}
		paging.setParams("search_gb", search_gb);
		paging.setParams("search_keyword", search_keyword);
	}

	sql.append("		ORDER BY A.OFFICE_CD  , A.SORT_ORDER ");
	sql.append("	) A WHERE ROWNUM < ").append(paging.getEndRowNo()).append(" \n");
	sql.append(") WHERE RNUM >= ").append(paging.getStartRowNo()).append(" \n");
	pstmt = conn.prepareStatement(sql.toString());

	if(!"".equals(parseNull(in_office_cd))){
		++cnt;
		pstmt.setString(cnt, in_office_cd);
	}

	if(!"".equals(parseNull(search_keyword))){
		++cnt;
		pstmt.setString(cnt, search_keyword);
	}

	rs = pstmt.executeQuery();
	dataList = getResultMapRows(rs);

	/* 부서리스트 */
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
	officeList = getResultMapRows(rs);


} catch (Exception e) {
	%>
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



function chngOfficeHigh(){
	$("#searchForm").attr("action","./list.jsp");
	$("#searchForm").submit();
}


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

		 $("#searchForm").attr("action","./workAct.jsp?command=delete");
	     $("#searchForm").submit();
	}
}

//전체정보 엑셀다운로드
function excel(){
	location.href="excel3.jsp";
	
}

//검색
function search(){
	$("#search_gb").val($("#search_select").val());
	//alert("선택값: ="+ $("#search_gb").val());
	$("#searchForm").submit();
}
</script>
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>업무분장</strong></p>
      <p class="location" style="float:right; margin-right:20px;">
		<span><a href="/iam/main/index.sko?lang=en_US" target="_top" class="last co_yellow">ENGLISH</a>[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span>님 안녕하세요.
		<a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
  	</p>
  </div>
	<div id="content">
		<div class="searchBox">
			<form action="./list.jsp" method="post" id="searchForm">
				<fieldset>
					<legend>검색하기</legend>
					<input type="hidden" name="pageNo" id="pageNo" value="<%=pageNo%>" />
					<input type="hidden" name="chk_obj" id="chk_obj" value="">	<!-- 삭제할 데이터의 키값 파싱 -->
					<input type="hidden" name="search_gb" id="search_gb" value="<%=search_gb%>">	<!-- 삭제할 데이터의 키값 파싱 -->

					<!-- 분류 -->
					<div class="boxinner">
						<span><label for="in_office_cd">부서</label>
							<select name="in_office_cd" id="in_office_cd" for="in_office_cd" onchange="chngOfficeHigh();" >
								<option value="">전체</option>
								<%
								if(officeList != null && officeList.size() > 0){
									for(int i=0; i<officeList.size(); i++){
										Map<String,Object> map = officeList.get(i);
										String a_office_id        = parseNull((String)map.get("OFFICE_CD"));
										String a_office_nm        = parseNull((String)map.get("OFFICE_NM"));
										%>
										<option <%if(a_office_id.equals(in_office_cd)){ %>selected="selected"<% } %> value="<%=a_office_id%>"><%=a_office_nm %></option>
										<%
									}
								}
								%>
							</select>
						</span>

						<span>
							<select name="search_select" id="search_select" >
								<option <%if("A".equals(search_gb)){ %>selected="selected"<% } %> value="A">부서</option>
								<option <%if("B".equals(search_gb)){ %>selected="selected"<% } %> value="B">이름</option>
							</select>
							<input type="text" name="search_keyword" id="search_keyword" onkeyup="if(event.keyCode ==13){search();}" value="<%=search_keyword%>" />
							<input type="button" value="검색" class="btn small edge mako" onclick="search();" />
						</span>
					</div>
				</fieldset>

				<div class="btn_area txt_r magT20">
					<button type="button" class="btn medium edge green" onclick="new_win2('./excelForm.jsp','group_form','600','400','yes','yes','yes');" >담당자정보 수정</button>
					<button type="button" class="btn medium edge darkMblue" onclick="new_win2('./insertForm2.jsp','group_form','600','400','yes','yes','yes');" >업무분장 등록</button>
					<button type="button" class="btn medium edge mako" onclick="new_win2('./insertForm3.jsp?command=insert','group_form','800','650','yes','yes','yes');" >개별등록</button>
					<button type="button" class="btn medium edge white" onclick="check_delete();" >선택삭제</button>
					<button type="button" class="btn medium edge white" onclick="excel();" >전체백업</button>
				</div>
			</form>
		</div>

		<div class="listArea">
			<form action="" method="post" id="postForm">
				<fieldset>
					<legend>업무분장 목록 결과</legend>
					<table class="bbs_list">
						<colgroup>
						<col />
						<col />
						<col />
						<col />
						<col />
						<col />
						<col />
						<col />
						<col />
						<col />
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><input type="checkbox" id="chkAll" name="chkAll" /></th>
								<th scope="col">번호</th>
								<th scope="col">과명</th>
								<th scope="col">부서명</th>
								<th scope="col">기준일자</th>
								<th scope="col">이름</th>
								<th scope="col">담당업무</th>
								<th scope="col">업무대행자</th>
								<th scope="col">수정</th>
								<th scope="col">복사</th>
							</tr>
						</thead>
						<tbody>
						<%
						if(dataList != null && dataList.size() > 0){
							num = paging.getRowNo();
							for(int i=0; i<dataList.size(); i++){
								Map<String,Object> map = dataList.get(i);
								e_seq            = parseNull((String)map.get("E_SEQ"));
								emplyr_nm        = parseNull((String)map.get("EMPLYR_NM"));
								position_nm      = parseNull((String)map.get("POSITION_NM"));
								office_cd        = parseNull((String)map.get("OFFICE_CD"));
								office_nm        = parseNull((String)map.get("OFFICE_NM"));
								office_cd_nm        = parseNull((String)map.get("OFFICE_CD_NM"));
								office_pt_memo   = parseNull((String)map.get("OFFICE_PT_MEMO"));
								office_tel       = parseNull((String)map.get("OFFICE_TEL"));
								agent_id         = parseNull((String)map.get("AGENT_ID"));
								agen_nm          = parseNull((String)map.get("AGEN_NM"));
								standard_dt      = parseNull((String)map.get("STANDARD_DT"));
								reg_dt           = parseNull((String)map.get("REG_DT"));
								reg_id           = parseNull((String)map.get("REG_ID"));
								mod_dt           = parseNull((String)map.get("MOD_DT"));
								mod_id           = parseNull((String)map.get("MOD_ID"));
								office_dp        = parseNull((String)map.get("OFFICE_DP"));
								office_pt_memo = office_pt_memo.replace("\n","<br>");
						%>
							<tr>
								<td class="title"><input type="checkbox" id="chk" name="chk" value="<%=e_seq %>" /></td>
								<td><%=num-- %></td>
								<td><%=office_cd_nm %></td>
								<td><%=office_nm %></td>
								<td><%=standard_dt %></td>
								<td><%=emplyr_nm %></td>
								<td class="txt_l"><%=office_pt_memo %></td>
								<td><%=agen_nm %></td>
								<td>
									<a href="#" onclick="new_win2('./insertForm3.jsp?command=update&e_seq=<%=e_seq %>&standard_dt=<%=standard_dt %>&office_dp=<%=office_dp %>','group_form','800','650','yes','yes','yes');"  class="btn small mako edge">
										수정
									</a>
								</td>
								<td>
									<a href="#" onclick="new_win2('./insertForm3.jsp?command=insert&e_seq=<%=e_seq %>&standard_dt=<%=standard_dt %>&office_dp=<%=office_dp %>','group_form','800','650','yes','yes','yes');"  class="btn small mako edge">
										복사
									</a>
								</td>
							</tr>
						<%
							}
						}else{
						%>
							<tr>
								<td colspan="10">데이터가 없습니다.</td>
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
