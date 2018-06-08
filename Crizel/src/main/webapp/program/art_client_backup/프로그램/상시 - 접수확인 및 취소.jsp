<%
/**
*   PURPOSE :   <상시> 프로그램 접수확인 및 취소
*   CREATE  :   20180208_thur   JI
*   MODIFY  :   ...
**/
%>

<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>


<%/*************************************** 프로그램 구역 ****************************************/%>

<%!
    private class ArtReqData {
        //신청 변수
        public int req_no;
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
        //신청 개별 변수
        //public int pro_no;
        public String pro_name;

        public String req_date_over;
    }

    private class ArtReqList implements RowMapper<ArtReqData> {
        public ArtReqData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ArtReqData reqData   =   new ArtReqData();
            
            //request tb data values
            reqData.req_no          =   rs.getInt("REQ_NO");
            reqData.req_sch_id      =   rs.getString("REQ_SCH_ID");
            reqData.sch_mng_nm      =   rs.getString("SCH_MNG_NM");
            reqData.sch_mng_tel     =   rs.getString("SCH_MNG_TEL");
            reqData.sch_mng_mail    =   rs.getString("SCH_MNG_MAIL");
            reqData.reg_date        =   rs.getString("REG_DATE");
            reqData.reg_ip          =   rs.getString("REG_IP");
            reqData.apply_flag      =   rs.getString("APPLY_FLAG");
            reqData.req_cnt         =   rs.getInt("REQ_CNT");
            reqData.req_date        =   rs.getString("REQ_DATE");
            reqData.req_aft_flag    =   rs.getString("REQ_AFT_FLAG");
            reqData.req_sch_nm      =   rs.getString("REQ_SCH_NM");
            reqData.req_sch_grade   =   rs.getString("REQ_SCH_GRADE");
            reqData.req_sch_group   =   rs.getString("REQ_SCH_GROUP");
            reqData.apply_date      =   rs.getString("APPLY_DATE");
            //program tb data values
            //reqData.pro_no          =   rs.getInt("PRO_NO");
            reqData.pro_name        =   rs.getString("PRO_NAME");

            reqData.req_date_over   =   rs.getString("REQ_DATE_OVER");

            return reqData;
        }
    }

    private String applyText (String flag , String reqDateOver) {
        String returnText   =   "승인대기";
        if (flag.equals("Y")) {
            returnText  =   "<td><span class=\"dis_mo\">접수상태</span><span class=\"fb red\">승인완료</span></td>";
        } else if (flag.equals("N")) {
            if (reqDateOver.equals("Y")) returnText  =   "<td><span class=\"dis_mo\">접수상태</span><span class=\"fb\">승인대기</span></td>";
            else returnText  =   "<td><span class=\"dis_mo\">접수상태</span><span class=\"fb\">기간초과</span></td>";
        } else if (flag.equals("A")) {
            returnText  =   "<td><span class=\"dis_mo\">접수상태</span><span class=\"fb\">관리자 취소</span></td>";
        } else if (flag.equals("C")) {
            returnText  =   "<td><span class=\"dis_mo\">접수상태</span><span class=\"fb\">직접취소</span></td>";
        } else {
            returnText  =   "<td><span class=\"fb red\">오류</span></td>";
        }
        return returnText;
    }

    private String aftText (String aftFlag) {
        String returnText   =   "전일";
        if (aftFlag.equals("M")) {
            returnText  =   "<td><span class=\"dis_mo\">분류</span><span class='badge bg-am'>오전</span></td>";
        } else if (aftFlag.equals("F")) {
            returnText  =   "<td><span class=\"dis_mo\">분류</span><span class='badge bg-pm'>오후</span></td>";
        } else if (aftFlag.equals("D")) {
            returnText  =   "<td><span class=\"dis_mo\">분류</span><span class='badge bg-day'>전일</span></td>";
        }
        return returnText;
    }

%>

<%

SessionManager sessionManager   =   new SessionManager(request);

/* Session Chk */
if (sessionManager.getName().trim().equals("") || sessionManager.getId().trim().equals("") || sessionManager.getName().trim().length() < 1 || sessionManager.getId().trim().length() < 1) {
    out.println("<script>");
    out.println("alert('로그인한 회원만 열람 가능합니다.');");
    out.println("location.href='/index.gne?menuCd=DOM_000002001002003002';");
    out.println("</script>");
}

