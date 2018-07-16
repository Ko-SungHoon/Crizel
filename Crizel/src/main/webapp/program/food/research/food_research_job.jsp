<%
/**
*   PURPOSE :   월별 조사 항목 및 개시
*   CREATE  :   20180320_tue    JI
*   MODIFY  :   조사내용 수정 script function 작성 20180320_tue    JI
*   MODIFY  :   승인/반려 버튼 생성 	20180412_thur    KO
*   MODIFY  :   관리자 일괄 승인 처리 btn and fucntion 	20180517_thur    JI
*	MODIFY	:	20180529	KO	조사 끝난 뒤 승인처리 기능 추가	
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/PagingClass2.jsp"%>
<%@ include file="/program/class/PagingClass3.jsp"%>
<%@ page import="org.springframework.jdbc.core.*" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>
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

String pageTitle = "월별 조사 항목 및 개시";

%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > <%=pageTitle%></title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
        <script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
        <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
		<script src="/program/food/modal.js"></script>
<style>
	.box_01 {border:2px solid #ccc;padding:15px;margin-bottom: 15px;}
	.box_01 .type01 {height: 15px;}
	.type01>li {padding:0px 15px 0px 15px; background:url(/img/common/bul_01.png) no-repeat 0 4px; float: left;}
	.rschTit {background: url(/img/common/bul_01.png) no-repeat 0 4px; font-size:1.4em; font-weight:600;margin-bottom:5px; padding-left:15px;} 
</style>
</head>

<body>
<%
Calendar cal 	= Calendar.getInstance();
int year 		= cal.get(Calendar.YEAR);
int month 		= cal.get(Calendar.MONTH)+1;
int date		= cal.get(Calendar.DATE);

String yearStr 	= Integer.toString(cal.get(Calendar.YEAR));
String monthStr = month<10 	? "0" + Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1);
String dateStr	= date<10 	? "0" + Integer.toString(cal.get(Calendar.DATE)) 	: Integer.toString(cal.get(Calendar.DATE));

String search1 	= parseNull(request.getParameter("search1"));	// 미조사식품
String search2 	= parseNull(request.getParameter("search2"));	// 이상조사
String search3 	= parseNull(request.getParameter("search3"));	// 권역
String search4 	= parseNull(request.getParameter("search4"));	// 팀
String search5 	= parseNull(request.getParameter("search5"));	// 구분
String search6 	= parseNull(request.getParameter("search6"));	// 년도 
String sr_1		= parseNull(request.getParameter("sr_1"));		// 조사자 제출 식품
String rt_1		= parseNull(request.getParameter("rt_1"));		// 팀장 반려 식품
String rr_1		= parseNull(request.getParameter("rr_1"));		// 관리자 반려 식품

String search7 		= parseNull(request.getParameter("search7"));	// 미조사식품
String search8 		= parseNull(request.getParameter("search8"));	// 이상조사
String search9 		= parseNull(request.getParameter("search9"));	// 권역
String search10 	= parseNull(request.getParameter("search10"));	// 팀
String search11		= parseNull(request.getParameter("search11"));	// 구분
String his_rsch_no	= parseNull(request.getParameter("his_rsch_no"));	// 이전 조사 정보 리스트를 불러오기 위한 변수
String sr_2			= parseNull(request.getParameter("sr_2"));		// 조사자 제출 식품
String rt_2			= parseNull(request.getParameter("rt_2"));		// 팀장 반려 식품
String rr_2			= parseNull(request.getParameter("rr_2"));		// 관리자 반려 식품

StringBuffer sql = null;
FoodVO rschVO 					= new FoodVO();
List<FoodVO> rschList 			= null;
List<FoodVO> zoneList			= null;
List<FoodVO> teamList			= null;
List<FoodVO> teamList2			= null;
List<FoodVO> catList			= null;
List<FoodVO> rschHisList 		= null;
List<FoodVO> rschHisViewList 	= null;
FoodVO rschHisViewVO			= new FoodVO();
int result 			= 0;
int rschHisListCnt	= 0;

Paging paging 		= new Paging();
String pageNo = parseNull(request.getParameter("pageNo"), "1");
Paging2 paging2 	= new Paging2();
String pageNo2 = parseNull(request.getParameter("pageNo2"), "1");
Paging3 paging3 	= new Paging3();
String pageNo3 = parseNull(request.getParameter("pageNo3"), "1");
int totalCount = 0;

Object[] setObj		= null;
List<String> setList	= new ArrayList<String>();

//조사 개시 flag
int rsch_no		=	0;
//마감된 조사 수
int otherCnt	=	0;

try{
	// 권역 리스트
	sql = new StringBuffer();
	sql.append("SELECT * FROM FOOD_ZONE WHERE SHOW_FLAG = 'Y' ORDER BY ZONE_NM 									");
	zoneList = jdbcTemplate.query(sql.toString(), new FoodList());
	
	if(!"".equals(search3) && !"".equals(search5)){
		// 팀 리스트
		sql = new StringBuffer();
		sql.append("SELECT * FROM FOOD_TEAM WHERE SHOW_FLAG = 'Y' AND ZONE_NO = ? AND CAT_NO = ? ORDER BY ORDER1, TEAM_NM		");
		teamList = jdbcTemplate.query(sql.toString(), new FoodList(), search3, search5);
	}
	if(!"".equals(search9) && !"".equals(search11)){
		// 팀 리스트
		sql = new StringBuffer();
		sql.append("SELECT * FROM FOOD_TEAM WHERE SHOW_FLAG = 'Y' AND ZONE_NO = ? AND CAT_NO = ? ORDER BY ORDER1, TEAM_NM		");
		teamList = jdbcTemplate.query(sql.toString(), new FoodList(), search9, search11);
	}
	
	// 구분 리스트
	sql = new StringBuffer();
	sql.append("SELECT * FROM FOOD_ST_CAT WHERE SHOW_FLAG = 'Y' ORDER BY CAT_NM 								");
	catList = jdbcTemplate.query(sql.toString(), new FoodList());
	
	// 현재 진행중인 조사 정보
	sql = new StringBuffer();
	sql.append("SELECT  																							");
	sql.append("      RSCH_NO																						");
	sql.append("	, RSCH_YEAR																						");
	sql.append("	, RSCH_MONTH																					");
	sql.append("	, TO_CHAR(STR_DATE, 'YYYY-MM-DD') AS STR_DATE													");
	sql.append("	, TO_CHAR(MID_DATE, 'YYYY-MM-DD') AS MID_DATE													");
	sql.append("	, TO_CHAR(END_DATE, 'YYYY-MM-DD') AS END_DATE													");
	sql.append("	, ABS(TO_DATE(END_DATE)-TO_DATE(SYSDATE)) AS RNUM												");
	sql.append("  	, (SELECT COUNT(*) FROM FOOD_RSCH_VAL WHERE RSCH_NO = A.RSCH_NO) AS CNT							");	// 조사항목 수
	sql.append("  	, (SELECT COUNT(*) FROM FOOD_RSCH_VAL WHERE RSCH_NO = A.RSCH_NO AND STS_FLAG != 'Y') AS CNT2	");	// 미조사 항목 수
	sql.append("  	, (SELECT COUNT(*) FROM FOOD_RSCH_VAL WHERE RSCH_NO = A.RSCH_NO AND STS_FLAG = 'Y') AS CNT3		");	// 조사완료 항목 수
	sql.append("FROM FOOD_RSCH_TB A																					");
	sql.append("WHERE STS_FLAG = 'N'																				");
	try{
		rschVO = jdbcTemplate.queryForObject(sql.toString(), new FoodList());
		rsch_no	=	Integer.parseInt(rschVO.rsch_no);
	}catch(Exception e){
		rschVO = new FoodVO();
	}

	//마감 조사 cnt val
	if (rsch_no > 0) {
		sql	=	new StringBuffer();
		sql.append("SELECT COUNT(RSCH_VAL_NO) FROM FOOD_RSCH_VAL	");
		sql.append("WHERE RSCH_NO = ?								");
		sql.append("	AND STS_FLAG = 'SS'							");
		otherCnt	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class, new Object[]{rsch_no});
	}

	setList	= new ArrayList<String>();
	sql = new StringBuffer();
	sql.append("SELECT	COUNT(*) AS CNT																				");
	sql.append("FROM FOOD_RSCH_TB A LEFT JOIN FOOD_RSCH_VAL B ON A.RSCH_NO = B.RSCH_NO								");
	sql.append("                    LEFT JOIN FOOD_ST_ITEM C ON B.ITEM_NO = C.ITEM_NO								");
	sql.append("WHERE A.SHOW_FLAG = 'Y' AND A.RSCH_NO = ?															");
	
	setList.add(rschVO.rsch_no);
	if(!"".equals(search1)){
		sql.append("AND B.STS_FLAG = 'N'																				");
		paging.setParams("search1", search1);
	}
	
	if(!"".equals(search2)){
		sql.append("AND (B.NON_SEASON = 'Y' OR B.NON_DISTRI = 'Y')														");
		paging.setParams("search2", search2);
	}
	
	if(!"".equals(sr_1)){
		sql.append("AND B.STS_FLAG = 'SR'		");
		paging.setParams("sr_1", sr_1);
	}
	
	if(!"".equals(rt_1)){
		sql.append("AND B.STS_FLAG = 'RT'		");
		paging.setParams("rt_1", rt_1);
	}
	
	if(!"".equals(rr_1)){
		sql.append("AND B.STS_FLAG = 'RR'		");
		paging.setParams("rr_1", rr_1);
	}

	if(!"".equals(search3)){
		sql.append("AND (SELECT ZONE_NO FROM FOOD_SCH_TB WHERE SCH_NO = B.SCH_NO) = ?									");
		paging.setParams("search3", search3);
		setList.add(search3);
	}
	if(!"".equals(search4)){
		sql.append("AND (SELECT TEAM_NO FROM FOOD_SCH_TB WHERE SCH_NO = B.SCH_NO) = ?									");
		paging.setParams("search4", search4);
		setList.add(search4);
	}
	if(!"".equals(search5)){
		sql.append("AND B.CAT_NO = ?																					");
		paging.setParams("search5", search5);
		setList.add(search5);
	}
	
	setObj = new Object[setList.size()];
    for(int i=0; i<setList.size(); i++){
    	setObj[i] = setList.get(i);
    }
    
	totalCount = jdbcTemplate.queryForObject(sql.toString(), Integer.class, setObj);

	paging.setPageSize(50);
    paging.setPageNo(Integer.parseInt(pageNo));
	paging.setTotalCount(totalCount);
	paging.makePaging();
	
	// 현재 진행 중인 조사 목록
	sql = new StringBuffer();
	sql.append("SELECT * FROM(																                   								 	");
	sql.append("	SELECT ROWNUM AS RNUM, A.* FROM (										                    								");
	sql.append("SELECT																															");
	sql.append("    B.RSCH_VAL_NO																												");
	sql.append("  , (SELECT CAT_NM FROM FOOD_ST_CAT WHERE CAT_NO = C.CAT_NO) || '-' ||															");
	sql.append("     C.FOOD_CAT_INDEX AS CAT_NM																									");
	sql.append("  , C.FOOD_CODE																													");
	sql.append("  , ( SELECT SUBSTR( XMLAGG(  																									");
	sql.append("                        XMLELEMENT(COL ,',', NM_FOOD) ORDER BY NM_FOOD).EXTRACT('//text()' 										");
	sql.append("                    ).GETSTRINGVAL(),2) NM_FOOD 																				");
	sql.append("      FROM FOOD_ST_NM 																											");
	sql.append("      WHERE NM_NO IN (C.FOOD_NM_1, C.FOOD_NM_2, C.FOOD_NM_3, C.FOOD_NM_4, C.FOOD_NM_5)) AS NM_FOOD								"); 
	sql.append("  , ( SELECT SUBSTR( XMLAGG(																									");  
	sql.append("                        XMLELEMENT(COL,',',DT_NM) ORDER BY DT_NM).EXTRACT('//text()'											"); 
	sql.append("                    ).GETSTRINGVAL(),2) DT_NM																					"); 
	sql.append("      FROM FOOD_ST_DT_NM																										"); 
	sql.append("      WHERE DT_NO IN (C.FOOD_DT_1, C.FOOD_DT_2, C.FOOD_DT_3, C.FOOD_DT_4, C.FOOD_DT_5											");
	sql.append("                    , C.FOOD_DT_6, C.FOOD_DT_7, C.FOOD_DT_8, C.FOOD_DT_9, C.FOOD_DT_10)) AS DT_NM								");
	sql.append("  , ( SELECT SUBSTR( XMLAGG(																									");  
	sql.append("                        XMLELEMENT(COL ,',', EX_NM) ORDER BY EX_NM).EXTRACT('//text()'											"); 
	sql.append("                    ).GETSTRINGVAL(),2) EX_NM																					"); 
	sql.append("      FROM FOOD_ST_EXPL																											");
	sql.append("      WHERE EX_NO IN (C.FOOD_EP_1, C.FOOD_EP_2, C.FOOD_EP_3, C.FOOD_EP_4, C.FOOD_EP_5											");
	sql.append("                    , C.FOOD_EP_6, C.FOOD_EP_7, C.FOOD_EP_8, C.FOOD_EP_9, C.FOOD_EP_10											");
	sql.append("                    , C.FOOD_EP_11, C.FOOD_EP_12, C.FOOD_EP_13, C.FOOD_EP_14, C.FOOD_EP_15										");
	sql.append("                    , C.FOOD_EP_16, C.FOOD_EP_17, C.FOOD_EP_18, C.FOOD_EP_19, C.FOOD_EP_20										");
	sql.append("                    , C.FOOD_EP_21, C.FOOD_EP_22, C.FOOD_EP_23, C.FOOD_EP_24, C.FOOD_EP_25)) AS EX_NM							");                  
	sql.append("  , (SELECT UNIT_NM FROM FOOD_ST_UNIT WHERE UNIT_NO = C.FOOD_UNIT) AS UNIT_NM													");   
	sql.append("  , (SELECT ZONE_NM FROM FOOD_ZONE WHERE ZONE_NO = (SELECT ZONE_NO FROM FOOD_SCH_TB WHERE SCH_NO = B.SCH_NO) ) AS ZONE_NM		");
	sql.append("  , (SELECT TEAM_NM FROM FOOD_TEAM WHERE TEAM_NO = (SELECT TEAM_NO FROM FOOD_SCH_TB WHERE SCH_NO = B.SCH_NO) ) AS TEAM_NM		");
	sql.append("  , (SELECT SCH_NM FROM FOOD_SCH_TB WHERE SCH_NO = B.SCH_NO) AS SCH_NM															");
	sql.append("  , B.RSCH_VAL1, B.RSCH_VAL2, B.RSCH_VAL3, B.RSCH_VAL4, B.RSCH_VAL5																");
	sql.append("  , B.RSCH_LOC1, B.RSCH_LOC2, B.RSCH_LOC3, B.RSCH_LOC4, B.RSCH_LOC5																");
	sql.append("  , B.RSCH_COM1, B.RSCH_COM2, B.RSCH_COM3, B.RSCH_COM4, B.RSCH_COM5																"); 
	sql.append("  , B.RSCH_REASON																												");
	sql.append("  , B.T_RJ_REASON																												");
	sql.append("  , B.RJ_REASON																													");
	sql.append("  , B.STS_FLAG																													");
	sql.append("  , B.SP_CHK																													");
	sql.append("  , B.RJ_DATE																													");
	sql.append("  , (SELECT ITEM_COMP_NO FROM FOOD_ITEM_PRE WHERE ITEM_NO = B.ITEM_NO) AS ITEM_COMP_NO											");
	sql.append("  , (SELECT ITEM_COMP_VAL FROM FOOD_ITEM_PRE WHERE ITEM_NO = B.ITEM_NO) AS ITEM_COMP_VAL										");
	sql.append("  , CASE																														");
	sql.append("      WHEN (SELECT COUNT(*) FROM FOOD_RSCH_VAL WHERE ITEM_NO = B.ITEM_NO AND RSCH_NO = B.RSCH_NO)								");
	sql.append("       <= (SELECT COUNT(*) FROM FOOD_RSCH_VAL WHERE ITEM_NO = B.ITEM_NO AND RSCH_NO = B.RSCH_NO AND STS_FLAG NOT IN('N', 'RT', 'RR')) THEN 'Y'	");
	sql.append("      ELSE 'N'																													");
	sql.append("    END RCH_BACK 																												");
	sql.append("FROM FOOD_RSCH_TB A LEFT JOIN FOOD_RSCH_VAL B ON A.RSCH_NO = B.RSCH_NO															");
	sql.append("                    LEFT JOIN FOOD_ST_ITEM C ON B.ITEM_NO = C.ITEM_NO															");
	sql.append("WHERE A.SHOW_FLAG = 'Y' AND A.RSCH_NO = ?																						");
	if(!"".equals(search1)){
		sql.append("AND B.STS_FLAG = 'N'																										");
	}

	if(!"".equals(search2)){
		sql.append("AND (B.NON_SEASON = 'Y' OR B.NON_DISTRI = 'Y')																				");
	}
	
	if(!"".equals(sr_1)){
		sql.append("AND B.STS_FLAG = 'SR'		");
	}
	
	if(!"".equals(rt_1)){
		sql.append("AND B.STS_FLAG = 'RT'		");
	}
	
	if(!"".equals(rr_1)){
		sql.append("AND B.STS_FLAG = 'RR'		");
	}

	if(!"".equals(search3)){
		sql.append("AND (SELECT ZONE_NO FROM FOOD_SCH_TB WHERE SCH_NO = B.SCH_NO) = ?															");
	}
	if(!"".equals(search4)){
		sql.append("AND (SELECT TEAM_NO FROM FOOD_SCH_TB WHERE SCH_NO = B.SCH_NO) = ?															");
	}
	if(!"".equals(search5)){
		sql.append("AND B.CAT_NO = ?																											");
	}
	sql.append("ORDER BY DECODE(B.STS_FLAG, 'SS', 1, 'Y', 2, 'RR', 3, 'RT', 4, 'RS', 5, 'RC', 6, 'N', 7), B.RSCH_VAL_NO							");
	sql.append("	) A WHERE ROWNUM <= " + paging.getEndRowNo() + "																			");
	sql.append(") WHERE RNUM > " + paging.getStartRowNo() + " 																					");
	rschList = jdbcTemplate.query(sql.toString(), new FoodList(), setObj);

	
	
	sql = new StringBuffer();
	sql.append("SELECT COUNT(*) AS CNT FROM FOOD_RSCH_TB WHERE SHOW_FLAG = 'Y'		");
	if(!"".equals(search6)){
		sql.append("AND RSCH_YEAR = ?												");
		totalCount = jdbcTemplate.queryForObject(sql.toString(), Integer.class, search6);
	}else{
		totalCount = jdbcTemplate.queryForObject(sql.toString(), Integer.class);
	}

	paging2.setPageSize(5);
    paging2.setPageNo(Integer.parseInt(pageNo2));
	paging2.setTotalCount(totalCount);
	paging2.makePaging();
	
	sql = new StringBuffer();
	sql.append("SELECT * FROM(																                   		 	");
	sql.append("	SELECT ROWNUM AS RNUM, A.* FROM (										                   		 	");
	sql.append("SELECT																									");
	sql.append("    RSCH_NO																								");			
	sql.append("  , RSCH_YEAR																							");	
	sql.append("  , RSCH_MONTH																							");
	sql.append("  , RSCH_NM																								");
	sql.append("  , STS_FLAG																							");
	sql.append("  , TO_CHAR(STR_DATE, 'YYYY-MM-DD') AS STR_DATE															");
	sql.append("  , TO_CHAR(END_DATE, 'YYYY-MM-DD') AS END_DATE															");
	sql.append("  , (SELECT COUNT(*) FROM FOOD_RSCH_VAL WHERE RSCH_NO = A.RSCH_NO) AS CNT								");
	sql.append("  , (SELECT COUNT(*) FROM FOOD_RSCH_VAL WHERE RSCH_NO = A.RSCH_NO AND STS_FLAG != 'Y') AS CNT2			");	
	sql.append("  , (SELECT COUNT(*) FROM FOOD_RSCH_VAL WHERE RSCH_NO = A.RSCH_NO AND STS_FLAG = 'Y') AS CNT3			");	
	sql.append("FROM FOOD_RSCH_TB A																						");
	sql.append("WHERE SHOW_FLAG = 'Y'																					");
	if(!"".equals(search6)){
		sql.append("AND RSCH_YEAR = ?																					");
	}
	sql.append("ORDER BY RSCH_NO DESC																					");
	sql.append("	) A WHERE ROWNUM <= " + paging2.getEndRowNo() + "													");
	sql.append(") WHERE RNUM > " + paging2.getStartRowNo() + " 															");
	if(!"".equals(search6)){
		rschHisList = jdbcTemplate.query(sql.toString(), new FoodList(), search6);
	}else{
		rschHisList = jdbcTemplate.query(sql.toString(), new FoodList());
	}
	
	if(rschHisList!=null && rschHisList.size()>0){rschHisListCnt = rschHisList.size();}
	
	
	
	// 이전 조사 항목 VIEW LIST
	setList	= new ArrayList<String>();
	sql = new StringBuffer();
	sql.append("SELECT	COUNT(*) AS CNT																											");
	sql.append("FROM FOOD_RSCH_TB A LEFT JOIN FOOD_RSCH_VAL B ON A.RSCH_NO = B.RSCH_NO															");
	sql.append("                    LEFT JOIN FOOD_ST_ITEM C ON B.ITEM_NO = C.ITEM_NO															");
	sql.append("WHERE A.SHOW_FLAG = 'Y' AND A.RSCH_NO = ?																						");
	
	setList.add(his_rsch_no);
	if(!"".equals(search7)){
		sql.append("AND B.STS_FLAG = 'N'																										");
		paging3.setParams("search7", search7);
	}

	if(!"".equals(search8)){
		sql.append("AND (B.NON_SEASON = 'Y' OR B.NON_DISTRI = 'Y')																				");
		paging3.setParams("search8", search8);
	}
	
	if(!"".equals(sr_2)){
		sql.append("AND B.STS_FLAG = 'SR'		");
		paging.setParams("sr_2", sr_2);
	}
	
	if(!"".equals(rt_2)){
		sql.append("AND B.STS_FLAG = 'RT'		");
		paging.setParams("rt_2", rt_2);
	}
	
	if(!"".equals(rr_2)){
		sql.append("AND B.STS_FLAG = 'RR'		");
		paging.setParams("rr_2", rr_2);
	}

	
	if(!"".equals(search9)){
		sql.append("AND (SELECT ZONE_NO FROM FOOD_SCH_TB WHERE SCH_NO = B.SCH_NO) = ?															");
		paging3.setParams("search9", search9);
		setList.add(search9);
	}
	if(!"".equals(search10)){
		sql.append("AND (SELECT TEAM_NO FROM FOOD_SCH_TB WHERE SCH_NO = B.SCH_NO) = ?															");
		paging3.setParams("search10", search10);
		setList.add(search10);
	}
	if(!"".equals(search11)){
		sql.append("AND B.CAT_NO = ?																											");
		paging3.setParams("search11", search11);
		setList.add(search11);
	}
	
	setObj = new Object[setList.size()];
    for(int i=0; i<setList.size(); i++){
    	setObj[i] = setList.get(i);
    }
    
	totalCount = jdbcTemplate.queryForObject(sql.toString(), Integer.class, setObj);

	paging3.setPageSize(50);
    paging3.setPageNo(Integer.parseInt(pageNo3));
	paging3.setTotalCount(totalCount);
	paging3.makePaging();
	
	sql = new StringBuffer();
	sql.append("SELECT * FROM(																                   								 	");
	sql.append("	SELECT ROWNUM AS RNUM, A.* FROM (										                    								");
	sql.append("SELECT																															");
	sql.append("    B.RSCH_VAL_NO																												");
	sql.append("  , (SELECT CAT_NM FROM FOOD_ST_CAT WHERE CAT_NO = C.CAT_NO) || '-' ||															");
	sql.append("     C.FOOD_CAT_INDEX AS CAT_NM																									");
	sql.append("  , C.FOOD_CODE																													");
	sql.append("  , ( SELECT SUBSTR( XMLAGG(  																									");
	sql.append("                        XMLELEMENT(COL ,',', NM_FOOD) ORDER BY NM_FOOD).EXTRACT('//text()' 										");
	sql.append("                    ).GETSTRINGVAL(),2) NM_FOOD 																				");
	sql.append("      FROM FOOD_ST_NM 																											");
	sql.append("      WHERE NM_NO IN (C.FOOD_NM_1, C.FOOD_NM_2, C.FOOD_NM_3, C.FOOD_NM_4, C.FOOD_NM_5)) AS NM_FOOD								"); 
	sql.append("  , ( SELECT SUBSTR( XMLAGG(																									");  
	sql.append("                        XMLELEMENT(COL,',',DT_NM) ORDER BY DT_NM).EXTRACT('//text()'											"); 
	sql.append("                    ).GETSTRINGVAL(),2) DT_NM																					"); 
	sql.append("      FROM FOOD_ST_DT_NM																										"); 
	sql.append("      WHERE DT_NO IN (C.FOOD_DT_1, C.FOOD_DT_2, C.FOOD_DT_3, C.FOOD_DT_4, C.FOOD_DT_5											");
	sql.append("                    , C.FOOD_DT_6, C.FOOD_DT_7, C.FOOD_DT_8, C.FOOD_DT_9, C.FOOD_DT_10)) AS DT_NM								");
	sql.append("  , ( SELECT SUBSTR( XMLAGG(																									");  
	sql.append("                        XMLELEMENT(COL ,',', EX_NM) ORDER BY EX_NM).EXTRACT('//text()'											"); 
	sql.append("                    ).GETSTRINGVAL(),2) EX_NM																					"); 
	sql.append("      FROM FOOD_ST_EXPL																											");
	sql.append("      WHERE EX_NO IN (C.FOOD_EP_1, C.FOOD_EP_2, C.FOOD_EP_3, C.FOOD_EP_4, C.FOOD_EP_5											");
	sql.append("                    , C.FOOD_EP_6, C.FOOD_EP_7, C.FOOD_EP_8, C.FOOD_EP_9, C.FOOD_EP_10											");
	sql.append("                    , C.FOOD_EP_11, C.FOOD_EP_12, C.FOOD_EP_13, C.FOOD_EP_14, C.FOOD_EP_15										");
	sql.append("                    , C.FOOD_EP_16, C.FOOD_EP_17, C.FOOD_EP_18, C.FOOD_EP_19, C.FOOD_EP_20										");
	sql.append("                    , C.FOOD_EP_21, C.FOOD_EP_22, C.FOOD_EP_23, C.FOOD_EP_24, C.FOOD_EP_25)) AS EX_NM							");                  
	sql.append("  , (SELECT UNIT_NM FROM FOOD_ST_UNIT WHERE UNIT_NO = C.FOOD_UNIT) AS UNIT_NM													");   
	sql.append("  , (SELECT ZONE_NM FROM FOOD_ZONE WHERE ZONE_NO = (SELECT ZONE_NO FROM FOOD_SCH_TB WHERE SCH_NO = B.SCH_NO) ) AS ZONE_NM		");
	sql.append("  , (SELECT TEAM_NM FROM FOOD_TEAM WHERE TEAM_NO = (SELECT TEAM_NO FROM FOOD_SCH_TB WHERE SCH_NO = B.SCH_NO) ) AS TEAM_NM		");
	sql.append("  , (SELECT SCH_NM FROM FOOD_SCH_TB WHERE SCH_NO = B.SCH_NO) AS SCH_NM															");
	sql.append("  , B.RSCH_VAL1, B.RSCH_VAL2, B.RSCH_VAL3, B.RSCH_VAL4, B.RSCH_VAL5																");
	sql.append("  , B.RSCH_LOC1, B.RSCH_LOC2, B.RSCH_LOC3, B.RSCH_LOC4, B.RSCH_LOC5																");
	sql.append("  , B.RSCH_COM1, B.RSCH_COM2, B.RSCH_COM3, B.RSCH_COM4, B.RSCH_COM5																"); 
	sql.append("  , B.RSCH_REASON																												");
	sql.append("  , B.T_RJ_REASON																												");
	sql.append("  , B.RJ_REASON																													");
	sql.append("  , B.STS_FLAG																													");
	sql.append("  , B.SP_CHK																													");
	sql.append("  , B.RJ_DATE																													");
	sql.append("  , (SELECT ITEM_COMP_NO FROM FOOD_ITEM_PRE WHERE ITEM_NO = B.ITEM_NO) AS ITEM_COMP_NO											");
	sql.append("  , (SELECT ITEM_COMP_VAL FROM FOOD_ITEM_PRE WHERE ITEM_NO = B.ITEM_NO) AS ITEM_COMP_VAL										");
	sql.append("  , CASE																														");
	sql.append("      WHEN (SELECT COUNT(*) FROM FOOD_RSCH_VAL WHERE ITEM_NO = B.ITEM_NO AND RSCH_NO = B.RSCH_NO)								");
	sql.append("       <= (SELECT COUNT(*) FROM FOOD_RSCH_VAL WHERE ITEM_NO = B.ITEM_NO AND RSCH_NO = B.RSCH_NO AND STS_FLAG NOT IN('N', 'RT', 'RR')) THEN 'Y'	");
	sql.append("      ELSE 'N'																													");
	sql.append("    END RCH_BACK 																												");
	sql.append("FROM FOOD_RSCH_TB A LEFT JOIN FOOD_RSCH_VAL B ON A.RSCH_NO = B.RSCH_NO															");
	sql.append("                    LEFT JOIN FOOD_ST_ITEM C ON B.ITEM_NO = C.ITEM_NO															");
	sql.append("WHERE A.SHOW_FLAG = 'Y' AND A.RSCH_NO = ?																						");
	if(!"".equals(search7)){
		sql.append("AND B.STS_FLAG = 'N'																										");
	}

	if(!"".equals(search8)){
		sql.append("AND (B.NON_SEASON = 'Y' OR B.NON_DISTRI = 'Y')																				");
	}
	
	if(!"".equals(sr_2)){
		sql.append("AND B.STS_FLAG = 'SR'		");
	}
	
	if(!"".equals(rt_2)){
		sql.append("AND B.STS_FLAG = 'RT'		");
	}
	
	if(!"".equals(rr_2)){
		sql.append("AND B.STS_FLAG = 'RR'		");
	}

	if(!"".equals(search9)){
		sql.append("AND (SELECT ZONE_NO FROM FOOD_SCH_TB WHERE SCH_NO = B.SCH_NO) = ?															");
	}
	if(!"".equals(search10)){
		sql.append("AND (SELECT TEAM_NO FROM FOOD_SCH_TB WHERE SCH_NO = B.SCH_NO) = ?															");
	}
	if(!"".equals(search11)){
		sql.append("AND B.CAT_NO = ?																											");
	}
	sql.append("ORDER BY B.RSCH_VAL_NO																											");
	sql.append("	) A WHERE ROWNUM <= " + paging3.getEndRowNo() + "																			");
	sql.append(") WHERE RNUM > " + paging3.getStartRowNo() + " 																					");
	rschHisViewList = jdbcTemplate.query(sql.toString(), new FoodList(), setObj);
	
	if(!"".equals(his_rsch_no)){
		sql = new StringBuffer();
		sql.append("SELECT  																								");
		sql.append("      RSCH_NO																							");
		sql.append("	, RSCH_YEAR																							");
		sql.append("	, RSCH_MONTH																						");
		sql.append("	, TO_CHAR(STR_DATE, 'YYYY-MM-DD') AS STR_DATE														");
		sql.append("	, TO_CHAR(MID_DATE, 'YYYY-MM-DD') AS MID_DATE														");
		sql.append("	, TO_CHAR(END_DATE, 'YYYY-MM-DD') AS END_DATE														");
		sql.append("  	, (SELECT COUNT(*) FROM FOOD_RSCH_VAL WHERE RSCH_NO = A.RSCH_NO) AS CNT								");	// 조사항목 수
		sql.append("  	, (SELECT COUNT(*) FROM FOOD_RSCH_VAL WHERE RSCH_NO = A.RSCH_NO AND STS_FLAG != 'Y') AS CNT2		");	// 미조사 항목 수
		sql.append("  	, (SELECT COUNT(*) FROM FOOD_RSCH_VAL WHERE RSCH_NO = A.RSCH_NO AND STS_FLAG = 'Y') AS CNT3			");	// 조사완료 항목 수
		sql.append("FROM FOOD_RSCH_TB A																						");
		sql.append("WHERE RSCH_NO = ? 																						");
		sql.append("	AND SHOW_FLAG = 'Y' 																				");
		try{
			rschHisViewVO = jdbcTemplate.queryForObject(sql.toString(), new FoodList(), his_rsch_no);
		}catch(Exception e){
			rschHisViewVO = new FoodVO();
		}
	}
	
	
	
}catch(Exception e){
	out.println(e.toString());
}
%>
<script>
    
    function newWin(url, title, w, h){
        var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
        var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

        var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
        var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

        var left = ((width / 2) - (w / 2)) + dualScreenLeft;
        var top = ((height / 2) - (h / 2)) + dualScreenTop;
        var newWindow = window.open(url, title, 'scrollbars=yes, resizable=yes, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
    }
    function updatePopup(upd_no, upd_flag, sts_flag){
    	var url = "?upd_no="+upd_no+"&upd_flag="+upd_flag+"&sts_flag="+sts_flag
    	newWin("food_update_popup.jsp"+url, 'PRINTVIEW', '1000', '740');
    }
    
    // 조사 엑셀 업로드
    function researchExcel(){
		<%/*if (rsch_no > 0) {%>
			alert("조사 개시 중에는 엑셀 업로드가 안됩니다.\n개시 중인 조사를 취소하거나 완료하세요.");
			return false;
		<%} else {*/%>
			var url = "/program/food/research/research_excel_popup.jsp";
			newWin(url, "PRINTVIEW", "1000", "740");
		<%/*}*/%>
    }

    //조사 내용 수정 function
    function researchMod (type) {
    	var rsch_no = $("#rsch_no").val();
        var url = "";
        if (type == "mod") {
        	url = "/program/food/research/research_popup.jsp?mode=" + type + "&rsch_no=" + rsch_no;
        	newWin(url, "PRINTVIEW", "1000", "740");
        } else {
			<%if (rsch_no > 0) {%>
				alert("복수의 조사개시를 할 수는 없습니다.\n개시 중인 조사를 취소하거나 완료하세요.");
				return false;
			<%} else {%>
				url = "/program/food/research/research_popup.jsp?mode=" + type;
				newWin(url, "PRINTVIEW", "1000", "740");
			<%}%>
        }
    }
	//미조사, 이상조사 중복 불가 function
	$(function() {
		$("#searchForm #search1").click(function () {
			if($("#searchForm #search1").is(":checked")){
				$("#searchForm #search2").prop("checked", false);
			}
			return;
		});
		$("#searchForm #search2").click(function () {
			if($("#searchForm #search2").is(":checked")){
				$("#searchForm #search1").prop("checked", false);
			}
			return;
		});

		//전체 체크박스 event
        $(".all_chk").click(function () {

            if ($(".all_chk").is(":checked")) {
                $(".val_chk").not(":disabled").prop('checked', true);
                return;
            }
            $(".val_chk").prop('checked', false);
            return;
        });
		
		
		$("#sr_1").click(function(){$("#rt_1").prop("checked", false); $("#rr_1").prop("checked", false);});
		$("#rt_1").click(function(){$("#sr_1").prop("checked", false); $("#rr_1").prop("checked", false);});
		$("#rr_1").click(function(){$("#sr_1").prop("checked", false); $("#rt_1").prop("checked", false);});
		
		$("#sr_2").click(function(){$("#rt_2").prop("checked", false); $("#rr_2").prop("checked", false);});
		$("#rt_2").click(function(){$("#sr_2").prop("checked", false); $("#rr_2").prop("checked", false);});
		$("#rr_2").click(function(){$("#sr_2").prop("checked", false); $("#rt_2").prop("checked", false);});
	});
	//마감 모두 승인 function
	function otherAcept () {
		//alert("준비 마쳤습니다.. 적용을 원하시면 연락주세요.");
		//return;
		 otherCnt	=	"<%=otherCnt %>";
		if (otherCnt < 1) {
			alert("마감된 조사 식품이 없습니다.");
		} else {
			if (confirm("마감된 조사 식품을 모두 승인처리 하시겠습니까?") == true) {
				location.href	=	"./food_research_act.jsp?mode=otherApproval&sts_flag=Y";
			}
		}
	}

	//일괄승인 function
    function wholeAcept () {
		//alert("준비 마쳤습니다.. 적용을 원하시면 연락주세요.");
		//return;
		//1st check cnt
        var chk_class   =   $(".val_chk");
        if (chk_class.length < 1) {
            alert("승인대상이 없습니다.");
            return;
        }
        var chk_val     =   "";
		//2nd check checked val
        for (var i = 0; i < chk_class.length; i++) {
            if (chk_class.eq(i).is(":checked") && chk_val.length > 0) {
                chk_val +=  "," + chk_class.eq(i).val();
            } else if (chk_class.eq(i).is(":checked")) {
                chk_val =   chk_class.eq(i).val();
            }
        }
        //3rd check value chk
        if (chk_val.length < 1) {
            alert("승인대상을 선택하세요.");
            return;
        }
		//4th submit
		if (confirm("선택한 대상을 승인 하시겠습니까?") == true) {
			location.href	=	"./food_research_act.jsp?mode=researchApproval&rsch_val_group=" + chk_val + "&sts_flag=Y";
		}
	}
    
    // 검색
    function searchSubmit(){
		if($("#searchForm #search1").is(":checked")){
			$("#totalForm #t_search1").val($("#searchForm #search1").val());
			$("#totalForm #t_search1").attr("checked", "true");
		}
		if($("#searchForm #search2").is(":checked")){
			$("#totalForm #t_search2").val($("#searchForm #search2").val());
			$("#totalForm #t_search2").attr("checked", "true");
		}
		
		if($("#searchForm #sr_1").is(":checked")){
			$("#totalForm #t_sr_1").val($("#searchForm #sr_1").val());
			$("#totalForm #t_sr_1").attr("checked", "true");
		}
		
		if($("#searchForm3 #rt_1").is(":checked")){
			$("#totalForm #t_rt_1").val($("#searchForm3 #rt_1").val());
			$("#totalForm #t_rt_1").attr("checked", "true");
		}
		
		if($("#searchForm #rr_1").is(":checked")){
			$("#totalForm #t_rr_1").val($("#searchForm #rr_1").val());
			$("#totalForm #t_rr_1").attr("checked", "true");
		}
		
		$("#totalForm #t_search3").val($("#searchForm #search3").val());
		$("#totalForm #t_search4").val($("#searchForm #search4").val());
		$("#totalForm #t_search5").val($("#searchForm #search5").val());
		
		$("#totalForm #t_search6").val($("#searchForm2 #search6").val());
		
		if($("#searchForm3 #search7").is(":checked")){
			$("#totalForm #t_search7").val($("#searchForm3 #search7").val());
			$("#totalForm #t_search7").attr("checked", "true");
		}
		if($("#searchForm3 #search8").is(":checked")){
			$("#totalForm #t_search8").val($("#searchForm3 #search8").val());
			$("#totalForm #t_search8").attr("checked", "true");
		}
		
		if($("#searchForm3 #sr_2").is(":checked")){
			$("#totalForm #t_sr_2").val($("#searchForm3 #sr_2").val());
			$("#totalForm #t_sr_2").attr("checked", "true");
		}
		
		if($("#searchForm3 #rt_2").is(":checked")){
			$("#totalForm #t_rt_2").val($("#searchForm3 #rt_2").val());
			$("#totalForm #t_rt_2").attr("checked", "true");
		}
		
		if($("#searchForm3 #rr_2").is(":checked")){
			$("#totalForm #t_rr_2").val($("#searchForm3 #rr_2").val());
			$("#totalForm #t_rr_2").attr("checked", "true");
		}
		
		$("#totalForm #t_search9").val($("#searchForm3 #search9").val());
		$("#totalForm #t_search10").val($("#searchForm3 #search10").val());
		$("#totalForm #t_search11").val($("#searchForm3 #search11").val());
		
		$("#totalForm").attr("action", "");
		$("#totalForm").attr("method", "get");
		$("#totalForm").submit();
	}
    
    function getView(rsch_no){
    	$("#totalForm #t_his_rsch_no").val(rsch_no);
    	searchSubmit();
    }
    
    function researchCom(rsch_no){
    	if(confirm("조사를 승인하시겠습니까?\n조사승인을 하시면,\n미조사된 조사는 강제 완료처리됩니다.\n이후 수정 할 수 없습니다.")){
    		location.href="food_research_act.jsp?mode=researchCom&rsch_no="+rsch_no;
    	}
    }
    
    function researchCan(rsch_no){
    	if(confirm("조사를 취소 하시겠습니까?\n조사취소를 하면 조사한 내용과\n조사개시 자체가 삭제 됩니다.")){
    		location.href="food_research_act.jsp?mode=researchCan&rsch_no="+rsch_no;
    	}
    }
    
    function teamSelect1(cat_no){
    	var html = "";
    	var zone_no = $("#search3").val();
    	if(cat_no != ""){
    		$.ajax({
        		type : "POST",
        		url : "/program/food/research/team_list.jsp",
        		data : {
        			"zone_no" : zone_no,
        			"cat_no"  : cat_no,
        			"mode"	  : "team"    
        			},
        		async : false,
        		success : function(data){
        			html += "<option value=''>팀 선택</option>";
        			html += data.trim();
        			$("#searchForm #search4").html(html);
        		},
        		error : function(request, status, error){
        		}
        	});
    	}else{
    		html += "<option value=''>팀 선택</option>";
    		$("#searchForm #search4").html(html);
    	}
    	
    }
    
    function teamSelect2(cat_no){
    	var html = "";
    	var zone_no = $("#search9").val();
    	if(cat_no != ""){
    		$.ajax({
        		type : "POST",
        		url : "/program/food/research/team_list.jsp",
        		data : {
        			"zone_no" : zone_no,
        			"cat_no"  : cat_no,
        			"mode"	  : "team"    
        			},
        		async : false,
        		success : function(data){
        			html += "<option value=''>팀 선택</option>";
        			html += data.trim();
        			$("#searchForm3 #search10").html(html);
        		},
        		error : function(request, status, error){
        		}
        	});
    	}else{
    		html += "<option value=''>팀 선택</option>";
    		$("#searchForm3 #search10").html(html);
    	}
    	
    }

    function researchApproval(rsch_val_no){
    	if(confirm("승인하시겠습니까?")){
        	location.href="food_research_act.jsp?mode=researchApproval&rsch_val_no="+rsch_val_no+"&sts_flag=Y";
    	}
    }
    function researchRejection(){
    	var rsch_val_no = $("#rejectionForm #rsch_val_no").val();
    	var rj_reason = $("#rejectionForm #rj_reason").val();
    	if(confirm("반려하시겠습니까?")){
        	location.href="food_research_act.jsp?mode=researchApproval&rsch_val_no="+rsch_val_no+"&sts_flag=RR&rj_reason="+rj_reason;
    	}
    }
    function rejectionModal(rsch_val_no){
    	$("#rejectionForm #rsch_val_no").val(rsch_val_no);
    	$("#rejectionForm #rj_reason").val("");
    	$("#rejectionDiv").popup("show");
    }
    function rejectionModalClose(){
    	$("#rejectionDiv").popup("hide");
    }
    function reasonModal(reason){
    	$("#reasonDiv #rj_reason").text(reason);
    	$("#reasonDiv").popup("show");
    	
    }
    function reasonModalClose(){
    	$("#reasonDiv").popup("hide");
    }
