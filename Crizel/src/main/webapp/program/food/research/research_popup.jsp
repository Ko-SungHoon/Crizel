<%
/**
*   PURPOSE :   조사개시/수정 팝업
*   CREATE  :   20180326_mon    JI
*   MODIFY  :   ....
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");


String mode         =   parseNull(request.getParameter("mode"), "new");
StringBuffer sql    =   null;
String sql_str      =   "";

List<FoodVO> researchItem   =   null;   //수정 정보

String pageTitle    =   "조사개시";
if (mode != null && "mod".equals(mode)) {
    pageTitle       =   "조사개시 수정";
}

try {
    if (mode != null && "mod".equals(mode)) {
        sql     =   new StringBuffer();
        sql_str =   " SELECT * ";
        sql_str +=  " FROM FOOD_RSCH_TB A JOIN FOOD_UP_FILE B ";
        sql_str +=  " ON A.FILE_NO = B.FILE_NO ";
        sql.append(sql_str);
        researchItem    =   jdbcTemplate.query(sql.toString(), new FoodList());
        
    }
    
} catch(Exception e) {
	out.println(e.toString());
}

%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title><%=pageTitle%></title>
<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
<script type='text/javascript' src='/js/jquery.js'></script>
<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />

<style type="text/css">
    input[type="number"] {border:1px solid #bfbfbf; vertical-align:middle; line-height:18px; padding:5px; box-sizing: border-box;}
</style>

<!-- link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css"/ -->
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
<script>
    $(function() {
        //오늘 날짜 가져오기
        var today   =   new Date();
        var dd      =   today.getDate();
        var mm      =   today.getMonth() + 1;
        var yyyy    =   today.getFullYear();
        if (dd < 10) {
            dd      =   '0' + dd;
        }
        if (mm < 10) {
            mm      =   '0' + mm;
        }

        today       =   yyyy + mm + dd;

        $.datepicker.regional['ko'] = { // Default regional settings
            closeText: '닫기',
            prevText: '이전달',
            nextText: '다음달',
            currentText: '오늘',
            monthNames: ['1월(JAN)','2월(FEB)','3월(MAR)','4월(APR)','5월(MAY)','6월(JUN)',
            '7월(JUL)','8월(AUG)','9월(SEP)','10월(OCT)','11월(NOV)','12월(DEC)'],
            monthNamesShort: ['1월','2월','3월','4월','5월','6월',
            '7월','8월','9월','10월','11월','12월'],
            dayNames: ['일','월','화','수','목','금','토'],
            dayNamesShort: ['일','월','화','수','목','금','토'],
            dayNamesMin: ['일','월','화','수','목','금','토']
        };

        $.datepicker.setDefaults($.datepicker.regional['ko']);

        $( "#str_date" ).datepicker({
            dateFormat: 'yymmdd',  //데이터 포멧형식
            changeMonth: true,    //달별로 선택 할 수 있다.
            changeYear: true,     //년별로 선택 할 수 있다.
            showOtherMonths: false,  //이번달 달력안에 상/하 빈칸이 있을경우 전달/다음달 일로 채워준다.
            selectOtherMonths: true,
            showButtonPanel: true,  //오늘 날짜로 돌아가는 버튼 및 닫기 버튼을 생성한다.
            minDate: 0,
            onClose: function( selectedDate ) {
                $("#mid_date").datepicker( "option", "minDate", selectedDate );
                $("#end_date").datepicker( "option", "minDate", selectedDate );
            }
        });
        $( "#mid_date" ).datepicker({
             dateFormat: 'yymmdd',  //데이터 포멧형식
             changeMonth: true,    //달별로 선택 할 수 있다.
             changeYear: true,     //년별로 선택 할 수 있다.
             showOtherMonths: false,  //이번달 달력안에 상/하 빈칸이 있을경우 전달/다음달 일로 채워준다.
             selectOtherMonths: true,
             showButtonPanel: true,  //오늘 날짜로 돌아가는 버튼 및 닫기 버튼을 생성한다.
             onClose: function( selectedDate ) {
                $("#str_date").datepicker( "option", "maxDate", selectedDate );
                $("#end_date").datepicker( "option", "minDate", selectedDate );
            }
        });
        $( "#end_date" ).datepicker({
             dateFormat: 'yymmdd',  //데이터 포멧형식
             changeMonth: true,    //달별로 선택 할 수 있다.
             changeYear: true,     //년별로 선택 할 수 있다.
             showOtherMonths: false,  //이번달 달력안에 상/하 빈칸이 있을경우 전달/다음달 일로 채워준다.
             selectOtherMonths: true,
             showButtonPanel: true,  //오늘 날짜로 돌아가는 버튼 및 닫기 버튼을 생성한다.
             onClose: function( selectedDate ) {
                $("#str_date").datepicker( "option", "maxDate", selectedDate );
                $("#mid_date").datepicker( "option", "maxDate", selectedDate );
            }
        });
    });
    
    //form submit
    function researchForm () {
    
        return false;
    
    }
</script>
</head>
<body>

<div id="right_view">
	<div class="top_view">
      <p class="location"><strong><%=pageTitle%></strong></p>
  </div>
</div>
          
<!-- S : #content -->
<div id="content">
	<div>
		<form id="researchForm" onsubmit="return researchForm();">
            <fieldset>
                <input type="hidden" id="mode" name="mode" value="<%=mode%>">
                <input type="hidden" id="rsch_year" name="rsch_year" value="">
                <input type="hidden" id="rsch_month" name="rsch_month" value="">
                <legend><%=pageTitle%> 테이블</legend>
                <table class="bbs_list2">
                    <colgroup>
                        <col style="width:20%">
                        <col style="width:20%">
                        <col style="width:20%">
                        <col>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">조사개시일</th>
                            <td><input type="text" class="str_date" id="str_date" name="str_date" placeholder="조사 개시일" required readonly></td>
                            <td><input type="text" class="mid_date" id="mid_date" name="mid_date" placeholder="중간 컴토일" required readonly></td>
                            <td><input type="text" class="end_date" id="end_date" name="end_date" placeholder="조사 종료일" required readonly></td>
                        </tr>
                        <tr>
                            <th scope="row">조사 명</th>
                            <td colspan="3"><input type="text" class="rsch_nm wps_75" id="rsch_nm" name="rsch_nm"></td>
                        </tr>
                        <tr>
                            <th scope="row">
                                조사 파일 등록
                                <input type="hidden" id="file_no" name="file_no" value="">
                            </th>
                            <td colspan="3"><input type="file" class="file_nm wps_75" id="file_nm" name="file_nm"></td>
                        </tr>
                    </tbody>
                </table>
                <p class="btn_area txt_c">
                    <button type="submit" class="btn medium edge darkMblue">
                    <%
                    if(mode!=null && "mod".equals(mode)){
                        out.println("조사내용 수정");
                    } else {
                        out.println("조사 개시하기");
                    }
                    %>
                    </button>
					<button type="button" class="btn medium edge mako" onclick="window.close();">닫기</button>
                </p>
            </fieldset>
        </form>
    </div>
</div>

</body>
</html>

