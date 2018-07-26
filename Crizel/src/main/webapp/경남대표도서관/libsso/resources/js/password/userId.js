$(function() {
    
	function moveNextPage(agentId, userId) {
        var form = $('<form action="/password/passwordQA.html" method="post">'
                + '<input type="hidden" name="agentId" value="' + agentId + '" />'
                + '<input type="hidden" name="userId" value="' + userId + '" />'
                + '</form>');
        $('body').append(form);
        form.submit();
    }
	
	function loginPage(agentId) {
        var form = $('<form action="/login.html" method="post">'
                + '<input type="hidden" name="agentId" value="' + agentId
                + '" />' + '</form>');
        $('body').append(form);
        form.submit();
    }
	
    var props = {
        constants : {},
        elements : {
            $captcha: $('#captcha'),
            $btnContinue : $('#btn-continue'),
            $btnCancel : $('#btn-cancel'),
            $btnReload : $('#btn-reLoad'),
            $btnSoundOn : $('#btn-soundOn')
        }
    };

    var UserIdView = new ISP.View({
        checkUserId : function() {

            resetErrorMessage();

            var id = $('#id').val();
            var agentId = $('#agentId').val();
            var captcha = $('#captcha').val();
            
            if (id == undefined || id.length == 0) {
                alertErrorMessage(L[210000]);
                return;
            }
            if (captcha == undefined || captcha.length == 0) {
                alertErrorMessage(L[320025]);
                return;
            }
            	
            $.ajax({
                url : '/password/checkUserId',
                type : 'POST',
                dataType : 'json',
                data : { 
                	userId : id, 
                	agentId : agentId, 
                	captcha : captcha
                	},
                success : function(data) {
                    console.log(data);
                    var resultCode = data.resultCode
                    var resultMessage = data.resultMessage

                    if (resultCode == "000000") {
                        var agentId = $('#agentId').val();
                        
                        moveNextPage(agentId, id);
                        return;
                    } else {
                        alertErrorMessage(resultMessage);
                        return;
                    }
                },
                error : function(xhr, msg, e) {
                }
            });

        },
        loadCaptcha : function() {
        	
        	var timeData = new Date();
        	var reloadNum = timeData.getTime();
        	var captchaUrl = '/password/getCaptCha';
        	
        	$('#captchaImg').html('<img src="/password/getCaptcha?' + reloadNum + '" style="width=100%"/>');
        },
        playAudio : function() {
        	
        	var timeData = new Date();
        	var reloadNum = timeData.getTime();
        	var browserInfo = navigator.userAgent.toLowerCase();

        	if((browserInfo.indexOf("msie") >= 0 || browserInfo.indexOf("trident") >= 0)) {
        		
        		var htmlString = '<bgsound src="/password/getCaptchaAudio?' + reloadNum + '">'
        		
        		$('#captchaAudio').html(htmlString);

        	} else if(browserInfo.indexOf("chrome") >= 0 ||
        			browserInfo.indexOf("firefox") >= 0 ||
        			browserInfo.indexOf("safari") >= 0) {

        		var htmlString = '<audio controls autoplay style="height:0px;width:0px;"><source src="/password/getCaptchaAudio?' + reloadNum + '" type="audio/wav"></audio>';

        		$('#htmlString').html(htmlString);

        	} else {
        		// 예외처리 필요
        		//alert(browserInfo);
        	}
        },
        appendEvents : function() {
            var self = this;
            var elements = props.elements;
            
            elements.$captcha.keypress(function(e) {
                if ( e.keyCode !== 13 ) return;
                self.checkUserId();
            });

            elements.$btnContinue.click(function() {
                self.checkUserId();
            });

            elements.$btnCancel.click(function() {
            	var agentId = $('#agentId').val();
            	loginPage(agentId);
            });

            elements.$btnReload.click(function() {
            	self.loadCaptcha();
            });

            elements.$btnSoundOn.click(function() {
            	//self.playAudio();
            });
        },
        init : function() {
            this.appendEvents();
            
            this.loadCaptcha();
        }
    });
    
    UserIdView.init();
});