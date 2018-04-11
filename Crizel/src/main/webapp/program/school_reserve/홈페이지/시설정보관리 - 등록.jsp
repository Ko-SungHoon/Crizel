<%
/**
*   PURPOSE :   시설정보 관리 등록
*   CREATE  :   2017... 고주임
*   MODIFY  :   20171116_thur   JI  옵션사용 / % 원 select 추가 및 submit 반영
*   MODIFY  : 20180222 LJH 모바일환경 구현class 추가
*/
%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ include file="/program/class/PagingClass.jsp" %>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.ParseException" %>
<link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css"/>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
<script>
$.datepicker.regional['kr'] = {
	    closeText: '닫기', // 닫기 버튼 텍스트 변경
	    currentText: '오늘', // 오늘 텍스트 변경
	    monthNames: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
	    monthNamesShort: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
	    minDate: 0,
	    maxDate: "+6M",
	    dayNames: ['월요일','화요일','수요일','목요일','금요일','토요일','일요일'], // 요일 텍스트 설정
	    dayNamesShort: ['월','화','수','목','금','토','일'] // 요일 텍스트 축약 설정    dayNamesMin: ['월','화','수','목','금','토','일'], // 요일 최소 축약 텍스트 설정
	};
$.datepicker.setDefaults($.datepicker.regional['kr']);

$(function() {
	  $( "#reserve_start" ).datepicker({
	    dateFormat: 'yy-mm-dd'
	  });
	  $( "#reserve_start2" ).datepicker({
		    dateFormat: 'yy-mm-dd'
		  });
	  $( "#reserve_end" ).datepicker({
		    dateFormat: 'yy-mm-dd'
		  });
	  $( "#reserve_end2" ).datepicker({
		    dateFormat: 'yy-mm-dd'
		  });

});
</script>

<%

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
List<Map<String, Object>> dataList = null;
List<String> valList = new ArrayList<String>();
List<String> resultList = new ArrayList<String>();
List<Map<String, Object>> optionList = null;

String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
Paging paging = new Paging();


String school_id = parseNull(request.getParameter("school_id"));
String command = parseNull(request.getParameter("command"), "insert");
String room_id = parseNull(request.getParameter("room_id"));
String reserve_type = "";
String reserve_type2 = "";
String reserve_number = "";
String reserve_area = "";
String reserve_max = "";
String reserve_date = "";
String reserve_etc = "";
String reserve_notice = "";
String save_img = "";
String real_img = "";
String directory = "";
String reserve_use = "";
String etc_price1 = "";
String etc_price2 = "";
String etc_price3 = "";
String option_title = "";
String option_price = "";
/* 20171116_thur */
String option_price_unit = "";
/* END */

String reserve_start = "";
String reserve_start2 = "";
String reserve_end = "";
String reserve_end2 = "";
String reserve_time1_1 = "";
String reserve_time1_2 = "";
String reserve_time1_3 = "";
String reserve_time1_4 = "";
String reserve_time2_1 = "";
String reserve_time2_2 = "";
String reserve_time2_3 = "";
String reserve_time2_4 = "";
String reserve_time3_1 = "";
String reserve_time3_2 = "";
String reserve_time3_3 = "";
String reserve_time3_4 = "";


