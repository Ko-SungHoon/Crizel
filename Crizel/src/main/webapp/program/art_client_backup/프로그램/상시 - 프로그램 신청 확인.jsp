<%
/**
*   PURPOSE :   <상시> 프로그램 신청 확인
*   CREATE  :   20180208_thur   JI
*   MODIFY  :   ...
**/
%>

<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>

<%/*************************************** 프로그램 구역 ****************************************/%>

<%!

	private class ArtProData {
		int pro_no;
		String pro_cat;
		String pro_cat_nm;
		String pro_name;
		String pro_memo;
		String pro_year;
		int max_per;
		String pro_tch_nm;
		int curr_per;
	}

	private class ArtProList implements RowMapper<ArtProData> {
		public ArtProData mapRow(ResultSet rs, int rowNum) throws SQLException {
			ArtProData artProData	=	new ArtProData();

			artProData.pro_no		=	rs.getInt("PRO_NO");
			artProData.pro_cat		=	rs.getString("PRO_CAT");
			artProData.pro_cat_nm	=	rs.getString("PRO_CAT_NM");
			artProData.pro_name		=	rs.getString("PRO_NAME");
			artProData.pro_memo		=	rs.getString("PRO_MEMO");
			artProData.pro_year		=	rs.getString("PRO_YEAR");
			artProData.max_per		=	rs.getInt("MAX_PER");
			artProData.pro_tch_nm	=	rs.getString("PRO_TCH_NM");
			artProData.curr_per		=	rs.getInt("CURR_PER");

			return artProData;
		}
	}

    private class ArtReqData {
		int req_no;
		String req_sch_id;
		String req_sch_nm;
		String sch_mng_nm;
		String sch_mng_tel;
		String sch_mng_mail;
		String sch_lead_nm;
		String sch_lead_tel;
		String apply_flag;
		String req_aft_flag;
		int my_pro_no;
		int req_per;
		
		String req_date_over;
	}

	private class ArtReqList implements RowMapper<ArtReqData> {
        public ArtReqData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ArtReqData reqData	=	new ArtReqData();
            
            reqData.req_no		=	rs.getInt("REQ_NO");
            reqData.req_sch_id	=	rs.getString("REQ_SCH_ID");
            reqData.req_sch_nm	=	rs.getString("REQ_SCH_NM");
            reqData.sch_mng_nm	=	rs.getString("SCH_MNG_NM");
            reqData.sch_mng_tel	=	rs.getString("SCH_MNG_TEL");
            reqData.sch_mng_mail=	rs.getString("SCH_MNG_MAIL");
			reqData.sch_lead_nm	=	rs.getString("SCH_LEAD_NM");
			reqData.sch_lead_tel=	rs.getString("SCH_LEAD_TEL");
            reqData.apply_flag	=	rs.getString("APPLY_FLAG");
            reqData.req_aft_flag=	rs.getString("REQ_AFT_FLAG");
            reqData.my_pro_no	=	rs.getInt("MY_PRO_NO");
            reqData.req_per		=	rs.getInt("REQ_PER");

			reqData.req_date_over	=	rs.getString("REQ_DATE_OVER");

            return reqData;
        }
    }

	private String applyText (String flag , String reqDateOver) {
        String returnText   =   "승인대기";
        if (flag.equals("Y")) {
            returnText  =   "<td><span class=\"fb red\">승인완료</span></td>";
        } else if (flag.equals("N")) {
            if (reqDateOver.equals("Y")) returnText  =   "<td><span class=\"fb\">승인대기</span></td>";
            else returnText  =   "<td><span class=\"fb\">기간초과</span></td>";
        } else if (flag.equals("A")) {
            returnText  =   "<td><span class=\"fb\">관리자 취소</span></td>";
        } else if (flag.equals("C")) {
            returnText  =   "<td><span class=\"fb\">직접취소</span></td>";
        } else {
            returnText  =   "<td><span class=\"fb red\">오류</span></td>";
        }
        return returnText;
    }

	private String aftText (String aft, int type) {
		String returnText	=	"전일반";
		if (aft.equals("M")) {
			returnText		=	"오전반";
			if (type == 2) {returnText += " (09:30 ~ 12:00)";}
		} else if (aft.equals("F")) {
			returnText		=	"오후반";
			if (type == 2) {returnText += " (13:30 ~ 16:00)";}
		} else if (aft.equals("D")) {
			returnText		=	"전일반";
			if (type == 2) {returnText += " (09:00 ~ 16:00)";}
		}
		return returnText;
	}
