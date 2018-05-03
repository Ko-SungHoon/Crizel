<%
/**
*	관리자 페이지 상담 글 로그
*/

%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 이전 상담로그</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
		<link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css"/>
		<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">


<script>
$(function() {
    $("#search_st_dt").datepicker({
		showButtonPanel: true,
		buttonImageOnly: true,
		currentText: '오늘 날짜',
		closeText: '닫기',
		dateFormat: "yymmdd",
		monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        dayNamesMin: ['일','월','화','수','목','금','토'],
		changeMonth: true, //월변경가능
        changeYear: true, //년변경가능
		showMonthAfterYear: true, //년 뒤에 월 표시
		showOn: "both",
		buttonImage: '${pageContext.request.contextPath}/jquery/icon_calendar.gif',
	    buttonImageOnly: true
     });

    $("#search_ed_dt").datepicker({
		showButtonPanel: true,
		buttonImageOnly: true,
		currentText: '오늘 날짜',
		closeText: '닫기',
		dateFormat: "yymmdd",
		monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        dayNamesMin: ['일','월','화','수','목','금','토'],
		changeMonth: true, //월변경가능
        changeYear: true, //년변경가능
		showMonthAfterYear: true, //년 뒤에 월 표시
		showOn: "both",
		buttonImage: '${pageContext.request.contextPath}/jquery/icon_calendar.gif',
	    buttonImageOnly: true
     });


    $('img.ui-datepicker-trigger').css({'cursor':'pointer', 'margin-left':'-22px', 'margin-top':'1px'});
});

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

	if(confirm("상담글을 삭제하면 답변도 삭제됩니다.\n 삭제하시겠습니까?")){
		 var chked_val = "";
		 $(":checkbox[name='chk']:checked").each(function(pi,po){
		   chked_val += ","+po.value;
		 });
		 if(chked_val!="")chked_val = chked_val.substring(1);

		 $("#chk_obj").val(chked_val);
		 //alert("선택값 : = "+chked_val);

		 $("#searchForm").attr("action","./teacher_register.jsp");
	     $("#searchForm").submit();
	}
}
</script>
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

SimpleDateFormat dfhm1        = new SimpleDateFormat("yyyyMMdd");
Calendar cal = Calendar.getInstance();
cal.add(Calendar.MONTH, -1);
String prevday = dfhm1.format(cal.getTime());

SimpleDateFormat dfhm        = new SimpleDateFormat("yyyyMMdd");
cal = Calendar.getInstance();
String today = dfhm.format(cal.getTime());

response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

//Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
List<Map<String, Object>> dataList = null;

String idx					= parseNull(request.getParameter("idx"));
String bidx					= parseNull(request.getParameter("bidx"));
String counselor 			= parseNull(request.getParameter("counselor"));
String signdate				= parseNull(request.getParameter("signdate"));
String type					= parseNull(request.getParameter("type"));
String process				= parseNull(request.getParameter("process"));
String counseldate			= parseNull(request.getParameter("counseldate"));
String counselorname		= parseNull(request.getParameter("counselorname"));


