<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 학교관리</title>
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

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
List<Map<String, Object>> dataList = null;

String school_id 			= parseNull(request.getParameter("school_id"));
String user_id 				= parseNull(request.getParameter("user_id"));
String school_name 			= parseNull(request.getParameter("school_name"));
String user_name 			= parseNull(request.getParameter("user_name"));
String reserve_time 		= parseNull(request.getParameter("reserve_time"));
String reserve_register 	= parseNull(request.getParameter("reserve_register"));
String reserve_approval 	= parseNull(request.getParameter("reserve_approval"));
String reserve_type 		= parseNull(request.getParameter("reserve_type"));
String school_area 			= parseNull(request.getParameter("school_area"));
String admin_cancel 		= "";
String refund_account 		= "";		//환불대기/완료 상태 만들기 위한 환불계좌, 환불완료날짜 변수 생성(2017.12.07)
String reserve_refund		= "";

String search1 = parseNull(request.getParameter("search1"));
String search2 = parseNull(request.getParameter("search2"));
String search3 = parseNull(request.getParameter("search3"));
String search4 = parseNull(request.getParameter("search4"));
String keyword = parseNull(request.getParameter("keyword"));

int num = 0;
int key = 0;

Paging paging = new Paging();
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;

String areaArr[] = {"창원시","김해시","진주시","양산시", "거제시" ,"통영시","사천시","밀양시","함안군","거창군","창녕군","고성군"
		,"하동군","합천군","남해군","함양군","산청군","의령군"};

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	//학교 카운트
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT COUNT(*) CNT FROM RESERVE_USER RU LEFT JOIN RESERVE_SCHOOL RS ON RU.SCHOOL_ID = RS.SCHOOL_ID WHERE 1=1 ");
	if(!"".equals(search1)){
		sql.append("AND RS.SCHOOL_AREA LIKE '%'||?||'%' ");
		paging.setParams("search1", search1);
	}
	if(!"".equals(search2)){
		sql.append("AND RU.RESERVE_TYPE LIKE '%'||?||'%' ");
		paging.setParams("search2", search2);
	}
	if(!"".equals(search3)){
		if("G".equals(search3)){								
			sql.append(" AND  RU.RESERVE_APPROVAL = 'F' AND RU.REFUND_ACCOUNT IS NOT NULL AND RESERVE_REFUND = 'N'	");		//환불요청 상태 검색을 위한 쿼리 추가(2017.12.07)
		}else if("H".equals(search3)){							
			sql.append(" AND  RU.RESERVE_APPROVAL = 'F' AND RU.RESERVE_REFUND = 'Y' 		");		//환불완료 상태 검색을 위한 쿼리 추가(2017.12.07)
		}else{
			sql.append(" AND  RU.RESERVE_APPROVAL = ? AND RU.REFUND_ACCOUNT IS NULL AND RU.RESERVE_REFUND = 'N' ");	//환불요청,완료가 아닌 상태를
																													//검색할 때는 환불계좌,환불완료날짜가
																													//없는 데이터를 검색한다(2017.12.07)
		}
		paging.setParams("search3", search3);
	}
	if(!"".equals(search4) && !"".equals(keyword)){
		if("school_name".equals(search4)){
			sql.append("AND RS.SCHOOL_NAME LIKE '%'||?||'%' ");
		}else if("user_name".equals(search4)){
			sql.append("AND RU.USER_NAME LIKE '%'||?||'%' ");
		}
		paging.setParams("search4", search4);
		paging.setParams("keyword", keyword);
	}
	pstmt = conn.prepareStatement(sql.toString());
	if(!"".equals(search1)){
		pstmt.setString(++key, search1);
	}
	if(!"".equals(search2)){
		pstmt.setString(++key, search2);
	}
	if(!"".equals(search3)){
		if(!"G".equals(search3) && !"H".equals(search3)){
			pstmt.setString(++key, search3);
		}
	}
	if(!"".equals(search4) && !"".equals(keyword)){
		if("school_name".equals(search4)){
			pstmt.setString(++key, keyword);
		}else if("user_name".equals(search4)){
			pstmt.setString(++key, keyword);
		}
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
	sql.append("		SELECT RU.SCHOOL_ID, RU.USER_ID, RS.SCHOOL_NAME, RU.USER_NAME, RU.RESERVE_TYPE, TO_CHAR(RU.RESERVE_REGISTER, 'yyyy-MM-dd') RESERVE_REGISTER,  ");
	sql.append("		RS.SCHOOL_AREA, RU.ADMIN_CANCEL, RU.RESERVE_APPROVAL, RU.REFUND_ACCOUNT, RU.RESERVE_REFUND				 		");
	sql.append("		FROM RESERVE_USER RU LEFT JOIN RESERVE_SCHOOL RS ON RU.SCHOOL_ID = RS.SCHOOL_ID WHERE 1=1		 			");
	if(!"".equals(search1)){
		sql.append("AND RS.SCHOOL_AREA LIKE '%'||?||'%' ");
		paging.setParams("search1", search1);
	}
	if(!"".equals(search2)){
		sql.append("AND RU.RESERVE_TYPE LIKE '%'||?||'%' ");
		paging.setParams("search2", search2);
	}
	if(!"".equals(search3)){
		if("G".equals(search3)){								
			sql.append(" AND  RU.RESERVE_APPROVAL = 'F' AND RU.REFUND_ACCOUNT IS NOT NULL AND RESERVE_REFUND = 'N' 	");		//환불요청 상태 검색을 위한 쿼리 추가(2017.12.07)
		}else if("H".equals(search3)){							
			sql.append(" AND  RU.RESERVE_APPROVAL = 'F' AND RU.RESERVE_REFUND = 'Y' 		");		//환불완료 상태 검색을 위한 쿼리 추가(2017.12.07)
		}else{
			sql.append(" AND  RU.RESERVE_APPROVAL = ? AND RU.REFUND_ACCOUNT IS NULL AND RU.RESERVE_REFUND = 'N' ");	//환불요청,완료가 아닌 상태를
																													//검색할 때는 환불계좌,환불완료날짜가
																													//없는 데이터를 검색한다(2017.12.07)
		}
		paging.setParams("search3", search3);
	}
	if(!"".equals(search4) && !"".equals(keyword)){
		if("school_name".equals(search4)){
			sql.append("AND RS.SCHOOL_NAME LIKE '%'||?||'%' ");
		}else if("user_name".equals(search4)){
			sql.append("AND RU.USER_NAME LIKE '%'||?||'%' ");
		}
		paging.setParams("search4", search4);
		paging.setParams("keyword", keyword);
	}
	sql.append("		ORDER BY RU.USER_ID DESC ");
	sql.append("	) A WHERE ROWNUM < ").append(paging.getEndRowNo()).append(" \n");
	sql.append(") WHERE RNUM >= ").append(paging.getStartRowNo()).append(" \n");
	pstmt = conn.prepareStatement(sql.toString());
	if(!"".equals(search1)){
		pstmt.setString(++key, search1);
	}
	if(!"".equals(search2)){
		pstmt.setString(++key, search2);
	}
	if(!"".equals(search3)){
		if(!"G".equals(search3) && !"H".equals(search3)){
			pstmt.setString(++key, search3);
		}
	}
	if(!"".equals(search4) && !"".equals(keyword)){
		if("school_name".equals(search4)){
			pstmt.setString(++key, keyword);
		}else if("user_name".equals(search4)){
			pstmt.setString(++key, keyword);
		}
	}
	rs = pstmt.executeQuery();	
	dataList = getResultMapRows(rs);
	
	
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
		location.href="delAction.jsp?school_id="+school_id;
	}else{
		return false;
	}
	
}

