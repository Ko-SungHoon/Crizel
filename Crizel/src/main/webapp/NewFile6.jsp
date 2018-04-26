<%@page import="com.ibm.icu.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String mid = request.getParameter("mid") == null
			? "000000000000"
			: request.getParameter("mid");
	mid = mid.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
	request.setAttribute("mid", mid);
	String sid = mid.length() > 2 ? mid.substring(0, 2) : "";
	
	
	Calendar cal = Calendar.getInstance();		//현재날짜
	Calendar endCal = Calendar.getInstance();	//목표날짜
	int year = cal.get(cal.YEAR);
	int month = cal.get(cal.MONTH)+1;
	int date = cal.get(cal.DATE);
	cal.set(year, month, date);
	
%><%@ include file="/include/config.jsp"%><%@ include
	file="/include/util.jsp"%>
<%
	String skin_link = "/upload/skin/board/basic.css";
	String js_link = "/ease_src/js/board.js";
%>
<%
	if (mid.length() == 12) {
%>
<jsp:include page="/include/header.jsp">
	<jsp:param name="CSS" value="<%=skin_link%>" />
	<jsp:param name="JS" value="<%=js_link%>" />
	<jsp:param name="p_title" value="목록" />
</jsp:include>
<jsp:include page="/include/header_sub.jsp" />
<%
	} else {
%>
<link href="/css/basic.css" rel="stylesheet" type="text/css" />
<link href="<%=skin_link%>" rel="stylesheet" type="text/css" />
<%
	}
%>

<%
	String chkSid = "";
	if (mid.length() == 12) {
		chkSid = mid.substring(0, 2);
	}
	String hopeLoginId = "";
	if (session.getAttribute("loginId") != null) {
		hopeLoginId = (String) session.getAttribute("loginId");
	}
	hopeLoginId = hopeLoginId.replaceAll("<", "&lt;").replaceAll(">",
			"&gt;");
	if ("".equals(hopeLoginId)) {
%>
<script>alert('로그인 후 사용가능한 메뉴입니다.');location.href='/login_search.es?sid=<%=chkSid%>';
</script>
<%
	}
	String referer = request.getHeader("referer");
	//if(session.getAttribute("loginIsLoca") != null && !"Y".equals((String)session.getAttribute("loginIsLoca")) && !hopeLoginId.equals("seogr") ) {
	if (!hopeLoginId.equals("esmaster")) {
		if (session.getAttribute("loginIsLoca") != null
				&& !"Y".equals((String) session
						.getAttribute("loginIsLoca"))) {
			if (referer == null || "".equals(referer))
				referer = "/";
%>
<!-- script>alert('가입하신 도서관에서만 이용하실 수 있는 기능입니다.');location.href='<%=referer%>';</script -->
<%
	}
	} else {
%>
<script>
	alert('최고관리자입니다. 페이지확인용이니 신청하지 마세요.');
</script>
<%
	}
%>

<%--
if(session.getAttribute("loginIsLoca") != null && !"Y".equals((String)session.getAttribute("loginIsLoca"))) {
	//String loginSidUrl = (request.getHeader("REFERER") != null && !"".equals(request.getHeader("REFERER").toString())) ? request.getHeader("REFERER").toString() : "/";
	String loginSidUrl = "/";
%>
<script>alert('가입하신 도서관에서만 이용하실 수 있는 기능입니다.');location.href='<%=loginSidUrl%>';</script>
<%
}
--%>

<form name="insForm" method="post">
	<input type="hidden" name="mid" value="${es:SearchXSS(param.mid)}" />
	<input type="hidden" name="searchYn" id="searchYn" value="" />

	<%--
