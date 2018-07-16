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
</head>

<body>

    <!-- login -->
    <div class="login_area">
        <form id="login_form" name="login_form">
            <fieldset>
                <legend>아이디찾기</legend>
                <div class="lang_sel">
                </div>

                <div class="box_area mt_100">
                    <h1 class="blind">경남대표도서관</h1>
                    <p class="logo">
                        <a href="/" title="메인화면">
                            <img src="images/common/logo_top.png" alt="경남대표도서관">
                        </a>
                    </p>
                    <h2 class="blind">경남대표도서관 아이디찾기</h2>

                    <div class="guide_msg id_find">
                        <p class="tit">아이디찾기</p>
                        <p>경남도서관 홈페이지 아이디를 잊으셨나요?</p>
                    </div>

                    <!-- 가입정보로 찾기 -->
                    <div class="find_id">
                        <!-- 본인인증으로 찾기 -->
                            <div class="certify">
                                <div class="certify1">
                                    <p class="bl_point mb_10">휴대폰인증</p>
                                    <p class="txt_small">정보통신망법 및 개인정보보호법 개정에 따라 주민번호를 사용하지 않고 <span class="c_red">휴대폰 인증</span>이 가능하도록 제공하고 있습니다.</p>
                                    <p class="txt_small">
                                        이용하고 계신 이동통신사를 선택하신 후 이름 및 휴대폰번호 등의 본인확인 정보를 통해 인증을 완료하시기 바랍니다.<br>
                                        <span class="c_blue block pt_10">※ 안내 1600-1522</span>
                                    </p>
                                    <p class="btn_medium">
                                        <a href="idSearchView.jsp" onclick="">휴대폰 인증받기</a>
                                    </p>

                                </div>
                                <div class="certify1">
                                    <div>
                                        <p class="bl_point mb_10">공공 아이핀(I-PIN) 인증</p>
                                        <p class="txt_small">
                                            회원가입 시 개인정보보호를 위해 주민등록번호 외 본인확인할 수 있는 <span class="c_red">공공 아이핀(I-PIN)</span>을 운영중입니다.
                                            <br><span class="c_blue block pt_10">※ 안내 02-2031-8500</span>
                                        </p>
                                        <p class="btn_medium">
                                            <a href="#" onclick="">아이핀 인증받기</a>
                                        </p>
                                    </div>
                                    <div class="box_mini mt_30">
                                        <p class="mb_10 txt_small c_bk1"><strong>※ 아이핀(I-PIN)인증 안내</strong></p>
                                        <p class="txt_small">
                                            <span class="c_red">아이핀(I-PIN) 이란? :</span> 회원가입 시 주민등록번호를 사용하지 않고도 본인임을 확인할 수 있는 개인정보보호 서비스입니다.
                                            <br>
                                            <a href="http://www.gpin.go.kr/center/info/box_miniInfo.gpin" target="_blank" title="새창 열림" class="btn_mini">자세히보기</a>
                                        </p>
                                        <p class="txt_small mt_20">
                                            <span class="c_red">발급안내 :</span> I-PIN발급(회원가입)에는 "온라인 발급 및 방문신청 발급" 두 가지 방법이 있습니다.
                                            <br><a href="http://www.gpin.go.kr/center/info/issueInfo.gpin" target="_blank" title="새창 열림" class="btn_mini">아이핀(I-PIN)발급 안내</a>
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <!-- //본인인증으로 찾기 -->
                    </div>
                </div>
            </fieldset>
        </form>

    </div>
    <!-- //login -->

</body>
</html>
