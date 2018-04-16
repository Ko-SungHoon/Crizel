<%@ page import="java.util.*, egovframework.rfc3.board.vo.BoardVO, egovframework.rfc3.board.vo.BoardCategoryVO, egovframework.rfc3.common.util.EgovStringUtil"%>
<%
	List<BoardCategoryVO> categoryList1 = bm.getCategoryList1();
	List<BoardCategoryVO> categoryList2 = bm.getCategoryList2();
	List<BoardCategoryVO> categoryList3 = bm.getCategoryList3();
%>
<link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.13/themes/humanity/jquery-ui.css" type="text/css" media="all" />
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.13/jquery-ui.min.js" type="text/javascript"></script>
<style>
 .ui-datepicker{
	 font-size : 16px;
	 width : 230px; 
 }
 .ui-datepicker select.ui-datepicker-month{
	 width:30%;  
	 font-size: 13px;
 }

 .ui-datepicker select.ui-datepicker-year{
	 width:40%;     
	 font-size: 13px; 
 }
</style>
	<script type="text/javascript">
	function CheckDate(pDate){
		var mDate = pDate.split("-");
		var mTimeStampe = new Date(mDate[0],mDate[1],mDate[2]).getTime();
		return mTimeStampe;
	}

function OnClear(pObj){
	pObj.value="";
}
$(function() {

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

     $( "#tmpField1" ).datepicker({
          dateFormat: 'yy/mm/dd',  //데이터 포멧형식
          minDate: '-30M',      //오늘 부터 30개월전까지만 선택 할 수 있다.
          maxDate: '+36M',     //오늘 부터 36개월후까지만 선택 할 수 있다.
          changeMonth: true,    //달별로 선택 할 수 있다.
          changeYear: true,     //년별로 선택 할 수 있다.
          showOtherMonths: false,  //이번달 달력안에 상/하 빈칸이 있을경우 전달/다음달 일로 채워준다.
          selectOtherMonths: true, 
          showButtonPanel: true  //오늘 날짜로 돌아가는 버튼 및 닫기 버튼을 생성한다.
     });
});
</script> 

