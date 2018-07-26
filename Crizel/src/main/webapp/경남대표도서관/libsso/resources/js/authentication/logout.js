$(function() {
    var props = {
            constants : {},
            elements:{
                $totalLogout : $('#totalLogout'),
                $csMode : $('#csMode'),
                $userAgent : $('#userAgent')
            }
        };
    
    function deleteSubkey(callback) {
        var req = webcrypto.addon.deleteValueForPredefinedKey('isignplus_cs');
        req.onerror = function(errMsg) {
            // 없는 키를 삭제하려고 해도 오류는 아니다.
            if (callback) {
                callback();
            }
        };
        req.onsuccess = function() {
            if (callback) {
                callback();
            }
        };
    }
    function formSubmit() {
        var totalLogout = props.elements.$totalLogout.val();
        if (totalLogout === "true") {
            var delayTime = $('#delayTime').val();
            setTimeout(function(){
                $('#form-index').submit();
            }, delayTime);
        } else {
            $('#form-index').submit();
        }
    }
    
    var csMode = props.elements.$csMode.val();
    var userAgent = props.elements.$userAgent.val();

    if (csMode === "true") {
        if (userAgent.indexOf("isignplus_hybrid") != -1) {
            if (userAgent.indexOf("Android") != -1) {
                Android.hybridLogout();
                formSubmit();
            } else if (userAgent.indexOf("iPhone") != -1 || userAgent.indexOf("iPad") != -1) {
                var param = "ios:hybridLogout:";
                document.location = param;
            } 
        }else if (userAgent.indexOf("Android") == -1 && userAgent.indexOf("iPhone") == -1 && userAgent.indexOf("iPad") == -1){
            setupWebCryptoE2E(function() {
                deleteSubkey(function() {
                    formSubmit();
                });
            });
        } else {
            formSubmit();
        }
    } else {
        formSubmit();
    }

});