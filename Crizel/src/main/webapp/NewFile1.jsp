<%@page import="egovframework.rfc3.board.web.BoardManager"%>
<%@page import="egovframework.rfc3.board.vo.BoardDataVO"%>
<%@page import="egovframework.rfc3.popup.web.PopupManager"%>
<%@page import="egovframework.rfc3.popup.vo.PopupVO"%>
<%@ page import="egovframework.rfc3.common.util.EgovStringUtil"%>
<%@page import="java.util.List"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="egovframework.rfc3.iam.manager.ViewManager" %>
<%@ include file="/program/class/UtilClass.jsp" %>
<%
String data_title = "";

BoardManager mainbm=new BoardManager(request);
//공지사항
List<BoardDataVO> BoardDataVOList1=null;
BoardDataVOList1=mainbm.getBoardDataList("BBS_0000034",6);

Calendar cal = Calendar.getInstance();
cal.add(Calendar.MONTH, 1);							//날짜를 다음달로 설정
int nowDate = cal.get(Calendar.DATE); 				//오늘 날짜를 구한다
int maxDate = cal.getActualMaximum(Calendar.DATE);  // 선택 월의 마지막 날짜를 구한다. (2월인경우 28 또는 29일, 나머지는 30일과 31일)
int setDate = maxDate - nowDate;				
%>

<!-- link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css"/ -->
<!-- link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" -->
<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.3.26/jquery.form-validator.min.js"></script>
<script>
$(function() {
	var maxDate = "+1M+<%=setDate%>D";		//다음달 + (다음달 말일 - 현재일)일 을 하여 다음달 말일까지 선택가능하게 수정

	if($("#adminCheck").val() == "Y"){
		maxDate = null;
	}

	$.datepicker.regional['kr'] = {
		    closeText: '닫기', // 닫기 버튼 텍스트 변경
		    currentText: '오늘', // 오늘 텍스트 변경
		    monthNames: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
		    monthNamesShort: ['1 월','2 월','3 월','4 월','5 월','6 월','7 월','8 월','9 월','10 월','11 월','12 월'], // 개월 텍스트 설정
		    dayNames: ['일요일', '월요일','화요일','수요일','목요일','금요일','토요일'], // 요일 텍스트 설정
		    minDate: 0,
		    maxDate: maxDate,
		    dayNamesShort: ['일', '월','화','수','목','금','토'], // 요일 텍스트 축약 설정
		    dayNamesMin: ['일', '월','화','수','목','금','토'] // 요일 최소 축약 텍스트 설정
		};
	$.datepicker.setDefaults($.datepicker.regional['kr']);

	  $( "#reserve_date" ).datepicker({
	    dateFormat: 'yy-mm-dd'
	  });

	  $("#school_name").keydown(function(key){
		 if(key.keyCode == 13){
			 searchSubmit();
		 }
	  });

});

