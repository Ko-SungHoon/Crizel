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
double[] chartVar = new double[counterVOList.size()];
String[] searchDate = new String[counterVOList.size()];



int dateCnt = 0;

for(VisitCounterVO c : counterVOList){	
	
	try{
		chartVar[dateCnt]= (double)c.getAccessCount();
		searchDate[dateCnt] = c.getConnectOs();
		dateCnt++;
	}catch(Exception ex){
		out.println(ex);
		dateCnt++;
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

		<link type="text/css" href="<c:url value='/js/egovframework/rfc3/datepicker/js/themes/base/ui.all.css' />" rel="stylesheet" />
		<script type="text/javascript" src="<c:url value='/jquery/jstree/lib/jquery.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/jquery/jstree/lib/jquery.cookie.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/jquery/jstree/lib/jquery.hotkeys.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/jquery/jstree/lib/jquery.metadata.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/jquery/jstree/lib/sarissa.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/jquery/jstree/jquery.tree.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/jquery/jstree/plugins/jquery.tree.contextmenu.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/jquery/jstree/plugins/jquery.tree.cookie.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/jquery/jstree/plugins/jquery.tree.hotkeys.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/jquery/jquery-ui-1.7.2.custom.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/jquery/jqgrid/js/i18n/grid.locale-en.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/jquery/jqgrid/js/jquery.jqGrid.min.js'/>"></script>
		
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
				document.listForm.action = "osdownload.sko";
				document.listForm.submit();
				document.listForm.action = "oslist.sko";
			}

			$(document).ready(function(){
			  $("#startDate").datepicker({          
					  monthNames: ['년 1월','년 2월','년 3월','년 4월','년 5월','년 6월','년 7월','년 8월','년 9월','년 10월','년 11월','년 12월'],
					  dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
					  showMonthAfterYear:true,
					  showAnim: "show",
					  showOptions: {},
					  duration: 200,          
					  dateFormat: 'yymmdd',          
					  onSelect: function(date) {
						  /*
						  var date_arr = date.split('-');
							if (date_arr.length==3){
								  var date_str = date_arr[0]+'년 '+date_arr[1]+'월 '+date_arr[2]+'일';
								  $("#span_in_last_date").html(date_str);
							}
							*/
					  }
					 
				})
				$("#endDate").datepicker({          
					monthNames: ['년 1월','년 2월','년 3월','년 4월','년 5월','년 6월','년 7월','년 8월','년 9월','년 10월','년 11월','년 12월'],
					dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
					showMonthAfterYear:true,          
					showAnim: "show",
					showOptions: {},
					duration: 200,          
					dateFormat: 'yymmdd',          
					onSelect: function(date) {
						  /*
						  var date_arr = date.split('-');
						  if (date_arr.length==3){
								var date_str = date_arr[0]+'년 '+date_arr[1]+'월 '+date_arr[2]+'일';
								$("#span_in_last_date").html(date_str);
						  }
						  */
					}
				   
			  })
			});

			var chart;
			$(document).ready(function() {
				chart = new Highcharts.Chart({
					chart: {
						renderTo: 'container',
						margin: [50, 200, 60, 170]
					},
					title: {
						text: '브라우저별 통계'
					},
					plotArea: {
						shadow: null,
						borderWidth: null,
						backgroundColor: null
					},
					tooltip: {
						formatter: function() {
							return '<b>'+ this.point.name +'</b>: '+ this.y +' %';
						}
					},
					plotOptions: {
						pie: {
							allowPointSelect: true,
							cursor: 'pointer',
							dataLabels: {
								enabled: true,
								formatter: function() {
									if (this.y > 5) return this.point.name;
								},
								color: 'white',
								style: {
									font: '13px Trebuchet MS, Verdana, sans-serif'
								}
							}
						}
					},
					legend: {
						layout: 'vertical',
						style: {
							left: 'auto',
							bottom: 'auto',
							right: '50px',
							top: '-100px'
						}
					},
				    series: [{
						type: 'pie',
						name: 'Browser share',
						data: [
						<%
						for(int i = 0 ; i < chartVar.length ; i++){
							if(i > 0){
								out.println(",");
							}
						%>		
							['<%=searchDate[i]%>  (<%=chartVar[i]%> 명)',  <%=chartVar[i]%>]
							
						<%}%>
						]
					}]
				});
			});
		</script>
	</head>
<body>
	<iframe name="comboaction" id="comboaction" src="" height="000" width="000"></iframe>
	<div id="right_view">
		<h2>통계관리<img src="<%=request.getContextPath()%>/images/egovframework/rfc3/iam/images/location_img.gif" alt=""  class="loca_img"/>접속자 통계 <img src="<%=request.getContextPath()%>/images/egovframework/rfc3/iam/images/location_img.gif" alt=""  class="loca_img"/><span>OS 통계</span></h2>
		<jsp:include page="../../iam/main/userinfo.jsp" />
	
		<div id="content">
			<div class="select01" style="margin:0 0 10px 0;">
				<div class="select02" style="padding:8px 0 0 8px;">
					<span class="btn_pack medium"><input value="년도별 통계" type="submit" onclick="document.location='yearlist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="월별 통계" type="submit" onclick="document.location='monthlist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="일일 통계" type="submit" onclick="document.location='datelist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="요일별 통계" type="submit" onclick="document.location='weeklist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="시간별 통계" type="submit" onclick="document.location='timelist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="IP 통계" type="submit" onclick="document.location='iplist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="브라우저 통계" type="submit" onclick="document.location='browserlist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="OS 통계" type="submit" onclick="document.location='oslist.sko';return false;"></span>
				</div>
			</div>
			<div class="select01">
				
				<!-- 상단 검색 영역  -->
				<div class="select02">
					<form name="listForm" action="oslist.sko" method="get" class="search">
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
							<form:input path="counterVO.startDate"   size="10" onchange="Date_Check(listForm.startDate)" cssStyle="margin:0 10px 0 0;" cssClass="txt"/>(yyyyMMdd)
								~
							<form:input path="counterVO.endDate"   size="10"  onchange="Date_Check(listForm.endDate)" cssStyle="margin:0 10px 0 0;" cssClass="txt"/>(yyyyMMdd)
							<span class="btn_pack medium"><input value="검색" type="submit"></span>
							<span class="btn_pack medium"><input value="다운로드" type="button" onclick="downloadXls();"></span>
						</fieldset>
					</form>
				</div>
				<!--  
				<img src="<%//=request.getContextPath()%>/upload_data/visitcounter/<c:out value="${fileName}"/>"/>
				-->
				<br>
				<div id="container" style="width: 1000px; height: 500px; margin: 0 auto"></div>
			</div>
		</div>
	</div>
	
</body>
</html>