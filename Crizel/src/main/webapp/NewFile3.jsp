<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %><%@ include file="/include/config.jsp" %>
<c:choose>
	<c:when test="${fn:length(itemList) > 0}">
		<div id="bookList3" style="padding: 0; margin: 0">
		<c:forEach var="item" items="${itemList}" varStatus="status">
			<a href="/book/detail.es?mid=${es:SearchXSS(param.mid)}&amp;vCtrl=${item.CTRLNO}&amp;vLoca=${item.LOCA}">
				<c:if test="${not empty item.COVER_SMALLURL and empty item.IMAGE_URL}">
					<img src="${item.COVER_SMALLURL}" alt="${es:convertHtmlchars(item.TITLE)}" onerror="this.src='/cwlib/img/sub/no_img.gif';" width="155">
				</c:if>
				<c:if test="${empty item.COVER_SMALLURL and not empty item.IMAGE_URL}">
					<img src="${item.IMAGE_URL}" alt="${es:convertHtmlchars(item.TITLE)}" onerror="this.src='/cwlib/img/sub/no_img.gif';" width="155">
				</c:if>
				<c:if test="${empty item.COVER_SMALLURL and empty item.IMAGE_URL}">
					<img src="/cwlib/img/sub/no_img.gif" alt="${es:convertHtmlchars(item.TITLE)}" width="155">
				</c:if>
			</a>
		</c:forEach>
		</div>
	</c:when>
	<c:otherwise>
		<p style="text-align: center; padding:50px 0 0 0;">등록된 게시물이 없습니다.</p>
	</c:otherwise>
</c:choose>

<script>
$(document).ready(function() {
	$("#bookList3").carouFredSel({
		circular	: true,
		width : '100%',
		align: "left",
		direction	: "left",
		auto        : {button : "#bookList_play3", pauseDuration : 3000, duration: 800},
		scroll		: {items : 1},
		items : {
			width : 103,
			height : 130,
			visible : {
				min : 3,
				max : 3
			}
		},
		swipe: {
			onMouse: true,
			onTouch: true
		}
	});
	$("#bookList3").swipe({
		excludedElements: "button, input, select, textarea, .noSwipe",
		swipeLeft: function() {
			$('#bookList3').trigger('next');
		},
		swipeRight: function() {
			$('#bookList3').trigger('prev');
		}
	});
});
</script>





<%-- 
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %><%@ include file="/include/config.jsp" %>
<c:choose>
	<c:when test="${fn:length(itemList) > 0}">
		<c:forEach var="item" items="${itemList}" varStatus="status">
<dl>
	<dt><a href="/book/detail.es?mid=${es:SearchXSS(param.mid)}&amp;vCtrl=${item.CTRLNO}&amp;vLoca=${item.LOCA}">${es:subString(es:convertHtmlchars(item.TITLE),0,100)}</a></dt>
	<dd class="photo"><a href="/book/detail.es?mid=${es:SearchXSS(param.mid)}&amp;vCtrl=${item.CTRLNO}&amp;vLoca=${item.LOCA}">
		<c:if test="${not empty item.COVER_SMALLURL and empty item.IMAGE_URL}">
			<img src="${item.COVER_SMALLURL}" alt="${es:convertHtmlchars(item.TITLE)}" onerror="this.src='/cwlib/img/sub/no_img.gif';" width="155">
		</c:if>
		<c:if test="${empty item.COVER_SMALLURL and not empty item.IMAGE_URL}">
			<img src="${item.IMAGE_URL}" alt="${es:convertHtmlchars(item.TITLE)}" onerror="this.src='/cwlib/img/sub/no_img.gif';" width="155">
		</c:if>
		<c:if test="${empty item.COVER_SMALLURL and empty item.IMAGE_URL}">
			<img src="/cwlib/img/sub/no_img.gif" alt="${es:convertHtmlchars(item.TITLE)}" width="155">
		</c:if>
	</a></dd>
	<dd>
		<ul>
			<li>${item.AUTHOR}</li>
			<li>출판사 : ${item.PUBLER}</li>
			<li>출판년도 : ${item.PUBLER_YEAR}</li>
			<li>소장도서관 : ${item.LOCA_NAME}</li>
		</ul>
	</dd>
</dl>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<p style="text-align: center; padding:25px 0 0 0;">등록된 자료가 없습니다.</p>
	</c:otherwise>
</c:choose>

<span class="btn_more" style="float: right;"><a href="/book/new_book/search.es?mid=${es:SearchXSS(param.mid)}"><img src="/${siteDetail.site_url}/img/main/btn_more.gif" alt="신착도서 더보기"></a> </span>

 --%>