<script type="text/javascript">
	<%if(!"".equals(bm.getCategoryCode1()) && bm.getCategoryCode1()!= null){%>
		$(function(){
				var category = "<%=bm.getCategoryCode1()%>";
				$("#sec_cate").val(category);
		});
	<%}%>
	function changeCate(obj){
		$("#sec_cate").val(obj.value);
	}

	function formSubmit(f)
	{		
		<%if("BBS_0000215".equals(bm.getBoardId())){
			if(!bm.isManager()){%>

		var d = new Date();
		var nowYear = d.getFullYear();
		var nowMonth = d.getMonth();
		var nowDay = d.getDate();
		var tmpField1 = $("#tmpField1").val();
		var year = tmpField1.substr(0,4);
		var month = tmpField1.substr(5,2);
		var day = tmpField1.substr(8,2);
		
		var date = new Date(year, (month*1)-1, day);
		var date2 = new Date(nowYear*1, nowMonth*1, nowDay*1);
		var nowHour = d.getHours();
		var nowMinutes = d.getMinutes();
		
		var strHour = nowHour.toString();
		var strMinutes = nowMinutes.toString();
		var strTime = strHour + strMinutes;
		var nowTimes = strTime * 1;
		
		var timelimit = 1200;
		
		if(nowTimes < timelimit){
			if(date2 > date){
			alert("보도요청일자는 현재날짜 이후로만 설정하실 수 있습니다.");
			f.tmpField1.focus();
			return false;
			}
		}
		else if(nowTimes > timelimit){
			if(d >= date){
			alert("보도요청일자는 현재날짜 이후로만 설정하실 수 있습니다.");
			f.tmpField1.focus();
			return false;
			}
		}
		<%}}%>
		if(f.dataTitle.value == '')
		{
			alert("제목을 입력하시기 바랍니다.");
			f.dataTitle.focus();
			return false;
		}
		<% if(bm.isWriteItem("CATEGORY_CODE1") && categoryList1 != null && categoryList1.size() > 0) {%>
		if(f.categoryCodeData1.value == '')
		{
			alert("1차 카테고리를 선택해 주세요.");
			f.categoryCodeData1.focus();
			return false;
		}
			<% if(bm.isWriteItem("CATEGORY_CODE2") && categoryList2 != null && categoryList2.size() > 0) {%>
			if(f.categoryCodeData2.value == '')
			{
				alert("2차 카테고리를 선택해 주세요.");
				f.categoryCodeData2.focus();
				return false;
			}
				<% if(bm.isWriteItem("CATEGORY_CODE3") && categoryList3 != null && categoryList3.size() > 0) {%>
				if(f.categoryCodeData3.value == '')
				{
					alert("3차 카테고리를 선택해 주세요.");
					f.categoryCodeData3.focus();
					return false;
				}
				<% } %>
			<% } %>
		<% } %>
		if(!checkDataContent(f)){
			return false;	
		}
 		
		if($("#checkInfo").prop("checked") == false){
			alert("개인정보 제공에 동의 하시기 바랍니다.");
			return false;
		}
				
		var board_id = "<%=bm.getBoardId()%>";
		var user_id = "<%=sm.getId()%>";
		var category_cd = $("#sec_cate").val();
		<%if(!bm.isManager()){%>
		var submit_chk = false;
		<%}else{%>
		var submit_chk = true;
		<%}%>
		
		var data_list = {"board_id" : board_id, "user_id" : user_id, "category_cd" : category_cd};
		
		
		/**  월 게시글 등록제한  **/
		var cnt_a = 4;	//학교
		var cnt_b = 5;	//교육지원청, 직속기관 
		var cnt_today = 1;	//하루에 등록가능한 게시물 수
		
		<%if(!"update".equals(bm.getCommand())){%>
		 $.ajax({
			type : "POST",
			url : "/program/day_limit.jsp",
			data : data_list,
			async : false,
			success : function(data){
				if(category_cd == 'A' || category_cd == 'B' || category_cd == 'C'){
					if(data >= cnt_a){
						alert("이번 달은 더이상 글을 작성할 수 없습니다. \n이번달 글 작성수 : "+data.trim());
						submit_chk = false;
					}else{
						submit_chk = true;
					}
				}else if(category_cd == 'D' || category_cd == 'E'){
					if(data >= cnt_b){
						alert("이번 달은 더이상 글을 작성할 수 없습니다. \n이번달 글 작성수 : "+data.trim());
						submit_chk = false;
					}else{
						submit_chk = true;
					}
				} 
			},
			error : function(){
			}
		}); 
		
		 $.ajax({
				type : "POST",
				url : "/program/day_limit2.jsp",
				data : data_list,
				async : false,
				success : function(data){
					if(data >= cnt_today){
						alert("오늘은 더이상 글을 작성할 수 없습니다.");
						submit_chk = false;
					}else{
						submit_chk = true;
					}
				},
				error : function(){
				}
			}); 
		 <%}else{%>
			submit_chk = true;
		 <%}%>
		 
		 return submit_chk;
		
	}
	
	
	<%  if(bm.isBoardDateIsUseCf()){ %>
	function CheckDate(pDate){
		var mDate = pDate.split("-");
		var mTimeStampe = new Date(mDate[0],mDate[1],mDate[2]).getTime();
		return mTimeStampe;
	}

	function OnClear(pObj){
		pObj.value="";
	}
<% }%>
	
</script>

<% if(bm.isBoardEditor()){ %>
<script type="text/javascript">	
function checkDataContent(f){
		oEditors.getById["dataContent"].exec("UPDATE_CONTENTS_FIELD", []);
		if(f.dataContent.value == '')
		{
			alert("내용을 입력하시기 바랍니다.");
			oEditors.getById["dataContent"].exec("FOCUS", []);

			return false;
		}
	return true;
}


</script>
<% }else{ %>
<script type="text/javascript">	
function checkDataContent(f){
		if(f.dataContent.value == '')
		{
			alert("내용을 입력하시기 바랍니다.");
			return false;
		}

	return true;
}
</script>
<% } %>
<script type="text/javascript" src="<%=request.getContextPath() %>/SmartEditor2/js/HuskyEZCreator.js"></script> 
			<!-- board_write -->
