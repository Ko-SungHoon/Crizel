<%@page import="java.lang.reflect.Method"%>
<%@page import="java.util.List"%>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper"%>
<%@ page import="egovframework.rfc3.login.vo.LoginVO,egovframework.rfc3.iam.security.userdetails.EgovUserDetails" %>
TEST <br>
USER_CLASS : <%= EgovUserDetailsHelper.getLoginVO().getSttusCode() %> <br>
MEMBER_CLASS : <%=EgovUserDetailsHelper.getLoginVO().getPaymentOfficeTel()%> <br>
VO : <%=EgovUserDetailsHelper.getLoginVO()%>
<br>

<%

LoginVO vo = new LoginVO();

for(Method ob : vo.getClass().getMethods()){
	out.println(ob + "<br>");
}


%>
