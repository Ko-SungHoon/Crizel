<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.net.URLEncoder"%>
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
        <script type="text/javascript" src="http://bs.gyeongnam.go.kr:9090/rfc3/user/domain/112.163.77.55.80/0/37.js"></script>
        <script type="text/javascript" src="http://bs.gyeongnam.go.kr:9090/rfc3/user/domain/112.163.77.55.80/0/38.js"></script>
    <![endif] -->
    <%
    String id			= request.getParameter("id")==null?"":request.getParameter("id");
    String ipin_hash 	= request.getParameter("ipin_hash")==null?"":request.getParameter("ipin_hash");
    
    String addr = "http://bs.gyeongnam.go.kr:9090/kdotapi/ksearchapi/usercheck";
	addr += "?option=1";
	addr += "&ipin_hash=" + URLEncoder.encode(ipin_hash, "UTF-8");
	InputStreamReader isr 	= null;
	URL url 				= null;
	HttpURLConnection conn 	= null;
	String result_info 		= "";
	JSONArray user_data 	= null;
	JSONObject data			= null;
	JSONObject search_count	= null;
	try{
		url = new URL(addr);
		conn = (HttpURLConnection) url.openConnection();
		isr = new InputStreamReader(conn.getInputStream());
		JSONObject object = (JSONObject) JSONValue.parse(isr);
		
		result_info = (String)object.get("RESULT_INFO");
		user_data = (JSONArray) object.get("USER_DATA");
		search_count = (JSONObject) user_data.get(0);
		
		if("SUCCESS".equals(result_info)){
			if(!"0".equals(search_count.toString())){
				data = (JSONObject) user_data.get(1);
			}else{
				out.println("<script>");
				out.println("alert('처리 중 오류가 발생하였습니다.');");
				out.println("history.go();");
				out.println("</script>");
			}
		}else{
			out.println("<script>");
			out.println("alert('처리 중 오류가 발생하였습니다.');");
			out.println("history.go(-1);");
			out.println("</script>");
		}
	}catch(Exception e){
		out.println("<script>");
		out.println("alert('처리 중 오류가 발생하였습니다."+e+"');");
		out.println("history.go(-1);");
		out.println("</script>");
	}
	
	String user_key			= data.get("REC_KEY").toString();
    %>
    <script>
    $(function(){
    	//getUserId();
    	
    	/* 패스워드 강도 검증 */
		$("#password").keyup(function() {
			passwordConfirm();
			passwordChkConfirm();
		});
		
		$("#passwordChk").keyup(function() {
			passwordConfirm();
			passwordChkConfirm();
		});
    });
    <%-- function getUserId(){
    	var url = "http://bs.gyeongnam.go.kr:9090/kdotapi/ksearchapi/usercheck";
    	var option = "1";
    	var ipin_hash = "<%=ipin_hash%>";
    	
    	$.ajax({
			type : "POST",
			url : url,
			data : {
				option : option, 
				ipin_hash : ipin_hash
			},
			contentType : "application/x-www-form-urlencoded; charset=utf-8",
			datatype : "json",
			success : function(data) {
				$.each(JSON.parse(data), function(i, val) {
					if(i=="RESULT_INFO" && val!="SUCCESS"){
						alert("계정을 확인하여 주시기 바랍니다.");
						history.go(-1);
					}
					if(i=="USER_DATA"){
						$("#userkey").val(val[1].REC_KEY);
					}
				});
			},
			error:function(request,status,error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
    } --%>
    
    function pwReset(){
    	//var url = "http://bs.gyeongnam.go.kr:9090/kdotapi/ksearchapi/userpasswordmodify";
    	var userkey = $("#userkey").val();
    	var password = btoa($("#password").val());
    	var client_ip = $("#client_ip").val();
    	$("#password").val(password);
    	
    	/* $.ajax({
			type : "POST",
			url : url,
			data : {
				userkey : userkey, 
				password : password,
				client_ip : client_ip
			},
			contentType : "application/x-www-form-urlencoded; charset=utf-8",
			datatype : "json",
			success : function(data) {
				$.each(JSON.parse(data), function(i, val) {
					if(i=="RESULT_INFO" && val=="SUCCESS"){
						alert("비밀번호가 변경되었습니다.");
						location.replace("index.jsp");
					}else{
						alert("처리중 오류가 발생하였습니다.");
						history.go(-1);
					}
				});
				return false;
			},
			error:function(request,status,error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		}); */
    	return true;
    }
    
    function passwordConfirm(){
    	var passwordConfirm = false;
    	var pwStrong = '<span class="c_blue txt_small">※ 좋습니다. 비밀번호가 강력합니다.</span><br>';
        var pwNomal = '<span class="c_blue">※ 보통 - 비밀번호로 사용하기 적당합니다.</span><br>';
        var pwWeak = '<span class="c_red">※ 매우 약함 - 아직 비밀번호가 사용하기에 적당하지 않습니다.<br>영소/영대/숫자/특수문자중 2가지 조합으로 10자리 이상, 3가지 조합으로 8자리 이상, 20자리 이하로 입력하여 주십시오.</span>';
		var str = $("#password").val();
		var strlen = str.length;
		var check1 = false;
		var check2 = false;
		var check3 = false;
		var check4 = false;
		var cnt = 0;

		if(str.match(/[a-z]/g)) {	// 소문자 검증
			var check1 = true;
		}			
		if(str.match(/[A-Z]/g)) {	// 대문자 검증
			var check2 = true;
		}
		if(str.match(/[0-9]/g)) {	// 숫자 검증
			var check3 = true;
		}		
		if(str.match(/[^a-z\w\s]/g)) {	//특수문자 검증
			var check4 = true;
		}
		
		if(check1 || check2){cnt++;}
		if(check3){cnt++;}
		if(check4){cnt++;}
		
		if(strlen>0){
			if(strlen>=10 && strlen<=20){
				if(cnt>=2){
					if(cnt==2){
						$("#pwConfirm").html(pwNomal);
						passwordConfirm = true;
					}else{
						$("#pwConfirm").html(pwStrong);
						passwordConfirm = true;
					}
				}else{
					$("#pwConfirm").html(pwWeak);
					passwordConfirm = false;
				}
			}else if(strlen>=8 && strlen<=20){
				if(cnt>=3){
					$("#pwConfirm").html(pwStrong);
					passwordConfirm = true;
				}else{
					$("#pwConfirm").html(pwWeak);
					passwordConfirm = false;
				}
			}else{
				$("#pwConfirm").html(pwWeak);
				passwordConfirm = false;
			}
		}else{
			$("#pwConfirm").html("");
			passwordConfirm = false;
		}
		return passwordConfirm;		
    }
    
    function passwordChkConfirm(){
    	var passwordConfirm = false;
    	var pwOk = '<span class="c_blue txt_small">※패스워드 값과 패스워드 확인값이 일치합니다.</span>';
    	var pwNo = '<span class="c_red">※패스워드 값과 패스워드 확인값이 일치하지 않습니다.</span>';
		var password = $("#password").val();
		var passwordChk = $("#passwordChk").val();
		var strlen = passwordChk.length;
		
		if(strlen>0){
			if(password!=passwordChk){
				$("#pwConfirm2").html(pwNo);
				passwordConfirm = false;
			}else{
				$("#pwConfirm2").html(pwOk);
				passwordConfirm = true;
			}
		}else{
			$("#pwConfirm2").html("");
			passwordConfirm = false;
		}
		return passwordConfirm;
    }
    </script>
</head>

<body>

    <!-- login -->
    <div class="login_area">
        <form id="login_form" name="login_form" action="pwResetAction.jsp" onsubmit="return pwReset();">
            <fieldset>
            	<input type="hidden" id="userkey" name="userkey" value="<%=user_key%>">
            	<input type="hidden" id="client_ip" name="client_ip" value="<%=request.getRemoteAddr()%>">
                <legend>비밀번호 재설정</legend>
                	<div class="join2">
                		<div class="box_area">
		                    <h1 class="blind">경남대표도서관</h1>
		                    <p class="logo">
		                        <a href="/" title="메인화면">
		                            <img src="images/common/logo_top.png" alt="경남대표도서관">
		                        </a>
		                    </p>
		                    <h2 class="blind">경남대표도서관 비밀번호 재설정</h2>
		
		                    <p class="info">
		                            <span class="c_red">*</span> 영소/영대/숫자/특수문자중 2가지 조합으로 10자리 이상, 3가지 조합으로 8자리 이상, 20자리 이하로 입력하여 주십시오.
		                        </p>
		                        <div class="input_idpw">
		                            <label for="password" class="info">비밀번호</label>
		                            <p class="input_id">
		                                <input type="password" name="password" id="password" placeholder="비밀번호" maxlength="20" required>
		                            </p>
		
		                            <div class="txt_small mt_10" id="pwConfirm"></div>
		
		                            <label for="passwordChk" class="info">비밀번호 재확인</label>
		                            <p class="input_pw_re">
		                                <input type="password" name="passwordChk" id="passwordChk" placeholder="비밀번호 재확인" maxlength="20" required>
		                            </p>
		                            <div class="txt_small mt_10" id="pwConfirm2"></div>
		                        </div>
		                    <!-- //비밀번호 재설정 -->
		                    	<div class="btn_big">
			                        <input type="submit" value="확 인" class="agree wps_100">
			                    </div>
		                </div>	
           			</div>
            </fieldset>
        </form>
    </div>
    <!-- //login -->

</body>
</html>
