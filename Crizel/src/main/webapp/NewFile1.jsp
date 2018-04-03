<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>
  <!-- vuetable-2 dependencies -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.5.9/vue.min.js"></script>

  <style>
    .con{margin-bottom:80px; overflow:hidden;font-weight: 100;line-height:1.6em;}
    .pagination {display: inline-flex;
    .pagination li a {display:inline-block; width:45px; height:45px;font-size:1.1em;  border:1px solid #dedede;line-height:45px;margin:0 2px 0 2px;}
    .active > a {color:#fff;background-color: #085dc0;text-decoration:none;}
    .pagination li.pagination-page.active > a{color:#fff;background-color: #085dc0;text-decoration:none;}
    .pagination > .disabled > span,
    .pagination > .disabled > span:hover,
    .pagination > .disabled > span:focus,
    .pagination > .disabled > a,
    .pagination > .disabled > a:hover,
    .pagination > .disabled > a:focus {
      color: #777777;
      background-color: #fff;
      border-color: #ddd;
      cursor: not-allowed;
    }
    .pageing_top img { cursor: pointer }
    [v-cloak] { display: none; }
  </style>

        <div id="spinner">
                <vue-simple-spinner
                  size="big" message="로딩중..."
                  v-show="loading"
                ></vue-simple-spinner>
        </div>

  <div class="con" id="book-search" 
	v-if="records"
	v-cloak>
    <div class="box1">
        <div class="all_sear2">
                <form name="search_form2" id="search_form2" action="/index.lib" method="GET">
                    <input type="hidden" name="menuCd" value="DOM_000000201001000000">
                <fieldset class="searchbg">
                    <legend>통합 검색</legend>
                    <div class="top_select_wrap">
                        <label for="category2" class="blind">통합검색</label>
                        <select name="search_select" id="category2" 
                            class="select" title="검색구분 선택"
                            v-model="searchSelect"
                        >
                            <option value="search_title" selected>통합검색</option>
                            <option value="search_title">서명</option>
                            <option value="search_author">저자</option>
                            <option value="search_publisher">출판사</option>
                        </select>
                    </div>
                    <label for="search_text" class="blind">검색어 입력</label>
                    <input name="search_text" v-model="searchText" type="text" id="search_text" class="sword" 
                      title="검색어를 입력하세요" placeholder="검색어를 입력하세요">
                    
                    <a href="javascript:{}" onclick="document.getElementById('search_form2').submit();" class="all_sear_btn">
                    검색</a>
                </fieldset>
            </form>
        </div>
    </div>

    <div v-if="records.RESULT_INFO=='SUCCESS'">
        <div class="search sort mb_30 mt_20">
            <form name="rfc_bbs_searchForm" class="searchForm board_srch">
                <fieldset>
                    <legend>전체검색</legend>
                    <label for="align_num1" class="blind">쪽당 출력 건수</label>
		    <!-- <span class="txt_s90p pr_5">출력 건수 </span>-->
                    <select id="align_num1" name="align_num" class="base small last"
                    v-model="perPage">
                        <option value="0" disabled selected>출력 건수</option>
                        <option :value="5">5</option>
                        <option :value="10">10</option>
                        <option :value="15">15</option>
                        <option :value="20">20</option>
                        <option :value="30">30</option>
                        <option :value="50">50</option>
                        <option :value="100">100</option>
                    </select>
                    <!-- <button type="submit" class="small">조회</button> -->
                </fieldset>
            </form>
        </div>

        <!-- 상단 페이징 -->
        <div class="pageing_top">
            <img v-if="pagination.currentPage != 1" 
            @click="setPage(pagination.currentPage-1)" 
            src="/images/common/btn_arr_l.gif" 
            alt="이전페이지">
            <span class="current">{{(pagination.currentPage-1)*perPage+1}}</span> - 
            <span>{{pagination.currentPage*perPage}}</span>
            <img v-if="pagination.currentPage != pagination.numPages" 
            @click="setPage(pagination.currentPage+1)" 
            src="/images/common/btn_arr_r.gif" 
            alt="다음페이지">
        </div>
        <!-- //상단 페이징 -->
        <!-- total-->
        <div class="total_area line">
            <p class="total">총 <strong>{{records.LIST_DATA[0].SEARCH_COUNT}}</strong>건 
            [page {{pagination.currentPage}}/{{pagination.numPages}}]</p>
        </div>
        <!--// total-->

        <form>
            <fieldset>
                <legend>도서 정보</legend>
                <ul class="result_search basic">

                    <template v-if="records.LIST_DATA[0].SEARCH_COUNT=='0'">
                    <li class="no_item">등록된 자료가 없습니다.</li>
                    </template>
                    <li class="item"
                    v-for="(record, index) in records.LIST_DATA"
                    v-if="index > 0">
                        <dl>
                            <dt class="tit blind">표지</dt>
                            <dd class="book_img">
                                <img :src="record.IMAGE" alt="표지이미지">
                            </dd>
                            <dt class="tit blind">번호 : </dt>
                            <dd class="num">[No.{{ record.RNUM }}]</dd>
                            <dt class="tit blind">제목 : </dt>
                            <dd class="tit book_name expand1">
                               <!-- <a href="#">{{record.TITLE_INFO}}</a> -->
				{{record.TITLE_INFO}}
                                <button type="button" title="상세보기" class="btn"
                                @click="toggleDetailInfo(record.BOOK_KEY)">상세보기</button>
                            </dd>
                            <dt class="tit">저자 : </dt>
                            <dd class="info">{{record.AUTHOR}}</dd>
                            <dt class="tit">출판사 : </dt>
                            <dd class="info">{{record.PUBLISHER}}</dd>
                            <dt class="tit">청구기호 : </dt>
                            <dd class="info">{{record.CALL_NO}}</dd>
                            <dt class="tit">출판년도 : </dt>
                            <dd class="info">{{record.PUB_YEAR}}</dd>
                            <dt class="tit">자료유형 : </dt>
                            <dd class="type info">{{record.FORM_CODE}}</dd>

                            <!-- 개발자 : 상세보기 버튼 클릭시 보여짐 -->
                            <dt class="tit blind preview_tit">상세정보</dt>
                            <dd class="preview" style="display: block;">
                                <detail-info
                                    v-if="isVisibleDetailInfo(record.BOOK_KEY)"
                                    :record="record">
                                </detail-info>
                            </dd>
                        </dl>

                        <div>
                            <div class="info_table expand2">
                                <p class="txt_s100p">
                                    <strong>소장정보</strong>
                                    <span class="c_red">{{ record.SHELF_LOC_NAME}}</span>
                                    <span class="btn small arr_down"
                                    @click="togglePlacementInfo(record.BOOK_KEY)">펼쳐보기</span>
                                </p>
                                <div class="table_area expand2_con" style="display:block;">
                                    <placement-info
                                        v-if="isVisiblePlacementInfo(record.BOOK_KEY)"
                                        :record="record"
					userkey="<%= EgovUserDetailsHelper.getUniqId() %>"
				    ></placement-info>
                                </div>
                            </div>
                        </div>
                    </li>
                </ul>


                <!-- 페이징 -->
                <div class="pageing">
                    <uib-pagination 
                    :total-items="records.LIST_DATA[0].SEARCH_COUNT"
                    :items-per-page="perPage"
                    v-model="pagination"
                    :max-size="5" 
                    class="pageing" 
                    :boundary-links="true"
                    @change="pageChanged()"
                    first-text="&lt;&lt;"
                    previous-text="&lt;"
                    next-text="&gt;"
                    last-text="&gt;&gt;"
                    ></uib-pagination>
                </div>
            </fieldset>
        </form>

    </div>
</div>                                                           

  <script src="/gnlib/lcms/component/vuejs-uib-pagination.js"></script>
  <script src="/gnlib/lcms/component/detail-info.js"></script>
  <script src="/gnlib/lcms/component/placement-info.js"></script>
  <script src="https://rawgit.com/cristijora/vue-tabs/master/dist/vue-tabs.js"></script>
  <script src="/gnlib/lcms/component/vue-simple-spinner.min.js"></script>
  <script src="/gnlib/lcms/book-search.js"></script>                                                                                                                                                                                                                                                                                   