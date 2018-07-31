<%
/**
*   PURPOSE :   <상시> 프로그램 신청 정보 입력
*   CREATE  :   20180208_thur   JI
*   MODIFY  :   20180322_thur	JI	전일 신청일 경우 오전, 오후 인원 모두 sum 하여 호출하기
*   MODIFY  :   20180404_wed	JI	학년 추가 column name ETC2, 인솔자명/인솔자 연락처 추가
*   MODIFY  :   20180612 KO 오전,오후 각각 200명만 신청 가능하게 수정
**/
%>

<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.web.multipart.MultipartHttpServletRequest" %>
<%@ page import="org.springframework.web.multipart.MultipartFile" %>

<%/*************************************** 프로그램 구역 ****************************************/%>

<%!
    private class ProPerData {
        public int proNo;
        public String proName;
        public String proTchNm;
        public int maxPer;
        public int currPer;

		//modify
		public String reqDate;
		public int reqPer;
		public String etc2;

		public String aftFlag;
		public String schMngName;
		public String schMngTel;
		public String schMngMail;
		public String schLeadName;
		public String schLeadTel;
		public int reqCnt;

    }
	//신규 신청
    private class ProPerList implements RowMapper<ProPerData> {
        public ProPerData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProPerData proData   =   new ProPerData();
            
            proData.proNo       =   rs.getInt("PRO_NO");
            proData.proName     =   rs.getString("PRO_NAME");
            proData.proTchNm    =   rs.getString("PRO_TCH_NM");
            proData.maxPer      =   rs.getInt("MAX_PER");
            proData.currPer     =   rs.getInt("CURR_PER");
            
			//modify
			proData.reqPer		=	rs.getInt("REQ_PER");
			proData.reqDate		=	rs.getString("REQ_DATE");
			proData.etc2		=	rs.getString("ETC2");

			proData.aftFlag		=	rs.getString("REQ_AFT_FLAG");
			proData.schMngName	=	rs.getString("SCH_MNG_NM");
			proData.schMngTel	=	rs.getString("SCH_MNG_TEL");
			proData.schMngMail	=	rs.getString("SCH_MNG_MAIL");
			proData.schLeadName	=	rs.getString("SCH_LEAD_NM");
			proData.schLeadTel	=	rs.getString("SCH_LEAD_TEL");
			proData.reqCnt		=	rs.getInt("REQ_CNT");

            return proData;
        }
    }
    

	//학교명 붙이기
	private String schNameAdd (String schoolName) {
		String rtrString	=	null;
		if (schoolName.substring(schoolName.length() - 1).equals("중")) {
			rtrString		=	schoolName + "학교";
		} else if (schoolName.substring(schoolName.length() - 1).equals("초")) {
			rtrString		=	schoolName + "등학교";
		} else {
			rtrString		=	schoolName;
		}
		return rtrString;
	}
	//오전, 오후, 전일
	private String aftText (String aftFlag) {
        String returnText   =   "<span class='badge bg-day'>전일</span>";
        if (aftFlag.equals("M")) {
            returnText  =   "<span class='badge bg-am'>오전</span>";
        } else if (aftFlag.equals("F")) {
            returnText  =   "<span class='badge bg-pm'>오후</span>";
        } else if (aftFlag.equals("D")) {
            returnText  =   "<span class='badge bg-day'>전일</span>";
        }
        return returnText;
    }

%>

<%
String listPage = "DOM_000002001002003002";		// 실서버 : DOM_000002001002003002 , 테스트 : DOM_000000126002003005

//session check
SessionManager sessionManager	=	new SessionManager(request);

if (sessionManager.getName().trim().equals("") || sessionManager.getId().trim().equals("") || sessionManager.getName().trim().length() < 1 || sessionManager.getId().trim().length() < 1 || !sessionManager.getGroupId().equals("GRP_000009")) {
	if (sessionManager.isRoleAdmin() || "gne_wwoof2002".equals(sessionManager.getId())) {
	} else {
%>
	<script>
		alert("본 서비스 이용을 원하시면 학교게정으로 로그인 하시기 바랍니다.\n※ 현재 로그인하신 아이디는 <%=sessionManager.getId()%> 입니다.");
		history.go(-1);
	</script>
<%
	return;
	}
}

String outHtml              =   "";

StringBuffer sql            =   null;
String sql_str              =   "";
List<ProPerData> ProPerList =   null;

