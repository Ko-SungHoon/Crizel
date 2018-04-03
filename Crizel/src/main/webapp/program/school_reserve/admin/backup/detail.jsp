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
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
List<Map<String, Object>> dataList = null;
List<Map<String, Object>> optionList = null;
List<Map<String, Object>> dayList = null;
List<Map<String, Object>> dateDelList = null;

String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
Paging paging = new Paging();

String user_account 		= "";
String school_id 			= parseNull(request.getParameter("school_id"));
String user_id 				= parseNull(request.getParameter("user_id"));
String user_name 			= parseNull(request.getParameter("user_name"));
String user_phone 			= parseNull(request.getParameter("user_phone"));
String organ_name 			= parseNull(request.getParameter("organ_name"));
String reserve_man 			= parseNull(request.getParameter("reserve_man"));
String use_purpose 			= parseNull(request.getParameter("use_purpose"));
String use_type 			= parseNull(request.getParameter("use_type"));
String school_area 			= parseNull(request.getParameter("school_area"));
String school_name 			= parseNull(request.getParameter("school_name"));
String reserve_type 		= parseNull(request.getParameter("reserve_type"));
String reserve_type2 		= parseNull(request.getParameter("reserve_type2"));
String reserve_date 		= parseNull(request.getParameter("reserve_date"));
String time_value 			= parseNull(request.getParameter("time_value"));
String reserve_approval 	= parseNull(request.getParameter("reserve_approval"));
String reserve_delete		= parseNull(request.getParameter("reserve_delete"));
String reserve_register 	= parseNull(request.getParameter("reserve_register"));
String account 				= parseNull(request.getParameter("account"));
String total_price 			= parseNull(request.getParameter("total_price"));
String reserve_change 		= parseNull(request.getParameter("reserve_change"));
String reserve_cancel 		= parseNull(request.getParameter("reserve_cancel"));
String reserve_code 		= parseNull(request.getParameter("reserve_code"));
String refund_account 		= parseNull(request.getParameter("refund_account"));
String reserve_refund		= "";
String cancel_date 			= parseNull(request.getParameter("cancel_date"));
String date_value 			= "";
String admin_cancel 		= "";
String add_price 			= "";
String dept_tel 			= "";
String user_option 			= "";

String search1 = parseNull(request.getParameter("search1"));
String keyword = parseNull(request.getParameter("keyword"));
String reserve_notice = "";
String time_min = "";
String time_max = "";
String option_title = "";
int count = 0;

