<%@page import="javax.swing.text.StyledEditorKit.ForegroundAction"%>
<%
/**
*	PURPOSE	:	전입학 / 전입학 오프라인 등록
*	CREATE	:	20180116_thur	JI
*	MODIFY	:	20180306 LJH css 클래스 수정
*/
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");
/************************** 접근 허용 체크 - 시작 **************************/
SessionManager sessionManager = new SessionManager(request);
String sessionId = sessionManager.getId();
if(sessionId == null || "".equals(sessionId)) {
	alertParentUrl(out, "관리자 로그인이 필요합니다.", adminLoginUrl);
	if(true) return;
}

String roleId= null;
String[] allowIp = null;
Connection conn2 = null;
try {
	sqlMapClient.startTransaction();
	conn2 = sqlMapClient.getCurrentConnection();
	
	// 접속한 관리자 회원의 권한 롤
	roleId= getRoleId(sqlMapClient, conn2, sessionId);
	
	// 관리자 접근 허용된 IP 배열
	allowIp = getAllowIpArrays(sqlMapClient, conn2);
} catch (Exception e) {
	sqlMapClient.endTransaction();
	alertBack(out, "트랜잭션 오류가 발생했습니다.");
} finally {
	sqlMapClient.endTransaction();
}

// 권한정보 체크
boolean isAdmin = sessionManager.isRole(roleId);

// 접근허용 IP 체크
String thisIp = request.getRemoteAddr();
boolean isAllowIp = isAllowIp(thisIp, allowIp);

/** Method 및 Referer 정보 **/
String getMethod = parseNull(request.getMethod());
String getReferer = parseNull(request.getHeader("referer"));

if(!isAdmin) {
	alertBack(out, "해당 사용자("+sessionId+")는 접근 권한이 없습니다.");
	if(true) return;
}
if(!isAllowIp) {
	alertBack(out, "해당 IP("+thisIp+")는 접근 권한이 없습니다.");
	if(true) return;
}
/************************** 접근 허용 체크 - 종료 **************************/

Connection conn	=	null;
PreparedStatement pstmt =   null;
ResultSet rs            =   null;
StringBuffer sql        =   null;
String sql_str          =   "";
String sql_where        =   "";
int key                 =   0;
int result              =   0;

/** Special varialbes **/
List<Map<String, Object>> specialList   =	null;
List<Map<String, Object>> foreignList   =	null;

String specialCode      =   "";
String specialCodeNm    =   "";
String foreignCode		=	"";
String foreignCodeNm	=	"";
String transferNo		=	"";

boolean adminChk	=	sessionManager.isRoleAdmin();

/** END **/

