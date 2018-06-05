<%@page contentType="text/html;charset=utf-8"%>
<%@ page import="javax.servlet.http.*"%>

<%
  session.invalidate();
  response.sendRedirect("index.jsp");
%>