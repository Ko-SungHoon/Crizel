<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.*" %>
<%
/* Map<String,Object> crizelMap = new HashMap<String,Object>();
crizelMap.put("id", "rhzhzh3");
crizelMap.put("nick", "크리젤");
request.getSession().setAttribute("login", crizelMap); */
%>
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
		<li><a href="/board.do?pageParam=1">게시판</a></li>
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
	
	<!--
		<div class="drop_btn" style="width: 100%; text-align: center;">
		<span>메뉴</span>
		</div> 
	-->
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

<!-- The Modal -->
	<div id="myModal" class="modal">
		<!-- Modal content -->
		<div class="modal-content">
			<table>
				<tr>
					<c:if test="${login eq null}">
						<td colspan="2">로그인</td>
					</c:if>
				</tr>
				<tr>
					<td>ID</td>
					<td><input type="text" name="id" id="id"></td>
				</tr>
				<tr>
					<td>PW</td>
					<td><input type="password" name="pw" id="pw"></td>
				</tr>
				<tr>
					<td colspan="2"><input type="button" value="로그인" id="call">
						&nbsp; <input class="modalClose" type="button" value="닫기"
						style="cursor: pointer;"></td>
				</tr>
			</table>
		</div>
	</div>


	<script>
	
	$(function(){
		var modal = document.getElementById('myModal');
		var btn = document.getElementById("myBtn");
		var modalClose = document.getElementsByClassName("modalClose")[0];
		
		$("#myBtn").click(function(){
			$("#myModal").css("display", "block");
		});
		$("#modalClose").click(function(){
			$("#myModal").css("display", "none");
		});
		window.onclick = function(event) {
			if (event.target == modal) {
				modal.style.display = "none";
			}
		}
	});
		
	</script>