<%
/**
*   PURPOSE :   장기예약-등록 페이지
*   CREATE  :   2017...
*   MODIFY  :   20171115_wed  JI  추가동작 btn, function 추가 및 수정 / 예약가능시간 arr 변수 추가 및 이용시점 추가
*/
%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ include file="/program/class/PagingClass.jsp" %>
<%@ page import="java.text.ParseException"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%
String adminCheck = "";

if("GRP_000009".equals(sm.getGroupId()) || sm.isRole("ROLE_000006") || sm.isRoleSym() ){
	adminCheck = "Y";
}

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

String school_id = parseNull(request.getParameter("school_id"));
String command = parseNull(request.getParameter("command"), "insert");
String room_id = parseNull(request.getParameter("room_id"));
String reserve_type = parseNull(request.getParameter("reserve_type"));
String reserve_type2 = parseNull(request.getParameter("reserve_type2"));
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

List<Map<String,Object>> roomList = null;		//2017.11.23. - 해당학교의 시설명 리스트
List<Map<String,Object>> roomList2 = null;		//2017.11.23. - 해당학교의 기타시설명 리스트

int key = 0;
try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	//시설정보
	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_ROOM WHERE SCHOOL_ID = ?  ");
	if(!"".equals(reserve_type)){
		sql.append("AND RESERVE_TYPE = ?");
		if("기타시설".equals(reserve_type) && !"".equals(reserve_type2)){									//2017.11.23. - 기타시설 검색조건 추가
			sql.append("AND RESERVE_TYPE2 = ?");
		}
	}else{
		sql.append("AND ROOM_ID = ?");
	}
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, school_id);
	if(!"".equals(reserve_type)){
		pstmt.setString(++key, reserve_type);
		if("기타시설".equals(reserve_type) && !"".equals(reserve_type2)){									//2017.11.23. - 기타시설 검색조건 추가
			pstmt.setString(++key, reserve_type2);
		}
	}else{
		pstmt.setString(++key, room_id);
	}
	rs = pstmt.executeQuery();
	if(rs.next()){
		room_id = parseNull(rs.getString("ROOM_ID"));
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
	sql = new StringBuffer();
	sql.append("SELECT RESERVE_TYPE, RESERVE_TYPE2 FROM RESERVE_ROOM WHERE SCHOOL_ID = ? AND ROOM_ID = ?  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, school_id);
	pstmt.setString(++key, room_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		reserve_type = rs.getString("RESERVE_TYPE");
		reserve_type2 = rs.getString("RESERVE_TYPE2");
	}
	if(pstmt!=null) pstmt.close();
	
	
	//2017.11.23. - 해당학교의 시설명 리스트
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT RESERVE_TYPE  														");
	sql.append("FROM RESERVE_ROOM  															");
	sql.append("WHERE SCHOOL_ID = ?															");
	sql.append("GROUP BY RESERVE_TYPE 														");
	sql.append("ORDER BY DECODE(RESERVE_TYPE, '강당', 1, '운동장', 2, '교실', 3, '기타시설', 4) 	");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, school_id);
	rs = pstmt.executeQuery();
	roomList = getResultMapRows(rs);
	if(pstmt!=null) pstmt.close();
	
	//2017.11.23. - 해당학교의 기타시설명 리스트
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT RESERVE_TYPE2  														");
	sql.append("FROM RESERVE_ROOM  															");
	sql.append("WHERE SCHOOL_ID = ?															");
	sql.append("GROUP BY RESERVE_TYPE2 														");
	sql.append("ORDER BY RESERVE_TYPE2													 	");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, school_id);
	rs = pstmt.executeQuery();
	roomList2 = getResultMapRows(rs);
	if(pstmt!=null) pstmt.close();
	
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
<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>