<form id="form" onsubmit="return formSubmit(this);" method="post" action="<%=request.getContextPath() %>/board/<%=bm.getCommand() != null && bm.getCommand().equals("update") ? "updateAct" : "writeAct"%>.<%=bm.getUrlExt()%>" enctype="multipart/form-data">
	<input type="hidden" name="orderBy" value="<%=bm.getOrderBy()%>" />
	<input type="hidden" name="boardId" value="<%=bm.getBoardId()%>" />
	<input type="hidden" name="searchStartDt" value="<%=bm.getSearchStartDt()%>" />
	<input type="hidden" name="searchEndDt" value="<%=bm.getSearchEndDt()%>" />
	
	<input type="hidden" name="menuCd" value="${menuCd}" />
	<input type="hidden" name="contentsSid" value="${contentsSid}" />

	<input type="hidden" name="command" value="<%=bm.getCommand() %>"/>
	<input type="hidden" name="startPage" value="<%=bm.getPageNum() %>"/>
	<input type="hidden" name="pcode" value="<%=bm.getPcode() %>"/>
	<input type="hidden" name="sec_cate" id="sec_cate" value=""/>
	
	<%
		if(bm.getCommand() != null && (bm.getCommand().equals("update") || bm.getCommand().equals("reply")))
		{
			%>			
			<input type="hidden" name="dataSid" value="<%=bm.getDataSid() %>"/>			
			<%
		}
	%>
<%
String boardTitle = (bm.getBoardVO()).getBoardTitle();
%>


			<section class="board">
				<fieldset>
					<legend>게시글 입력</legend>

					<p class="board_point"><span>*</span> 표시가 있는 항목은 필수 입력항목입니다.</p>
					<table class="board_write"  summary="게시글에 대한 정보를 입력합니다.">   
