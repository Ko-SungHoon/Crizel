var apiURL = 'http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/newbooklist?manage_code=MA'
// var apiURL = 'http://localhost/gnlib/lcms/newbooklist.html?manage_code=MA'

var bus = new Vue()

var spinner = new Vue({
  el: '#spinner',
  data: {
    loading: false
  },
  created: function () {
    self = this
    bus.$on('loadingBus', function (value) {
      console.log(value)
      self.loading = value
    })
  },
})

var demo = new Vue({
  el: '#new-book-list',
  data: {
    records: null,
    headers: null,
    visibleDetailInfoes: [],
    visiblePlacementInfoes: [],
    perPage: 10,
    page: 1,
    totalCount: 0,

    pagination: { currentPage: 1 },
    loading: false
  },
  created: function() {
    this.fetchData()    
  },
  watch: {
    perPage: function (val, oldVal) {
      this.$nextTick(function() {
        this.fetchData()
      })
    },
    page: function (val, oldVal) {
      this.$nextTick(function() {
        this.fetchData()
      })
    }
  },
  filters: {
    truncate: function(v) {
      var newline = v.indexOf('\n')
      return newline > 0 ? v.slice(0, newline) : v
    },
    formatDate: function(v) {
      return v.replace(/T|Z/g, ' ')
    }
  },
  methods: {
    fetchData: function() {
      var xhr = new XMLHttpRequest()
      var self = this
      var perPage = '&display='+self.perPage
      var page = '&pageno='+self.page
      var requestUrl = ''
      var date = new Date()
      var enddate = '&enddate='+date.toISOString().slice(0,10).replace(/-/g,"")
      var dayOfMonth = date.getDate();
      date.setDate(dayOfMonth - 30)
      var startdate = '&startdate='+date.toISOString().slice(0,10).replace(/-/g,"")
      requetUrl = apiURL + perPage + page + startdate + enddate
      xhr.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) self.onNext(xhr.responseText)
      }
      xhr.open('GET', requetUrl)
      // xhr.onload = function () {
      //   self.records = JSON.parse(xhr.responseText)
      // }
      xhr.send()
      this.loading = true
      this.transferLoading()
      // pageLoading = this.loading
      this.pagination.currentPage = self.page
      
    },
    transferLoading: function () {
      bus.$emit('loadingBus', this.loading)
    },
    onNext: function(responseText) {
      var self = this
      this.records = JSON.parse(responseText)
      this.loading = false
      this.transferLoading()
      // setTimeout(function() {
      //   console.log('Works!')
      //   self.records = JSON.parse(responseText)
      //   self.loading = false
      //   self.transferLoading()
      // }, 9000)
      
    },
    isVisibleDetailInfo: function(dataId) {
      return this.visibleDetailInfoes.indexOf(dataId) >= 0
    },
    showDetailInfo: function(dataId) {
      if (!this.isVisibleDetailInfo(dataId)) {
        this.visibleDetailInfoes.push(dataId)
      }
    },
    hideDetailInfo: function(dataId) {
      if (this.isVisibleDetailInfo(dataId)) {
        this.visibleDetailInfoes.splice(
          this.visibleDetailInfoes.indexOf(dataId), 1
        )
      }
    },
    toggleDetailInfo: function (dataId) {
      if (this.isVisibleDetailInfo(dataId)) {
        this.hideDetailInfo(dataId)
      } else {
        this.showDetailInfo(dataId)
      }
    },
    isVisiblePlacementInfo: function(dataId) {
      return this.visiblePlacementInfoes.indexOf(dataId) >= 0
    },
    showPlacementInfo: function(dataId) {
      if (!this.isVisiblePlacementInfo(dataId)) {
        this.visiblePlacementInfoes.push(dataId)
      }
    },
    hidePlacementInfo: function(dataId) {
      if (this.isVisiblePlacementInfo(dataId)) {
        this.visiblePlacementInfoes.splice(
          this.visiblePlacementInfoes.indexOf(dataId), 1
        )
      }
    },
    togglePlacementInfo: function (dataId) {
      if (this.isVisiblePlacementInfo(dataId)) {
        this.hidePlacementInfo(dataId)
      } else {
        this.showPlacementInfo(dataId)
      }
    },

    pageChanged: function() {
      console.log('Page changed to: ' + this.pagination.currentPage);
      this.page = this.pagination.currentPage
    },
    setPage: function(pageNo) {
      console.log('pageNo: ', pageNo)
      this.page = pageNo
    }
  }
})