<%
/**
*   PURPOSE :   날짜관리 popup page
*   CREATE  :   20180705	KO
*   MODIFY  :   
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
		<title>날짜관리</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
		<style type="text/css">
			input[type="number"] {border:1px solid #bfbfbf; vertical-align:middle; line-height:18px; padding:5px; box-sizing: border-box;}
		</style>
		<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
        <script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
        <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
</head>
<body>

<script>
$.datepicker.regional['kr'] = {
        closeText: '닫기', // 닫기 버튼 텍스트 변경
        currentText: '오늘', // 오늘 텍스트 변경
        monthNames: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
        monthNamesShort: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
        dayNames: ['일요일', '월요일','화요일','수요일','목요일','금요일','토요일'], // 요일 텍스트 설정
        dayNamesShort: ['일','월','화','수','목','금','토'], // 요일 텍스트 축약 설정
        dayNamesMin: ['일','월','화','수','목','금','토'] // 요일 최소 축약 텍스트 설정
    };
$.datepicker.setDefaults($.datepicker.regional['kr']);

$(function(){
	getList();
	$('#ban_date').datepicker({ 
		dateFormat: "yy-mm-dd",
		onClose: function( selectedDate ) {
            $("#ban_date2").datepicker( "option", "minDate", selectedDate );
        }});
	$('#ban_date2').datepicker({ dateFormat: "yy-mm-dd" });
	
	$("#ban_date").change(function(){
		$("#ban_date2").val($(this).val());
	});
	
	$("#allCheck").click(function(){
		if($("#allCheck").is(":checked")){
			$("input:checkbox[name=banno_arr]").prop("checked", "true");
		}else{
			$("input:checkbox[name=banno_arr]").removeAttr("checked");
		}
	});
});

function getList(){
	var html = "";
	var cnt = 0;
	$.ajax({
		type : "POST",
		url : "dateAction.jsp",
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		data : {
			mode : "dateList"
		},
		datatype : "json",
		success : function(data) {
			$.each(JSON.parse(data), function(i, val) {				//ajax로 받아온 json 데이터를 html로 구성한다
				cnt++;
				html += "<tr class='txt_c'>";
				html += "	<td><input type='checkbox' name='banno_arr' value='"+val.banno+"'></td>";
				html += "	<td>" + val.ban_date;
				if(val.ban_date != val.ban_date2){
					html += " ~ " + val.ban_date2;
				}
				html += " (" + val.ban_etc + ")</td>";
				html += ""
				html += "	<td><a class='btn edge small red' href='javascript:dateDel(\""+val.banno+"\")'>삭제</a></td>";
				html += "</tr>";
			});
			
			if(cnt == 0){
				html += "<tr class='txt_c'><td colspan='3'>데이터가 없습니다.</td></tr>";
			}
			
			$("#dateList tbody").html(html);
		},
		error:function(request,status,error){
			alert("처리중 오류가 발생하였습니다");
			//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}

function insertSubmit(){
	var data = $("#insertForm").serialize();
	
	if(confirm("날짜를 추가하시겠습니까?")){
		$.ajax({
			type : "POST",
			url : "dateAction.jsp",
			contentType : "application/x-www-form-urlencoded; charset=utf-8",
			data : data,
			datatype : "html",
			success : function(data) {
				if(data.trim() == "dup"){
					alert("날짜와 시간이 중복되었습니다.");
				}else if(data.trim() == "Y"){
					alert("날짜가 추가되었습니다.");
					getList();
				}else{
					alert("처리중 오류가 발생하였습니다.");
				}
				
				return false;
			},
			error:function(request,status,error){
				//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				alert("처리중 오류가 발생하였습니다.");
			}
		});
		return false;
	}else{
		return false;
	}
}



function dateDel(banno){
	var mode = "dateDelete";
	if(confirm("날짜를 삭제하시겠습니까?")){
		$.ajax({
			type : "POST",
			url : "dateAction.jsp",
			contentType : "application/x-www-form-urlencoded; charset=utf-8",
			data : {mode : mode, banno : banno},
			datatype : "html",
			success : function(data) {
				if(data.trim() == "Y"){
					alert("날짜가 삭제되었습니다.");
					getList();
				}else{
					alert("처리중 오류가 발생하였습니다.");
				}
			},
			error:function(request,status,error){
				//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				alert("처리중 오류가 발생하였습니다.");
			}
		});
	}
}

function allDelete(){
	var mode = "dateDeleteAll";
	var banno_arr = new Array();
	$("input:checkbox[name='banno_arr']:checked").each(function(){
		banno_arr.push($(this).val()); 
	});
	if(confirm("선택한 날짜를 삭제하시겠습니까?")){
		$.ajaxSettings.traditional = true
		$.ajax({
			type : "POST",
			url : "dateAction.jsp",
			contentType : "application/x-www-form-urlencoded; charset=utf-8",
			data : {mode : mode, banno_arr : banno_arr},
			datatype : "html",
			success : function(data) {
				if(data.trim() == "Y"){
					alert("날짜가 삭제되었습니다.");
					getList();
				}else{
					alert("처리중 오류가 발생하였습니다.");
				}
			},
			error:function(request,status,error){
				//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				alert("처리중 오류가 발생하였습니다.");
			}
		});
	}
}
</script>
<div id="right_view">
	<div class="top_view">
      <p class="location"><strong>날짜관리</strong></p>
  </div>
</div>
<!-- S : #content -->
<div id="content">
	<div>
		<form action="dateAction.jsp" method="post" id="insertForm" onsubmit="return insertSubmit()">
			<fieldset>
			<input type="hidden" id="mode" name="mode" value="dateInsert">
				<legend>날짜입력</legend>
				<table class="bbs_list2">
					<colgroup>
						<col style="width:20%">
						<col  />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">날짜입력</th>
							<td>
								<input type="text" id="ban_date" name="ban_date" value="" required readonly> ~
								<input type="text" id="ban_date2" name="ban_date2" value="" required readonly>
								<input type="radio" id="ban_etc_1" name="ban_etc" value="오전" required>
								<label for="ban_etc_1">오전</label>
								<input type="radio" id="ban_etc_2" name="ban_etc" value="오후" required>
								<label for="ban_etc_2">오후</label>
								<button class="btn small edge mako">추가</button>
								<button type="button" class="btn small edge mako f_r" onclick="allDelete();">선택 삭제</button>
							</td>
						</tr>
					</tbody>
				</table>
			</fieldset>
		</form>
		<table class="bbs_list2 td-c" id="dateList">
			<caption>날짜추가 입력폼입니다.</caption>
			<colgroup>
				<col style="width:20%" />
				<col />
				<col style="width:20%" />
			</colgroup>
			<thead>
			<tr>
				<th scope="row"><input type="checkbox" id="allCheck"></th>
				<th scope="row">날짜(시간)</th>
				<th scope="row">삭제</th>
			</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
		<p class="btn_area txt_c">
			<button type="button" class="btn medium edge mako" onclick="window.close();">닫기</button>
		</p>
	</div>
</div>
	<!-- //E : #content -->
</body>
</html>
