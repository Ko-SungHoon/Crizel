Vue.component('bookSimpleList', {
  template: '#book-loan-list-history-template',
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
      requestUrl = self.apiUrl + userKey + '&startdate=20180101&pageno=1&display=1000'
      requestUrl = encodeURI(requestUrl)
      xhr.open('GET', requestUrl)
      xhr.onload = function () {
        self.records = JSON.parse(xhr.responseText)
      }
      xhr.send()
    },    
  }
})

var bookList = new Vue({
  el: '#book-loan-list-history',
  data: {
  },
  watch: {
  },
  filters: {
  },
  methods: {

  }
})