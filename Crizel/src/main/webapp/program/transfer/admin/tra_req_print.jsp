<%
/**
*	PURPOSE	:	전입학 / 전입학 배정원서 인쇄
*	CREATE	:	20180122_mon	JMG
*	MODIFY	:	....
*/

%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>


<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");
SessionManager sessionManager = new SessionManager(request);
%>

<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 전입학 배정원서 목록 > 배정원서 보기 > 인쇄</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
		<link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css" />
		<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
	</head>
	<script>
		$(function(){
			var open = $("div.listArea", opener.document).html();
			$("div.listArea").append(open);
		});    	
	</script>
	<body onload="window.print(); window.close();">
		<div class="listArea">
		
		</div>
	</body>    
</html>