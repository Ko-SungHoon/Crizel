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
<%@ page import="egovframework.rfc3.common.filter.HTMLTagFilterRequestWrapper"%>
<%!  
    public String getCookie(HttpServletRequest request, String keyname, String domainId) throws Exception {  
        Cookie [] cookies = request.getCookies();           //-- 1. 배열로 쿠키를 몽땅 로드한다.  
        //String value = "";                                //-- 2. 키값을 리턴하기 위한 변수 선언.  
        String value = domainId;                                //-- 2. 키값을 리턴하기 위한 변수 선언.  
        if(cookies!=null) {  
            for(int j=0;j<cookies.length;j++) {              //-- 3. 배열을 돌면서 해당 키가 나올때까지 루프!!  
                if(keyname.equals(cookies[j].getName())) {  
                    value = cookies[j].getValue();  
                    break;  
                }  
            }  
        }  
          
        return value;  
    }  
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>:: 경상남도 교육청 :: 통합 로그인 처리 ::</title>
</head>
<body>
<%
    /** 로그인되어 있다면 메인페이지로 이동하기 **/
    if (!sm.getId().equals("")) {
        out.println("<script type=\"text/javascript\">");
        out.println("location.href = '/';");
        out.println("</script>");
        return;
    }

    String id = session.getAttribute("ID") == null ? "" : session.getAttribute("ID").toString();
    String name = session.getAttribute("NAME_KOR") == null ? "" : session.getAttribute("NAME_KOR").toString();
    String name_eng = session.getAttribute("NAME_ENG") == null ? "" : session.getAttribute("NAME_ENG").toString();
    
    String returnUrl = session.getAttribute("SSO_RETURN_URL") == null || "".equals(session.getAttribute("SSO_RETURN_URL")) ? "/" : URLDecoder.decode(session.getAttribute("SSO_RETURN_URL").toString(), "UTF-8");
    //String returnUrl = session.getAttribute("SSO_RETURN_URL") == null || "".equals(session.getAttribute("SSO_RETURN_URL")) ? "/" : URLDecoder.decode(session.getAttribute("SSO_RETURN_URL").toString(), "UTF-8");
    //String returnUrl = request.getParameter("ssoReturnUrl") == null || "".equals(request.getParameter("ssoReturnUrl")) ? "/" : request.getParameter("ssoReturnUrl");
    String departCode = session.getAttribute("DEPARTCODE") == null ? "" : session.getAttribute("DEPARTCODE").toString();
    session.removeAttribute("SSO_RETURN_URL");
    
    System.out.println("\n sso_name : " + session.getAttribute("NAME_KOR") + "\n");
	
    if(returnUrl.indexOf("gne.go.kr") < 0 && !"/".equals(returnUrl)){
   		out.println("<script>								");
   		out.println("alert('비정상적인 returnUrl입니다.');	");
   		out.println("location.href='http://www.gne.go.kr';	");
   		out.println("</script>								");
   		return;
   	}    
    
    ApplicationContext contextData = new ClassPathXmlApplicationContext("datasource.xml");
    DataSource dataSource = (DataSource) contextData.getBean("cmsDataSource");

    Connection conn = null;
    ResultSet rs = null;
    PreparedStatement pstmt = null;
    
    String userSe = "";
    int line = 0;
    
    /** 20160823 적용; SSO 거부 계정 **/
    boolean isRejectId = id.startsWith("t_");
    if (isRejectId) {
        out.println("<script type=\"text/javascript\">");
        out.println("alert('경남교육청 홈페이지 아이디로 로그인하시기 바랍니다.\\n※ 학교홈페이지 아이디는 로그인 불가');");
        out.println("location.href = '/sso/logout.jsp';");
        out.println("</script>");
        return;
    }
