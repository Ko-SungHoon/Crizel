<%@ page import="java.io.ByteArrayInputStream,java.io.ByteArrayOutputStream,java.net.*,java.io.*,java.util.*,javax.servlet.http.Cookie" %>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper"%>
<%@ page import="javax.servlet.http.Cookie"%>
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
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource"%>
<%@ page import="egovframework.rfc3.common.filter.HTMLTagFilterRequestWrapper"%>
<%
    // 변수 --------------------------------------------------------------------------------
    String retInfo		= "";		// 결과정보
	String name			= "";       // 성명
	String sex			= "";		// 성별
	String birYMD		= "";		// 생년월일
	String fgnGbn		= "";		// 내외국인 구분값
    String di			= "";		// DI
    String ci1			= "";		// CI
    String ci2			= "";		// CI
    String civersion    = "";       // CI Version
    String reqNum		= "";       // 본인확인 요청번호
    String result		= "";       // 본인확인결과 (Y/N)
    String certDate		= "";       // 검증시간
    String certGb		= "";       // 인증수단
	String cellNo		= "";		// 핸드폰 번호
	String cellCorp		= "";		// 이동통신사
	String addVar		= "";		// 회원사 추가 파라미터

	//복화화용 변수
	String encPara		= "";
	String encMsg		= "";
	String msgChk       = "N";  
	String returnUrl	= "";
    //--------------------------------------------------------------------------------------

    try{
        // Parameter 수신
        retInfo  = request.getParameter("retInfo").trim();
	 String sreqNum = (String) session.getAttribute("reqNum");
	//out.println(sreqNum+"|||");
	//out.println("     ||||||||||||||||||||");
	//out.println(retInfo);



		// 1. 암호화 모듈 (jar) Loading
        com.sci.v2.pcc.secu.SciSecuManager sciSecuMg = new com.sci.v2.pcc.secu.SciSecuManager();
        //쿠키에서 생성한 값을 Key로 생성 한다.
        retInfo  = sciSecuMg.getDec(retInfo, sreqNum);
      
        // 2.1차 파싱---------------------------------------------------------------
        String[] aRetInfo1 = retInfo.split("\\^");
		encPara  = aRetInfo1[0];    //암호화된 통합 파라미터
        encMsg   = aRetInfo1[1];    //암호화된 통합 파라미터의 Hash값
		
		String  encMsg2   = sciSecuMg.getMsg(encPara);
		// 3.위/변조 검증 ---------------------------------------------------------------
		 if(encMsg2.equals(encMsg)){
            msgChk="Y";
        }

		if(msgChk.equals("N")){
			%>
		    <script language=javascript>
            alert("비정상적인 접근입니다.!!<%=msgChk%>");
		    </script>
			<%
			return;
		}

        // 복호화 및 위/변조 검증
		retInfo  = sciSecuMg.getDec(encPara, sreqNum);
        String[] aRetInfo = retInfo.split("\\^");

        name		= aRetInfo[0];
		birYMD		= aRetInfo[1];
        sex			= aRetInfo[2];        
        fgnGbn		= aRetInfo[3];
        di			= aRetInfo[4];
        ci1			= aRetInfo[5];
        ci2			= aRetInfo[6];
        civersion	= aRetInfo[7];
        reqNum		= aRetInfo[8];
        result		= aRetInfo[9];
        certGb		= aRetInfo[10];
		cellNo		= aRetInfo[11];
		cellCorp	= aRetInfo[12];
        certDate	= aRetInfo[13];
		addVar		= aRetInfo[14];
		
		//String realName = request.getParameter("realName");
		//String virtualNo = request.getParameter("virtualNo");
		//returnUrl = URLEncoder.encode(addVar, "UTF-8");
		//returnUrl = URLEncoder.encode(returnUrl, "UTF-8");
		if(!result.equals("Y")){
			%>
		    <script language=javascript>
            alert("본인확인에 실패 하엿습니다.");
			window.close();
		    </script>
			<%
			return;
		}		
					
		//session.setAttribute("UID", di);
		//session.setAttribute("UNAME", name);
		//session.setAttribute("ULEVEL", 1);
		//session.setAttribute("UTYPE", "sil");
        //            	out.println("<script>");		
        //        	out.println("opener.document.location.href='/ssoUser/ssoRealUserProxy.sko?returnUrl="+returnUrl+"'");
		//out.println("window.close();");
        //        	out.println("</script>");
        
         
        
        	HTMLTagFilterRequestWrapper htmlReq = new HTMLTagFilterRequestWrapper(request);
		 WebApplicationContext context  = WebApplicationContextUtils.getWebApplicationContext(request.getSession().getServletContext());

		 
		 	session.setAttribute("phoneDi", di);
			session.setAttribute("phoneCi1", ci1);
			session.setAttribute("phoneCi2", ci2);
		    String userSe = "";
		    String Uid = di;
		    String Uname = name;
		    //String UreturnUrl = StringUtils.isEmpty(htmlReq.getParameter("returnUrl")) ? "" : htmlReq.getParameter("returnUrl");
			returnUrl = addVar==null||"".equals(addVar)||"null".equals(addVar) ? "/" : URLDecoder.decode(addVar, "utf-8"); 

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
		    loginVO.setName(name);
		    loginVO.setUserSe(userSe);
                    loginVO.setUserHomepage(cellNo);


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
		    
        	%>
        	<script language=javascript>
            opener.location.href="<%=returnUrl%>";
            window.close();
		    </script>
        	
        	<%	


	} catch(Exception ex) {
	}
%>