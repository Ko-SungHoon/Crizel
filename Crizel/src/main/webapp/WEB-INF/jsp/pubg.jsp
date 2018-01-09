<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/jsp/header.jsp" />
<title>PUBG</title>
<style type="text/css">
.region_mode{display: block;}
.region_mode:hover{background: #525252;}
.on{background: #525252;}
</style>
<script>
function setChange(region, mode){
	$("#region").val(region);
	$("#mode").val(mode);
	$("#getForm").submit();
}

$(function(){
	var region = $("#region").val();
	var mode = $("#mode").val();
	$("#"+region).addClass("on");
	$("#"+mode).addClass("on");
});
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/menu.jsp" />
	<div class="content">
<table class="tbl_type01">	
	<colgroup>
		<col width="25%">
		<col width="25%">
		<col width="25%">
		<col width="25%">
	</colgroup>
	<thead>
	<tr>
		<td>
			<a href="javascript: setChange('krjp', '${mode}')" class="region_mode" id="krjp">KR/JP</a>
		</td>
		<td>
			<a href="javascript: setChange('agg', '${mode}')" class="region_mode" id="agg">ASIA</a>
		</td>
		<td colspan="2"></td>
	</tr>
	<tr>
		<td>
			<a href="javascript: setChange('${region}', 'solo')" class="region_mode" id="solo">SOLO</a>
		</td>
		<td>
			<a href="javascript: setChange('${region}', 'duo')" class="region_mode" id="duo">DUO</a>
		</td>
		<td>
			<a href="javascript: setChange('${region}', 'squad')" class="region_mode" id="squad">SQUAD</a>
		</td>
		<td>
		</td>
	</tr>
	<tr>
		<td colspan="4">
			<form id="getForm" action="pubg.do" method="get">
				<input type="text" name="nickname" id="nickname" value="${data.nickname}">
				<input type="hidden" name="region" id="region" value="${region}">
				<input type="hidden" name="mode" id="mode" value="${mode}">
				<input type="submit" value="검색">
			</form>
		</td>
	</tr>	
	</thead>
		<c:if test="${data ne null}">
		<c:choose>
			<c:when test="${data.searchResult eq 'Y' }">
					<tbody>
						<tr>
							<th colspan="4">${data.nickname}</th>
						</tr>
						<tr>
							<th>항목</th>
							<th>수치</th>
							<th>상위 %</th>
							<th>순위</th>
						</tr>
						<tr>
							<td>레이팅</td>
							<td>
								${data.resultMap.Rating}
							</td>
							<td>
								${data.resultMap.Rating_percentile} %
							</td>
							<td>
								${data.resultMap.Rating_rank} 위
							</td>
						</tr>
						<tr>
							<td>KD</td>
							<td>
								${data.resultMap.KillDeathRatio} %
							</td>
							<td>
								${data.resultMap.KillDeathRatio_percentile} %
							</td>
							<td>
								${data.resultMap.KillDeathRatio_rank} 위
							</td>
						</tr>
						<tr>
							<td>KDA</td>
							<td>
								${data.resultMap.Kills}/${data.resultMap.Losses}/${data.resultMap.Assists} 
							</td>
							<td>
							</td>
							<td>
							</td>
						</tr>
						<tr>
							<td>승률</td>
							<td>${data.resultMap.WinRatio} %</td>
							<td>
								${data.resultMap.WinRatio_percentile} %
							</td>
							<td>
								${data.resultMap.WinRatio_rank} 위
							</td>
						</tr>
						<tr>
							<td>평균 딜량</td>
							<td>${data.resultMap.DamagePg}</td>
							<td>
								${data.resultMap.DamagePg_percentile} %
							</td>
							<td>
								${data.resultMap.DamagePg_rank} 위
							</td>
						</tr>
						<tr>
							<td>헤드샷</td>
							<td>${data.resultMap.HeadshotKills}</td>
							<td>
								${data.resultMap.HeadshotKills_percentile} %
							</td>
							<td>
								${data.resultMap.HeadshotKills_rank} 위
							</td>
						</tr>
						<tr>
							<td>최다킬</td>
							<td>${data.resultMap.RoundMostKills}</td>
							<td>
								${data.resultMap.RoundMostKills_percentile} %
							</td>
							<td>
								${data.resultMap.RoundMostKills_rank} 위
							</td>
						</tr>
						<tr>
							<td>게임 수</td>
							<td>${data.resultMap.RoundsPlayed}</td>
							<td>
								${data.resultMap.RoundsPlayed_percentile} %
							</td>
							<td>
								${data.resultMap.RoundsPlayed_rank} 위
							</td>
						</tr>
					</tbody>
			</c:when>	
			<c:otherwise>
				<tfoot>
					<tr>
						<td colspan="4">검색결과가 없습니다.</td>
					</tr>
				</tfoot>
			</c:otherwise>
		</c:choose>
		</c:if>
</table>
	</div>
</body>
</html>