Vue.component('bookDetail', {
  template: '#book-detail-template',
  props: {
    apiUrl: {
      type: String,
      required: true
    },
    bookType: {
      type: String,
      required: true
    },
    record: {
	    type: Object,
	    required: true
	  },
	  userkey: '',
  },
  
  data: function () {
      return { records: null }
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
      var regNo = '&reg_no='+ this.getRequestParam('breg_no')
      requestUrl = self.apiUrl + bookType + regNo
      requestUrl = encodeURI(requestUrl)
      xhr.open('GET', requestUrl)
      xhr.onload = function () {
        self.records = JSON.parse(xhr.responseText)
      }
      xhr.send()
    },
    getRequestParam: function (name){
      if(name=(new RegExp('[?&]'+encodeURIComponent(name)+'=([^&]*)')).exec(location.search))
         return decodeURIComponent(name[1])
    },
    reservationBook: function(record) {
        var xhr = new XMLHttpRequest()
        var self = this
        var requestUrl = 'http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/bookreserve?'
        // var requestUrl = 'http://localhost/gnlib/lcms/book-reservation-result-json.html?'
        requestUrl = requestUrl + 'userkey='+self.userkey + '&bookkey=' + record.BOOK_KEY + '&booktype=BO'
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
      },
  }
})

var bookDetail = new Vue  ({
  el: '#book-detail-view',
})