Object[] insObj =   null;

String dataType	=	"ins";	//ins, mod

String req_no	=   parseNull(request.getParameter("req_no"), "");
String pro_no	=   parseNull(request.getParameter("pro_no"), ""); 

String req_date =   request.getParameter("req_date");
String aft_flag =   parseNull(request.getParameter("aft_flag"), "");

String schMngName	=	"";
String schMngTel	=	"";
String schMngMail	=	"";
String schLeadName	=	"";
String schLeadTel	=	"";

int ableSchCnt = 0;

//request 가 없을 시 back
if (!((req_date != null && req_date.length() > 0) || (aft_flag != null && aft_flag.length() > 0)) && !(req_no != null && req_no.length() > 0)) {
    out.println("<script>");
    out.println("alert(\"날짜가 없습니다. 돌아갑니다.\");");
    out.println("history.back();");
    out.println("</script>");
    return;
}

String req_week =   null;

int totalMaxCnt     =   0;
int totalCurrCnt    =   0;
int totalReqCnt		=   0;

//수정
if (req_no != null && req_no.length() > 0) {

	dataType	=	"mod";	//수정으로 변경

	//프로그램 정보 가져오기
	sql     =   new StringBuffer();
	sql_str =   "SELECT ";
	sql_str +=  "   * ";
	sql_str +=  "FROM ( ";
	sql_str +=  "   SELECT ";
	sql_str +=  "   * ";
	sql_str +=  "   FROM ART_PRO_ALWAY ";
	sql_str +=  "   WHERE PRO_NO = ? AND DEL_FLAG != 'Y' AND SHOW_FLAG = 'Y' AND PRO_YEAR = SUBSTR((SELECT REQ_DATE FROM ART_REQ_ALWAY WHERE REQ_NO = ?), 1, 4) ";
	sql_str +=  ") PRO ";
	sql_str +=  "LEFT JOIN ( ";
	sql_str +=  "   SELECT ";
	sql_str +=  "       REQ_AL.* ";
	sql_str +=  "       , REQ_AL_CNT.PRO_NO AS PRO_CHK_NO ";
	sql_str +=  "       , REQ_AL_CNT.REQ_PER ";

	sql_str +=  "       , REQ_AL_CNT.ETC2 ";
	/*
	*	PURPOSE	:	전일 신청일 경우 오전, 오후 인원 모두 sum 하여 호출하기
	*	CREATE	:	20180322_thur	JI
	*	MODIFY	:	....
	*/
	if ("D".equals(aft_flag)) {
		sql_str +=  "       , (SELECT NVL(SUM(B.REQ_PER), 0) FROM ART_REQ_ALWAY A LEFT JOIN ART_REQ_ALWAY_CNT B ON A.REQ_NO = B.REQ_NO WHERE A.REQ_DATE = REQ_AL.REQ_DATE AND A.APPLY_FLAG IN ('Y', 'N') AND A.REQ_AFT_FLAG IN ('M', 'F', REQ_AL.REQ_AFT_FLAG) AND B.PRO_NO = REQ_AL_CNT.PRO_NO) AS CURR_PER ";
	} else {
		sql_str +=  "       , (SELECT NVL(SUM(B.REQ_PER), 0) FROM ART_REQ_ALWAY A LEFT JOIN ART_REQ_ALWAY_CNT B ON A.REQ_NO = B.REQ_NO WHERE A.REQ_DATE = REQ_AL.REQ_DATE AND A.APPLY_FLAG IN ('Y', 'N') AND A.REQ_AFT_FLAG IN ('D', REQ_AL.REQ_AFT_FLAG) AND B.PRO_NO = REQ_AL_CNT.PRO_NO) AS CURR_PER ";
	}
	/* END */
	sql_str +=  "   FROM ART_REQ_ALWAY REQ_AL LEFT JOIN ART_REQ_ALWAY_CNT REQ_AL_CNT ";
	sql_str +=  "   ON REQ_AL.REQ_NO = REQ_AL_CNT.REQ_NO ";
	sql_str +=  "   WHERE REQ_AL.REQ_NO = ? ";
	sql_str +=  ") REQ ON PRO.PRO_NO = REQ.PRO_CHK_NO ";
	sql_str +=  "ORDER BY PRO.PRO_NO ";

	sql.append(sql_str);
	insObj =   new Object[] {
		pro_no
		, req_no
		, req_no
	};

	ProPerList  =   jdbcTemplate.query(sql.toString(), insObj, new ProPerList());

	//신청 인원 모으기...
	for(ProPerData data : ProPerList) {totalReqCnt	+=	data.reqPer;}

	//변수 지정
	for(ProPerData data : ProPerList) {
		//escape value is
		if (data.reqDate != null && !(data.reqDate.equals(""))) {
			req_date	=	parseNull(data.reqDate, "");
			aft_flag	=	parseNull(data.aftFlag, "");
			totalReqCnt	=	data.reqCnt;
			schMngName	=	parseNull(data.schMngName, "");
			schMngTel	=	parseNull(data.schMngTel, "");
			schMngMail	=	parseNull(data.schMngMail, "");
			schLeadName	=	parseNull(data.schLeadName, "");
			schLeadTel	=	parseNull(data.schLeadTel, "");
			break;
		}
	}

//새로 입력
} else {

	//프로그램 과 현원 정원 select
	sql     =   new StringBuffer();
	sql_str =   "SELECT ";
	sql_str +=  "   * ";
	sql_str +=  "FROM ( ";
	sql_str +=  "   SELECT ";
	sql_str +=  "   * ";
	sql_str +=  "   FROM ART_PRO_ALWAY ";
	sql_str +=  "   WHERE PRO_NO = ? AND SHOW_FLAG = 'Y' AND DEL_FLAG != 'Y' AND PRO_YEAR = SUBSTR(?, 1, 4) ";
	sql_str +=  ") PRO ";
	sql_str +=  "LEFT JOIN ( ";
	sql_str +=  "   SELECT ";
	sql_str +=  "       REQ_AL.* ";
	sql_str +=  "       , REQ_AL_CNT.PRO_NO AS PRO_CHK_NO ";
	sql_str +=  "       , REQ_AL_CNT.REQ_PER ";

	sql_str +=  "       , REQ_AL_CNT.ETC2 ";

	/*
	*	PURPOSE	:	전일 신청일 경우 오전, 오후 인원 모두 sum 하여 호출하기
	*	CREATE	:	20180322_thur	JI
	*	MODIFY	:	....
	*/
	if ("D".equals(aft_flag)) {
		sql_str +=  "       , (SELECT NVL(SUM(B.REQ_PER), 0) FROM ART_REQ_ALWAY A LEFT JOIN ART_REQ_ALWAY_CNT B ON A.REQ_NO = B.REQ_NO WHERE A.REQ_DATE = REQ_AL.REQ_DATE AND A.APPLY_FLAG IN ('Y', 'N') AND A.REQ_AFT_FLAG IN ('M', 'F', REQ_AL.REQ_AFT_FLAG) AND B.PRO_NO = REQ_AL_CNT.PRO_NO) AS CURR_PER  ";
	} else {
		sql_str +=  "       , (SELECT NVL(SUM(B.REQ_PER), 0) FROM ART_REQ_ALWAY A LEFT JOIN ART_REQ_ALWAY_CNT B ON A.REQ_NO = B.REQ_NO WHERE A.REQ_DATE = REQ_AL.REQ_DATE AND A.APPLY_FLAG IN ('Y', 'N') AND A.REQ_AFT_FLAG IN ('D', REQ_AL.REQ_AFT_FLAG) AND B.PRO_NO = REQ_AL_CNT.PRO_NO) AS CURR_PER  ";
	}
	/* END */
	sql_str +=  "   FROM ART_REQ_ALWAY REQ_AL LEFT JOIN ART_REQ_ALWAY_CNT REQ_AL_CNT ";
	sql_str +=  "   ON REQ_AL.REQ_NO = REQ_AL_CNT.REQ_NO ";
	sql_str +=  "    ";
	if ("D".equals(aft_flag)) {
		sql_str +=  "   WHERE (REQ_AL.REQ_DATE = ? AND REQ_AL.REQ_AFT_FLAG IN (?, 'M', 'F')) AND REQ_AL.APPLY_FLAG IN ('Y', 'N') ";
	} else {
		sql_str +=  "   WHERE (REQ_AL.REQ_DATE = ? AND REQ_AL.REQ_AFT_FLAG IN (?, 'D')) AND REQ_AL.APPLY_FLAG IN ('Y', 'N') ";
	}
	sql_str +=  ") REQ ON PRO.PRO_NO = REQ.PRO_CHK_NO ";
	sql_str +=  "ORDER BY PRO.PRO_NO ";

	sql.append(sql_str);
	insObj =   new Object[] {
		 pro_no
		, req_date
		, req_date
		, aft_flag
	};

	ProPerList  =   jdbcTemplate.query(sql.toString(), insObj, new ProPerList());
	
	
	
	
	sql_str = new String();
    sql_str +=  "SELECT SUM(REQ_PER) AS ABLE_SCH_CNT													";
    sql_str +=  "FROM ART_REQ_ALWAY A LEFT JOIN ART_REQ_ALWAY_CNT B ON A.REQ_NO = B.REQ_NO				";
    sql_str +=  "WHERE A.REQ_DATE = ? AND A.APPLY_FLAG IN ('Y', 'N') AND (SELECT AFT_FLAG FROM ART_PRO_ALWAY WHERE PRO_NO = B.PRO_NO) = ?	";
    try{
    	ableSchCnt = jdbcTemplate.queryForObject(sql_str, Integer.class, req_date, aft_flag);
    }catch(Exception e){
    	ableSchCnt = 0;
    }
}
	//요일 지정
	Date trsDate    =   new SimpleDateFormat("yyyy-MM-dd").parse(req_date);
	Calendar cal    =   Calendar.getInstance();
	cal.setTime(trsDate);

	switch (cal.get(Calendar.DAY_OF_WEEK)) {
		case 1: req_week = "일"; break;
		case 2: req_week = "월"; break;
		case 3: req_week = "화"; break;
		case 4: req_week = "수"; break;
		case 5: req_week = "목"; break;
		case 6: req_week = "금"; break;
		case 7: req_week = "토"; break;
	}
