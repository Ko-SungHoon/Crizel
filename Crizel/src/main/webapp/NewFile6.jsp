  <!-- vuetable-2 dependencies -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.5.9/vue.js"></script>

<style>
    [v-cloak] {
        display: none;
    }
</style>

<script type="text/x-template" id="book-detail-template">
    <div>
        <template v-for="(record, index) in records.LIST_DATA" v-if="index > 0">
            <h3 class="bl_h3 blind">상세정보</h3>
            <ul class="result_search basic">
                <li class="item view box1 line mb_0">
                    <p class="tit1">{{record.TITLE_INFO}}</p>
                    <p class="tit2">{{record.AUTHOR}}</p>
                    <dl>
                        <dt class="tit blind">표지</dt>
                        <dd class="book_img">
                            <img :src="record.IMAGE" alt="표지이미지">
                            <span class="book_mask"></span>
                        </dd>
                        <dt class="tit line">자료유형 : </dt>
                        <dd class="type info line">{{record.MEDIA_NAME}}</dd>
                        <dt class="tit">개인저자 : </dt>
                        <dd class="info">{{record.AUTHOR}}</a></dd>
                        <dt class="tit">서명/저자사항 </dt>
                        <dd class="info">{{record.TITLE_INFO}} / {{record.AUTHOR}}</dd>
                        <dt class="tit">발행사항 : </dt>
                        <dd class="info">{{record.PUBLISHER}}, {{record.PUB_YEAR}}</dd>
                        <dt class="tit">형태사항 : </dt>
                        <dd class="info">{{record.PAGE}}, {{record.BOOK_SIZE}}</dd>
                        <dt class="tit">ISBN : </dt>
                        <dd class="info">{{record.ISBN}}</dd>
                    </dl>
                </li>
            </ul>

            <h3 class="bl_h3">소장정보</h3>
            <div class="table_area">
                <table class="table_c">
                    <caption>소장정보 : 번호, 등록번호, 청구기호, 자료실/서가, 도서상태, 반납예정일일에 대한 정보를 제공하는 표</caption>
                    <colgroup>
                        <col style="width:10%;">
                        <col style="width:15%;">
                        <col style="width:20%;">
                        <col style="width:15%;">
                        <col style="width:20%;">
                        <col style="width:20%;">
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">No.</th>
                            <th scope="col">등록번호</th>
                            <th scope="col">청구기호</th>
                            <th scope="col">자료실/서가</th>
                            <th scope="col">도서상태</th>
                            <th scope="col">반납예정일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>{{record.RNUM}}</td>
                            <td>{{record.CONTROL_NO}}</td>
                            <td>{{record.CALL_NO}}</td>
                            <td>{{record.SHELF_LOC_NAME}}</td>
							<td v-if="record.BOOK_STATUS == 1 && (record.RESERVATION_CNT != 1 && record.RESERVATION_CNT != 2)">대출가능</td>
          					<td v-else-if="record.BOOK_STATUS == 1 && (record.RESERVATION_CNT == 1 || record.RESERVATION_CNT == 2)">예약대출대기중</td>
          					<td class="c_red" v-else>대출불가
            					<div v-if="record.RESERVATION_STATUS ==1">
            						<span class="btn small" @click="reservationBook">예약하기</span>
								</div>
            					<div class="c_red" v-else>예약불가</div>
          					</td>
                            <td v-if="record.LOAN_CHECK == 0">대출가능</td>
                            <td v-else>대출불가</td>
                            <td v-if="record.LOAN_CHECK == 0">-</td>
                            <td v-else>{{record.RETURN_PLAN_DATE}}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </template>
    </div>
</script>
<div class="con" id="book-detail-view" v-cloak>
    <book-detail api-url="http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/getbookinfo?manage_code=MA"
                 book-type="BOOK">
    </book-detail>


    <div class="btn_area">
        <button type="button" class="btn medium color1" onclick="javascript:history.back()">이전화면</button>
    </div>
</div>

<script src="/gnlib/lcms/component/vue-simple-spinner.min.js"></script>
<script src="/gnlib/lcms/book-detail.js"></script>                                                                                                                                                                 