$(function() {
 // 개발팀 서버 공개키
    var pubkey1 = 'MIGIAoGAeBZCbkJVAE1oaUiBOC/ToeE5dCpK64E9jYS8+8+wQvXbSOdPkcJTuUxs/ypW9vaqkabE37c9RVRcbXIcqoQaQ1zvv946rgpF4cV57MfbA+gudGSK+bSkTgx9bAvY3qVrkbWWS1l1u2xYwBPsYl4SltsOROpq1t/hdCQbYKLGr+MCAwEAAQA=';
    // 지원팀 서버 공개키
    var pubkey2 = 'MIGIAoGAcLXicXHD1eDSIL3D3JLb4xsQ7ooPlbKfVQ8Dg2kyWw4sGkAxPXex29fpc/RSjzRwRmCWTMZwT+r6ArMb4YgIBTzBmy/lBYWsFozwJ/meTQojBNPM+bAdp2aYSwoxsmZ8B1PyAnPDtWGzckB01YB3ZeKGmUpvKdqSYRrLuti4Y50CAwEAAQ==';

    var encrypt_header = "encrypt_";
    var double_header = "double_";

    var keyname1 = 'Sample1';
    var keyname2 = 'Sample2';
    var keyname3 = 'Sample3';
    var keyname4 = 'Sample4';

    function issacweb_escape(msg){
        var i;
        var ch;
        var encMsg = '';
        var tmp_msg = String(msg);

        for (i = 0; i < tmp_msg.length; i++) {
            ch = tmp_msg.charAt(i);

            if (ch == ' ')
                encMsg += '%20';
            else if (ch == '%')
                encMsg += '%25';
            else if (ch == '&')
                encMsg += '%26';
            else if (ch == '+')
                encMsg += '%2B';
            else if (ch == '=')
                encMsg += '%3D';
            else if (ch == '?')
                encMsg += '%3F';
            else if (ch == '|')
                encMsg += '%7C';
            else
                encMsg += ch;
        }
        return encMsg;
    }
    
    var props = {
        constants : {},
        elements:{
            $pw : $('#pw'),
            $formlogin : $('#form-login'),
            $btnLogin : $('#btn-login'),
            $linkfindPassowrd : $('#link-find-password')
        }
    };
    
    
    var LoginView = new ISP.View({
    	login : function() {
           
    		var id = $('#id').val();
            var pw = $('#pw').val();
            
            if (id == undefined || id.length == 0) {
            	alertErrorMessage(L[210000]);
                return;
            }
            if (pw == undefined || pw.length == 0) {
            	alertErrorMessage(L[210001]);
                return;
            }
            
            var message = issacweb_escape('id') + "=" + issacweb_escape(id);
            message += "&" + issacweb_escape('pw') + "=" + issacweb_escape(pw);
            
            // public key 얻기
            $.ajax({
                url : '/openapi/authentication/publickey/get',
                type : 'GET',
                dataType : 'json',
                success : function(data) {
                	console.log(data);
                    var resultCode = data.resultCode
                    var resultMessage = data.resultMessage
                    
                    if (resultCode == "000000") {
                    	
                    	var publicKey = data.resultData.publicKey;
                    	
                        try{
                        	var reqHybridEnc = webcrypto.e2e.hybridEncrypt(keyname1, message, 
                                    'UTF-8', 'SEED', publicKey, 'RSAES-OAEP', 'RSA-SHA1');
                            
                            reqHybridEnc.onerror = function(errMsg) { alert(errMsg); };
                            reqHybridEnc.oncomplete = function(result) {
                                
                                if(result === "") {
                                	alertErrorMessage("issacweb_data is null");
                                    return;
                                }
                                
                                var agentId = $('#agentId').val();
                                var userId = $('#userId').val();
                                var issacwebData = result;
                                
                                var action = "/authentication/issacweb/loginProcess";
                                var form = $('<form action=' + action + ' method="post">'
                                    + '<input type="hidden" name="agentId" value="' + agentId + '" />'
                                    + '<input type="hidden" name="userId" value="' + userId + '" />'
                                    + '<input type="hidden" name="issacwebData" value="' + issacwebData + '" />'
                                    + '</form>');
                                $('body').append(form);
                                form.submit();
                            };
                        }catch(e){
                            if (e.message) {
                                alert(e.message);
                            } else {
                                alert(e);
                            }
                        }
                        
                    } else {
                    	alertErrorMessage(resultMessage);
                        return;
                    }
                }
            });
            
        },
        appendEvents : function() {
            var self = this;
            var elements = props.elements;

            elements.$pw.keydown(function(e) {
                if ( e.keyCode !== 13 ) return;
                self.login();
            });
            
            elements.$btnLogin.click(function() {
                self.login();
            });
            
            elements.$linkfindPassowrd.click(function() {
            	var agentId = $('#agentId').val();
            	var url = "/password/userId.html?&agentId=" + agentId;
            	$(location).attr('href',url);
            });
        },
        init: function () {
            this.appendEvents();
            
            $('input[name=id]').focus();
        }
    });
    LoginView.init();
});