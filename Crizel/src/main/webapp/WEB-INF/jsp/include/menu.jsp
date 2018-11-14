<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script>
$(function(){
	$("#home").click(function(){
		if($(".menu li").css("display") != "block"){
			$(".menu").css("display","inline-block");
			$(".menu li").css("display","block");
		}else{
			$(".menu").css("display","none");
			$(".menu li").css("display","none");
		}
	});
});
</script>
<style>
</style>
<nav class="header">
	<a class="logo" href="/">CRIZEL</a>
	<ul class="mobMenu">
		<li id="home"><span>메뉴</span></li>
	</ul>
	<ul class="menu">
		<li><a href="/index.jsp">홈</a></li>
		<li><a href="/list.do?mode=nyaa">리스트</a>
			<ul>
				<li><a href="/listInsertPage.do">추가</a></li>
			</ul>
		</li>
		<li><a href="/girls.do">사진</a>
			<ul>
				<li><a href="/girlsInsertPage.do">추가/삭제</a></li>
			</ul>
		</li>
		<li><a href="#">링크</a>
			<ul>
				<li><a href="/comic.do">만화</a></li>
				<li><a href="/nyaa.do">Nyaa</a></li>
				<li><a href="/music.do">MUSIC</a></li>
				<li><a href="/torrent.do">TORRENT</a></li>
				<li><a href="/onejav.do">ONEJAV</a></li>
				<li><a href="/mars.do">화성지부</a></li>
				<li><a href="/directory.do">파일</a></li>
				<li><a href="/diary.do">일기</a></li>
				<li><a href="/money.do">가계부</a></li>
				<li><a href="http://www.youtube-audio.com/" target="blank">유튜브 mp3 추출</a></li>
				<li><a href="http://www.anissia.net/anitime/" target="_blank">애니시아</a></li>
				<li><a href="https://hentaku.net/poombun.php">검색기</a></li>
				<li><a href="/test.do">TEST</a></li>
			</ul></li>
		<li><a href="/board.do">게시판</a></li>
	</ul>
	<span class="login_menu">
		<c:if test="${login eq null}">
			<a href="/loginPage.do">로그인</a>
			<a href="/registerPage.do">회원가입</a>
		</c:if>
		
		<c:if test="${login ne null}">
			<a href="/logout.do">로그아웃</a>
		</c:if>
	</span>
</nav>

<style>
 #remoCon {
	position: fixed;
	width: 80px;
	height: 20px;
	right: 0px;
	bottom: 0px;
	display: none;
	padding: 10px;
	color:black;
 } 
</style>
<script>
$(document).scroll(function(){
	var con = $("#remoCon");
	var position = $(window).scrollTop();
	if(position > 250){ con.fadeIn(500); }
	else if(position < 250){ con.fadeOut(500); }
});
$(function(){
	$("#remoCon").click(function(){
		$("html, body").animate({scrollTop: 0}, 300);
	 });	
});

</script>

<span id="remoCon">
	Going Up 
</span> 