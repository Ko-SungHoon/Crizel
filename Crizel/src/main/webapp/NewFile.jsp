<%@ page import="java.lang.reflect.Method, org.springframework.jdbc.support.*"%>
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

			officeTel = userVO.getAreaNo() + "-" + userVO.getMiddleTelno() + "-" + userVO.getEndTelno();
		}

		offiCd1 = sm.getOrgnztId().substring(0,4);

	} catch(Exception e) { }
		

	BoardDataVO orginVO = new BoardDataVO();
	if( bm.getCommand() != null && bm.getCommand().equals( "reply" ) ) {
		orginVO  = bm.getBoardDataVO( bm.getDataSid() );
	}


%>
<%
// 에디터 사용 유무 확인하여 사용시 에디터 로드
if(bm.isBoardEditor()){
	%>
	<script type="text/javascript" src="/ckeditor4/ckeditor.js"></script>
	<%
}
%>

<%

	// 회원로그인 정보 ( 연락처 )
	MberManageVO userVO = null;

	// 회원정보 불려오기
	if(sm.getUserSe().equals("GNR")){
	userVO = (MberManageVO)cm.getUserInfo();
	}
	%>
	<script>
	console.log("officeTel : <%=officeTel%>");
	</script>
	<%

	if(userVO == null) userVO = new MberManageVO();

	String sGetId = EgovStringUtil.isNullToString(sm.getId());

	// 핸드폰 번호
	String getUserTel = "";
	String mUserTel = "";

	String userTel1 = "";
	String userTel2 = "";
	String userTel3 = "";

	mUserTel = EgovStringUtil.isNullToString(bm.getUserTel()); // 사용자 폰번호

	//폰번호
	if(mUserTel.equals("")){

		if( sGetId.length() < 40 ) {
			// 회원로그인
			getUserTel = EgovStringUtil.isNullToString(userVO.getMoblfristNo())+EgovStringUtil.isNullToString(userVO.getMoblmiddleNo())+EgovStringUtil.isNullToString(userVO.getMoblendNo());
		} else {
			// 폰 본인인증 연락처
			getUserTel = (String)session.getAttribute("cellNo");
		}

	}

	// 연락처 체크
	if( !EgovStringUtil.isNullToString( getUserTel ).equals("") ) {

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

		 if( !userTel1.equals("") ) {
			getUserTel = userTel1 + "-" + userTel2 + "-" + userTel3;
		 } else {
			 getUserTel = "";
		 }
	}
	if (!mUserTel.equals("")){
		getUserTel = mUserTel;
	}

%>


<script type="text/javascript">
$(function(){
	console.log("<%=cm.getUserInfo()%>, 모바일 : <%=userVO.getMoblfristNo()%>, 전화번호 : <%=userVO.getAreaNo()%>, userVO : <%=userVO%>");
});

