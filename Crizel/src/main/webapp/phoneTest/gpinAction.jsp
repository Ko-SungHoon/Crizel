<%@page import="java.net.URLDecoder"%>
<%
String dupInfo 		= request.getParameter("dupInfo")		==null?"":request.getParameter("dupInfo");		// 중복확인코드
String RNUM 		= request.getParameter("RNUM")			==null?"":request.getParameter("RNUM");			// 개인식별코드
String RUNAME		= request.getParameter("RNUM")			==null?"":request.getParameter("RNUM");

String returnUrl 	= request.getParameter("gPinReturnUrl")	==null?"":request.getParameter("gPinReturnUrl");

/* 
session.setAttribute("dupInfo", dupInfo);
session.setAttribute("RNUM", RNUM);
session.setAttribute("RUNAME", RUNAME); 
*/

out.println("dupInfo : " + request.getParameter("dupInfo") + "<br>");
out.println("RNUM : " + request.getParameter("RNUM") + "<br>");
out.println("RUNAME : " + request.getParameter("RUNAME") + "<br>");
out.println("gPinRealName : " + request.getParameter("gPinRealName") + "<br>");

%>
<script>
<%-- opener.location.href="<%=URLDecoder.decode(returnUrl, "UTF-8")%>";
window.close(); --%>
</script>
