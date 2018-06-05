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
  <li><a href="login.jsp?userid=admin">������ �α���</a></li>
  <li><a href="login.jsp?userid=user1">����1 �α���</a></li>
  <li><a href="login.jsp?userid=user2">����2 �α���</a></li>
  <li><a href="login.jsp?userid=user3">����3 �α���</a></li>
  <li><a href="<%= request.getContextPath() %>/j_spring_security_logout?returnUrl=<%= request.getContextPath() %>/gnlib/">logout</a></li>
</ul>

<h2>�α��� ����</h2>

<div>
	���̵� : <%= EgovUserDetailsHelper.getId() %><br>
	�̸� : <%= EgovUserDetailsHelper.getName() %><br>
	���� : <%= EgovUserDetailsHelper.getAuthorities() %><br>

  <%= EgovUserDetailsHelper.isRole("ROLE_USER") %>
</div>


<h2>���α׷� ��ũ</h2>
<div>
  <a href="lect/index.jsp">����</a>
  <a href="vltr/index.jsp">�ڿ�����</a>
</div>
</body>
</html>