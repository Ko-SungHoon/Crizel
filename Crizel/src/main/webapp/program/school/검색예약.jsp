<%@ include file="/program/class/UtilClass.jsp" %>
<%@ include file="/program/class/PagingClass.jsp" %>
<%!
private class reserveVO{
	public int school_id;
	public String school_name;
	public String school_area;
	public String school_addr;
	public String school_tel;
	public String school_url;
	public String charge_dept;
	public String dept_tel;
	public String charge_name;
	public String charge_phone;
	public String account;
	public String area_type;
	public String charge_id;
	public String school_approval;
	public String sch_approval_date;
	public String charge_name2;
	
	public String reserve_type;
}

private class schoolList implements RowMapper<reserveVO> {
    public reserveVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	reserveVO vo = new reserveVO();
        vo.school_id			=	rs.getInt("SCHOOL_ID");
        vo.school_name			=	rs.getString("SCHOOL_NAME");
        vo.school_area			=	rs.getString("SCHOOL_AREA");
        vo.school_addr			=	rs.getString("SCHOOL_ADDR");
        vo.reserve_type			=	rs.getString("RESERVE_TYPE");
        vo.school_tel			=	rs.getString("SCHOOL_TEL");
        return vo;
    }
}

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

public boolean isMobile(HttpServletRequest request) {
	String userAgent = request.getHeader("user-agent");
	boolean mobile1 = userAgent.matches(".*(iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson).*");
	boolean mobile2 = userAgent.matches(".*(LG|SAMSUNG|Samsung).*");
	if(mobile1 || mobile2) {
		return true;
	}
	return false;
}
%>
<%
String InfoPage = "DOM_000000118001002000";

String menuCd			= parseNull(request.getParameter("menuCd"));
String reserve_date		= parseNull(request.getParameter("reserve_date"));
String school_area		= parseNull(request.getParameter("school_area"));
String school_name		= parseNull(request.getParameter("school_name"));
String[] reserve_type 	= request.getParameterValues("reserve_type");

StringBuffer sql 				= null;
List<reserveVO> schoolList	 	= null;
List<String> setList			= new ArrayList<String>();
Object[] setObj					= null;

Paging paging = new Paging();
paging.setPageSize(10);
String pageNo	=	parseNull(request.getParameter("pageNo"), "1");
int totalCount	=	0;
int num 		=	0;

