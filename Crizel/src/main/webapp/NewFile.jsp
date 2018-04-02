<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>
  <!-- vuetable-2 dependencies -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.5.9/vue.min.js"></script>
  <script src="/gnlib/lcms/component/vue-simple-spinner.min.js"></script>
  <script src="/gnlib/lcms/component/vuejs-uib-pagination.js"></script>
  <script src="/gnlib/lcms/component/detail-info.js"></script>
  <script src="/gnlib/lcms/component/placement-info.js"></script>
  <script src="/gnlib/lcms/component/api-image.js"></script>
  <script src="/gnlib/lcms/main.js"></script>  

  <style>
    .con{margin-bottom:80px; overflow:hidden;font-weight: 100;line-height:1.6em;}
    .pagination {display: inline-flex;}
    .pagination li a {display:inline-block; width:45px; height:45px;font-size:1.1em;  border:1px solid #dedede;line-height:45px;margin:0 2px 0 2px;}
    .active > a {color:#fff;background-color: #085dc0;text-decoration:none;}
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

<div class="con" id="new-book-list" 
	v-if="records"
	v-cloak>
    <div class="search sort mb_30 mt_20" v-if="records.LIST_DATA != null">
        <form name="rfc_bbs_searchForm" class="searchForm board_srch">
            <fieldset>
                <legend>전체검색</legend>
                <label for="align_num2" class="blind">쪽당 출력 건수</label>
                <select id="align_num2" name="align_num" class="base small last" v-model="perPage">
            <option value="0" disabled selected>출력 건수</option>
            <option :value="5">5</option>
            <option :value="10">10</option>
            <option :value="15">15</option>
            <option :value="20">20</option>
            <option :value="30">30</option>
            <option :value="50">50</option>
            <option :value="100">100</option>
                </select>
            </fieldset>
        </form>
    </div>

    <!-- 상단 페이징 -->
    <div class="pageing_top" v-if="records.LIST_DATA != null">
      <img v-if="pagination.currentPage != 1" @click="setPage(pagination.currentPage-1)" src="/images/common/btn_arr_l.gif" alt="이전페이지">
      <span class="current">{{(pagination.currentPage-1)*perPage+1}}</span> - <span>{{pagination.currentPage*perPage}}</span>
      <img v-if="pagination.currentPage != pagination.numPages" @click="setPage(pagination.currentPage+1)" src="/images/common/btn_arr_r.gif" alt="다음페이지">
    </div>
    <!-- //상단 페이징 -->
   <!--  total -->
    <div class="total_area line" v-if="records.LIST_DATA != null">
      <p class="total">총 <strong>{{records.LIST_DATA[0].SEARCH_COUNT}}</strong>건
      [page {{pagination.currentPage}}/{{pagination.numPages}}]</p>
    </div> 
    <!--// total-->

    <form>
        <fieldset>
            <legend>도서 정보</legend>
            <ul class="result_search basic">

                <!-- 개발자 : 등록된 자료가 없을 경우 안내 -->
                <li class="no_item" v-if="records.LIST_DATA == null">등록된 자료가 없습니다.</li>

                <li v-for="(record, index) in records.LIST_DATA" class="item" v-if="index > 0">
            <dl>
              <dt class="tit blind">표지</dt>
              <dd class="book_img">
                <api-image 
                  :api-url="'http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/getbookinfo?manage_code=MA&book_type=BOOK&'+'reg_no='+record.REG_NO">
                </api-image>
              </dd>
              <dt class="tit blind">번호 : </dt>
              <dd class="num">[No.{{ record.RNUM }}]</dd>
              <dt class="tit blind">제목 : </dt>
              <dd class="tit book_name expand1">
               
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
              <dd class="info">{{ record.PUB_YEAR}}</dd>
              <dt class="tit">자료유형 : </dt>
              <dd class="type info">{{ record.FORM_CODE}}</dd>
              <dt class="tit blind preview_tit">상세정보</dt>
              <dd class="preview" style="display:block">
                <template v-if="isVisibleDetailInfo(record.BOOK_KEY)">
                  <detail-info 
                    :record="record">
                  </detail-info>
                </template>
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
                <div class="table_area expand2_con" style="display: block;">
                  <template v-if="isVisiblePlacementInfo(record.BOOK_KEY)">
                    <placement-info
		      userkey="<%= EgovUserDetailsHelper.getUniqId() %>"
                      :record="record">
                    </placement-info>
                  </template>
                </div>
              </div>
            </div>
                </li>
            </ul>


            <!-- 페이징 -->
        <div class="pageing" v-if="records.LIST_DATA != null">
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
  <script src="/gnlib/lcms/component/vuejs-uib-pagination.js"></script>
  <script src="/gnlib/lcms/component/detail-info.js"></script>
  <script src="/gnlib/lcms/component/placement-info.js"></script>
  <script src="/gnlib/lcms/component/api-image.js"></script>
  <script src="/gnlib/lcms/main.js"></script>                                                                                                                                                                                                                         