<%@ page import="java.util.*, egovframework.rfc3.board.vo.BoardVO, egovframework.rfc3.board.vo.BoardCategoryVO"%>
<%@ page import="egovframework.rfc3.menu.vo.MenuVO" %>
<%@ page import="egovframework.rfc3.common.util.EgovStringUtil" %>
<%@ page import="egovframework.rfc3.common.util.CommonUtil" %>
<%@ page import="egovframework.rfc3.office.web.OfficeManager"%>
<%@ page import="egovframework.rfc3.user.vo.*"%>
<%@ page import="egovframework.rfc3.office.vo.OfficeVO"%>
<%@ page import="egovframework.rfc3.board.vo.BoardDataVO"%>
<%
	List<BoardCategoryVO> categoryList1 = bm.getCategoryList1();
	List<BoardCategoryVO> categoryList2 = bm.getCategoryList2();
	List<BoardCategoryVO> categoryList3 = bm.getCategoryList3();

	MenuVO currentMenuVO1 = cm.getMenuVO();
	
	OfficeManager office = new OfficeManager(request);
	OfficeVO officevo = new OfficeVO();
	String officename = "";
	String officepart = "";

	long oid = 0;
	String officeTel =  "";
	String offiCd1 = "";
	try {
		officevo = office.getOfficeInfo(sm.getOrgnztId());
		officename = office.getOfficeName(sm.getOrgnztId(), 1);
		officepart = office.getOfficeName(sm.getOrgnztId(), 2);
	    oid = Long.parseLong(sm.getOrgnztId());

		office.setOfficePartInfo(oid);
		officeTel = office.getOfficePartTel();

		
		if(officeTel.equals("")) {
			UserManageVO userVO=null ;
			userVO = (UserManageVO)cm.getUserInfo();

			//officeTel = userVO.getAreaNo() + "-" + userVO.getMiddleTelno() + "-" + userVO.getEndTelno();
			officeTel = EgovStringUtil.isNullToString(userVO.getAreaNo()) + EgovStringUtil.isNullToString(userVO.getMiddleTelno()) + EgovStringUtil.isNullToString(userVO.getEndTelno());
		}
		
		offiCd1 = sm.getOrgnztId().substring(0,4);

	} catch(Exception e) { }
	
	//--회원로그인 정보 (연락처)
	MberManageVO userVO = null ;
	
	// 회원정보 불려오기
	if(sm.getUserSe().equals("GNR")){
	userVO = (MberManageVO)cm.getUserInfo();
	}

	if(userVO == null) userVO = new MberManageVO();
	
%>

<script type="text/javascript">	

