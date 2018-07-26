$(function() {
    var props = {
        constants : {},
        elements:{
            $formSend : $('#form-send'),
            $secureToken : $('#secureToken'),
            $secureSessionId : $('#secureSessionId'),
            $csMode : $('#csMode'),
            $userAgent : $('#userAgent')
        }
    };

    var csMode = props.elements.$csMode.val();
    var userAgent = props.elements.$userAgent.val();
    var secureToken = props.elements.$secureToken.val();
    var secureSessionId = props.elements.$secureSessionId.val();
    
    if (csMode === "true") {
        if (userAgent.indexOf("isignplus_hybrid") != -1) {
            if (userAgent.indexOf("Android") != -1) {
                Android.setLoginData(secureToken, secureSessionId);
            } else if (userAgent.indexOf("iPhone") != -1 || userAgent.indexOf("iPad") != -1) {
                var param = "ios:setLoginData:";
                param = param + "secureToken=" + encodeURIComponent(secureToken);
                param = param + "&" + "secureSessionId=" + encodeURIComponent(secureSessionId);
                //document.location = param;
                document.location = param;
            }
            $('#form-agentProc').submit();
        } else if (userAgent.indexOf("Android") == -1 && userAgent.indexOf("iPhone") == -1 && userAgent.indexOf("iPad") == -1) {
            setupWebCryptoE2E(function() {
                var valueObject = {};
                valueObject['isignplus_cs_login_state'] = '2';
                valueObject['isignplus_cs_secure_token'] = secureToken;
                valueObject['isignplus_cs_secure_session_id'] = secureSessionId;
                
                var req = webcrypto.addon.setValueForPredefinedKeyList(valueObject);
                req.onerror = function(errMsg, resultSet) {
                    var message = '미리 정의된 값 설정 실패 : ' + errMsg + '\n\n';
                    alert(message);
                };
                req.onsuccess = function() {
                    console.log("saved");
                    $('#form-agentProc').submit();
                };
            });
        } else {
            $('#form-agentProc').submit();
        }
    } else {
        $('#form-agentProc').submit();
    }
});