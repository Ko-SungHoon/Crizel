<%@ page import="org.apache.commons.httpclient.HttpClient"%>
<%@ page import="org.apache.commons.httpclient.NameValuePair"%>
<%@ page import="org.apache.commons.httpclient.methods.PostMethod"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="org.apache.commons.httpclient.HttpStatus" %>
<%@ page import="org.apache.commons.httpclient.HttpException" %>
<%@ include file="agentInfo.jsp"%>
<%
    /**
     * checkauth - SSO로부터 호출 되는 페이지
     *      토큰 검증 및 업데이트 진행
     */
    System.out.println("[[[ checkauth page ]]] : " + session.getId());
    String resultCode = request.getParameter("resultCode") == null ? "" : request.getParameter("resultCode");
    String secureToken = request.getParameter("secureToken") == null ? "" : request.getParameter("secureToken");
    String secureSessionId = request.getParameter("secureSessionId") == null ? "" : request.getParameter("secureSessionId");
    String clientIp = request.getRemoteAddr();

    String resultMessage = "";
    String returnUrl = "";

    System.out.println("resultCode : " + resultCode);
    System.out.println("secureToken : " + secureToken);
    System.out.println("secureSessionId : " + secureSessionId);

    if (resultCode.equals("000000") && "".equals(secureToken) == false && "".equals(resultCode) == false) {
        // debug print
        /*
        System.out.println("secureToken : " + secureToken);
        System.out.println("secureSessionId : " + secureSessionId);
        System.out.println("agentId : " + agentId);
        System.out.println("requestData : " + requestData);
        System.out.println("clientIp : " + clientIp);
        */

        PostMethod method = null;
        try {
            // 인증서버에 토큰 검증 및 사용자 정보를 요청하기 위해 httpclient를 사용하여 전달
            method = new PostMethod(TOKEN_AUTHORIZATION_URL);
            NameValuePair[] nameValuePair = {
                    new NameValuePair("secureToken", secureToken),
                    new NameValuePair("secureSessionId", secureSessionId),
                    new NameValuePair("requestData", requestData),
                    new NameValuePair("agentId", agentId),
                    new NameValuePair("clientIP", clientIp)
            };

            method.setQueryString(nameValuePair);

            HttpClient httpClient = new HttpClient();
            httpClient.setConnectionTimeout(connectionTimeout);
            httpClient.setTimeout(soTimeout);

            int status_code = httpClient.executeMethod(method);
            // 정상적으로 호출이 되지 않았을 경우 Exception 처리
            if (status_code != HttpStatus.SC_OK) {
                throw new HttpException(method.getStatusLine().toString());
            }

            String httpResponse = method.getResponseBodyAsString();
            System.out.println("httpResponse : " + httpResponse);
            JSONParser jsonParser = new JSONParser();
            JSONObject jsonObject = (JSONObject) jsonParser.parse(httpResponse);

            // 사용자 요청 정보
            JSONObject dataObject = (JSONObject) jsonObject.get("user");
            // 결과 코드와 메시지
            resultCode = (String) jsonObject.get("resultCode");
            resultMessage = (String) jsonObject.get("resultMessage");
            // Return URL(인증서버에서 리다이렉션될 주소를 전달)
            returnUrl = (String) jsonObject.get("returnUrl");

            // check cs mode(토큰저장소에 토큰을 저장하기 위해 사용되며 CS모드일 경우는 SAVE_TOKEN_URL로 리다이렉션 됨)
            boolean useCSMode  = jsonObject.get("useCSMode") == null ? false:Boolean.valueOf(jsonObject.get("useCSMode").toString());

            // 요청 데이터 정보 추출
            if ("000000".equals(resultCode)) {
                // 검증 성공
                String[] keys = requestData.split(",");

                for (int i = 0; i < keys.length; i++) {
                    String value = (String) dataObject.get(keys[i]);
                    if (value == null) {
                        continue;
                    }

                    session.setAttribute(keys[i], value);
                }

                // cs mode 체크 하여 saveToken page 호출 여부 판단
                if (useCSMode) {
                    returnUrl = SAVE_TOKEN_URL;
                }

            } else if ("310017".equals(resultCode) || "310012".equals(resultCode)) {
                // 서비스 접근 권한 실패(다른 서비스에 영향을 주어서는 안됨으로 로그아웃은 하지 않음)
                returnUrl = SERVICE_ERR_PAGE;
            } else {
                // SSO 검증 실패(로그아웃 필요)
                returnUrl = ERROR_PAGE;
            }

            // 결과 코드와 메시지, 사용자 요청 데이터를 세션에 저장
            session.setAttribute("resultCode", resultCode);
            session.setAttribute("resultMessage", resultMessage);
        } catch (HttpException e) {
            System.out.println("[checkauth HttpException] : " + e.toString());

            // TODO - 인증서버와 통신 실패 시 개별 업무로 로그인 할 수 있도록 처리 해야 합니다.
            returnUrl = EXCEPTION_PAGE;
        } catch (Exception e) {
            System.out.println("[checkauth Exception] : " + e.toString());

            returnUrl = ERROR_PAGE;
        } finally {
            try {
                method.releaseConnection();
            } catch(Exception e) {}
        }

    } else {
        // 비정상 호출 할 경우 Business 페이지로 리다이렉션 처리
        System.out.println("unknown call");
        returnUrl = LOGOUT_PAGE;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
</head>
<body>
<form name="sendForm" method="post">
    <input type="hidden" name="agentId" value="<%=agentId%>" />
    <input type="hidden" name="errCode" value="<%=resultCode%>" />
    <input type="hidden" name="secureSessionId" value="<%=secureSessionId%>" />
</form>

<script>
    var sendUrl = "<%=returnUrl%>";
    var sendForm = document.sendForm;
    sendForm.action = sendUrl;
    sendForm.submit();
</script>
</body>
</html>