/*    isRejectId = id.startsWith("test");
    if (isRejectId) {
        out.println("<script type=\"text/javascript\">");
	String msg = "경남교육청 홈페이지 아이디로 로그인하시기 바랍니다ㅠㅠ\\n※ 테스트용 아이디는 로그인 불가 : "+id + " : " + name;
        out.println("alert('"+msg+"');");
        out.println("location.href = '/sso/logout.jsp';");
        out.println("</script>");
        return;
    }*/
    
    /** 20160714 1800i 이후 new DepartCode **/
    boolean isGroupA = departCode.equals("0000000017");   // 도교육청
    boolean isGroupB = departCode.equals("0000000018");   // 직속기관
    boolean isGroupC = departCode.equals("0000000020")    // 교육지원청(창원)
                    || departCode.equals("0000000021")    // 교육지원청(진주)
                    || departCode.equals("0000000022")    // 교육지원청(통영)
                    || departCode.equals("0000000023")    // 교육지원청(사천)
                    || departCode.equals("0000000024")    // 교육지원청(김해)
                    || departCode.equals("0000000025")    // 교육지원청(밀양)
                    || departCode.equals("0000000026")    // 교육지원청(거제)
                    || departCode.equals("0000000027")    // 교육지원청(양산)
                    || departCode.equals("0000000028")    // 교육지원청(의령)
                    || departCode.equals("0000000029")    // 교육지원청(함안)
                    || departCode.equals("0000000030")    // 교육지원청(창녕)
                    || departCode.equals("0000000031")    // 교육지원청(고성)
                    || departCode.equals("0000000032")    // 교육지원청(남해)
                    || departCode.equals("0000000033")    // 교육지원청(하동)
                    || departCode.equals("0000000034")    // 교육지원청(산청)
                    || departCode.equals("0000000035")    // 교육지원청(함양)
                    || departCode.equals("0000000036")    // 교육지원청(거창)
                    || departCode.equals("0000000037");   // 교육지원청(합천)
    boolean isGroupD = departCode.equals("0000000039")    // 학교(창원)
                    || departCode.equals("0000000040")    // 학교(진주)
                    || departCode.equals("0000000041")    // 학교(통영)
                    || departCode.equals("0000000042")    // 학교(사천)
                    || departCode.equals("0000000043")    // 학교(김해)
                    || departCode.equals("0000000044")    // 학교(밀양)
                    || departCode.equals("0000000045")    // 학교(거제)
                    || departCode.equals("0000000046")    // 학교(양산)
                    || departCode.equals("0000000047")    // 학교(의령)
                    || departCode.equals("0000000048")    // 학교(함안)
                    || departCode.equals("0000000049")    // 학교(창녕)
                    || departCode.equals("0000000050")    // 학교(고성)
                    || departCode.equals("0000000051")    // 학교(남해)
                    || departCode.equals("0000000052")    // 학교(하동)
                    || departCode.equals("0000000053")    // 학교(산청)
                    || departCode.equals("0000000054")    // 학교(함양)
                    || departCode.equals("0000000055")    // 학교(거창)
                    || departCode.equals("0000000056");    // 학교(합천)

