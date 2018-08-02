<%@ page import="java.util.*" %>
<%@ page import="egovframework.rfc3.menu.vo.MenuVO" %>
<%@ page import="egovframework.rfc3.contents.vo.ContentsVO" %>
<%
	ArrayList topMenuList = (ArrayList) cm.getMenuList(cm.getDomainId(request.getServerName(),"80"),1);
%>
<header id="header">
    <div id="gnb">
        <div class="dv_wrap">
            <div class="gnb_top">
                <h1>
                    <a href="http://lib.gyeongnam.go.kr/index.lib">
                        <img src="/images/common/logo_top.png" alt="경남대표도서관" />
                    </a>
                </h1>
                <div class="all_sear">
                    <form id="search_form" action="/index.lib" method="GET">
                        <input type="hidden" name="menuCd" value="DOM_000000201001000000">
                        <fieldset class="searchbg">
                            <legend>자료검색</legend>
                            <div class="top-select-wrap">
                                <label for="category" class="blind">자료검색</label>
                                <select name="search_select" id="category" class="select small select-category" title="검색구분 선택">
                                    <option value="search_title" selected>통합검색</option>
                                    <option value="search_title">서명</option>
                                    <option value="search_author">저자</option>
                                    <option value="search_publisher">출판사</option>
                                </select>
                            </div>
                            <label for="tkeyword" class="blind">검색어 입력</label>
                            <input name="search_text" type="text" id="tkeyword" class="sword" title="검색어를 입력하세요" placeholder="검색어를 입력하세요">
                            <a href="javascript:{}" onclick="document.getElementById('search_form').submit();" class="all_sear_btn">
                                <img src="/images/common/ico_search.png" alt="검색">
                            </a>
                        </fieldset>
                    </form>
                </div>
                <% if (request.getUserPrincipal() != null ) { %>
               	<% if (session.getAttribute("loanStopDate") != null && !"".equals(session.getAttribute("loanStopDate"))) { %>
               	<div class="id_name" style="right:100px !important;">대출정지기간:<%= session.getAttribute("loanStopDate") %></div>
               	<%} %>
                <div class="id_name"><%= egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper.getName() %>님</div>
                <% } %>
                <ul>
                    <% if (request.getUserPrincipal() == null ) { %>
                    <li class="gnb_btn2"><a href="/index.lib?menuCd=DOM_000000217001000000">로그인</a></li>
                    <li class="gnb_btn2"><a href="http://bs.gyeongnam.go.kr:9090/kcms/Membership/step_01/MA" target="blank" title="새창 열림">회원가입</a></li>
                    <% } else { %>
                    <li class="gnb_btn2"><a href="<%= request.getContextPath() %>/j_spring_security_logout?returnUrl=/" style="border-right:none;">로그아웃</a></li>
                    <li><a href="/index.lib?menuCd=DOM_000000206001001000" class="gnb_btn3 bg_b1">내도서관</a></li>
                    <% } %>
                    <li><a href="/index.lib?menuCd=DOM_000000210000000000" class="gnb_btn3 bg_b2">ENGLISH</a></li>
                </ul>
            </div>
        </div>
    </div>
    <div class="lnb_container clearfix">
        <nav id="lnb">
            <div class="lnb_list">
                <ul class="depth1">
                    <%
                    for (int i=0; i
                    <topMenuList.size(); i++)
                                         {
                                         MenuVO topMenuVO=(MenuVO) topMenuList.get(i);
                                         ArrayList topMenuList2=(ArrayList) cm.getMenuList(topMenuVO.getMenuCd(), 2);
                                         %>
                        <li class="m<%=i+1%>">
                            <a href="/index.<%=cm.getUrlExt()%>?menuCd=<%=topMenuVO.getMenuCd()%>"<%if("_blank".equals(topMenuVO.getMenuTg())){%> target="_blank" title="새창으로 열립니다."<%}%>><%=topMenuVO.getMenuNm()%>
					<%if("_blank".equals(topMenuVO.getMenuTg())){%><img src="/images/common/open_new.png" alt="새창 열림"/><%}%>
					</a>
                            <div class="depth2">
                                <ul class="litype_cir">
                                    <%
                                    for (int j=0; j
                                    <topMenuList2.size(); j++)
                                                          {
                                                          MenuVO topMenuVO2=(MenuVO) topMenuList2.get(j);
                                                          ArrayList topMenuList3=(ArrayList) cm.getMenuList(topMenuVO2.getMenuCd(), 3);
                                                          %>
                                        <li>
                                            <a href="/index.<%=cm.getUrlExt()%>?menuCd=<%=topMenuVO2.getMenuCd()%>"<%if("_blank".equals(topMenuVO2.getMenuTg())){%> target="_blank" title="새창으로 열립니다."<%}%>><%=topMenuVO2.getMenuNm()%>
									<%if("_blank".equals(topMenuVO2.getMenuTg())){%><img src="/images/common/open_new2.png" alt="새창 열림"/><%}%>
									</a>
                                        </li>
                                        <%
                                        }
                                        %>
                                </ul>
                            </div>
                        </li>


                        <%
                        }
                        %>
                        <!-- <li class="m1">
                            <a href="../sub1/1_1.jsp">자료검색</a>
                            <div class="depth2">
                                <ul class="litype_cir">
                                    <li><a href="../sub1/1_1.jsp">통합검색</a></li>
                                    <li><a href="../sub1/1_2.jsp">신착도서</a></li>
                                    <li><a href="../sub1/1_3.jsp">사서추천도서</a></li>
                                    <li><a href="../sub1/1_4.jsp">인기대출도서</a></li>
                                </ul>
                            </div>
                        </li>
                        <li class="m2">
                            <a href="../sub2/2_1.jsp">이용안내 </a>
                            <div class="depth2">
                                <ul class="litype_cir">
                                    <li><a href="../sub2/2_1.jsp">이용시간 및 절차</a></li>
                                    <li><a href="../sub2/2_2.jsp">본관 이용안내</a></li>
                                    <li><a href="../sub2/2_3.jsp">어린이관 이용안내</a></li>
                                    <li><a href="../sub2/2_4.jsp">청소년관 이용안내</a></li>
                                </ul>
                            </div>
                        </li>
                        <li class="m3">
                            <a href="../sub3/3_1.jsp">신청·예약</a>
                            <div class="depth2">
                                <ul class="litype_cir">
                                    <li><a href="../sub3/3_1.jsp">강좌 수강신청</a></li>
                                    <li><a href="../sub3/3_2.jsp">도서관 견학신청</a></li>
                                    <li><a href="../sub3/3_2.jsp">자원봉사신청</a></li>
                                    <li><a href="../sub3/3_2.jsp">디지털자료실 좌석예약</a></li>
                                </ul>
                            </div>
                        </li>
                        <li class="m4">
                            <a href="../sub4/4_1.jsp">열린마당</a>
                            <div class="depth2">
                                <ul class="litype_cir">
                                    <li><a href="../sub4/4_1.jsp">공지사항</a></li>
                                    <li><a href="../sub4/4_2.jsp">도서관일정</a></li>
                                    <li><a href="../sub4/4_3.jsp">설문조사</a></li>
                                    <li><a href="../sub4/4_4.jsp">도서관에 바란다</a></li>
                                    <li><a href="../sub4/4_5.jsp">사서에게 물어보세요</a></li>
                                </ul>
                            </div>
                        </li>
                        <li class="m5">
                            <a href="../sub5/5_1.jsp">도서관소개</a>
                            <div class="depth2">
                                <ul class="litype_cir">
                                    <li><a href="../sub5/5_1.jsp">인사말</a></li>
                                    <li><a href="../sub5/5_2.jsp">연혁</a></li>
                                    <li><a href="../sub5/5_3.jsp">조직 및 업무</a></li>
                                    <li><a href="../sub5/5_4.jsp">로고</a></li>
                                    <li><a href="../sub5/5_5.jsp">경상남도 도서관</a></li>
                                </ul>
                            </div>
                        </li> -->
                        <!--
                        <li class="m6">
                            <a href="../sub6/6_1.jsp">내도서관</a>
                            <div class="depth2">
                                <ul class="litype_cir">
                                    <li><a href="../sub6/6_1.jsp">도서 현황</a></li>
                                    <li><a href="../sub6/6_2.jsp">신청 현황</a></li>
                                </ul>
                            </div>
                        </li>
                        <li class="m7">
                            <a href="../sub7/7_1.jsp">사이트 이용안내</a>
                            <div class="depth2">
                                <ul class="litype_cir">
                                    <li><a href="../sub7/7_1.jsp">개인정보처리방침</a></li>
                                    <li><a href="../sub7/7_2.jsp">이메일주소 무단수집거부</a></li>
                                    <li><a href="../sub7/7_3.jsp">뷰어프로그램</a></li>
                                    <li><a href="../sub7/7_4.jsp">사이트맵</a></li>
                                    <li><a href="../sub7/7_5.jsp">로그인</a></li>
                                </ul>
                            </div>
                        </li>-->

                        <% if (request.getUserPrincipal() != null ) { %>
                        <li class="m7 lnb_mo">
                            <a href="#">내도서관</a>
                            <div class="depth2">
                                <ul class="litype_cir">
                                    <li>
                                        <a href="/index.lib?menuCd=DOM_000000206001001000">도서이용내역</a>
                                        <ul>
                                            <li><a href="/index.lib?menuCd=DOM_000000206001001000">대출중도서</a></li>
                                            <li><a href="/index.lib?menuCd=DOM_000000206001002000">대출이력</a></li>
                                            <li><a href="/index.lib?menuCd=DOM_000000206001003000">대출예약도서</a></li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="/index.lib?menuCd=DOM_000000206002001000">신청내역</a>
                                        <ul>
                                            <li><a href="/index.lib?menuCd=DOM_000000206002001000">수강신청</a></li>
                                            <!--<li><a href="/index.lib?menuCd=DOM_000000206002002000">자원봉사</a></li>-->
                                            <li><a href="/index.lib?menuCd=DOM_000000206002003000">희망도서신청내역</a></li>
                                        </ul>
                                    </li>
				    <li><a href="/index.lib?menuCd=DOM_000000206003000000">체험형 동화구연</a></li>
				    <li><a href="/index.lib?menuCd=DOM_000000206004000000">회원 정보 수정</a></li>
                                </ul>
                            </div>
                        </li>
                        <% } %>
                </ul>

                <div id="lnb_btn1">
                    <a href="/index.lib?menuCd=DOM_000000207001000000"><img src="/images/common/btn_menuall.png" alt="사이트맵 바로가기"></a>
                </div>
                <div id="lnb_bg"></div>
            </div>
            <div class="close_area">
                <% if (request.getUserPrincipal() != null ) { %>
                <p class="home_btn"><%= egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper.getName() %>님 안녕하세요.</p>
                <% } else { %>
                <p class="home_btn no">로그인을 해주세요.</p>
                <% } %>
                <p class="close"></p><span class="blind">닫기</span>
            </div>
            <ul class="lnb_btn_area lnb_btn_mo">
                <li>
                    <% if (request.getUserPrincipal() == null ) { %>
                    <a href="/index.lib?menuCd=DOM_000000217001000000">로그인</a>
                    <!--<a href="http://27.101.166.44:9090/kcms/Membership/step_01/MA" target="blank" title="새창 열림">회원가입</a>-->
                    <% } else { %>
                    <a href="<%= request.getContextPath() %>/j_spring_security_logout?returnUrl=/">로그아웃</a>
                    <!--<a href="/index.lib?menuCd=DOM_000000206001001000">내도서관</a>-->
                    <% } %>
                    
                    <a href="/index.lib?menuCd=DOM_000000210000000000">ENGLISH</a>
                </li>
            </ul>
        </nav>
    </div>
    <div id="lnb_btn2" class="lnb_btn_mo"><img src="/images/common/btn_menuall_1.png" alt="전체메뉴보기"></div>
    <% if (request.getUserPrincipal() == null ) { %>
    <div id="lnb_btn3" class="lnb_btn_mo"><a href="/index.lib?menuCd=DOM_000000217001000000"><img src="/images/common/btn_login.png" alt="로그인"></a></div>
    <% } else { %>
    <div id="lnb_btn3" class="lnb_btn_mo"><a href="<%= request.getContextPath() %>/j_spring_security_logout?returnUrl=/"><img src="/images/common/btn_logout.png" alt="로그아웃"></a></div>
    <% } %>
    <div id="lnb_mask"></div>
</header>
<script>
function printNew()
        {

	 var w = window.open('/index.lib?menuCd=DOM_000000209000000000','메뉴 인쇄', 'width=780, height=1230, toolbar=no, menubar=no, scrollbars=yes, resizable=no, top=10');
        }</script>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  