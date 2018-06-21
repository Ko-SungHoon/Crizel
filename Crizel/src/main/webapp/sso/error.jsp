<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="agentInfo.jsp"%>
<%
    /**
     * error - 에러 출력
     *      에러를 출력하고 로그아웃 페이지로 리다이렉션 처리
     */
    String resultCode = session.getAttribute("resultCode") == null ? "unknown error" : session.getAttribute("resultCode").toString();
    String resultMessage = session.getAttribute("resultMessage") == null ? "unknown message" : session.getAttribute("resultMessage").toString();

    if (!"".equals(resultCode)) {
        session.removeAttribute("resultCode");
    }
    
    if (!"".equals(resultMessage)) {
        session.removeAttribute("resultMessage");
    }
%>
<html>
    <body>
        <script>
            var resultCode = "<%=resultCode%>";
            var resultMessage = "<%=resultMessage%>";

            alert("resultCode : " + resultCode + "\nresultMessage : " + resultMessage)
            location.replace("<%=LOGOUT_PAGE%>");

        </script>
        <h1>resultCode : <%=resultCode%></h1>
        <h1>resultMessage : <%=resultMessage%></h1>
    </body>
</html>
