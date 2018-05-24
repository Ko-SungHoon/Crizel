<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp"/>
<title>Admin</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<style type="text/css">
</style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/menu.jsp"/>
<div class="content">
	<div class="search center">
		<a href="/menuInsertPage.do?menu_level=1">1차메뉴 추가</a>
		<a href="/menuInsertPage.do?menu_level=2">2차메뉴 추가</a>
		<a href="/menuInsertPage.do?menu_level=3">3차메뉴 추가</a>
	</div>
	<table class="tbl_type02">	
		<colgroup>
			<col width="30%" />
			<col width="70%" />
		</colgroup>
		<tr>
			<th>1차메뉴</th>
			<td>
				<select id="menu_1">
				</select>
			</td>
		</tr>
		<tr>
			<th>2차메뉴</th>
			<td>
				<select id="menu_2">
				</select>
			</td>
		</tr>
		<tr>
			<th>메뉴명</th>
			<td><input type="text" id="menu_title" name="menu_title"></td>
		</tr>
		<tr>
			<th>보이기 여부</th>
			<td>
				<label for="view_y"><input type="radio" id="view_y" name="view_yn" value="Y">보이기</label>
				<label for="view_n"><input type="radio" id="view_n" name="view_yn" value="N">숨김</label>
			</td>
		</tr>
		<tr>
			<th>메뉴타입</th>
			<td>
				<select id="menu_type" name="menu_type">
					<option value="content">컨텐츠</option>
					<option value="board">게시판</option>
					<option value="url">URL</option>
				</select>
			</td>
		</tr>
		<tr>
			<th>메뉴 내용</th>
			<td>
				<textarea cols="10" id="content" name="content" style="width: 90%;"></textarea>
			</td>
		</tr>
	</table>
</div>
</body>
</html>