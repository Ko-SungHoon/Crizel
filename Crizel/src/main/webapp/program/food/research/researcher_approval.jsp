<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
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



String sch_no 		= parseNull(request.getParameter("sch_no"));
String sch_app_flag	= parseNull(request.getParameter("sch_app_flag"));	//Y=승인,N=취소,D=삭제
String returnVal	= "NO";

StringBuffer sql 		= null;
int result 				= 0;

try {
    //일괄승인
    if (sch_no.contains(",")) {
        
        String sch_no_arr[] =   sch_no.split(",");
        int sch_no_cnt      =   sch_no_arr.length;
        
        for (int i = 0; i < sch_no_arr.length; i++) {
            sql = new StringBuffer();
            sql.append("UPDATE FOOD_SCH_TB SET			");
            sql.append("	  SCH_APP_FLAG = ?			");
            if("Y".equals(sch_app_flag)){
                sql.append("	, APP_DATE = SYSDATE	");
            }else{
                sql.append("	, APP_DATE = NULL		");
            }
            sql.append("WHERE SCH_NO = ?				");
            result  +=  jdbcTemplate.update(sql.toString(),
                    new Object[]{sch_app_flag, sch_no_arr[i]}
                    );
        }
        
        if (result == sch_no_cnt) {
            returnVal = "OK";
        }
    //단건 승인
    } else {

		//단건 취소 전 확인
		if ("N".equals(sch_app_flag)) {
			sql	=	new StringBuffer();
			sql.append("SELECT NVL(COUNT(RSCH_ITEM_NO), 0) ");
			sql.append("FROM FOOD_RSCH_ITEM                ");
			sql.append("WHERE SCH_NO = ?				   ");
			int rsch_item_cnt	=	jdbcTemplate.queryForObject(
									sql.toString(),
									new Object[]{sch_no},
									Integer.class
									);
			if (rsch_item_cnt > 0) {
				returnVal	=	"OVER";
			} else {
                sql = new StringBuffer();
                sql.append("UPDATE FOOD_SCH_TB SET			");
                sql.append("	  SCH_APP_FLAG = ?			");
                sql.append("	, APP_DATE = NULL		    ");
                sql.append("WHERE SCH_NO = ?				");
                result = jdbcTemplate.update(sql.toString(),
                    new Object[]{sch_app_flag, sch_no}
                    );

                if(result > 0){
                    returnVal = "OK";
                }
            }
		} else if ("Y".equals(sch_app_flag)) {

            sql = new StringBuffer();
            sql.append("UPDATE FOOD_SCH_TB SET			");
            sql.append("	  SCH_APP_FLAG = ?			");
            sql.append("	, APP_DATE = SYSDATE	    ");
            sql.append("WHERE SCH_NO = ?				");
            result = jdbcTemplate.update(sql.toString(),
                    new Object[]{sch_app_flag, sch_no}
                    );

            if(result > 0){
                returnVal = "OK";
            }
        } else if ("D".equals(sch_app_flag)) {

            // 조사자 삭제
            sql = new StringBuffer();
            sql.append("UPDATE FOOD_SCH_NU SET SHOW_FLAG = 'N' WHERE SCH_NO = ?		");
            result = jdbcTemplate.update(sql.toString(), sch_no);
            
            sql = new StringBuffer();
            sql.append("UPDATE FOOD_SCH_TB SET SHOW_FLAG = 'N' WHERE SCH_NO = ?		");
            result = jdbcTemplate.update(sql.toString(), sch_no);
            
            if(result > 0){
                returnVal = "OK";
            }else{
                returnVal = "NO";
            }

        } else if ("R".equals(sch_app_flag)) {

            //조사자 복원
            sql = new StringBuffer();
            sql.append("UPDATE FOOD_SCH_NU SET SHOW_FLAG = 'Y' WHERE SCH_NO = ?		");
            result = jdbcTemplate.update(sql.toString(), sch_no);
            
            sql = new StringBuffer();
            sql.append("UPDATE FOOD_SCH_TB SET SHOW_FLAG = 'Y' WHERE SCH_NO = ?		");
            result = jdbcTemplate.update(sql.toString(), sch_no);

            if(result > 0){
                returnVal = "OK";
            }else{
                returnVal = "NO";
            }
        }
    }
	
} catch (Exception e) {
    out.println(e.toString());
	e.printStackTrace();
	//alertBack(out, "처리중 오류가 발생하였습니다.");
}
%>
<%=returnVal%>