try{
	sql = new StringBuffer();
	sql.append("SELECT	COUNT(*) CNT		 																");
	sql.append("FROM RESERVE_SCHOOL		 																	");
	sql.append("WHERE SCHOOL_APPROVAL = 'Y'	 																");
	if(!"".equals(school_name)){
	sql.append("AND SCHOOL_NAME LIKE '%'||?||'%'															");	
	setList.add(school_name);
	paging.setParams("school_name", school_name);
	}
	if(!"".equals(school_area)){
	sql.append("AND SCHOOL_AREA LIKE '%'||?||'%'															");
	setList.add(school_area);
	paging.setParams("school_area", school_area);
	}				
	if(!"".equals(reserve_date)){
	sql.append("AND 'Y' IN																					");
	sql.append("(SELECT 																					");
	sql.append("	DECODE(DATE_START, NULL, 																");
	sql.append("		CASE																				");
	sql.append("			WHEN 	TO_CHAR(TO_DATE(?), 'DAY') = '월요일' OR								");
	sql.append("					TO_CHAR(TO_DATE(?), 'DAY') = '화요일' OR 								");
	sql.append("					TO_CHAR(TO_DATE(?), 'DAY') = '수요일' OR 								");
	sql.append("					TO_CHAR(TO_DATE(?), 'DAY') = '목요일' OR 								");
	sql.append("					TO_CHAR(TO_DATE(?), 'DAY') = '금요일' 									");
	sql.append("			THEN																			");
	sql.append("				DECODE(TIME_START_A, NULL, 													");
	sql.append("					DECODE(TIME_START_A2, NULL, 'N', 'Y')									");
	sql.append("					,																		");
	sql.append("					'Y')																	");
	sql.append("			WHEN TO_CHAR(TO_DATE(?), 'DAY') = '토요일'										");
	sql.append("			THEN 																			");
	sql.append("				DECODE(TIME_START_B, NULL, 													");
	sql.append("					DECODE(TIME_START_B2, NULL, 'N', 'Y')									");
	sql.append("					, 																		");
	sql.append("					'Y')																	");
	sql.append("			WHEN TO_CHAR(TO_DATE(?), 'DAY') = '일요일'										");
	sql.append("			THEN																			");
	sql.append("				DECODE(TIME_START_C, NULL, 													");
	sql.append("					DECODE(TIME_START_C2, NULL, 'N', 'Y')									");
	sql.append("					,																		");
	sql.append("					'Y')																	");
	sql.append("		END																					");
	sql.append("	,																						");
	sql.append("	CASE																					");
	sql.append("		WHEN DATE_START <= ? AND DATE_END >= ? THEN 									");
	sql.append("			CASE																			");
	sql.append("				WHEN 	TO_CHAR(TO_DATE(?), 'DAY') = '월요일' OR							");
	sql.append("						TO_CHAR(TO_DATE(?), 'DAY') = '화요일' OR 							");
	sql.append("						TO_CHAR(TO_DATE(?), 'DAY') = '수요일' OR 							");
	sql.append("						TO_CHAR(TO_DATE(?), 'DAY') = '목요일' OR 							");
	sql.append("						TO_CHAR(TO_DATE(?), 'DAY') = '금요일' 								");
	sql.append("				THEN																		");
	sql.append("					DECODE(TIME_START_A, NULL, 												");
	sql.append("						DECODE(TIME_START_A2, NULL, 'N', 'Y')								");
	sql.append("						,																	");
	sql.append("						'Y')																");
	sql.append("				WHEN TO_CHAR(TO_DATE(?), 'DAY') = '토요일'									");
	sql.append("				THEN 																		");
	sql.append("					DECODE(TIME_START_B, NULL, 												");
	sql.append("						DECODE(TIME_START_B2, NULL, 'N', 'Y')								");
	sql.append("						, 																	");
	sql.append("						'Y')																");
	sql.append("				WHEN TO_CHAR(TO_DATE(?), 'DAY') = '일요일'									");
	sql.append("				THEN																		");
	sql.append("					DECODE(TIME_START_C, NULL, 												");
	sql.append("						DECODE(TIME_START_C2, NULL, 'N', 'Y')								");
	sql.append("						,																	");
	sql.append("						'Y')																");
	sql.append("			END																				");
	sql.append("		ELSE 'N'																			");
	sql.append("		END																					");
	sql.append("		) AS RESULT																			");
	sql.append("FROM RESERVE_DATE																			");
	sql.append(")																							");
	for(int i=0; i<16; i++){
		setList.add(reserve_date);	
	}
	paging.setParams("reserve_date", reserve_date);

	}
	if(reserve_type != null){
		for(int i=0; i<reserve_type.length; i++){
			sql.append("AND  SCHOOL_ID IN (SELECT SCHOOL_ID FROM RESERVE_ROOM T WHERE RESERVE_TYPE = ? ");	
			sql.append("AND (SELECT COUNT(RESERVE_TYPE) FROM RESERVE_ROOM WHERE SCHOOL_ID IN T.SCHOOL_ID) >= " + reserve_type.length  +"  ) ");
			setList.add(reserve_type[i]);
			paging.setParams("reserve_type", reserve_type[i]);
		}
	}

	setObj = new Object[setList.size()];
	for(int i=0; i < setList.size(); i++){
		setObj[i] = setList.get(i);
	}

	totalCount = jdbcTemplate.queryForObject(
			sql.toString(),
			Integer.class,
			setObj
		);

	paging.setPageNo(Integer.parseInt(pageNo));
	paging.setTotalCount(totalCount);
	paging.setPageSize(10);

	if(isMobile(request)){
		paging.setPageBlock(5);		//모바일기기 접속 시 5개
	}else{
		paging.setPageBlock(10);
	}
	paging.makePaging();

	sql = new StringBuffer();
	sql.append("SELECT * FROM(																				");
	sql.append("SELECT ROWNUM AS RNUM, A.* FROM (															");
	sql.append("SELECT																						");
	sql.append("	SCHOOL_ID,	 																			");
	sql.append("	SCHOOL_AREA, 																			");
	sql.append("	SCHOOL_NAME,																			");
	sql.append("	SCHOOL_ADDR,																			");
	sql.append("	SCHOOL_TEL,																				");
	sql.append("		(SELECT																				");
	sql.append("			SUBSTR(																			");
	sql.append("				XMLAGG(																		");
	sql.append("					XMLELEMENT(COL ,', ', RESERVE_TYPE) ORDER BY							");
	sql.append("					DECODE(RESERVE_TYPE, '강당', 1, '운동장', 2, '교실', 3, '기타시설', 4))			");
	sql.append("					.EXTRACT('//text()'														");
	sql.append("				).GETSTRINGVAL()															");
	sql.append("			, 2) RESERVE_TYPE																");
	sql.append("		FROM(																				");
	sql.append("			SELECT SCHOOL_ID, RESERVE_TYPE													");
	sql.append("			FROM RESERVE_ROOM																");
	sql.append("			GROUP BY SCHOOL_ID, RESERVE_TYPE												");
	sql.append("		)																					");
	sql.append("		WHERE SCHOOL_ID = RESERVE_SCHOOL.SCHOOL_ID											");
	sql.append("		GROUP BY SCHOOL_ID																	");
	sql.append("		) RESERVE_TYPE																		");
	sql.append("FROM RESERVE_SCHOOL																			");
	sql.append("WHERE SCHOOL_APPROVAL = 'Y'																	");
	if(!"".equals(school_name)){
	sql.append("AND SCHOOL_NAME LIKE '%'||?||'%'															");	
	}
	if(!"".equals(school_area)){
	sql.append("AND SCHOOL_AREA LIKE '%'||?||'%'															");	
	}				
	if(!"".equals(reserve_date)){
	sql.append("AND 'Y' IN																					");
	sql.append("(SELECT 																					");
	sql.append("	DECODE(DATE_START, NULL, 																");
	sql.append("		CASE																				");
	sql.append("			WHEN 	TO_CHAR(TO_DATE(?), 'DAY') = '월요일' OR									");
	sql.append("					TO_CHAR(TO_DATE(?), 'DAY') = '화요일' OR 									");
	sql.append("					TO_CHAR(TO_DATE(?), 'DAY') = '수요일' OR 									");
	sql.append("					TO_CHAR(TO_DATE(?), 'DAY') = '목요일' OR 									");
	sql.append("					TO_CHAR(TO_DATE(?), 'DAY') = '금요일' 									");
	sql.append("			THEN																			");
	sql.append("				DECODE(TIME_START_A, NULL, 													");
	sql.append("					DECODE(TIME_START_A2, NULL, 'N', 'Y')									");
	sql.append("					,																		");
	sql.append("					'Y')																	");
	sql.append("			WHEN TO_CHAR(TO_DATE(?), 'DAY') = '토요일'										");
	sql.append("			THEN 																			");
	sql.append("				DECODE(TIME_START_B, NULL, 													");
	sql.append("					DECODE(TIME_START_B2, NULL, 'N', 'Y')									");
	sql.append("					, 																		");
	sql.append("					'Y')																	");
	sql.append("			WHEN TO_CHAR(TO_DATE(?), 'DAY') = '일요일'										");
	sql.append("			THEN																			");
	sql.append("				DECODE(TIME_START_C, NULL, 													");
	sql.append("					DECODE(TIME_START_C2, NULL, 'N', 'Y')									");
	sql.append("					,																		");
	sql.append("					'Y')																	");
	sql.append("		END																					");
	sql.append("	,																						");
	sql.append("	CASE																					");
	sql.append("		WHEN DATE_START <= ? AND DATE_END >= ? THEN 										");
	sql.append("			CASE																			");
	sql.append("				WHEN 	TO_CHAR(TO_DATE(?), 'DAY') = '월요일' OR								");
	sql.append("						TO_CHAR(TO_DATE(?), 'DAY') = '화요일' OR 								");
	sql.append("						TO_CHAR(TO_DATE(?), 'DAY') = '수요일' OR 								");
	sql.append("						TO_CHAR(TO_DATE(?), 'DAY') = '목요일' OR 								");
	sql.append("						TO_CHAR(TO_DATE(?), 'DAY') = '금요일' 								");
	sql.append("				THEN																		");
	sql.append("					DECODE(TIME_START_A, NULL, 												");
	sql.append("						DECODE(TIME_START_A2, NULL, 'N', 'Y')								");
	sql.append("						,																	");
	sql.append("						'Y')																");
	sql.append("				WHEN TO_CHAR(TO_DATE(?), 'DAY') = '토요일'									");
	sql.append("				THEN 																		");
	sql.append("					DECODE(TIME_START_B, NULL, 												");
	sql.append("						DECODE(TIME_START_B2, NULL, 'N', 'Y')								");
	sql.append("						, 																	");
	sql.append("						'Y')																");
	sql.append("				WHEN TO_CHAR(TO_DATE(?), 'DAY') = '일요일'									");
	sql.append("				THEN																		");
	sql.append("					DECODE(TIME_START_C, NULL, 												");
	sql.append("						DECODE(TIME_START_C2, NULL, 'N', 'Y')								");
	sql.append("						,																	");
	sql.append("						'Y')																");
	sql.append("			END																				");
	sql.append("		ELSE 'N'																			");
	sql.append("		END																					");
	sql.append("		) AS RESULT																			");
	sql.append("FROM RESERVE_DATE																			");
	sql.append(")																							");
	}
	if(reserve_type != null){
		for(int i=0; i<reserve_type.length; i++){
			sql.append("AND  SCHOOL_ID IN (SELECT SCHOOL_ID FROM RESERVE_ROOM T WHERE RESERVE_TYPE = ? ");	
			sql.append("AND (SELECT COUNT(RESERVE_TYPE) FROM RESERVE_ROOM WHERE SCHOOL_ID IN T.SCHOOL_ID) >= " + reserve_type.length  +"  ) ");
		}
	}
	sql.append("ORDER BY SCHOOL_NAME																		");
	sql.append(") A WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" 								");
	sql.append(") WHERE RNUM > ").append(paging.getStartRowNo()).append(" 									");


	schoolList = jdbcTemplate.query(
				sql.toString(),
				new schoolList(),
				setObj
			);
}catch(Exception e){
	out.println(e.toString());
}

String adminCheck = "";

if("GRP_000009".equals(sm.getGroupId()) || sm.isRole("ROLE_000006") || sm.isRoleSym() ){
	adminCheck = "Y";
}

Calendar cal0 = Calendar.getInstance();
cal0.add(Calendar.MONTH, 1);							// 날짜를 다음달로 설정
int nowDate0 = cal0.get(Calendar.DATE); 				// 오늘 날짜를 구한다
int maxDate0 = cal0.getActualMaximum(Calendar.DATE);  	// 선택 월의 마지막 날짜를 구한다. (2월인경우 28 또는 29일, 나머지는 30일과 31일)
int setDate0 = maxDate0 - nowDate0;

%>
<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
<script>
$(function() {

	var maxDate = "+1M+<%=setDate0%>D";		//다음달 + (다음달 말일 - 현재일)일 을 하여 다음달 말일까지 선택가능하게 수정

	if($("#adminCheck").val() == "Y"){
		maxDate = null;
	}

	$.datepicker.regional['kr'] = {
		    closeText: '닫기', // 닫기 버튼 텍스트 변경
		    currentText: '오늘', // 오늘 텍스트 변경
		    monthNames: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
		    monthNamesShort: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
		    dayNames: ['월요일','화요일','수요일','목요일','금요일','토요일','일요일'], // 요일 텍스트 설정
		    minDate: 0,
		    maxDate: maxDate,
		    dayNamesShort: ['월','화','수','목','금','토','일'], // 요일 텍스트 축약 설정
		    dayNamesMin: ['월','화','수','목','금','토','일'] // 요일 최소 축약 텍스트 설정
		};
	$.datepicker.setDefaults($.datepicker.regional['kr']);
	  $( "#reserve_date" ).datepicker({
	    dateFormat: 'yy-mm-dd'
	  });
});

function searchSubmit(){
	$("#searchForm").attr("action", "").submit();
}

$(function(){		//20180302 JMG
	$("input[name='reserve_type']").change(function(){
		if($("#reserve_type1").prop("checked") && $("#reserve_type2").prop("checked")
				&& $("#reserve_type3").prop("checked") && $("#reserve_type4").prop("checked")){
				$("#reserve_typeAll").prop("checked", true);
			}else{
				$("#reserve_typeAll").prop("checked", false);
			}
	});

	$("#reserve_typeAll").change(function(){
		if($("#reserve_typeAll").prop("checked")){
			$("input[name='reserve_type']:checkbox").each(function() {
				$(this).prop("checked", false);
			});
		}/* else{
			$("input[name='reserve_type']:checkbox").each(function() {
				$(this).prop("checked", false);
			});
		} */
	});
	
	$("input[name='reserve_type']").change(function(){
		if($("#reserve_type1").prop("checked") && $("#reserve_type2").prop("checked")
			&& $("#reserve_type3").prop("checked") && $("#reserve_type4").prop("checked")){
			$("#reserve_typeAll").prop("checked", true);
		}else{
			$("#reserve_typeAll").prop("checked", false);
		}
	});	
});

function school_info(school_id){
	$("#postForm #school_id").val(school_id);
	$("#postForm #menuCd").val("<%=InfoPage%>");
	
	var reserve_type 	= "";
	var reserve_date 	= "<input type='hidden' name='reserve_date' value='" + $("#reserve_date").val() + "'>";
	var school_area 	= "<input type='hidden' name='school_area' value='" + $("#school_area").val() + "'>";
	var school_name 	= "<input type='hidden' name='school_name' value='" + $("#school_name").val() + "'>";
	
	for(var i=0; i<$("input[name=reserve_type]:checked").length; i++){
		reserve_type += "<input type='checkbox' name='reserve_type' value='"+$("input[name=reserve_type]:checked").eq(i).val()+"' checked>" 
	}
	
	$("#postForm").append(reserve_type);
	$("#postForm").append(reserve_date);
	$("#postForm").append(school_area);
	$("#postForm").append(school_name);

	$("#postForm").attr("action", "/index.gne").submit();
}
</script>

<div class="faciList">
<form method="get" class="board" id="searchForm" onsubmit="searchSubmit()">
	<input type="hidden" name="menuCd" id="menuCd" value="<%=menuCd%>">
	<table class="board_read02">
		<caption>시설검색/예약 : 희망대여일, 희밍지역, 시설명, 학교명 등</caption>
		<colgroup>
			<col class="wps_15"/>
			<col class="wps_10"/>
			<col />
			<col class="wps_15" />
			<col class="wps_25">
		</colgroup>
		<tbody>
			<tr class="topline">
				<th scope="row">희망대여일</th>
				<td colspan="2">
					<label for="reserve_date" class="dis_mo">희망대여일</label>
					<input type="text" name="reserve_date" id="reserve_date" value="<%=reserve_date%>" class="wps_100">
				</td>
				<th scope="row">희망지역</th>
				<td>
         			<label for="school_area" class="dis_mo">희망지역</label>
         			<%
         			String areaArr[] = {"창원시","김해시","진주시","양산시", "거제시" ,"통영시","사천시","밀양시","함안군","거창군","창녕군","고성군"
         					,"하동군","합천군","남해군","함양군","산청군","의령군"};
         			%>
					<select name="school_area" id="school_area" class="wps_100">
					<option value="">지역선택</option>
					<%
					for(String ob : areaArr){
					%>
					<option value="<%=ob%>" <%if(ob.equals(school_area)){%> selected <%}%> ><%=ob%></option>
					<%
					}
					%>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">시설명</th>
				<td class="reserveType">
					<label class="dis_mo">시설명</label>
          			<span>
          				<input type="checkbox" name="reserve_typeAll" id="reserve_typeAll" value="">
          				<label for="reserve_typeAll">전체</label>
          			</span>
				</td>
				<td class="reserveType">
					<%
					String[] reserveTypeArr = {"강당", "운동장", "교실", "기타시설"	};
					List<String> reserveTypeList = new ArrayList<String>();
					if(reserve_type != null){
						for(String ob : reserve_type){
							reserveTypeList.add(ob);
						}
					}
					for(int i=0; i<reserveTypeArr.length; i++){
						String ob = reserveTypeArr[i];
					%>
					<span>
						<input type="checkbox" name="reserve_type" id="reserve_type<%=i+1%>" value="<%=ob%>"
						<%if(reserveTypeList.contains(ob)){%>
							checked
						<%} %>
						> 
						<label for="reserve_type<%=i+1%>"><%=ob%></label>
					</span>
					<%
					} 
					%>
				</td>
				<th scope="row">학교명</th>
				<td>
					<label for="school_name" class="dis_mo">학교명</label>
					<input type="text" name="school_name" id="school_name" class="wps_100" value="<%=school_name%>"></td>
			</tr>
		</tbody>
	</table>
	<p class="c magT10 magB20"><button class="btn_type01">검색</button> </p>
</form>
<form id="postForm" method="get" style="display: none;">
	<input type="hidden" name="menuCd" id="menuCd" value="<%=menuCd%>">
	<input type="hidden" name="school_id" id="school_id">
</form>
<div class="search">
  <label><input type="hidden" name="pageNo" value=""></label>
	<p class="f_r magB5 badge_guide">
		<span><i class="badge ca2">강</i>강당</span>
		<span><i class="badge ca1">운</i>운동장</span>
		<span><i class="badge ca3">교</i>교실</span>
		<span><i class="badge ca4">기</i>기타시설</span>
	</p>
	
	<%num = paging.getRowNo(); %>
	<p class="total">총 <strong><%=totalCount%></strong>건 [page <%=pageNo %>/<%=paging.getFinalPageNo() %>]</p>
</div>
<table class="tb_board">
	<caption>시설 검색 목록입니다.</caption>
	<colgroup>
		<col style="width:8%" />
		<col style="width:10%" />
		<col style="width:15%" />
		<col style="width:15%" />
		<col  />
		<col style="width:15%" />
	</colgroup>
  <thead>
    <tr>
      <th scope="col">번호</th>
      <th scope="col">지역</th>
      <th scope="col">학교명</th>
      <th scope="col">시설명</th>
      <th scope="col">주소</th>
      <th scope="col">전화번호</th>
    </tr>
  </thead>
  	<%if(schoolList!=null && schoolList.size()>0){
  		for(reserveVO ob : schoolList){%>
	<tr>
		<td class="no"><span class="dis_mo">번호</span><%=num--%></td>
		<td class="area"><span class="dis_mo">지역</span><%=ob.school_area %></td>
		<%-- <td class="sch_name"><span class="dis_mo">학교명</span><a href="javascript:school_info('<%=school_id%>', '/index.gne?menuCd=DOM_000001201003001001');"><%=school_name%></a> </td>		<!-- 실서버 --> --%>
		<td class="sch_name">
			<span class="dis_mo">학교명</span>
			<a href="javascript:school_info('<%=ob.school_id%>')"><%=ob.school_name %></a> 
		</td>	
		<td class="faci_name">
      		<span class="dis_mo">시설명</span>
			<%
			String reserve_type_icon = "";
			if(!"".equals(parseNull(ob.reserve_type))){
				for(String ob2 : ob.reserve_type.split(",")){
					if("운동장".equals(ob2.replace(" ", ""))){
						reserve_type_icon += "<i class='badge ca1'>" + ob2 + "</i>";
					}else if("강당".equals(ob2.replace(" ", ""))){
						reserve_type_icon += "<i class='badge ca2'>" + ob2 + "</i>";
					}else if("교실".equals(ob2.replace(" ", ""))){
						reserve_type_icon += "<i class='badge ca3'>" + ob2 + "</i>";
					}else if("기타시설".equals(ob2.replace(" ", ""))){
						reserve_type_icon += "<i class='badge ca4'>" + ob2 + "</i>";
					}
				}
			}
			%>
			<%=reserve_type_icon %>
		</td>
		<td class="address"><span class="dis_mo">주소</span>경상남도 <%=ob.school_area %> <%=ob.school_addr %> </td>
		<td class="tel"><span class="dis_mo">전화번호</span>055-<%=telSet(ob.school_tel) %></td>
	</tr>
	<%	}
	}else{ %>
<!-- 검색결과가 없을 때 노출 -->
	<tr>
		<td colspan="6">검색된 시설이 없습니다.</td>
	</tr>
	<%}%>
</table>

<% if(paging.getTotalCount() > 0) { %>
<div class="pageing c">
	<%=paging.getHtml() %>
</div>
<% } %>
</div>