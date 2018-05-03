<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ page import="java.util.List,egovframework.rfc3.search.web.SearchManager,egovframework.rfc3.search.vo.SearchVO" %>
<%@ page import="org.springframework.beans.factory.annotation.Autowired" %>
<%@ page import="org.springframework.stereotype.Controller" %>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title>RFC3.0 관리자시스템</title>
<meta name="title" content="관리자시스템" />
<meta name="author" content=" skoinfo_KoSangA " />
<meta name="keywords" content="RFC, 3.0, 관리자시스템 " />
<meta name="description" content="RFC3.0 관리자시스템입니다." />
<link href="<c:url value='/css/egovframework/rfc3/iam/import.css' />" rel="stylesheet" type="text/css" />
<script type='text/javascript' src='<c:url value='/js/egovframework/rfc3/iam/common.js' />'></script>
<script type='text/javascript' src='<c:url value='/dwr/interface/selectNotOfficeSgroupList.js' />'></script>
<script type='text/javascript' src='<c:url value='/dwr/interface/selectSearchDomainUserAdminList.js' />'></script>
<script type='text/javascript' src='<c:url value='/dwr/interface/selectSearchDomainList.js' />'></script>
<script type='text/javascript' src='<c:url value='/dwr/interface/selectMenutCodeDwr.js' />'></script>
<script type='text/javascript' src='<c:url value='/dwr/engine.js' />'></script>

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