<caption>게시글 입력</caption>
				<tbody>
							<tr>
								<th scope="row" class="topline"><label for="dataTitle"><span>*</span>제 목</label></th>
								<td class="topline"><input type="text" name="dataTitle" id="dataTitle" value="<%=bm.getDataTitle() %>" style="width:95%"/></td>

							</tr>

							<tr>
								<th scope="row" ><label for="userNick"><span>*</span>작 성 자</label></th>
								<!--<td><input name="userNick" id="userNick" value="이찬희" title="작성자" readonly="Readonly" type="text"></td>-->
								<td>

					<%
					if(!bm.isManager())
					{
						if(bm.getCommand() != null && "update".equals(bm.getCommand()))
						{
							%>
							<input type="text" name="userNick" id="userNick" value="<%=bm.getUserNick() %>" />
							<%
						}else{
							if(bm.getSUserName() != null && !"".equals(bm.getSUserName()))
							{
								%>
								<input type="text" name="userNick" id="userNick" value="<%=bm.getSUserName() %>" />
								<%
							}else{
								%>
								<input type="text" name="userNick" id="userNick" value="" />
								<%
							}
						}
					}else{
						if(bm.getCommand() != null && "update".equals(bm.getCommand()))
						{
							%>
							<input type="text" name="userNick" id="userNick" value="<%=bm.getUserNick() %>" />
							<%
						}else{
							%>
							<input type="text" name="userNick" id="userNick" value="<%=bm.getSUserName() %>" />
							<%
						}						
					}
					%>								
								
								</td>
							</tr>
            


							<%					
			int extensionCount = bm.extensionCount();
			for(int i=0;i<extensionCount;i++)
			{
				bm.setExtensionVO(i);
				%>
				<tr>
					<th scope="row"><label for="<%=bm.getExtensionKey()%>"><%=bm.getExtensionDesc() %></label></th>
					<td>
						<%=bm.getExtensionTag("","","")%>
					</td>
				</tr>
				<%
			}
			%>
			<%
			if(bm.isBoardNoticeCf() && bm.isManager())
			{
				%>
				<tr>
					<th scope="row"><label for="dataNotice">공지글</label></th>
					<td><input type="checkbox" name="dataNotice" id="dataNotice" value="true" <%=bm.isNotice() == true ? "checked" : ""%>/> 공지</td>
				</tr>
				<%
						if(bm.isBoardDateIsUseCf()){
					%>
						<!-- <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.13/themes/humanity/jquery-ui.css" type="text/css" media="all" />
						<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js" type="text/javascript"></script>
						<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.13/jquery-ui.min.js" type="text/javascript"></script>
						<style>
							 .ui-datepicker{
								 font-size : 16px;
								 width : 230px; 
							 }
							 .ui-datepicker select.ui-datepicker-month{
								 width:30%;  
								 font-size: 13px;
							 }
						
							 .ui-datepicker select.ui-datepicker-year{
								 width:40%;     
								 font-size: 13px; 
							 }
						</style>
							<script type="text/javascript">
								function CheckDate(pDate){
									var mDate = pDate.split("-");
									var mTimeStampe = new Date(mDate[0],mDate[1],mDate[2]).getTime();
									return mTimeStampe;
								}

							function OnClear(pObj){
								pObj.value="";
							}
							$(function() {
							
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
							
							     $( "#start_dt" ).datepicker({
							          dateFormat: 'yy-mm-dd',  //데이터 포멧형식
							          minDate: '-30M',      //오늘 부터 3달전까지만 선택 할 수 있다.
							          maxDate: '+36M',     //오늘 부터 36개월후까지만 선택 할 수 있다.
							          changeMonth: true,    //달별로 선택 할 수 있다.
							          changeYear: true,     //년별로 선택 할 수 있다.
							          showOtherMonths: false,  //이번달 달력안에 상/하 빈칸이 있을경우 전달/다음달 일로 채워준다.
							          selectOtherMonths: true, 
							          showButtonPanel: true  //오늘 날짜로 돌아가는 버튼 및 닫기 버튼을 생성한다.
							     });
							     $( "#end_dt" ).datepicker({
							          dateFormat: 'yy-mm-dd',  //데이터 포멧형식
							          minDate: '-30M',      //오늘 부터 3달전까지만 선택 할 수 있다.
							          maxDate: '+36M',     //오늘 부터 36개월후까지만 선택 할 수 있다.
							          changeMonth: true,    //달별로 선택 할 수 있다.
							          changeYear: true,     //년별로 선택 할 수 있다.
							          showOtherMonths: false,  //이번달 달력안에 상/하 빈칸이 있을경우 전달/다음달 일로 채워준다.
							          selectOtherMonths: true, 
							          showButtonPanel: true  //오늘 날짜로 돌아가는 버튼 및 닫기 버튼을 생성한다.
							     });
							});
							</script> -->
											
							<tr>
								<th scope="row">개시기간</th>
								<td colspan="5">
									시작일 : <input id="start_dt" name="start_dt" type="text" class="calendar" onclick="javascript:OnClear(this);"  onchange="Date_Check(this);" size="20" title="시작일" readonly="readonly"  value="<%=bm.getStart_dt("yyyy-MM-dd") %>"/> ~ 종료일 : <input id="end_dt" name="end_dt" type="text" class="calendar" onclick="javascript:OnClear(this);"  onchange="Date_Check(this);" size="20" title="종료일" readonly="readonly"  value="<%=bm.getEnd_dt("yyyy-MM-dd") %>"/>
								</td>
							</tr>
				<%
						}
			}%>
			<%
			if(bm.isBoardIsSecretCf())
			{
				%>
				<tr>
					<th scope="row"><label for="dataSecret">비밀글</label></th>
					<td><input type="checkbox" name="dataSecret"  id="dataSecret" value="true" <%=bm.isSecret() == true ? "checked" : ""%>/> 비밀글</td>
				</tr>
				<%
			}%>
			<%
			if(bm.getSUserId().equals(""))
			{
				%>
				<tr>
					<th scope="row"><label for="userPw">패스워드</label></th>
					<td><input type="text" name="userPw" id="userPw" value="" /></td>
				</tr>
				<%
			}%>
			<%
			if(bm.isWriteItem("CATEGORY_CODE1") || bm.isWriteItem("CATEGORY_CODE2") || bm.isWriteItem("CATEGORY_CODE3")) {
			if( (categoryList1 != null && categoryList1.size() > 0) || (categoryList2 != null && categoryList2.size() > 0) || (categoryList3 != null && categoryList3.size() > 0))
			{ 
				%>
					<%if(bm.getMenuIsBoard1Cate()||bm.getMenuIsBoard2Cate()||bm.getMenuIsBoard3Cate()) {%>
					
					<tr <%if("BBS_0000212".equals(bm.getBoardId())){ %>style="display:none;"<%} %>>
					<th scope="row"><span>*</span>카테고리</th>
					<td>
					<%} %>
						<% 
						if(bm.isWriteItem("CATEGORY_CODE1") && categoryList1 != null && categoryList1.size() > 0){ 
							if(bm.getMenuIsBoard1Cate()){
						%>
								<select name="categoryCodeData1" id="categoryCodeData1" class="layout_select" title="카테고리1" onchange="changeCate(this)">
								<option value="">1차 카테고리</option>
						<% 
								for(BoardCategoryVO category : categoryList1){ 
										if(!category.getCategoryName().equals("noview")){
						%>
											<option value="<%=category.getCategoryCode()%>" <%if(bm.getCategoryCode1().equals(category.getCategoryCode()))out.print("selected");%>><%=category.getCategoryName()%></option>
						<% 
										}
								} 
						%>
								</select>
						<%
							}else{
						%>
								<input type="hidden" name="categoryCodeData1" id="categoryCodeData1" value="<%=bm.getCategoryCode1()%>"  title="카테고리1"/>
						<%
							}
						}
					
						%>


						<% 
						if(bm.isWriteItem("CATEGORY_CODE2") && categoryList2 != null && categoryList2.size() > 0){ 
							if(bm.getMenuIsBoard2Cate()){
						%>
							<select name="categoryCodeData2" id="categoryCodeData2" class="layout_select"  title="카테고리2">
							<option value="">2차 카테고리</option>
						<% 
							for(BoardCategoryVO category2 : categoryList2){
								if(!category2.getCategoryName().equals("noview")){
						%>
								<option value="<%=category2.getCategoryCode()%>" <%if(bm.getCategoryCode2().equals(category2.getCategoryCode()))out.print("selected");%>><%=category2.getCategoryName()%></option>
						<% 
								}
							} 
						%>
							</select>
						<%
							}else{
						%>
							<input type="hidden" name="categoryCodeData2" id="categoryCodeData2" value="<%=bm.getCategoryCode2()%>"  title="카테고리2"/>
						<%
							}
						}
						%>

						<% 
						if(bm.isWriteItem("CATEGORY_CODE3") && categoryList3 != null && categoryList3.size() > 0){ 
							if(bm.getMenuIsBoard3Cate()){
								
						%>
							<select name="categoryCodeData3" id="categoryCodeData3" class="layout_select"  title="카테고리3">
							<option value="">3차 카테고리</option>
						<% 
							for(BoardCategoryVO category3 : categoryList3){
								if(!category3.getCategoryName().equals("noview")){
						%>
								<option value="<%=category3.getCategoryCode()%>" <%if(bm.getCategoryCode3().equals(category3.getCategoryCode()))out.print("selected");%>><%=category3.getCategoryName()%></option>
						<% 
								}
							} 
						%>
							</select>
						<%
							}else{
						%>
							<input type="hidden" name="categoryCodeData3" id="categoryCodeData3" value="<%=bm.getCategoryCode3()%>"  title="카테고리3"/>
						<%
							}
						}
						%>
						<%if(bm.getMenuIsBoard1Cate()||bm.getMenuIsBoard2Cate()||bm.getMenuIsBoard3Cate()) {%>
					</td>
				</tr>
				<%}%>
				<%
			}
			}
			%>