%>

<script>

    $(function (){
		$(".req_per").focusout(function (){
			var index	=	$(".req_per").index(this);
			var max		=	$(".req_per").eq(index).data("value");
			var currPer	=	$(".curr_per").eq(index).text();
			var ableSchCnt = $("#ableSchCnt").val();
			
			//오전,오후 각각 200명까지만 신청 가능
			if(Number($(".req_per").eq(index).val()) > 200-Number(ableSchCnt)){
				alert("전체 신청인원이 200명이 넘어 신청이 불가능합니다.");
				$(".req_per").eq(index).val(200-Number(ableSchCnt));
			}
			//정원보다 많은 인원 입력 후 focus out
			else if (Number($(".req_per").eq(index).val()) > Number(max)) {
				alert("신청 가능 인원보다 많은 신청 불가합니다.");
				$(".req_per").eq(index).val(max);
			//5명 이하 입력
			} else if ((Number($(".req_per").eq(index).val()) > 0) && (Number($(".req_per").eq(index).val()) < 5) && (max > 5)) {
				alert("5명 이상의 인원부터 신청이 가능합니다.");
				$(".req_per").eq(index).val(5);
			//"-" 입력 시
			} else if ((Number($(".req_per").eq(index).val()) < 0) && (max > 5)) {
				alert("음수 입력은 하지 마세요.");
				$(".req_per").eq(index).val(0);
			
			//5명 이하 만 입력이 가능한 경우
			}/* else if ((Number($(".req_per").eq(index).val()) < 5) && (max < 5)) {
				$(".req_per").eq(index).val(max);
			}*/

			var req_cnt	=	0;
			for (i = 0; i < $(".req_per").length; i++) {
				if (parseInt($(".req_per").eq(i).val()) > 0) {
					req_cnt +=  parseInt($(".req_per").eq(i).val());
				}/* else {
					$(".req_per").eq(i).val(max);
				}*/
			}
			$("#req_total_cnt").val(req_cnt);
		});
	});

	//onsubmit check
	function chkSubmit() {
		/*var totalMaxCnt		=	$(".totalMaxCnt").text();
		var totalCurrCnt	=	$(".totalCurrCnt").text();
		var req_total_cnt	=	$("#req_total_cnt").val();

		//신청 가능 인원이 50보다 작을 경우
		if ((Number(totalMaxCnt) - Number(totalCurrCnt)) < 50) {
			if (req_total_cnt < (Number(totalMaxCnt) - Number(totalCurrCnt)))
				alert("50명 이하의 신청인원은 모두 채우길 바랍니다.");
				return false;
		} else {
			if (req_total_cnt < 50) {
				alert("신청인원은 50명 이상부터 입니다.");
				return false;
			}
		}*/
		return true;
	}

