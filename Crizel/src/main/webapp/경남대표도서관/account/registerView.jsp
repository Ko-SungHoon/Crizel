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
    <%
    	String name = request.getParameter("name")==null?"":request.getParameter("name");
    %>
    </script>
</head>
<body>
    <!-- login -->
    <div class="login_area">
        <form id="login_form" name="login_form" action="index.jsp" method="get">
            <fieldset>
                <legend>로그인</legend>
                <div class="complete box_area">
                    <h1 class="blind">경남대표도서관</h1>
                    <p class="logo">
                        <a href="/" title="메인화면">
                            <img src="images/common/logo_top.png" alt="경남대표도서관">
                        </a>
                    </p>
                    <h2 class="blind">경남대표도서관 회원가입완료</h2>
                    <div class="guide_msg">
                        <p class="tit">회원가입이 완료되었습니다.</p>
                        <p><strong><%=name%></strong>님 회원가입이 완료되었습니다.</p>
                    </div>

                    <div class="msg">
                        <div>
                            <h3 class="bl_h3 mt_30">회원증 발급장소</h3>
                            <ul class="list1 box_mini mb_10">
                                <li>도서 대출은 카드 발급 후 이용 가능합니다.</li>
                                <li>디지털자료실 (경남대표도서관 본관 1층)</li>
                            </ul>
                        </div>
                        <div>
                            <h3 class="bl_h3">회원증 발급 요건</h3>
                            <ul class="list1 box_mini mb_10">
                                <li><span class="c_red">경상남도</span>에 주민등록이 되어 있는 자</li>
                                <li><span class="c_red">경상남도</span> 소재 직장 또는 학교에 재직하거나 재학 중인 자</li>
                            </ul>
                        </div>
                        <div>
                            <h3 class="bl_h3">회원증 주의사항</h3>
                            <ul class="list1 box_mini mb_10">
                                <li><span class="c_red">본인 및 자격 확인에 필요한 신분증 및 구비서류는 원본</span>을 제출하셔야 합니다.</li>
                                <li>여권은 소재지 정보가 없어 사용이 불가합니다.</li>
                                <li>사원증 및 명함에는 서울 주소가 반드시 기재되어 있어야 합니다.</li>
                            </ul>
                        </div>
                        <br>
                    </div>
                    <div class="btn_big">
                        <input type="submit" value="확 인" class="agree wps_100">
                    </div>
                </div>
            </fieldset>
        </form>
    </div>
    <!-- //login -->

</body>
</html>
