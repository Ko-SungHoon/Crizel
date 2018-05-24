<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>


<%
	if (EgovUserDetailsHelper.getId() == null || EgovUserDetailsHelper.getId() == "") {
		out.println("<script>alert('로그인이 필요합니다.');");
		out.println("location.href='/index.lib?menuCd=DOM_000000217001000000';</script>");
	        return;
	}

%>

<form name="elibUserCheck" method="post">
	<input type="hidden" name="ssoUserId" value="<%= EgovUserDetailsHelper.getId() %>">
	<input type="hidden" name="ssoUserName" value="<%= EgovUserDetailsHelper.getName() %>">
	<input type="hidden" name="ssoUserClass" value="<%= EgovUserDetailsHelper.getLoginVO().getSttusCode() %>">
	<input type="hidden" name="ssoMemberClass" value="<%=EgovUserDetailsHelper.getLoginVO().getPaymentOfficeTel()%>">

</form>

<SCRIPT>
	document.elibUserCheck.action="http://elib.gyeongnam.go.kr/ssoLogin/LoginCheck.do";
	document.elibUserCheck.submit();
</SCRIPT>
</body>
</html>
                                                                                                                  