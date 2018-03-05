<%
/**
*   PURPOSE :   프로그램 통계 관리
*   CREATE  :   ...
*   MODIFY  :   20180223 LJH 마크업, 클래스 수정
**/
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>

<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 승인대기 및 취소 - 심화</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
<script>
</script>
</head>
<body>

<div id="right_view">
		<div class="top_view">
				<p class="location"><strong>프로그램 운영 > 통계 관리</strong></p>
		</div>
</div>
<!-- S : #content -->
	<div id="content">
		<div class="btn_area">
				<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/alwaysReq.jsp'">승인대기 및 취소 - 상시</button>
				<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/alwaysMng.jsp'">프로그램 관리 - 상시</button>
				<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/deepReq.jsp'">승인대기 및 취소 - 심화</button>
				<button type="button" class="btn medium white" onclick="location.href='/program/art/admin/deepMng.jsp'">프로그램 관리 - 심화</button>
				<button type="button" class="btn medium mako" onclick="location.href='/program/art/admin/programStat.jsp'">통계관리</button>
		</div>
		<div class="searchBox magT20 magB20">
			<!-- 개발작업 진행시 검색폼 옵션 및 항목을 수정하시기 바랍니다.-->
			<form id="searchForm" method="get" class="topbox2">
				<fieldset>
					<input type="text" id="start_date" name="start_date" readonly="" value="" class="hasDatepicker">
					<input type="text" id="end_date" name="end_date" readonly="" value="" class="hasDatepicker">
					<!-- <label for="search1">검색분류</label> -->
					<select id="search1" name="search1">
						<option value="">선택</option>
						<option value="req_id">아이디</option>
						<option value="req_mng_nm">신청자명</option>
					</select>
					<!-- <label for="keyword">검색어</label> -->
					<input type="text" id="keyword" name="keyword" value="">
					<select id="search2" name="search2" onchange="instSelect(this.value)">
						<option value="">프로그램분류</option>
	          <option value=""></option>
	          <option value=""></option>
					</select>
					<select id="search3" name="search3">
						<option value="">프로그램명</option>
					</select>
					<button class="btn small edge mako" onclick="searchSubmit();">검색하기</button>
				</fieldset>
			</form>
		</div>

	</div>
<!-- //E : #content -->
</body>
</html>
