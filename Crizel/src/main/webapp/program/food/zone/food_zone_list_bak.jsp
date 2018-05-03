<%
/**
*	PURPOSE	:	학교급식 권역 리스트
*	CREATE	:	20180302_fri	JMG
*	MODIFY	:	
*/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ page import="org.springframework.jdbc.core.*" %>
<%@ include file="/program/class/UtilClass.jsp" %> 
<%@ include file="/program/food/food_util.jsp" %>


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

String menuTitle 		=	"학교급식 권역 목록";

Connection conn         =   null;
PreparedStatement pstmt =   null;
ResultSet rs            =   null;
StringBuffer sql        =   null;
String sql_where        =   "";
int num                 =   0;
int result              =   0;

//파라미터
List<ZoneVO> zoneList	=	null;
List<AreaVO> areaList	=	null;
ZoneVO zoneVO			=	new ZoneVO();
zoneVO.zone_no			=	Integer.parseInt(parseNull(request.getParameter("zone_no"), "0"));

try {
	sqlMapClient.startTransaction(); 
	conn = sqlMapClient.getCurrentConnection();
	/* conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD); */
	
	//권역
	sql 		= 	new StringBuffer();
	sql.append(" SELECT ROWNUM, ZONE_NO, ZONE_NM, SHOW_FLAG, 						\n");
	sql.append(" TO_CHAR(REG_DATE, 'YYYY\"년\" MM\"월\" DD\"일\"') AS DATE_KOR  	\n");
	sql.append(" FROM FOOD_ZONE WHERE SHOW_FLAG = 'Y' ORDER BY REG_DATE				\n");
	pstmt		=	conn.prepareStatement(sql.toString());
	rs			=	pstmt.executeQuery();
	zoneList	=	getResultZoneRows(rs);		//select결과를 zoneList에 add
	dbClose(rs, pstmt, conn, "");
	
	//첫페이지
	if(zoneVO.zone_no == 0){
		sql			=	new StringBuffer();
		sql.append(" SELECT * FROM (		\n");
		sql.append(" SELECT ROWNUM AS RNUM, A.* FROM ( 				\n");
		sql.append(" SELECT ZONE_NO FROM FOOD_ZONE 					\n");
		sql.append(" WHERE SHOW_FLAG = 'Y' ORDER BY REG_DATE			\n");
		sql.append(" )A WHERE ROWNUM <= 1 	\n");
		sql.append(" ) WHERE RNUM > 0 		\n");
		
		pstmt		=	conn.prepareStatement(sql.toString());
		rs			=	pstmt.executeQuery();
		if(rs.next())	zoneVO.zone_no	=	rs.getInt("ZONE_NO");
		dbClose(rs, pstmt, conn, "");
	}
	
	//지역목록
	sql			=	new StringBuffer();
	num			=	0;
	
	sql.append(" SELECT AREA_NO, AREA_NM, ZONE_NO, SHOW_FLAG,							\n");
	sql.append(" TO_CHAR(REG_DATE, 'YYYY\"년\" MM\"월\" DD\"일\"') AS DATE_KOR		\n");
	sql.append(" FROM FOOD_AREA WHERE SHOW_FLAG = 'Y' AND ZONE_NO = ?					\n");
	sql.append(" ORDER BY REG_DATE 	\n");
	
	pstmt		=	conn.prepareStatement(sql.toString());
	pstmt.setInt(++num, zoneVO.zone_no);
	rs			=	pstmt.executeQuery();
	areaList	=	getResultAreaRows(rs);
	
} catch (Exception e) {
    out.println(e.toString());
	e.printStackTrace();
} finally {
	dbClose(rs, pstmt, conn, "finally");
	sqlMapClient.endTransaction();
}
%>

