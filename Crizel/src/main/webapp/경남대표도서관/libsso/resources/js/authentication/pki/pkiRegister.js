$(function() {
    
    //  토큰 정보등을 가지고 returnUrl로 forward 한다.
    function sendToken(resultCode, resultMessage, secureToken, secureSessionId, returnUrl) {
        
        var form = $('<form action="' + returnUrl + '" method="post">' +
          '<input type="hidden" name="resultCode" value="' + resultCode + '" />' +
          '<input type="hidden" name="resultMessage" value="' + resultMessage + '" />' +
          '<input type="hidden" name="secureToken" value="' + secureToken + '" />' +
          '<input type="hidden" name="secureSessionId" value="' + secureSessionId + '" />' +
          '</form>');
        
        $('body').append(form);
        form.submit();
    }
    
    var props = {
        constants : {},
        elements:{
            $formlogin : $('#form-pki-register'),
            $btnLogin : $('#btn-login'),
            $pw : $('#pw'),
            $challenge : $('#challenge'),
            $response : $('#response')
        }
    };

    var LoginView = new ISP.View({
        login : function() {
            //var pageform = document.pkiform;
            
            var id = $('#id').val();
            var pw = $('#pw').val();

            resetErrorMessage();

            if (id == undefined || id.length == 0) {
                alertErrorMessage(L[210000]);
                return;
            }
            if (pw == undefined || pw.length == 0) {
                alertErrorMessage(L[210001]);
                return;
            }
            
            var displayMediaTypes = ['HDD', 'USB'];
            if (webcrypto.pka.ui.setStorageType(displayMediaTypes) === false) {
                alert('저장매체 설정 실패! 기본 설정값으로 동작합니다.');
            }

            // 인증서 선택 다이얼로그 오픈
            var caTypes = ['NPKI', 'EPKI', 'GPKI'];
            var request = webcrypto.pka.ui.openCertSelectionBox(caTypes);
            request.onsuccess = function() {
                var challenge = props.elements.$challenge.val();
                var req = webcrypto.pka.makeResponse(challenge);
                
                req.onerror = function(errMsg) {
                    alert('응답값 생성 실패 : ' + errMsg);
                    webcrypto.pka.finalize();
                };
                req.oncomplete = function(result) {
                    props.elements.$response.val(result);
                    webcrypto.pka.finalize();
                    //pageform.submit();
                    var params = props.elements.$formlogin.serialize();
                    console.log(params);
                    $.ajax({
                        url:'/authentication/pki/registerProcess',
                        type:'POST',
                        dataType:'json',
                        data: params,
                        success:function (data) {
                            console.log(data);
                            var resultCode = data.resultCode
                            var resultMessage = data.resultMessage
                            
                            if(resultCode == "000000") {
                                // 토큰 값을 returnURL로 보내주기
                                sendToken(resultCode, resultMessage, data.secureToken, data.secureSessionId, data.returnUrl);
                            } else {
                                alertErrorMessage(resultMessage);
                                return;
                            }
                        },
                        error:function(xhr, msg, e){
                        }
                    });
                };
            };
            
        },
        appendEvents : function() {
            var self = this;
            var elements = props.elements;

            elements.$pw.keypress(function(e) {
                if ( e.keyCode !== 13 ) return;
                self.login();
            });
            
            elements.$btnLogin.click(function() {
                self.login();
            });
        },
        init: function () {
            this.appendEvents();
        }
    });
    
    
    
    
    LoginView.init();
});