<script type='text/javascript'>

	//도메인 선택
	function check_domain(val) {
		//총관리자 및 시스템 관리자
		<% if(EgovUserDetailsHelper.isRoleSym()) {%>
		selectSearchDomainList.selectSearchDomainList(val,callbackDomainList);
		//도메인 관리자 인경우
		<%} else if(EgovUserDetailsHelper.isRole("ROLE_RESTRICTED")) {%>
		selectSearchDomainUserAdminList.selectSearchDomainUserAdminList('<%=EgovUserDetailsHelper.getSgroupId()%>','<%=EgovUserDetailsHelper.getId()%>',callbackDomainList);
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
	</script>
</head>
<body>
<iframe name="comboaction" id="comboaction" src="" height="0" width="0"></iframe>
<div id="right_view">
  <h2>기타유틸<img src="<%=request.getContextPath()%>/images/egovframework/rfc3/iam/images/location_img.gif" alt=""  class="loca_img"/><span>검색인덱싱</span></h2>
  <jsp:include page="../../iam/main/userinfo.jsp" />
  <div id="content">
    <div class="select01">
      <div class="select02">
        <!-- 검색폼 -->
        <form name="listForm" action="<c:url value='/cms/search/list.sko'/>" method="post" onsubmit="check_list(listForm)" class="search">
          <fieldset>
          <legend>검색하기</legend>
           <!-- 셀렉트 -->			
			<form:select path="searchVO.sgroupId" id="sgroupId"  cssStyle=""  cssClass="" multiple="false" onchange="check_domain(this.value)">
				<form:option value="" label="--사이트 그룹--"/>
				<form:options  items="${sgroupList}" itemValue="sgroupId" itemLabel="sgroupNm" />
			</form:select>
			<form:select path="searchVO.domainId" id="domainId"  cssStyle=""  cssClass="" multiple="false" onchange="check_menucd(this.value)">	
				<form:option value="" label="--도메인 그룹을 선택하세요--"/>
				<form:options  items="${domainList}" itemValue="domainId" itemLabel="domainNm" />	
			</form:select>
           <span class="btn_pack medium"><input value="검색" type="submit"></span>
          </fieldset>
        </form>
      <!-- 등록버튼-->
    </div>
    
    <table class="bbs_list" summary="사이트 그룹별 현황 목록 입니다.">
      <caption>
      그룹별회원현황
      </caption>
      <colgroup>
      <col width="15%" /><!-- 메뉴코드  -->
      <col width="*" /><!--  주소복사  -->
      <col width="10%" /><!-- 메뉴코드  -->      
      <col width="10%" /><!-- 메뉴코드  -->
      <col width="10%" /><!-- 메뉴코드  -->
      <col width="10%" /><!--  메뉴이름  -->
 
      </colgroup>
      <tr>
        <th class="red">항목</th>
        <th>진행률</th>
        <th>퍼센트</th>
        <th>인덱싱 갯수</th>
        <th>전체 갯수</th>
        <th>인덱싱</th>
      </tr>
       <!-- 1 차 리스트   -->
       
 
       <!-- ---------------------------------------- -->
        
       <!-- 1 차 리스트   -->
       
       <!-- 1 차 리스트 출력  -->
       <%
       SearchManager searchManager = new SearchManager(request);
       SearchVO searchVO = (SearchVO)request.getAttribute("searchVO");
       String domainId = "";
       if(searchVO == null) domainId = "";
       else domainId = searchVO.getDomainId();
       
       if(domainId == null) domainId = "";
      domainId = searchManager.getDomain(domainId);
       %>
       
		<tr>
			<th class="title">컨텐츠</th><!-- 사이트그룹 --> 
			<td style="text-align:left;">				
				<div style="width:90%;float:left;margin:0 0 0 20px;">	
					<img src="<%=request.getContextPath()%>/images/egovframework/rfc3/menu/gradebar.jpg" height="10px" style="width:<%=(int)Math.round(((double)(searchManager.searchIndexMax("contents",domainId,""))/(double)((Integer)request.getAttribute("contentsCount")))*100.0) > 100 ? 100 : (int)Math.round(((double)(searchManager.searchIndexMax("contents",domainId,""))/(double)((Integer)request.getAttribute("contentsCount")))*100.0) %>%;" id="contentsBar"/>
				</div>
			</td>
			<td>
					<font color="000000"><span id="contentsPercent"><%=(int)Math.round(((double)(searchManager.searchIndexMax("contents",domainId,""))/(double)((Integer)request.getAttribute("contentsCount")))*100.0)%></span>%</font>
			</td>
			<td>
					<font color="000000"><span id="contentsCount"><%=searchManager.searchIndexMax("contents",domainId,"")%></span></font>
			</td>
			<td>
					<font color="000000"><c:out value="${contentsCount}" /></font>
			</td>
			<td>
				<form action="<c:url value='/cms/search/indexAct.sko'/>" method="post" target="comboaction">
					<form:hidden path="searchVO.sgroupId"/>
					<form:hidden path="searchVO.domainId"/>
					<input type="hidden" name="indexingType" value="contents"/>
					<span class="btn_pack medium"><input value="인덱싱 시작" type="submit"></span>
				</form>				        	
	        </td>
		</tr>
		<tr>
			<th class="title">게시물</th><!-- 사이트그룹 --> 
			<td style="text-align:left;">				
				<div style="width:90%;float:left;margin:0 0 0 20px;">	
					<img src="<%=request.getContextPath()%>/images/egovframework/rfc3/menu/gradebar.jpg" height="10px" style="width:<%=(int)Math.round(((double)(searchManager.searchIndexMax("data",domainId,""))/(double)((Integer)request.getAttribute("dataCount")))*100.0) > 100 ? 100 : (int)Math.round(((double)(searchManager.searchIndexMax("data",domainId,""))/(double)((Integer)request.getAttribute("dataCount")))*100.0)%>%;" id="dataBar"/>
				</div>
			</td>
			<td>
					<font color="000000"><span id="dataPercent"><%=(int)Math.round(((double)(searchManager.searchIndexMax("data",domainId,""))/(double)((Integer)request.getAttribute("dataCount")))*100.0)%></span>%</font>
			</td>
			<td>
					<font color="000000"><span id="dataCount"><%=searchManager.searchIndexMax("data",domainId,"")%></span></font>
			</td>
			<td>
					<font color="000000"><c:out value="${dataCount}" /></font>
			</td>
			<td>
				<form action="<c:url value='/cms/search/indexAct.sko'/>" method="post"  target="comboaction">
					<form:hidden path="searchVO.sgroupId"/>
					<form:hidden path="searchVO.domainId"/>
					<input type="hidden" name="indexingType" value="data"/>
					<span class="btn_pack medium"><input value="인덱싱 시작" type="submit"></span>
				</form>				        	
	        </td>
		</tr>
		<tr>
			<th class="title">첨부파일</th><!-- 사이트그룹 --> 
			<td style="text-align:left;">				
				<div style="width:90%;float:left;margin:0 0 0 20px;">	
					<img src="<%=request.getContextPath()%>/images/egovframework/rfc3/menu/gradebar.jpg" height="10px" style="width:<%=(int)Math.round(((double)(searchManager.searchIndexMax("file",domainId,""))/(double)((Integer)request.getAttribute("fileCount")))*100.0) > 100 ? 100 : (int)Math.round(((double)(searchManager.searchIndexMax("file",domainId,""))/(double)((Integer)request.getAttribute("fileCount")))*100.0)%>%;" id="fileBar"/>
				</div>
			</td>
			<td>
					<font color="000000"><span id="filePercent"><%=(int)Math.round(((double)(searchManager.searchIndexMax("file",domainId,""))/(double)((Integer)request.getAttribute("fileCount")))*100.0)%></span>%</font>
			</td>
			<td>
					<font color="000000"><span id="fileCount"><%=searchManager.searchIndexMax("file",domainId,"")%></span></font>
			</td>
			<td>
					<font color="000000"><c:out value="${fileCount}" /></font>
			</td>
			<td>
				<form action="<c:url value='/cms/search/indexAct.sko'/>" method="post"  target="comboaction">
					<form:hidden path="searchVO.sgroupId"/>
					<form:hidden path="searchVO.domainId"/>
					<input type="hidden" name="indexingType" value="file"/>
					<span class="btn_pack medium"><input value="인덱싱 시작" type="submit"></span>
				</form>				        	
	        </td>
		</tr>
		<tr>

			<td style="text-align:right;padding-right:20px;" colspan="6">					
				<form action="<c:url value='/cms/search/indexAct.sko'/>" method="post"  target="comboaction">
					<form:hidden path="searchVO.sgroupId"/>
					<form:hidden path="searchVO.domainId"/>
					<input type="hidden" name="indexingType" value="all"/>
					<span class="btn_pack medium"><input value="인덱싱 시작" type="submit"></span>
				</form>			
			</td>
		</tr>
	</table>
    <!-- n:페이징 -->
    
      <%
  /* 
  SearchManager searchManager = new SearchManager(request);     
  List<SearchVO> searchVOList = searchManager.getSearchList("data","44","","",0,1000);
      int i=1;
      for(SearchVO search : searchVOList)
      {
    	  %>
    	  <%=i++%>. <%=search.getId() %> : <%=search.getTitle() %> : <%=search.getContent() %> : <%=search.getUrl() %> : <img src="<%=search.getThumb() %>"/><br/>
    	  <%
      }*/%>
    
         
	</div>
	</div>
 </div>
  </div>
</body>
</html>
    