<%@ page import="org.springframework.web.multipart.MultipartHttpServletRequest" %>
<%@ page import="org.springframework.web.multipart.MultipartFile" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>



<%
out.println(((HttpServletRequestWrapper)request).getRequest());
/*
MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
MultipartFile multipartFile = multiRequest.getFile("file");

out.println(multipartFile);
out.println(multiRequest.getParameter("code"));
*/
%>