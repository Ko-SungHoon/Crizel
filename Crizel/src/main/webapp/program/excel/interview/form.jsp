<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@ include file="/program/excel/_class.jsp" %>
<%!
public static void alertParentUrl(JspWriter out, String message, String url) {
	try {
		out.println("<script type=\"text/javascript\">");
		if(message != null && !"".equals(message)) out.println("alert('"+message+"');");
		if(url != null && !"".equals(url)) {
			out.println("if(parent.opener != undefined) {parent.opener.location.href='"+url+"';} \n");
			out.println("else if(parent != undefined) {parent.location.href='"+url+"';} \n");
			out.println("else {window.opener.location.href='"+url+"';} \n");
		}
		out.println("</script>");
	} catch(Exception e) {
	}
}
public String getRoleId(SqlMapClient sqlMapClient, Connection conn, String id)
{
	String roleId = null;
	if(id == null || "".equals(id)) return roleId;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try{
		StringBuffer query = new StringBuffer();
		query.append("SELECT ROLE_ID FROM RFC_COMTNAUTHORITES WHERE SUBJECT_ID = ?");
		pstmt = conn.prepareStatement(query.toString());
		pstmt.setString(1, id);
		rs = pstmt.executeQuery();
		if(rs.next()) roleId = rs.getString("ROLE_ID");
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if (rs != null) try { rs.close(); } catch (SQLException se) {}
		if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	}
	return roleId;
}
public String[] getAllowIpArrays(SqlMapClient sqlMapClient, Connection conn)
{
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	StringBuffer result = new StringBuffer();
	try{
		StringBuffer query = new StringBuffer();
		query.append("SELECT ACCESS_IP FROM RFC_COMTNACCESSIP WHERE ATYPE = 'admin' ");
		pstmt = conn.prepareStatement(query.toString());
		rs = pstmt.executeQuery();
		while(rs.next()) {
			if(result.length() > 1) result.append("|");
			result.append(rs.getString("ACCESS_IP"));
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		if (rs != null) try { rs.close(); } catch (SQLException se) {}
		if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	}
	return (result.toString()).split("\\|");
}
public static void alertBack(JspWriter out, String message) {
	try {
		out.println("<script type=\"text/javascript\">");
		if(message != null && !"".equals(message)) out.println("alert('"+message+"');");
		out.println("history.go(-1);");
		out.println("</script>");
	} catch(Exception e) {
	}
}
%>
<%
/************************** 접근 허용 체크 - 시작 **************************/
String adminLoginUrl = "/iam/login/login.sko";
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

/** 접근 가능한 IP 설정 및 체크 **/
thisIp = request.getRemoteAddr();
String[] allowIp2 = { "112.163.77.52","112.163.77.46","115.91.44.58", "180.80.117.1", "180.80.117.25", 
		/* "10.250.74.197", "10.250.74.187", "10.250.74.188" */"10.250.70.127", "10.250.70.130", "10.250.70.129", "0:0:0:0:0:0:0:1" };

/** Method 및 Referer 정보 **/
getMethod = parseNull(request.getMethod());
getReferer = parseNull(request.getHeader("referer"));

/** 회원정보 **/
//SessionManager sessionManager = new SessionManager(request);
isAdmin = sessionManager.isRoleAdmin();

/* if (!isAdmin || getMethod.equals("") || getReferer.equals("") || 
		(getReferer.indexOf("www.gne.go.kr") < 0 && getReferer.indexOf("localhost") < 0 && getReferer.indexOf("127.0.0.1") < 0)) {
	out.println("<script type=\"text/javascript\">");
	out.println("alert('잘못된 접근 방식입니다.\\n해당 페이지를 닫습니다.');");
	out.println("window.opener='nothing';window.open('','_parent','');window.close();");
	out.println("</script>");
} else { */
	if (isAllowIp(thisIp, allowIp2)) {
		/** DB Process **/
		//Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Map<String, Object>> dataList = null;
		
		String sdate = "";
		String edate = "";
		String always = "";
		String savename = "";
		String realname = "";
		String inputfield = "";
		
		try {
			sqlMapClient.startTransaction();
			conn = sqlMapClient.getCurrentConnection();
			
			StringBuffer sql = new StringBuffer();
			sql.append("SELECT \n");
			sql.append("    ALWAYSYN, SAVENAME, REALNAME, INPUTFIELD, \n");
			sql.append("    TO_CHAR(TO_DATE(SDATE, 'YYYY-MM-DD HH24:MI'), 'YYYY-MM-DD HH24:MI') AS SDATE, \n");
			sql.append("    TO_CHAR(TO_DATE(EDATE, 'YYYY-MM-DD HH24:MI'), 'YYYY-MM-DD HH24:MI') AS EDATE \n");
			sql.append("FROM TBL_FORMDATA \n");
			sql.append("WHERE GUBUN = 'E' \n");
			
			pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();
			dataList = getResultMapRows(rs);
			
		 	if (dataList != null && dataList.size() > 0) {
		 		Map<String, Object> dataMap = dataList.get(0);
		 		sdate = dataMap.get("SDATE").toString();
		 		edate = dataMap.get("EDATE").toString();
		 		always = dataMap.get("ALWAYSYN").toString();
		 		savename = dataMap.get("SAVENAME").toString();
		 		realname = dataMap.get("REALNAME").toString();
		 		inputfield = dataMap.get("INPUTFIELD").toString();
			}
		} catch (Exception e) {
			sqlMapClient.endTransaction();
			out.println("<script type=\"text/javascript\">");
			out.println("alert('Exception Error : 처리중 오류가 발생하였습니다.');");
			out.println("history.go(-1);");
			out.println("</script>");
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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>:: 경상남도 교육청 관리자 모드 :: 기타 정보 업로드 ::</title>
<link type="text/css" rel="stylesheet" href="/program/excel/common/css/common.css"/>
<link type="text/css" rel="stylesheet" href="/program/excel/common/css/home.css"/>
<link type="text/css" rel="stylesheet" href="/program/excel/common/css/board.css"/>
<link type="text/css" rel="stylesheet" href="/program/excel/common/css/spring.css"/>
<link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css"/>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
<script type="text/javaScript">
//<![CDATA[
$(document).ready(function() {
	/** 폼 체크  **/
	window.fn_doSubmitForm = function(form) {
		if (form.inputfield.value === "") {
			Alert("Information", "입력항목을 입력해주세요.", form.inputfield);
			return false;
		} else if (form.inputfield.value != "" && (form.inputfield.value.split(",").length > 2 || form.inputfield.value.split(",").length < 2)) {
			Alert("Information", "입력항목의 형식이 유효하지 않습니다. <br/>공백 없이 구분 값 쉼표를 이용하여 두 항목을 입력해주세요.", form.inputfield);
			return false;
		}
		if (!$("#always").is(":checked")) {
			if (form.sdate.value === "") {
				Alert("Information", "조회기간 시작일을 입력해주세요.", form.sdate);
				return false;
			} else if (form.edate.value === "") {
				Alert("Information", "조회기간 종료일을 입력해주세요.", form.edate);
				return false;
			} else if (form.sdate.value != "" && form.edate.value != "") {
				var sdate = form.sdate.value.replace(/\-/g, '') + getSelected("shour") + getSelected("smin");
				var edate = form.edate.value.replace(/\-/g, '') + getSelected("ehour") + getSelected("emin");
				if (parseInt(sdate, 10) > parseInt(edate, 10)) {
					Alert("Information", "조회기간 설정이 잘못되었습니다.<br/>시작일자는 종료일자를 초과할 수 없습니다.", form.sdate);
					return false;
				}
			}
		}
		if (form.uploadfile.value === "") {
			Alert("Information", "파일을 첨부해주세요.", form.uploadfile);
			return false;
		} else if (!fn_doAvaliableExt("uploadfile")) {
			Alert("Warning", "첨부파일은 Excel 97-2003 통합 문서 파일(xls)만 등록가능합니다.", form.uploadfile);
			return false;
		}
	};
});

$.datepicker.regional['kr'] = {
	    closeText: '닫기', // 닫기 버튼 텍스트 변경
	    currentText: '오늘', // 오늘 텍스트 변경
	    monthNames: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
	    monthNamesShort: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
	    dayNames: ['월요일','화요일','수요일','목요일','금요일','토요일','일요일'], // 요일 텍스트 설정
	    dayNamesShort: ['월','화','수','목','금','토','일'], // 요일 텍스트 축약 설정    dayNamesMin: ['월','화','수','목','금','토','일'], // 요일 최소 축약 텍스트 설정
	};
	$.datepicker.setDefaults($.datepicker.regional['kr']);


$(function() {
	  $( "#sdate" ).datepicker({
	    dateFormat: 'yymmdd'
	  });
	});
	
$(function() {
	  $( "#edate" ).datepicker({
	    dateFormat: 'yymmdd'
	  });
	});
//]]>
</script>
</head>
<body>
<div id="wrap">
	<section id="site_content" class="ui-sub-body">
		<article class="ui-board ui-write">
<form name="dataForm" method="post" enctype="multipart/form-data" action="/program/excel/interview/action.jsp" onsubmit="javascript:return fn_doSubmitForm(this);">
	<input type="hidden" name="gubun" id="gubun" value="E" />
	
	<h3 class="title-bar">
		<strong style="color: #fff100;">기타</strong> 정보 파일 업로드
	</h3>
	
	<br />
	<table>
		<colgroup>
			<col style="width: 200px;"/>
			<col />
		</colgroup>
		
		<tbody>
			<tr>
				<th><label for="inputfield">입력항목</label></th>
				<td>
					<input type="text" name="inputfield" id="inputfield" class="w_f_200 ime_active" />&nbsp;예)&nbsp;이름,생년월일
					<p style="margin: 5px 0 5px 0;">
						※ 조회시 입력할 항목을 공백 없이 입력 해주세요. 구분 값은 쉼표(,) 입니다.
					</p>
				</td>
			</tr>
			<tr>
				<th><label for="sdate">조회기간</label></th>
				<td>
					<input type="text" name="sdate" id="sdate"/>
					<select name="shour" id="shour">
<%for (int shour = 0; shour < 24; shour++) {%>
						<option value="<%=shour < 10 ? ("0" + String.valueOf(shour)) : String.valueOf(shour)%>"><%=shour < 10 ? ("0" + String.valueOf(shour)) : String.valueOf(shour)%>시</option>
<%}%>
					</select>
					<select name="smin" id="smin">
<%for (int smin = 0; smin < 59; smin += 5) {%>
						<option value="<%=smin < 10 ? ("0" + String.valueOf(smin)) : String.valueOf(smin)%>"><%=smin < 10 ? ("0" + String.valueOf(smin)) : String.valueOf(smin)%>분</option>
<%}%>
						<option value="59">59분</option>
					</select>부터&nbsp;
					<input type="text" name="edate" id="edate"/>
					<select name="ehour" id="ehour">
<%for (int ehour = 0; ehour < 24; ehour++) {%>
						<option value="<%=ehour < 10 ? ("0" + String.valueOf(ehour)) : String.valueOf(ehour)%>"><%=ehour < 10 ? ("0" + String.valueOf(ehour)) : String.valueOf(ehour)%>시</option>
<%}%>
					</select>
					<select name="emin" id="emin">
<%for (int emin = 0; emin < 59; emin += 5) {%>
						<option value="<%=emin < 10 ? ("0" + String.valueOf(emin)) : String.valueOf(emin)%>"><%=emin < 10 ? ("0" + String.valueOf(emin)) : String.valueOf(emin)%>분</option>
<%}%>
						<option value="59">59분</option>
					</select>까지
					<input type="checkbox" name="always" id="always" value="Y" onclick="javascript:fn_isAlways();" /><label for="always">항상</label>
				</td>
			</tr>
			<tr>
				<th>샘플파일</th>
				<td>
					<p style="margin: 5px 0 5px 0;">
						<a href="/program/excel/download.jsp?path=interview&savename=<%=URLEncoder.encode("sample.xls", "UTF-8")%>">sample.xls</a>
					</p>
				</td>
			</tr>
			<tr>
				<th><label for="uploadfile">첨부파일</label></th>
				<td>
					<p style="margin: 5px 0 5px 0;">
						※ 반드시 상기의 xls 샘플파일을 내려 받아 내용 부분을 입력하여 첨부해주시기 바랍니다.
					</p>
					<input type="file" name="uploadfile" id="uploadfile" style="width: 450px;" />
				</td>
			</tr>
		</tbody>
	</table>
	
	<br />
	
	<div class="buttonBox" style="text-align: center;">
		<input type="submit" value="확인" />
	</div>
	
<%if (dataList != null && dataList.size() > 0) {%>
	<br />
	<h4>&bull;&nbsp;최근정보</h4>
	<table>
		<colgroup>
			<col style="width: 15%;" />
			<col style="width: 23%;" />
			<col />
		</colgroup>
		
		<thead>
			<tr>
				<th>입력항목</th>
				<th>조회기간</th>
				<th>첨부파일</th>
			</tr>
		</thead>
		
		<tbody>
			<tr>
				<td><%=inputfield%></td>
				<td style="text-align: center;">
	<%if (always.equals("Y")) {%>
					항상
	<%} else {%>
					<%=sdate%>부터<br /><%=edate%>까지
				</td>
	<%}%>
				<td>
					<a href="/program/excel/download.jsp?path=interview&savename=<%=URLEncoder.encode(savename, "UTF-8") %>&realname=<%=URLEncoder.encode(realname, "UTF-8") %>"><%=realname%></a>
				</td>
			</tr>
		</tbody>
	</table>
<%}%>
</form>
		</article>
	</section>
</div>
</body>
</html>
<%
	} else {
		out.println("<script type=\"text/javascript\">");
		out.println("alert('해당IP("+thisIp+")는 접근권한이 없습니다.');");
		out.println("history.go(-1);");
		out.println("</script>");
	}
/* } */
%>