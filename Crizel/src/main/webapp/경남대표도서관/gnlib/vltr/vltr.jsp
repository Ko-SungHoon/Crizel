<%@page contentType="text/html;charset=utf-8"%>

<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>

<style type="text/css">
.ui-datepicker {width: 100% !important;}
</style>

<div class="con">
  <div class="box5">
    <div id="datepicker" class="car"></div>
    <div id="divVltrList"></div>

    <% if(EgovUserDetailsHelper.isRole("ROLE_ADMIN")) {%>
    <div align="right">
      <button id="btnVltrAdminWrite" class="btn_type1 btn_type_s color2">등록하기</button>
    </div>
    <% } %>
  </div>

  <div id="divLoadVltrRequestList">
  </div>
</div>


<script language="javascript">
  $(function () {
    loadVltrList(formatDate());
//    loadVltrRequestForm();

    $("#datepicker").datepicker({
      changeMonth: true,
      changeYear: true,
      dateFormat: 'yy-mm-dd',
      showMonthAfterYear: true, // 월, 년순의 셀렉트 박스를 년,월 순으로 바꿔준다.
      dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], // 요일의 한글 형식.
      monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'], // 월의 한글 형식.
      onShow: function() {},
      onSelect: function(dateText, inst) {
        var dateAsString = dateText;
        loadVltrList(dateAsString);
        $("form[name='frmVltrAdmin']").find("input[name='vltrdate']").val(dateAsString);
      }
    });

    $("#btnVltrAdminWrite").click(function(){
      $("#dialogVltrAdminForm").find("input[name='vltrmode']").val("WRITE");
      $("#dialogVltrAdminForm").find("input[name='vltrloc']").val("");
      $("#dialogVltrAdminForm").find("select[name='vltrtime1']").val("09:00");
      $("#dialogVltrAdminForm").find("select[name='vltrtime2']").val("09:00");
      $("#dialogVltrAdminForm").find("select[name='vltrcnt']").val(1);
      $("#dialogVltrAdminForm").dialog("open");
    });
  });

</script>