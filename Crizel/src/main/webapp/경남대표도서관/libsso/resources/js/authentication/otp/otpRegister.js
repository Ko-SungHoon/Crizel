$(function() {

    // 토큰 정보등을 가지고 returnUrl로 forward 한다.
    function sendToken(resultCode, resultMessage, secureToken, secureSessionId,
            returnUrl) {
        console.log("returnUrl : " + returnUrl);
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
            $formRegister : $('#form-register'),
            $btnGenerateServerKey : $('#btn-generateServerKey'),
            $btnTest : $('#btn-test'),
            $btnVerifyOtpNumber : $('#btn-verifyOtpNumber'),
            $testOtpNumber : $('#testOtpNumber'),
            $clientKey : $('#clientKey'),
            $btnRegist : $('#btn-regist')
        }
    };

    var RegisterView = new ISP.View({
        generateServerKey : function() {

            var clientKey = $('#clientKey').val();
            var userId = $('#userId').val();

            console.log(clientKey);

            resetErrorMessage();
/*
            if (clientKey == undefined || clientKey.length == 0) {
                alertErrorMessage(L[230002]);
                return;
            }
*/
            $.ajax({
                url : '/authentication/otp/generateServerKey',
                type : 'POST',
                dataType : 'json',
                data : {
                    "userId" : userId
                },
                success : function(data) {
                    console.log(data);
                    var resultCode = data.resultCode
                    var resultMessage = data.resultMessage
                    var serverKey = data.serverKey

                    if (resultCode == "000000") {
                        // 일련번호 설정
                        $('#serverKey').val(serverKey);
                        //$('#clientKey').attr("disabled","disabled");
                        $('#divOtpNumberTest').show();
                        $('#otp_step').html(L['OTP등록_STEP2']);
                        $('#div_btn-generateServerKey').hide();
                        $('#div_btn-test').show();
                        return;
                    } else {
                        alertErrorMessage(resultMessage);
                        return;
                    }
                },
                error:function(xhr, msg, e){
                }
            });

        },
        test : function() {

            var clientKey = $('#clientKey').val();
            var serverKey = $('#serverKey').val();

            resetErrorMessage();

            if (clientKey == undefined || clientKey.length == 0) {
                alertErrorMessage(L[230002]);
                return;
            }
            if (serverKey == undefined || serverKey.length == 0) {
                alertErrorMessage(L[230003]);
                return;
            }

            $('#divOtpNumberTest').show();

        },
        verifyOtpNumber : function() {

            var clientKey = $('#clientKey').val();
            var serverKey = $('#serverKey').val();
            var testOtpNumber = $('#testOtpNumber').val();

            console.log(clientKey);
            console.log(serverKey);
            console.log(testOtpNumber);

            resetErrorMessage();

            if (clientKey == undefined || clientKey.length == 0) {
                alertErrorMessage(L[230002]);
                return;
            }
            if (serverKey == undefined || serverKey.length == 0) {
                alertErrorMessage(L[230003]);
                return;
            }
            if (testOtpNumber == undefined || testOtpNumber.length == 0) {
                alertErrorMessage(L[230007]);
                return;
            }

            $.ajax({
                url : '/authentication/otp/verifyOtpNumber',
                type : 'POST',
                dataType : 'json',
                data : {
                    "clientKey" : clientKey,
                    "serverKey" : serverKey,
                    "otpNumber" : testOtpNumber
                },
                success : function(data) {
                    console.log(data);
                    var resultCode = data.resultCode
                    var resultMessage = data.resultMessage

                    if (resultCode == "230006") {
                        //alertSuccessMessage(resultMessage);
                        $('#divOtpNumberTest').hide();
                        $('#testOtpNumber').val("");
                        $('#testFlag').val("true");
                        $('#clientKey').attr('disabled', 'disabled');
                        $('#otp_step').html(L['OTP등록_STEP3']);
                        $('#div_btn-test').hide();
                        $('#div_btn-regist').show();
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
        regist : function() {
            
            var clientKey = $('#clientKey').val();
            var testFlag = $('#testFlag').val();
            console.log("testFlag : " + testFlag);

            resetErrorMessage();
            
            if (clientKey == undefined || clientKey.length == 0) {
                alertErrorMessage(L[230002]);
                return;
            }
            if (testFlag != "true") {
                alertErrorMessage(L[230008]);
                return;
            }

            var userId = $('#userId').val();
            var agentId = $('#agentId').val();
            var clientKey = $('#clientKey').val();
            var serverKey = $('#serverKey').val();

            $.ajax({
                url : '/authentication/otp/registOtp',
                type : 'POST',
                dataType : 'json',
                data : {
                    "clientKey" : clientKey,
                    "serverKey" : serverKey,
                    "userId" : userId,
                    "agentId" : agentId
                },
                success : function(data) {
                    console.log(data);
                    var resultCode = data.resultCode
                    var resultMessage = data.resultMessage

                    if (resultCode == "230010") {
                        // returnURL로 이동하기
                        //alert(resultMessage);
                        sendToken(resultCode, resultMessage, '', '',
                                data.returnUrl);
                    } else {
                        alertErrorMessage(resultMessage);
                        return;
                    }
                },
                error : function(xhr, msg, e) {
                }
            });

        },
        appendEvents : function() {
            var self = this;
            var elements = props.elements;

            elements.$btnRegist.click(function() {
                self.regist();
            });
            
            elements.$clientKey.keypress(function(e) {
                if ( e.keyCode !== 13 ) return;
                self.generateServerKey();
            });

            elements.$btnGenerateServerKey.click(function() {
                self.generateServerKey();
            });

            elements.$btnTest.click(function() {
                self.test();
            });
            
            elements.$testOtpNumber.keydown(function(e) {
                if ( e.keyCode !== 13 ) return;
                self.verifyOtpNumber();
            });

            elements.$btnVerifyOtpNumber.click(function() {
                self.verifyOtpNumber();
            });
        },
        init : function() {
            this.appendEvents();

            $('#testFlag').val(false);
            //$('#divOtpNumberTest').hide();
            //$('#div_btn-test').hide();
            $('#div_btn-regist').hide();
            
            RegisterView.generateServerKey();
        }
    });
    RegisterView.init();

});