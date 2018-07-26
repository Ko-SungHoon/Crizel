<%@ page import = "java.util.*, egovframework.rfc3.board.vo.CommentVO,java.text.SimpleDateFormat" %>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper"%>
<%@ page import="egovframework.rfc3.board.vo.BoardDataVO"%>
<%@ page import="egovframework.rfc3.board.vo.BoardCategoryVO"%>
<%@ page import="egovframework.rfc3.common.util.EgovStringUtil"%>
<%
try{
	ArrayList<BoardDataVO> answerList = (ArrayList<BoardDataVO>)bm.getBoardReplyDataList(bm.getDataIdx());
	BoardManager bms= new BoardManager(request);
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

function fileViewer(file){
	var moveUrl	=	"/transformViewer/viewer.jsp?filePath=" + file;
	window.open(moveUrl, '문서뷰어', 'height=' + screen.availHeight + ',width=' + screen.availWidth + '');
}
</script>
			<!-- board_read -->
			<section class="board">
<table class="board_read02">
				<caption><%=bm.getDataTitle()%>의 작성자, 등록일, 첨부파일, 전화번호, 이메일, 내용 상세보기표입니다.</caption>
				<thead>
					<tr>
					<th scope="col" colspan="4"  class="topline"><%=bm.getDataTitle()%></th>
					</tr>
				</thead>
				<tbody>
					<tr>
					<th scope="row" style="width: 20%;">작성자</th>
					<td style="width: 30%;">
				<%
				if(!bm.isManager() && bm.isSecret()){
						if(bm.getUserNick() != null){
							out.println(bm.getUserNick().substring(0,1));
							for(int a = 1; a < bm.getUserNick().length(); a++){
								out.println("*");
								}
							}
					}else{
						out.println(bm.getUserNick());
					}%>
				</td>
					<th scope="row" class="lline" style="width: 20%;">등록일</th>
					<td style="width: 30%;"><%=bm.getRegister_dt("yyyy/MM/dd")%></td>
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
							String realPath		=	"";
							if("fileUpload".equals(bm.getBoardFileVO(fcnt).getFileId()) || "upload".equals(bm.getBoardFileVO(fcnt).getFileId())
									|| "ksboard".equals(bm.getBoardFileVO(fcnt).getFileId()) || "data".equals(bm.getBoardFileVO(fcnt).getFileId())
									|| "openxx0021".equals(bm.getBoardFileVO(fcnt).getFileId()) || "Labor_Notice".equals(bm.getBoardFileVO(fcnt).getFileId())
									|| "jibang_1".equals(bm.getBoardFileVO(fcnt).getFileId()) || "openxx002".equals(bm.getBoardFileVO(fcnt).getFileId())
									|| "safeguard001".equals(bm.getBoardFileVO(fcnt).getFileId()) || "BBS_0000181".equals(bm.getBoardFileVO(fcnt).getFileId())
									|| "BBS_0000183".equals(bm.getBoardFileVO(fcnt).getFileId())) {
								
								if("fileUpload".equals(bm.getBoardFileVO(fcnt).getFileId())){
									realPath	=	("/fileUpload/real/" + bm.getBoardFileVO(fcnt).getFileMask());
								}else if("upload".equals(bm.getBoardFileVO(fcnt).getFileId())){
									String strYear	=	bm.getRegister_dt("yyyy");
									String strMonth	=	bm.getRegister_dt("MM");
									String strDate	=	bm.getRegister_dt("dd");
									realPath	=	"/upload/mr_board/files/" + strYear + "/" + strMonth + "/" + strDate + "/" + bm.getBoardFileVO(fcnt).getFileMask();
								}else if("ksboard".equals(bm.getBoardFileVO(fcnt).getFileId())){
									realPath	=	"/ksboard/data/board/" + bm.getBoardFileVO(fcnt).getFileMask();
								}else if("data".equals(bm.getBoardFileVO(fcnt).getFileId())){
									realPath	=	"/data/file/";
									if("BBS_0000284".equals(bm.getBoardId())) {
										realPath += "b2_01";
									} else if("BBS_0000241".equals(bm.getBoardId())) {
										realPath += "b3_01";
									} else if("BBS_0000242".equals(bm.getBoardId())) {
										realPath += "b3_01_02";
									} else if("BBS_0000243".equals(bm.getBoardId())) {
										realPath += "b3_02";
									} else if("BBS_0000244".equals(bm.getBoardId())) {
										realPath += "b3_02_02";
									} else if("BBS_0000247".equals(bm.getBoardId())) {
										realPath += "b3_06";
									} else if("BBS_0000249".equals(bm.getBoardId())) {
										realPath += "b4_02";
									} else if("BBS_0000250".equals(bm.getBoardId())) {
										realPath += "b4_03";
									}
									realPath	+=	bm.getBoardFileVO(fcnt).getFileMask();
								}else if("openxx0021".equals(bm.getBoardFileVO(fcnt).getFileMask())){
									realPath = "/upload_data/board_data/openxx0021" + bm.getBoardFileVO(fcnt).getFileMask();
								}else if("Labor_Notice".equals(bm.getBoardFileVO(fcnt).getFileMask())){
									realPath = "/upload_data/board_data/Labor_Notice" + bm.getBoardFileVO(fcnt).getFileMask();
								}else if("jibang_1".equals(bm.getBoardFileVO(fcnt).getFileMask())){
									realPath = "/upload_data/board_data/jibang_1" + bm.getBoardFileVO(fcnt).getFileMask();
								}else if("openxx002".equals(bm.getBoardFileVO(fcnt).getFileMask())){
									realPath = "/upload_data/board_data/openxx002" + bm.getBoardFileVO(fcnt).getFileMask();
								}else if("safeguard001".equals(bm.getBoardFileVO(fcnt).getFileMask())){
									realPath = "/upload_data/board_data/safeguard001" + bm.getBoardFileVO(fcnt).getFileMask();
								}else if("BBS_0000181".equals(bm.getBoardFileVO(fcnt).getFileMask())){
									realPath = "/upload_data/board_data/BBS_0000181" + bm.getBoardFileVO(fcnt).getFileMask();
								}else if("BBS_0000183".equals(bm.getBoardFileVO(fcnt).getFileMask())){
									realPath = "/upload_data/board_data/BBS_0000183" + bm.getBoardFileVO(fcnt).getFileMask();
								}
								
								out.print(bm.getFileList(bm.getBoardFileVO(fcnt),"<span style=\"vertical-align: bottom;\"><a href=\"{fileDown}\">{fileName} ({fileSize})</a></span> ").replace("<br/>","").replace("(null  kb)","").replace("/board/download.gne", "/program/board/download.jsp"));
								out.print("<a href=\"javascript:;\" onclick=\"fileViewer('" + realPath + "');\"> [미리보기] </a>");
							} else {
								realPath		=	bm.getFilePath(fcnt);
								out.print(bm.getFileList(bm.getBoardFileVO(fcnt),"<span style=\"vertical-align: bottom;\"><a href=\"{fileDown}\">{fileName} ({fileSize})</a> &nbsp;</span> "
								+ "<a href=\"javascript:;\" onclick=\"fileViewer('" + realPath + "');\"> [미리보기] </a>").replace("<br/>","").replace("(null  kb)",""));							
							}							
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
			<%
			int tdCnt = 0;
			%>
			<%if(bm.isViewItem("TMP_FIELD1") && tdCnt == 0){ out.print("<tr>");}%>
			<% if(bm.isViewItem("TMP_FIELD1")) { tdCnt++; %>
				<th scope="row" style="width: 20%;">전화번호</th>
					<td style="width: 30%;">
																						<%
					if(!bm.isManager() && !bm.isSecret()){
						out.print("개인정보는 비공개 처리됩니다.");
					}else{
						out.print(EgovStringUtil.isNullToString(bms.getTmpField1()));
					}
				%>
																			</td>
			<% } %>
			<%if(bm.isViewItem("TMP_FIELD1") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

			<%if(bm.isViewItem("USER_EMAIL") && tdCnt == 0){ out.print("<tr>");}%>
			<% if(bm.isViewItem("USER_EMAIL")) { tdCnt++; %>
				<th scope="row" style="width: 20%;">이메일</th>
					<td style="width: 30%;">
					<%
					if(!bm.isManager() && !bm.isSecret()){
						out.print("개인정보는 비공개 처리됩니다.");
					}else{
						out.print(EgovStringUtil.isNullToString(bms.getUserEmail()));
					}
				%></td>
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
			<th scope="row" style="width: 20%;">전화번호</th>
				<td style="width: 30%;">
<%=EgovStringUtil.isNullToString(bm.getUserTel())%>
</td>
		<% } %>
		<%if(bm.isViewItem("USER_TEL") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(bm.isViewItem("USER_CEL") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("USER_CEL")) {  tdCnt++;%>
			<th scope="row" style="width: 20%;">휴대전화</th>
				<td style="width: 30%;"><%=EgovStringUtil.isNullToString(bm.getUserCel())%></td>
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
								<th scope="row" style="width: 20%;">카테고리1</th>
									<td style="width: 30%;"><%=category.getCategoryName()%></td>
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
								<th scope="row" style="width: 20%;">카테고리2</th>
									<td style="width: 30%;"><%=category2.getCategoryName()%></td>
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
								<th scope="row" style="width: 20%;">카테고리3</th>
									<td style="width: 30%;"><%=category3.getCategoryName()%></td>
						<%
						if(tdCnt == 2){tdCnt=0; out.print("</tr>");}
								}
							}
							}
						}
						%>






		<%if(bm.isViewItem("TMP_FIELD2") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("TMP_FIELD2")) { tdCnt++; %>
			<th scope="row" style="width: 20%;">임시필드2</th>
				<td style="width: 30%;"><%=EgovStringUtil.isNullToString(bm.getTmpField2())%></td>
		<% } %>
		<%if(bm.isViewItem("TMP_FIELD2") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(bm.isViewItem("TMP_FIELD3") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("TMP_FIELD3")) { tdCnt++; %>
			<th scope="row" style="width: 20%;">임시필드3</th>
				<td style="width: 30%;"><%=EgovStringUtil.isNullToString(bm.getTmpField3())%></td>
		<% } %>
		<%if(bm.isViewItem("TMP_FIELD3") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(bm.isViewItem("TMP_FIELD4") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("TMP_FIELD4")) { tdCnt++; %>
			<th scope="row" style="width: 20%;">임시필드4</th>
				<td style="width: 30%;"><%=EgovStringUtil.isNullToString(bm.getTmpField4())%></td>
		<% } %>
		<%if(bm.isViewItem("TMP_FIELD4") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(bm.isViewItem("TMP_FIELD5") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("TMP_FIELD5")) { tdCnt++; %>
			<th scope="row" style="width: 20%;">임시필드5</th>
				<td style="width: 30%;"><%=EgovStringUtil.isNullToString(bm.getTmpField5())%></td>
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
				<th scope="row" style="width: 20%;"><%=bm.getExtensionDesc() %></th>
					<td style="width: 30%;"><%=bm.getExtensionValue(bm.getExtensionKey())%></td>
				<%
				if(tdCnt == 2){tdCnt=0; out.print("</tr>");}
			}
			%>
			<%if(tdCnt != 0){tdCnt=0; out.print("<td colspan=\"2\"></td>");}%>
			<tr>
			<th scope="row">내용</th>
			<td colspan="3"><%=bm.getDataContent().replace("\r\n","<br>")%><br>
				<%
					int [] ext = bm.searchFileNameExt("jpg|bmp|png");
					for(int i=0;i<ext.length;i++)
					{
						%>
						<img src="<%=bm.getThumbnailPath(ext[i]) %>"  onError="this.src='<%=bm.getFilePath(ext[i]) %>'" style="max-width:500px;" alt="<%=bm.getDataTitle()%> 첨부이미지 <%=i%>" />	<br>

						<%
					}
					%>

			</td>
			<tr>
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
if(answerList.size() > 0 )
{
	for(int j=0; j < answerList.size(); j++) {
		bms.setBoardDataVO(answerList.get(j));
		if(!bms.isSecret() || bm.isManager() || sm.getId().equals(bm.getUserId())){
%>
			<section class="board">
<table class="board_read02">
				<caption><%=bms.getDataTitle()%> 상세보기</caption>
				<thead>
					<tr>
					<th colspan="4"  class="topline"><%=bms.getDataTitle()%></th>
					</tr>
				</thead>
				<tbody>
					<tr>
					<th scope="row" style="width: 20%;">작성자</th>
					<td style="width: 30%;"><%=bms.getUserNick()%></td>
					<th scope="row" class="lline" style="width: 20%;">등록일</th>
					<td style="width: 30%;"><%=bms.getRegister_dt("yyyy/MM/dd")%></td>
					</tr>
				<tr>
				<th scope="row">첨부파일</th>
				<td colspan="3">
		<%
					userAgent = request.getHeader("user-agent");
					if(bms.getFileCount() > 0){
					for(int fcnt = 0;fcnt<bms.getFileCount();fcnt++)
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
						if(bms.getBoardFileVO(fcnt) != null)
						{
							String realPath		=	"";
							if("fileUpload".equals(bms.getBoardFileVO(fcnt).getFileId()) || "upload".equals(bms.getBoardFileVO(fcnt).getFileId())
									|| "ksboard".equals(bms.getBoardFileVO(fcnt).getFileId()) || "data".equals(bms.getBoardFileVO(fcnt).getFileId())
									|| "openxx0021".equals(bms.getBoardFileVO(fcnt).getFileId()) || "Labor_Notice".equals(bms.getBoardFileVO(fcnt).getFileId())
									|| "jibang_1".equals(bms.getBoardFileVO(fcnt).getFileId()) || "openxx002".equals(bms.getBoardFileVO(fcnt).getFileId())
									|| "safeguard001".equals(bms.getBoardFileVO(fcnt).getFileId()) || "BBS_0000181".equals(bms.getBoardFileVO(fcnt).getFileId())
									|| "BBS_0000183".equals(bms.getBoardFileVO(fcnt).getFileId())) {
								
								if("fileUpload".equals(bms.getBoardFileVO(fcnt).getFileId())){
									realPath	=	("/fileUpload/real/" + bms.getBoardFileVO(fcnt).getFileMask());
								}else if("upload".equals(bms.getBoardFileVO(fcnt).getFileId())){
									String strYear	=	bms.getRegister_dt("yyyy");
									String strMonth	=	bms.getRegister_dt("MM");
									String strDate	=	bms.getRegister_dt("dd");
									realPath	=	"/upload/mr_board/files/" + strYear + "/" + strMonth + "/" + strDate + "/" + bms.getBoardFileVO(fcnt).getFileMask();
								}else if("ksboard".equals(bms.getBoardFileVO(fcnt).getFileId())){
									realPath	=	"/ksboard/data/board/" + bms.getBoardFileVO(fcnt).getFileMask();
								}else if("data".equals(bms.getBoardFileVO(fcnt).getFileId())){
									realPath	=	"/data/file/";
									if("BBS_0000284".equals(bms.getBoardId())) {
										realPath += "b2_01";
									} else if("BBS_0000241".equals(bms.getBoardId())) {
										realPath += "b3_01";
									} else if("BBS_0000242".equals(bms.getBoardId())) {
										realPath += "b3_01_02";
									} else if("BBS_0000243".equals(bms.getBoardId())) {
										realPath += "b3_02";
									} else if("BBS_0000244".equals(bms.getBoardId())) {
										realPath += "b3_02_02";
									} else if("BBS_0000247".equals(bms.getBoardId())) {
										realPath += "b3_06";
									} else if("BBS_0000249".equals(bms.getBoardId())) {
										realPath += "b4_02";
									} else if("BBS_0000250".equals(bms.getBoardId())) {
										realPath += "b4_03";
									}
									realPath	+=	bms.getBoardFileVO(fcnt).getFileMask();
								}else if("openxx0021".equals(bms.getBoardFileVO(fcnt).getFileId())){
									realPath = "/upload_data/board_data/openxx0021" + bms.getBoardFileVO(fcnt).getFileMask();
								}else if("Labor_Notice".equals(bms.getBoardFileVO(fcnt).getFileId())){
									realPath = "/upload_data/board_data/Labor_Notice" + bms.getBoardFileVO(fcnt).getFileMask();
								}else if("jibang_1".equals(bms.getBoardFileVO(fcnt).getFileId())){
									realPath = "/upload_data/board_data/jibang_1" + bms.getBoardFileVO(fcnt).getFileMask();
								}else if("openxx002".equals(bms.getBoardFileVO(fcnt).getFileId())){
									realPath = "/upload_data/board_data/openxx002" + bms.getBoardFileVO(fcnt).getFileMask();
								}else if("safeguard001".equals(bms.getBoardFileVO(fcnt).getFileId())){
									realPath = "/upload_data/board_data/safeguard001" + bms.getBoardFileVO(fcnt).getFileMask();
								}else if("BBS_0000181".equals(bms.getBoardFileVO(fcnt).getFileId())){
									realPath = "/upload_data/board_data/BBS_0000181" + bms.getBoardFileVO(fcnt).getFileMask();
								}else if("BBS_0000183".equals(bms.getBoardFileVO(fcnt).getFileId())){
									realPath = "/upload_data/board_data/BBS_0000183" + bms.getBoardFileVO(fcnt).getFileMask();
								}
								
								
								out.print(bms.getFileList(bms.getBoardFileVO(fcnt),"<span style=\"vertical-align: bottom;\"><a href=\"{fileDown}\">{fileName} ({fileSize})</a></span> ").replace("<br/>","").replace("(null  kb)","").replace("/board/download.gne", "/program/board/download.jsp"));
								out.print("<a href=\"javascript:;\" onclick=\"fileViewer('" + realPath + "');\"> [미리보기] </a>");
							} else {
								realPath		=	bms.getFilePath(fcnt);
								out.print(bms.getFileList(bms.getBoardFileVO(fcnt),"<span style=\"vertical-align: bottom;\"><a href=\"{fileDown}\">{fileName} ({fileSize})</a> &nbsp;</span> "
								+ "<a href=\"javascript:;\" onclick=\"fileViewer('" + realPath + "');\"> [미리보기] </a>").replace("<br/>","").replace("(null  kb)",""));							
							}
							
							/* if(bms.getBoardFileVO(fcnt).getFileId()!=null && !bm.getBoardFileVO(fcnt).getFileId().equals("")){
							out.print(bms.getHtmlViewerIcon(bms.getBoardFileVO(fcnt),"",isMobile).replaceAll("images/egovframework/rfc3/board/images/skin/common","images/sub"));
							}else{
							out.print(bms.getConvertIcon(bms.getBoardFileVO(fcnt),null).replaceAll("images/egovframework/rfc3/board/images/skin/common","images/sub"));
							} */


						}
					}
					}
					%>
					</td>
					</tr>
			<%
			tdCnt = 0;
			%>
			<%if(bms.isViewItem("TMP_FIELD1") && tdCnt == 0){ out.print("<tr>");}%>
			<% if(bms.isViewItem("TMP_FIELD1")) { tdCnt++; %>
				<th scope="row" style="width: 20%;">전화번호</th>
					<td style="width: 30%;">
				<%
					if(!bm.isManager() && !bm.isSecret()){
						out.print("개인정보는 비공개 처리됩니다.");
					}else{
						out.print(EgovStringUtil.isNullToString(bms.getTmpField1()));
					}
				%>
				</td>
			<% } %>
			<%if(bms.isViewItem("TMP_FIELD1") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

			<%if(bms.isViewItem("USER_EMAIL") && tdCnt == 0){ out.print("<tr>");}%>
			<% if(bms.isViewItem("USER_EMAIL")) { tdCnt++; %>
				<th scope="row" style="width: 20%;">이메일</th>
					<td style="width: 30%;">
				<%
					if(!bm.isManager() && !bm.isSecret()){
						out.print("개인정보는 비공개 처리됩니다.");
					}else{
						out.print(EgovStringUtil.isNullToString(bms.getUserEmail()));
					}
				%>
				</td>
			<% } %>
			<%if(bms.isViewItem("USER_EMAIL") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(tdCnt != 0){tdCnt=0; out.print("<td colspan=\"2\"></td>");}%>
		<% if(bms.isViewItem("USER_HOMEPAGE")) { %>
			<tr>
			<th scope="row">홈페이지</th>
			<td colspan="3"><%=EgovStringUtil.isNullToString(bms.getUserHomepage())%></td>
			<tr>
		<% } %>

		<%if(bms.isViewItem("USER_TEL") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bms.isViewItem("USER_TEL")) { tdCnt++; %>
			<th scope="row" style="width: 20%;">전화번호</th>
				<td style="width: 30%;">
			<%
					if(!bm.isManager() && !bm.isSecret()){
						out.print("개인정보는 비공개 처리됩니다.");
					}else{
						out.print(EgovStringUtil.isNullToString(bms.getUserTel()));
					}
			%>
			</td>
		<% } %>
		<%if(bms.isViewItem("USER_TEL") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(bms.isViewItem("USER_CEL") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bms.isViewItem("USER_CEL")) {  tdCnt++;%>
			<th scope="row" style="width: 20%;">휴대전화</th>
				<td style="width: 30%;"><%=EgovStringUtil.isNullToString(bms.getUserCel())%></td>
		<% } %>
		<%if(bms.isViewItem("USER_CEL") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(tdCnt != 0){tdCnt=0; out.print("<td colspan=\"2\"></td>");}%>
		<% if(bms.isViewItem("USER_ZIPCODE") || bms.isViewItem("USER_ADDRESS") || bms.isViewItem("USER_DETAILADDR")) { %>
			<tr>
			<th scope="row">주소</th>
			<td colspan="3">
				<% if(bms.isViewItem("USER_ZIPCODE")){ %>
			(<%=EgovStringUtil.isNullToString(bms.getUserZipcode())%>)
			<% } %>

			<% if(bms.isViewItem("USER_ADDRESS")){ %>
			<%=EgovStringUtil.isNullToString(bms.getUserAddress())%>
			<% } %>

			<% if(bms.isViewItem("USER_DETAILADDR")){ %>
			&nbsp;&nbsp;<%=EgovStringUtil.isNullToString(bms.getUserDetailAddr())%>
			<% } %>
			</td>
			</tr>
		<% } %>


		<%
						if(bms.isViewItem("CATEGORY_CODE1") && categoryList1 != null && categoryList1.size() > 0){
							if(bms.getMenuIsBoard1Cate()){
								if(tdCnt == 0){ out.print("<tr>");}
								tdCnt++;
								for(BoardCategoryVO category : categoryList1){
									if(bms.getCategoryCode1().equals(category.getCategoryCode())){
						%>
								<th scope="row" style="width: 20%;">카테고리1</th>
									<td style="width: 30%;"><%=category.getCategoryName()%></td>
						<%
								if(tdCnt == 2){tdCnt=0; out.print("</tr>");}
									}
								}
							}
						}
						%>


						<%
						if(bms.isViewItem("CATEGORY_CODE2") && categoryList2 != null && categoryList2.size() > 0){
							if(bms.getMenuIsBoard2Cate()){
								if(tdCnt == 0){ out.print("<tr>");}
								tdCnt++;
							for(BoardCategoryVO category2 : categoryList2){
								if(bms.getCategoryCode2().equals(category2.getCategoryCode())){
						%>
								<th scope="row" style="width: 20%;">카테고리2</th>
									<td style="width: 30%;"><%=category2.getCategoryName()%></td>
						<%
						if(tdCnt == 2){tdCnt=0; out.print("</tr>");}
								}
							}
							}
						}
						%>

						<%
						if(bms.isViewItem("CATEGORY_CODE3") && categoryList3 != null && categoryList3.size() > 0){
							if(bms.getMenuIsBoard3Cate()){
								if(tdCnt == 0){ out.print("<tr>");}
								tdCnt++;
							for(BoardCategoryVO category3 : categoryList3){
								if(bms.getCategoryCode3().equals(category3.getCategoryCode())){
						%>
								<th scope="row" style="width: 20%;">카테고리3</th>
									<td style="width: 30%;"><%=category3.getCategoryName()%></td>
						<%
						if(tdCnt == 2){tdCnt=0; out.print("</tr>");}
								}
							}
							}
						}
						%>






		<%if(bms.isViewItem("TMP_FIELD2") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bms.isViewItem("TMP_FIELD2")) { tdCnt++; %>
			<th scope="row" style="width: 20%;">임시필드2</th>
				<td style="width: 30%;"><%=EgovStringUtil.isNullToString(bms.getTmpField2())%></td>
		<% } %>
		<%if(bms.isViewItem("TMP_FIELD2") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(bms.isViewItem("TMP_FIELD3") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bms.isViewItem("TMP_FIELD3")) { tdCnt++; %>
			<th scope="row" style="width: 20%;">임시필드3</th>
				<td style="width: 30%;"><%=EgovStringUtil.isNullToString(bms.getTmpField3())%></td>
		<% } %>
		<%if(bms.isViewItem("TMP_FIELD3") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(bms.isViewItem("TMP_FIELD4") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bms.isViewItem("TMP_FIELD4")) { tdCnt++; %>
			<th scope="row" style="width: 20%;">임시필드4</th>
				<td style="width: 30%;"><%=EgovStringUtil.isNullToString(bms.getTmpField4())%></td>
		<% } %>
		<%if(bms.isViewItem("TMP_FIELD4") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(bms.isViewItem("TMP_FIELD5") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bms.isViewItem("TMP_FIELD5")) { tdCnt++; %>
			<th scope="row" style="width: 20%;">임시필드5</th>
				<td style="width: 30%;"><%=EgovStringUtil.isNullToString(bms.getTmpField5())%></td>
		<% } %>
		<%if(bms.isViewItem("TMP_FIELD5") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%
			extensionCount = bms.extensionCount();
			for(int i=0;i<extensionCount;i++)
			{
				if(tdCnt == 0){ out.print("<tr>");}
				tdCnt++;
				bms.setExtensionVO(i);
				%>
				<th scope="row" style="width: 20%;"><%=bms.getExtensionDesc() %></th>
					<td style="width: 30%;"><%=bms.getExtensionValue(bms.getExtensionKey())%></td>
				<%
				if(tdCnt == 2){tdCnt=0; out.print("</tr>");}
			}
			%>
			<%if(tdCnt != 0){tdCnt=0; out.print("<td colspan=\"2\"></td>");}%>
			<tr>
			<th scope="row">내용</th>
			<td colspan="3"><%=bms.getDataContent().replace("\r\n","<br>")%><br>
				<%
					ext = bms.searchFileNameExt("jpg|bmp|png");
					for(int i=0;i<ext.length;i++)
					{
						%>
						<img src="<%=bms.getThumbnailPath(ext[i]) %>"  onError="this.src='<%=bms.getFilePath(ext[i]) %>'" style="max-width:500px;" alt="<%=bms.getDataTitle()%> 첨부 이미지 <%=i%>" />	<br>

						<%
					}
					%>

			</td>
			<tr>
				</tbody>
				</table>
				<p class="read_page" style="margin:20px 0px;">
				<!--RFC 공통 버튼 시작-->
				<div class="rfc_bbs_btn">
					<%=bms.getViewIcons()%>
				</div>
				<!--RFC 공통 버튼 끝-->
								</p>
											</section>
<%	}
	}
}
%>

<%
String ipAddress = request.getRemoteAddr();
if("115.91.44.58".equals(ipAddress)) {
%>

<%if(bm.isCommentUse())
{
	List<CommentVO> commentVOList = bm.getCommentList();
	%>
	<!-- RFC 별점&평가 시작 -->
	<div class="rfc_bbs_point">
		<div class="rfc_bbs_point_last">
			별점&amp;평가
		</div>
		<ul>
			<%
			for(CommentVO comment : commentVOList)
			{
				%>
				<li>
					<dl>
						<dt><%=comment.getDataDep() != 1 ? "<img src=\""+request.getContextPath()+"/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_re.gif\" alt=\"Re\" />" : ""%><%=comment.getUserNick()%></dt>
						<dd class="rfc_bbs_point_star"><img src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_point_star0<%=comment.getStarPoint()%>.gif" alt="별<%=comment.getStarPoint()%>개" /></dd>
						<dd class="rfc_bbs_point_data"><%=new SimpleDateFormat("yyyy/MM/dd").format(comment.getRegister_dt()).toString()%></dd>
						<dd class="rfc_bbs_point_down" style="display:none">
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
						<dd class="rfc_bbs_point_txt_left_con" style="display:none"><%=comment.getCommentTitle()%></dd>
					</dl>
					<%
					if(comment.getDataDep() == 1)
					{
						%>
						<h4 style="display:none;"><a href="#" onclick="showCommentReply('comment<%=comment.getCommentSid()%>');return false;"><img src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_star_tit.gif" alt="별점평가하기" /></a></h4>
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

										<div class="rfc_bbs_star_file_write" style="display:none">
											<textarea name="commentTitle" id="textarea" cols="100%" rows="3" title="내용"></textarea>
											<input type="image" src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_btn_star.gif" alt="평가하기" class="rfc_bbs_border_none"/>
										</div>
										<div class="rfc_bbs_star_file_find" style="display:none">
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
	<!-- RFC 별점&평가 끝 -->


	<!--RFC 공통 페이지 시작-->
	<div class="rfc_bbs_pager">
		<%=bm.printPaging()%>
	</div>
	<!--RFC 공통 페이지 끝-->

	<!-- RFC 별점평가하기 시작 -->
	<h4><img src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_star_tit.gif" alt="별점평가하기" /></h4>
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

					<div class="rfc_bbs_star_star">
						<input type="radio" name="starPoint" id="star_radio01" value="1" title="1점" class="rfc_bbs_border_none rfc_bbs_radio_none"/><img src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_point_star01.gif" alt="별1개" />
						<input type="radio" name="starPoint" id="star_radio02" value="2" title="2점" class="rfc_bbs_border_none rfc_bbs_radio_none" /><img src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_point_star02.gif" alt="별2개" />
						<input type="radio" name="starPoint" id="star_radio03" value="3" title="3점" class="rfc_bbs_border_none rfc_bbs_radio_none" /><img src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_point_star03.gif" alt="별3개" />
						<input type="radio" name="starPoint" id="star_radio04" value="4" title="4점" class="rfc_bbs_border_none rfc_bbs_radio_none" /><img src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_point_star04.gif" alt="별4개" />
						<input type="radio" name="starPoint" id="star_radio05" value="5" title="5점" class="rfc_bbs_border_none rfc_bbs_radio_none" /><img src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_point_star05.gif" alt="별5개" />
					</div>
					<div class="rfc_bbs_star_file_write">
						<textarea name="commentTitle" id="textarea" cols="100%" rows="3" title="내용" style="display:none"></textarea>
						<input type="image" src="<%=request.getContextPath()%>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_btn_star.gif" alt="평가하기" class="rfc_bbs_border_none"/>
					</div>
					<div class="rfc_bbs_star_file_find" style="display:none">
						<label class="label_block" for="file">* 첨부파일</label>
						<input type="file" name="file" id="file" value="" title="첨부파일" class="rfc_bbs_star_file_input" />
					</div>
				</fieldset>
			</form>
		</div>
	</div>
	<!-- RFC 별점평가하기 끝 -->
	<%
}
%>

<%
}

}catch(Exception e){
	out.println(e.toString());
}
%>