//첨부파일 용량 체크 1--------------------------------------------------------------------
var maxFileSize = <%=bm.getBoardFileSizeCf()%> * 1024 * 1024;
var fileSizeList = new Array(0,0,0,0,0,0,0,0,0,0);
$(function(){
	$("input[name=upload]").each(function(i){
		$(this).bind("change", function() {
			if($(this).val()!=""){
				fileSizeList[i] = this.files[0].size;
			}else{
				fileSizeList[i] = 0;
			}
		});
	});
});
//---------------------------------------------------------------------------------------

	function formSubmit(f)
	{

		//첨부파일 용량 체크 2--------------------------------------------------------------------
		var currentFileSize = 0;
		for(i=0;i<fileSizeList.length;i++){
			currentFileSize += fileSizeList[i];
		}

		if(currentFileSize > maxFileSize){
		   alert("첨부파일 사이즈는 <%=bm.getBoardFileSizeCf()%>MB 이내로 등록 가능합니다. ");
		   return false;
		}
		//---------------------------------------------------------------------------------------

		if(f.dataTitle.value == '')
		{
			alert("제목을 입력하시기 바랍니다.");
			f.dataTitle.focus();
			return false;
		}

		
		if(f.userCel1.value == '' || f.userCel2.value == '' || f.userCel3.value == '')
		{
			alert("전화번호를 입력하시기 바랍니다.");
			
			if(f.userCel1.value == ''){
				f.userCel1.focus();
			}else if(f.userCel2.value == ''){
				f.userCel2.focus();
			}else{
				f.userCel3.focus();
			}
			
			return false;
		}

	<%if(bm.getDataDep()==1 && !bm.getCommand().equals("reply")){ %>
			/* if(f.userTel1.value == '')
			{
				alert("연락처를 입력하시기 바랍니다.");
				f.userTel.focus();
				return false;
			} */
			
			if(f.userTel1.value == '' || f.userTel2.value == '' || f.userTel3.value == '')
			{
				alert("연락처를 입력하시기 바랍니다.");
				
				if(f.userTel1.value == ''){
					f.userTel1.focus();
				}else if(f.userTel2.value == ''){
					f.userTel2.focus();
				}else{
					f.userTel3.focus();
				}
				
				return false;
			}
			
			if(f.userAddress.value == ''){
				
				alert("주소를 입력하시기 바랍니다.");
				f.userAddress.focus();
				return false;
				
			}

	<%}%>
	<%
	if(bm.getCommand() != null && (bm.getCommand().equals("update") || bm.getCommand().equals("reply")))
	{ } else {
	%>
				if(f.adminReplyNotice.value == 'Y')
				{
					//접수로 수정
					f.categoryCodeData1.value = 'A';
				}
				if(f.adminReplyNotice.value == 'N')
				{
					//답변요청안함
					f.categoryCodeData1.value = 'E';
				}
	<% } %>
	
		
		if(CKEDITOR.instances.dataContent.getData() == '')
		{
			alert("내용을 입력하시기 바랍니다.");
			CKEDITOR.instances.dataContent.focus();
			return false;
		}
		<% if(!bm.isManager()) { %>
		if(!f.pCheck1.checked){
			
			alert("개인정보 수집 및 이용 동의하셔야 됩니다");
			f.pCheck1.focus();
			
			return false;
		}
		<% } %>
		if(f.submitCheck.value=='true') {
			alert('게시글 작성 중 입니다. 잠시만 기다려주세요.');
			return false;			
		} 
		if(f.submitCheck.value=='false') {
			f.submitCheck.value = 'true';
		}

		return true;
	
	}
	
	function goPopup(){   
		// 주소검색을 수행할 팝업 페이지를 호출합니다.
		// 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(http://www.juso.go.kr/addrlink/addrLinkUrl.do)를 호출하게 됩니다.
		var pop = window.open("/index.gyeong?contentsSid=1832","pop","width=570,height=420, scrollbars=yes, resizable=yes");
	}

    function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
        // 팝업페이지에서 주소입력한 정보를 받아서, 현 페이지에 정보를 등록합니다.
		$('#userZipcode').val(zipNo);
        $('#userAddress').val(roadAddrPart1 + ' ' + roadAddrPart2 + ' ' + addrDetail);
        //$('#userDetailAddr').val(roadAddrPart2 + ' ' + addrDetail);
        return false;
    }
    
    function f_celnumber() {
    	
		var s_userCel1 = $('#userCel1').val();
		var s_userCel2 = $('#userCel2').val();
		var s_userCel3 = $('#userCel3').val();
		var s_userCel = $('#userCel').val();
		
		s_userCel = s_userCel1 +'-'+ s_userCel2 +'-'+ s_userCel3;
		
		$('#userCel').val(s_userCel); 
	}
    
  function f_telnumber() {
    	
		var s_userTel1 = $('#userTel1').val();
		var s_userTel2 = $('#userTel2').val();
		var s_userTel3 = $('#userTel3').val();
		var s_userTel = $('#userTel').val();
		
		s_userTel = s_userTel1 +'-'+ s_userTel2 +'-'+ s_userTel3;
		
		$('#userTel').val(s_userTel); 
	}
    
    

</script>
<!-- s : BOARD -->
<script type="text/javascript" src="/ckeditor4/ckeditor.js"></script>
<%
//답변글 [수정] 체크
boolean isReply = false;
if(bm.getCommand() != null && bm.getCommand().equals("reply")) {
	isReply = true;
}
if(bm.getCommand() != null && bm.getCommand().equals("update")) {
	//1보다 크면 답변
	if(bm.getDataDep()>1) {
		isReply = true;
	}
}
%>
<%--
[<%=isReply%>]
[<%=bm.getDataDep()%>] 
 --%>
