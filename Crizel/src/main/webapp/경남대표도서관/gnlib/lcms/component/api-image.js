Vue.component('apiImage', {
  template: [
    '<img :src="books.LIST_DATA[1].IMAGE" alt="표지이미지" :style="this.inlineStyle">',
  ].join(''),
  props: {
    apiUrl: {
      type: String,
      required: true
    },
    inlineStyle: '',
  },
  data: 
    function () {
      return { books: null }
    }
  ,
  created: function() {
    this.fetchData()
  },   
  methods: {
    fetchData: function() {
      var xhr = new XMLHttpRequest()
      var self = this
      var requestUrl = ''
      requestUrl = self.apiUrl
      requestUrl = encodeURI(requestUrl)
      xhr.open('GET', requestUrl, false)
      xhr.onload = function () {
        self.books = JSON.parse(xhr.responseText)
      }
      xhr.send()
    },
  }
})