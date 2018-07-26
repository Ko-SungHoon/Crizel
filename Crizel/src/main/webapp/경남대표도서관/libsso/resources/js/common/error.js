$(function() {

    var props = {
        constants : {},
        elements : {
            $formHome : $('#form-home'),
            $btnHome : $('#btn-home')
        }
    };

    var ErrorView = new ISP.View({
        home : function() {

            var agentId = $('#agentId').val();
            location.href = "/login.html?agentId=" + agentId;

        },
        appendEvents : function() {
            var self = this;
            var elements = props.elements;

            elements.$btnHome.click(function() {
                self.home();
            });
        },
        init : function() {
            this.appendEvents();
        }
    });
    ErrorView.init();

});