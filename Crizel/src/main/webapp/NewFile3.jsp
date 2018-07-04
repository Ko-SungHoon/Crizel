<%
/**
*	PURPOSE	:	시설별 예약현황 / 예약관리
*	CREATE	:	2017....
*	MODIFY	:	....
*/
%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ include file="/program/class/PagingClass.jsp" %>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%
String listPage = "DOM_000001201007002000";	// DOM_000001201007002000 , TEST : DOM_000000106007002000

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

String user_account 	= "";
String school_id 		= parseNull(request.getParameter("school_id"));
String user_id 			= parseNull(request.getParameter("user_id"));
String user_name 		= parseNull(request.getParameter("user_name"));
String user_phone 		= parseNull(request.getParameter("user_phone"));
String organ_name 		= parseNull(request.getParameter("organ_name"));
String reserve_man 		= parseNull(request.getParameter("reserve_man"));
String use_purpose 		= parseNull(request.getParameter("use_purpose"));
String use_type 		= parseNull(request.getParameter("use_type"));
String school_area 		= parseNull(request.getParameter("school_area"));
String school_name 		= parseNull(request.getParameter("school_name"));
String reserve_type 	= parseNull(request.getParameter("reserve_type"));
String reserve_type2 	= parseNull(request.getParameter("reserve_type2"));
String reserve_date 	= parseNull(request.getParameter("reserve_date"));
String time_value 		= parseNull(request.getParameter("time_value"));
String reserve_approval = parseNull(request.getParameter("reserve_approval"));
String reserve_delete 	= parseNull(request.getParameter("reserve_delete"));
String reserve_register = parseNull(request.getParameter("reserve_register"));
String account	 		= parseNull(request.getParameter("account"));
String total_price 		= parseNull(request.getParameter("total_price"));
String reserve_change 	= parseNull(request.getParameter("reserve_change"));
String reserve_cancel 	= parseNull(request.getParameter("reserve_cancel"));
String reserve_code 	= parseNull(request.getParameter("reserve_code"));
String refund_account 	= parseNull(request.getParameter("refund_account"));
String reserve_refund	= "";
String cancel_date 		= parseNull(request.getParameter("cancel_date"));
String date_value 		= "";
String user_option 		= "";
String add_comment 		= "";

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