int num = 0;
int key = 0;
boolean id_check = false;
boolean delDateCheck = false;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	//학교 정보
		key = 0;
		sql = new StringBuffer();
		sql.append("SELECT * FROM RESERVE_SCHOOL WHERE SCHOOL_ID = (SELECT SCHOOL_ID FROM RESERVE_USER WHERE USER_ID = ?) ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(++key, user_id);
		rs = pstmt.executeQuery();
		if(rs.next()){
			school_name = rs.getString("SCHOOL_NAME");
			account = rs.getString("ACCOUNT");
			dept_tel = rs.getString("DEPT_TEL");
		}



		//시설 정보
		key = 0;
		sql = new StringBuffer();
		sql.append("SELECT * FROM RESERVE_ROOM WHERE ROOM_ID = (SELECT ROOM_ID FROM RESERVE_USER WHERE USER_ID = ?) ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(++key, user_id);
		rs = pstmt.executeQuery();
		if(rs.next()){
			reserve_notice = rs.getString("RESERVE_NOTICE");
		}



		//예약자 정보
		key = 0;
		sql = new StringBuffer();
		sql.append("SELECT  RESERVE_TYPE, RESERVE_TYPE2, TO_CHAR(RESERVE_REGISTER, 'yyyy-MM-dd') RESERVE_REGISTER, RESERVE_APPROVAL, ADMIN_CANCEL, ");
		sql.append("	USER_NAME, USER_PHONE, ORGAN_NAME, RESERVE_MAN, TOTAL_PRICE, USE_TYPE, USE_PURPOSE, RESERVE_CODE, RESERVE_CANCEL, ADD_PRICE ");
		sql.append("	, USER_DATE_VALUE, USER_TIME_START, USER_TIME_END, USER_OPTION, RESERVE_REFUND, REFUND_ACCOUNT ");
		sql.append("FROM RESERVE_USER WHERE USER_ID = ? ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(++key, user_id);
		rs = pstmt.executeQuery();
		if(rs.next()){
			user_name 			= parseNull(rs.getString("USER_NAME"));
			user_phone 			= parseNull(rs.getString("USER_PHONE"));
			organ_name 			= parseNull(rs.getString("ORGAN_NAME"));
			reserve_type 		= parseNull(rs.getString("RESERVE_TYPE"));
			reserve_type2 		= parseNull(rs.getString("RESERVE_TYPE2"));
			reserve_man 		= parseNull(rs.getString("RESERVE_MAN"));
			total_price 		= parseNull(rs.getString("TOTAL_PRICE"));
			use_type 			= parseNull(rs.getString("USE_TYPE"));
			use_purpose 		= parseNull(rs.getString("USE_PURPOSE"));
			reserve_approval 	= parseNull(rs.getString("RESERVE_APPROVAL"));
			reserve_register 	= parseNull(rs.getString("RESERVE_REGISTER"));
			reserve_code 		= parseNull(rs.getString("RESERVE_CODE"));
			reserve_cancel 		= parseNull(rs.getString("RESERVE_CANCEL"));
			admin_cancel 		= parseNull(rs.getString("ADMIN_CANCEL"));
			add_price 			= parseNull(rs.getString("ADD_PRICE"));
			date_value 			= parseNull(rs.getString("USER_DATE_VALUE"));
			time_min 			= parseNull(rs.getString("USER_TIME_START"));
			time_max 			= parseNull(rs.getString("USER_TIME_END"));
			user_option 		= parseNull(rs.getString("USER_OPTION"));
			refund_account 		= parseNull(rs.getString("REFUND_ACCOUNT"));
			reserve_refund 		= parseNull(rs.getString("RESERVE_REFUND"));
		}



		//실 개수 정보
		key = 0;
		sql = new StringBuffer();
		sql.append("SELECT USER_ID, USE_ID FROM RESERVE_USE WHERE USER_ID = ? GROUP BY USER_ID, USE_ID ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(++key, user_id);
		rs = pstmt.executeQuery();
		while(rs.next()){
			count++;
		}



		//예약 옵션
		key = 0;
		sql = new StringBuffer();
		sql.append("SELECT * FROM RESERVE_OPTION WHERE ROOM_ID = (SELECT ROOM_ID FROM RESERVE_USER WHERE USER_ID = ? ) ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(++key, user_id);
		rs = pstmt.executeQuery();
		optionList = getResultMapRows(rs);



		/* //날짜 리스트
		key = 0;
		sql = new StringBuffer();
		sql.append("SELECT * FROM RESERVE_USE WHERE USER_ID = ? ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(++key, user_id);
		rs = pstmt.executeQuery();
		if(rs.next()){
			date_value=rs.getString("DATE_VALUE");
		}



		//시간 정보
		key = 0;
		sql = new StringBuffer();
		sql.append("SELECT MIN(TIME_START) MIN, MAX(TIME_END) MAX FROM RESERVE_USE WHERE USER_ID = ? ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(++key, user_id);
		rs = pstmt.executeQuery();
		if(rs.next()){
			if(rs.getString("MIN") != null){
				time_min = timeSet(rs.getString("MIN"));
				time_max = timeSet(rs.getString("MAX"));
			}
		} */


		if("A".equals(reserve_approval)){
			reserve_approval = "승인대기";
		}else if("B".equals(reserve_approval)){
			reserve_approval = "입금요청";
		}else if("C".equals(reserve_approval)){
			reserve_approval = "예약완료";
		}else if("D".equals(reserve_approval)){
			reserve_approval = "승인불가";
		}else if("E".equals(reserve_approval)){
			reserve_approval = "예약취소(미입금)";
		}else if("F".equals(reserve_approval)){
			if(!"".equals(refund_account)){
				if("N".equals(reserve_refund)){
					reserve_approval = "예약취소(환불요청)";		//입금완료 후 예약취소했을 경우
				}else{
					reserve_approval = "예약취소(환불완료)";		//관리자가 환불완료했을 경우
				}
			}else{
				reserve_approval = "예약취소";
			}
		}
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
		location.href="delAction.jsp?school_id="+school_id;
	}else{
		return false;
	}

}
function selChange(){
	var length = $("input[name=selCheck]:checked").length;
	if(length > 0){
		if(confirm("상태를 변경하시겠습니까?")){
			$("#school_approval").val($("#allChange").val());
			$("#postForm").attr("action", "/program/school_reserve/admin/approvalAction2.jsp");
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
      <p class="location"><strong>학교관리</strong></p>
  </div>
	<div id="content">
	<div class="listArea">
		<form action="" method="post" id="postForm">
<input type="hidden" name="reserve_change" id="reserve_change" value="N">
<input type="hidden" name="reserve_approval" id="reserve_approval">
<input type="hidden" name="user_id" id="user_id" value="<%=user_id%>">

<section>
	<h3>시설예약정보</h3>
	<table class="bbs_list2">
		<caption> 학교 시설물 예약 상세 정보입니다. </caption>
		<colgroup>
			<col class="wps_20" />
			<col />
			<col class="wps_20" />
			<col class="wps_30"/>
		</colgroup>
		<tbody>
				<tr>
					<th scope="row">학교명</th>
					<td><p class="blind">학교명</p><%=school_name %></td>
					<th scope="row">시설명</th>
					<td>
						<%
						if("".equals(reserve_type2)){
						%>
							<%=reserve_type %> 
						<%
						}else{
						%>	
							<%=reserve_type2 %> 
						<%} %> (<%=count%>)실
					</td>
				</tr>
				<tr>
					<th scope="row">사용일자</th>
					<td><p class="blind">사용일자</p>
					<span><%=date_value %></span>

					</td>
					<th scope="row">예약시간</th>
					<td><%=timeSet(time_min) %> ~ <%=timeSet(time_max)%>	</td>
				</tr>
				<tr>
					<th scope="row">신청일자</th>
					<td><%=reserve_register %></td>
					<th scope="row">진행상태</th>
					<td><%=reserve_approval%></td>
				</tr>
				<tr>
					<th scope="row">사용유형</th>
					<td colspan="3" ><%=use_type %></td>
				</tr>
				<tr>
					<th scope="row">사용옵션</th>
					<td colspan="3">
						<%
						if(!"".equals(user_option) ){
						%>
						<%=user_option %> 사용
						<%
						}
						%>
					</td>
				</tr> 
				<%if(!"승인대기".equals(reserve_approval)){ %>
				<tr>
					<th scope="row">입금계좌</th>
					<td colspan="3">
					<%if("입금요청".equals(reserve_approval)){%>
					<!-- 입금요청시 노출되는 문구 -->
						<p class="topbox_round bg1 magB10">&#8251; <%=user_name %>님의 시설사용이 승인되었습니다. <br />금액을 확인 후 아래 계좌로 입금해주시기 바랍니다. <span class="red">3일 이내 미입금 시 자동취소</span>됩니다.</p>
					<!-- // 여기까지 입금요청시 노출되는 문구 -->
					<%} %>
						<p class="bankinfo"><%=account%> </p>
					</td>
				</tr>
				<%} %>
				<tr>
					<th scope="row">사용금액</th>
					<td colspan="3">
						<strong class="red"><%=moneySet(total_price)%>원</strong>
						<%if(!"".equals(add_price)){%>
							<span class="addtxt">(사용목적 등의 이유로 학교관리자에 의해 <span><%=moneySet(add_price)%>원이 추가</span>된 금액입니다.)</span>
						<%} %>
						
					</td>
				</tr>
			</tbody>
	</table>
</section>
<section>
	<h3>예약자 정보</h3>
	<table class="bbs_list2">
		<caption>예약자 상세 정보입니다. </caption>
		<colgroup>
			<col class="wps_20" />
			<col />
			<col class="wps_20" />
			<col class="wps_30"/>
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">예약번호</th>
				<td><%=reserve_code %></td>
				<th scope="row">예약자명</th>
				<td><%=user_name %></td>
			</tr>
			<tr>
				<th scope="row">단체명/인원</th>
				<td><%=organ_name %> / <%=reserve_man %></td>
				<th scope="row">연락처</th>
				<td><strong><%=telSet(user_phone) %></strong></td>
			</tr>
			<tr>
				<th scope="row">사용목적</th>
				<td colspan="3"><%=use_purpose %></td>
			</tr>
			<%if("예약취소".equals(reserve_approval)){%>
			<tr>
				<th scope="row">환불계좌</th>
				<td colspan="3"><%=refund_account %></td>
			</tr>
			<tr>
				<th scope="row">예약취소일</th>
				<td colspan="3"><%=cancel_date %></td>
			</tr>
			<%} %>
			<%if(dateDelList!=null && dateDelList.size()>0){
				int dateDelCnt = 0;
			%>
			<tr>
				<th scope="row">날짜변경요청</th>
				<td colspan="3">
				<%for(Map<String,Object> ob : dateDelList){ %>			
					<label><input type="checkbox" name="reserve_date_del" id="reserve_date_del" value="<%=ob.get("RESERVE_DATE").toString() %>"></label>	
					<%=ob.get("RESERVE_DATE").toString() %>
				<%} %>
				<button type="button" onclick="dateDelApproval()" class="btn small edge darkMblue">날짜변경승인</button>
				</td>
			</tr>
			<%
			}
			%>
			
		</tbody>
	</table>
</section>
<div class="btn_area c">
	<button type="button" onclick="location.href='userList.jsp'" class="btn medium edge mako">목록보기</button>
</div>
</form>
	</div>
	<!-- // content -->
	</div>
</div>
</body>
</html>