String outHtml      =   "";
String tmpDate      =   "";

StringBuffer sql                =   null;
String sql_str                  =   "";
List<ArtReqData> reqDateList    =   null;

Object[] insObj =   null;
int totalDate   =   0;
int cnt         =   0;
int num         =   0;

int tmpReqNo    =   0;
String tmpProName   =   "";

//프로그램 수 확인
int program_cnt     =   1;
sql     =   new StringBuffer();
sql.append(" SELECT NVL(COUNT(*), 1) FROM ART_PRO_ALWAY WHERE SHOW_FLAG = 'Y' AND DEL_FLAG != 'Y' ");
program_cnt =   jdbcTemplate.queryForObject(sql.toString(), Integer.class);

Paging paging = new Paging();
paging.setPageSize(10 * program_cnt);
String pageNo = parseNull(request.getParameter("pageNo"), "1");
int totalCount = 0;

try{
	
	//나중에 getId 로 매칭 된 것만 select totalCount
    sql     =   new StringBuffer();
    sql_str =   " SELECT COUNT(*) ";
    sql_str +=  " FROM ART_REQ_ALWAY REQAL LEFT JOIN ART_REQ_ALWAY_CNT REQAL_CNT ON REQAL.REQ_NO = REQAL_CNT.REQ_NO ";
    sql_str +=  " JOIN (SELECT * FROM ART_PRO_ALWAY WHERE DEL_FLAG != 'Y' AND SHOW_FLAG = 'Y') C ON REQAL_CNT.PRO_NO = C.PRO_NO ";
    sql_str +=  " WHERE REQAL.REQ_SCH_ID = ? ";
    sql_str +=  " ORDER BY REQAL.REQ_DATE DESC, REQAL.REQ_NO DESC ";
    sql.append(sql_str);
    insObj  =   new Object[] {
        sessionManager.getId()
    };
    totalCount =   jdbcTemplate.queryForObject(sql.toString(), insObj, Integer.class);
    
    paging.setPageNo(Integer.parseInt(pageNo));
    paging.setTotalCount(totalCount);
    paging.makePaging();
	
    //나중에 getId 로 매칭 된 것만 select
    sql     =   new StringBuffer();
    sql_str = 	"SELECT TOTAL.* FROM( ";
    sql_str += 	" SELECT ROWNUM AS RNUM, A.* FROM( ";
    sql_str +=  " SELECT ";
    sql_str +=  " COUNT(*)OVER(PARTITION BY REQAL.REQ_NO) ROWSPAN ";
    sql_str +=  " ,	REQAL.REQ_NO ";
    sql_str +=  " , REQAL.REQ_SCH_ID ";
    sql_str +=  " , REQAL.SCH_MNG_NM ";
    sql_str +=  " , REQAL.SCH_MNG_TEL ";
    sql_str +=  " , REQAL.SCH_MNG_MAIL ";
    sql_str +=  " , REQAL.REG_DATE ";
    sql_str +=  " , REQAL.REG_IP ";
    sql_str +=  " , REQAL.APPLY_FLAG ";
    sql_str +=  " , REQAL.REQ_CNT ";
    sql_str +=  " , REQAL.REQ_DATE ";
    sql_str +=  " , REQAL.REQ_AFT_FLAG ";
    sql_str +=  " , REQAL.REQ_SCH_NM ";
    sql_str +=  " , REQAL.REQ_SCH_GRADE ";
    sql_str +=  " , REQAL.REQ_SCH_GROUP ";
    sql_str +=  " , REQAL.APPLY_DATE ";
    sql_str +=  " , REQAL_CNT.PRO_NAME ";
    sql_str +=  " , (CASE WHEN REQAL.REQ_DATE > TO_CHAR(SYSDATE, 'YYYY-MM-DD') THEN 'Y' ";
    sql_str +=  "   WHEN REQAL.REQ_DATE <= TO_CHAR(SYSDATE, 'YYYY-MM-DD') THEN 'N' END) AS REQ_DATE_OVER ";
    sql_str +=  " FROM ART_REQ_ALWAY REQAL LEFT JOIN ART_REQ_ALWAY_CNT REQAL_CNT ON REQAL.REQ_NO = REQAL_CNT.REQ_NO ";
    sql_str +=  " JOIN (SELECT * FROM ART_PRO_ALWAY WHERE DEL_FLAG != 'Y' AND SHOW_FLAG = 'Y') C ON REQAL_CNT.PRO_NO = C.PRO_NO ";
    sql_str +=  " WHERE REQAL.REQ_SCH_ID = ? ";
    sql_str +=  " ORDER BY REQAL.REQ_DATE DESC, REQAL.REQ_NO DESC ";
    sql_str +=  "  ) A WHERE ROWNUM <= ? ";
    sql_str +=  " ) TOTAL WHERE RNUM > ? ";
    sql.append(sql_str);
    insObj  =   new Object[] {
        sessionManager.getId(), paging.getEndRowNo(), paging.getStartRowNo()
    };
    reqDateList =   jdbcTemplate.query(sql.toString(), insObj, new ArtReqList());
    
}catch(Exception e){
	out.println(e.toString());
}

