Vue.component('singlePlacementInfo', {
  template: [
    '<div>',
    '<template v-for="(record, index) in records.LIST_DATA" v-if="index > 0">',
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
          '<td v-if="record.RESERVATION_STATUS == 0">대출가능</td>',
	      '<td class="c_red" v-else>대출불가',
            '<div v-if="record.RESERVATION_STATUS ==1">',
            '<span class="btn small" @click="reservationBook">예약하기</span></div>',
            '<div class="c_red" v-else>예약불가</div>',
          '</td>',
          '<td>{{record.RETURN_PLAN_DATE}}</td>',
        '</tr>',
      '</tbody>',
    '</table>',
    '</template>',
    '</div>',
  ].join(''),
  props: {
    apiUrl: {
      type: String,
      required: true
    },
    bookType: {
      type: String,
      required: true
    },
    userkey: {
      type: String,
      required: true
    },
    bookRegNo: {
      type: String,
      required: true
    },
  },
  
  data: function () {
      return { 
        records: null,
        resultData: null 
      }
  },
  
  created: function() {
    this.fetchData()
  },  
  methods: {
    fetchData: function() {
      var xhr = new XMLHttpRequest()
      var self = this
      var requestUrl = ''
      var bookType = '&book_type='+self.bookType
      var regNo = '&reg_no='+ self.bookRegNo
      requestUrl = self.apiUrl + bookType + regNo
      requestUrl = encodeURI(requestUrl)
      console.log('requestUrl ', requestUrl)
      xhr.open('GET', requestUrl, false)
      xhr.onload = function () {
        self.records = JSON.parse(xhr.responseText)
      }
      xhr.send()
    },
    reservationBook: function(bookKey, event) {
      var xhr = new XMLHttpRequest()
      var self = this
      var requestUrl = 'http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/bookreserve?'
      // var requestUrl = 'http://localhost/gnlib/lcms/book-reservation-result-json.html?'
      requestUrl = requestUrl + 'userkey='+self.userkey + '&bookkey=' + bookKey + '&booktype=BO'

      console.log('requestUrl',requestUrl)

      xhr.open('GET', requestUrl, false)
      xhr.onload = function() {
        self.resultData = JSON.parse(xhr.responseText)
      }
      xhr.send()
      if (self.resultData.RESULT_INFO == "ERROR") {
    	  if(self.resultData.RESULT_CODE == "K0171001"){
    		  alert("로그인후 비치희망도서를 신청하실수 있습니다");  
    	  }else if(self.resultData.RESULT_CODE == "K0173008"){
    		  alert("대출정지기간에는 비치희망도서를 신청하실 수 없습니다");
    	  }else{
    		  alert('도서예약에 실패하였습니다.')
    		  //alert(self.resultData.RESULT_MESSAGE);  
    	  }
    			
        //alert('도서예약에 실패하였습니다.')
      } else {
        alert('선택한 도서가 예약되었습니다. 내도서관 메뉴에서 확인하세요.')
      }
    }
  }
})
