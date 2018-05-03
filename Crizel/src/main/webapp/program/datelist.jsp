<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ page import="org.apache.commons.jxpath.*,java.io.*,java.util.*,java.net.*" %>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>
<%@ page import="egovframework.rfc3.visitcounter.vo.VisitCounterVO" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="egovframework.rfc3.user.web.SessionManager"%>
<%@ include file="/program/class/UtilClass.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
/************************** 접근 허용 체크 - 시작 **************************/
SessionManager sessionManager = new SessionManager(request);
String sessionId = sessionManager.getId();
if(sessionId == null || "".equals(sessionId)) {
	alertParentUrl(out, "관리자 로그인이 필요합니다.", adminLoginUrl);
	if(true) return;
}

String roleId= null;
String[] allowIp = null;
Connection conn = null;
try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	// 접속한 관리자 회원의 권한 롤
	roleId= getRoleId(sqlMapClient, conn, sessionId);
	
	// 관리자 접근 허용된 IP 배열
	allowIp = getAllowIpArrays(sqlMapClient, conn);
} catch (Exception e) {
	sqlMapClient.endTransaction();
	alertBack(out, "트랜잭션 오류가 발생했습니다.");
} finally {
	sqlMapClient.endTransaction();
}

// 권한정보 체크
boolean isAdmin = sessionManager.isRole(roleId);

// 접근허용 IP 체크
String thisIp = request.getRemoteAddr();
boolean isAllowIp = isAllowIp(thisIp, allowIp);

/** Method 및 Referer 정보 **/
String getMethod = parseNull(request.getMethod());
String getReferer = parseNull(request.getHeader("referer"));

if(!isAdmin) {
	alertBack(out, "해당 사용자("+sessionId+")는 접근 권한이 없습니다.");
	if(true) return;
}
if(!isAllowIp) {
	alertBack(out, "해당 IP("+thisIp+")는 접근 권한이 없습니다.");
	if(true) return;
}
/************************** 접근 허용 체크 - 종료 **************************/

List<VisitCounterVO> counterVOList = (List<VisitCounterVO>)request.getAttribute("counterVOList");
VisitCounterVO counterVOs = (VisitCounterVO)request.getAttribute("counterVO");

//차트에 사용할 테이터 삽입
List<String> labels = new ArrayList<String>();

int maxDay = 0;


//해당 월의 총 날짜수 구하기
DateFormat df = new SimpleDateFormat("yyyyMM");
try
{
	Date date = df.parse(counterVOs.getAccessDate());
	Calendar cal = Calendar.getInstance();
	cal.setTime(date);
	
	maxDay = cal.getActualMaximum(cal.DAY_OF_MONTH);
}catch(Exception e)
{
	maxDay = 31;
}
double[] datelists = new double[maxDay];




for(VisitCounterVO c : counterVOList){
	//out.println((double)c.getAccessCount());
	//out.println(c.getAccessDate().substring(6,8));
	for(int dateCnt = 0 ; dateCnt < datelists.length;dateCnt++){
		if(dateCnt+1 == Integer.parseInt(c.getAccessDate().substring(6,8))){
			datelists[dateCnt] = (double)c.getAccessCount();
		}
		
	}
}	

