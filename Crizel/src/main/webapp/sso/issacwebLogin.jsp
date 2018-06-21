<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="org.apache.commons.httpclient.HttpClient"%>
<%@page import="org.apache.commons.httpclient.methods.GetMethod"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.util.Map"%>
<%@include file="agentInfo.jsp"%>
<%

    String clientIp = request.getRemoteAddr();
    String userAgent = request.getHeader("User-Agent");
    

    System.out.println("Auth url : " + AUTH_URL);
    System.out.println("agent id : " + agentId);
    System.out.println("clientIp : " + clientIp);
    System.out.println("userAgent : " + userAgent);

    String resultCode = "unknown code";
    String resultMessage = "server not response";
	String publicKey = "";
    boolean isErrorPage = false;

    GetMethod method = null;
    try {
        HttpClient httpClient = new HttpClient();
        method = new GetMethod(GET_PUBLICKEY_URL);
        httpClient.setConnectionTimeout(connectionTimeout);
		httpClient.setTimeout(soTimeout);

        httpClient.executeMethod(method);
        
        String httpResponse = method.getResponseBodyAsString();

        JSONParser jsonParser = new JSONParser();
        JSONObject jsonObject = (JSONObject)jsonParser.parse(httpResponse);

        // debug print
        System.out.println("httpResponse : " + jsonObject);

        resultCode = (String)jsonObject.get("resultCode");
        resultMessage = (String)jsonObject.get("resultMessage");
		Object resultDataObj = jsonObject.get("resultData");
		if (resultDataObj != null) {
			Map<String, String> resultData = (Map<String, String>)resultDataObj;
			publicKey = resultData.get("publicKey");
		}
        // debug print
        System.out.println("resultCode :" + resultCode);
        System.out.println("resultMessage :" + resultMessage);
        System.out.println("publicKey :" + publicKey);
        
        if (resultCode == null ||
			!(resultCode.equals("000000") || resultCode.equals("410004"))) {
            throw new Exception();
        }
        
    } catch (Exception e) {
        isErrorPage = true;
        session.setAttribute("isErrorPage", isErrorPage);
        session.setAttribute("resultCode", resultCode);
        session.setAttribute("resultMessage", resultMessage);
        
        System.out.println(e.toString());
        System.out.println(resultCode);
        System.out.println(resultMessage);
        System.out.println(e.toString());
        
        response.sendRedirect("error.jsp");
    } finally {
        try {
            method.releaseConnection();
        } catch(Exception e) {}
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
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
    <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/webcrypto/common/webcrypto.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/webcrypto/common/webcrypto_msg.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="<%=AUTH_URL%>/resources/js/webcrypto/js/webcrypto/e2e/webcrypto_e2e.js?v=3.0.4.5" charset="UTF-8"></script>

    <script type="text/javascript" src="jquery-3.1.1.min.js"></script>
    <script type="text/javascript">
        $(function() {
            // 서버에서 얻은 공개키
			var publicKey = '<%=publicKey%>';

            var keyname1 = 'Sample1';
            function issacweb_escape(msg) {
                var i;
                var ch;
                var encMsg = '';
                var tmp_msg = String(msg);

                for (i = 0; i < tmp_msg.length; i++) {
                    ch = tmp_msg.charAt(i);

                    if (ch == ' ')
                        encMsg += '%20';
                    else if (ch == '%')
                        encMsg += '%25';
                    else if (ch == '&')
                        encMsg += '%26';
                    else if (ch == '+')
                        encMsg += '%2B';
                    else if (ch == '=')
                        encMsg += '%3D';
                    else if (ch == '?')
                        encMsg += '%3F';
                    else if (ch == '|')
                        encMsg += '%7C';
                    else
                        encMsg += ch;
                }
                return encMsg;
            }
            
            var props = {
                constants : {},
                elements:{
                    $formlogin : $('#form-login'),
                    $btnLogin : $('#btn-login')
                }
            };
            
            $("#btn-login").click(function(){
                var id = $('#id').val();
                var pw = $('#pw').val();

				if (publicKey == undefined || publicKey.length == 0) {
                    alert("설정된 공개키가 없습니다. 관리자에게 문의하시기 바랍니다.");
                    return;
                }
                if (id == undefined || id.length == 0) {
                    alert("id를 입력하세요.");
                    return;
                }
                if (pw == undefined || pw.length == 0) {
                    alert("비밀번호를 입력하세요.");
                    return;
                }
                
                var message = issacweb_escape('id') + "=" + issacweb_escape(id);
                message += "&" + issacweb_escape('pw') + "=" + issacweb_escape(pw);

                try {
                    var reqHybridEnc = webcrypto.e2e.hybridEncrypt(keyname1, message, 'UTF-8', 'SEED', publicKey, 'RSAES-OAEP', 'RSA-SHA1');
                    reqHybridEnc.onerror = function(errMsg) {
                        alert(errMsg);
                    };
                    reqHybridEnc.oncomplete = function(issacwebData) {
                        if(issacwebData === "") {
                            alert("issacweb_data is null");
                            return;
                        }
                        
                        var agentId = $('#agentId').val();
                        var userId = $('#userId').val();

                        var action = "<%=ISSACWEB_LOGIN_PROCESS%>";
                        var form = $('<form action=' + action + ' method="post">'
                            + '<input type="hidden" name="agentId" value="' + agentId + '" />'
                            + '<input type="hidden" name="userId" value="' + userId + '" />'
                            + '<input type="hidden" name="issacwebData" value="' + issacwebData + '" />'
                            + '</form>');
                        $('body').append(form);
                        form.submit();
                    };
                } catch(e) {
                    if (e.message) {
                        alert(e.message);
                    } else {
                        alert(e);
                    }
                }
            });
            
            $("#pw").keydown(function(key) {
                if(key.keyCode == 13) {
                    $("#btn-login").click();
                }
                
            });
        });
    </script>
    <meta charset="UTF-8">
    <title>login page</title>
<body>

<h1>issacweb login page</h1>
<form id="form-login">
    <input type="hidden" id="agentId" name="agentId" value="<%=agentId%>">
    <input type="hidden" id="issacwebData" name="issacwebData">
    <input type="text" id="id"name="id" placeholder="loginId">
    <input type="password" id="pw" name="pw" placeholder="loginPw">
    <button type="button" id="btn-login">로그인</button>
</form>
</body>
</html>
