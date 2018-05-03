<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper"%>
<%@ page import="java.util.*, egovframework.rfc3.board.vo.BoardVO, egovframework.rfc3.board.vo.BoardCategoryVO"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<script type="text/javascript">
function changeCate(sn,objCode){
	if(sn == '1'){
		document.rfc_bbs_searchForm.categoryCode1.value=objCode;
	}else if(sn == '2'){
		document.rfc_bbs_searchForm.categoryCode2.value=objCode;
	}else if(sn == '3'){
		document.rfc_bbs_searchForm.categoryCode3.value=objCode;
	}
	document.rfc_bbs_searchForm.submit();
}	

</script>

<link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" media="all" />
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js" type="text/javascript"></script>
<script>
$(function() {
  $( "#datepicker1,#datepicker2" ).datepicker({
    dateFormat: 'yy-mm-dd',
    prevText: '이전 달',
    nextText: '다음 달',
    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
    dayNames: ['일','월','화','수','목','금','토'],
    dayNamesShort: ['일','월','화','수','목','금','토'],
    dayNamesMin: ['일','월','화','수','목','금','토'],
    showMonthAfterYear: true,
    yearSuffix: '년'
  });
});
</script>


<%
List<BoardCategoryVO> categoryList1 = bm.getCategoryList1();
List<BoardCategoryVO> categoryList2 = bm.getCategoryList2();
List<BoardCategoryVO> categoryList3 = bm.getCategoryList3();

boolean cate1 = true;
boolean cate2 = true;
boolean cate3 = true;
boolean cate1Type = true;
boolean cate2Type = true;
boolean cate3Type = true;
if(categoryList1 != null && categoryList1.size() > 0){
	BoardCategoryVO cate1Print = (BoardCategoryVO)categoryList1.get(categoryList1.size()-1);
	if(cate1Print.getCategoryName().equals("noview")){
		String[] code1 = cate1Print.getCategoryCode().split("_");
		String checkString =cate1Print.getCategoryCode();
		if(code1.length ==2){
			checkString = code1[1];
		}
		
		if(checkString.indexOf("L") > -1){
			cate1=false;
		}
		if(checkString.indexOf("B") > -1){
			cate1Type=false;
		}
		//categoryList1.remove(categoryList1.size()-1);
	}
}

if(categoryList2 != null && categoryList2.size() > 0){
	BoardCategoryVO cate2Print = (BoardCategoryVO)categoryList2.get(categoryList2.size()-1);
	if(cate2Print.getCategoryName().equals("noview")){
		String[] code2 = cate2Print.getCategoryCode().split("_");
		String checkString =cate2Print.getCategoryCode();
		if(code2.length ==2){
			checkString = code2[1];
		}
		if(checkString.indexOf("L") > -1){
			cate2=false;
		}
		if(checkString.indexOf("B") > -1){
			cate2Type=false;
		}
		//categoryList2.remove(categoryList2.size()-1);
	}
}

if(categoryList3 != null && categoryList3.size() > 0){
	BoardCategoryVO cate3Print = (BoardCategoryVO)categoryList3.get(categoryList3.size()-1);
	if(cate3Print.getCategoryName().equals("noview")){
		String[] code3 = cate3Print.getCategoryCode().split("_");
		String checkString =cate3Print.getCategoryCode();
		if(code3.length ==2){
			checkString = code3[1];
		}
		if(checkString.indexOf("L") > -1){
			cate3=false;
		}
		if(checkString.indexOf("B") > -1){
			cate3Type=false;
		}
		//categoryList3.remove(categoryList3.size()-1);
	}
}
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
						<input type="hidden" name="categoryCode1" value="<%=bm.getSearchCategoryCode1() %>" />

						
