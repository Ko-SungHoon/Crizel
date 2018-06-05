<%
/**
*   PURPOSE :   상시프로그램 추가 popup page
*   CREATE  :   20180130_tue    Ko
*   MODIFY  :   20180226 LJH 클래스 수정
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>상시프로그램 추가</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
		<style type="text/css">
			input[type="number"] {border:1px solid #bfbfbf; vertical-align:middle; line-height:18px; padding:5px; box-sizing: border-box;}
		</style>
</head>
<body>
<%!
private class ArtVO{
	public int pro_no;
	public String pro_cat;
	public String pro_cat_nm;
	public String pro_name;
	public String pro_memo;
	public String pro_year;
	public String reg_id;
	public String reg_ip;
	public String reg_date;
	public String mod_date;
	public String show_flag;
	public String del_flag;
	public int max_per;
	public String aft_flag;
	public String pro_tch_nm;

	public int req_per;

	public int artcode_no;
	public String code_tbl;
	public String code_col;
	public String code_name;
	public String code_val1;
	public String code_val2;
	public String code_val3;
	public int order1;
	public int order2;
	public int order3;
}

private class ArtVOMapper implements RowMapper<ArtVO> {
    public ArtVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ArtVO vo = new ArtVO();
        vo.pro_no			=	rs.getInt("PRO_NO");
        vo.pro_cat			=	rs.getString("PRO_CAT");
        vo.pro_cat_nm 		=	rs.getString("PRO_CAT_NM");
        vo.pro_name			=	rs.getString("PRO_NAME");
        vo.pro_memo 		=	rs.getString("PRO_MEMO");
        vo.pro_year 		=	rs.getString("PRO_YEAR");
        vo.reg_id			=	rs.getString("REG_ID");
        vo.reg_ip			=	rs.getString("REG_IP");
        vo.reg_date 		=	rs.getString("REG_DATE");
        vo.mod_date 		=	rs.getString("MOD_DATE");
        vo.show_flag 		=	rs.getString("SHOW_FLAG");
        vo.del_flag 		=	rs.getString("DEL_FLAG");
        vo.max_per 			=	rs.getInt("MAX_PER");
        vo.aft_flag 		=	rs.getString("AFT_FLAG");
        vo.pro_tch_nm 		=	rs.getString("PRO_TCH_NM");

		vo.req_per			=	rs.getInt("REQ_PER");

        return vo;
    }
}

private class ArtVOMapper2 implements RowMapper<ArtVO> {
    public ArtVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	ArtVO vo = new ArtVO();
        vo.artcode_no		= rs.getInt("ARTCODE_NO");
        vo.code_tbl 		= rs.getString("CODE_TBL");
        vo.code_col			= rs.getString("CODE_COL");
        vo.code_name 		= rs.getString("CODE_NAME");
        vo.code_val1 		= rs.getString("CODE_VAL1");
        vo.code_val2		= rs.getString("CODE_VAL2");
        vo.code_val3		= rs.getString("CODE_VAL3");
        vo.order1 			= rs.getInt("ORDER1");
        vo.order2 			= rs.getInt("ORDER2");
        vo.order3 			= rs.getInt("ORDER3");
        return vo;
    }
}


%>
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
Connection conn = null;
try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	// 접속한 관리자 회원의 권한 롤
	roleId= getRoleId(sqlMapClient, conn, sessionId);
	
	// 관리자 접근 허용된 IP 배열
	allowIp = getAllowIpArrays(sqlMapClient, conn);
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

SessionManager sm = new SessionManager(request);

Calendar cal    =  Calendar.getInstance();
String year 	=  parseNull(request.getParameter("year"), Integer.toString(cal.get(Calendar.YEAR)) );
String mode 	=  parseNull(request.getParameter("mode"), "insert");
String pro_no 	=  parseNull(request.getParameter("pro_no"));

StringBuffer sql 		= null;
List<ArtVO> list 		= null;
ArtVO vo			 	= new ArtVO();
List<ArtVO> list2 		= null;

try{
	if(!"".equals(pro_no)){
		sql = new StringBuffer();
		sql.append("SELECT ART_PRO_ALWAY.*					");
		sql.append("	, (SELECT NVL(MAX(ART_REQ_ALWAY_CNT.REQ_PER), 0) FROM ART_REQ_ALWAY_CNT WHERE PRO_NO = ART_PRO_ALWAY.PRO_NO) AS REQ_PER ");
		sql.append("FROM ART_PRO_ALWAY						");
		sql.append("WHERE PRO_NO = ?						");
		sql.append("ORDER BY PRO_NO DESC		 			");
		vo = jdbcTemplate.queryForObject(
					sql.toString(),
					new ArtVOMapper(),
					new Object[]{pro_no}
				);
	}

	sql = new StringBuffer();
	sql.append("SELECT *								");
	sql.append("FROM ART_PRO_CODE						");
	sql.append("WHERE CODE_NAME = 'ART_PRO_ALWAY' 		");
	sql.append("ORDER BY ORDER1, ARTCODE_NO	 			");
	list2 = jdbcTemplate.query(
				sql.toString(),
				new ArtVOMapper2()
			);

}catch(Exception e){
	out.println(e.toString());
}

%>
<script>
function insertSubmit(){
	var msg;
	var addr;

	if (Number($("#max_per").val()) < Number($("#curr_per").val())) {
		alert("정원이 신청인원 보다 적습니다.");
		$("#max_per").focus();
		return false;
	}

	if($("#mode").val() == "insert"){
		msg 	= "등록";
	}else{
		msg 	= "수정";
	}

	if(confirm(msg+"하시겠습니까?")){
		return true;
	}else{
		return false;
	}
}
$(function(){
	$('#max_per').keyup(function(){this.value = this.value.replace(/[^0-9]/g,'');});
});
</script>
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>상시프로그램 <%if("insert".equals(mode)){%>추가<%}else{%>수정<%}%></strong></p>
  </div>
	<div id="content">
		<div class="listArea">
			<form action="programAlwaysInsertAction.jsp" method="post" id="insertForm" name="insertForm" onsubmit="return insertSubmit();">
				<fieldset>
				<input type="hidden" id="mode" name="mode" value="<%=mode%>">
				<input type="hidden" id="reg_id" name="reg_id" value="<%=sm.getId()%>">
				<input type="hidden" id="reg_ip" name="reg_ip" value="<%=request.getRemoteAddr()%>">
				<input type="hidden" id="pro_no" name="pro_no" value="<%=vo.pro_no%>">
					<legend>분류관리</legend>
					<table class="bbs_list2 td-l">
						<colgroup>
							<col width="30%" />
							<col width="70%" />
						</colgroup>
						<tbody style="text-align: center; vertical-align: middle;">
						<tr>
							<th scope="row">
								프로그램 분류
							</th>
							<td>
								<select id="pro_cat_nm" name="pro_cat_nm">
								<%
								if(list2!=null && list2.size()>0){
								for(ArtVO ob : list2){
								%>
									<option value="<%=ob.code_val1%>" <%if(ob.code_val1.equals(vo.pro_cat_nm)){%> selected="selected" <%}%> ><%=ob.code_val1 %></option>
								<%
								}
								}
								%>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">
								년도
							</th>
							<td>
								<select id="pro_year" name="pro_year">
								<%
								for(int i=cal.get(Calendar.YEAR); i>=2017; i--){
								%>
									<option value="<%=i%>" <%if(Integer.toString(i).equals(vo.pro_year)){%> selected="selected" <%}%>><%=i%>년</option>
								<%
								}
								%>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">
								프로그램명
							</th>
							<td>
								<input type="text" id="pro_name" name="pro_name" class="wps_70" value="<%=parseNull(vo.pro_name)%>" required>
							</td>
						</tr>
						<tr>
							<th scope="row">
								오전/오후
							</th>
							<td>
								<select id="aft_flag" name="aft_flag" required>
									<option value="M" <%if("M".equals(vo.aft_flag)){out.println("selected");}%>>오전</option>
									<option value="F" <%if("F".equals(vo.aft_flag)){out.println("selected");}%>>오후</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">
								강사명
							</th>
							<td>
								<input type="text" id="pro_tch_nm" name="pro_tch_nm" value="<%=parseNull(vo.pro_tch_nm)%>" required>
							</td>
						</tr>

                        <%--20180221_wed    JI
                            그냥 모두로 고정
						<tr>
							<th scope="row">
								오전,오후,종일,모두 선택
							</th>
							<td>
								<input type="radio" id=aft_flag name="aft_flag" value="M"	<%if("M".equals(vo.aft_flag)){%> checked="checked" <%}%> required>오전
								<input type="radio" id="aft_flag" name="aft_flag" value="F" <%if("F".equals(vo.aft_flag)){%> checked="checked" <%}%> required>오후
								<input type="radio" id="aft_flag" name="aft_flag" value="D" <%if("D".equals(vo.aft_flag)){%> checked="checked" <%}%> required>종일
								<input type="radio" id="aft_flag" name="aft_flag" value="A" <%if("A".equals(vo.aft_flag)){%> checked="checked" <%}%> required>모두
							</td>
						</tr>
                        --%>

						<tr>
							<th scope="row">
								가장 많은 신청 인원
							</th>
							<td>
								<input type="text" id="curr_per" name="curr_per" class="w_100" value="<%=vo.req_per%>" readonly>
							</td>
						</tr>
						<tr>
							<th scope="row">
								정원
							</th>
							<td>
								<input type="text" id="max_per" name="max_per" class="w_100" value="<%=vo.max_per%>" required>
							</td>
						</tr>
						<tr>
							<th scope="row">
								노출 여부
							</th>
							<td>
								<input type="radio" id="show_flag1" name="show_flag" value="Y" <%if("Y".equals(vo.show_flag)){%> checked="checked" <%}%> required> <label for="show_flag1">Y</label>
								<input type="radio" id="show_flag2" name="show_flag" value="N" <%if("N".equals(vo.show_flag)){%> checked="checked" <%}%> required> <label for="show_flag2">N</label>
							</td>
						</tr>
						<tr>
							<th scope="row">
								프로그램 상세 내용
							</th>
							<td>
								<textarea class="wps_90 h150" id="pro_memo" name="pro_memo" required><%=parseNull(vo.pro_memo)%></textarea>
							</td>
						</tr>
						</tbody>
					</table>
					<p class="txt_c">
						<button type="submit" class="btn medium edge darkMblue">
						<%
						if("insert".equals(mode)){
						%>
							등록
						<%}else{ %>
							수정
						<%} %>
						</button>
						<button type="button" class="btn medium edge mako" onclick="window.close();">닫기</button>
					</p>
				</fieldset>
			</form>
		</div>
	</div>
	<!-- // content -->
<%--
<%@ page import ="org.jsoup.Jsoup"%>
<%@ page import ="org.jsoup.nodes.Document"%>
<%@ page import ="org.jsoup.select.Elements"%>
<%@ page import ="org.json.simple.JSONArray"%>
<%@ page import ="org.json.simple.JSONObject"%>
<%@ page import ="org.json.simple.parser.JSONParser"%>

<%!
class BanVO{
	public String year;
	public String month;
	public String day;
	public String name;
}
public List<BanVO> getVO(String year){
	String json 		= "";
	List<BanVO> banList	= new ArrayList<BanVO>();
	BanVO vo			= new BanVO();
	try {
		Document document = Jsoup.connect("https://apis.sktelecom.com/v1/eventday/days?month=&year="+year+"&type=h&day=")
				.userAgent("Mozilla")
				.ignoreContentType(true)
				.header("TDCProjectKey", "61816f66-5e21-42aa-9d76-eed601aa42d5")
				.header("referer", "https://developers.sktelecom.com/projects/project_53742147/services/EventDay/Analytics/")
				.header("Accept", "application/json")
				.get();
		Elements elem = document.select("body");

		for (org.jsoup.nodes.Element e : elem) {
	    	json += e.text();
		}

	    JSONParser parser = new JSONParser();
	    Object obj = parser.parse( json );
	    JSONObject jsonObj = (JSONObject) obj;

	    JSONArray jsonArr = (JSONArray) jsonObj.get("results");

	    for (int i = 0; i < jsonArr.size(); i++) {
			JSONObject data = (JSONObject) jsonArr.get(i);
			vo = new BanVO();
			vo.year 	= data.get("year").toString();
			vo.month 	= data.get("month").toString();
			vo.day 		= data.get("day").toString();
			vo.name 	= data.get("name").toString();
			banList.add(vo);
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	return banList;
}
%>
<%
List<BanVO> banList = getVO("2018");
for(BanVO ob : banList){
	out.println(ob.year + "-" + ob.month + "-" + ob.day + " : " + ob.name + "<br>");
}

%>
 --%>
</div>
</body>
</html>
