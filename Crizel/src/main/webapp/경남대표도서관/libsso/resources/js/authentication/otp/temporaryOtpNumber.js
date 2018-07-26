$(function() {
    
    // 토큰 정보등을 가지고 returnUrl로 forward 한다.
	function loginPage(agentId) {
        var form = $('<form action="/authentication/otp/otpLogin.html" method="post">'
                + '<input type="hidden" name="agentId" value="' + agentId
                + '" />' + '</form>');
        $('body').append(form);
        form.submit();
    }

    var props = {
        constants : {},
        elements : {
            $btnLogin : $('#btn-login')
        }
    };

    var LoginView = new ISP.View({
        appendEvents : function() {
            var self = this;
            var elements = props.elements;
            
            elements.$btnLogin.click(function() {
            	var agentId = $('#agentId').val();
            	loginPage(agentId);
            });
        },
        init : function() {
            this.appendEvents();
        }
    });
    LoginView.init();

});