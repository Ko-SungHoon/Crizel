<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="menu">
	<ul>
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
		<li><a href="/directory.do">파일</a></li>
		<li><a href="#">링크</a>
			<ul>
				<li><a href="/nyaa.do">Nyaa</a></li>
				<li><a href="/torrent.do">TORRENT</a></li>
				<li><a href="/onejav.do">ONEJAV</a></li>
				<li><a href="/diary.do">일기</a></li>
				<li><a href="https://5nani.com/xe/index.php?mid=manko">화성지부</a></li>
				<li><a href="http://www.youtube-audio.com/" target="blank">유튜브 mp3</a></li>
				<li><a href="http://www.anissia.net/anitime/" target="_blank">애니시아</a></li>
				<li><a href="https://hentaku.net/poombun.php">검색기</a></li>
			</ul></li>
		<li><a href="/board.do">게시판</a></li>
	</ul>
</div>