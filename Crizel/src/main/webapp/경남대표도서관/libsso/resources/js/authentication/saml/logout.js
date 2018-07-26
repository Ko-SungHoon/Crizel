$(function() {
    var delayTime = $('#delayTime').val();
    setTimeout(function(){
        $('#form-index').submit();
    }, delayTime);
});