<form onsubmit="return formSubmit(this);" method="post" action="<%=request.getContextPath() %>/board/<%=bm.getCommand() != null && bm.getCommand().equals("update") ? "updateAct" : "writeAct"%>.<%=bm.getUrlExt()%>" enctype="multipart/form-data">
	<input type="hidden" name="orderBy" value="<%=bm.getOrderBy()%>" />
	<input type="hidden" name="boardId" value="<%=bm.getBoardId()%>" />
	<input type="hidden" name="searchStartDt" value="<%=bm.getSearchStartDt()%>" />
	<input type="hidden" name="searchEndDt" value="<%=bm.getSearchEndDt()%>" />
	
	<input type="hidden" name="menuCd" value="${menuCd}" />
	<input type="hidden" name="contentsSid" value="${contentsSid}" />

	<input type="hidden" name="command" value="<%=bm.getCommand() %>"/>
	<input type="hidden" name="startPage" value="<%=bm.getPageNum() %>"/>
	<input type="hidden" name="pcode" value="<%=bm.getPcode() %>"/>
	<input type="hidden" name="tmpField19" value="<%=EgovStringUtil.isNullToString(bm.getTmpField19())%>"  />
	<input type="hidden" name="tmpField20" value="<%=EgovStringUtil.isNullToString(bm.getTmpField20())%>"  />
	<%if(!bm.getCommand().equals("update")){%>
		<input type="hidden" name="backupUserNick" value="<%=om.getOfficeName(sm.getOrgnztId(),3)%>"/>
	<%}%>

	<%
		if(bm.getCommand() != null && (bm.getCommand().equals("update") || bm.getCommand().equals("reply")))
		{
			%>			
			<input type="hidden" name="dataSid" value="<%=bm.getDataSid() %>"/>			
			<%
		}
	%>
	<!-- submit 한번만 하세요! -->
	<input type="hidden" name="submitCheck" value="false"/>
	
	<%-- 
		비밀글(신고게시판)/처리게시판(경남도청에 바란다) 공유해서 사용중,
	    - 답변요청, 비밀글 
	 --%>
	
	<%
 
			//처리게시판인경우
			if(bm.getDataDep()==1 && !bm.getCommand().equals("reply"))
			{}else{ //답글일때 답변유무값(N:답변요청안함)
			%>
			<input type="hidden" name="adminReplyNotice" value="N"/>
		<%
			}
		
	%>
