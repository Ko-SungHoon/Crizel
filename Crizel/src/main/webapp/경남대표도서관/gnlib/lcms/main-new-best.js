var newBookApiURL = 'http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/newbooklist?manage_code=MA'
var bestBookApiURL = 'http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/bookloanbest?manage_code=MA'
// var newBookApiURL = 'http://localhost/gnlib/lcms/newbooklist.html?manage_code=MA'
// var bestBookApiURL = 'http://localhost/gnlib/lcms/book-loan-best-result-json.html?manage_code=MA'

var bus = new Vue()

var spinner = new Vue({
  el: '#spinner',
  data: {
    loading: false
  },
  created: function () {
    self = this
    bus.$on('loadingBus', function (value) {
      self.loading = value
    })
  },
})

var newbook = new Vue({
  el: '#new-book-main',
  data: {
    records: null,
    perPage: 4,
    page: 1,
    loading: false,
  },
  created: function() {
    this.fetchData()
  },
  watch: {
  },
  filters: {
  },
  methods: {
    fetchData: function() {
      var xhr = new XMLHttpRequest()
      var self = this
      var requestUrl = ''
      var date = new Date()
      var enddate = '&enddate='+ date.toISOString().slice(0,10).replace(/-/g,"")
      var dayOfMonth = date.getDate();
      date.setDate(dayOfMonth - 120)
      var startdate = '&startdate='+date.toISOString().slice(0,10).replace(/-/g,"")
      var perPage = '&display='+self.perPage
      requetUrl = newBookApiURL + perPage + startdate + enddate
      xhr.open('GET', requetUrl)
      xhr.onload = function () {
        self.records = JSON.parse(xhr.responseText)
        self.loading = false
        self.transferLoading()
      }
      xhr.send()
      this.loading = true
      this.transferLoading()
    },
    transferLoading: function () {
      bus.$emit('loadingBus', this.loading)
    },    
  }
})

var bestbook = new Vue({
  el: '#best-book-main',
  data: {
    records: null,
    perPage: 4,
    page: 1,
  },
  created: function() {
    this.fetchData()
  },
  watch: {
  },
  filters: {
  },
  methods: {
    fetchData: function() {
      var xhr = new XMLHttpRequest()
      var self = this
      var requestUrl = ''
      var date = new Date()
      var enddate = '&enddate='+date.toISOString().slice(0,10).replace(/-/g,"")
      var dayOfMonth = date.getDate();
      date.setDate(dayOfMonth - 30)
      var startdate = '&startdate='+date.toISOString().slice(0,10).replace(/-/g,"")
      var perPage = '&display='+self.perPage
      requetUrl = bestBookApiURL + perPage + startdate + enddate
      xhr.open('GET', requetUrl)
      xhr.onload = function () {
        self.records = JSON.parse(xhr.responseText)
      }
      xhr.send()
    },
  }
})