function searchSubmit(){
	
	var reserve_date = $("#reserve_date").val();
	var pattern = /^\d{4}\-\d{2}\-\d{2}$/; 
	
	if($("#reserve_date").val() != ""){
		if(pattern.test(reserve_date)) {
		    
		}else{
		    alert("날짜 형식을 확인하여주시기 바랍니다.\nex)2018-01-01");
		    return;
		}
	}
	
	  $("#reserve_type").val($("#reserve_typeSel").val());
		 if($("#reserve_type").val() != ""){
			 $("#reserve_type").attr("checked", "checked");
		 }
		  $("#searchForm").attr("action", "/index.gne?menuCd=DOM_000000106003001000");
		  $("#searchForm").submit();
}
</script>
<div class="dv_wrap">
	<div>
	    <section class="main_type">
				<h2 class="blind">학교시설예약관리시스템 메인 컨텐츠</h2>
	        <div class="item col-12">

	            <!--  visual -->
	            <div class="m_visual dv_wrap">
	                <div class="visualArea">
	                    <!--<div class="visualBtn">
	                        <span class="visaulBtn_dot">
	                            <a href="#page_location">
	                                <img src="/img/main/m_off.png" alt="1번째 이미지" />
	                            </a> <a href="#page_location">
	                                <img src="/img/main/m_off.png" alt="2번째 이미지" />
	                            </a>
	                        </span> <span class="visaulBtn_stop">
	                            <a href="#page_location">
	                                <img src="/img/main/m_stop.png" alt="이미지 롤링 멈추기" id="playbtn" />
	                            </a>
	                        </span>
	                    </div>-->
	                    <ul style="left: 0px;" class="mVisual">
	                        <li class="1" style="display: block;">
	                            <a href="#">
	                                <img src="/img/school/img_visual.jpg" alt="학교시설예약 관리시스템" />
	                            </a>
	                        </li>
	                        <li class="2" style="display: none;">
	                            <a href="#">
	                                <img src="/img/school/img_visual.jpg" alt="학교시설예약 관리시스템" />
	                            </a>
	                        </li>
	                    </ul>
	                </div>
	                <div class="visual_ico">
	                    <div class="item mo-col-12 li_col5">
	                        <ul>
	                            <li>
	                                <a href="/index.gne?menuCd=DOM_000000106002001000">
	                                    <img src="/img/school/ico_img01.png" alt="이용안내" />
	                                </a>
	                            </li>
	                            <li>
	                                <a href="/index.gne?menuCd=DOM_000000106002002000">
	                                    <img src="/img/school/ico_img02.png" alt="시설사용료" />
	                                </a>
	                            </li>
	                            <li>
	                                <a href="/index.gne?menuCd=DOM_000000106003001000">
	                                    <img src="/img/school/ico_img03.png" alt="시설검색/예약" />
	                                </a>
	                            </li>
	                        </ul>
	                    </div>
	                </div>
	            </div>
	        </div>

	        <div class="item col-5 mo-col-12 notice">
	            <dl class="single-board">
	                <dt class="ui-item-title">공지사항</dt>
	                <dd>
	                    <ul class="latest_bbs">
	                    <%

		for(BoardDataVO bodataVO : BoardDataVOList1) {
			if(bodataVO.getDataTitle().length() >= 130){
				data_title = bodataVO.getDataTitle().substring(0,130);
			}else{
				data_title = bodataVO.getDataTitle();
			}
	%>
	<li>
		<a href="/board/view.gne?boardId=BBS_0000034&amp;menuCd=DOM_000000106001001000&amp;startPage=1&amp;ataSid=<%=bodataVO.getDataSid()%>">
			<span>[<%=(bodataVO.getRegister_str()).replaceAll("-", ".")%>]</span> <%=data_title%>
		</a>
	</li>
	<%
		}
	%>
                    </ul>
                    <a href="/index.gne?menuCd=DOM_000000106001001000" title="공지사항 더보기" class="btn-more">
                        <img src="/img/school/btn_more.png" alt="공지사항 더보기"/>
                    </a>
                </dd>
            </dl>
	        </div>
	        <div class="item col-3 mo-col-5 search">
	            <div class="search_box">
	                <div class="form">
	                	<form method="post" id="searchForm">
	                    <p class="tit">Search</p>
	                    <span><label for="reserve_date">희망대여날짜</label> </span>
	                    <input name="reserve_date" class="text_form wps_90" id="reserve_date" type="text">
											<br />
	                    <label for="reserve_typeSel" class="blind">시설명</label>
	                    <input type="checkbox" id="reserve_type" name="reserve_type" style="display: none;">
	                    <select name="select_typeSel" id="reserve_typeSel" class="select_form wps_100 magT10" title="시/도 선택">
	                        <option value="">시설명 검색</option>
	                        <option value="강당">강당</option>
	                        <option value="교실">교실</option>
	                        <option value="운동장">운동장</option>
							<option value="기타시설">기타시설</option>
	                    </select>
											<div class="srch_txt">
	                    	<label for="school_name">학교명 검색</label>
	                    	<input name="school_name" class="text_form" id="school_name" type="text">
	                    	<button class="btn edge small darkMblue" type="button" onclick="searchSubmit()">검색</button>
											</div>
	                   </form>
	                </div>
	            </div>
	        </div>
	        <div class="item col-4 mo-col-7 btn_set">
	            <div class="btn_box">
	                <a href="/index.gne?menuCd=DOM_000000106001002000">
	                    <div class="btn01">
	                        <p> 관련법규 및 규칙 </p>
	                        <span> 학교시설과 관련된 관련법규 및 규칙을 안내합니다. </span>
	                    </div>
	                </a>
	                <a href="/index.gne?menuCd=DOM_000000106001003000">
	                    <div class="btn02">
	                        <p> 공개자료실 </p>
	                        <span> 공개 자료실에 학교시설예약 관리 시스템과 관련한 사항들을 확인해보세요. </span>
	                    </div>
	                </a>
	            </div>
	        </div>
	    </section>
	</div>
</div>