<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > <%=menuTitle%></title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
		<link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css" />
		<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
	</head>
    <body>
		<div id="right_view">
			<div class="top_view">
				<p class="location"><strong><%=menuTitle%></strong></p>
			</div>
            <div id="content">
                <div class="tabBox" style="float:left; padding:0px 0px 5px;" >
                <%out.print(printZone(zoneVO.zone_no, zoneList));%>
                </div>    
                <div class="tabBox" style="float:right; padding:0px 0px 5px;">
				<form id="zoneForm" name="zoneForm" method="post">
					<input type="hidden" name="actType" value="">
					<input type="hidden" name="zone_no" value="">
					<label for="zone_nm" class="blind">권역명</label>
					<input type="text" name="zone_nm" id="zone_nm" value="">
					<input type="submit" value="권역추가" class="btn small edge mako" onclick="javascript:insertZone();">
					<%if(zoneList != null && zoneList.size() > 0 ) {%>
	                	<input type="button" value="권역삭제" class="btn small edge mako" onclick="javascript:deleteZone('<%=zoneVO.zone_no%>')">
	                	<input type="button" value="지역추가" class="btn small edge mako" onclick="javascript:insertAreaWin('<%=zoneVO.zone_no%>');">
                	<%}%>
				</form>
                </div>
                <div class="listArea">
					<form id="listForm" name="listForm" method="post">
						<table class="bbs_list">
	                        <colgroup>
		                        <col style="width:20%;">
		                        <col style="width:50%;">
		                        <col style="width:30%">
	                        </colgroup>
	                        <thead>
		                        <tr>
			                        <th scope="col">지역ID</th>
			                        <th scope="col">지역명</th>
			                        <th scope="col">관리</th>
		                        </tr>
	                        </thead>
	                        <tbody>
	                        <%out.print(printAreaList(areaList));%>
	                        </tbody>
	                    </table>
	                </form>
           		</div>
        	</div>
        </div>
        <div id="insertArea" style="display:none;">
        	<form name="areaForm" id="areaForm" method="post" onsubmit="return insertArea();">
        		<input type="hidden" name="actType" value="">
        		<input type="hidden" name="area_no" value="">
	        	<table class="bbs_list">
	        		<tr>
	        			<td><label for="zone_no">권역선택</label></td>
	        			<td>
	        				<select name="zone_no" id="zone_no" title="권역을 선택해주세요." style="width:70%;">
	        					<option value="">-권역선택-</option>
	        					<%
	        					if(zoneList!=null && zoneList.size()>0){
	        					for(int i=0; i<zoneList.size(); i++){
	        						out.print(printOption(Integer.toString(zoneList.get(i).zone_no), zoneList.get(i).zone_nm, Integer.toString(zoneVO.zone_no)));
	        					}
	        					}%>
	        				</select>
	        			</td>
	        		</tr>
	        		<tr>
	        			<td><label for="areaNm">지역명</label></td>
	        			<td><input type="text" name="areaNm" id="areaNm" value="" style="width:70%;"></td>
	        		</tr>
	        	</table>
	        	 <div style="text-align:center;">
	        	 	<input type="submit" value="등록" class="btn small edge mako">
	        	 </div>
        	</form>	 
        </div>
    </body>
    <script>
    
    	//권역 추가
    	function insertZone(){
    		if(document.zoneForm.zone_nm.value == ""){
    			alert("권역명은 필수값입니다.");
    			document.zoneForm.zone_nm.focus();
    			return;
    		}
    		document.zoneForm.action 			= 	"./food_zone_act.jsp";
    		document.zoneForm.actType.value 	= 	"insertZone";
    		document.zoneForm.submit();
    	}
    	
    	//권역 삭제
 		function deleteZone(zone_no){
 			if(confirm("현재 권역을 삭제하시겠습니까?")==true){
 	 			document.zoneForm.action			=	"./food_zone_act.jsp";
 	 			document.zoneForm.zone_no.value		=	zone_no;
 	 			document.zoneForm.actType.value		=	"deleteZone";
 	 			document.zoneForm.submit();
 			}
 		}
 		
    	//권역 이동
 		function moveZone(zone_no){
 			document.zoneForm.action			=	"./food_zone_list.jsp";
	 		document.zoneForm.zone_no.value		=	zone_no;
 			document.zoneForm.submit();
 		}
    	
    	//지역 추가 window
 		function insertAreaWin(){
    		$("#insertArea").dialog({
    			width:400,
    			height:230,
    			modal:true,
    		});
    	}
    	
    	//지역 추가
    	function insertArea(zone_no){
    		document.areaForm.action			=	"./food_zone_act.jsp";
    		document.areaForm.actType.value		=	"insertArea";
    		document.areaForm.submit();
    	}
    	
    	//지역 삭제
    	function deleteArea(area_no){
    		if(confirm("정말 삭제하시겠습니까?") == true){
    			document.areaForm.action			=	"./food_zone_act.jsp";
        		document.areaForm.area_no.value		=	area_no;
        		document.areaForm.actType.value		=	"deleteArea";
        		document.areaForm.submit();
    		}    		
    	}
    </script>
</html>
