<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@include file="agentInfo.jsp"%>
<%
    
    
    
    String clientIp = request.getRemoteAddr();
    String userAgent = request.getHeader("User-Agent");
    String downloadPage = AUTH_URL + "/authentication/pki/download/download.html";
    
    System.out.println("Auth url : " + AUTH_URL);
    System.out.println("agent id : " + agentId);
    System.out.println("clientIp : " + clientIp);
    System.out.println("userAgent : " + userAgent);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="<%=AUTH_URL%>/resources/js/webcrypto/ui_template/css/certificate_ui.css?v=3.0.4.5">

        <!-- js 로딩 순서 바꾸면 안됨 -->
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/forge.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/jsbn.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/util.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/sha1.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/sha256.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/sha512.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/asn1.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/cipher.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/cipherModes.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/seed.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/aes.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/prng.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/random.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/rsa.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/pkcs1.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/oids.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/des.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/rc2.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/pkcs7.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/pkcs7asn1.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/hmac.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/pbkdf2.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/x509.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/pbe.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/forge/pkcs12.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/json/json2.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/webcrypto/common/webcrypto.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/webcrypto/common/webcrypto_msg.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/webcrypto/common/webcrypto_addon.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/webcrypto/e2e/webcrypto_e2e.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/webcrypto/e2e/webcrypto_e2e_addon.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/webcrypto/pka/webcrypto_pka.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/webcrypto/pka/webcrypto_pka_addon.js?v=3.0.4.5" charset="UTF-8"></script>
        <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/ui_template/ui_template.js?v=3.0.4.5" charset="UTF-8"></script>
        
        <script type="text/javascript" src="jquery-3.1.1.min.js"></script>
        <script type="text/javascript">
            function includeWebCryptoPfxFileIframe() {
                // PKA의 인증서 가져오기에서 사용될 iframe을 동적으로 웹페이지에 추가함
                webcrypto.loadPfxFileIframe('<%=AUTH_URL%>/resources/js/webcrypto/js/webcrypto/pka/file_open_frame.html');
            }
            
            var addEvent = addEvent || (function(_window) {        
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
                
            function setupWebCryptoPKA() {
                // NOTE : 버전 체크 기능이 필요하면 활용하여 적용하고 불필요하면 주석 부분 모두 삭제할 것 (페이지 사이즈 감소 측면)
                /*
                // 각 모듈 버전 체크
                var verPka = webcrypto.pka.getVersion().verPka;
                alert('WC-PKA 버전 : ' + verPka);

                var verE2e = webcrypto.e2e.getVersion().verE2e;
                alert('WC-E2E 버전 : ' + verE2e);
                */

                // WC-PKA의 PFX 파일 다이얼로그를 위한 iframe include
                includeWebCryptoPfxFileIframe();

                // UI 초기 설정
                webcrypto.pka.ui.initialize();

                // 설치 프로그램과 통신을 위한 URL 초기화 및 동작 여부 확인
                // whitelist 는 지원팀에서 추가로 입력해야함. whitelist 를 만드는 툴로 생성된 base64 값을 입력할 것.
                //var whitelist = "";
                //var reqInit = webcrypto.addon.initializeCorsUrl(1500, whitelist);  // 입력 변수는 응답 대기 시간 msec 단위
                var reqInit = webcrypto.addon.initializeCorsUrl(1500);  // 입력 변수는 응답 대기 시간 msec 단위
                reqInit.onsuccess = function() {
                    // 설치 프로그램의 버전 업그레이드 필요 여부 확인
                    var necessaryVersion = '3.0.4.5';
                    if (webcrypto.addon.checkAddonVersion(necessaryVersion) === false) {
                        // 자바스크립트 모듈 버전보다 동작중 프로그램 버전이 낮을 경우 false 발생. 설치 패키지의 업그레이드가 필요한 상황
                        if(confirm('D\'Amo WebCrypto 프로그램 버전이 낮습니다. 프로그램 다운로드 페이지로 이동하시겠습니까?')) {
                            // NOTE : 다운로드 페이지 적용할 것
                            location.href = "<%=downloadPage%>";
                        }
                    }
                    
                    
                    // 특정 버전을 고정하여 설치패키지를 유도하고 싶을 때 위의 방식을 빼고 다음처럼 사용 가능                    
                    //var necessaryVersion = '2.0.4.0';
                    /*
                    var necessaryVersion = '';
                    if (reqInit.version !== necessaryVersion) {
                        if(confirm('D\'Amo WebCrypto 프로그램의 재설치가 필요합니다. 다운로드 페이지로 이동하시겠습니까?')) {
                            location.href = "/isignplus/webcrypto_downloads/webcrypto_download.jsp";
                        }
                    }*/
                    
                };
                reqInit.onerror = function(err) {
                    if(confirm('D\'Amo WebCrypto 프로그램이 실행중이 아닙니다. 프로그램 다운로드 페이지로 이동하시겠습니까?')) {
                        // NOTE : 다운로드 페이지 적용할 것
                        location.href = "<%=downloadPage%>";
                    }
                };
                reqInit.onforbidden = function() {
                    alert('허용되지 않은 도메인입니다. D\'Amo WebCrypto 프로그램을 사용할 수 없습니다.');
                };
            }

            function initializeWithWebCrypto() {
                setupWebCryptoPKA();

                // NOTE : 페이지 로딩 후 실행되어야 할 내용이 있다면 함수로 작성하여 여기에서 호출하도록 한다.
                //win_Load();
            }

            addEvent(window, 'load', initializeWithWebCrypto, false);
        </script>
    </head>

<body>
<script type="text/javascript">
    $(function() {
        
        var props = {
            constants : {},
            elements:{
                $formlogin : $('#form-login'),
                $btnLogin : $('#btn-login'),
                $challenge : $('#challenge'),
                $response : $('#response')
            }
        };

        $("#btn-login").click(function(){
            var reqChallenge = webcrypto.pka.makeChallenge();
            reqChallenge.onerror = function(errMsg){
                alert('챌린지값 생성 실패 : ' + errMsg);
            };
                
            reqChallenge.oncomplete = function(challengeData){
                var challenge = challengeData;
                console.log(challenge);
                var displayMediaTypes = ['HDD', 'USB'];
                if (webcrypto.pka.ui.setStorageType(displayMediaTypes) === false) {
                    alert('저장매체 설정 실패! 기본 설정값으로 동작합니다.');
                }
            
                // 인증서 선택 다이얼로그 오픈
                var caTypes = ['NPKI'];
                var request = webcrypto.pka.ui.openCertSelectionBox(caTypes);
                request.onsuccess = function() {
                    var req = webcrypto.pka.makeResponse(challenge);
                    
                    req.onerror = function(errMsg) {
                        alert('응답값 생성 실패 : ' + errMsg);
                        webcrypto.pka.finalize();
                    };
                    req.oncomplete = function(result) {
                        props.elements.$response.val(result);
                        props.elements.$challenge.val(challenge);
                        webcrypto.pka.finalize();
                        
                        var action = "<%=PKI_LOGIN_PROCESS%>";
                        props.elements.$formlogin.attr('action', action);
                        props.elements.$formlogin.attr('method', 'post');
                        props.elements.$formlogin.submit();
                        
                    };
                };
            };
        });
        
        /*function win_Load() {
            document.pkiform.action = "/authentication/pki/loginProcess";
        }*/
    });
</script>
<h1>pki login page</h1>
<form id="form-login" name="pkiform">
    <input type="hidden" id="agentId" name="agentId" value="<%=agentId%>">
    <input type="hidden" id="challenge" name="challenge">
    <input type="hidden" id="response" name="response" >
    <button type="button" id="btn-login">pki로그인</button>
</form>

<!-- ASP, ASPX, PHP에서 include 하는 ui template -->
<div id="wc_cert_selection_layout" class="webcryptoLayout wcBlinder" style="display:none;">
  <div class="wcCertificateWrap"> <!-- 인증서 선택 UI 레이아웃 -->
    <div class="wcSection">
      <h1 class="wcHeader"></h1>
    </div>

    <div class="wcSection">
      <h2 class="wcTitle">인증서 저장매체 선택</h2>
      <ul class="wcMediaTabs" id="wc_media_tabs">
        <li class=""> <!-- 기본 <li class=""> / 선택 <li class="wcSelcOn"> / 서비스안함 <li class="wcSelcOff"> -->
          <label for="wc_media_tab_hdd" class="wcMediaTabHDD">
            <input type="radio" name="wc_media_selection_radio" id="wc_media_tab_hdd" value="HDD" class="hide" checked />
            <span>하드디스크</span>
          </label>
        </li>
        <li class="">
          <label for="wc_media_tab_usb" class="wcMediaTabUSB">
            <input type="radio" name="wc_media_selection_radio" id="wc_media_tab_usb" value="USB" class="hide" />
            <span>이동식디스크</span>
          </label>
        </li>
        <li class="">
          <label for="wc_media_tab_phone" class="wcMediaTabPhone">
            <input type="radio" name="wc_media_selection_radio" id="wc_media_tab_phone" value="Phone" class="hide" />
            <span>휴대폰인증</span>
          </label>
        </li>
        <li class="">
          <label for="wc_media_tab_hsm" class="wcMediaTabHWToken">
            <input type="radio" name="wc_media_selection_radio" id="wc_media_tab_hsm" value="HSM" class="hide" />
            <span>보안토큰</span>
          </label>
        </li>
        <li class="">
          <label for="wc_media_tab_usim" class="wcMediaTabUSIM">
            <input type="radio" name="wc_media_selection_radio" id="wc_media_tab_usim" value="USIM" class="hide" />
            <span>스마트인증(USIM)</span>
          </label>
        </li>
      </ul>
    </div>

    <div class="wcSection">
      <h2 class="wcTitle">사용할 인증서 선택</h2>
      <div class="wcCertList" style="overflow-y:hidden; overflow-x:hidden;"> <!-- 인증서가 6개 이상 될 경우 overflow-y:scroll; -->
        <table summary="공인인증서 구분, 사용자, 만료일, 발급자 정보" style="width:auto;">
          <caption>공인인증서 목록</caption>
          <thead id="wc_cert_list_thead">
          </thead>
          <tbody id="wc_cert_list_tbody">
          </tbody>
        </table>
      </div>
      <div class="wcBtnWrap">
        <span><input type="button" name="button" id="wc_import_cert" value="인증서 찾기" /></span>
        <span><input type="button" name="button" id="wc_detail_view" value="인증서 보기" /></span>
        <span><input type="button" name="button" id="wc_cert_delete" value="인증서 삭제" /></span>
      </div>
      <div class="wcBtnWrap">
        <span><input type="button" name="button" id="wc_export_cert" value="인증서 내보내기" /></span>
        <span><input type="button" name="button" id="wc_cert_copy" value="인증서 복사" /></span>
        <span><input type="button" name="button" id="wc_password_change" value="비밀번호 변경" /></span>
      </div>
    </div>

    <div class="wcSection">
      <h2 class="wcTitle">인증서 비밀번호 입력</h2>
      <div class="wcPwWrap">
        <div class="wcPwInput">
          <label for=""><input type="password" name="password" id="wc_cert_selection_password" title="인증서 비밀번호 입력" /></label>
        </div>
        <p class="wcTipText">인증서 비밀번호는 대소문자를 구분합니다.</p>
      </div>
    </div>

    <p class="wcProgBtnWrap">
      <span class="wcOkBtn"><input type="button" name="button" id="wc_cert_selection_ok" value="확인" /></span>
      <span class="cancelBtn"><input type="button" name="button" id="wc_cert_selection_cancel" value="취소" /></span>
    </p>
  </div>

  <!-- 보안토큰 드라이브 선택 창 -->
  <div id="wc_hsm_drive_selection_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcDriveSelectionWrap">
      <h3 class="wcTitleBar">보안토큰 서비스 정보</h3>
      <div class="wcDriveSelectionCont">
        <h2 class="wcTitle">보안토큰 서비스 제공자 선택</h2>
        <div id="wc_hsm_drive_selection" class="wcDriveSelection" style="overflow-y:hidden; overflow-x:hidden;"> <!-- driveID가 5개 초과 될 경우 overflow-y:scroll; -->
          <table summary="보안토큰 서비스 모듈" style="width:auto; margin:0;">
            <thead>
              <tr>
                <th scope="col" style="width:298px;">
                  <div class="wcDriveTit">
                    보안토큰 서비스 모듈
                  </div>
                </th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
        </div>
      </div>

      <div class="wcBtnWrap02">
        <span><input type="button" name="button" id="wc_hsm_drive_selection_ok" value="확인" /></span>
        <span><input type="button" name="button" id="wc_hsm_drive_selection_cancel" value="취소" /></span>
      </div>

    </div>
  </div>

  <!-- 스마트인증 드라이브 선택 창 -->
  <div id="wc_usim_drive_selection_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcDriveSelectionWrap">
      <h3 class="wcTitleBar">스마트인증 서비스 정보</h3>
      <div class="wcDriveSelectionCont">
        <h2 class="wcTitle">스마트인증 서비스 제공자 선택</h2>
        <div id="wc_usim_drive_selection" class="wcDriveSelection" style="overflow-y:hidden; overflow-x:hidden;"> <!-- driveID가 4개 초과 될 경우 overflow-y:scroll; -->
          <table summary="스마트인증 서비스 모듈" style="width:auto; margin:0;">
            <thead>
              <tr>
                <th scope="col" style="width:298px;">
                  <div class="wcDriveTit">
                    스마트인증 서비스 모듈
                  </div>
                </th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
        </div>
      </div>

      <div class="wcBtnWrap02">
        <span><input type="button" name="button" id="wc_usim_drive_selection_ok" value="확인" /></span>
        <span><input type="button" name="button" id="wc_usim_drive_selection_cancel" value="취소" /></span>
      </div>

    </div>
  </div>

  <!-- 보안토큰 PIN 입력창 -->
  <div id="wc_hsm_login_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcPkcs11LoginWrap">
      <h3 class="wcTitleBar">보안토큰 로그인</h3>
      <div class="wcPkcs11LoginCont">
        <div class="wcSection">
          <h2 class="wcTitle">보안토큰 비밀번호 입력</h2>
          <div class="wcPwWrap">
            <div class="wcPwInput">
              <label for=""><input type="password" name="password" id="wc_hsm_login_pin" title="보안토큰 비밀번호 입력" /></label>
            </div>
            <p class="wcTipText">보안토큰 비밀번호는 대소문자를 구분합니다.</p>
          </div>
        </div>
      </div>

      <p class="wcProgBtnWrap">
        <span class="wcOkBtn"><input type="button" name="button" id="wc_hsm_login_ok" value="확인" /></span>
        <span class="cancelBtn"><input type="button" name="button" id="wc_hsm_login_cancel" value="취소" /></span>
      </p>
    </div>
  </div>

  <!-- 스마트인증 PIN 입력창 -->
  <div id="wc_usim_login_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcPkcs11LoginWrap">
      <h3 class="wcTitleBar">스마트인증 로그인</h3>
      <div class="wcPkcs11LoginCont">
        <div class="wcSection">
          <h2 class="wcTitle">스마트인증 비밀번호 입력</h2>
          <div class="wcPwWrap">
            <div class="wcPwInput">
              <label for=""><input type="password" name="password" id="wc_usim_login_pin" title="스마트인증 비밀번호 입력" /></label>
            </div>
            <p class="wcTipText">스마트인증 비밀번호는 대소문자를 구분합니다.</p>
          </div>
        </div>
      </div>

      <p class="wcProgBtnWrap">
        <span class="wcOkBtn"><input type="button" name="button" id="wc_usim_login_ok" value="확인" /></span>
        <span class="cancelBtn"><input type="button" name="button" id="wc_usim_login_cancel" value="취소" /></span>
      </p>
    </div>
  </div>

  <!-- 인증서 비밀번호 입력창 -->
  <div id="wc_pw_input_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcPwLayoutWrap">
      <h3 class="wcTitleBar">인증서 비밀번호 확인</h3>
      <div class="wcPwLayoutCont">
        <div class="wcSection">
          <h2 class="wcTitle">인증서 비밀번호 입력</h2>
          <div class="wcPwWrap">
            <div class="wcPwInput">
              <label for=""><input type="password" name="password" id="wc_pw_input_password" title="인증서 비밀번호 입력" /></label>
            </div>
            <p class="wcTipText">인증서 비밀번호는 대소문자를 구분합니다.</p>
          </div>
        </div>
      </div>

      <p class="wcProgBtnWrap">
        <span class="wcOkBtn"><input type="button" name="button" id="wc_pw_input_ok" value="확인" /></span>
        <span class="cancelBtn"><input type="button" name="button" id="wc_pw_input_cancel" value="취소" /></span>
      </p>
    </div>
  </div>

  <!-- 인증서 비밀번호 변경창 -->
  <div id="wc_pw_change_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcPwLayoutWrap">
      <h3 class="wcTitleBar">인증서 비밀번호 변경</h3>
      <div class="wcPwLayoutCont">
        <div class="wcSection">
          <h2 class="wcTitle">인증서 비밀번호 입력</h2>
          <div class="wcPwChangeWrap">
            <div class="wcPwChange">
              <label for="">
                <span>변경전 비밀번호</span>
                <input type="password" name="password" id="wc_pw_change_old" title="변경전 비밀번호" />
              </label>
            </div>
            <div class="wcPwChange">
              <label for="">
                <span>변경후 비밀번호</span>
                <input type="password" name="password" id="wc_pw_change_new1" title="변경후 비밀번호" />
              </label>
            </div>
            <div class="wcPwChange">
              <label for="">
                <span>비밀번호 재입력</span>
                <input type="password" name="password" id="wc_pw_change_new2" title="비밀번호 재입력" />
              </label>
            </div>
            <p class="wcTipText">인증서 비밀번호는 대소문자를 구분합니다.</p>
          </div>
        </div>
      </div>

      <p class="wcProgBtnWrap">
        <span class="wcOkBtn"><input type="button" name="button" id="wc_pw_change_ok" value="확인" /></span>
        <span class="cancelBtn"><input type="button" name="button" id="wc_pw_change_cancel" value="취소" /></span>
      </p>
    </div>
  </div>

  <!-- 인증서 상세보기 -->
  <div id="wc_cert_detail_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcCretDetailWrap">
      <h3 class="wcTitleBar">인증서 정보</h3>
      <div class="wcCretDetailCont">
        <ul>
          <!-- 일반 | 선택시 : <li class="wcTap01 wcSelcOn"> -->
          <li class="wcTap01 wcSelcOn">
            <!--<a id="wc_detail_base_tab" href="#" class="wcTapTit">일반</a>-->
            <div id="wc_detail_base_tab" class="wcTapTit">일반</div>
            <div class="wcTapCont">
              <div class="wcBaseInfo">
                <p class="wcBaseInfoTit" id="wc_base_info_title"></p>
                <dl class="wcBaseInfoCont">
                  <dt>발급대상</dt>
                  <dd id="wc_detail_base_subject"></dd>
                  <dt>발급자</dt>
                  <dd id="wc_detail_base_issuer"></dd>
                  <dt>유효기간</dt>
                  <dd id="wc_detail_base_validity"></dd>
                  <dt>PC Time</dt>
                  <dd id="wc_detail_base_time"></dd>
                </dl>
              </div>
            </div>
          </li>

          <!-- 자세히 | 선택시 : <li class="wcTap02 wcSelcOn"> -->
          <li class="wcTap02 ">
            <!--<a id="wc_detail_contents_tab" href="#" class="wcTapTit">자세히</a>-->
            <div id="wc_detail_contents_tab" class="wcTapTit">자세히</div>
            <div class="wcTapCont">
              <div id="wc_detail_info" class="wcDetailInfo" style="overflow-y:auto; overflow-x:auto;">
                <table summary="인증서 상세 정보" style="width:auto; margin:0;">
                  <thead>
                    <tr>
                      <th scope="col" style="width:80px;">
                        <div class="wcDetailTit">
                          이름
                          <div class="wcMoveBar"></div>
                        </div>
                      </th>
                      <th scope="col" style="width:278px;">
                        <div class="wcDetailTit">
                          값
                          <div class="wcMoveBar"></div>
                        </div>
                      </th>
                    </tr>
                  </thead>
                  <tbody id="wc_detail_contents">
                  </tbody>
                </table>
              </div>

              <div class="wcDetailInfo02" id="wc_detail_contents_value">
              </div>
            </div>
          </li>
        </ul>
      </div>

      <div class="wcBtnWrap02">
        <span><input type="button" name="button" id="wc_cert_detail_ok" value="확인" /></span>
      </div>

    </div>
  </div>

  <!-- 인증서 가져오기 -->
  <div id="wc_import_cert_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcImportCertificateWrap">
      <h3 class="wcTitleBar">인증서 가져오기</h3>
      <div class="wcImportCertificateCont">

        <div class="wcSection" style="display:none;"> <!-- dirveID 노출이 필요할 시 display:block -->
          <h2 class="wcTitle">저장할 이동식디스크 선택</h2>
          <div id="wc_portable_drive_list" class="wcDriveSelection" style="overflow-y:hidden; overflow-x:hidden;"> <!-- driveID가 4개 초과 될 경우 height:105px; overflow-y:scroll; -->
            <table summary="이동식디스크 목록" style="width:auto;">
              <thead>
                <tr>
                  <th scope="col" style="width:318px;">
                    <div class="wcDriveTit">
                      디스크명
                    </div>
                  </th>
                </tr>
              </thead>
              <tbody>
              </tbody>
            </table>
          </div>
        </div>

        <div class="wcSection">
          <h2 class="wcTitle">PFX 비밀번호 입력</h2>
          <div class="wcPwWrap">
            <div class="wcPwInput">
              <label for=""><input type="password" name="password" id="wc_import_pfx_password" title="PFX 비밀번호 입력" /></label>
            </div>
            <p class="wcTipText">PFX 비밀번호는 대소문자를 구분합니다.</p>
          </div>
        </div>

        <div class="wcSection" id="wc_import_cert_password_input" style="display:none;">
          <h2 class="wcTitle">인증서 비밀번호 입력</h2>
          <div class="wcPwWrap">
            <p class="wcTipText">비밀번호가 PFX와 다른 경우에 입력합니다.</p>
            <div class="wcPwInput">
              <label for=""><input type="password" name="password" id="wc_import_cert_password" title="인증서 비밀번호 입력" /></label>
            </div>
            <p class="wcTipText">인증서 비밀번호는 대소문자를 구분합니다.</p>
          </div>
        </div>
      </div>

      <p class="wcProgBtnWrap">
        <span class="wcOkBtn"><input type="button" name="button" id="wc_import_cert_ok" value="확인" /></span>
        <span class="cancelBtn"><input type="button" name="button" id="wc_import_cert_cancel" value="취소" /></span>
      </p>
    </div>
  </div>

  <!-- 인증서 복사 -->
  <div id="wc_cert_copy_layout" class="wcBlinderSub" style="display:none;">
    <div class="wcCertCopyWrap">
      <h3 class="wcTitleBar">인증서 복사</h3>
      <div class="wcSection">
        <h2 class="wcTitle">인증서 복사 대상 저장매체 선택</h2>
        <ul class="wcMediaTabs" id="wc_target_media_tabs">
          <li class=""> <!-- 기본 <li class=""> / 선택 <li class="wcSelcOn"> / 서비스안함 <li class="wcSelcOff"> -->
            <label for="wc_target_media_tab_hdd" class="wcMediaTabHDD">
              <input type="radio" name="wc_target_media_radio" id="wc_target_media_tab_hdd" value="HDD" class="hide" checked />
              <span>하드디스크</span>
            </label>
          </li>
          <li class="">
            <label for="wc_target_media_tab_usb" class="wcMediaTabUSB">
              <input type="radio" name="wc_target_media_radio" id="wc_target_media_tab_usb" value="USB" class="hide" />
              <span>이동식디스크</span>
            </label>
          </li>
          <li class="">
            <label for="wc_target_media_tab_phone" class="wcMediaTabPhone">
              <input type="radio" name="wc_target_media_radio" id="wc_target_media_tab_phone" value="Phone" class="hide" />
              <span>휴대폰인증</span>
            </label>
          </li>
          <li class="">
            <label for="wc_target_media_tab_hsm" class="wcMediaTabHWToken">
              <input type="radio" name="wc_target_media_radio" id="wc_target_media_tab_hsm" value="HSM" class="hide" />
              <span>보안토큰</span>
            </label>
          </li>
          <li class="">
            <label for="wc_target_media_tab_usim" class="wcMediaTabUSIM">
              <input type="radio" name="wc_target_media_radio" id="wc_target_media_tab_usim" value="USIM" class="hide" />
              <span>스마트인증(USIM)</span>
            </label>
          </li>
        </ul>
      </div>

      <div class="wcSection">
        <h2 class="wcTitle">복사 대상 디스크 및 모듈 선택</h2>
        <div id="wc_target_drive_list" class="wcDriveSelection" style="overflow-y:hidden; overflow-x:hidden;"> <!-- driveID가 4개 초과 될 경우 height:105px; overflow-y:scroll; -->
          <table summary="장치드라이브 목록" style="width:auto;">
            <thead>
              <tr>
                <th scope="col" style="width:448px;">
                  <div class="wcDriveTit">
                    디스크 및 모듈
                  </div>
                </th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
        </div>
      </div>

      <p class="wcProgBtnWrap">
        <span class="wcOkBtn"><input type="button" name="button" id="wc_cert_copy_ok" value="확인" /></span>
        <span class="cancelBtn"><input type="button" name="button" id="wc_cert_copy_cancel" value="취소" /></span>
      </p>
    </div>
  </div>
</div>
</body>
</html>
