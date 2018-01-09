$(function(){
	/*
	var d = new Date();
	var week = new Array('일', '월', '화', '수', '목', '금', '토');
	var dayCheck = week[d.getDay()];
	var value = $('#dayCheck').val();
	var dayCheck = value;
	if (dayCheck == "일") {
		$('.sun').css('background', '#525252');
		$('.sun').css('color', 'white');
	} else if (dayCheck == "월") {
		$('.mon').css('background', '#525252');
		$('.mon').css('color', 'white');
	} else if (dayCheck == "화") {
		$('.tue').css('background', '#525252');
		$('.tue').css('color', 'white');
	} else if (dayCheck == "수") {
		$('.wed').css('background', '#525252');
		$('.wed').css('color', 'white');
	} else if (dayCheck == "목") {
		$('.thu').css('background', '#525252');
		$('.thu').css('color', 'white');
	} else if (dayCheck == "금") {
		$('.fri').css('background', '#525252');
		$('.fri').css('color', 'white');
	} else if (dayCheck == "토") {
		$('.sat').css('background', '#525252');
		$('.sat').css('color', 'white');
	}
	*/
	
	if($(window ).width() < 768){
		for(var i=0; i<31; i++){
			if($("#price_"+i).text() != ""){
				$("#td_"+i).css("background", "#5496ff");
			}else{
				$("#td_"+i).css("background", "#7ac6ff");
			}
		}	
	}
	
	$( window ).resize(function() {
		if($(window ).width() < 768){
			for(var i=0; i<31; i++){
				if($("#price_"+i).text() != ""){
					$("#td_"+i).css("background", "#5496ff");
				}
			}	
		}else{
			for(var i=0; i<31; i++){
				$("#td_"+i).css("background", "#7ac6ff");
			}	
		}
	});
	
	//메인페이지 북마크 마우스오버시 투명해지기
	$(".menu ul a img").hover(function(){
		$(this).animate({
			opacity: 0.3
		}, 300);
		$(this).parent().children("span").css("display", "block");
	},function(){
		$(this).clearQueue();
		$(this).animate({opacity: 1});
		$(this).parent().children("span").css("display", "none");
	});
	
	//회원가입
	$("#registerSubmit").click(function(){
		if($.trim($("#re_id").val())==""){
			alert("ID를 입력하여 주십시오");
		}else if($.trim($("#re_pw").val())==""){
			alert("PW를 입력하여 주십시오");			
		}else if($.trim($("#name").val())==""){
			alert("이름을 입력하여 주십시오");			
		}else if($.trim($("#email").val())==""){
			alert("이메일을 입력하여 주십시오");			
		}else if($.trim($("#phone").val())==""){
			alert("전화번호를 입력하여 주십시오");			
		}else if($.trim($("#nick").val())==""){
			alert("닉네임을 입력하여 주십시오");			
		}else{
			
			var id = $("#re_id").val();
			$.ajax({
				type : "POST",
				url : "/registerCheck.do?re_id="+id,
				contentType : "application/x-www-form-urlencoded; charset=utf-8",
				data : id,
				datatype : "json",				
				success : function(data) {
					if(data.result=="success"){
						alert("이미 존재하는 아이디입니다.");
					}else{
						$("#registerForm").attr("post","/register.do").submit();
					}
				},
				error : function(e) {
					alert("에러발생");
				}
			});			
		}	
		
	});	
});
