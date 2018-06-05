<%@ page import="java.util.*" %>
<%@ page import="egovframework.rfc3.menu.vo.MenuVO" %>  
<%@ page import="egovframework.rfc3.contents.vo.ContentsVO" %>
<%
	ArrayList topMenuList = (ArrayList) cm.getMenuList(cm.getDomainId(request.getServerName(),"80"),1);
%>
<header id="header">
    <div id="gnb">
        <div class="dv_wrap">
            <div class="gnb_btn1"><a href="">ENGLISH</a></div>
            <div class="gnb_top">
                <h1>
                    <a href="../main/index.jsp">
                        <img src="/images/common/logo_top.png" alt="경상남도 대표도서관" class="pc1" />
                        <img src="/images/common/logo_top_m.png" alt="경상남도 대표도서관" class="mo2" />
                    </a>
                </h1>
                <div class="all_sear">
                    <form>
                        <fieldset class="searchbg">
                            <legend>통합 검색</legend>
                            <div class="top-select-wrap">
                                <label for="" class="blind">통합검색</label>
                                <select name="category" class="select small select-category" title="검색구분 선택">
                                    <option value="TOTAL">통합검색</option>
                                    <option value="BOARD">웹게시물</option>
                                </select>
                            </div>
                            <label for="tkeyword" class="blind">검색어 입력</label>
                            <input type="text" style="ime-mode:active" class="sword" title="검색어를 입력하세요" placeholder="검색어를 입력하세요">
                            <a href="" class="all_sear_btn"><img src="/images/common/ico_search.png" alt="검색"></a>
                        </fieldset>
                    </form>
                </div>
                <div class="id_name">홍길동님</div>
                <ul>
                    <li class="gnb_btn2"><a href="../sub1/1_1.jsp">로그인</a></li>
                    <!-- <li class="gnb_btn2"><a href="../sub1/1_1.jsp">로그아웃</a></li> -->
                    <li class="gnb_btn2"><a href="../sub1/1_1.jsp">회원가입</a></li>
                    <li class="gnb_btn3 bg_b1"><a href="../sub1/1_1.jsp">내도서관</a></li>
                    <li class="gnb_btn3 bg_b2"><a href="../sub1/1_1.jsp">전자도서관</a></li>
                </ul>
            </div>
        </div>
    </div>
    <div class="lnb_container clearfix">
        <nav id="lnb">
            <section class="lnb_list">
                <ul class="depth1">
                <%
					for (int i=0; i<topMenuList.size(); i++) 
					{
						MenuVO topMenuVO = (MenuVO) topMenuList.get(i);
						ArrayList topMenuList2 = (ArrayList) cm.getMenuList(topMenuVO.getMenuCd(), 2);
				%>
				<li class="m<%=i+1%>">
					<a href="/index.<%=cm.getUrlExt()%>?menuCd=<%=topMenuVO.getMenuCd()%>"<%if("_blank".equals(topMenuVO.getMenuTg())){%> target="_blank" title="새창으로 열립니다."<%}%>><%=topMenuVO.getMenuNm()%>
					<%if("_blank".equals(topMenuVO.getMenuTg())){%><img src="/images/juknok/open_new2.png" alt="새창"/><%}%>
					</a>
					<div class="depth2">
						<ul class="litype_cir">
							<%
								for (int j=0; j<topMenuList2.size(); j++) 
								{
									MenuVO topMenuVO2 = (MenuVO) topMenuList2.get(j);
									ArrayList topMenuList3 = (ArrayList) cm.getMenuList(topMenuVO2.getMenuCd(), 3);
							%>
								<li>
									<a href="/index.<%=cm.getUrlExt()%>?menuCd=<%=topMenuVO2.getMenuCd()%>"<%if("_blank".equals(topMenuVO2.getMenuTg())){%> target="_blank" title="새창으로 열립니다."<%}%>><%=topMenuVO2.getMenuNm()%>
									<%if("_blank".equals(topMenuVO2.getMenuTg())){%><img src="/images/juknok/open_new2.png" alt="새창"/><%}%>
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
                </ul>
                <!--<div id="lnb_btn1">
                <img src="/images/common/btn_menuall.png" alt="전체메뉴보기"></div>-->
                <div id="lnb_bg"></div>
            </section>
            <div class="close_area">
                <p class="home_btn">HOME</p>
                <p class="close"></p><span class="blind">닫기</span>
            </div>
        </nav>
    </div>
    <div id="lnb_btn2" class="lnb_btn_mo"><img src="/images/common/btn_menuall_1.gif" alt="전체메뉴보기"></div>
    <div id="lnb_btn3" class="lnb_btn_mo"><img src="/images/common/btn_gogin.gif" alt="전체메뉴보기"></div>
    <div id="lnb_mask"></div>
</header>                  