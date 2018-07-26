<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 버전 정보. webcrypto의 버전과 맞춰서 넣음
    String version = "3.0.4.5";

    // webcrypto 파일들의 root 경로
    String baseURL = "..";

    String userAgent = (String) request.getHeader("User-Agent");
    String[] mobileOS = { "iPhone", "iPod", "Android", "BlackBerry", "Windows CE",
       "Nokia", "Webos", "Opera Mini", "SonyEricsson", "Opera Mobi", "IEMobile" };

    Boolean addonSupport = true;
    if (userAgent != null && !userAgent.equals("")) {
        for (int i = 0; i < mobileOS.length; i++) {
            if (userAgent.indexOf(mobileOS[i]) >= 0) {
                addonSupport = false;
            }
        }
    }
%>
    <link rel="stylesheet" type="text/css" href="<%=baseURL%>/ui_template/css/certificate_ui.css?v=<%=version%>">

    <!-- js 로딩 순서 바꾸면 안됨 -->
    <script type="text/javascript" src="<%=baseURL%>/js/forge/forge.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/jsbn.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/util.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/sha1.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/sha256.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/sha512.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/asn1.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/cipher.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/cipherModes.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/seed.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/aes.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/prng.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/random.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/rsa.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/pkcs1.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/oids.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/des.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/rc2.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/pkcs7.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/pkcs7asn1.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/hmac.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/pbkdf2.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/x509.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/pbe.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/forge/pkcs12.js?v=<%=version%>" charset="UTF-8"></script>

    <script type="text/javascript" src="<%=baseURL%>/js/json/json2.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/webcrypto/common/webcrypto.js?v=<%=version%>" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=baseURL%>/js/webcrypto/common/webcrypto_msg.js?v=<%=version%>" charset="UTF-8"></script>
<%  if (addonSupport) { %>
    <script type="text/javascript" src="<%=baseURL%>/js/webcrypto/common/webcrypto_addon.js?v=<%=version%>" charset="UTF-8"></script>
<%  } %>

    <script type="text/javascript" src="<%=baseURL%>/js/webcrypto/e2e/webcrypto_e2e.js?v=<%=version%>" charset="UTF-8"></script>

    <script type="text/javascript" src="<%=baseURL%>/js/webcrypto/pka/webcrypto_pka.js?v=<%=version%>" charset="UTF-8"></script>
<%  if (addonSupport) { %>
    <script type="text/javascript" src="<%=baseURL%>/js/webcrypto/pka/webcrypto_pka_addon.js?v=<%=version%>" charset="UTF-8"></script>
<%  } %>
    <script type="text/javascript" src="<%=baseURL%>/ui_template/ui_template.js?v=<%=version%>" charset="UTF-8"></script>

    <script type="text/javascript">
      function includeWebCryptoPfxFileIframe() {
        // PKA의 인증서 가져오기에서 사용될 iframe을 동적으로 웹페이지에 추가함
        webcrypto.loadPfxFileIframe('<%=baseURL%>/js/webcrypto/pka/file_open_frame.html');
      }
    </script>
