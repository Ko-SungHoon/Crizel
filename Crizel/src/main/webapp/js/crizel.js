function goLink(){
	var array = ["/list.do?mode=nyaa", "/onejav.do", "https://5nani.com/xe/index.php?mid=manko"
		, "/girls.do"];		// /comic/do
	
	for(var i=0; i<array.length; i++){
		window.open(array[i], "_blank");
		}
}

$(function(){
	var width = window.innerWidth;
	$(window).scroll(function() {
		console.log($(this).scrollTop());
		var $el = $('.menu');
	  if(width>1024){
		  var $el = $('.menu');
	  }else{
		  var $el = $('.menu_icon');
	  }
	  
	  if($(this).scrollTop() <= 0) $el.css('position', 'static');
	  else $el.css('position', 'fixed');
	});
	
	$(".menu_icon").click(function(){
		if($(".menu").css("display") == "none"){
			$(".menu").css("display", "block");
		}else{
			$(".menu").css("display", "none");
		}
	});
});