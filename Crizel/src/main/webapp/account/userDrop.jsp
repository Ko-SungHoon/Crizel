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
    <!--<link rel="Shortcut Icon" href="../../images/favicon.ico">--><!-- // favicon -->
    <link rel="stylesheet" type="text/css" href="css/default.css" media="all">
    <link rel="stylesheet" type="text/css" href="css/login.css" media="all">
    <script type="text/javascript" src="js/jquery-1.11.3.min.js"></script>
    <!-- [if lt IE 9]>
        <script type="text/javascript" src="js/html5.js"></script>
        <script type="text/javascript" src="js/respond.js"></script>
    <![endif] -->
    <script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
</head>
<body>
    <!-- login -->
    <div class="login_area">
        <form id="login_form" name="login_form">
            <fieldset>
                <legend>로그인</legend>
                <div class="box_area mt_50">
                    <h1 class="blind">경남대표도서관</h1>
                    <p class="logo">
                        <a href="/" title="메인화면">
                            <img src="../../images/common/logo_top.png" alt="경남대표도서관">
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
                            <li>성명 : 홍길동 (wisd4d)</li>
                            <li>회원번호 : 200004</li>
                            <li>탈퇴가능 여부 : 대출중 도서 없음 (회원탈퇴 가능)</li>
                        </ul>
                    </div>
                </div>
                <div class="btn_big">
                    <a href="#" class="no_agree" title="메인이동">취소</a><input type="submit" value="회원탈퇴" class="agree last">
                </div>
            </fieldset>
        </form>
    </div>
    <!-- //login -->

</body>
</html>