<c:if test="${mid eq 'a30303000000' or mid eq 'c30203000000'}">
--%>
	<!-- 창원도서관 -->
	<c:if test="${fn:indexOf(mid,'a2') > -1}">
		<h4 class="title">이용안내</h4>
		<ol class="h_li" style="margin-bottom: 20px">
			<li><strong class="col_blue">희망도서는 월 1인 3종 이내로 신청
					가능합니다.</strong></li>
			<li><strong class="col_blue">다음 도서는 구입대상에서 제외되니, 이점
					양지하시어 신청 바랍니다.</strong>
				<ul>
					<li>신간도서 주문 중이거나 정리중인 도서</li>
					<li>참고서 및 수험서, 판타지 및 무협지, 로맨스 소설, 만화, 해외주문도서</li>
					<li>비도서, 정기간행물</li>
					<li>출간년도(3년)가 오래된 도서</li>
					<li>고가의 전문도서(정기 구입시 반영)</li>
				</ul></li>
			<li><strong class="col_blue">위에 사항들에 해당하는 경우 희망도서신청
					취소사유가 됩니다.</strong></li>
		</ol>
	</c:if>
	<!--//창원도서관 -->


	<!-- 거제도서관 -->

	<c:if test="${fn:indexOf(mid,'c7') > -1}">

		<div class="Box mb40">

			<h4 class="title">이용안내</h4>

			<ul class="h_li">
				<li>희망도서는 월 1인 3종 이내로 신청 가능합니다.</li>
				<li>다음 도서는 구입 대상에서 제외되니, 이점 양지하시어 신청 바랍니다.
					<ul>
						<li>신간도서 주문 중이거나 정리중인 도서</li>
						<li>참고서 및 수험서, 개인 학습용 문제집 등</li>
						<li>개인적 신념에 의한 종교자료</li>
						<li>출간된 지 3년이 지난 자료(소장이 필요한 경우는 예외)</li>
						<li>내용이 선정적이거나 폭력성이 짙은 도서</li>
						<li>비회원이 신청한 도서 또는 상업적 판매를 위해 신청한 도서</li>
						<li>오락성 만화물 및 전집류, 판타지 및 무협지, 로맨스 소설류 등</li>
						<li>비도서, 정기간행물, 해외주문도서</li>
						<li>비슷한 주제의 도서를 중복 신청하는 경우</li>
						<li>고가의 전문도서(정기 구입시 반영)</li>
					</ul>
				</li>
			</ul>
		</div>
	</c:if>

	<!--//거제도서관 -->


	<!-- 김해도서관 -->
	<c:if test="${fn:indexOf(mid,'a3') > -1}">
		<div style="border: 1px solid #dedede; padding: 0px 8px 30px 8px;">
		<% 
			endCal.set(2018, 1, 1);
			if(cal.before(endCal)){
		%>
			<h4 class="title">공지사항</h4>
			<ul class="h_li" style="margin-bottom: 20px">
				<li>2017년 12월 15일(금)까지 희망도서 신청가능, 15일 이후 신청한 희망자료는 2018년 1월 이후에 처리함.</li>
			</ul>
			
			<%} %>
			<h4 class="title">이용안내</h4>
			<ul class="h_li" style="margin-bottom: 20px">
				<li>희망도서 신청 책수 : 1인당 <span style="color:red">월 4권</span>까지 신청 가능.</li>
				<li>신청방법 : 홈페이지를 통한 인터넷신청, 도서관 내 자료검색PC 이용 신청</li>
				<li><strong style="color:red">선정 제외도서 기준</strong>
					<ul>
						<li>우리도서관 소장도서나 구입, 정리중인 도서</li>
						<li>서양서(해외주문도서), 전자자료(E-Book, DVD등 비도서), 5만원 이상 고가도서
						<br/>(단, 정기구입시 검토 후 구입여부 결정)</li>
						<li>품절 및 절판도서</li>
						<li>개인학습을 위한 자격증학습서, 수험서 등 문제위주의 도서 및 교과서</li>
						<li>최신성이 떨어지는 자료(출판된지 5년이 지난 도서)</li>
						<li>절판 및 품절 도서</li>
						<li>무협지, 판타지소설, 인터넷 로맨스, 잡지, 만화(학습만화 제외), 전집류 등 <br/>기타  공공도서관의 목적과 기능에 어긋나는 도서 등</li>
					</ul></li>
				<li><strong>위에 사항들에 해당하는 경우 희망도서신청 취소사유가 됩니다.</strong></li>
			</ul>
			<h4 class="title">처리기간</h4>
			<ul class="h_li" >
				<li>도서구입은 월 3회이며 소요기간은 신청일로부터 3주 내외로 자료특성에 따라 초과 될 수 있음.</li>
			</ul>

			<h4 class="title">처리 진행 확인</h4>
			<ul class="h_li" >
				<li>자료검색 -> 대출조회/연기/예약도서 -> 대출내역 -> 희망도서 신청내역에서 확인가능</li>
			</ul>

			<h4 class="title">희망도서 제공</h4>
			<ul class="h_li" >
				<li>자료실에 희망도서 비치와 동시에 SMS 발송(<span class="col_blue">SMS
						발송 후 3일 이내에 대출</span>하여야 하고 그 기간 초과시는 신간서가 비치됨)
				</li>
			</ul>
			<div style="float: right;">
				<span style="font-size: 1.2em; color: blue;">문의 : 김해도서관
					수서정리담당 320-5561~2, 5566</span>
			</div>

		</div>
		<br />
		<br />
	</c:if>
	<!--//김해도서관 -->


	<!--마산도서관 -->
	<c:if test="${fn:indexOf(mid,'a4') > -1}">
	
	<%
		endCal.set(2018, 1, 5);		//목표 날짜 (2018년 1월 4일 23:59분 까지)
		if(cal.before(endCal)){ 		//오늘 날짜(cal)가 목표날짜(endCal)보다 작을 경우 %>		
		<script>
			$(function(){
				alert("2017년 한 해동안 희망도서 서비스를 이용해 주셔서 감사합니다!\n\n2017년 희망도서는 12월 4일까지 마감하며, 그 이후 신청한 도서는 \n2018년 1월 순차적으로 처리될 예정이니, 참고바랍니다!\n\n(문의:240-4531)");
			});
		</script>
	<%}%>
		<div class="Box mb40">
			<div class="guide_txt">
				이용자가 원하는 도서를 신속하게 제공하여 이용자 만족도를 높이고자하는 <span class="col_blue">고객맞춤서비스</span>입니다.
			</div>

			<h4 class="title">희망도서 신청</h4>

			<ul class="h_li">
				<li>우리도서관 관외대출회원 이어야 합니다.</li>
				<li><span class="col_green">1인당 월5권(시리즈 3권이내)까지 신청 가능,
						초과 신청한 자료는 취소됩니다.</span></li>
				<li>신청방법 : 홈페이지를 통한 인터넷신청, 도서관 내 자료검색PC 이용 신청 가능.</li>
				<li><span class="col_green">선정 제외도서 기준</span>
					<ul>
						<li>우리도서관 소장도서나 구입. 정리중인 도서</li>
						<li>서양서(해외주문도서), 전자자료(E-Book, DVD등 비도서), 5만원 이상 고가도서(단, 정기구입시
							검토 후 구입여부 결정)</li>
						<li>품절 및 절판도서<li>개인학습을 위한 자격증학습서, 수험서 등 문제위주의 도서 및 교과서</li>
					<li>청소년이 이용하기에 부적합한 선정적인 외설도서</li>
					<li>최신성이 떨어지는 자료(출판된지 3년이 지난 도서)</li>
					<li>만화, 무협지, 판타지소설, 인터넷 로맨스, 잡지, 전집류 등</li>
					<li>기타 공공도서관의 목적과 기능에 어긋나는 도서 등</li>
				</ul>
			</li>
		</ul>

		<h4 class="title">희망도서 구입</h4>
		<ul class="h_li">
			<li>신청하신 도서 구입은 주1회이며 소요기간은 신청일로부터 3주내외로 자료 특성에 따라 초과 될 수 있습니다.</li>
			<li>신청 진행상태는  <span class="col_blue">자료검색->대출조회/연기/예약도서->대출내역->희망도서신청내역</span>에서 확인 할 수 있습니다.</li>
		</ul>

		<h4 class="title">희망도서 제공</h4>
		<ul class="h_li">
			<li>희망도서가 자료실에 비치되면 신청자에게 SMS를 발송하여 알려드립니다.</li>
			<li>SMS 발송 후 3일 이내에 대출하여야 합니다.</li>
		</ul>


		<div class="fon_16 txt_right col_oran">문의 : 마산도서관 수서정리담당 240-4531~2</div>
	</div>
