/*
 * COPYRIGHT 1997 Pentasecurity
 * ALL RIGHTS RESERVED
 */

//****************************************************************************************//

(function() {
/************************************************************************
 * 클로저 오브젝트의 private 변수
*************************************************************************/
var _certListManager = null;
var _callbackObj = {onsuccess: null};
var _getMessage = webcrypto.msg.getMessage;
var _supportedMediaTypes = ['HDD', 'USB', 'Phone', 'HSM', 'USIM'];
var _mediaSelected = '';
var _layoutManager = null;
var _doNotDrawCertList = false;
var _showExpiredCert = false;
var _verifyCert = true;
var _authcode = null;
var _pfxRelay = null;
var _driveSelection = {
  _driveIDSelected: '',
  _contentText: '',

  clear: function() {
    _driveIDSelected = '';
    _contentText = '';
  },

  getDriveIDSelected: function() {
    return _driveIDSelected;
  },

  setDriveIDSelected: function(driveID) {
    _driveIDSelected = driveID;
  },

  getContentText: function() {
    return _contentText;
  },

  setContentText: function(text) {
    _contentText = text;
  }
};

/************************************************************************
 * 클로저 오브젝트의 public 메소드 정의 (네임스페이스 적용)
*************************************************************************/
var ui = webcrypto.namespace('pka.ui');

/**
 * @brief 사용자 인증서 선택창을 띄워주는 함수
 * @return [OUT] 인증서 선택이 완료되었을 때 실행될 콜백함수(onsuccess)를 받을 오브젝트. {onsuccess: null}
 */
ui.openCertSelectionBox = function(caType, policyOID, options) {
  webcrypto.pka.setCertificateAuthority(caType);
  webcrypto.pka.setCertificatePolicyOID(policyOID);
  webcrypto.pka.setPrivateOptions(options);
  _openCertSelection();
  return _callbackObj;
};

/**
 * @brief 사용자 인증서 선택창을 띄워주는 함수
 * @return [OUT] 인증서 선택이 완료되었을 때 실행될 콜백함수(onsuccess)를 받을 오브젝트. {onsuccess: null}
 */
ui.openImportCertRelayBox = function(caType, policyOID, options, authcode, pfxRelay) {
  webcrypto.pka.setCertificateAuthority(caType);
  webcrypto.pka.setCertificatePolicyOID(policyOID);
  webcrypto.pka.setPrivateOptions(options);
  _authcode = authcode;
  _pfxRelay = pfxRelay;
  _openImportCertRelay();
  return _callbackObj;
};

/**
 * @brief UI에 대한 초기 설정 함수
 * UI 쪽 html 엘리먼트에 대한 이벤트는 여기서 넣어주고, 외부 엘리먼트에 대한 이벤트는 html 페이지에서 넣자
 */
ui.initialize = _initialize;

/**
 * @brief UI에 보여줄 저장메체에 대한 초기 설정 함수
 * @param mediaTypes [IN] UI에 활성화할 저장매체 배열, 지원하는 전체 저장매체는 ['HDD', 'USB', 'Phone', 'HSM', 'USIM']
 * @return [OUT] 성공/실패
 */
ui.setStorageType = _setMediaType;

/**
 * @brief 인증서 목록에 유효기간이 지난 인증서를 보이게 할지 여부를 설정한다.
 * @param showExpiredCert {Boolean}  [IN] true : 유효기간이 지난 인증서 보임, false 유효기간이 지난 인증서 숨김
 */
ui.setShowExpiredCert = _setShowExpiredCert;

/**
 * @brief 인증서 자세히 보기 실행 시 유효성 검증 실행 여부를 설정한다.
 * @param verifyCert {Boolean} [IN] true : 유효성 검증 실행, false : 유효성 검증 실행하지 않음
 */
ui.setVerifyCert = _setVerifyCert;

/************************************************************************
 * 클로저 오브젝트의 private 메소드
*************************************************************************/
var _initialized = false;
function _initialize() {
  if (_initialized === true) {
    return;
  }

  // IE의 자동 Caps Lock 키 체크 기능을 끈다.
  if (typeof document.msCapsLockWarningOff === 'boolean') {
    document.msCapsLockWarningOff = true;
  }

  // UI에서 내부적으로 관리할 인증서 정보 리스트 오브젝트 생성
  _certListManager = new CertListManager();

  // Layout의 이벤트 관리를 위한 오브젝트 생성
  _layoutManager = new LayoutManager();

  // UI의 html 앨리먼트들에 대한 이벤트 등록
  _addEvent(document.getElementById('wc_import_cert'), 'click', _openImportCert, false);
  _addEvent(document.getElementById('wc_detail_view'), 'click', _openDetailCert, false);
  _addEvent(document.getElementById('wc_cert_delete'), 'click', _delCert, false);
  _addEvent(document.getElementById('wc_export_cert'), 'click', _exportCert, false);
  _addEvent(document.getElementById('wc_cert_copy'), 'click', _copyCert, false);
  _addEvent(document.getElementById('wc_password_change'), 'click', _changePassword, false);

  _addEvent(document.getElementById('wc_cert_selection_password'), 'keypress', _eventHandlerInputPw, false);
  _addEvent(document.getElementById('wc_cert_selection_ok'), 'click', _layoutManager.onOk, false);
  _addEvent(document.getElementById('wc_cert_selection_cancel'), 'click', _layoutManager.onCancel, false);

  _addEvent(document.getElementById('wc_hsm_drive_selection_ok'), 'click', _layoutManager.onOk, false);
  _addEvent(document.getElementById('wc_hsm_drive_selection_cancel'), 'click', _layoutManager.onCancel, false);

  _addEvent(document.getElementById('wc_usim_drive_selection_ok'), 'click', _layoutManager.onOk, false);
  _addEvent(document.getElementById('wc_usim_drive_selection_cancel'), 'click', _layoutManager.onCancel, false);

  _addEvent(document.getElementById('wc_hsm_login_pin'), 'keypress', _eventHandlerInputPw, false);
  _addEvent(document.getElementById('wc_hsm_login_ok'), 'click', _layoutManager.onOk, false);
  _addEvent(document.getElementById('wc_hsm_login_cancel'), 'click', _layoutManager.onCancel, false);

  _addEvent(document.getElementById('wc_usim_login_pin'), 'keypress', _eventHandlerInputPw, false);
  _addEvent(document.getElementById('wc_usim_login_ok'), 'click', _layoutManager.onOk, false);
  _addEvent(document.getElementById('wc_usim_login_cancel'), 'click', _layoutManager.onCancel, false);

  _addEvent(document.getElementById('wc_pw_input_password'), 'keypress', _eventHandlerInputPw, false);
  _addEvent(document.getElementById('wc_pw_input_ok'), 'click', _layoutManager.onOk, false);
  _addEvent(document.getElementById('wc_pw_input_cancel'), 'click', _layoutManager.onCancel, false);

  _addEvent(document.getElementById('wc_pw_change_new2'), 'keypress', _eventHandlerInputPw, false);
  _addEvent(document.getElementById('wc_pw_change_ok'), 'click', _layoutManager.onOk, false);
  _addEvent(document.getElementById('wc_pw_change_cancel'), 'click', _layoutManager.onCancel, false);

  _addEvent(document.getElementById('wc_import_pfx_password'), 'keypress', _eventHandlerInputPw, false);
  _addEvent(document.getElementById('wc_import_cert_password'), 'keypress', _eventHandlerInputPw, false);
  _addEvent(document.getElementById('wc_import_cert_ok'), 'click', _layoutManager.onOk, false);
  _addEvent(document.getElementById('wc_import_cert_cancel'), 'click', _layoutManager.onCancel, false);

  _addEvent(document.getElementById('wc_cert_detail_ok'), 'click', _layoutManager.onOk, false);
  _addEvent(document.getElementById('wc_detail_base_tab'), 'click', _selectDetailBase, false);
  _addEvent(document.getElementById('wc_detail_contents_tab'), 'click', _selectDetailContents, false);

  _addEvent(document.getElementById('wc_import_relay_ok'), 'click', _layoutManager.onOk, false);
  _addEvent(document.getElementById('wc_import_relay_cancel'), 'click', _layoutManager.onCancel, false);

  _addEvent(document.getElementById('wc_cert_copy_ok'), 'click', _layoutManager.onOk, false);
  _addEvent(document.getElementById('wc_cert_copy_cancel'), 'click', _layoutManager.onCancel, false);

  // ESC 키 이벤트 처리. 모든 layout의 close 처리.
  _addEvent(document.getElementById('wc_cert_selection_layout').parentNode, 'keydown', _eventHandler, false);

  _setMediaType();

  _disableSelection(document.getElementById('wc_cert_selection_layout'));
  _initialized = true;
}

// UI에 텍스트 하이라이트 방지
function _disableSelection(target) {
  //For IE
  if (typeof target.onselectstart != 'undefined') {
    target.onselectstart = function() { return false; };

  //For Firefox
  } else if (typeof target.style.MozUserSelect != 'undefined') {
    target.style.MozUserSelect = 'none';

  //All other  (ie: Opera)
  } else {
    target.onmousedown = function() { return false; };
  }
}

function _isMediaTypePKCS11(mediaType) {
  return (mediaType === 'HSM' || mediaType === 'USIM')
}

function _isMediaTypeDisk(mediaType) {
  return (mediaType === 'HDD' || mediaType === 'USB')
}

// 저장매체 디스플레이, 설정, 이벤트 처리
function _setMediaType(mediaTypes) {
  var displayMediaTypes = [];

  if (typeof mediaTypes !== 'undefined') {
    displayMediaTypes = _reconstituteMediaType(mediaTypes)
  } else {
    displayMediaTypes = _supportedMediaTypes.slice(0);
  }

  if (displayMediaTypes.length === 0) {
    return false;
  }

  var activatedMediaTypes = [];

  // 메인 다이얼로그 저장매체 탭에 대한 설정
  activatedMediaTypes = _activateMediaType(displayMediaTypes, 'wc_media_selection_radio', _handleMediaTap);

  _mediaSelected = activatedMediaTypes[0];
  _setMediaChecked('wc_media_selection_radio', _mediaSelected);

  // 인증서복사 다이얼로그 저장매체 탭에 대한 설정. Phone과 USIM은 복사 대상에서 제외되어야 한다.
  var targetMediaTypes = displayMediaTypes.slice(0);
  var indexPreventMedia = targetMediaTypes.indexOf('Phone');
  if (indexPreventMedia !== -1) {
    targetMediaTypes.splice(indexPreventMedia, 1);
  }
  indexPreventMedia = targetMediaTypes.indexOf('USIM');
  if (indexPreventMedia !== -1) {
    targetMediaTypes.splice(indexPreventMedia, 1);
  }

  activatedMediaTypes = _activateMediaType(targetMediaTypes, 'wc_target_media_radio', _handleTargetMediaTap);
  _setMediaChecked('wc_target_media_radio', activatedMediaTypes[0]);

  activatedMediaTypes = _activateMediaType(targetMediaTypes, 'wc_import_relay_media_radio', _handleImportRelayTap);
  _setMediaChecked('wc_import_relay_media_radio', activatedMediaTypes[0]);

  return true;
}

function _setShowExpiredCert(showExpiredCert) {
  _showExpiredCert = showExpiredCert;
}

function _setVerifyCert(verifyCert) {
  _verifyCert = verifyCert;
}

// 보여줄 저장매체 변수 재구성. 올바른 입력값인지 체크, 지원하는 저장매체만으로 배열 재구성
function _reconstituteMediaType(mediaTypes) {
  var resultMediaTypes = [];

  // 입력값이 정상인지 확인
  if (typeof mediaTypes === 'undefined' || mediaTypes.constructor !== Array) {
    return resultMediaTypes;
  }

  for (var index = 0; index < mediaTypes.length; index++) {
    if (typeof mediaTypes[index] === 'string') {
      var media = mediaTypes[index].toUpperCase();
      if (media === 'PHONE') {
        media = 'Phone';
      }
      if (_supportedMediaTypes.indexOf(media) !== -1) {
        resultMediaTypes.push(media);
      }
    }
  }

  return resultMediaTypes;
}

// 저장매체 UI 활성화 및 이벤트 처리, 미지원 플랫폼 처리
function _activateMediaType(mediaTypes, elemRadioName, clickEventFunc) {
  var activatedMediaTypes = [];
  var tabs = document.getElementsByName(elemRadioName);
  var platformInfo = webcrypto.getPlatformInfo();

  for (var i = 0; i < tabs.length; i++) {
    if (typeof clickEventFunc === 'function') {
      _removeEvent(tabs[i], 'click', clickEventFunc, false);
    }

    if (mediaTypes.indexOf(tabs[i].value) !== -1) {
      // NOTE : 보여줄 저장매체 목록에 있어도 미지원 이유로 비활성 필요한 저장매체에 대한 처리
      // TODO : 추후 지원하게 되면 수정
      if (tabs[i].value === 'USIM') {
        // 스마트인증을 정식으로 연동하기 전까지는 미지원
        tabs[i].disabled = true;
        tabs[i].parentNode.parentNode.className = 'wcSelcOff';
      } else if (platformInfo.platform !== 'win' && (_isMediaTypePKCS11(tabs[i].value) || tabs[i].value === 'Phone')) {
        // 윈도우 플랫폼이 아닌 경우 PKCS#11 디바이스 및 유비키 미지원
        tabs[i].disabled = true;
        tabs[i].parentNode.parentNode.className = 'wcSelcOff';
      } else if (platformInfo.os === 'Windows XP' && _isMediaTypePKCS11(tabs[i].value)) {
        // 윈도우 XP에서 PKCS#11 디바이스 미지원
        tabs[i].disabled = true;
        tabs[i].parentNode.parentNode.className = 'wcSelcOff';
      } else {
        tabs[i].disabled = false;
        tabs[i].parentNode.parentNode.className = '';

        // 활성화된 매체는 이벤트 추가
        if (typeof clickEventFunc === 'function') {
          _addEvent(tabs[i], 'click', clickEventFunc, false);
        }
        activatedMediaTypes.push(tabs[i].value);
      }
    } else {
      // 보여줄 저장매체 목록에 없는 매체는 비활성화
      tabs[i].disabled = true;
      tabs[i].parentNode.parentNode.className = 'wcSelcOff';
    }
  }

  return activatedMediaTypes;
}

// 인증서 저장매체 탭 선택 관리
function _getMediaChecked(elemRadioName) {
  var value = '';
  var tabs = document.getElementsByName(elemRadioName);

  for (var i = 0; i < tabs.length; i++) {
    if (tabs[i].parentNode.parentNode.className !== 'wcSelcOff') {
      if (tabs[i].checked) {
        value = tabs[i].value;
        tabs[i].parentNode.parentNode.className = 'wcSelcOn';
      } else {
        tabs[i].parentNode.parentNode.className = '';
      }
    }
  }

  return value;
}

function _setMediaChecked(elemRadioName, media) {
  var tabs= document.getElementsByName(elemRadioName);
  var result = false;

  for (var i = 0; i < tabs.length; i++) {
    if (tabs[i].parentNode.parentNode.className !== 'wcSelcOff') {
      if (tabs[i].value === media) {
        tabs[i].checked = true;
        tabs[i].parentNode.parentNode.className = 'wcSelcOn';
        result = true;
      } else {
        tabs[i].parentNode.parentNode.className = '';
      }
    }
  }

  return result;
}

// 이벤트 등록 메소드, 크로스브라우징 고려
var _addEvent = (function(_window) {
  if (_window.addEventListener) {
    return function(element, eventName, callback, isCapture) {
      element.addEventListener(eventName, callback, isCapture);
    };
  } else if (_window.attachEvent) {
    return function(element, eventName, callback) {
      element.attachEvent('on' + eventName, callback);
    };
  } else {
    return function(element, eventName, callback) {
      element['on' + eventName] = callback;
    };
  }
})(window);

// 이벤트 해제 메소드, 크로스브라우징 고려
var _removeEvent = (function(_window) {
  if (_window.removeEventListener) {
    return function(element, eventName, callback, isCapture) {
      element.removeEventListener(eventName, callback, isCapture);
    };
  } else if (_window.detachEvent) {
    return function(element, eventName, callback) {
      element.detachEvent('on' + eventName, callback);
    };
  } else {
    return function(element, eventName, callback) {
      if (element['on' + eventName] === callback)
        element['on' + eventName] = null;
    };
  }
})(window);

// 마우스 이벤트 트리거 메소드, 크로스브라우징 고려
function _triggerMouseEvent(element, eventName) {
  var event;
  if (document.createEvent) {
    event = document.createEvent('MouseEvents');
    event.initEvent(eventName, true, true);
  } else if (document.createEventObject) {  // IE < 9
    event = document.createEventObject();
    event.eventType = eventName;
  }

  event.eventName = eventName;

  if (element.dispatchEvent) {
    element.dispatchEvent(event);
  } else if (element.fireEvent) {
    element.fireEvent('on'+event.eventType, event);
  } else if (element[eventName]) {
    element[eventName]();
  } else if (element['on'+eventName]) {
    element['on'+eventName]();
  }
}

// 이벤트 막기
function _preventEvent(e) {
  var evt = e || event;
  try {
    if (evt.preventDefault) {
      evt.preventDefault();
      if (evt.stopPropagation) {
        evt.stopPropagation();
      }
    } else if (window.event) {
      window.event.returnValue = false;
    }
    return false;
  } catch(ex) {
    return false;
  }
}

// 키 이벤트 핸들러 API
function _eventHandler(evt) {
  var keyCode = 0;
  keyCode = evt.which ? evt.which : evt.keyCode;

  // esc키가 눌리면 열려있는 layout을 닫아준다.
  if (keyCode === 27) {
    _layoutManager.onCancel();
  }
}

// password 입력창 키 이벤트 핸들러
function _eventHandlerInputPw(evt) {

  var keyCode = 0;
  keyCode = evt.which ? evt.which : evt.keyCode;

  // 엔터키 처리
  if (keyCode === 13) {
    _layoutManager.onOk();
    _preventEvent(evt);
  }

/*
  // CapsLock 체크하는 부분
  var shiftKey = false;
  shiftKey = evt.shiftKey ? evt.shiftKey : ((keyCode === 16) ? true : false);
  var capsLockEnabled = ((keyCode >= 65 && keyCode <= 90) && !shiftKey) || ((keyCode >= 97 && keyCode <= 122) && shiftKey);

  if (capsLockEnabled) {
    document.getElementById('caps_indicator').style.display = 'block';
  } else {
    document.getElementById('caps_indicator').style.display = 'none';
  }
*/
}

// UI Layout Open/Close 관리 API
function LayoutManager() {
  var layoutOpened = 'Main';
  var callFunctionName = '';

  // NOTE : 추가 layout이 생성되면 추가한다.
  function _closeLayout() {
    switch(layoutOpened) {
      case 'CertSelction':
        document.getElementById('wc_cert_selection_password').value = '';
        document.getElementById('wc_hsm_login_pin').value = '';
        document.getElementById('wc_import_pfx_password').value = '';
        document.getElementById('wc_import_cert_password').value = '';
        document.getElementById('wc_cert_selection_layout').style.display = 'none';
        document.getElementById('wc_cert_selection_password').disabled = false;
        layoutOpened = 'Main';
      break;

      case 'hsmDriveSelection':
        document.getElementById("wc_hsm_drive_selection_layout").style.display = 'none';
        layoutOpened = 'CertSelction';
      break;

      case 'usimDriveSelection':
        document.getElementById("wc_usim_drive_selection_layout").style.display = 'none';
        layoutOpened = 'CertSelction';
      break;

      case 'hsmLogin':
        document.getElementById('wc_hsm_login_pin').value = '';
        document.getElementById("wc_hsm_login_layout").style.display = 'none';
        layoutOpened = 'CertSelction';
        callFunctionName = '';
      break;

      case 'usimLogin':
        document.getElementById('wc_usim_login_pin').value = '';
        document.getElementById("wc_usim_login_layout").style.display = 'none';
        layoutOpened = 'CertSelction';
        callFunctionName = '';
      break;

      case 'passwordInput':
        document.getElementById('wc_pw_input_password').value = '';
        document.getElementById("wc_pw_input_layout").style.display = 'none';
        layoutOpened = 'CertSelction';
        callFunctionName = '';
      break;

      case 'passwordChange':
        document.getElementById('wc_pw_change_old').value = '';
        document.getElementById('wc_pw_change_new1').value = '';
        document.getElementById('wc_pw_change_new2').value = '';
        document.getElementById("wc_pw_change_layout").style.display = 'none';
        layoutOpened = 'CertSelction';
      break;

      case 'Detail':
        document.getElementById('wc_cert_detail_layout').style.display = 'none';
        layoutOpened = 'CertSelction';
      break;

      case 'ImportCert':
        document.getElementById('wc_import_cert_layout').style.display = 'none';
        layoutOpened = 'CertSelction';
      break;

      case 'ImportCertRelay':
        document.getElementById('wc_import_cert_relay_layout').style.display = 'none';
        layoutOpened = 'CertSelction';
      break;

      case 'certCopy':
        document.getElementById('wc_cert_copy_layout').style.display = 'none';
        layoutOpened = 'CertSelction';
      break;

      default:
        document.getElementById('wc_import_cert_layout').style.display = 'none';
        document.getElementById('wc_cert_detail_layout').style.display = 'none';
        document.getElementById('wc_hsm_drive_selection_layout').style.display = 'none';
        document.getElementById("wc_usim_drive_selection_layout").style.display = 'none';
        document.getElementById('wc_hsm_login_layout').style.display = 'none';
        document.getElementById("wc_usim_login_layout").style.display = 'none';
        document.getElementById("wc_pw_input_layout").style.display = 'none';
        document.getElementById("wc_pw_change_layout").style.display = 'none';
        document.getElementById('wc_authcode_input_layout').style.display = 'none';
        document.getElementById('wc_import_cert_relay_layout').style.display = 'none';
        document.getElementById('wc_cert_copy_layout').style.display = 'none';
        document.getElementById('wc_cert_selection_layout').style.display = 'none';
        layoutOpened = 'Main';
      break;
    }
  }

  // NOTE : 추가 layout이 생성되면 추가한다.
  this.openLayoutCertSelection = function() {
    layoutOpened = 'CertSelction';
    document.getElementById('wc_cert_selection_password').value = '';
    document.getElementById('wc_cert_selection_layout').style.display = 'block';
    document.getElementById('wc_cert_selection_password').focus();
  };
  this.openLayoutPkcs11DriveSelection = function(mediaType) {
    if (mediaType === 'HSM') {
      layoutOpened = 'hsmDriveSelection';
      document.getElementById("wc_hsm_drive_selection_layout").style.display = 'block';
    } else if (mediaType === 'USIM') {
      layoutOpened = 'usimDriveSelection';
      document.getElementById("wc_usim_drive_selection_layout").style.display = 'block';
    }
  };
  this.openLayoutPkcs11Login = function(mediaType, functionName) {
    if (mediaType === 'HSM') {
      layoutOpened = 'hsmLogin';
      callFunctionName = functionName;
      document.getElementById('wc_hsm_login_pin').value = '';
      document.getElementById("wc_hsm_login_layout").style.display = 'block';
      document.getElementById('wc_hsm_login_pin').focus();
    } else if (mediaType === 'USIM') {
      layoutOpened = 'usimLogin';
      callFunctionName = functionName;
      document.getElementById('wc_usim_login_pin').value = '';
      document.getElementById("wc_usim_login_layout").style.display = 'block';
      document.getElementById('wc_usim_login_pin').focus();
    }
  };
  this.openLayoutPasswordInput = function(functionName) {
    layoutOpened = 'passwordInput';
    callFunctionName = functionName;
    document.getElementById('wc_pw_input_password').value = '';
    document.getElementById("wc_pw_input_layout").style.display = 'block';
    document.getElementById('wc_pw_input_password').focus();
  };
  this.openLayoutPasswordChange = function() {
    layoutOpened = 'passwordChange';
    document.getElementById('wc_pw_change_old').value = '';
    document.getElementById('wc_pw_change_new1').value = '';
    document.getElementById('wc_pw_change_new2').value = '';
    document.getElementById("wc_pw_change_layout").style.display = 'block';
    document.getElementById('wc_pw_change_old').focus();
  };
  this.openLayoutDetail = function() {
    layoutOpened = 'Detail';
    document.getElementById("wc_cert_detail_layout").style.display = 'block';
  };
  this.openLayoutImportCert = function() {
    layoutOpened = 'ImportCert';
    document.getElementById('wc_import_pfx_password').value = '';
    document.getElementById('wc_import_cert_password').value = '';
    document.getElementById('wc_import_cert_layout').style.display = 'block';
    document.getElementById('wc_import_pfx_password').focus();
  };
  this.openLayoutImportCertRelay = function() {
    layoutOpened = 'ImportCertRelay';
    document.getElementById('wc_import_cert_relay_layout').style.display = 'block';
  };
  this.openLayoutCertCopy = function() {
    layoutOpened = 'certCopy';
    document.getElementById("wc_cert_copy_layout").style.display = 'block';
  };
  // NOTE : 추가 layout이 생성되면 추가한다.
  this.onOk = function() {
    switch(layoutOpened) {
      case 'CertSelction':
        _onOkCertSelection();
        break;

      case 'hsmDriveSelection':
      case 'usimDriveSelection':
        _closeLayout();
        _drawCertList();
        break;

      case 'hsmLogin':
        _onOkPkcs11Login('HSM', callFunctionName);
        break;

      case 'usimLogin':
        _onOkPkcs11Login('USIM', callFunctionName);
        break;

      case 'passwordInput':
        _onOkPasswordInput(callFunctionName);
        break;

      case 'passwordChange':
        _onOkPasswordChange();
        break;

      case 'Detail':
        _closeLayout();
        break;

      case 'ImportCert':
        _onOkImportCert();
        break;

      case 'ImportCertRelay':
        _onOkImportCertRelay();
        break;

      case 'certCopy':
        _onOkCertCopy();
        break;

      default:
        break;
    }
  };

  // NOTE : 추가 layout이 생성되면 추가한다.
  this.onCancel = function() {
    switch(layoutOpened) {
      case 'CertSelction':
        webcrypto.pka.finalize();
        _closeLayout();
      break;

      case 'hsmDriveSelection':
      case 'usimDriveSelection':
        _driveSelection.clear();
        _closeLayout();
      break;

      case 'hsmLogin':
      case 'usimLogin':
        if (callFunctionName === '_onOkImportCert') {
          webcrypto.pka.clearPfxFileDialog();
        }
        _closeLayout();
      break;

      case 'passwordInput':
        _closeLayout();
      break;

      case 'passwordChange':
        _closeLayout();
      break;

      case 'Detail':
        _closeLayout();
      break;

      case 'ImportCert':
        webcrypto.pka.clearPfxFileDialog();
        document.getElementById('wc_import_pfx_password').value = '';
        document.getElementById('wc_import_cert_password').value = '';
        _closeLayout();
      break;

      case 'AuthcodeInput':
        _closeLayout();
        break;

      case 'ImportCertRelay':
        _closeLayout();
      break;

      case 'certCopy':
        _closeLayout();
      break;

      default:
      break;
    }
  };

  this.closeLayout = _closeLayout;
}

// 인증서 정보 관리 API
function CertListManager(){
  this.certList = null;
  this.selectedIndex = -1;
};
CertListManager.prototype.setCertList = function(certInfoList){
  if (certInfoList && certInfoList.length > 0) {
    this.certList = [];
    var i;
    for (i = 0; i < certInfoList.length; i++) {
      var certInfo = {
        'driveID':'',
        'driveName':'',
        'subjectDN':'',
        'subjectName':'',
        'issuerName':'',
        'validityNotAfter':'',
        'validityNotAfterFull':'',
        'remainDays':'',
        'certUsage':''
      };
      certInfo['driveID'] = certInfoList[i].getDriveID();

      // 유닉스 계열은 driveID가 폴더 형태이므로 마지막 Name만을 가져와서 화면에 출력
      do {
        var separatorIndex = certInfo['driveID'].lastIndexOf('/');
      } while (separatorIndex === certInfo['driveID'].length)

      if (separatorIndex === -1) {
        separatorIndex = 0;
      } else {
        separatorIndex++;
      }

      certInfo['driveName'] = certInfo['driveID'].substring(separatorIndex);
      certInfo['subjectDN'] = certInfoList[i].getSubjectNameFull();
      certInfo['subjectName'] = certInfoList[i].getSubjectName();
      certInfo['issuerName'] = certInfoList[i].getIssuerName();
      var validTo = certInfoList[i].getValidityNotAfter();
      certInfo['validityNotAfter'] = validTo.slice(0,4) + '-' + validTo.slice(4,6) + '-' + validTo.slice(6,8);
      certInfo['validityNotAfterFull'] = certInfoList[i].getValidityNotAfterFull();
      certInfo['remainDays'] = certInfoList[i].getRemainDays();
      certInfo['certUsage'] = certInfoList[i].getCertUsage();
      this.certList.push(certInfo);
    }
    if (this.selectedIndex === -1) {
      this.selectedIndex = 0;
    } else if (this.selectedIndex >= this.certList.length) {
      this.selectedIndex = this.certList.length - 1;
    }
    return true;
  } else {
    this.certList = null;
    this.selectedIndex = -1;
    return false;
  }
};
CertListManager.prototype.getCertCount = function(){
  if (this.certList) {
    return this.certList.length;
  } else {
    return 0;
  }
};
CertListManager.prototype.setSelectedIndex = function(index){
  if (this.certList !== null && this.certList.length > index){
    this.selectedIndex = index;
    return true;
  } else {
    return false;
  }
};
CertListManager.prototype.getCertList = function(){
  return this.certList;
};
CertListManager.prototype.getSelectedCert = function(){
  if (this.certList !== null && this.selectedIndex !== -1){
    return this.certList[this.selectedIndex];
  } else {
    return null;
  }
};
CertListManager.prototype.getSelectedIndex = function(){
  return this.selectedIndex;
};
CertListManager.prototype.getCert = function(index){
  if (this.certList !== null && this.certList.length > index){
    return this.certList[index];
  } else {
    return null;
  }
};
CertListManager.prototype.selectNext = function() {
  if (this.selectedIndex >= this.certList.length - 1) {
    return false;
  } else {
    this.selectedIndex++;
    return true;
  }
};
CertListManager.prototype.selectPrev = function() {
  if (this.selectedIndex <= 0) {
    return false;
  } else {
    this.selectedIndex--;
    return true;
  }
};
CertListManager.prototype.isCertSelected = function() {
  if (this.certList && this.selectedIndex >= 0 && this.selectedIndex < this.certList.length) {
    return true;
  } else {
    return false;
  }
};
CertListManager.prototype.isFirstSelected = function() {
  if (this.certList && this.selectedIndex === 0) {
    return true;
  } else {
    return false;
  }
};
CertListManager.prototype.isLastSelected = function() {
  if (this.certList && this.selectedIndex === this.certList.length - 1) {
    return true;
  } else {
    return false;
  }
};

function _openImportCertRelay() {
  _layoutManager.openLayoutCertSelection();
  _doNotDrawCertList = true;
  _handleMediaTap();
  _doNotDrawCertList = false;
  _layoutManager.openLayoutImportCertRelay();
  _handleImportRelayTap();
}

function _openCertSelection() {
  _layoutManager.openLayoutCertSelection();
  _handleMediaTap();
}

function _clearDriveContents(elemID) {
  // clear tbody & 이벤트 삭제
  var divDriveList = document.getElementById(elemID);
  var driveListTableBody = divDriveList.getElementsByTagName('tbody')[0];
  var tableRows = driveListTableBody.getElementsByTagName('tr');
  var rowCount = tableRows.length;
  for (var x = rowCount -1; x >= 0; x--) {
    tableRows[x].onclick = null;
    driveListTableBody.removeChild(tableRows[x]);
  }
}

var _onclickDriveContent = (function(elemID, driveID, contentText) {
  return function() {
    var divDriveList = document.getElementById(elemID);
    var driveListTableBody = divDriveList.getElementsByTagName('tbody')[0];
    var tableRows = driveListTableBody.getElementsByTagName('tr');
    var rowCount = tableRows.length;

    for (var x = rowCount -1; x >= 0; x--) {
      tableRows[x].className = '';
    }

    this.className = 'wcSelcOn';
    _driveSelection.setDriveIDSelected(driveID);
    _driveSelection.setContentText(contentText);
  };
});

function _drawDriveSelectionContents(elemID, mediaType, driveList, flexible) {
  var divDriveList = document.getElementById(elemID);
  var driveListTableBody = divDriveList.getElementsByTagName('tbody')[0];

  var totalIndexRow = driveList.length;

  flexible = flexible || false;

  if (totalIndexRow === 0) {
    return;
  } else if (totalIndexRow < 5) {
    if (flexible) {
      divDriveList.style.height = 'auto';
    }
    divDriveList.style.overflowY = 'hidden';
  } else {
    if (flexible) {
      divDriveList.style.height = '102px';
    }
    divDriveList.style.overflowY = 'scroll';
  }

  for (var indexRow = 0; indexRow < totalIndexRow; indexRow++) {
    var driveInfo = driveList[indexRow];
    var driveID = driveInfo.driveID;
    var description = (driveInfo.description !== '') ? driveInfo.description : '로컬 디스크';
    var contentText = _isMediaTypeDisk(mediaType) ? description + ' (' + driveInfo.driveID + ')' : driveInfo.description;

    var tr, td, div;
    tr = document.createElement('tr');
    td = document.createElement('td');
    div = document.createElement('div');
    div.className = 'wcDriveConts';
    div.appendChild( document.createTextNode(contentText) );
    td.appendChild(div);
    tr.appendChild(td);
    driveListTableBody.appendChild(tr);
    tr.onclick = _onclickDriveContent(elemID, driveID, contentText);
  }

  var tableRows = driveListTableBody.getElementsByTagName('tr');
  if (typeof tableRows[0].click === 'function') {
    tableRows[0].click();
  } else {
    _triggerMouseEvent(tableRows[0], 'click');
  }
}

var _columnTypes = {
  'normal':[
    {'key':'certUsage','name':'구분','width':'70px'},
    {'key':'subjectName','name':'사용자','width':'200px'},
    {'key':'validityNotAfter','name':'만료일','width':'75px'},
    {'key':'issuerName','name':'발급자','width':'75px'}
  ],
  'driveShown':[
    {'key':'driveName','name':'디스크','width':'61px'},
    {'key':'certUsage','name':'구분','width':'62px'},
    {'key':'subjectName','name':'사용자','width':'140px'},
    {'key':'validityNotAfter','name':'만료일','width':'75px'},
    {'key':'issuerName','name':'발급자','width':'75px'}
  ]
};

function _handleImportRelayTap() {
  _driveSelection.clear();
  var mediaType = _getMediaChecked('wc_import_relay_media_radio');

  var elemID = 'wc_import_relay_drive_list';
  _clearDriveContents(elemID);
  var reqGetDriveList = webcrypto.pka.getDriveList(mediaType);
  reqGetDriveList.onerror = function(errMsg) {alert(errMsg);};
  reqGetDriveList.oncomplete = function(result) {
    if (mediaType !== _getMediaChecked('wc_import_relay_media_radio')) {
      return;
    }
    var driveList = result;
    _drawDriveSelectionContents(elemID, mediaType, driveList);
  };
}

function _handleTargetMediaTap() {
  _driveSelection.clear();
  var mediaType = _getMediaChecked('wc_target_media_radio');

  var elemID = 'wc_target_drive_list';
  _clearDriveContents(elemID);
  var reqGetDriveList = webcrypto.pka.getDriveList(mediaType);
  reqGetDriveList.onerror = function(errMsg) {alert(errMsg);};
  reqGetDriveList.oncomplete = function(result) {
    if (mediaType !== _getMediaChecked('wc_target_media_radio')) {
      return;
    }
    var driveList = result;
    _drawDriveSelectionContents(elemID, mediaType, driveList);
  };
}

function _handleMediaTap() {
  _driveSelection.clear();
  document.getElementById('wc_cert_selection_password').value = '';

  var mediaValue = _getMediaChecked('wc_media_selection_radio');
  if (!mediaValue) {
    alert("사용할 수 있는 인증서 저장매체가 없습니다");
    return;
  }
  var support = webcrypto.pka.setMediaModule(mediaValue);
  if (support) {
    _mediaSelected = mediaValue;
  } else {
    alert(webcrypto.pka.getLastErrMsg());
    _setMediaChecked('wc_media_selection_radio', _mediaSelected);
    webcrypto.pka.setMediaModule(_mediaSelected);
    return;
  }

  var colType;
  if (_mediaSelected !== 'USB') {
    colType = 'normal';
  } else {
    colType = 'driveShown';
  }

  _releaseCertEvent('wc_cert_list_tbody', _certListManager, true);
  _clearCertList('wc_cert_list_thead', 'wc_cert_list_tbody');
  _certListManager.setCertList([]);

  _drawCertListColumn(colType, 'wc_cert_list_thead');
  if (_doNotDrawCertList === false) {
    if (_isMediaTypePKCS11(_mediaSelected)) {
      document.getElementById('wc_cert_selection_password').disabled = true;
      var elemID = _mediaSelected === 'HSM' ? 'wc_hsm_drive_selection' : 'wc_usim_drive_selection';
      _clearDriveContents(elemID);
      var reqGetDriveList = webcrypto.pka.getDriveList();
      reqGetDriveList.onerror = function(errMsg) {alert(errMsg);};
      reqGetDriveList.oncomplete = function(result) {
        var driveList = result;
        _drawDriveSelectionContents(elemID, _mediaSelected, driveList);
        _layoutManager.openLayoutPkcs11DriveSelection(_mediaSelected);
      };
    } else {
      document.getElementById('wc_cert_selection_password').disabled = false;
      _drawCertList();
    } 
  }
}

function _drawCertList() {
  var driveID = '';
  var colType = 'normal';

  if (_isMediaTypePKCS11(_mediaSelected)) {
    driveID = _driveSelection.getDriveIDSelected();
  } else if (_mediaSelected === 'USB') {
    colType = 'driveShown';
  }

  var currentMedia = _mediaSelected;

  _releaseCertEvent('wc_cert_list_tbody', _certListManager, true);
  _clearCertList('wc_cert_list_thead', 'wc_cert_list_tbody');
  _certListManager.setCertList([]);

  _drawCertListColumn(colType, 'wc_cert_list_thead');

  var reqCertInfoList = webcrypto.pka.getCertInfoList(driveID, _showExpiredCert);

  reqCertInfoList.onerror = function(errMsg) {
    alert(errMsg);
  };

  reqCertInfoList.oncomplete = function (result) {
    if (currentMedia !== _mediaSelected) {
      return;
    }

    _certListManager.setCertList(result);

    if (_certListManager.getCertCount() === 0) {
      if (_mediaSelected === 'HDD') {
        alert('하드디스크에 저장된 인증서가 없습니다.');
      } else if(_mediaSelected === 'USB') {
        alert('이동식디스크에 저장된 인증서가 없거나 연결된 이동식디스크가 없습니다.');
      }

      // TODO : 만약 확인 버튼에 대한 비활성화 처리를 해야한다면 작업한다.
      //document.getElementById('wc_cert_selection_ok').disabled = true;
      return;
    } else {
      // TODO : 만약 확인 버튼에 대한 활성화 처리를 해야한다면 작업한다.
      //document.getElementById('wc_cert_selection_ok').disabled = false;
    }

    _drawCertListContent(colType, 'wc_cert_list_tbody', _certListManager);
    _setCertEvent('wc_cert_list_tbody', _certListManager, true);
    _selectStateChanged('wc_cert_list_tbody', _certListManager);
  };
}

function _clearCertList(elemIdThead, elemIdTbody) {
  // 리스트 컬럼 clear
  var certListTableHead = document.getElementById(elemIdThead);
  var tableRows = certListTableHead.getElementsByTagName('tr');
  var rowCount = tableRows.length;
  for (var x = rowCount -1; x >= 0; x--) {
    certListTableHead.removeChild(tableRows[x]);
  }

  // 리스트 내용 clear
  var certListTableBody = document.getElementById(elemIdTbody);
  var tableRows = certListTableBody.getElementsByTagName('tr');
  var rowCount = tableRows.length;
  for (var x = rowCount -1; x >= 0; x--) {
    certListTableBody.removeChild(tableRows[x]);
  }
}

function _drawCertListColumn(colType, elemIdThead) {
  var certListTableHead = document.getElementById(elemIdThead);
  var columnNames = _columnTypes[colType];
  var tr, th, divTit, divMov;
  tr = document.createElement('tr');

  for (var indexCol = 0; indexCol < columnNames.length; indexCol++) {
    th = document.createElement('th');
    th.scope = 'col';
    th.style.width = columnNames[indexCol]['width'];
    divTit = document.createElement('div');
    divTit.className = 'wcCertListTit';
    divTit.appendChild(document.createTextNode( columnNames[indexCol]['name'] ));
    divMov = document.createElement('div');
    divMov.className = 'wcMoveBar';
    divTit.appendChild(divMov);
    th.appendChild(divTit);
    tr.appendChild(th);
  }
  certListTableHead.appendChild(tr);
}

function _drawCertListContent(colType, elemIdTbody, listManager) {
  var certListTableBody = document.getElementById(elemIdTbody);
  var columnNames = _columnTypes[colType];
  var totalIndexRow = listManager.getCertCount();

  if (totalIndexRow < 7) {
    //certListTableBody.parentNode.parentNode.style.overflowX = 'hidden';
    certListTableBody.parentNode.parentNode.style.overflowY = 'hidden';
  } else {
    //certListTableBody.parentNode.parentNode.style.overflowX = 'scroll';
    certListTableBody.parentNode.parentNode.style.overflowY = 'scroll';
  }

  for (var indexRow = 0; indexRow < totalIndexRow; indexRow++) {
    var certInfo = listManager.getCert(indexRow);

    var tr, td, div;
    tr = document.createElement('tr');
    tr.id = elemIdTbody + '_' + indexRow;

    for (var indexCol = 0; indexCol < columnNames.length; indexCol++) {
      td = document.createElement('td');
      div = document.createElement('div');
      div.className = 'wcCertListConts';
      div.style.width = columnNames[indexCol]['width'];
      div.appendChild( document.createTextNode( certInfo[columnNames[indexCol]['key']] ) );
      td.appendChild(div);
      tr.appendChild(td);
    }

    certListTableBody.appendChild(tr);
  }
}

var _onclickCertListText = (function(elemIdTbody, listManager, index) {
  return function() {
    if (listManager.setSelectedIndex(index) == true) {
      _selectStateChanged(elemIdTbody, listManager);
      var remainDays = Number(listManager.getSelectedCert().remainDays);
      // UI 에서의 선택 표시를 먼저 해주기 위해서 setTimeout으로 실행함
      if (remainDays < 0) {
        setTimeout(function() {
          alert('유효기간이 지난 인증서입니다.');
        }, 10);
      } else if (remainDays < 30) {
        setTimeout(function() {
          alert('선택한 인증서의 유효기간이 ' + remainDays + '일 남았습니다');
        }, 10);
      }
    }
  };
});

var _ondblclickCertListText = (function(elemIdTbody, listManager, index) {
  return function() {
    if (listManager.setSelectedIndex(index) === true) {
      _selectStateChanged(elemIdTbody, listManager);
      _openDetailCert();
    }
  };
});

function _releaseCertEvent(elemIdTbody, listManager, eventDBLClickSet) {
  if (eventDBLClickSet === undefined) {
    eventDBLClickSet = true;
  }

  var certCount = listManager.getCertCount();
  for (var certIndex = 0; certIndex < certCount; certIndex++) {
    var certListID = elemIdTbody + '_' +certIndex;
    var certElement = document.getElementById(certListID);
    if (certElement) {
      var index = certIndex;
      certElement.onclick = null;
      if (eventDBLClickSet === true) {
        certElement.ondblclick = null;
      }
    }
  }
}

function _setCertEvent(elemIdTbody, listManager, eventDBLClickSet) {
  if (eventDBLClickSet === undefined) {
    eventDBLClickSet = true;
  }

  var certCount = listManager.getCertCount();
  for (var certIndex = 0; certIndex < certCount; certIndex++) {
    var certListID = elemIdTbody + '_' + certIndex;
    var certElement = document.getElementById(certListID);
    if (certElement) {
      var index = certIndex;
      certElement.onclick = _onclickCertListText(elemIdTbody, listManager, index);
      if (eventDBLClickSet === true) {
        certElement.ondblclick = _ondblclickCertListText(elemIdTbody, listManager, index);
      }
    }
  }
}

function _selectStateChanged(elemIdTbody, listManager) {
  // 선택 상태가 바뀌었을 때 리스트의 색 토글 기능
  var indexSelected = listManager.getSelectedIndex();
  var certCount = listManager.getCertCount();
  for (var certIndex = 0; certIndex < certCount; certIndex++) {
    var certID = elemIdTbody + '_' +certIndex;
    var certElem = document.getElementById(certID);
    if (certIndex === indexSelected) {
      certElem.className = 'wcSelcOn';
    } else {
      certElem.className = '';
    }
  }
}

// 인증서 내보내기
function _exportCert() {
  var selectedCert = _certListManager.getSelectedCert();
  if (selectedCert === null) {
    alert('선택된 인증서가 없습니다.');
    return;
  }

  if (_isMediaTypeDisk(_mediaSelected)) {
    _layoutManager.openLayoutPasswordInput('_exportCert');
  } else {
    alert('선택한 저장매체에서는 지원하지 않는 기능입니다.');
  }
}

// 비밀번호 변경
function _changePassword() {
  if (_isMediaTypePKCS11(_mediaSelected) || _mediaSelected === 'Phone') {
    alert('선택한 저장매체에서는 지원하지 않는 기능입니다.');
    return;
  }

  var selectedCert = _certListManager.getSelectedCert();
  if (selectedCert === null) {
    alert('선택된 인증서가 없습니다.');
    return;
  }

  _layoutManager.openLayoutPasswordChange();
}

// 인증서 삭제
function _delCert(){
  var selectedCert = _certListManager.getSelectedCert();
  if (selectedCert === null) {
    alert('선택된 인증서가 없습니다.');
    return;
  }

  // NOTE : 스마트인증은 해당 기능을 일단 막아 놓음
  if (_mediaSelected === 'USIM') {
    alert('스마트폰 앱의 인증서 삭제 기능을 이용하십시오.');
    return;
  }

  if (_isMediaTypeDisk(_mediaSelected)) {
    _layoutManager.openLayoutPasswordInput('_delCert');
  } else if (_isMediaTypePKCS11(_mediaSelected)) {
    _layoutManager.openLayoutPkcs11Login(_mediaSelected, '_delCert');
  } else if (_mediaSelected === 'WEB') {
    var requestSel = webcrypto.pka.selectCert(selectedCert.subjectDN, selectedCert.driveID);
    requestSel.onerror = function(errMsg) {
      alert(errMsg);
      webcrypto.pka.releaseCertSelected();
    };
    requestSel.onsuccess = function() {
      var elemID = {'pin':'', 'ok':'', 'cancel':''};
      elemID['ok'] = 'wc_cert_selection_ok';
      elemID['cancel'] = 'wc_cert_selection_cancel';

      _removeSelectedCert(elemID);
    };
  } else {
    alert('선택한 저장매체에서는 지원하지 않는 기능입니다.');
  }
}

// 인증서 복사
function _copyCert() {
  var selectedCert = _certListManager.getSelectedCert();
  if (selectedCert === null) {
    alert('선택된 인증서가 없습니다.');
    return;
  }

  if (_isMediaTypeDisk(_mediaSelected) === false) {
    alert('선택한 저장매체에서는 지원하지 않는 기능입니다.');
    return;
  }

  _layoutManager.openLayoutCertCopy();

  _handleTargetMediaTap();
}

// 반드시 webcrypto.pka.selectCert 함수 호출 후 사용
function _removeSelectedCert(elemID) {
  if(confirm('선택된 인증서는 영구히 삭제됩니다. 인증서를 삭제하시겠습니까?')) {
    document.getElementById(elemID['ok']).disabled = true;
    document.getElementById(elemID['cancel']).disabled = true;
    if (elemID['pin'].length > 0) {  // pin 또는 비밀번호 입력창이 뜬 경우에 해당
      document.getElementById(elemID['pin']).readOnly = true;
    }

    var requestRm = webcrypto.pka.removeCert();
    requestRm.onerror = function(errMsg) {
      alert(errMsg);
      webcrypto.pka.releaseCertSelected();

      document.getElementById(elemID['ok']).disabled = false;
      document.getElementById(elemID['cancel']).disabled = false;
      if (elemID['pin'].length > 0) {  // pin 또는 비밀번호 입력창이 뜬 경우에 해당
        document.getElementById(elemID['pin']).readOnly = false;
        _layoutManager.closeLayout();
      }
    };
    requestRm.onsuccess = function () {
      if (_certListManager.isLastSelected()) {
        _certListManager.selectPrev();
      }
      alert('선택한 인증서를 삭제하였습니다.');
      _drawCertList();
      webcrypto.pka.releaseCertSelected();

      document.getElementById(elemID['ok']).disabled = false;
      document.getElementById(elemID['cancel']).disabled = false;
      if (elemID['pin'].length > 0) {  // pin 또는 비밀번호 입력창이 뜬 경우에 해당
        document.getElementById(elemID['pin']).readOnly = false;
        _layoutManager.closeLayout();
      }
    };

    return true;
  } else {
    webcrypto.pka.releaseCertSelected();
    return false;
  }
}

function _excuteCertSelectionCallback(pw) {
  var obj = {onsuccess: null, onerror: null};

  var selectedCert = _certListManager.getSelectedCert();
  var requestSel = webcrypto.pka.selectCert(selectedCert.subjectDN, selectedCert.driveID);
  requestSel.onerror = function(errMsg) {
    if (typeof obj.onerror === 'function') {
      obj.onerror(errMsg);
    }
  };
  requestSel.onsuccess = function() {
    var requestChkPw = webcrypto.pka.checkPw(pw);
    requestChkPw.onerror = function(errMsg) {
      webcrypto.pka.releaseCertSelected();

      if (typeof obj.onerror === 'function') {
        obj.onerror(errMsg);
      }
    };
    requestChkPw.onsuccess = function() {
      if (typeof _callbackObj.onsuccess === 'function') {
        _callbackObj.onsuccess();
      }
      _callbackObj.onsuccess = null;

      if (typeof obj.onsuccess === 'function') {
        obj.onsuccess();
      }

      _layoutManager.closeLayout();
    };
  };

  return obj;
}

function _onOkCertSelection() {
  var selectedCert = _certListManager.getSelectedCert();
  if (selectedCert === null) {
    alert('선택된 인증서가 없습니다.');
    return;
  }

  if (_isMediaTypePKCS11(_mediaSelected)) {
    _layoutManager.openLayoutPkcs11Login(_mediaSelected, '_onOkCertSelection');
    return;
  } else {
    if (document.getElementById('wc_cert_selection_password').value === '') {
      alert('인증서 비밀번호를 입력하십시오.');
      document.getElementById('wc_cert_selection_password').focus();
      return;
    }

    var pw = document.getElementById('wc_cert_selection_password').value;
    document.getElementById('wc_cert_selection_password').value = '';
    var req = _excuteCertSelectionCallback(pw);
    req.onerror = function(errMsg) {
      alert(errMsg);
      webcrypto.pka.releaseCertSelected();
      document.getElementById('wc_cert_selection_password').focus();
    };
  }
}

function _onOkPkcs11Login(mediaType, functionName) {
  var elemID = {'pin':'', 'ok':'', 'cancel':''};
  var errMsgPin = '';

  if (mediaType === 'HSM') {
    elemID['pin'] = 'wc_hsm_login_pin';
    elemID['ok'] = 'wc_hsm_login_ok';
    elemID['cancel'] = 'wc_hsm_login_cancel';
    errMsgPin = '보안토큰 비밀번호를 입력하십시오.';
  } else if (mediaType === 'USIM') {
    elemID['pin'] = 'wc_usim_login_pin';
    elemID['ok'] = 'wc_usim_login_ok';
    elemID['cancel'] = 'wc_usim_login_cancel';
    errMsgPin = '스마트인증 비밀번호를 입력하십시오.';
  }

  if (document.getElementById(elemID['pin']).value === '') {
    alert(errMsgPin);
    document.getElementById(elemID['pin']).focus();
    return;
  }

  var pkcs11Pin = document.getElementById(elemID['pin']).value;
  document.getElementById(elemID['pin']).value = '';

  switch(functionName) {
    case '_onOkCertSelection':
      var req = _excuteCertSelectionCallback(pkcs11Pin);
      req.onerror = function(errMsg) {
        alert(errMsg);
        webcrypto.pka.releaseCertSelected();
        _layoutManager.closeLayout();
      };
      req.onsuccess = function() {
        _layoutManager.closeLayout();
      };
    break;

    case '_delCert':
      var selectedCert = _certListManager.getSelectedCert();
      var requestSel = webcrypto.pka.selectCert(selectedCert.subjectDN, selectedCert.driveID);
      requestSel.onerror = function(errMsg) {
        alert(errMsg);
        webcrypto.pka.releaseCertSelected();
        _layoutManager.closeLayout();
      };
      requestSel.onsuccess = function() {
        var requestChkPw = webcrypto.pka.checkPw(pkcs11Pin);
        requestChkPw.onerror = function(errMsg) {
          alert(errMsg);
          webcrypto.pka.releaseCertSelected();
          _layoutManager.closeLayout();
        };
        requestChkPw.onsuccess = function() {
          if (_removeSelectedCert(elemID) === false) {
            _layoutManager.closeLayout();
          }
        };
      };
    break;

    case '_onOkImportCert':
      var pfxPw = document.getElementById('wc_import_pfx_password').value;
      document.getElementById('wc_import_pfx_password').value = '';

      var certPw = document.getElementById('wc_import_cert_password').value;
      document.getElementById('wc_import_cert_password').value = '';

      var driveID = _driveSelection.getDriveIDSelected();
      var reqImport = webcrypto.pka.importPfx(pfxPw, driveID, certPw, pkcs11Pin);

      document.getElementById(elemID['pin']).readOnly = true;
      document.getElementById(elemID['ok']).disabled = true;
      document.getElementById(elemID['cancel']).disabled = true;

      reqImport.onerror = function(errMsg) {
        alert(errMsg);

        document.getElementById(elemID['pin']).readOnly = false;
        document.getElementById(elemID['ok']).disabled = false;
        document.getElementById(elemID['cancel']).disabled = false;

        _layoutManager.closeLayout();
      };
      reqImport.onsuccess = function() {
        alert('인증서 가져오기에 성공하였습니다.');
        _drawCertList();

        document.getElementById(elemID['pin']).readOnly = false;
        document.getElementById(elemID['ok']).disabled = false;
        document.getElementById(elemID['cancel']).disabled = false;

        _layoutManager.closeLayout();
      };
    break;

    case '_onOkCertCopy':
      var driveID = _driveSelection.getDriveIDSelected();
      var reqCopy = webcrypto.pka.copyCert(mediaType, driveID, pkcs11Pin);

      document.getElementById(elemID['pin']).readOnly = true;
      document.getElementById(elemID['ok']).disabled = true;
      document.getElementById(elemID['cancel']).disabled = true;

      reqCopy.onerror = function(errMsg) {
        alert(errMsg);

        document.getElementById(elemID['pin']).readOnly = false;
        document.getElementById(elemID['ok']).disabled = false;
        document.getElementById(elemID['cancel']).disabled = false;

        document.getElementById(elemID['pin']).focus();
      };
      reqCopy.onsuccess = function() {
        alert('인증서 복사에 성공하였습니다.');
        _drawCertList();

        document.getElementById(elemID['pin']).readOnly = false;
        document.getElementById(elemID['ok']).disabled = false;
        document.getElementById(elemID['cancel']).disabled = false;

        webcrypto.pka.releaseCertSelected();
        _layoutManager.closeLayout();
      };
    break;

    default:
      alert('처리할 작업이 없습니다.');
      webcrypto.pka.releaseCertSelected();
      _layoutManager.closeLayout();
    break;
  }
}

function _onOkPasswordInput(functionName) {
  var elemID = {'pin':'', 'ok':'', 'cancel':''};
  elemID['pin'] = 'wc_pw_input_password';
  elemID['ok'] = 'wc_pw_input_ok';
  elemID['cancel'] = 'wc_pw_input_cancel';

  if (document.getElementById(elemID['pin']).value === '') {
    alert('인증서 비밀번호를 입력하십시오.');
    document.getElementById(elemID['pin']).focus();
    return;
  }

  var certPw = document.getElementById(elemID['pin']).value;
  document.getElementById(elemID['pin']).value = '';

  switch(functionName) {
    case '_delCert':
      var selectedCert = _certListManager.getSelectedCert();
      var requestSel = webcrypto.pka.selectCert(selectedCert.subjectDN, selectedCert.driveID);
      requestSel.onerror = function(errMsg) {
        alert(errMsg);
        webcrypto.pka.releaseCertSelected();
        _layoutManager.closeLayout();
      };
      requestSel.onsuccess = function() {
        var requestChkPw = webcrypto.pka.checkPw(certPw);
        requestChkPw.onerror = function(errMsg) {
          alert(errMsg);
          webcrypto.pka.releaseCertSelected();
          _layoutManager.closeLayout();
        };
        requestChkPw.onsuccess = function() {
          if (_removeSelectedCert(elemID) === false) {
            _layoutManager.closeLayout();
          }
        };
      };
    break;

    case '_exportCert':
      var selectedCert = _certListManager.getSelectedCert();
      var requestSel = webcrypto.pka.selectCert(selectedCert.subjectDN, selectedCert.driveID);
      requestSel.onerror = function(errMsg) {
        alert(errMsg);
        webcrypto.pka.releaseCertSelected();
        _layoutManager.closeLayout();
      };
      requestSel.onsuccess = function() {
        var requestChkPw = webcrypto.pka.checkPw(certPw);
        requestChkPw.onerror = function(errMsg) {
          alert(errMsg);
          webcrypto.pka.releaseCertSelected();
          _layoutManager.closeLayout();
        };
        requestChkPw.onsuccess = function() {
          var reqExport = webcrypto.pka.exportCert();
          reqExport.onerror = function(errMsg) {
            alert(errMsg);
            webcrypto.pka.releaseCertSelected();
            _layoutManager.closeLayout();
          };
          reqExport.onsuccess = function() {
            webcrypto.pka.releaseCertSelected();
            _layoutManager.closeLayout();
          };
        };
      };
    break;

    case '_onOkCertCopy':
      var selectedCert = _certListManager.getSelectedCert();
      var requestSel = webcrypto.pka.selectCert(selectedCert.subjectDN, selectedCert.driveID);
      requestSel.onerror = function(errMsg) {
        alert(errMsg);
        webcrypto.pka.releaseCertSelected();
        _layoutManager.closeLayout();
      };
      requestSel.onsuccess = function() {
        var requestChkPw = webcrypto.pka.checkPw(certPw);
        requestChkPw.onerror = function(errMsg) {
          alert(errMsg);
          document.getElementById(elemID['pin']).focus();
        };
        requestChkPw.onsuccess = function() {
          _layoutManager.closeLayout();
          var mediaType = _getMediaChecked('wc_target_media_radio');
          if (_isMediaTypePKCS11(mediaType)) {
            _layoutManager.openLayoutPkcs11Login(mediaType, functionName);
          }else {
            var selectedCert = _certListManager.getSelectedCert();
            var requestSel = webcrypto.pka.selectCert(selectedCert.subjectDN, selectedCert.driveID);
            requestSel.onerror = function(errMsg) {
              alert(errMsg);
              webcrypto.pka.releaseCertSelected();
              _layoutManager.closeLayout();
            };
            requestSel.onsuccess = function() {
              var targetDriveID = _driveSelection.getDriveIDSelected();
              var reqCopy = webcrypto.pka.copyCert(mediaType, targetDriveID);
              reqCopy.onerror = function(errMsg) {
                alert(errMsg);
                webcrypto.pka.releaseCertSelected();
                _layoutManager.closeLayout();
              };
              reqCopy.onsuccess = function() {
                alert('인증서 복사에 성공하였습니다.');
                _drawCertList();
                webcrypto.pka.releaseCertSelected();
              };
            };
          }
        };
      };
    break;

    default:
      alert('처리할 작업이 없습니다.');
      webcrypto.pka.releaseCertSelected();
      _layoutManager.closeLayout();
    break;
  }
}

function _onOkImportCertRelay() {
  if (_isMediaTypePKCS11(_mediaSelected)) {
    _layoutManager.closeLayout();
    _layoutManager.openLayoutPkcs11Login(_mediaSelected, '_onOkImportCert');
    return;
  }

  var driveID = '';
  if (_mediaSelected === 'USB') {
    driveID = _driveSelection.getDriveIDSelected();
    if (driveID === '') {
      alert('선택된 디스크가 없습니다.');
      return;
    }

    var contentText = _driveSelection.getContentText();
    if (confirm('선택하신 ' + contentText + ' 디스크로 인증서를 저장하시겠습니까?') === false) {
      return;
    }
  }
  var req = webcrypto.pka.importCertKeyRelay(driveID, _pfxRelay, _authcode, '');

  document.getElementById('wc_import_relay_ok').disabled = true;
  document.getElementById('wc_import_relay_cancel').disabled = true;

  req.onerror = function(errMsg) {
    alert(errMsg);

    document.getElementById('wc_import_relay_ok').disabled = false;
    document.getElementById('wc_import_relay_cancel').disabled = false;

    _layoutManager.closeLayout();
  };
  req.onsuccess = function() {
    alert('인증서 가져오기에 성공하였습니다.');

    document.getElementById('wc_import_relay_ok').disabled = false;
    document.getElementById('wc_import_relay_cancel').disabled = false;

    _layoutManager.closeLayout();
    _releaseCertEvent('wc_cert_list_tbody', _certListManager, true);
    _clearCertList('wc_cert_list_thead', 'wc_cert_list_tbody');
    _certListManager.setCertList([]);
    _drawCertList();
  };
}

function _onOkCertCopy() {
  var targetDriveID = _driveSelection.getDriveIDSelected();
  if (targetDriveID === '') {
    alert('선택된 디스크 및 모듈이 없습니다.');
    return;
  }
  _layoutManager.closeLayout();
  _layoutManager.openLayoutPasswordInput('_onOkCertCopy');
}

function passwordCheck() {

  var newPassword1 = document.getElementById("wc_pw_change_new1").value;

  // 길이
  if (newPassword1.length < 10) { 
    alert("비밀번호는 숫자, 영문(대/소), 특수문자 조합으로 10자리 이상 사용해야 합니다."); 
    return false;
  }

  // 영문(대/소), 숫자, 특수문자 3종 이상 혼용
  var chk = 0;
  if (newPassword1.search(/[0-9]/g) != -1) {
    chk++; //숫자 포함 확인
  }
  if (newPassword1.search(/[a-z]/g)  != -1) {
    chk++; //소문자 포함 확인
  }
  if (newPassword1.search(/[A-Z]/g)  != -1) {
    chk++; //대문자 포함 확인
  }
  if (newPassword1.search(/[!@#$%^&*()?_~]/g) != -1) {
    chk++; //특수문자 포함 확인
  }
  if (chk < 3) {
    alert("비밀번호는 숫자, 영문(대/소), 특수문자를 3가지이상 혼용하여야 합니다.");
    return false;
  }

  if (newPassword1.search(/[\"\'\\|]/g) != -1) {
    // ",',\,| 사용 불가
    alert("사용 할 수 없는 문자가 포함되어 있음.");
    return false;
  }

  // 3회 이상 동일한 문자/숫자, 연속된 문자
  var SamePass_0 = 0; //동일문자 카운트
  var SamePass_1 = 0; //연속성(321,cba) 카운트
  var SamePass_2 = 0; //연속성(123,abc) 카운트

  var chr_pass_0;
  var chr_pass_1;
  var chr_pass_2;

  for (var i = 0; i < newPassword1.length - 2; i++) {
    chr_pass_0 = newPassword1.charAt(i);
    chr_pass_1 = newPassword1.charAt(i + 1);
    chr_pass_2 = newPassword1.charAt(i + 2);

    //동일문자 카운트
    if (chr_pass_0 == chr_pass_1 && chr_pass_1 == chr_pass_2) {
      alert("동일문자를 3번 이상 사용할 수 없습니다.");
      return false;
    }

    //연속성(321,cba) 카운드
    if (chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1) {
      alert("연속된 문자열(123 또는 321, abc, cba 등)을\n 3자 이상 사용 할 수 없습니다.");
      return false;
    }

    //연속성(123,abc) 카운드
    if (chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1) {
      alert("연속된 문자열(123 또는 321, abc, cba 등)을\n 3자 이상 사용 할 수 없습니다.");
      return false;
    }
  }

  return true;
}

function _onOkPasswordChange() {
  if (document.getElementById('wc_pw_change_old').value === '') {
    alert('변경전 비밀번호를 입력하십시오.');
    document.getElementById('wc_pw_change_old').focus();
    return;
  } else if (document.getElementById('wc_pw_change_new1').value === '') {
    alert('변경후 비밀번호를 입력하십시오.');
    document.getElementById('wc_pw_change_new1').focus();
    return;
  } else if (document.getElementById('wc_pw_change_new2').value === '') {
    alert('변경후 비밀번호를 재입력하십시오.');
    document.getElementById('wc_pw_change_new2').focus();
    return;
  }

  var pwOld = document.getElementById('wc_pw_change_old').value;
  var pwNew1 = document.getElementById('wc_pw_change_new1').value;
  var pwNew2 = document.getElementById('wc_pw_change_new2').value;

  // 1. 비밀번호 변경 시, 비밀번호 조합규칙 적용 (확정, 근거: 미래창조과학부 ‘공인인증서 비밀번호 체계 강화대책’ 권고, 2014년 10월 시행 )
  // o 영어 대/소문자 구분
  // o 영문자/숫자/특수문자 중 3가지 이상의 조합  (각 최소 1자리 이상 포함)
  // o 최소 10자리 이상
  // o 특수문자 중 “, ’, \, | (4가지) 제외
  if (passwordCheck() == false) {
    alert("패스워드 규칙에 맞지 않습니다.");
    return;
  }

  if (pwNew1 !== pwNew2) {
    alert('변경후 비밀번호가 일치하지 않습니다.');
    document.getElementById('wc_pw_change_new1').value = '';
    document.getElementById('wc_pw_change_new2').value = '';
    document.getElementById('wc_pw_change_new1').focus();
    return;
  }

  var selectedCert = _certListManager.getSelectedCert();
  var requestSel = webcrypto.pka.selectCert(selectedCert.subjectDN, selectedCert.driveID);
  requestSel.onerror = function(errMsg) {
    alert(errMsg);
  };
  requestSel.onsuccess = function() {
    var req = webcrypto.pka.changePassword(pwOld, pwNew1);
    req.onerror = function(errMsg) {
      alert(errMsg);
      document.getElementById('wc_pw_change_old').value = '';
      document.getElementById('wc_pw_change_new1').value = '';
      document.getElementById('wc_pw_change_new2').value = '';
      document.getElementById('wc_pw_change_old').focus();
    };
    req.onsuccess = function() {
      alert('인증서 비밀번호 변경에 성공하였습니다.');
      webcrypto.pka.releaseCertSelected();
      _layoutManager.closeLayout();
    };
  };
}

// 인증서 가져오기 관련 API
function _openImportCert() {
  if (_mediaSelected === 'Phone') {
    alert('선택한 저장매체에서는 지원하지 않는 기능입니다.');
    return;
  } else if (_mediaSelected === 'USIM') {
    alert('스마트폰 앱의 인증서 가져오기 기능을 이용하십시오.');
    return;
  }

  webcrypto.pka.openPfxFileDialog(_openLayoutImportCert);
}

function _openLayoutImportCert() {
  _clearDriveContents('wc_portable_drive_list');
  document.getElementById('wc_portable_drive_list').parentNode.style.display = 'none';
  document.getElementById('wc_import_cert_password_input').style.display = 'none';

  if (_mediaSelected === 'USB') {
    var reqGetDriveList = webcrypto.pka.getDriveList();
    reqGetDriveList.onerror = function(errMsg) {alert(errMsg);};
    reqGetDriveList.oncomplete = function(result) {
      var driveList = result;
      document.getElementById('wc_portable_drive_list').parentNode.style.display = 'block';
      var flexible = true;
      _drawDriveSelectionContents('wc_portable_drive_list', _mediaSelected, driveList, flexible);
      _layoutManager.openLayoutImportCert();
    };
  } else if (_isMediaTypePKCS11(_mediaSelected)) {
    document.getElementById('wc_import_cert_password_input').style.display = 'block';
    _layoutManager.openLayoutImportCert();
  } else {
    _layoutManager.openLayoutImportCert();
  }
}

function _onOkImportCert() {
  var pfxPw = document.getElementById('wc_import_pfx_password').value;

  if (pfxPw === '') {
    alert('PFX 비밀번호를 입력하십시오.');
    document.getElementById('wc_import_pfx_password').focus();
    return;
  }

  if (_isMediaTypePKCS11(_mediaSelected)) {
    _layoutManager.closeLayout();
    _layoutManager.openLayoutPkcs11Login(_mediaSelected, '_onOkImportCert');
    return;
  }

  document.getElementById('wc_import_pfx_password').value = '';
  document.getElementById('wc_import_cert_password').value = '';

  var driveID = '';
  if (_mediaSelected === 'USB') {
    driveID = _driveSelection.getDriveIDSelected();
    if (driveID === '') {
      alert('선택된 디스크가 없습니다.');
      return;
    }

    var contentText = _driveSelection.getContentText();
    if (confirm('선택하신 ' + contentText + ' 디스크로 인증서를 저장하시겠습니까?') === false) {
      return;
    }
  }

  var certPw = '', pkcs11Pin = '';
  var req = webcrypto.pka.importPfx(pfxPw, driveID, certPw, pkcs11Pin);

  document.getElementById('wc_import_pfx_password').readOnly = true;
  document.getElementById('wc_import_cert_password').readOnly = true;
  document.getElementById('wc_import_cert_ok').disabled = true;
  document.getElementById('wc_import_cert_cancel').disabled = true;

  req.onerror = function(errMsg) {
    alert(errMsg);

    document.getElementById('wc_import_pfx_password').readOnly = false;
    document.getElementById('wc_import_cert_password').readOnly = false;
    document.getElementById('wc_import_cert_ok').disabled = false;
    document.getElementById('wc_import_cert_cancel').disabled = false;

    _layoutManager.closeLayout();
  };
  req.onsuccess = function() {
    alert('인증서 가져오기에 성공하였습니다.');

    document.getElementById('wc_import_pfx_password').readOnly = false;
    document.getElementById('wc_import_cert_password').readOnly = false;
    document.getElementById('wc_import_cert_ok').disabled = false;
    document.getElementById('wc_import_cert_cancel').disabled = false;

    _layoutManager.closeLayout();
    _drawCertList();
  };
}

// UI에 인증서 유효기간 체크하는 부분이 미포함. 필요 없음이 확정되면 삭제한다.
function _checkValidityNotAfter(certInfo) {
  var year = Number(certInfo.validityNotAfterFull.slice(0,4));
  var month = Number(certInfo.validityNotAfterFull.slice(4,6));
  var date = Number(certInfo.validityNotAfterFull.slice(6,8));
  var hours = Number(certInfo.validityNotAfterFull.slice(8,10));
  var minutes = Number(certInfo.validityNotAfterFull.slice(10,12));
  var seconds = Number(certInfo.validityNotAfterFull.slice(12,14));

  // 만료일
  var dateExpired = new Date(month + '/' + date + '/' + year + ' ' + hours + ':' + minutes + ':' + seconds);

  // 만료일 한달전
  var dateExpiredBeforeOneMonth = new Date(((month-2)%12+1) + '/' + date + '/' + year + ' ' + hours + ':' + minutes + ':' + seconds);

  // 현재 날짜 및 시간
  var today = new Date();

  var result = '';
  // 만료일이 지났는지 검사
  if (today > dateExpired) {
    result = 'expired';

  // 만료일이 임박했는지 검사
  } else if (today > dateExpiredBeforeOneMonth) {
    result = 'willBeExpire';

  // 유효기간이 충분한 경우
  } else {
    result = 'normal';
  }
  return result;
}

// 인증서 자세히보기 관련 API 시작.
function _openDetailCert() {
  var selectedCert = _certListManager.getSelectedCert();
  if (selectedCert === null) {
    alert("선택된 인증서가 없습니다.");
    return;
  }

  var requestSel = webcrypto.pka.selectCert(selectedCert.subjectDN, selectedCert.driveID);
  requestSel.onerror = function(errMsg) { alert(errMsg); };
  requestSel.onsuccess = function() {
    var reqDetail = webcrypto.pka.getCertDetail(_verifyCert);
    reqDetail.onerror = function(errMsg) {
      alert(errMsg);
      webcrypto.pka.releaseCertSelected();
    };
    reqDetail.oncomplete = function(result) {
      // 세부내용 그리기
      _drawDetailBase(result);
      _drawDetailContents(result);
      _layoutManager.openLayoutDetail();

      // 레이아웃 컨트롤들 위치 상태 초기화
      _selectDetailContents();
      document.getElementById('wc_detail_info').scrollLeft = 0;
      document.getElementById('wc_detail_info').scrollTop = 0;
      var tableRows = document.getElementById('wc_detail_contents').getElementsByTagName('tr');
      if (typeof tableRows[0].click === 'function') {
        tableRows[0].click();
      } else {
        _triggerMouseEvent(tableRows[0], 'click');
      }

      _selectDetailBase();
      webcrypto.pka.releaseCertSelected();
    };
  };
}

function _selectDetailBase() {
  document.getElementById('wc_detail_base_tab').parentNode.className="wcTap01 wcSelcOn";
  document.getElementById('wc_detail_contents_tab').parentNode.className="wcTap02";
}
function _selectDetailContents() {
  document.getElementById('wc_detail_contents_tab').parentNode.className="wcTap02 wcSelcOn";
  document.getElementById('wc_detail_base_tab').parentNode.className="wcTap01";
}

function _leadingZeros(num, digits){
  var zero = '';
  num = num.toString();
  if(num.length < digits){
    for (var i = 0 ; i < digits - num.length ; ++i){
      zero += '0';
    }
  }
  return zero + num;
}

function _drawDetailBase(details) {
  var subject = '',
      issuer = '',
      validFrom = '',
      validTo = '',
      title = '';

  for (var indexDetails = 0 ; indexDetails < details.length ; indexDetails++) {
    var field = details[indexDetails].field;
    var value = details[indexDetails].value;
    var names;

    if (field === '주체' || field === 'Subject') {
      names = new Array();
      names = value.split(',');
      for (var indexNames = 0; indexNames < names.length; indexNames++) {
        if (names[indexNames].indexOf('cn=') !== -1) {
          subject = names[indexNames].slice(3);
        }
      }
    } else if (field === '발급자' || field === 'Issuer') {
      names = new Array();
      names = value.split(',');
      for (var indexNames = 0; indexNames < names.length; indexNames++) {
        if (names[indexNames].indexOf('o=') !== -1) {
          issuer = names[indexNames].slice(2);
        }
      }
      issuer = _getMessage(issuer);
    } else if (field === '유효기간(시작)' || field === 'Validity Not Befor') {
      validFrom = value.slice(0,4) + '-' + value.slice(4,6) + '-' + value.slice(6,8) + ' ' + value.slice(8,10) + ':' + value.slice(10,12) + ':' + value.slice(12,14);
    } else if (field === '유효기간(끝)' || field === 'Validity Not After') {
      validTo = value.slice(0,4) + '-' + value.slice(4,6) + '-' + value.slice(6,8) + ' ' + value.slice(8,10) + ':' + value.slice(10,12) + ':' + value.slice(12,14);
    } else if (field === 'validate') {
      title = value;
    }
  }

  document.getElementById('wc_detail_base_subject').innerHTML = subject;
  document.getElementById('wc_detail_base_subject').innerText = subject;
  document.getElementById('wc_detail_base_issuer').innerHTML = issuer;
  document.getElementById('wc_detail_base_issuer').innerText = issuer;
  document.getElementById('wc_detail_base_validity').innerHTML = validFrom + ' ~ ' + validTo;
  document.getElementById('wc_detail_base_validity').innerText = validFrom + ' ~ ' + validTo;
  document.getElementById('wc_base_info_title').innerHTML = title;
  document.getElementById('wc_base_info_title').innerText = title;

  var pcDate = new Date();
  var pcTime = pcDate.getFullYear().toString() + '-' +
    _leadingZeros(pcDate.getMonth() + 1, 2) + '-' +
    _leadingZeros(pcDate.getDate(), 2) + ' ' +
    _leadingZeros(pcDate.getHours(), 2) + ':' +
    _leadingZeros(pcDate.getMinutes(), 2) + ':' +
    _leadingZeros(pcDate.getSeconds(), 2);

  document.getElementById('wc_detail_base_time').innerHTML = pcTime;
  document.getElementById('wc_detail_base_time').innerText = pcTime;
}

var _onclickDetailContent = (function(value) {
  return function() {
    var tbody = document.getElementById('wc_detail_contents');
    var tableRows = tbody.getElementsByTagName('tr');
    var rowCount = tableRows.length;
    for (var x = rowCount -1; x >= 0; x--) {
      tableRows[x].className = '';
    }

    this.className = 'wcSelcOn';
    document.getElementById('wc_detail_contents_value').innerHTML = value;
    document.getElementById('wc_detail_contents_value').innerText = value;
  };
});

function _drawDetailContents(details) {
  var tbody = document.getElementById('wc_detail_contents');
  document.getElementById('wc_detail_info').scrollLeft = 0;
  document.getElementById('wc_detail_info').scrollTop = 0;

  // clear 테이블 & 이벤트 삭제
  var tableRows = tbody.getElementsByTagName('tr');
  var rowCount = tableRows.length;
  for (var x = rowCount -1; x >= 0; x--) {
    tableRows[x].onclick = null;
    tbody.removeChild(tableRows[x]);
  }

  for (var i = 0 ; i < details.length ; i++){
    var field = details[i].field;
    var value = details[i].value;

    if (field === '유효기간(시작)' || field === 'Validity Not Befor') {
      value = value.slice(0,4) + '-' + value.slice(4,6) + '-' + value.slice(6,8) + ' ' + value.slice(8,10) + ':' + value.slice(10,12) + ':' + value.slice(12,14);
    } else if (field === '유효기간(끝)' || field === 'Validity Not After') {
      value = value.slice(0,4) + '-' + value.slice(4,6) + '-' + value.slice(6,8) + ' ' + value.slice(8,10) + ':' + value.slice(10,12) + ':' + value.slice(12,14);
    } else if (field === 'validate')  {
      continue;
    }

    var tr, td, div;
    tr = document.createElement('tr');

    td = document.createElement('td');
    div = document.createElement('div');
    div.className = 'wcDetailConts';
    div.style.width = '80px';
    div.innerHTML = field;
    div.innerText = field;
    td.appendChild(div);
    tr.appendChild(td);

    td = document.createElement('td');
    div = document.createElement('div');
    div.className = 'wcDetailConts';
    div.style.width = '270px';
    div.innerHTML = value;
    div.innerText = value;
    td.appendChild(div);
    tr.appendChild(td);

    tbody.appendChild(tr);
    tr.onclick = _onclickDetailContent(value);
  }

  document.getElementById('wc_detail_contents_value').innerHTML = '';
  document.getElementById('wc_detail_contents_value').innerText = '';
}

})();