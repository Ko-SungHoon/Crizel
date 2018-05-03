<%
/**
*   PURPOSE :   업데이트요청 팝업 html 코딩
*   CREATE	:   20180405_thur   LJH
*   MODIFY	:   20180411_wed    JI		식품 검색 기능
*   MODIFY	:   20180412_thur	JI		식품 업데이트 요청 등록
*/
%>

<%@ page import="egovframework.rfc3.menu.web.CmsManager" %>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%

request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");
SessionManager sManager =	new SessionManager(request);

//list
StringBuffer sql 		= null;
List<FoodVO> catList 	= null;
List<FoodVO> nuList 	= null;

try{
	//품목 리스트 조회
	sql	=	new StringBuffer();
	sql.append(" SELECT *			");
	sql.append(" FROM FOOD_ST_CAT	");
	sql.append(" ORDER BY CAT_NO	");

	try{
		catList =    jdbcTemplate.query(sql.toString(), new FoodList());
	}catch(Exception e){
		catList =    null;
	}

	//나중에 아이디 세션에서 받아서 조회 후 where 절에서 던져야 함.
	//영양사 리스트
	sql	=	new StringBuffer();
	sql.append(" SELECT	* 										");
	sql.append(" FROM FOOD_SCH_TB A JOIN FOOD_SCH_NU B			");
	sql.append(" ON A.SCH_NO = B.SCH_NO AND B.SHOW_FLAG = 'Y'	");
	sql.append(" WHERE A.TEAM_NO = (SELECT TEAM_NO				");
	sql.append(" 	FROM FOOD_SCH_TB WHERE SCH_ID = ?)			");
	try {
		nuList	=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{sManager.getId()});
	}catch(Exception e){
		nuList	=   null;
		out.println("<script>console.log('" + e.toString() + "');</script>");
	}

}catch(Exception e){
	out.println(e.toString());
}
%>