</c:if>
<!--//마산도서관 -->

<!-- 함양도서관 -->
<c:if test="${fn:indexOf(mid, 'a8')>-1}">
	<h4 class="title">이용안내</h4>
	<ul class="h_li">
		<li>필수정보(*표시)는 빠짐없이 입력해 주세요.</li>
		<li>월 1인 3권 이내로 신청 가능합니다.</li>
		<li>희망도서 신청 신청방법 : 홈페이지, 모바일 가능</li>
		<li>신청도서 대출안내 : 이용가능 SMS 문자로 알림(*대출가능 날짜까지(3일) 미대출시 자동 취소)</li>
		<li>신청제한 : 이용자가 희망한 도서라도 아래의 자료는 취소될 수 있습니다.
			<ul>
				<li>각종 시험을 대비한 문제집, 교과서, 학습참고서</li>
				<li>50면 미만의 소책자(아동서 제외)</li>
				<li>소수 한정된 이용자만을 위한 도서</li>
				<li>상업성 광고로 여겨지는 도서</li>
				<li>학위논문, 전집류</li>
				<li>판타지, 무협지, 만화 등에서 내용상 정서를 해할 우려가 있다고 생각되는 도서</li>
				<li>현재 정기구입에서 처리중인 도서나 절판 및 품절도서</li>
				<li>우리 도서관 대출회원이 아닌 사람이 신청한 자료</li>
				<li>발행연도가 6년 이상 지난 오래된 자료는 자료실 담당자의 의견을 수렴하여 처리</li>
			</ul>
		</li>
	</ul>
