// var apiBookSearchUrl = 'http://localhost/gnlib/lcms/book-purchase-search-error.html?'
// var apiBookSearchUrl = 'http://localhost/gnlib/lcms/book-purchase-search-result-json.html?'
var apiBookSearchUrl = 'http://lib.gyeongnam.go.kr/kdotapi/UserHistory/BookSearch?'

var Bus = Vuedals.Bus;
var Component = Vuedals.Component;
var Plugin = Vuedals.default;

Vue.use(Plugin);

var bookBus = new Vue()

var bookSearch = {

  name: 'book-search-modal',
  template: '#book-purchase-request-book-search-template',
  props: ['userKey'],
  data: function () {
    return { searchText: '',
              records: null,
              perPage: 10,
              page: 1,
              totalCount: 0,
              pagination: { currentPage: 1 },
              checkResult: null
            }
  },
  watch: {
    page: function (val, oldVal) {
      this.$nextTick(function() {
        this.fetchData()
      })
    }
  },
  methods: {
    fetchData: function() {
      var xhr = new XMLHttpRequest()
      var self = this
      var requestUrl = ''
      var searchText = 'keyword='+self.searchText
      var perPage = '&display='+self.perPage
      var page = '&pageno='+self.page
      requestUrl = apiBookSearchUrl + searchText + perPage + page
      requestUrl = encodeURI(requestUrl)
      console.log('requestUrl ', requestUrl)
      xhr.open('GET', requestUrl, false)
      xhr.onload = function () {
        self.records = JSON.parse(xhr.responseText)
      }
      xhr.send()
    },
    sendBookInfo: function (record) {
      bookBus.$emit('bookInfoBus', record)
      this.$vuedals.close()
    },
    searchBook: function(searchText) {
      console.log('searchText: ', searchText)
      this.searchText = searchText
      this.fetchData()
    },
    pageChanged: function() {
      this.page = this.pagination.currentPage
    },
    setPage: function(pageNo) {
      this.page = pageNo
    },
    checkBook: function(record) {
      var xhr = new XMLHttpRequest()
      var self = this
      var requestUrl = 'http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/bookfurnishrequestcheck?manage_code=MA'
      // var requestUrl = 'http://localhost/gnlib/lcms/book-purchase-search-check-result-json.html?manage_code=MA'
      var userKey = '&userkey='+self.userKey
      var isbn = '&isbn='+record.ISBN
      requestUrl = requestUrl + userKey + isbn
      requestUrl = encodeURI(requestUrl)
      console.log('requestUrl ', requestUrl)
      xhr.open('GET', requestUrl, false)
      xhr.onload = function () {
        self.checkResult = JSON.parse(xhr.responseText)
      }
      xhr.send()
      if(self.checkResult.RESULT_INFO=="ERROR") {
        alert(self.checkResult.RESULT_MESSAGE)
      } else {
        alert('신청가능한 도서입니다.')
      }
    },
  },
  created: function() {
    this.fetchData()
    console.log('page: ',this.page)
  },    
};

var bookRequest = new Vue({
  el: '#book-purchase-request',
  components: {
    vuedals: Component,
    // uib-pagination: aaa,
  },
  created: function () {
    self = this
    bookBus.$on('bookInfoBus', function (value) {
      var rex = /(<([^>]+)>)/ig;
      self.isbn = value.ISBN
      self.price = value.PRICE
      self.title = value.TITLE.replace(rex,"")
      self.publisher = value.PUBLISHER
      self.publish = value.PUBDATE.substring(0,4)
      self.author = value.AUTHOR
    })
  },
  data: {
    record: null,
    resultData: null,
    userKey: null,
    publish: null,
    sms: 'Y',
    author: null,
    recomOpinion: null,
    title: null,
    manageCode: 'MA',
    price: null,
    publisher: null,
    isbn: null,
  },
  watch: {
  },
  filters: {
  },
  methods: {
    requestBook: function(reckey, event) {
      var xhr = new XMLHttpRequest()
      var self = this
      var requestUrl = 'http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/bookfurnishrequest?'
      requestUrl = requestUrl + 'userkey=' + self.userKey
                    +'&publish_year=' + self.publish
                    +'&sms_receipt_yn=' + self.sms
                    +'&author=' + self.author
                    +'&recom_opinion=' + self.recomOpinion
                    +'&title=' + self.title
                    +'&manage_code=' + self.manageCode
                    +'&price=' + self.price
                    +'&publisher=' + self.publisher
                    +'&isbn=' + self.isbn

      
      requestUrl = encodeURI(requestUrl)
      console.log('requestUrl',requestUrl)
      xhr.open('POST', requestUrl, false)
      xhr.onload = function() {
        self.resultData = JSON.parse(xhr.responseText)
      }
      xhr.send()
      if(self.resultData.RESULT_INFO == "SUCCESS") {
        location.href='/index.lib?menuCd=DOM_000000206002003000'
      } else {
          alert(self.resultData.RESULT_MESSAGE)
      }
    },
    openModal: function() {
      this.$vuedals.open({
              title: '신청도서검색',
              size: 'lg',
              component: bookSearch,
              props: {
                  userKey: this.userKey,
              }
          });
      },
  }
})