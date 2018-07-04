<%@page import="egovframework.rfc3.menu.web.CmsManager, egovframework.rfc3.common.util.EgovStringUtil"%>
<%@ page import="java.sql.*,java.util.*,java.text.*"%>
<%@ page import="java.util.*, egovframework.rfc3.board.vo.*, java.text.SimpleDateFormat" %>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>
<%@ page import="egovframework.rfc3.common.util.*"%>
<%@ page import="java.lang.reflect.Method, org.springframework.jdbc.support.*"%> 
<%@ page import="java.net.*" %>

<%@ page import = "org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import = "org.springframework.web.context.WebApplicationContext" %>
<%@ page import = "com.ibatis.sqlmap.client.SqlMapClient,java.sql.Connection" %>
<%@ page import = "javax.sql.DataSource, egovframework.ubitec.common.vo.Rfc_comtnmember"%>
<%@ page import = "org.springframework.context.ApplicationContext"%>
<%@ page import = "org.springframework.context.support.ClassPathXmlApplicationContext"%>

<%@ page import="egovframework.rfc3.user.vo.*"%>

<script src="//code.jquery.com/jquery.min.js"></script>

<c:set value="${returnUrl}" var="retunUrl2" />
<%
	/*
	BoardManager bm = new BoardManager(request);
	CmsManager cm = new CmsManager(request);
	SessionManager sm = new SessionManager(request);
	/**/

	String loginUserName = bm.isManager() ? bm.getSUserName() : !"".equals( sm.getId() ) ? sm.getName() : "";
	String url = "/board/view."+cm.getUrlExt()+"?boardId=BBS_0000434&menuCd=DOM_000000105008000000&startPage=1&contentsSid=2950&dataSid=" + bm.getDataSid();
	String rurl = url;
	String returnUrl = EgovStringUtil.isNullToString(pageContext.getAttribute("retunUrl2"));
	url = URLEncoder.encode( url, "UTF-8" );
	returnUrl = URLEncoder.encode( returnUrl, "UTF-8" );


	WebApplicationContext context  = WebApplicationContextUtils.getWebApplicationContext(request.getSession().getServletContext());
	SqlMapClient sqlMapUbitec = (SqlMapClient)context.getBean("sqlMapUbitec");
	String ihIdNum = "";
	
	try {
		Rfc_comtnmember param = new Rfc_comtnmember();
		param.setUniq_id( sm.getUniqId() );
		Rfc_comtnmember result = (Rfc_comtnmember) sqlMapUbitec.queryForObject("rfcMemberApp.getRfcMember", param);
		if( result != null ) {
			ihIdNum = result.getIhid_num();
		}
	} catch( Exception ex) { out.print( ex.getMessage() ); }
	
	
	// 회원로그인 정보 ( 연락처 )
	MberManageVO userVO = null;
	
	// 회원정보 불려오기
	if(sm.getUserSe().equals("GNR")){
	userVO = (MberManageVO)cm.getUserInfo();
	}

	if(userVO == null) userVO = new MberManageVO();
%>

<%
	String user_id = sm.getId();
	String comment_sid = request.getParameter( "comment_sid" ) == null ? "" : request.getParameter( "comment_sid" ).toString();
	String comment_title = request.getParameter( "comment_title" ) == null ? "" : request.getParameter( "comment_title" ).toString();

	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	StringBuffer sql = new StringBuffer();
	if (!"".equals(comment_sid)){
		try{ 
			sqlMapUbitec.startTransaction();
			
			try {
				conn = sqlMapUbitec.getCurrentConnection();
			} catch(SQLException ex){}
		
			sql.append( "UPDATE RFC_COMTNBBSCOMMENT " );
			sql.append( "SET comment_title ='" + comment_title + "'" );		
			sql.append( "WHERE COMMENT_SID = '" + comment_sid + "'" );			
			if(!bm.isManager() ) {
				sql.append( " AND USER_ID = '" + user_id + "'" );
			}
			pstmt = conn.prepareStatement( sql.toString() );
			pstmt.executeUpdate(); 
			
			sqlMapUbitec.commitTransaction();
		} catch ( Exception ex ){ 
			out.print(ex.getMessage());
		} finally {
			try{ if(rs != null) rs.close();} catch ( SQLException se ) { se.printStackTrace(); }
			try{ if(pstmt != null) pstmt.close();} catch ( SQLException se ) { se.printStackTrace(); }
			try{ if(conn != null) conn.close();} catch ( SQLException se ) { se.printStackTrace(); }
			
			sqlMapUbitec.endTransaction();
			response.sendRedirect(rurl);
		}
	}