</c:if>
<!-- //함양도서관 -->

<!-- 사천도서관 -->
<c:if test="${fn:indexOf(mid,'c2') > -1}">
	<div class="Box mb40">
		<h4 class="title">희망도서 신청시 유의사항</h4>

		<ul class="h_li">
		<li>1인당 희망도서 신청은 월 3권 이내로 제한되어 있으니 신중하게 신청하여 주시기 바랍니다.</li>
		<li>판타지, 무협, 로맨스(하이틴), SF 등 오락성이 짙은 도서는 자제하고 학술적, 문학적, 예술적 가치가 있는 도서 위주로 신청하여 주시기 바랍니다.</li>
		<li>기존의 소장도서나 개인수험서 및 문제집 류 등 도서관 장서로 부적합하다고 판단하는 자료는 구입하지 않습니다.</li>
		<li>기타사항은 도서관(853-8401)로 문의하시기 바랍니다.</li>
		</ul>


	</div>
</c:if>
<!--// 사천도서관 -->

<!--창녕도서관 -->
<c:if test="${fn:indexOf(mid,'c3') > -1}">

<div class="mb20">
<h4 class="title">신청안내</h4>
<h5 class="title">희망도서는 월 1인 3권 이내로 신청 가능합니다.</h5>
<h5 class="title">다음 도서는 구입대상에서 제외되니, 이점 양지하시어 신청바랍니다.</h5>
<ul class="h_li">
<li>신간도서 주문 중이거나 정리중인 도서</li>
<li>참고서 및 수험서, 판타지 및 무협지, 로맨스 소설, 만화, 해외주문도서</li>
<li>비도서(DVD, 전자책), 정기간행물</li>
<li>출판년도가 5년 이상 경과한 자료</li>
<li>고가(4만원 이상)의 전문도서 (단, 정기구입시 반영)</li>
<li>서지사항(서명, 저자, 출판사 등)이 정확하지 않은 도서</li>
</ul>
<h5 class="title">위의 사항들에 해당하는 경우 희망도서신청 취소사유가 됩니다.</h5>


</div>
</c:if>
<!--//창녕도서관 -->


<!-- 통영도서관 -->
<c:if test="${fn:indexOf(mid,'b2') > -1}">

	<h4 class="title">이용안내</h4>
	<ol class="h_li" style="margin-bottom: 20px">
		<li><strong class="col_blue">희망도서는 월 1인5종 이내로 신청 가능합니다.</strong></li>
		<li><strong class="col_blue">다음 도서는 구입 대상에서 제외되니, 이점 양지하시어 신청 바랍니다.</strong>
			<ul>
				<li>신간도서 주문 중이거나 정리중인 도서</li>
				<li>참고서 및 수험서, 개인 학습용 문제집 등</li>
				<li>개인적 신념에 의한 종교자료</li>
				<li>출간된 지 3년이 지난 자료(소장이 필요한 경우는 예외)</li>
				<li>내용이 선정적이거나 폭력성이 짙은 도서</li>
				<li>비회원이 신청한 도서 또는 상업적 판매를 위해 신청한 도서</li>
				<li>오락성 만화물 및 전집류, 판타지 및 무협지, 로맨스 소설류 등</li>
				<li>비도서, 정기간행물, 해외주문도서</li>
				<li>비슷한 주제의 도서를 중복 신청하는 경우</li>
				<li>고가의 전문도서(정기 구입시 반영)</li>
			</ul>
		</li>
	</ol>