</script>
<!-- MODAL START -->
<div id="rejectionDiv" style="display: none; width: 30%;">
	<form id="rejectionForm">
		<fieldset>
			<input type="hidden" id="rsch_val_no">
		</fieldset>
		<div class="top_view">
			<p class="location"><strong>반려사유 입력</strong></p>
		</div>
		<table class="bbs_list">
		<colgroup>
			<col width="15%">
			<col width="75%">
		</colgroup>
			<tr>
				<th scope="row">반려사유</th>
				<td>
					<textarea class="wps_60 h080" id="rj_reason"></textarea>
				</td>
			</tr>
		</table>
		<p class="btn_area txt_c">
			<button type="button" class="btn medium edge mako" onclick="rejectionModalClose()">닫기</button>
			<button type="button" class="btn medium edge green" onclick="researchRejection()">확인</button>
		</p>
	</form>
</div>

<div id="reasonDiv" style="display: none; width: 30%;">
	<div class="top_view">
		<p class="location"><strong>반려사유</strong></p>
	</div>
	<table class="bbs_list">
		<tr>
			<td>
				<span id="rj_reason"></span>
			</td>
		</tr>
	</table>
	<p class="btn_area txt_c">
		<button type="button" class="btn small edge mako" onclick="reasonModalClose()">닫기</button>
	</p>
