<%@ include file="/program/class/UtilClass.jsp" %>
<%@ include file="/program/class/PagingClass.jsp" %>
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

<%!
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
String adminCheck = "";

if("GRP_000009".equals(sm.getGroupId()) || sm.isRole("ROLE_000006") || sm.isRoleSym() ){
	adminCheck = "Y";
}

Calendar cal0 = Calendar.getInstance();
cal0.add(Calendar.MONTH, 1);							//날짜를 다음달로 설정
int nowDate0 = cal0.get(Calendar.DATE); 				//오늘 날짜를 구한다
int maxDate0 = cal0.getActualMaximum(Calendar.DATE);  //선택 월의 마지막 날짜를 구한다. (2월인경우 28 또는 29일, 나머지는 30일과 31일)
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
</script>
<%

Calendar cal = Calendar.getInstance();
String y = Integer.toString(cal.get(Calendar.YEAR));
String m = Integer.toString(cal.get(Calendar.MONTH)+1);
String d = Integer.toString(cal.get(Calendar.DATE));
if(Integer.parseInt(m) < 10){
	m = "0" + m;
}
if(Integer.parseInt(d) < 10){
	d = "0" + d;
}
String nowDate = y+"-"+m+"-"+d;

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

Connection conn2 = null;
PreparedStatement pstmt2 = null;
ResultSet rs2 = null;
StringBuffer sql2 = null;

List<Map<String, Object>> dataList = null;
List<Map<String, Object>> dataList2 = null;
Map<String, List<String>> typeMap = new HashMap<String, List<String>>();
List<String> typeList = null;
List<String> typeList2 = null;

String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;
Paging paging = new Paging();

String school_id = "";
String school_name = request.getParameter("school_name")==null?"":request.getParameter("school_name");
String school_area = request.getParameter("school_area")==null?"":request.getParameter("school_area");
String school_addr = "";
String school_tel = "";
String school_url = "";
String charge_dept = "";
String dept_tel = "";
String charge_name = "";
String charge_phone = "";
String account = "";
String area_type = "";

String room_id = "";
String reserve_type[] = request.getParameterValues("reserve_type");
String reserve_type2 = "";
String reserve_type_icon = "";
String reserve_number = "";
String reserve_area = request.getParameter("reserve_area")==null?"":request.getParameter("reserve_area");
String reserve_max = "";
String reserve_date = request.getParameter("reserve_date")==null?"":request.getParameter("reserve_date");
String reserve_date_day = "";
if(!"".equals(reserve_date)){
	reserve_date_day = getDateDay(reserve_date,"yyyy-MM-dd");
}

String reserve_etc = "";
String reserve_notice = "";
String save_img = "";
String real_img = "";
String directory = "";
String reserve_use = "";

int num = 0;
int cnt = 0;