</c:if>
<!--//통영도서관 -->

<!-- 삼천포도서관 -->
<c:if test="${fn:indexOf(mid,'a6')>-1 }">

</c:if>


<!-- 거창도서관  -->
<c:if test="${fn:indexOf(mid,'b9') > -1 }">
	<h4 class="title">이용안내</h4>
	<ol class="h_li" style="margin-bottom: 20px">
		<li><strong class="col_blue">희망도서로 선정되어 자료실에 비치된 도서에 한하여 희망도서 신청시 기재된 연락처로 개별통보(SMS)하여 우선 대출할 수 있도록 함.</strong></li>
		<li><strong class="col_blue">도서는 SMS통보 후 3일간 별도 보관 뒤 신간코너로 이동</strong>
		<li><strong class="col_blue">신청가능 수량 : 월1인 3권 이하(가족이용자는 가족수와 상관없이 월6권 이하)</strong></li>
		<li>희망도서 선정 제한 기준
			<ul>
				<li>소장자료 : 우리도서관에 이미 소장되어 있는 자료</li>
				<li>개인의 학습을 위한 도서(수험서, 문제지, 교과서 등)</li>
				<li>오락성 및 혐오성이 짙은 도서(만화, 무협, 판타지 등)<ul><li>(단, 문학적 가치가 인정되거나 우량만화는 선정할 수 있음)</li></ul></li>
				<li>공공도서관에서 대출하기 어려운 형태의 자료<ul><li>(문제풀이집, 색칠공부, 입체도서, 교구가 많이 딸린 자료)</li></ul></li>
				<li>대형 인터넷서점 2곳 이상에서 품절 및 절판으로 확인된 도서</li>
				<li>신청일 현재 기준으로 5년 이상된 자료(일부 문학류 등은 제외)</li>
				<li>불특정 일반인을 위한 것이 아닌 극소수 이용자를 위한 전문도서</li>
				<li>전집류 시리즈물 등 수량이 많거나, 고가(4만원 이상)인 자료</li>
				<li>종교에 관하여 학문적, 이론적으로 다룬 것이 아닌 도서</li>
				<li>해외에서 구매해야하는 원서</li>
				<li>도서명, 저자명, 출판사항이 정확치 않은 경우</li>
			</ul>
		</li>
	</ol>
</c:if>

<!-- 함안도서관 -->
<c:if test="${fn:indexOf(mid,'a7') > -1}">
	<div>
		<span class="col_green">희망도서는 각종 수험서 및 문제집, 환타지(로맨스,무협지), 특정종교서적, 고가 서적, 전집류, 대학 교재, 만화, 출판년도가 오래된 도서, 기타 도서관 장서 구성 목적에 어긋난 자료를 제외한 도서에 한하여 월1인당 3권 신청 가능합니다.</span>
		<div>(희망도서가 비치되면 희망도서도착안내 문자가 자동 발송되며, 3일 이내에 종합자료실 카운터에서 대출하시기 바랍니다!)</div>
	</div>
	<script>
alert("2017년 한 해동안 희망도서 서비스를 이용해 주셔서 감사합니다.\n지금부터 신청하는 희망도서는 2018년 1월에 처리될 예정이니\n참고하시기 바랍니다.");
</script>
</c:if>
<!--//함안도서관 -->

<!-- 남지도서관 -->	
<c:if test="${fn:indexOf(mid,'c4') > -1}">
<script>
/* $(function(){
	alert('도서관 공사로 인하여 9월30일까지 도서신청을 이용하실 수 없습니다.');
	history.back();
	}); */
