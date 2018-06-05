var apiURL = 'http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/booksearch?manage_code=MA'
// var apiURL = 'http://localhost/gnlib/lcms/booksearch2-result-json.html?manage_code=MA'

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

var bookSearch = new Vue({
  el: '#book-search',
  props: {
    // apiURL: null,
  },
  data: {
    records: null,
    headers: null,
    visibleDetailInfoes: [],
    visiblePlacementInfoes: [],
    perPage: 10,
    page: 1,
    totalCount: 0,
    pagination: { currentPage: 1 },
    searchText: '',
    searchSelect: 'search_title',
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
      this.loading = true
      var xhr = new XMLHttpRequest()
      var self = this
      var perPage = '&display='+self.perPage
      var page = '&pageno='+self.page
      var requestUrl = ''
      var requestParamSearchSelect = self.getRequestParam('search_select')
      var requestParamSearchText = self.getRequestParam('search_text')

      if (typeof requestParamSearchText != 'undefined') {
        self.searchText = requestParamSearchText
      }

      if (typeof requestParamSearchSelect != 'undefined') {
        self.searchSelect = requestParamSearchSelect
      }

      var searchText = '&' + self.searchSelect +'='+self.searchText + '&search_type=detail'
      requestUrl = apiURL + searchText + perPage + page
      requestUrl = encodeURI(requestUrl)
      xhr.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) self.onNext(xhr.responseText)
      }
      xhr.open('GET', requestUrl)
      xhr.send()
      this.pagination.currentPage = self.page
      this.loading = true
      this.transferLoading()
    },
    transferLoading: function () {
      bus.$emit('loadingBus', this.loading)
    },    
    onNext: function(responseText) {
      this.records = JSON.parse(responseText)
      this.loading = false
      this.transferLoading()
      
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
    },
    searchBook: function(searchText) {
      console.log('searchText: ', searchText)
      this.searchText = searchText
      this.fetchData()
    },
    getRequestParam: function (name){
      if(name=(new RegExp('[?&]'+encodeURIComponent(name)+'=([^&]*)')).exec(location.search))
         return decodeURIComponent(name[1])
    },
  }
})