String areaArr[] = {"창원시","김해시","진주시","양산시", "거제시" ,"통영시","사천시","밀양시","함안군","거창군","창녕군","고성군"
		,"하동군","합천군","남해군","함양군","산청군","의령군"};

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	sql = new StringBuffer();
	sql.append("SELECT COUNT(*) AS CNT FROM RESERVE_SCHOOL WHERE SCHOOL_APPROVAL = 'Y' ");
	if(!"".equals(reserve_date)){
		if("평일".equals(reserve_date_day)){
			sql.append("AND SCHOOL_ID IN (SELECT SCHOOL_ID FROM RESERVE_DATE WHERE (RESERVE_TYPE = 'A' OR (DATE_START <= ? AND DATE_END >= ?)) AND TIME_START_A IS NOT NULL  GROUP BY SCHOOL_ID) ");
		}else if("토".equals(reserve_date_day)){
			sql.append("AND SCHOOL_ID IN (SELECT SCHOOL_ID FROM RESERVE_DATE WHERE (RESERVE_TYPE = 'A' OR (DATE_START <= ? AND DATE_END >= ?)) AND TIME_START_B IS NOT NULL  GROUP BY SCHOOL_ID) ");
		}else if("일".equals(reserve_date_day)){
			sql.append("AND SCHOOL_ID IN (SELECT SCHOOL_ID FROM RESERVE_DATE WHERE (RESERVE_TYPE = 'A' OR (DATE_START <= ? AND DATE_END >= ?)) AND TIME_START_C IS NOT NULL  GROUP BY SCHOOL_ID) ");
		}
		paging.setParams("reserve_date", reserve_date);
	}
	if(!"".equals(school_area)){
		sql.append(" AND  SCHOOL_AREA = ? ");
		paging.setParams("school_area", school_area);
	}

	if(reserve_type != null && reserve_type.length > 0){
		if(!"".equals(reserve_date)){
			if("평일".equals(reserve_date_day)){
				sql.append("AND SCHOOL_ID IN (SELECT SCHOOL_ID FROM RESERVE_DATE WHERE (RESERVE_TYPE = 'A' OR (DATE_START <= ? AND DATE_END >= ?)) AND TIME_START_A IS NOT NULL  ");
				sql.append("AND ROOM_ID IN (SELECT ROOM_ID FROM RESERVE_ROOM WHERE RESERVE_TYPE IN (? ");
				for(int i=1; i<reserve_type.length; i++){
					sql.append(", ? ");
				}
				sql.append(") GROUP BY ROOM_ID) ");
				sql.append("GROUP BY SCHOOL_ID) ");
			}else if("토".equals(reserve_date_day)){
				sql.append("AND SCHOOL_ID IN (SELECT SCHOOL_ID FROM RESERVE_DATE WHERE (RESERVE_TYPE = 'A' OR (DATE_START <= ? AND DATE_END >= ?)) AND TIME_START_A IS NOT NULL  ");
				sql.append("AND ROOM_ID IN (SELECT ROOM_ID FROM RESERVE_ROOM WHERE RESERVE_TYPE IN (? ");
				for(int i=1; i<reserve_type.length; i++){
					sql.append(", ? ");
				}
				sql.append(") GROUP BY ROOM_ID) ");
				sql.append("GROUP BY SCHOOL_ID) ");
			}else if("일".equals(reserve_date_day)){
				sql.append("AND SCHOOL_ID IN (SELECT SCHOOL_ID FROM RESERVE_DATE WHERE (RESERVE_TYPE = 'A' OR (DATE_START <= ? AND DATE_END >= ?)) AND TIME_START_A IS NOT NULL  ");
				sql.append("AND ROOM_ID IN (SELECT ROOM_ID FROM RESERVE_ROOM WHERE RESERVE_TYPE IN (? ");
				for(int i=1; i<reserve_type.length; i++){
					sql.append(", ? ");
				}
				sql.append(") GROUP BY ROOM_ID) ");
				sql.append("GROUP BY SCHOOL_ID) ");
			}
		}else{
			for(int i=0; i<reserve_type.length; i++){
				sql.append("AND  SCHOOL_ID IN (SELECT SCHOOL_ID FROM RESERVE_ROOM T WHERE RESERVE_TYPE = ? ");	
				if(reserve_type.length == 4){
					sql.append("AND (SELECT COUNT(RESERVE_TYPE) FROM RESERVE_ROOM WHERE SCHOOL_ID IN T.SCHOOL_ID) >= " + reserve_type.length  +"  ) ");
				}else{
					sql.append("AND (SELECT COUNT(RESERVE_TYPE) FROM RESERVE_ROOM WHERE SCHOOL_ID IN T.SCHOOL_ID) = " + reserve_type.length  +"  ) ");	
				}
				paging.setParams("reserve_type", reserve_type[i]);
			}
		}
		
	}
	if(!"".equals(school_name)){
		sql.append("  AND  SCHOOL_NAME LIKE '%'||?||'%' ");
		paging.setParams("school_name", school_name);
	}
	pstmt = conn.prepareStatement(sql.toString());
	if(!"".equals(reserve_date)){
		pstmt.setString(++cnt, reserve_date);
		pstmt.setString(++cnt, reserve_date);
	}
	if(!"".equals(school_area)){
		++cnt;
		pstmt.setString(cnt, school_area);
	}
	if(reserve_type != null && reserve_type.length > 0){
		if(!"".equals(reserve_date)){
			pstmt.setString(++cnt, reserve_date);
			pstmt.setString(++cnt, reserve_date);
		}
		for(String ob : reserve_type){
			pstmt.setString(++cnt,ob);
		}
	}
	if(!"".equals(school_name)){
		++cnt;
		pstmt.setString(cnt, school_name);
	}
	cnt = 0;
	rs = pstmt.executeQuery();
	if(rs.next()){
		totalCount = rs.getInt("CNT");
	}




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
	sql.append("SELECT * FROM ( \n");
	sql.append("	SELECT ROWNUM AS RNUM, A.* FROM ( \n");
	sql.append("		SELECT 	");
	sql.append("			SCHOOL_ID,	 						");
	sql.append("			SCHOOL_NAME,	 					");
	sql.append("			SCHOOL_AREA,	 					");
	sql.append("			SCHOOL_ADDR,	 					");
	sql.append("			SCHOOL_TEL,	 						");
	sql.append("			SCHOOL_URL,	 						");
	sql.append("			CHARGE_DEPT,	 					");
	sql.append("			DEPT_TEL,	 						");
	sql.append("			CHARGE_NAME,	 					");
	sql.append("			CHARGE_PHONE,	 					");
	sql.append("			ACCOUNT,	 						");
	sql.append("			AREA_TYPE,	 						");
	sql.append("			CHARGE_ID,	 						");
	sql.append("			SCHOOL_APPROVAL,	 				");
	sql.append("			SCH_APPROVAL_DATE,	 				");
	sql.append("			CHARGE_NAME2,	 					");
	sql.append("			(SELECT		 						");
	sql.append("				SUBSTR( 						");
	sql.append("					XMLAGG(	 					");
	sql.append("						XMLELEMENT(COL ,', ', RESERVE_TYPE) ORDER BY DECODE(RESERVE_TYPE, '강당', 1, '운동장', 2, '교실', 3, '기타시설', 4)) \n");
	sql.append("						.EXTRACT('//text()' 				");
	sql.append("					).GETSTRINGVAL() 						");
	sql.append("				, 2) RESERVE_TYPE	 						");
	sql.append("			FROM 	(	 									");
	sql.append("					SELECT SCHOOL_ID, RESERVE_TYPE	 		");
	sql.append("					FROM RESERVE_ROOM	 					");
	sql.append("					GROUP BY SCHOOL_ID, RESERVE_TYPE	 	");
	sql.append("					)	 									");
	sql.append("			WHERE SCHOOL_ID = RESERVE_SCHOOL.SCHOOL_ID	 	");
	sql.append("			GROUP BY SCHOOL_ID					 			");
	sql.append("			) RESERVE_TYPE	 			");
	sql.append("		FROM RESERVE_SCHOOL WHERE SCHOOL_APPROVAL = 'Y' 	");
	if(!"".equals(reserve_date)){
		if("평일".equals(reserve_date_day)){
			sql.append("AND SCHOOL_ID IN (SELECT SCHOOL_ID FROM RESERVE_DATE WHERE (RESERVE_TYPE = 'A' OR (DATE_START <= ? AND DATE_END >= ?)) AND TIME_START_A IS NOT NULL  GROUP BY SCHOOL_ID) ");
		}else if("토".equals(reserve_date_day)){
			sql.append("AND SCHOOL_ID IN (SELECT SCHOOL_ID FROM RESERVE_DATE WHERE (RESERVE_TYPE = 'A' OR (DATE_START <= ? AND DATE_END >= ?)) AND TIME_START_B IS NOT NULL  GROUP BY SCHOOL_ID) ");
		}else if("일".equals(reserve_date_day)){
			sql.append("AND SCHOOL_ID IN (SELECT SCHOOL_ID FROM RESERVE_DATE WHERE (RESERVE_TYPE = 'A' OR (DATE_START <= ? AND DATE_END >= ?)) AND TIME_START_C IS NOT NULL  GROUP BY SCHOOL_ID) ");
		}
		paging.setParams("reserve_date", reserve_date);
	}
	if(!"".equals(school_area)){
		sql.append(" AND  SCHOOL_AREA = ? ");
		paging.setParams("school_area", school_area);
	}
	if(reserve_type != null && reserve_type.length > 0){
		if(!"".equals(reserve_date)){
			if("평일".equals(reserve_date_day)){
				sql.append("AND SCHOOL_ID IN(SELECT SCHOOL_ID FROM RESERVE_DATE WHERE RESERVE_TYPE = 'A' OR (DATE_START <= ? AND DATE_END >= ?) AND TIME_START_A IS NULL)  ");
				sql.append("AND SCHOOL_ID NOT IN(SELECT SCHOOL_ID FROM RESERVE_BAN WHERE (DATE_START <= ? AND DATE_END >= ?) AND TIME_START_A IS NOT NULL)  ");
				sql.append("AND SCHOOL_ID IN(SELECT SCHOOL_ID FROM RESERVE_ROOM WHERE RESERVE_TYPE IN (? ");
				for(int i=1; i<reserve_type.length; i++){
					sql.append(", ? ");
				}
				sql.append(")) ");
			}else if("토".equals(reserve_date_day)){
				sql.append("AND SCHOOL_ID IN(SELECT SCHOOL_ID FROM RESERVE_DATE WHERE RESERVE_TYPE = 'A' OR (DATE_START <= ? AND DATE_END >= ?) AND TIME_START_B IS NULL)  ");
				sql.append("AND SCHOOL_ID NOT IN(SELECT SCHOOL_ID FROM RESERVE_BAN WHERE (DATE_START <= ? AND DATE_END >= ?) AND TIME_START_B IS NOT NULL)  ");
				sql.append("AND SCHOOL_ID IN(SELECT SCHOOL_ID FROM RESERVE_ROOM WHERE RESERVE_TYPE IN (? ");
				for(int i=1; i<reserve_type.length; i++){
					sql.append(", ? ");
				}
				sql.append(")) ");
			}else if("일".equals(reserve_date_day)){
				sql.append("AND SCHOOL_ID IN(SELECT SCHOOL_ID FROM RESERVE_DATE WHERE RESERVE_TYPE = 'A' OR (DATE_START <= ? AND DATE_END >= ?) AND TIME_START_C IS NULL)  ");
				sql.append("AND SCHOOL_ID NOT IN(SELECT SCHOOL_ID FROM RESERVE_BAN WHERE (DATE_START <= ? AND DATE_END >= ?) AND TIME_START_C IS NOT NULL)  ");
				sql.append("AND SCHOOL_ID IN(SELECT SCHOOL_ID FROM RESERVE_ROOM WHERE RESERVE_TYPE IN (? ");
				for(int i=1; i<reserve_type.length; i++){
					sql.append(", ? ");
				}
				sql.append(")) ");
			}
		}else{
			for(int i=0; i<reserve_type.length; i++){
				sql.append("AND  SCHOOL_ID IN (SELECT SCHOOL_ID FROM RESERVE_ROOM T WHERE RESERVE_TYPE = ? ");	
				if(reserve_type.length == 4){
					sql.append("AND (SELECT COUNT(RESERVE_TYPE) FROM RESERVE_ROOM WHERE SCHOOL_ID IN T.SCHOOL_ID) >= " + reserve_type.length  +"  ) ");
				}else{
					sql.append("AND (SELECT COUNT(RESERVE_TYPE) FROM RESERVE_ROOM WHERE SCHOOL_ID IN T.SCHOOL_ID) = " + reserve_type.length  +"  ) ");	
				}
			}
		}
	}
	if(!"".equals(school_name)){
		sql.append("  AND  SCHOOL_NAME LIKE '%'||?||'%' ");
		paging.setParams("school_name", school_name);
	}
	sql.append("		ORDER BY SCHOOL_NAME ");
	sql.append("	) A WHERE ROWNUM <= ").append(paging.getEndRowNo()).append(" \n");
	sql.append(") WHERE RNUM > ").append(paging.getStartRowNo()).append(" \n");
	pstmt = conn.prepareStatement(sql.toString());
	if(!"".equals(reserve_date)){
		pstmt.setString(++cnt, reserve_date);
		pstmt.setString(++cnt, reserve_date);
	}
	if(!"".equals(school_area)){
		++cnt;
		pstmt.setString(cnt, school_area);
	}
	if(reserve_type != null && reserve_type.length > 0){
		if(!"".equals(reserve_date)){
			pstmt.setString(++cnt, reserve_date);
			pstmt.setString(++cnt, reserve_date);
			pstmt.setString(++cnt, reserve_date);
			pstmt.setString(++cnt, reserve_date);
		}
		for(String ob : reserve_type){
			pstmt.setString(++cnt, ob);
		}
	}
	if(!"".equals(school_name)){
		++cnt;
		pstmt.setString(cnt, school_name);
	}
	rs = pstmt.executeQuery();
	dataList = getResultMapRows(rs);

	/* sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_SCHOOL \n");
	pstmt = conn.prepareStatement(sql.toString());
	rs = pstmt.executeQuery();
	dataList2 = getResultMapRows(rs);

	if(dataList2!=null && dataList2.size()>0){
		for(int i=0; i<dataList2.size(); i++){
			Map<String, Object> map = dataList2.get(i);

			typeList = new ArrayList<String>();
			sql = new StringBuffer();
			sql.append("SELECT RESERVE_TYPE FROM RESERVE_ROOM WHERE SCHOOL_ID = ? GROUP BY RESERVE_TYPE \n");
			sql.append("ORDER BY DECODE(RESERVE_TYPE, '강당', 1, '운동장', 2, '교실', 3, '기타시설', 4) \n");
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, map.get("SCHOOL_ID").toString());
			rs = pstmt.executeQuery();
			while(rs.next()){
				typeList.add(rs.getString("RESERVE_TYPE"));
			}

			if(typeList.size() > 0 && typeList != null){
				typeMap.put(map.get("SCHOOL_ID").toString(),  typeList);
			}
		}
	} */

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
function school_info(school_id, menuCd){
	$("#postForm").attr("method", "post");
	$("#postForm").attr("action", menuCd+"&school_id="+school_id).submit();
}
</script>
<div class="faciList">
<form action="" method="post" class="board" id="postForm">
<input type="hidden" name="adminCheck" id="adminCheck" value="<%=adminCheck%>">
	<table class="board_read02">
		<caption>시설검색/예약 : 희망대여일, 희밍지역, 시설명, 학교명 등</caption>
		<colgroup>
			<col class="wps_15"/>
			<col />
			<col class="wps_15" />
			<col class="wps_25">
		</colgroup>
		<tbody>
			<tr class="topline">
				<th scope="row">희망대여일</th>
				<td><label for="reserve_date" class="dis_mo">희망대여일</label><input type="text" name="reserve_date" id="reserve_date" value="<%=reserve_date%>" class="wps_60"></td>
				<th scope="row">희망지역</th>
				<td>
          <label for="school_area" class="dis_mo">희망지역</label>
					<select name="school_area" id="school_area" class="wps_70">
					<option value="">지역선택</option>
					<%
					for(int i=0; i<areaArr.length; i++){
					%>
					<option value="<%=areaArr[i] %>" <%if(areaArr[i].equals(school_area)){%> selected="selected" <%}%>><%=areaArr[i] %></option>
					<%
					}
					%>
					</select>
				</td>
			</tr>
			<tr>
				<th scope="row">시설명</th>
				<%
				boolean reserve_type_check_1 = false;
				boolean reserve_type_check_2 = false;
				boolean reserve_type_check_3 = false;
				boolean reserve_type_check_4 = false;

				if(reserve_type != null && reserve_type.length > 0){
					for(int i=0; i<reserve_type.length; i++){
						if("운동장".equals(reserve_type[i])){
							reserve_type_check_1 = true;
						}else if("강당".equals(reserve_type[i])){
							reserve_type_check_2 = true;
						}else if("교실".equals(reserve_type[i])){
							reserve_type_check_3 = true;
						}else if("기타시설".equals(reserve_type[i])){
							reserve_type_check_4 = true;
						}
					}
				}

				%>
				<script>
				$(function(){
					if($("#reserve_type1").prop("checked") && $("#reserve_type2").prop("checked")
						&& $("#reserve_type3").prop("checked") && $("#reserve_type4").prop("checked")){
						$("#reserve_typeAll").prop("checked", true);
					}else{
						$("#reserve_typeAll").prop("checked", false);
					}
					
					$("#reserve_typeAll").change(function(){
						if($("#reserve_typeAll").prop("checked")){
							$("input[name='reserve_type']:checkbox").each(function() {
								$(this).prop("checked", true);
							});
						}else{
							$("input[name='reserve_type']:checkbox").each(function() {
								$(this).prop("checked", false);
							});
						}
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
				</script>
				<td class="reserveType">
         			<label class="dis_mo">시설명</label>
          			<span><input type="checkbox" name="reserve_typeAll" id="reserve_typeAll" value=""  > <label for="reserve_typeAll">전체</label></span>
					<span><input type="checkbox" name="reserve_type" id="reserve_type2" value="강당" <%if(reserve_type_check_2){%>checked="checked"<%}%>> <label for="reserve_type2">강당</label></span>
          			<span><input type="checkbox" name="reserve_type" id="reserve_type1" value="운동장" <%if(reserve_type_check_1){%>checked="checked"<%}%> > <label for="reserve_type1">운동장</label></span>
					<span><input type="checkbox" name="reserve_type" id="reserve_type3" value="교실" <%if(reserve_type_check_3){%>checked="checked"<%}%>> <label for="reserve_type3">교실</label></span>
					<span><input type="checkbox" name="reserve_type" id="reserve_type4" value="기타시설" <%if(reserve_type_check_4){%>checked="checked"<%}%>> <label for="reserve_type4">기타시설</label></span>
				</td>
				<th scope="row">학교명</th>
				<td><label for="school_name" class="dis_mo">학교명</label><input type="text" name="school_name" id="school_name" class="wps_70" value="<%=school_name%>"></td>
			</tr>
		</tbody>
	</table>
	<p class="c magT10 magB20"><button class="btn_type01">검색</button> </p>
</form>

<div class="search">
  <label><input type="hidden" name="pageNo" value="<%=pageNo%>"></label>
	<p class="f_r magB5 badge_guide"><span><i class="badge ca2">강</i>강당</span><span><i class="badge ca1">운</i>운동장</span><span><i class="badge ca3">교</i>교실</span><span><i class="badge ca4">기</i>기타시설</span></p>
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
<%
if(dataList!=null && dataList.size()>0){
	num = paging.getRowNo();
for(int i=0; i<dataList.size(); i++){
	Map<String, Object> map = dataList.get(i);
	school_id = map.get("SCHOOL_ID").toString();
	school_name = map.get("SCHOOL_NAME").toString();
	school_area = map.get("SCHOOL_AREA").toString();
	school_addr = map.get("SCHOOL_ADDR").toString();
	school_tel = map.get("SCHOOL_TEL").toString();
	school_url = map.get("SCHOOL_URL").toString();
	charge_dept = map.get("CHARGE_DEPT").toString();
	charge_phone = map.get("CHARGE_PHONE").toString();
	account = map.get("ACCOUNT").toString();
	area_type = map.get("AREA_TYPE").toString();
	dept_tel = map.get("DEPT_TEL").toString();
	reserve_type_icon = map.get("RESERVE_TYPE").toString();

%>
	<tr>
		<td class="no"><span class="dis_mo">번호</span><%=num--%> </td>
		<td class="area"><span class="dis_mo">지역</span><%=school_area%> </td>
		<td class="sch_name"><span class="dis_mo">학교명</span><a href="javascript:school_info('<%=school_id%>', '/index.gne?menuCd=DOM_000001201003001001');"><%=school_name%></a> </td>		<!-- 실서버 -->
		<%-- <td> <a href="javascript:school_info('<%=school_id%>', '/index.gne?menuCd=DOM_000000106003001001');"><%=school_name%></a> </td>		<!-- 테스트서버 --> --%>
		<td class="faci_name">
      <span class="dis_mo">시설명</span>
			<%
			String reserve_type_icon2 = "";
			for(String ob : reserve_type_icon.split(",")){
				if("운동장".equals(ob.replace(" ", ""))){
					reserve_type_icon2 += "<i class='badge ca1'>" + ob + "</i>";
				}else if("강당".equals(ob.replace(" ", ""))){
					reserve_type_icon2 += "<i class='badge ca2'>" + ob + "</i>";
				}else if("교실".equals(ob.replace(" ", ""))){
					reserve_type_icon2 += "<i class='badge ca3'>" + ob + "</i>";
				}else if("기타시설".equals(ob.replace(" ", ""))){
					reserve_type_icon2 += "<i class='badge ca4'>" + ob + "</i>";
				}
			}
			%>
			<%=reserve_type_icon2 %>
			<%-- 
			<%
			typeList2 = typeMap.get(school_id);
			if(typeList2 != null && typeList2.size() > 0){
				String typeClass = "";
			for(int j=0; j<typeList2.size(); j++){
				if("운동장".equals(typeList2.get(j))){
					typeClass = "ca1";
				}else if("강당".equals(typeList2.get(j))){
					typeClass = "ca2";
				}else if("교실".equals(typeList2.get(j))){
					typeClass = "ca3";
				}else if("기타시설".equals(typeList2.get(j))){
					typeClass = "ca4";
				}
				%>
					<i class="badge <%=typeClass%>"><%=typeList2.get(j)%></i>
				<%
			}}
			%>
			 --%>
		</td>
		<td class="address"><span class="dis_mo">주소</span>경상남도 <%=school_area%> <%=school_addr %> </td>
		<td class="tel"><span class="dis_mo">전화번호</span>055-<%=telSet(dept_tel)%> </td>
	</tr>
<%}
}else{
%>
<!-- 검색결과가 없을 때 노출 -->
	<tr>
		<td colspan="6">검색된 시설이 없습니다.</td>
	</tr>
<%} %>
</table>

<% if(paging.getTotalCount() > 0) { %>
<div class="pageing c">
	<%=paging.getHtml() %>
</div>
<% } %>
</div>