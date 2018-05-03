<%@ page import = "java.util.*, egovframework.rfc3.board.vo.CommentVO,java.text.SimpleDateFormat" %>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper"%>
<%@ page import="egovframework.rfc3.board.vo.BoardDataVO"%>
<%@ page import="egovframework.rfc3.board.vo.BoardCategoryVO"%>
<%@ page import="egovframework.rfc3.common.util.EgovStringUtil"%>
<%@page import="egovframework.rfc3.board.vo.BoardFileVO"%>
<%
	ArrayList<BoardDataVO> answerList = (ArrayList<BoardDataVO>)bm.getBoardReplyDataList(bm.getDataIdx());
%>
<%
		BoardManager bms= new BoardManager(request);
%>
<section class="board">
<table class="board_read02">  
		     <caption><%=bm.getDataTitle()%>의 작성자, 등록일, 첨부파일, 내용 등 상세보기표입니다.</caption>
		     <thead>
		      <tr>
		       <th scope="col" colspan="4"  class="topline"><%=bm.getDataTitle()%></th>
		      </tr>
		     </thead>
		     <tbody>
		      <tr>
		       <th scope="row" style="width: 20%;">작성자</th>
		       <td style="width: 30%;"><%=bm.getUserNick()%></td>
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

<%
if(answerList.size() > 0)
{
	for(int j=0; j < answerList.size(); j++) {
		bms.setBoardDataVO(answerList.get(j));
%>
			<section class="board">
			<table class="board_read02">
				<caption><%=bm.getDataTitle()%>의 작성자, 등록일, 첨부파일, 내용등 답변상세내용표입니다.</caption>
				<thead>
					<tr>
					<th scope="col" colspan="4"  class="topline"><%=bms.getDataTitle()%></th>
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
								out.print(bms.getFileList(bms.getBoardFileVO(fcnt),"<span style=\"vertical-align: bottom;\"><a href=\"{fileDown}\">{fileName} ({fileSize})</a></span> ").replace("<br/>","").replace("(null  kb)","").replace("/board/download.gne", "/program/board/download.jsp"));
							} else {
								out.print(bms.getFileList(bms.getBoardFileVO(fcnt),"<span style=\"vertical-align: bottom;\"><a href=\"{fileDown}\">{fileName} ({fileSize})</a></span> ").replace("<br/>","").replace("(null  kb)",""));
							}
							//out.print(bms.getFileList(bms.getBoardFileVO(fcnt),"<span style=\"vertical-align: bottom;\"><a href=\"{fileDown}\">{fileName} ({fileSize})</a></span> ").replace("<br/>","").replace("(null  kb)",""));
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
			<tr>
			<th scope="row">내용</th>
			<td colspan="3"><%=bms.getDataContent().replace("\r\n","<br>")%><br>
				<%-- // 첨부파일 이미지 출력 주석처리
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
				<img src="<%=img %>"  onerror="this.src='/images/no_img.gif';"  /><br>
				<%

						}
					}
				}
				--%>

			</td>
			</tr>
				</tbody>
				</table>
<div class="rfc_bbs_btn">
	<%=bms.getViewIcons()%>
</div>
</section>
<%	}
}
%>								