</div>
<!-- MODAL END -->


<div id="right_view">
		<div class="top_view">
				<p class="location"><strong><%=pageTitle %></strong></p>
				<p class="loc_admin">
                    <a href="/iam/main/index.sko?lang=en_US" target="_top" class="white">ENGLISH</a> <span class="yellow">[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span>님 안녕하세요.
                    <a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
                </p>
		</div>
</div>
<!-- S : #content -->
<div id="content">
	<h2 class="tit"><%=pageTitle%></h2>
	
	<form id="totalForm" class="hidden">
	<%if(!"".equals(rschVO.rsch_no)){%>
		<input type="checkbox" name="search1" id="t_search1">
		<input type="checkbox" name="search2" id="t_search2">
		<input type="checkbox" name="sr_1" id="t_sr_1">
		<input type="checkbox" name="rt_1" id="t_rt_1">
		<input type="checkbox" name="rr_1" id="t_rr_1">
		<input type="hidden" name="search3" id="t_search3">
		<input type="hidden" name="search4" id="t_search4">
		<input type="hidden" name="search5" id="t_search5">
	<%} %>
		<input type="hidden" name="search6" id="t_search6">
	<%if(!"".equals(rschHisViewVO.rsch_no)){%>
		<input type="hidden" name="search7" id="t_search7">
		<input type="hidden" name="search8" id="t_search8">
		<input type="hidden" name="search9" id="t_search9">
		<input type="hidden" name="search10" id="t_search10">
		<input type="hidden" name="search11" id="t_search11">
		<input type="checkbox" name="sr_2" id="t_sr_2">
		<input type="checkbox" name="rt_2" id="t_rt_2">
		<input type="checkbox" name="rr_2" id="t_rr_2">
	<%} %>
		<input type="hidden" name="his_rsch_no" id="t_his_rsch_no" value="<%=his_rsch_no%>">
	</form>
	
	<%
	if(!"".equals(rschVO.rsch_no)){
	%>
	
	<h2 class="rschTit">
		<%=rschVO.rsch_year%>년 <%=rschVO.rsch_month%>월 조사기간입니다.
	</h2>
	<div class="box_01">
		<ul class="type01 fsize_120">
			<li>시작일 : <%=rschVO.str_date %> </li>
			<li>제출종료일 : <%=rschVO.mid_date %></li>
			<li>마감종료일 : <%=rschVO.end_date%></li>
			<li>D-<%=rschVO.rnum%></li>
			<li>조사품목 <%=rschVO.cnt3 %>/<%=rschVO.cnt%> 완료</li>
		</ul>
	</div>
	<div class="searchBox magB20">
		<form id="searchForm" method="get" class="topbox2">
			<fieldset>
				<input type="hidden" id="rsch_no" value="<%=rschVO.rsch_no%>">
				<input type="checkbox" id="search1" name="search1" value="Y" <%if("Y".equals(search1)){out.println("checked"); }%>>
					<label for="search1">미조사 식품 보기</label>
				<input type="checkbox" id="search2" name="search2" value="Y" <%if("Y".equals(search2)){out.println("checked"); }%>>
					<label for="search2">이상 조사 보기</label>
				<input type="checkbox" id="sr_1" name="sr_1" value="Y" <%if("Y".equals(sr_1)){out.println("checked"); }%>>
					<label for="sr_1">조사자 제출 식품 보기</label>
				<input type="checkbox" id="rt_1" name="rt_1" value="Y" <%if("Y".equals(rt_1)){out.println("checked"); }%>>
					<label for="rt_1">팀장 반려 식품 보기</label>
				<input type="checkbox" id="rr_1" name="rr_1" value="Y" <%if("Y".equals(rr_1)){out.println("checked"); }%>>
					<label for="rr_1">관리자 반려 식품 보기</label>
				<select id="search3" name="search3">
					<option value="">권역 선택</option>
				<%
				if(zoneList!=null && zoneList.size()>0){
					for(FoodVO ob : zoneList){
						out.println("<option value='"+ ob.zone_no +"'");
						if(search3.equals(ob.zone_no)){
							out.println(" selected ");
						}
						out.println(">" + ob.zone_nm +"</option>");
					}
				}
				%>	
				</select>
				<select id="search5" name="search5" onchange="teamSelect1(this.value)">
					<option value="">구분 선택</option>
				<%
				if(catList!=null && catList.size()>0){
					for(FoodVO ob : catList){
						out.println("<option value='"+ ob.cat_no +"'");
						if(search5.equals(ob.cat_no)){
							out.println(" selected ");
						}
						out.println(">" + ob.cat_nm +"</option>");
					}
				}
				%>
				</select>
				<select id="search4" name="search4">
					<option value="">팀 선택</option>
				<%
				if(teamList!=null && teamList.size()>0){
					for(FoodVO ob : teamList){
						out.println("<option value='"+ ob.team_no +"'");
						if(search4.equals(ob.team_no)){
							out.println(" selected ");
						}
						out.println(">" + ob.team_nm +"</option>");
					}
				}
				%>
				</select>
				<button type="button" class="btn small edge mako" onclick="searchSubmit();">조회</button>
				
				<div class="f_r">
					<button type="button" class="btn small edge darkMblue" onclick="otherAcept();"><span><%=otherCnt%> 개</span> 마감 모두 승인처리</button>
					<button type="button" class="btn small edge white" onclick="wholeAcept();">일괄 승인처리</button>
					<button type="button" class="btn small edge green" onclick="researchMod('mod');">조사내용수정</button>
					<%-- <button type="button" class="btn small edge darkMblue" onclick="researchCom('<%=rschVO.rsch_no%>')" >조사완료</button> --%>
					<button type="button" class="btn small edge mako" onclick="researchCan('<%=rschVO.rsch_no%>')" >조사취소</button>
				</div>
			</fieldset>
		</form>
	</div>
	
	<table class="bbs_list">
		<caption><%=pageTitle%> 테이블</caption>
		<colgroup>
			<col style="width: 2%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col >
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
		</colgroup>
		<thead>
			<tr>
				<th scope="col"><input type="checkbox" value="all" class="all_chk"></th>
				<th scope="col">식품 조사번호</th>
				<th scope="col">구분</th>	
				<th scope="col">식품코드</th>
				<th scope="col">식품명</th>
				<th scope="col">상세 식품명</th>
				<th scope="col">식품설명</th>
				<th scope="col">단위</th>
				<th scope="col">비교그룹</th>
				<th scope="col">권역/팀</th>
				<th scope="col">학교</th>
				<th scope="col">조사가1</th>
				<th scope="col">조사가2</th>
				<th scope="col">조사가3</th>
				<th scope="col">조사가4</th>
				<th scope="col">조사가5</th>
				<th scope="col">조사처1</th>
				<th scope="col">조사처2</th>
				<th scope="col">조사처3</th>
				<th scope="col">조사처4</th>
				<th scope="col">조사처5</th>
				<th scope="col">브랜드1</th>
				<th scope="col">브랜드2</th>
				<th scope="col">브랜드3</th>
				<th scope="col">브랜드4</th>
				<th scope="col">브랜드5</th>
				<th scope="col">사유</th>
				<th scope="col">승인/반려</th>
			</tr>
		</thead>
		<tbody>
		<%
		if(rschList!=null && rschList.size()>0){
			for(FoodVO ob : rschList){
		%>
			<tr <%if("Y".equals(ob.rch_back)){out.println("class=\"bak-yellow\"");} %>>
				<%//일괄승인 체크 박스 추가	20180517_thur	JI
				%>
				<td>
					<input type="checkbox" class="val_chk" value="<%=ob.rsch_val_no %>" 
					<%if (!"SS".equals(ob.sts_flag)) {%>
						disabled onclick="alert('마감되지 않은 조사식품은 승인되지 않습니다.');"
					<%}%> >
				</td>
				<td><%=ob.rsch_val_no %></td>
				<td><%=ob.cat_nm%></td>
				<td><%=ob.food_code %></td>
				<td><%=ob.nm_food %></td>
				<td><%=ob.dt_nm %></td>
				<td><%=ob.ex_nm %></td>
				<td><%=ob.unit_nm %></td>
				<td><%=ob.item_comp_no %>-<%=ob.item_comp_val %></td>
				<td><%=ob.zone_nm %> / <%=ob.team_nm %></td>
				<td><%=ob.sch_nm %></td>
				<td><%=numberComma(ob.rsch_val1) %></td>
				<td><%=numberComma(ob.rsch_val2) %></td>
				<td><%=numberComma(ob.rsch_val3) %></td>
				<td><%=numberComma(ob.rsch_val4) %></td>
				<td><%=numberComma(ob.rsch_val5) %></td>
				<td><%=ob.rsch_loc1 %></td>
				<td><%=ob.rsch_loc2 %></td>
				<td><%=ob.rsch_loc3 %></td>
				<td><%=ob.rsch_loc4 %></td>
				<td><%=ob.rsch_loc5 %></td>
				<td><%=ob.rsch_com1 %></td>
				<td><%=ob.rsch_com2 %></td>
				<td><%=ob.rsch_com3 %></td>
				<td><%=ob.rsch_com4 %></td>
				<td><%=ob.rsch_com5 %></td>
				<td><%=ob.rsch_reason %></td>
				<td>
				<%
				
				if("N".equals(ob.sts_flag)){
					out.println("미조사");
				}else if("RS".equals(ob.sts_flag)){
					out.println("검증");
				}else if("SR".equals(ob.sts_flag)){
					out.println("조사자 제출");
				}else if("RC".equals(ob.sts_flag)){
					out.println("검토");
				}else if("RT".equals(ob.sts_flag)){
				%>
					<a href="javascript:reasonModal('<%=ob.t_rj_reason.replace("\n", "<br>")%>')">팀장 반려</a>
				<%
				}else if("SS".equals(ob.sts_flag)){
				%>
					<button type="button" class="btn small edge green" onclick="researchApproval('<%=ob.rsch_val_no%>')">승인</button>
					<button type="button" class="btn small edge mako" onclick="rejectionModal('<%=ob.rsch_val_no%>')">반려</button>
				<%
				}else if("RR".equals(ob.sts_flag)){
				%>
					<a href="javascript:reasonModal('<%=ob.rj_reason.replace("\n", "<br>")%>')">관리자 반려</a>
				<%
				}else if("Y".equals(ob.sts_flag)){
					out.println("승인");
				}
				%>
				</td>
			</tr>
		<%
			}
		}else{
		%>
		<tr>
			<td colspan="28">데이터가 없습니다.</td>
		</tr>
		<%} %>
		
		</tbody>
	</table>
	
	<% if(paging.getTotalCount() > 0) { %>
	<div class="page_area">
		<%=paging.getHtml() %>
	</div>
	<% } %>

	<%
	}
	%>
	
	<div class="searchBox magB20">
		<form id="searchForm2" method="get" class="topbox2">
			<fieldset>
				<select id="search6" name="search6">
					<option value="">년도 선택</option>
					<option value="2018" <%if("2018".equals(search6)){out.println("selected");}%>>2018년</option>
					<option value="2017" <%if("2017".equals(search6)){out.println("selected");}%>>2017년</option>
					<option value="2016" <%if("2016".equals(search6)){out.println("selected");}%>>2016년</option>
				</select>
				<button type="button" class="btn small edge mako" onclick="searchSubmit();">조회</button>
				<div class="f_r">
					<button type="button" class="btn small edge green" onclick="researchExcel();">엑셀 업로드</button>
					<button type="button" class="btn small edge green" onclick="researchMod('new');">조사개시</button>
				</div>
			</fieldset>
		</form>
	</div>
	<h2 class="rschTit">
		<%=yearStr%>년 조사 수 <%=rschHisListCnt%> 건
	</h2>
	<table class="bbs_list">
		<caption><%=pageTitle%> 테이블</caption>
		<colgroup>
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
			<col style="width: 10%">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">조사번호</th>
				<th scope="col">년도</th>	
				<th scope="col">조사월</th>
				<th scope="col">조사명</th>
				<th scope="col">조사완료 여부</th>
				<th scope="col">개시일</th>
				<th scope="col">완료일</th>
				<th scope="col">조사항목 수</th>
				<th scope="col">미조사 수</th>
				<th scope="col">조사완료 수</th>
			</tr>
		</thead>
		<tbody>
		<%
		if(rschHisList!=null && rschHisList.size()>0){
			for(FoodVO ob : rschHisList){
		%>
			<tr>
				<td><%=ob.rsch_no %></td>
				<td><%=ob.rsch_year %></td>
				<td><%=ob.rsch_month %></td>
				<td><a href="javascript:getView('<%=ob.rsch_no%>')"><%=ob.rsch_nm %></a></td>
				<td><%=ob.sts_flag %></td>
				<td><%=ob.str_date %></td>
				<td><%=ob.end_date %></td>
				<td><%=ob.cnt %></td>
				<td><%=ob.cnt2 %></td>
				<td><%=ob.cnt3 %></td>
			</tr>
		<%
			}
		}else{
		%>
		<tr>
			<td colspan="10">데이터가 없습니다.</td>
		</tr>
		<%} %>
		</tbody>
	</table>
	<% if(paging2.getTotalCount() > 0) { %>
	<div class="page_area">
		<%=paging2.getHtml() %>
	</div>
	<% } %>
	
	
	<!-- 이전 조사 목록 VIEW LIST -->
	<%
	if(!"".equals(rschHisViewVO.rsch_no)){
	%>
	
	<h2 class="tit"><%=rschHisViewVO.rsch_year%>년 <%=rschHisViewVO.rsch_month%>월 조사</h2>
	<span>조사품목 <%=rschHisViewVO.cnt3 %>/<%=rschHisViewVO.cnt%> 완료</span>
	<div class="searchBox magB20">
		<form id="searchForm3" method="get" class="topbox2">
			<fieldset>
				<input type="checkbox" id="search7" name="search7" value="Y" <%if("Y".equals(search7)){out.println("checked"); }%>>
					<label for="search7">미조사 식품 보기</label>
				<input type="checkbox" id="search8" name="search8" value="Y" <%if("Y".equals(search8)){out.println("checked"); }%>>
					<label for="search8">이상 조사 보기</label>
				<input type="checkbox" id="sr_2" name="sr_2" value="Y" <%if("Y".equals(sr_2)){out.println("checked"); }%>>
					<label for="sr_2">조사자 제출 식품 보기</label>
				<input type="checkbox" id="rt_2" name="rt_2" value="Y" <%if("Y".equals(rt_2)){out.println("checked"); }%>>
					<label for="rt_2">팀장 반려 식품 보기</label>
				<input type="checkbox" id="rr_2" name="rr_2" value="Y" <%if("Y".equals(rr_2)){out.println("checked"); }%>>
					<label for="rr_2">관리자 반려 식품 보기</label>
				<select id="search9" name="search9" >
					<option value="">권역 선택</option>
				<%
				if(zoneList!=null && zoneList.size()>0){
					for(FoodVO ob : zoneList){
						out.println("<option value='"+ ob.zone_no +"'");
						if(search9.equals(ob.zone_no)){
							out.println(" selected ");
						}
						out.println(">" + ob.zone_nm +"</option>");
					}
				}
				%>	
				</select>
				<select id="search11" name="search11" onchange="teamSelect2(this.value)">
					<option value="">구분 선택</option>
				<%
				if(catList!=null && catList.size()>0){
					for(FoodVO ob : catList){
						out.println("<option value='"+ ob.cat_no +"'");
						if(search11.equals(ob.cat_no)){
							out.println(" selected ");
						}
						out.println(">" + ob.cat_nm +"</option>");
					}
				}
				%>
				</select>
				<select id="search10" name="search10">
					<option value="">팀 선택</option>
				<%
				if(teamList!=null && teamList.size()>0){
					for(FoodVO ob : teamList){
						out.println("<option value='"+ ob.team_no +"'");
						if(search10.equals(ob.team_no)){
							out.println(" selected ");
						}
						out.println(">" + ob.team_nm +"</option>");
					}
				}
				%>
				</select>
				<button type="button" class="btn small edge mako" onclick="searchSubmit();">조회</button>
			</fieldset>
		</form>
	</div>
	
	<table class="bbs_list">
		<caption><%=pageTitle%> 테이블</caption>
		<colgroup>
			<col style="width: 2%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col >
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
			<col style="width: 3.3%">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">식품 조사번호</th>
				<th scope="col">구분</th>	
				<th scope="col">식품코드</th>
				<th scope="col">식품명</th>
				<th scope="col">상세 식품명</th>
				<th scope="col">식품설명</th>
				<th scope="col">단위</th>
				<th scope="col">비교그룹</th>
				<th scope="col">권역/팀</th>
				<th scope="col">학교</th>
				<th scope="col">조사가1</th>
				<th scope="col">조사가2</th>
				<th scope="col">조사가3</th>
				<th scope="col">조사가4</th>
				<th scope="col">조사가5</th>
				<th scope="col">조사처1</th>
				<th scope="col">조사처2</th>
				<th scope="col">조사처3</th>
				<th scope="col">조사처4</th>
				<th scope="col">조사처5</th>
				<th scope="col">브랜드1</th>
				<th scope="col">브랜드2</th>
				<th scope="col">브랜드3</th>
				<th scope="col">브랜드4</th>
				<th scope="col">브랜드5</th>
				<th scope="col">사유</th>
				<th scope="col">승인/반려</th>
			</tr>
		</thead>
		<tbody>
		<%
		if(rschHisViewList!=null && rschHisViewList.size()>0){
			for(FoodVO ob : rschHisViewList){
		%>
			<tr <%if("Y".equals(ob.rch_back)){out.println("class=\"bak-yellow\"");} %>>
				<td><%=ob.rsch_val_no %></td>
				<td><%=ob.cat_nm%></td>
				<td><%=ob.food_code %></td>
				<td><%=ob.nm_food %></td>
				<td><%=ob.dt_nm %></td>
				<td><%=ob.ex_nm %></td>
				<td><%=ob.unit_nm %></td>
				<td><%=ob.item_comp_no %>-<%=ob.item_comp_val %></td>
				<td><%=ob.zone_nm %> / <%=ob.team_nm %></td>
				<td><%=ob.sch_nm %></td>
				<td><%=numberComma(ob.rsch_val1) %></td>
				<td><%=numberComma(ob.rsch_val2) %></td>
				<td><%=numberComma(ob.rsch_val3) %></td>
				<td><%=numberComma(ob.rsch_val4) %></td>
				<td><%=numberComma(ob.rsch_val5) %></td>
				<td><%=ob.rsch_loc1 %></td>
				<td><%=ob.rsch_loc2 %></td>
				<td><%=ob.rsch_loc3 %></td>
				<td><%=ob.rsch_loc4 %></td>
				<td><%=ob.rsch_loc5 %></td>
				<td><%=ob.rsch_com1 %></td>
				<td><%=ob.rsch_com2 %></td>
				<td><%=ob.rsch_com3 %></td>
				<td><%=ob.rsch_com4 %></td>
				<td><%=ob.rsch_com5 %></td>
				<td><%=ob.rsch_reason %></td>
				<td>
				<%
				if("N".equals(ob.sts_flag)){
					out.println("미조사");
				}else if("RS".equals(ob.sts_flag)){
					out.println("검증");
				}else if("SR".equals(ob.sts_flag)){
					out.println("조사자 제출");
				}else if("RC".equals(ob.sts_flag)){
					out.println("검토");
				}else if("RT".equals(ob.sts_flag)){
				%>
					<a href="javascript:reasonModal('<%=ob.t_rj_reason.replace("\n", "<br>")%>')">팀장 반려</a>
				<%
				}else if("SS".equals(ob.sts_flag)){
				%>
					<button type="button" class="btn small edge green" onclick="researchApproval('<%=ob.rsch_val_no%>')">승인</button>
					<button type="button" class="btn small edge mako" onclick="rejectionModal('<%=ob.rsch_val_no%>')">반려</button>
				<%
				}else if("RR".equals(ob.sts_flag)){
				%>
					<a href="javascript:reasonModal('<%=ob.rj_reason.replace("\n", "<br>")%>')">관리자 반려</a>
				<%
				}else if("Y".equals(ob.sts_flag)){
					out.println("승인");
				}
				%>
				</td>
			</tr>
		<%
			}
		}else{
		%>
		<tr>
			<td colspan="26">데이터가 없습니다.</td>
		</tr>
		<%} %>
		
		</tbody>
	</table>
	<% if(paging3.getTotalCount() > 0) { %>
	<div class="page_area">
		<%=paging3.getHtml() %>
	</div>
	<% } %>

	<%
	}
	%>
	
	
	
</div>
<!-- // E : #content -->  
</body>
    
</html>