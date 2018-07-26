$(function() {     
    var props = {
        constants : {},
        elements:{
            $formlogin : $('#form-login')
        }
    };

    var LoginView = new ISP.View({
        login : function() {
            
            var action = "/authentication/kerberos/loginProcess";
            props.elements.$formlogin.attr('action', action);
            props.elements.$formlogin.attr('method', 'post');
            props.elements.$formlogin.submit();
        },
        appendEvents : function() {
            var self = this;
            var elements = props.elements;
            self.login();
        },
        init: function () {
            this.appendEvents();
        }
    });
    LoginView.init();
});