/** 20161004 1800i 이후 **/
	boolean isSchoolId = id.startsWith("m_a");
	//if(!isSchoolId) isSchoolId = id.startsWith("test99");
	
	
	// 방과후학교인지
	/*boolean isGroupE = false;
	String USERDOMAIN = (String)session.getAttribute("USERDOMAIN");
	String USERTYPE = (String)session.getAttribute("USERTYPE");*/
	String loginPath = null;
	StringBuffer loginPathBuf = new StringBuffer();
	/*if(USERDOMAIN != null) {
		loginPathBuf.append("https://").append(USERDOMAIN).append(request.getContextPath()).append("/user/loginProc.").append(cm.getUrlExt());
		isGroupE = true;
		isSchoolId = false;
		session.removeAttribute("USERDOMAIN");
		session.removeAttribute("USERTYPE");
	} else {
		loginPathBuf.append(request.getContextPath()).append("/user/loginProc.").append(cm.getUrlExt());
	}*/
	loginPathBuf.append(request.getContextPath()).append("/user/loginProc.").append(cm.getUrlExt());
	loginPath = loginPathBuf.toString();
	/*boolean isGroupE = false;
	String CK_USERDOMAIN = getCookie(request, "USERDOMAIN",cm.getDomainId());
	String CK_USERTYPE = getCookie(request, "USERTYPE",cm.getDomainId());
	if(CK_USERDOMAIN != null && CK_USERTYPE != null) {
		if(CK_USERDOMAIN.equals(request.getServerName())) {
			isGroupE = true;
			isSchoolId = false;
		}
	}*/
	
    
    //boolean isGroup = isGroupA || isGroupB || isGroupC || isGroupD || isSchoolId || isGroupE;
	boolean isGroup = isGroupA || isGroupB || isGroupC || isGroupD || isSchoolId;
    
    /*if (!isRejectId && isGroupE) {
        out.println("<script type=\"text/javascript\">");
		String msg = "방과후학교지원센터 : "+CK_USERDOMAIN + " : " + CK_USERTYPE;
        out.println("alert('"+msg+"');");
        out.println("</script>");
        return;
    }*/
    String GROUP_ID = "";
    String userName = "";
    String isUserName = "";
    
    int cnt = 0;
    if (!isRejectId) {    // SSO 허용 계정인 경우
        try {
            conn = dataSource.getConnection();
            
            if (isGroup) {
                line = 1;
                userSe = "USR";
                GROUP_ID = "";
                /** 20160714 1800i 이전 **/
//                 if ("0000000003".equals(departCode)) GROUP_ID ="GRP_000005"; // 도교육청
//                 else if ("0000000005".equals(departCode)) GROUP_ID ="GRP_000006"; // 직속기관
//                 else if ("0000000006".equals(departCode)) GROUP_ID ="GRP_000007"; // 교육지원청
//                 else if ("0000000007".equals(departCode)) GROUP_ID ="GRP_000008"; // 소속기관
//                 else if ("0000000008".equals(departCode)) GROUP_ID ="GRP_000009"; // 학교
                
                /** 20160714 1800i 이후 **/
                if (isGroupA)        GROUP_ID = "GRP_000005"; // 도교육청
                else if (isGroupB)    GROUP_ID = "GRP_000006"; // 직속기관
                else if (isGroupC)    GROUP_ID = "GRP_000007"; // 교육지원청
                else if (isGroupD)    GROUP_ID = "GRP_000009"; // 학교
                //else if (isGroupE)    GROUP_ID = USERTYPE; // 방과후학교지원센터

				/** 20161004 1800i 이후 **/
				if(isSchoolId) {
					GROUP_ID = "GRP_000009"; // 학교
				}
                
                userName = "";
                //if (isGroupA || isGroupD || isSchoolId || isGroupE)        userName = name;
                if (isGroupA || isGroupD || isSchoolId)        userName = name;
                else if (isGroupB || isGroupC)    userName = name_eng;
                
                line = 2;
                StringBuffer query = new StringBuffer();
                query.append(" SELECT COUNT(*) AS CNT FROM RFC_COMTNMANAGER WHERE EMPLYR_ID = ? ");
                pstmt = conn.prepareStatement(query.toString());
                pstmt.setString(1, id);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    cnt = rs.getInt(1);
                }
                if (cnt == 0) {
                	rs.close();
                	pstmt.close();
                    query = new StringBuffer();
                    query.append(" INSERT INTO RFC_COMTNMANAGER (UNIQ_ID, EMPLYR_ID, EMPLYR_NM, PASSWORD,EMAIL_YN, SITE_GROUP_ID, GROUP_ID, \n");
                    query.append(" EMPLYR_STTUS_CODE, EMAIL_STTUS_CODE, USER_LEVEL, SBSCRB_DE, USER_AUTH_CODE,    LOGIN_FIRST_EVENT_YN \n");
                    query.append(" ) VALUES ( \n");
                    query.append("(SELECT TRIM('USR_'||TRIM(TO_CHAR(TO_NUMBER(SUBSTR(MAX(UNIQ_ID),5))+1,'00000000000'))) FROM RFC_COMTNMANAGER), ?, ?, 'Si4MUsZTTZwn4ahCDRjYwu9NcA3tkNvTOsshlKXntJs=', '1', 'SGRP_00001', ?, \n");
                    query.append(" 'P', 'T', 0, systimestamp, 'DES', 1)");
                    pstmt = conn.prepareStatement(query.toString());
                    pstmt.setString(1, id);
                    pstmt.setString(2, userName);
                    pstmt.setString(3, GROUP_ID);
                    pstmt.executeUpdate();
                }
                if (cnt == 1){
                	rs.close();
                	pstmt.close();
                	query = new StringBuffer();
                	query.append(" SELECT EMPLYR_NM FROM RFC_COMTNMANAGER WHERE EMPLYR_ID= ? ");
                	pstmt = conn.prepareStatement(query.toString());
                	pstmt.setString(1, id);
                    rs = pstmt.executeQuery();
                    if(rs.next()){
                    	isUserName = rs.getString(1);
                    }
                    // 2) RFC_COMTNMANAGER 테이블 안의 유저이름과 SSO에서 가져오는 유저이름의 일치여부를 확인한다.
                    if(!isUserName.equals(userName) && isUserName != userName){
                    	// 3) 일치하지 않을경우, SSO에서 가져오는 유저이름으로 최신화시킨다.
                    	rs.close();
                    	pstmt.close();
                    	query = new StringBuffer();	
                    	query.append(" UPDATE RFC_COMTNMANAGER SET EMPLYR_NM= ? WHERE EMPLYR_ID= ?");
                    	pstmt = conn.prepareStatement(query.toString());
                    	pstmt.setString(1, userName);
                    	pstmt.setString(2, id);
						pstmt.executeUpdate();
                    	
                    }
                }
            } else {
                line = 4;
                userSe = "GNR";
                
                StringBuffer query = new StringBuffer();
                query.append(" SELECT COUNT(*) AS CNT FROM RFC_COMTNMEMBER WHERE MBER_ID = ? ");
                pstmt = conn.prepareStatement(query.toString());
                pstmt.setString(1, id);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    cnt = rs.getInt(1);
                }
                if (cnt == 0) {
                	// 2016.11.10 회원 등록
                    rs.close();
                	pstmt.close();
                    query = new StringBuffer();
                    query.append(" INSERT INTO RFC_COMTNMEMBER (UNIQ_ID, MBER_ID, MBER_NM, PASSWORD,EMAIL_YN, SITE_GROUP_ID, GROUP_ID, \n");
                    query.append(" MBER_STTUS_CODE, USER_TY, USER_LEVEL, SBSCRB_DE, USER_AUTH_CODE,    LOGIN_FIRST_EVENT_YN \n");
                    query.append(" ) VALUES ( \n");
                    query.append("(SELECT TRIM('USR_'||TRIM(TO_CHAR(TO_NUMBER(SUBSTR(MAX(UNIQ_ID),5))+1,'00000000000'))) FROM RFC_COMTNMEMBER), ?, ?, ?, '', 'SGRP_00001', '', \n");
                    query.append(" 'P', 'GNR', 0, systimestamp, 'DES', 1)");
                    pstmt = conn.prepareStatement(query.toString());
                    pstmt.setString(1, id);
                    pstmt.setString(2, name);
                    pstmt.setString(3, "wAH9CMhST/YJ9u2is00Lt+TFYJVPzBX96Nm0ZiW8kVg=");
                    //pstmt.setString(3, egovUserDetails.getPassword() == null ? "wAH9CMhST/YJ9u2is00Lt+TFYJVPzBX96Nm0ZiW8kVg=" : egovUserDetails.getPassword());
                    pstmt.executeUpdate();
                }
                // 2017.07.06   1) 통합로그인을 했을 때, RFC_COMTNMEMBER 테이블에 해당 ID가 있을 경우, 
                if (cnt == 1){
                	rs.close();
                	pstmt.close();
                	query = new StringBuffer();
                	query.append(" SELECT MBER_NM FROM RFC_COMTNMEMBER WHERE MBER_ID= ? ");
                	pstmt = conn.prepareStatement(query.toString());
                	pstmt.setString(1, id);
                    rs = pstmt.executeQuery();
                    if(rs.next()){
                    	isUserName = rs.getString(1);
                    }
                    // 2) RFC_COMTNMEMBER 테이블 안의 유저이름과 SSO에서 가져오는 유저이름의 일치여부를 확인한다.
                    if(!isUserName.equals(name) && isUserName != name){
                    	// 3) 일치하지 않을경우, SSO에서 가져오는 유저이름으로 최신화시킨다.
                    	rs.close();
                    	pstmt.close();
                    	query = new StringBuffer();	
                    	query.append(" UPDATE RFC_COMTNMEMBER SET MBER_NM= ? WHERE MBER_ID= ?");
                    	pstmt = conn.prepareStatement(query.toString());
                    	pstmt.setString(1, name);
                    	pstmt.setString(2, id);
						pstmt.executeUpdate();
                    	
                    }
                }
                //if (cnt == 0) {
                    HTMLTagFilterRequestWrapper htmlReq = new HTMLTagFilterRequestWrapper(request);
                    WebApplicationContext context  = WebApplicationContextUtils.getWebApplicationContext(request.getSession().getServletContext());
                    
                    session.setAttribute("loinType", "gnr");
                    String Uid = id;
                    String Uname = name; 
    
//                     pageContext.setAttribute("returnUrl", returnUrl);
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
    
                    line = 5;
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
                    
                    line = 6;
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
                    line = 7;
                    SecurityContext securityContext = new SecurityContextImpl();
                    securityContext.setAuthentication(authentication);
                    SecurityContextHolder.setContext(securityContext);
                    session.setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY, securityContext);
                    PersistentTokenBasedRememberMeServices rememberMeServices= (PersistentTokenBasedRememberMeServices)context.getBean("rememberMeServices");
    
                    /**
                     * 자동 로그인 등록[rememberme services]
                     */
                    line = 8;
                    rememberMeServices.loginSuccess(request, response, realAuthToken);
                    response.sendRedirect(returnUrl);   /** returnUrl에 &가 들어가 있을경우 &가 잘려서 나옴. 그래서 &를 %26으로 전환해서 보냄. 17/11/07 **/
               // }
            }
            
            session.setAttribute("loinType", "sso");
        } catch (Exception e) {
            out.println("Exception Error");
        } finally {
            /** 6. 사용한 resource 종료 **/
            if (rs != null) try { rs.close(); } catch (SQLException ex) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ex) {}
            if (conn != null) try { conn.close(); } catch (SQLException ex) {}
        }
%>
<form name="loginForm" method="post" action ="http://www.gne.go.kr/<%=loginPath%>" >
    <input type="hidden" name="returnUrl" value="<%=returnUrl%>"/>	
    <input type="hidden" name="userSe" value="<%=userSe%>"/>
    <input type="hidden" name="id" value="<%=id %>"/>
    <input type="hidden" name="password" value="rydbrrudska(!!"/>
<!--     <input type="submit" value="로그인"/> -->
<!--     <input type="submit" name="교육청이동" value="교육청으로 이동"/> -->
</form>
<script type="text/javascript">
    document.loginForm.submit();
</script>
<%}%>
</body>
</html>