%>
<script type="text/javascript">

	$(function(){
 	$('.tBtn > a').each(function(index) {
 	 //console.log($(this).attr('href'));
 	 var href = $(this).attr('href');
	  if(href.indexOf('extendedTreatment')>-1) {
	   $(this).hide();
 	 }
	 });
	});

	$( document ).ready( function() {
		$( "#commentTitle" ).on( "focus", function() {
			// 로그인을 안했을때 로그인페이지로

			<%
			if( "".equals(loginUserName) ) {
				%>
				location.href="/index.gyeong?menuCd=DOM_000000106007007000&returnUrl=<%=returnUrl%>";
				<%
			}
			%>


		} );
	} );


</script>
<div class="subCnt">
<!-- ********************************************************************************************-->

<!-- s : BOARD -->
<div class="board">
	<div class="basicView"><!-- basicView -->
		<div class="titleField">
			<h4><%=bm.getDataTitle()%></h4>
			<ul>
				<li class="t-1"><strong>조회 : </strong><span><%=bm.getViewCount()%></span></li>
				<li class="t-2"><strong>등록일 : </strong><span><%=bm.getRegister_dt()%></span></li>
				<li class="t-3"><strong>작성자 : </strong>
					<span>
						<%=bm.getUserNick() %>
					</span>
				</li>
			</ul>
		</div>
		<div class="conField">
			<ul>
				<%
					if( bm.isManager() || bm.getSUserId().equals(bm.getUserId())) {
						%>
						<li class="w100">
							<span>연락처</span>
							<p><%=EgovStringUtil.isNullToString( bm.getUserTel() )%></p>
						</li>
						<li class="w100">
							<span>거주 시&middot;도</span>
							<p><%=EgovStringUtil.isNullToString( bm.getUserAddress() )%></p>
						</li>
						<%
					}
					try{
					BoardVO vo = new BoardVO();
					vo = bm.getBoardVO();
					String item = vo.getItemView();

					if( item != null && !item.equals("") ) {

						String[] items = item.split(",");
						List<String> convertItems = new ArrayList<>();

						for ( int index = 0 ; index < items.length ; index++ ) {
							if ( items[index].indexOf( "FILE_ICON" ) < 0 && items[index].indexOf( "DATA_CONTENT" ) < 0 && items[index].indexOf( "DATA_TITLE" ) < 0 ) {
								convertItems.add( items[index] );
							}
						}

						for ( int index = 0 ; index < convertItems.size() ; index++ ) {
							String[] innerItems = convertItems.get(index).split( ":" );

							String getterName = innerItems[2];
							%>
							<li<%=convertItems.size() % 2 <= 0 ? "" : index == convertItems.size() - 1 ? " class=\"w100\"" : ""%>>
								<span>
									<%
										if ( "카테고리1".equals( innerItems[0] ) ) {
											out.print( "진행여부" );
										} else if ( "사용자 아이콘".equals( innerItems[0] ) ) {
											out.print( "공개여부" );
										} else if ( "임시필드1".equals( innerItems[0] ) ) {
											out.print( "기간" );
										} else {
											out.print( innerItems[0] );
										}
									%>
								</span>
								<%
									try {
										Class classType = BoardManager.class;
										Method methodGetter;

										if(innerItems[1].equals( "DATA_TITLE") ) {
											methodGetter = classType.getMethod( "getDataTitle" );
										} else {
											methodGetter = classType.getMethod( getterName );
										}

										Object result = methodGetter.invoke( bm, null );

										/*
										임시필드1 항목선택시 기간표출..
										tmpField1 : 시작기간
										tmpField2 : 마감기간
										 */
										if( innerItems[1].equals( "TMP_FIELD1" ) ) {
											%>
											<p><%=bm.getTmpField1() %> ~ <%=bm.getTmpField2() %></p>
											<%
										} else {
											%>
											<p><%=result == null ? "" : result%></p>
											<%
										}

									} catch( Throwable e ) {
										out.println("오류2 : " + e.getMessage());
									}
									%>
							</li>
							<%
						}
					}

					if ( bm.getFileCount() > 0 ) {
				%>
				<li class="w100"><!-- width:100% -->
					<span>첨부파일</span>
					<p>
						<span class="attach">

<%
		                    String userAgent = request.getHeader("user-agent");
		                    for(int fcnt = 0;fcnt<bm.getFileCount();fcnt++){
		                        boolean isMobile = false;
		                        boolean isHtml5 = !(userAgent.toLowerCase().indexOf("msie 6.0")>-1||userAgent.toLowerCase().indexOf("msie 7.0")>-1||userAgent.toLowerCase().indexOf("msie 8.0")>-1);
		                        if(userAgent.toLowerCase().indexOf("mobile") >=0){
		                            isMobile = true;
		                        }
		                        if(fcnt > 0){
		                            out.println("<br />");
		                        }
		                        if(bm.getBoardFileVO(fcnt) != null){
		                            out.print(bm.getFileList(bm.getBoardFileVO(fcnt),"<a href=\"{fileDown}\" title=\"{fileName} 다운받기\" class=\"file\">{fileName} ({fileSize})</a> ").replace("<br/>","").replace("(null  kb)",""));

		                            if(bm.getBoardFileVO(fcnt).getFileId()!=null && !bm.getBoardFileVO(fcnt).getFileId().equals("")){
										out.print(bm.getHtmlViewerIcon(bm.getBoardFileVO(fcnt),"",isMobile).replaceAll("전용뷰어","바로보기"));
									}else{
										out.print(bm.getConvertIcon(bm.getBoardFileVO(fcnt),null).replaceAll("전용뷰어","바로보기"));
									}
		                        }
		                    }
		                %>
						</span>
				<%
					}
				%>
					</p><!-- attach -->
				</li>
			</ul>
		</div>
		<div class="conText">
			<!-- 입력 예시 -->
			<p class="img">
				<%
				int [] ext = bm.searchFileNameExt( "jpg|bmp|png" );

				if( ext.length != 0) {
					if ( ext.length > 0 ) {
						String fileAlt = cm.getMenuVO().getMenuNm() + "의 파일 이미지";
					%>
					<img src="<%=bm.getFilePath( ext[0] )%>" alt="<%=bm.getFileText( ext[0] ) == null ? fileAlt : bm.getFileText( ext[0] )%>" />
					<%
					} else {
					%>
					<img src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/bbs_list_type2/no_images.gif" alt="no images" />
					<%
					}
				}
			}catch(Exception ex){
				out.println("오류1 : " + ex.getMessage());
			}
				%>
			</p><!-- img -->
			<%-- 내용 --%>
			<%
				String content = EgovStringUtil.isNullToString(bm.getDataContent());
			%>
			<%
				//if(!bm.isBoardEditor())
				if(!content.contains("</p>"))
				{
					content = content.replace( "&lt;", "<" ).replace( "&gt;", ">" );
				}
			%>
			<%=content%><br/>
		</div>
		<%if(bm.isCclViewFl()) {  //공공누리 수정1---------------------------------------------start  %>
		<%if(!bm.isCclIsWriter()) {//000%>
		<div class="cclBox view">
			<div class="codeView">
				<img src="http://www.kogl.or.kr/open/web/images/images_2014/codetype/new_img_opencode0.jpg" alt="<%=bm.getDataTitle()%> 저작물은 자유이용을 불가합니다."/>
				<p><%=bm.getDataTitle()%> 저작물은 자유이용을 불가합니다.</p>
			</div>
		</div>
		<%} else {%>
			<%if(!bm.isCclIsPay()) {%>
				<%if(!bm.isCclIsModify()) {//100%>
					<div class="cclBox view">
						<div class="codeView">
							<img src="http://www.kogl.or.kr/open/web/images/images_2014/codetype/new_img_opencode1.jpg" alt="<%=bm.getDataTitle()%> 저작물은 공공누리 출처표시 조건에 따라 이용할 수 있습니다."/>
							<p><%=bm.getDataTitle()%> 저작물은 공공누리 "출처표시" 조건에 따라 이용할 수 있습니다.</p>
						</div>
					</div>
				<%
				} else {//101
					%>
					<div class="cclBox view">
						<div class="codeView">
							<img src="http://www.kogl.or.kr/open/web/images/images_2014/codetype/new_img_opencode3.jpg" alt="<%=bm.getDataTitle()%> 저작물은 공공누리 출처표시+변경금지 조건에 따라 이용할 수 있습니다."/>
							<p><%=bm.getDataTitle()%> 저작물은 공공누리 “출처표시+변경금지” 조건에 따라 이용할 수 있습니다.</p>
						</div>
					</div>
					<%
					}
				%>
				<%
				} else {
				%>
				<%
					if (!bm.isCclIsModify()) {//110
					%>
					<div class="cclBox view">
						<div class="codeView">
							<img src="http://www.kogl.or.kr/open/web/images/images_2014/codetype/new_img_opencode2.jpg" alt="<%=bm.getDataTitle()%> 저작물은 공공누리 '출처표시+상업적이용금지' 조건에 따라 이용할 수 있습니다."/>
							<p><%=bm.getDataTitle()%> 저작물은 공공누리 “출처표시+상업적이용금지” 조건에 따라 이용할 수 있습니다.</p>
						</div>
					</div>
					<%
				} else {//111
					%>
					<div class="cclBox view">
						<div class="codeView">
							<img src="http://www.kogl.or.kr/open/web/images/images_2014/codetype/new_img_opencode4.jpg" alt="<%=bm.getDataTitle()%> 저작물은 공공누리 “출처표시+상업적이용금지+변경금지” 조건에 따라 이용할 수 있습니다."/>
							<p><%=bm.getDataTitle()%> 저작물은 공공누리 “출처표시+상업적이용금지+변경금지” 조건에 따라 이용할 수 있습니다.</p>
						</div>
					</div>
					<%}%>
				<%}%>
			<%}%>
		<%}  //공공누리 수정1---------------------------------------------end  %>
	</div>