<% if(bm.isWriteItem("USER_EMAIL")) { %>
            <tr>
                <th scope="row"><label for="userEmail">이메일</label></th>
                <td><input type="text" name="userEmail" value="<%=EgovStringUtil.isNullToString(bm.getUserEmail())%>" style="width:50%" id="userEmail" /></td>
            </tr>
            <% } %>
            <% if(bm.isWriteItem("USER_HOMEPAGE")) { %>
            <tr>
                <th  scope="row"><label for="userHomepage">홈페이지</label></th>
                <td><input type="text" name="userHomepage" value="<%=EgovStringUtil.isNullToString(bm.getUserHomepage())%>" style="width:99%" id="userHomepage" /></td>
            </tr>
            <% } %>
            <% if(bm.isWriteItem("USER_TEL")) { %>
            <tr>
                <th  scope="row"><label for="userTel">전화번호</label></th>
                <td><input type="text" name="userTel" value="<%=EgovStringUtil.isNullToString(bm.getUserTel())%>" style="width:50%" id="userTel" /></td>
            </tr>
            <% } %>
			 <% if(bm.isWriteItem("USER_CEL")) { %>
            <tr>
                <th scope="row"><label for="userCel">핸드폰번호</label></th>
                <td><input type="text" name="userCel" value="<%=EgovStringUtil.isNullToString(bm.getUserCel())%>" style="width:50%" id="userCel" /></td>
            </tr>
            <% } %>
            <% if(bm.isWriteItem("USER_ZIPCODE")) { %>
            <tr>
                <th  scope="row"><label for="userZipcode">우편번호</label></th>
                <td><input type="text" name="userZipcode" value="<%=EgovStringUtil.isNullToString(bm.getUserZipcode())%>" style="width:50%" id="userZipcode" /></td>
            </tr>
            <% } %>
            <% if(bm.isWriteItem("USER_ADDRESS")) { %>
            <tr>
                <th  scope="row"><label for="userAddress">주소</label></th>
                <td><input type="text" name="userAddress" value="<%=EgovStringUtil.isNullToString(bm.getUserAddress())%>" style="width:99%" id="userAddress" /></td>
            </tr>
            <% } %>
            <% if(bm.isWriteItem("USER_DETAILADDR")) { %>
            <tr>
                <th  scope="row"><label for="userDetailAddr">상세주소</label></th>
                <td><input type="text" name="userDetailAddr" value="<%=EgovStringUtil.isNullToString(bm.getUserAddress())%>" style="width:99%" id="userDetailAddr" /></td>
            </tr>
            <% } %>
           
            <% if(bm.isWriteItem("TMP_FIELD1")) { %>
           <%if("BBS_0000215".equals(bm.getBoardId())){ %>
            <tr>
                <th scope="row"><label for="tmpField1">보도요청일자</label></th>
                <td><input type="text" name="tmpField1" value="<%=EgovStringUtil.isNullToString(bm.getTmpField1())%>" style="width:25%" id="tmpField1" readonly="readonly" /></td>
            </tr>
            <%} %>
            <% } %>
            <% if(bm.isWriteItem("TMP_FIELD2")) { %>
            <tr>
                <th scope="row"><label for="tmpField2">임시필드2</label></th>
                <td><input type="text" name="tmpField2" value="<%=EgovStringUtil.isNullToString(bm.getTmpField2())%>" style="width:99%" id="tmpField2" /></td>
            </tr>
            <% } %>
            <% if(bm.isWriteItem("TMP_FIELD3")) { %>
            <tr>
                <th scope="row"><label for="tmpField3">임시필드3</label></th>
                <td><input type="text" name="tmpField3" value="<%=EgovStringUtil.isNullToString(bm.getTmpField3())%>" style="width:99%" id="tmpField3" /></td>
            </tr>
            <% } %>
            <% if(bm.isWriteItem("TMP_FIELD4")) { %>
            <tr>
                <th scope="row"><label for="tmpField4">임시필드4</label></th>
                <td><input type="text" name="tmpField4" value="<%=EgovStringUtil.isNullToString(bm.getTmpField4())%>" style="width:99%" id="tmpField4" /></td>
            </tr>
            <% } %>
            <% if(bm.isWriteItem("TMP_FIELD5")) { %>
            <tr>
                <th scope="row"><label for="tmpField5">임시필드5</label></th>
                <td><input type="text" name="tmpField5" value="<%=EgovStringUtil.isNullToString(bm.getTmpField5())%>" style="width:99%" id="tmpField5" /></td>
            </tr>
            <% } %>
			
			<% if(!"C".equals(bm.getCategoryCode1()) && !"D".equals(bm.getCategoryCode1()) && !"E".equals(bm.getCategoryCode1())){%>
			<tr>
                <th  scope="row"><label for="userHomepage">담당부서</label></th>
                <td><input type="text" name="userHomepage" value="<%=EgovStringUtil.isNullToString(bm.getUserHomepage())%>" id="userHomepage" /></td>
            </tr>
			<%} %>

			<%
			if(bm.getFileCount() >0){
			if(bm.getCommand() != null && bm.getCommand().equals("update"))
			{
				%>
				<tr>
					<th scope="row">첨부파일</th>
					<td>
						<%=bm.getFileList("<span title=\"첨부파일:{fileName}\"><a href=\"{fileDelete}\" onclick=\"Javascript:if(confirm('선택한 첨부파일을 삭제 하시겠습니까?')) return true; else return false;\" onkeypress=\"if(event.keyCode == 13){return confirm('선택한 첨부파일을 삭제 하시겠습니까?');}\">{fileMemo} {fileName} ({fileSize}) </a><a style=\"color:red\" href=\"{fileDelete}\" onclick=\"Javascript:if(confirm('선택한 첨부파일을 삭제 하시겠습니까?')) return true; else return false;\">삭제</a></span><br/>")%>
					</td>
				</tr>
				<%
			}}%>



							<tr>
								<th scope="row">내 용</th>
								<td><textarea name="dataContent" id="dataContent" style="width:95%; height:400px" rows="5" cols="50" title="내용"><%=bm.getDataContent()%></textarea>
							<% if(bm.isBoardEditor()){ %>
								<script type="text/javascript">
								createEditor("dataContent,<%=request.getContextPath() %>/SmartEditor2/SEditorSkin.html");
								</script>
							<% } %>	 
								</td>
							</tr>
							<tr>
								<th scope="row">첨부화일</th>
								<td>
									
									<%=bm.getFileUpload() %>

<!--										<label for="upload0" class="none">첨부파일</label><input name="upload" id="upload0" title="첨부파일" type="file" style="width:95%;" />
										<label for="upload1" class="none">첨부파일</label><input name="upload" id="upload1" title="첨부파일" type="file" style="width:95%;" />
										<label for="upload2" class="none">첨부파일</label><input name="upload" id="upload2" title="첨부파일" type="file" style="width:95%;" />-->
									
								</td>
							</tr>			   
						</tbody>
					</table>
					<p class="read_page" style="margin:20px 0px;">

	<!--RFC 공통 버튼 시작-->
	<div class="rfc_bbs_btn">
		<%=bm.getWriteIcons()%>
	</div><br /><br />

	<!--RFC 공통 버튼 끝-->

<!--						<a href="#">&lt; 목록</a><a href="#" class="btn_blue">수정</a><a href="#" class="btn_gray">취소</a>-->
					</p>

				</fieldset>
			</section>
			<!-- board_write -->

</form>