function clearSearch(){
	$("#search1").val("");
	$("#search2").val("");
	$("#search3").val("");
	$("#search4").val("");
	$("#keyword").val("");
	$("#searchForm").submit();
	
}
</script>
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>예약현황</strong></p>
  </div>
	<div id="content">
		<div class="searchBox">
			<form action="" method="post" id="searchForm">
				<fieldset>
					<legend>검색하기</legend>
					<input type="hidden" name="pageNo" id="pageNo" value="<%=pageNo%>">
					<button type="button" class="btn small edge mako" onclick="clearSearch()">전체</button>
					<select name="search1" id="search1">
						<option value="">지역선택</option>
						<%
						for(int i=0; i<areaArr.length; i++){
						%>
						<option value="<%=areaArr[i] %>" <%if(areaArr[i].equals(search1)){%> selected="selected" <%}%>><%=areaArr[i] %></option>
						<%
						}
						%>
					</select>
					<select name="search2" id="search2">
						<option value="">시설선택</option>
						<option value="강당" <%if("강당".equals(search2)){%> selected="selected" <%}%>>강당</option>
						<option value="교실" <%if("교실".equals(search2)){%> selected="selected" <%}%>>교실</option>
						<option value="기타시설" <%if("기타시설".equals(search2)){%> selected="selected" <%}%>>기타시설</option>
						<option value="운동장" <%if("운동장".equals(search2)){%> selected="selected" <%}%>>운동장</option>
					</select>
					<select name="search3" id="search3">
						<option value="">상태선택</option>
						<option value="A" <%if("A".equals(search3)){%> selected="selected" <%}%>>승인대기</option>
						<option value="B" <%if("B".equals(search3)){%> selected="selected" <%}%>>승인완료(입금대기)</option>
						<option value="C" <%if("C".equals(search3)){%> selected="selected" <%}%>>예약완료</option>
						<option value="D" <%if("D".equals(search3)){%> selected="selected" <%}%>>승인불가</option>
						<option value="E" <%if("E".equals(search3)){%> selected="selected" <%}%>>예약취소(미입금)</option>
						<option value="F" <%if("F".equals(search3)){%> selected="selected" <%}%>>예약취소</option>
						<option value="G" <%if("G".equals(search3)){%> selected="selected" <%}%>>예약취소(환불요청)</option>
						<option value="H" <%if("H".equals(search3)){%> selected="selected" <%}%>>예약취소(환불완료)</option>
					</select>
					<select name="search4" id="search4">
						<option value="">선택</option>
						<option value="school_name" <%if("school_name".equals(search4)){%> selected="selected" <%}%>>학교명</option>
						<option value="user_name" <%if("user_name".equals(search4)){%> selected="selected" <%}%>>예약자명</option>
					</select>
					<input type="text" name="keyword" id="keyword" value="<%=keyword%>">
					<input type="submit" value="검색하기" class="btn small edge mako">
				</fieldset>
			</form>
		</div>

		<div class="listArea">
			<form action="" method="post" id="postForm">
				<fieldset>
					<legend>예약현황 목록</legend>
					<table class="bbs_list">
						<colgroup>
						<col width="5%"/>
						<col width="15%"/>
						<col />
						<col width="20%"/>
						<col width="20%"/>
						<col width="10%"/>
						<col width="5%"/>
						<col width="5%"/>
						</colgroup>
						<thead>
							<tr>
								<th scope="col">번호</th>
								<th scope="col">지역</th>
								<th scope="col">학교명</th>
								<th scope="col">예약자명</th>
								<th scope="col">시설명</th>
								<th scope="col">예약일</th>
								<th scope="col">예약상태</th>
								<th scope="col">상세보기</th>
							</tr>
						</thead>
						<tbody>
						<%
						if(dataList != null && dataList.size() > 0){
							num = paging.getRowNo();
							for(int i=0; i<dataList.size(); i++){
								Map<String,Object> map = dataList.get(i);
								school_id 			= parseNull(map.get("SCHOOL_ID").toString());
								user_id 			= parseNull(map.get("USER_ID").toString());
								school_area 		= parseNull(map.get("SCHOOL_AREA").toString());
								school_name 		= parseNull(map.get("SCHOOL_NAME").toString());
								user_name 			= parseNull(map.get("USER_NAME").toString());
								reserve_type 		= parseNull(map.get("RESERVE_TYPE").toString());
								reserve_register 	= parseNull(map.get("RESERVE_REGISTER").toString());
								reserve_approval 	= parseNull(map.get("RESERVE_APPROVAL").toString());
								admin_cancel 		= parseNull(map.get("ADMIN_CANCEL").toString());
								refund_account	 	= parseNull(map.get("REFUND_ACCOUNT").toString());
								reserve_refund 		= parseNull(map.get("RESERVE_REFUND").toString());
								
								if("A".equals(reserve_approval)){
									reserve_approval = "승인대기";
								}else if("B".equals(reserve_approval)){
									reserve_approval = "입금요청";
								}else if("C".equals(reserve_approval)){
									reserve_approval = "예약완료";
								}else if("D".equals(reserve_approval)){
									reserve_approval = "승인불가";
								}else if("E".equals(reserve_approval)){
									reserve_approval = "예약취소<br>(미입금)";
								}else if("F".equals(reserve_approval)){
									if(!"".equals(admin_cancel)){					
										reserve_approval = "예약취소<br>(관리자취소)";		//관리자가 취소했을 경우
									}else if(!"".equals(refund_account)){
										if("N".equals(reserve_refund)){
											reserve_approval = "예약취소<br>(환불요청)";		//입금완료 후 예약취소했을 경우
										}else{
											reserve_approval = "예약취소<br>(환불완료)";		//관리자가 환불완료했을 경우
										}
									}else{
										reserve_approval = "예약취소";
									}
								}
						%>
							<tr>
								<td><%=num-- %></td>
								<td><%=school_area %></td>
								<td><%=school_name %></td>
								<td><%=user_name %></td>
								<td><%=reserve_type %></td>
								<td><%=reserve_register %></td>
								<td><%=reserve_approval %></td>
								<td><a href="detail.jsp?user_id=<%=user_id%>&school_id=<%=school_id%>" >상세보기</a> </td>
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