user_account = sm.getId();

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	//학교 정보
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_SCHOOL WHERE SCHOOL_ID = (SELECT SCHOOL_ID FROM RESERVE_USER WHERE USER_ID = ?) AND SCHOOL_APPROVAL = 'Y' ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, user_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		school_name = rs.getString("SCHOOL_NAME");
		account = rs.getString("ACCOUNT");
		id_check = true;
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
	sql.append("SELECT  RESERVE_TYPE, RESERVE_TYPE2, TO_CHAR(RESERVE_REGISTER, 'yyyy-MM-dd') RESERVE_REGISTER, RESERVE_APPROVAL, USER_NAME, USER_PHONE,ORGAN_NAME,  ");
	sql.append("	RESERVE_MAN, TOTAL_PRICE, USE_TYPE, USE_PURPOSE, RESERVE_CANCEL, RESERVE_CODE, REFUND_ACCOUNT, TO_CHAR(CANCEL_DATE, 'yyyy-MM-dd') CANCEL_DATE ");
	sql.append("	,USER_DATE_VALUE, USER_TIME_START, USER_TIME_END, USER_OPTION, RESERVE_REFUND, ADD_COMMENT ");
	sql.append("FROM RESERVE_USER WHERE USER_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, user_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		user_name = parseNull(rs.getString("USER_NAME"));
		user_phone = parseNull(rs.getString("USER_PHONE"));
		organ_name = parseNull(rs.getString("ORGAN_NAME"));
		reserve_type = parseNull(rs.getString("RESERVE_TYPE"));
		reserve_type2 = parseNull(rs.getString("RESERVE_TYPE2"));
		reserve_man = parseNull(rs.getString("RESERVE_MAN"));
		total_price = parseNull(rs.getString("TOTAL_PRICE"));
		use_type = parseNull(rs.getString("USE_TYPE"));
		use_purpose = parseNull(rs.getString("USE_PURPOSE"));
		reserve_approval = parseNull(rs.getString("RESERVE_APPROVAL"));
		reserve_register = parseNull(rs.getString("RESERVE_REGISTER"));
		reserve_cancel = parseNull(rs.getString("RESERVE_CANCEL"));
		reserve_code = parseNull(rs.getString("RESERVE_CODE"));
		refund_account = parseNull(rs.getString("REFUND_ACCOUNT"));
		reserve_refund = parseNull(rs.getString("RESERVE_REFUND"));
		cancel_date = parseNull(rs.getString("CANCEL_DATE"));
		time_min = timeSet(rs.getString("USER_TIME_START"));
		time_max = timeSet(rs.getString("USER_TIME_END"));
		date_value=rs.getString("USER_DATE_VALUE");
		user_option = parseNull(rs.getString("USER_OPTION"));
		add_comment = parseNull(rs.getString("ADD_COMMENT"));
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
	if (pstmt != null)pstmt.close();
	if (rs != null)rs.close();

	
	

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
	}
	if (pstmt != null)pstmt.close();
	if (rs != null)rs.close(); */
} catch (Exception e) {
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
function printPage(){
	$("#printArea").printThis();
}
function postForm(reserve_type){
	$("#postForm").submit();
}
function reserveChange(){
	if($("#changeVal").val() == $("#reserve_approval").val()){
		return false;
	}else{
		var check = true;
		
		if($("#changeVal").val() == "D" || $("#changeVal").val() == "F"){
			if($("#reserve_approval").val() == "B" || $("#reserve_approval").val() =="C"){
				if($.trim($("#refund_price").val()) == ""){
					alert("환불금액을 입력하여 주시기 바랍니다.");
					check = false;
					return false;
				}else{
					check = true;
				}
				
				if(parseInt($("#total_price").val()) < parseInt($("#refund_price").val())){
					alert("환불금액이 사용금액보다 많습니다.");
					check = false;
					return false;
				}
			}
			
			if($.trim($("#reserve_cancel").val()) == ""){
				alert("예약승인 불가(취소) 사유를 입력하여 주시기 바랍니다.");
				check = false;
				return false;
			}else{
				check = true;
			}
			
		}else if($("#changeVal").val() == "B" ){
			if($.trim($("#add_price").val()) == ""){
				check = true;
			}else{
				if($.trim($("#add_comment").val()) == ""){
					alert("추가금액 사유를 입력하여 주시기 바랍니다.");
					check = false;
				}else{
					check = true;
				}
			}
		}
		
		if(check){
			if(confirm("진행상태를 변경하시겠습니까?")){
				var reserve_approval = $("#changeVal").val();
				$("#reserve_change").val("Y");
				$("#reserve_approval").val(reserve_approval);
				$("#postForm").attr("action","/program/school_reserve/reserve_change.jsp");
				$("#postForm").submit();
			}
		}
	}
}

function refundAction(){
	if($.trim($("#refund_price").val()) == ""){
		alert("환불금액을 입력하여 주시기 바랍니다.");	
		return false;
	}else{
		if(parseInt($("#total_price").val()) < parseInt($("#refund_price").val())){
			alert("환불금액이 사용금액보다 많습니다.");
			check = false;
		}else{
			if(confirm("환불완료로 상태를 변경하시겠습니까?")){
				$("#postForm").attr("action", "/program/school_reserve/refundAction.jsp").submit();
			}else{
				return false;
			}
		}
	}
}


$(function(){
	f_changeVal($("#changeVal").val());
	$("#add_price").keyup(function(){$(this).val($(this).val().replace(/[^0-9]/g,"") );} );
	$("#add_price").keydown(function(){$(this).val($(this).val().replace(/[^0-9]/g,"") );} );
	$("#refund_price").keyup(function(){$(this).val($(this).val().replace(/[^0-9]/g,"") );} );
	$("#refund_price").keydown(function(){$(this).val($(this).val().replace(/[^0-9]/g,"") );} );
	
	<%
	if(/* "F".equals(reserve_approval) &&  */!"".equals(refund_account)/*  && "N".equals(reserve_refund) */){
	%>
		$("#refundPrice").css("display","");
	<%
	}else{
	%>
		$("#refundPrice").css("display","none");
	<%
	}
	%>
	
});



function f_changeVal(value){
	if($("#changeVal").val() == $("#reserve_approval").val()){
		$("#changeBtn").css("background", "#666666");
	}else{
		$("#changeBtn").css("background", "#35518b");
	}
	
	if(value == "D"){
		$("#changeValInsert").css("display","");
		$("#add_price_div").css("display","none");
		$("#add_comment_div").css("display","none");
		if($("#reserve_approval").val() == "B" || $("#reserve_approval").val() =="C"){
			$("#refundPrice").css("display","");
		}
	}else if(value == "B"){
		$("#add_price_div").css("display","");
		$("#add_comment_div").css("display","");
		$("#changeValInsert").css("display","none");
		$("#refundPrice").css("display","none");
	}else if(value == "F"){
		$("#changeValInsert").css("display","");
		$("#add_price_div").css("display","none");
		$("#add_comment_div").css("display", "none");
		if($("#reserve_approval").val() == "B" || $("#reserve_approval").val() =="C"){
			$("#refundPrice").css("display","");
		}
	}
	else{
		$("#changeValInsert").css("display","none");
		$("#add_price_div").css("display","none");
		$("#add_comment_div").css("display","none");
		$("#refundPrice").css("display","none");
	}
}

function dateDelApproval(){
	if(confirm("날짜변경을 승인하시겠습니까?")){
		$("#postForm").attr("action", "/program/school_reserve/dateDelAdmin.jsp");
		$("#postForm").submit();
	}else{
		return false;
	}
}

function phoneChange(){
	var user_phone = $("#user_phone").val().replace(/-/gi,"");
	$("#user_phone").val(user_phone);
	$("#postForm").attr("action","/program/school_reserve/userPhoneChange.jsp").submit();
}
</script>
<%if(id_check){%>
<form action="" method="post" id="postForm">
<input type="hidden" name="reserve_change" id="reserve_change" value="N">
<input type="hidden" name="reserve_approval" id="reserve_approval" value="<%=reserve_approval%>">
<input type="hidden" name="user_id" id="user_id" value="<%=user_id%>">
<input type="hidden" name="totaL_price" id="total_price" value="<%=total_price%>">
<%
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
%>
<div id="printArea">

<section>
	<h3>시설예약정보</h3>
	<table class="table_skin01">
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
				<td><%=school_name %></td>
				<th scope="row">시설명</th>
				<td><strong><%=reserve_type %>(<%=count%>)실 /
				<%
				if(!"".equals(user_option) ){
				%>
				<%=user_option %> 사용
				<%
				}
				%></strong>
				</td>
			</tr>
			<tr>
				<th scope="row">사용일자</th>
				<td><strong>
				<span><%=date_value %></span>
					<%
					if(dayList != null && dayList.size()>0){
						for(int i=0; i<dayList.size(); i++){
							Map<String, Object> map = dayList.get(i);
							reserve_date = map.get("RESERVE_DATE").toString();
							
							if(dateDelList != null && dateDelList.size() > 0){
								for(Map<String,Object> ob : dateDelList){
									if(ob.get("RESERVE_DATE").toString().equals(reserve_date)){
										delDateCheck = true;
									}
								}
							}
							if(i==0){
						%>
							<span <%if(delDateCheck){delDateCheck=false;%> style="color: red;" <%}%>><%=reserve_date %> </span>
						<%
							}else{
						%>
							, <span <%if(delDateCheck){delDateCheck=false;%> style="color: red;" <%}%>><%=reserve_date %></span>
						<%
							}
						}
					}
					%></strong>
				</td>
				<th scope="row">예약시간</th>
				<td><strong><%=time_min %> ~ <%=time_max %>	</strong></td>
			</tr>
			<tr>
				<th scope="row">신청일자</th>
				<td><%=reserve_register %></td>
				<th scope="row">진행상태</th>
				<td class="l">
					<label for="changeVal" class="blind">진행상태</label>
					<%
					if("예약취소(환불요청)".equals(reserve_approval)){
					%>
					<select id="changeVal" onchange="f_changeVal(this.value)" class="wps_80">
						<option value="G">예약취소(환불요청)</option>
					</select>
					<button type="button" onclick="refundAction()" class="btn small edge darkMblue" id="changeBtn">환불완료</button>
					<%
					}else if("예약취소(환불완료)".equals(reserve_approval)){
					%>
					<select id="changeVal" onchange="f_changeVal(this.value)" class="wps_80">
						<option value="H">예약취소(환불완료)</option>
					</select>
					<%	
					}else{
					%>
					<select id="changeVal" onchange="f_changeVal(this.value)" class="wps_60">
					<%if("승인대기".equals(reserve_approval)){ %>
						<option value="A" <%if("예약접수".equals(reserve_approval)){%> selected="selected" <%}%>>예약접수</option>
					<%} %>
					<%if("승인대기".equals(reserve_approval) || "입금요청".equals(reserve_approval)){ %>
						<option value="B" <%if("입금요청".equals(reserve_approval)){%> selected="selected" <%}%>>입금요청</option>
					<%} %>
					<%if("승인대기".equals(reserve_approval) || "입금요청".equals(reserve_approval) || "예약완료".equals(reserve_approval)){ %>
						<option value="C" <%if("예약완료".equals(reserve_approval)){%> selected="selected" <%}%>>예약완료</option>
					<%} %>
					<%if("승인대기".equals(reserve_approval) || "입금요청".equals(reserve_approval) || "예약완료".equals(reserve_approval) || "승인불가".equals(reserve_approval)){ %>
						<option value="D" <%if("승인불가".equals(reserve_approval)){%> selected="selected" <%}%>>승인불가</option>
					<%} %>
					<%if("승인대기".equals(reserve_approval) || "입금요청".equals(reserve_approval) || "예약완료".equals(reserve_approval) || "승인불가".equals(reserve_approval)){ %>
						<option value="E" <%if("예약취소(미입금)".equals(reserve_approval)){%> selected="selected" <%}%>>예약취소(미입금)</option>
					<%} %>
						
						<option value="F" <%if("예약취소".equals(reserve_approval)){%> selected="selected" <%}%>>예약취소</option>
					</select>
					<button type="button" onclick="reserveChange()" class="btn small edge darkMblue" id="changeBtn">변경</button>
					<%} %>
				</td>
			</tr>
			<tr id="refundPrice" style="display: none;">
				<th scope="row" class="red">환불금액 입력</th>
				<td colspan="3" class="l">
					<input type="text" id="refund_price" name="refund_price">
				</td>
			</tr>
			<tr id="changeValInsert" style="display: none;">
				<th scope="row" class="red">예약불가(취소) 사유입력</th>
				<td colspan="3" class="l">
					<!-- input type="text" id="reserve_cancel" name="reserve_cancel" value="<%=reserve_cancel %>" -->
					<label for="reserve_cancel" class="hidden">예약불가(취소) 사유입력</label>
					<textarea id="reserve_cancel" name="reserve_cancel" rows="3" class="wps_80"><%=reserve_cancel %></textarea>
					<!-- <button type="submit" class="btn medium edge mako">저장</button> -->
				</td>
			</tr>
			<tr id="add_price_div" style="display: none;">
				<th scope="row" class="red">추가금액 입력</th>
				<td colspan="3" class="l">
					<input type="text" id="add_price" name="add_price">
				</td>
			</tr>
			<tr id="add_comment_div" style="display: none;">
				<th scope="row" class="red">추가금액 사유</th>
				<td colspan="3" class="l">
					<label for="add_comment" class="hidden">추가금액 사유</label>
					<textarea id="add_comment" name="add_comment" rows="3" class="wps_80"><%=add_comment %></textarea>
				</td>
			</tr>
			<tr>
				<th scope="row">사용유형</th>
				<td colspan="3" class="l"><%=use_type %></td>
			</tr>
			<tr>
				<th scope="row">사용금액</th>
				<td><strong class="red"><%=moneySet(total_price)%>원</strong></td>
				<th scope="row">입금계좌</th>
				<td><%=account%></td>
			</tr>
		</tbody>
	</table>
</section>
<section>
	<h3>예약자 정보</h3>
	<table class="table_skin01">
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
				<td>
					<input type="text" name="user_phone" id="user_phone" value="<%=telSet(user_phone) %>" class="wps_60">
					<button type="button" onclick="phoneChange()" class="btn small edge darkMblue">변경</button>
					<%-- <strong><%=telSet(user_phone) %></strong>  --%>
				</td>
			</tr>
			<tr>
				<th scope="row">사용목적</th>
				<td colspan="3"><%=use_purpose %></td>
			</tr>
			<%if(!"".equals(refund_account)){%>
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
</div>
<div class="btn_area c">
	<button type="button" onclick="location.href='/index.gne?menuCd=<%=listPage %>'" class="btn medium edge mako">목록보기</button>
	<button type="button" onclick="printPage();" class="btn medium edge mako">출력</button>
</div>
</form>

<%}else{ %>
<div class="topbox2 c">
	학교정보가 등록되지 않았거나 승인되지 않았습니다.
</div>
<%} %>