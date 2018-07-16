var apiUrl = 'http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/bookloanbest?manage_code=MA&shelf_loc_code=002'
// var apiUrl = 'http://localhost/gnlib/lcms/book-loan-best-result-json.html?manage_code=MA'

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

var bookSearch = new Vue({
  el: '#book-loan-best',
  data: {
    records: null,
    headers: null,
    visibleDetailInfoes: [],
    visiblePlacementInfoes: [],
    perPage: 15,
    page: 1,
    totalCount: 0,
    pagination: { currentPage: 1 },
    searchText: '',
    loading: false,
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
      var searchText = '&search_txt='+self.searchText
      requestUrl = apiUrl + searchText + perPage + page + startdate + enddate 
      requestUrl = encodeURI(requestUrl)
      xhr.open('GET', requestUrl)
      xhr.onload = function () {
        self.records = JSON.parse(xhr.responseText)
        self.loading = false
        self.transferLoading()
      }
      xhr.send()
      this.loading = true;
      this.transferLoading()
      this.pagination.currentPage = self.page
    },
    transferLoading: function () {
      bus.$emit('loadingBus', this.loading)
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
      this.page = this.pagination.currentPage
    },
    setPage: function(pageNo) {
      this.page = pageNo
    },
    searchBook: function(searchText) {
      this.searchText = searchText
      this.fetchData()
    },
  }
})
