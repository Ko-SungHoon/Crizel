<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>
  <!-- vuetable-2 dependencies -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.5.9/vue.min.js"></script>

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
<div class="con" 
    id="book-loan-best"
    v-if="records"
    v-cloak>
    <div v-if="records.RESULT_INFO=='SUCCESS'">
	<p class="box1 info_mini"><strong>TOP 100 목록 (최근 30일 자료집계)</strong></p>
        <form>
            <fieldset>
                <legend>도서 정보</legend>
                <ul class="result_search basic best">

                    <template v-if="records.LIST_DATA[0].SEARCH_COUNT=='0'">
                    <li class="no_item">등록된 자료가 없습니다.</li>
                    </template>
                    <li class="item"
                    v-for="(record, index) in records.LIST_DATA"
                    >
                        <dl>
                            <dt class="tit blind">표지</dt>
                            <dd class="book_img">
                                
				<span class="best_label">{{ record.RANK }}</span>
                                <img :src="record.IMAGE" alt="표지이미지">
				<!--<api-image 
                                    :api-url="'http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/getbookinfo?manage_code=MA&book_type=BOOK&'+'reg_no='+record.REG_NO">
                                </api-image>-->
                            </dd>
                            <dt class="tit blind">번호 : </dt>
                            <dd class="num">[No.{{ record.RANK }}]</dd>
                            <dt class="tit blind">제목 : </dt>
                            <dd class="tit book_name expand1">
                                <!-- <a href="#">{{record.TITLE}}</a> -->
				{{record.TITLE}}
                            </dd>
                            <dt class="tit">저자 : </dt>
                            <dd class="info">{{record.AUTHOR}}</dd>
                            <dt class="tit">출판사 : </dt>
                            <dd class="info">{{record.PUBLISHER}}</dd>
                            <dt class="tit">청구기호 : </dt>
                            <dd class="info">{{record.CALL_NO}}</dd>
                            <dt class="tit">출판년도 : </dt>
                            <dd class="info">{{record.PUBLISH_YEAR}}</dd>
                            <dt class="tit">ISBN : </dt>
                            <dd class="info">{{record.ISBN}}</dd>
                        </dl>

                        <div>
                            <div class="info_table expand2">
                                <p class="txt_s100p">
                                    <strong>소장정보</strong>
                                    <span class="c_red">{{ record.SHELF_LOC_NAME}}</span>
                                    <span class="btn small arr_down"
                                    @click="togglePlacementInfo(record.REG_NO)">펼쳐보기</span>
                                </p>
                                <div class="table_area expand2_con" style="display:block;">
                                    <single-placement-info
                                        v-if="isVisiblePlacementInfo(record.REG_NO)"
                                        api-url="http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/getbookinfo?manage_code=MA"
                                        book-type="BOOK"
                                        userkey="<%= EgovUserDetailsHelper.getUniqId() %>"
                                        :book-reg-no="record.REG_NO"
                                    ></single-placement-info>
                                </div>
                            </div>
                        </div>
                    </li>
                </ul>
            </fieldset>
        </form>

    </div>
</div>                                                           

  <script src="/gnlib/lcms/component/vuejs-uib-pagination.js"></script>
  <script src="/gnlib/lcms/component/detail-info.js"></script>
<script src="/gnlib/lcms/component/single-placement-info.js"></script>
  <script src="/gnlib/lcms/component/vue-simple-spinner.min.js"></script>
  <script src="/gnlib/lcms/component/api-image.js"></script>
  <script src="/gnlib/lcms/book-loan-best.js"></script>                                                                                                        