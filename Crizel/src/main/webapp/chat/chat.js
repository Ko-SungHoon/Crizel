$(function(){
	chat("first");
});

function chat(mode){
	var nick_name = $("#nick_name").val();
	var content = $("#content").val();
	var reg_ip = $("#reg_ip").val();
	var currHeight = $(".chat_data")[0].scrollHeight;
	if(mode == "write"){
		$("#content").val("");
	}
	$.ajax({
		type : "POST",
		url : "/chat/chatAction.jsp",
		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		data : {
			nick_name 	: 	nick_name
			, content	:	content
			, reg_ip	:	reg_ip
			, mode		: 	mode
		},
		datatype : "html",
		success : function(data) {
			$(".chat_data").html(data.trim());
			if((currHeight != $(".chat_data")[0].scrollHeight) || mode == "write" || mode == "first"){
				$(".chat_data").scrollTop($(".chat_data")[0].scrollHeight);
			}
		},
		error:function(request,status,error){
			//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}

setInterval(function(){chat("view");}, 100);