%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<title>RFC3.0 관리자시스템</title>
		<meta name="title" content="관리자시스템" />
		<meta name="author" content=" skoinfo_KoSangA " />
		<meta name="keywords" content="RFC, 3.0, 관리자시스템 " />
		<meta name="description" content="RFC3.0 관리자시스템입니다." />
		<link href="<c:url value='/css/egovframework/rfc3/iam/import.css' />" rel="stylesheet" type="text/css" />	
		<script type='text/javascript' src='<c:url value='/js/egovframework/rfc3/iam/common.js' />'></script>
		<script type='text/javascript' src='<c:url value='/dwr/interface/selectDomainListForSgroupId.js' />'></script>
		<script type='text/javascript' src='<c:url value='/dwr/interface/selectDomainUserAdminList.js' />'></script>		
		<script type='text/javascript' src='<c:url value='/dwr/engine.js' />'></script>
		
		<script language="javascript" type="text/javascript" src="/jquery/jqplot/jquery.min.js"></script>
		  <script language="javascript" type="text/javascript" src="/jquery/jqplot/jquery.jqplot.min.js"></script>
		  <link rel="stylesheet" type="text/css" href="/jquery/jqplot/jquery.jqplot.min.css" />
		  <script class="include" language="javascript" type="text/javascript" src="/jquery/jqplot/jqplot.barRenderer.min.js"></script>
		  <script class="include" language="javascript" type="text/javascript" src="/jquery/jqplot/jqplot.categoryAxisRenderer.min.js"></script>
		  <script class="include" language="javascript" type="text/javascript" src="/jquery/jqplot/jqplot.pointLabels.min.js"></script>
		  <script type="text/javascript" src="/jquery/jqplot/jqplot.highlighter.js"></script> 
		  
		  <script type="text/javascript" src="/jquery/js/highcharts.js"></script>
		  <!-- 1a) Optional: the exporting module -->
		  <script type="text/javascript" src="/jquery/js/modules/exporting.js"></script>
		  
		<script type="text/javascript">
			function linkPage(pageNo) {
			    document.listForm.pageIndex.value = pageNo;
			    document.listForm.submit();
			}
			//도메인 선택
			function check_domain(val) {
				//총관리자 및 시스템 관리자
				<% if(EgovUserDetailsHelper.isRoleSym()) {%>
				selectDomainListForSgroupId.selectDomainListForSgroupId(val,callbackDomainList);
				//도메인 관리자 인경우
				<%} else if(EgovUserDetailsHelper.isRole("ROLE_RESTRICTED")) {%>
				selectDomainUserAdminList.selectDomainUserAdminList('<%=EgovUserDetailsHelper.getSgroupId()%>','<%=EgovUserDetailsHelper.getId()%>',callbackDomainList);
				<%}%>
				
			}
			//callbackDomainList
			function callbackDomainList(list) {
				var domainId=document.getElementById("domainId");
				var cnt=list.length;
				if(cnt > 0) {
					if(domainId) clearSelect(domainId,"--도메인--");
					initSelect(domainId,list);
				} else {
					if(domainId) clearSelect(domainId,"--도메인--");
				}
			}
			
			//초기화
			function clearSelect(obj,depth) {
				obj.length=0;
				var optionArray=new Array();
				var option =document.createElement("option");
				option.text="--"+depth+"--";
				option.value="";
				optionArray[optionArray.length]=option;
				for(var i=0 ; i < optionArray.length;i++) {
					try {
						obj.add(optionArray[i],null);
					} catch(e) {
						obj.add(optionArray[i],-1);
					}
				}
			}
			
			//입력하기
			function initSelect(obj,list) {
				var optionArray = new Array();
				for (var i = 0 ; i < list.length ; i++) {
					option = document.createElement("option");
					option.text = list[i].domainNm;
					option.value = list[i].domainId;
					optionArray[optionArray.length] = option;
				}
				for (var i = 0 ; i < optionArray.length ; i++) {
					try {
						obj.add(optionArray[i], null);
					} catch(e) {
						obj.add(optionArray[i], -1);
					}
				}
			}

			function downloadXls()
			{
				document.listForm.action = "datedownload.sko";
				document.listForm.submit();
				document.listForm.action = "datelist.sko";
			}

			var chart;
			$(document).ready(function() {
				chart = new Highcharts.Chart({
					chart: {
						renderTo: 'container',
						defaultSeriesType: 'line'
					},
					title: {
						text: '일일 통계관리'
					},
					subtitle: {
						text: '일일 통계'
					},
					xAxis: {
						categories: [
									<%
									for(int i=0; i<maxDay; i++)
									{
										
										if(i<9) {
											out.println("'0"+(i+1)+"'");
											if(maxDay != i)out.println(",");
										}else {
											
											out.println(Integer.toString((i+1)));
											if(maxDay != i+1)out.println(",");
										}
									}
									%>
									]
					},
					yAxis: {
						title: {
							text: '일일 접속자 (명)'
						}
					},
					tooltip: {
						enabled: false,
						formatter: function() {
							return '<b>'+ this.series.name +'</b><br/>'+
								this.x +': '+ this.y +'명';
						}
					},
					plotOptions: {
						line: {
							dataLabels: {
								enabled: true
							},
							enableMouseTracking: false
						}
					},
					series: [{
						name: '일일 접속자',
						
						data: [
								<%
								for(int aaa = 0 ; aaa < datelists.length ; aaa++){
									if(aaa > 0){
										out.println(",");
									}
									out.println(datelists[aaa]);
								}
								%>

							  ]
								
					}]
				});
				
				
			});
		</script>
	</head>
