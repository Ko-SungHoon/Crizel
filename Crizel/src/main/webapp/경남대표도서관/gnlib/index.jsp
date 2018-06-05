<%@page contentType="text/html;charset=euc-kr"%>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
</head>
<body>
<h1>index page</h1>

<h2>Temp Login</h2>

<ul>
  <li><a href="login.jsp?userid=admin">관리자 로그인</a></li>
  <li><a href="login.jsp?userid=user1">유저1 로그인</a></li>
  <li><a href="login.jsp?userid=user2">유저2 로그인</a></li>
  <li><a href="login.jsp?userid=user3">유저3 로그인</a></li>
  <li><a href="<%= request.getContextPath() %>/j_spring_security_logout?returnUrl=<%= request.getContextPath() %>/gnlib/">logout</a></li>
</ul>

<h2>로그인 정보</h2>

<div>
	아이디 : <%= EgovUserDetailsHelper.getId() %><br>
	이름 : <%= EgovUserDetailsHelper.getName() %><br>
	역할 : <%= EgovUserDetailsHelper.getAuthorities() %><br>

  <%= EgovUserDetailsHelper.isRole("ROLE_USER") %>
</div>


<h2>프로그램 링크</h2>
<div>
  <a href="lect/index.jsp">강좌</a>
  <a href="vltr/index.jsp">자원봉사</a>
</div>
</body>
</html>