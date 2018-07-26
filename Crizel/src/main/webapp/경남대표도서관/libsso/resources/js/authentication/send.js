$(function() {
    
    function passwordChange(agentId, userId) {
        if (externalPasswordChangePageUrl != null 
                && externalPasswordChangePageUrl != "") {
            window.location.replace(externalPasswordChangePageUrl);
        } else {
            var form = $('<form action="/password/passwordChange.html" method="post">' +
                    '<input type="hidden" name="agentId" value="' + agentId + '" />' +
                    '<input type="hidden" name="userId" value="' + userId + '" />' +
                    '</form>');
            $('body').append(form);
            form.submit();
        }
        
    }
    
    var resultCode = $('#resultCode').val();
    var resultMessage = $('#resultMessage').val();
    var id = $('#userId').val();
    var agentId = $('#agentId').val();
    var externalPasswordChangePageUrl = $('#externalPasswordChangePageUrl').val();
    var returnUrl = $('#returnUrl').val();
    
    console.log(resultCode);
    
    if (resultCode != null && resultCode != "") {
        
        if (resultCode == "000000") {
            $('#form-send').submit();
        } else if (resultCode == "210010") {
            if(confirm(resultMessage) == true) {
                passwordChange(agentId, id);
                //window.history.back();
            } else {
                $('#resultCode').val("000000");
                $('#form-send').submit();
            }
        } else if (resultCode == "210002" || resultCode == "210011") {
            alert(resultMessage);
            passwordChange(agentId, id);
        } else if (resultCode == "270000") {
            alert(resultMessage);
        } else if (resultCode == "500001") {
            if(confirm(resultMessage) == true) {
                var action = "/duplicationLoginProcess";
                $('#form-send').attr('action', action);
                $('#form-send').submit();
                return;
            } else {
                var action = "/login.html?agentId=" + agentId;
                $('#form-send').attr('action', action);
                $('#form-send').submit();
                return;
            }
        } else if (resultCode == "200005") {    
            // 첫번째 인증 받지 않은 경우
        	alert(resultMessage);
        	var action = "/login.html?agentId=" + agentId;
        	$('#form-send').attr('action', action);
            $('#form-send').submit();
        } else {
            alert(resultMessage);
            //window.history.back();
            var action = "/login.html?agentId=" + agentId;
            if(returnUrl != '') {
            	action = returnUrl;
            }
            
            $('#form-send').attr('action', action);
            $('#form-send').submit();
            return;
        }
    }
});