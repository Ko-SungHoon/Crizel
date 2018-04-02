<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@ include file="/program/excel/_class.jsp" %>

<%
/** 접근 가능한 IP 설정 및 체크 **/
String thisIp = request.getRemoteAddr();
String[] allowIp = { "112.163.77.52", "112.163.77.46", "115.91.44.58", "180.80.117.1", "180.80.117.25", 
		/* "10.250.74.197", "10.250.74.187", "10.250.74.188" */"10.250.70.127", "10.250.70.130", "0:0:0:0:0:0:0:1" };

/** Method 및 Referer 정보 **/
String getMethod = parseNull(request.getMethod());
String getReferer = parseNull(request.getHeader("referer"));

/** 회원정보 **/
SessionManager sessionManager = new SessionManager(request);
boolean isAdmin = sessionManager.isRoleAdmin();

if (!isAdmin || getMethod.equals("") || getReferer.equals("") || 
		(getReferer.indexOf("www.gne.go.kr") < 0 && getReferer.indexOf("localhost") < 0 && getReferer.indexOf("127.0.0.1") < 0)) {
	out.println("<script type=\"text/javascript\">");
	out.println("alert('잘못된 접근 방식입니다.\\n해당 페이지를 닫습니다.');");
	out.println("window.opener='nothing';window.open('','_parent','');window.close();");
	out.println("</script>");
} else {
	if (isAllowIp(thisIp, allowIp)) {
		/** DB Process **/
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Map<String, Object>> dataList = null;
		
		String term = "";
		String sdate = "";
		String edate = "";
		String always = "";
		String savename = "";
		String realname = "";
		
		try {
			sqlMapClient.startTransaction();
			conn = sqlMapClient.getCurrentConnection();
			
			StringBuffer sql = new StringBuffer();
			sql.append("SELECT \n");
			sql.append("    TERM, ALWAYSYN, SAVENAME, REALNAME, \n");
			sql.append("    TO_CHAR(TO_DATE(SDATE, 'YYYY-MM-DD HH24:MI'), 'YYYY-MM-DD HH24:MI') AS SDATE, \n");
			sql.append("    TO_CHAR(TO_DATE(EDATE, 'YYYY-MM-DD HH24:MI'), 'YYYY-MM-DD HH24:MI') AS EDATE \n");
			sql.append("FROM TBL_FORMDATA \n");
			sql.append("WHERE GUBUN = 'A' \n");
			
			pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();
			dataList = getResultMapRows(rs);
			
		 	if (dataList != null && dataList.size() > 0) {
		 		Map<String, Object> dataMap = dataList.get(0);
		 		term = dataMap.get("TERM").toString();
		 		sdate = dataMap.get("SDATE").toString();
		 		edate = dataMap.get("EDATE").toString();
		 		always = dataMap.get("ALWAYSYN").toString();
		 		savename = dataMap.get("SAVENAME").toString();
		 		realname = dataMap.get("REALNAME").toString();
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
<title>:: 경상남도 교육청 관리자 모드 :: 검정고시 합격자 정보 업로드 ::</title>
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
		if (form.term.value === "") {
			Alert("Information", "회차를  입력해주세요.", form.term);
			return false;
		} else if (!fn_isInteger(form.term.value)) {
			Alert("Information", "회차는 숫자만 입력가능합니다.", form.term);
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
<form name="dataForm" method="post" enctype="multipart/form-data" action="/program/excel/gosi/action.jsp" onsubmit="javascript:return fn_doSubmitForm(this);">
	<input type="hidden" name="gubun" id="gubun" value="A" />
	
	<h3 class="title-bar">
		<strong style="color: #fff100;">검정고시</strong> 합격자 정보 파일 업로드
	</h3>
	
	<br />
	<table>
		<colgroup>
			<col style="width: 200px;"/>
			<col />
		</colgroup>
		
		<tbody>
			<tr>
				<th>회차</th>
				<td><input type="text" name="term" id="term" maxlength="2" style="width: 100px;" />&nbsp;*&nbsp;숫자만 입력해주세요.</td>
			</tr>
			<tr>
				<th><label for="sdate">조회기간</label></th>
				<td>
					<input type="text" name="sdate" id="sdate" />
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
					<input type="text" name="edate" id="edate" />
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
						<a href="/program/excel/download.jsp?path=gosi&savename=<%=URLEncoder.encode("exam_sample.xls", "UTF-8")%>">sample.xls</a>
					</p>
				</td>
			</tr>
			<tr>
				<th><label for="uploadfile">첨부파일</label></th>
				<td>
					<p style="margin: 5px 0 5px 0;">
						※ 반드시 상기의 xls 샘플파일을 내려 받아서 첨부해주시기 바랍니다.
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
			<col style="width: 7%;" />
			<col style="width: 23%;" />
			<col />
		</colgroup>
		
		<thead>
			<tr>
				<th>회차</th>
				<th>조회기간</th>
				<th>첨부파일</th>
			</tr>
		</thead>
		
		<tbody>
			<tr>
				<td style="text-align: center;"><%=term%>회</td>
				<td style="text-align: center;">
	<%if (always.equals("Y")) {%>
					항상
	<%} else {%>
					<%=sdate%>부터<br /><%=edate%>까지
				</td>
	<%}%>
				<td>
					<a href="/program/excel/download.jsp?path=gosi&savename=<%=URLEncoder.encode(savename, "UTF-8") %>&realname=<%=URLEncoder.encode(realname, "UTF-8") %>"><%=realname%></a>
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
}
%>