/* String search_st_dt = parseNull(request.getParameter("search_st_dt"),prevday);	//검색시작일자
String search_ed_dt = parseNull(request.getParameter("search_ed_dt"),today);		//검색종료일자 */
String search_st_dt = parseNull(request.getParameter("search_st_dt"));	//검색시작일자
String search_ed_dt = parseNull(request.getParameter("search_ed_dt"));		//검색종료일자
String search_category_gb = parseNull(request.getParameter("search_category_gb"));	//분류 A01 = 진로 , A02 = 진학
String search_target_gb = parseNull(request.getParameter("search_target_gb"));		//대상 B01 = 초등 , B02 = 중등
String search_advice_sts = parseNull(request.getParameter("search_advice_sts"));	//대상 A = 상담대기중 , B = 상담완료 C=상담취소
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
	sql.append("SELECT COUNT(*) CNT FROM ADVICE_BOARD_LOG_TEST WHERE 1=1 ");

	if(!"".equals(parseNull(search_st_dt)) && !"".equals(parseNull(search_ed_dt))){	//검색일자
		sql.append("AND COUNSELDATE >= ? ");
		sql.append("AND COUNSELDATE <= ? ");
		paging.setParams("search_st_dt", search_st_dt);
		paging.setParams("search_ed_dt", search_ed_dt);
	}

	if(!"".equals(parseNull(search_category_gb))){	//분류
		sql.append("AND TYPE = ? ");
		paging.setParams("search_category_gb", search_category_gb);
	}


	if(!"".equals(parseNull(search_advice_sts))){	//상담상태
		sql.append("AND PROCESS = ? ");
		paging.setParams("search_advice_sts", search_advice_sts);

	}

	if(!"".equals(parseNull(search_keyword))){
		if("A".equals(search_gb)){	//상담교사이름
			sql.append("AND COUNSELORNAME LIKE '%'||?||'%' ");
		}else if("B".equals(search_gb)){	//상담교사아이디
			sql.append("AND COUNSELOR LIKE '%'||?||'%' ");
			paging.setParams("search_keyword", search_keyword);
		}else if("C".equals(search_gb)){	//학생이름
			sql.append("AND REG_NM LIKE '%'||?||'%' ");
			paging.setParams("search_keyword", search_keyword);
		}else if("D".equals(search_gb)){	//학생아이디
			sql.append("AND REG_ID LIKE '%'||?||'%' ");
			paging.setParams("search_keyword", search_keyword);
		}
	}


	pstmt = conn.prepareStatement(sql.toString());


	if(!"".equals(parseNull(search_st_dt)) && !"".equals(parseNull(search_ed_dt))){	//검색일자
		++cnt;
		pstmt.setString(cnt, search_st_dt);

		++cnt;
		pstmt.setString(cnt, search_ed_dt);
	}

	if(!"".equals(parseNull(search_category_gb))){
		++cnt;
		pstmt.setString(cnt, search_category_gb);
	}

	if(!"".equals(parseNull(search_advice_sts))){
		++cnt;
		pstmt.setString(cnt, search_advice_sts);
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


	//상담교사 리스트
	cnt = 0;
	sql = new StringBuffer();
	sql.append("SELECT * FROM ( \n");
	sql.append("	SELECT ROWNUM AS RNUM, A.* FROM (														\n");
	sql.append(" 		SELECT IDX, BIDX, TO_CHAR(SIGNDATE, 'yyyy-MM-dd') SIGNDATE, COUNSELOR				\n");
	sql.append(" 		, TYPE, PROCESS, TO_CHAR(COUNSELDATE, 'yyyy-MM-dd') COUNSELDATE, COUNSELORNAME		\n");
	sql.append(" 		FROM ADVICE_BOARD_LOG_TEST A  WHERE 1=1												\n");
	if(!"".equals(parseNull(search_st_dt)) && !"".equals(parseNull(search_ed_dt))){	//검색일자
		sql.append("AND A.COUNSELDATE >= ? ");
		sql.append("AND A.COUNSELDATE <= ? ");
		paging.setParams("search_st_dt", search_st_dt);
		paging.setParams("search_ed_dt", search_ed_dt);
	}

	if(!"".equals(parseNull(search_category_gb))){	//분류
		sql.append("AND A.TYPE = ? ");
		paging.setParams("search_category_gb", search_category_gb);
	}

	if(!"".equals(parseNull(search_advice_sts))){	//상담상태
		sql.append("AND A.PROCESS = ? ");
		paging.setParams("search_advice_sts", search_advice_sts);

	}

	if(!"".equals(parseNull(search_keyword))){
		if("A".equals(search_gb)){	//상담교사이름
			sql.append("AND A.COUNSELORNAME LIKE '%'||?||'%' ");
		}else if("B".equals(search_gb)){	//상담교사아이디
			sql.append("AND A.COUNSELOR LIKE '%'||?||'%' ");
			paging.setParams("search_keyword", search_keyword);
		}else if("C".equals(search_gb)){	//학생이름
			sql.append("AND A.REG_NM LIKE '%'||?||'%' ");
			paging.setParams("search_keyword", search_keyword);
		}else if("D".equals(search_gb)){	//학생아이디
			sql.append("AND A.REG_ID LIKE '%'||?||'%' ");
			paging.setParams("search_keyword", search_keyword);
		}
	}

	sql.append("		ORDER BY A.IDX DESC ");
	sql.append("	) A WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" \n");
	sql.append(") WHERE RNUM > ").append(paging.getStartRowNo()).append(" \n");
	pstmt = conn.prepareStatement(sql.toString());

	if(!"".equals(parseNull(search_st_dt)) && !"".equals(parseNull(search_ed_dt))){	//검색일자
		++cnt;
		pstmt.setString(cnt, search_st_dt);

		++cnt;
		pstmt.setString(cnt, search_ed_dt);
	}

	if(!"".equals(parseNull(search_category_gb))){
		++cnt;
		pstmt.setString(cnt, search_category_gb);
	}

	if(!"".equals(parseNull(search_advice_sts))){
		++cnt;
		pstmt.setString(cnt, search_advice_sts);
	}

	if(!"".equals(parseNull(search_keyword))){
		++cnt;
		pstmt.setString(cnt, search_keyword);
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
//상담 로그 엑셀다운로드
function excel(){
	location.href="excel2.jsp";
}
</script>
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>이전 상담로그</strong></p>
  </div>
	<div id="content">
		<div class="searchBox">
			<form action="./log.jsp" method="post" id="searchForm">
				<input type="hidden" name="pageNo" id="pageNo" value="<%=pageNo%>">
				<input type="hidden" name="chk_obj" id="chk_obj" value="">	<!-- 삭제할 데이터의 키값 파싱 -->
				<input type="hidden" name="command" id="command" value="board_delete">	<!-- 커맨드 -->
				<fieldset>
					<legend>검색하기</legend>
					<div class="boxinner">
						<span>
							<label for="search_st_dt">기간</label>
							<input type="text" id="search_st_dt" name="search_st_dt" value="<%=search_st_dt %>" /> ~
							<input type="text" id="search_ed_dt" name="search_ed_dt" value="<%=search_ed_dt %>" />
						</span>
						<span>
							<label for="search_category_gb">분류</label>
							<select name="search_category_gb" id="search_category_gb" for="search_category_gb" >
								<option value="">전체</option>
								<option <%if("L".equals(search_category_gb)){ %>selected="selected"<% } %> value="L">진로</option>
								<option <%if("H".equals(search_category_gb)){ %>selected="selected"<% } %> value="H">진학</option>
							</select>
						</span>
						<span>
							<label for="search_advice_sts">상담현황</label>
							<select name="search_advice_sts" id="search_advice_sts" for="search_advice_sts" value="<%=search_advice_sts%>">
								<option value="">전체</option>
								<option <%if("I".equals(search_advice_sts)){ %>selected="selected"<% } %> value="I">상담대기중</option>
								<option <%if("E".equals(search_advice_sts)){ %>selected="selected"<% } %> value="E">상담완료</option>
								<option <%if("C".equals(search_advice_sts)){ %>selected="selected"<% } %> value="C">상담취소</option>
							</select>
							<select name="search_gb" id="search_gb" >
								<option <%if("A".equals(search_gb)){ %>selected="selected"<% } %> value="A">상담교사이름</option>
								<option <%if("B".equals(search_gb)){ %>selected="selected"<% } %> value="B">상담교사아이디</option>
							</select>
							<input type="text" name="search_keyword" id="search_keyword" value="<%=search_keyword%>">
							<input type="submit" value="검색" class="btn small edge mako">
						</span>
					</div>
				</fieldset>
			</form>
		</div>
		
		<div class="btn_area txt_r magT20">
		<!-- <button type="button" class="btn medium edge white" onclick="check_delete();" >선택삭제</button>
		<button type="button" onclick="excel();" class="btn medium edge mako">엑셀다운로드</button> -->
		</div>

		<div class="listArea">
			<form method="post" id="postForm">
				<fieldset>
					<legend>상담로그 목록 결과</legend>
					<table class="bbs_list">
						<colgroup>
						<col class="wps_5"/>
						<col class="wps_5"/>
						<col />
						<col class="wps_10"/>
						<col class="wps_10"/>
						<col class="wps_10"/>
						</colgroup>
						<thead>
							<tr>
								<th scope="col">번호</th>
								<th scope="col">분류</th>
								<th scope="col">이름(아이디)</th>
								<th scope="col">상담신청일</th>
								<th scope="col">상담일</th>
								<th scope="col">상태</th>
							</tr>
						</thead>
						<tbody>
						<%
						if(dataList != null && dataList.size() > 0){
							num = paging.getRowNo();
							for(int i=0; i<dataList.size(); i++){
								Map<String,Object> map = dataList.get(i);
								idx						= parseNull((String)map.get("IDX"));
								bidx					= parseNull((String)map.get("BIDX"));
								counselor 				= parseNull((String)map.get("COUNSELOR"));
								signdate				= parseNull((String)map.get("SIGNDATE"));
								type					= parseNull((String)map.get("TYPE"));
								process					= parseNull((String)map.get("PROCESS"));
								counseldate				= parseNull((String)map.get("COUNSELDATE"));
								counselorname			= parseNull((String)map.get("COUNSELORNAME"));
								
								if("L".equals(type)){
									type = "진로";
								}else if("H".equals(type)){
									type = "진학";
								}
								
								if("I".equals(process)){
									process = "상담대기";
								}else if("E".equals(process)){
									process = "상담완료";
								}else if("C".equals(process)){
									process = "상담취소";
								}

						%>
							<tr>
								<td><%=num-- %></td>
								<td><%=type %></td>
								<td><%=counselorname %>(<%=counselor %>)</td>
								<td><%=signdate %></td>
								<td><%=counseldate %></td>
								<td><%=process %></td>
							</tr>
						<%
							}
						}else{
						%>
							<tr>
								<td colspan="6">데이터가 없습니다.</td>
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
