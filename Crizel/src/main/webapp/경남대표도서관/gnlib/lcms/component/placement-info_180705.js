Vue.component('placementInfo', {
  template: [
    '<table class="table_c">',
      '<caption>자료실/서가, 청구기호, 등록번호, 도서상태, 반납예정일에 관한표</caption>',
      '<colgroup>',
        '<col style="width:25%;">',
        '<col style="width:20%;">',
        '<col style="width:20%;">',
        '<col style="width:15%;">',
        '<col style="width:20%;">',
      '</colgroup>',
      '<thead>',
        '<tr>',
          '<th scope="col">자료실/서가</th>',
          '<th scope="col">청구기호</th>',
          '<th scope="col">등록번호</th>',
          '<th scope="col">도서상태</th>',
          '<th scope="col">반납예정일</th>',
        '</tr>',
      '</thead>',
      '<tbody>',
      '<tr>',
        '<td>{{ record.SHELF_LOC_NAME}}</td>',
        '<td>{{record.CALL_NO}}</td>',
        '<td>{{record.REG_NO}} / {{record.LOAN_CHECK}}</td>',
        '<td v-if="record.LOAN_CHECK == 0">대출가능</td>',
        '<td class="c_red" v-else>대출불가',
          '<div v-if="record.RESERVATION_STATUS ==1">',
          '<span class="btn small" @click="reservationBook">예약하기</span></div>',
          '<div class="c_red" v-else>예약불가</div>',
        '</td>',
        '<td>{{record.RETURN_PLAN_DATE}}</td>',
      '</tr>',
      '</tbody>',
    '</table>',
  ].join(''),
  props: {
    record: {
      type: Object,
      required: true
    },
    userkey: '',
  },
  data: function () {
    return { resultData: null }
  }
  ,
  methods: {
    reservationBook: function(event) {
      var xhr = new XMLHttpRequest()
      var self = this
      var requestUrl = 'http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/bookreserve?'
      // var requestUrl = 'http://localhost/gnlib/lcms/book-reservation-result-json.html?'
      requestUrl = requestUrl + 'userkey='+self.userkey + '&bookkey=' + self.record.BOOK_KEY + '&booktype=BO'

      console.log('requestUrl',requestUrl)

      xhr.open('GET', requestUrl, false)
      xhr.onload = function() {
        self.resultData = JSON.parse(xhr.responseText)
      }
      xhr.send()
      if (self.resultData.RESULT_INFO == "ERROR") {
        alert('도서예약에 실패하였습니다.')
      } else {
        alert('선택한 도서가 예약되었습니다. 내도서관 메뉴에서 확인하세요.')
      }
    }
  }
})
