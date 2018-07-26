$(function() {

    var props = {
        constants : {},
        elements : {
            $id : $('input[name=id]'),
            $pw : $('input[name=pw]'),
            $formlogin : $('#login_form'),
            $btnLogin : $('#btn-login'),
            $saveIdChk : $('#saveIdChk'),
            $linkfindPassowrd : $('#link-find-password')
        }
    };

    var LoginView = new ISP.View({
        login : function() {

            var id = props.elements.$id.val();
            var pw = props.elements.$pw.val();
            var agentId = $('#agentId').val();

            if (id == undefined || id.length == 0) {
                alert(L[210000]);
                props.elements.$id.focus();
                return;
            }
            if (pw == undefined || pw.length == 0) {
                alert(L[210001]);
                props.elements.$pw.focus();
                return;
            }

            if (props.elements.$saveIdChk.is(":checked")) {
                $.cookie("saveId", id, { expires : 365, path : '/'});
            } else {
                $.cookie("saveId", id, { expires : -1, path : '/'});
            }

            var action = "/authentication/idpw/loginProcess";
            props.elements.$formlogin.attr('action', action);
            props.elements.$formlogin.attr('method', 'post');
            props.elements.$formlogin.submit();

        },
        checkSaveId : function () {
            var saveId = $.cookie("saveId") ? $.cookie("saveId"):'';
            if (saveId != "") {
                props.elements.$id.val(saveId);
                props.elements.$saveIdChk.attr("checked", true);
            }

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

            elements.$linkfindPassowrd.click(function() {
                var agentId = $('#agentId').val();
                var url = "/password/userId.html?&agentId=" + agentId;
                $(location).attr('href',url);
            });
        },
        init : function() {
            this.appendEvents();
            this.checkSaveId();
        }
    });
    LoginView.init();
});