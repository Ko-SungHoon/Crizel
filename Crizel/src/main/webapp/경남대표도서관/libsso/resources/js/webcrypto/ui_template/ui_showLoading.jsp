<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="../ui_template/jquery.ui/css/jquery.ui.all.css">
<script type="text/javascript" src="../ui_template/jquery-1.10.2.js"></script>
<script type="text/javascript" src="../ui_template/jquery.ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="../ui_template/jquery.ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="../ui_template/jquery.ui/jquery.ui.progressbar.js"></script>
<script type="text/javascript">
var popupName = "damowa_loading_layer";
var showLoadingUI = function () {
	var progressWidth = 600;
	var progressHeight = 28;
	var messageHeight = 28;
	var popupWidth = progressWidth;
	var popupHeight = progressHeight + messageHeight;
	var installpop =
		'<div id="' + popupName + '_div"' +
		'    style="position:fixed; top:0; left:0; width:100%; height:100%; z-index:20000000000000000000000000;">' +
		'  <div style="position:absolute; top:0; left:0; width:100%; height:100%; background:#000;'	+
		'      opacity:0.4; filter:alpha(opacity=40); line-height:450px;"></div>' +
		   // popup
		'  <div style="position:absolute; top:50%; left:50%; background:#000; z-index:20000000000000000000000;' +
		'      width:' + popupWidth + 'px;' +
		'      margin-left:-' + parseInt(popupWidth, 10) / 2 + 'px;' +
		'      height:' + popupHeight + 'px;' +
		'      margin-top:-' + parseInt(popupHeight, 10) / 2 + 'px;' +
		'      border-radius:5px; text-align:center; opacity:0.7; filter:alpha(opacity=70);">' +
		     // progress bar
		'    <div id="damowa_progressbar" style="text-align:center;">' +
		'    </div>' +
		     // message
		'    <div id="damowa_message" style="height: '+ messageHeight + 'px; text-align:center;' +
		'        font:12px/1.5 dotum,돋움,Arial,Tahoma,sans-serif; color:#fff;font-weight:bold;">' +
		'      D\'Amo WA v3.0 프로그램을 로딩중입니다.' +
		'    </div>' +
		'  </div>' +
		'</div>';
		
	newDiv = document.createElement("div");
	newDiv.setAttribute("id", popupName);
	newDiv.innerHTML = installpop;
	document.body.appendChild(newDiv);
	$(function() {
		$("#damowa_progressbar").progressbar({
			value: false
		});
	});
};

var removeLoadingUI = function (flag) {
	var targetElement = document.getElementById(popupName);
	if (targetElement) {
		document.body.removeChild(targetElement);
	}
};
</script>
<style>
#damowa_progressbar .ui-progressbar-value {
    background-color: #8888CC;
}
</style>