<div class="board write"><!-- Add : write -->
	<p class="ess-1"><span class="star">*</span> 표시된 항목은 필수 입력 항목입니다.</p>
	<table class="basicWrite"><!-- basicWrite -->
		<caption><%=currentMenuVO1.getMenuNm()%> 의 글쓰기 페이지 </caption>
		<colgroup>
			<col style="width:15%;" />
			<col style="width:*%;" />
		</colgroup>
		<tbody>
		
			<tr>
				<th scope="row"><span class="star">*</span><label for="fieldTitle">제목</label></th>
				<td><input type="text" name="dataTitle" id="fieldTitle" value="<%=bm.getDataTitle() %>" /></td>
			</tr>
			<tr>
				<%
				String userNick = "";
				String userNickTitle = "작성자";
				if(isReply) {
					userNickTitle = "담당부서";
					if(bm.getCommand() != null && "update".equals(bm.getCommand())) {
						userNick = bm.getUserNick();
					} else {
						userNick = officename;
					}
				} else { } 
				%>
				<th scope="row"><span class="star">*</span><label for="w1"><%=userNickTitle %></label></th>
				<td>
				<%
				if(isReply) {
				%>
				<input type="text" name="userNick" id="userNick" value="<%=userNick %>" />
				<%
				} else {
					
				
					if(!bm.isManager())
					{
						if(bm.getCommand() != null && "update".equals(bm.getCommand()))
						{
							%>
							<%=bm.getUserNick() %>
							<input type="hidden" name="userNick" id="w1" value="<%=bm.getUserNick() %>" />
							<%
						}else{
							if(bm.getSUserName() != null && !"".equals(bm.getSUserName()))
							{
								%>
								<%=bm.getSUserName() %>
								<input type="hidden" name="userNick" id="w1" value="<%=bm.getSUserName() %>" />
								<%
							}else{
								%>
								<input type="text" name="userNick" id="w1"/>
								<%
							}
						}
					}else{
						if(bm.getCommand() != null && "update".equals(bm.getCommand()))
						{
							%><%=bm.getUserNick() %>
							<input type="hidden" name="userNick" id="w1" value="<%=bm.getUserNick() %>" />
							<%
						}else{
							%><%=bm.getSUserName() %>
							<input type="hidden" name="userNick" id="w1" value="<%=bm.getSUserName() %>" />
							<%
						}						
					}
				}
				%>
				</td>
			</tr>
			<% 
			String PNAME = bm.getExtensionValue("PNAME");
			if(bm.getCommand() != null && "update".equals(bm.getCommand())) {
				PNAME = bm.getExtensionValue("PNAME");
			} else { 
				PNAME = bm.getSUserName();
			}
				
			String command = EgovStringUtil.isNullToString(bm.getCommand());
			//if(bm.getBoardId().equals("BBS_0000388")) { 
				if(isReply) {
			%>
			<tr>
				<th scope="row"><span class="star">*</span><label for="PNAME">담당자명</label></th>
				<td>
					<input type="text" name="PNAME" id="PNAME" value="<%=PNAME%>" class="input_v2"/>
				</td>
			</tr>
			<% } 
				//} %>
			<%if(bm.isWriteItem("USER_EMAIL")) {%>
			<tr>
				<th scope="row"><label for="userEmail">이메일</label></th> 
				<td>
						<input type="text" name="userEmail" id="userEmail" value="<%=EgovStringUtil.isNullToString(bm.getUserEmail()) %>" />
						<%if(bm.getDataDep()==1 && !bm.getCommand().equals("reply")){ %>
						<div class="ntc"><!-- ntc -->
								<input type="checkbox" id="userJumin2" name="userJumin2" value="1" <%=toINT(bm.getUserJumin2())== 1 ? "checked" : ""%>>
								<label for="userJumin2">응답여부 메일수신</label>
						</div>
						<%} %>
				</td>
			</tr>
			<%}%>
			<% 
			String s_getId = EgovStringUtil.isNullToString(sm.getId());
			
			//전화번호 
			String getUserCel = "";						
			String mUserCel = "";	

			String userCel1 = "";
			String userCel2 = "";
			String userCel3 = "";
			
			//핸드폰
			String getUserTel = "";
			String mUserTel = "";	

			String userTel1 = "";
			String userTel2 = "";
			String userTel3 = "";
			
			
			if(bm.getCommand() != null && bm.getCommand().equals("reply")) {
				
				getUserCel = EgovStringUtil.isNullToString(officeTel);  //관리자 답변

				
			} else {
				
				mUserCel = EgovStringUtil.isNullToString(bm.getUserCel()); //사용자 전화번호
				
				mUserTel = EgovStringUtil.isNullToString(bm.getUserTel()); //사용자 폰번호
				
				
				//전화번호
				if(!mUserCel.equals("")){
					
					getUserCel = mUserCel.replaceAll("-", "");
					
				}else{
					
					if(s_getId.length() < 40){
						//회원로그인
						getUserCel = EgovStringUtil.isNullToString(userVO.getMoblfristNo())+EgovStringUtil.isNullToString(userVO.getMoblmiddleNo())+EgovStringUtil.isNullToString(userVO.getMoblendNo());
					
					}else{
						getUserCel = (String)session.getAttribute("cellNo"); //폰 본인인증 연락처
					}	
					 
				}
	
				//폰번호
				if(mUserTel.equals("")){
					

					if(s_getId.length() < 40){
						
						//회원로그인
						getUserTel = EgovStringUtil.isNullToString(userVO.getMoblfristNo())+EgovStringUtil.isNullToString(userVO.getMoblmiddleNo())+EgovStringUtil.isNullToString(userVO.getMoblendNo());

						
					}else{
						
						getUserTel = (String)session.getAttribute("cellNo"); //폰 본인인증 연락처 
					}

					
					//session.removeAttribute("cellNo"); //submit 하기전에 세션 삭제
					
				}else{
					
					getUserTel = mUserTel.replaceAll("-", "");
				}
				
				
			}
			
			//전화번호 체크
			 if(!EgovStringUtil.isNullToString(getUserCel).equals("")){
				 
				 if(getUserCel.length() == 11){
					 
						
						userCel1 = getUserCel.substring(0, 3);
						userCel2 = getUserCel.substring(3, 7);
						userCel3 = getUserCel.substring(7, 11);
				 }
				 
				 if(getUserCel.length() == 10){
					 
						
						userCel1 = getUserCel.substring(0, 3);
						userCel2 = getUserCel.substring(3, 6);
						userCel3 = getUserCel.substring(6, 10);
				 }
				 
				 getUserCel = userCel1+ "-"+ userCel2 + "-" + userCel3;
			}
			
			//연락처 체크
			 if(!EgovStringUtil.isNullToString(getUserTel).equals("")){
					 
					if(getUserTel.length() == 11){
						
						userTel1 = getUserTel.substring(0, 3);
						userTel2 = getUserTel.substring(3, 7);
						userTel3 = getUserTel.substring(7, 11);
					
					 }
					
					 if(getUserTel.length() == 10){
						 
							
						 userTel1 = getUserTel.substring(0, 3);
						 userTel2 = getUserTel.substring(3, 6);
						 userTel3 = getUserTel.substring(6, 10);
					 }
					
					getUserTel = userTel1+ "-"+ userTel2 + "-" + userTel3;
					
				}
			
			if(bm.isWriteItem("USER_CEL")) { 
			
			%>
			<tr>
				<th scope="row"><span class="star">*</span>전화번호</th>
				<td>
					<label for="userCel1" class="blind">전화번호 첫번째 자리</label>
					<input type="text" name="userCel1" id="userCel1" value="<%=userCel1%>" class="input_v2" onchange="f_celnumber()" maxlength="3"/>-
					<label for="userCel2" class="blind">전화번호 두번째 자리</label>
					<input type="text" name="userCel2" id="userCel2" value="<%=userCel2%>" class="input_v2" onchange="f_celnumber()" maxlength="4"/>-
					<label for="userCel3" class="blind">전화번호 세번째 자리</label>
					<input type="text" name="userCel3" id="userCel3" value="<%=userCel3%>" class="input_v2" onchange="f_celnumber()" maxlength="4"/>
					<input type="hidden" name="userCel" id="userCel" value="<%=EgovStringUtil.isNullToString(getUserCel)%>" class="input_v2"/>
					<!-- <div class="ntc">
						<p>※ 055-0000-0000 형식으로 입력 하세요.</p>
					</div> -->
				</td>
			</tr>
			<%}%>
			<% 
				
				
				if(bm.isWriteItem("USER_TEL")) {
					if(bm.getDataDep()==1 && !bm.getCommand().equals("reply")){ 
			%>
					<tr>
						<th scope="row"><span class="star">*</span>연락처</th>
						<td>
							<label for="userTel1" class="blind">연락처 첫번째 자리</label>
							<input type="text" name="userTel1" id="userTel1" value="<%=userTel1%>" class="input_v2" onchange="f_telnumber()" maxlength="3"/>-
							<label for="userTel2" class="blind">연락처 두번째 자리</label>
							<input type="text" name="userTel2" id="userTel2" value="<%=userTel2%>" class="input_v2" onchange="f_telnumber()" maxlength="4"/>-
							<label for="userTel3" class="blind">연락처 세번째 자리</label>
							<input type="text" name="userTel3" id="userTel3" value="<%=userTel3%>" class="input_v2" onchange="f_telnumber()" maxlength="4"/>
							<input type="hidden" name="userTel" id="userTel" value="<%=EgovStringUtil.isNullToString(getUserTel)%>" class="input_v2"/>
							<div class="ntc"><!-- ntc -->
										<p>※ 귀하의 연락처는 처리부서 및 담당자에 통보됩니다.</p>
										<input type="checkbox" id="userJumin1" name="userJumin1" value="1" <%=toINT(bm.getUserJumin1())== 1 ? "checked" : ""%>>
										<label for="userJumin1">응답여부 SMS수신</label>
							</div>
						</td>
					</tr>
			<%
					}else{

			%>
							<tr>
								<th scope="row"><label for="userJumin1">SMS발송여부</label></th>
								<td>
									<input type="checkbox" id="userJumin1" name="userJumin1" value="1" <%=toINT(bm.getUserJumin1())== 1 ? "checked" : ""%>><label for="userJumin1">SMS발송여부</label>
								</td>
							</tr>
			<%
					}
				}
			%>
			<% 
				if (bm.isWriteItem("USER_ADDRESS")) {
					if(bm.getDataDep()==1 && !bm.getCommand().equals("reply")){ 
			%>
			<tr>
				<th scope="row"><span class="star">*</span><label for="userAddress">주소</label></th>
				<td>
				<label for="userZipcode" class="blind">우편번호</label>
				<input type="text" name="userZipcode" id="userZipcode" value="<%=EgovStringUtil.isNullToString(bm.getUserZipcode()) %>" class="input_v2"/>
				<input type="button" id="confirm_id" value="우편번호찾기" onclick="goPopup()" title="새창">
				<input type="text" name="userAddress" id="userAddress" value="<%=EgovStringUtil.isNullToString(bm.getUserAddress())%>"/>
				<%-- <input type="text" name="userDetailAddr" id="userDetailAddr" value="<%=EgovStringUtil.isNullToString(bm.getUserDetailAddr())%>" /> --%>
				</td>
			</tr>
			<%
					}
				}
			%>
			<% if(bm.isBoardEditor()){%>
			<tr>
				<th scope="row"><label for="dataContent">내용</label></th>
				<td>
					<div class="ntc"><!-- ntc -->
							<p>※개인정보 보호를 위하여 주민등록번호, 주소, 전화번호 등을 글의 내용에 남기지 마시기 바랍니다.</p>
					</div>
					<textarea id="dataContent" cols="30" rows="10"  name="dataContent"><%=EgovStringUtil.isNullToString(bm.getDataContent())%></textarea>
					<script type="text/javascript">
						var editor = CKEDITOR.replace('dataContent',{filebrowserUploadUrl : '<%=request.getContextPath()%>/board/imageFileUpload.sko?boardId=<%=bm.getBoardId()%>'});
					</script> 
				</td>
			</tr>
			<%}%>
				    <%
				         //______________________________________________________ 수정상태 체크
				         if(bm.getCommand() != null && "update".equals(bm.getCommand())) {
				    %>
				             <tr>
				                 <th scope="row"><label for="attachFile-1">첨부파일</label></th>
				                 <td>
				                 	<% if(bm.getFileUploadCf()){ %>
				                  	<span style='color:red;'>※첨부파일 용량은 최대 <%=bm.getBoardFileSizeCf()%>mb까지 등록 가능합니다.</span><br>
				                  	<%} %>
				                      <%=bm.getFileList("<span title=\"첨부파일:{fileName}\">{fileMemo} {fileName} ({fileSize})</span><a href=\"{fileDelete}\" onclick=\"Javascript:if(confirm('선택한 첨부파일을 삭제 하시겠습니까?')) return true; else return false;\" onkeypress=\"if(event.keyCode == 13){return confirm('선택한 첨부파일을 삭제 하시겠습니까?');}\"><img src=\"/upload_data/board_data/BBS_0000231/151082078225137.png\" alt=\"삭제\"  /></a><br />")%>
				                 	 <%=bm.getFileUpload().replace("'file'","'file' class='input_text wr_wi400'")%>
				                 </td>
				             </tr>
				    <%}else{%>
							<tr>
				                   <th scope="row">파일첨부</th>
				                   <td>
				                   	<% if(bm.getFileUploadCf()){ %>
				                      <span style='color:red;'>※첨부파일 용량은 최대 <%=bm.getBoardFileSizeCf()%>mb까지 등록 가능합니다.</span><br>
				                     <%} %>
				                       <%=bm.getFileUpload().replace("'file'","'file' class='input_text wr_wi400'")%>
				                   </td>
				           </tr> 
				     <%} %>


		<%
		if(bm.isBoardNoticeCf() && bm.isManager())
		{
			%>
			<tr>
				<th scope="row"><label for="dataNotice">공지글</label></th>
				<td class="con_border"><input type="checkbox" name="dataNotice" id="dataNotice" value="true" <%=bm.isNotice() == true ? "checked" : ""%>/> 공지</td>
			</tr>
			<%
		}%>

		<%
		boolean isSecret = bm.isSecret();
		if(bm.isBoardIsSecretCf()) {
	        if(isReply) {
				//원본글 정보 가져오기
				BoardDataVO original = bm.getBoardDataVO(bm.getDataSid());
		        isSecret = original.isDataSecret(); //비밀글 여부
	        } else { }
		%>
			<%-- 처리사항게시판일 경우(경남도청에 바란다) --%>
			<tr>
				<th scope="row">공개여부</th>
				<td>
						<label for="dataSecret2"><input type="radio" name="dataSecret" id="dataSecret2" value="false" <%=isSecret != true ? "checked" : ""%>/>공개</label>
						<label for="dataSecret1"><input type="radio" name="dataSecret" id="dataSecret1" value="true" <%=isSecret == true ? "checked" : ""%>/>비공개</label>
						<div class="ntc"><!-- ntc -->
							<p style="font-weight:900">※ <span style="color:red">비공개</span>로 작성한 게시글은 목록에서 조회되지 않으며, 로그인하여 “나의 게시글 보기”에서 확인하실 수 있습니다.</p>
						</div>
				</td>
			</tr>
			<%
		}%>
	<%-- 처리사항게시판일 경우(경남도청에 바란다) --%>
	 <%if(bm.getDataDep()==1 && !bm.getCommand().equals("reply")){ %>
			<%--(답변이 아닐때만 표출)답변요청 확인 --%>
			<tr>
				<th scope="row">답변요청</th>
				 <td>
						<input type="hidden" name="categoryCodeData1" id="categoryCodeData1" value="<%=bm.getCategoryCode1()%>"  /><%-- 처리상태 --%>
						<%--(기존)부서값 --%>
						<%--
						<input type="hidden" name="tmpField20" id="tmpField20" value="<%=EgovStringUtil.isNullToString(bm.getTmpField20())%>"  />
						 --%>
						<% if(bm.getCommand().equals("update")) {
									if(bm.isManager()){
										//관리자는 수정 가능
						%>
										<input type="radio" name="adminReplyNotice" id="replyRequest1" value="Y" <%if(EgovStringUtil.isNullToString(bm.getAdminReplyNotice()).equals("Y"))out.print("checked");%>/><label for="replyRequest1">예</label>
										<input type="radio" name="adminReplyNotice" id="replyRequest2" value="N" <%if(EgovStringUtil.isNullToString(bm.getAdminReplyNotice()).equals("N") || EgovStringUtil.isNullToString(bm.getAdminReplyNotice()).equals(""))out.print("checked");%>/><label for="replyRequest2">아니요</label>
						
						<%
									}else{
										//사용자인경우
						%>
										<input type="hidden" name="adminReplyNotice" value="<%=EgovStringUtil.isNullToString(bm.getAdminReplyNotice())%>" />
										<%if(EgovStringUtil.isNullToString(bm.getAdminReplyNotice()).equals("Y")){out.print("예");}else{out.print("아니오");}%>
						<%
									}
									
							 } else { %>
							 
							<input type="radio" name="adminReplyNotice" id="replyRequest1" value="Y" <%if(EgovStringUtil.isNullToString(bm.getAdminReplyNotice()).equals("Y"))out.print("checked");%>/><label for="replyRequest1">예</label>
							<input type="radio" name="adminReplyNotice" id="replyRequest2" value="N" <%if(EgovStringUtil.isNullToString(bm.getAdminReplyNotice()).equals("N") || EgovStringUtil.isNullToString(bm.getAdminReplyNotice()).equals(""))out.print("checked");%>/><label for="replyRequest2">아니요</label>
						
						<% } %>

						<div class="ntc"><!-- ntc -->
							<p>※답변요청을 하시겠습니까?</p>
						</div>
				</td> 
			</tr>
			<%--//답변요청 확인 --%>
		<%} %>
	<%--// 처리사항게시판일 경우(경남도청에 바란다) --%>
			

	<%if(bm.getCommand().equals("update") && !EgovStringUtil.isNullToString(bm.getUserPw()).equals("")){ %>
		<tr>
			<th> <span class="star">*</span><label for="userPw">비밀번호</label></th>
			<td><input type="password" name="userPw" id="userPw"  class="input_v2" value="<%=bm.getUserPw() == null ? "" : bm.getUserPw()%>" style="width:50%;"/></td>
		</tr>
	<%} %>
		
		<%
		int extensionCount = bm.extensionCount();
		for(int i=0;i<extensionCount;i++)
		{
			bm.setExtensionVO(i);
			%>
			<tr>
				<th scope="row"><label for="<%=bm.getExtensionKey()%>"><%=bm.getExtensionDesc() %></label></th>
				<td class="con_border">
					<%=bm.getExtensionTag("","","").replaceAll("class=\"\"","class=\"text_normal w70\"").replaceAll("null","")%>
				</td>
			</tr>
			<%
		}
		%>
		</tbody>
	</table>
	
