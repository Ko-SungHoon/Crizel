var popupName = "penta_loading_layer";

var showLoadingUI = function () {
	var imageWidth = 300;
	var imageHeight = 300;
	var messageHeight = 28;
	var popupWidth = imageWidth;
	var popupHeight = imageHeight + messageHeight;
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
		     // image
		'    <div id="' + popupName + '_content1" style="text-align:center;">' +
		'      <img src="../ui_template/image/load2.gif" alt="진행 중" />' +
		'    </div>' +
		     // message
		'    <div id="' + popupName + '_content2" style="height: '+ messageHeight + 'px; text-align:center;' +
		'        font:12px/1.5 dotum,돋움,Arial,Tahoma,sans-serif; color:#fff;font-weight:bold;">' +
		'      D\'Amo WA v3.0 프로그램을 로딩중입니다.' +
		'    </div>' +
		'  </div>' +
		'</div>';
	newDiv = document.createElement("div");
	newDiv.setAttribute("id", popupName);
	newDiv.innerHTML = installpop;
	var attachElement = document.body;
	attachElement.appendChild(newDiv);
};

var removeLoadingUI = function (flag) {
	var attachElement = document.body;
	var targetElement = document.getElementById(popupName);
	attachElement.removeChild(targetElement);
};