try {

	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	//특이사항
    sql            	=   new StringBuffer();
    sql_str        	=   "SELECT * FROM TCODE WHERE PCODE = 'SPECIALDT' ORDER BY ORDER1, ORDER2, ORDER3";
    sql.append(sql_str);
    pstmt          	=   conn.prepareStatement(sql.toString());
	rs             	=   pstmt.executeQuery();
	specialList    	=   getResultMapRows(rs);

	if (rs != null) try { rs.close(); } catch (SQLException se) {}
    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}

  	//제2외국어 리스트
    sql            	=   new StringBuffer();
    sql_str        	=   " SELECT FCODE, FNAME FROM TFOREIGN_CODE			";
    sql_str			+=	" WHERE USEYN = 'Y' ORDER BY ORDERED, ROWNUM, FCODE ";
    sql.append(sql_str);
    pstmt          	=   conn.prepareStatement(sql.toString());
	rs             	=   pstmt.executeQuery();
	foreignList    	=   getResultMapRows(rs);

	if (rs != null) try { rs.close(); } catch (SQLException se) {}
    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}

    //임시저장 여부 확인
    sql            	=   new StringBuffer();
    sql_str        	=   " SELECT TRANSFERNO FROM TTRANSFER					";
    sql_str			+=	" WHERE TEMPFLAG = 'Y' AND ROWNUM = 1				";
    sql_str			+=	" ORDER BY APPLYDATE DESC							";
    sql.append(sql_str);
    pstmt          	=   conn.prepareStatement(sql.toString());
	rs             	=   pstmt.executeQuery();
	if(rs.next())	transferNo	=	rs.getString("TRANSFERNO");

} catch (Exception e) {
    out.println(e.toString());
	e.printStackTrace();
	//alertBack(out, "처리중 오류가 발생하였습니다.");
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
    <title>RFC관리자 > 전입학 오프라인 등록</title>
    <script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
    <script type='text/javascript' src='/js/jquery.js'></script>
    <script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
    <script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/program/excel/common/js/common.js"></script>
    <script type="text/javascript" src="/program/excel/common/js/popup.js"></script>
    <link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
    <link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css" />
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
    <style>
	 .ui-datepicker{
		 font-size : 16px;
		 width : 230px;
	 }
	 .ui-datepicker select.ui-datepicker-month{
		 font-size: 13px;
		 color:black;
	 }

	 .ui-datepicker select.ui-datepicker-year{
		 font-size: 13px;
		 color:black;
	 }
</style>
</head>
<body>

    <h1 class="blind">전입학 오프라인 등록</h1>
    <div id="right_view">
        <div class="top_view">
            <p class="location"><strong>전입학 오프라인 등록</strong></p>
						<p class="loc_admin fb">
							<a href="/iam/main/index.sko?lang=en_US" target="_top" class="white">ENGLISH</a> <span class="yellow">[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span> 님 안녕하세요.
							<a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
						</p>
        </div>
    </div>
    <div id="content">
        <!-- 주의사항 -->
        <section>
            <h2 class="tit">주의사항</h2>
            <div class="topbox2">
                <ul class="list_num">
                    <li><i>1</i>승인시 접수번호가 자동으로 생성됩니다.</li>
                    <li><i>2</i>접수번호는 년도 변경시 '년도+001'부터 시작합니다. <span class="red">예)20100001</span></li>
                    <li><i>3</i>희망학교를 선택 시 현재 재학중인 학교는 제외하고 선택하여 주십시오.</li>
                </ul>
            </div>
        </section>
        <!-- ./주의사항 -->
        <form name="postForm" id="postForm" method="post" action="/program/transfer/admin/tra_off_act.jsp?actType=insert" onsubmit="return schoolChk(this);">
            <!-- 특이사항 -->
            <section>
                <h2 class="tit">특이사항</h2>
                <div class="topbox3 clearfix">
                    <fieldset>
                        <div class="f_l">
                            <label for="transfer_special">특이사항 선택 : </label>
                            <select name="transfer_special" id="transfer_special" required>
                            <option value="">특이사항 선택</option>
                            <%
                                if (specialList != null && specialList.size() > 0) {
                                    for (int i = 0; i < specialList.size(); i++) {
                                        Map<String, Object> dataMap =   specialList.get(i);
                                        specialCode     =   parseNull((String)dataMap.get("CODE"));
                                        specialCodeNm   =   parseNull((String)dataMap.get("CODENAME"));
                                        out.println("<option value="+ specialCode +">"+ specialCodeNm +"</option>");
                                    }
                                }
                            %>
                            </select>
                        </div>
                        <div class="f_l fb magL20 magT5">
                            <span class="red">*</span> 특이사항을 반드시 선택하여 주십시오, 해당 특이사항이 없을 경우에는 "해당없음"을 선택하시면 됩니다.
                        </div>
                    </fieldset>
                </div>
            </section>
            <!-- ./특이사항 -->
            <!-- 지원자(학생) 정보 -->
            <section>
                <h2 class="tit">지원자(학생) 정보</h2>
                <table class="bbs_list2">
									<caption>전입학 오프라인 지원자(학생) 정보입력</caption>
                    <colgroup>
                        <col style="width:22%">
                        <col />
                        <col style="width:22%">
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><span class="red">*</span><label for="schname">현재 재학교 이름</label></th>
                            <td colspan="3"><input type="text" class="wps_50" id="schname" name="schname" value="" required
                            onkeyup="javascript:searchSch(this);" autocomplete="off">
                            <div id="searchDiv" style="position:absolute;"></div></td>
                        </tr>
                        <tr>
                            <th scope="row"><span class="red">*</span><label for="stsdate">현재 재학교 입학일자</label></th>
                            <td><input type="text" id="stsdate" name="stsdate" value="" required></td>
                            <th scope="row"><span class="red">*</span><label for="stedate">현재 재학교 최종재학일자</label></th>
                            <td><input type="text" id="stedate" name="stedate" value="" required></td>
                        </tr>
                        <tr>
                            <th scope="row"><span class="red">*</span><label for="gubun">현재 재학구분</label></th>
                            <td>
	                            <select name="gubun" id="gubun" required>
	                            	<option value="">재학구분</option>
	                            	<option value="SH_NORMAL">종합고등학교 보통과</option>
	                            	<option value="SH_SPE_PURPOSE">특수목적 고등학교</option>
	                            	<option value="SH_SELF_PUBLIC">자율형 공립 고등학교</option>
	                            	<option value="SH_VOCATIONAL">종합고등학교 실업과</option>
	                            	<option value="SH_SPECIAL">특성화 고등학교</option>
	                            	<option value="NH_NIGHT">일반계고등학교 야간부</option>
	                            	<option value="SH_SELF_PRIVATE">자율형 사립 고등학교</option>
	                            	<option value="NH_DAY">일반계고등학교 주간부</option>
	                            </select>
                            </td>
                            <th scope="row"><span class="red">*</span><label for="stgrade">현재 재학교 학년/반</label></th>
                            <td>
                                <input type="text" id="stgrade" name="stgrade" value="" required class="w_70">학년
                                <input type="text" id="stclass" name="stclass" value="" required class="w_70">반
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><span class="red">*</span><label for="schtel">현재 재학교 연락처</label></th>
                            <td><input type="text" id="schtel" name="schtel" value="" required maxlength="11"></td>
                            <th scope="row"><label for="">현재 재학교 FAX</label></th>
                            <td><input type="text" id="schfax" name="schfax" value=""></td>
                        </tr>
                        <tr>
                            <th scope="row"><span class="red">*</span><label for="prezipcode">전주소</label></th>
                            <td colspan="3">
                                <input type="text" id="prezipcode" name="prezipcode" value="" class="w_70" required>
                                <span><input type="button" value="우편번호검색" class="btn small edge mako" onclick="javascript:goPopup('prev');"></span>
                                <input type="text" id="preaddr" name="preaddr" value="" class="wps_80" required>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><span class="red">*</span><label for="currzipcode">현주소</label></th>
                            <td colspan="3">
                                <input type="text" id="currzipcode" name="currzipcode" value="" class="w_70" required>
                                <span><input type="button" value="우편번호검색" class="btn small edge mako" onclick="javascript:goPopup('curr');"></span>
                                <input type="text" id="curraddr" name="curraddr" value="" class="wps_80" required>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><span class="red">*</span><label for="stname">학생 이름</label></th>
                            <td><input type="text" id="stname" name="stname" value="" required></td>
                            <th scope="row"><span class="red">*</span><label for="stjumin">주민등록번호 앞7자리</label></th>
                            <td><input type="text" id="stjumin" name="stjumin" value="" maxlength="7" required></td>
                        </tr>
                        <tr>
                            <th scope="row"><span class="red">*</span>성별</th>
                            <td>
                                <input type="radio" class="stsex" id="sex1" name="stsex" value="M"
                                onclick="javascript:genderChk(); return false;"><label for="sex1">남</label>&nbsp;&nbsp;
                                <input type="radio" class="stsex" name="stsex" id="sex2" value="F"
                                onclick="javascript:genderChk(); return false;"><label for="sex2">여</label>
                            </td>
                            <th rowspan="3"><span class="red">*</span><label for="hopeschname1">희망학교 <span>
                            <input type="button" value="학교선택하기" class="initialism slide_open openLayer btn small edge mako"
                            id="hopeSchool" onclick="javascript:hopeSchoolSel();"></span></label></th>
                            <td rowspan="3">
                                <span id="hopeschname1_txt">선택1<input type="text" id="hopeschname1" name="hopeschname1" value="" style="width: 70%" readonly="readonly">
                                <input type="hidden" name="hopeschno1" id="hopeschno1" value="">
                                </span><br>
                                <span id="hopeschname2_txt">선택2<input type="text" id="hopeschname2" name="hopeschname2" value="" style="width: 70%" readonly="readonly">
                                <input type="hidden" name="hopeschno2" id="hopeschno2" value="">
                                </span><br>
                                <span id="hopeschname3_txt">선택3<input type="text" id="hopeschname3" name="hopeschname3" value="" style="width: 70%" readonly="readonly">
                                <input type="hidden" name="hopeschno3" id="hopeschno3" value="">
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><span class="red">*</span><label for="fcode">제2외국어</label></th>
                            <td>
                                <select id="fcode" name="fcode" required>
                                <option value="">-해당없음-</option>
                                <%if(foreignList != null && foreignList.size() > 0){
                                	for(int i=0; i<foreignList.size(); i++){
                                	Map<String, Object> map = foreignList.get(i);
                                	foreignCode		=	(String)map.get("FCODE");
                                	foreignCodeNm	=	(String)map.get("FNAME");
                                	%>
                                	<option value="<%=foreignCode%>"><%=foreignCodeNm%></option>
                                	<%
                                	}
                                }%>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><span class="red">*</span><label for="fuseyn">제2외국어 반영유무</label></th>
                            <td>
                            <input type="radio" id="fuseyn" class="fuseyn" name="fuseyn" value="Y" required>사용함
                            <input type="radio" id="fuseyn2" class="fuseyn" name="fuseyn" value="N" checked="checked" required>사용안함
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="midschname">졸업 중학교 정보</label></th>
                            <td><input type="text" id="midschname" name="midschname" value="" style="width: 70%">중학교</td>
                            <td colspan="2">중학교 3학년 때의 반 정보 : <input type="text" id="midsch3class" name="midsch3class" value="">반</td>
                        </tr>
                    </tbody>
                </table>
            </section>
            <!-- ./지원자(학생) 정보 -->
            <!-- 보호자 인적사항 정보 -->
            <section>
                <h2 class="tit">보호자 인적사항</h2>
                <table class="bbs_list2">
									<caption>전입학 오프라인 보호자 인적사항 입력</caption>
                    <colgroup>
                        <col style="width:22%">
                        <col />
                        <col style="width:22%">
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><label for="ptname">성명</label></th>
                            <td><input type="text" id="ptname" name="ptname" value="" ></td>
                            <th scope="row"><label for="ptjumin">주민등록번호 앞7자리</label></th>
                            <td><input type="text" id="ptjumin" name="ptjumin" value="" ></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="pttel">연락처</label></th>
                            <td colspan="3"><input type="text" id="pttel" name="pttel" value=""  maxlength="11"></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="pthp">휴대폰</label></th>
                            <td  colspan="3">
                                <input type="text" id="pthp" name="pthp" value=""  >
                            </td>
                        </tr>
                    </tbody>
                </table>
            </section>
            <!-- ./보호자 인적사항 정보 -->
            <!-- 처리담당자 -->
            <section>
                <h2 class="tit">처리담당자</h2>
                <table class="bbs_list2">
									<caption>전입학 오프라인 보호자 처리담당자 입력</caption>
                    <colgroup>
                        <col style="width:22%">
                        <col />
                        <col style="width:22%">
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><span class="red">*</span><label for="mgname">처리자 이름</label></th>
                            <td><input type="text" id="mgname" name="mgname" value="" required></td>
                            <th scope="row"><span class="red">*</span><label for="mgtel">처리자 전화번호</label></th>
                            <td><input type="text" id="mgtel" name="mgtel" value="" required maxlength="11"></td>
                        </tr>
                            <tr>
                            <th scope="row"><span class="red">*</span><label for="mgposition">처리자 소속</label></th>
                            <td><input type="text" id="mgposition" name="mgposition" value="" required></td>
                            <th scope="row"><span class="red">*</span><label for="mgduty">처리자 직위</label></th>
                            <td><input type="text" id="mgduty" name="mgduty" value="" required></td>
                        </tr>
                        <tr>
                            <th colspan="2"><span class="red">*</span><label for="kind">전입학 오프라인 신청 종류 선택</label></th>
                            <td colspan="2">
                                <select id="kind" name="kind" required>
                                <option value="">신청종류선택</option>
                                <option value="OFFLINE_FAX">팩스신청</option>
                                <option value="OFFLINE_VISIT">방문신청</option>
                                </select>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </section>
            <!-- ./보호자 인적사항 정보 -->

            <div class="btn_area">
                <button type="button" class="f_l btn green medium" onclick="location.href='/program/transfer/admin/tra_req_list.jsp'">전입학 배정원서 목록</button>
								<p class="f_r">
									<input type="button" class="btn mako medium" onclick="javascript:temporary();" value="임시저장">
	                <button type="submit" class="btn skyblue medium">확인</button>
								</p>
            </div>
        </form>

    </div><!-- ./END content -->
    <!-- 희망학교 -->
	<div id="slide" style="display:none;">

	</div>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>

$(function() {
	$.datepicker.regional['ko'] = { // Default regional settings
        closeText: '닫기',
        prevText: '이전달',
        nextText: '다음달',
        currentText: '오늘',
        monthNames: ['1월(JAN)','2월(FEB)','3월(MAR)','4월(APR)','5월(MAY)','6월(JUN)',
        '7월(JUL)','8월(AUG)','9월(SEP)','10월(OCT)','11월(NOV)','12월(DEC)'],
        monthNamesShort: ['1월','2월','3월','4월','5월','6월',
        '7월','8월','9월','10월','11월','12월'],
        dayNames: ['일','월','화','수','목','금','토'],
        dayNamesShort: ['일','월','화','수','목','금','토'],
        dayNamesMin: ['일','월','화','수','목','금','토']
	};

	$.datepicker.setDefaults($.datepicker.regional['ko']);

     $( "#stsdate" ).datepicker({
          dateFormat: 'yymmdd',  //데이터 포멧형식
          changeMonth: true,    //달별로 선택 할 수 있다.
          changeYear: true,     //년별로 선택 할 수 있다.
          showOtherMonths: false,  //이번달 달력안에 상/하 빈칸이 있을경우 전달/다음달 일로 채워준다.
          selectOtherMonths: true,
          showButtonPanel: true  //오늘 날짜로 돌아가는 버튼 및 닫기 버튼을 생성한다.
     });
     $( "#stedate" ).datepicker({
         dateFormat: 'yymmdd',  //데이터 포멧형식
         changeMonth: true,    //달별로 선택 할 수 있다.
         changeYear: true,     //년별로 선택 할 수 있다.
         showOtherMonths: false,  //이번달 달력안에 상/하 빈칸이 있을경우 전달/다음달 일로 채워준다.
         selectOtherMonths: true,
         showButtonPanel: true  //오늘 날짜로 돌아가는 버튼 및 닫기 버튼을 생성한다.
    });

    <%if(!"".equals(transferNo)){%>
    var transferNo	=	"<%=transferNo%>";
    if(confirm("임시저장된 내용이 있습니다. 불러오시겠습니까?\n\n(불러오지 않을 경우 임시저장된 내용이 삭제됩니다.)")==true){
    	$.ajax({
			type : "POST",
			url : "/program/transfer/admin/tra_off_act.jsp?actType=tempCall",
			data : {"transferNo" : transferNo},
			dataType : "json",
			async : false,
			success : function(data){
				$("#transfer_special").val(data.transfer_special);
		 		$("#schname").val(data.schname);
		 		$("#stsdate").val(data.stsdate);
		 		$("#stedate").val(data.stedate);
		 		$("#gubun").val(data.gubun);
		 		$("#stgrade").val(data.stgrade);
		 		$("#stclass").val(data.stclass);
		 		$("#schtel").val(data.schtel);
		 		$("#schfax").val(data.schfax);
		 		$("#prezipcode").val(data.prezipcode);
		 		$("#preaddr").val(data.preaddr);
		 		$("#currzipcode").val(data.currzipcode);
		 		$("#curraddr").val(data.curraddr);
		 		$("#stname").val(data.stname);
		 		$("#stjumin").val(data.stjumin);
		 		$("input:radio[name='stsex'][value='"+data.stsex+"']").prop("checked", true);
		 		$("#fcode").val(data.fcode);
		 		$("input:radio[name='fuseyn'][value='"+data.fuseyn+"']").prop("checked", true);
		 		$("#hopeschname1").val(data.hopeschname1);
		 		$("#hopeschname2").val(data.hopeschname2);
		 		$("#hopeschname3").val(data.hopeschname3);
		 		$("#hopeschno1").val(data.hopeschno1);
		 		$("#hopeschno2").val(data.hopeschno2);
		 		$("#hopeschno3").val(data.hopeschno3);
		 		$("#midschname").val(data.midschname);
		 		$("#midsch3class").val(data.midsch3class);
		 		$("#ptname").val(data.ptname);
		 		$("#ptjumin").val(data.ptjumin);
		 		$("#pttel").val(data.pttel);
		 		$("#pthp").val(data.pthp);
		 		$("#mgname").val(data.mgname);
		 		$("#mgtel").val(data.mgtel);
		 		$("#mgposition").val(data.mgposition);
		 		$("#mgduty").val(data.mgduty);
		 		$("#kind").val(data.kind);
		 		
		 		if($("#transfer_special").val() == "1" || $("#transfer_special").val() == "6"){
					$("#hopeschname2_txt").css("display", "none");
					$("#hopeschname3_txt").css("display", "none");
				}else{
					$("#hopeschname2_txt").css("display", "");
					$("#hopeschname3_txt").css("display", "");
				}
			},
			error : function(request, status, error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText.trim()+"\n"+"error:"+error);
			}
		});
    }else{
    	$.ajax({
			type : "POST",
			url : "/program/transfer/admin/tra_off_act.jsp?actType=tempDel",
			data : {"transferNo" : transferNo},
			async : false,
			success : function(data){
				alert("임시저장된 내용이 삭제되었습니다.");
			},
			error : function(request, status, error){
				alert("임시저장된 내용을 삭제하는데 실패했습니다.");
			}
		});
    }
    <%}%>

});


	function hopeSchoolSel(){
		var gender		=	$("input:radio[name=stsex]:checked").val();
		var stGrade		=	$("input:text[name=stgrade]").val();
		var fuseYn		=	$("input:radio[name=fuseyn]:checked").val();
		var fcode		=	$("select[name=fcode]").val();
		var moveUrl		=	"/program/transfer/admin/tra_off_sch.jsp?stsex=" + gender + "&stgrade=" + stGrade + "&fuseYn=" + fuseYn + "&fcode=" + fcode;
		
		if(stGrade == null || stGrade == ""){
			alert("학년을 선택해주세요.");
			document.postForm.stgrade.focus();
			return;
		}

		if(gender == null || gender == ""){
			alert("성별을 선택해주세요.");
			document.postForm.stsex[0].focus();
			return;
		}


/* 		window.open(moveUrl, "test", "width=800px, height=400px, toolbar=no, menubar=no, scrollbars=no");
 */
		$.ajax({
			type : "POST",
			url : "/program/transfer/admin/tra_off_sch.jsp",
			data : {"stsex" : gender, "stgrade" : stGrade, "fuseyn" : fuseYn, "fcode" : fcode},
			async : false,
			success : function(data){
				$("#slide").html(data);
				$('#slide').popup({
			 		 focusdelay: 400,
			 		 outline: true,
			 		 vertical: 'top'
			 	});
			},
			error : function(request, status, error){
				alert(request);
			}
		});
	}

	function selTab(tabNo){
		var gender			=	$("input:radio[name=stsex]:checked").val();
		var stGrade			=	$("input:text[name=stgrade]").val();
		var fuseYn			=	$("input:radio[name=fuseyn]:checked").val();
		var fcode			=	$("select[name=fcode]").val();
		var schoolSelector	=	$("#selectSchools").html();
		var schoolType		=	$("#schType").html();

		$.ajax({
			type : "POST",
			url : "/program/transfer/admin/tra_off_sch.jsp",
			data : {"stsex" : gender, "stgrade" : stGrade, "fuseyn" : fuseYn, "fcode" : fcode, "goTab" : tabNo},
			async : false,
			success : function(data){
				$("#slide").html(data);
				$("#selectSchools").html(schoolSelector);
				$("#schType").html(schoolType);
				$('#slide').popup({
			 		 focusdelay: 400,
			 		 outline: true,
			 		 vertical: 'top'
			 	});
			},
			error : function(request, status, error){
				alert(request);
			}
		});
	}

	function schComp(schNo, schName, type) {
		var selectCnt = $("#selSchools>option").length;

		if($("#transfer_special :selected").val() == "1" && selectCnt >= 1 ){
			alert("체육 특기자는 하나의 희망교 선택만 가능합니다.");
			return;
		}
		if($("#transfer_special :selected").val() == "6" && selectCnt >= 1 ){
			alert("원적교는 하나의 희망교 선택만 가능합니다.");
			return;
		}
		if( $("#selSchools>option").length >= 3 ) {
			alert("우선순위 3개까지 지정 가능 합니다.");
			return;
		} else {
			if(type == "3"){
				alert("선택한 학교를 지망할 수 없습니다. 선택하신 학교는 현원이 정원의 5%를 초과하였습니다.");
				return;
			}else if(selectCnt > 0 && $("#schType>input").eq(0).val() == "1"){
				alert("선택하신 1지망 학교는 정원 미달이므로 2지망 학교를 선택하실 필요가 없습니다.");
				return;
			}
			for(var i=0; i<selectCnt; i++){
				if($("#selSchools>option").eq(i).val() == schNo){
					alert("이미 선택한 학교입니다.");
					return;
				}
			}
			$("#selSchools").append("<option value='" + schNo + "'>" + schName + "</option>");
			$("#schType").append("<input type='hidden' name='schType_" + schNo + "' id='schType_" + schNo + "' value='" + type + "'/>");
		}
	}

	function inputSchool(){

		if($("#selSchools>option").length < 3 && $("#transfer_special :selected").val() != "1" && $("#transfer_special :selected").val() != "6"
				&& $("#schType>input").eq(0).val() != "1"){
			alert("희망학교를 3개까지 선택하셔야합니다.");
			return;
		}

		$("#hopeschname1").val($("#selSchools>option").eq(0).text());
		$("#hopeschno1").val($("#selSchools>option").eq(0).val());
		$("#hopeschname2").val($("#selSchools>option").eq(1).text());
		$("#hopeschno2").val($("#selSchools>option").eq(1).val());
		$("#hopeschname3").val($("#selSchools>option").eq(2).text());
		$("#hopeschno3").val($("#selSchools>option").eq(2).val());

		$("#schType").html("");
	}

	function clearSchool(){
		alert("값의 변경으로 인해 희망학교가 초기화되었습니다.");
		$("#hopeschname1").val("");
		$("#hopeschno1").val("");
		$("#hopeschname2").val("");
		$("#hopeschno2").val("");
		$("#hopeschname3").val("");
		$("#hopeschno3").val("");

		$("#schType").html("");
	}

	$("#stgrade").on("input", function(){
		if($("#hopeschname1").val() != ""){
			clearSchool();
		}
	});

	$("#stjumin").on("input", function(){
		var stjumin	=	$("#stjumin").val();
		if(stjumin.length == 7){
			if(($("#stjumin").val().substr(6, 1)*1) % 2 != 0){
				$("input:radio[name='stsex'][value='M']").prop("checked", true);
			}else{
				$("input:radio[name='stsex'][value='F']").prop("checked", true);
			}
		}
		if($("#hopeschname1").val() != ""){
			clearSchool();
		}
	});

	$(".fuseyn").click(function(){
		if($("input:radio[name='fuseyn'][value='Y']").prop("checked")==true){
			if($("#fcode").val()==""){
				alert("제2외국어부터 선택해주세요.");
				$(".fuseyn[value='N']").prop("checked", true);
				$("#fcode").focus();
			}else{
				if($("#hopeschname1").val() != ""){
					clearSchool();
				}
			}
		}
	});

	$("#fcode").change(function(){
		if($("#fcode").val() == ""){
			$(".fuseyn[value='N']").prop("checked", true);
		}
		if($("#hopeschname1").val() != ""){
			clearSchool();
		}
	});

	$("#transfer_special").change(function(){
		if($("#transfer_special").val() == "1" || $("#transfer_special").val() == "6"){
			$("#hopeschname2_txt").css("display", "none");
			$("#hopeschname3_txt").css("display", "none");
		}else{
			$("#hopeschname2_txt").css("display", "");
			$("#hopeschname3_txt").css("display", "");
		}
	});

	function genderChk(){
		if($("#stjumin").val().length == 7 && $("#stjumin") != null){
			if(($("#stjumin").val().substr(6, 1)*1) % 2 != 0){
				$("input:radio[name='stsex'][value='M']").prop("checked", true);
			}else{
				$("input:radio[name='stsex'][value='F']").prop("checked", true);
			}
		}else{
			alert("성별은 주민등록번호 입력시 자동으로 선택됩니다.");
			$("#stjumin").focus();
		}
	}

	function optionRemove(){
		var selected	=	$("#selSchools>option:selected").val();
		$("#schType_"+selected).remove();
		$("#selSchools>option:selected").remove();
	}

	function goPopup(inputType){
		// 주소검색을 수행할 팝업 페이지를 호출합니다.
		// 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(http://www.juso.go.kr/addrlink/addrLinkUrl.do)를 호출하게 됩니다.
		var pop = window.open("/program/transfer/admin/jusoPopup.jsp?inputType=" + inputType,"pop","width=570,height=420, scrollbars=yes, resizable=yes");

		// 모바일 웹인 경우, 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(http://www.juso.go.kr/addrlink/addrMobileLinkUrl.do)를 호출하게 됩니다.
	    //var pop = window.open("/popup/jusoPopup.jsp","pop","scrollbars=yes, resizable=yes");
	}

	function jusoCallBack(roadFullAddr, zipNo, inputType){
		var returnAddr	=	"";
		var returnZip	=	"";
		if(inputType == "prev"){
			returnAddr	=	$("#preaddr");
			returnZip	=	$("#prezipcode");
		}else if(inputType == "curr"){
			returnAddr	=	$("#curraddr");
			returnZip	=	$("#currzipcode");
		}

		// 팝업페이지에서 주소입력한 정보를 받아서, 현 페이지에 정보를 등록합니다.
		returnAddr.val(roadFullAddr);
		returnZip.val(zipNo);
	}

 	/* //본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
    function postCode(type) {
    	var txt_addr	=	"";
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 도로명 조합형 주소 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }
                // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
                if(fullRoadAddr !== ''){
                    fullRoadAddr += extraRoadAddr;
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById(type + "zipcode").value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById(type + "addr").value = fullRoadAddr;

            }
        }).open();
 	} 	 */
 	//전화번호
	function autoHypenPhone(str){
		str = str.value.replace(/[^0-9]/g, '');
		var tmp = '';
		if( str.length < 4){
			return str;
		}else if(str.length < 7){
			tmp += str.substr(0, 3);
			tmp += '-';
			tmp += str.substr(3);
		return tmp;
		}else if(str.length < 11){
			tmp += str.substr(0, 3);
			tmp += '-';
			tmp += str.substr(3, 3);
			tmp += '-';
			tmp += str.substr(6);
		return tmp;
		}else{
			tmp += str.substr(0, 3);
			tmp += '-';
			tmp += str.substr(3, 4);
			tmp += '-';
			tmp += str.substr(7);
		return tmp;
		}
		return str;
	}

 	function temporary(){
 		var transfer_special	=	$("#transfer_special").val();
 		var schname				=	$("#schname").val();
 		var stsdate				=	$("#stsdate").val();
 		var stedate				=	$("#stedate").val();
 		var gubun				=	$("#gubun").val();
 		var stgrade				=	$("#stgrade").val();
 		var stclass				=	$("#stclass").val();
 		var schtel				=	$("#schtel").val();
 		var schfax				=	$("#schfax").val();
 		var prezipcode			=	$("#prezipcode").val();
 		var preaddr				=	$("#preaddr").val();
 		var currzipcode			=	$("#currzipcode").val();
 		var curraddr			=	$("#curraddr").val();
 		var stname				=	$("#stname").val();
 		var stjumin				=	$("#stjumin").val();
 		var stsex				=	"";
 		var fcode				=	$("#fcode").val();
 		var fname				=	$("#fcode :selected").text();
 		var fuseyn				=	$("input:radio[name='fuseyn']:checked").val();
 		var hopeschname1		=	$("#hopeschname1").val();
 		var hopeschname2		=	$("#hopeschname2").val();
 		var hopeschname3		=	$("#hopeschname3").val();
 		var hopeschno1			=	$("#hopeschno1").val();
 		var hopeschno2			=	$("#hopeschno2").val();
 		var hopeschno3			=	$("#hopeschno3").val();
 		var midschname			=	$("#midschname").val();
 		var midsch3class		=	$("#midsch3class").val();
 		var ptname				=	$("#ptname").val();
 		var ptjumin				=	$("#ptjumin").val();
 		var pttel				=	$("#pttel").val();
 		var pthp				=	$("#pthp").val();
 		var mgname				=	$("#mgname").val();
 		var mgtel				=	$("#mgtel").val();
 		var mgposition			=	$("#mgposition").val();
 		var mgduty				=	$("#mgduty").val();
 		var kind				=	$("#kind").val();
 		
 		if( $("input:radio[name='stsex']:checked").val() == null){
 			stsex	=	"";
 		}else{
 			stsex	=	$("input:radio[name='stsex']:checked").val();
 		}
 		location.href="/program/transfer/admin/tra_off_act.jsp?actType=temporary&transfer_special=" + transfer_special
 				+ "&stsdate=" + stsdate + "&stedate=" + stedate + "&gubun=" + gubun + "&stgrade=" + stgrade + "&stclass=" + stclass
 				+ "&schtel=" + schtel + "&schfax=" + schfax + "&prezipcode=" + prezipcode + "&preaddr=" + preaddr + "&currzipcode=" + currzipcode
 				+ "&curraddr=" + curraddr + "&stname=" + stname + "&stjumin=" + stjumin + "&stsex=" + stsex + "&fcode=" + fcode + "&fuseyn=" + fuseyn
 				+ "&hopeschname1=" + hopeschname1 + "&hopeschname2=" + hopeschname2 + "&hopeschname3=" + hopeschname3 + "&hopeschno1=" + hopeschno1
 				+ "&hopeschno2=" + hopeschno2 + "&hopeschno3=" + hopeschno3 + "&midschname=" + midschname + "&midsch3class=" + midsch3class
 				+ "&ptname=" + ptname + "&ptjumin=" + ptjumin + "&pttel=" + pttel + "&pthp=" + pthp + "&mgname=" + mgname + "&mgtel=" + mgtel
 				+ "&mgposition=" + mgposition + "&mgduty=" + mgduty + "&kind=" + kind + "&fname=" + fname + "&schname=" + schname;
 	}

 	function searchSch(str){
		var schName	=	str.value;
		$.ajax({
			type : "POST",
			url : "/program/transfer/admin/tra_off_auto.jsp",
			data : {"schName" : schName},
			async : false,
			success : function(data){
				$("#searchDiv").html(data.trim());
			},
			error : function(request, status, error){
			}
		});
	}

	function selInput(selectSch){
		$("#schname").val(selectSch);
		searchSch(selectSch);
	}
	
	function schoolChk(){
		if($("#hopeschname1").val() == ""){
			alert("희망학교를 선택해주세요.");
			$("#hopeSchool").focus();
			return false;
		}
		return true;
	}
</script>
</body>
