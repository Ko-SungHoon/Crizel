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
      console.log('requestUrl ', requestUrl)
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
  }
})

var bookDetail = new Vue  ({
  el: '#book-detail-view',
})
