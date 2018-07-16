<%
/**************************************************************************************************************************
* Program Name  : 본인확인 결과 수신 Sample JSP 
* File Name     : pcc_V3_result_seed.jsp
* Comment       : 
* History       :  
*
**************************************************************************************************************************/
%>

<%@ page  contentType = "text/html;charset=utf-8"%>
<%@ page import = "java.util.*" %> 
    [본인확인 결과 수신 Sample - JSP ] <br> <br>
<%
    // 변수 --------------------------------------------------------------------------------
    String retInfo		= "";																// 결과정보

	String name			= "";                                                               //성명
	String sex			= "";																//성별
	String birYMD		= "";																//생년월일
	String fgnGbn		= "";																//내외국인 구분값
	
    String di			= "";																//DI
    String ci1			= "";																//CI
    String ci2			= "";																//CI
    String civersion    = "";                                                               //CI Version
    
    String reqNum		= "";                                                               // 본인확인 요청번호
    String result		= "";                                                               // 본인확인결과 (Y/N)
    String certDate		= "";                                                               // 검증시간
    String certGb		= "";                                                               // 인증수단
	String cellNo		= "";																// 핸드폰 번호
	String cellCorp		= "";																// 이동통신사
	String addVar		= "";


	//복화화용 변수
	String encPara		= "";
	String encMsg		= "";
	String msgChk       = "N";  
	
	String returnUrl	= request.getParameter("returnUrl");
	
    //-----------------------------------------------------------------------------------------------------------------
  	 String sreqNum = (String) session.getAttribute("reqNum");
	 sreqNum =sreqNum.trim();

    try{

        // Parameter 수신 --------------------------------------------------------------------
        retInfo  = request.getParameter("retInfo").trim();
        
        // 1. 암호화 모듈 (jar) Loading
        com.sci.v2.pcc.secu.SciSecuManager sciSecuMg = new com.sci.v2.pcc.secu.SciSecuManager();
        //쿠키에서 생성한 값을 Key로 생성 한다.
        retInfo  = sciSecuMg.getDec(retInfo, sreqNum);

        // 2.1차 파싱---------------------------------------------------------------
        String[] aRetInfo1 = retInfo.split("\\^");

		encPara  = aRetInfo1[0];         //암호화된 통합 파라미터
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


        // 복호화 및 위/변조 검증 ---------------------------------------------------------------
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
		
		session.setAttribute("phoneDi", di);
		session.setAttribute("phoneCi1", ci1);
		session.setAttribute("phoneCi2", ci2);
%>
<script>
opener.location.href="<%=addVar%>";
window.close();
</script>
<%-- <html>
    <head>
        <title>SCI평가정보 본인확인서비스  테스트</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <style>
            <!--
            body,p,ol,ul,td
            {
                font-family: 굴림;
                font-size: 12px;
            }

            a:link { size:9px;color:#000000;text-decoration: none; line-height: 12px}
            a:visited { size:9px;color:#555555;text-decoration: none; line-height: 12px}
            a:hover { color:#ff9900;text-decoration: none; line-height: 12px}

            .style1 {
                color: #6b902a;
                font-weight: bold;
            }
            .style2 {
                color: #666666
            }
            .style3 {
                color: #3b5d00;
                font-weight: bold;
            }
            -->
        </style>
    </head>
	<body>
            [복호화 후 수신값] <br>
            <br>
            <table cellpadding="1" cellspacing="1" border="1">
				<tr>
					<td align="center" colspan="2">본인확인 결과</td>
				</tr>
				<tr>
                    <td align="left">성명</td>
                    <td align="left"><%=name%></td>
                </tr>
				<tr>
                    <td align="left">성별</td>
                    <td align="left"><%=sex%></td>
                </tr>
				<tr>
                    <td align="left">생년월일</td>
                    <td align="left"><%=birYMD%></td>
                </tr>
				<tr>
                    <td align="left">내외국인 구분값(1:내국인, 2:외국인)</td>
                    <td align="left"><%=fgnGbn%></td>
                </tr>				
				<tr>
                    <td align="left">중복가입자정보</td>
                    <td align="left"><%=di%></td>
                </tr>
				<tr>
                    <td align="left">연계정보1</td>
                    <td align="left"><%=ci1%></td>
                </tr>
				<tr>
                    <td align="left">연계정보2</td>
                    <td align="left"><%=ci2%></td>
                </tr>
				<tr>
                    <td align="left">연계정보버전</td>
                    <td align="left"><%=civersion%></td>
                </tr>
                <tr>
                    <td align="left">요청번호</td>
                    <td align="left"><%=reqNum%></td>
                </tr>
				<tr>
                    <td align="left">인증성공여부</td>
                    <td align="left"><%=result%></td>
                </tr>
				<tr>
                    <td align="left">인증수단</td>
                    <td align="left"><%=certGb%></td>
                </tr>
				<tr>
                    <td align="left">핸드폰번호</td>
                    <td align="left"><%=cellNo%>&nbsp;</td>                
                </tr>
				<tr>
                    <td align="left">이동통신사</td>
                    <td align="left"><%=cellCorp%>&nbsp;</td>                
                </tr>
                <tr>
                    <td align="left">요청시간</td>
                    <td align="left"><%=certDate%></td>
                </tr>				
				<tr>
                    <td align="left">추가파라미터</td>
                    <td align="left"><%=addVar%>&nbsp;</td>
                </tr>
            </table>            
            <br>
            <br>
            <a href="http://.../pcc_V3_input_seed.jsp">[Back]</a>
</body>
</html> --%>
<%
        // ----------------------------------------------------------------------------------

    }catch(Exception ex){
    	out.println(ex.toString());
    }
%>