$(document).ready(function(){
	var $window=$(window);
	var $body=$('body');
	var $lnb=$('#lnb');
	var $gnb=$('#gnb');
	var $bg=$('#lnb_bg');
	var $li=$lnb.find('li'); 
	var $sub=$lnb.find('.depth2');
	var $lnb_btn=$('#lnb_btn2 , .close, #lnb_mask');
	var winWidth=$window.width();
	var current=0;
	var speed=300;
	var subHeight=$sub.find('ul').height();
	var inflection=900;
	var scrollTop=0;


	//scrollTop
	$(document).scroll(function(){
		scrollTop=$window.scrollTop();
		//console.log(scrollTop)
	})

	//event
	$li.bind({
		//pc
		mouseenter:function(){
			if(winWidth>=inflection){
				$body.addClass('lnb_over');
				$(this).addClass('on');
				$sub.stop().animate({'height':subHeight},speed);
				$bg.stop().animate({'height':subHeight},speed);
			}
		},
		mouseleave:function(){
			if(winWidth>=inflection){
				$body.removeClass('lnb_over');
				$(this).removeClass('on');
				$sub.stop().animate({'height':0},speed);
				$bg.stop().animate({'height':0},speed);
			}
		},

		//mobile
		click:function(){
			if(winWidth<inflection){
				if(current!=$li.index($(this))){
					$li.removeClass('on');
				}
				current=$li.index($(this));
				$(this).toggleClass('on');
			}
		}
	});

	$lnb_btn.bind('click',function(){
		$body.toggleClass('lnb_on');
		if($lnb.css("left")!="0px"){
			$lnb.css({'left':'-100%'}).stop().animate({'left':0},speed);
		}else{
			$lnb.css({'left':'0'}).stop().animate({'left':'-100%'},speed);
			$li.removeClass('on');
		}
	});


	//body class
	function setBodyClass(_b){
		winWidth=$window.width();
		if(winWidth>=inflection){
			$body.addClass('pc');
			$body.removeClass('mo');
			$lnb.height('auto');
			subHeight=$sub.find('ul').height();
		}else{
			$body.addClass('mo');
			$body.removeClass('pc');
			$lnb.height($window.outerHeight()-$lnb.position().top+scrollTop);
		}
		$li.removeClass('on')

	};
	setBodyClass();

	$window.resize(function(){
		setBodyClass();


	})
	
	//포커스 시 메뉴 펼치기
	$li.bind( "focusin", function() {
		if(winWidth>=inflection){
			$body.addClass('lnb_over');
			$(this).addClass('on');
			$sub.stop().animate({'height':subHeight},speed);
			$bg.stop().animate({'height':subHeight},speed);
		}
	});
	
	$li.bind( "focusout", function() {
		if(winWidth>=inflection){
			$body.removeClass('lnb_over');
			$(this).removeClass('on')
			$sub.stop().animate({'height':0},speed);
			$bg.stop().animate({'height':0},speed);
		}
	});

});          