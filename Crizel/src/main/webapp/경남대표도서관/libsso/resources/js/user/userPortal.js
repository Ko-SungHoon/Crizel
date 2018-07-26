$(function() {
    function commonAjaxSuccessCallback(message) {
        ISP.notify('success', message);
        setTimeout(function() {
            var url = location.href, idx = -1;
            if ( (idx = url.indexOf('#')) == -1 ) location.reload();
            else location.href = url.substr(0, idx);
        }, 1000);
    }
    
    $('select').select2({ minimumResultsForSearch : Infinity });
    
    var AuthTypeView = new ISP.View({
        model:new ISP.Model({}),
        elements : {
            $btnChangePassword : $('#btn-change-password'),
            $btnSavePassword : $('#btn-save-password'),
            $btnInsertPasswordQA : $('#btn-insert-password-qa'),
            $btnUpdatePasswordQA : $('#btn-update-password-qa'),
            $btnSavePasswordQA : $('#btn-save-password-qa'),
            $btnResetOtpTemporaryNumberSendEmail : $('#btn-reset-temp-otp-send'),
            $btnOtpTemporaryNumberSendEmail : $('#btn-temp-otp-send'),
            $btnOtpTemporaryNumber : $('#btn-temp-otp'),
            $btnResetOtpTemporaryNumber : $('#btn-reset-temp-otp'),
            $btnChangeOtp : $('#btn-change-otp'),
            $btnInsertPki : $('#btn-insert-pki'),
            $btnUpdatePki : $('#btn-update-pki'),
            $linkLogout : $('#link-logout')
        },
        openChangePasswordModal : function() {
            
            $('#pw').val('');
            $('#newPw').val('');
            $('#rePw').val('');
            
            $('#change-password-modal').modal({backdrop: 'static'});
            $('#change-password-modal').modal('show');
            
        },
        openChangePasswordQAModal : function(mode) {

        	$('#qaPw').val('');
            $("#question option:eq(0)").attr("selected", "selected");
            $('#answer').val('');
            $('#qaMode').val(mode);

            if(mode == 'update') {
            	$('#change-password-qa-modal-title').html(L['사용자포털_비밀번호찾기_타이틀_변경']);
            } else {
            	$('#change-password-qa-modal-title').html(L['사용자포털_비밀번호찾기_타이틀_등록']);
            }
            
            $('#change-password-qa-modal').modal({backdrop: 'static'});
            $('#change-password-qa-modal').modal('show');
            
        },
        openTempOtpModal : function(tempOtpNumber, enableEmailSend) {
            $('#temp_otp').html(tempOtpNumber);

        	var email = $('#email').val();
            
        	if(enableEmailSend && email) {
        		$('#btn-temp-otp-send').show();
            } else {
            	$('#btn-temp-otp-send').hide();
            }
            
            $('#temp-otp-modal').modal({backdrop: 'static'});
            $('#temp-otp-modal').modal('show');
        },
        openResetTempOtpModal : function(tempOtpNumber, enableEmailSend, code, message) {
            $('#reset_temp_otp').html(tempOtpNumber);
            $('#count-temp-otp').html("5");
            $('#btn-temp-otp').removeAttr("disabled");
            
            var email = $('#email').val();
            
            if(enableEmailSend && email) {
            	$('#btn-reset-temp-otp-send').show();
            } else {
            	$('#btn-reset-temp-otp-send').hide();
            }
            
            $('#reset-temp-otp-modal').modal({backdrop: 'static'});
            $('#reset-temp-otp-modal').modal('show');
        },
        sendEmail : function() {
        	var sid = $('#sid').val();
        	var email = $('#email').val();
        	
            $.ajax({
                url:'/user/portal/sendTemporaryOtpNumberEmail',
                method:'POST',
                data:{
                	sid : sid,
                	email : email
                }
            }).success(function(data){
                var resultCode = data.resultCode
                var resultMessage = data.resultMessage

                if (resultCode == "230018") {
                	commonAjaxSuccessCallback(resultMessage);
                } else if (resultCode == "000004") {
                	var agentId = $('#agentId').val();
                	location.href="/login.html?agentId=" + agentId;
            	} else {
            		ISP.notify('error', resultMessage);
            	}
            });
        },
        changePassword : function() {

            var userId = $('#userId').val();
            var pw = $('#pw').val();
            var newPw = $('#newPw').val();
            var rePw = $('#rePw').val();

            if (pw == undefined || pw.length == 0) {
                ISP.notify('error', L[320007]);
                return;
            }
            if (newPw == undefined || newPw.length == 0) {
                ISP.notify('error', L[320008]);
                return;
            }
            if (rePw == undefined || rePw.length == 0) {
                ISP.notify('error', L[320009]);
                return;
            }

            $.ajax({
                url : '/password/passwordChangeProcess',
                type : 'POST',
                dataType : 'json',
                data:{
                	userId : userId,
                	pw : pw,
                	newPw : newPw,
                	rePw : rePw
                },
                success : function(data) {
                    console.log(data);
                    var resultCode = data.resultCode
                    var resultMessage = data.resultMessage

                    if (resultCode == "320000") {
                    	commonAjaxSuccessCallback(resultMessage);
                        return;
                    } else {
                        ISP.notify('error', resultMessage);
                        return;
                    }
                },
                error : function(xhr, msg, e) {
                }
            });

        },
        changePasswordQA : function() {

            var sid = $('#sid').val();
            var qaPw = $('#qaPw').val();
            var question = $("#question option:selected").val();
            var answer = $('#answer').val();
            var mode = $('#qaMode').val();

            if (qaPw == undefined || qaPw.length == 0) {
                ISP.notify('error', L[320019]);
                return;
            }
            if (answer == undefined || answer.length == 0) {
                ISP.notify('error', L[320020]);
                return;
            }

            $.ajax({
                url : '/user/portal/savePasswordQA',
                type : 'POST',
                dataType : 'json',
                data:{
                	sid : sid,
                	qaPw : qaPw,
                	question : question,
                	answer : answer
                },
                success : function(data) {
                    console.log(data);
                    var resultCode = data.resultCode
                    var resultMessage = data.resultMessage

                    if (resultCode == "000000") {
                    	if(mode == 'update') {
                        	commonAjaxSuccessCallback(L[320017]);
                    	} else {
                        	commonAjaxSuccessCallback(L[320016]);
                    	}
                        return;
                    } else if (resultCode == "000004") {
                    	var agentId = $('#agentId').val();
                    	location.href="/login.html?agentId=" + agentId;
                    } else {
                        ISP.notify('error', resultMessage);
                        return;
                    }
                },
                error : function(xhr, msg, e) {
                }
            });

        },
        appendEvents: function(){
            var self = this;
            
            self.elements.$btnResetOtpTemporaryNumber.click(function(){
            	
            	var tempOtpCount = $('#tempOtpCount').val();
                if(tempOtpCount != 0) {
                	if(confirm(L['사용자포털_임시OTP_재발급경고']) == false) {
                		return;
                	}
                }
                
            	var sid = $('#sid').val();
            	
                $.ajax({
                    url:'/user/portal/resetTempOtpNumber',
                    method:'POST',
                    data:{
                    	sid : sid
                    }
                }).success(function(data){
                    var resultCode = data.resultCode
                    var resultMessage = data.resultMessage
                    var tempOtpNumber = data.tempOtpNumber
                    var enableEmailSend = data.enableEmailSend

                    if (resultCode == "230017") {
                    	self.openResetTempOtpModal(tempOtpNumber, enableEmailSend, resultCode, resultMessage);
                    } else if (resultCode == "000004") {
                    	var agentId = $('#agentId').val();
                    	location.href="/login.html?agentId=" + agentId;
                	} else {
                		ISP.notify('error', resultMessage);
                	}
                });
            });
            
            self.elements.$btnOtpTemporaryNumber.click(function(){
                
            	var sid = $('#sid').val();
            	
                $.ajax({
                    url:'/user/portal/getTemporaryOtpNumberList',
                    method:'POST',
                    data:{
                    	sid : sid
                    }
                }).success(function(data){
                    var resultCode = data.resultCode
                    var resultMessage = data.resultMessage
                    var tempOtpNumber = data.tempOtpNumber
                    var enableEmailSend = data.enableEmailSend
                	
                    if (resultCode == "000000") {
                    	self.openTempOtpModal(tempOtpNumber, enableEmailSend);
                    } else if (resultCode == "000004") {
                    	var agentId = $('#agentId').val();
                    	location.href="/login.html?agentId=" + agentId;
                    } else {
                		ISP.notify('error', resultMessage);
                	}
                });
            });
            
            self.elements.$btnResetOtpTemporaryNumberSendEmail.click(function(){
            	self.sendEmail();
            });
            
            self.elements.$btnOtpTemporaryNumberSendEmail.click(function(){
            	self.sendEmail();
            });
            
            self.elements.$btnChangePassword.click(function(){
            	self.openChangePasswordModal();
            });
            
            self.elements.$btnSavePassword.click(function(){
            	self.changePassword();
            });
            
            $("input[name=rePw]").keypress(function(event){
                if(event.keyCode == 13){
                    self.changePassword();
                }
            });
            
            self.elements.$btnInsertPasswordQA.click(function(){
            	self.openChangePasswordQAModal('insert');
            });
            
            self.elements.$btnUpdatePasswordQA.click(function(){
            	if(confirm(L['사용자포털_비밀번호찾기_변경경고']) == false) {
            		return;
            	}
            	self.openChangePasswordQAModal('update');
            });
            
            self.elements.$btnSavePasswordQA.click(function(){
            	self.changePasswordQA();
            });
            
            $("input[name=answer]").keypress(function(event){
                if(event.keyCode == 13){
                    self.changePasswordQA();
                }
            });
            
            self.elements.$btnChangeOtp.click(function(){
            	
                var mode = $('#isDefaultOtp').val();
                if(mode == 0) {
                	if(confirm(L['사용자포털_OTP등록_변경경고']) == false) {
                		return;
                	}
                }
            	OtpRegisterView.openChangeOtpModal();
            });
            
            self.elements.$btnInsertPki.click(function(){
            	PkiRegisterView.openChangePkiModal('insert');
            });
            
            self.elements.$btnUpdatePki.click(function(){
            	if(confirm(L['사용자포털_PKI등록_변경경고']) == false) {
            		return;
            	}
            	PkiRegisterView.openChangePkiModal('update');
            });
            
            self.elements.$linkLogout.click(function(){
            	var agentId = $('#agentId').val();
            	location.href="/logout?agentId=" + agentId;
            });
            
        },
        init : function(){
            this.appendEvents();
            
            // 비밀번호 찾기 질문/답변 등록 여부 확인
            var passwordQA = $('#passwordQA').val();
            // 등록 안되어있으면 먼저 등록해야 함
            if(passwordQA == 'false') {
            	alert(L[320022]);
            	this.openChangePasswordQAModal('insert');
            	
            }
        }
    });
    
    var ServiceListView = new ISP.View({
        loadData : function() {
        	var sid = $('#sid').val();
            $.getJSON('/user/portal/service/list/' + sid).success($.proxy(this.renderTable, this));
        },
        renderTable : function(serviceList) {
            var targetEl = elements.$ServiceTable.find('tbody').empty();
            _.forEach(serviceList, function(v) {
                
            	var resourceAddBtn
            	
            	if(v.shortCutUrl) {
                    var resourceAddBtn = $('<button />').attr({
                        'class':'btn btn-xs btn-success',
                        'type':'button'
                    })
                    .append($('<i class="fa fa-share">'))
                    .append($('<span>').text(' ' + L['사용자포털_바로가기']));
                    
                    resourceAddBtn.click(function(e) {
                    	window.open(v.shortCutUrl, '_blank');
                    })
            	}
                
                var tr = $('<tr/>')
                    .append($('<td/>').append(v.name))
                    .append($('<td/>').append(v.dispAuthType))
                    .append($('<td/>').text(v.serviceType))
                    .append($('<td/>').css('text-align', 'center').append(resourceAddBtn));
                targetEl.append(tr);

            });
            
            
        },
        init : function() {
            this.loadData();
        }
    });
    
    
    var OtpRegisterView = new ISP.View({
        model:new ISP.Model({}),
        elements : {
            $btnVerifyOtpNumber : $('#btn-verify-otp'),
            $btnRegistOtp : $('#btn-regist-otp')
        },
        openChangeOtpModal : function() {
            
            var mode = $('#isDefaultOtp').val();
            
            $('#clientKey').val('');
            $('#serverKey').val('');
            $('#testOtpNumber').val('');
            
            if(mode == '1') {
            	$('#change-otp-modal-title').html(L['사용자포털_OTP등록_타이틀_등록']);
            } else {
            	$('#change-otp-modal-title').html(L['사용자포털_OTP등록_타이틀_변경']);
            }
            
            $('#change-otp-modal').modal({backdrop: 'static'});
            $('#change-otp-modal').modal('show');
            
            this.generateServerKey();
        },
        generateServerKey : function() {
            var userId = $('#userId').val();
            
            $.ajax({
                url : '/authentication/otp/generateServerKey',
                type : 'POST',
                dataType : 'json',
                data : {
                    "userId" : userId
                },
                success : function(data) {
                    //console.log(data);
                    var resultCode = data.resultCode
                    var resultMessage = data.resultMessage
                    var serverKey = data.serverKey

                    if (resultCode == "000000") {
                        // 일련번호 설정
                        $('#serverKey').val(serverKey);
                        $('#div-otp-test').show();
                        $('#regist-otp-step').html(L['OTP등록_STEP2']);
                        $('#btn-test-otp').show();
                        return;
                    } else {
                        ISP.notify('error', resultMessage);
                        return;
                    }
                },
                error:function(xhr, msg, e){
                }
            });

        },
        verifyOtpNumber : function() {

            var clientKey = $('#clientKey').val();
            var serverKey = $('#serverKey').val();
            var testOtpNumber = $('#testOtpNumber').val();

            if (clientKey == undefined || clientKey.length == 0) {
                ISP.notify('error', L[230002]);
                return;
            }
            if (serverKey == undefined || serverKey.length == 0) {
                ISP.notify('error', L[230003]);
                return;
            }
            if (testOtpNumber == undefined || testOtpNumber.length == 0) {
                ISP.notify('error', L[230007]);
                return;
            }

            $.ajax({
                url : '/authentication/otp/verifyOtpNumber',
                type : 'POST',
                dataType : 'json',
                data : {
                    "clientKey" : clientKey,
                    "serverKey" : serverKey,
                    "otpNumber" : testOtpNumber
                },
                success : function(data) {
                    console.log(data);
                    var resultCode = data.resultCode
                    var resultMessage = data.resultMessage

                    if (resultCode == "230006") {
                        $('#div-otp-test').hide();
                        $('#testOtpNumber').val("");
                        $('#otpTestFlag').val("true");
                        $('#clientKey').attr('disabled', 'disabled');
                        $('#regist-otp-step').html(L['OTP등록_STEP3']);
                        $('#btn-verify-otp').hide();
                        $('#btn-regist-otp').show();
                        return;
                    } else {
                        ISP.notify('error', resultMessage);
                        return;
                    }
                },
                error : function(xhr, msg, e) {
                }
            });

        },
        regist : function() {
        	
            var clientKey = $('#clientKey').val();
            var testFlag = $('#otpTestFlag').val();
            
            if (clientKey == undefined || clientKey.length == 0) {
                ISP.notify('error', L[230002]);
                return;
            }
            if (testFlag != "true") {
                ISP.notify('error', L[230008]);
                return;
            }

            var userId = $('#userId').val();
            var clientKey = $('#clientKey').val();
            var serverKey = $('#serverKey').val();

            $.ajax({
                url : '/authentication/otp/registOtp',
                type : 'POST',
                dataType : 'json',
                data : {
                    "clientKey" : clientKey,
                    "serverKey" : serverKey,
                    "userId" : userId
                },
                success : function(data) {
                    console.log(data);
                    var resultCode = data.resultCode
                    var resultMessage = data.resultMessage

                    if (resultCode == "230010") {
                    	commonAjaxSuccessCallback(resultMessage);
                    } else {
                        ISP.notify('error', resultMessage);
                        return;
                    }
                },
                error : function(xhr, msg, e) {
                }
            });

        },
        appendEvents : function() {
            var self = this;
            
            self.elements.$btnVerifyOtpNumber.click(function() {
                self.verifyOtpNumber();
            });
            
            $("input[name=testOtpNumber]").keypress(function(event){
                if(event.keyCode == 13){
                    self.verifyOtpNumber();
                }
            });
            
            self.elements.$btnRegistOtp.click(function() {
                self.regist();
            });
            
        },
        init : function() {
            this.appendEvents();

            $('#otpTestFlag').val(false);
            $('#btn-test-otp').hide();
            $('#btn-regist-otp').hide();
        }
    });
    
    var PkiRegisterView = new ISP.View({
        model:new ISP.Model({}),
        elements : {
            $btnRegistPki : $('#btn-save-pki'),
            $pkiPw : $('#pkiPw')
        },
        openChangePkiModal : function(mode) {
            
        	$('#pkiPw').val('');
        	
            if(mode == 'update') {
            	$('#change-pki-modal-title').html(L['사용자포털_PKI등록_타이틀_변경']);
            } else {
            	$('#change-pki-modal-title').html(L['사용자포털_PKI등록_타이틀_등록']);
            }
            
            $('#change-pki-modal').modal({backdrop: 'static'});
            $('#change-pki-modal').modal('show');
            
            this.getChallenge();
        },
        getChallenge : function() {
            $.ajax({
                url : '/openapi/authentication/challenge/get',
                type : 'GET',
                dataType : 'json',
                success : function(data) {
                    console.log(data);
                    var resultCode = data.resultCode
                    var resultMessage = data.resultMessage
                    var resultData = data.resultData
                    
                    if (resultCode == "000000") {
                    	$('#challenge').val(resultData.challenge);
                    } else {
                        ISP.notify('error', resultMessage);
                        return;
                    }
                },
                error : function(xhr, msg, e) {
                }
            });

        },
        regist : function() {
            //var pageform = document.pkiform;
            
            var id = $('#userId').val();
            var pw = $('#pkiPw').val();
            
            if (pw == undefined || pw.length == 0) {
                ISP.notify('error', L[210001]);
                return;
            }
            
            var displayMediaTypes = ['HDD', 'USB'];
            if (webcrypto.pka.ui.setStorageType(displayMediaTypes) === false) {
                alert(L['PKI등록_저장매체설정실패']);
            }
            
            $('#btn-close-pki').click();

            // 인증서 선택 다이얼로그 오픈
            var caTypes = ['NPKI', 'EPKI', 'GPKI'];
            var request = webcrypto.pka.ui.openCertSelectionBox(caTypes);
            request.onsuccess = function() {
                var challenge = $('#challenge').val();
                var req = webcrypto.pka.makeResponse(challenge);
                
                req.onerror = function(errMsg) {
                    alert('응답값 생성 실패 : ' + errMsg);
                    webcrypto.pka.finalize();
                };
                req.oncomplete = function(result) {
                    var response = result;
                    webcrypto.pka.finalize();
                    //pageform.submit();
                    
                    $.ajax({
                        url:'/authentication/pki/registerProcess',
                        type:'POST',
                        dataType:'json',
                        data : {
                            "challenge" : challenge,
                            "response" : response,
                            "id" : id,
                            "pw" : pw
                        },
                        success:function (data) {
                            console.log(data);
                            var resultCode = data.resultCode
                            var resultMessage = data.resultMessage
                            
                            if(resultCode == "000000") {
                            	commonAjaxSuccessCallback(L['사용자포털_PKI등록_성공']);
                            	
                            } else if(resultCode == "210003") {
                            	ISP.notify('error', L[220018]);
                            	return;
                            } else {
                                ISP.notify('error', resultMessage);
                                return;
                            }
                        },
                        error:function(xhr, msg, e){
                        }
                    });
                };
            };
            
        },
        appendEvents : function() {
            var self = this;

            self.elements.$pkiPw.keypress(function(e) {
                if ( e.keyCode !== 13 ) return;
                self.regist();
            });
            
            self.elements.$btnRegistPki.click(function() {
                self.regist();
            });
        },
        init: function () {
            this.appendEvents();
        }
    });
    
    var elements = {
    		$ServiceTable:$('#service-list-table')    
        };

    AuthTypeView.init();
    OtpRegisterView.init();
    PkiRegisterView.init();
    ServiceListView.init();
    
});