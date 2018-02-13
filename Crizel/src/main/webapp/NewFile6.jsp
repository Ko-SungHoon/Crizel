<%@ page import = "java.util.*, egovframework.rfc3.board.vo.CommentVO,java.text.SimpleDateFormat" %>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper"%>
<%@ page import="egovframework.rfc3.board.vo.BoardDataVO"%>
<%@ page import="egovframework.rfc3.board.vo.BoardCategoryVO"%>
<%@ page import="egovframework.rfc3.common.util.EgovStringUtil"%>
<%@ page import="egovframework.rfc3.board.vo.BoardFileVO"%>
<%
	ArrayList<BoardDataVO> answerList = (ArrayList<BoardDataVO>)bm.getBoardReplyDataList(bm.getDataIdx());
%>
<%
		BoardManager bms= new BoardManager(request);
%>
<%
	List<BoardCategoryVO> categoryList1 = bm.getCategoryList1();
	List<BoardCategoryVO> categoryList2 = bm.getCategoryList2();
	List<BoardCategoryVO> categoryList3 = bm.getCategoryList3();
%>
<script type="text/javascript">
function showCommentReply(id)
{
	var reply = document.getElementById(id);
	if(reply.style.display == 'none')
	{
		reply.style.display = 'block';
	}else{
		reply.style.display = 'none';
	}
}
</script>

			<!-- board_read -->
			<section class="board">
			<table class="board_read02" summary="상세내용입니다">
				<caption><%=bm.getDataTitle()%> 상세내용</caption>
						<colgroup>
						<col width="18%">
						<col width="32%">
						<col width="18%">
						<col width="*">
						</colgroup>
				<thead>
					<tr>
					<th colspan="4"  class="topline"><%=bm.getDataTitle()%></th>
					</tr>
				</thead>
				<tbody>
					<tr>
					<th scope="row">작성자</th>
					<td><%=bm.getUserNick()%></td>
					<th scope="row" class="lline">등록일</th>
					<td><%=bm.getRegister_dt("yyyy/MM/dd")%></td>
					</tr>

			<%
			int tdCnt = 0;
			%>
			<%if(bm.isViewItem("USER_EMAIL") && tdCnt == 0){ out.print("<tr>");}%>
			<% if(bm.isViewItem("USER_EMAIL")) { tdCnt++; %>
				<th scope="row">이메일</th>
					<td><%=EgovStringUtil.isNullToString(bm.getUserEmail())%></td>
			<% } %>
			<%if(bm.isViewItem("USER_EMAIL") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(tdCnt != 0){tdCnt=0; out.print("<td colspan=\"2\"></td>");}%>
		<% if(bm.isViewItem("USER_HOMEPAGE")) { %>
			<tr>
			<th scope="row">홈페이지</th>
			<td colspan="3"><%=EgovStringUtil.isNullToString(bm.getUserHomepage())%></td>
			<tr>
		<% } %>

		<%if(bm.isViewItem("USER_TEL") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("USER_TEL")) { tdCnt++; %>
			<th scope="row">전화번호</th>
				<td><%=EgovStringUtil.isNullToString(bm.getUserTel())%></td>
		<% } %>
		<%if(bm.isViewItem("USER_TEL") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(bm.isViewItem("USER_CEL") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("USER_CEL")) {  tdCnt++;%>
			<th scope="row">휴대전화</th>
				<td><%=EgovStringUtil.isNullToString(bm.getUserCel())%></td>
		<% } %>
		<%if(bm.isViewItem("USER_CEL") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(tdCnt != 0){tdCnt=0; out.print("<td colspan=\"2\"></td>");}%>
		<% if(bm.isViewItem("USER_ZIPCODE") || bm.isViewItem("USER_ADDRESS") || bm.isViewItem("USER_DETAILADDR")) { %>
			<tr>
			<th scope="row">주소</th>
			<td colspan="3">
				<% if(bm.isViewItem("USER_ZIPCODE")){ %>
			(<%=EgovStringUtil.isNullToString(bm.getUserZipcode())%>)
			<% } %>

			<% if(bm.isViewItem("USER_ADDRESS")){ %>
			<%=EgovStringUtil.isNullToString(bm.getUserAddress())%>
			<% } %>

			<% if(bm.isViewItem("USER_DETAILADDR")){ %>
			&nbsp;&nbsp;<%=EgovStringUtil.isNullToString(bm.getUserDetailAddr())%>
			<% } %>
			</td>
			</tr>
		<% } %>


		<%
						if(bm.isViewItem("CATEGORY_CODE1") && categoryList1 != null && categoryList1.size() > 0){
							if(bm.getMenuIsBoard1Cate()){
								if(tdCnt == 0){ out.print("<tr>");}
								tdCnt++;
								for(BoardCategoryVO category : categoryList1){
									if(bm.getCategoryCode1().equals(category.getCategoryCode())){
						%>
								<th scope="row">카테고리1</th>
									<td><%=category.getCategoryName()%></td>
						<%
								if(tdCnt == 2){tdCnt=0; out.print("</tr>");}
									}
								}
							}
						}
						%>


						<%
						if(bm.isViewItem("CATEGORY_CODE2") && categoryList2 != null && categoryList2.size() > 0){
							if(bm.getMenuIsBoard2Cate()){
								if(tdCnt == 0){ out.print("<tr>");}
								tdCnt++;
							for(BoardCategoryVO category2 : categoryList2){
								if(bm.getCategoryCode2().equals(category2.getCategoryCode())){
						%>
								<th scope="row">카테고리2</th>
									<td><%=category2.getCategoryName()%></td>
						<%
						if(tdCnt == 2){tdCnt=0; out.print("</tr>");}
								}
							}
							}
						}
						%>

						<%
						if(bm.isViewItem("CATEGORY_CODE3") && categoryList3 != null && categoryList3.size() > 0){
							if(bm.getMenuIsBoard3Cate()){
								if(tdCnt == 0){ out.print("<tr>");}
								tdCnt++;
							for(BoardCategoryVO category3 : categoryList3){
								if(bm.getCategoryCode3().equals(category3.getCategoryCode())){
						%>
								<th scope="row">카테고리3</th>
									<td><%=category3.getCategoryName()%></td>
						<%
						if(tdCnt == 2){tdCnt=0; out.print("</tr>");}
								}
							}
							}
						}
						%>




		<%if(bm.isViewItem("TMP_FIELD1") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("TMP_FIELD1")) { tdCnt++; %>
			<th scope="row">임시필드1</th>
				<td><%=EgovStringUtil.isNullToString(bm.getTmpField1())%></td>
		<% } %>
		<%if(bm.isViewItem("TMP_FIELD1") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(bm.isViewItem("TMP_FIELD2") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("TMP_FIELD2")) { tdCnt++; %>
			<th scope="row">임시필드2</th>
				<td><%=EgovStringUtil.isNullToString(bm.getTmpField2())%></td>
		<% } %>
		<%if(bm.isViewItem("TMP_FIELD2") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(bm.isViewItem("TMP_FIELD3") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("TMP_FIELD3")) { tdCnt++; %>
			<th scope="row">임시필드3</th>
				<td><%=EgovStringUtil.isNullToString(bm.getTmpField3())%></td>
		<% } %>
		<%if(bm.isViewItem("TMP_FIELD3") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(bm.isViewItem("TMP_FIELD4") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("TMP_FIELD4")) { tdCnt++; %>
			<th scope="row">임시필드4</th>
				<td><%=EgovStringUtil.isNullToString(bm.getTmpField4())%></td>
		<% } %>
		<%if(bm.isViewItem("TMP_FIELD4") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(bm.isViewItem("TMP_FIELD5") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("TMP_FIELD5")) { tdCnt++; %>
			<th scope="row">임시필드5</th>
				<td><%=EgovStringUtil.isNullToString(bm.getTmpField5())%></td>
		<% } %>
		<%if(bm.isViewItem("TMP_FIELD5") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%
			int extensionCount = bm.extensionCount();
			for(int i=0;i<extensionCount;i++)
			{
				if(tdCnt == 0){ out.print("<tr>");}
				tdCnt++;
				bm.setExtensionVO(i);
				%>
				<th scope="row"><%=bm.getExtensionDesc() %></th>
					<td><%=bm.getExtensionValue(bm.getExtensionKey())%></td>
				<%
				if(tdCnt == 2){tdCnt=0; out.print("</tr>");}
			}
			%>
			<%if(tdCnt != 0){tdCnt=0; out.print("<td colspan=\"2\"></td>");}%>
			<tr>
			<th scope="row">내용</th>
			<td colspan="3">
				<%
				if(bm.getFileCount() > 0) {
					String fileName = null;
					String ext = null;
					String img = null;
					for(int i=0; i<bm.getFileCount(); i++) {
						BoardFileVO fileVO = (BoardFileVO)bm.getBoardFileVO(i);
						fileName = fileVO.getFileMask();
						ext = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
						if("jpg".equals(ext) || "bmp".equals(ext) || "png".equals(ext) || "gif".equals(ext) || "jpeg".equals(ext)) {
							if("fileUpload".equals(fileVO.getFileId())) {
								img = "/fileUpload/real/" + fileVO.getFileMask();
							} else if("ksboard".equals(fileVO.getFileId())) {
								img = "/ksboard/data/photo/" + fileVO.getFileMask();
							} else {
								img = "/upload_data/board_data/" + fileVO.getBoardId() + "/" + fileVO.getFileMask();
							}
				%>
				<%if("".equals(fileVO.getFileMemo()) || fileVO.getFileMemo()==null){ %>
				<img src="<%=img %>" alt="<%=bm.getDataTitle()%> <%=fileVO.getFileName().substring(0, fileVO.getFileName().length()-4)%>" title="<%=bm.getDataTitle()%> <%=fileVO.getFileName().substring(0, fileVO.getFileName().length()-4)%>" onerror="this.src='/images/no_img.gif';"  /><br>
				<%}else{ %>
				<img src="<%=img %>" alt="<%=fileVO.getFileMemo()%>" title="<%=fileVO.getFileMemo()%>" onerror="this.src='/images/no_img.gif';"  /><br>
				
				<%
				}
						}
					}
				}
				%>
				<%if(bm.getDataContent() != null){ %>
					<%=bm.getDataContent().replace("\r\n","<br>")%>
				<%} %>
			</td>
			</tr>
			<tr>
				<th scope="row">첨부파일</th>
				<td colspan="3">
		<%
					String userAgent = request.getHeader("user-agent");
					if(bm.getFileCount() > 0){
					for(int fcnt = 0;fcnt<bm.getFileCount();fcnt++)
					{
						boolean isMobile = false;
						boolean isHtml5 = !(userAgent.toLowerCase().indexOf("msie 6.0")>-1||userAgent.toLowerCase().indexOf("msie 7.0")>-1||userAgent.toLowerCase().indexOf("msie 8.0")>-1);
						if(userAgent.toLowerCase().indexOf("mobile") >=0)
						{
							isMobile = true;
						}
						if(fcnt > 0)
						{
							%>
							<br/>
							<%
						}
						if(bm.getBoardFileVO(fcnt) != null)
						{
							if("fileUpload".equals(bm.getBoardFileVO(fcnt).getFileId()) || "upload".equals(bm.getBoardFileVO(fcnt).getFileId())
									|| "ksboard".equals(bm.getBoardFileVO(fcnt).getFileId()) || "data".equals(bm.getBoardFileVO(fcnt).getFileId())) {
								out.print(bm.getFileList(bm.getBoardFileVO(fcnt),"<span><a href=\"{fileDown}\" class=\"file\">{fileName} ({fileSize})</a></span> ").replace("<br/>","").replace("(null  kb)","").replace("/board/download.gne", "/program/board/download.jsp"));
							} else {
								out.print(bm.getFileList(bm.getBoardFileVO(fcnt),"<span><a href=\"{fileDown}\" class=\"file\">{fileName} ({fileSize})</a></span> ").replace("<br/>","").replace("(null  kb)",""));
							}
							//out.print(bm.getFileList(bm.getBoardFileVO(fcnt),"<span><a href=\"{fileDown}\" class=\"file\">{fileName} ({fileSize})</a></span> ").replace("<br/>","").replace("(null  kb)",""));
							if(bm.getBoardFileVO(fcnt).getFileId()!=null && !bm.getBoardFileVO(fcnt).getFileId().equals("")){
							out.print(bm.getHtmlViewerIcon(bm.getBoardFileVO(fcnt),"",isMobile).replaceAll("images/egovframework/rfc3/board/images/skin/common","images/sub"));
							}else{
							out.print(bm.getConvertIcon(bm.getBoardFileVO(fcnt),null).replaceAll("images/egovframework/rfc3/board/images/skin/common","images/sub"));
							}


						}
					}
					}
					%>
					</td>
					</tr>
				</tbody>
				</table>
				<p class="read_page" style="margin:20px 0px;">
<!--RFC 공통 버튼 시작-->
<div class="rfc_bbs_btn">
	<%=bm.getViewIcons()%>
</div>
<!--RFC 공통 버튼 끝-->
				</p>
			</section>
			<!-- board_read -->
<%
if(answerList.size() > 0)
{
	for(int j=0; j < answerList.size(); j++) {
		bms.setBoardDataVO(answerList.get(j));
%>
			<table class="board_read02" summary="답변 상세내용입니다">
				<caption><%=bm.getDataTitle()%> 답변 상세내용</caption>
						<colgroup>
						<col width="18%">
						<col width="32%">
						<col width="18%">
						<col width="*">
						</colgroup>
				<thead>
					<tr>
					<th colspan="4"  class="topline"><%=bms.getDataTitle()%></th>
					</tr>
				</thead>
				<tbody>
					<tr>
					<th scope="row">작성자</th>
					<td><%=bms.getUserNick()%></td>
					<th scope="row" class="lline">등록일</th>
					<td><%=bms.getRegister_dt("yyyy/MM/dd")%></td>
					</tr>

			<tr>
			<th scope="row">내용</th>
			<td colspan="3">
				<%
				if(bms.getFileCount() > 0) {
					String fileName = null;
					String ext = null;
					String img = null;
					for(int i=0; i<bms.getFileCount(); i++) {
						BoardFileVO fileVO = (BoardFileVO)bms.getBoardFileVO(i);
						fileName = fileVO.getFileMask();
						ext = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
						if("jpg".equals(ext) || "bmp".equals(ext) || "png".equals(ext) || "gif".equals(ext) || "jpeg".equals(ext)) {
							if("fileUpload".equals(fileVO.getFileId())) {
								img = "/fileUpload/real/" + fileVO.getFileMask();
							} else if("ksboard".equals(fileVO.getFileId())) {
								img = "/ksboard/data/photo/" + fileVO.getFileMask();
							} else {
								img = "/upload_data/board_data/" + fileVO.getBoardId() + "/" + fileVO.getFileMask();
							}
				%>
				<%if("".equals(fileVO.getFileMemo()) || fileVO.getFileMemo()==null){ %>
				<img src="<%=img %>" alt="<%=bm.getDataTitle()%> <%=fileVO.getFileName().substring(0, fileVO.getFileName().length()-4)%>" title="<%=bm.getDataTitle()%> <%=fileVO.getFileName().substring(0, fileVO.getFileName().length()-4)%>" onerror="this.src='/images/no_img.gif';"  /><br>
				<%}else{ %>
				<img src="<%=img %>" alt="<%=fileVO.getFileMemo()%>" title="<%=fileVO.getFileMemo()%>" onerror="this.src='/images/no_img.gif';"  /><br>
				
				<%
				}
						}
					}
				}
				%>
				<%=bms.getDataContent().replace("\r\n","<br>")%>
			</td>
			</tr>
						<tr>
				<th scope="row">첨부파일</th>
				<td colspan="3">
		<%
					String userAgent2 = request.getHeader("user-agent");
					if(bms.getFileCount() > 0){
					for(int fcnt = 0;fcnt<bms.getFileCount();fcnt++)
					{
						boolean isMobile = false;
						boolean isHtml5 = !(userAgent2.toLowerCase().indexOf("msie 6.0")>-1||userAgent2.toLowerCase().indexOf("msie 7.0")>-1||userAgent2.toLowerCase().indexOf("msie 8.0")>-1);
						if(userAgent2.toLowerCase().indexOf("mobile") >=0)
						{
							isMobile = true;
						}
						if(fcnt > 0)
						{
							%>
							<br/>
							<%
						}
						if(bms.getBoardFileVO(fcnt) != null)
						{
							if("fileUpload".equals(bms.getBoardFileVO(fcnt).getFileId()) || "upload".equals(bms.getBoardFileVO(fcnt).getFileId())
									|| "ksboard".equals(bms.getBoardFileVO(fcnt).getFileId()) || "data".equals(bms.getBoardFileVO(fcnt).getFileId())) {
								out.print(bms.getFileList(bms.getBoardFileVO(fcnt),"<span><a href=\"{fileDown}\" class=\"file\">{fileName} ({fileSize})</a></span> ").replace("<br/>","").replace("(null  kb)","").replace("/board/download.gne", "/program/board/download.jsp"));
							} else {
								out.print(bms.getFileList(bms.getBoardFileVO(fcnt),"<span><a href=\"{fileDown}\" class=\"file\">{fileName} ({fileSize})</a></span> ").replace("<br/>","").replace("(null  kb)",""));
							}
							//out.print(bms.getFileList(bms.getBoardFileVO(fcnt),"<span><a href=\"{fileDown}\" class=\"file\">{fileName} ({fileSize})</a></span> ").replace("<br/>","").replace("(null  kb)",""));
							if(bms.getBoardFileVO(fcnt).getFileId()!=null && !bms.getBoardFileVO(fcnt).getFileId().equals("")){
							out.print(bms.getHtmlViewerIcon(bms.getBoardFileVO(fcnt),"",isMobile).replaceAll("images/egovframework/rfc3/board/images/skin/common","images/sub"));
							}else{
							out.print(bms.getConvertIcon(bms.getBoardFileVO(fcnt),null).replaceAll("images/egovframework/rfc3/board/images/skin/common","images/sub"));
							}


						}
					}
					}
					%>
					</td>
					</tr>
				</tbody>
				</table>
<div class="rfc_bbs_btn">
	<%=bms.getViewIcons()%>
</div>
<%	}
}
%>


<%if(bm.isCommentUse())
{
	List<CommentVO> commentVOList = bm.getCommentList();
	%>
	<!-- 코멘트 시작 -->
	<div class="rfc_bbs_point">
		<!--div class="rfc_bbs_point_last">
			코멘트 목록
		</div-->
		<ul class="comment_list">
			<%
			for(CommentVO comment : commentVOList)
			{
				%>
				<li>
					<dl>
						<dt class="comment_name"><%=comment.getDataDep() != 1 ? "<img src=\""+request.getContextPath()+"/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_re.gif\" alt=\"Re\" />" : ""%><%=comment.getUserNick()%></dt>
						<dd class="rfc_bbs_point_star" style="display: none;"><img src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_point_star0<%=comment.getStarPoint()%>.gif" alt="별<%=comment.getStarPoint()%>개" /></dd>
						<dd class="rfc_bbs_point_data"><%=new SimpleDateFormat("yyyy/MM/dd").format(comment.getRegister_dt()).toString()%></dd>
						<dd class="rfc_bbs_point_down" style="display: none;">
						<%
						if(comment.getFileName() != null && !"".equals(comment.getFileName()))
						{
							%>
							<a href="<%=request.getContextPath() %>/board/downloadComment.<%=bm.getUrlExt()%>?dataSid=<%=bm.getDataSid()%>&amp;boardId=<%=bm.getBoardId() %>&amp;commentSid=<%=comment.getCommentSid() %>"><img src="<%=request.getContextPath() %>/images/egovframework/rfc3/board/images/skin/bbs_list_type1/rfc_bbs_file.gif" alt="파일이미지" class="rfc_bbs_point_down_img" /><%=comment.getFileName()%> (<%=comment.getFileSize()%>)</a>
							<%
						}%>
						</dd>
						<dd class="rfc_bbs_point_btn">
							<!--a href="#"><img src="/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_point_btn_answer.gif" alt="답변" /></a>
							<a href="#"><img src="/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_point_btn_modify.gif" alt="수정" /></a-->
							<%=bm.getCommentDelete(request.getContextPath()+"/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_point_btn_delete.gif",comment.getCommentSid(),"") %>
						</dd>
						<dd class="rfc_bbs_point_txt_left_con"><%=comment.getCommentTitle()%></dd>
					</dl>
					<%
					if(comment.getDataDep() == 1)
					{
						%>
						<!--h4><a href="#" onclick="showCommentReply('comment<%=comment.getCommentSid()%>');return false;"><img src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_star_tit.gif" alt="별점평가하기" /></a></h4-->
						<div class="rfc_bbs_star" id="comment<%=comment.getCommentSid()%>" style="display:none;">
							<div class="rfc_bbs_star_last">
								<form name="comment" action="<%=request.getContextPath()%>/board/writeComment.<%=bm.getUrlExt() %>" method="post" class="rfc_bbs_Form" enctype="multipart/form-data">
									<fieldset>
										<legend>코멘트 답변</legend>
										<input type="hidden" name="commentSid" value="<%=comment.getCommentSid()%>" />
										<input type="hidden" name="boardSid" value="<%=bm.getBoardSid()%>" />
										<input type="hidden" name="orderBy" value="<%=bm.getOrderBy()%>" />
										<input type="hidden" name="boardId" value="<%=bm.getBoardId()%>" />
										<input type="hidden" name="dataSid" value="<%=bm.getDataSid()%>" />

										<input type="hidden" name="searchType" value="<%=bm.getSearchType()%>" />
										<input type="hidden" name="keyword" value="<%=bm.getKeyword()%>" />

										<input type="hidden" name="searchStartDt" value="<%=bm.getSearchStartDt()%>" />
										<input type="hidden" name="searchEndDt" value="<%=bm.getSearchEndDt()%>" />
										<input type="hidden" name="startPage" value="<%=bm.getPageNum()%>" />

										<input type="hidden" name="menuCd" value="${menuCd}" />
										<input type="hidden" name="contentsSid" value="${contentsSid}" />

										<div class="rfc_bbs_star_file_write">
											<textarea name="commentTitle" id="textarea" cols="100%" rows="3" title="내용"></textarea>
											<input type="image" src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_btn_star.gif" alt="평가하기" class="rfc_bbs_border_none"/>
										</div>
										<div class="rfc_bbs_star_file_find" style="display: none;">
											<label class="label_block" for="file">* 첨부파일</label>
											<input type="file" name="file" value="" title="첨부파일" class="rfc_bbs_star_file_input" />
										</div>
									</fieldset>
								</form>
							</div>
						</div>
						<%
					}%>
				</li>
				<%
			}%>
		</ul>
	</div>
	<!-- 코멘트 목록 끝 -->


	<!--RFC 공통 페이지 시작-->
	<div class="rfc_bbs_pager">
		<%=bm.printPaging()%>
	</div>
	<!--RFC 공통 페이지 끝-->

	<!-- 코멘트 등록 시작 -->
	<!--h4><img src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_star_tit.gif" alt="별점평가하기" /></h4-->
	<div class="rfc_bbs_star">
		<div class="rfc_bbs_star_last">
			<form name="comment" action="<%=request.getContextPath()%>/board/writeComment.<%=bm.getUrlExt() %>" method="post" class="rfc_bbs_Form" enctype="multipart/form-data">
				<fieldset>
					<input type="hidden" name="boardSid" value="<%=bm.getBoardSid()%>" />
					<input type="hidden" name="orderBy" value="<%=bm.getOrderBy()%>" />
					<input type="hidden" name="boardId" value="<%=bm.getBoardId()%>" />
					<input type="hidden" name="dataSid" value="<%=bm.getDataSid()%>" />

					<input type="hidden" name="searchType" value="<%=bm.getSearchType()%>" />
					<input type="hidden" name="keyword" value="<%=bm.getKeyword()%>" />

					<input type="hidden" name="searchStartDt" value="<%=bm.getSearchStartDt()%>" />
					<input type="hidden" name="searchEndDt" value="<%=bm.getSearchEndDt()%>" />
					<input type="hidden" name="startPage" value="<%=bm.getPageNum()%>" />

					<input type="hidden" name="menuCd" value="${menuCd}" />
					<input type="hidden" name="contentsSid" value="${contentsSid}" />

					<div class="rfc_bbs_star_star" style="display: none;">
						<input type="radio" name="starPoint" id="star_radio01" value="1" title="1점" class="rfc_bbs_border_none rfc_bbs_radio_none"/><img src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_point_star01.gif" alt="별1개" />
						<input type="radio" name="starPoint" id="star_radio02" value="2" title="2점" class="rfc_bbs_border_none rfc_bbs_radio_none" /><img src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_point_star02.gif" alt="별2개" />
						<input type="radio" name="starPoint" id="star_radio03" value="3" title="3점" class="rfc_bbs_border_none rfc_bbs_radio_none" /><img src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_point_star03.gif" alt="별3개" />
						<input type="radio" name="starPoint" id="star_radio04" value="4" title="4점" class="rfc_bbs_border_none rfc_bbs_radio_none" /><img src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_point_star04.gif" alt="별4개" />
						<input type="radio" name="starPoint" id="star_radio05" value="5" title="5점" class="rfc_bbs_border_none rfc_bbs_radio_none" /><img src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_point_star05.gif" alt="별5개" />
					</div>
					<div class="rfc_bbs_star_file_write">
						<textarea name="commentTitle" id="textarea" cols="100%" rows="3" title="내용" style="float:left;width:658px;margin-right:10px;"></textarea>
						<input type="image" src="<%=request.getContextPath()%>/images/btn_comment.jpg" alt="평가하기" class="rfc_bbs_border_none"/>
					</div>
					<div class="rfc_bbs_star_file_find" style="display: none;">
						<label class="label_block" for="file">* 첨부파일</label>
						<input type="file" name="file" id="file" value="" title="첨부파일" class="rfc_bbs_star_file_input" />
					</div>
				</fieldset>
			</form>
		</div>
	</div>
	<!-- 코멘트 등록 끝 -->
	<%
}
%>