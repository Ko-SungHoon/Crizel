<%
String dupInfo = (String)session.getAttribute("dupInfo")==null?"":(String)session.getAttribute("dupInfo");
String phoneDi = (String)session.getAttribute("phoneDi")==null?"":(String)session.getAttribute("phoneDi");
%>
아이핀 로그인 : <%=dupInfo%> <br>
휴대폰 로그인 : <%=phoneDi%> <br>
