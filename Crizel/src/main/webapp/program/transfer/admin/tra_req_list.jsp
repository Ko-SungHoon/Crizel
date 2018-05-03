<%
/**
*	PURPOSE	:	전입학 / 전입학 배정원서 목록
*	CREATE	:	20180116_thur	JI
*	MODIFY	:	20180122_mon	JMG
*	MODIFY	:	20180412_thur	JI		엑셀다운로드 기능 추가
*/

%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>

<%!
	//typeSearchDetail	정리
	//신규코드가 들어가야할 일이 있을 경우 여기다가 추가하면 됨!
	public static void searchTypeDetailMap(Map<String, String> map){
		map.put("APPLY", "민원인 결재 대기");
		map.put("PAID", "재적학교 접수 대기중");
		map.put("SCH_RECEIPT", "재적학교 접수 후 처리중");
		map.put("SCH_APPROVAL", "접수대기");
		map.put("TR_F_RECEIPT", "처리중");
		map.put("TR_F_APPROVAL", "최종 승인자 승인 대기중");
		map.put("TR_L_APPROVAL", "최종 처리 완료");
		map.put("MW_CANCEL", "민원인에 의한 취소");
		map.put("SYS_CANCEL", "시스템에 의한 자동 취소");
		map.put("SCH_CANCEL", "재적 학교 담당자에 의한 자동 취소");
		map.put("TR_CANCEL", "도교육청 담당자에 의한 취소");
	}

	public static void searchTypeMap(Map<String, String> map){
		map.put("'APPLY','PAID','SCH_RECEIPT'","미리보기");
		map.put("'SCH_APPROVAL'", "접수대기");
		map.put("'TR_F_RECEIPT'", "처리중");
		map.put("'TR_F_APPROVAL','TR_L_APPROVAL'", "승인완료");
		map.put("'MW_CANCEL','SYS_CANCEL','SCH_CANCEL','TR_CANCEL'", "취소");
	}
%>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");
SessionManager sessionManager = new SessionManager(request);

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

String pageTitle = "전입학 배정원서 목록";

//페이징
Paging paging 		=	new Paging();
int totalCount 		= 	0;
String pageNo		=	parseNull(request.getParameter("pageNo"), "1");

String sql_str		=	"";
String outHtml  	=   "";
String sql_where 	=	"";
int cnt				=	0;

boolean adminChk	=	sessionManager.isRoleAdmin();

/* if(!adminChk){
 */	%>
	<!-- <script>alert('관리자권한이 없습니다. \n다시 로그인해주세요.'); location.href='/iam/main/index.sko';</script> -->
<%/* } */

//파라미터
String categorySearch 		= 	parseNull(request.getParameter("categorySearch"));
String typeSearch			=	parseNull(request.getParameter("typeSearch"));
String typeSearchDetail		=	parseNull(request.getParameter("typeSearchDetail"));
String listSize				=	parseNull(request.getParameter("listSize"));
String stNameParam			=	parseNull(request.getParameter("stName"));
String stGradeParam			=	parseNull(request.getParameter("stGrade"));
String stClassParam			=	parseNull(request.getParameter("stClass"));

String[] typeSearchArr		=	null;
Map<String, String>	typeMap	=	new HashMap<String, String>();
Map<String, String> typeDetailMap	=	new HashMap<String, String>();

//맵에 카테고리를 put한다.
searchTypeMap(typeMap);
searchTypeDetailMap(typeDetailMap);

if(!"".equals(typeSearch)){
	typeSearchArr	=	typeSearch.replace("'", "").split(",");
}

String rNum			=	"";
String kind			=	"";
String kindState	=	"";
String schName		=	"";
String stName		=	"";
String stGrade		=	"";
String stClass		=	"";
String applyDate	=	"";
String applyTime	=	"";
String stateCd		=	"";
String state		=	"";
String transferNo	=	"";
String typeState	=	"";
String receiptYear	=	"";		//접수년도
String receiptNum	=	"";		//접수번호


List<Map<String, Object>> reqList = null;