</div>
<!-- e : BOARD -->

<!-- s : 게시판버튼 -->
<div class="tBtn tac">
	<%=bm.getViewIcons()%>
</div>
<!-- e : 게시판버튼 -->

<!-- s : 코멘트 쓰기 -->
	<script type="text/javascript">
		function formCommentSubmit( f ) {

			if( f.commentTitle.value == null || f.commentTitle.value == '' ) {
				alert("참여의견을 작성해주세요.");
				f.commentTitle.focus();
				return false;
			} else {
				if($('#commentTitle').val().length > 950) {
					$('#commentTitle').val( $('#commentTitle').val().substring(0, 950) );
					alert("참여의견은 950자를 초과 입력 할 수 없습니다.");
					return false;
				}
			}

			var regExp = /^\d{3}-\d{3,4}-\d{4}$/;

			if( !f.pCheck1.checked && f.giftTel.value != '' ) {
				alert('개인정보수집에 동의해주세요.');
				f.pCheck1.focus();
				return false;
			} else if( f.pCheck1.checked && f.giftTel.value == '' ) {
				alert('연락처를 입력해주세요.');
				f.giftTel.focus();
				return false;
			} else if( f.pCheck1.checked && f.giftTel.value != '' ) {
				if ( !regExp.test( f.giftTel.value ) ) {
					alert( '연락처는 -를 포함해서 입력해주세요.' );
					f.giftTel.focus();
					return false;
				} else {
					var gift = f.commentTitle.value + '§' + f.giftTel.value;
					f.commentTitle.value = gift;
				}
			}
		}
		function formCommentUpdate(t, s) {
			var result = confirm("수정하시겠습니까?");
	    		if(result){
				f = document.getElementById("comment_action");
				t = Number(t);
				var c_title;
				var fileValue = $("textarea[name='c_title']").length;
				var fileData = new Array(fileValue);
		    		for(var i=0; i<fileValue; i++){
					if (i == t){
		         		if ($("input[name='telupt']")[i].value != ''){
		         			c_title = $("textarea[name='c_title']")[i].value + '§' + $("input[name='telupt']")[i].value;
		         		} else {
		         			c_title = $("textarea[name='c_title']")[i].value;
		         		}
					}
			   	}
			    	if(c_title.length > 950){
		    			alert("참여 의견은 950자를 초과입력 할 수 없습니다.")
		    			return;
		    		}
			 	f.comment_title.value = c_title;
				f.comment_sid.value = s;
				f.action = "<%=rurl%>";
				f.submit();
	    		} else {
	    			return;
	    		}
		}
		function likeAction( sid ) {
		<%
			if( "".equals(loginUserName) ) {
		%>
			location.href="/index.gyeong?menuCd=DOM_000000106007007000&returnUrl=<%=returnUrl%>";
		<%
			} else {
		%>
			var frm = document.likeForm;
			frm.commentSid.value = sid;
			frm.submit();
		<%
			}
		%>
		}
	</script>
	<div class="agree mt20">
	<%
		String sGetId = EgovStringUtil.isNullToString(sm.getId());
		
		// 핸드폰 번호
		String getUserTel = "";
		String mUserTel = "";
		
		String userTel1 = "";
		String userTel2 = "";
		String userTel3 = "";
		
		// mUserTel = EgovStringUtil.isNullToString(bm.getUserTel()); // 사용자 폰번호

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
			
		%>

		<%
		try{
				%>
				<form name="comment" onsubmit="return formCommentSubmit(this);" id="comment" method="post" action="/board/writeComment.gyeong" enctype="multipart/form-data">
					<!-- s :개인정보 수집동의 -->
					<h5 class="h5 mb20">개인정보 수집 동의</h5>
					<div class="brdbox v2">
						<ol class="ol-v1">
							<li><strong>1. 개인정보의 수집&middot;이용 목적</strong>
								<ul>
									<li>- 경상남도 홈페이지시스템에 입력된 개인정보는 게시자의 의견 확인 및 답변을 위해 수집&middot;활용됩니다.</li>
								</ul>
							</li>
							<li><strong>2. 수집하는 개인정보의 항목</strong>
								<ul>
									<li>- 수집항목 : 성명 , 연락처, 가상실명인증키
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
						<input type="checkbox" id="pCheck1" value="Y" name="pCheck1" /><label for="pCheck1">개인정보수집에 동의합니다.</label>
					</div>
					<!-- e :개인정보 수집동의 -->
					<input type="hidden" name="dataSid" value="<%=bm.getDataSid()%>" />
					<input type="hidden" name="boardId" value="<%=bm.getBoardId()%>" />
					<input type="hidden" name="boardSid" value="<%=bm.getBoardSid()%>" />
					<input type="hidden" name="userId" value="<%=sm.getId()%>" />
					<input type="hidden" name="userNick" value="<%=loginUserName%>" />
					<input type="hidden" name="menuCd" value="<%=cm.getMenuVO().getMenuCd()%>" />
					<fieldset>
						<legend>참여의견 쓰기</legend>
						<div class="sns_login">
							<h3>참여의견 등록하기 <span class="re_span">※ 950자 이내로 작성해 주세요.</span></h3>
						</div>

						<div class="sns_write">
							<p class="telArea">
								<label for="giftTel">연락처</label> 
								<input type="text" name="giftTel" class="input" id="giftTel" title="연락처" value="<%=EgovStringUtil.isNullToString( getUserTel )%>">
								<label for="userNick">이름</label> 
								<input type="text" name="userNick" class="input" id="userNick" title="이름" value="<%=EgovStringUtil.isNullToString( loginUserName )%>" <%if(!bm.isManager()){out.println("readonly");} %>>
							</p>
							<label for="commentTitle" class="blind">댓글쓰기</label>
							<textarea rows="10" cols="30" id="commentTitle" name="commentTitle" title="댓글쓰기" style="width:90%; float: left; heigth: 75px; padding: 10px; border: 1px solid #e4e4e4; background: #f9f9f9; resize: none; color: #666;" placeholder="950자 이내로 작성해 주세요."></textarea>
							<label for="commentSubmit" class="blind">등록</label>
							<input type="submit" id="commentSubmit" value="등록" title="등록">
						</div>
					</fieldset>
				</form>
				<%
		}catch(Exception ex){
			out.println("오류4 : " + ex.getMessage());
		}
		try{
		%>
		<!-- s : 코멘트 리스트 -->
		<%
			List<CommentVO> commentList = bm.getCommentList( bm.getDataSid() );
			SimpleDateFormat sdf = new SimpleDateFormat( "yyyy.MM.dd" );
		%>

		<div class="replyList replyInput">
			<form name="comment_action" id="comment_action" method="post">
			<input type="hidden" name="comment_title" value="" />
			<input type="hidden" name="comment_sid" value="" />
			</form>
			<ul>
				<%
				for ( int index = 0 ; index < commentList.size() ; index++ ) {
					
					CommentVO comment = commentList.get( index );
					
					
					String date = sdf.format( comment.getRegister_dt() );
					String title = "";
					String tel = "";
					
					if( comment.getCommentTitle().contains("§") ) {
						String[] splitTitle = comment.getCommentTitle().split("§");
						
						title = splitTitle[0];
						tel = splitTitle[1];
					} else {
						title = comment.getCommentTitle();
					}
					%>
					<li>
						<strong>
							<%
							if( bm.isManager() ) {
								%>
								<%=comment.getUserNick()%>
								<%
							} else {
								String userNick = EgovStringUtil.isNullToString(comment.getUserNick());
								
								if( !userNick.equals("") ) {
									userNick = userNick.substring(0, 1);
								}
								%>
								<%=userNick %>**
								<%
							}
							%>
							

						</strong>
						<%
						if( bm.isManager() ) {
						%>
							<span class="mr20"><%=EgovStringUtil.isNullToString(tel)%></span>

							<div class="btn">
								<%=bm.getCommentDelete(request.getContextPath()+"/images/egovframework/rfc3/board/images/skin/common/btn_del1.gif",comment.getCommentSid(),"") %>
								<a href="javascript:formCommentUpdate('<%=index%>', '<%=comment.getCommentSid()%>');"><img alt="수정버튼" src="/images/egovframework/rfc3/board/images/skin/common/btn_modify1.gif"/></a>
							</div>

						<%
						} else {
							if( !EgovStringUtil.isNullToString(comment.getUserId()).equals("") ) {
								if( comment.getUserId().equals( sm.getId() ) || ihIdNum.equals( comment.getUserId() ) ) { 
								%>
										<div class="btn">
											<%=bm.getCommentDelete(request.getContextPath()+"/images/egovframework/rfc3/board/images/skin/common/btn_del1.gif",comment.getCommentSid(),"") %>
											<a href="javascript:formCommentUpdate('<%=index%>', '<%=comment.getCommentSid()%>');"><img alt="수정버튼" src="/images/egovframework/rfc3/board/images/skin/common/btn_modify1.gif"/></a>
										</div>
								<%
								}
							}
						}
						%>
						<div class="sns_write">
							<textarea rows="10" cols="30" id="c_title" name="c_title" style="width:100%; float: left; heigth: 75px; padding: 10px; border: 1px solid #e4e4e4; background: #f9f9f9; resize: none; color: #666;"><%=title.replaceAll( "<br>", "&#10;" )%></textarea>
							<input type="hidden" name="telupt" value="<%=EgovStringUtil.isNullToString(tel)%>">
						</div>

						<button class="comment_recomm btn_g btn_recomm" onclick="likeAction('<%=comment.getCommentSid()%>');">
							<span class="num_txt"><%=bm.getBoardCommentLikeCount( "G", comment.getCommentSid() )%></span>
						</button>
						<span class="sns_date"><%=date%></span>

					</li>
					<%
				}
		}catch(Exception ex){
			out.println("오류5 : " + ex.getMessage());
		}
				%>
			</ul>
		</div>
		<form action="/board/util/commentLikeAction.gyeong" id='likeForm' name="likeForm"  method="post">
			<input type="hidden" name="dataSid" value="<%=bm.getDataSid()%>" />
			<input type="hidden" name="boardId" value="<%=bm.getBoardId()%>" />
			<input type="hidden" name="boardSid" value="<%=bm.getBoardSid()%>" />
			<input type="hidden" name="userId" value="<%=sm.getId()%>" />
			<input type="hidden" name="userNick" value="<%=loginUserName%>" />
			<input type="hidden" name="userName" value="<%=loginUserName%>" />
			<input type="hidden" name="menuCd" value="<%=cm.getMenuVO().getMenuCd()%>" />
			<input type="hidden" name="checkType" value="G" />
			<input type="hidden" name="countType" value="G" />
			<input type="hidden" name="commentSid" value="" />
		</form>
		<!-- e : 코멘트 리스트 -->
	</div>