<script title="tabmenu js">
	
	var tabNo	=	0;

    $(function () {
        $(".tab_content").hide();
        $(".tab_content:first").show();
		tabNo	=	1;

        $("ul.tabs li").click(function () {
			$("ul.tabs li").removeClass("active");
			//$(this).addClass("active").css({"color": "darkred","font-weight": "bolder"});
			$(this).addClass("active");
			$(".tab_content").hide()
			var activeTab = $(this).attr("rel");
			$("#" + activeTab).show();
			//$("#" + activeTab).fadeIn();
			//tab 변경 시점에 input clear
			//tab 번호 추출
			tabNo	=	activeTab.charAt(activeTab.length-1);
			$("input").val("");
			$("textarea").val("");
			return false;
        });

		//검색 버튼
		$("#schModBtn").click(function () {
			var nm_food	=	$("#schModVal").val();
			schModalOpen (nm_food);
		});
		$("#schDelBtn").click(function () {
			var nm_food	=	$("#schDelVal").val();
			schModalOpen (nm_food);
		});

		//요청사 select 선택
		$("#selRequester1").change(function (){
			var nu_no	=	$("#selRequester1 option:selected").val();
			var nu_tel	=	$("#selRequester1 option:selected").data("value");
			$("#telView1").val(nu_tel);
		});
		$("#selRequester2").change(function (){
			var nu_no	=	$("#selRequester2 option:selected").val();
			var nu_tel	=	$("#selRequester2 option:selected").data("value");
			$("#telView2").val(nu_tel);
		});
		$("#selRequester3").change(function (){
			var nu_no	=	$("#selRequester3 option:selected").val();
			var nu_tel	=	$("#selRequester3 option:selected").data("value");
			$("#telView3").val(nu_tel);
		});

    });

    //검색 modal open
    function schModalOpen (nm_food) {
		if( nm_food == "" || nm_food == null || nm_food == undefined 
			|| ( nm_food != null && typeof nm_food == "object" && !Object.keys(nm_food).length ) ) {
			alert("검색할 식품명을 입력하세요.");
			return;
		} else {
			$('#slide').popup({
				focusdelay: 400,
				outline: true,
				vertical: 'middle'
			});
			ajaxListFood (nm_food);
		}
    }

	//검색 ajax
	function ajaxListFood (nm_food) {
		$.ajax({
			type : "POST",
			url : "/program/food/update/food_update_ajax.jsp",
			data : {"nm_food": nm_food},
			dataType : "text",
			async : false,
			success : function(data){
				$("#sch_list").html(data);
			},
			error : function(request, status, error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText.trim()+"\n"+"error:"+error);
			}
		});
	}

	//검색 식품 선택
	function selFood (s_item_no, cat_no, item_no, nm_food, dt_nm, ex_nm, food_code, unit_nm) {
		//탭 삭제
		if (tabNo == 3) {
			//$("#schDelVal").val(nm_food);
			$(".s_item_no").eq(1).val(s_item_no);
			$(".cat_no").eq(2).val(cat_no);
			$(".nm_food").eq(1).val(nm_food);
			$(".food_code").eq(1).val(food_code);
			$(".dt_nm").eq(1).val(dt_nm);
			$(".ex_nm").eq(1).val(ex_nm);
			$(".unit_nm").eq(1).val(unit_nm);
		//탭 수정
		} else {
			//$("#schModVal").val(nm_food);
			$(".s_item_no").eq(0).val(s_item_no);
			$(".cat_no").eq(0).val(cat_no);
			$(".nm_food").eq(0).val(nm_food);
			$(".food_code").eq(0).val(food_code);
			$(".dt_nm").eq(0).val(dt_nm);
			$(".ex_nm").eq(0).val(ex_nm);
			$(".unit_nm").eq(0).val(unit_nm);
		}
		//modal close
		$("#slide_wrapper").click();
	}

	//request Submit
	function reqSendUpdate () {
		//영양사가 있는 학교인지, 확인이 먼저...
		var selRequester	=	"";
		var upd_reason		=	"";
		var s_item_no		=	"";
		var n_cat_no		=	"";
		var n_item_nm		=	"";
		var n_item_code		=	"";
		var n_item_dt_nm	=	"";
		var n_item_expl		=	"";
		var n_item_unit		=	"";

		var params			=	"";

		// 마지막에 작업
		var sendForm	=	$("#tab1_form");
		var mode		=	$("<input type='hidden' name='mode' class='mode' value='mod'>");
		mode			=	"mod";

		if (tabNo == 3) {
			sendForm	=	$("#tab3_form");
			mode		=	$("<input type='hidden' name='mode' class='mode' value='del'>");
			mode		=	"del";

			selRequester=	$("#selRequester3 option:selected").val();
			upd_reason	=	$(".upd_reason").eq(2).val();

			s_item_no	=	$(".s_item_no").eq(1).val();
			if (nullChk(s_item_no)) {
				alert("삭제할 식품을 선택하세요.");
				return;
			}

		} else if (tabNo == 2) {
			sendForm	=	$("#tab2_form");
			mode		=	$("<input type='hidden' name='mode' class='mode' value='add'>");
			mode		=	"add";

			selRequester=	$("#selRequester2 option:selected").val();
			upd_reason	=	$(".upd_reason").eq(1).val();

			n_cat_no	=	$("#foodName option:selected").val();
			if (nullChk(n_cat_no)) {
				alert("품목구분을 선택하세요.");
				return;
			}
			n_item_nm	=	$(".n_item_nm").eq(1).val();
			n_item_code	=	$(".n_item_code").eq(1).val();
			n_item_dt_nm=	$(".n_item_dt_nm").eq(1).val();
			n_item_expl	=	$(".n_item_expl").eq(1).val();
			n_item_unit	=	$(".n_item_unit").eq(1).val();
			if (nullChk(n_item_nm) || nullChk(n_item_code) || nullChk(n_item_dt_nm) || nullChk(n_item_expl) || nullChk(n_item_unit)) {
				alert("추가할 식품 정보를 입력하세요.");
				return;
			}

		} else {
			selRequester=	$("#selRequester1 option:selected").val();
			upd_reason	=	$(".upd_reason").eq(0).val();

			s_item_no	=	$(".s_item_no").eq(0).val();
			if (nullChk(s_item_no)) {
				alert("변경할 식품을 선택하세요.");
				return;
			}
			n_item_nm	=	$(".n_item_nm").eq(0).val();
			n_item_code	=	$(".n_item_code").eq(0).val();
			n_item_dt_nm=	$(".n_item_dt_nm").eq(0).val();
			n_item_expl	=	$(".n_item_expl").eq(0).val();
			n_item_unit	=	$(".n_item_unit").eq(0).val();
			if (nullChk(n_item_nm) && nullChk(n_item_code) && nullChk(n_item_dt_nm) && nullChk(n_item_expl) && nullChk(n_item_unit)) {
				alert("변경할 식품 정보를 입력하세요.");
				return;
			}

		}
		if (nullChk(upd_reason) || nullChk(selRequester)) {
			alert("요청자 정보와 사유를 입력하세요.");
			return;
		}

		//submit
		var sendUrl	=	"/program/food/update/food_update_reg_act.jsp";
		params		=	{mode: mode,
						selRequester: selRequester,
						upd_reason: upd_reason,
						s_item_no: s_item_no,
						/* foodName: foodName, */
						n_cat_no: n_cat_no,
						n_item_nm: n_item_nm,
						n_item_code: n_item_code,
						n_item_dt_nm: n_item_dt_nm,
						n_item_expl: n_item_expl,
						n_item_unit: n_item_unit};
		post_to_url(sendUrl, params, "post");

		//sendForm.append(mode);
		//sendForm.attr("action", "/program/food/update/food_update_reg_act.jsp");
		//sendForm.submit();
	}

	function nullChk (value) {
		if (value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length)) { 
			return true;
		}else{
			return false;
		}
	}

	function post_to_url(path, params, method) {
        method = method || "post";  //method 부분은 입력안하면 자동으로 post가 된다.
        var form = document.createElement("form");
        form.setAttribute("method", method);
        form.setAttribute("action", path);
        //input type hidden name(key) value(params[key]);
        for(var key in params) {
            var hiddenField = document.createElement("input");
            hiddenField.setAttribute("type", "hidden");
            hiddenField.setAttribute("name", key);
            hiddenField.setAttribute("value", params[key]);
            form.appendChild(hiddenField);
        }
        document.body.appendChild(form);
        form.submit();
    }
