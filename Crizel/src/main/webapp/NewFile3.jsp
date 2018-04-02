<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<!--<div id="MainVisual" class="MainVisual">
</div>-->

<div id="MainContents">
    <div class="BoardWrap MtabCon">
        <ul>
            <li class="on">
                <a href="#" class="tab1">행사공지</a>
                <div class="tabCon">
                    <%-- <jsp:include page="/boardMain.es">
                        <jsp:param name="sid" value="${siteDetail.sid}" />
                        <jsp:param name="mid" value="c91102000000" />
                        <jsp:param name="bid" value="C9_11020" />
                        <jsp:param name="b_list" value="5" />
                        <jsp:param name="file_name" value="board_list_wikim" />
                    </jsp:include> --%>
                    <span class="btn_more"><a href="/board.es?mid=c91102000000&bid=C9_11020"><img src="/${siteDetail.site_url}/img/main/btn_more1.png" alt="행사공지 더보기"></a></span>
                </div>

            </li>
            <li>
                <a href="#" class="tab2">공지사항</a>
                <div class="tabCon" style="display:none">
                    <%-- <jsp:include page="/boardMain.es">
                        <jsp:param name="sid" value="${siteDetail.sid}" />
                        <jsp:param name="mid" value="c91101000000" />
                        <jsp:param name="bid" value="0006" />
                        <jsp:param name="b_list" value="5" />
                        <jsp:param name="file_name" value="board_list_wikim" />
                    </jsp:include> --%>
                    <span class="btn_more"><a href="/board.es?mid=c91101000000&bid=0006"><img src="/${siteDetail.site_url}/img/main/btn_more1.png" alt="공지사항 더보기"></a></span>
                </div>
            </li>
        </ul>
    </div>

    <div id="m_left">
        <!-- 팝업존 -->
        <%-- <jsp:include page="/main/popupzone.es">
            <jsp:param name="sid" value="${siteDetail.sid}" />
            <jsp:param name="file_name" value="popupzone_list_slide_wisdom" />
            <jsp:param name="site_nm" value="${siteDetail.site_url}" />
        </jsp:include> --%>
    </div>
    <div id="m_right">
        <ul class="banner_02">
            <li class="con1">
                <a href="/menu.es?mid=c90904010000">
                    <span class="text1">공간별<br>프로그램</span>
                </a>
            </li>
            <li class="con2">
                <a href="/menu.es?mid=c90902010000">
                    <span class="text1">인문학<br>도시락</span>
                </a>
            </li>

            <li class="con3">
                <a href="/menu.es?mid=c30203000000">
                    <span class="text1">지혜<br>밤바다</span>
                </a>
            </li>
            <li class="con4">
                <a href="/menu.es?mid=c90903030000">
                    <span class="text1">학교참여<br>프로그램</span>
                </a>
            </li>
            <li class="con5">
                <a href="/usr_gne/lec_list.es?mid=c91002000000&cate_no=79">
                    <span class="text1">프로그램<br>신청<span>
                </a>
            </li>
            <li class="con6">
                <a href="/menu.es?mid=c91501000000">
                    <span class="text1">나의<br>도서관</span>
                </a>
            </li>
        </ul>
        <p class="clr"></p>
    </div>
    <p class="clr"></p>
    <div class="ConMid">
        <!-- 이달의 행사 -->
        <div class="schedulWrap">
            <h2>이달의 행사</h2>
			<ul>
				<li>휴관일</li>
				<li>행사</li>
			</ul>
            <%-- <jsp:include page="/calendarMain.es">
                <jsp:param name="act" value="list" />
                <jsp:param name="mid" value="c90901000000" />
                <jsp:param name="file_name" value="calendar_wisdom_list" />
                <jsp:param name="use_control" value="Y" />
            </jsp:include> --%>
        </div>
        <!-- //이달의 행사 -->
        <div class="MtabCon bestBook bookWrap">
            <ul>
                <li>
                    <a href="#" class="tab1 on">추천도서</a>
                    <div class="tabCon">
                        <%-- <jsp:include page="/main/recom_book/search.es">
                            <jsp:param name="sid" value="c2" />
                            <jsp:param name="mid" value="c90706000000" />
                            <jsp:param name="vCnt" value="9" />
                            <jsp:param name="vEndPos" value="9" />
                            <jsp:param name="file_name" value="recom_search_list_wisdom" />
                        </jsp:include> --%>
                        <p class="btn_more">
                            <a href="/book/recom_book/search.es?mid=c90706000000">
                                <img src="/${siteDetail.site_url}/img/main/btn_more1.png" alt="추천도서 더보기" />
                            </a>
                        </p>

                    </div>
                </li>
                <li>
                    <a href="#" class="tab2">신착도서</a>
                    <div class="tabCon" style="display:none;">
                        <%-- <jsp:include page="/main/new_book/search.es">
                            <jsp:param name="sid" value="c2" />
                            <jsp:param name="mid" value="c90706000000" />
                            <jsp:param name="vCnt" value="3" />
                            <jsp:param name="file_name" value="new_search_list_wisdom" />
                        </jsp:include> --%>
                        <p class="btn_more"><a href="/book/new_book/search.es?mid=c30207000000"><img src="/${siteDetail.site_url}/img/main/btn_more1.png" alt="신착도서 더보기" /></a></p>
                    </div>
                </li>
            </ul>
        </div>
        <script>
            //<![CDATA[
            $(document).ready(function () {
                //탭기능
                $(".MtabCon.BoardWrap > ul > li > a").click(function () {
                    $(".MtabCon > ul > li > a").removeClass("on");
                    $(this).addClass("on");
                    $(".MtabCon.BoardWrap .tabCon").hide();
                    $(this).parent().children(".MtabCon.BoardWrap .tabCon").show()
                    return false;
                });

                //탭기능
                $(".MtabCon.bookWrap > ul > li > a").click(function () {
                    $(".MtabCon > ul > li > a").removeClass("on");
                    $(this).addClass("on");
                    $(".MtabCon.bookWrap .tabCon").hide();
                    $(this).parent().children(".MtabCon.bookWrap .tabCon").show()
                    return false;
                });
            });
            //]]>
        </script>

        <div class="book1">
            <h2 class="blind">편의정보</h2>
            <ul class="banner_03">
                <li><a href="http://www.nl.go.kr/ask/" class="con1" title="새창으로 열림" target="_blank">사서에게<br />물어보세요</a></li>
                <li><a href="http://www.nl.go.kr/nill/user/index.jsp" class="con2" title="새창으로 열림" target="_blank">책바다</a></li>
                <li><a href="http://dream.nl.go.kr/dream/chaeknarae" class="con3" title="새창으로 열림" target="_blank">책나래</a></li>
            </ul>
            <p class="clr"></p>
        </div>

        <div class="quickMenu">
            <h2 class="blind">외부메뉴 바로가기</h2>
            <ul class="banner_03">
                <li><a href="https://www.facebook.com/GNEseaofwisdom" class="con1" title="새창으로 열림" target="_blank">페이스북</a></li>
                <li><a href="https://twitter.com/gneseaofwisdom" class="con2" title="새창으로 열림" target="_blank">트위터</a></li>
                <li><a href="https://story.kakao.com/gneseaofwisdom" class="con3" title="새창으로 열림" target="_blank">카카오스토리</a></li>
                <li><a href="https://www.youtube.com/channel/UCgqPFNTFdzXmdiX8GYHi4qw" class="con4" title="새창으로 열림" target="_blank">유튜브</a></li>
            </ul>
            <p class="clr"></p>
        </div>
        <p class="clr"></p>
    </div>

    <div class="quickLink">
        <h2 class="blind">바로가기</h2>
        <ul>
            <li class="ic1"><a href="/menu.es?mid=c90708010000"><span></span>상호대차</a></li>
            <li class="ic2"><a href="http://www.nl.go.kr/nill/user/index.jsp" target="_blank" title="새창열림"><span></span>책바다</a></li>
            <li class="ic3"><a href="http://dream.nl.go.kr/dream/chaeknarae/index.do" target="_blank" title="새창열림"><span></span>책나래</a></li>
            <li class="ic4"><a href="http://www.nl.go.kr/ask/" target="_blank" title="새창열림"><span></span>사서에게물어보세요</a></li>
            <li class="ic5"><a href="http//www.sancheong.go.kr/tour/index.do" target="_blank" title="새창열림"><span></span>내고장안내</a></li>
            <li class="ic6"><a href="/menu.es?mid=c90606000000"><span></span>오시는길</a></li>
        </ul>
    </div>

    <div class="bannerList">
        <h2>배너모음</h2>
        <div class="bannerBox">
            <%-- <jsp:include page="/main/banner.es">
                <jsp:param name="sid" value="${siteDetail.sid}" />
                <jsp:param name="file_name" value="banner_wisdom_list" />
                <jsp:param name="site_nm" value="${siteDetail.site_url}" />
            </jsp:include> --%>
        </div>
    </div>
</div>
