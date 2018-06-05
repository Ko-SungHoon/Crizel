Vue.component('bookSimpleList', {
  template: '#book-reservation-list-template',
  props: {
    apiUrl: {
      type: String,
      required: true
    },
    userKey: null,
  },
  data: 
    function () {
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
      var userKey = 'userkey='+self.userKey
      requestUrl = self.apiUrl + userKey
      requestUrl = encodeURI(requestUrl)
      console.log('requestUrl ', requestUrl)
      xhr.open('GET', requestUrl, false)
      xhr.onload = function () {
        self.records = JSON.parse(xhr.responseText)
      }
      xhr.send()
    },
    reservationCancelBook: function(reckey, event) {
      var xhr = new XMLHttpRequest()
      var self = this
      var requestUrl = 'http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/bookreservecancel?'
      requestUrl = requestUrl + 'userkey='+self.userKey + '&reckey=' + reckey

      console.log('requestUrl',requestUrl)

      xhr.open('GET', requestUrl, false)
      xhr.onload = function() {
        self.resultData = JSON.parse(xhr.responseText)
      }
      xhr.send()
      self.fetchData()
    }
  }
})

var bookList = new Vue({
  el: '#book-reservation-list',
  data: {
  },
  watch: {
  },
  filters: {
  },
  methods: {

  }
})