</script>
<h4 class="title">신청안내</h4>
	<ol class="h_li" style="margin-bottom: 20px">
		<li><strong class="col_green">희망도서는 월 1인 3권 이내로 신청 가능합니다.</strong></li>
		<li><strong class="col_green">다음 도서는 구입대상에서 제외되니, 이점 양지하시어 신청바랍니다.</strong>
			<ul>
				<li>도서관 소장 자료, 신간도서 주문 중이거나 정리중인 자료, 품절 및 절판인 자료</li>
				<li>제목 및 저자 등이 불명확한 자료, 출판년도가 3년이상 지난 자료</li>
				<li>개인 학습 자료(학습지, 문제집, 수험서, 참고서 등), 색칠공부, 입체 도서 등</li>
				<li>5만원 이상의 고가 자료 및 전집 자료(시리즈), 해외 구입 원서자료 등</li>
				<li>오락성, 선정성 및 폭력성 짙은 자료(만화, 연애소설, 무협소설, 판타지 소설)</li>
				<li>극소수를 위한 전문자료, 특정 출판사나 특정 종교 및 단체 관련 자료</li>
				<li>기타 도서관 장서 기준에 맞지 않는 자료</li>
			</ul>
		</li>
		<li><strong class="col_green">위의 사항들에 해당하는 경우 희망도서신청 취소사유가 됩니다.</strong></li>
	</ol>

</c:if>

<!--진동도서관 -->
<c:if test="${fn:indexOf(mid,'b6') > -1}">

<div class="mt40">
<div class="guide_txt">희망도서 신청은 도서관 미소장 도서로 <span class="col_blue">월별 1인당 3권</span>까지 가능합니다.<br>
<span class="col_red">희망도서 배가 시 도서연체, 대출정지 시 개별연락 하지 않습니다.</span>
</div>



<h5 class="title">구입 제외 도서</h5>

<ul class="h_li">
<li>자격증, 수험서 등 개인 학습 용도의 도서</li>
<li>발행년도가 3년이 지난 도서</li>
<li>판타지, 무협지, 로맨스 소설류</li>
<li>외서, 품절, 절판으로 구입이 어려운 도서</li>
</ul>

<h5 class="title">문의: 수서담당 (271-8145)</h5>
</div>
</c:if>
<!--//진동도서관 -->

<!-- 진영도서관 -->
<c:if test="${fn:indexOf(mid, 'a9') > -1}">
<h4 class="title">신청안내</h4>
	<ol class="h_li" style="margin-bottom: 20px">
		<li><strong class="col_green">희망도서는 월 1인 3종 이내로 신청 가능합니다.</strong></li>
		<li><strong class="col_green">다음 도서는 구입대상에서 제외될 수 있습니다.</strong>
			<ul>
				<li>신간도서 주문 중이거나 정리중인 도서</li>
				<li>참고서 및 수험서, 판타지 및 무협지, 로맨스 소설, 만화, 해외주문도서</li>
				<li>출간년도가 오래된(3년 이상) 도서</li>
				<li>고가의 전문도서</li>
			</ul>
		</li>
		<li><strong class="col_green">위의 사항에 해당되는 경우 희망도서신청 취소사유가 됩니다.</strong></li>
	</ol>
<h4 class="title">처리 진행 확인</h4>
<ol class="h_li" style="margin-bottom: 20px">
		<li><strong class="col_green">나의도서관 > 도서대출내역 > 희망도서 신청내역에서 확인가능</strong></li>
	</ol>
	
<h4 class="title">희망도서 제공</h4>
<ol class="h_li" style="margin-bottom: 20px">
		<li><strong class="col_green">자료실에 희망도서 비치와 동시에 SMS 발송(SMS 발송 후 3일 이내에 대출하여야 하고 그 기간 초과시는 신간서가에 비치됨)</strong></li>
	</ol>	
</c:if>
<!--//진영도서관 -->


<!-- 남해도서관 -->
<c:if test="${fn:indexOf(mid, 'c1') > -1}">
<ol class="h_li" style="margin-bottom: 20px">
		<li><strong class="col_green">희망도서로 선정되어 자료실에 비치된 도서에 한하여 희망도서 신청시 기재된 연락처로 개별통보(SMS)하여 우선 대출할 수 있도록 함.</strong></li>
		<li><strong class="col_green">도서는 SMS 통보 후 3일간 별도 보관 뒤 신간코너로 이동</strong>
		<li><strong class="col_green">신청가능 수량 : 월 1인 3권 이하</strong>
		<li><strong class="col_green">아래 희망도서는 선정에서 제외됩니다.</strong>
			<ul>
				<li>신간도서 주문 중이거나 정리중인 도서, 소장중인 자료</li>
				<li>출간년도(3년 이상)가 오래된 도서</li>
				<li>비도서(CD·DVD)/잡지 등 정기간행물</li>
				<li>대학교재/참고서/수험서/교과서/해외주문도서/극소수 이용자들을 위한 전문도서</li>
				<li>오락성이 짙은 판타지 및 무협지, 로맨스·만화 도서<br/>(단, 문학적 가치가 인정되는 우량도서의 경우 선정가능)</li>
				<li>전집류 시리즈물 등 수량이 많거나, 고가(5만원 이상)인 자료</li>
				<li>월 1인 희망도서 신청권수(3권) 초과 도서</li>
			</ul>
		</li>
	</ol>