<body>
	<iframe name="comboaction" id="comboaction" src="" height="000" width="000"></iframe>
	<div id="right_view">
		<h2>통계관리<img src="<%=request.getContextPath()%>/images/egovframework/rfc3/iam/images/location_img.gif" alt=""  class="loca_img"/>접속자 통계 <img src="<%=request.getContextPath()%>/images/egovframework/rfc3/iam/images/location_img.gif" alt=""  class="loca_img"/><span>일일 통계</span></h2>
		<jsp:include page="../../iam/main/userinfo.jsp" />
	
		<div id="content">
			<div class="select01" style="margin:0 0 10px 0;">
				<div class="select02" style="padding:8px 0 0 8px;">
					<span class="btn_pack medium"><input value="년도별 통계" type="submit" onclick="document.location='yearlist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="월별 통계" type="submit" onclick="document.location='monthlist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="일일 통계" type="submit" onclick="document.location='datelist.sko';return false;" ></span>
					<span class="btn_pack medium"><input value="요일별 통계" type="submit" onclick="document.location='weeklist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="시간별 통계" type="submit" onclick="document.location='timelist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="IP 통계" type="submit" onclick="document.location='iplist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="브라우저 통계" type="submit" onclick="document.location='browserlist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="OS 통계" type="submit" onclick="document.location='oslist.sko';return false;" style="color:#bdbebd;"></span>
				</div>
			</div>
			<div class="select01">
				
				<!-- 상단 검색 영역  -->
				<div class="select02">
					<form name="listForm" action="datelist.sko" method="post" class="search">
						<fieldset>
							<legend>검색하기</legend>
							<form:select path="counterVO.sgroupId" id="sgroupId"  cssStyle=""  cssClass="" multiple="false" onchange="check_domain(this.value)">
								<form:option value="" label="--사이트 그룹--"/>
								<form:options  items="${sgroupList}" itemValue="sgroupId" itemLabel="sgroupNm" />
							</form:select>
							<form:select path="counterVO.domainId" id="domainId"  cssStyle=""  cssClass="" multiple="false" >								
								<form:option value="" label="--도메인 그룹을 선택하세요--"/>
								<form:options  items="${domainList}" itemValue="domainId" itemLabel="domainNm" />	
							</form:select>
							<form:select path="counterVO.accessDate" id="accessDate"  cssStyle=""  cssClass="" multiple="false" >								
									<form:option value="" label="-- 년도--"/>
									<c:forEach var="result" items="${yearlist}" varStatus="status">
										<option value="${result.value}" <c:out value="${result.value == fn:substring(counterVO.accessDate,0,4) ? 'selected' : ''}"/> >${result.key}</option>
									</c:forEach>
							</form:select>	년
							<select name="accessDate">
								<option value="">월 선택</option>
								<%
								VisitCounterVO counterVO = (VisitCounterVO)request.getAttribute("counterVO");
								String date = counterVO.getAccessDate();
								if(date == null || "".equals(date)) date = "000000";
								if(date.length() <= 2)
								{
									date = "0000"+date;
								}
								for(int i=1;i<=12;i++)
								{
									String value = "";
									if(i<10)
									{
										value = "0";
									}
									%>
									<option value="<%=value%><%=i%>" <%=i == Integer.parseInt(date.substring(4,6)) ? "selected" : "" %>><%=i %></option>
									<%
								}
								%>
							</select>월
							<span class="btn_pack medium"><input value="검색" type="submit"></span>
							<span class="btn_pack medium"><input value="다운로드" type="button" onclick="downloadXls();"></span>
						</fieldset>
					</form>
				</div>
				<br>
				<!--  
				<img src="<%//=request.getContextPath()%>/upload_data/visitcounter/<c:out value="${fileName}"/>"/>
				-->
				<div id="container" style="width: 1000px; height: 500px; margin: 0 auto"></div>
			</div>
		</div>
	</div>
	
</body>
</html>