%>


<%/*************************************** 퍼블리싱 구역임 ****************************************/%>
<h3>접수확인 및 취소</h3>
<table class="rwList tb_board nohover thgrey td-c">
	<caption>상시프로그램 접수확인 및 취소 : 접수번호, 신청일, 프로그램명, 분류, 총 신청인원, 담당자명, 접수일, 접수상태 등의 정보를 제공하는 목록표입니다.</caption>
	<colgroup>
		<col style="width:8%">
		<col style="width:13%">
		<col />
		<col style="width:7%">
		<col style="width:10%">
		<col style="width:10%">
		<col style="width:20%">
		<col style="width:65px">
	</colgroup>
	<thead>
		<tr>
			<th scope="col">접수번호</th>
			<th scope="col">신청일</th>
			<th scope="col">프로그램명</th>
			<th scope="col">분류</th>
			<th scope="col">총 신청인원</th>
			<th scope="col">담당자명</th>
			<th scope="col">접수일</th>
			<th scope="col">접수상태</th>
		</tr>
	</thead>
	<tbody>
    <%
    if (reqDateList.size() > 0) {
        for(ArtReqData data : reqDateList){
            if (tmpReqNo != data.req_no) {
                tmpReqNo    =   data.req_no;
                tmpProName  =   "";

                out.println("<tr>");
            %>
                <td><span class="dis_mo">접수번호</span><%=data.req_no %></td>
                <td><span class="dis_mo">신청일</span><a href="./index.gne?menuCd=DOM_000002001002003004&req_no=<%=data.req_no %>&req_date=<%=data.req_date %>" class="fb"><%=data.req_date %></a></td>
                <td><span class="dis_mo">프로그램명</span><%
                int pro_cnt =   0;
                for(ArtReqData proNm : reqDateList) {
                    if (tmpReqNo == proNm.req_no && tmpProName.equals("")) {
                        tmpProName	=	proNm.pro_name;
                    } else if (tmpReqNo == proNm.req_no && tmpProName.length() > 1) {
                        pro_cnt +=  1;
                    }
                }//END FOR
                if (pro_cnt > 0) {tmpProName	+=	" 외 " + pro_cnt + "개";}
                out.println(tmpProName);
                %></td>
                <%out.println(aftText(data.req_aft_flag));%>
                <td><span class="dis_mo">총 신청인원</span><%=data.req_cnt %></td>
                <td><span class="dis_mo">담당자명</span><%=data.sch_mng_nm %></td>
                <td><span class="dis_mo">접수일</span><%=data.reg_date %></td>
                <%out.println(applyText(data.apply_flag, data.req_date_over));%>
            </tr>
            <%}/*END IF*/%>
    <%}/*END FOR*/%>
    <%} else {%>
        <tr>
            <td colspan="8">신청 내역이 없습니다.</td>
        </tr>
    <%}/*END ELSE*/%>
	</tbody>
</table>

<% if(paging.getTotalCount() > 0) { %>
	<div class="pageing">
		<%=paging.getHtml("2") %>
	</div>
<% } %>