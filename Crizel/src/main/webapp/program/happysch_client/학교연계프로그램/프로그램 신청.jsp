<%
/**
*   PURPOSE :   <학교연계> 프로그램 신청 and 달력
*   CREATE  :   20180314_wed    JI
*   MODIFY  :   전일제반 모두 주석 처리 20180315_thur   JI
**/
%>

<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>

<%/*************************************** 프로그램 ****************************************/%>

<%!
/** Class Part **/
    private class ArtCalData {
        //calendar
        public String callDate;         //날짜
        public String callDateWeek;     //요일 한글
        public String hlyDateFlag;      //요일 구분 SA,SU = 토,일 D = 평일, H = 휴일
        public String hlyDateName;      //휴일 이름, NULL
        public String req_info;			// 특정일 신청자 정보

        //프로그램 변수
        public String pro_name;
        public int max_per;
        public int curr_per;

        //신청 변수
        public int req_no;
        public int pro_no;
        public String req_sch_id;
        public String sch_mng_nm;
        public String sch_mng_tel;
        public String sch_mng_mail;
        public String reg_date;
        public String reg_ip;
        public String apply_flag;
        public int req_cnt;
        public String req_date;
        public String req_aft_flag;
        public String req_sch_nm;
        public String req_sch_grade;
        public String req_sch_group;
        public String apply_date;

        //신청 불가 확인 변수
        public String able_sch_flag;
        public String my_request;
        public int my_req_no;
        public int hold_cnt;
        public int apply_cnt;
        public String mor_sch_flag;
        public String aft_sch_flag;
        
        public String mor_cnt_flag;
        public String aft_cnt_flag;
    }

    private class ArtCalList implements RowMapper<ArtCalData> {
        public ArtCalData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ArtCalData calData   =   new ArtCalData();
            //date values
            calData.callDate        =   rs.getString("MON_DTE");
            calData.callDateWeek    =   rs.getString("WEEK_DTE");
            calData.hlyDateFlag     =   rs.getString("HLY_DTE");
            calData.hlyDateName     =   rs.getString("HLY_NAME");
            //program tb data values
            calData.pro_name        =   rs.getString("PRO_NAME");
            calData.max_per         =   rs.getInt("MAX_PER");
            calData.curr_per        =   rs.getInt("CURR_PER");
            //request tb data values
            calData.req_no          =   rs.getInt("REQ_NO");
            calData.pro_no          =   rs.getInt("PRO_NO");
            calData.req_sch_id      =   rs.getString("REQ_SCH_ID");
            calData.sch_mng_nm      =   rs.getString("SCH_MNG_NM");
            calData.sch_mng_tel     =   rs.getString("SCH_MNG_TEL");
            calData.sch_mng_mail    =   rs.getString("SCH_MNG_MAIL");
            calData.reg_date        =   rs.getString("REG_DATE");
            calData.reg_ip          =   rs.getString("REG_IP");
            calData.apply_flag      =   rs.getString("APPLY_FLAG");
            calData.req_cnt         =   rs.getInt("REQ_CNT");
            calData.req_date        =   rs.getString("REQ_DATE");
            calData.req_aft_flag    =   rs.getString("REQ_AFT_FLAG");
            calData.req_sch_nm      =   rs.getString("REQ_SCH_NM");
            calData.req_sch_grade   =   rs.getString("REQ_SCH_GRADE");
            calData.req_sch_group   =   rs.getString("REQ_SCH_GROUP");
            calData.apply_date      =   rs.getString("APPLY_DATE");
            //block able request variables
            calData.able_sch_flag   =   rs.getString("ABLE_SCH_FLAG");
            calData.my_request      =   rs.getString("MY_REQUEST");
            //calData.my_req_no       =   rs.getInt("MY_REQ_NO");
            calData.hold_cnt        =   rs.getInt("HOLD_CNT");
            calData.apply_cnt        =   rs.getInt("APPLY_CNT");
            calData.mor_sch_flag    =   rs.getString("MOR_SCH_FLAG");
            calData.aft_sch_flag    =   rs.getString("AFT_SCH_FLAG");
            
            calData.mor_cnt_flag    =   rs.getString("MOR_CNT_FLAG");
            calData.aft_cnt_flag    =   rs.getString("AFT_CNT_FLAG");
            
            calData.req_info		=	rs.getString("REQ_INFO");
            return calData;
        }
    }

    public int dayOfWeek(String date) throws Exception{		// 1:일, 2:월, 3:화 , ... , 7:토
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd") ;
        Date nDate = dateFormat.parse(date) ;
        Calendar cal = Calendar.getInstance() ;
        cal.setTime(nDate);
        int dayNum = cal.get(Calendar.DAY_OF_WEEK) ;
    	return dayNum;
    }
%>