try {
    sqlMapClient.startTransaction();
    conn    =   sqlMapClient.getCurrentConnection();

    //리스트 카운트
    sql     	=   new StringBuffer();

    if(!"".equals(categorySearch)){
    	sql_where	+=	" AND B.KIND = ?  ";
    	paging.setParams("categorySearch", categorySearch);
    }
    if(typeSearchArr != null && typeSearchArr.length > 0){
    	for(int i=0; i<typeSearchArr.length; i++){
    		if(i==0)	sql_where	+=	" AND ( C.STATECD = ? ";
    		else		sql_where	+=	" OR C.STATECD = ? ";
    		paging.setParams("typeSearch", typeSearch);
    	}
    	sql_where	+=	") ";
    }
    if(!"".equals(typeSearchDetail)){
    	sql_where 	+=	" AND C.STATECD = ? ";
    	paging.setParams("typeSearchDetail", typeSearchDetail);
    }
    if(!"".equals(stNameParam)){
    	sql_where	+=	" AND B.STNAME = ? ";
    	paging.setParams("stName", stName);
    }
    if(!"".equals(stGradeParam)){
    	sql_where	+=	" AND B.STGRADE = ? ";
    	paging.setParams("stGrade", stGrade);
    }
    if(!"".equals(stClassParam)){
    	sql_where	+=	" AND B.STCLASS = ? ";
    	paging.setParams("stClass", stClass);
    }
    if(!"".equals(listSize)){
    	paging.setPageSize(Integer.parseInt(listSize));
    	paging.setParams("listSize", listSize);
    }

    sql_str 	=   " SELECT COUNT(*) AS CNT FROM TTRANSFER B, TTRANS_STATE C WHERE 1=1 		";
    sql_str		+=	" AND B.TRANSFERNO = C.TRANSFERNO AND C.ORDERED = 1 AND B.TEMPFLAG = 'N'	";
    sql_str		+=	sql_where;
    sql.append(sql_str);
    pstmt	=	conn.prepareStatement(sql.toString());

    if(!"".equals(categorySearch)){
    	pstmt.setString(++cnt, categorySearch);
    }
    if(typeSearchArr != null && typeSearchArr.length > 0){
    	for(int i=0; i<typeSearchArr.length; i++){
    		pstmt.setString(++cnt, typeSearchArr[i]);
    	}
    }
    if(!"".equals(typeSearchDetail)){
    	pstmt.setString(++cnt, typeSearchDetail);
    }
    if(!"".equals(stNameParam)){
    	pstmt.setString(++cnt, stNameParam);
    }
    if(!"".equals(stGradeParam)){
    	pstmt.setString(++cnt, stGradeParam);
    }
    if(!"".equals(stClassParam)){
    	pstmt.setString(++cnt, stClassParam);
    }

    rs      =   pstmt.executeQuery();
    if(rs.next())	totalCount = rs.getInt("CNT");

    if (rs != null) try { rs.close(); } catch (SQLException se) {}
    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}

    paging.setPageNo(Integer.parseInt(pageNo));
    paging.setTotalCount(totalCount);

    sql     	=   new StringBuffer();
	cnt			=	0;

    sql_str		=	" SELECT * FROM ( ";
    sql_str		+=	" SELECT ROWNUM AS RNUM, A.* FROM ( ";
    sql_str		+=	" SELECT B.KIND, B.SCHNAME, B.STNAME, B.STGRADE, B.RECEIPTYEAR, B.RECEIPTNUM, ";
    sql_str		+=	" B.STCLASS, B.APPLYDATE, B.APPLYTIME, C.STATECD, B.TRANSFERNO ";
    sql_str		+=	" FROM TTRANSFER B, TTRANS_STATE C WHERE 1=1 AND B.TRANSFERNO = C.TRANSFERNO ";
    sql_str		+=	" AND C.ORDERED = 1 AND B.TEMPFLAG = 'N' ";
    sql_str		+=	sql_where;
    sql_str		+=	" ORDER BY APPLYDATE DESC, APPLYTIME DESC ";
    sql_str		+=	" )A WHERE ROWNUM <= " + paging.getEndRowNo();
    sql_str		+=	" )WHERE RNUM > " + paging.getStartRowNo();
    sql.append(sql_str);
    pstmt		=	conn.prepareStatement(sql.toString());

    if(!"".equals(categorySearch)){
    	pstmt.setString(++cnt, categorySearch);
    }
    if(typeSearchArr != null && typeSearchArr.length > 0){
    	for(int i=0; i<typeSearchArr.length; i++){
    		pstmt.setString(++cnt, typeSearchArr[i]);
    	}
    }
    if(!"".equals(typeSearchDetail)){
    	pstmt.setString(++cnt, typeSearchDetail);
    }
    if(!"".equals(stNameParam)){
    	pstmt.setString(++cnt, stNameParam);
    }
    if(!"".equals(stGradeParam)){
    	pstmt.setString(++cnt, stGradeParam);
    }
    if(!"".equals(stClassParam)){
    	pstmt.setString(++cnt, stClassParam);
    }

    rs			=	pstmt.executeQuery();
    reqList		=	getResultMapRows(rs);

} catch (Exception e) {
    e.printStackTrace();
    alertBack(out, "처리중 오류가 발생하였습니다."+e.getMessage());
} finally {
    if (rs != null) try { rs.close(); } catch (SQLException se) {}
    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
    if (conn != null) try { conn.close(); } catch (SQLException se) {}
    sqlMapClient.endTransaction();
}
%>


