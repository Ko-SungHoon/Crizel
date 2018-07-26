$(function() {
    
    var props = {
        constants : {},
        elements:{
            $formlogin : $('#form-login'),
            $btnLogin : $('#btn-login'),
            $btnRegist : $('#btn-regist'),
            $challenge : $('#challenge'),
            $response : $('#response')
        }
    };

    var LoginView = new ISP.View({
        login : function() {
            //var pageform = document.pkiform;
            
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
                    
                    props.elements.$formlogin.attr('action', '/authentication/pki/loginProcess');
                    props.elements.$formlogin.attr('method', 'post');
                    props.elements.$formlogin.submit();
                };
            };
            
        },
        appendEvents : function() {
            var self = this;
            var elements = props.elements;
            
            elements.$btnLogin.click(function() {
                self.login();
            });
            elements.$btnRegist.click(function() {
                var agentId = $('#agentId').val();
                var pkiRegisterPageUrl = $('#pkiRegisterPageUrl').val();
                //location.href = "/authentication/pki/pkiRegister.html?agentId=" + agentId;
                location.href = pkiRegisterPageUrl;
            });
        },
        init: function () {
            this.appendEvents();
        }
    });
    
    
    
    
    /*function win_Load() {
        document.pkiform.action = "/authentication/pki/loginProcess";
    }*/
    
    LoginView.init();
});