<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.InputStreamReader"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv="content-Script-Type" content="text/javascript">
    <meta http-equiv="content-Style-Type" content="text/css">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <meta name="title" content="경상남도대표도서관">
    <meta name="keywords" content="경상남도대표도서관,도서관,경상남도">
    <meta name="description" content="경상남도대표도서관 로그인페이지입니다.">
    <title>경상남도대표도서관</title>
    <!--<link rel="Shortcut Icon" href="images/favicon.ico">--><!-- // favicon -->
    <link rel="stylesheet" type="text/css" href="css/default.css" media="all">
    <link rel="stylesheet" type="text/css" href="css/login.css" media="all">
    <script type="text/javascript" src="js/jquery-1.11.3.min.js"></script>
    <!-- [if lt IE 9]>
        <script type="text/javascript" src="js/html5.js"></script>
        <script type="text/javascript" src="js/respond.js"></script>
    <![endif] -->
    <script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<%
String id		= request.getParameter("id")==null?"":request.getParameter("id");
String password = request.getParameter("password")==null?"":request.getParameter("password");

if(id!=null && !"".equals(id) && password!=null && !"".equals(password)){

	String addr = "http://bs.gyeongnam.go.kr:9090/kdotapi/ksearchapi/userinfoview";
	addr += "?id=" + id;
	addr += "&password=" + password;
	InputStreamReader isr 	= null;
	URL url 				= null;
	HttpURLConnection conn 	= null;
	String result_info 		= "";
	JSONObject data			= null;
	JSONObject data2		= null;
	String user_key			= "";
	
	String name  			=	"";
	String user_id			=	"";
	try{
		url = new URL(addr);
		conn = (HttpURLConnection) url.openConnection();
		isr = new InputStreamReader(conn.getInputStream());
		JSONObject object = (JSONObject) JSONValue.parse(isr);
		
		result_info = (String)object.get("RESULT_INFO");
		
		if("SUCCESS".equals(result_info)){
			data = (JSONObject) object.get("USER_DATA");
			
			addr = new String();
			addr = "http://bs.gyeongnam.go.kr:9090/kdotapi/ksearchapi/getuserkey";
			addr += "?id="+id;
			url = new URL(addr);
			conn = (HttpURLConnection) url.openConnection();
			isr = new InputStreamReader(conn.getInputStream());
			object = (JSONObject) JSONValue.parse(isr);
			
			result_info = (String)object.get("RESULT_INFO");
			
			if("SUCCESS".equals(result_info)){
				data2 = (JSONObject) object.get("USER_DATA");
				user_key = data2.get("USER_KEY").toString();
				
				name 		= 	data.get("NAME").toString();
				user_id		=	data.get("USER_ID").toString();	
			}else{
				out.println("<script>");
				out.println("alert('처리 중 오류가 발생하였습니다.');");
				out.println("history.go(-1);");
				out.println("</script>");
			}
		}else{
			out.println("<script>");
			out.println("alert('처리중 오류가 발생하였습니다.');");
			if(object.get("RESULT_MESSAGE")!=null){
				out.println("alert('" + (String)object.get("RESULT_MESSAGE") + "');");
			}
			out.println("history.go(-1);");
			out.println("</script>");
		}
	}catch(Exception e){
		out.println("<script>");
		out.println("alert('처리 중 오류가 발생하였습니다.');");
		out.println("history.go(-1);");
		out.println("</script>");
	}
%>  
    <script>
    function userDrop(){
    	if(confirm("회원탈퇴 하시겠습니까?")){
    		return true;
    	}else{
    		return false;
    	}
    }
    </script>
</head>
<body>
    <!-- login -->
    <div class="login_area">
        <form id="login_form" name="login_form" action="userDropAction.jsp" onsubmit="return userDrop();">
            <fieldset>
            	<input type="hidden" id="userkey" name="userkey" value="<%=user_key%>">
            	<input type="hidden" id="client_ip" name="client_ip" value="<%=request.getRemoteAddr()%>">
            	<input type="hidden" id="sys" name="sys" value="homepage">
            	<input type="hidden" id="option" name="option" value="direct">
                <legend>로그인</legend>
                <div class="box_area mt_50">
                    <h1 class="blind">경남대표도서관</h1>
                    <p class="logo">
                        <a href="/" title="메인화면">
                            <img src="images/common/logo_top.png" alt="경남대표도서관">
                        </a>
                    </p>
                    <h2 class="blind">경남대표도서관 회원탈퇴</h2>
                    <div class="guide_msg">
                        <p class="tit">회원탈퇴 안내</p>
                        <p>회원탈퇴를 원하시면 하단의 <span class="c_blue">'회원탈퇴'</span>를 누르세요.</p>
                    </div>

                    <div class="certify1 pt_10">
                        <h3 class="bl_h3">회원탈퇴정보</h3>
                        <ul class="list1 txt_small mb_10">
                            <li>서울도서관 홈페이지 회원을 탈퇴하시면 제공 서비스를 모두 이용하실 수 없게 됩니다.</li>
                            <li class="c_red">회원탈퇴시 기존 아이디의 재사용이 안되며, 회원정보 복원 또한 불가합니다.</li>
                            <li class="c_red">대출중인 도서가 있으면 탈퇴처리가 불가능합니다.</li>
                        </ul>
                    </div>

                    <div>

                        <p class="bl_point mb_10">회원탈퇴안내</p>
                        <ul class="list1 box_mini mb_10">
                            <li>성명 : <%=name%> (<%=user_id%>)</li>
                            <!-- <li>회원번호 : 200004</li>
                            <li>탈퇴가능 여부 : 대출중 도서 없음 (회원탈퇴 가능)</li> -->
                        </ul>
                    </div>
                </div>
                <div class="btn_big">
                    <a href="index.jsp" class="no_agree" title="메인이동">취소</a><input type="submit" value="회원탈퇴" class="agree last">
                </div>
            </fieldset>
        </form>
    </div>
    <!-- //login -->
<%
}else{
%>
	<script>
	function passBase64(){
		var password = btoa($("#password").val());
		$("#password").val(password);
	}
	</script>
	<!-- login -->
    <div class="login_area">
        <form id="login_form" name="login_form" action="userDrop.jsp" method="post" onsubmit="passBase64();">
            <fieldset>
                <legend>로그인</legend>
                <div class="box_area login_top">
                    <h1 class="blind">경남대표도서관</h1>
                    <p class="logo">
                        <a href="/" title="메인화면">
                            <img src="images/common/logo_top.png" alt="경남대표도서관">
                        </a>
                    </p>
                    <h2 class="blind">경남대표도서관 로그인</h2>
                    <div class="guide_msg">
                        <p class="tit">비밀번호 재확인</p>
                        <p>이용자의 정보를 안전하게 보호하기 위해 비밀번호를 한번 더 입력하십시오.</p>
                    </div>
                    <div class="input_form">
                        <p class="">아이디</p>
                        <p class="input_id"><input type="text" id="id" name="id" title="아이디" placeholder="아이디" value="" required></p>
                        <p class="mt_20">비밀번호</p>
                        <p class="input_pw"><input type="password" id="password" name="password" title="비밀번호" placeholder="비밀번호" required></p>
                    </div>
                    <div class="btn_big mb_10">
                        <input type="submit" value="로그인" class="agree wps_100">
                    </div>
                </div>
            </fieldset>
        </form>
    </div>
    <!-- //login -->
<%
}
%>
</body>
</html>   

</body>
</html>