<%if(bm.isCclViewFl()) {  //공공누리 수정1---------------------------------------------start  %>
$(document).ready(function(){
	
	
	var writer = $("input[name='cclIsWriter']").val();
	var pay = $("input[name='cclIsPay']").val();
	var modify = $("input[name='cclIsModify']").val();

	if($("#formTn").attr("action").indexOf("updateAct") > -1) {
		setCCL(writer + pay + modify);
	}
	$('#koglType1').click(function() {setCCL("100");}); //type1 check
	$('#koglType2').click(function() {setCCL("110");}); //type2 check
	$('#koglType3').click(function() {setCCL("101");}); //type3 check
	$('#koglType4').click(function() {setCCL("111");}); //type4 check
	$('#koglType5').click(function() {setCCL("000");}); //적용불가 check
});

function setCCL(wpm) {
	console.log(wpm);
	switch(wpm) {
		case "000" :
			$(".codeView02, .codeView03, .codeView04, .codeView01").hide();
			$(".codeView05").show();
			$("input[name='cclIsWriter']").val("0");
			$("input[name='cclIsPay']").val("0");
			$("input[name='cclIsModify']").val("0");
			$("input[name='rgt_type_code']:input[value='5']").attr("checked", true);
			break;

		case "100" :
			$(".codeView02, .codeView03, .codeView04, .codeView05").hide();
			$(".codeView01").show();
			$("input[name='cclIsWriter']").val("1");
			$("input[name='cclIsPay']").val("0");
			$("input[name='cclIsModify']").val("0");
			$("input[name='rgt_type_code']:input[value='1']").attr("checked", true);
			break;

		case "110" :
			$(".codeView01, .codeView03, .codeView04, .codeView05").hide();
			$(".codeView02").show();
			$("input[name='cclIsWriter']").val("1");
			$("input[name='cclIsPay']").val("1");
			$("input[name='cclIsModify']").val("0");
			$("input[name='rgt_type_code']:input[value='2']").attr("checked", true);
			break;

		case "101" :
			$(".codeView02, .codeView01, .codeView04, .codeView05").hide();
			$(".codeView03").show();
			$("input[name='cclIsWriter']").val("1");
			$("input[name='cclIsPay']").val("0");
			$("input[name='cclIsModify']").val("1");
			$("input[name='rgt_type_code']:input[value='3']").attr("checked", true);
			break;

		case "111" :
			$(".codeView02, .codeView03, .codeView01, .codeView05").hide();
			$(".codeView04").show();
			$("input[name='cclIsWriter']").val("1");
			$("input[name='cclIsPay']").val("1");
			$("input[name='cclIsModify']").val("1");
			$("input[name='rgt_type_code']:input[value='4']").attr("checked", true);
			break;
	}
}
<% } //공공누리 수정1---------------------------------------------end %>
//---------------------------------------------------------------------------------------

	function formSubmit( form ) {
		// 전화번호 정규식
		var regExp = /^\d{3}-\d{3,4}-\d{4}$/;

		if ( form.dataTitle.value == '' ) {
			alert( "제목을 입력하시기 바랍니다." );
			form.dataTitle.focus();
			return false;
		}

		if ( form.userNick.value == '' ) {
			alert( "작성자명을 입력하시기 바랍니다." );
			form.userNick.focus();
			return false;
		}

		<%if(bm.isCclViewFl()) {  //공공누리 수정2---------------------------------------------start%>
		if($("input[name='rgt_type_code']:checked").length < 1) {
			alert("공공저작물 자유이용 조건을 선택해 주세요");
			return false;
		}
		<% } //공공누리 수정2---------------------------------------------end %>

		<%
		if ( bm.isBoardEditor() ) {
		%>
			if(CKEDITOR.instances.dataContent.getData() == '')
			{
				alert("내용을 입력하시기 바랍니다.");
				CKEDITOR.instances.dataContent.focus();
				return false;
			}
		<%
		} else {
		%>
			if ( typeof( form.dataContent ) !== 'undefined' ) {
				if( form.dataContent.value == '' ) {
					alert( "내용을 입력하시기 바랍니다." );
					form.dataContent.focus();
					return false;
				}
			}

		    var sImsi =  form.dataContent.value;
				sImsi = sImsi .replace(/(?:\r\n|\r|\n)/g, '<br>');
				sImsi = sImsi.replace('<p>', '');
				sImsi = sImsi.replace('</p>', '');
				form.dataContent.value = sImsi;
		<%
		}
		%>
	}
</script>

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

<div class="subCnt">
<!-- ***********************************************************-->
<%
	//공공누리 수정2-1---------------------------------------------start
	//반드시 form ID 를 formTn으로 해야지 복/붙할때 편함
 	//공공누리 수정2-1---------------------------------------------end