</c:if>
<!--//남해도서관 -->

<!-- 고성도서관 -->
<c:if test="${fn:indexOf(mid, 'b3') > -1}">
<div class="guide_txt">
희망도서 신청은 월별 1인당 3권까지 가능합니다.
<br/>공익과 장서의 질을 생각하여 신중하 게 구입 신청함으로써 소중한 예산을 유용하게 쓸 수 있도록 협조하여 주시기 바랍니다.
</div>
<h4 class="title">구입제외도서</h4>
<ol class="h_li" style="margin-bottom: 20px">
	<li>출간된 지 5년이 지난 도서<br/>(시리자의 결호, 스테디셀러 중 도서관이 소장하고 있지 않은 자료는 제외)</li>
	<li>수험서, 무협지, 만화(우량만화 제외)</li>
	<li>특정 종교 및 특정 출판사, 특정 주제의 도서를 반복 요청하는 경우</li>
	<li>영어원서 및 시리즈도서는 검토후 수시 구입 시 입수</li>
</ol>
</c:if>
<!-- //고성도서관 -->
<table class="tstyle_write">
	<caption>서명, 저자, 출판사, 출판년도, ISBN, 가격, 신청사유의 희망자료신청표입니다.</caption>
	<colgroup>
		<col width="25%" />
			<col />
	</colgroup>
	<tr>
		<th scope="row"><label for="title"><spring:message
						code="i18n.book.title" />*</label></th>
		<td><input type="text" name="title" id="title"
				style="width:70%; ime-mode:active;" value="" maxlength="100"
				class="textbox" title="서명을 입력하세요" />
		<%--
			<span class="btnSm2"><a href="#" title="새창" onclick="book_search(); return false;">소장여부확인</a></span>
		--%>
			<span class="btnSm2"><a href="#" title="새창"
					onclick="api_search(); return false;">책검색</a></span>
		</td>
	</tr>
	<tr>
		<th scope="row"><label for="author"><spring:message
						code="i18n.book.author" />*</label></th>
		<td>
			<input type="text" name="author" id="author" style="width:70%"
				value="" maxlength="100" class="textbox" title="저자를 입력하세요" />
		</td>
	</tr>
	<tr>
		<th scope="row"><label for="publer"><spring:message
						code="i18n.book.publer" />*</label></th>
		<td>
			<input type="text" name="publer" id="publer" value="" maxlength="12"
				class="textbox" title="출판사를 입력하세요" />
		</td>
	</tr>
	<tr>
		<th scope="row"><label for="publer_year"><spring:message
						code="i18n.book.publer_year" /></label></th>
		<td>
			<input type="text" name="publer_year" id="publer_year" value=""
				maxlength="12" class="textbox" title="출판년도를 입력하세요" />
		</td>
	</tr>
	<tr>
		<th scope="row"><label for="isbn">ISBN</label></th>
		<td>
			<input type="text" name="isbn" id="isbn" value="" maxlength="13"
				class="textbox" title="ISBN을 입력하세요" />
		</td>
	</tr>
	<tr>
		<th scope="row"><label for="price"><spring:message
						code="i18n.book.price" /></label></th>
		<td>
			<input type="text" name="price" id="price" value="" maxlength="12"
				class="textbox" title="가격을 입력하세요" style="ime-mode:disabled"
				onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)' /> &nbsp; 숫자만 입력하세요. 예) 12000
		</td>
	</tr>
	<tr>
		<th scope="row"><label for="user_remark"><spring:message
						code="i18n.book.req_reason" /></label></th>
		<td>
			<input type="text" name="user_remark" id="user_remark" value=""
				style="width:70%" maxlength="100" class="textbox"
				title="신청사유를 입력하세요" />
		</td>
	</tr>

