$(function(){
	var bus = new Vue();
	var spinner = new Vue({
		  el: '#spinner',
		  data: {
		    loading: false
		  },
		  created: function () {
		    self = this
		    bus.$on('loadingBus', function (value) {
		      console.log("value : " + value)
		      self.loading = value
		    })
		  },
		})

	var movieApi = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchWeeklyBoxOfficeList.json?";
	var mainMovie = new Vue({
		  el: '#mainMovie',
		  data: {
		    records: null,
		    loading: false
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
		      var date = new Date();
		      date.setDate(date.getDate() - 7)
		      var key = "key=af6cbec63ac47906095794b914d659e7";
		      var targetDt = '&targetDt=' + date.toISOString().slice(0,10).replace(/-/g,"");
		      requetUrl = movieApi + key + targetDt;
		      xhr.open('GET', requetUrl)
		      xhr.onload = function () {
		        self.records = JSON.parse(xhr.responseText);
		        self.loading = false;
		        self.transferLoading();
		        console.log("vue : " + requetUrl);
		        saramin();
		      }
		      xhr.send();
		      this.loading = true;
		      this.transferLoading();	
		    },
		    transferLoading: function () {
		      bus.$emit('loadingBus', this.loading);
		    },
		  }
		});
});


function saramin(){
	 $.ajax({
 		type : "POST",
 		url : "/saramin.do",
 		contentType : "application/x-www-form-urlencoded; charset=utf-8",
 		datatype : "json",
 		beforeSend:function(){
	        $("#saramin").html("로딩중입니다");
	    },
 		success : function(data) {
 			var html = "<ul class='ul_type01'>";
 			$.each(data, function(i, val) {
 				html += "<li><ul>";
 				html += "<li><a href='"+ val.url +"'>" + val.name + "</a></li>";
 				html += "<li>" + val.category + "</li>";
 				html += "<li>" + val.salary + "</li>";
 				html += "</li></ul>";
			});
 			html += "</ul>";
 			$("#saramin").append(html);	
 		},
 		error : function(request,status,error) {
 			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
 			alert("에러발생");
 		}
 	});
} 	

