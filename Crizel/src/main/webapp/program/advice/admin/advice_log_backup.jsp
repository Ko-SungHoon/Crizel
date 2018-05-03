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
		<title>RFC관리자 > 상담로그</title>
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
SimpleDateFormat dfhm1        = new SimpleDateFormat("yyyyMMdd");
Calendar cal = Calendar.getInstance();
cal.add(Calendar.MONTH, -1);
String prevday = dfhm1.format(cal.getTime());

SimpleDateFormat dfhm        = new SimpleDateFormat("yyyyMMdd");
cal = Calendar.getInstance();
String today = dfhm.format(cal.getTime());

response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
List<Map<String, Object>> dataList = null;


String board_id       = parseNull(request.getParameter("board_id"));
String board_title    = parseNull(request.getParameter("board_title"));
String board_content  = parseNull(request.getParameter("board_content"));
String category       = parseNull(request.getParameter("category"));
String grade          = parseNull(request.getParameter("grade"));
String advice_sts     = parseNull(request.getParameter("advice_sts"));
String reg_dt         = parseNull(request.getParameter("reg_dt"));
String reg_id         = parseNull(request.getParameter("reg_id"));
String mod_dt         = parseNull(request.getParameter("mod_dt"));
String mod_id         = parseNull(request.getParameter("mod_id"));
String ref_id         = parseNull(request.getParameter("ref_id"));
String board_lvl      = parseNull(request.getParameter("board_lvl"));
String board_dept     = parseNull(request.getParameter("board_dept"));
String attach_seq     = parseNull(request.getParameter("attach_seq"));
String notice_yn      = parseNull(request.getParameter("notice_yn"));
String teacher_id     = parseNull(request.getParameter("teacher_id"));
String complete_dt    = parseNull(request.getParameter("complete_dt"));
String teacher_nm     = parseNull(request.getParameter("teacher_nm"));
String reg_nm         = parseNull(request.getParameter("reg_nm"));
String reply_id       = parseNull(request.getParameter("reply_id"));


String search_st_dt = parseNull(request.getParameter("search_st_dt"),prevday);	//검색시작일자
String search_ed_dt = parseNull(request.getParameter("search_ed_dt"),today);		//검색종료일자
String search_category_gb = parseNull(request.getParameter("search_category_gb"));	//분류 A01 = 진로 , A02 = 진학
String search_target_gb = parseNull(request.getParameter("search_target_gb"));		//대상 B01 = 초등 , B02 = 중등
String search_advice_sts = parseNull(request.getParameter("search_advice_sts"));	//대상 A = 상담대기중 , B = 상담완료 C=상담취소
String search_gb = parseNull(request.getParameter("search_gb")); //검색구분
String search_keyword = parseNull(request.getParameter("search_keyword")); //검색어

int num = 0;