int key = 0;
try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	if(!"".equals(room_id)){
		//시설정보
		sql = new StringBuffer();
		sql.append("SELECT * FROM RESERVE_ROOM WHERE SCHOOL_ID = ? AND ROOM_ID = ?  ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(++key, school_id);
		pstmt.setString(++key, room_id);
		rs = pstmt.executeQuery();
		if(rs.next()){
			reserve_type = parseNull(rs.getString("RESERVE_TYPE"));
			reserve_type2 = parseNull(rs.getString("RESERVE_TYPE2"));
			reserve_number = parseNull(rs.getString("RESERVE_NUMBER"));
			reserve_area = parseNull(rs.getString("RESERVE_AREA"));
			reserve_max = parseNull(rs.getString("RESERVE_MAX"));
			reserve_etc = parseNull(rs.getString("RESERVE_ETC"));
			reserve_notice = parseNull(rs.getString("RESERVE_NOTICE"));
			save_img = parseNull(rs.getString("SAVE_IMG"));
			real_img = parseNull(rs.getString("REAL_IMG"));
			directory = parseNull(rs.getString("DIRECTORY"));
			reserve_use = parseNull(rs.getString("RESERVE_USE"));
			etc_price1 = parseNull(rs.getString("ETC_PRICE1"));
			etc_price2 = parseNull(rs.getString("ETC_PRICE2"));
			etc_price3 = parseNull(rs.getString("ETC_PRICE3"));
		}


		key = 0;
		//개방시간
		sql = new StringBuffer();
		sql.append("SELECT * FROM RESERVE_DATE WHERE SCHOOL_ID = ? AND ROOM_ID = ? AND RESERVE_TYPE = 'A'	");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(++key, school_id);
		pstmt.setString(++key, room_id);
		rs = pstmt.executeQuery();
		if(rs.next()){
			reserve_time1_1 = parseNull(rs.getString("TIME_START_A"));
			reserve_time1_2 = parseNull(rs.getString("TIME_END_A"));
			reserve_time1_3 = parseNull(rs.getString("TIME_START_A2"));
			reserve_time1_4 = parseNull(rs.getString("TIME_END_A2"));

			reserve_time2_1 = parseNull(rs.getString("TIME_START_B"));
			reserve_time2_2 = parseNull(rs.getString("TIME_END_B"));
			reserve_time2_3 = parseNull(rs.getString("TIME_START_B2"));
			reserve_time2_4 = parseNull(rs.getString("TIME_END_B2"));

			reserve_time3_1 = parseNull(rs.getString("TIME_START_C"));
			reserve_time3_2 = parseNull(rs.getString("TIME_END_C"));
			reserve_time3_3 = parseNull(rs.getString("TIME_START_C2"));
			reserve_time3_4 = parseNull(rs.getString("TIME_END_C2"));
		}

		key = 0;
		sql = new StringBuffer();
		sql.append("SELECT * FROM RESERVE_OPTION WHERE ROOM_ID = ? ORDER BY OPTION_ID  ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(++key, room_id);
		rs = pstmt.executeQuery();
		optionList = getResultMapRows(rs);

	}

} catch (Exception e) {
	%>
	<%=e.toString() %>
	<%
	/* e.printStackTrace();
	sqlMapClient.endTransaction();
	alertBack(out, "처리중 오류가 발생하였습니다.");  */
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
}
%>
<%!
public List<String> timeList(List<String> param){
	String timeArr[] = {"0600", "0630", "0700", "0730", "0800", "0830", "0900", "0930", "1000", "1030", "1100", "1130", "1200"
			, "1230", "1300", "1330", "1400", "1430", "1500", "1530", "1600", "1630", "1700", "1730", "1800", "1830", "1900"
			, "1930", "2000", "2030", "2100", "2130", "2200", "2230", "2300", "2330", "2400"};
	List<String> list = new ArrayList<String>();
	int leng = param.size();
	for(int i=0; i<leng-1; i++){
		if(arrIndex(param.get(i+1)) - arrIndex(param.get(i)) > 1 ){
			list.add(param.get(i));
			list.add(param.get(i+1));
		}
	}

	if(list.size()==1){
		list.add(list.get(0));
	}

	return list;
}
%>
<%!
public int arrIndex(String param){
	String timeArr[] = {"0600", "0630", "0700", "0730", "0800", "0830", "0900", "0930", "1000", "1030", "1100", "1130", "1200"
			, "1230", "1300", "1330", "1400", "1430", "1500", "1530", "1600", "1630", "1700", "1730", "1800", "1830", "1900"
			, "1930", "2000", "2030", "2100", "2130", "2200", "2230", "2300", "2330", "2400"};
	int index = 0;
	for(int i=0; i<timeArr.length; i++){
		if(param.equals(timeArr[i])){
			index = i;
		}
	}

	return index;
}
%>

<%!
public List<String> dateList(List<String> param){
	String nextDate= "";
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	Date date = new Date();
	Calendar c = Calendar.getInstance();
	List<String> list = new ArrayList<String>();
	int leng = param.size();
	try{
		for(int i=0; i<leng-1; i++){
			date = sdf.parse(param.get(i));
			c.setTime(date);
			c.add(Calendar.DATE,1);
			nextDate =  sdf.format(c.getTime());
			if(!param.get(i+1).equals(nextDate) ){
				list.add(param.get(i));
				list.add(param.get(i+1));
			}
		}

		if(list.size()==1){
			list.add(list.get(0));
		}

   }catch(ParseException e){
   		e.printStackTrace();
   }

	return list;
}
%>

<form action="" method="post" id="postForm">
	<label><input type="checkbox" name="id_check" id="id_check" value="<%=room_id%>" style="display: none;"></label>
</form>


<form action="/program/school_reserve/actionWae.jsp" method="post" enctype="multipart/form-data" id="reserveForm" class="faci_add">
<input type="hidden" name="school_id" id="school_id" value="<%=school_id%>">
<input type="hidden" name="room_id" id="room_id" value="<%=room_id%>">
<input type="hidden" name="command" id="command" value="<%=command%>">
<input type="hidden" name="save_img_check" id="save_img_check" value="<%=save_img%>">
<input type="hidden" name="reserve_use" id="reserve_use">


<table class="board_read">
	<caption>학교시설물 등록 및 수정 입력표입니다.</caption>
	<colgroup>
		<col class="wps_15" />
		<col />
	</colgroup>
	<tbody>
		<tr>
			<th scope="row"><span class="red">*</span> 시설종류</th>
			<td>
				<label for="reserve_type" class="dis_mo">시설종류</label>
				<%if("insert".equals(command)){%>
				<!-- 등록 할 때 select -->
				<select name="reserve_type" id="reserve_type" onchange="reserve_type_change(this.value)">
					<option value="">선택</option>
					<option value="강당" <%if("강당".equals(reserve_type)){%> selected="selected" <%}%>  >강당</option>
					<option value="교실" <%if("교실".equals(reserve_type)){%> selected="selected" <%}%>>교실</option>
					<option value="운동장" <%if("운동장".equals(reserve_type)){%> selected="selected" <%}%>>운동장</option>
					<option value="기타시설" <%if("기타시설".equals(reserve_type)){%> selected="selected" <%}%>>기타시설</option>
				</select>
				<%}else{ %>
				<!-- 수정 할 때 text -->
					<%=reserve_type%>
					<input type="hidden" name="reserve_type" id="reserve_type" value="<%=reserve_type %>" >
				<%} %>
				<!-- 교실 선택시 노출 -->
				<p class="reserve_group" style="display: none;">
					<span class="title"><label for="reserve_group">시설 수</label></span>
					<input type="text" name="reserve_group" id="reserve_group" value="<%=reserve_number%>">
				</p>

				<!-- 기타 시설 선택시 노출 -->
				<p class="reserve_type2 magT10" style="display: none;">
					<span class="titlle"><label for="reserve_type2">기타시설명</label></span>
					<label><input type="text" name="reserve_type2" id="reserve_type2" value="<%=reserve_type2%>" class="wps_60"></label>
				</p>
			</td>
		</tr>
		<tr>
			<th scope="row">면적</th>
			<td>
				<label for="reserve_area" class="dis_mo">면적</label>
				<input type="text" name="reserve_area" id="reserve_area" value="<%=reserve_area %>" class="wps_50"> ㎡
			</td>
		</tr>
		<tr>
			<th scope="row">수용가능 인원</th>
			<td>
				<label for="reserve_max" class="dis_mo">수용가능 인원</label>
				<input type="text" name="reserve_max" id="reserve_max" value="<%=reserve_max %>" class="wps_50"> 명(1실 기준)
			</td>
		</tr>
		<%-- <tr>
			<th scope="row">개방여부 설정</th>
			<td>
				<input type="checkbox" name="reserve_use" id="reserve_use" value="Y" <%if("Y".equals(reserve_use)){%> checked="checked" <%}%>> <label for="reserve_use" class="fb">개방함</label>
				<!--
				<p>1.
					<label for="reserve_start" class="blind">시작날짜 선택</label><input type="text" name="reserve_start" id="reserve_start" disabled="disabled" value="<%=reserve_start%>" placeholder="시작날짜 입력"> ~ <label for="reserve_end" class="blind">종료날짜 선택</label><input type="text" name="reserve_end" id="reserve_end" disabled="disabled" value="<%=reserve_end%>" placeholder="종료날짜 입력">
				</p>
				<p class="magT10">2.
					<input type="text" name="reserve_start2" id="reserve_start2" disabled="disabled" value="<%=reserve_start2%>" placeholder="시작날짜 입력"> ~
					<input type="text" name="reserve_end2" id="reserve_end2" disabled="disabled" value="<%=reserve_end2%>" placeholder="종료날짜 입력">
				</p>
				-->
				<p class="fontsmall blue"> &#8251 체크하지 않을 경우 &ldquo;개방안함&rdquo;으로 표시됩니다. </p>
			</td>
		</tr> --%>
			<tr>
				<th scope="row">개방시간 설정</th>
				<td>
				<label class="dis_mo">개방시간 설정</label>
				<%
				String timeStr[] = {"00:00", "00:30", "01:00", "01:30", "02:00", "02:30", "03:00", "03:30", "04:00", "04:30", "05:00", "05:30"
						, "06:00", "06:30", "07:00", "07:30", "08:00", "08:30", "09:00", "09:30", "10:00", "10:30", "11:00", "11:30", "12:00"
						, "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00"
						, "19:30", "20:00", "20:30", "21:00", "21:30", "22:00", "22:30", "23:00", "23:30", "24:00"};
				String timeStr2[] = {"0000", "0030", "0100", "0130", "0200", "0230", "0300", "0330", "0400", "0430", "0500", "0530"
						, "0600", "0630", "0700", "0730", "0800", "0830", "0900", "0930", "1000", "1030", "1100", "1130", "1200"
						, "1230", "1300", "1330", "1400", "1430", "1500", "1530", "1600", "1630", "1700", "1730", "1800", "1830", "1900"
						, "1930", "2000", "2030", "2100", "2130", "2200", "2230", "2300", "2330", "2400"};
				%>
					<p class="inputBox">
						<%-- <input type="checkbox" name="date_type" id="date_type" value="평일"<%if("".equals(reserve_time1_1)){ %> disabled="disabled" <%}else{%> checked="checked" <%} %> > --%>
						<span class="date">평일</span>
						<span class="opt">
							오전
							<label for="reserve_time1_1" class="blind">시작시간 선택</label>
							<select name="reserve_time" id="reserve_time1_1" >
								<option value="">선택</option>
								<%
								for(int i=0; i<(timeStr.length/2)+1; i++){
								%>
									<option value="<%=timeStr2[i]%>" <%if(reserve_time1_1.equals(timeStr2[i])){ %> selected="selected" <%} %>><%=timeStr[i]%></option>
								<%} %>
							</select>
							~
							<label for="reserve_time1_2" class="blind">종료시간 선택</label>
							<select name="reserve_time" id="reserve_time1_2" >
								<option value="">선택</option>
								<%
								for(int i=0; i<(timeStr.length/2)+1; i++){
								%>
									<option value="<%=timeStr2[i]%>" <%if(reserve_time1_2.equals(timeStr2[i])){ %> selected="selected" <%} %>><%=timeStr[i]%></option>
								<%} %>
							</select>
							,<br class="dis_mo" />
							오후
							<label for="reserve_time1_3" class="blind">시작시간 선택</label>
							<select name="reserve_time" id="reserve_time1_3" >
								<option value="">선택</option>
								<%
								for(int i=timeStr.length/2; i<timeStr.length; i++){
								%>
									<option value="<%=timeStr2[i]%>" <%if(reserve_time1_3.equals(timeStr2[i])){ %> selected="selected" <%} %>><%=timeStr[i]%></option>
								<%} %>
							</select>
							~
							<label for="reserve_time1_4" class="blind">종료시간 선택</label>
							<select name="reserve_time" id="reserve_time1_4" >
								<option value="">선택</option>
								<%
								for(int i=timeStr.length/2; i<timeStr.length; i++){
								%>
									<option value="<%=timeStr2[i]%>" <%if(reserve_time1_4.equals(timeStr2[i])){ %> selected="selected" <%} %>><%=timeStr[i]%></option>
								<%} %>
							</select>
						</span>
					</p>

					<p class="inputBox">
						<%-- <input type="checkbox" name="date_type" id="date_type2" value="토요일" <%if("".equals(reserve_time2_1)){ %> disabled="disabled" <%}else{%> checked="checked" <%} %> > --%>
						<!-- <label for="date_type2">토요일</label> -->
						<span class="date">토요일</span>
						<span class="opt">
							오전
							<label for="reserve_time2_1" class="blind">시작시간 선택</label>
							<select name="reserve_time" id="reserve_time2_1" >
								<option value="">선택</option>
								<%
								for(int i=0; i<(timeStr.length/2)+1; i++){
								%>
									<option value="<%=timeStr2[i]%>" <%if(reserve_time2_1.equals(timeStr2[i])){ %> selected="selected" <%} %>><%=timeStr[i]%></option>
								<%} %>
							</select>
							~
							<label for="reserve_time2_2" class="blind">종료시간 선택</label>
							<select name="reserve_time" id="reserve_time2_2" >
								<option value="">선택</option>
								<%
								for(int i=0; i<(timeStr.length/2)+1; i++){
								%>
									<option value="<%=timeStr2[i]%>" <%if(reserve_time2_2.equals(timeStr2[i])){ %> selected="selected" <%} %>><%=timeStr[i]%></option>
								<%} %>
							</select>
							,<br class="dis_mo" />
							오후
							<label for="reserve_time2_3" class="blind">시작시간 선택</label>
							<select name="reserve_time" id="reserve_time2_3" >
								<option value="">선택</option>
								<%
								for(int i=timeStr.length/2; i<timeStr.length; i++){
								%>
									<option value="<%=timeStr2[i]%>" <%if(reserve_time2_3.equals(timeStr2[i])){ %> selected="selected" <%} %>><%=timeStr[i]%></option>
								<%} %>
							</select>
							~
							<label for="reserve_time2_4" class="blind">종료시간 선택</label>
							<select name="reserve_time" id="reserve_time2_4" >
								<option value="">선택</option>
								<%
								for(int i=timeStr.length/2; i<timeStr.length; i++){
								%>
									<option value="<%=timeStr2[i]%>" <%if(reserve_time2_4.equals(timeStr2[i])){ %> selected="selected" <%} %>><%=timeStr[i]%></option>
								<%} %>
							</select>
						</span>
					</p>
					<p class="inputBox">
						<%-- <input type="checkbox" name="date_type" id="date_type3" value="일요일" <%if("".equals(reserve_time3_1)){ %> disabled="disabled" <%}else{%> checked="checked" <%} %>> --%>
						<!-- <label for="date_type3">일요일</label> -->
						<span class="date">일요일</span>
						<span class="opt">
							오전
							<label for="reserve_time3_1" class="blind">시작시간 선택</label>
							<select name="reserve_time" id="reserve_time3_1" >
								<option value="">선택</option>
								<%
								for(int i=0; i<(timeStr.length/2)+1; i++){
								%>
									<option value="<%=timeStr2[i]%>" <%if(reserve_time3_1.equals(timeStr2[i])){ %> selected="selected" <%} %>><%=timeStr[i]%></option>
								<%} %>
							</select>
							~
							<label for="reserve_time3_2" class="blind">종료시간 선택</label>
							<select name="reserve_time" id="reserve_time3_2" >
								<option value="">선택</option>
								<%
								for(int i=0; i<(timeStr.length/2)+1; i++){
								%>
									<option value="<%=timeStr2[i]%>" <%if(reserve_time3_2.equals(timeStr2[i])){ %> selected="selected" <%} %>><%=timeStr[i]%></option>
								<%} %>
							</select>
							,<br class="dis_mo" />
							오후
							<label for="reserve_time3_3" class="blind">시작시간 선택</label>
							<select name="reserve_time" id="reserve_time3_3" >
								<option value="">선택</option>
								<%
								for(int i=timeStr.length/2; i<timeStr.length; i++){
								%>
									<option value="<%=timeStr2[i]%>" <%if(reserve_time3_3.equals(timeStr2[i])){ %> selected="selected" <%} %>><%=timeStr[i]%></option>
								<%} %>
							</select>
							~
							<label for="reserve_time3_4" class="blind">종료시간 선택</label>
							<select name="reserve_time" id="reserve_time3_4" >
								<option value="">선택</option>
								<%
								for(int i=timeStr.length/2; i<timeStr.length; i++){
								%>
									<option value="<%=timeStr2[i]%>" <%if(reserve_time3_4.equals(timeStr2[i])){ %> selected="selected" <%} %>><%=timeStr[i]%></option>
								<%} %>
							</select>
						</span>
					</p>
					<p class="fontsmall blue">&#42; 미선택 시 "개방안함" 으로 표시됩니다.</p>
				</td>
			</tr>
			<tr>
				<th scope="row">옵션사용</th>
				<td>
					<label class="dis_mo">옵션사용</label>
					<span id="addOpt" class="btn small mako edge">옵션 추가 &plus;</span> <span class="fontsmall blue">&#42; 시설 특성에 맞는 가산금액 옵션을 추가할 수 있습니다.</span>

					<table id="addOptTbl" class="tb_board wps_90 magB5">
						<caption>가산옵션 추가 입력 표입니다.</caption>
						<colgroup>
							<col class="" />
							<col class="wps_30" />
							<col class="wps_20" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">항목</th>
								<th scope="col">금액(%/&#x20a9)</th>
								<th scope="col">삭제 </th>
							</tr>
						</thead>
						<tbody>

						<%
						if(optionList !=null && optionList.size() >0 ){
							for(int i=0; i<optionList.size(); i++){
								Map<String,Object> map = optionList.get(i);
								option_title = map.get("OPTION_TITLE").toString();
								option_price = map.get("OPTION_PRICE").toString();
								option_price_unit = map.get("OPTION_PRICE_UNIT").toString();
						%>
							<tr id="tr<%=i+1%>">
								<td>
									<label><input type="checkbox" name="option_title" id="option_title<%=i+1%>" style="display: none;" checked='checked'></label>
									<label for="addOptTitle<%=i+1%>" class="blind">항목명</label><input type="text" id="addOptTitle<%=i+1%>" value="<%=option_title%>">
								</td>
								<td>
									<label><input type="checkbox" name="option_price" id="option_price<%=i+1%>" style="display: none;" checked='checked'></label>
									<label for="addOptPrice<%=i+1%>" class="blind">금액</label>
									<input type='text' id='addOptPrice<%=i+1%>' value="<%=option_price%>" style="width: 50%;">
                                    <%/**
                                    *   PURPOSE :   단위 select 추가
                                    *   CREATE  :   20171116_thur   JI
                                    *   MODIFY  :   ....
                                    */%>
                                    <label><input type="checkbox" name="option_price_unit" id="option_price_unit<%=i+1%>" style="display: none;" checked='checked'></label>
									<select name="addOptPriceUnit" id="addOptPriceUnit<%=i+1%>">
									    <option value="%" <%if(option_price_unit.equals("%")) {out.println("selected=selected");} %> >%</option>
									    <option value="&#x20a9" <%if(option_price_unit.equals("？")) {out.println("selected=selected");} %> >&#x20a9</option>
									</select>
                                    <%/* END */%>
								</td>
								<td>
									<span onclick='delOpt("<%=i+1%>")' class="btn small edge white">삭제</span>
								</td>
							</tr>
						<%
							}
						}else{ if("insert".equals(command)){%>
							<tr id="tr1">
								<td>
									<label><input type="checkbox" name="option_title" id="option_title1" style="display: none;" checked='checked'></label>
									<label for="addOptTitle1" class="blind">항목명</label><input type="text" id="addOptTitle1" value="냉난방">
								</td>
								<td>
                                    <label><input type="checkbox" name="option_price" id="option_price1" style="display: none;" checked='checked'></label>
                                    <label for="addOptPrice1" class="blind">금액</label>
                                    <input type='text' id='addOptPrice1' value="20" style="width: 50%;">
                                    <%/**
                                    *   PURPOSE :   단위 select 추가
                                    *   CREATE  :   20171116_thur   JI
                                    *   MODIFY  :   ....
                                    */%>
                                    <label><input type="checkbox" name="option_price_unit" id="option_price_unit1" style="display: none;" checked='checked'></label>
                                    <select name="addOptPriceUnit" id="addOptPriceUnit1">
                                        <option value="%">%</option>
                                        <option value="&#x20a9">&#x20a9</option>
                                    </select>
                                    <%/* END */%>
								</td>
								<td><a href="javascript:;" onclick='delOpt("1")' class="btn edge small white">삭제</a> </td>
							</tr>
						<%} }%>
						</tbody>
					</table>
				</td>
			</tr>
			<tr id="etc_price" style="display: none;">
				<th scope="row">사용료</th>
				<td>
					<label class="dis_mo">사용료</label>
					<table class="tb_board wps_90">
						<caption>사용료 개별 입력 표입니다.</caption>
						<colgroup>
							<col />
							<col />
							<col />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">2시간까지</th>
								<th scope="col">2시간 초과 4시간 이하</th>
								<th scope="col">4시간 초과</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><label for="etc_price1" class="blind">2시간까지의 금액</label><input type="text" name="etc_price1" id="etc_price1" value="<%=etc_price1%>"></td>
								<td><label for="etc_price2" class="blind">2시간 초과 4시간 이하 금액</label><input type="text" name="etc_price2" id="etc_price2" value="<%=etc_price2%>"></td>
								<td><label for="etc_price3" class="blind">4시간 초과</label><input type="text" name="etc_price3" id="etc_price3" value="<%=etc_price3%>"></td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<th scope="row">특이사항</th>
				<td>
					<label for="reserve_etc" class="dis_mo">특이사항</label>
					<textarea rows="3" cols="5" class="wps_80" name="reserve_etc" id="reserve_etc"><%=reserve_etc %> </textarea>
				</td>
			</tr>
			<tr>
				<th scope="row">주의사항</th>
				<td>
					<label for="reserve_notice" class="dis_mo">주의사항</label>
					<textarea rows="3" cols="5" class="wps_80" name="reserve_notice" id="reserve_notice"><%=reserve_notice %> </textarea>
				</td>
			</tr>
			<tr>
				<th scope="row"><span class="red">*</span> 사진등록</th>
				<td>
					<label class="dis_mo"><span class="red">*</span> 사진등록</label>
					<label for="uploadfile" class="blind">업로드</label><input type="file" name="uploadfile" id="uploadfile" <%if(!"".equals(real_img)){%> style="display: none;" <%}%>>
					<label for="fileCheckVal" class="blind">파일선택</label><input type="hidden" name="fileCheckVal" id="fileCheckVal"  <%if(!"".equals(real_img)){%> value="Y" <%}else{%> value="N" <%} %>>
					<%if(!"".equals(real_img)){%>
						<span id="fileCheck"><%=save_img%> <span id="fileDel" class="btn edge small white magL5">삭제</span></span>
					<%}%>
				</td>
			</tr>
		</tbody>
	</table>
	<div class="btn_area c">
		<%
		if("insert".equals(command)){
		%>
			<button type="button" id="formSubmit" class="btn medium edge darkMblue">등록하기</button>
		<%}else if("update".equals(command)){ %>
			<button type="button" id="formSubmit" class="btn medium edge darkMblue">수정하기</button>
			<button type="button" id="roomDel" class="btn medium edge white">삭제하기</button>
		<%} %>
		<button type="button" onclick="location.href='/index.gne?menuCd=DOM_000001201007001001'" class="btn medium edge white">취소하기</button> 	<!-- 실서버 -->
		<!-- <button type="button" onclick="location.href='/index.gne?menuCd=DOM_000000106007001001'" class="btn medium edge white">취소하기</button> --> 	<!-- 테스트서버 -->
	</div>
</form>

<script>
$(function(){
	//파일 용량 10mb로 제한
	$("input[id=uploadfile").change(function(){
	    // 필드 채워지면
	    if($(this).val() != ""){
	    	//파일 검증
	        var fileName    =   $(this).val().split("\\")[$(this).val().split("\\").length -1];
	        var fileExtName =   $(this).val().split(".")[$(this).val().split(".").length -1];
	        fileExtName     =   fileExtName.toLowerCase();
	        if ($.inArray(fileExtName, ['jpg', 'png', 'gif', 'jpeg']) == -1) {
	            alert ("이미지 파일 형식을 확인하여 주시기 바랍니다.\njpg, png, gif, jpeg 파일만 등록 가능합니다.");
	            $(this).val("");
	            return;
	        }
	    	
            // 용량 체크
            var fileSize = this.files[0].size;
            var maxSize = 1024 * 1024 * 10;
            if(fileSize > maxSize){
                alert("10mb 이하의 이미지 파일을 선택하여 주시기 바랍니다.");
                $(this).val("");
            }
	    }
	});
	
	//옵션 추가
	$("#addOpt").click(function(){
		var row = $("#addOptTbl tr").length;
		var value = "";

		if(row == 0){
			value += "<thead>";
			value += "<tr>";
			value += "<th scope='col'>항목</th><th scope='col'>금액(%/&#x20a9)</th><th scope='col'>삭제</th>";
			value += "<tr>";
			value += "</thead>";
			value += "<tr id='tr" + row + "'><td>";
			value += "<label><input type='checkbox' name='option_title' id='option_title"+ row +"' checked='checked' style='display: none;'></label>";
			value += "<label><input type='text' id='addOptTitle" + row + "'></label>";
			value += "</td>";
			value += "<td>";
			value += "<label><input type='checkbox' name='option_price' id='option_price"+ row +"' checked='checked' style='display: none;'></label>";
			value += "<label><input type='text' id='addOptPrice" + row + "' style='width: 50%;'></label>";
            <%/**
            *   PURPOSE :   단위 select 추가
            *   CREATE  :   20171116_thur   JI
            *   MODIFY  :   ....
            */%>
            value += "<label><input type=\"checkbox\" name=\"option_price_unit\" id=\"option_price_unit"+ row +"\" style=\"display: none;\" checked='checked'></label>";
            value += "<select name=\"addOptPriceUnit" + row + "\" id=\"addOptPriceUnit" + row + "\">";
            value += "<option value=\"%\">%</option><option value=\"&#x20a9\">&#x20a9</option>";
            value += "</select>"
            <%/* END */%>
			value += "</td>";
			value += "<td>";
			value += "<span onclick='delOpt(\"" + row + "\")' class='btn edge small white'>삭제</span>";
			value += "</td></tr>";
		}else{
			value += "<tr id='tr" + row + "'><td>";
			value += "<label><input type='checkbox' name='option_title' id='option_title"+ row +"' checked='checked' style='display: none;'></label>";
			value += "<label><input type='text' id='addOptTitle" + row + "'></label>";
			value += "</td>";
			value += "<td>";
			value += "<label><input type='checkbox' name='option_price' id='option_price"+ row +"' checked='checked' style='display: none;'></label>";
			value += "<label><input type='text' id='addOptPrice" + row + "' style='width: 50%;'></label>";
            <%/**
            *   PURPOSE :   단위 select 추가
            *   CREATE  :   20171116_thur   JI
            *   MODIFY  :   ....
            */%>
            value += "<label><input type=\"checkbox\" name=\"option_price_unit\" id=\"option_price_unit"+ row +"\" style=\"display: none;\" checked='checked'></label>";
            value += "<select name=\"addOptPriceUnit\" id=\"addOptPriceUnit" + row + "\">";
            value += "<option value=\"%\">%</option><option value=\"&#x20a9\">&#x20a9</option>";
            value += "</select>"
            <%/* END */%>
			value += "</td>";
			value += "<td>";
			value += "<span onclick='delOpt(\"" + row + "\")' class='btn edge small white'>삭제</span>";
			value += "</td></tr>";
		}
		$("#addOptTbl").append(value);
	});

	//숫자만 입력
	$("#reserve_max").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") );} );
	$("#reserve_group").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") );} );
	//전송 클릭 시 작성안한 필드 찾아내기
	$("#formSubmit").click(function(){
		var str = "";
		var command = $("#command").val();


		if($("#reserve_time1_1").val() == "" && $("#reserve_time1_2").val() == "" &&
				$("#reserve_time1_3").val() == "" && $("#reserve_time1_4").val() == "" &&
				$("#reserve_time2_1").val() == "" && $("#reserve_time2_2").val() == "" &&
				$("#reserve_time2_3").val() == "" && $("#reserve_time2_4").val() == "" &&
				$("#reserve_time3_1").val() == "" && $("#reserve_time3_2").val() == "" &&
				$("#reserve_time3_3").val() == "" && $("#reserve_time3_4").val() == ""){
			str = "시간 미선택시 개방안함으로 설정됩니다. "
		}

		if(command == "insert"){
			str += "등록";
		}else{
			str += "수정";
		}

		var row = $("#addOptTbl tr").length;
		for(var i=0; i<row; i++){
			if($("#addOptTitle"+i).val() == ""){
				alert("옵션명을 입력하여 주시기 바랍니다.");
				$("#addOptTitle"+i).focus();
				return false;
			}else{
				$("#option_title"+i).val($("#addOptTitle"+i).val());
			}

			if($("#addOptPrice"+i).val() == ""){
				alert("금액을 입력하여 주시기 바랍니다.");
				$("#addOptPrice"+i).focus();
				return false;
			}else{
				$("#option_price"+i).val($("#addOptPrice"+i).val());
			}
            <%/**
            *   PURPOSE :   단위 select 추가
            *   CREATE  :   20171116_thur   JI
            *   MODIFY  :   ....
            */%>
            $("#option_price_unit"+i).val($("#option_price_unit"+i).val());
            <%/* END */%>
		}

		if(
				$("#reserve_time1_1").val() == "" && $("#reserve_time1_2").val() == "" &&
				$("#reserve_time1_3").val() == "" && $("#reserve_time1_4").val() == "" &&
				$("#reserve_time2_1").val() == "" && $("#reserve_time2_2").val() == "" &&
				$("#reserve_time2_3").val() == "" && $("#reserve_time2_4").val() == "" &&
				$("#reserve_time3_1").val() == "" && $("#reserve_time3_2").val() == "" &&
				$("#reserve_time3_3").val() == "" && $("#reserve_time3_4").val() == ""
		)
		{
			$("#reserve_use").val("N");
		}else{
			$("#reserve_use").val("Y");

		}

		/* if($("#reserve_use").is(":checked") == true){
			$("#reserve_use").val("Y");
		}else{
			$("#reserve_use").val("N");
		} */
		
		if($("#reserve_time1_1").val() > $("#reserve_time1_2").val()){
			alert('시작시간과 종료시간을 확인하여 주시기 바랍니다.');
			$("#reserve_time1_1").focus();
			return false;
		}else if($("#reserve_time1_3").val() > $("#reserve_time1_4").val()){
			alert('시작시간과 종료시간을 확인하여 주시기 바랍니다.');
			$("#reserve_time1_3").focus();
			return false;
		}else if($("#reserve_time2_1").val() >  $("#reserve_time2_2").val()){
			alert('시작시간과 종료시간을 확인하여 주시기 바랍니다.');
			$("#reserve_time2_1").focus();
			return false;
		}else if($("#reserve_time2_3").val() > $("#reserve_time2_4").val()){
			alert('시작시간과 종료시간을 확인하여 주시기 바랍니다.');
			$("#reserve_time2_3").focus();
			return false;
		}else if($("#reserve_time3_1").val() > $("#reserve_time3_2").val()){
			alert('시작시간과 종료시간을 확인하여 주시기 바랍니다.');
			$("#reserve_time3_1").focus();
			return false;
		}else if($("#reserve_time3_3").val() > $("#reserve_time3_4").val()){
			alert('시작시간과 종료시간을 확인하여 주시기 바랍니다.');
			$("#reserve_time3_3").focus();
			return false;
		}
		
		

		if($("#reserve_type").val() == ""){
			alert("시설종류를 입력하여 주시기 바랍니다.");
			return false;
		}else if($("#reserve_type").val() == "교실" && $("#reserve_group").val() == ""){
			alert("대여 시설 수를 입력하여 주시기 바랍니다.");
			$("#reserve_group").focus();
			return false;
		}
		else if(
			($("#reserve_time1_1").val() == "" && $("#reserve_time1_2").val() != "")
			||($("#reserve_time1_3").val() == "" && $("#reserve_time1_4").val() != "")
			||($("#reserve_time2_1").val() == "" && $("#reserve_time2_2").val() != "")
			||($("#reserve_time2_3").val() == "" && $("#reserve_time2_4").val() != "")
			||($("#reserve_time3_1").val() == "" && $("#reserve_time3_2").val() != "")
			||($("#reserve_time3_3").val() == "" && $("#reserve_time3_4").val() != "")
		){
			alert("시작시간을 선택하여 주시기 바랍니다.")
		}
		else if(
			($("#reserve_time1_1").val() != "" && $("#reserve_time1_2").val() == "")
			||($("#reserve_time1_3").val() != "" && $("#reserve_time1_4").val() == "")
			||($("#reserve_time2_1").val() != "" && $("#reserve_time2_2").val() == "")
			||($("#reserve_time2_3").val() != "" && $("#reserve_time2_4").val() == "")
			||($("#reserve_time3_1").val() != "" && $("#reserve_time3_2").val() == "")
			||($("#reserve_time3_3").val() != "" && $("#reserve_time3_4").val() == "")
		){
			alert("종료시간을 선택하여 주시기 바랍니다.")
		}
		else if($("#reserve_type").val() == "기타시설" && $.trim($("#reserve_type2").val()) == ""){
			alert("시설종류를 입력하여 주시기 바랍니다.");
			$("#reserve_type2").focus();
			return false;
		}else if($("#reserve_type").val() == "기타시설" && $.trim($("#etc_price1").val()) == ""){
			alert("시설 사용료를 입력하여 주시기 바랍니다.");
			$("#etc_price1").focus();
			return false;
		}else if($("#reserve_type").val() == "기타시설" && $.trim($("#etc_price2").val()) == ""){
			alert("시설 사용료를 입력하여 주시기 바랍니다.");
			$("#etc_price2").focus();
			return false;
		}else if($("#reserve_type").val() == "기타시설" && $.trim($("#etc_price3").val()) == ""){
			alert("시설 사용료를 입력하여 주시기 바랍니다.");
			$("#etc_price3").focus();
			return false;
		}else if($.trim($("#reserve_max").val()) == ""){
			alert("이용가능 인원을 입력하여 주시기 바랍니다.");
			$("#reserve_max").focus();
			return false;
		}
		else if($("#command").val() == "insert" &&  $.trim($("#uploadfile").val()) == ""){
			alert("시설 이미지를 등록하여 주시기 바랍니다.");
			return false;
		}
		else if($("#command").val() == "update" && $.trim($("#save_img_check").val()) == "" && $.trim($("#uploadfile").val()) == ""){
			alert("시설 이미지를 등록하여 주시기 바랍니다.");
			return false;
		}
		else{
			console.log($("#addOptPriceUnit1").val());
			if(confirm(str+" 하시겠습니까")){
				if(command == "insert"){
					$("#reserveForm").attr("action", "/program/school_reserve/actionWae.jsp");
				}else if(command == "update"){
					$("#reserveForm").attr("action", "/program/school_reserve/room_update.jsp");
				}
				$("#reserveForm").submit();
			}else{
				return false;
			}


		}

	});

	$("#addOptPrice1").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") );} );
	$("#etc_price1").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") );} );
	$("#etc_price2").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") );} );
	$("#etc_price3").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") );} );


	//첨부파일 삭제
	$("#fileDel").click(function(){
		var room_id = $("#room_id").val();
		var str = {
				"room_id" : room_id
			}
			$.ajax({
				url : '/program/school_reserve/fileDel.jsp',
				data : str,
				success : function(data) {
					$("#uploadfile").css("display", "block");
					$("#fileCheck").remove();
					$("#fileCheckVal").val("N");
					$("#save_img_check").val("");
				},
				error : function(e) {
					alert("에러발생");
				}
			});


	});

	//시설 삭제
	$("#roomDel").click(function(){
		var room_id = $("#room_id").val();
		if(confirm("모든 데이터(통계 포함)가 삭제됩니다. \n삭제하시겠습니까?")){
			$("#postForm").attr("action", "/program/school_reserve/roomDel.jsp?room_id="+room_id);
			$("#postForm").submit();
		}else{
			return false;
		}
	});

	if($("#reserve_type").val() == "기타시설"){
		$(".reserve_type2").css("display", "");
		$("#reserve_type2").removeAttr('disabled');
		$("#etc_price").css("display", "");
	}else{
		$(".reserve_type2").css("display", "none");
		$("#reserve_type2").prop('disabled', 'true');
		$("#etc_price").css("display", "none");
	}

	if($("#reserve_type").val() == "교실"){
		$(".reserve_group").css("display", "");
		$("#reserve_group").removeAttr('disabled');
	}else{
		$(".reserve_group").css("display", "none");
		$("#reserve_group").prop('disabled', 'true');
	}

});

function reserve_type_change(val){
	if(val == "기타시설"){
		$(".reserve_type2").css("display", "");
		$("#reserve_type2").removeAttr('disabled');
		$("#etc_price").css("display", "");
	}else{
		$(".reserve_type2").css("display", "none");
		$("#reserve_type2").prop('disabled', 'true');
		$("#etc_price").css("display", "none");
	}

	if(val == "교실"){
		$(".reserve_group").css("display", "");
		$("#reserve_group").removeAttr('disabled');
	}else{
		$(".reserve_group").css("display", "none");
		$("#reserve_group").prop('disabled', 'true');
	}


}

//옵션 삭제
function delOpt(row){
	$("#addOptTbl #tr"+row).remove();

	var length = $("#addOptTbl tr").length;
	if(length == 1){
		$("#addOptTbl thead").remove();
	}
}
</script>