%>

<%

SessionManager sessionManager   =   new SessionManager(request);

/* Session Chk */
if (sessionManager.getName().trim().equals("") || sessionManager.getId().trim().equals("") || sessionManager.getName().trim().length() < 1 || sessionManager.getId().trim().length() < 1) {
    out.println("<script>");
    out.println("alert('로그인 정보 저장 시간초과 입니다. 다시 로그인 하세요.');");
    out.println("location.href='/index.gne?menuCd=DOM_000002001002003005';");
    out.println("</script>");
}

String outHtml      =   "";
String tmpDate      =   "";

StringBuffer sql                =   null;
String sql_str                  =   "";
List<ArtProData> proDataList    =   null;
List<ArtReqData> reqDataList    =   null;

Object[] insObj =   null;
int totalDate   =   0;
int cnt         =   0;
int num         =   0;

String req_no	=   parseNull(request.getParameter("req_no"), "");
String req_date =   parseNull(request.getParameter("req_date"), "");
//파라미터 확인
if (req_no.trim().equals("") || req_no.length() < 1 || req_date.trim().equals("") || req_date.length() < 1) {
	out.println("<script>");
    out.println("alert('파라미터가 확인 되지 않습니다. 관리자에게 문의하세요.');");
    out.println("location.href='/index.gne?menuCd=DOM_000002001002003005';");
    out.println("</script>");
}

//신청 공통 변수
String sch_nm			=	null;
String req_date_week	=	null;
String apply_text		=	null;
String aft_text			=	null;
String sch_mng_nm		=	null;
String sch_mng_tel		=	null;
String sch_mng_mail		=	null;
String sch_lead_nm		=	null;
String sch_lead_tel		=	null;
String req_date_over	=	null;

Date trsDate    =   new SimpleDateFormat("yyyy-MM-dd").parse(req_date);
Calendar cal    =   Calendar.getInstance();
cal.setTime(trsDate);

switch (cal.get(Calendar.DAY_OF_WEEK)) {
    case 1: req_date_week = req_date + "(일)"; break;
    case 2: req_date_week = req_date + "(월)"; break;
    case 3: req_date_week = req_date + "(화)"; break;
    case 4: req_date_week = req_date + "(수)"; break;
    case 5: req_date_week = req_date + "(목)"; break;
    case 6: req_date_week = req_date + "(금)"; break;
    case 7: req_date_week = req_date + "(토)"; break;
}

int tmpReqNo    =   0;
String tmpProName   =   "";

//계 variables
int totalMaxPer	=	0;
int totalCurrPer=	0;
int totalReqPer	=	0;

//신청 정보 호출
sql		=	new StringBuffer();
sql_str	=	" SELECT ";
sql_str	+=	" ARAL.* ";
sql_str	+=	" , ARALC.PRO_NO AS MY_PRO_NO ";
sql_str	+=	" , ARALC.* ";
sql_str	+=	" , (CASE WHEN ARAL.REQ_DATE > TO_CHAR(SYSDATE, 'YYYY-MM-DD') THEN 'Y'  ";
sql_str	+=	" 	WHEN ARAL.REQ_DATE <= TO_CHAR(SYSDATE, 'YYYY-MM-DD') THEN 'N' END) AS REQ_DATE_OVER ";
sql_str	+=	" FROM ART_REQ_ALWAY ARAL LEFT JOIN ART_REQ_ALWAY_CNT ARALC ON ARAL.REQ_NO = ARALC.REQ_NO ";
sql_str	+=	" WHERE ARAL.REQ_NO = ? ";
sql_str	+=	" ORDER BY MY_PRO_NO ";
sql.append(sql_str);

