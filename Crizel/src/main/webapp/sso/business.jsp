<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="org.apache.commons.httpclient.HttpClient"%>
<%@ page import="org.apache.commons.httpclient.methods.GetMethod"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>

<%@include file="agentInfo.jsp"%>
<%
    /**
     * Business - 최초로 호출되는 페이지
     *    인증서버 통신체크 한 후 이상이 없을 경우 인증서버의 로그인 페이지(SSO_LOGIN_PAGE)로 리다이렉션 처리
     */
    System.out.println("[[[ business page ]]] : " + session.getId());

    // 인증서버 통신 체크
    GetMethod method = null;
    try {
        HttpClient httpClient = new HttpClient();
        method = new GetMethod(CHECK_SERVER_URL);
        httpClient.setConnectionTimeout(connectionTimeout);
        httpClient.setTimeout(soTimeout);

        httpClient.executeMethod(method);
        String httpResponse = method.getResponseBodyAsString();

        JSONParser jsonParser = new JSONParser();
        JSONObject jsonObject = (JSONObject)jsonParser.parse(httpResponse);

        // debug print
        System.out.println("httpResponse : " + jsonObject);

        String resultCode = (String)jsonObject.get("resultCode");

        if (resultCode == null || resultCode.equals("000000") == false) {
            throw new Exception();
        }
        
    } catch (Exception e) {
        // SSO 인증서버와 통신이 되지 않을 경우 개별 로그인 처리
        System.out.println("[Business Exception] : " + e.toString());

        // TODO - 인증서버와 통신 실패 시 개별 업무로 로그인 할 수 있도록 처리 해야 합니다.
        response.sendRedirect(EXCEPTION_PAGE);
        return;
    } finally {
        try {
            method.releaseConnection();
        } catch(Exception e) {}
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
    </form>

    <script>
        var sendUrl = "<%=AUTH_LOGIN_PAGE%>";
        var sendForm = document.sendForm;
        
        sendForm.action = sendUrl;
        sendForm.submit();
    </script>
    
</body>
</html>