<%
/**
*   PURPOSE :   <심화> 프로그램 정보 입력
*   CREATE  :   20180222_thur   JI
*   MODIFY  :   ....
**/
%>

<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>

<%/*************************************** 프로그램 ****************************************/%>
<%try {%>

<%!

    //심화프로그램 호출
    private class DeepPro {
        public int pro_no;
        public int pro_cat_no;
        public String pro_cat_nm;
        public String pro_name;
        public String pro_tch_name;
        public String pro_tch_tel;
        public String pro_memo;
        public String appStr_date;
        public String appEnd_date;
        public String proStr_date;
        public String proEnd_date;
        public int curr_per;
        public int max_per;
        public String ob_employee;
        public String ob_student;
        public String ob_citizen;
        public String pro_time;

        public String pro_sts_flag;     //상태 표시(프로그램 종료 : PE, 프로그램 중 : PD, 모집종료 : AE, 모집중 : Y, 모집전 : N)

        //modify
        public int req_no;
        public int req_per;
        public String apply_flag;
        public String req_group;
        public String req_user_nm;
        public String req_user_tel;
        public String req_user_mail;
        public String req_mot;
        public String req_date;

    }

    private class DeepProList implements RowMapper<DeepPro> {
        public DeepPro mapRow(ResultSet rs, int rowNum) throws SQLException {
            DeepPro deepPro     =   new DeepPro();

            deepPro.pro_no          =   rs.getInt("PRO_NO");
            deepPro.pro_cat_no      =   rs.getInt("ARTCODE_NO");
            deepPro.pro_cat_nm      =   rs.getString("PRO_CAT_NM");
            deepPro.pro_name        =   rs.getString("PRO_NAME");
            deepPro.pro_tch_name    =   rs.getString("PRO_TCH_NAME");
            deepPro.pro_tch_tel     =   rs.getString("PRO_TCH_TEL");
            deepPro.pro_tch_tel     =   rs.getString("PRO_MEMO");
            deepPro.appStr_date     =   rs.getString("APPSTR_DATE");
            deepPro.appEnd_date     =   rs.getString("APPEND_DATE");
            deepPro.proStr_date     =   rs.getString("PROSTR_DATE");
            deepPro.proEnd_date     =   rs.getString("PROEND_DATE");
            deepPro.curr_per        =   rs.getInt("CURR_PER");
            deepPro.max_per         =   rs.getInt("MAX_PER");
            deepPro.ob_employee     =   rs.getString("OB_EMPLOYEE");
            deepPro.ob_student      =   rs.getString("OB_STUDENT");
            deepPro.ob_citizen      =   rs.getString("OB_CITIZEN");
            deepPro.pro_time        =   rs.getString("PRO_TIME");
            
            deepPro.pro_sts_flag    =   rs.getString("PRO_STS_FLAG");    //상태 표시(프로그램 종료 : PE, 모집종료 : AE, 모집중 : Y, 모집전 : N)

            return deepPro;
        }
    }

    private class ReqProList implements RowMapper<DeepPro> {
        public DeepPro mapRow(ResultSet rs, int rowNum) throws SQLException {
            DeepPro deepPro     =   new DeepPro();

            deepPro.pro_no          =   rs.getInt("PRO_NO");
            deepPro.pro_cat_no      =   rs.getInt("ARTCODE_NO");
            deepPro.pro_cat_nm      =   rs.getString("PRO_CAT_NM");
            deepPro.pro_name        =   rs.getString("PRO_NAME");
            deepPro.pro_tch_name    =   rs.getString("PRO_TCH_NAME");
            deepPro.pro_tch_tel     =   rs.getString("PRO_TCH_TEL");
            deepPro.pro_tch_tel     =   rs.getString("PRO_MEMO");
            deepPro.appStr_date     =   rs.getString("APPSTR_DATE");
            deepPro.appEnd_date     =   rs.getString("APPEND_DATE");
            deepPro.proStr_date     =   rs.getString("PROSTR_DATE");
            deepPro.proEnd_date     =   rs.getString("PROEND_DATE");
            deepPro.curr_per        =   rs.getInt("CURR_PER");
            deepPro.max_per         =   rs.getInt("MAX_PER");
            deepPro.ob_employee     =   rs.getString("OB_EMPLOYEE");
            deepPro.ob_student      =   rs.getString("OB_STUDENT");
            deepPro.ob_citizen      =   rs.getString("OB_CITIZEN");
            deepPro.pro_time        =   rs.getString("PRO_TIME");
            
            deepPro.pro_sts_flag    =   rs.getString("PRO_STS_FLAG");    //상태 표시(프로그램 종료 : PE, 모집종료 : AE, 모집중 : Y, 모집전 : N)

            deepPro.req_no          =   rs.getInt("REQ_NO");
            deepPro.req_per         =   rs.getInt("REQ_PER");
            deepPro.apply_flag      =   rs.getString("APPLY_FLAG");
            deepPro.req_group       =   rs.getString("REQ_GROUP");
            deepPro.req_user_nm     =   rs.getString("REQ_USER_NM");
            deepPro.req_user_tel    =   rs.getString("REQ_USER_TEL");
            deepPro.req_user_mail   =   rs.getString("REQ_USER_MAIL");
            deepPro.req_mot         =   rs.getString("REQ_MOT");
            deepPro.req_date        =   rs.getString("REQ_DATE");

            return deepPro;
        }
    }

%>

<%
//session check
SessionManager sessionManager	=	new SessionManager(request);

if (sessionManager.getName().trim().equals("") || sessionManager.getId().trim().equals("") || sessionManager.getName().trim().length() < 1 || sessionManager.getId().trim().length() < 1) {
	out.println("<script>");
	out.println("alert(\"로그인 정보가 확인되지 않습니다. 학교계정 로그인 후 시도 하세요.\");");
	out.println("history.back();");
	out.println("</script>");
	return;
}

String outHtml              =   "";

StringBuffer sql            =   null;
String sql_str              =   "";

DeepPro deepProData         =   null;   //심화 프로그램 데이터
Object[] insObj =   null;

String dataType	=	"ins";	//ins, mod

String pro_no	=   parseNull(request.getParameter("pro_no"), "");
String req_no	=   parseNull(request.getParameter("req_no"), "");
if (req_no != null && req_no.trim().length() > 0) {dataType = "mod";}

    //수정
    if ("mod".equals(dataType)) {

        sql     =   new StringBuffer();
        sql_str =   " SELECT ";
        sql_str +=  " PRO.*, REQ.* ";
        sql_str +=  " , REQ.REG_DATE AS REQ_DATE ";
        sql_str +=  " , (SELECT ARTCODE_NO FROM ART_PRO_CODE WHERE CODE_TBL = 'ART_PRO_DEEP' AND CODE_COL = 'PRO_CAT_NM' AND CODE_VAL1 = PRO.PRO_CAT_NM) AS ARTCODE_NO ";
        sql_str +=  " , (CASE ";
        sql_str +=  "   WHEN SYSDATE > PRO.PROEND_DATE THEN 'PE' ";
        sql_str +=  "   WHEN SYSDATE > PRO.APPEND_DATE OR ";
        sql_str +=  "   PRO.MAX_PER <= (SELECT NVL(SUM(REQ_PER), 0) FROM (SELECT * FROM ART_REQ_DEEP WHERE APPLY_FLAG = 'Y' AND SHOW_FLAG = 'Y' AND DEL_FLAG != 'Y') WHERE PRO_NO = PRO.PRO_NO)  ";
        sql_str +=  "   THEN 'AE' ";
        sql_str +=  "   WHEN SYSDATE < PRO.APPSTR_DATE THEN 'N' ";
        sql_str +=  "   ELSE 'Y' ";
        sql_str +=  "   END) AS PRO_STS_FLAG ";
        sql_str +=  " FROM ";
        sql_str +=  " (SELECT * FROM ART_REQ_DEEP WHERE SHOW_FLAG = 'Y' AND DEL_FLAG != 'Y' AND REQ_NO = ? ) REQ ";
        sql_str +=  " JOIN ART_PRO_DEEP PRO ON REQ.PRO_NO = PRO.PRO_NO ";
        sql.append(sql_str);
        deepProData    =   jdbcTemplate.queryForObject(sql.toString(), new Object[]{req_no}, new ReqProList());

    //신규 신청
    } else {

        sql     =   new StringBuffer();
        sql_str =   " SELECT ";
        sql_str +=  " PRO.* ";
        sql_str +=  " , (SELECT ARTCODE_NO FROM ART_PRO_CODE WHERE CODE_TBL = 'ART_PRO_DEEP' AND CODE_COL = 'PRO_CAT_NM' AND CODE_VAL1 = PRO.PRO_CAT_NM) AS ARTCODE_NO ";
        sql_str +=  " , (CASE ";
        sql_str +=  "   WHEN SYSDATE > PRO.PROEND_DATE THEN 'PE' ";
        sql_str +=  "   WHEN SYSDATE > PRO.APPEND_DATE ";
        sql_str +=  "       OR ";
        sql_str +=  "       PRO.MAX_PER <= (SELECT NVL(SUM(REQ_PER), 0) FROM (SELECT * FROM ART_REQ_DEEP WHERE APPLY_FLAG = 'Y' AND SHOW_FLAG = 'Y' AND DEL_FLAG != 'Y') WHERE PRO_NO = PRO.PRO_NO) ";
        sql_str +=  "   THEN 'AE' ";
        sql_str +=  "   WHEN SYSDATE < PRO.APPSTR_DATE THEN 'N' ";
        sql_str +=  "   ELSE 'Y' ";
        sql_str +=  "   END ) AS PRO_STS_FLAG ";
        sql_str +=  "    ";
        sql_str +=  "    ";
        sql_str +=  " FROM ";
        sql_str +=  " (SELECT * FROM ART_PRO_DEEP WHERE SHOW_FLAG = 'Y' AND DEL_FLAG != 'Y' AND PRO_NO = ? ORDER BY PRO_NO DESC) PRO ";
        sql.append(sql_str);
        deepProData    =   jdbcTemplate.queryForObject(sql.toString(), new Object[]{pro_no}, new DeepProList());

    }

%>

<%/*************************************** 퍼블리싱 ****************************************/%>

<form action="/program/art/client/programDeepReqAction.jsp" id="req_deep" name="req_deep" method="post">
	<input type="hidden" id="pro_no" name="pro_no" value="<%=pro_no %>">
	<input type="hidden" id="req_no" name="req_no" value="<%=req_no %>">
	<input type="hidden" id="dataType" name="dataType" value="<%=dataType %>">

	<h3>프로그램 신청 정보 입력</h3>
	<fieldset class="board">
		<legend>신청 정보 입력</legend>
			<table class="rwList tb_board nohover thgrey td-c">
				<caption>심화프로그램별 신청 인원 입력표입니다.</caption>
				<colgroup>
					<col style="width:8%">
					<col style="width:20%">
					<col />
                    <col style="width:20%">
					<col style="width:15%">
					<col style="width:10%">
					<col style="width:65px">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">구분</th>
						<th scope="col">프로그램명</th>
						<th scope="col">시간</th>
						<th scope="col">강사명</th>
						<th scope="col">현원/정원</th>
						<th scope="col">신청인원</th>
					</tr>
				</thead>
				<tbody>
                    <tr>
                        <td><span class="dis_mo">번호</span><span><%=deepProData.pro_no %></span></td>
                        <td><span class="dis_mo">구분</span><span><%=deepProData.pro_cat_nm %></span></td>
                        <td><span class="dis_mo">프로그램명</span><span><%=deepProData.pro_name %></span></td>
                        <td><span class="dis_mo">시간</span><span><%=deepProData.pro_time %></span></td>
                        <td><span class="dis_mo">강사명</span><span><%=deepProData.pro_tch_name %></span></td>
                        <td><span class="dis_mo">현원/정원</span><span><%=deepProData.curr_per %></span>/<span><%=deepProData.max_per %></span></td>
                        <td><span class="dis_mo">신청인원</span><span>
                            <input type="number" class="wps_70 c req_per" id="req_per" name="req_per" 
                            value="<% if("mod".equals(dataType)){out.print(deepProData.req_per);} %>" min="0" max="<%=deepProData.max_per-deepProData.curr_per %>" required/>
                        </span></td>
                    </tr>
                </tbody>
			</table>
	</fieldset>

    <h3>신청 담당자 정보</h3>
	<fieldset>
		<legend>신청 담당자 정보 입력</legend>
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
					<th scope="row"><span class="red fb">*</span> 소속기관</th>
					<td colspan="3"><input type="text" value="<% if("mod".equals(dataType)){out.print(deepProData.req_group);} %>" class="wps_80" id="req_group" name="req_group" placeholder="소속기관을 정확히 기재(가족단위 신청일 경우 ‘학부모로 기재’)" required></td>
				</tr>
                <tr>
					<th scope="row"><span class="red fb">*</span> 신청자명</th>
					<td colspan="3"><input type="text" value="<% if("mod".equals(dataType)){out.print(deepProData.req_user_nm);} %>" class="wps_80" id="req_user_nm" name="req_user_nm" placeholder="담당자명을 입력하세요." required></td>
				</tr>
				<tr>
					<th scope="row"><span class="red fb">*</span> 연락처</th>
					<td><input type="text" value="<% if("mod".equals(dataType)){out.print(deepProData.req_user_tel);} %>" class="wps_80" id="req_user_tel" name="req_user_tel" placeholder="숫자만 입력하세요." required>
						<br><span class="red fsize_90">&#8251; 반드시 연락 가능한 연락처를 입력해 주세요.</span>
                    </td>
					<th scope="row">이메일</th>
					<td><input type="text" value="<% if("mod".equals(dataType)){out.print(deepProData.req_user_mail);} %>" class="wps_80" id="req_user_mail" name="req_user_mail" placeholder="your@mail.com"><br /></td>
				</tr>
				<tr>
					<th scope="row">기타 입력사항</th>
					<td colspan="3">
                        <span class="red fsize_90">&#8251; 단체일 경우 구체적인 참여 명단을 입력해주세요.</span><br>
                        <textarea id="req_mot" name="req_mot"><% if("mod".equals(dataType)){out.print(parseNull(deepProData.req_mot, ""));} %></textarea>
                    </td>
				</tr>
			</tbody>
		</table>
	</fieldset>

	<fieldset>
		<legend>실행 버튼 영역</legend>
		<div class="btn_area c">
			<button onclick="history.back()" type="button" class="btn medium edge white">취소</button>
			<button type="submit" class="btn medium edge darkMblue w_100">확인</button>
		</div>
	</fieldset>
</form>



<%} catch (Exception e) {out.println(e.toString()); }%>