reqDataList	=	jdbcTemplate.query(sql.toString(), new Object[]{req_no}, new ArtReqList());
for (ArtReqData data : reqDataList) {
	sch_nm			=	data.req_sch_nm;
	apply_text		=	data.apply_flag;
	aft_text		=	data.req_aft_flag;
	sch_mng_nm		=	data.sch_mng_nm;
	sch_mng_tel		=	data.sch_mng_tel;
	sch_mng_mail	=	parseNull(data.sch_mng_mail, "메일이 없습니다.");
	sch_lead_nm		=	parseNull(data.sch_lead_nm, "-");
	sch_lead_tel	=	parseNull(data.sch_lead_tel, "-");
	totalReqPer		+=	data.req_per;
	req_date_over	=	data.req_date_over;
}

//프로그램 리스트와 정원 현원 호출
sql     =   new StringBuffer();
sql_str	=	" SELECT ";
sql_str	+=	" APAL.* ";
sql_str	+=	" , ( ";
sql_str	+=	"   SELECT NVL(SUM(ART_REQ_ALWAY_CNT.REQ_PER), 0) ";
sql_str	+=	"   FROM ART_REQ_ALWAY LEFT JOIN ART_REQ_ALWAY_CNT ON ART_REQ_ALWAY.REQ_NO = ART_REQ_ALWAY_CNT.REQ_NO ";
/*
*	PURPOSE	:	전일 신청일 경우 오전, 오후 인원 모두 sum 하여 호출하기
*	CREATE	:	20180322_thur	JI
*	MODIFY	:	....
*/

sql_str	+=	"   WHERE ART_REQ_ALWAY.APPLY_FLAG IN ('Y', 'N') AND ART_REQ_ALWAY_CNT.PRO_NO= APAL.PRO_NO AND ART_REQ_ALWAY.REQ_DATE= ? ";
sql_str	+=	"   AND ART_REQ_ALWAY.REQ_AFT_FLAG IN ('D', ? ) ";
sql_str	+=	"   ) AS CURR_PER ";
sql_str	+=	" FROM ART_PRO_ALWAY APAL ";
sql_str	+=	" WHERE APAL.SHOW_FLAG = 'Y' AND APAL.DEL_FLAG != 'Y' ";
sql_str	+=	" ORDER BY APAL.PRO_NO ";
sql.append(sql_str);

insObj  =   new Object[] {
        req_date
		, aft_text
    };
proDataList =   jdbcTemplate.query(sql.toString(), insObj, new ArtProList());


%>

<%/*************************************** javascript 구역임 ****************************************/%>
<script>
	function go_cancel(req_no) {
		if (confirm("접수된 프로그램 신청이 취소됩니다.\n취소한 신청은 되돌릴 수 없습니다.\n신청을 취소하시겠습니까?")) {
			location.href="/program/art/client/programAlwaysReqAction.jsp?dataType=can&reqNo=" + req_no;
			return;
		}
	}

	function go_modify(req_no, aft_text) {
		if (confirm("수정하시겠습니까?")) {
			location.href="/index.gne?menuCd=DOM_000002001002003003&req_no=" + req_no + "&aft_flag=" + aft_text;
			return;
		}
	}
</script>
<%/*************************************** 퍼블리싱 구역임 ****************************************/%>