</script>
    
<!-- S: 수정 폼에서 노출-->
	<div class="box_02 magB20">
		<ul class="type01 ">
			<li><span class="fb">주의사항</span>
				<ul class="fsize_90">
					<li><span class="red">날짜 및 시간 분류(오전반, 오후반)은 수정할 수 없습니다.</span></li>
					<li>이미 신청한 프로그램의 날짜 및 시간분류를 변경하고자 하실 때는 해당 프로그램을 <span class="red">&quot;신청취소&quot;</span>를 하신 후, 다시 신청해주시기 바랍니다.</li>
				</ul>
			</li>
		</ul>
	</div>
<!-- //E: 수정 폼에서 노출 끝 -->

<%
/* onsubmit 추가 신청 인원 50명 이상으로 채우기 */
%>
<form action="/program/art/client/programAlwaysReqAction.jsp"  id="req_alway" name="req_alway" method="post" onsubmit="return chkSubmit()">
	<input type="hidden" id="reqNo" name="reqNo" value="<%=req_no %>">
	<input type="hidden" id="dataType" name="dataType" value="<%=dataType %>">
	<input type="hidden" id="req_date" name="req_date" value="<%=req_date %>">
	<input type="hidden" id="aft_flag" name="aft_flag" value="<%=aft_flag %>">
	<input type="hidden" id="ableSchCnt" name="ableSchCnt" value="<%=ableSchCnt%>">

	<h3>프로그램 신청 정보</h3>
	<fieldset class="board">
		<legend>신청 인원 입력</legend>
			<table class="tb_board nohover thgrey">
				<caption>상시프로그램별 신청 인원 입력표입니다.</caption>
				<colgroup>
					<col style="width:8%">
					<col style="width:20%">
					<col />
					<col style="width:10%">
					<col style="width:10%">
					<col style="width:65px">
					<col style="width:10%">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">프로그램 번호</th>
						<th scope="col">신청일/분류</th>
						<th scope="col">프로그램명</th>
						<th scope="col">정원</th>
						<th scope="col">현원</th>
						<th scope="col">신청인원</th>
						<th scope="col">학년</th>
					</tr>
				</thead>
				<tbody>
                <%
                    for(ProPerData data : ProPerList) {
                        totalMaxCnt     +=   data.maxPer;
                        totalCurrCnt    +=   data.currPer;
                %>
                        <tr>
                            <td><input type="hidden" name="proNo" class="proNo" value="<%=data.proNo %>"><%=data.proNo %></td>
                            <td><%=req_date %>(<%=req_week %>) /<%=aftText(aft_flag) %></td>
                            <td><%=data.proName %></td>
                            <td><span class="req_max_value"><%=data.maxPer %></span></td>
						<%/*수정 시*/
						if ("mod".equals(dataType)) {%>
                            <td class="curr_per"><%=Integer.toString(data.currPer - data.reqPer) %></td>
                            <td><input type="number" class="wps_70 c req_per" name="req_per" value="<%=data.reqPer %>" data-value="<%=data.maxPer-data.currPer+data.reqPer %>" required/></td>
							<td><input type="text" class="wps_70 c etc2" name="etc2" placeholder="숫자만" value="<%=parseNull(data.etc2, "") %>" required></td>
						<%/*신규 시*/
						} else {%>
                            <td class="curr_per"><%=data.currPer %></td>
							<%if (data.maxPer <= data.currPer) {%>
								<td><span class="red">마감</span><input type="hidden" class="wps_70 c req_per" name="req_per" value="0" data-value="<%=data.maxPer-data.currPer %>"></td>
							<%} else {%>
								<td><input type="number" class="wps_70 c req_per" name="req_per" value="0" data-value="<%=data.maxPer-data.currPer %>" required/></td>
							<%}%>
							<td><input type="text" class="wps_70 c etc2" name="etc2" placeholder="숫자만" required></td><%-- 학년 column name ETC2 --%>
                        <%}/*END ELSE*/%>
                        </tr>
                <%}%>
				</tbody>
                <%-- <tfoot>
					<tr>
						<td colspan="4">계</td>
						<td><span class="totalMaxCnt"><%=totalMaxCnt %></span></td>
						<td><span class="totalCurrCnt"><%=totalCurrCnt %></span></td>
						<td><input type="number" id="req_total_cnt" name="req_total_cnt" class="wps_70 c" value="<%=totalReqCnt %>" readonly required></td>
						<td>
					</tr>
				</tfoot> --%>
			</table>
	</fieldset>

	<h3>신청 담당자 정보</h3>
	<fieldset>
		<legend>신청자 정보 입력</legend>
		<table class="table_skin01 fsize td-l f_nanum">
			<caption>프로그램 신청 담당자 정보 입력폼입니다.</caption>
			<colgroup>
				<col style="width:18%" />
				<col style="width:30%" />
				<col style="width:18%" />
				<col style="width:30%" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">신청학교명</th>
					<td colspan="3"><%=schNameAdd(sessionManager.getName()) %></td>
				</tr>
				<tr>
					<th scope="row"><span class="red fb">*</span> 담당자명</th>
					<td><input type="text" value="<%=schMngName %>" class="wps_100" id="sch_mng_name" name="sch_mng_name" placeholder="담당자명을 입력하세요." required></td>
					<th scope="row"><span class="red fb">*</span> 담당자 연락처</th>
					<td>
						<input type="text" value="<%=schMngTel %>" class="wps_100" id="sch_mng_tel" name="sch_mng_tel" placeholder="숫자만 입력하세요" required><br />
						<span class="red fsize_90">&#8251; 반드시 연락 가능한 연락처를 입력해 주세요.</span>
					</td>
				</tr>
				<tr>
					<th scope="row"><span class="red fb">*</span>담당자 이메일</th>
					<td colspan="3"><input type="text" value="<%=schMngMail %>" class="wps_100" id="sch_mng_mail" name="sch_mng_mail" placeholder="your@mail.com" required></td>
				</tr>
				<tr>
					<th scope="row"><span class="red fb">*</span>체험 당일 인솔교사</th>
					<td><input type="text" value="<%=parseNull(schLeadName, "") %>" class="wps_100" id="sch_lead_name" name="sch_lead_name" placeholder="대표 인솔자명을 입력하세요." required></td>
					<th scope="row"><span class="red fb">*</span>대표 인솔교사 연락처</th>
					<td><input type="text" value="<%=parseNull(schLeadTel, "") %>" class="wps_100" id="sch_lead_tel" name="sch_lead_tel" placeholder="숫자만 입력하세요." required><br />
						<span class="red fsize_90">&#8251; 반드시 연락 가능한 연락처를 입력해 주세요.</span>
					</td>
				</tr>
			</tbody>
		</table>
	</fieldset>

	<h3 class="title">개인정보 수집 및 이용 동의</h3>
	<fieldset>
		<label>
		<textarea name="" cols="" rows="" id="policy" class="wps_100 h100 fsize_90">1. 개인정보의 수집·이용 목적