<!-- e : 코멘트 쓰기 -->


<%
	if( bm.getCategoryCode1().equals( "01" ) ) {
		%>
		<!-- s : 코멘트 목록 밑 게시판버튼 -->
		<div class="tBtn tac">
			<%=bm.getViewIcons()%>
		</div>
		<!-- e : 코멘트 목록 밑 게시판버튼 -->
		<%
	}
%>

<!-- s : 이전/다음글 -->
<%
	int dataIdx = bm.getDataIdx();
	int prev = dataIdx - 5;
	int next = dataIdx + 5;

	//다음글
	List<BoardDataVO> nextList;
	nextList = bm.getBoardDataUserList(bm.getBoardId(), " and DATA_IDX > " + dataIdx + " and DATA_IDX < " + next, "data_idx:asc", 1);

	//이전글
	List<BoardDataVO> beforeList = new ArrayList<BoardDataVO>();
	beforeList = bm.getBoardDataUserList(bm.getBoardId(), " and DATA_IDX < " + dataIdx + " and DATA_IDX > " + prev, "data_idx:desc", 1);

%>

<div class="viewPager">
	<ul>
		<li class="prev">
			<span>이전글</span>
			<p>
				<%
					if( beforeList.size() == 0 ) {
				%>
						이전 게시물이 없습니다.
				<%
					} else {
						BoardDataVO beforeVO = beforeList.get(0);
				        bm.setDataVO(beforeVO);
				%>
						<a href="/board/view.gyeong?boardId=<%=bm.getBoardId()%><%=bm.getToViewParam()%>"><%=bm.getDataTitle()%></a>
				<%
					}
				%>
			</p>
		</li>
		<li class="next">
			<span>다음글</span>
			<p>
				<%
					if( nextList.size() == 0 ) {
				%>
						다음 게시물이 없습니다.
				<%
					} else {
						BoardDataVO nextVO = nextList.get(0);
				        bm.setDataVO(nextVO);
				%>
						<a href="/board/view.gyeong?boardId=<%=bm.getBoardId()%><%=bm.getToViewParam()%>"><%=bm.getDataTitle()%></a>
				<%
					}
				%>
			</p>
		</li>
	</ul>
</div>
<!-- e : 이전/다음글 -->
</div>
                                  