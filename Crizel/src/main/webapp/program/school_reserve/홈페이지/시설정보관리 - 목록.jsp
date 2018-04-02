<%@ include file="/program/class/UtilClass.jsp" %>
<%@ include file="/program/class/PagingClass.jsp" %>
<%@ page import="java.text.ParseException"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.text.DateFormat"%>
<%@ page import="java.util.Date"%>
<%!
public String getDateDay(String date, String dateType) throws Exception {
    String day = "" ;
    SimpleDateFormat dateFormat = new SimpleDateFormat(dateType) ;
    Date nDate = dateFormat.parse(date) ;
    Calendar cal = Calendar.getInstance() ;
    cal.setTime(nDate);
    int dayNum = cal.get(Calendar.DAY_OF_WEEK) ;
    switch(dayNum){
        case 1: day = "일"; break ;
        case 2: day = "평일"; break ;
        case 3: day = "평일"; break ;
        case 4: day = "평일"; break ;
        case 5: day = "평일"; break ;
        case 6: day = "평일"; break ;
        case 7: day = "토"; break ;
    }
    return day ;
}
%>
<%
//String schoolInfoPage = "DOM_000001201007003000";			//학교정보
String schoolInfoPage = "DOM_000000106007003000";			//테스트서버

//String writePage = "DOM_000001201007001002";				//시설등록
String writePage = "DOM_000000106007001003";				//테스트서버

//String longWritePage = "DOM_000001201007005001";			//장기예약 등록
String longWritePage = "DOM_000000106007005001";			//테스트서버

//String infoPage = "DOM_000001201003001001";				//시설예약 - 선택
String infoPage = "DOM_000000106003001001";					//테스트서버

//String roomInfoPage = "DOM_000001201007001003";			//시설상세보기
String roomInfoPage = "DOM_000000106007001005";				//테스트서버



Calendar cal = Calendar.getInstance();

String nowYear = "";
String nowMonth = "";
String nowDay = "";
String date2 = "";

nowYear = Integer.toString(cal.get(Calendar.YEAR));
if(cal.get(Calendar.MONTH)+1 < 10){
	nowMonth = "0" + Integer.toString(cal.get(Calendar.MONTH)+1);
}else{
	nowMonth = Integer.toString(cal.get(Calendar.MONTH)+1);
}
if(cal.get(Calendar.DATE) < 10){
	nowDay = "0" + Integer.toString(cal.get(Calendar.DATE));
}else{
	nowDay = Integer.toString(cal.get(Calendar.DATE));
}

date2 = nowYear + "-" + nowMonth + "-" + nowDay;

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;
List<Map<String, Object>> dataList = null;
List<Map<String, Object>> useAbleList = null;
List<Map<String, Object>> useAbleListBan = null;

String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
Paging paging = new Paging();


String school_id = parseNull(request.getParameter("school_id"));
String room_id = "";
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
String reserve_start = "";
String reserve_end = "";
String time1_1 = "";
String time1_2 = "";
String time1_3 = "";
String time1_4 = "";
String time2_1 = "";
String time2_2 = "";
String time2_3 = "";
String time2_4 = "";
String time3_1 = "";
String time3_2 = "";
String time3_3 = "";
String time3_4 = "";
String all_open = "";

boolean id_check = false;
String charge_id = parseNull(request.getParameter("charge_id"));
if(!"".equals(sm.getId())){
	charge_id = sm.getId();
}

if("gne_ksis00".equals(charge_id)){
	//charge_id = "m_17191";
}

boolean sc_approval_check = false;
boolean all_time_check = false;

