<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/food/food_util.jsp"%>
<%@ include file="/program/food/foodVO.jsp"%>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

/************************** 접근 허용 체크 - 시작 **************************/
SessionManager sessionManager = new SessionManager(request);
String sessionId = sessionManager.getId();
if(sessionId == null || "".equals(sessionId)) {
	alertParentUrl(out, "관리자 로그인이 필요합니다.", adminLoginUrl);
	if(true) return;
}

String roleId= null;
String[] allowIp = null;
Connection conn2 = null;
try {
	sqlMapClient.startTransaction();
	conn2 = sqlMapClient.getCurrentConnection();
	
	// 접속한 관리자 회원의 권한 롤
	roleId= getRoleId(sqlMapClient, conn2, sessionId);
	
	// 관리자 접근 허용된 IP 배열
	allowIp = getAllowIpArrays(sqlMapClient, conn2);
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


String sch_id 		= parseNull(request.getParameter("sch_id"));
sch_id 				= sch_id.replace("m_", "");

StringBuffer sql 		= null;
Object[] setObj			= null;
List<String> setList	= new ArrayList<String>();
List<FoodVO> userNmList	=	null;
List<FoodVO> searchList	=	null;

try {
	if(!"".equals(sch_id)){
		sql = new StringBuffer();	
		sql.append("SELECT USER_NM									");
		sql.append("FROM RFC_COMVNUSERMASTER 						");
		sql.append("WHERE GROUP_ID = 'GRP_000009'					");
		sql.append("	  AND SUBSTR(USER_ID,3,6) LIKE ''||?||'%'	");
		userNmList = jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{sch_id});
		
		if(userNmList!=null && userNmList.size()>0 && sch_id.length() == 5){
			sql = new StringBuffer();
	   	 	sql.append("SELECT SID, TITLE, ADDR, TEL, AREA_TYPE, CATE2 AS FOUND, COEDU		");
	   	 	sql.append("FROM SCHOOL_SEARCH													");
	    	sql.append("WHERE 1=1 															");
    		sql.append("AND	(																");
	    	for(int i=0; i<userNmList.size(); i++){
	    		FoodVO ob = userNmList.get(i);
	    		if(i<userNmList.size()-1){
	    			sql.append("TITLE LIKE '%'||?||'%' OR							");
	    		}else{
	    			sql.append("TITLE LIKE '%'||?||'%' 								");
	    		}
	    		setList.add(ob.user_nm);
	    	}
	    	sql.append(")															");
    		
	    	setObj = new Object[setList.size()];
		    for(int i=0; i<setList.size(); i++){
		    	setObj[i] = setList.get(i);
		    }
			searchList = jdbcTemplate.query(sql.toString(), new FoodList(), setObj);
	    }
		
		if(searchList==null && sch_id.length() == 5 && userNmList!=null && userNmList.size()>0){
			sql = new StringBuffer();
			sql.append("SELECT 	SID, SCHOOL_NAME AS TITLE, SCHOOL_ADDR AS ADDR, '남여공학' AS COEDU,	");
			sql.append("		SCHOOL_TEL AS TEL, SCHOOL_AREA AS AREA_TYPE, FOUND_TYPE AS FOUND	");
			sql.append("FROM AD_PRESCHOOL															");
			sql.append("WHERE 1=1 																	");
    		sql.append("AND	(																		");
	    	for(int i=0; i<userNmList.size(); i++){
	    		FoodVO ob = userNmList.get(i);
	    		if(i<userNmList.size()-1){
	    			sql.append("SCHOOL_NAME LIKE '%'||?||'%' OR										");
	    		}else{
	    			sql.append("SCHOOL_NAME LIKE '%'||?||'%' 										");
	    		}
	    		setList.add(ob.user_nm);
	    	}
	    	sql.append(")																			");
    		
	    	setObj = new Object[setList.size()];
		    for(int i=0; i<setList.size(); i++){
		    	setObj[i] = setList.get(i);
		    }
			searchList = jdbcTemplate.query(sql.toString(), new FoodList(), setObj);
		}
	}
} catch (Exception e) {
    out.println(e.toString());
	e.printStackTrace();
	//alertBack(out, "처리중 오류가 발생하였습니다.");
}
%>

<%
if(searchList != null && searchList.size() > 0){
	%>
	<div style="background-color:#F6F6F6; width:200px; overflow: auto; height:100px;">
		<ul>
		<%
		for(int i=0; i<searchList.size(); i++){
			FoodVO vo	=	searchList.get(i);
			%>
			<li id="searchResult<%=i+1%>">
				<a href="javascript:selInput('<%=vo.sid%>','<%=vo.title%>', '<%=vo.addr%>', 
				'<%=vo.tel%>', '<%=vo.area_type%>', '<%=vo.found%>', '<%=vo.coedu%>');"><%=vo.title%></a>
			</li>
			<%
		}%>
		</ul>
	</div>
	<%
	}
%>
                                                                                                            