<%
try{
	

String listPage		=	"DOM_000000129001001002";	//	DOM_000000139008002002	,	TEST : DOM_000000129001001002
String viewPage		=	"DOM_000000129001001003";	//	DOM_000000139008002003	,	TEST : DOM_000000129001001003
String writePage	=	"DOM_000000129001001004";	//	DOM_000000139008002004	,	TEST : DOM_000000129001001004
String confirmPage	=	"DOM_000000129001001005";	//	DOM_000000139008002005	,	TEST : DOM_000000129001001005

String loginPage	=	"DOM_000000101001000000";	//	DOM_000000103007007000	,	TEST : DOM_000000101001000000

SessionManager sessionManager   =   new SessionManager(request);

String outHtml      =   "";
String tmpDate      =   "";

//request year / month value
Calendar cal            =   Calendar.getInstance();
SimpleDateFormat sdf    =   new SimpleDateFormat("yyyy")
                , sdf2  =   new SimpleDateFormat("MM")
                , sdf3  =   new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
                , sdf4  =   new SimpleDateFormat("dd")
                , adfToday  =   new SimpleDateFormat("yyyyMMdd");

String toDay        =   adfToday.format(cal.getTime());

String callYear     =   parseNull(request.getParameter("callYear"), sdf.format(cal.getTime()));     //기본은 이번년
String callMonth    =   parseNull(request.getParameter("callMonth"), sdf2.format(cal.getTime()));   //기본은 이번달

/** SQL Data Part **/
StringBuffer sql                =   null;
String sql_str                  =   "";
List<ArtCalData> calDateList    =   null;

int totalDate   =   0;
int cnt         =   0;
int num         =   0;
String tmpInfo	=	"";

    sql     =   new StringBuffer();
    sql_str =   "SELECT STANDARD_MONTH.* ";
    sql_str +=  ",(SELECT 					 ";
    sql_str +=  "	  REQ_SCH_NM || '(' || (SELECT LISTAGG(CASE REQ_AFT_FLAG		 "; 
    sql_str +=  "	                                          WHEN 'M' THEN '오후'	 ";	 
    sql_str +=  "	                                          WHEN 'F' THEN '오전'		 "; 
    sql_str +=  "	                                       END || ':' || (SELECT SUM(REQ_PER) FROM HAPPY_REQ_SCH_CNT WHERE REQ_NO = A.REQ_NO)  , ', ')  WITHIN GROUP (ORDER BY REQ_AFT_FLAG)		 ";  
    sql_str +=  "	                        FROM HAPPY_REQ_SCH A		 ";  
    sql_str +=  "	                        WHERE REQ_DATE = STANDARD_MONTH.MON_DTE AND APPLY_FLAG IN ('Y', 'N') AND REQ_SCH_ID = COMPARE_DATE.REQ_SCH_ID) || ')' AS REQ_INFO		 "; 
    sql_str +=  "	FROM HAPPY_REQ_SCH		 ";  
    sql_str +=  "	WHERE REQ_DATE = STANDARD_MONTH.MON_DTE AND APPLY_FLAG IN ('Y', 'N') AND REQ_SCH_ID = COMPARE_DATE.REQ_SCH_ID		 "; 
    sql_str +=  "	GROUP BY REQ_SCH_NM) AS REQ_INFO		 "; 
    sql_str +=  ", CASE ";
    sql_str +=  "   WHEN (SELECT COUNT(BANNO) FROM HAPPY_BAN_TABLE WHERE BAN_DATE = TO_DATE(TO_CHAR(STANDARD_MONTH.MON_DTE, 'YYYYMMDD'), 'YYYY-MM-DD')) > 0 ";
    sql_str +=  "   THEN 'H' ";
    sql_str +=  "   WHEN TO_CHAR(STANDARD_MONTH.MON_DTE, 'd') = '1' THEN 'SU' ";
    sql_str +=  "   WHEN TO_CHAR(STANDARD_MONTH.MON_DTE, 'd') = '7' THEN 'SA' ";
    sql_str +=  "   ELSE 'D' ";
    sql_str +=  "  END AS HLY_DTE ";
    sql_str +=  ", CASE (SELECT COUNT(BANNO) FROM HAPPY_BAN_TABLE WHERE BAN_DATE = TO_DATE(TO_CHAR(STANDARD_MONTH.MON_DTE, 'YYYYMMDD'), 'YYYY-MM-DD')) ";
    sql_str +=  "   WHEN 1 THEN (SELECT BAN_NM FROM HAPPY_BAN_TABLE WHERE BAN_DATE = TO_DATE(TO_CHAR(STANDARD_MONTH.MON_DTE, 'YYYYMMDD'), 'YYYY-MM-DD')) ";
    sql_str +=  "   ELSE NULL ";
    sql_str +=  "  END AS HLY_NAME ";
    sql_str +=  "  , (SELECT PRO_NAME FROM HAPPY_PRO_SCH WHERE PRO_NO = COMPARE_DATE.PRO_NO) AS PRO_NAME ";
    sql_str +=  "  , (SELECT MAX_PER FROM HAPPY_PRO_SCH WHERE PRO_NO = COMPARE_DATE.PRO_NO) AS MAX_PER ";
    sql_str +=  "  , (SELECT SUM(REQ_CNT) FROM HAPPY_REQ_SCH WHERE REQ_DATE = STANDARD_MONTH.MON_DTE AND PRO_NO = COMPARE_DATE.PRO_NO AND APPLY_FLAG IN ('Y', 'N')) AS CURR_PER ";
    sql_str +=  "  , COMPARE_DATE.* ";
/* 날짜 신청 여부 flag value 호출 */
    sql_str +=  "  , (CASE ";
    sql_str +=  "  WHEN (SELECT NVL(COUNT(REQ_SCH_ID), 0) FROM HAPPY_REQ_SCH WHERE REQ_DATE = STANDARD_MONTH.MON_DTE AND APPLY_FLAG IN ('Y', 'N')) >= 50 THEN 'N' ";
    sql_str +=  "  WHEN /*정원 확인*/ ";
    sql_str +=  "       (SELECT SUM(MAX_PER) FROM HAPPY_PRO_SCH WHERE DEL_FLAG != 'Y' AND SHOW_FLAG = 'Y') ";
    sql_str +=  "       <= (SELECT NVL(SUM(REQ_PER), 0) FROM (SELECT * FROM HAPPY_REQ_SCH WHERE APPLY_FLAG IN ('Y', 'N') AND REQ_AFT_FLAG = 'D') A LEFT JOIN HAPPY_REQ_SCH_CNT B ON A.REQ_NO = B.REQ_NO WHERE A.REQ_DATE = STANDARD_MONTH.MON_DTE) THEN 'N' ";
    //sql_str +=  "       WHEN /*내가 신청한 건지 확인*/ (SELECT NVL(COUNT(REQ_SCH_ID), 0) FROM HAPPY_REQ_SCH WHERE (REQ_DATE = STANDARD_MONTH.MON_DTE) AND APPLY_FLAG IN ('Y', 'N') AND REQ_SCH_ID = '"+sessionManager.getId()+"') > 0 THEN 'N' ";
    sql_str +=  "       ELSE 'Y' ";
    sql_str +=  "  END) AS ABLE_SCH_FLAG ";

 	// 오전 프로그램에 신청했으면 막기
    sql_str +=  ", (CASE														";
    sql_str +=  "      WHEN  (SELECT COUNT(*) AS CNT							";
    sql_str +=  "             FROM HAPPY_REQ_SCH								";
    sql_str +=  "             WHERE REQ_SCH_ID = '"+sessionManager.getId()+"' AND APPLY_FLAG IN ('Y', 'N') AND REQ_DATE = STANDARD_MONTH.MON_DTE AND REQ_AFT_FLAG = 'M') > 0 THEN 'N'	";
    sql_str +=  "      ELSE 'Y'								";
    sql_str +=  "     END									";
    sql_str +=  "  ) AS MOR_CNT_FLAG						";
  	 
 	// 오후 프로그램에 신청했으면 막기
    sql_str +=  ", (CASE														";
    sql_str +=  "      WHEN  (SELECT COUNT(*) AS CNT							";
    sql_str +=  "             FROM HAPPY_REQ_SCH								";
    sql_str +=  "             WHERE REQ_SCH_ID = '"+sessionManager.getId()+"' AND APPLY_FLAG IN ('Y', 'N') AND REQ_DATE = STANDARD_MONTH.MON_DTE AND REQ_AFT_FLAG = 'F') > 0 THEN 'N'	";
    sql_str +=  "      ELSE 'Y'								";
    sql_str +=  "     END									";
    sql_str +=  "  ) AS AFT_CNT_FLAG  						";

    sql_str +=  "  , (CASE ";
    sql_str +=  "  WHEN /*내가 신청 승인완료*/ ";
    sql_str +=  "  (SELECT NVL(COUNT(REQ_SCH_ID), 0) FROM (SELECT * FROM HAPPY_REQ_SCH WHERE APPLY_FLAG = 'Y') WHERE REQ_DATE = STANDARD_MONTH.MON_DTE AND REQ_SCH_ID = '"+sessionManager.getId()+"') > 0 ";
    sql_str +=  "  THEN 'Y' ";
    sql_str +=  "  WHEN /*내가 신청 승인대기*/ ";
    sql_str +=  "  (SELECT NVL(COUNT(REQ_SCH_ID), 0) FROM (SELECT * FROM HAPPY_REQ_SCH WHERE APPLY_FLAG = 'N') WHERE REQ_DATE = STANDARD_MONTH.MON_DTE AND REQ_SCH_ID = '"+sessionManager.getId()+"') > 0 ";
    sql_str +=  "  THEN 'H' ";
    sql_str +=  "  END) AS MY_REQUEST ";

    //sql_str +=  "  , (SELECT REQ_NO FROM HAPPY_REQ_SCH WHERE REQ_DATE = STANDARD_MONTH.MON_DTE AND REQ_SCH_ID = '"+sessionManager.getId()+"' AND APPLY_FLAG IN ('Y', 'N')) AS MY_REQ_NO ";

    //승인대기자
    sql_str +=  "  , (SELECT NVL(COUNT(REQ_NO), 0) FROM HAPPY_REQ_SCH ";
    sql_str +=  "  WHERE REQ_DATE = STANDARD_MONTH.MON_DTE AND REQ_SCH_ID NOT IN ('"+sessionManager.getId()+"') AND APPLY_FLAG IN ('N') ";
    sql_str +=  "  ) AS HOLD_CNT ";
    //승인완료
    sql_str +=  "  , (SELECT NVL(COUNT(REQ_NO), 0) FROM HAPPY_REQ_SCH ";
    sql_str +=  "  WHERE REQ_DATE = STANDARD_MONTH.MON_DTE AND REQ_SCH_ID NOT IN ('"+sessionManager.getId()+"') AND APPLY_FLAG IN ('Y') ";
    sql_str +=  "  ) AS APPLY_CNT ";

    sql_str +=  "  , (CASE ";
    sql_str +=  "  WHEN ";
    sql_str +=  "  (SELECT SUM(MAX_PER) FROM HAPPY_PRO_SCH WHERE DEL_FLAG != 'Y' AND SHOW_FLAG = 'Y') ";
    sql_str +=  "    <= (SELECT NVL(SUM(REQ_PER), 0) FROM (SELECT * FROM HAPPY_REQ_SCH WHERE APPLY_FLAG IN ('Y', 'N') AND REQ_AFT_FLAG IN ('M', 'D')) A LEFT JOIN HAPPY_REQ_SCH_CNT B ON A.REQ_NO = B.REQ_NO WHERE A.REQ_DATE = STANDARD_MONTH.MON_DTE) THEN 'N' ";
    sql_str +=  "  ELSE 'Y' ";
    sql_str +=  "  END) AS MOR_SCH_FLAG ";
    sql_str +=  "  , (CASE ";
    sql_str +=  "  WHEN ";
    sql_str +=  "  (SELECT SUM(MAX_PER) FROM HAPPY_PRO_SCH WHERE DEL_FLAG != 'Y' AND SHOW_FLAG = 'Y') ";
    sql_str +=  "    <= (SELECT NVL(SUM(REQ_PER), 0) FROM (SELECT * FROM HAPPY_REQ_SCH WHERE APPLY_FLAG IN ('Y', 'N') AND REQ_AFT_FLAG IN ('F', 'D')) A LEFT JOIN HAPPY_REQ_SCH_CNT B ON A.REQ_NO = B.REQ_NO WHERE A.REQ_DATE = STANDARD_MONTH.MON_DTE) THEN 'N' ";
    sql_str +=  "  ELSE 'Y' ";
    sql_str +=  "  END) AS AFT_SCH_FLAG ";
/* 날짜 테이블 생성 및 프로그램 테이블 JOIN */
    sql_str +=  "   ";
    sql_str +=  "  FROM ";
    sql_str +=  "   (SELECT ";
    sql_str +=  "       (START_DTE + LEVEL) AS MON_DTE ";
    sql_str +=  "       , TO_CHAR(START_DTE + LEVEL, 'DY') AS WEEK_DTE ";
    sql_str +=  "   FROM ";
    sql_str +=  "       ( ";
    sql_str +=  "       SELECT ";
    sql_str +=  "           ( ";
    sql_str +=  "           CASE TO_CHAR(TO_DATE( '" + callYear + "' || '" + callMonth + "' || '01', 'YYYY-MM-DD'), 'D') ";
    sql_str +=  "               WHEN '1' THEN TO_DATE( '" + callYear + "' || '" + callMonth + "' || '01', 'YYYY-MM-DD') -1 ";
    sql_str +=  "               ELSE TO_DATE( '" + callYear + "' || '" + callMonth + "' || '01', 'YYYY-MM-DD') - TO_NUMBER(TO_CHAR(TO_DATE( '" + callYear + "' || '" + callMonth + "' || '01', 'YYYY-MM-DD'), 'D')) ";
    sql_str +=  "           END ";
    sql_str +=  "           ) AS START_DTE ";
    sql_str +=  "           , ( ";
    sql_str +=  "           CASE TO_CHAR(ADD_MONTHS(TO_DATE( '" + callYear + "' || '" + callMonth + "' || '01', 'YYYY-MM-DD'), 1), 'D') ";
    sql_str +=  "               WHEN '7' THEN ADD_MONTHS(TO_DATE( '" + callYear + "' || '" + callMonth + "' || '01', 'YYYY-MM-DD'), 1) -1 ";
    sql_str +=  "               ELSE ADD_MONTHS(TO_DATE( '" + callYear + "' || '" + callMonth + "' || '01', 'YYYY-MM-DD') -1, 1) + (7 - TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE( '" + callYear + "' || '" + callMonth + "' || '01', 'YYYY-MM-DD') -1, 1), 'D' ))) ";
    sql_str +=  "           END ";
    sql_str +=  "           ) AS END_DTE ";
    sql_str +=  "       FROM DUAL ";
    sql_str +=  "       ) ";
    sql_str +=  "   CONNECT BY LEVEL <= END_DTE - START_DTE ";
    sql_str +=  "   ) STANDARD_MONTH LEFT JOIN (SELECT * FROM HAPPY_REQ_SCH WHERE APPLY_FLAG = 'Y') COMPARE_DATE ON STANDARD_MONTH.MON_DTE = COMPARE_DATE.REQ_DATE ";
    sql_str +=  "ORDER BY STANDARD_MONTH.MON_DTE, COMPARE_DATE.REQ_SCH_ID ";
    sql.append(sql_str);

    calDateList =   jdbcTemplate.query(sql.toString(), new ArtCalList());

%>

<link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.13/themes/humanity/jquery-ui.css" type="text/css" media="all" />

<%/*************************************** STR Modal part ****************************************/%>
<div id="slide" style="display:none;">
  <div class="topbar">
    <h3>신청일 및 분류선택</h3>
  </div>
  <div class="inner">
    <form name="validate" action="./index.gne?menuCd=<%=writePage%>" onsubmit="return validateForm()" method="post" enctype="multipart/form-data">
        <table class="bbs_list2 td-l th-c fsize_80">
          <caption>신청일 및 분류선택 : 학교명, 선택일자, 분류 입력란입니다.</caption>
            <colgroup>
                <col style="width:30%">
                <col />
            </colgroup>
            <tr>
                <th scope="row">학교명</th>
                <td>
                    <label for="school_name" class="blind">학교명</label>
                    <input type="text" id="school_name" value="<%=sessionManager.getName() %>" readonly required>
                </td>
            </tr>
            <tr>
                <th scope="row">선택일자</th>
                <td><label for="req_date" class="blind">선택일자</label><input type="text" name="req_date" id="req_date" required readonly></td>
            </tr>
            <tr>
                <th scope="row">분류</th>
                <td>
                  <label for="aft_flag" class="blind">분류</label>
                  <input type="hidden" id="aft_flag" name="aft_flag" value="D" readonly required>
                  <label for="aft_flag_text" class="blind">오전,오후</label>
                  <input type="text" id="aft_flag_text" name="aft_flag_text" value="오전반(09:30 ~ 12:00)" readonly required>
                    <%--<select name="aft_flag" id="aft_flag">
                        <option value="M">오전반(09:30 ~ 12:00)</option>
                        <option value="F">오후반(14:00 ~ 16:30)</option>
                        <option value="D">전일반(09:00 ~ 16:00)</option>
                    </select>--%>
                </td>
            </tr>
        </table>
        <div class="btn_area c mg_b5">
            <input type="submit" class="btn medium edge darkMblue" value="신청하기">
        </div>
    </form>
    <a href="javascript:;" class="btn_cancel popup_close slide_close" id="modalClose" title="창닫기"><img src="/img/art/layer_close.png" alt="창닫기"></a>
  </div>
</div>
<%/*************************************** END Modal part ****************************************/%>


<div class="red" style="letter-spacing:-0.08em; text-decoration:underline;"><strong>※ 주의사항</strong>: <span>프로그램 운영 목적상 타 학교와의 합반은 불가하니, 다른 학교가 이미 신청한 프로그램에 대해 중복 신청 하지 않도록 유의</span></div>
<!--<div class="box_02 magT10">
	<ul class="badge-guide badge_type2">
		<li><i class="badge bg-am">오전</i> 오전반(신청가능)</li>
		<li><i class="badge bg-pm">오후</i> 오후반(신청가능)</li>
		<%--<li><i class="badge bg-day">전일</i> 전일제반(신청가능)</li>--%>
		<li><i class="badge finish">grey</i> 마감(신청불가)</li>
	</ul>
</div>-->

<div class="cal magT20">
	<div class="calbtn">
		<a href="javascript:;" class="prem" onclick="move('pre')" title="이전 달">&lt; <span class="blind">이전달</span></a> <span><%=callYear %>.<%=callMonth %></span> <a href="javascript:;" class="nextm" onclick="move('next')" title="다음 달"><span class="blind">다음달</span> &gt;</a>
	</div>
	<%--<div class="booking">
		<a href="javascript:;" class="btn small edge mako initialism slide_open openLayer" id="pro_request">프로그램 신청하기 &gt;</a>
	</div>--%>
	<table class="table_skin01 td-l wps_100">
		<caption>상시프로그램 신청 현황을 보여주는 달력입니다.</caption>
		<colgroup>
			<col style="width:14.285%">
			<col style="width:14.285%">
			<col style="width:14.285%">
			<col style="width:14.285%">
			<col style="width:14.285%">
			<col style="width:14.285%">
			<col style="width:14.285%">
		</colgroup>
		<thead>
			<tr>
				<th scope="col" class="sun">일</th>
				<th scope="col">월</th>
				<th scope="col">화</th>
				<th scope="col">수</th>
				<th scope="col">목</th>
				<th scope="col">금</th>
				<th scope="col" class="sat">토</th>
			</tr>
		</thead>
		<tbody>
<%/***************달력 STR*******************/%>
            <%
                for(ArtCalData data : calDateList){

                    String compareDay   =   "";
                    long diff           =   0;
                    int diffDate        =   0;

                    if (!tmpDate.equals(data.callDate)) {
                        //날짜 비교
                        compareDay  =   adfToday.format(sdf3.parse(data.callDate));
                        diff        =   adfToday.parse(compareDay).getTime() - adfToday.parse(toDay).getTime();
                        diff        =   diff / (24 * 60 * 60 * 1000);
                        diffDate    =   (int) diff;
                        tmpDate     =   data.callDate;

                        if (data.hlyDateFlag.equals("SU")) {
                            outHtml =   "<td class=\"sun\">";
                            outHtml +=  "<span class=\"date\">" + sdf4.format(sdf3.parse(data.callDate)) + "</span>";
                        } else if (data.hlyDateFlag.equals("SA")) {
                            outHtml =   "<td class=\"sat\">";
                            outHtml +=  "<span class=\"date\">" + sdf4.format(sdf3.parse(data.callDate)) + "</span>";
                        } else if (data.hlyDateFlag.equals("H")) {
                            outHtml =   "<td class=\"holiday\">";
                            outHtml +=  "<span class=\"date\">" + sdf4.format(sdf3.parse(data.callDate)) /*+ data.hlyDateName*/ + "</span>";
                        } else {
                            outHtml =   "<td class=\"\">";
                            outHtml +=  "<span class=\"date\">" + sdf4.format(sdf3.parse(data.callDate)) + "</span>";

                            outHtml +=  "<span class=\"badge-group badge_type2\">";

                            //오늘 과 이전 날짜 확인
                             if (
                            		(diffDate <= 4 || diffDate > 300) 
                            		|| ((Integer.parseInt(toDay)!=20180614 && Integer.parseInt(toDay)!=20180615) && Integer.parseInt(compareDay) < 20180507) 
                            		|| ((Integer.parseInt(toDay)!=20180614 && Integer.parseInt(toDay)!=20180615) && Integer.parseInt(compareDay) > 20180720)
                            		|| ((Integer.parseInt(toDay)==20180614 || Integer.parseInt(toDay)==20180615) && Integer.parseInt(compareDay) < 20180903)
                            		|| ((Integer.parseInt(toDay)==20180614 || Integer.parseInt(toDay)==20180615) && Integer.parseInt(compareDay) > 20181221)
                            		|| (Integer.parseInt(compareDay) == 20181004) || (Integer.parseInt(compareDay) == 20181005)
                            	) {
                                outHtml +=  "<span title=\"오전반 신청 불가\" class=\"badge bg-am finish\">오전</span>";
                                outHtml +=  "<span title=\"오후반 신청 불가\" class=\"badge bg-pm finish\">오후</span>";
                                //outHtml +=  "<span title=\"전일반 신청 불가\" class=\"badge bg-day finish\">전일</span>";
                                outHtml +=  "</span>";
                            } 
                            else if(dayOfWeek(compareDay) == 3 || dayOfWeek(compareDay) == 5){
                            	outHtml +=  "<a href=\"javascript:;\" title=\"오전반 신청\" class=\"badge bg-am initialism slide_open openLayer\" data-value=\""+ data.callDate.substring(0, 10) +"\">오전</a>";
                                outHtml +=  "<span title=\"오후반 신청 불가\" class=\"badge bg-pm finish\">오후</span>";
                            }
                            else {
                                //차단 조건 1(쿼리에서 제어) => 한날짜 아이디 2개 or 자신의 아이디로 승인 받은 신청 존재 or 정원이 없을 경우
                                if ("Y".equals(data.able_sch_flag)) {
                                    //차단 조건 2(쿼리에서 제어) 오전반 정원 확인(승인된 전일 + 오전이 정원을 넘었을 경우)
	                                if (("Y".equals(data.mor_sch_flag) && "Y".equals(data.mor_cnt_flag)) && ("Y".equals(data.aft_sch_flag) && "Y".equals(data.aft_cnt_flag))) {
	                                    outHtml +=  "<a href=\"javascript:;\" title=\"오전반 신청\" class=\"badge bg-am initialism slide_open openLayer\" data-value=\""+ data.callDate.substring(0, 10) +"\">오전</a>";
	                                    outHtml +=  "<a href=\"javascript:;\" title=\"오후반 신청\" class=\"badge bg-pm initialism slide_open openLayer\" data-value=\""+ data.callDate.substring(0, 10) +"\">오후</a>";
	                                    //outHtml +=  "<a href=\"javascript:;\" title=\"전일제반 신청\" class=\"badge bg-day initialism slide_open openLayer\" data-value=\""+ data.callDate.substring(0, 10) +"\">전일</a>";
	                                } else if ("Y".equals(data.mor_sch_flag) && "Y".equals(data.mor_cnt_flag)) {
	                                    outHtml +=  "<a href=\"javascript:;\" title=\"오전반 신청\" class=\"badge bg-am initialism slide_open openLayer\" data-value=\""+ data.callDate.substring(0, 10) +"\">오전</a>";
	                                    outHtml +=  "<span title=\"오후반 마감\" class=\"badge bg-pm finish\">오후</span>";
	                                    //outHtml +=  "<span title=\"전일제반 마감\" class=\"badge bg-day finish\">전일</span>";
	                                } else if ("Y".equals(data.aft_sch_flag) && "Y".equals(data.aft_cnt_flag)) {
	                                    outHtml +=  "<span title=\"오전반 마감\" class=\"badge bg-am finish\">오전</span>";
	                                    outHtml +=  "<a href=\"javascript:;\" title=\"오후반 신청\" class=\"badge bg-pm initialism slide_open openLayer\" data-value=\""+ data.callDate.substring(0, 10) +"\">오후</a>";
	                                    //outHtml +=  "<span title=\"전일제반 마감\" class=\"badge bg-day finish\">전일</span>";
	                                } else {
	                                    outHtml +=  "<span title=\"오전반 마감\" class=\"badge bg-am finish\">오전</span>";
	                                    outHtml +=  "<span title=\"오후반 마감\" class=\"badge bg-pm finish\">오후</span>";
	                                    //outHtml +=  "<span title=\"전일제반 마감\" class=\"badge bg-day finish\">전일</span>";
	                                }
                                    outHtml +=  "</span>";

                                } else {
                                    outHtml +=  "<span title=\"오전반 마감\" class=\"badge bg-am finish\">오전</span>";
                                    outHtml +=  "<span title=\"오후반 마감\" class=\"badge bg-pm finish\">오후</span>";
                                    //outHtml +=  "<span title=\"전일제반 마감\" class=\"badge bg-day finish\">전일</span>";
                                    outHtml +=  "</span>";
                                }
                            }/* END ELSE */

                            //대기자 count
                            if (/*"Y".equals(data.able_sch_flag) && */(diffDate > 1)) {
                               /*  if (data.hold_cnt > 0) {outHtml +=  "<p class=\"state waiting\">승인대기자 : "+ data.hold_cnt +"</p>";}
                                if (data.apply_cnt > 0) {outHtml +=  "<p class=\"state waiting\">승인완료자 : "+ data.apply_cnt +"</p>";} */
                            }

                            //임시 테스트
                            for(ArtCalData pro : calDateList){
                            	if(!tmpInfo.equals(parseNull(pro.req_info))){
                            		tmpInfo = parseNull(pro.req_info);
                            		if (pro.callDate.equals(data.callDate)) {
                                        //승인완료 학교명 노출 && 자기 아이디는 제외
                                        if (pro.req_sch_id != null && pro.req_sch_id.length() > 0 && (sessionManager.getId() != null && !pro.req_sch_id.equals(sessionManager.getId()))) {
                                            outHtml +=  "<p class=\"state\">" + parseNull(pro.req_info) + "</p>";
                                        } else if ("Y".equals(pro.my_request) && (diffDate > 1)) {
                                            outHtml +=  "<p class=\"state red\"><a href=\"/index.gne?menuCd="+confirmPage+"&req_sch_id="+sessionManager.getId()+"&req_date="+pro.callDate.substring(0, 10)+"\">승인완료</a></p>";
                                        } else if ("H".equals(pro.my_request) && (diffDate > 1)) {
                                            outHtml +=  "<p class=\"state\"><a href=\"/index.gne?menuCd="+confirmPage+"&req_sch_id="+sessionManager.getId()+"&req_date="+pro.callDate.substring(0, 10)+"\">승인대기 중</a></p>";
                                        }
                                    }/*END IF*/
                            	}/*END IF*/
                            }/*END FOR*/
                        }
                        outHtml +=  "</td>";
                        //sunday
                        if (data.callDateWeek.equals("일")) {
                            out.println("<tr>");
                            out.println(outHtml);
                        //saturday
                        } else if (data.callDateWeek.equals("토")) {
                            out.println(outHtml);
                            out.println("</tr>");
                        } else {
                            out.println(outHtml);
                        }
                    }
                }
            %>

            </tbody>
        </table>
    </div>

<div class="box_02 magT10">
	<ul class="badge-guide badge_type2">
		<li><i class="badge bg-am">오전</i> 오전반(신청가능)</li>
		<li><i class="badge bg-pm">오후</i> 오후반(신청가능)</li>
		<!-- <li><i class="badge bg-day">전일</i> 전일제반(신청가능)</li> -->
		<li><i class="badge finish">grey</i> 마감(신청불가)</li>
	</ul>
</div>

 <div class="btn_area c magT25 magB50">
       <a class="btn white medium" href="/program/down.jsp?path=/img/happysch&amp;filename=organization_table.hwp" title="오리엔테이션 및 반편성표 다운로드">
       <i class="ico-hwp"></i> 오리엔테이션  및 반편성표 다운로드</a><span style="display:none;"><%=cm.isMenuCmsManager(sm) %></span>
    </div>

<script>
    var apply_submit=false;
    function validateForm(){
        var req_date=$("#req_date").val();
        var school_name=$("#school_name").val();
        if(req_date==null||req_date==""||req_date.trim().length<1||school_name==null||school_name==""||school_name.trim().length<1){
            alert("신청가능한 선택일자와 학교이름을 입력하세요.");
            $("#req_date").focus();
            return false;
        }else{
            if(apply_submit){
                return true;
            }else{
                alert("신청가능한 선택일자와 학교이름을 입력하세요");
                $("#req_date").focus();
                return false;
            }
        }
    }

    $("#req_date").change(function(){apply_submit=false;var set_req_date=$(this).val();
        var set_aft_flag=$("#aft_flag").val();
        if($.inArray(set_req_date,banDate)==-1){
            req_date_chk(set_req_date,set_aft_flag);
        }else{
            alert("신청가능한 날짜를 선택하세요.");
            $(this).val("");return;
        }
    });

    function req_date_chk(req_date,aft_flag){if(!req_date||!aft_flag){alert("날짜가 없거나 올바르지 않은 값입니다.");return}
        $.ajax({
            type:"POST",
            url:"/program/happysch/client/programSchoolAjaxAction.jsp?",
            data:{"req_date":req_date,"aft_flag":aft_flag},dataType:"text",
            async:false,
            success:function(data){
            if(data.trim()=="1"){
                apply_submit=true;return}else{$(this).val("");
            if(data="s_f"){
                alert("학교계정으로 로그인 해야 합니다.")
            }else if(data="f"){
                alert("신청가능한 날짜가 아닙니다.");
            }return}
            },error:function(request,status,error){
                alert("code:"+request.status+"\n"+"message:"+request.responseText.trim()+"\n"+"error:"+error)
            }
        });
    }

        $.datepicker.regional['ko']={closeText:'닫기',prevText:'',nextText:'',currentText:'오늘',monthNames:['1월(JAN)','2월(FEB)','3월(MAR)','4월(APR)','5월(MAY)','6월(JUN)','7월(JUL)','8월(AUG)','9월(SEP)','10월(OCT)','11월(NOV)','12월(DEC)'],monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],dayNames:['일','월','화','수','목','금','토'],dayNamesShort:['일','월','화','수','목','금','토'],dayNamesMin:['일','월','화','수','목','금','토'],beforeShowDay:disableAllTheseDays};$.datepicker.setDefaults($.datepicker.regional['ko']);/*$("#req_date").datepicker({minDate:1,maxDate:90,dateFormat:'yy-mm-dd',changeMonth:false,changeYear:false,showOtherMonths:false,selectOtherMonths:true,showButtonPanel:false}).click(function(){$(".ui-datepicker-calendar").prepend("<caption>프로그램 신청 및 달력</caption>")});*/

        var banDate=new Array;

        <%for(ArtCalData data:calDateList){if("SU".equals(data.hlyDateFlag)||"SA".equals(data.hlyDateFlag)||"H".equals(data.hlyDateFlag)||"N".equals(data.able_sch_flag)){%>
        banDate.push("<%=data.callDate.substring(0, 10) %>");<%}}%>

        function disableAllTheseDays(date){
            var m=date.getMonth(),d=date.getDate(),y=date.getFullYear();
            for(i=0;i<banDate.length;i++){
                if($.inArray(y+'-'+(m+1)+'-'+d,banDate)!=-1){return[false]}
            }return[true]}

        $(function(){
            $(".bg-am").click(function(){
                $("#req_date").val($(this).data("value"));
                modal_open("M");
            });
            $(".bg-pm").click(function(){
                $("#req_date").val($(this).data("value"));
                modal_open("F");
            });
            $(".bg-day").click(function(){
                $("#req_date").val($(this).data("value"));
                modal_open("D")
            });
            $("#pro_request").click(function(){modal_open("D")});
        });

        function modal_open(aft_flag){
            var reg_name="<%=parseNull(sessionManager.getName(), "") %>";
            if(reg_name==""&&reg_name.length<1){
                alert("로그인한 회원만 신청가능 합니다.");

                var send_url    =   "/index.gne?menuCd=<%=loginPage%>";
                /*var params      =   {"forwardUrl": decodeURIComponent("/e-sucheop/index.gne?menuCd=<%=listPage%>&callYear=<%=callYear %>&callMonth=<%=callMonth %>"),
                                    "returnUrl": decodeURIComponent("/e-sucheop/index.gne?menuCd=<%=listPage%>&callYear=<%=callYear %>&callMonth=<%=callMonth %>")};*/
                var params      =   {"forwardUrl": decodeURIComponent("/e-sucheop/index.gne?menuCd=<%=listPage%>"),
                                    "returnUrl": decodeURIComponent("/e-sucheop/index.gne?menuCd=<%=listPage%>")};
                post_to_url(send_url, params, "post");

                return;
            }
            apply_submit=true;
            if (aft_flag == "M") {$("#aft_flag").val(aft_flag);$("#aft_flag_text").val("오전반(09:30 ~ 12:00)");}
            else if (aft_flag == "F") {$("#aft_flag").val(aft_flag);$("#aft_flag_text").val("오후반(14:00 ~ 16:30)");}
            //else {$("#aft_flag").val(aft_flag);$("#aft_flag_text").val("전일반(09:00 ~ 16:00)");}

            //$("#aft_flag").val(aft_flag).prop("selected",true);
            $('#slide').popup({focusdelay:400,outline:true,vertical:'middle',});
        }

        function post_to_url(path, params, method) {
                method = method || "post";  //method 부분은 입력안하면 자동으로 post가 된다.
                var form = document.createElement("form");
                form.setAttribute("method", method);
                form.setAttribute("action", path);
                //input type hidden name(key) value(params[key]);
                for(var key in params) {
                    var hiddenField = document.createElement("input");
                    hiddenField.setAttribute("type", "hidden");
                    hiddenField.setAttribute("name", key);
                    hiddenField.setAttribute("value", params[key]);
                    form.appendChild(hiddenField);
                }
                document.body.appendChild(form);
                form.submit();
            }

            function move(arrow){var presentYear="<%=callYear %>";var presentMonth="<%=callMonth %>";presentYear*=1;presentMonth*=1;if(arrow=="pre"){if((presentMonth-1)<1){presentYear-=1;presentMonth=12}else{presentMonth=addZero(presentMonth-1)}}else if(arrow=="next"){if((presentMonth+1)>12){presentYear+=1;presentMonth="01"}else{presentMonth=addZero(presentMonth+1)}}location.href="/index.gne?menuCd=<%=listPage%>&callYear="+presentYear+"&callMonth="+presentMonth;function addZero(value){if(value<10){return"0"+value}else{return value}}}
</script>

<%
}catch(Exception finalE){
	out.println("<script>");
	out.println("alert('처리중 오류가 발생하였습니다.');");
	out.println("history.go(-1);");
	out.println("</script>");
}
%>