</div>
<% if(!bm.isManager()) { %>
<h5 class="h5 mb20">개인정보 수집 동의</h5>
<div class="brdbox v2" tabindex="0">
	<ol class="ol-v1">
		<li><strong>1. 개인정보의 수집·이용 목적</strong>
			<ul>
				<li>- 경상남도 홈페이지시스템에 입력된 개인정보는 게시자의 의견 확인 및 답변을 위해 수집·활용됩니다.</li>
			</ul>
		</li>
		<li><strong>2. 수집하는 개인정보의 항목</strong>
			<ul>
				<li>- 수집항목 : 성명 , 전화번호 , 핸드폰번호 , 가상실명인증키
					<p>※ 각 게시판 별 수집항목은 차이가 있을 수 있습니다.</p>
				</li>
			</ul>
		</li>
		<li><strong>3. 보유·이용기간</strong>
			<ul>
				<li>- 법령에 따른 개인정보 보유·이용기간내에서 개인정보를 처리 및 보유합니다.</li>
			</ul>
		</li>
		<li><strong>4. 이용자는 해당 개인정보 수집 및 이용 동의에 대한 거부 권리가 있습니다.</strong>
			<p>※ 단, 개인정보 수집 및 이용 동의를 하지 않으실 경우 의견 접수 및 답변이 불가할 수 있습니다.</p>
		</li>
	</ol>
</div>
<div class="privacyCheck">
	<input type="checkbox" id="pCheck1" value="Y" name="pCheck1" /><label for="pCheck1">개인정보수집에 동의합니다.</label>
</div>
<%}  %>
<!-- e : BOARD -->

