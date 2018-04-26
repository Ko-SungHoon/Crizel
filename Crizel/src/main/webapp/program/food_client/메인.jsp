<%
/**
*	CREATE	:	20180326 LJH
*	MODIFY	:	20180326 JMG
*	MODIFY	:	20180422 LJH / 2차비번  label for 수정
*/
%>

<%@ page import="egovframework.rfc3.menu.web.CmsManager"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%
String moveUrlReg	=	"/index.gne?menuCd=DOM_000002101006000000";		//이동할 링크 (승인신청)	운영서버:DOM_000002101006000000, 테스트서버:DOM_000000127006000000
String moveUrlMain	=	"/index.gne?contentsSid=2299";					//이동할 링크 (로그인 검증페이지)	운영서버:2299, 테스트서버: 648
String foodRole		= 	"ROLE_000094";									// 운영서버:ROLE_000094 , 테스트서버:ROLE_000012

request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");
SessionManager sManager =	new SessionManager(request);



	StringBuffer sql 	= 	null;
	String schId		=	sManager.getId();
	String schName		=	sManager.getName();
	String groupId		=	sManager.getGroupId();
	String appFlag		=	""; //승인여부

	try{
		//회원신청 승인여부 확인
		sql		= 	new StringBuffer();
		sql.append(" SELECT 			  		\n");
		sql.append(" SCH_APP_FLAG 				\n");
		sql.append(" FROM FOOD_SCH_TB 			\n");
		sql.append(" WHERE SCH_ID = ? 			\n");
		sql.append(" AND SHOW_FLAG = 'Y' 		\n");
		sql.append(" AND ROWNUM = 1 			\n");
		sql.append(" ORDER BY SCH_NO DESC 		\n");

		try{
			appFlag		=	jdbcTemplate.queryForObject(sql.toString(), String.class, new Object[]{schId});
		}catch(Exception e){
			appFlag 	= 	"";
		}
	}catch(Exception e){
		alert(out, e.toString());
	}finally{

		//세션이 존재하고, (허용된 그룹일 때 (학교, 소속기관, 교육지원청, 직속기관, 도교육청) 또는 관리자일 때)
		if(!"".equals(schId) && ("GRP_000009".equals(groupId) || "GRP_000008".equals(groupId)
				|| "GRP_000007".equals(groupId) || "GRP_000006".equals(groupId) || "GRP_000005".equals(groupId)
				|| sManager.isRoleAdmin() ||  sManager.isRole(foodRole)   )){

			//승인상태일 시
			if(!"".equals(appFlag) && appFlag != null && "Y".equals(appFlag)){
				session.setAttribute("foodUserChk", "Y");
			}
			//승인대기 상태일 시
			else if(!"".equals(appFlag) && appFlag != null && "N".equals(appFlag)){
				session.setAttribute("foodUserChk", "N");
			}
			//미신청 상태일 시
			else{
				session.setAttribute("foodUserChk", "S");
			}
		}
		//세션이 존재하지 않을 시, 또는 허용된 그룹이 아닐 시
		else{
			out.print("<script>alert('로그인 중이 아니거나, 허용된 그룹이 아닙니다.');window.close();</script>");
			return;
		}
	}
	%>
	<section id="content">
	  	<h2><span class="green fb">학교급식거래실례조사시스템</span>에 오신것을 환영합니다.</h2>
	  	<p>이 시스템은 학교급식 업무관계자들만 이용할 수 있습니다.</p>

	  	<form name="schLoginForm" id="schLoginForm" method="post" action="<%=moveUrlMain%>">

		<!-- 미신청 상태일 때, 또는 승인대기 상태일 때 -->
		<%if("S".equals(session.getAttribute("foodUserChk")) || "N".equals(session.getAttribute("foodUserChk"))){%>
		<div class="box_mdiv c">
			<p class="fsize_120 padT10 padB15">본 시스템 사용을 위해서 사용 승인 신청을 해주시기 바랍니다.</p>

		    <div class="btn_area c">
		    <!-- 미신청 상태일 시 -->
		    <%if("S".equals(session.getAttribute("foodUserChk"))){%>
		      <a href="<%=moveUrlReg%>" class="btn medium darkMblue">사용 승인 신청하기</a>

		    <!-- 승인대기 상태일 시 -->
		    <%}else if("N".equals(session.getAttribute("foodUserChk"))){%>
		      <a href="javascript:plzWait();" class="btn medium darkMblue">사용 승인 신청하기</a>
		    <%}%>
		    </div>
		</div>

		<!-- 승인된 상태일 때 (2차비밀번호 입력하기) -->
		<%}else if("Y".equals(session.getAttribute("foodUserChk"))){%>
			<input type="hidden" name="actType" id="actType" value="2">
			<div class="box_mdiv c magT10">
				<p class="fsize_120 padT10">등록된 회원 정보 확인을 위하여 2차 비밀번호를 입력하여 주시기 바랍니다.</p>
			    <div class="btn_area">
					<label for="schPw" class="fb">2차 비밀번호 :</label> <input type="password" name="schPw" id="schPw" required/>
				    <button type="submit" class="btn small edge mako">확인</button>
			    </div>
			</div>
		<%}%>
		</form>
	</section>
	<script>
		function plzWait(){
			alert("현재 승인 대기 상태입니다. 다음에 다시 시도해주십시오.");
		}
	</script>