<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 전입학 배정원서 목록</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
    	<script type="text/javascript" src="/program/excel/common/js/popup.js"></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
		<link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css" />
		<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />

		<script>
			function searchClear(){
				$("#categorySearch").val("");
				$("#typeSearch").val("");
				$("#typeSearchDetail").val("");
				$("#stName").val("");
				$("#stGrade").val("");
				$("#stClass").val("");
				$("#listSize").val("");
			}
	    	function search(){
	    		document.searchForm.submit();
	    	}
	    	function searchType(){
	    		document.searchForm.typeSearchDetail.value = "";
	    		document.searchForm.submit();
	    	}
	    	function viewRecord(transferNo){
	    		var moveUrl	=	"/program/transfer/admin/tra_req_rec.jsp?transferNo=" + transferNo;
	    		window.open(moveUrl, "이력 보기", "width=800px, height=400px, toolbar=no, menubar=no, scrollbars=no");
	    	}
	    	function viewDetail(transferNo){
	    		document.searchForm.action = "/program/transfer/admin/tra_req_view.jsp?transferNo=" + transferNo;
	    		document.searchForm.submit();
			}
			
			function excelDw () {
				$('#slide').popup({
			 		 focusdelay: 400,
			 		 outline: true,
			 		 vertical: 'middle'
			 	});
			}

			function excelDown () {
				var selYear		=	$("#excelYear option:selected").val();
				var selMonth	=	$("#excelMonth option:selected").val();

				if (nullChk(selYear)) {
					alert("년도를 선택하세요.");
					$("#excelYear").focus();
					return;
				} else if (nullChk(selMonth)) {
					alert("개월을 선택하세요.");
					$("#excelMonth").focus();
					return;
				}
				/* 엑셀 다운로드 page 이동 */
				location.href="tra_req_list_excel.jsp?selYear="+selYear+"&selMonth="+selMonth;
				return;
			}

			/* Null chk function */
			function nullChk (value) {
				if( value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length)) { 
					return true 
				} else {
					return false 
				}
			}

		</script>
	</head>

    <body>
<%--Modal Part--%>
	<div id="slide" style="display:none;">
		<div class="topbar">
			<h3>엑셀다운로드</h3>
		</div>
		<div class="inner">
			<label for="excelYear">년도 선택</label>
			<select id="excelYear" name="excelYear" title="년도를 선택하세요.">
				<option value="">년도 선택</option>
				<option value="2015">2015</option>
				<option value="2016">2016</option>
				<option value="2017">2017</option>
				<option value="2018">2018</option>
				<option value="2019">2019</option>
				<option value="2020">2020</option>
				<option value="2021">2021</option>
			</select>
			<label for="excelMonth">개월 선택</label>
			<select id="excelMonth" name="excelMonth" title="개월를 선택하세요.">
				<option value="">개월 선택</option>
				<option value="01">01</option>
				<option value="02">02</option>
				<option value="03">03</option>
				<option value="04">04</option>
				<option value="05">05</option>
				<option value="06">06</option>
				<option value="07">07</option>
				<option value="08">08</option>
				<option value="09">09</option>
				<option value="10">10</option>
				<option value="11">11</option>
				<option value="12">12</option>
			</select>
			<input type="button" class="btn edge green medium" value="엑셀 다운로드" onclick="excelDown()" />
		</div>
		<a href="javascript:;" class="btn_cancel popup_close slide_close" id="modalClose" title="창닫기"><img src="/img/art/layer_close.png" alt="창닫기"></a>
	</div>