<!-- s : 게시판버튼 -->
<div class="tBtn tac">
	<%=bm.getWriteIcons()%>
</div>
<!-- e : 게시판버튼 --> 
  
</form> 


<!-- 
<script src="http://code.jquery.com/jquery.min.js"></script>
<script type="text/javascript">
$("input[name=userTel]").on("blur", function(){
	//핸드폰 관련 인풋 박스에서 포커스 아웃 blur 발생시 
	var trans_num = $(this).val().replace(/-/gi,'');
	//인풋 박스에 적혀 있는 - 표시 제거
	if(trans_num != null && trans_num != ''){
		if(trans_num.length==11 || trans_num.length==10) {
			//휴대폰 번호는 11 혹은 10 자리 
			var regExp_ctn = /^01([016789])([1-9]{1})([0-9]{2,3})([0-9]{4})$/;
			//휴대폰 번호가 유효한 번호인지 정규식으로 검사
			if(regExp_ctn.test(trans_num)){
				trans_num = $(this).val().replace(/^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?([0-9]{3,4})-?([0-9]{4})$/, "$1-$2-$3");
				//정상적인 번호라면 01012341234 => 010-1234-1234 의 형태로 변경
				$(this).val(trans_num);
				//인풋 박스에 삽입 
			}else{
				alert("유효하지 않은 전화번호 입니다.");
				$(this).val("");
				$("#userTel").focus();
			}

		}else{
			alert("유효하지 않은 전화번호 입니다.");
			$(this).val("");
			$("#userTel").focus();
		}
	}
});
</script>
 -->   
<%!
public int toINT(String val) {
	try {
		if(val.substring(0,1).equals("0")) { val = val.substring(1,val.length()); } 
		int returnval = Integer.parseInt(val);
		return returnval;
	} catch(Exception e) {
		return 0;
	}
}

%>                                                                                                                                                                                                                                                                                                                                                                                                                                                                   