</script>

<section class="pop_update">
	<h1 class="c">업데이트 요청하기</h1>
	<!-- 탭메뉴 -->
	<div class="tab_wrap clearfix">
		<ul class="tabs">
			<li class="active" rel="tab1"><a href="javascript:;">수정</a></li>
			<li rel="tab2"><a href="javascript:;">추가</a></li>
			<li rel="tab3"><a href="javascript:;">삭제</a></li>
		</ul>
	</div>
	<!-- //탭메뉴 -->

	<div class="tab_container">

	<!-- tab1 수정 -->
		<section id="tab1" class="tab_content">
			<h2 class="blind">품목정보 수정하기</h2>
			<form id="tab1_form" name="tab1_form" method="post">
				<input type="hidden" name="s_item_no" class="s_item_no" value="">
				<input type="hidden" name="cat_no" class="cat_no" value="">
				<fieldset>
					<legend>품목 정보 수정 폼</legend>
					<h3>품목정보 수정하기</h3>
					<span class="red">&#8251; 복수의 내용 입력시 "," 로 구분하세요. (예: 생육, 양념)</span>
					<table class="table_skin02 td-l">
						<caption>업데이트 요청 : 품목정보 수정 입력 : 식품명, 식품코드, 상세식품명, 식품설명, 단위 등의 기존 데이터 노출과 변경데이터 입력</caption>
						<colgroup>
							<col style="width:20%" />
							<col style="width:40%" />
							<col style="width:40%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">구분</th>
								<th scope="col">기존데이터</th>
								<th scope="col">변경데이터</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th scope="row" class="bg_green">식품명</th>
								<td>
                                    <label><input type="text" value="" id="schModVal" name="schModVal nm_food" title="식품명" class="wps_70 nm_food" placeholder="식품명을 입력하세요." /></label>
                                    <a href="javascript:;" id="schModBtn" class="btn small edge mako slide_open">검색</a>
                                </td>
								<td><label><input type="text" value="" placeholder="식품명(변경할 경우에만 입력)" title="식품명" class="wps_90 n_item_nm" /></label></td>
							</tr>
							<tr>
								<th scope="row" class="bg_green">식품코드</th>
								<td><label><input type="text" value="" title="식품코드" class="wps_90 food_code" readonly /></label></td>
								<td><label><input type="text" placeholder="식품코드(변경할 경우에만 입력)" value="" title="식품코드" class="wps_90 n_item_code" /></label></td>
							</tr>
							<tr>
								<th scope="row" class="bg_green">상세식품명</th>
								<td><label><input type="text" value="" title="상세식품명" class="wps_90 dt_nm" readonly /></label></td>
								<td><label><input type="text" placeholder="상세식품명(변경할 경우에만 입력)" value="" title="상세식품명" class="wps_90 n_item_dt_nm" /></label></td>
							</tr>
							<tr>
								<th scope="row" class="bg_green">식품설명</th>
								<td><label><textarea title="식품설명" class="wps_90 h050 ex_nm" readonly></textarea></label></td>
								<td><label><textarea placeholder="식품설명(변경할 경우에만 입력)" value="" title="식품설명" class="wps_90 h050 n_item_expl"></textarea></label></td>
							</tr>
							<tr>
								<th scope="row" class="bg_green">단위</th>
								<td><label><input type="text" value="" title="단위" class="wps_90 unit_nm" readonly /></label></td>
								<td><label><input type="text" placeholder="단위(변경할 경우에만 입력)" value="" title="단위" name="upd_reason" class="wps_90 n_item_unit" /></label></td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				<fieldset>
					<legend>요청자 정보 및 사유</legend>
					<h3>요청자 정보 및 사유</h3>
					<table class="table_skin02 td-l">
						<caption>업데이트 요청자 정보 및 사유 입력</caption>
						<colgroup>
							<col style="width:20%" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">요청자명</th>
								<td>
									<label for="selRequester1" class="blind">요청자 선택</label>
									<select name="" id="selRequester1" class="selRequester1" name="nu_no" required>
										<option value="">요청자 선택</option>
										<%if(nuList != null && nuList.size() > 0) {
											for(FoodVO vo : nuList){%>
											<option value="<%=vo.nu_no %>" data-value="<%=vo.nu_tel %>"><%=vo.nu_nm %></option>
										<%}/*END FOR*/
										}/*END IF*/%>
									</select>
									<label for="telView1" class="blind">연락처 확인란</label>
									<input type="text" id="telView1" value="" placeholder="연락처 확인란" class="wps_40 nu_tel" readonly required/>
								</td>
							</tr>
							<tr>
								<th scope="row">사유</th>
								<td>
									<label><textarea placeholder="사유를 구체적으로 입력하세요." title="업데이트 요청 사유 입력" name="upd_reason" class="wps_90 h050 upd_reason"  required></textarea></label>
								</td>
							</tr>
						</tbody>
					</table>
				</fieldset>
			</form>
		</section>
		<!-- //tab1 : 수정 끝 -->
		<!-- tab2 : 추가 품목 -->
		<section id="tab2" class="tab_content">
			 <h2 class="blind">품목정보 추가하기</h2>
			 <form id="tab2_form" name="tab2_form" method="post">
				 <fieldset>
					 <legend>품목 정보 추가 폼</legend>
					 <h3>품목정보 추가하기</h3>
					 <span class="red">&#8251; 복수의 내용 입력시 "," 로 구분하세요. (예: 생육, 양념)</span>
					 <table class="table_skin02 td-l">
						 <caption>업데이트 요청 - 품목정보 추가입력 : 식품명, 식품코드, 상세식품명, 식품설명, 단위 등의 기존 데이터 노출과 변경데이터 입력</caption>
						 <colgroup>
							 <col style="width:20%" />
							 <col />
						 </colgroup>
						 <thead>
							 <tr>
								 <th scope="col">구분</th>
								 <th scope="col">정보입력</th>
							 </tr>
						 </thead>
						 <tbody>
							 <tr>
								 <th scope="row" class="bg_green">품목구분</th>
								 <td>
									 <label for="foodName" class="blind">품목구분</label>
									 <select id="foodName" name="cat_no" class="cat_no">
										 <%if(catList != null && catList.size() > 0) {
											 for (FoodVO vo:catList) {%>
										 <option value="<%=vo.cat_no %>"><%=vo.cat_nm %></option>
										 <%}/*END FOR*/
										 }/*END IF*/%>
									 </select>
								 </td>
							 </tr>
							 <tr>
								 <th scope="row" class="bg_green">식품명</th>
								 <td><label><input type="text" value="" placeholder="식품명을 입력하세요." title="식품명" name="n_item_nm" class="wps_50 n_item_nm" /></label></td>
							 </tr>
							 <tr>
								 <th scope="row">식품코드</th>
								 <td><label><input type="text" placeholder="식품코드를 입력하세요." value="" title="식품코드" name="n_item_code" class="wps_50 n_item_code" /></label></td>
							 </tr>
							 <tr>
								 <th scope="row" class="bg_green">상세식품명</th>
								 <td><label><input type="text" placeholder="상세식품명을 입력하세요." value="" title="상세식품명" name="n_item_dt_nm" class="wps_80 n_item_dt_nm" /></label></td>
							 </tr>
							 <tr>
								 <th scope="row" class="bg_green">식품설명</th>
								 <td><label><textarea placeholder="식품설명을 입력하세요." value="" title="식품설명" name="n_item_expl" class="wps_80 h050 n_item_expl"></textarea></label></td>
							 </tr>
							 <tr>
								 <th scope="row" class="bg_green">단위</th>
								 <td><label><input type="text" placeholder="단위를 입력하세요." value="" title="단위" name="n_item_unit" class="wps_50 n_item_unit" /></label></td>
							 </tr>
						 </tbody>
					 </table>
				 </fieldset>
				 <fieldset>
					 <legend>요청자 정보 및 사유</legend>
					 <h3>요청자 정보 및 사유</h3>
					 <table class="table_skin02 td-l">
						 <caption>업데이트 요청자 정보 및 사유 입력</caption>
						 <colgroup>
							 <col style="width:20%" />
							 <col />
						 </colgroup>
						 <tbody>
							 <tr>
								 <th scope="row">요청자명</th>
								 <td>
									 <label for="selRequester2" class="blind">요청자 선택</label>
									 <select name="selRequester2" id="selRequester2" class="nu_no" required>
										 <option value="">요청자 선택</option>
										 <%if(nuList != null && nuList.size() > 0) {
											for(FoodVO vo : nuList){%>
											<option value="<%=vo.nu_no %>" data-value="<%=vo.nu_tel %>"><%=vo.nu_nm %></option>
										<%}/*END FOR*/
										}/*END IF*/%>
									 </select>
									 <label for="telView2" class="blind">연락처 확인란</label>
									 <input type="text" id="telView2" value="" placeholder="연락처 확인란" class="wps_40" readonly required/>
								 </td>
							 </tr>
							 <tr>
								 <th scope="row">사유</th>
								 <td>
									 <label><textarea placeholder="사유를 구체적으로 입력하세요." title="업데이트 요청 사유 입력" name="upd_reason" class="wps_90 h050 upd_reason" required></textarea></label>
								 </td>
							 </tr>
						 </tbody>
					 </table>
				 </fieldset>
			 </form>
		 </section>
		 <!-- //tab2 추가 끝 -->
		 <!-- tab3 : 삭제 -->
		 <section id="tab3" class="tab_content">
			<h2 class="blind">품목정보 삭제하기</h2>
			<form id="tab3_form" name="tab3_form" method="post">
				<input type="hidden" name="s_item_no" class="s_item_no" value="">
				<input type="hidden" name="cat_no" class="cat_no" value="">
				<fieldset>
					<legend>품목 정보 삭제 폼</legend>
					<h3>품목정보 삭제하기</h3>
					<table class="table_skin02 td-l">
						<caption>업데이트 요청 - 기존데이터 삭제 : 식품명, 식품코드, 상세식품명, 식품설명, 단위 등의 기존 데이터</caption>
						<colgroup>
							<col style="width:20%" />
							<col />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">구분</th>
								<th scope="col">기존데이터</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th scope="row" class="bg_green">식품명</th>
								<td>
									<label>
									<input type="text" id="schDelVal" name="schDelVal" value="" placeholder="식품명을 입력하세요." title="식품명" class="wps_50 nm_food" />
									</label>
									<a href="javascript:;" id="schDelBtn" class="btn small edge mako slide_open">검색</a>
								</td>
							</tr>
							<tr>
								<th scope="row">식품코드</th>
								<td><label><input type="text" value="040113" title="식품코드" readonly class="wps_50 food_code" /></label></td>
							</tr>
							<tr>
								<th scope="row" class="bg_green">상세식품명</th>
								<td><label><input type="text" value="생것, 꼬투리 깐 것" title="상세식품명" readonly class="wps_80 dt_nm" /></label></td>
							</tr>
							<tr>
								<th scope="row" class="bg_green">식품설명</th>
								<td><label><textarea title="식품설명" class="wps_80 h050 ex_nm" readonly>국산, 상품, 깐것, 진녹색,크기균일,낟알 고르고, 병충해가 없는 것</textarea></label></td>
							</tr>
							<tr>
								<th scope="row" class="bg_green">단위</th>
								<td><label><input type="text" value="kg" title="단위" class="wps_50 unit_nm" readonly /></label></td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				<fieldset>
					<legend>요청자 정보 및 사유</legend>
					<h3>요청자 정보 및 사유</h3>
					<table class="table_skin02 td-l">
						<caption>업데이트 요청자 정보 및 사유 입력</caption>
						<colgroup>
							<col style="width:20%" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">요청자명</th>
								<td>
									<label for="selRequester3" class="blind">요청자 선택</label>
									<select name="selRequester3" id="selRequester3" class="nu_no" required>
										<option value="">요청자 선택</option>
										<%if(nuList != null && nuList.size() > 0) {
											for(FoodVO vo : nuList){%>
											<option value="<%=vo.nu_no %>" data-value="<%=vo.nu_tel %>"><%=vo.nu_nm %></option>
										<%}/*END FOR*/
										}/*END IF*/%>
									</select>
									<label for="telView3" class="blind">연락처 확인란</label>
									<input type="text" id="telView3" value="010-1234-5678" placeholder="연락처 확인란" class="wps_40" readonly required/>
								</td>
							</tr>
							<tr>
								<th scope="row">사유</th>
								<td>
									<label><textarea placeholder="사유를 구체적으로 입력하세요." title="업데이트 요청 사유 입력" name="upd_reason" class="wps_90 h050 upd_reason" required></textarea></label>
								</td>
							</tr>
						</tbody>
					</table>
				</fieldset>
			</form>
		 </section>
		 <!-- //tab3 삭제 끝 -->
	</div>

	<div class="btn_area c">
		<button type="submit" class="btn medium darkMblue" onclick="reqSendUpdate();">확인</button>
		<button type="button" onclick="window.close();" class="btn medium mako">닫기</button>
	</div>
</section>

<%/*************************************** STR Modal part ****************************************/%>
<!-- 식품명 목록 -->
	<div id="slide" class="modal well" style="display:none;">
		<div class="topbar">
			<h3>식품 목록</h3>
		</div>
		<div class="inner">
			<table class="table_skin01">
				<caption>식품명 검색 목록 : 식품명, 상세식품명, 식품코드, 선택</caption>
				<colgroup>
					<col style="width:23%" />
					<col />
					<col />
					<col style="width:11%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">식품명</th>
						<th scope="col">상세식품명</th>
						<th scope="col">식폼코드</th>
						<th scope="col">선택</th>
					</tr>
				</thead>
				<tbody id="sch_list">
					<tr>
						<td colspan="4">검색된 식품이 없습니다.</td>
					</tr>
				</tbody>
			</table>
		</div>
		<a href="javascript:;" class="btn_cancel popup_close slide_close" id="modalClose" title="창닫기"><img src="/img/art/layer_close.png" alt="창닫기"></a>
	</div>
<!-- //식품명 목록 끝 -->
<%/*************************************** END Modal part ****************************************/%>