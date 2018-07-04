<%@ page import="egovframework.rfc3.board.web.BoardManager" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="egovframework.rfc3.common.util.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="egovframework.rfc3.common.util.DateUtils" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%

try {
response.setHeader("Pragma", "no-cache" );
response.setDateHeader("Expires", 0);
response.setHeader("Pragma", "no-store");
response.setHeader("Cache-Control", "no-cache" );

String dt = DateUtils.getDate(new Date(),"yyyyMMddHHmmss");
Random ran = new Random();
//랜덤 문자 길이
int numLength = 6;
String randomStr = "";

for (int i = 0; i < numLength; i++) {
	randomStr += ran.nextInt(10);
}
String id       = "SGNE001";												// 본인실명확인 회원사 아이디
String srvNo    = "001002";													// 본인실명확인 서비스번호
String reqNum   = dt + randomStr;											// 본인실명확인 요청번호
String exVar    = "0000000000000000";                                       // 복호화용 임시필드
String retUrl   = "32https://www.gne.go.kr/index.gne?contentsSid=826";	//request.getParameter("retUrl");// 본인실명확인 결과수신 URL


String certDate	= dt;									                    // 본인실명확인 요청시간
String certGb	= "H";														// 본인실명확인 본인확인 인증수단
String addVar	= request.getParameter("forwardUrl");				// 본인실명확인 추가 파라메터
//String boardReturnUrl2 = request.getParameter("boardReturnUrl");
//out.print("addVar=["+addVar+"]<br/>");
//if(addVar != null && addVar.equals("http://part13.gne.go.kr/setsession.sko")){
//	if(boardReturnUrl2 != null && !boardReturnUrl2.equals("")){
//		addVar = addVar + "?boardReturnUrl=" + java.net.URLEncoder.encode(boardReturnUrl2,"UTF-8");
//	}
//}
//out.print("addVar2=["+java.net.URLDecoder.decode(addVar,"UTF-8")+"]<br/>");
session.setAttribute("reqNum", reqNum);
session.setAttribute("addVar", addVar);
//session.setAttribute("addVar", addVar);


//01. 암호화 모듈 선언
com.sci.v2.pcc.secu.SciSecuManager seed  = new com.sci.v2.pcc.secu.SciSecuManager();

//02. 1차 암호화
String encStr  = "";
String reqInfo = id+"^"+srvNo+"^"+reqNum+"^"+certDate+"^"+certGb+"^"+addVar+"^"+exVar;  // 데이터 암호화
encStr         = seed.getEncPublic(reqInfo);
//out.println(encStr);out.println("|||||||||||||||||||||");
//03. 위변조 검증 값 생성
com.sci.v2.pcc.secu.hmac.SciHmac hmac = new com.sci.v2.pcc.secu.hmac.SciHmac();
String hmacMsg = hmac.HMacEncriptPublic(encStr);
//out.println(hmacMsg);
//03. 2차 암호화
reqInfo  = seed.getEncPublic(encStr + "^" + hmacMsg + "^" + "0000000000000000");  //2차암호화
//String returnMenuCd=(request.getParameter("returnMenuCd"));
//if(returnMenuCd ==null) returnMenuCd="";

//String personnel = "";
//if(request.getParameter("personnel") == null || request.getParameter("personnel") == ""){
//  personnel = "";
//}else{
//  personnel = "y";
//}

//HashMap events = CommonUtil.wssIsUse("");
//String isUseSSo = (String)events.get("constant.SSO_IS_USE");
//if(isUseSSo==null) isUseSSo="";

HttpSession m_Session = request.getSession();
String sessionID = m_Session.getId();
String boardReturnUrl=(request.getParameter("boardReturnUrl"));
session.setAttribute("boardReturnUrl",boardReturnUrl);

String strServerCert = "";
String returnUrl  = request.getParameter("forwardUrl")==null?"":request.getParameter("forwardUrl");
//returnUrl=java.net.URLEncoder.encode(returnUrl.replaceAll("setsession.sko","index.gne"),"UTF-8");
session.setAttribute("SSO_RETURN_URL",returnUrl);
//로그인되어 있다면 메인페이지로 이동하기
//if(!sm.getUserId().equals("")) {
//	out.println("<script>");
//	out.println(" location.href='/'");
//	out.println("</script>");
//	return;
//}
%>
<script type="text/javascript">

<!--

console.log("<%=session.getAttribute("SSO_RETURN_URL")%>");

function alreadyIn(){
	<%if(!sm.getId().equals("")) {
		out.print("return true;");
	}else{
		out.print("return false;");
	}%>
}

    var PCC_window;
    function openPCCWindow(){
		if(alreadyIn()){
			alert("이미 로그인된 상태 입니다. 로그아웃 하십시오.");
			return false;
		}
        var PCC_window = window.open('', 'PCCV3Windows', 'width=430, height=560, resizable=1, scrollbars=no, status=0, titlebar=0, toolbar=0, left=300, top=200' );

        if(PCC_window == null){
			 alert(" ※ 윈도우 XP SP2 또는 인터넷 익스플로러 7 사용자일 경우에는 \n    화면 상단에 있는 팝업 차단 알림줄을 클릭하여 팝업을 허용해 주시기 바랍니다. \n\n※ MSN,야후,구글 팝업 차단 툴바가 설치된 경우 팝업허용을 해주시기 바랍니다.");
        }

        document.reqPCCForm.action = 'https://pcc.siren24.com/pcc_V3/jsp/pcc_V3_j10.jsp';
        document.reqPCCForm.target = 'PCCV3Windows';
		document.reqPCCForm.submit();
		return true;
    }
//-->
</script>
<section>


			<form id="reqPCCForm" name="reqPCCForm" method="post" onsubmit="return openPCCWindow()">
				<input type="hidden" name="reqInfo" value = "<%=reqInfo%>" />
				<input type="hidden" name="retUrl"  value = "<%=retUrl%>" />

            </form>

				<div class="login">
					<ul class="type01">
						<li>본인확인(휴대폰인증 또는 공공아이핀인증)을 거친 후 해당 서비스를 이용하실 수 있으며 아래 본인확인 절차를 거치시면 해당 서비스 화면으로 자동으로 이동합니다.</li>
					</ul>
				</div>

				<div class="ppt">
					<div class="personnal pleft">
						<dl>
							<dt>휴대폰인증</dt>
							<dd>휴대폰인증을 위해 SCI서울신용평가정보(주)를 통하여 입력하신 성명, 전화번호는 본인확인 목적으로만 사용되며, 경상남도교육청홈페이지에는 저장되지 않습니다.<br />
							<a href="#phoneLogin" class="button bblue" onclick="return openPCCWindow();" title="새창으로 열립니다.">휴대폰 인증하기</a></dd>
						</dl>
					</div>

					<div class="personnal pright">
						<dl>
							<dt>공공아이핀인증</dt>
							<dd>공공아이핀이란 인터넷상에서 주민등록번호를 대체할 수 있는 개인식별번호로 본인확인 기관으로부터 발급 받은 개인식별 아이디를 이용하여 본인확인을 하는 서비스입니다. 개인식별 아이디가 없으신 분은 본인요청 버튼을 클릭 후 신규발급을 받으시기 바랍니다.
							<%
					            String returnCtnSid="/index.gne?contentsSid=855";
					            %>
							<!--  <a href="http://www.gne.go.kr/G-PIN/Sample-AuthRequest.jsp?returnCtnSid=<%=returnCtnSid%>&amp;returnUrl=<%=returnUrl%>&amp;boardReturnUrl=<s:property value="boardReturnUrl" />" onclick="window.open(this.href, 'gpinWindow', 'width=500,height=500,scrollbars=yes'); return false;" title="새창으로 열립니다." target="_blank" class="button bblue">공공아이핀 인증하기</a>-->
							<a href="http://www.gne.go.kr/G-PIN3/Sample-AuthRequest.jsp?returnCtnSid=<%=returnCtnSid%>&amp;returnUrl=<%=returnUrl%>" onclick="window.open(this.href, 'gpinWindow', 'width=500,height=500,scrollbars=yes'); return false;" title="새창으로 열립니다." target="_blank" class="button bblue">공공아이핀 인증하기</a>
							</dd>

						</dl>

					</div>
					<div class="clr"></div>


					<div class="personnal01">
						<dl>
							<dt>경상남도교육청통합로그인</dt>
							<dd> 학교홈페이지, 경상남도교육청 홈페이지, 경남사이버학습, 경남교수학습지원센터, 경남사이버영재교육원, 경남진로진학지원센터, 독도사랑나라사랑, 경남교육사이버도서관, 경상남도교육연구정보원을 하나의 아이디로 이용할 수 있는 통합로그인 서비스입니다.<a href="/sso/business.jsp" class="button bblue" style="text-align: center">경상남도교육청통합로그인</a>
							</dd>
						</dl>
					</div>


				</div>
			</section>

 <% } catch(Exception eee) {
	 
	 out.println("<script>");
	 out.println("alert('처리중 오류가 발생하였습니다.');");
	 out.println("history.go(-1);");
	 out.println("</script>");
	 
 } %>