<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper"%>
<%@ page import="java.util.*, egovframework.rfc3.board.vo.BoardVO, egovframework.rfc3.board.vo.BoardCategoryVO"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<%
List<BoardCategoryVO> categoryList1 = bm.getCategoryList1();
List<BoardCategoryVO> categoryList2 = bm.getCategoryList2();
List<BoardCategoryVO> categoryList3 = bm.getCategoryList3();

//목록 항목 갯수	
int listCount = bm.listItemCount();
%>
			<section class="board">
				<div class="search">
<form action="<%=request.getContextPath() %>/board/list.<%=bm.getUrlExt()%>" name="rfc_bbs_searchForm" class="rfc_bbs_searchForm" method="get">
				<fieldset>
					<legend>전체검색</legend>

						<input type="hidden" name="orderBy" value="<%=bm.getOrderBy()%>" />
						<input type="hidden" name="boardId" value="<%=bm.getBoardId()%>" />

						
<%
				if( (categoryList1 != null && categoryList1.size() > 0) || (categoryList2 != null && categoryList2.size() > 0) || (categoryList3 != null && categoryList3.size() > 0))
					{ 
			%>
								<% 
						if(categoryList1 != null && categoryList1.size() > 0){ 
							if(bm.getMenuIsBoard1Cate()){
						%>
								<select name="categoryCode1" id="categoryCode1" class="layout_select" title="카테고리1">
								<option value="">1차 카테고리</option>
						<% 
								for(BoardCategoryVO category : categoryList1){ 
						%>
									<option value="<%=category.getCategoryCode()%>" <%if(bm.getSearchCategoryCode1().equals(category.getCategoryCode()))out.print("selected");%>><%=category.getCategoryName()%></option>
						<% 
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
					}
			%>
									<% 
						if(categoryList2 != null && categoryList2.size() > 0){ 
							if(bm.getMenuIsBoard2Cate()){
						%>
							<select name="categoryCode2" id="categoryCode2" class="layout_select"  title="카테고리2">
							<option value="">2차 카테고리</option>
						<% 
							for(BoardCategoryVO category2 : categoryList2){ 
						%>
								<option value="<%=category2.getCategoryCode()%>" <%if(bm.getSearchCategoryCode2().equals(category2.getCategoryCode()))out.print("selected");%>><%=category2.getCategoryName()%></option>
						<% 
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
						if(categoryList3 != null && categoryList3.size() > 0){ 
							if(bm.getMenuIsBoard3Cate()){
						%>
							<select name="categoryCode3" id="categoryCode3" class="layout_select"  title="카테고리3">
							<option value="">3차 카테고리</option>
						<% 
							for(BoardCategoryVO category3 : categoryList3){ 
						%>
								<option value="<%=category3.getCategoryCode()%>" <%if(bm.getSearchCategoryCode3().equals(category3.getCategoryCode()))out.print("selected");%>><%=category3.getCategoryName()%></option>
						<% 
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



<!--


						<select name="key" id="key" class="text" title="검색항목을 선택하세요">
						<option value="subject">제목</option>
						<option value="content">내용</option>
						<option value="all">제목+내용</option>
						</select>
						<label for="keyword">검색어 입력</label><input type="text" name="keyword" id="keyword" placeholder="검색어 입력" class="text"  style="ime-mode:active;" />
						<button>검색</button>
					</form>

-->









						<input type="hidden" name="searchStartDt" value="<%=bm.getSearchStartDt()%>" />
						<input type="hidden" name="searchEndDt" value="<%=bm.getSearchEndDt()%>" />
						<input type="hidden" name="startPage" value="1" />
						
						<input type="hidden" name="menuCd" value="${menuCd}" />
						<input type="hidden" name="contentsSid" value="${contentsSid}" />
						<select name="searchType" class="text" title="검색항목을 선택하세요" >
							<!-- <option value="">선택</option> -->
							<option value="DATA_TITLE" <%=bm.getSearchType().equals("DATA_TITLE") ? "selected" : "" %>>제목</option>
							<option value="DATA_CONTENT" <%=bm.getSearchType().equals("DATA_CONTENT") ? "selected" : "" %>>내용</option>
							<option value="USER_NICK" <%=bm.getSearchType().equals("USER_NICK") ? "selected" : "" %>>작성자</option>
<!--							<option value="ADDR" <%=bm.getSearchType().equals("ADDR") ? "selected" : "" %>>주소</option>
							<option value="TEL" <%=bm.getSearchType().equals("TEL") ? "selected" : "" %>>연락처</option>
							<option value="ENJOY" <%=bm.getSearchType().equals("ENJOY") ? "selected" : "" %>>취미</option>-->
						</select>
<!--						<select name="searchOperation" title="검색조건" >
							<option value="">선택</option>
							<option value="OR" <%=bm.getSearchOperation().equals("OR") ? "selected" : "" %>>OR</option>
							<option value="AND" <%=bm.getSearchOperation().equals("AND") ? "selected" : "" %>>AND</option>
						</select>-->
					<input type="text" name="keyword" title="검색어 입력" value="<%=bm.getKeyword()%>"  
style="ime-mode:active;"/>
<!--					<input type="image" src="<%=request.getContextPath() %>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_btn_search.gif" alt="검색" class="button11"/>-->
<button onclick="javascript:return searchingCheck();">검색하기</button>

				</fieldset>
			</form>



					<p><strong>총 <span><%=bm.getDataCount()%></span> 건</strong> [ Page <%=bm.getPageNum()%>/<%=bm.getPageCount()%> ]</p>
				</div>
<%
String boardTitle = (bm.getBoardVO()).getBoardTitle();
%>
				<table class="tb_board">
				<caption><%=boardTitle %>의 글번호, 제목, 작성자, 작성일, 조회수 목록표입니다.</caption>
<colgroup>
	<%
	//목록 항목별 넓이 비율
	for(int i=0;i<listCount;i++)
	{
		%>
		<col style="width:<%=bm.getItemWidth(i) != null && !"0".equals(bm.getItemWidth(i) ) ? bm.getItemWidth(i)+"%"  : ""%>"/>
		<%
	}
	%>
</colgroup>				
					<thead>
						<tr>
				<%
				//각 항목별 사용자 지정명 출력
				for(int i=0;i<listCount;i++)
				{
					%>
					<th scope="col" <%= (i+1) == listCount ? "class=\"rfc_bbs_list_last\"" : ""%>><%=bm.getItemName(i)%></th>
					<%
				}
				%>
							
						</tr>
					</thead>
					<tbody>
			<%
			//게시물이 없을경우 메시지
			if(bm.getListCount() == 0) {
				if(bm.getEmptyMessage() != null && !"".equals(bm.getEmptyMessage())) {
				%>
					<tr>
						<td colspan="<%=listCount%>"><%=bm.getEmptyMessage()%></td>
					</tr>
				<%
				}
			}
			%>
			<%
			//게시물 Index
			int index = 0;
			//게시판의 행 만큼 반복
			for(int i=0; i<bm.getListCount() && i< bm.getBoardRow(); i++) {
				//게시물의 열 만큼 반복
				for(int j=0; j<bm.getListCount() && j< bm.getBoardCell(); j++) {
					//게시물 객채 설정
					BoardDataVO dataVO = bm.getBoardDataVOList(index++);
					bm.setDataVO(dataVO);
					%>
					<tr>
						<%
						//목록 항목에 지정된 항목 값 호출 메서드 실행
						for(int k=0;k<listCount;k++)
						{
							ArrayList<BoardDataVO> answerList = (ArrayList<BoardDataVO>)bm.getBoardReplyDataList(bm.getDataIdx());
							if(bm.getItemMethod(k).equals("getDataNum") && bm.isNotice())
							{
								%>
								<td><img src="/images/common/s3_menu01_on.gif" alt="공지" /></td>
								<%
								continue;
							}%>
							<td <%if(bm.getItemMethod(k).equals("getViewTitle"))out.print("class=\"l\""); %>>
								<%	if(bm.getItemMethod(k).equals("getViewTitle") && bm.isSecret()){	%>
									<img src="/img/common/icon_lock.png" alt="비밀글"/>
								<% } %>
								<%=egovframework.rfc3.common.util.EgovStringUtil.isNullToString(bm.getMethodValue(bm.getItemMethod(k),bm.getItemField(k),(Object)bm))%>								<%	if(bm.getItemMethod(k).equals("getViewTitle") ){	%><%=answerList.size() > 0 ? "[답변:"+answerList.size()+"]":""%><% } %>
</td>
							<%
						}
						%>
					</tr>					
					<%
				}
			}
			%>




					</tbody>
				</table>

					
	<!--RFC 공통 버튼 시작-->
	<div class="r">
		<%=bm.getListIcons() %>
	</div>
	<!--RFC 공통 버튼 끝-->


<script type="text/javascript">
	function linkPage(pageNo){
				document.rfc_bbs_searchForm.startPage.value=pageNo;
		document.rfc_bbs_searchForm.keyword.value="<%=bm.getKeyword()%>";
		document.rfc_bbs_searchForm.submit();
	}	
</script>

				<!-- 페이징시작 -->
				<div class="pageing">
					<%//=bm.getPaging().replace("><",">&nbsp;<") %></br>

					<%//=bm.getPaging() %></br>
		 <ui:pagination paginationInfo = "${paginationInfo}" type="cus1" jsFunction="linkPage"/>


					<%//=bm.getPaging(10) %></br>
    	<%//=bm.getPaging("bt","bt", "", "on", "bt", "bt", 5)%></br>


				</div>

				<div class="pageing_mo">
<%
int nowpage = bm.getPageNum() ;
int nowCpage = bm.getPageCount() ;
int lastcnt = 0;
int fastcnt  = 0;
if(nowpage < nowCpage ){
	lastcnt = nowpage +1 ;
}else{
	lastcnt = nowpage ;
}
if(nowpage > 1 ){
	fastcnt = nowpage -1 ;
}else{
	fastcnt = 1;

}

%>
					<a href="/board/list.gne?boardId=<%=bm.getBoardId()%>&amp;menuCd=${menuCd}&amp;startPage=<%=fastcnt%>&amp;searchType=<%=bm.getSearchType()%>&amp;keyword=<%=bm.getKeyword()%>" id="mobile_prev" class="bt_pre">&lt;</a>				
					<span><strong><%=bm.getPageNum() %></strong> / <%=bm.getPageCount() %></span>			
					<a href="/board/list.gne?boardId=<%=bm.getBoardId()%>&amp;menuCd=${menuCd}&amp;startPage=<%=lastcnt%>&amp;searchType=<%=bm.getSearchType()%>&amp;keyword=<%=bm.getKeyword()%>" id="mobile_next" class="bt_next">&gt;</a>
				</div>

				<!-- 페이징끝 -->
			</section>
			<!-- board_list -->