우리 기관은 개인정보를 다음의 목적을 위해 처리합니다. 처리한 개인정보는 다음의 목적 이외의 용도로는 사용되지 않으며, 이용목적이 변경될 시에는 별도 공지할 예정입니다.
- 수집·이용목적: 해봄 프로그램 신청 및 확인

2. 수집하는 개인정보의 항목
우리 기관은 본 서비스에서 아래와 같은 개인정보를 수집하고 있습니다.
- 수집항목: 신청자명, 연락처, 이메일, 대표 인솔자명, 대표 인솔자 연락처

3. 개인정보의 보유 및 이용기간
이용자의 개인정보는 2년간 보유되며 기간이 만료되면 지체 없이 파기됩니다.

※ 개인정보 수집·이용에 대하여 동의를 원하지 않을 경우 동의를 거부할 수 있으며, 동의 거부시 본 서비스를 이용할 수 없습니다.</textarea>
		</label>
		<p class="magT10">
			<label><input name="proChk" type="checkbox" value="Y" required>개인정보 수집 및 이용에 대한 안내를 이해하였으며 동의합니다.</label>
		</p>
	</fieldset>

	<fieldset>
		<legend>실행 버튼 영역</legend>
		<div class="btn_area c">
			<button type="submit" class="btn medium edge darkMblue w_100">확인</button>
			<button onclick="location.href='./index.gne?menuCd=<%=listPage%>'" type="button" class="btn medium edge white">취소</button>
		</div>
	</fieldset>
</form>