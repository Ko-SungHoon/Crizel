<%@ page import = "java.util.*, egovframework.rfc3.board.vo.CommentVO,java.text.SimpleDateFormat" %>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper"%>
<%@ page import="egovframework.rfc3.board.vo.BoardDataVO"%>
<%@ page import="egovframework.rfc3.board.vo.BoardCategoryVO"%>
<%@ page import="egovframework.rfc3.common.util.EgovStringUtil"%>
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
			<%
			String userNick = "";
			int userNickCnt	= 0;
			if(bm.isSecret()){
				userNickCnt = bm.getUserNick().length();
				userNick = bm.getUserNick().substring(0,1);
				for(int userCnt = 1; userCnt < userNickCnt; userCnt++){
					userNick += "*";
				}
			}else{
				userNick = bm.getUserNick();
			}
			%>
			<table class="board_read02" summary="제목, 작성자, 전화번호, 전자우편, 개인정보동의여부, 내용, 첨부파일 등의 알림마당>채용정보>구직 게시글에 대한 정보를 입력함.">
				<caption>알림마당&gt;채용정보&gt;구직 게시글 입력</caption>
				<thead>
					<tr>
					<th colspan="4"  class="topline"><%=bm.getDataTitle()%></th>
					</tr>
				</thead>
				<tbody>
					<tr>
					<th scope="row" width="20%">작성자</th>
					<td width="30%"><%=userNick%></td>
					<th scope="row" class="lline" width="20%">등록일</th>
					<td width="30%"><%=bm.getRegister_dt("yyyy/MM/dd")%></td>
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
							out.print(bm.getFileList(bm.getBoardFileVO(fcnt),"<span style=\"vertical-align: bottom;\"><a href=\"{fileDown}\">{fileName} ({fileSize})</a></span> ").replace("<br/>","").replace("(null  kb)",""));
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
			<%if(bm.isViewItem("USER_EMAIL") && tdCnt == 0){ out.print("<tr>");}%>
			<% if(bm.isViewItem("USER_EMAIL")) { tdCnt++; %>
				<th scope="row" width="20%">전자우편</th>
					<td width="30%"><%=EgovStringUtil.isNullToString(bm.getUserEmail())%></td>
			<% } %>
			<%if(bm.isViewItem("USER_EMAIL") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(tdCnt != 0){tdCnt=0; out.print("<td colspan=\"2\"></td>");}%>
		<% if(bm.isViewItem("USER_HOMEPAGE")) { %>
			<tr>
			<th scope="row">전화번호</th>
			<td colspan="3"><%=EgovStringUtil.isNullToString(bm.getUserHomepage())%></td>
			<tr>
		<% } %>

		<%if(bm.isViewItem("USER_TEL") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("USER_TEL")) { tdCnt++; %>
			<th scope="row" width="20%">전화번호</th>
				<td width="30%"><%=EgovStringUtil.isNullToString(bm.getUserTel())%></td>
		<% } %>
		<%if(bm.isViewItem("USER_TEL") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(bm.isViewItem("USER_CEL") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("USER_CEL")) {  tdCnt++;%>
			<th scope="row" width="20%">휴대전화</th>
				<td width="30%"><%=EgovStringUtil.isNullToString(bm.getUserCel())%></td>
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
								<th scope="row" width="20%">카테고리1</th>
									<td width="30%"><%=category.getCategoryName()%></td>
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
								<th scope="row" width="20%">카테고리2</th>
									<td width="30%"><%=category2.getCategoryName()%></td>
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
								<th scope="row" width="20%">카테고리3</th>
									<td width="30%"><%=category3.getCategoryName()%></td>
						<%
						if(tdCnt == 2){tdCnt=0; out.print("</tr>");}
								}
							}
							}
						}
						%>




		<%if(bm.isViewItem("TMP_FIELD1") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("TMP_FIELD1")) { tdCnt++; %>
			<th scope="row" width="20%">임시필드1</th>
				<td width="30%"><%=EgovStringUtil.isNullToString(bm.getTmpField1())%></td>
		<% } %>
		<%if(bm.isViewItem("TMP_FIELD1") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(bm.isViewItem("TMP_FIELD2") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("TMP_FIELD2")) { tdCnt++; %>
			<th scope="row" width="20%">임시필드2</th>
				<td width="30%"><%=EgovStringUtil.isNullToString(bm.getTmpField2())%></td>
		<% } %>
		<%if(bm.isViewItem("TMP_FIELD2") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(bm.isViewItem("TMP_FIELD3") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("TMP_FIELD3")) { tdCnt++; %>
			<th scope="row" width="20%">임시필드3</th>
				<td width="30%"><%=EgovStringUtil.isNullToString(bm.getTmpField3())%></td>
		<% } %>
		<%if(bm.isViewItem("TMP_FIELD3") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(bm.isViewItem("TMP_FIELD4") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("TMP_FIELD4")) { tdCnt++; %>
			<th scope="row" width="20%">임시필드4</th>
				<td width="30%"><%=EgovStringUtil.isNullToString(bm.getTmpField4())%></td>
		<% } %>
		<%if(bm.isViewItem("TMP_FIELD4") && tdCnt == 2){tdCnt=0; out.print("</tr>");}%>

		<%if(bm.isViewItem("TMP_FIELD5") && tdCnt == 0){ out.print("<tr>");}%>
		<% if(bm.isViewItem("TMP_FIELD5")) { tdCnt++; %>
			<th scope="row" width="20%">임시필드5</th>
				<td width="30%"><%=EgovStringUtil.isNullToString(bm.getTmpField5())%></td>
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
				<th scope="row" width="20%"><%=bm.getExtensionDesc() %></th>
					<td width="30%"><%=bm.getExtensionValue(bm.getExtensionKey())%></td>
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
						<img src="<%=bm.getThumbnailPath(ext[i]) %>"  onError="this.src='<%=bm.getFilePath(ext[i]) %>'" style="max-width:500px;" />	<br>
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