</table>

<div class="BtnArea mt-33" style="padding-top: 15px">
<p>
<input type="button" class="btn03" value="신청하기" onclick="javascript:book_request();">
</p>
</div>






</form>

<form action="" method="post" name="book_search_form" id="book_search_form">
<input type="hidden" name="searchKeyword" id="title2">
</form>

<link rel="stylesheet" href="/jquery/jquery-ui.css">
<script src="/jquery/jquery-ui.min.js"></script>
<script type="text/javascript">
<!--
	function api_search() {
		$('#searchYn').val('Y');
		if ($('#title').val() != '') {
			$('#title2').val($('#title').val());
			window
					.open("", "book_search_pop",
							"frame=no, scrollbars=yes, resizable=no, top=10, width=900, height=770");
			$('#book_search_form').attr('target', 'book_search_pop');
			$('#book_search_form').attr('action',
					'/book/api/search.es?mid=${es:SearchXSS(param.mid)}');
			$('#book_search_form').attr('method', 'post');
			$('#book_search_form').submit();
		} else {
			alert('검색할 서명을 입력해 주세요.');
		}

	}

	function book_search() {
		$('#searchYn').val('Y');
		if ($('#title').val() != '') {
			$('#title2').val($('#title').val());
			window
					.open("", "book_search_pop",
							"frame=no, scrollbars=yes, resizable=no, top=10, width=900, height=770");
			$('#book_search_form').attr('target', 'book_search_pop');
			$('#book_search_form').attr('action',
					'/book/popup/search.es?mid=${es:SearchXSS(param.mid)}');
			$('#book_search_form').attr('method', 'post');
			$('#book_search_form').submit();
		} else {
			alert('검색할 서명을 입력해 주세요.');
			//window.open("/book/popup/search.es?mid=${es:SearchXSS(param.mid)}", "_blank", "frame=no, scrollbars=no, resizable=no, top=0, width=900, height=800");
		}

	}

	function book_request() {
		/*if($('#searchYn').val() != 'Y') {
			alert('소장여부를 확인해 주세요.');
			return;
		}*/
		if ($('#title').val() == '') {
			alert('서명을 입력하세요');
			return;
		}
		if ($('#author').val() == '') {
			alert('저자를 입력하세요');
			return;
		}
		if ($('#publer').val() == '') {
			alert('출판사를 입력하세요');
			return;
		}
		//var msg = '검색하신 도서는 도서관에 현재 소장중이므로\n';
		//msg += '구입이 취소될 수 있습니다. 신청하시겠습니까?';
		var msg = '신청하시겠습니까?';
		if (!confirm(msg)) {
			return;
		}
		$('#title').val($('#title').val().replace('%', '퍼센트'));
		document.insForm.action = "/book/hope_request.es";
		document.insForm.submit();
	}

	$(function() {
		/*var autocomplete_text = ["자동완성기능","Autocomplete","개발로짜","국이"];
		$("#title").autocomplete({
			source: autocomplete_text
		});
		 */
		$("#title").autocomplete({
			source : function(request, response) {
				$.ajax({
					type : 'post',
					url : "/book/search/autocomplete.es",
					dataType : "json",
					//request.term = $("#title").val()
					data : {
						searchKeyword : $("#title").val()
					},
					success : function(data) {
						//서버에서 json 데이터 response 후 목록에 뿌려주기 위함
						response($.map(data, function(item) {
							return {
								label : item.word,
								value : item.word
							}
						}));
					}
				});
			},
			//조회를 위한 최소글자수
			minLength : 1,
			select : function(event, ui) {
				// 만약 검색리스트에서 선택하였을때 선택한 데이터에 의한 이벤트발생
			}
		});
	});
//-->
</script> <c:if test="${fn:length(param.mid) == 12}">
								<jsp:include page="/include/foot_sub.jsp" />
								<jsp:include page="/include/foot.jsp" />
							</c:if> <jsp:include page="/include/foot_hide.jsp">
								<jsp:param value="<%=cpctype%>" name="cpctype" />
								<jsp:param value="<%=sid%>" name="sid" />
							</jsp:include>
