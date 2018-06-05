Vue.component('bookSimpleList', {
  template: [
    '    <table class="tb_board">',
    '      <caption>도서 정보</caption>',
    '       <thead>',
    '         <tr>',
    '           <th scope="col">번호</th>',
    '           <th scope="col">도서명 / 저자</th>',
    '           <th scope="col">대출일</th>',
    '           <th scope="col">반납예정일</th>',
    '           <th scope="col">상태</th>',
    '           <th scope="col">반납연기</th>',
    '         </tr>',
    '       </thead>',
    '       <tbody>',
    '         <tr align="center"',
    '           v-for="(record, index) in records.LIST_DATA"',
    '           v-if="index > 0"',
    '    >',
    '           <td class="object1">{{record.RNUM}}</td>',
    '           <td class="object2 left">',
    '             <div>{{record.TITLE_INFO}}</div>',
    '             <div>{{record.AUTHOR}}</div>',
    '           </td>',
    '           <td class="etc center">{{record.LOAN_DATE}}</td>',
    '           <td class="etc center">{{record.RETURN_PLAN_DATE}}</td>',
    '           <td class="etc center" v-if="record.STATUS == 0">대출</td>',
    '           <td class="etc center" v-else-if="record.STATUS == 1">반납</td>',
    '           <td class="etc center" v-else-if="record.STATUS == 2">예약</td>',
    '           <td class="etc center" v-else-if="record.STATUS == 3">예약취소</td>',
    '           <td class="etc center">',
    '		        	<template v-if="record.RETURN_DEALY_CODE == 100">',
    '     			    <button type="button" class="btn medium color1">대출연장</button>',
    '			        </template>',
    '			        <template v-else>',
    '			           연기불가',
    '	        		</template>',    
    '            </td>',
    '         </tr>',
    '	  <template v-if="records.LIST_DATA[0].SEARCH_COUNT==0">',
    '		  <tr><td colspan="6">등록된 자료가 없습니다.</td></tr>',
    '	  </template>',
    '       </tbody>',
    '     </table>',    
    
    
  ].join(''),
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
      xhr.open('GET', requestUrl)
      xhr.onload = function () {
        //self.headers = xhr.getResponseHeader('link').split(',')
        self.records = JSON.parse(xhr.responseText)
      }
      xhr.send()
    },    
  }
})

var bookList = new Vue({
  el: '#book-loan-list',
  data: {
  },
  watch: {
  },
  filters: {
  },
  methods: {

  }
})