%>
	<!-- s : BOARD -->
	<form id="formTn" onsubmit="return formSubmit(this);" action="<%=request.getContextPath() %>/board/<%=bm.getCommand() != null && bm.getCommand().equals("update") ? "updateAct" : "writeAct"%>.<%=bm.getUrlExt()%>" method="post" enctype="multipart/form-data">
		<input type="hidden" name="orderBy" value="<%=bm.getOrderBy()%>" />
		<input type="hidden" name="boardId" value="<%=bm.getBoardId()%>" />
		<input type="hidden" name="menuCd" value="${menuCd}" />
		<input type="hidden" name="contentsSid" value="${contentsSid}" />
		<input type="hidden" name="command" value="<%=bm.getCommand() %>"/>
		<input type="hidden" name="startPage" value="<%=bm.getPageNum() %>"/>
		<input type="hidden" name="pcode" value="<%=bm.getPcode() %>"/>
	  	<%
			if(bm.getCommand() != null && (bm.getCommand().equals("update") || bm.getCommand().equals("reply")))
			{
		%>
				<input type="hidden" name="dataSid" value="<%=bm.getDataSid() %>"/>
		<%
			}
		%>

		<%if(bm.isCclViewFl()) {  //공공누리 수정3---------------------------------------------start %>
		<input type="hidden" name="cclIsModify" value="<%=bm.isCclIsModify() ? "1" : "0"%>"/>
		<input type="hidden" name="cclIsPay" value="<%=bm.isCclIsPay() ? "1" : "0"%>"/>
		<input type="hidden" name="cclIsWriter" value="<%=bm.isCclIsWriter() ? "1" : "0"%>"/>
		<%}  //공공누리 수정3---------------------------------------------end %>

		<div class="board write"><!-- Add : write -->
			<p class="ess-1"><span class="star">*</span> 표시된 항목은 필수 입력 항목입니다.</p>
			<table class="basicWrite"><!-- basicWrite -->
				<caption><%=currentMenuVO1.getMenuNm()%> 의 글쓰기 페이지</caption>
				<colgroup>
					<col style="width:15%">
					<col style="width:35%">
					<col style="width:15%">
					<col style="width:35%">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><span class="star">*</span><label for="dataTitle">제목</label></th>
						<td colspan="3"><input type="text" id="dataTitle" name="dataTitle" value="<%=bm.getDataTitle()%>" style="width:100%;"></td>
					</tr>
					<%
					if(isReply){
						String tmpField3 = EgovStringUtil.isNullToString(bm.getTmpField3());
						if(bm.getCommand() != null && "update".equals(bm.getCommand())) {
							tmpField3 = EgovStringUtil.isNullToString(bm.getTmpField3());
						} else {
							tmpField3 = bm.getSUserName();
						}
					%>
					<tr>
						<th scope="row"><span class="star">*</span><label for="tmpField3">담당자</label></th>
						<td colspan="3"><input type="text" id="tmpField3" name="tmpField3" style="width:40%;" value="<%=tmpField3%>" required></td>
					</tr>
					<%} %>
					<tr>
						<%
						String userNick = "";
						String userNickTitle = "작성자";
						if( isReply ) {
							userNickTitle = "담당부서";
							if( bm.getCommand() != null && bm.getCommand().equals( "update" ) ) {
								userNick = bm.getUserNick();
							} else {
								userNick  = officename;
							}
						}
						%>
						<th scope="row"><span class="star">*</span><label for="userNick"><%=userNickTitle%></label></th>
						<td colspan="3">
							<%
							if( isReply ) {
								%>
								<input type="text" name="userNick" id="userNick" value="<%=userNick %>" style="width:40%" />
								<%
							} else {
								if( !bm.isManager() ) {
									if( bm.getCommand() != null && "update".equals( bm.getCommand() ) )	{
										%>
										<%=bm.getUserNick() %>
										<input type="hidden" name="userNick" id="w1" value="<%=bm.getUserNick() %>" style="width:40%" />
										<%
									} else {
										if( bm.getSUserName() != null && !"".equals( bm.getSUserName() ) ) {
											%>
											<%=bm.getSUserName() %>
											<input type="hidden" name="userNick" id="w1" value="<%=bm.getSUserName() %>" style="width:40%" />
											<%
										} else {
											%>
											<input type="text" name="userNick" id="w1" style="width:40%"/>
											<%
										}
									}
								} else {
									if( bm.getCommand() != null && "update".equals( bm.getCommand() ) ) {
										%>
										<input type="text" name="userNick" id="w1" value="<%=bm.getUserNick() %>" style="width:40%" />
										<%
									} else {
										%>
										<input type="text" name="userNick" id="w1" value="<%=bm.getSUserName() %>" style="width:40%" />
										<%
									}
								}
							}
							%>
						</td>
					</tr>

					<%
					if(isReply){
						String s_getId = EgovStringUtil.isNullToString(sm.getId());
						//전화번호
						String getUserCel = "";
						String mUserCel = "";

						String userCel1 = "";
						String userCel2 = "";
						String userCel3 = "";

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
					%>
					<tr>
						<th scope="row"><span class="star">*</span><label for="tmpField4">부서 연락처</label></th>
						<td class="con_border" colspan="3">
							<input type="text" name="tmpField4" id="tmpField4" value="<%=EgovStringUtil.isNullToString(getUserCel)%>" style="width:40%;" required />
						</td>
					</tr>
					<%
					}else{
						if(!bm.isManager()){
					%>
					<tr>
						<th scope="row"><span class="star">*</span><label for="userTel">연락처</label></th>
						<td class="con_border" colspan="3">
							<input type="text" name="userTel" id="userTel" value="<%=EgovStringUtil.isNullToString(getUserTel)%>" style="width:40%;" required />
							<span>※ 010-1234-5678형태로 입력하시기 바랍니다.</span>
						</td>
					</tr>
					<%
						}
					} %>
				<%if(!isReply ){
					if(!bm.isManager()){
				%>
					<tr>
						<th scope="row"><span class="star">*</span><label for="userAddress">거주 시&middot;도</label></th>
						<td class="con_border" colspan="3">
							<input type="text" name="userAddress" id="userAddress" value="<%=EgovStringUtil.isNullToString(bm.getUserAddress())%>" style="width:40%;" required />
							<span>※ 시&middot;도 형태로 입력하시기 바랍니다.(예:'경상남도' 또는 '창원시')</span>
						</td>
					</tr>
					<!-- 180702 추가 항목 -->
					<tr>
						<th scope="row"><span class="star">*</span><label for="tmpField1">생년월일</label></th>
						<td class="con_border"><input type="text" name="tmpField1" id="tmpField1" value="<%=EgovStringUtil.isNullToString(bm.getTmpField1())%>" style="width:50%;" required />
						<span>※ 입력예:1998.01.01</span></td>
						<th scope="row"><span class="star">*</span>성별</th>
						<td class="con_border">
							<input type="radio" name="tmpField2" id="tmpField2M" value="M" required <%if("M".equals(EgovStringUtil.isNullToString(bm.getTmpField2()))){out.println("checked");} %> /><label for="tmpField2M">남</label>&nbsp;&nbsp;
							<input type="radio" name="tmpField2" id="tmpField2F" value="F" required <%if("F".equals(EgovStringUtil.isNullToString(bm.getTmpField2()))){out.println("checked");} %> /><label for="tmpField2F">여</label>
						</td>
					</tr>
				<%	}
				}%>
					<%
					if( bm.isBoardNoticeCf() && bm.isManager() && !isReply ) {
						%>
						<tr>
							<th><label for="dataNotice">공지글</label></th>
							<td colspan="3"><input type="checkbox" name="dataNotice" id="dataNotice" value="true" <%=bm.isNotice() == true ? "checked" : ""%>/> 공지</td>
						</tr>
						<%
					}

					if( bm.isBoardIsSecretCf() ) {
						%>
						<tr>
							<th><label for="dataSecret">비밀글</label></th>
							<td colspan="3"><input type="checkbox" name="dataSecret"  id="dataSecret" value="true" <%=bm.isSecret() == true ? "checked" : ""%>/> 비밀글</td>
						</tr>
						<%
					}

					BoardVO vo = new BoardVO();
					vo = bm.getBoardVO();
					String item = vo.getItemWrite();

					if( item != null && !item.equals("") ) {
						String[] items = item.split(",");

						for( int index = 0; index < items.length; index++ ) {

							String[] innerItems = items[index].split(":");
							String value = "";

							String getterName = innerItems[2];

							if( innerItems[1].contains("_") ) {
								value = JdbcUtils.convertUnderscoreNameToPropertyName( innerItems[1] );
							} else {
								value = "pCode";
							}

							try {
								Class classType = BoardManager.class;
								Method methodGetter;

								if(innerItems[1].equals( "DATA_TITLE") ) {
									methodGetter = classType.getMethod( "getDataTitle" );
								} else {
									methodGetter = classType.getMethod( getterName );
								}

								Object result = methodGetter.invoke( bm, null );

								if ( !"fileIcon".equals( value ) && !"dataContent".equals( value ) && !"dataTitle".equals( value ) && !"userNick".equals( value ) ) {
									%>
									<tr>
										<th scope="row"><label for="<%=value%>"><%=innerItems[0]%></label></th>
										<td colspan="3">
											<input type="text" id="<%=value%>" name="<%=value%>" class="input_v2" value="<%=result == null ? "" : result%>" style="width:90%;"/>
										</td>
									</tr>
								<%
								}

							} catch( Throwable e ) {
								out.println(e);
							}
						}
					}
				    %>
					<tr>
						<th scope="row" style="vertical-align: middle;"><span class="star">*</span><label for="dataContent">내용</label></th>
						<td colspan="3">
							<%
							String content = EgovStringUtil.isNullToString( bm.getDataContent() );
							%>
							<textarea id="dataContent" cols="30" rows="10"  name="dataContent"><%=content%></textarea>
							<script type="text/javascript">
								var editor = CKEDITOR.replace('dataContent',{filebrowserUploadUrl : '<%=request.getContextPath()%>/board/imageFileUpload.sko?boardId=<%=bm.getBoardId()%>'});
							</script>
						</td>
					</tr>
				<%
				if( bm.getFileUploadCf() ) {
				    if(bm.getCommand() != null && bm.getCommand().equals("update")) {
					%>
					<tr>
						<th>첨부파일</th>
						<td colspan="3">
							<%=bm.getFileList("<span title=\"첨부파일:{fileName}\"><a href=\"{fileDelete}\" onclick=\"Javascript:if(confirm('선택한 첨부파일을 삭제 하시겠습니까?')) return true; else return false;\" onkeypress=\"if(event.keyCode == 13){return confirm('선택한 첨부파일을 삭제 하시겠습니까?');}\">{fileMemo} {fileName} ({fileSize}) </a></span><br>")%>
						</td>
					</tr>
					<%

					}
				    %>
				    <tr>
						<th scope="row"><label for="upload">첨부파일</label></th>
						<td colspan="3">
							<p class="ess-2">※ 첨부파일 용량은 최대 <%=bm.getBoardFileSizeCf()%>MB까지 등록 가능합니다.</p>
							<div id='uploadfield'>
								<%=bm.getFileUpload() %>
							</div>
						</td>
					</tr>
				    <%
			    }
			    %>
				<%if(bm.isCclViewFl()) {  //공공누리 수정4---------------------------------------------start %>
				<tr>
					<th scope="row">저작권 표시</th>
					<td>
						<!---4. 공공누리 디자인 추가 영역 ---->
						<div>
							<div class="cclTit">
								<h3>공공누리 적용</h3>
								<p>저작권법 24조의2에 따라 국가나 지방자치단체, 공공기관이 업무상 작성하여 공표한 저작물이나 저작재산권 전부를 보유한 저작물은 국민이 허락 없이 이용할 수 있으며, 이에 따라 개방기관은 공공저작물 자유이용에 관한 표시를 하여야 합니다. </p>
								<a href="http://www.kogl.or.kr/info/freeUse.do" target="_blank" title="공공누리 홈페이지 새창">▶ 상세내용 : 공공누리 홈페이지 참조</a>
							</div>

							<div  class="cclBox">
								<ul>
									<li class="type1">
										<input type="radio" name="rgt_type_code" id="koglType1" value="1">
										<label for="koglType1">
											<img src="http://www.kogl.or.kr/open/web/images/images_2014/codetype/new_img_opencode1.jpg" alt="1유형 : 출처표시 (상업적 이용 및 변경 가능)"/>
											<span>1유형 : 출처표시 (상업적 이용 및 변경 가능)</span>
										</label>
									</li>
									<li class="type2">
										<input type="radio" name="rgt_type_code" id="koglType2" value="2">
										<label for="koglType2" >
											<img src="http://www.kogl.or.kr/open/web/images/images_2014/codetype/new_img_opencode2.jpg" alt="2유형 : 출처표시 + 상업적이용금지"/>
											<span>2유형 : 출처표시 + 상업적이용금지</span>
										</label>
									</li>
									<li class="type3">
										<input type="radio" name="rgt_type_code" id="koglType3" value="3">
										<label for="koglType3" >
											<img src="http://www.kogl.or.kr/open/web/images/images_2014/codetype/new_img_opencode3.jpg" alt="3유형 : 출처표시 + 변경금지" />
											<span>3유형 : 출처표시 + 변경금지</span>
										</label>
									</li>
									<li class="type4">
										<input type="radio" name="rgt_type_code" id="koglType4" value="4">
										<label for="koglType4" >
											<img src="http://www.kogl.or.kr/open/web/images/images_2014/codetype/new_img_opencode4.jpg" alt="4유형 : 출처표시 + 상업적이용금지 + 변경금지" />
											<span>4유형 : 출처표시 + 상업적이용금지 + 변경금지</span>
										</label>
									</li>
									<li class="type5">
										<input type="radio" name="rgt_type_code" id="koglType5" value="5">
										<label for="koglType5">
											<img src="http://www.kogl.or.kr/open/web/images/images_2014/codetype/new_img_opencode0.jpg" alt="자유이용 불가 (저작권법 제24조의2 제1항 제1호 ~ 4호 중 어느 하나에 해당됨)" />
											<span>
										<br/><br/>자유이용 불가 (저작권법 제24조의2 제1항 제1호 ~ 4호 중 어느 하나에 해당됨)<br/>
										1. 국가안전보장에 관련되는 정보를 포함하는 경우<br/>
										2. 개인의 사생활 또는 사업상 비밀에 해당하는 경우<br/>
										3. 다른 법률에 따라 공개가 제한되는 정보를 포함하는 경우<br/>
										4. 제112조에 따른 한국저작권위원회에 등록된 저작물로서 「국유재산법」에 따른 국유재산 또는 「공유재산 및 물품 관리법」에 따른 공유재산으로 관리되는 경우<br/>
									</span>
										</label>
										<a href="http://www.law.go.kr/법령/저작권법" target="_blank" title="해당사항 확인 (국가법령정보센터) 새창">
											<span>▶</span> 해당사항 확인 (국가법령정보센터)</a>
									</li>
								</ul>
								<div class="codeView type1 codeView01"><!--  type1  제외 하고 나머지 타입들은 css display:none  처리 -->
									<img src="http://www.kogl.or.kr/open/web/images/images_2014/codetype/new_img_opencode1.jpg" alt="출처표시 공공누리 - 공공지적물 자유이용허락"/>
									<p>본 공공저작물은 공공누리 "출처표시" 조건에 따라 이용할 수 있습니다.</p>
								</div>
								<div class="codeView type2 codeView02">
									<img src="http://www.kogl.or.kr/open/web/images/images_2014/codetype/new_img_opencode2.jpg" alt="출처표시+상업적이용금지 공공누리 - 공공지적물 자유이용허락"/>
									<p>본 공공저작물은 공공누리  “출처표시+상업적이용금지”  조건에  따라  이용할  수  있습니다.</p>
								</div>
								<div class="codeView type3 codeView03">
									<img src="http://www.kogl.or.kr/open/web/images/images_2014/codetype/new_img_opencode3.jpg" alt="출처표시+변경금지 공공누리 - 공공지적물 자유이용허락"/>
									<p>본 공공저작물은 공공누리  “출처표시+변경금지”  조건에  따라  이용할  수  있습니다.</p>
								</div>
								<div class="codeView type4 codeView04">
									<img src="http://www.kogl.or.kr/open/web/images/images_2014/codetype/new_img_opencode4.jpg" alt="출처표시+상업적이용금지+변경금지 공공누리 - 공공지적물 자유이용허락" />
									<p>본 공공저작물은 공공누리 “출처표시+상업적이용금지+변경금지”  조건에  따라  이용할  수  있습니다.</p>
								</div>
								<div class="codeView type5 codeView05">
									<img src="http://www.kogl.or.kr/open/web/images/images_2014/codetype/new_img_opencode0.jpg" alt="자유이용 불가 공공누리 - 공공지적물 자유이용허락"/>
									<p>자유이용을 불가합니다.</p>
								</div>
							<div class="cclInfo">
								<ul class="ul-v1">
									<li><strong>공공누리 제2~4유형</strong> 의 적용은 공동저작물 등 제3자의 권리가 포함된 저작물에 한하여 제3자의 이용허락 범위에 따라 <strong>제한적으로 적용</strong></li>
									<li><span>공공저작권 관련 상담센터 ☎ 1670-0052</span></li>
								</ul>
							</div>
						</div>
						<!---// 공공누리 디자인 추가 영역 끝---->
					</td>
				</tr>
				<% } //공공누리 수정4---------------------------------------------end %>
				</tbody>
			</table>
		</div>
		<!-- e : BOARD -->

		<!-- s : 개인정보 동의 -->
		<%
		if(bm.getDataDep() == 1 && !bm.getCommand().equals("reply") && !bm.getCommand().equals("update")){
			if(!bm.isManager()){
			%>
			<h5 class="h5 mb20">개인정보 수집 동의</h5>
			<div class="brdbox v2" tabindex="0"><!-- (v2) -->
				<ol class="ol-v1">
					<li><strong>1. 개인정보의 수집&middot;이용 목적</strong>
						<ul>
							<li>- 경상남도 홈페이지시스템에 입력된 개인정보는 게시자의 의견 확인 및 답변을 위해 수집&middot;활용됩니다.</li>
						</ul>
					</li>
					<li><strong>2. 수집하는 개인정보의 항목</strong>
						<ul>
							<li>- 수집항목 : 성명 , 연락처, 생년월일, 성별, 가상실명인증키
								<p>※ 각 게시판 별 수집항목은 차이가 있을 수 있습니다.</p>
							</li>
						</ul>
					</li>
					<li><strong>3. 보유&middot;이용기간</strong>
						<ul>
							<li>- 법령에 따른 개인정보 보유&middot;이용기간내에서 개인정보를 처리 및 보유합니다.</li>
						</ul>
					</li>
					<li><strong>4. 이용자는 해당 개인정보 수집 및 이용 동의에 대한 거부 권리가 있습니다.</strong>
						<p>※ 단, 개인정보 수집 및 이용 동의를 하지 않으실 경우 의견 접수 및 답변이 불가할 수 있습니다.</p>
					</li>
				</ol>
			</div>
			<div class="privacyCheck">
				<input type="checkbox" id="pCheck1" value="Y" name="pCheck1" required /><label for="pCheck1">개인정보수집에 동의합니다.</label>
			</div>
			<%
			}
		}
		%>
		<!-- e : 개인정보동의 -->
		<!-- s : 게시판버튼 -->
		<div class="tBtn tac">
			<%=bm.getWriteIcons()%>
		</div>
		<!-- e : 게시판버튼 -->
	</form>
	<script type="text/javascript">
		$('.calendar').datepicker({
			dateFormat: 'yy-mm-dd'
		});
	</script>
</div>
                                           