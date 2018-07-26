$(function() {
    
	function moveNextPage(agentId, userId, question, answer) {
        var form = $('<form action="/password/passwordSet.html" method="post">'
                + '<input type="hidden" name="agentId" value="' + agentId + '" />'
                + '<input type="hidden" name="userId" value="' + userId + '" />'
                + '<input type="hidden" name="question" value="' + question + '" />'
                + '<input type="hidden" name="answer" value="' + answer + '" />'
                + '</form>');
        $('body').append(form);
        form.submit();
    }
	
	function loginPage(agentId) {
        var form = $('<form action="/login.html" method="post">'
                + '<input type="hidden" name="agentId" value="' + agentId
                + '" />' + '</form>');
        $('body').append(form);
        form.submit();
    }
	
    $('select').select2({ minimumResultsForSearch : Infinity });
    
    var props = {
        constants : {},
        elements : {
            $answer: $('#answer'),
            $btnContinue : $('#btn-continue'),
            $btnCancel : $('#btn-cancel')
        }
    };

    var PasswordQAView = new ISP.View({
    	checkPasswordQA : function() {

            resetErrorMessage();

            var userId = $('#userId').val();
            var agentId = $('#agentId').val();
            var question = $("#question option:selected").val();
            var answer = $('#answer').val();

            if (question == undefined || question.length == 0) {
                alertErrorMessage(L[320021]);
                return;
            }
            if (answer == undefined || answer.length == 0) {
                alertErrorMessage(L[320020]);
                return;
            }
            
            $.ajax({
                url : '/password/checkPasswordQA',
                type : 'POST',
                dataType : 'json',
                data:{
                	userId : userId,
                	agentId : agentId,
                	question : question,
                	answer : answer
                },
                success : function(data) {
                    console.log(data);
                    var resultCode = data.resultCode
                    var resultMessage = data.resultMessage

                    if (resultCode == "000000") {
                        var agentId = $('#agentId').val();
                        
                        moveNextPage(agentId, userId, question, answer);
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
            
            elements.$answer.keypress(function(e) {
                if ( e.keyCode !== 13 ) return;
                self.checkPasswordQA();
            });

            elements.$btnContinue.click(function() {
                self.checkPasswordQA();
            });

            elements.$btnCancel.click(function() {
            	var agentId = $('#agentId').val();
            	loginPage(agentId);
            });
        },
        init : function() {
            this.appendEvents();
        }
    });
    
    PasswordQAView.init();
});