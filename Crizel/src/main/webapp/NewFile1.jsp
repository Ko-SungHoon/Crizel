<%
/**
*   CREATE  :  레이아웃 180323 LJH
*   MODIFY  :   ....
**/
%>
<%@page import="egovframework.rfc3.user.web.SessionManager"%>
<%@ page import="java.util.*" %>
<%@ page import="egovframework.rfc3.menu.vo.MenuVO" %>
<%@ page import="egovframework.rfc3.contents.vo.ContentsVO" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%
ArrayList topMenuList = (ArrayList) cm.getMenuList("DOM_000002101000000000",2);
SessionManager headSManager =	new SessionManager(request);

String returnMenuUrl	=	"/index.gne?menuCd=DOM_000002101000000000";	//메인페이지 주소
String returnUrlEncode = URLEncoder.encode(returnMenuUrl, "UTF-8");

String headerMenuCd = cm.getMenuVO().getMenuCd()==null?"DOM_000002101000000000":cm.getMenuVO().getMenuCd(); 

//세션 체크 (로그인 여부 및 승인여부)
/**  if("".equals(headSManager.getId()) || session.getAttribute("foodUserChk")==null){
	out.print("<script> 						\n");
	out.print("alert('비정상적인 접근입니다.'); 			\n");
	out.print("window.close(); 					\n");	
	out.print("</script> 						\n");
}**/
String headerSql = new String();
String userType = "";

if(!"".equals(headSManager.getId())){
	try{
		headerSql = new String();
		headerSql += "SELECT 																						";
		headerSql += "  CASE 																						";
		headerSql += "    WHEN SCH_TYPE = 'Z' OR SCH_TYPE = 'Y' OR SCH_TYPE = 'X' OR SCH_TYPE = 'V' THEN '기관'		";
		headerSql += "    ELSE DECODE(SCH_GRADE, 'T', '조사팀장', '조사자')												";
		headerSql += "  END AS SCH_TYPE																				";
		headerSql += "FROM FOOD_SCH_TB																				";
		headerSql += "WHERE SCH_ID = ?																				";
		userType = jdbcTemplate.queryForObject(headerSql, String.class, headSManager.getId());
	}catch(Exception e){
		userType = "";
	}
}
%>
<header>
<div id="skipNavi">
	<strong>컨텐츠 바로가기</strong>
	<ul>
	<li><a href="#content">본문으로 바로가기</a></li>
	<li><a href="#lnb">주메뉴 바로가기</a></li>
	</ul>
</div>
<div id="dv_gnb">
	<div class="dv_wrap">
	<!-- S : 로고 -->
	<h1><a href="/index.gne?menuCd=DOM_000002101000000000"><img src="/img/food/logo.png" alt="경상남도교육청 학교급식거래실례조사시스템" class="logo" /></a></h1>
	<!--//E : 로고 -->
		<!-- S : 로그인 영역 -->
		<div class="login_area">
		<!-- 로그인 상태 -->
		<%if(!"".equals(headSManager.getId())){%>
			<a href="javascript:;"><span class="blue fb"><%=userType%> <%=headSManager.getName()%></span></a> 님, 반갑습니다.
			<a href="/index.gne?menuCd=DOM_000002101007000000"class="btn_mypage">마이페이지</a>
			<a href="/index.gne?menuCd=DOM_000002101006000000&actType=1" class="btn_modify">정보수정</a>
		<%}%>	
		</div>
		<!-- // E : 로그인 영역 -->
	</div>
</div>

	<div class="lnb_group">
    <div class="lnb_container clearfix">
      	<nav id="lnb">
        <div class="lnb_list">
          	<ul class="depth1 clearfix">
	    <% for (int i=0; i<topMenuList.size(); i++) {
					MenuVO topMenuVO = (MenuVO) topMenuList.get(i);
					if("DOM_000002101".equals(topMenuVO.getMenuCd().substring(0,13))){
						ArrayList topMenuList2 = (ArrayList) cm.getMenuList(topMenuVO.getMenuCd(), 3);
				%>
					<li class="m<%=i+1%> <%if(headerMenuCd.equals(topMenuVO.getMenuCd())){ out.println("current");} %>" >
						<a href="/index.<%=cm.getUrlExt()%>?menuCd=<%=topMenuVO.getMenuCd()%>"<%if("_blank".equals(topMenuVO.getMenuTg())){%> target="_blank" title="새창으로 열립니다."<%}%>><%=topMenuVO.getMenuNm()%>
						<%if("_blank".equals(topMenuVO.getMenuTg())){%><img src="/img/common/open_new.png" alt="새창"/><%}%>
						</a>
						<div class="depth2">
							<ul class="litype_cir">
								<% for (int j=0; j<topMenuList2.size(); j++) {
										MenuVO topMenuVO2 = (MenuVO) topMenuList2.get(j);
										if("DOM_000002101".equals(topMenuVO2.getMenuCd().substring(0,13))){
										ArrayList topMenuList3 = (ArrayList) cm.getMenuList(topMenuVO2.getMenuCd(), 4);
								%>
									<li>
										<a href="/index.<%=cm.getUrlExt()%>?menuCd=<%=topMenuVO2.getMenuCd()%>"<%if("_blank".equals(topMenuVO2.getMenuTg())){%> target="_blank" title="새창으로 열립니다."<%}%>><%=topMenuVO2.getMenuNm()%>
										<%if("_blank".equals(topMenuVO2.getMenuTg())){%><img src="/img/common/open_new.png" alt="새창"/><%}%>
										</a>
									</li>
								<% }
							} %>
							</ul>
						</div>
					</li>
				<% }
			 } %>
          	</ul>
          	<div id="lnb_bg" style="height:auto;"></div>
        </div>
        <div class="close_area">
          	<p class="close"></p><span class="blind">닫기</span>
        </div>
    </nav>
    </div>
		<div id="lnb_btn"><img src="/img/school/btn_menuall.png" alt="전체메뉴보기"></div>
    <div id="lnb_mask"></div>
	</div>
</header>
<script>
function fn_ssoLogin() {
	window.location.href="/sso/business.jsp";
}
</script>