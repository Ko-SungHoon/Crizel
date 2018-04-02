<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>RFC관리자 > 통계관리 - 사립</title>
<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
<script type='text/javascript' src='/js/jquery.js'></script>
<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />

</head>
<body>
		
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
List<Map<String, Object>> dataList = null;
List<Map<String, Object>> yearList = null;
List<Map<String, Object>> totalList = null;

String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
Paging paging = new Paging();

SessionManager sessionManager = new SessionManager(request);

String user_account 		= "";
String school_id 			= parseNull(request.getParameter("school_id"));
String school_area 			= parseNull(request.getParameter("school_area"));
String school_name 			= parseNull(request.getParameter("school_name"));
String use_cnt 				= parseNull(request.getParameter("use_cnt"));
String total_price 			= parseNull(request.getParameter("total_price"));
String year 				= "";
String month 				= "";
String total_total_price 	= parseNull(request.getParameter("total_total_price"));
int total_cnt_1 = 0;
int total_cnt_2 = 0;
int total_cnt_3 = 0;
int total_cnt_4 = 0;

int total_sum = 0;


DecimalFormat df = new DecimalFormat("#,###");

String search1 = parseNull(request.getParameter("search1"));
String search2 = parseNull(request.getParameter("search2"));
String search3 = parseNull(request.getParameter("search3"));
String keyword = parseNull(request.getParameter("keyword"));


if(!"".equals(search1)){
	keyword = search1;
}
if(!"".equals(search2)){
	keyword = search1 + "-" + search2;
}

String areaArr[] = {"창원시","김해시","진주시","양산시", "거제시" ,"통영시","사천시","밀양시","함안군","거창군","창녕군","고성군"
		,"하동군","합천군","남해군","함양군","산청군","의령군"};

int num = 0;
int key = 0;


