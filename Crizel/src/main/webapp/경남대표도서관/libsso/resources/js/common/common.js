/**
* ISP common
* @author:bhkim@pentasecurity.com
* @since: 2016.02.23
**/
(function (win) {
    var ISP = {};

    function browserPolyFills() {
        // 혹시나 하위버전IE로 들어왔을때 새가 되지않도록 :)
        win.console = win.console || (function dummyConsole() {
            var emptyFn = function() {};
            return {
                log:emptyFn
            };
        })();
    }

    /**
    * 전역 jquery ajax 설정
    * spinner 처리, 공통 에러 루틴 처리
    **/
    function setJqueryAjaxGlobalSettings() {
        $.ajaxSetup({
            cache:false
        });

        $(document).ajaxError(function(event, xhr, ajaxSettings, thrownError) {
            console.log(arguments);
            if ( xhr.status == 403 ) {
                location.href = ISP.props.contextPath + '/login.html';
                return;
            }
            if(thrownError != "abort"){
                ISP.notify('error', (xhr.responseJSON && xhr.responseJSON.message) || 'Unknown Error' );
            }
        }).ajaxComplete(function(e, xhr, opts) {
            if(!(opts.ignoreSpinner)){
                ISP.spinner.hide();
            }
        }).ajaxSend(function(e, xhr, opts) {
            //var token = $("meta[name='_csrf']").attr("content");
            //var header = $("meta[name='_csrf_header']").attr("content");
            //xhr.setRequestHeader(header, token);
            if(!(opts.ignoreSpinner)){
                ISP.spinner.show();
            }

        });
    }

    function assert(cond, msg) { if ( !cond ) throw msg || 'Assertion Failed'; }
    function $equals(id1, id2) {
        if (id1 != undefined && id2 != undefined) {
            return id1 == id2;
        }
        return false;
    }

    function $length(text, min, max) {
        if (text == undefined) {
            return false;
        }
        if (min >= 0 && text.length < min) {
            return false;
        }
        if (max >= 0 && text.length > max) {
            return false;
        }
        return true;
    }
    function $isEmail(text) {
        return /^[a-z0-9!#$%&'*+\/=?^_`{|}~.-]+@[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z0-9]([a-z0-9-]*[a-z0-9])?)*$/i.test(text);
    }
    
    function $isApiKey(text) {
        // 영대소문자+숫자
        // /^[a-zA-Z0-9]*$/;
        return /^[a-zA-Z0-9]*$/i.test(text);
    }

    function isValidIp(text) {
        return /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/i.test(text);
    }

    /**
    * 8자이상 영어 대소문자,숫자, 특수문자 포함
    */
    function $isMatchPasswordPattern(text) {
        return /^.*(?=^.{8,}$)(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/.test(text);
    }

    /**
    * Notification plugin
    * ISP.notify('success', 'msg');
    * ISP.notify('info', 'msg');
    * ISP.notify('warning', 'msg');
    * ISP.notify('error', 'msg');
    **/
    var notifier = (function() {
        toastr.options = {
            closeButton: false,
            debug: false,
            newestOnTop: false,
            progressBar: false,
            positionClass: 'toast-top-full-width',
            preventDuplicates: false,
            onclick: null,
            showDuration: 300,
            hideDuration: 300,
            timeOut: 5000,
            extendedTimeOut: 1000,
            showEasing: 'swing',
            hideEasing: 'linear',
            showMethod: 'slideDown',
            hideMethod: 'slideUp'
        }
        return function(level, msg, opts) {
            level = level || 'info'
            if ( opts ) toastr.options = $.extend(toastr.options, opts);
            toastr[level](msg);
        };
    })();

    /**
    * loading spinner
    * ISP.spinner.show();
    * ISP.spinner.hide();
    **/
    var spinner = {
        show:function() {
            if ( $('.backdrop').size() > 0 ) return;

            var backdrop = $(_.template($('#tpl-backdrop').html())());
            $('body').append(backdrop);
            backdrop.show().addClass('show');
        },
        hide:function() {
            $('.backdrop').removeClass('show');
            setTimeout(function() {
                $('.backdrop').remove();
            }, 500);
        }
    };

    var Model = (function ModelClass() {
        var fn;
        function Model (opts) {
            this.listeners = {};
            $.extend(this, opts);
        }
        (fn = Model.prototype).set = function set(k, v) {
            var t0, i, origValue, newValue;
            origValue = this[k], newValue = (this[k] = v);

            // fire events
            t0 = this.listeners[k] || [], i = t0.length;
            while(i--) t0[i](origValue, newValue);
        },
        fn.listen = function listen(issue, fn) {
            var t0, t1, i;
            t0 = issue.split(",");
            i = t0.length;
            if ( t0.length == 0 ) return;
            while(i--) (this.listeners[t0[i]] || (this.listeners[t0[i]] = [])).push(fn);
        };
        return Model;
    })();
    
    var View = (function ViewClass() {
        var fn;
        function View (opts) {
            this.targetEl = $('body');

            $.extend(this, opts);
            this.template = _.template($(this.tmpl).html());
            this.children = [];
            this.model = this.model || {};
        }
        // append 될 targetEL을 명시적으로 설정할수 있음
        (fn = View.prototype).render = function (targetEl) {
            var i, n;
            this.targetEl = targetEl ? targetEl : this.targetEl;
            if ( this.el ) this.clear();
            this.el = $(this.template(this.model));
            this.targetEl.append(this.el);
            this.bindEvents();

            for ( i=0,n=this.children.length;i<n;i++ )
                this.children[i].render();
        },
        fn.clear = function () { this.el.remove(); },
        fn.destroy = function () {
            this.clear();
            var i = this.children.length;
            while(i--) this.children[i].destroy();
        },
        fn.add = function(view) { this.children.push(view); };
        return View;
    })();

    ISP.Utils = {
        $equals:$equals,
        $length:$length,
        $email:$isEmail,
        $apiKey:$isApiKey,
        $password:$isMatchPasswordPattern,
        $isValidIp: isValidIp
    };
    ISP.Model = Model;
    ISP.View = View;
    ISP.notify = notifier;
    ISP.spinner = spinner;

    browserPolyFills();
    setJqueryAjaxGlobalSettings();
    
    // 외부 Namespace 노출
    win.ISP = ISP;
    
})(this);

function alertErrorMessage(message) {

    $('#error-alert').show();
    $('#error-alert').html(message);
    
}

function alertSuccessMessage(message) {

    $('#success-alert').show();
    $('#success-alert').html(message);
    
}

function resetErrorMessage() {

    $('#error-alert').hide();
    $('#error-alert').html("");
    
}