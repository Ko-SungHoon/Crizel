<%@page import="java.net.URLEncoder"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
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
    String ipin_hash = request.getParameter("ipin_hash")==null?"bRKusdfmCsKUa80Nk0sx3QYjWnlOLtPDtvaBzJtz+Tj3djkQ4nhQtWVsFQ+nvyf2X+N9ms67WnSHjK2xxlBiBw==":request.getParameter("ipin_hash");
    String addr = "http://bs.gyeongnam.go.kr:9090/kdotapi/ksearchapi/usercheck";
    addr += "?option=1";
    addr += "&ipin_hash=" + URLEncoder.encode(ipin_hash, "UTF-8");
    
	InputStreamReader isr 	= null;
	URL url 				= null;
	HttpURLConnection conn 	= null;
	String result_info 		= "";
	JSONObject search_count = null;
	JSONArray user_data 	= null;
	JSONObject data 		= null;
	
	try {
		url = new URL(addr);
		conn = (HttpURLConnection) url.openConnection();
		isr = new InputStreamReader(conn.getInputStream());
		JSONObject object = (JSONObject) JSONValue.parse(isr);
		
		result_info = (String)object.get("RESULT_INFO");	
		user_data = (JSONArray) object.get("USER_DATA");
		
		search_count = (JSONObject) user_data.get(0);
		
		if(!"0".equals(search_count.toString())){
			data = (JSONObject) user_data.get(1);
		}else{
			out.println("<script>");
			out.println("alert('처리 중 오류가 발생하였습니다.');");
			out.println("history.go();");
			out.println("</script>");
		}
	} catch (Exception e) {
		out.println("<script>");
		out.println("alert('처리 중 오류가 발생하였습니다.');");
		out.println("history.go();");
		out.println("</script>");
	}
    %>
    <script>
    $(function(){
    	getUserId();
    });
    
    function getUserId(){
    	var result_info = "<%=result_info%>";
    	
    	if(result_info == "SUCCESS"){
    		$("#name").text("<%=data.get("NAME").toString()%>");
    		$("#user_id").text("<%=data.get("USER_ID").toString().substring(0, data.get("USER_ID").toString().length()-3) + "***"%>");
    	}else{
    		alert("처리 중 오류가 발생하였습니다.");
    		history.go();
    	}
    	
    	/* var url = "http://bs.gyeongnam.go.kr:9090/kdotapi/ksearchapi/usercheck";
    	var option = "1";
    	var ipin_hash = "bRKusdfmCsKUa80Nk0sx3QYjWnlOLtPDtvaBzJtz+Tj3djkQ4nhQtWVsFQ+nvyf2X+N9ms67WnSHjK2xxlBiBw==";
    	//ipin_hash = ipin_hash.replace(/[+]/g, "%2B");
    	//ipin_hash = ipin_hash.replace(/[&]/g, "%26");
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
						$("#name").text(val[1].NAME);
						$("#user_id").text(val[1].USER_ID.substring(0,val[1].USER_ID.length-3) + "***");
					}
				});
			},
			error:function(request,status,error){
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		}); */
    }
    </script>
</head>

<body>

    <!-- login -->
    <div class="login_area">
        <form id="login_form" name="login_form" action="pwConfirm.jsp" method="get">
            <fieldset>
                <legend>로그인</legend>
                <div class="complete box_area mt_100">
                    <h1 class="blind">경남대표도서관</h1>
                    <p class="logo">
                        <a href="/" title="메인화면">
                            <img src="images/common/logo_top.png" alt="경남대표도서관">
                        </a>
                    </p>
                    <h2 class="blind">경남대표도서관 아이디찾기 안내</h2>
                    <div class="guide_msg id_info">
                        <p class="tit">아이디찾기 안내</p>
                        <p><span id="name"></span>님의 아이디는 <strong><span class="c_red" id="user_id"></span></strong> 입니다.</p>
                    </div>

                    <div class="msg mt_30">
                        <!--<p class="bl_point">개인정보 보호를 위해 끝자리 일부는 '*'로 표시됩니다.</p>-->
                        <!-- <div>
                            <h3 class="bl_h3">아이디찾기 안내</h3>
                            <ul class="list1 box_mini mb_10">
                                <li>개인정보 보호를 위해 끝자리 일부는 '*'로 표시됩니다.</li>
                                <li>개인정보 보호를 위해 전체 아이디 확인은 <span class="c_red">[본인인증으로 찾기]</span>를 이용해주세요.</li>
                            </ul>
                        </div>
                        <div>
                            <h3 class="bl_h3">회원가입 정보</h3>
                            <ul class="list1 box_mini mb_10">
                                <li><span class="c_blue">가입일 : </span>2017년 11월 22일</li>
                            </ul>
                        </div> -->
                        <br>
                    </div>
                    <div class="btn_big">
                        <input type="button" value="확 인" class="agree wps_100" onclick="location.href='index.jsp'">
                    </div>
                </div>

                <div class="btn_big">
                    <!-- <a href="#" class="no_agree" title="메인이동">본인인증으로 찾기</a> -->
                    <input type="submit" value="비밀번호 재설정" class="no_agree last">
                </div>
            </fieldset>
        </form>
    </div>
    <!-- //login -->

</body>
</html>
