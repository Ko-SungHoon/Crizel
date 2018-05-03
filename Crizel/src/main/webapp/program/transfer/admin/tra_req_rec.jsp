<%
/**
*	PURPOSE	:	전입학 / 전입학 배정원서 목록 / 이력보기
*	CREATE	:	20180122_mon	JMG
*	MODIFY	:	....
*/

%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>

<%!
	//typeSearchDetail	정리
	//신규코드가 들어가야할 일이 있을 경우 여기다가 추가하면 됨!
	public void searchTypeDetailMap(Map<String, String> map){
		map.put("APPLY", "배정신청서 작성 완료");
		map.put("PAID", "민원요금결재 완료(민원 배정 신청완료)");
		map.put("SCH_RECEIPT", "재적학교 담당자 접수	");
		map.put("SCH_APPROVAL", "재적학교 담당자 승인	");
		map.put("TR_F_RECEIPT", "도교육청 담당자 접수");
		map.put("TR_F_APPROVAL", "도교육청 담당자 승인");
		map.put("TR_L_APPROVAL", "도교육청 최종승인자 승인");
		map.put("MW_CANCEL", "민원인에 의한 취소");
		map.put("SYS_CANCEL", "시스템에 의한 자동 취소");
		map.put("SCH_CANCEL", "재적 학교 담당자에 의한 자동 취소");
		map.put("TR_CANCEL", "도교육청 담당자에 의한 취소");
	}

	public static String strToTime(String time, int type){
		String str = "";
		if(time.length() == 4){
			if(type == 1)	str	=	time.substring(0, 2) + "시 " + time.substring(2, 4) + "분";
		}else if(time.length() == 6){
			if(type == 1)		str	=	time.substring(0, 2) + "시 " + time.substring(2, 4) + "분";
			else if(type == 2)	str	=	time.substring(0, 2) + "시 " + time.substring(2, 4) + "분 " + time.substring(4, 6) + "초";
		}else{
			str = time;
		}
		return str;
	}

	public static String strToDate(String date, String type){
		String str = "";
		if(type.equals("yyyy년MM월dd일")){
			if(date.length() == 8){
				str	=	date.substring(0, 4) + "년 " + date.substring(4, 6) + "월 " + date.substring(6, 8) + "일" ;
			}
		}else if(type.equals("yyyy/MM/dd")){
			if(date.length() == 8){
				str	=	date.substring(0, 4) + "/" + date.substring(4, 6) + "/" + date.substring(6, 8);
			}
		}
		return str;
	}
%>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");
SessionManager sessionManager = new SessionManager(request);

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

String sql_str		=	"";
String outHtml  	=   "";
String sql_where 	=	"";

//파라미터
String transferNo	=	parseNull(request.getParameter("transferNo"));

String rNum			=	"";
String stateCd		=	"";
String state		=	"";
String name			=	"";
String regDate		=	"";
String regTime		=	"";
String regIp		=	"";
String reason		=	"";

boolean adminChk	=	sessionManager.isRoleAdmin();

/* if(!adminChk){
 */	%>
	<!-- <script>alert('관리자권한이 없습니다. \n다시 로그인해주세요.'); location.href='/iam/main/index.sko';</script> -->
<%/* } */

List<Map<String, Object>> recordList	= 	null;
Map<String, String> typeDetailMap	=	new HashMap<String, String>();

searchTypeDetailMap(typeDetailMap);

if(!"".equals(transferNo)){
	try {
	    sqlMapClient.startTransaction();
	    conn    =   sqlMapClient.getCurrentConnection();

	    sql     	=   new StringBuffer();

	    sql_str		=	" SELECT ROWNUM, TRANSFERNO, STATECD, REGDATE, REGTIME, REGIP, USERNO, NAME, ORDERED, REASON";
	    sql_str		+=	" FROM TTRANS_STATE WHERE TRANSFERNO = ? ORDER BY ORDERED DESC ";
	    sql.append(sql_str);
	    pstmt		=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, transferNo);

	    rs				=	pstmt.executeQuery();
	    recordList		=	getResultMapRows(rs);

	} catch (Exception e) {
	    e.printStackTrace();
	    alertBack(out, "처리중 오류가 발생하였습니다."+e.getMessage());
	} finally {
	    if (rs != null) try { rs.close(); } catch (SQLException se) {}
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	    if (conn != null) try { conn.close(); } catch (SQLException se) {}
	    sqlMapClient.endTransaction();
	}
}else{
	out.println("<script>");
    out.println("alert('파라미터 값 이상입니다. 관리자에게 문의하세요.');");
    out.println("window.close();");
    out.println("</script>");
}
%>


<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 전입학 배정원서 목록 > 상태 이력 목록</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
		<link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css" />
		<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
	</head>

    <body>
		<div id="right_view">
			<div class="top_view">
				<p class="location"><strong>상태 이력 목록</strong></p>
			</div>
            <div id="content">
                <div class="listArea">
                    <table class="bbs_list">
                    	<caption>번호, 상태, 등록자, 등록일자, 등록시간, 등록자 Ip, 취소/반려 이유 등 이력 목록입니다.</caption>
                        <colgroup>
	                        <col style="width:7%;">
	                        <col style="width:15%;">
	                        <col style="width:13%;">
	                        <col style="width:15%;">
	                        <col style="width:10%;">
	                        <col >
	                        <col>
                        </colgroup>
                        <thead>
	                        <tr>
		                        <th scope="col">번호</th>
		                        <th scope="col">상태</th>
		                        <th scope="col">등록자</th>
		                        <th scope="col">등록일자</th>
		                        <th scope="col">등록시간</th>
		                        <th scope="col">등록자IP</th>
		                        <th scope="col">취소/반려 이유</th>
                     	   </tr>
                        </thead>
                        <tbody>
                       		<%if(recordList != null && recordList.size() > 0){
                       			for(int i=0; i<recordList.size(); i++){
                       				Map<String, Object> map = recordList.get(i);
                       				rNum		=	(String)map.get("ROWNUM");
                       				stateCd		=	(String)map.get("STATECD");
                       				regDate		=	(String)map.get("REGDATE");
                       				regTime		=	(String)map.get("REGTIME");
                       				regIp		=	(String)map.get("REGIP");
                       				name		=	(String)map.get("NAME");
                       				reason		=	(String)map.get("REASON");

                       				if(typeDetailMap.containsKey(parseNull(stateCd))){
                       					state	=	typeDetailMap.get(stateCd);
                       				}
                       			%>
                       			<tr>
                       				<td><%=rNum%></td>
                       				<td><%=state%></td>
                       				<td><%=name%></td>
                       				<td><%=strToDate(regDate, "yyyy년MM월dd일")%></td>
                       				<td><%=strToTime(regTime, 1)%></td>
                       				<td><%=regIp%></td>
                       				<td><%=parseNull(reason)%></td>
                       			</tr>
                       			<%}
                       		}%>
                        </tbody>
                    </table>
										<div class="btn_area txt_c">
											<input type="button" class="btn mako small edge" value="닫기" onclick="javascript:window.close();">       	
										</div>
                </div>
            </div>
        </div>
    </body>
</html>
