<%!
    /************************************************************
     *  Web-Agent 환경 설정   (** 수정)
     ************************************************************/
/**/private static final String AUTH_URL = "http://libsso.gyeongnam.go.kr";   // ISign+ SSO URL
/**/private static final String agentId = "1";                      // 업무 시스템 고유 번호(관리자가 할당한 번호)
/**/private static final String requestData = "ID,PWD";                 // 요청 데이터(세션에 저장될 값)


    /************************************************************
     *  Agent Page
     ************************************************************/
    private static final String BUSINESS_PAGE = "business.jsp";     // SSO 에이전트 호출 시작 페이지
    private static final String LOGOUT_PAGE = "logout.jsp";         // SSO 에이전트 로그아웃 페이지
    private static final String ERROR_PAGE = "error.jsp";           // SSO 인증 실패시 호출 되는 페이지(에러 출력용)
    private static final String EXCEPTION_PAGE = "#";               // SSO 네트워크 통신 실패 시 기존 업무 로그인 페이지 또는 에러 화면으로 리다이렉션


    /************************************************************
     *  HttpClient Timeout 설정
     ************************************************************/
    private static final int connectionTimeout = 5000;	    // 서버 응답 시간 한도 설정
    private static final int soTimeout = 5000;			    // 연결 후 Read 하는 동안 특정 시각동안 패킷이 없을 경우 Connection 종료
    private static final int maxTotalConnections = 500;     // keepalive 연결


    /************************************************************
     *  ISign+ 호출 URL
     ************************************************************/
    private static final String CHECK_SERVER_URL = AUTH_URL + "/openapi/checkserver";
    private static final String TOKEN_AUTHORIZATION_URL = AUTH_URL + "/token/authorization";
    private static final String SAVE_TOKEN_URL = AUTH_URL + "/token/saveToken.html";
    private static final String AUTH_LOGIN_PAGE = AUTH_URL + "/login.html";
    private static final String AUTH_LOGOUT_PAGE = AUTH_URL + "/logout.html";
    private static final String SERVICE_ERR_PAGE = AUTH_URL + "/serviceError.html";
    private static final String GET_PUBLICKEY_URL = AUTH_URL + "/openapi/authentication/publickey/get";
    // Login Process
    private static final String IDPW_LOGIN_PROCESS = AUTH_URL + "/authentication/idpw/loginProcess";
    private static final String PKI_LOGIN_PROCESS = AUTH_URL + "/authentication/pki/loginProcess";
    private static final String ISSACWEB_LOGIN_PROCESS = AUTH_URL + "/authentication/issacweb/loginProcess";
%>
