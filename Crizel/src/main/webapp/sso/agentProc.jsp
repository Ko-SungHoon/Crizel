<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.Enumeration" %>

<%@include file="agentInfo.jsp"%>
<%
    /**
     * agentProc - 인증이 완료된 후 호출 되는 페이지
     */

    String resultCode = session.getAttribute("resultCode") == null ? "" : session.getAttribute("resultCode").toString();
    String resultMessage = session.getAttribute("resultMessage") == null ? "" : session.getAttribute("resultMessage").toString();

    /**
     *  TODO - 결과 코드가 성공이라면 인증 처리 페이지로 리다이렉션 처리
     *      업무 처리 페이지 안에서 세션에 사용자 정보를 취득하여 SSO 연동 작업을 한다.
     */
    if ("000000".equals(resultCode)) {
        response.sendRedirect("loginProc");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <style>
        table {
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid;
        }
    </style>

    <script>
        var resultCode = "<%=resultCode%>";
        if (resultCode !== "000000" && resultMessage !== "") {
            alert("<%=resultMessage%>");
        }
    </script>

</head>
<body>
<input type="button" onclick="javascript:location.href='<%=LOGOUT_PAGE%>'" style="cursor:hand" value="로그아웃" />
<!-------------------------------------------------
  [ 세션 목록 리스팅 ]
  ------------------------------------------------->
    <table>
        <tr>
            <th>Key</th>
            <th>Value</th>
        </tr>
        <tr>
            <td>Agent Id</td>
            <td><%=agentId%></td>
        </tr>

        <%
            Enumeration e = session.getAttributeNames();
            while (e.hasMoreElements()) {
                String name = e.nextElement().toString();
                String attrName = String.valueOf(session.getAttribute(name));
        %>
        <tr>
            <td bgcolor="#ffffff" width="30%"><%=name%></td>
            <td bgcolor="#dddddd"><%=attrName%></td>
        </tr>
        <% } %>

    </table>


</body>
</html>