int key = 0;

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	//로그인 한 아이디의 학교 번호 찾기
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_SCHOOL WHERE CHARGE_ID = ? AND SCHOOL_APPROVAL = 'Y' ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, charge_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		school_id = rs.getString("SCHOOL_ID");
		id_check = true;
	}
	
	
	
	//학교정보 등록은 했지만 아직 승인나지 않았을 경우를 찾는다
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_SCHOOL WHERE CHARGE_ID = ? AND SCHOOL_APPROVAL != 'Y' ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, charge_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		sc_approval_check = true;
	}
	
	


	sql = new StringBuffer();
	sql.append("SELECT COUNT(*) AS CNT FROM RESERVE_ROOM WHERE SCHOOL_ID = ? ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		totalCount = rs.getInt("CNT");
	}
	
	


	sql = new StringBuffer();
	sql.append("SELECT SCHOOL_ID, ROOM_ID, RESERVE_TYPE, RESERVE_TYPE2, RESERVE_AREA, RESERVE_NUMBER, RESERVE_MAX, RESERVE_ETC, RESERVE_NOTICE, SAVE_IMG, DIRECTORY, 	 ");
	sql.append("	(SELECT RESERVE_TYPE FROM RESERVE_DATE WHERE RESERVE_TYPE = 'A' AND ROOM_ID = RR.ROOM_ID GROUP BY RESERVE_TYPE) ALL_OPEN ");
	sql.append("FROM RESERVE_ROOM RR WHERE SCHOOL_ID = ? ORDER BY ROOM_ID DESC		 ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(1, school_id);
	rs = pstmt.executeQuery();
	dataList = getResultMapRows(rs);
	
	//paging.setParams("search1", search1);
	//paging.setPageNo(Integer.parseInt(pageNo));
	//paging.setTotalCount(totalCount);
	//paging.setPageSize(10);
	//paging.setPageBlock(10);

} catch (Exception e) {
	%>
	<%=e.toString() %>
	<%
/*
	e.printStackTrace();
	sqlMapClient.endTransaction();
	alertBack(out, "처리중 오류가 발생하였습니다."); */
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
}
if(id_check){
%>
<script>
function selDel(){
	if(confirm("모든 데이터(통계 포함)가 삭제됩니다. \n삭제하시겠습니까?")){
		$("#postForm").attr("action", "/program/school_reserve/roomDel.jsp");
		$("#postForm").submit();
	}else{
		return false;
	}
}

function roomReg(){
	$("#postForm").attr("action", "/index.gne?menuCd=<%=writePage%>").submit();
}

function roomEdit(room_id){
	$("#command").val("update");
	$("#room_id").val(room_id);
	$("#postForm").attr("action", "/index.gne?menuCd=<%=writePage%>").submit();
}
</script>
<form action="" method="post" id="postForm">
<input type="hidden" name="pageNo" value="<%=pageNo%>">
<input type="hidden" name="school_id" value="<%=school_id%>">
<input type="hidden" name="command" id="command" value="insert">
<input type="hidden" name="room_id" id="room_id">

<section class="sch_faciList">
	<h3>학교시설물 목록</h3>
	<ul class="list">
	<%
	if(dataList.size()>0){
	for(int i=0; i<dataList.size(); i++){
		time1_1 = "";
		time1_2 = "";
		time1_3 = "";
		time1_4 = "";
		time2_1 = "";
		time2_2 = "";
		time2_3 = "";
		time2_4 = "";
		time3_1 = "";
		time3_2 = "";
		time3_3 = "";
		time3_4 = "";
		Map<String, Object> map = dataList.get(i);
		school_id = parseNull(map.get("SCHOOL_ID").toString());
		room_id = parseNull(map.get("ROOM_ID").toString());
		reserve_type = parseNull(map.get("RESERVE_TYPE").toString());
		reserve_type2 = parseNull(map.get("RESERVE_TYPE2").toString());
		reserve_area = parseNull(map.get("RESERVE_AREA").toString());
		reserve_number = parseNull(map.get("RESERVE_NUMBER").toString());
		reserve_max = parseNull(map.get("RESERVE_MAX").toString());
		reserve_etc = parseNull(map.get("RESERVE_ETC").toString());
		reserve_notice = parseNull(map.get("RESERVE_NOTICE").toString());
		save_img = parseNull(map.get("SAVE_IMG").toString());
		directory = parseNull(map.get("DIRECTORY").toString());
		all_open = parseNull(map.get("ALL_OPEN").toString());

		try {
			sqlMapClient.startTransaction();
			conn = sqlMapClient.getCurrentConnection();
			
			//개방일 및 개방시간
			sql = new StringBuffer();
			sql.append("SELECT * 	 ");
			sql.append("FROM RESERVE_DATE	 ");
			sql.append("WHERE SCHOOL_ID = ? AND ROOM_ID = ? AND RESERVE_GROUP = 0 AND ((DATE_END >= ? AND RESERVE_TYPE = 'B') OR RESERVE_TYPE = 'A') 	");
			sql.append("ORDER BY RESERVE_TYPE, DATE_START	 ");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, school_id);
			pstmt.setString(2, room_id);
			pstmt.setString(3, date2);
			rs = pstmt.executeQuery();
			useAbleList = getResultMapRows(rs);
			
			//개방불가일 및 개방불가시간
			sql = new StringBuffer();
			sql.append("SELECT * 	 ");
			sql.append("FROM RESERVE_BAN	 ");
			sql.append("WHERE SCHOOL_ID = ? AND ROOM_ID = ? AND DATE_END >= ? 	");
			sql.append("ORDER BY DATE_START	 ");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, school_id);
			pstmt.setString(2, room_id);
			pstmt.setString(3, date2);
			rs = pstmt.executeQuery();
			useAbleListBan = getResultMapRows(rs);

		} catch (Exception e) {
			%>
			<%=e.toString() %>
			<%
			e.printStackTrace();
			sqlMapClient.endTransaction();
			/*
			alertBack(out, "처리중 오류가 발생하였습니다."); */
		} finally {
			if (rs != null) try { rs.close(); } catch (SQLException se) {}
			if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
			if (conn != null) try { conn.close(); } catch (SQLException se) {}
			sqlMapClient.endTransaction();
		}

	%>
	 <li>
		 <dl>
			 <dt><span title="<%if(!"기타시설".equals(reserve_type)){%><%=reserve_type %><%}else{ %><%=reserve_type2 %><%} %>"><img src="<%=directory%><%=save_img%>" alt="<%if(!"기타시설".equals(reserve_type)){%><%=reserve_type %><%}else{ %><%=reserve_type2 %><%} %>" onError="this.onerror=null; this.src='/img/school/noimg.png'"></span>
<!-- 등록된 이미지 없을 때 이미지 노출 경로 
		<span title="등록된 사진이 없습니다."><img src="/img/school/noimg.png" alt="등록된 사진이 없습니다." /></span>
-->
</dt>
			 <dd>
				<%if(!"기타시설".equals(reserve_type)){%>
					<h4><%=reserve_type %></h4>
				<%}else{ %>
					<h4><%=reserve_type2 %></h4>
				<%} %>

					<table class="tbl_gray magT10">
						<caption> 해당학교의 시설물 상세 내용입니다. </caption>
						<colgroup>
							<col class="">
							<col class="wps_20">
							<col class="wps_20">
							<col class="wps_20">
							<col class="wps_20">
							<col class="wps_20">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">면적</th>
								<td><%=reserve_area %> m&sup2;</td>
								<th scope="row">대여시설 수</th>
								<td><%=reserve_number %> 개</td>
								<th scope="row">최대수용인원</th>
								<td><%=reserve_max%> 명</td>
							</tr>
							<tr>
									<th scope="row">개방일 및 개방시간</th>
									<td colspan="5">
								<%
								if(useAbleList!=null && useAbleList.size()>0){	
									boolean dayCheck1 = false;		//시작날짜와 종료날짜 사이에 평일이 있는지 확인하는 변수
									boolean dayCheck2 = false;		//시작날짜와 종료날짜 사이에 토요일이 있는지 확인하는 변수
									boolean dayCheck3 = false;		//시작날짜와 종료날짜 사이에 일요일이 있는지 확인하는 변수
								%>
										<ul>
										<%
										for(int k=0; k<useAbleList.size(); k++){
											Map<String,Object> map2 = useAbleList.get(k);
											
											dayCheck1 = false;
											dayCheck2 = false;
											dayCheck3 = false;
											
											String s1=map2.get("DATE_START").toString();
											String s2=map2.get("DATE_END").toString();
											DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
											SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
											try{
												Date d1 = df.parse( s1 );
												Date d2 = df.parse( s2 );
												Calendar c1 = Calendar.getInstance();
												Calendar c2 = Calendar.getInstance();
												//Calendar 타입으로 변경 add()메소드로 1일씩 추가해 주기위해 변경
												c1.setTime( d1 );
												c2.setTime( d2 );
												while( c1.compareTo( c2 ) !=1 ){
													if("평일".equals(getDateDay(sdf.format(c1.getTime()), "yyyy-MM-dd"))){
														dayCheck1 = true;
													}else if("토".equals(getDateDay(sdf.format(c1.getTime()), "yyyy-MM-dd"))){
														dayCheck2 = true;
													}else if("일".equals(getDateDay(sdf.format(c1.getTime()), "yyyy-MM-dd"))){
														dayCheck3 = true;
													}
													
													//시작날짜 + 1 일
													c1.add(Calendar.DATE, 1);
												}
											}catch(ParseException e){
												e.printStackTrace();
											}
										%>
											<li>
												<%if("".equals( parseNull(map2.get("DATE_START").toString()))){%>
													<%
													if(!"".equals( parseNull(map2.get("TIME_START_A").toString())) ||
														!"".equals( parseNull(map2.get("TIME_START_B").toString()))||
														!"".equals( parseNull(map2.get("TIME_START_C").toString()))){%>
														<strong>항시개방</strong>												
													<%
														if(!"".equals( parseNull(map2.get("TIME_START_A").toString()))){
															dayCheck1 = true;
														}
														if(!"".equals( parseNull(map2.get("TIME_START_B").toString()))){
															dayCheck2 = true;
														}
														if(!"".equals( parseNull(map2.get("TIME_START_C").toString()))){
															dayCheck3 = true;
														}
													} %>
													
												<%}else{%>
													<strong><%=map2.get("DATE_START").toString()%> ~ <%=map2.get("DATE_END").toString() %></strong>
												<%}%>
												
												<%if(!"".equals( parseNull(map2.get("TIME_START_A").toString())) && dayCheck1){%>
													<span>평일 : <%=timeSet(map2.get("TIME_START_A").toString())%> ~ <%=timeSet(map2.get("TIME_END_A").toString()) %>
													<%if(!"".equals( parseNull(map2.get("TIME_START_A2").toString()))){%>
													, <%=timeSet(map2.get("TIME_START_A2").toString())%> ~ <%=timeSet(map2.get("TIME_END_A2").toString()) %>
													<%} %>
													</span>
												<%}%>
												
												<%if(!"".equals( parseNull(map2.get("TIME_START_B").toString())) && dayCheck2){%>
													<span>토요일 : <%=timeSet(map2.get("TIME_START_B").toString())%> ~ <%=timeSet(map2.get("TIME_END_B").toString()) %>
													<%if(!"".equals( parseNull(map2.get("TIME_START_B2").toString()))){%>
													, <%=timeSet(map2.get("TIME_START_B2").toString())%> ~ <%=timeSet(map2.get("TIME_END_B2").toString()) %>
													<%} %>
													</span>
												<%}%>
												
												<%if(!"".equals( parseNull(map2.get("TIME_START_C").toString())) && dayCheck3){%>
													<span>일요일 : <%=timeSet(map2.get("TIME_START_C").toString())%> ~ <%=timeSet(map2.get("TIME_END_C").toString()) %>
													<%if(!"".equals( parseNull(map2.get("TIME_START_C2").toString()))){%>
													, <%=timeSet(map2.get("TIME_START_C2").toString())%> ~ <%=timeSet(map2.get("TIME_END_C2").toString()) %>
													<%} %>
													</span>
												<%}%>
												
											</li>
											<%} %>
										
											<%
											for(int k=0; k<useAbleListBan.size(); k++){
												Map<String,Object> map2 = useAbleListBan.get(k);
												
												dayCheck1 = false;
												dayCheck2 = false;
												dayCheck3 = false;
												
												String s1=map2.get("DATE_START").toString();
												String s2=map2.get("DATE_END").toString();
												DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
												SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
												try{
													Date d1 = df.parse( s1 );
													Date d2 = df.parse( s2 );
													Calendar c1 = Calendar.getInstance();
													Calendar c2 = Calendar.getInstance();
													//Calendar 타입으로 변경 add()메소드로 1일씩 추가해 주기위해 변경
													c1.setTime( d1 );
													c2.setTime( d2 );
													while( c1.compareTo( c2 ) !=1 ){
														if("평일".equals(getDateDay(sdf.format(c1.getTime()), "yyyy-MM-dd"))){
															dayCheck1 = true;
														}else if("토".equals(getDateDay(sdf.format(c1.getTime()), "yyyy-MM-dd"))){
															dayCheck2 = true;
														}else if("일".equals(getDateDay(sdf.format(c1.getTime()), "yyyy-MM-dd"))){
															dayCheck3 = true;
														}
														//시작날짜 + 1 일
														c1.add(Calendar.DATE, 1);
													}
												}catch(ParseException e){
													e.printStackTrace();
												}
											%>
												<li>
													<%if("".equals( parseNull(map2.get("DATE_START").toString()))){%>
														<%if(!"".equals( parseNull(map2.get("TIME_START_A").toString())) ||
															!"".equals( parseNull(map2.get("TIME_START_B").toString()))||
															!"".equals( parseNull(map2.get("TIME_START_C").toString()))){%>
															<strong>항시개방</strong>												
														<%} %>
														
													<%}else{%>
														<strong><%=map2.get("DATE_START").toString()%> ~ <%=map2.get("DATE_END").toString() %> (개방불가)</strong>
													<%}%>
													
													<%if(!"".equals( parseNull(map2.get("TIME_START_A").toString())) && dayCheck1){%>
														<span>평일 : <%=timeSet(map2.get("TIME_START_A").toString())%> ~ <%=timeSet(map2.get("TIME_END_A").toString()) %>
														<%if(!"".equals( parseNull(map2.get("TIME_START_A2").toString()))){%>
														, <%=timeSet(map2.get("TIME_START_A2").toString())%> ~ <%=timeSet(map2.get("TIME_END_A2").toString()) %>
														<%} %>
														</span>
													<%}%>
													
													<%if(!"".equals( parseNull(map2.get("TIME_START_B").toString())) && dayCheck2){%>
														<span>토요일 : <%=timeSet(map2.get("TIME_START_B").toString())%> ~ <%=timeSet(map2.get("TIME_END_B").toString()) %>
														<%if(!"".equals( parseNull(map2.get("TIME_START_B2").toString()))){%>
														, <%=timeSet(map2.get("TIME_START_B2").toString())%> ~ <%=timeSet(map2.get("TIME_END_B2").toString()) %>
														<%} %>
														</span>
													<%}%>
													
													<%if(!"".equals( parseNull(map2.get("TIME_START_C").toString())) && dayCheck3){%>
														<span>일요일 : <%=timeSet(map2.get("TIME_START_C").toString())%> ~ <%=timeSet(map2.get("TIME_END_C").toString()) %>
														<%if(!"".equals( parseNull(map2.get("TIME_START_C2").toString()))){%>
														, <%=timeSet(map2.get("TIME_START_C2").toString())%> ~ <%=timeSet(map2.get("TIME_END_C2").toString()) %>
														<%} %>
														</span>
													<%}%>
													
												</li>
												<%} %>
											
										</ul>		
								<%
								}
								%>
									
									</td>
								</tr>
							<tr>
								<th scope="row">특이사항</th>
								<td colspan="5"><%if("".equals(reserve_etc)){%>내용없음<%}else{%><%=reserve_etc.replace("\r\n", "<br>") %><%}%></td>
							</tr>
							<tr>
								<th scope="row">주의사항</th>
								<td colspan="5"><%if("".equals(reserve_notice)){%>내용없음<%}else{%><%=reserve_notice.replace("\r\n", "<br>") %><%}%></td>
							</tr>
						</tbody>
					</table>

				<div class="btn_area">
					<button type="button" onclick="location.href='/index.gne?menuCd=<%=longWritePage%>&school_id=<%=school_id%>&room_id=<%=room_id%>'" class="btn edge small green">장기예약등록</button>
					<button type="button"  onclick="location.href='/index.gne?menuCd=<%=infoPage %>&school_id=<%=school_id%>&room_id=<%=room_id%>'" class="btn edge small mako">단기예약등록</button>
					<button type="button" onclick="location.href='/index.gne?menuCd=<%=roomInfoPage%>&school_id=<%=school_id%>&room_id=<%=room_id%>'" class="btn edge small darkMblue">설정변경</button>
				</div>
			 </dd>
		 </dl>
	 </li>
	 <%}} %>
</seciton>
<div class="btn_area c">
	<button type="button" onclick="roomReg()" class="btn edge medium darkMblue">등록하기</button>
</div>

<%}else{
	
	
	if(sc_approval_check){		//학교 등록은 ？으나 아직 승인되지 않았을 때
%>
	<script>
	$(function(){
		alert("승인대기중입니다. 관리자 승인 완료 후 해당 메뉴를 이용하여 주시기 바랍니다. 문의전화 : 도교육청 재정과 268-1483");
		location.href="/index.gne?menuCd=<%=schoolInfoPage%>";
	});
	</script>	
<%		
	}else{						//학교등록이 안되있을때
%>
	<script>
	$(function(){
		alert("학교정보가 등록되지 않았습니다. 등록한 후 승인이 되면 사용 가능합니다.");
		location.href="/index.gne?menuCd=<%=schoolInfoPage%>";
	});
	</script>
<%		
	}
%>

<!-- <div class="topbox2 c">학교정보가 등록되지 않았거나 승인되지 않았습니다.</div> -->
<%} %>
</form>