<%--END Modal Part--%>
		<div id="right_view">
			<div class="top_view">
				<p class="location"><strong>전입학 배정원서 목록</strong></p>
        <p class="loc_admin fb">
            <a href="/iam/main/index.sko?lang=en_US" target="_top" class="white">ENGLISH</a> <span class="yellow">[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span> 님 안녕하세요.
            <a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
        </p>
			</div>
            <div id="content">
                <div class="searchBox">
                    <form id="searchForm" name="searchForm" method="post" class="topbox1 clearfix">
                    	<input type="hidden" name="pageNo" value="<%=pageNo%>">
											<div class="boxinner">
												<span>
													<label for="categorySearch">종류별 검색</label>
			                    <select id="categorySearch" name="categorySearch" title="신청 종류를 선택해주세요." onchange="javascript:search();">
			                    	<option value="">- 전체 -</option>
			                    	<option value="ONLINE" <%if("ONLINE".equals(categorySearch)){%>selected=selected<%}%>>온라인 신청</option>
			                    	<option value="OFFLINE_FAX" <%if("OFFLINE_FAX".equals(categorySearch)){%>selected=selected<%}%>>팩스 신청</option>
			                    	<option value="OFFLINE_VISIT" <%if("OFFLINE_VISIT".equals(categorySearch)){%>selected=selected<%}%>>방문 신청</option>
			                    </select>
												</span>
												&nbsp;&nbsp;&nbsp;
												<span>
													<label for="typeSearch">상태별 검색</label>
			                    <select id="typeSearch" name="typeSearch" title="상태 그룹을 선택해주세요." onchange="javascript:searchType();">
			                    	<option value="">- 전체 -</option>
			                    	<%for(Map.Entry<String, String> entry : typeMap.entrySet()){%>
			                    		<option value="<%=entry.getKey()%>"
			                    		<%if(typeSearch.equals(entry.getKey())){%>selected=selected<%}%>><%=entry.getValue()%></option>
			                    	<%}%>
			                    </select>
													<label for="typeSearchDetail" class="blind">상태 상세 선택</label>
			                    <select id="typeSearchDetail" name="typeSearchDetail" title="상세 상태를 선택해주세요." onchange="javascript:search();">
			                    	<option value="">- 상태 상세 선택 -</option>
			                    	<%if(!"".equals(typeSearch)){%>
			                    		<%for(int i=0; i<typeSearchArr.length; i++){%>
			                    		<option value="<%=typeSearchArr[i]%>" <%if(typeSearchDetail.equals(typeSearchArr[i])){%>selected=selected<%}%>>
			                    			<%if(typeDetailMap.containsKey(typeSearchArr[i])){%><%=typeDetailMap.get(typeSearchArr[i])%><%} %>
			                    		</option>
			                    		<%}%>
			                    	<%}else{%>
			                    		<%for(Map.Entry<String, String> entry : typeDetailMap.entrySet()){%>
			                    		<option value="<%=entry.getKey()%>"
			                    			<%if(typeSearchDetail.equals(entry.getKey())){%>selected=selected<%}%>><%=entry.getValue()%>
			                    		</option>
			                    		<%}%>
			                    	<%}%>
			                    </select>
												</span>
											</div>

											<div class="boxinner">
												<span>
													<span class="label">조건별 검색</span>&nbsp;&nbsp;
													<label for="stName">학생이름</label>&nbsp;<input type="text" name="stName" id="stName" class="w_150" value="<%=stNameParam%>" />&nbsp;&nbsp;
													<label for="stGrade">학년</label><input type="text" name="stGrade" id="stGrade" class="w_80" value="<%=stGradeParam%>" />&nbsp;&nbsp;
													<label for="stClass">반</label>
			                    <input type="text" name="stClass" id="stClass" class="w_80" value="<%=stClassParam%>" />&nbsp;&nbsp;
													<label for="listSize">줄보기</label>
													<input type="text" name="listSize" id="listSize" class="w_80" value="<%=listSize%>">
												</span>
												<div class="f_r">
													<input type="submit" value="검색" class="btn edge mako medium w_100" />
			                    <input type="button" value="검색 초기화" class="btn edge white medium" onclick="javascript:searchClear();"/>
								<input type="button" value="엑셀 다운로드" class="btn edge green medium initialism slide_open" onclick="excelDw();">
												</div>
											</div>
                    </form>
                </div>
                <div class="listArea">
                    <table class="bbs_list">
                        <colgroup>
	                        <col style="width:8%;">
	                        <col style="width:10%;">
	                        <col style="width:13%;">
	                        <col style="width:10%;">
	                        <col style="width:7%;">
	                        <col style="width:7%;">
	                        <col style="width:10%;">
	                        <col style="width:10%;">
	                        <col style="width:15%;">
	                        <col style="width:10%;">
                        </colgroup>
                        <thead>
	                        <tr>
		                        <th scope="col">번호</th>
		                        <th scope="col">신청종류<br/>(접수번호)</th>
		                        <th scope="col">학교명</th>
		                        <th scope="col">학생이름</th>
		                        <th scope="col">학년</th>
		                        <th scope="col">반</th>
		                        <th scope="col">접수일자</th>
		                        <th scope="col">상태그룹</th>
		                        <th scope="col">상태 상세 설명</th>
		                        <th scope="col">관리</th>
	                        </tr>
                        </thead>
                        <tbody>
                       	<%
		           		if(reqList != null && reqList.size() > 0){
		           			for(int i=0; i<reqList.size(); i++){
		           				Map<String, Object> map	=	reqList.get(i);
		           				rNum		= (String)map.get("RNUM");
		           				kind		= (String)map.get("KIND");
		           				schName		= (String)map.get("SCHNAME");
		           				stName		= (String)map.get("STNAME");
		           				stGrade		= (String)map.get("STGRADE");
		           				stClass		= (String)map.get("STCLASS");
		           				applyDate	= (String)map.get("APPLYDATE");
		           				stateCd		= (String)map.get("STATECD");
		           				transferNo	= (String)map.get("TRANSFERNO");
		           				receiptYear	= (String)map.get("RECEIPTYEAR");
		           				receiptNum	= (String)map.get("RECEIPTNUM");

		           				int lengthCnt	=	receiptNum.length();
		           				if(lengthCnt < 4){
		           					for(int j=0; j<(4-lengthCnt); j++){
		           						receiptNum = "0" + receiptNum;
		           					}
		           				}
		           				if("ONLINE".equals(kind)){
		           					kindState	=	"온라인신청";
	           					}else if("OFFLINE_FAX".equals(kind)){
	           						kindState	=	"팩스신청";
	           					}else if("OFFLINE_VISIT".equals(kind)){
	           						kindState	=	"방문신청";
	           					}else{
	           						kindState	=	"";
	           					}


		           				//stateCd 값이 typeMap에 키값으로 존재할 경우 state에 value값을 넣는다.
		           				if(typeDetailMap.containsKey(stateCd)){
		           					state	=	(String)typeDetailMap.get(stateCd);
		           				}

		           				for(Map.Entry<String, String> entry : typeMap.entrySet()){
		           					if(entry.getKey().indexOf(stateCd)>-1){
		           						typeState	=	entry.getValue();
		           					}
		           				}
		           				%>
                       			<tr>
			           				<td><%=transferNo%></td>
			           				<td><%=kindState%><br/>(<%=receiptYear + receiptNum%>)</td>
			           				<td><%=schName%></td>
			           				<td><%=stName%></td>
			           				<td><%=stGrade%></td>
			           				<td><%=stClass%></td>
			           				<td><%=applyDate%></td>
			           				<td><%=typeState%></td>
			           				<td><%=state%></td>
			           				<td><input type="button" class="btn edge small darkMblue" value="보기" onclick="javascript:viewDetail('<%=transferNo%>');">&nbsp;
			           				<input type="button" class="btn edge small white" value="이력" onclick="javascript:viewRecord('<%=transferNo%>');"></td>
		           				</tr>
		           				<%
		           			}
		           		} else {
		           			%>
		           			<tr>
		           				<td colspan="10">목록이 존재하지 않습니다. </td>
		           			</tr>
		           			<%
		           		}
		               	%>
                        </tbody>
                    </table>
                    <% if(paging.getTotalCount() > 0) { %>
	               		<div class="page_area"><p style="text-align:center;" id="btn_g"><%=paging.getHtml("1")%></p></div>
	                <% } %>
                </div>
            </div>
        </div>
    </body>
</html>
