<%@page contentType="text/html;charset=utf-8"%>

<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page import="org.springframework.context.support.ClassPathXmlApplicationContext"%>
<%@ page import="javax.sql.DataSource"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.io.ByteArrayInputStream,java.io.ByteArrayOutputStream,java.net.*,java.io.*,java.util.*,javax.servlet.http.Cookie" %>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper"%>
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

<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import="java.net.URL" %>

<%
  String userid = request.getParameter("userid");
  String key = "tkfkdgo";

  JSONParser parser = new JSONParser();
  URL url = new URL("http://localhost/gnlib/json/"+ userid +".jsp");
  Object obj = parser.parse(new InputStreamReader(url.openStream(), "UTF-8"));
  JSONObject loginResult = (JSONObject) obj;
  JSONObject userData = (JSONObject)loginResult.get("USER_DATA");

  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(request.getSession().getServletContext());

  UserAttribute userAttribute = new UserAttribute();
  List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();

  if (authorities.size() == 0) {
     authorities = new ArrayList<GrantedAuthority>();
     authorities.add(new GrantedAuthorityImpl("ROLE_ANONYMOUS"));
     authorities.add(new GrantedAuthorityImpl("ROLE_AUTHENTICATED_ANONYMOUSLY"));
     authorities.add(new GrantedAuthorityImpl("ROLE_USER"));
     if( "admin".equals(userid) ) {
       authorities.add(new GrantedAuthorityImpl("ROLE_ADMIN"));
     }
  }

  userAttribute.setAuthorities(authorities);
  userAttribute.setPassword((String)userData.get("USER_ID"));

  LoginVO loginVO = new LoginVO();
  loginVO.setId((String)userData.get("USER_ID"));
  loginVO.setPassword((String)userData.get("USER_NO"));
  loginVO.setName((String)userData.get("NAME"));
  loginVO.setUserSe("USR");

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

   response.sendRedirect("/gnlib/");
%>
