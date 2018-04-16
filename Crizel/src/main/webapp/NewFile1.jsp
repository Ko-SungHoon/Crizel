<style type="text/css">
/* login */
.box_area.login_top {margin-top:20px;}
.login_area{position:relative;width:460px;margin:0 auto;height:100%;padding-bottom:10px;}
.login_area .goMain{position:absolute;top:7px;left:0;}
.login_area .goMain img{vertical-align:top}
.login_area .logo{float:none;text-align:center;padding-bottom: 20px;border-bottom: 1px solid #ddd;margin-bottom:5px;}
.login_area .input_form{margin:30px 0 15px;}
.login_area .input_form input{width:100%;height:49px;border:1px solid #dadada;text-indent:13px}
.login_area .input_form input:active, .login_area .input_form  input:focus{border: 1px solid #085dc0; outline:0;}
.login_menu.no_line{border:none;margin:0 0 20px;padding-top: 10px;}
.login_menu.tabmenu .on{background: #2587e1;color: #fff;border: 1px solid #2587e1;}
.login_menu a.col_2{width:49%; height: 50px; line-height:50px;padding:0;}
.login_menu{border-top: 1px solid #e4e4e5;width: 100%;margin-top: 20px;padding-top: 20px;text-align: center;margin-bottom: 20px;}
.login_menu a{letter-spacing:-0.05em;display: inline-block;height: 40px;line-height: 38px;padding: 0 15px;border: 1px solid #175bc4;color: #175bc4;font-size: 14px;border-radius: 3px;}
.login_menu a::after{content:">"; padding-left:10px;/*text-decoration: underline;*/text-decoration-color: #fff;}
.login_menu a:first-child{margin-left:0}

/*입력 오류 안내*/
.no_alert{position:relative;margin-bottom:20px;padding:0px 0px 10px 0px;font-size:13px;line-height:1.4em;color:#ff0000;}

/* btn */
.btn_big .agree.wps_100 {width:100%;}
.btn_medium{margin:25px 0 15px;text-align:center}
.btn_medium a{display:inline-block;padding:15px 40px;background-color: #444;font-size:16px;color:#fff}
.btn_big{text-align:center; margin-bottom:20px;}
.btn_big .no_agree{display:inline-block;width:210px;height:58px;margin-right:15px;color: #1e4da4;font-size:20px;border: 1px solid #1e4da4;vertical-align:top;line-height:58px;text-align:center;background-color:#fff;font-weight:100;}
.btn_big .agree{line-height:60px;width:229px;height:60px;color:#fff;font-size:20px;border:none;background-color: #1e4da4;vertical-align:top;text-align:center;}
.btn_mini{padding: 2px 5px;border: 1px solid #9999b1;color: #1e4da4;font-size: 12px;border-radius: 5px; background: #fff;}

@media all and (max-width:480px){
.login_area{width:100%; }
.login_menu a {width:100%;margin-bottom:8px;}

</style>

    <!-- login -->
    <div class="login_area">
        <form id="login_form" name="login_form" action="<%= request.getContextPath() %>/index.lib?contentsSid=176" method="post" onsubmit="return rememberUserid(this)">
            <input type="hidden" name="return" value="<%= request.getParameter("return") %>">
			<input type="hidden" name="hash">
            <fieldset>
                <legend>로그인</legend>
                <div class="box_area login_top">
                    <div class="input_form">
                        <p class="">아이디</p>
                        <p class="input_id"><input type="text" id="userid" name="userid" title="아이디" placeholder="아이디"></p>
                        <p class="mt_20">비밀번호</p>
                        <p class="input_pw"><input type="password" id="passwd" name="passwd" title="비밀번호" placeholder="비밀번호"></p>

                        <!-- [개발자]입력 오류 안내 : 입력오류시 안내합니다. -->
<%if("true".equals( request.getParameter("loginFail")) ) {%>
                        <div class="no_alert">
                            <p>※ 아이디 또는 비밀번호를 다시 입력해 주세요.</p>
                            <p>※ 등록되지 않은 아이디이거나, 아이디 또는 비밀번호를 잘못 입력하셨습니다.</p>
                        </div>
<%}%>
                        <!-- //입력 오류 안내 -->

                    </div>
                    <div class="btn_big mb_10">
                        <input type="submit" value="로그인" class="agree wps_100">
                    </div>
                    <p class="save_id">
                        <input type="checkbox" id="saveId" name="saveId">
                        <label for="saveId">아이디 저장</label></p>
<div class="login_menu">
                        <a href="http://27.101.166.44:9090/kcms/Membership/step_01/MA" target="_blank" title="회원가입">회원가입</a>
                        <a href="http://27.101.166.44:9090/kcms/Login/IdSearchPage/MA" target="_blank" title="아이디 찾기">아이디 찾기</a>
                        <a href="http://27.101.166.44:9090/kcms/Login/PwSearchPage_01/MA" target="_blank" title="비밀번호 재부여">비밀번호 재부여</a>
</div>
                </div>
            </fieldset>
        </form>
    </div>
    <!-- //login -->
<script language="javascript">

$(function(){
    var userid = getCookie('userid');
    if( userid != '' ) {
       $("input[name='userid']").val(userid);
    }
});

function rememberUserid(frm) {
	frm.hash.value = location.hash;
	if( frm.saveId.checked ) {
      setCookie('userid', frm.userid.value, 7);
    }
}

var setCookie = function(name, value, exp) {
  var date = new Date();
  date.setTime(date.getTime() + exp*24*60*60*1000);
  document.cookie = name + '=' + value + ';expires=' + date.toUTCString() + ';path=/';
};

var getCookie = function(name) {
  var value = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
  return value? value[2] : null;
};
</script>                                                                                                                                                                                        