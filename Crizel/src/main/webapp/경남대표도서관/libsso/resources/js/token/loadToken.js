$(function() {
    var props = {
        constants : {},
        elements:{
            $formSend : $('#form-send'),
            $userAgent : $('#userAgent'),
            $secureToken : $('#secureToken'),
            $secureSessionId : $('#secureSessionId')
        }
    };
    
    var check = function(state, token, sessionId) {
        if (state === '2') { //LS Login
            if (token) {
                props.elements.$secureToken.val(token);
            }
            
            if (sessionId) {
                props.elements.$secureSessionId.val(sessionId);
            }
        }
        
        props.elements.$formSend.attr('action', '/token/check/csmode');
        props.elements.$formSend.submit();
    }
    
    
    var userAgent = props.elements.$userAgent.val();
    
    if (userAgent.indexOf("Android") != -1) {
        Android.getToken();
    } else if (userAgent.indexOf("iPhone") != -1 || userAgent.indexOf("iPad") != -1) {
        
    } else {
        setupWebCryptoE2E(function() {
            
            var keyArray = ["isignplus_cs_login_state", "isignplus_cs_secure_token", "isignplus_cs_secure_session_id"];
            var req = webcrypto.addon.getValueForPredefinedKeyList(keyArray);
            req.onerror = function(errMsg, resultSet) {
                console.log("error");
                check(resultSet[keyArray[0]], resultSet[keyArray[1]], resultSet[keyArray[2]] );
            };
            
            req.oncomplete = function(resultSet) {
                console.log("success");
                check(resultSet[keyArray[0]], resultSet[keyArray[1]], resultSet[keyArray[2]] );
            };
        });
    }
});

function androidTokenCheck(token, sessionId) {
    if (token) {
        document.getElementById("secureToken").value = token;
    }
    
    if (sessionId) {
        document.getElementById("secureSessionId").value = sessionId;
    }

    document.getElementById("form-send").action = '/token/check/csmode';
    document.getElementById("form-send").submit();
}

