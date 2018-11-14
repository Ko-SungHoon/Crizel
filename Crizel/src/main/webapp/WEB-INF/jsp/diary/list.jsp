<%@page import="com.ibm.icu.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/include/header.jsp" />
<title>Diary</title>
<script>
function dayChange(value){
	location.href="/diary.do?dayChange="+value +"&month="+$("#month").val()+"&year="+$("#year").val();
}
</script>
<style type="text/css">
</style>
</head>
<body>
<%@include file="/WEB-INF/jsp/include/menu.jsp" %>
<div class="content">
	<input type="hidden" name="month" id="month" value="${cal.month}">
	<input type="hidden" name="year" id="year" value="${cal.year}">
	<div class="search">
		<%!
		public String numberFormat(String val){
			if(Integer.parseInt(val) < 10){
				val = "0" + val;
			}
			return val;
		}
		%>
		<%
		Map<String,Object> map = (Map<String,Object>)request.getAttribute("cal");
		String year = request.getParameter("year")==null? map.get("year").toString() :request.getParameter("year");
		String month = request.getParameter("month")==null? numberFormat(map.get("month").toString()) :request.getParameter("month");
		Calendar cal = Calendar.getInstance();
		String monthArr[] = {"01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"};
		%>
		<form action="/diary.do" method="post" id="postForm">
			<select name="year">
				<%
				for(int i=cal.get(Calendar.YEAR) ; i>=2016; i--){
				%>
					<option value="<%=i%>" <%if(Integer.toString(i).equals(year)){%> selected <%}%> ><%=i%>년</option>
				<%
				}
				%>
			</select>
			<select name="month">
				<%
				for(int i=0; i<monthArr.length; i++){
				%>
					<option value="<%=monthArr[i]%>" <%if(monthArr[i].equals(month)){%> selected <%}%> ><%=monthArr[i]%>월</option>
				<%
				}
				%>
			</select>
			<button>검색</button>
		</form>
	</div>
	<table class="tbl_type01">
		<colgroup>
			<col style="width:14.285%" />
			<col style="width:14.285%" />
			<col style="width:14.285%" />
			<col style="width:14.285%" />
			<col style="width:14.285%" />
			<col style="width:14.285%" />
			<col style="width:14.285%" />
		</colgroup>
		<thead>
			<tr>
				<th colspan="2" class="cal_pre" >
					<span onclick="dayChange('pre')">이전달</span>
				</th>
				<th colspan="3" class="cal_date">
					${cal.year}년 ${cal.month}월
				</th>
				<th colspan="2" class="cal_next">
					<span onclick="dayChange('next')">다음달</span>
				</th>
			</tr>
			<tr>
				<th scope="col" class="sun">일</th>
				<th scope="col">월</th>
				<th scope="col">화</th>
				<th scope="col">수</th>
				<th scope="col">목</th>
				<th scope="col">금</th>
				<th scope="col" class="sat">토</th>
			</tr>
		</thead>
		<tbody>
			<c:set var="dayValCheck" value="0"/>
			<c:set var="dayVal" value="1"/>
			<c:set var="dayVal2" value="1"/>
			<c:set var="useCheck" value="N"/>		
			
			<c:forEach begin="0" end="${cal.weekNum-1}" var="i">
				<tr>
					<c:forEach begin="0" end="6" var="j">
						<c:set var="dayValCheck" value="${dayValCheck+1}"/>
						<fmt:formatNumber var="fmtMonth" minIntegerDigits="2" value="${cal.month}" type="number"/>
						<fmt:formatNumber var="fmtDay" minIntegerDigits="2" value="${dayVal}" type="number"/>
								
						<td
							<c:choose>
								<c:when test="${j == '0'}">class="sun"</c:when>
								<c:when test="${j == '6'}">class="sat"</c:when>
							</c:choose>
						>
							<c:if test="${dayValCheck >= cal.startNum and dayVal <= cal.lastNum}">
								<c:set var="dayVal2" value="${cal.year}-${fmtMonth}-${fmtDay}" />
								
								<c:forEach items="${cal.useDay}" var="ob">
									<c:if test="${ob eq dayVal2}">
										<c:set var="useCheck" value="Y"/>
									</c:if>
								</c:forEach>
								
								<c:forEach items="${cal.holiday}" var="ob">
									<c:if test="${ob eq dayVal2}">
										<span class="holiday"></span>
									</c:if>
								</c:forEach>
								
								<a href="/diaryContent.do?day=${cal.year}-${cal.month}-${dayVal}" <c:if test="${useCheck eq 'Y'}">class="on"</c:if> >
									${dayVal} 
								</a>
								<c:set var="useCheck" value="N"/>
								<c:set var="dayVal" value="${dayVal+1}"/>
							</c:if>
						</td>
					</c:forEach>
				</tr>
			</c:forEach>
			
			
			<%-- <c:forEach begin="0" end="${cal.calCnt}" var="i">
				<c:if test="${i%7 eq 1 or i eq 0}">
					<tr>
				</c:if>
				<c:choose>
					<c:when test="${i >= cal.startNum and j <= cal.lastNum }">
						<c:choose>
						<c:when test="${i%7 eq 1 }">
							<td class="sun">
						</c:when>
						<c:when test="${i%7 eq 0 }">
							<td class="sat">
						</c:when>
						<c:otherwise>
							<td>
						</c:otherwise>
					</c:choose>
					
					
					<c:choose>
						<c:when test="${cal.month < 10}">
							<c:choose>
								<c:when test="${j < 10}">
									<c:set var="j2" value="${cal.year}-0${cal.month}-0${j}" />
								</c:when>
								<c:otherwise>
									<c:set var="j2" value="${cal.year}-0${cal.month}-${j}" />
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<c:choose>
								<c:when test="${j <10}">
									<c:set var="j2" value="${cal.year}-${cal.month}-0${j}" />
								</c:when>
								<c:otherwise>
									<c:set var="j2" value="${cal.year}-${cal.month}-${j}" />
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
					
					<c:forEach items="${cal.useDay}" var="ob">
						<c:if test="${ob eq j2}">
							<c:set var="useCheck" value="Y"/>
						</c:if>
					</c:forEach>
					
					<c:forEach items="${cal.holiday}" var="ob">
						<c:if test="${ob eq j2}">
							<span class="holiday"></span>
						</c:if>
					</c:forEach>
					
					<a href="/diaryContent.do?day=${cal.year}-${cal.month}-${j}" <c:if test="${useCheck eq 'Y'}">class="on"</c:if> >${j}</a>
					<c:set var="useCheck" value="N"/>
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
					</tr>
				</c:if>
			</c:forEach> --%>

		</tbody>
	</table>
</div>
</body>
</html>