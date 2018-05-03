<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ page import="org.apache.commons.jxpath.*,java.io.*,java.util.*,java.net.*" %>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>
<%@page import="egovframework.rfc3.user.web.SessionManager"%>
<%@ include file="/program/class/UtilClass.jsp"%>
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
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
				document.listForm.action = "ipdownload.sko";
				document.listForm.submit();
				document.listForm.action = "iplist.sko";
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
		</script>
	</head>
<body>
	<iframe name="comboaction" id="comboaction" src="" height="000" width="000"></iframe>
	<div id="right_view">
		<h2>통계관리<img src="<%=request.getContextPath()%>/images/egovframework/rfc3/iam/images/location_img.gif" alt=""  class="loca_img"/>접속자 통계 <img src="<%=request.getContextPath()%>/images/egovframework/rfc3/iam/images/location_img.gif" alt=""  class="loca_img"/><span>IP 통계</span></h2>
		<jsp:include page="../../iam/main/userinfo.jsp" />
	
		<div id="content">
			<div class="select01" style="margin:0 0 10px 0;">
				<div class="select02" style="padding:8px 0 0 8px;">
					<span class="btn_pack medium"><input value="년도별 통계" type="submit" onclick="document.location='yearlist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="월별 통계" type="submit" onclick="document.location='monthlist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="일일 통계" type="submit" onclick="document.location='datelist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="요일별 통계" type="submit" onclick="document.location='weeklist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="시간별 통계" type="submit" onclick="document.location='timelist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="IP 통계" type="submit" onclick="document.location='iplist.sko';return false;"></span>
					<span class="btn_pack medium"><input value="브라우저 통계" type="submit" onclick="document.location='browserlist.sko';return false;" style="color:#bdbebd;"></span>
					<span class="btn_pack medium"><input value="OS 통계" type="submit" onclick="document.location='oslist.sko';return false;" style="color:#bdbebd;"></span>
				</div>
			</div>
					
			<div class="select01">
				
				<!-- 상단 검색 영역  -->
				<div class="select02">
					<form name="listForm" action="iplist.sko" method="get" class="search">
						<input name="pageIndex" type="hidden" value="<c:out value='${counterVO.pageIndex}'/>"/>
			            <input name="orderField" type="hidden" value="<c:out value='${counterVO.orderField}'/>"/>
			            <input name="orderSort" type="hidden" value="<c:out value='${counterVO.orderSort}'/>"/>
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
				
				<table class="bbs_list" summary="도메인 내용 입니다..">
					<caption>
						도메인그룹
					</caption>
					<colgroup>
						<col width="20%" />
						<col width="15%" />
						<col width="*" />						
					</colgroup>
					<thead>
						<tr>
							<th class="red">아이피</th>
							<th>통계</th>
							<th>통계 그래프</th>
						</tr>
					</thead>
					<tbody>						
						<c:if test="${counterVOList =='[]'}">
							<tr>
								<td class="title" colspan="3">등록된 액션이 없습니다.</td>
							</tr>
						</c:if>
						<c:set var="row"  value="${paginationInfo.totalRecordCount-(paginationInfo.currentPageNo-1)*paginationInfo.pageSize}"/>
						<c:forEach var="result" items="${counterVOList}" varStatus="status">
							<tr>
								<th class="title">
									<c:out value="${result.connectIp}"/>
								</th>
								<td><c:out value="${result.accessCount}"/></td>
								<td class="left">
									<img src="<%=request.getContextPath() %>/images/egovframework/rfc3/menu/gradebar.jpg" width="<c:out value="${result.accessCount}"/>px" height="10px">
								</td>
							</tr>
							<c:set var="row" value="${row-1}"/>
						</c:forEach>

					</tbody>
				</table>	
				
				<c:if test="${!empty counterVO.pageIndex }">
					<div class="page_area">
						<ul >
							<ui:pagination paginationInfo = "${paginationInfo}"  type="default" jsFunction="linkPage"/>
						</ul>
					</div>
				</c:if> 					
			</div>
		</div>
	</div>
	
</body>
</html>