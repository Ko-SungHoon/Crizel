<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>Money</title>
<script type="text/javascript">
</script>
<style type="text/css">
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp" />
	<div class="content">
		<table class="tbl_type01">
			<colgroup>
				<col style="width:14%;"/>
				<col style="width:14%;"/>
				<col style="width:14%;"/>
				<col style="width:14%;"/>
				<col style="width:14%;"/>
				<col style="width:14%;"/>
				<col style="width:14%;"/>
			</colgroup>
			<tr>
				<th colspan="7">
					<div class="moneyRemote">
						<form action="/main.do" method="post">
							<select name="y">
								<option value="2017">2017</option>
								<option value="2016">2016</option>
								<option value="2015">2015</option>
								<option value="2014">2014</option>
							</select> 년 <select name="m">
								<c:set var="i" value="1" />
								<c:forEach begin="1" end="12">
									<c:choose>
										<c:when test="${i eq month+1}">
											<option value="${i}" selected="selected">${i}</option>
										</c:when>
										<c:otherwise>
											<option value="${i}">${i}</option>
										</c:otherwise>
									</c:choose>
			
									<c:set var="i" value="${i+1}" />
								</c:forEach>
							</select> 월 <input type="submit" value="이동" class="btn06"> <input
								type="hidden" id="id" name="id" value="${login.id}">
						</form>
			
						<c:set var="j" value="1" />
						<c:choose>
							<c:when test="${month>0}">
								<a href="/main.do?y=${year}&m=${month}&id=${login.id}"
									style="text-decoration: none;">◁</a>
							</c:when>
							<c:when test="${month eq 0}">
								<c:set var="preyear" value="${year-1}" />
								<a href="/main.do?y=${preyear}&m=12&id=${login.id}"
									style="text-decoration: none;">◁</a>
			
							</c:when>
						</c:choose>
			
						${year} 년 ${month+1} 월
			
						<c:choose>
							<c:when test="${month<11}">
								<a href="/main.do?y=${year}&m=${month+2}&id=${login.id}"
									style="text-decoration: none;">▷</a>
							</c:when>
							<c:when test="${month eq 11}">
								<c:set var="nextyear" value="${year+1}" />
								<a href="/main.do?y=${nextyear}&m=1&id=${login.id}"
									style="text-decoration: none;">▷</a>
							</c:when>
						</c:choose>
					</div>
				</th>
			</tr>
			<tr>
				<th class="sun">일</th>
				<th>월</th>
				<th>화</th>
				<th>수</th>
				<th>목</th>
				<th>금</th>
				<th class="sat">토</th>
				<c:forEach begin="0" end="${cnt}" var="i">
					<c:choose>
						<c:when test="${i>=startNum and j<=lastNum}">
							<td onclick="location.href='/moneyDetail.do?year=${year}&month=${month}&day=${j}&id=${login.id}'" id="td_${j}">
								<c:choose>
									<c:when test="${i%7 eq 0}">
										<span class="sat">${j} </span>
									</c:when>
									<c:when test="${i%7 eq 1}">
										<span class="sun">${j} </span>
									</c:when>
									<c:otherwise>
												${j} 
									</c:otherwise>
								</c:choose> 
								<c:if test="${price[j-1].daySum ne null}">
										<br>
										<span class="day_price" id="price_${j}">${price[j-1].daySum}원</span>
								</c:if>
							</td>
							<c:set var="j" value="${j+1}" />
						</c:when>
						<c:otherwise>
							<c:if test="${i ne 0}">
								<td></td>
							</c:if>
						</c:otherwise>
					</c:choose>

					<c:if test="${i%7 eq 0}">
						<tr></tr>
					</c:if>
				</c:forEach>
			</tr>
			<tr>
				<td colspan="7">
					<a href="/totalList.do?year=${year}&month=${month}&id=${login.id}" style="display: block;">
						합계 : ${monthSum} 원
					</a>
				</td>
			</tr>
		</table>

	</div>
</body>
</html>