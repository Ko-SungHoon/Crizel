<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
String pageParam = request.getParameter("pageParam")==null?"1":request.getParameter("pageParam");
%>

<!-- top -->
<jsp:include page="../inc/top.jsp"/>
<!--// top -->

<!-- 컨텐츠 시작 -->



<div id="work_list_wrap">
	<div class="dv_wrap uk-margin-large-bottom">
		
		

<div class="uk-width-1-1 uk-row-first">

                    <ul class="uk-subnav uk-subnav-pill" data-uk-switcher="{connect:'#switcher-content'}">
                        <li class="uk-active" aria-expanded="true"><a href="#">All</a></li>
                        <li aria-expanded="false"><a href="#">Logo</a></li>
                        <li aria-expanded="false"><a href="#">Web</a></li>
                        <li aria-expanded="false"><a href="#">App</a></li>
                    </ul>

                    <ul id="switcher-content" class="uk-switcher">
<c:forEach items="${list}" var="ob">
                        <li class="uk-active" aria-hidden="false">
                            <div class="uk-grid" data-uk-grid-margin="">
                                <div class="uk-width-medium-1-3 uk-row-first">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                       
										<figure class="uk-overlay">
                                            <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade">
											
											<dl class="li_info">
                            <dt><a href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view">${ob.title}</a></dt>
                            <dd><span>Client</span> ${ob.writer}</dd>
                            <dd><span>Date</span> ${ob.temp_field_2}</dd>
                        </dl>
											
											</figcaption>


                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
										
                                    </div>
                                    
                                </div>
                                <div class="uk-width-medium-1-3">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                             <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                </div>
                                <div class="uk-width-medium-1-3">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                            <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                    
                                </div>
                             </div>

                             <div class="uk-grid" data-uk-grid-margin="">
                                <div class="uk-width-medium-1-3 uk-row-first">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                            <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                    
                                </div>
                                <div class="uk-width-medium-1-3">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                            <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                   
                                </div>
                                <div class="uk-width-medium-1-3">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                            <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                    
                                </div>
                             </div>

                             <div class="uk-grid" data-uk-grid-margin="">
                                <div class="uk-width-medium-1-3 uk-row-first">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                            <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                   
                                </div>
                                <div class="uk-width-medium-1-3">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                            <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                   
                                </div>
                                <div class="uk-width-medium-1-3">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                            <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                    
                                </div>
                             </div>
                        </li>

                        <li aria-hidden="true">
                            <div class="uk-grid" data-uk-grid-margin="">
                                <div class="uk-width-medium-1-3 uk-row-first">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                             <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                   
                                </div>
                                <div class="uk-width-medium-1-3 uk-row-first">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                           <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                   
                                </div>
                                <div class="uk-width-medium-1-3 uk-row-first">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                           <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                    
                                </div>
                            </div>

                            <div class="uk-grid" data-uk-grid-margin="">
                                <div class="uk-width-medium-1-3 uk-row-first">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                           <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                    
                                </div>
                                <div class="uk-width-medium-1-3 uk-row-first">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                            <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                   
                                </div>
                                <div class="uk-width-medium-1-3 uk-row-first">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                           <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                    
                                </div>
                            </div>
                        </li>

                        <li aria-hidden="true">
                            <div class="uk-grid" data-uk-grid-margin="">
                                <div class="uk-width-medium-1-3 uk-row-first">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                           <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                    
                                </div>
                                <div class="uk-width-medium-1-3 uk-row-first">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                           <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                   
                                </div>
                                <div class="uk-width-medium-1-3 uk-row-first">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                          <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                    
                                </div>
                             </div>

                             <div class="uk-grid" data-uk-grid-margin="">
                                <div class="uk-width-medium-1-3 uk-row-first">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                           <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                   
                                </div>
                                <div class="uk-width-medium-1-3 uk-row-first">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                           <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                   
                                </div>
                             </div>
                        </li>

                        <li aria-hidden="true">
                            <div class="uk-grid" data-uk-grid-margin="">
                                <div class="uk-width-medium-1-3 uk-row-first">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                          <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                    
                                </div>
                                <div class="uk-width-medium-1-3 uk-row-first">
                                    <div class="uk-thumbnail uk-overlay-hover">
                                        <figure class="uk-overlay">
                                         <c:if test="${ob.saveFile ne null }">
                                <img src="/upload/${ob.saveFile}" alt="${ob.title}" width="600" height="400">
                            </c:if>
                            <c:if test="${ob.saveFile eq null }">
                                <img src="/images/default.png" alt="${ob.title}" />
                            </c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                </div>
                             </div>
                        </li>

						 </c:forEach>
                <c:if test="${fn:length(list) <= 0}">
                    <li class="uk-text-center">등록된 글이 없습니다.</li>
                </c:if>

                    </ul>

                </div>












		
		<!--<div class="uk-width-1-1 uk-row-first">

                    <ul class="uk-subnav uk-subnav-pill" data-uk-switcher="{connect:'#switcher-content'}">
                        <li class="uk-active" aria-expanded="true"><a href="#">All</a></li>
                        <li aria-expanded="false"><a href="#">Logo2</a></li>
                        <li aria-expanded="false"><a href="#">Web</a></li>
                        <li aria-expanded="false"><a href="#">App</a></li>
                    </ul>

                    <ul id="switcher-content" class="uk-switcher">
					<c:forEach items="${list}" var="ob">
                        <li class="uk-active" aria-hidden="false">
                            <div class="uk-grid" data-uk-grid-margin="">
                                <div class="uk-width-medium-1-3 uk-row-first">
                                    <div class="uk-thumbnail uk-overlay-hover" data-uk-modal="{target:'#modal-1'}">
                                        <figure class="uk-overlay">
                                            <c:if test="${ob.saveFile ne null }">
												<img src="/upload/${ob.saveFile}" alt="${ob.title}" />
											</c:if>
											<c:if test="${ob.saveFile eq null }">
											<img src="/images/default.png" alt="${ob.title}" />
											</c:if>
                                            <figcaption class="uk-overlay-panel uk-overlay-icon uk-overlay-background uk-overlay-fade"></figcaption>
                                            <a class="uk-position-cover" href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view"></a>
                                        </figure>
                                    </div>
                                </div>
                             </div>
                        </li>
                      </c:forEach>
                    </ul>

                </div>
		-->
		<ul class="list_wrap">
			<c:forEach items="${list}" var="ob">
				 <li class="uk-clearfix">
					<p class="li_thumb"><a href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view">
						<c:if test="${ob.saveFile ne null }">
							<img src="/upload/${ob.saveFile}" alt="${ob.title}" />
						</c:if>
						<c:if test="${ob.saveFile eq null }">
							<img src="/images/default.png" alt="${ob.title}" />
						</c:if>
						</a>
					</p>
					<dl class="li_info">
						<dt><a href="/boardContent.ksis?board_id=${ob.board_id}&menu_cd=/work/view">${ob.title}</a></dt>
		                <dd><span>Client</span> ${ob.writer}</dd>
		                <dd><span>URL</span> <a href="${ob.temp_field_1}" target="_blank">${ob.temp_field_1}</a></dd>
		                <dd><span>Date</span> ${ob.temp_field_2}</dd>
					</dl>
		   		 </li>
			</c:forEach>
			<c:if test="${fn:length(list) <= 0}">
				<li class="uk-text-center">등록된 글이 없습니다.</li>
			</c:if>
		</ul>
		<div class="uk-text-right">
			<c:if test="${login.id ne null}">
				<a href="/boardInsertPage.ksis?menu_cd=/work/write" class="uk-button uk-button-large uk-button-primary">글쓰기</a>
			</c:if>
		</div>

		<!-- 페이징 -->
		<c:if test="${totalCount>0}">
			<ul class="uk-pagination">
				<li><a href="/board.ksis?pageParam=1&menu_cd=/work/index&cate=work" title="처음페이지">
					<i class="uk-icon-angle-double-left"></i><span class="uk-hidden">처음</span></a>
				</li>
				<li><a href="/board.ksis?pageParam=${pre}&menu_cd=/work/index&cate=work" title="이전페이지">
					<i class="uk-icon-angle-left"></i><span class="uk-hidden">이전</span></a>
				</li>

				<c:set var="pageParam" value="<%=pageParam%>" />

				<c:forEach begin="${startPage}" end="${endPage}" varStatus="i">
					<c:choose>
						<c:when test="${pageParam eq i.index}">
							<li class="uk-active"><span onclick="location.href='/board.ksis?pageParam=${i.index}&menu_cd=/work/index&cate=work'">${i.index}</span></li>
						</c:when>
						<c:otherwise>
							<li><span onclick="location.href='/board.ksis?pageParam=${i.index}&menu_cd=/work/index&cate=work'">${i.index}</span></li>
						</c:otherwise>
					</c:choose>


				</c:forEach>
				<li><a href="/board.ksis?pageParam=${next}&menu_cd=/work/index&cate=work" title="다음페이지">
					<i class="uk-icon-angle-right"></i><span class="uk-hidden">다음</span></a>
				</li>
				<li><a href="/board.ksis?pageParam=${totalPage}&menu_cd=/work/index&cate=work" title="마지막페이지">
					<i class="uk-icon-angle-double-right"></i><span class="uk-hidden">마지막</span></a>
				</li>
			</ul>
		</c:if>
		<!-- //페이징 끝 -->
	</div>
</div>
<!-- //컨텐츠 끝 -->

<!-- bottom -->
<jsp:include page="../inc/bottom.jsp"/>
<!-- //bottom -->