<script>
/**
 *   PURPOSE :   예약가능시간 확인 array 변수 추가 => useCheckArr
 *   CREATE  :   20171115_wed
 *   MODIFY  :   ....
 */
 var useCheckArr   =   ['N'];
 $(".useCheck").val(useCheckArr);
 /* END */
 
    $(function() {
        $.datepicker.regional['kr'] = {
                closeText: '닫기', // 닫기 버튼 텍스트 변경
                currentText: '오늘', // 오늘 텍스트 변경
                monthNames: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
                monthNamesShort: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
                dayNames: ['일요일', '월요일','화요일','수요일','목요일','금요일','토요일'], // 요일 텍스트 설정
                dayNamesShort: ['일','월','화','수','목','금','토'], // 요일 텍스트 축약 설정    
                dayNamesMin: ['일','월','화','수','목','금','토'] // 요일 최소 축약 텍스트 설정
            };
        $.datepicker.setDefaults($.datepicker.regional['kr']);
        runDatePicker();

        /**
        *   PURPOSE :   추가 버튼 동작 임시 나중에 수정 필요
        *   CREATE  :   20171115_wed    JI
        *   MODIFY  : 20171116_thur JI  => 추가등록 삭제버튼
        */
        $(".add_btn").click(function () {
            if (confirm("예약신청 폼을 추가 합니까?")) {

                var sec2    =   $(".sec2").eq(0).clone();
                var sec2_1  =   sec2.children().eq(3).remove();
                sec2        =   $(".sec2").eq(0).clone();
                var sec2_2  =   sec2.children().eq(4).remove();
                var sec3    =   $(".sec3").eq(0).clone();


                $(".dateTimeSec").append("<section class='sec2 topbox2'></section>");
                $(".sec2").eq(-1).append(sec2_1);
                $(".sec2").eq(-1).append(sec2_2);
                $(".dateTimeSec").append(sec3);

                useCheckArr.push('N');
                $(".useCheck").val(useCheckArr);
                
				var day = $(".sec2");
                
                for(var i=0; i<day.length; i++){
                	day.eq(i).attr("id", "day_"+i);
                }
                
				var day2 = $(".sec3");
                
                for(var i=0; i<day2.length; i++){
                	day2.eq(i).attr("id", "time_"+i);
                }

                runDatePicker();
            }
        });
        $(".rm_btn").click(function () {
            var sec2Class   =   $(".sec2");
            console.log(sec2Class.length);
            if (sec2Class.length < 2) {
                alert("마지막 등록 폼은 삭제할 수 없습니다.");
                return;
            }
            sec2Class.eq(-1).remove();
            $(".sec3").eq(0).remove();
        });
        /* END */

        $(document).on('click',".dateCheck",function(){
            var index   =   $(".dateCheck").index(this);

            var cnt = 0;
            $("#day_"+index+" input[name=dateDay]:checked").each(function() {
                cnt++;
            });

            if(parseInt($("#time_"+index+" .time_start").eq(index).val()) > parseInt($("#time_"+index+" .time_end").eq(index).val())){
                alert("종료시간이 시작시간보다 이릅니다.");
            }

            if($("#date_start").val() == ""){
                alert("시작날짜를 입력하여 주십시오.");
            }else if($("#date_end").val() == ""){
                alert("종료날짜를 입력하여 주십시오.");
            }else if(cnt == 0){
                alert("요일을 선택하여 주십시오.")
            }else if($("#time_"+index+" .time_start").val() == ""){
                alert("시작시간을 선택하여 주십시오.");	
            }else if($("#time_"+index+" .time_end").val() == ""){
                alert("종료시간을 선택하여 주십시오.");	
            }else{
                var dateDay = Array();
                var cnt = 0;
                var dateVal;
                $("#day_"+index+" input[name=dateDay]:checked").each(function() {
                    dateVal = $(this).val();
                    dateDay[cnt] = dateVal;
                    cnt++;
                });

                var school_id 		= $("#school_id").val();
                var reserve_type 	= $("#reserve_type").val();
                var reserve_type2 	= $("#reserve_type2").val();
                var date_start 		= $("#date_start").val();
                var date_end 		= $("#date_end").val();
                var time_start 		= $("#time_"+index+" .time_start").val();
                var time_end 		= $("#time_"+index+" .time_end").val();
                var count 			= $("#count").val();

                var str = {
                    "school_id" 	: school_id,
                    "reserve_type"	: reserve_type,
                    "reserve_type2"	: reserve_type2,
                    "dateDay" 		: dateDay,
                    "date_start" 	: date_start,
                    "date_end" 		: date_end,
                    "time_start" 	: time_start,
                    "time_end" 		: time_end,
                    "count" 		: count
                };

                $.ajaxSettings.traditional = true
                $.ajax({
                    url : '/program/school_reserve/longCheck.jsp',
                    data : str,
                    success : function(data) {
                        var returnVal = data.trim();
                        if(returnVal == "Y") {
                            alert("예약가능");
                            $("#useCheck").val("Y");
                        }else if(returnVal =="N"){
                            alert("예약불가");
                            $("#useCheck").val("N");
                        }else{
                            $("#useCheck").val("N");
                        }

                        useCheckArr[index]  =   returnVal;
                        $("#useCheck").val(useCheckArr);
                    },
                    error : function(e) {
                        alert("에러발생");
                        useCheckArr[index]  =   "N";
                        $("#useCheck").val(useCheckArr);
                    }
                });
            }
        });

        $("#user_phone").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") );} );
        $("#reserve_man").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") );} );
        $("#total_price").keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") );} );

    });
    
    function runDatePicker () {
        /* $( ".date_start" ).datepicker({dateFormat: 'yy-mm-dd'}); */
        
        $('.date_start').datepicker({
            dateFormat: "yy-mm-dd",             // 날짜의 형식
            onClose: function( selectedDate ) {    
                // 시작일(fromDate) datepicker가 닫힐때
                // 종료일(toDate)의 선택할수있는 최소 날짜(minDate)를 선택한 시작일로 지정
                $(".date_end").datepicker( "option", "minDate", selectedDate );
            }                
        });
        
        $( ".date_end" ).datepicker({
            dateFormat: 'yy-mm-dd'
        });
        $( ".date_start, .date_end").removeClass("hasDatepicker");
    }

    function formPost(){

        var cnt = 0;
        $("input[name=dateDay]:checked").each(function() {
            cnt++;
        });

        if($("#date_start").val() == ""){
            alert("시작날짜를 입력하여 주십시오.");
        }else if($("#date_end").val() == ""){
            alert("종료날짜를 입력하여 주십시오.");
        }else if(cnt == 0){
            alert("요일을 선택하여 주십시오.");
        }else if($("#time_start").val() == ""){
            alert("시작시간을 선택하여 주십시오.");
        }else if($("#time_end").val() == ""){
            alert("종료시간을 선택하여 주십시오.");	
        /**
        *   PURPOSE :   #useCheck arr 변수 확인 function 호출 및 생성
        *   CREATE  :   20171115_wed    JI
        *   MODIFY  :   ...
        */
        }else if(!useCheckChk ()){
            alert("예약가능시간 확인을 해주십시오.");
        }else if($.trim($("#total_price").val()) == ""){
            alert("사용금액을 입력하여 주십시오.");
        }else if($.trim($("#user_name").val()) == ""){
            alert("예약자명을 선택하여 주십시오.");
        }
        
        /* else if($.trim($("#organ_name").val()) == ""){
            alert("사용단체명을 선택하여 주십시오.");	
        } */
        
        else if($.trim($("#user_phone").val()) == ""){
            alert("휴대폰번호를 선택하여 주십시오.");	
        }else if($.trim($("#reserve_man").val()) == ""){
            alert("사용인원을 선택하여 주십시오.");	
        }else if($.trim($("#use_purpose").val()) == ""){
            alert("사용목적을 선택하여 주십시오.");	
        }else{
			var sec2 = $(".sec2");
        	
        	var chkArr = new Array();
        	var check = new Array();
        	
        	var html = "";
        	
        	for(var i=0; i<sec2.length; i++){
        		chkArr = new Array();
        		check = new Array();
        		$("#day_"+i+" input[name=dateDay]:checked").each(function() {
        			check.push($(this).val());
        		});
        		chkArr.push(check);
        		html += '<input type="hidden" name="arr" id="arr" value="' + chkArr + '" >';
        		
        	}
        	$("#test").html(html);
        	
            if(confirm("등록하시겠습니까?")){
                $("#postForm").attr("action", "/program/school_reserve/action2.jsp");
                $("#postForm").submit();
            }else{
                return false;
            }
        }
    }
    
    function useCheckChk () {
        var resBool =   true;
        for (i = 0; i < useCheckArr.length; i++) {
            if (useCheckArr[i]  ==  'N') resBool   =   false;
        }
        return resBool;
    }
    /* END */

    function reserve_type_change(){
        $("#postForm").attr("action","").submit();
        //ajax 로 사용가능 여부 확인하는 code 로 변경해야함.
    }