<form id="" method="">
	<h3>프로그램 신청 정보</h3>
	<table class="table_skin01 fsize td-l f_nanum">
		<caption>프로그램 신청 정보 정보 : 학교명, 접수상태, 신청일, 분류, 프로그램내역, 담당자명, 담당자 명, 담당자 연락처, 담당자 이메일, 대표 인솔자명, 대표 인솔자명 연락처 등의 정보를 제공하는 표입니다.</caption>
		<colgroup>
			<col style="width:18%" />
			<col style="width:32%"/>
			<col style="width:18%" />
			<col style="width:32%"/>
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">학교명</th>
				<td><%=sch_nm %></td>
				<th scope="row">접수상태</th>
				<%=applyText(apply_text, req_date_over) %>
			</tr>
			<tr>
				<th scope="row">신청일</th>
				<td><%=req_date_week %></td>
				<th scope="row">분류</th>
				<td><%=aftText(aft_text, 2) %></td>
			</tr>
			<tr>
				<th scope="row">프로그램 내역</th>
				<td colspan="3">
					<table class="tb_board nohover thgrey td-c mg_0">
							<caption>프로그램 내역 : 번호, 신청일/분류, 프로그램명, 강사명, 정원, 현원, 신청인원 등의 정보를 제공합니다.</caption>
							<colgroup>
								<col style="width:8%">
								<col />
								<col style="width:20%">
								<col style="width:15%">
								<col style="width:10%">
								<col style="width:10%">
								<col style="width:65px">
							</colgroup>
							<thead>
								<tr>
									<th scope="col">번호</th>
									<th scope="col">신청일/분류</th>
									<th scope="col">프로그램명</th>
									<th scope="col">강사명</th>
									<th scope="col">정원</th>
									<th scope="col">현원</th>
									<th scope="col">신청인원</th>
								</tr>
							</thead>
							<tbody>
							<%for(ArtProData data : proDataList) {
								totalMaxPer	+=	data.max_per;
								totalCurrPer+=	data.curr_per;
							%>
								<tr>
									<td><%=data.pro_no %></td>
									<td><%=req_date_week %> / <%=aftText(aft_text, 1) %></td>
									<td><%=data.pro_name %></td>
									<td><%=data.pro_tch_nm %></td>
									<td><%=data.max_per %></td>
									<td>
										<%if (data.max_per <= data.curr_per) {
											out.println("<span class='red'>마감</span>");
										} else {out.println(data.curr_per);}
										%>
									</td>
									<td><span class="fb">
									<%for (ArtReqData list : reqDataList) {
										if (Integer.toString(list.my_pro_no).equals(Integer.toString(data.pro_no))) {
											out.println(list.req_per);
										}// else {out.println("0");}
									}%>
									</span></td>
								</tr>
							<%}%>
							</tbody>
							<tfoot>
								<tr>
									<td colspan="4" class="c">계</td>
									<td class="c"><%=totalMaxPer %></td>
									<td class="c"><%=totalCurrPer %></td>
									<td class="c"><%=totalReqPer %></td>
								</tr>
							</tfoot>
						</table>
				</td>
			</tr>
			<tr>
				<th scope="row">담당자명</th>
				<td><%=sch_mng_nm %></td>
				<th scope="row">담당자 연락처</th>
				<td><%=sch_mng_tel %></td>
			</tr>
			<tr>
				<th scope="row">담당자 이메일</th>
				<td colspan="3"><%=sch_mng_mail %></td>
			</tr>
			<tr>
				<th scope="row">대표 인솔자명</th>
				<td><%=sch_lead_nm %></td>
				<th scope="row">대표 인솔자명 연락처</th>
				<td><%=sch_lead_tel %></td>
			</tr>
		</tbody>
	</table>

	<fieldset>
		<legend>실행 버튼 영역</legend>
		<div class="btn_area c">
			<%if (apply_text.equals("N") && req_date_over.equals("Y")) {%>
			<button type="button" onclick="go_modify('<%=req_no%>', '<%=aft_text%>')" class="btn medium edge mako">수정</button>
			<button type="button" onclick="go_cancel('<%=req_no%>')" class="btn medium edge mako">접수 취소</button>
			<%} else if (req_date_over.equals("Y") && apply_text.equals("Y")) {%>
			<button type="button" onclick="go_cancel('<%=req_no%>')" class="btn medium edge mako">접수 취소</button>
			<%}%>
			<button onclick="history.back();" type="button" class="btn medium edge darkMblue w_100">확인</button>
		</div>
	</fieldset>
</form>