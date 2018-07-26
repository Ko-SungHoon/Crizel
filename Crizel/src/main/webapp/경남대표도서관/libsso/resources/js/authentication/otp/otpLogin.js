$(function() {
    
    // 토큰 정보등을 가지고 returnUrl로 forward 한다.
    function sendToken(resultCode, resultMessage, secureToken, secureSessionId,
            returnUrl) {

        var form = $('<form action="' + returnUrl + '" method="post">'
                + '<input type="hidden" name="resultCode" value="' + resultCode
                + '" />' + '<input type="hidden" name="resultMessage" value="'
                + resultMessage + '" />'
                + '<input type="hidden" name="secureToken" value="' + secureToken
                + '" />' + '<input type="hidden" name="secureSessionId" value="'
                + secureSessionId + '" />' + '</form>');

        $('body').append(form);
        form.submit();
    }

    var props = {
        constants : {},
        elements : {
            $formlogin : $('#form-login'),
            $otpNumber : $('#otpNumber'),
            $btnLogin : $('#btn-login'),
            $linkTemporaryOtpNumber : $('#link-temporary-otp-number')
        }
    };

    var LoginView = new ISP.View({
        login : function() {

            var otpNumber = $('#otpNumber').val();

            console.log(otpNumber);

            if (otpNumber == undefined || otpNumber.length == 0) {
                alertErrorMessage(L[230007]);
                return;
            }

            var action = "/authentication/otp/loginProcess";
            props.elements.$formlogin.attr('action', action);
            props.elements.$formlogin.attr('method', 'post');
            props.elements.$formlogin.submit();
            
            /*
            var params = props.elements.$formlogin.serialize();
            console.log(params);

            $.ajax({
                url : '/authentication/otp/loginProcess',
                type : 'POST',
                dataType : 'json',
                data : params,
                success : function(data) {
                    console.log(data);
                    var resultCode = data.resultCode
                    var resultMessage = data.resultMessage
                    
                    if (resultCode == "000000") {
                        // 토큰 값을 returnURL로 보내주기
                        sendToken(resultCode, resultMessage, data.secureToken,
                                data.secureSessionId, data.returnUrl);
                    } else if (resultCode == "500001") {
                        if(confirm(resultMessage) == true) {
                            var form = $('<form action="/duplicationLoginProcess" method="post"></form>');
                            $('body').append(form);
                            form.submit();
                            return;
                        } else {
                            return;
                        }
                    } else {
                        alertErrorMessage(resultMessage);
                        return;
                    }
                },
                error : function(xhr, msg, e) {
                }
            });
            */

        },
        appendEvents : function() {
            var self = this;
            var elements = props.elements;

            elements.$otpNumber.keydown(function(e) {
                if ( e.keyCode !== 13 ) return;
                self.login();
                return;
            });
            
            elements.$btnLogin.click(function() {
                self.login();
            });
            
            elements.$linkTemporaryOtpNumber.click(function() {
            	var agentId = $('#agentId').val();
            	var url = "/authentication/otp/temporaryOtpNumber.html?&agentId=" + agentId;
            	$(location).attr('href',url);
            });
        },
        init : function() {
            this.appendEvents();

            $('input[name=otpNumber]').focus();
        }
    });
    LoginView.init();

});