</script>
<form method="post" id="postForm" class="booking">
<div id="test">
</div>

<%
/**
*   PURPOSE : 임시 추가 버튼 구현 button.add_btn
*   CREATE  : 20171115_wed  JI
*   MODIFY  : 20171116_thur JI  => 추가등록 삭제버튼
*/
%>
    <button type="button" class="btn edge small mako add_btn">등록추가버튼</button>
    <button type="button" class="btn edge small mako rm_btn">추가등록 삭제버튼</button>
<!-- END -->
    <input type="hidden" name="adminCheck" id="adminCheck" value="<%=adminCheck%>">
    <input type="hidden" name="room_id" id="room_id" value="<%=room_id%>">
    <input type="hidden" name="school_id" id="school_id" value="<%=school_id%>">
    <input type="hidden" name="useCheck" id="useCheck" class="useCheck" value="">

    <section class="sec1 topbox3">
        <h3 class="blind">시설구분</h3>
        <p class="kind">
            <label>시설명
            
            	<!-- 2017.11.23.
            	시설명을 DB에서 가져오게 수정 -->
                <select id="reserve_type" name="reserve_type" onchange="reserve_type_change()">
                <%
                if(roomList != null && roomList.size() > 0){
                	for(Map<String,Object> ob : roomList){
                %>
                        <option value="<%=ob.get("RESERVE_TYPE") %>" <%if(ob.get("RESERVE_TYPE").equals(reserve_type)){%>selected="selected"<%}%>>
                        	<%=ob.get("RESERVE_TYPE") %>
                        </option>
                <%
                	}
                }
                %>
                </select>
            </label>
            
            <!-- 2017.11.23.
            	기타시설명을 DB에서 가져오게 수정 -->
            <%
            if(!"".equals(reserve_type2) && reserve_type2!=null){
            %>
            <label>기타시설명	
        	    <select id="reserve_type2" name="reserve_type2" onchange="reserve_type_change()">
            	<%
                if(roomList2 != null && roomList2.size() > 0){
                	for(Map<String,Object> ob : roomList2){ 
                		if(!"".equals(ob.get("RESERVE_TYPE2"))){
                %>
                        <option value="<%=ob.get("RESERVE_TYPE2") %>" <%if(ob.get("RESERVE_TYPE2").equals(reserve_type2)){%>selected="selected"<%}%>>
                        	<%=ob.get("RESERVE_TYPE2") %>
                        </option>
                <%
                		}
                	}
                }
                %>
            	</select>
            </label>
           <%
           } 
           %>
        </p>
		
		<!-- 2017.11.23.
            	사용시설 수를 DB에서 가져오게 수정 -->
        <p class="kind">
            <label for="count">사용시설 수</label>
            <select name="count" id="count"">
            	<%
            	if(!"".equals(reserve_number)){
            	for(int i=1; i<=Integer.parseInt(reserve_number); i++){ %>
                <option value="<%=i%>"><%=i%></option>
                <%}} %>
            </select>
        </p>
    </section>

    <div class="dateTimeSec">
    <section class="sec2 topbox2" id="day_0">
        <h3 class="title item col-2 mo-col-12">사용일자</h3>
        <div class="item col-7 mo-col-12 datePickerSec">
        <label for="reserve_start" class="blind">시작날짜 선택</label>
        <input type="text" name="date_start" id="date_start" class="date_start" value="" placeholder="시작날짜 입력" readonly="readonly">
         ~
        <label for="reserve_end" class="blind">종료날짜 선택</label>
        <input type="text" name="date_end" id="date_end" class="date_end" value="" placeholder="종료날짜 입력" readonly="readonly">
        </div>
      <div class="clr padB10"> </div>

      <h3 class="title item col-2 mo-col-12">요일지정</h3>
      <div class="item col-7 mo-col-12">
        <span><input type="checkbox" id="mon" name="dateDay" value="월"/>월</span>
        <span><input type="checkbox" id="tue" name="dateDay" value="화"/>화</span>
        <span><input type="checkbox" id="wed" name="dateDay" value="수"/>수</span>
        <span><input type="checkbox" id="thu" name="dateDay" value="목"/>목</span>
        <span><input type="checkbox" id="fri" name="dateDay" value="금"/>금</span>
        <span><input type="checkbox" id="sat" name="dateDay" value="토"/>토</span>
        <span><input type="checkbox" id="sun" name="dateDay" value="일"/>일</span>
      </div>
        <div class="clr"> </div>

        <!-- 모달 윈도우  -->
        <div id="myModal" class="modal" style="display: none;">
            <!-- Modal content -->
            <div class="modal_content">
            <p class="modal_top">예약가능 시간 확인 <a class="btn_cancel" id="modalClose" style="cursor:pointer;"><img src="/img/school/layer_close2.png" alt="닫기"></a></p>
                <div class="" id="checkDiv">
                    <table class="tb_board">
                        <caption>선택한 날짜의 예약 가능여부 확인 표입니다.</caption>
                        <colgroup>
                            <col>
                            <col>
                            <col>
                            <col>
                        </colgroup>
                        <thead>
                            <tr><th scope="col">일자</th>
                            <th scope="col">시간</th>
                            <th scope="col">가능여부</th>
                            <th scope="col">선택</th>
                        </tr></thead>
                        <tbody>
                            <tr>
                                <td>2017-09-12</td>
                                <td>12:00 ~ 13:00</td>
                                <td><span class="green">예약가능</span><!-- span class="red">예약불가능</span--></td>
                                <td><label><input type="checkbox" name="date_check" id="check_1" value=""></label></td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="c">
                        <button type="button" class="btn edge small darkMblue" onclick="dateConfirm()">확인</button>
                    </div>
                </div>
            </div>
        </div>
        <script>
        var modal = document.getElementById('myModal');
        var btn = document.getElementById("myBtn");
        var modalClose = document.getElementById("modalClose");

        function ori_image(path) {
            var path_split = path.split("/");
            path = path_split[0] + "/" + path_split[1] + "/" + path_split[2] + "/" + path_split[3] + "/" + path_split[5];
            $(".modal_content img").eq(1).attr("src", path);
            modal.style.display = "block";
        }

        modalClose.onclick = function () {
            modal.style.display = "none";
        }
        window.onclick = function (event) {
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }

    </script>
    <!-- //모달 윈도우 끝 -->

    </section>
    <!-- // 달력 끝 -->
    <!-- 예약시간 선택 -->
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

    <section class="sec3 topbox3 longbook" id="time_0">
        <h3 class="title">사용시간 선택</h3>
        <span class="red subscript">* 시작시간과 종료시간을 선택하세요.</span>
        <div class="time_sel magL">
        <label for="reserve_time1_1" class="blind">시작시간 선택</label>
        <select name="time_start" id="time_start" class="time_start">
                <option value="">선택</option>
                <%
                for(int i=0; i<timeStr.length; i++){
                %>
                    <option value="<%=timeStr2[i]%>" ><%=timeStr[i]%></option>
                <%} %>
            </select>
        ~
        <label for="reserve_time1_2" class="blind">종료시간 선택</label>
        <select name="time_end" id="time_end" class="time_end">
                <option value="">선택</option>
                <%
                for(int i=0; i<timeStr.length; i++){
                %>
                    <option value="<%=timeStr2[i]%>" ><%=timeStr[i]%></option>
                <%} %>
            </select>
        <button type="button" class="btn edge small mako dateCheck" id="dateCheck">예약가능시간 확인</button>
            <div class="clr"> </div>
        </div>
    </section>

    </div>

    <!-- 사용금액 -->
    <section class="sec5 topbox2">
        <h3 class="title">사용금액</h3>
        <div class="topbox3">
            <input type="text" name="total_price" id="total_price" value="" class="wps_40"> 원
        </div>
    </section>


    <!-- 예약자 정보 -->
    <section class="sec7 topbox1">
        <h3 class="title"> 예약자 정보 </h3>
        <table class="table_skin01 txt_l">
            <caption> 예약자명, 사용단체명, 휴대폰번호, 사용인원, 사용목적 등을 기입하는 예약자 정보 입력표입니다. </caption>
            <colgroup>
                <col class="wps_20">
                <col>
                <col class="wps_20">
                <col class="wps_25">
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row"><span class="red">*</span> 예약자명</th>
                    <td><label><span class="mo_tit"><span class="red">*</span> 예약자명</span><input type="text" class="wps_80" name="user_name" id="user_name"></label></td>
                    <th scope="row">사용단체명</th>
                    <td><label><span class="mo_tit">사용단체명</span><input type="text" class="wps_100" name="organ_name" id="organ_name"></label> </td>
                </tr>
                <tr>
                    <th scope="row"><span class="red">*</span> 휴대폰번호</th>
                    <td><label><span class="mo_tit"><span class="red">*</span> 휴대폰번호</span><input type="text" class="wps_80" name="user_phone" id="user_phone"></label>
                        <p class="fontsmall magT5">※ 진행상태를 문자로 알려드립니다. 연락가능한 휴대전화번호를 <u class="red">숫자만</u> 정확히 기재하세요.</p>
                    </td>
                    <th scope="row"><span class="red">*</span> 사용인원</th>
                    <td>
                        <label for="reserve_man"><span class="mo_tit"><span class="red">*</span> 사용인원</span>
                        <input type="text" class="wps_80" name="reserve_man" id="reserve_man">
                        </label>
                    </td>
                </tr>
                <tr>
                    <th scope="row"><span class="red">*</span> 사용목적</th>
                    <td colspan="3">
                        <label><span class="mo_tit"><span class="red">*</span> 사용목적</span>
                        <textarea class="wps_90 h050" name="use_purpose" id="use_purpose"></textarea>
                        </label>
                    </td>
                </tr>
            </tbody>
        </table>
    </section>

    <div class="c magT30">
        <button type="button" class="btn edge medium darkMblue" onclick="formPost()">예약하기</button>
    </div>
</form>