try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	//통계 총합
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT SUM(TOTAL_PRICE) TOTAL_PRICE   ");
	sql.append("FROM RESERVE_USER WHERE APPROVAL_DATE IS NOT NULL AND RESERVE_APPROVAL = 'C'  ");
	sql.append("AND SCHOOL_ID IN ((SELECT SCHOOL_ID FROM RESERVE_SCHOOL WHERE SCHOOL_TYPE = 'PRIVATE')) ");
	
	if(!"".equals(keyword)){
		sql.append("AND TO_CHAR(APPROVAL_DATE, 'yyyy-MM-dd') LIKE '%'||?||'%' ");
		paging.setParams("keyword", keyword);
	}

	pstmt = conn.prepareStatement(sql.toString());
	
	if(!"".equals(keyword)){
		pstmt.setString(++key, keyword);
	}
	rs = pstmt.executeQuery();	
	if(rs.next()){
		total_total_price = rs.getString("TOTAL_PRICE");
	}
	pstmt.close();
	
	//통계 총합 리스트
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT RU.RESERVE_TYPE, COUNT(RU.RESERVE_TYPE) TOTAL_CNT   ");
	sql.append("FROM RESERVE_USER RU LEFT JOIN RESERVE_SCHOOL RS ON RU.SCHOOL_ID=RS.SCHOOL_ID   ");
	sql.append("WHERE RU.APPROVAL_DATE IS NOT NULL AND RU.RESERVE_APPROVAL = 'C'    ");
	sql.append("AND RS.SCHOOL_TYPE = 'PRIVATE' ");
	
	if(!"".equals(keyword)){
		sql.append("AND TO_CHAR(RU.APPROVAL_DATE, 'yyyy-MM-dd') LIKE '%'||?||'%' ");
		paging.setParams("keyword", keyword);
	}
	
	if(!"".equals(search3)){
		sql.append("AND SCHOOL_AREA = ? ");
		paging.setParams("search3", search3);
	}
	
	sql.append("GROUP BY RU.RESERVE_TYPE     ");
	sql.append("ORDER BY RU.RESERVE_TYPE  ");
	
	pstmt = conn.prepareStatement(sql.toString());
	
	if(!"".equals(keyword)){
		pstmt.setString(++key, keyword);
	}
	if(!"".equals(search3)){
		pstmt.setString(++key, search3);
	}
	
	rs = pstmt.executeQuery();	
	while(rs.next()){
		if("강당".equals(rs.getString("RESERVE_TYPE"))){
			total_cnt_1 = rs.getInt("TOTAL_CNT");
		}else if("교실".equals(rs.getString("RESERVE_TYPE"))){
			total_cnt_2 = rs.getInt("TOTAL_CNT");
		}else if("기타시설".equals(rs.getString("RESERVE_TYPE"))){
			total_cnt_3 = rs.getInt("TOTAL_CNT");
		}else if("운동장".equals(rs.getString("RESERVE_TYPE"))){
			total_cnt_4 = rs.getInt("TOTAL_CNT");
		}
		total_sum += rs.getInt("TOTAL_CNT");
	}
	
	//통계목록 갯수
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT COUNT(*) CNT FROM(	  ");
	sql.append("SELECT COUNT(*) CNT  ");
	sql.append("FROM RESERVE_SCHOOL RS LEFT JOIN RESERVE_USER RU ON RS.SCHOOL_ID = RU.SCHOOL_ID WHERE 1=1 AND RU.RESERVE_APPROVAL = 'C'  ");
	sql.append("AND SCHOOL_TYPE = 'PRIVATE' ");
	
	if(!"".equals(keyword)){
		sql.append("AND TO_CHAR(APPROVAL_DATE, 'yyyy-MM-dd') LIKE '%'||?||'%' ");
		paging.setParams("keyword", keyword);
	}
	if(!"".equals(search3)){
		sql.append("AND SCHOOL_AREA = ? ");
		paging.setParams("search3", search3);
	}
	sql.append("GROUP BY RS.SCHOOL_ID, RS.SCHOOL_AREA, RS.SCHOOL_NAME ORDER BY RS.SCHOOL_NAME	");
	sql.append(")");
	pstmt = conn.prepareStatement(sql.toString());
	
	if(!"".equals(keyword)){
		pstmt.setString(++key, keyword);
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
	paging.setPageSize(20);
	paging.setPageBlock(10);
	paging.makePaging();
	
	//통계목록
	key = 0;
	sql = new StringBuffer();
	sql = new StringBuffer();
	sql.append("SELECT * FROM ( \n");
	sql.append("	SELECT ROWNUM AS RNUM, A.* FROM ( \n");
	sql.append("SELECT RS.SCHOOL_ID, RS.SCHOOL_AREA, RS.SCHOOL_NAME   ");
	sql.append(",(SELECT COUNT(*) FROM RESERVE_USER WHERE RESERVE_TYPE = '강당' AND SCHOOL_ID = RS.SCHOOL_ID AND RESERVE_APPROVAL = 'C') RESERVE_TYPE1  ");
	sql.append(",(SELECT COUNT(*) FROM RESERVE_USER WHERE RESERVE_TYPE = '교실' AND SCHOOL_ID = RS.SCHOOL_ID AND RESERVE_APPROVAL = 'C') RESERVE_TYPE2  ");
	sql.append(",(SELECT COUNT(*) FROM RESERVE_USER WHERE RESERVE_TYPE = '기타시설' AND SCHOOL_ID = RS.SCHOOL_ID AND RESERVE_APPROVAL = 'C') RESERVE_TYPE3  ");
	sql.append(",(SELECT COUNT(*) FROM RESERVE_USER WHERE RESERVE_TYPE = '운동장' AND SCHOOL_ID = RS.SCHOOL_ID AND RESERVE_APPROVAL = 'C') RESERVE_TYPE4  ");
	sql.append(",(SELECT COUNT(*) FROM RESERVE_USER WHERE SCHOOL_ID = RS.SCHOOL_ID AND RESERVE_APPROVAL = 'C') RESERVE_TYPE5  ");
	sql.append(", SUM(RU.TOTAL_PRICE) TOTAL_PRICE  ");
	
	sql.append("FROM RESERVE_SCHOOL RS LEFT JOIN RESERVE_USER RU ON RS.SCHOOL_ID = RU.SCHOOL_ID WHERE 1=1 AND RU.RESERVE_APPROVAL = 'C'  ");
	sql.append("AND SCHOOL_TYPE = 'PRIVATE' ");
	
	if(!"".equals(keyword)){
		sql.append("AND TO_CHAR(APPROVAL_DATE, 'yyyy-MM-dd') LIKE '%'||?||'%' ");
		paging.setParams("keyword", keyword);
	}
	if(!"".equals(search3)){
		sql.append("AND SCHOOL_AREA = ? ");
		paging.setParams("search3", search3);
	}
	sql.append("GROUP BY RS.SCHOOL_ID, RS.SCHOOL_AREA, RS.SCHOOL_NAME ");
	sql.append("ORDER BY RS.SCHOOL_NAME  ");
	sql.append("	) A WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" \n");
	sql.append(") WHERE RNUM > ").append(paging.getStartRowNo()).append(" \n");
	pstmt = conn.prepareStatement(sql.toString());
	
	if(!"".equals(keyword)){
		pstmt.setString(++key, keyword);
	}
	if(!"".equals(search3)){
		pstmt.setString(++key, search3);
	}
	
	rs = pstmt.executeQuery();	
	dataList = getResultMapRows(rs);
	
	//년도 리스트
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT TO_CHAR(APPROVAL_DATE, 'yyyy') year   ");
	sql.append("FROM RESERVE_USER    ");
	sql.append("WHERE APPROVAL_DATE IS NOT NULL   ");
	sql.append("GROUP BY TO_CHAR(APPROVAL_DATE, 'yyyy') ");
	sql.append("ORDER BY TO_CHAR(APPROVAL_DATE, 'yyyy') ");
	pstmt = conn.prepareStatement(sql.toString());
	rs = pstmt.executeQuery();	
	yearList = getResultMapRows(rs);

	if(!"".equals(total_total_price) && total_total_price !=null){
		total_total_price = df.format(Integer.parseInt(total_total_price));
	}else{
		total_total_price = "0";
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

function searchFormSubmit(){
	if($("#search1").val() == "" && $("#search2").val() != ""){
		alert("연도를 입력하여주시기 바랍니다.");
		return false;
	}
	$("#postForm").attr("action", "");
	$("#postForm").submit();
}

function excelDown(){
	$("#postForm").attr("action", "/program/school_reserve/admin/statExcel.jsp");
	$("#postForm").submit();
}
</script>

<form action="" method="post" id="postForm">
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>통계 관리 - 사립</strong></p>
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
					<select name="search1" id="search1">
						<option value="">연도 선택</option>
					<%
					if(yearList != null){
						for(int i=0; i<yearList.size(); i++){
							Map<String,Object> map = yearList.get(i);
							year = map.get("YEAR").toString();
					%>	
							<option value="<%=year%>" <%if(year.equals(search1)){%> selected="selected" <%}%>><%=year%>년</option>
					<%
						}
					}
					%>
					</select>
					<select name="search2" id="search2">
						<option value="">월 선택</option>
					<%
					for(int i=1; i<=12; i++){
						if(i<10){
							month = "0" + Integer.toString(i);
						}else{
							month = Integer.toString(i);
						}
					%>	
						<option value="<%=month%>" <%if(month.equals(search2)){%> selected="selected" <%}%> ><%=month%>월</option>
					<%
					}
					%>
					</select>
					<input type="hidden" name="search4" id="search4" value="PRIVATE">
					<input type="button" value="검색하기" id="searchSubmit" onclick="searchFormSubmit()" class="btn small edge mako">
					<input type="button" value="엑셀다운로드" id="excel" class="btn small edge mako" onclick="excelDown();">
				</fieldset>
			</form>
		</div>
		
		<div class="listArea">
			<form action="del.jsp" method="post" id="listForm" onsubmit="return del();">
				<fieldset>
					<legend>총합 데이터</legend>
					<table class="bbs_list">
						<colgroup>
						<col width="20%"/>
						<col width="20%"/>
						<col width="20%"/>
						<col width="20%"/>
						<col width="20%"/>
						</colgroup>
						<thead>
							<tr>
								<th scope="col">총 승인 금액</th>
								<td colspan="4"><%=total_total_price %> 원</td>
							</tr>
							<tr>
								<th scope="col">운동장</th>
								<th scope="col">강당</th>
								<th scope="col">교실</th>
								<th scope="col">기타시설</th>
								<th scope="col">시설합계</th>
							
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><%=total_cnt_4%></td>
								<td><%=total_cnt_1%></td>
								<td><%=total_cnt_2%></td>
								<td><%=total_cnt_3%></td>
								<td><%=total_sum%></td>
							</tr>
						</tbody>
					</table>
				</fieldset>
			</form>
		</div>

		<div class="listArea">
			<form action="del.jsp" method="post" id="listForm" onsubmit="return del();">
				<fieldset>
					<legend>통계 관리</legend>
					<table class="bbs_list">
						<colgroup>
						<col width="5%"/>
						<col width="10%"/>
						<col width="10"/>
						<col width="5%"/>
						<col width="5%"/>
						<col width="5%"/>
						<col width="5%"/>
						<col width="5%"/>
						<col width="25%"/>
						</colgroup>
						<thead>
							<tr>
								<th scope="col">번호</th>
								<th scope="col">지역</th>
								<th scope="col">학교명</th>
								<th scope="col">강당</th>
								<th scope="col">교실</th>
								<th scope="col">기타시설</th>
								<th scope="col">운동장</th>
								<th scope="col">시설합계</th>
								<th scope="col">총금액</th>
							</tr>
						</thead>
						<tbody>
						<%
						if(dataList != null && dataList.size()>0){
							num = paging.getRowNo();
							for(int i=0; i<dataList.size(); i++){
								Map<String,Object> map = dataList.get(i);
								school_area = parseNull(map.get("SCHOOL_AREA").toString());
								school_name = parseNull(map.get("SCHOOL_NAME").toString());
								total_price = parseNull(map.get("TOTAL_PRICE").toString());
								
								if(!"".equals(total_price)){
									total_price = df.format(Integer.parseInt(total_price));
								}
						%>
							<tr>
								<td><%=num-- %></td>
								<td><%=school_area %></td>
								<td><%=school_name %></td>
								<td><%=parseNull(map.get("RESERVE_TYPE1").toString()) %></td>
								<td><%=parseNull(map.get("RESERVE_TYPE2").toString()) %></td>
								<td><%=parseNull(map.get("RESERVE_TYPE3").toString()) %></td>
								<td><%=parseNull(map.get("RESERVE_TYPE4").toString()) %></td>
								<td><%=parseNull(map.get("RESERVE_TYPE5").toString()) %></td>
								<td><%=total_price %> 원</td>
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
		<% if(paging.getTotalCount() > 0) { %>
		<div class="page_area">
			<%=paging.getHtml() %>
		</div>
		<% } %>
	</div>
	<!-- // content -->
</div>
</form>
</body>
</html>