<%
				if( (categoryList1 != null && categoryList1.size() > 0) || (categoryList2 != null && categoryList2.size() > 0) || (categoryList3 != null && categoryList3.size() > 0))
					{ 
							/*-------------------------------------- 카테고리 버튼 시작   --------------------------------------*/
					if(categoryList1 != null && categoryList1.size() > 0){ 
							if(bm.getMenuIsBoard1Cate() && cate1 && !cate1Type){
						%>
								<input type="hidden" name="categoryCode1" id="categoryCode1" value="<%=bm.getSearchCategoryCode1() %>"  title="카테고리1"/>
								<section  class="buseo_list">
									<ul>
									<li><a href="#" <%if(bm.getSearchCategoryCode1().equals(""))out.print("class='on'");%>   onclick="changeCate('1','');">전체보기</a></li>
						<% 
								for(BoardCategoryVO category : categoryList1){
									if(!category.getCategoryName().equals("noview")){
						%>			
									<li><a href="#" <%if(bm.getSearchCategoryCode1().equals(category.getCategoryCode()))out.print("class='on'");%> onclick="changeCate('1','<%=category.getCategoryCode()%>');"><%=category.getCategoryName()%></a></li>
						<% 	
									}
								} 
						%>
								</ul>
									<div class="clr"></div>
								</section>
						<%
							}
						}
						%>

									<% 
						if(categoryList2 != null && categoryList2.size() > 0){ 
							if(bm.getMenuIsBoard2Cate() && cate2 && !cate2Type){
						%>
								<input type="hidden" name="categoryCode2" id="categoryCode2" value="<%=bm.getSearchCategoryCode2() %>"  title="카테고리2"/>
								<section  class="buseo_list">
									<ul>
									<li><a href="#" <%if(bm.getSearchCategoryCode2().equals(""))out.print("class='on'");%>   onclick="changeCate('2','');">전체보기</a></li>
						<% 
								for(BoardCategoryVO category2 : categoryList2){
									if(!category2.getCategoryName().equals("noview")){
						%>			
									<li><a href="#" <%if(bm.getSearchCategoryCode2().equals(category2.getCategoryCode()))out.print("class='on'");%> onclick="changeCate('2','<%=category2.getCategoryCode()%>');"><%=category2.getCategoryName()%></a></li>
						<% 
									}
								} 
						%>
								</ul>
									<div class="clr"></div>
								</section>
						<%
							}
						}
						%>
						
								<% 
						if(categoryList3 != null && categoryList3.size() > 0){ 
							if(bm.getMenuIsBoard3Cate() && cate3 && !cate3Type){
						%>
							<input type="hidden" name="categoryCode3" id="categoryCode3" value="<%=bm.getSearchCategoryCode3() %>"  title="카테고리3"/>
							<section  class="buseo_list">
									<ul>
									<li><a href="#" <%if(bm.getSearchCategoryCode3().equals(""))out.print("class='on'");%>   onclick="changeCate('3','');">전체보기</a></li>
						<% 
								for(BoardCategoryVO category3 : categoryList3){
									if(!category3.getCategoryName().equals("noview")){
						%>			
									<li><a href="#" <%if(bm.getSearchCategoryCode3().equals(category3.getCategoryCode()))out.print("class='on'");%> onclick="changeCate('3','<%=category3.getCategoryCode()%>');"><%=category3.getCategoryName()%></a></li>
						<% 
									}
								} 
						%>
								</ul>
									<div class="clr"></div>
								</section>
						<%
								}
							}
								/*  -------------------------------------- 카테고리 버튼 끝    --------------------------------------*/
						%>
						
						
						<% /*  -------------------------------------- 카테고리 select 시작   --------------------------------------*/
						if(categoryList1 != null && categoryList1.size() > 0){ 
							if(bm.getMenuIsBoard1Cate()&& cate1 && cate1Type){
						%>
								<select name="categoryCode1" id="categoryCode1" class="layout_select" title="카테고리1" onchange="changeCate(this);">
								<option value="">전 체</option>
						<% 
								for(BoardCategoryVO category : categoryList1){ 
									if(!category.getCategoryName().equals("noview")){
						%>
									<option value="<%=category.getCategoryCode()%>" <%if(bm.getSearchCategoryCode1().equals(category.getCategoryCode()))out.print("selected");%>><%=category.getCategoryName()%></option>
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
						if(categoryList2 != null && categoryList2.size() > 0){ 
							if(bm.getMenuIsBoard2Cate()&& cate2 && cate2Type){
						%>
							<select name="categoryCode2" id="categoryCode2" class="layout_select"  title="카테고리2">
							<option value="">2차 카테고리</option>
						<% 
							for(BoardCategoryVO category2 : categoryList2){
								if(!category2.getCategoryName().equals("noview")){
						%>
								<option value="<%=category2.getCategoryCode()%>" <%if(bm.getSearchCategoryCode2().equals(category2.getCategoryCode()))out.print("selected");%>><%=category2.getCategoryName()%></option>
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
						if(categoryList3 != null && categoryList3.size() > 0){ 
							if(bm.getMenuIsBoard3Cate()&& cate3 && cate3Type){
						%>
							<select name="categoryCode3" id="categoryCode3" class="layout_select"  title="카테고리3">
							<option value="">3차 카테고리</option>
						<% 
							for(BoardCategoryVO category3 : categoryList3){ 
								if(!category3.getCategoryName().equals("noview")){
						%>
								<option value="<%=category3.getCategoryCode()%>" <%if(bm.getSearchCategoryCode3().equals(category3.getCategoryCode()))out.print("selected");%>><%=category3.getCategoryName()%></option>
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
						} /*  -------------------------------------- 카테고리 select 끝   --------------------------------------*/
					}
				%>



				<input id="datepicker1" name="searchStartDt" type="text" class="calendar" title="기간검색 시작" value="<%=bm.getSearchStartDt() %>" size="10" onclick="this.value=''"> ~ 	
				<input id="datepicker2" name="searchEndDt" type="text" class="calendar" title="기간검색 끝" value="<%=bm.getSearchEndDt() %>" size="10" onclick="this.value=''">
						<input type="hidden" name="startPage" value="1" />
						<input type="hidden" name="menuCd" value="${menuCd}" />
						<input type="hidden" name="contentsSid" value="${contentsSid}" />
						<select name="searchType" class="text" title="검색항목을 선택하세요" >
							<!-- <option value="">선택</option> -->
							<option value="DATA_TITLE" <%=bm.getSearchType().equals("DATA_TITLE") ? "selected" : "" %>>제목</option>
							<option value="DATA_CONTENT" <%=bm.getSearchType().equals("DATA_CONTENT") ? "selected" : "" %>>내용</option>
							<option value="USER_NICK" <%=bm.getSearchType().equals("USER_NICK") ? "selected" : "" %>>작성자</option>
						</select>
					<input type="text" name="keyword" title="검색어 입력" value="<%=bm.getKeyword()%>" style="ime-mode:active;"/>
<!--					<input type="image" src="<%=request.getContextPath() %>/images/egovframework/rfc3/board/images/skin/common/rfc_bbs_btn_search.gif" alt="검색" class="button11"/>-->
<button onclick="javascript:return searchingCheck();">검색하기</button>

				</fieldset>
			</form>


</div>
					<p><strong>총 <span><%=bm.getDataCount()%></span> 건</strong> [ Page <%=bm.getPageNum()%>/<%=bm.getPageCount()%> ]</p>
				
<%
String boardTitle = (bm.getBoardVO()).getBoardTitle();
%>
<%
String captionText = "";
for(int i=0; i<bm.listItemCount(); i++){
	if(bm.isManager()){													// 관리자일 경우 checkbox, 상태, 삭제 컬럼이 추가되기 때문에
		if(i>=3){														// index 3부터 변수에 저장
			if(i>3 && i<bm.listItemCount()){captionText += ", ";}		
			captionText += bm.getItemName(i);
		}
	}else{
		if(i>0 && i<bm.listItemCount()){captionText += ", ";}
		captionText += bm.getItemName(i);
	}
}
%>
				<table class="tb_board">
				<caption><%=boardTitle%>의 <%=captionText%> 목록표입니다.</caption>
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
								<%	if(bm.getItemMethod(k).equals("getTmpField1")){	%>
									<%=bm.getCategoryCode1()%> -
								<% } %>
								<%=egovframework.rfc3.common.util.EgovStringUtil.isNullToString(bm.getMethodValue(bm.getItemMethod(k),bm.getItemField(k),(Object)bm))%></td>
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
		document.rfc_bbs_searchForm.submit();	}	
</script>

				<!-- 페이징시작 -->
				<div class="pageing">
					<%//=bm.getPaging().replace("><",">&nbsp;<") %><br />

					<%//=bm.getPaging() %><br />
		 <ui:pagination paginationInfo = "${paginationInfo}" type="cus1" jsFunction="linkPage"/>


					<%//=bm.getPaging(10) %><br />
    	<%//=bm.getPaging("bt","bt", "", "on", "bt", "bt", 5)%><br />


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
					<a href="/board/list.gne?boardId=<%=bm.getBoardId()%>&amp;menuCd=${menuCd}&amp;categoryCode1=<%=bm.getSearchCategoryCode1() %>&amp;contentsSid=${contentsSid}&amp;startPage=<%=fastcnt%>&amp;searchType=<%=bm.getSearchType()%>&amp;keyword=<%=bm.getKeyword()%>" id="mobile_prev" class="bt_pre">&lt;</a>				
					<span><strong><%=bm.getPageNum() %></strong> / <%=bm.getPageCount() %></span>			
					<a href="/board/list.gne?boardId=<%=bm.getBoardId()%>&amp;menuCd=${menuCd}&amp;categoryCode1=<%=bm.getSearchCategoryCode1() %>&amp;contentsSid=${contentsSid}&amp;startPage=<%=lastcnt%>&amp;searchType=<%=bm.getSearchType()%>&amp;keyword=<%=bm.getKeyword()%>" id="mobile_next" class="bt_next">&gt;</a>
				</div>

				<!-- 페이징끝 -->
			</section>
			<!-- board_list -->