SessionManager sessionManager = new SessionManager(request);

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
	sql.append("SELECT COUNT(*) CNT FROM ADVICE_BOARD WHERE 1=1 ");
	sql.append(" 		AND BOARD_LVL = 0                         \n");
	sql.append(" 		AND BOARD_DEPT = 0                         \n");
	sql.append(" 		AND ADVICE_STS <> 'C'                         \n");

	if(!"".equals(parseNull(search_st_dt)) && !"".equals(parseNull(search_ed_dt))){	//검색일자
		sql.append("AND REG_DT >= ? ");
		sql.append("AND REG_DT <= ? ");
		paging.setParams("search_st_dt", search_st_dt);
		paging.setParams("search_ed_dt", search_ed_dt);
	}

	if(!"".equals(parseNull(search_category_gb))){	//분류
		sql.append("AND CATEGORY = ? ");
		paging.setParams("search_category_gb", search_category_gb);
	}

	if(!"".equals(parseNull(search_target_gb))){	//대상
		sql.append("AND GRADE = ? ");
		paging.setParams("search_target_gb", search_target_gb);

	}

	if(!"".equals(parseNull(search_advice_sts))){	//상담상태
		sql.append("AND ADVICE_STS = ? ");
		paging.setParams("search_advice_sts", search_advice_sts);

	}

	if(!"".equals(parseNull(search_keyword))){
		if("A".equals(search_gb)){	//상담교사이름
			sql.append("AND TEACHER_NM LIKE '%'||?||'%' ");
		}else if("B".equals(search_gb)){	//상담교사아이디
			sql.append("AND TEACHER_ID LIKE '%'||?||'%' ");
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

	if(!"".equals(parseNull(search_target_gb))){
		++cnt;
		pstmt.setString(cnt, search_target_gb);
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
	sql.append("	SELECT ROWNUM AS RNUM, A.* FROM ( \n");

	sql.append(" 		SELECT                                      \n");
	sql.append("					  A.BOARD_ID                                  ");
	sql.append("					, A.BOARD_TITLE                               ");
	sql.append("					, A.BOARD_CONTENT                             ");
	sql.append("					, CASE WHEN A.CATEGORY = 'A01' THEN '진로'      ");
	sql.append("					       WHEN A.CATEGORY = 'A02' THEN '진학'        ");
	sql.append("					  END CATEGORY                              ");
	sql.append("					, CASE WHEN A.GRADE = 'B01' THEN '초등'         ");
	sql.append("						   WHEN A.GRADE = 'B02' THEN '중등'         ");
	sql.append("					  END GRADE                                 ");
	sql.append("					,  CASE WHEN A.ADVICE_STS = 'A' THEN '상담대기중'  ");
	sql.append("					   		WHEN A.ADVICE_STS = 'B' THEN '상담완료'   ");
	sql.append("					   		WHEN A.ADVICE_STS = 'C' THEN '상담취소'   ");
	sql.append("				  	  END ADVICE_STS                            ");
	//sql.append("					, NVL2(A.REG_DT,SUBSTR(A.REG_DT,1,4)||'-'||SUBSTR(A.REG_DT,5,2)||'-'||SUBSTR(A.REG_DT,7,2),'') AS REG_DT ");
	sql.append("					, TO_CHAR(TO_DATE(REG_DT||REG_HMS,'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS') AS REG_DT ");
	sql.append("					, A.REG_ID                                    ");
	sql.append("					, A.MOD_DT                                    ");
	sql.append("					, A.MOD_ID                                    ");
	sql.append("					, A.REF_ID                                    ");
	sql.append("					, A.BOARD_LVL                                 ");
	sql.append("					, A.BOARD_DEPT                                ");
	sql.append("					, A.ATTACH_SEQ                                ");
	sql.append("					, A.NOTICE_YN                                 ");
	sql.append("					, A.TEACHER_ID                                ");
	sql.append("					, NVL2(A.COMPLETE_DT,SUBSTR(A.COMPLETE_DT,1,4)||'-'||SUBSTR(A.COMPLETE_DT,5,2)||'-'||SUBSTR(A.COMPLETE_DT,7,2),'') AS COMPLETE_DT ");
	sql.append("					, A.TEACHER_NM                                ");
	sql.append("					, A.REG_NM                                ");
	sql.append("					, (SELECT MAX(C.BOARD_ID) FROM ADVICE_BOARD C WHERE C.REF_ID = A.BOARD_ID AND C.BOARD_LVL = 1 AND C.BOARD_DEPT = 1) AS REPLY_ID  ");
	sql.append(" 		FROM ADVICE_BOARD A  WHERE A.NOTICE_YN = 'N'                         \n");
	sql.append(" 		AND A.BOARD_LVL = 0                         \n");
	sql.append(" 		AND A.BOARD_DEPT = 0                         \n");
	sql.append(" 		AND A.ADVICE_STS <> 'C'                         \n");

	if(!"".equals(parseNull(search_st_dt)) && !"".equals(parseNull(search_ed_dt))){	//검색일자
		sql.append("AND A.REG_DT >= ? ");
		sql.append("AND A.REG_DT <= ? ");
		paging.setParams("search_st_dt", search_st_dt);
		paging.setParams("search_ed_dt", search_ed_dt);
	}

	if(!"".equals(parseNull(search_category_gb))){	//분류
		sql.append("AND A.CATEGORY = ? ");
		paging.setParams("search_category_gb", search_category_gb);
	}

	if(!"".equals(parseNull(search_target_gb))){	//대상
		sql.append("AND A.GRADE = ? ");
		paging.setParams("search_target_gb", search_target_gb);

	}

	if(!"".equals(parseNull(search_advice_sts))){	//상담상태
		sql.append("AND A.ADVICE_STS = ? ");
		paging.setParams("search_advice_sts", search_advice_sts);

	}

	if(!"".equals(parseNull(search_keyword))){
		if("A".equals(search_gb)){	//상담교사이름
			sql.append("AND A.TEACHER_NM LIKE '%'||?||'%' ");
		}else if("B".equals(search_gb)){	//상담교사아이디
			sql.append("AND A.TEACHER_ID LIKE '%'||?||'%' ");
			paging.setParams("search_keyword", search_keyword);
		}else if("C".equals(search_gb)){	//학생이름
			sql.append("AND A.REG_NM LIKE '%'||?||'%' ");
			paging.setParams("search_keyword", search_keyword);
		}else if("D".equals(search_gb)){	//학생아이디
			sql.append("AND A.REG_ID LIKE '%'||?||'%' ");
			paging.setParams("search_keyword", search_keyword);
		}
	}

	sql.append("		ORDER BY A.BOARD_ID DESC ");
	sql.append("	) A WHERE ROWNUM < ").append(paging.getEndRowNo()).append(" \n");
	sql.append(") WHERE RNUM >= ").append(paging.getStartRowNo()).append(" \n");
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

	if(!"".equals(parseNull(search_target_gb))){
		++cnt;
		pstmt.setString(cnt, search_target_gb);
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
      <p class="location"><strong>상담로그</strong></p>
      <p class="location" style="float:right; margin-right:20px;">
		<span><a href="/iam/main/index.sko?lang=en_US" target="_top" class="last co_yellow">ENGLISH</a>[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span>님 안녕하세요.
		<a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
  	</p>
  </div>
  
	<div id="content">
		<div class="searchBox">
			<form action="./advice_log.jsp" method="post" id="searchForm">
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
								<option <%if("A01".equals(search_category_gb)){ %>selected="selected"<% } %> value="A01">진로</option>
								<option <%if("A02".equals(search_category_gb)){ %>selected="selected"<% } %> value="A02">진학</option>
							</select>
						</span>
						<span>
							<label for="search_target_gb">대상</label>
							<select name="search_target_gb" id="search_target_gb" for="search_target_gb" >
								<option value="">전체</option>
								<option <%if("B01".equals(search_target_gb)){ %>selected="selected"<% } %> value="B01">초등</option>
								<option <%if("B02".equals(search_target_gb)){ %>selected="selected"<% } %> value="B02">중등</option>
							</select>
						</span>
						<span>
							<label for="search_advice_sts">상담현황</label>
							<select name="search_advice_sts" id="search_advice_sts" for="search_advice_sts" value="<%=search_advice_sts%>">
								<option value="">전체</option>
								<option <%if("A".equals(search_advice_sts)){ %>selected="selected"<% } %> value="A">상담대기중</option>
								<option <%if("B".equals(search_advice_sts)){ %>selected="selected"<% } %> value="B">상담완료</option>
								<option <%if("C".equals(search_advice_sts)){ %>selected="selected"<% } %> value="C">상담취소</option>
							</select>
							<select name="search_gb" id="search_gb" >
								<option <%if("A".equals(search_gb)){ %>selected="selected"<% } %> value="A">상담교사이름</option>
								<option <%if("B".equals(search_gb)){ %>selected="selected"<% } %> value="B">상담교사아이디</option>
								<option <%if("C".equals(search_gb)){ %>selected="selected"<% } %> value="C">학생이름</option>
								<option <%if("D".equals(search_gb)){ %>selected="selected"<% } %> value="D">학생아이디</option>
							</select>
							<input type="text" name="search_keyword" id="search_keyword" value="<%=search_keyword%>">
							<input type="submit" value="검색" class="btn small edge mako">
						</span>
					</div>
				</fieldset>
			</form>
		</div>
		
		<div class="btn_area txt_r magT20">
		<button type="button" class="btn medium edge white" onclick="check_delete();" >선택삭제</button>
			<button type="button" onclick="excel();" class="btn medium edge mako">엑셀다운로드</button>
		</div>

		<div class="listArea">
			<form action="" method="post" id="postForm">
				<fieldset>
					<legend>상담로그 목록 결과</legend>
					<table class="bbs_list">
						<colgroup>
						<col class="wps_5"/>
						<col class="wps_5"/>
						<col class="wps_5" />
						<col class="wps_5"/>
						<col />
						<col />
						<col />
						<col class="wps_10"/>
						<col class="wps_10"/>
						<col class="wps_10"/>
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><input type="checkbox" id="chkAll" name="chkAll" /></th>
								<th scope="col">번호</th>
								<th scope="col">분류</th>
								<th scope="col">대상</th>
								<th scope="col">상담교사명(아이디)</th>
								<th scope="col">학생명(아이디)</th>
								<th scope="col">상담글 제목</th>
								<th scope="col">상담신청일</th>
								<th scope="col">상담완료일</th>
								<th scope="col">상담현황</th>
							</tr>
						</thead>
						<tbody>
						<%
						if(dataList != null && dataList.size() > 0){
							num = paging.getRowNo();
							for(int i=0; i<dataList.size(); i++){
								Map<String,Object> map = dataList.get(i);
								board_id       = parseNull((String)map.get("BOARD_ID"));       //SEQ
								board_title    = parseNull((String)map.get("BOARD_TITLE"));    //상담제목
								board_content  = parseNull((String)map.get("BOARD_CONTENT"));  //상담내용
								category       = parseNull((String)map.get("CATEGORY"));       //분류(A01:진로, A02:진학)
								grade          = parseNull((String)map.get("GRADE"));          //학년(B01:초등, B02:중등)
								advice_sts     = parseNull((String)map.get("ADVICE_STS"));     //상태(A:상담완료, B:상담대기중)
								reg_dt         = parseNull((String)map.get("REG_DT"));         //등록일자
								reg_id         = parseNull((String)map.get("REG_ID"));         //등록자아이디
								mod_dt         = parseNull((String)map.get("MOD_DT"));         //수정일자
								mod_id         = parseNull((String)map.get("MOD_ID"));         //수정자아이디
								ref_id         = parseNull((String)map.get("REF_ID"));         //부모아이디
								board_lvl      = parseNull((String)map.get("BOARD_LVL"));      //레벨
								board_dept     = parseNull((String)map.get("BOARD_DEPT"));     //답글깊이
								attach_seq     = parseNull((String)map.get("ATTACH_SEQ"));     //첨부SEQ
								notice_yn      = parseNull((String)map.get("NOTICE_YN"));      //공지여부
								teacher_id     = parseNull((String)map.get("TEACHER_ID"));     //상담선생님ID
								complete_dt    = parseNull((String)map.get("COMPLETE_DT"));    //상담완료일시
								teacher_nm     = parseNull((String)map.get("TEACHER_NM"));     //상담선생님이름
								reg_nm     	   = parseNull((String)map.get("REG_NM"));         //등록자이름
								reply_id       = parseNull((String)map.get("REPLY_ID"));       //답변글 board_id

						%>
							<tr>
								<td><input type="checkbox" id="chk" name="chk" value="<%=board_id %>" /></td>
								<td><%=num-- %></td>
								<td><%=category %></td>
								<td><%=grade %></td>
								<td><%=teacher_nm %>(<%=teacher_id %>)</td>
								<td><%=reg_nm %>(<%=reg_id %>)</td>
								<td>
									<a href="/index.gne?menuCd=DOM_000001001004002003&board_id=<%=board_id %>" target="_blank">
										<%=board_title %>
									</a>
								</td>
								<td><%=reg_dt %></td>
								<td><%=complete_dt %></td>
								<td>
									<%=advice_sts %>
								</td>
							</tr>
						<%
							}
						}else{
						%>
							<tr>
								<td colspan="8">데이터가 없습니다.</td>
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
