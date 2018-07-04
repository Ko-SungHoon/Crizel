<%
/**
*   PURPOSE :   <학교연계> 프로그램 신청 확인
*   CREATE  :   20180314_wed	JI
*   MODIFY  :   20180621	KO	전일제 삭제, 한 아이디로 오전·오후 중복 선택 가능하게 수정
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
		String req_aft_flag;
		String req_per;
		String rowspan;
		String req_no;
		String apply_flag;
		String req_date_over;
		String req_sch_type;
	}

	private class ArtProList implements RowMapper<ArtProData> {
		public ArtProData mapRow(ResultSet rs, int rowNum) throws SQLException {
			ArtProData artProData	=	new ArtProData();

			artProData.pro_no			=	rs.getInt("PRO_NO");
			artProData.pro_cat			=	rs.getString("PRO_CAT");
			artProData.pro_cat_nm		=	rs.getString("PRO_CAT_NM");
			artProData.pro_name			=	rs.getString("PRO_NAME");
			artProData.pro_memo			=	rs.getString("PRO_MEMO");
			artProData.pro_year			=	rs.getString("PRO_YEAR");
			artProData.max_per			=	rs.getInt("MAX_PER");
			artProData.pro_tch_nm		=	rs.getString("PRO_TCH_NM");
			artProData.curr_per			=	rs.getInt("CURR_PER");
			artProData.req_aft_flag		=	rs.getString("REQ_AFT_FLAG");
			artProData.req_per			=	rs.getString("REQ_PER");
			artProData.rowspan			=	rs.getString("ROWSPAN");
			artProData.req_no			=	rs.getString("REQ_NO");
			artProData.apply_flag		=	rs.getString("APPLY_FLAG");
			artProData.req_date_over	=	rs.getString("REQ_DATE_OVER");
			artProData.req_sch_type		=	rs.getString("REQ_SCH_TYPE");

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
			if (type == 2) {returnText += " (14:00 ~ 16:30)";}
		} else if (aft.equals("D")) {
			returnText		=	"전일반";
			if (type == 2) {returnText += " (09:00 ~ 16:00)";}
		}
		return returnText;
	}
%>

<%

try{
	

String listPage		=	"DOM_000000139008002002";	//	DOM_000000139008002002	,	TEST : DOM_000000129001001002
String viewPage		=	"DOM_000000139008002003";	//	DOM_000000139008002003	,	TEST : DOM_000000129001001003
String writePage	=	"DOM_000000139008002004";	//	DOM_000000139008002004	,	TEST : DOM_000000129001001004
String confirmPage	=	"DOM_000000139008002005";	//	DOM_000000139008002005	,	TEST : DOM_000000129001001005

SessionManager sessionManager   =   new SessionManager(request);

/* Session Chk */
if (sessionManager.getName().trim().equals("") || sessionManager.getId().trim().equals("") || sessionManager.getName().trim().length() < 1 || sessionManager.getId().trim().length() < 1) {
    out.println("<script>");
    out.println("alert('로그인 정보 저장 시간초과 입니다. 다시 로그인 하세요.');");
    out.println("location.href='/index.gne?menuCd="+viewPage+"';");
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

String req_no		=   parseNull(request.getParameter("req_no"), "");
String req_sch_id	=   parseNull(request.getParameter("req_sch_id"), "");
String req_date 	=   parseNull(request.getParameter("req_date"), "");
//파라미터 확인
if (req_sch_id.trim().equals("") || req_sch_id.length() < 1 || req_date.trim().equals("") || req_date.length() < 1) {
	out.println("<script>");
    out.println("alert('파라미터가 확인 되지 않습니다. 관리자에게 문의하세요.');");
    out.println("location.href='/index.gne?menuCd="+confirmPage+"';");
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
String req_date_over	=	null;

String req_sch_type		= 	""; 

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
sql_str	+=	" FROM HAPPY_REQ_SCH ARAL LEFT JOIN HAPPY_REQ_SCH_CNT ARALC ON ARAL.REQ_NO = ARALC.REQ_NO ";
sql_str	+=	" WHERE ARAL.REQ_SCH_ID = ?  ";
sql_str	+=	" ORDER BY MY_PRO_NO ";
sql.append(sql_str);

reqDataList	=	jdbcTemplate.query(sql.toString(), new Object[]{req_sch_id}, new ArtReqList());
for (ArtReqData data : reqDataList) {
	sch_nm			=	data.req_sch_nm;
	apply_text		=	data.apply_flag;
	aft_text		=	data.req_aft_flag;
	sch_mng_nm		=	data.sch_mng_nm;
	sch_mng_tel		=	data.sch_mng_tel;
	sch_mng_mail	=	parseNull(data.sch_mng_mail, "메일이 없습니다.");
	//totalReqPer		+=	data.req_per;
	req_date_over	=	data.req_date_over;
}

//프로그램 리스트와 정원 현원 호출
/* sql_str	=	" SELECT ";
sql_str	+=	" APAL.* ";
sql_str	+=	" , ( ";
sql_str	+=	"   SELECT NVL(SUM(HAPPY_REQ_SCH_CNT.REQ_PER), 0) ";
sql_str	+=	"   FROM HAPPY_REQ_SCH LEFT JOIN HAPPY_REQ_SCH_CNT ON HAPPY_REQ_SCH.REQ_NO = HAPPY_REQ_SCH_CNT.REQ_NO ";
sql_str	+=	"   WHERE HAPPY_REQ_SCH.APPLY_FLAG IN ('Y', 'N') AND HAPPY_REQ_SCH_CNT.PRO_NO= APAL.PRO_NO AND HAPPY_REQ_SCH.REQ_DATE= ? ";
sql_str	+=	"   AND HAPPY_REQ_SCH.REQ_AFT_FLAG IN ('D', ? ) ";
sql_str	+=	"   ) AS CURR_PER ";
sql_str	+=	" FROM HAPPY_PRO_SCH APAL ";
sql_str	+=	" WHERE APAL.SHOW_FLAG = 'Y' AND APAL.DEL_FLAG != 'Y' ";
sql_str	+=	" ORDER BY APAL.PRO_NO "; 
sql.append(sql_str);*/

sql_str = new String();
sql_str += "SELECT  																																";
sql_str += "	C.PRO_NO 																															";
sql_str += "	, C.PRO_CAT 																														";
sql_str += "	, C.PRO_CAT_NM 																														";
sql_str += "	, C.PRO_NAME 																														";
sql_str += "	, C.PRO_MEMO 																														";
sql_str += "	, C.PRO_YEAR 																														";
sql_str += "	, C.MAX_PER 																														";
sql_str += "	, C.PRO_TCH_NM 																														";
sql_str += "	, B.REQ_AFT_FLAG																													";
sql_str += "	, B.REQ_NO																															";
sql_str += "	, (SELECT COUNT(*) FROM HAPPY_REQ_SCH_CNT WHERE REQ_DATE = B.REQ_DATE AND REQ_NO = B.REQ_NO) AS ROWSPAN								";
sql_str += "	, B.APPLY_FLAG																														";
sql_str += "	, B.REQ_SCH_TYPE																													";
sql_str += "	, (CASE WHEN B.REQ_DATE > TO_CHAR(SYSDATE, 'YYYY-MM-DD') THEN 'Y'																	";
sql_str += "	   WHEN B.REQ_DATE <= TO_CHAR(SYSDATE, 'YYYY-MM-DD') THEN 'N' END) AS REQ_DATE_OVER													";   
sql_str += "	, A.REQ_PER																															";
sql_str += "	, (SELECT SUM(REQ_PER) 																												";
sql_str += "		FROM HAPPY_REQ_SCH_CNT 																											";
sql_str += "	     WHERE REQ_DATE = B.REQ_DATE AND PRO_NO = A.PRO_NO AND REQ_NO IN (SELECT REQ_NO 												";
sql_str += "	                                              	FROM HAPPY_REQ_SCH 																	";
sql_str += "	                                               	WHERE REQ_DATE = B.REQ_DATE AND REQ_AFT_FLAG = B.REQ_AFT_FLAG AND APPLY_FLAG IN ('Y', 'N')) ) AS CURR_PER		";					
sql_str += "	, (SELECT SUM(REQ_PER) FROM HAPPY_REQ_SCH_CNT WHERE REQ_DATE = B.REQ_DATE AND PRO_NO = A.PRO_NO ) AS CURR_PER						";
sql_str += "FROM HAPPY_REQ_SCH_CNT A LEFT JOIN HAPPY_REQ_SCH B ON A.REQ_NO = B.REQ_NO																";
sql_str += "						 LEFT JOIN HAPPY_PRO_SCH C ON A.PRO_NO = C.PRO_NO																";
/* sql_str += "SELECT 																												";
sql_str += "	A.*																												";
sql_str	+= "	, (SELECT SUM(REQ_PER) FROM HAPPY_REQ_SCH_CNT WHERE REQ_DATE = A.REQ_DATE AND PRO_NO = B.PRO_NO) AS CURR_PER	";
sql_str += "FROM HAPPY_REQ_SCH A LEFT JOIN HAPPY_REQ_SCH_CNT B ON A.REQ_NO = B.REQ_NO											"; */
sql_str += "WHERE B.REQ_SCH_ID = ? AND B.REQ_DATE = ? AND B.APPLY_FLAG IN ('Y', 'N')																";
sql_str += "ORDER BY DECODE(B.REQ_AFT_FLAG, 'M', 1, 'F', 2), A.PRO_NO																				";

insObj  =   new Object[] {
		req_sch_id
        , req_date
    };
proDataList =   jdbcTemplate.query(sql_str, insObj, new ArtProList());
%>

<%/*************************************** javascript 구역임 ****************************************/%>
<script>
	function go_cancel(req_no) {
		if (confirm("접수된 프로그램 신청이 취소됩니다.\n취소한 신청은 되돌릴 수 없습니다.\n신청을 취소하시겠습니까?")) {
			location.href="/program/happysch/client/programSchoolReqAction.jsp?dataType=can&reqNo=" + req_no;
			return;
		}
	}

	function go_modify(req_no) {
		location.href="/index.gne?menuCd=<%=writePage%>&req_no=" + req_no;
	}
</script>
<%/*************************************** 퍼블리싱 구역임 ****************************************/%>

<form id="" method="">
	<h3>프로그램 신청 정보</h3>
	<p class="f_r red">※ 신청유형(A:학교 단위 진로 체험, 자유학기제, B:꿈키움, WeeClass, 학업중단숙려제, 자유학교, Wee센터 체험 등)</p>
	<table class="table_skin01 fsize td-l f_nanum">
		<caption>프로그램 신청 정보 확인</caption>
		<colgroup>
			<col style="width:15%" />
			<!-- <col style="width:35%"/>
			<col style="width:15%" />
			<col style="width:35%"/> -->
			<col style="width:85%" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">학교명</th>
				<td colspan="3"><%=sch_nm %></td>
				<%-- <th>접수상태</th>
				<%=applyText(apply_text, req_date_over) %> --%>
			</tr>
			<tr>
				<th scope="row">신청일</th>
				<td colspan="3"><%=req_date_week %></td>
				<%-- <th scope="row">분류</th>
				<td><%=aftText(aft_text, 2) %></td> --%>
			</tr>
			<tr>
				<th scope="row">프로그램 내역</th>
				<td colspan="3">
					<table class="tb_board nohover thgrey td-c mg_0">
							<caption>상시프로그램별 신청 인원 입력표입니다.</caption>
							<colgroup>
								<col style="width:8%">
								<col />
								<col style="width:20%">
								<col style="width:15%">
								<col style="width:7%">
								<col style="width:7%">
								<col style="width:7%">
								<col style="width:5%">
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
									<th scope="col">신청유형</th>
									<th scope="col">접수취소</th>
								</tr>
							</thead>
							<tbody>
							<%
							String tmpReq = "";
							for(ArtProData data : proDataList) {
								totalMaxPer		+=	data.max_per;
								totalCurrPer	+=	data.curr_per;
								totalReqPer		+=	Integer.parseInt(data.req_per);
								req_sch_type 	= parseNull(data.req_sch_type);
								if(!"".equals(req_sch_type)){
									if("학교 단위 진로 체험, 자유학기제".equals(data.req_sch_type)){
										req_sch_type = "A";
									}else{
										req_sch_type = "B";
									}
								}
							%>
								<tr>
									<td><%=data.pro_no %></td>
									<td><%=req_date_week %> / <%=aftText(data.req_aft_flag, 1) %></td>
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
										<%=data.req_per %>
									<%-- <%for (ArtReqData list : reqDataList) {
										if (Integer.toString(list.my_pro_no).equals(Integer.toString(data.pro_no))) {
											out.println(list.req_per);
										}// else {out.println("0");}
									}%> --%>
									</span></td>
									<td><%=req_sch_type%></td>
									<%
									if(!tmpReq.equals(data.req_no)){
									%>
									<td rowspan="<%=data.rowspan%>">
										<%if ("N".equals(data.apply_flag) && "Y".equals(data.req_date_over)) {%>
										<button type="button" onclick="go_modify('<%=data.req_no%>')" class="btn small edge mako mg_b15">수정</button>
										<button type="button" onclick="go_cancel('<%=data.req_no%>')" class="btn small edge mako mg_b15">취소</button>
										<%} else if ("Y".equals(data.req_date_over) && "Y".equals(data.apply_flag)) {%>
										<button type="button" onclick="go_cancel('<%=data.req_no%>')" class="btn small edge mako mg_b15">취소</button>
										<%}%>
									</td>
									<%
									}
									tmpReq = data.req_no;
									%>
								</tr>
							<%}%>
							</tbody>
							<tfoot>
								<tr>
									<td colspan="4" class="c">계</td>
									<td class="c"><%=totalMaxPer %></td>
									<td class="c"><%=totalCurrPer %></td>
									<td class="c"><%=totalReqPer %></td>
									<td colspan="2" class="c"></td>
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
		</tbody>
	</table>

	<fieldset>
		<legend>실행 버튼 영역</legend>
		<div class="btn_area c">
			<%-- <%if (apply_text.equals("N") && req_date_over.equals("Y")) {%>
			<button type="button" onclick="go_modify('<%=req_sch_id%>')" class="btn medium edge mako">수정</button>
			<button type="button" onclick="go_cancel('<%=req_sch_id%>')" class="btn medium edge mako">접수 취소</button>
			<%} else if (req_date_over.equals("Y") && apply_text.equals("Y")) {%>
			<button type="button" onclick="go_cancel('<%=req_sch_id%>')" class="btn medium edge mako">접수 취소</button>
			<%}%> --%>
			<button onclick="history.back();" type="button" class="btn medium edge darkMblue w_100">확인</button>
		</div>
	</fieldset>
</form>

<%}catch(Exception ee){
	out.println("<script>");
	out.println("alert('처리중 오류가 발생하였습니다.');");
	out.println("history.go(-1);");
	out.println("</script>");
}%>