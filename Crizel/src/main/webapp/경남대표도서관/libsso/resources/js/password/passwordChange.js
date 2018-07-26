$(function() {

    function loginPage(agentId) {
        var form = $('<form action="/login.html" method="post">'
                + '<input type="hidden" name="agentId" value="' + agentId
                + '" />' + '</form>');
        $('body').append(form);
        form.submit();
    }

    var props = {
        constants : {},
        elements : {
            $formPasswordChange : $('#form-passwordChange'),
            $btnSave : $('#btn-save')
        }
    };

    var ChangePasswordView = new ISP.View({
        changePassword : function() {

            var pw = $('#pw').val();
            var newPw = $('#newPw').val();
            var rePw = $('#rePw').val();

            resetErrorMessage();

            if (pw == undefined || pw.length == 0) {
                alertErrorMessage(L[320007]);
                return;
            }
            if (newPw == undefined || newPw.length == 0) {
                alertErrorMessage(L[320008]);
                return;
            }
            if (rePw == undefined || rePw.length == 0) {
                alertErrorMessage(L[320009]);
                return;
            }

            var params = props.elements.$formPasswordChange.serialize();
            console.log(params);

            $.ajax({
                url : '/password/passwordChangeProcess',
                type : 'POST',
                dataType : 'json',
                data : params,
                success : function(data) {
                    console.log(data);
                    var resultCode = data.resultCode
                    var resultMessage = data.resultMessage

                    if (resultCode == "320000") {
                        var agentId = $('#agentId').val();
                        loginPage(agentId);
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
        appendEvents : function() {
            var self = this;
            var elements = props.elements;

            elements.$btnSave.click(function() {
                self.changePassword();
            });
            
            $("input[name=rePw]").keypress(function(event){
                if(event.keyCode == 13){
                    self.changePassword();
                }
            });
        },
        init : function() {
            this.appendEvents();

            $('input[name=pw]').focus();
        }
    });
    ChangePasswordView.init();

});