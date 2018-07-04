<%@ page import="java.io.ByteArrayInputStream,java.io.ByteArrayOutputStream,egovframework.rfc3.common.util.*,java.net.*,java.io.*,java.util.*,org.springframework.security.core.userdetails.memory.UserAttribute" %>
<%@ page import="org.springframework.security.core.GrantedAuthority,org.springframework.security.core.authority.GrantedAuthorityImpl" %>
<%@ page import="egovframework.rfc3.login.vo.LoginVO,egovframework.rfc3.iam.security.userdetails.EgovUserDetails" %>
<%@ page import="org.springframework.security.authentication.AuthenticationDetailsSource,org.springframework.security.web.authentication.session.SessionAuthenticationStrategy" %>
<%@ page import="org.springframework.security.web.authentication.WebAuthenticationDetailsSource,org.springframework.security.web.authentication.session.NullAuthenticatedSessionStrategy" %>
<%@ page import="egovframework.rfc3.iam.security.authentication.rlauth.RealNameAuthenticationToken,org.springframework.context.ApplicationEventPublisher" %>
<%@ page import="org.springframework.security.authentication.event.InteractiveAuthenticationSuccessEvent,org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.web.context.WebApplicationContext,org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="org.springframework.security.authentication.AuthenticationManager,egovframework.rfc3.iam.security.authentication.rememberme.PersistentTokenBasedRememberMeServices"%>
<%@ page import="org.springframework.security.core.context.SecurityContext,org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="org.springframework.security.core.context.SecurityContextImpl,org.springframework.security.web.context.HttpSessionSecurityContextRepository"%>
<%@ page import="egovframework.rfc3.common.filter.HTMLTagFilterRequestWrapper"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>G-PIN인증 페이지</title>
</head>
<body>
<%
    String returnUrl ="";
    String dupInfo = request.getParameter("dupInfo") == null ? "" : request.getParameter("dupInfo"); // 중복확인코드(dupInfo); 20160823 추가
    String RNUM = request.getParameter("RNUM")==null?"":request.getParameter("RNUM"); // 개인식별번호(virtualNo)
    String RUNAME = request.getParameter("RUNAME")==null?"":request.getParameter("RUNAME");
    String gPinReturnUrl = request.getParameter("gPinReturnUrl")==null?"/":URLDecoder.decode(request.getParameter("gPinReturnUrl"),"utf-8");
	session.setAttribute("dupInfo",dupInfo);
	session.setAttribute("RNUM", RNUM);
    //     String RNUM = session.getAttribute("virtualNo");
//     String RUNAME = session.getAttribute("realName");
//     String gPinReturnUrl = session.getAttribute("gPinReturnUrl");

    returnUrl = (gPinReturnUrl == null ? "/index.gne" : gPinReturnUrl);

//     session.setAttribute("RNUM", RNUM);
//     session.setAttribute("RUNAME", RUNAME);

//     session.setAttribute("UID", RNUM);
//     session.setAttribute("UNAME",RUNAME);
//     session.setAttribute("UNAME", new String(RUNAME.getBytes("ISO-8859-1"), "UTF-8"));
//     session.setAttribute("ULEVEL", 1);    
//     session.setAttribute("UTYPE", "sil");
    
    try{
        HTMLTagFilterRequestWrapper htmlReq = new HTMLTagFilterRequestWrapper(request);
        WebApplicationContext context  = WebApplicationContextUtils.getWebApplicationContext(request.getSession().getServletContext());

        String userSe = "";
        /** 20160823 virtualNo 에서 dupInfo 로 변경 **/
        String Uid = RNUM; // virtualNo
        //String Uid = dupInfo; // dupInfo
        String Uname = RUNAME;
        //String UreturnUrl = StringUtils.isEmpty(htmlReq.getParameter("returnUrl")) ? "" : htmlReq.getParameter("returnUrl");
        //returnUrl = addVar==null||"".equals(addVar)||"null".equals(addVar) ? "/" : URLDecoder.decode(addVar, "utf-8"); 

        pageContext.setAttribute("returnUrl", returnUrl);
        UserAttribute userAttribute = new UserAttribute();
        List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();
            
        /*
        UID 또는 userId를 통하여 CMS의 회원 데이터를 검색, 데이터가  있는경우 필요하 필드값들을 참조하여 변수에 저장
        CMS에 회원정보가 존재하는경우 해당 ID를 통하여 권한정보를 가져옴
        */

        if (authorities.size() == 0) {
            userSe = "GNR";
            authorities = new ArrayList<GrantedAuthority>();
            authorities.add(new GrantedAuthorityImpl("ROLE_ANONYMOUS"));
            authorities.add(new GrantedAuthorityImpl("ROLE_AUTHENTICATED_ANONYMOUSLY"));
        } else {
            userSe = "GNR"; 
        }

        userAttribute.setAuthorities(authorities);
        userAttribute.setPassword(Uid);
        String key = "tkfkdgo";

        LoginVO loginVO = new LoginVO();
        loginVO.setId(Uid);
        loginVO.setPassword(Uid);
        loginVO.setName(Uname);
        loginVO.setUserSe(userSe);


        EgovUserDetails egovUserDetails = new EgovUserDetails(loginVO.getId(), loginVO.getId(), true, loginVO);
        AuthenticationDetailsSource authenticationDetailsSource = new WebAuthenticationDetailsSource();
        SessionAuthenticationStrategy sessionStrategy = new NullAuthenticatedSessionStrategy();

        /**
         * 인증토큰 만들기
         */
        RealNameAuthenticationToken realAuthToken = new RealNameAuthenticationToken(key, egovUserDetails,userAttribute.getAuthorities());
        realAuthToken.setDetails(authenticationDetailsSource.buildDetails(request));

        /**
         * 세션접속 상태에 토큰을 임시 저장
         */
        sessionStrategy.onAuthentication(realAuthToken, request, response);

        /**
         * 이벤트 등록
         */
            /*
            ApplicationEventPublisher eventPublisher;
           if (eventPublisher != null) {
               eventPublisher.publishEvent(new InteractiveAuthenticationSuccessEvent(realAuthToken, this.getClass()));
           }*/

        /**
         * securityContext 에 저장
         */
        AuthenticationManager authenticationManager = (AuthenticationManager)context.getBean("authenticationManager");
        Authentication authentication = authenticationManager.authenticate(realAuthToken);

        SecurityContext securityContext = new SecurityContextImpl();
        securityContext.setAuthentication(authentication);
        SecurityContextHolder.setContext(securityContext);
        session.setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY, securityContext);
        PersistentTokenBasedRememberMeServices rememberMeServices= (PersistentTokenBasedRememberMeServices)context.getBean("rememberMeServices");

        /**
         * 자동 로그인 등록[rememberme services]
         */
        rememberMeServices.loginSuccess(request, response, realAuthToken);
        session.setAttribute("loinType", "gnr");
    } catch (Exception e) {
%>
        <script language=javascript>
        alert("본인인증처리를 실패하였습니다. 관리자에게 문의하세요.");
         opener.location.href="/";
         window.close();
        </script>        
<%
out.println("<script>");
out.println("alert('처리중 오류가 발생하였습니다.');");
out.println("history.go(-1);");
out.println("</script>");
    }
    
%>
<script language=javascript>
    opener.location.href="<%=returnUrl%>";
    window.close();
</script>
</body>
</html>