function goLink(){
	var array = ["/list.do?mode=nyaa", "/onejav.do", "https://5nani.com/xe/index.php?mid=manko"
		, "/girls.do"];		// /comic/do
	
	for(var i=0; i<array.length; i++){
		window.open(array[i], "_blank");
		}
}

$(function(){
	$(window).scroll(function() {
		console.log($(this).scrollTop());
		var $el = $('.menu');
	  
		if($(this).scrollTop() <= 0) $el.css('position', 'static');
		else $el.css('position', 'fixed');
	});
});