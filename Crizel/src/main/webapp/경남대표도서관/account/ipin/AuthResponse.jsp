<%@ page language = "java" contentType = "text/html; charset=UTF-8"%>

<%@ page import="gov.mogaha.gpin.sp.proxy.*" %>

<%
    /**
     * 이 서비스는 공공I-PIN인증정보수신 페이지입니다.
     * 사용자인증 정보, 사이트가입확인요청 등의 요청서비스에 대해서 공공I-PIN에서 응답을 주는 페이지이므로
     * 1) 공공I-PIN 공무원창구를 통해 정확하게 URL이 등록되어야하며
     * 2) 서비스와 관련된 내용을 수정하시면 안됩니다.
     *
     */
    response.addHeader("Cache-Control", "private");

    GPinProxy proxy = GPinProxy.getInstance(this.getServletConfig().getServletContext());

    String parameter = request.getParameter("versionRequest");
    if(parameter != null && "versionRequest".equals(parameter) )
    {
        try
        {
            out.println(proxy.getSPVersion());
        }
        catch(Exception e)
        {
            // 에러에 대한 처리는 이용기관에 맞게 처리할 수 있습니다.
            e.printStackTrace();
            out.println(e.getMessage());
        }
        return;
    }
    boolean result = false;

	// 요청한 사용자 IP와 응답받는 사용자 IP를 비교한다.
    boolean ipCheck = request.getRemoteAddr().equals(session.getAttribute("gpinUserIP"));
    if (ipCheck)
    {
        try
        {
            result = proxy.parseSAMLResponse(request, session);
        }
        catch(Exception e)
        {
            // 에러에 대한 처리는 이용기관에 맞게 처리할 수 있습니다.
            e.printStackTrace();
            out.println(e.getMessage());
        }
    }
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>G-PIN인증 페이지</title>
 </head>

 <body>


<form name="f" method="post" action="<%=session.getAttribute("gpinAuthRetPage")%>">
	<input type="hidden" name="dupInfo"   value="<%=session.getAttribute("dupInfo")%>"/>
	<input type="hidden" name="RNUM"   value="<%=session.getAttribute("virtualNo")%>"/>
	<input type="hidden" name="RUNAME"   value="<%=session.getAttribute("realName")%>"/>
	<input type="hidden" name="gPinRealName"   value="<%=session.getAttribute("realName")%>"/>
	<input type="hidden" name="gPinReturnUrl"   value="<%=session.getAttribute("gPinReturnUrl")%>"/>
</form>


	
<script language="javascript" type="text/javascript">
        <%
        if(result){
		%>
			var formname = document.f;
			formname.submit();
        
		<%
        } else if(!ipCheck){
        %>
            alert("요청이 금지된 IP입니다.<%=session.getAttribute("gpinUserIP")%>");
        <%
        } else {
        %>
            alert("수신받은 인증값이 없습니다.");
        <%
        }
		%>
</script>
<%
    session.setAttribute("gpinAuthRetPage", null);
%>
</body>
</html>



