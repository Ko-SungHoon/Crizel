<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.InputStreamReader"%>
<%-- <%@page import="java.util.Base64"%>
<%@page import="java.util.Base64.Encoder"%> --%>
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
<script>
    //본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
    function getAddr() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 도로명 조합형 주소 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }
                // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
                if(fullRoadAddr !== ''){
                    fullRoadAddr += extraRoadAddr;
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('h_zipcode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('h_addr1').value = fullRoadAddr + " " + data.jibunAddress;
                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                /* if(data.autoRoadAddress) {
                    //예상되는 도로명 주소에 조합형 주소를 추가한다.
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';

                } else if(data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';

                } else {
                    document.getElementById('guide').innerHTML = '';
                } */
            }
        }).open();
    }
</script>
</head>
<body>
<%
String id		= request.getParameter("id")==null?"":request.getParameter("id");
String password = request.getParameter("password")==null?"":request.getParameter("password");

if(id!=null && !"".equals(id) && password!=null && !"".equals(password)){
	/* Encoder encoder = Base64.getEncoder();
	password = new String(encoder.encode(password.getBytes("UTF-8"))); */
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
	
	
	if("SUCCESS".equals(result_info)){
		String birthday_year 		= 	data.get("BIRTHDAY")==null?"":data.get("BIRTHDAY").toString().split("/")[0];
	    String birthday_month 		= 	data.get("BIRTHDAY")==null?"":data.get("BIRTHDAY").toString().split("/")[1];
	    String birthday_day 		= 	data.get("BIRTHDAY")==null?"":data.get("BIRTHDAY").toString().split("/")[2];
	    String user_id 				= 	data.get("USER_ID")==null?"":data.get("USER_ID").toString();
	    String name 				= 	data.get("NAME")==null?"":data.get("NAME").toString();
	    String gpin_sex 			= 	data.get("GPIN_SEX")==null?"":data.get("GPIN_SEX").toString();
	    String birthday 			= 	data.get("BIRTHDAY")==null?"":data.get("BIRTHDAY").toString();
	    String birthday_type 		= 	data.get("BIRTHDAY_TYPE")==null?"":data.get("BIRTHDAY_TYPE").toString();
	    String exchange_mobile 		= 	data.get("HANDPHONE")==null?"":data.get("HANDPHONE").toString().split("-")[0];
	    String mobile1 				= 	data.get("HANDPHONE")==null?"":data.get("HANDPHONE").toString().split("-")[1];
	    String mobile2 				= 	data.get("HANDPHONE")==null?"":data.get("HANDPHONE").toString().split("-")[2];
	    String sms_user_yn 			= 	data.get("SMS_USE_YN")==null?"":data.get("SMS_USE_YN").toString();
	    String home_exchange_phone 	= 	data.get("H_PHONE")==null?"":data.get("H_PHONE").toString().split("-")[0];
	    String home_phone1 			= 	data.get("H_PHONE")==null?"":data.get("H_PHONE").toString().split("-")[1];
	    String home_phone2 			= 	data.get("H_PHONE")==null?"":data.get("H_PHONE").toString().split("-")[2];
	    String e_mail 				= 	data.get("E_MAIL")==null?"":data.get("E_MAIL").toString();
	    String mailing_use_yn 		= 	data.get("MAILING_USE_YN")==null?"":data.get("MAILING_USE_YN").toString();
	    String h_zipcode 			= 	data.get("H_ZIPCODE")==null?"":data.get("H_ZIPCODE").toString();
	    String h_addr1 				= 	data.get("H_ADDR1")==null?"":data.get("H_ADDR1").toString();
%>
	<script>
    $(function(){
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
    
    function userInfoModify(){
    	var url = "http://bs.gyeongnam.go.kr:9090/kdotapi/ksearchapi/userinfomodify";
    	var password = $("#password").val();
    	var passwordChk = $("#passwordChk").val();
    	
    	var handphone_cnt = 0;
    	if($("#exchange_mobile").val() != ""){handphone_cnt++;}
    	if($("#mobile1").val() != ""){handphone_cnt++;}
    	if($("#mobile2").val() != ""){handphone_cnt++;}
    	
    	var h_phone_cnt = 0;
    	if($("#home_exchange_phone").val() != ""){h_phone_cnt++;}
    	if($("#home_phone1").val() != ""){h_phone_cnt++;}
    	if($("#home_phone2").val() != ""){h_phone_cnt++;}
    	
    	if(handphone_cnt == 0 && h_phone_cnt == 0){
    		alert("휴대전화 혹은 집전화 번호를 입력하여 주시기 바랍니다.");
    		return false;
    	}else if(handphone_cnt != 0 && handphone_cnt != 3){
    		alert("번호를 모두 입력하여 주시기 바랍니다.");
    		return false;
    	}else if(h_phone_cnt != 0 && h_phone_cnt != 3){
    		alert("번호를 모두 입력하여 주시기 바랍니다.");
    		return false;
    	}
    	
    	$("#user_password").val(btoa(password));
    	
    	var data = $("#login_form").serialize();
    	
    	if(password == ""){		// 비밀번호 변경 안할 시
    		url = "http://bs.gyeongnam.go.kr:9090/kdotapi/ksearchapi/userinfomodify";
    	}else{					// 비밀번호 변경 시
    		url = "http://bs.gyeongnam.go.kr:9090/kdotapi/ksearchapi/useraccountmodify";
    	}

    	if((password == "" && passwordChk == "") || (passwordConfirm() && passwordChkConfirm())){
    		return true;
    	}else{
    		alert("비밀번호를 다시 입력하여 주시기 바랍니다.");
    		$("#password").focus();
    		return false;
    	}
    	return false;
    }
    
    </script>
	<!-- login -->
    <h2 class="blind">경남대표도서관 회원가입</h2>
    <div class="login_area">
        <form id="login_form" name="login_form" action="userInfoModifyAction.jsp" method="post" onsubmit="return userInfoModify();">
            <fieldset>
            	<input type="hidden" id="userkey" name="userkey" value="<%=user_key%>">
            	<input type="hidden" id="birthday_year" name="birthday_year" value="<%=birthday_year%>">
            	<input type="hidden" id="birthday_month" name="birthday_month" value="<%=birthday_month%>">
            	<input type="hidden" id="birthday_day" name="birthday_day" value="<%=birthday_day%>">
            	<input type="hidden" id="user_password" name="user_password">
            	<input type="hidden" id="client_ip" name="client_ip" value="<%=request.getRemoteAddr()%>">
                <legend>로그인</legend>
                <!--<div class="lang_sel"></div>-->
                <div class="join2">
                    <div class="box_area">
                        <h1 class="blind">경남대표도서관</h1>
                        <p class="logo">
                            <a href="/" title="메인화면">
                                <img src="images/common/logo_top.png" alt="경남대표도서관">
                            </a>
                        </p>
                        <h2 class="blind">경남대표도서관 회원가입 정보 입력</h2>
                        <p class="bl_point mt_20">로그인 정보 및 가입 정보를 입력하세요.</p>
                        <!-- <p class="info"><span class="c_red">*</span> 아이디는 영문 소문자, 숫자 5~15자 이내로 입력하세요.</p> -->
                        <div class="input_idpw">
                            <p class="input_id bg">
                                <input type="text" id="user_id" name="user_id" placeholder="아이디" maxlength="15" readonly="readonly" value="<%=user_id%>">
                            </p>
                        </div>
                        <p class="info">
                            <span class="c_red">*</span> 영소/영대/숫자/특수문자중 2가지 조합으로 10자리 이상, 3가지 조합으로 8자리 이상, 20자리 이하로 입력하여 주십시오.
                        </p>
                        <div class="input_idpw">
                            <label for="password" class="info">비밀번호</label>
                            <p class="input_id">
                                <input type="password" name="password" id="password" placeholder="비밀번호" maxlength="20">
                            </p>

                            <div class="txt_small mt_10" id="pwConfirm"></div>

                            <label for="passwordChk" class="info">비밀번호 재확인</label>
                            <p class="input_pw_re">
                                <input type="password" name="passwordChk" id="passwordChk" placeholder="비밀번호 재확인" maxlength="20">
                            </p>
                            <div class="txt_small mt_10" id="pwConfirm2"></div>
                        </div>

                        <div class="input_profile">
                            <div class="neme_area">
                                <label for="name" class="info">이름</label>
                                <p><input type="text" name="name" placeholder="이름" id="name" readonly="readonly" class="textInput fix" value="<%=name%>"></p>
                                <div class="chk">
                                	<input type="radio" id="gpin_sex_1" name="gpin_sex" value="0" required <%if("0".equals(gpin_sex)){out.println("checked");} %>> <label for="gpin_sex_1" class="info mt_10">남자</label>
                               	 	<input type="radio" id="gpin_sex_2" name="gpin_sex" value="1" required <%if("1".equals(gpin_sex)){out.println("checked");} %>> <label for="gpin_sex_2" class="info mt_10">여자</label>
                                </div>
                                <label for="birthday" class="info">생년월일</label>
                                <p><input type="text" id="birthday" name="birthday" readonly="readonly" class="textInput fix birth" value="<%=birthday%>"></p>
                                <div class="chk">
                                	<input type="radio" id="birthday_type_1" name="birthday_type" value="+" required <%if("+".equals(birthday_type)){out.println("checked");} %>> <label for="birthday_type_1" class="info mt_10">양력</label>
                                	<input type="radio" id="birthday_type_2" name="birthday_type" value="-" required <%if("-".equals(birthday_type)){out.println("checked");} %>> <label for="birthday_type_2" class="info mt_10">음력</label>
                                </div>
                            </div>
                            <div class="mb_50">
                                <p class="info"><span class="c_red">*</span> 집전화 미입력시 필수 사항입니다.</p>
                                <p>
                                	<%
                                	String[] exchange_mobileArr = {"010", "011", "016", "017", "018", "019"};
                                	%>
                                    <select name="exchange_mobile" id="exchange_mobile">
                                    	<option value="">선택</option>
                                    	<%
                                    	for(String ob : exchange_mobileArr){
                                    	%>
                                    		<option value="<%=ob%>" <%if(ob.equals(exchange_mobile)){out.println("selected");} %>><%=ob%></option>
                                    	<%
                                    	}
                                    	%>
                                        <!-- <option value="010">010</option>
                                        <option value="011">011</option>
                                        <option value="016">016</option>
                                        <option value="017">017</option>
                                        <option value="018">018</option>
                                        <option value="019">019</option> 
                                        <option value="000">-없음-</option> -->
                                    </select>
                                    <input id="mobile1" name="mobile1" class="phone" type="text" maxlength="4" placeholder="휴대폰번호 앞자리" value="<%=mobile1%>">
                                    <input id="mobile2" name="mobile2" class="phone" type="text" maxlength="4" placeholder="휴대폰번호 뒷자리" value="<%=mobile2%>">
                                </p>
                                <div class="center mb_20">
                                    <div class="agree_chk mt_10 fr">
                                    	<input type="radio" id="sms_use_yn_1" name="sms_use_yn" value="Y" required <%if("Y".equals(sms_user_yn)){out.println("checked");} %>> 수신
										<input type="radio" id="sms_use_yn_2" name="sms_use_yn" value="N" class="ml_30" required <%if("N".equals(sms_user_yn)){out.println("checked");} %>> 수신안함
                                    </div>
                                </div>
                            </div>
                            <div>
                                <p class="info"><span class="c_red">*</span> 휴대폰 미입력시 필수 사항입니다.</p>
                                <p>
                                <%
                                String[] home_exchange_phoneArr = {"02", "031", "032", "033", "041", "042", "043", "051", "052", "053"
                                		, "054", "055", "061", "062", "063", "064", "070", "010", "011", "016", "017"
                                		, "018", "019"};
                                %>
                                    <select name="home_exchange_phone" id="home_exchange_phone" class="tel">
                                    	<option value="">선택</option>
                                    	<%
                                    	for(String ob : home_exchange_phoneArr){
                                    	%>
                                    		<option value="<%=ob%>" <%if(ob.equals(home_exchange_phone)){out.println("selected");} %>><%=ob%></option>
                                    	<%
                                    	}
                                    	%>
                                        <!-- <option value="02">02</option>
                                        <option value="031">031</option>
                                        <option value="032">032</option>
                                        <option value="033">033</option>
                                        <option value="041">041</option>
                                        <option value="042">042</option>
                                        <option value="043">043</option>
                                        <option value="051">051</option>
                                        <option value="052">052</option>
                                        <option value="053">053</option>
                                        <option value="054">054</option>
                                        <option value="055">055</option>
                                        <option value="061">061</option>
                                        <option value="062">062</option>
                                        <option value="063">063</option>
                                        <option value="064">064</option>
                                        <option value="070">070</option>
                                        <option value="010">010</option>
                                        <option value="011">011</option>
                                        <option value="016">016</option>
                                        <option value="017">017</option>
                                        <option value="018">018</option>
                                        <option value="019">019</option> -->
                                    </select>
                                    <input id="home_phone1" name="home_phone1" class="phone" type="text" maxlength="4" placeholder="전화번호 앞자리" value="<%=home_phone1%>">
                                    <input id="home_phone2" name="home_phone2" class="phone" type="text" maxlength="4" placeholder="전화번호 뒷자리" value="<%=home_phone2%>">

                                </p>
                            </div>
                            <div>
                                <p class="info"><span class="c_red">*</span> 이메일 <span class="c_red">(필수)</span></p>
                                <p><input type="text" id="e_mail" name="e_mail" class="email" placeholder="이메일 주소" required value="<%=e_mail%>"></p>
                                <div class="center mb_20">
                                    <div class="agree_chk mt_10 fr">
										<input type="radio" id="mailing_use_yn_1" name="mailing_use_yn" value="Y" required <%if("Y".equals(mailing_use_yn)){out.println("checked");} %>> 수신
										<input type="radio" id="mailing_use_yn_2" name="mailing_use_yn" value="N" class="ml_30" required <%if("N".equals(mailing_use_yn)){out.println("checked");} %>> 수신안함
                                    </div>
                                </div>
                            </div>
                            <div>
                                <p class="info">
                                    <span class="c_red">*</span> 주소 / 상세주소 <span class="c_red">(필수)</span>
                                </p>
                                <p class="addrs">
                                    <input type="text" id="h_zipcode" name="h_zipcode" placeholder="기본주소" class="textInput fix" required value="<%=h_zipcode%>">
                                    <!-- <a href="pop.html" onclick="window.open('/index.lib?contentsSid=261', 'popup','width=500, height=700'); return false;" class="login_btn1" onkeypress="this.onclick" id="idCheckBtn" target="epost" title="새창으로열림">우편번호검색</a> -->
                                    <a href="javascript:getAddr()" class="login_btn1" id="idCheckBtn" title="새창으로열림">우편번호검색</a>
                                </p>
                                <p class="input_addrs">
                                    <input type="text" id="h_addr1" name="h_addr1" placeholder="상세주소" required value="<%=h_addr1%>">
                                </p>
                            </div>
                        </div>
                        <!-- <div>
                            <p class="bl_point">부가서비스</p>
                            <ul class="list1 box_mini mb_10">
                                <li>경남대표도서관의 소식지 및 유용한 정보를 발송시 받아볼 수 있습니다.</li>
                                <li><span class="c_red">기본서비스(대출/반납. 예약, 연체알림등)와 관련된안내는 수신동의 여부와 관계없이 발송됩니다.</span></li>
                            </ul>
                        </div>
                        <div class="txt_h3 center">
                            <span class="agree_chk">
                                문자 수신동의
                                <label class="check" id="sms_label">
                                    <input type="checkbox" id="sms_input" name="sms_yn" checked="checked">
                                </label>
                            </span>
                            <span class="agree_chk">
                                이메일 수신동의
                                <label class="check" id="mail_label">
                                    <input type="checkbox" id="mail_input" name="mail_yn" checked="checked">
                                </label>
                            </span>
                        </div> -->
                    </div>
                    <div class="btn_big">
                        <input type="submit" value="수정" class="agree">
                    </div>
                </div>
            </fieldset>
        </form>
    </div>
    <!-- //login -->
<%
	}
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
        <form id="login_form" name="login_form" action="userInfoModify.jsp" method="post" onsubmit="passBase64();">
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