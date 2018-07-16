Vue.component('bookSimpleList', {
  template: '#book-purchase-request-list-template',
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
      requestUrl = self.apiUrl + userKey + '&display=1000'
      requestUrl = encodeURI(requestUrl)
      xhr.open('GET', requestUrl, false)
      xhr.onload = function () {
        self.records = JSON.parse(xhr.responseText)
      }
      xhr.send()
    },
    requestCancelBook: function(reckey, event) {
      var xhr = new XMLHttpRequest()
      var self = this
      var requestUrl = 'http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/bookfurnishcancel?'
      requestUrl = requestUrl + 'reckey=' + reckey

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
  el: '#book-purchase-request-list',
  data: {
  },
  watch: {
  },
  filters: {
  },
  methods: {

  }
})