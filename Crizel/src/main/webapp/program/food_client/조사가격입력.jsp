<%
/**
* PURPOSE : 조사가격입력 page
*	CREATE	:	조사가격입력 html 코딩 / 20180328 LJH
*	MODIFY	:	html 코딩 완료 / 20180403 LJH
*	MODIFY	:	20180425_wed	KO		최저가 삭제 및 비교그룹 출력, 학교급식 관리자 권한 추가
*/
%>
<%@page import="egovframework.rfc3.user.web.SessionManager"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%
String foodRole		= 	"ROLE_000094";		//운영서버:ROLE_000094 , 테스트서버:ROLE_000012	

request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");
SessionManager sManager =	new SessionManager(request); 

int viewYN			=	0;		//1일경우 페이지 정상 작동
String moveUrl		=	"/index.gne?contentsSid=2303";					//액션페이지		// 운영서버:2303, 테스트서버:661
String moveUrlLog	=	"/index.gne?menuCd=DOM_000002101003001000";		//이력페이지(새창)	// 운영서버:DOM_000002101003001000, 테스트서버:DOM_000000127003002000
String moveUrlMain	=	"/index.gne?menuCd=DOM_000002101000000000";		//메인페이지

//2차 로그인 여부
if("Y".equals(session.getAttribute("foodLoginChk")) || sManager.isRoleAdmin() || sManager.isRole(foodRole)){
	viewYN	=	1;
}else{
	out.print("<script> 							\n");
	out.print("alert('2차 로그인 후 이용하실 수 있습니다.');		\n");
	out.print("location.href='" + moveUrlMain + "'; \n");
	out.print("</script> 							\n");
  return;
}

if(viewYN == 1){
	StringBuffer sql 		= 	null;
	String sqlWhere			=	"";
	int resultCnt 			=	0;
	int cnt					=	0;
	int allCnt				= 	0;
	int completeCnt			=	0;
	int nCompleteCnt		=	0;
	int leaderNCnt			=	0;
	
	int pageNo				=	Integer.parseInt(parseNull(request.getParameter("pageNo"), "1"));
	
	// 조사자 = ( 0 : 미완료, 1 : 완료  )|| 조사팀장 = ( 0 : 검토대상, 1 : 미감완료, 2 : 미제출 )
	int actType				=	Integer.parseInt(parseNull(request.getParameter("actType"), "0"));	
	
	FoodVO foodVO			=	new FoodVO();
	FoodVO tbVO				=	new FoodVO();
	FoodVO cntVO			=	new FoodVO();
	Paging pagingVO			=	new Paging();
	List<FoodVO> userList	=	null;
	List<FoodVO> rschList	=	null;
	
	String schId			=	sManager.getId();
	String titleTxt			=	"";		//조사, 미조사 품목 텍스트	
	String chkNoData		=	parseNull(request.getParameter("chkNoData"), "N");

	try{
		//userList
		sql		=	new StringBuffer();
		sql.append(" SELECT  						            \n");
		sql.append(" SCH.SCH_GRADE, 				        \n");
		sql.append(" SCH.SCH_NO, 					          \n");
		sql.append(" SCH.ZONE_NO, 					        \n");
		sql.append(" ZONE.ZONE_NM, 					        \n");
		sql.append(" SCH.TEAM_NO, 					        \n");
		sql.append(" SCH.JO_NO,  					          \n");
		sql.append(" SCH.AREA_NO,  					        \n");
		sql.append(" NU.NU_NO,  					          \n");
		sql.append(" NU.NU_NM  						          \n");
		sql.append(" FROM FOOD_SCH_TB SCH			      \n");
		sql.append(" LEFT JOIN FOOD_SCH_NU NU		    \n");
		sql.append(" ON SCH.SCH_NO = NU.SCH_NO		  \n");
		sql.append(" LEFT JOIN FOOD_ZONE ZONE		    \n");
		sql.append(" ON SCH.ZONE_NO = ZONE.ZONE_NO	\n");
		sql.append(" WHERE SCH.SCH_ID = ?			      \n");
		sql.append(" AND NU.SHOW_FLAG = 'Y'			    \n");
		
		userList	=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{schId});
		
		//where절 세팅
		if(userList != null && userList.size() >0){
			
			foodVO.sch_no		=	userList.get(0).sch_no;
			foodVO.zone_no		=	userList.get(0).zone_no;
			foodVO.zone_nm		=	userList.get(0).zone_nm;
			foodVO.team_no		=	userList.get(0).team_no;
			foodVO.sch_grade	=	userList.get(0).sch_grade;
			
			if("R".equals(foodVO.sch_grade)){
				if(actType == 0)	{
					sqlWhere	+=	" AND (VAL.STS_FLAG = 'N' OR VAL.STS_FLAG = 'RR' OR VAL.STS_FLAG = 'RT' OR VAL.STS_FLAG = 'RS')	\n";
					titleTxt	=	"미조사 품목";
				}
				else if(actType == 1){
					sqlWhere	+=	" AND (VAL.STS_FLAG = 'Y' OR VAL.STS_FLAG = 'RC' OR VAL.STS_FLAG = 'SS' OR VAL.STS_FLAG = 'SR')	\n ";
					titleTxt	=	"조사완료 품목";
				}
			}else if("T".equals(foodVO.sch_grade)){
				if(actType == 0){
					sqlWhere	+=	" AND (VAL.STS_FLAG = 'SR' OR VAL.STS_FLAG = 'RC')		\n";
					titleTxt	=	"검토대상 품목";
					
					if("Y".equals(chkNoData)){
						sqlWhere	+=	" AND NULL_RSCH_FLAG = 'Y'		 	\n";
					}
				}
				else if(actType == 1){
					sqlWhere	+=	" AND (VAL.STS_FLAG = 'SS' OR VAL.STS_FLAG = 'Y')		\n";
					titleTxt	=	"마감완료 품목";
				}
				else if(actType == 2){
					sqlWhere	+=	" AND (VAL.STS_FLAG = 'N' OR VAL.STS_FLAG = 'RR' OR VAL.STS_FLAG = 'RT' OR VAL.STS_FLAG = 'RS')	\n";
					titleTxt	=	"미제출 품목";
				}
				
				
			}
		
			//조사개시 존재여부
			sql		=	new StringBuffer();
			sql.append(" SELECT 				\n");
			sql.append(" COUNT(RSCH_NO) 		\n");
			sql.append(" FROM FOOD_RSCH_TB 		\n");
			sql.append(" WHERE STS_FLAG = 'N' 	\n");
			
			cnt		=	jdbcTemplate.queryForInt(sql.toString());
			
			if(cnt == 1){
				sql		=	new StringBuffer();
				sql.append(" SELECT 						\n");
				sql.append(" RSCH_NO, 						\n");
				sql.append(" RSCH_NM, 						\n");
				sql.append(" RSCH_YEAR,						\n");
				sql.append(" RSCH_MONTH,					\n");
				sql.append(" TO_CHAR(END_DATE, 'YY/MM/DD')	\n");
				sql.append(" AS END_DATE					\n");
				sql.append(" FROM FOOD_RSCH_TB 				\n");
				sql.append(" WHERE STS_FLAG = 'N' 			\n");
				
				tbVO	=	jdbcTemplate.queryForObject(sql.toString(), new FoodList());
				
				//조사자일 때
				if("R".equals(foodVO.sch_grade)){
					
					//조사목록 카운트
					sql		=	new StringBuffer();
					
					//CNT2 : 미조사, 검증, 팀장반려, 관리자반려
					sql.append(" SELECT 														\n");
					sql.append("(SELECT COUNT(RSCH_VAL_NO) FROM FOOD_RSCH_VAL 	 				\n");
					sql.append(" WHERE RSCH_NO = ? AND SCH_NO = ?								\n");
					sql.append(" AND (STS_FLAG = 'N' OR STS_FLAG = 'RR' OR STS_FLAG = 'RT' 		\n");
					sql.append(" OR STS_FLAG = 'RS')) AS CNT2,									\n");
					
					//CNT3 : 완료, 검토, 제출, 마감
					sql.append("(SELECT COUNT(RSCH_VAL_NO) FROM FOOD_RSCH_VAL 	 				\n");
					sql.append(" WHERE RSCH_NO = ? AND SCH_NO = ?								\n");
					sql.append(" AND (STS_FLAG = 'Y' OR STS_FLAG = 'RC' OR STS_FLAG = 'SR'		\n");
					sql.append(" OR STS_FLAG = 'SS')) AS CNT3,									\n");	
					
					sql.append("(SELECT COUNT(RSCH_VAL_NO) FROM FOOD_RSCH_VAL 	 				\n");
					sql.append(" WHERE RSCH_NO = ? AND SCH_NO = ?								\n");
					sql.append(" ) AS CNT 														\n");	
					sql.append(" FROM DUAL					  									\n");
					
					try{
						cntVO	=	jdbcTemplate.queryForObject(sql.toString(), new FoodList(), new Object[]{
								tbVO.rsch_no, foodVO.sch_no, tbVO.rsch_no, foodVO.sch_no,
								tbVO.rsch_no, foodVO.sch_no
						});
					}catch(Exception e){
						cntVO	=	new FoodVO();
					}
					
					if(!"".equals(cntVO.cnt) && !"".equals(cntVO.cnt2) && !"".equals(cntVO.cnt3)){
						completeCnt 	= 	Integer.parseInt(cntVO.cnt3);		//완료 카운트
						nCompleteCnt	=	Integer.parseInt(cntVO.cnt2);		//미조사 카운트
						allCnt			=	Integer.parseInt(cntVO.cnt);		//모든 카운트
					}
					
					if(actType == 0)	pagingVO.setTotalCount(nCompleteCnt);
					if(actType == 1)	pagingVO.setTotalCount(completeCnt);
					
					pagingVO.setPageNo(pageNo);
					pagingVO.setPageSize(5);
					pagingVO.makePaging();
					
					//조사목록 및 완료목록
					sql		=	new StringBuffer();
					sql.append(" SELECT * FROM (												\n");
					sql.append(" SELECT ROWNUM AS RNUM, A.* FROM (								\n");
					sql.append(" SELECT 														\n");
					sql.append(" PRE.ITEM_NO,													\n");
					sql.append(" (SELECT CAT_NM	FROM FOOD_ST_CAT								\n");
					sql.append(" WHERE CAT_NO = ITEM.CAT_NO) AS CAT_NM,							\n");
					
					sql.append(" (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', NM_FOOD)			\n");
					sql.append(" ORDER BY NM_FOOD).EXTRACT('//text()').GETSTRINGVAL(),2)		\n");
					sql.append(" NM_FOOD														\n");
					sql.append(" FROM FOOD_ST_NM												\n");
					sql.append(" WHERE NM_NO IN (												\n");
					sql.append(" FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5))		\n");
					sql.append(" AS NM_FOOD,													\n");
					
					sql.append(" (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', DT_NM)				\n");
					sql.append(" ORDER BY DT_NM).EXTRACT('//text()').GETSTRINGVAL(), 2)			\n");
					sql.append(" DT_NM															\n");
					sql.append(" FROM FOOD_ST_DT_NM												\n");
					sql.append(" WHERE DT_NO IN(												\n");
					sql.append(" FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5,			\n");
					sql.append(" FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10))		\n");
					sql.append(" AS DT_NM, 														\n");
					
					sql.append(" (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', EX_NM)				\n");
					sql.append(" ORDER BY EX_NM).EXTRACT('//text()').GETSTRINGVAL(), 2)			\n");
					sql.append(" EX_NM															\n");
					sql.append(" FROM FOOD_ST_EXPL												\n");
					sql.append(" WHERE EX_NO IN(												\n");
					sql.append(" FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5,			\n");
					sql.append(" FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10, 		\n");
					sql.append(" FOOD_EP_11, FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15,	\n");
					sql.append(" FOOD_EP_16, FOOD_EP_17, FOOD_EP_18, FOOD_EP_19, FOOD_EP_20,	\n");
					sql.append(" FOOD_EP_21, FOOD_EP_22, FOOD_EP_23, FOOD_EP_24, FOOD_EP_25))	\n");
					sql.append(" AS EX_NM, 														\n");
					
					sql.append(" (SELECT UNIT_NM FROM FOOD_ST_UNIT 								\n");
					sql.append(" WHERE UNIT_NO = ITEM.FOOD_UNIT) AS UNIT_NM, 					\n");
					sql.append(" PRE.REG_DATE,													\n");
					sql.append(" PRE.MOD_DATE,													\n");
					sql.append(" PRE.SHOW_FLAG,													\n");
					sql.append(" (SELECT REG_IP FROM FOOD_UP_FILE							 	\n");
					sql.append(" WHERE FILE_NO = PRE.FILE_NO) REG_IP,							\n");
					sql.append(" (SELECT REG_ID FROM FOOD_UP_FILE								\n");
					sql.append(" WHERE FILE_NO = PRE.FILE_NO) REG_ID,							\n");
					sql.append(" PRE.ITEM_GRP_NO,												\n");
					sql.append(" PRE.ITEM_GRP_ORDER,											\n");
					sql.append(" PRE.ITEM_COMP_NO, 												\n");
					sql.append(" PRE.ITEM_COMP_VAL,												\n");
					sql.append(" PRE.LOW_RATIO, 												\n");
					sql.append(" PRE.AVR_RATIO, 												\n");
					sql.append(" PRE.LB_RATIO,	 												\n");
					sql.append(" TB.RSCH_NM,	 												\n");
					sql.append(" TB.RSCH_YEAR,	 												\n");
					sql.append(" TB.RSCH_MONTH,	 												\n");
					sql.append(" TO_CHAR(TB.END_DATE,'YY/MM/DD') AS END_DATE,					\n");
					sql.append(" ITEM.FOOD_CAT_INDEX,											\n");
					sql.append(" ITEM.FOOD_CODE,												\n");
					sql.append(" VAL.STS_FLAG,													\n");
					sql.append(" VAL.RSCH_VAL_NO,												\n");
					sql.append(" VAL.NON_SEASON,												\n");
					sql.append(" VAL.NON_DISTRI,												\n");
					sql.append(" VAL.RSCH_REASON,												\n");
					sql.append(" VAL.T_RJ_REASON,												\n");
					sql.append(" VAL.RJ_REASON,													\n");
					sql.append(" (SELECT NU_NM FROM FOOD_SCH_NU WHERE NU_NO = VAL.NU_NO)		\n");
					sql.append(" AS NU_NM,														\n");
					sql.append(" VAL.NU_NO,														\n");
					sql.append(" VAL.RSCH_VAL1,													\n");
					sql.append(" VAL.RSCH_VAL2,													\n");
					sql.append(" VAL.RSCH_VAL3,													\n");
					sql.append(" VAL.RSCH_VAL4,													\n");
					sql.append(" VAL.RSCH_VAL5,													\n");
					sql.append(" VAL.RSCH_LOC1,													\n");
					sql.append(" VAL.RSCH_LOC2,													\n");
					sql.append(" VAL.RSCH_LOC3,													\n");
					sql.append(" VAL.RSCH_LOC4,													\n");
					sql.append(" VAL.RSCH_LOC5,													\n");
					sql.append(" VAL.RSCH_COM1,													\n");
					sql.append(" VAL.RSCH_COM2,													\n");
					sql.append(" VAL.RSCH_COM3,													\n");
					sql.append(" VAL.RSCH_COM4,													\n");
					sql.append(" VAL.RSCH_COM5													\n");
					sql.append(" FROM FOOD_ITEM_PRE PRE 										\n");
					
					sql.append(" LEFT JOIN FOOD_ST_ITEM ITEM ON PRE.S_ITEM_NO = ITEM.ITEM_NO	\n");
					sql.append(" LEFT JOIN FOOD_RSCH_VAL VAL ON VAL.ITEM_NO = ITEM.ITEM_NO		\n");
					sql.append(" LEFT JOIN FOOD_RSCH_TB TB ON VAL.RSCH_NO = TB.RSCH_NO			\n");
					sql.append(" LEFT JOIN FOOD_SCH_TB SCH ON VAL.SCH_NO = SCH.SCH_NO			\n");
					sql.append(" LEFT JOIN FOOD_SCH_NU NU ON VAL.NU_NO = NU.NU_NO				\n");				
					sql.append(" WHERE TB.SHOW_FLAG = 'Y'										\n");
					sql.append(" AND SCH.SCH_NO = ? 											\n");
					sql.append(sqlWhere);
					sql.append(" ORDER BY PRE.ITEM_NO											\n");
					sql.append(" )A WHERE ROWNUM <= ?											\n");
					sql.append(" ) WHERE RNUM > ?												\n");
					
					rschList	=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{
							foodVO.sch_no, pagingVO.getEndRowNo(), pagingVO.getStartRowNo()
					});
				}//조사자일 때 end
				
				//조사팀장일 때
				else if("T".equals(foodVO.sch_grade)){
					//조사목록 카운트
					sql		=	new StringBuffer();
					
					//CNT2 : 검토, 제출
					sql.append(" SELECT 														\n");
					sql.append("(SELECT COUNT(RSCH_VAL_NO) FROM FOOD_RSCH_VAL 	 				\n");
					sql.append(" WHERE RSCH_NO = ? AND TEAM_NO = ?								\n");
					sql.append(" AND (STS_FLAG = 'SR' OR STS_FLAG = 'RC')) AS CNT2,				\n");
					
					//CNT3 : 마감, 완료
					sql.append("(SELECT COUNT(RSCH_VAL_NO) FROM FOOD_RSCH_VAL 	 				\n");
					sql.append(" WHERE RSCH_NO = ? AND TEAM_NO = ?								\n");
					sql.append(" AND (STS_FLAG = 'Y' OR STS_FLAG = 'SS')) AS CNT3,				\n");
					
					//CNT4 : 조사팀장 미제출 
					sql.append("(SELECT COUNT(RSCH_VAL_NO) FROM FOOD_RSCH_VAL 	 				\n");
					sql.append(" WHERE RSCH_NO = ? AND TEAM_NO = ?								\n");
					sql.append(" AND (STS_FLAG = 'N' OR STS_FLAG = 'RR' OR STS_FLAG = 'RT' 		\n");
					sql.append(" OR STS_FLAG = 'RS')) AS CNT4,									\n");
					
					//CNT : all
					sql.append("(SELECT COUNT(RSCH_VAL_NO) FROM FOOD_RSCH_VAL 	 				\n");
					sql.append(" WHERE RSCH_NO = ? AND TEAM_NO = ?								\n");
					sql.append(" ) AS CNT 														\n");	
					sql.append(" FROM DUAL					  									\n");
					
					try{
						cntVO	=	jdbcTemplate.queryForObject(sql.toString(), new FoodList(), new Object[]{
								tbVO.rsch_no, foodVO.team_no, tbVO.rsch_no, foodVO.team_no,
								tbVO.rsch_no, foodVO.team_no, tbVO.rsch_no, foodVO.team_no
						});
					}catch(Exception e){
						cntVO	=	new FoodVO();
					}
					
					if(!"".equals(cntVO.cnt) && !"".equals(cntVO.cnt2) && !"".equals(cntVO.cnt3) && !"".equals(cntVO.cnt4)){
						completeCnt 	= 	Integer.parseInt(cntVO.cnt3);	//마감 카운트
						nCompleteCnt	=	Integer.parseInt(cntVO.cnt2);	//검토중 및 제출 카운트
						allCnt			=	Integer.parseInt(cntVO.cnt);	//모든 카운트
						leaderNCnt		=	Integer.parseInt(cntVO.cnt4);	//조사팀장 미제출 카운트
					}
					
					if(actType == 0)	pagingVO.setTotalCount(nCompleteCnt);
					if(actType == 1)	pagingVO.setTotalCount(completeCnt);
					if(actType == 2)	pagingVO.setTotalCount(leaderNCnt);
					
					pagingVO.setPageNo(pageNo);
					pagingVO.setPageSize(5);
					pagingVO.makePaging();
					
					//조사팀장 검토대상, 마감완료, 미제출 목록
					sql		=	new StringBuffer();
					sql.append(" SELECT * FROM (												\n");
					sql.append(" SELECT ROWNUM AS RNUM, A.* FROM (								\n");
					sql.append(" SELECT 														\n");
					sql.append(" PRE.ITEM_NO,													\n");
					sql.append(" (SELECT CAT_NM	FROM FOOD_ST_CAT								\n");
					sql.append(" WHERE CAT_NO = ITEM.CAT_NO) AS CAT_NM,							\n");
					
					sql.append(" (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', NM_FOOD)			\n");
					sql.append(" ORDER BY NM_FOOD).EXTRACT('//text()').GETSTRINGVAL(),2)		\n");
					sql.append(" NM_FOOD														\n");
					sql.append(" FROM FOOD_ST_NM												\n");
					sql.append(" WHERE NM_NO IN (												\n");
					sql.append(" FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5))		\n");
					sql.append(" AS NM_FOOD,													\n");
					
					sql.append(" (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', DT_NM)				\n");
					sql.append(" ORDER BY DT_NM).EXTRACT('//text()').GETSTRINGVAL(), 2)			\n");
					sql.append(" DT_NM															\n");
					sql.append(" FROM FOOD_ST_DT_NM												\n");
					sql.append(" WHERE DT_NO IN(												\n");
					sql.append(" FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5,			\n");
					sql.append(" FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10))		\n");
					sql.append(" AS DT_NM, 														\n");
					
					sql.append(" (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', EX_NM)				\n");
					sql.append(" ORDER BY EX_NM).EXTRACT('//text()').GETSTRINGVAL(), 2)			\n");
					sql.append(" EX_NM															\n");
					sql.append(" FROM FOOD_ST_EXPL												\n");
					sql.append(" WHERE EX_NO IN(												\n");
					sql.append(" FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5,			\n");
					sql.append(" FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10, 		\n");
					sql.append(" FOOD_EP_11, FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15,	\n");
					sql.append(" FOOD_EP_16, FOOD_EP_17, FOOD_EP_18, FOOD_EP_19, FOOD_EP_20,	\n");
					sql.append(" FOOD_EP_21, FOOD_EP_22, FOOD_EP_23, FOOD_EP_24, FOOD_EP_25))	\n");
					sql.append(" AS EX_NM, 														\n");
							
					sql.append(" (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', NU_NO)				\n");
					sql.append(" ).EXTRACT('//text()').GETSTRINGVAL(),2) T_NU_NO				\n");
					sql.append(" FROM (SELECT NU_NO, SCH_NO AS T_SCH_NO							\n");
					sql.append(" FROM FOOD_SCH_NU												\n");
					sql.append(" WHERE SHOW_FLAG = 'Y')											\n");
					sql.append(" WHERE T_SCH_NO = VAL.SCH_NO)									\n");
					sql.append(" AS T_NU_NO,													\n");
					
					sql.append(" (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', NU_NM)				\n");
					sql.append(" ).EXTRACT('//text()').GETSTRINGVAL(),2) T_NU_NM				\n");
					sql.append(" FROM (SELECT NU_NM, SCH_NO AS T_SCH_NO							\n");
					sql.append(" FROM FOOD_SCH_NU												\n");
					sql.append(" WHERE SHOW_FLAG = 'Y')											\n");
					sql.append(" WHERE T_SCH_NO = VAL.SCH_NO)									\n");
					sql.append(" AS T_NU_NM,													\n");
					
					sql.append(" (SELECT UNIT_NM FROM FOOD_ST_UNIT 								\n");
					sql.append(" WHERE UNIT_NO = ITEM.FOOD_UNIT) AS UNIT_NM, 					\n");
					sql.append(" PRE.REG_DATE,													\n");
					sql.append(" PRE.MOD_DATE,													\n");
					sql.append(" PRE.SHOW_FLAG,													\n");
					sql.append(" (SELECT REG_IP FROM FOOD_UP_FILE							 	\n");
					sql.append(" WHERE FILE_NO = PRE.FILE_NO) REG_IP,							\n");
					sql.append(" (SELECT REG_ID FROM FOOD_UP_FILE								\n");
					sql.append(" WHERE FILE_NO = PRE.FILE_NO) REG_ID,							\n");
					sql.append(" PRE.ITEM_GRP_NO,												\n");
					sql.append(" PRE.ITEM_GRP_ORDER,											\n");
					sql.append(" PRE.ITEM_COMP_NO, 												\n");
					sql.append(" PRE.ITEM_COMP_VAL,												\n");
					sql.append(" PRE.LOW_RATIO, 												\n");
					sql.append(" PRE.AVR_RATIO, 												\n");
					sql.append(" PRE.LB_RATIO,	 												\n");
					sql.append(" TB.RSCH_NM,	 												\n");
					sql.append(" TB.RSCH_YEAR,	 												\n");
					sql.append(" TB.RSCH_MONTH,	 												\n");
					sql.append(" TO_CHAR(TB.END_DATE,'YY/MM/DD') AS END_DATE,					\n");
					sql.append(" ITEM.FOOD_CAT_INDEX,											\n");
					sql.append(" ITEM.FOOD_CODE,												\n");
					sql.append(" VAL.STS_FLAG,													\n");
					sql.append(" VAL.RSCH_VAL_NO,												\n");
					sql.append(" VAL.RSCH_REASON,												\n");
					sql.append(" VAL.T_RJ_REASON,												\n");
					sql.append(" VAL.RJ_REASON,													\n");
					sql.append(" VAL.NON_SEASON,												\n");
					sql.append(" VAL.NON_DISTRI,												\n");
					sql.append(" (SELECT NU_NM FROM FOOD_SCH_NU WHERE NU_NO = VAL.NU_NO)		\n");
					sql.append(" AS NU_NM,														\n");
					sql.append(" VAL.NU_NO,														\n");
					sql.append(" VAL.RSCH_VAL1,													\n");
					sql.append(" VAL.RSCH_VAL2,													\n");
					sql.append(" VAL.RSCH_VAL3,													\n");
					sql.append(" VAL.RSCH_VAL4,													\n");
					sql.append(" VAL.RSCH_VAL5,													\n");
					sql.append(" VAL.RSCH_LOC1,													\n");
					sql.append(" VAL.RSCH_LOC2,													\n");
					sql.append(" VAL.RSCH_LOC3,													\n");
					sql.append(" VAL.RSCH_LOC4,													\n");
					sql.append(" VAL.RSCH_LOC5,													\n");
					sql.append(" VAL.RSCH_COM1,													\n");
					sql.append(" VAL.RSCH_COM2,													\n");
					sql.append(" VAL.RSCH_COM3,													\n");
					sql.append(" VAL.RSCH_COM4,													\n");
					sql.append(" VAL.RSCH_COM5													\n");
					sql.append(" FROM FOOD_ITEM_PRE PRE 										\n");
					
					sql.append(" LEFT JOIN FOOD_ST_ITEM ITEM ON PRE.S_ITEM_NO = ITEM.ITEM_NO	\n");
					sql.append(" LEFT JOIN FOOD_RSCH_VAL VAL ON VAL.ITEM_NO = ITEM.ITEM_NO		\n");
					sql.append(" LEFT JOIN FOOD_RSCH_TB TB ON VAL.RSCH_NO = TB.RSCH_NO			\n");
					sql.append(" LEFT JOIN FOOD_SCH_TB SCH ON VAL.SCH_NO = SCH.SCH_NO			\n");
					sql.append(" LEFT JOIN FOOD_SCH_NU NU ON VAL.NU_NO = NU.NU_NO				\n");				
					sql.append(" WHERE TB.SHOW_FLAG = 'Y'										\n");
					sql.append(" AND SCH.TEAM_NO = ? 											\n");
					sql.append(sqlWhere);
					sql.append(" ORDER BY PRE.ITEM_NO											\n");
					sql.append(" )A WHERE ROWNUM <= ?											\n");
					sql.append(" ) WHERE RNUM > ?												\n");
					
					rschList	=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{
							foodVO.team_no, pagingVO.getEndRowNo(), pagingVO.getStartRowNo()
					});
					
				
				}//조사팀장일 때 end
			}else if(cnt == 0){
				//열려있는 조사가 없음.
				alertBack(out, "조사기간이 아닙니다.");
			}
		}
		//영양사가 없을 때 (보통 학교가 아닌 기관인 경우)
		else{
			alertBack(out, "조사자 및 조사팀장이 아닙니다.");
		}
		
	}catch(Exception e){
		alertBack(out, e.toString());
	}finally{
		
	}
%>

<script>

// type = 0 : 제출(마감), 1 : 검증(검토), 2 : 재검증(마감재검증), 3 : 사유입력(반려)
function submissionRsch(number, type){
	
	if(type == 3){
		<%if("T".equals(foodVO.sch_grade) && actType != 2){%>	//조사팀장이고 팀장 미조사 품목이 아닐 경우
			number	=	$("#rschValNoR").val();
		<%}else{%>
			number	=	$("#rschValNo").val();
		<%}%>
	}
	
	var rschValArr	=	new Array();	//조사가
	var rschLocArr	=	new Array();	//조사처
	var rschComArr	=	new Array();	//조사업체
	var returnType	=	false;
	
	var nuNo		=	$("#rschSel_" + number).val();		//조사자
	var rschYear	=	"<%=tbVO.rsch_year%>";				//년
	var rschMonth	=	"<%=tbVO.rsch_month%>";				//월
	var schNo		=	"<%=foodVO.sch_no%>";		//학교
	var zoneNo		=	"<%=foodVO.zone_no%>";		//권역
	var teamNo		=	"<%=foodVO.team_no%>";		//팀
	var userType	=	"";									//이용자타입 (조사자, 조사팀장)
	
	<%if(actType == 2){%>		//조사팀장 미제출목록일 때 userType을 조사자로 적용
		userType	=	"R";		
	<%}else{%>	
		userType	=	"<%=foodVO.sch_grade%>";
	<%}%>
	
	var reason		=	$("#reason").val();					//사유
	var returnWrite =	$("#returnWrite").val();			//반려사유
	var nonSeason	=	"N";								//비계절
	var nonDist		=	"N";								//비유통
	var rCondition	=	$("#reasonInput_p").text();			//사유입력 발생조건 
	
	//비유통, 비계절 제품 체크여부에 따라 값 전달
	if($("input:checkbox[id='offSeason_" + number + "']").is(":checked") == true){
		nonSeason	=	$("#offSeason_" + number).val();
	}
	if($("input:checkbox[id='offDist_" + number + "']").is(":checked") == true){
		nonDist	=	$("#offDist_" + number).val();
	}
	
	//제출, 검증, 재검증, 사유입력 url
	var submitUrl	=	"";
	
	if(type == 0)	submitUrl	=	"<%=moveUrl%>&actType=0";	
	else if(type == 1)	submitUrl	=	"<%=moveUrl%>&actType=1";	
	else if(type == 2)	submitUrl	=	"<%=moveUrl%>&actType=2";
	else if(type == 3)	submitUrl	=	"<%=moveUrl%>&actType=3";
	
	if($("#rschSel_" + number).val() == ""){
		alert("조사자를 선택해주세요.");
		$("#rschSel_" + number).focus();
		return;
	}
	
	for(var i=0; i<5; i++){
		rschValArr[i]	=	$("#rschVal" + (i+1) + "_" + number).val();
		rschLocArr[i]	=	$("#rschLoc" + (i+1) + "_" + number).val();
		rschComArr[i]	=	$("#rschCom" + (i+1) + "_" + number).val();
	}
	if(inputCheck(number) == false) return false;
	
	if(type == 0){
		if(submissionRsch(number, 2) == false) return false;
	}	
		
	jQuery.ajaxSettings.traditional = true;
	$.ajax({
		type : "POST",
		url : submitUrl,
		data : { 
			"number" : number, 			"rschVal" : rschValArr, 
			"rschLoc" : rschLocArr, 	"rschCom" : rschComArr,
			"rschYear" : rschYear, 		"rschMonth" : rschMonth,
			"schNo" : schNo, 			"rschSel" : nuNo,
			"offSeason" : nonSeason,	"offDist" : nonDist,
			"reason" : reason,			"zoneNo" : zoneNo,
			"teamNo" : teamNo,			"userType" : userType,
			"rCondition" : rCondition, 	"returnWrite" : returnWrite
		},
		dataType : "json",
		async : false,
		success : function(data){
			if(data.resultMsg != null && data.resultMsg != ""){
				alert(data.resultMsg);
			}else{
				//재검증 시 returnType이 true일 경우 재검증 정상, false일 경우 이전 검증때의 값과 불일치
				if(type == 2){
					returnType	=	true;
				}
			}
			//제출시 새로고침
			if(type == 0 || type == 3){
				location.reload(); 
			}
			//검증시 
			else if(type == 1){
				//chkCode가 빈값이 아닐 경우 사유입력창을 띄운다.
				if(data.chkCode != null && data.chkCode != ""){
					$("#reasonInput_p").text(data.resultMsg);
					$("#rschValNo").val(number);
					$("#reasonClick").trigger("click");
				}
			}
		},
		error:function(request,status,error){
	        $("#errorMsg").html("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	    }
	});
	
	return returnType;
}

//입력 유효성 검사
function inputCheck(number){
	var alertMsg	=	"";		//출력할 메시지
	var checkCnt	=	0;		//입력한 값의 개수
	var checkSetCnt	=	0;		//(조사가, 조사처, 브랜드) 1set가 온전히 입력된 수
	
	var rschVal		=	"";		//조사가
	var rschLoc		=	"";		//조사처
	var rschCom		=	"";		//브랜드
		
	for(var i=0; i<5; i++){		
		rschVal		=	$("#rschVal" + (i+1) + "_" + number).val();	
		rschLoc		=	$("#rschLoc" + (i+1) + "_" + number).val();	
		rschCom		=	$("#rschCom" + (i+1) + "_" + number).val();	
		
		//조사가, 조사처, 브랜드 1set가 온전히 입력되었을 때 && 조사가 숫자체크
		if(rschVal != "" && rschLoc != "" && rschCom != ""){
			if(numberChk(rschVal) == false)		return false;
			checkSetCnt	+=	1;
		}
		
		//조사가, 조사처, 브랜드 중 하나라도 입력되었을때 나머지 두값도 무조건 입력하게 하는 기능 && 조사가 숫자체크
		else if(rschVal != "" || rschLoc != "" || rschCom != ""){
			
			if(rschVal == ""){
				alertMsg	+=	"조사가" + (i+1) + ", ";
				checkCnt	+=	1;
			}
			if(rschLoc == ""){
				if(numberChk(rschVal) == false)		return false;
				alertMsg	+=	"조사처" + (i+1) + ", ";
				checkCnt	+=	1;
			}
			if(rschCom == ""){
				if(numberChk(rschVal) == false)		return false;
				alertMsg	+=	"브랜드" + (i+1) + ", ";
				checkCnt	+=	1;
			}
		}		
	}
	
	if($("input:checkbox[id='offDist_" + number + "']").is(":checked") == true || 
			$("input:checkbox[id='offSeason_" + number + "']").is(":checked") == true){
		if(checkSetCnt > 0){
			alert("비계절 또는 비유통을 체크하실 경우 조사가를 입력하실 수 없습니다.");
			$("#rschVal1_" + number).focus();
			return false;
		}
	}else{
		if(checkCnt > 0){
			alertMsg	=	alertMsg.substr(0, alertMsg.length-2);
			alert(alertMsg + "이(가) 입력되지 않았습니다.");
			return false;
		}
		
		if(checkSetCnt != 1 && checkSetCnt != 3 && checkSetCnt != 5){
			alert("조사 데이터는 홀수개 입력되어야 합니다.");
			return false;
		}
	}
}

//숫자체크
function numberChk(checkData){
	if(isNaN(checkData) == true){
		alert("조사가에는 숫자만 입력할 수 있습니다.");
		return false;
	}else{
		return true;
	}
}

function offChk(number, type){
	if(type == '1')			$("input:checkbox[id='offDist_" + number + "']").prop("checked", false);
	else if(type == '2') 	$("input:checkbox[id='offSeason_" + number + "']").prop("checked", false);
}

//사유입력 modal창 열기
function inputPopup(){
	$("#reasonInput").popup({
		focusdelay: 400,
 		 outline: true,
 		 vertical: 'middle'
	});
}

//사유보기 modal창 열기
function viewPopup(text){
	var reasonTxt	=	text.split("|");
	
	if(reasonTxt.length > 1){
		$("#reasonView_p").text(reasonTxt[0]);
		$("#reasonView_txt").val(reasonTxt[1]);
	}else{
		$("#reasonView_p").text(reasonTxt[0]);
		$("#reasonView_txt").val(reasonTxt[0]);
	}
	
	$("#reasonView").popup({
		focusdelay: 400,
 		 outline: true,
 		 vertical: 'middle'
	});
}

//반려 modal창 열기
function returnPopup(number){
	$("#rschValNoR").val(number);
	$("#returnInput").popup({
		focusdelay: 400,
		 outline: true,
		 vertical: 'middle'
	});
}

//반려 사유보기 modal창 열기
function returnViewPopup(text){
	$("#returnView_p").text(text);
	$("#returnView").popup({
		focusdelay: 400,
 		 outline: true,
 		 vertical: 'middle'
	});
}

//모달창 닫기
function modalClose(id){
	$("#" + id).popup("hide");
	if($("#reason").length > 0)			$("#reason").val("");
	if($("#reasonSel").length > 0)		$("#reasonSel").val("");
	if($("#reasonView_p").length > 0)	$("#reasonView_p").text("");
	if($("#reasonView_txt").length > 0)	$("#reasonView_txt").val("");
	if($("#reSelDirect").length > 0)	$("#reSelDirect").val("");
	if($("#returnWrite").length > 0)	$("#returnWrite").val("");
	if($("#returnView_p").length > 0)	$("#returnView_p").text("");
}

//사유선택시 상세입력창 비활성화
function reasonChk(value){
	if(value != ""){
		$("#reason").val(value);
		$("#reason").prop("readonly", "readonly");
	}else{
		$("#reason").val("");
		$("#reason").prop("readonly", "");
	}
}

//반려 사유 선택시 상세입력창 비활성화
function returnChk(value){
	if(value != ""){
		$("#returnWrite").val(value);
		$("#returnWrite").prop("readonly", "readonly");
	}else{
		$("#returnWrite").val("");
		$("#returnWrite").prop("readonly", "");
	}
}

//이력 보기
function careerRsch(number){
	var moveUrl	=	"<%=moveUrlLog%>&item_no=" + number;
	
	newWin(moveUrl, '이력확인', 1500, 1000);
}

//새창 열기
function newWin(url, title, w, h){
    var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
    var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

    var left = ((width / 2) - (w / 2)) + dualScreenLeft;
    var top = ((height / 2) - (h / 2)) + dualScreenTop;
    var newWindow = window.open(url, title, 'scrollbars=yes, resizable=yes, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
}

//미입력 마감완료 보기
function noInputComp(){
	var actType	=	"<%=actType%>";
	var moveUrl	=	"index.gne?menuCd=<%=request.getParameter("menuCd")%>";
	if($("input:checkbox[id='chkNoData']").is(":checked") == true){
		location.href= moveUrl + "&actType=" + actType + "&chkNoData=Y";
	}else{
		/* location.href="/index.gne?menuCd=DOM_000000127003000000&actType=" + actType; */
		location.href= moveUrl + "&actType=" + actType
	}
}
</script>
<!-- 배너링크 include -->
{CNT:2305}			<!-- 운영서버:2305, 테스트서버:669 -->
<!-- // 배너 include -->

<div class="rsrch_info">
  <ul class="clearfix mag0">
    <li><strong>권역</strong>: <%=foodVO.zone_nm%></li>
    <li><strong>조사명</strong>: <%=tbVO.rsch_nm%></li>
    <li class="end_date"><strong>조사마감날짜</strong>: <%=tbVO.end_date%></li>
  </ul>
</div>


<%
//조사자일 때
if("R".equals(foodVO.sch_grade)){
%>
<!-- 탭메뉴 -->
<div class="tab_wrap clearfix">
  <ul class="tabs">
    <li<%if(actType==0){ out.print(" class=\"active\""); }%>><a href="/index.gne?menuCd=<%=request.getParameter("menuCd")%>&actType=0">미조사 품목</a></li>
    <li<%if(actType==1){ out.print(" class=\"active\""); }%>><a href="/index.gne?menuCd=<%=request.getParameter("menuCd")%>&actType=1">조사완료 품목</a></li>
  </ul>
</div>
<!-- //탭메뉴 -->

<div class="tab_container">
  <section class="tab_content" style="display:block;">
    <h3 class="stit"><%=titleTxt%> <span class="dec fsize_80">(완료 <span class="fb blue"><%=completeCnt%></span>건 / 전체 <%=allCnt%>건)</span></h3>
    <%if(actType == 0){%>
      <table class="tbl_rsrch tr-even">
        <caption>미조사 품목 입력 : 구분, 식품코드, 식품명, 상세식품명, 식품설명, 단위, 비계절, 비유통, 비교그룹, 조사자, 조사가 정보, 검증/제출</caption>
        <colgroup>
          <col style="width:50px"/>
          <col style="width:6%" />
          <col style="width:6%"/>
          <col style="width:8%"/>
          <col style="width:14%" />
          <col style="width:30px"/>
          <col style="width:30px"/>
          <col style="width:30px"/>
          <col style="width:30px"/>
          <col style="width:8%"/>
          <col />
          <col style="width:64px;" />
        </colgroup>
        <thead>
          <tr>
            <th scope="row">품목<br />구분</th>
            <th scope="row">식품코드</th>
            <th scope="row">식품명</th>
            <th scope="row">상세식품명</th>
            <th scope="row">식품설명</th>
            <th scope="row">단위</th>
            <th scope="row">비계절</th>
            <th scope="row">비유통</th>
            <th scope="row">비교그룹</th>
            <th scope="row">조사자</th>
            <th scope="row">조사가 정보</th>
            <th scope="row">검증/제출</th>
          </tr>
        </thead>
        <tbody>
        <%
        if(rschList != null && rschList.size() > 0){
        	for(int i=0; i<rschList.size(); i++){	
        	FoodVO vo			=	rschList.get(i);
        	String classTxt		=	"";
        	
       		//관리자반려 또는 팀장반려일 경우 tr태그에 class를 추가한다.
       		if("RR".equals(vo.sts_flag) || "RT".equals(vo.sts_flag)){
       			classTxt	=	" class=\"rch_return\"";
       		}
        	%>
          <tr<%=classTxt%>>
            <td>
            <span class="wid_cate"><%=vo.cat_nm%>-<%=vo.food_cat_index%></span></td>
            <td><%=vo.food_code%></td>
            <td><a href="#" class="dp_block"><span class="blue fb"><%=vo.nm_food%></span></a></td>
            <td><span class="wid_ndetail"><%=vo.dt_nm%></span></td>
            <td><span class="wid_expl"><%=vo.ex_nm%></span></td>
            <td><%=vo.unit_nm%></td>
            <td>
            	<label for="offSeason_<%=vo.rsch_val_no%>" class="blind">비계절 체크</label>
            	<input type="checkbox" id="offSeason_<%=vo.rsch_val_no%>" name="offSeason" class="chbig" title="비계절 체크" value="Y" onclick="offChk('<%=vo.rsch_val_no%>', '1');"
            	<%if("Y".equals(vo.non_season)){%>checked<%}%>/></td>
            <td>
            	<label for="offDist_<%=vo.rsch_val_no%>" class="blind">비유통 체크</label>
            	<input type="checkbox" id="offDist_<%=vo.rsch_val_no%>" name="offDist" class="chbig" title="비유통 체크" value="Y" onclick="offChk('<%=vo.rsch_val_no%>', '2');"
            	<%if("Y".equals(vo.non_distri)){%>checked<%}%>/></td>
            <td>
            	<%=vo.item_comp_no %>
            </td>
            <td>
              <label for="rschSel_<%=vo.rsch_val_no%>" class="blind">조사자 선택</label>
              <select id="rschSel_<%=vo.rsch_val_no%>" name="rschSel">
                <option value="">선택</option>
                <%
                if(userList != null && userList.size() > 0){
                	for(int j=0; j<userList.size(); j++){
                		out.print(printOption(userList.get(j).nu_no, userList.get(j).nu_nm, vo.nu_no));
                	}
                }
                %>
              </select>
            </td>
            <td class="padR5 padL5">
              <table class="table_skin02 mag0 th-pd1 td-pd1 rsch_price">
                <caption>조사가1~5에 대한 조사처 및 브랜드 정보 입력</caption>
                <colgroup>
                  <col style="width:15%" />
                  <col style="width:17%" span="5" />
                </colgroup>
                <thead>
                  <tr>
                    <th scope="col">구분</th>
                    <th scope="col">조사가1</th>
                    <th scope="col">조사가2</th>
                    <th scope="col">조사가3</th>
                    <th scope="col">조사가4</th>
                    <th scope="col">조사가5</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <th scope="row" class="bg_green">조사가</th>
                    <td><label><input type="text" name="rschVal1" id="rschVal1_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val1%>" title="조사가1 가격" /></label></td>
                    <td><label><input type="text" name="rschVal2" id="rschVal2_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val2%>" title="조사가2 가격" /></label></td>
                    <td><label><input type="text" name="rschVal3" id="rschVal3_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val3%>" title="조사가3 가격" /></label></td>
                    <td><label><input type="text" name="rschVal4" id="rschVal4_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val4%>" title="조사가4 가격" /></label></td>
                    <td><label><input type="text" name="rschVal5" id="rschVal5_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val5%>" title="조사가5 가격" /></label></td>
                  </tr>
                  <tr>
                    <th scope="row" class="bg_green">조사처</th>
                    <td><label><input type="text" name="rschLoc1" id="rschLoc1_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc1%>" title="조사가1 조사처" /></label></td>
                    <td><label><input type="text" name="rschLoc2" id="rschLoc2_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc2%>" title="조사가2 조사처" /></label></td>
                    <td><label><input type="text" name="rschLoc3" id="rschLoc3_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc3%>" title="조사가3 조사처" /></label></td>
                    <td><label><input type="text" name="rschLoc4" id="rschLoc4_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc4%>" title="조사가4 조사처" /></label></td>
                    <td><label><input type="text" name="rschLoc5" id="rschLoc5_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc5%>" title="조사가5 조사처" /></label></td>
                  </tr>
                  <tr>
                    <th scope="row" class="bg_green">브랜드</th>
                    <td><label><input type="text" name="rschCom1" id="rschCom1_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com1%>" title="조사가1 브랜드" /></label></td>
                    <td><label><input type="text" name="rschCom2" id="rschCom2_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com2%>" title="조사가2 브랜드" /></label></td>
                    <td><label><input type="text" name="rschCom3" id="rschCom3_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com3%>" title="조사가3 브랜드" /></label></td>
                    <td><label><input type="text" name="rschCom4" id="rschCom4_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com4%>" title="조사가4 브랜드" /></label></td>
                    <td><label><input type="text" name="rschCom5" id="rschCom5_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com5%>" title="조사가5 브랜드" /></label></td>
                  </tr>
      		
                </tbody>
              </table>
            </td>
            <td class="btn_mingroup">
            <!-- 반려 사유 링크 : 팀장에 의해 반려되었을 경우 -->
            <%if("RT".equals(vo.sts_flag)){%>
              <a href="javascript:;" class="returnView_open openLayer" id="resViewBtn" title="반려된 사유보기" onclick="returnViewPopup('<%=vo.t_rj_reason%>');"><span class="red u fb dp_block magB5">*반려됨<br />(사유보기)</span></a>
            <%}else if("RR".equals(vo.sts_flag)){%>
              <a href="javascript:;" class="returnView_open openLayer" id="resViewBtn" title="반려된 사유보기" onclick="returnViewPopup('<%=vo.rj_reason%>');"><span class="red u fb dp_block magB5">*반려됨<br />(사유보기)</span></a>
            <%} %>
            <!--//반려 사유 끝 -->
              <button type="button" class="btn darkMblue initialism slide_open openLayer" onclick="submissionRsch('<%=vo.rsch_val_no%>', '1');">검증</button>
              <button type="button" class="btn green" onclick="submissionRsch('<%=vo.rsch_val_no%>', '0');">제출</button>
              <button type="button" class="btn white" onclick="careerRsch('<%=vo.item_no%>')">이력</button>
            </td>
          </tr>
          <%}
          }else{
            	out.print("<tr>");
              	out.print("<td colspan=\"12\"> 조사 대상이 없습니다. </td>");
              	out.print("</tr>");
          }%>
        </tbody>
      </table>

   <!-- 조사완료 품목 : 조사자 -->
   <%}else if(actType == 1){%>
     <table class="tbl_rsrch tr-even">
         <caption>조사완료 품목 : 구분, 식품코드, 식품명, 상세식품명, 식품설명, 단위, 비계절, 비유통, 비교그룹, 조사자, 조사가 정보, 검증/제출</caption>
         <colgroup>
           <col style="width:50px"/>
           <col style="width:6%" />
           <col style="width:6%"/>
           <col style="width:8%"/>
           <col style="width:14%" />
           <col style="width:30px"/>
           <col style="width:30px"/>
           <col style="width:30px"/>
           <col style="width:30px"/>
           <col style="width:8%"/>
           <col />
           <col style="width:64px;" />
         </colgroup>
         <thead>
           <tr>
             <th scope="row">품목<br />구분</th>
             <th scope="row">식품코드</th>
             <th scope="row">식품명</th>
             <th scope="row">상세식품명</th>
             <th scope="row">식품설명</th>
             <th scope="row">단위</th>
             <th scope="row">비계절</th>
             <th scope="row">비유통</th>
             <th scope="row">비교그룹</th>
             <th scope="row">조사자</th>
             <th scope="row">조사가 정보</th>
             <th scope="row">상태</th>
           </tr>
         </thead>
         <tbody>
         <%if(rschList != null && rschList.size() > 0){
         	for(int i=0; i<rschList.size(); i++){
         		FoodVO vo	=	rschList.get(i);
         		%>
         		<tr>
	             <td><span class="wid_cate"><%=vo.cat_nm%>-<%=vo.food_cat_index%></span></td>
	             <td><%=vo.food_code%></td>
	             <td><a href="#" class="dp_block"><span class="blue fb"><%=vo.nm_food%></span></a></td>
	             <td><span class="wid_ndetail"><%=vo.dt_nm%></span></td>
	             <td><span class="wid_expl"><%=vo.ex_nm%></span></td>
	             <td><%=vo.unit_nm%></td>
	             <td><%=vo.non_season%></td>
	             <td><%=vo.non_distri%></td>
	             <td><%=vo.item_comp_no%></td>
	             <td><%=vo.nu_nm%></td>
	             <td class="padR5 padL5">
	               <table class="table_skin02 mag0 th-pd1 td-pd1 rsch_price">
	                 <caption>조사가1~5에 대한 조사처 및 브랜드 정보 입력</caption>
	                 <colgroup>
	                   <col style="width:15%">
	                   <col style="width:17%" span="5">
	                 </colgroup>
	                 <thead>
	                   <tr>
	                     <th scope="col">구분</th>
	                     <th scope="col">조사가1</th>
	                     <th scope="col">조사가2</th>
	                     <th scope="col">조사가3</th>
	                     <th scope="col">조사가4</th>
	                     <th scope="col">조사가5</th>
	                   </tr>
	                 </thead>
	                 <tbody>
	                   <tr>
	                     <th scope="row" class="bg_green">조사가</th>
	                     <td><%=vo.rsch_val1%></td>
	                     <td><%=vo.rsch_val2%></td>
	                     <td><%=vo.rsch_val3%></td>
	                     <td><%=vo.rsch_val4%></td>
	                     <td><%=vo.rsch_val5%></td>
	                   </tr>
	                   <tr>
	                     <th scope="row" class="bg_green">조사처</th>
	                     <td><%=vo.rsch_loc1%></td>
	                     <td><%=vo.rsch_loc2%></td>
	                     <td><%=vo.rsch_loc3%></td>
	                     <td><%=vo.rsch_loc4%></td>
	                     <td><%=vo.rsch_loc5%></td>
	                   </tr>
	                   <tr>
	                     <th scope="row" class="bg_green">브랜드</th>
	                     <td><%=vo.rsch_com1%></td>
	                     <td><%=vo.rsch_com2%></td>
	                     <td><%=vo.rsch_com3%></td>
	                     <td><%=vo.rsch_com4%></td>
	                     <td><%=vo.rsch_com5%></td>
	                   </tr>
	                 </tbody>
	               </table>
	             </td>
	             <td class="btn_mingroup"><span class="wid_state">제출완료</span></td>
	           </tr>
         		<%
         	}
         }else{
        	 out.print("<tr>");
        	 out.print("<td colspan=\"12\">완료 내역이 없습니다.</td>");
        	 out.print("</tr>");
         }
         %>
         </tbody>
       </table>
       <%}%>
   	<!-- paging -->
   	<%if(pagingVO.getTotalCount() > 0){%>
		<div class="pageing">
			<%=pagingVO.getHtml()%>
		</div>
	<%}%>
	<!-- //paging -->
   </section>
</div>

<%}	//조사자일 때 end

//조사팀장일 때
else if("T".equals(foodVO.sch_grade)){%>
<!-- 탭메뉴 -->
	<div class="tab_wrap clearfix">
	  <ul class="tabs">
	    <li<%if(actType==0){ out.print(" class=\"active\""); }%>><a href="/index.gne?menuCd=<%=request.getParameter("menuCd")%>&actType=0">검토대상 품목</a></li>
	    <li<%if(actType==1){ out.print(" class=\"active\""); }%>><a href="/index.gne?menuCd=<%=request.getParameter("menuCd")%>&actType=1">마감완료 품목</a></li>
	    <li<%if(actType==2){ out.print(" class=\"active\""); }%>><a href="/index.gne?menuCd=<%=request.getParameter("menuCd")%>&actType=2">미제출 품목</a></li>
	  </ul>
	</div>
	<!-- //탭메뉴 -->
	<div class="tab_container">
  	<section class="tab_content" style="display:block;">
    <h3 class="stit"><%=titleTxt%> <span class="dec fsize_80">(완료 <span class="fb blue"><%=completeCnt%></span>건 / 전체 <%=allCnt%>건)</span></h3>
    
    <%
    //검토 목록
    if(actType == 0){%>
    <!-- 자동마감시 미입력된 데이터만 보기 : 이 옵션은 자동마감시 데이터를 입력안하고 마감되었을 경우에 해당 데이터만 볼 수 있는 기능임. -->
        <div class="op_nodata">
          <input type="checkbox" id="chkNoData" class="" onclick="noInputComp();" /> <label for="chkNoData">미입력 마감완료</label>
        </div>
    <!-- // 자동마감시 미입력된 데이터만 보기 끝 -->
	<table class="tbl_rsrch tr-even">
        <caption>검토대상 품목 입력 : 구분, 식품코드, 식품명, 상세식품명, 식품설명, 단위, 비계절, 비유통, 비교그룹, 조사자, 조사가 정보, 검증/제출</caption>
        <colgroup>
          <col style="width:50px"/>
          <col style="width:6%" />
          <col style="width:6%"/>
          <col style="width:8%"/>
          <col style="width:14%" />
          <col style="width:30px"/>
          <col style="width:30px"/>
          <col style="width:30px"/>
          <col style="width:30px"/>
          <col style="width:8%"/>
          <col />
          <col style="width:64px;" />
        </colgroup>
        <thead>
          <tr>
            <th scope="row">품목<br />구분</th>
            <th scope="row">식품코드</th>
            <th scope="row">식품명</th>
            <th scope="row">상세식품명</th>
            <th scope="row">식품설명</th>
            <th scope="row">단위</th>
            <th scope="row">비계절</th>
            <th scope="row">비유통</th>
            <th scope="row">비교그룹</th>
            <th scope="row">조사자</th>
            <th scope="row">조사가 정보</th>
            <th scope="row">검증/제출</th>
          </tr>
        </thead>
        <tbody>
        <%
        if(rschList != null && rschList.size() > 0){
        	for(int i=0; i<rschList.size(); i++){	
        	FoodVO vo			=	rschList.get(i);
        	%>
          <tr>
            <td>
            <span class="wid_cate"><%=vo.cat_nm%>-<%=vo.food_cat_index%></span></td>
            <td><%=vo.food_code%></td>
            <td><a href="#" class="dp_block"><span class="blue fb"><%=vo.nm_food%></span></a></td>
            <td><span class="wid_ndetail"><%=vo.dt_nm%></span></td>
            <td><span class="wid_expl"><%=vo.ex_nm%></span></td>
            <td><%=vo.unit_nm%></td>
            <td>
            	<label for="offSeason_<%=vo.rsch_val_no%>" class="blind">비계절 체크</label>
            	<input type="checkbox" id="offSeason_<%=vo.rsch_val_no%>" name="offSeason" class="chbig" title="비계절 체크" value="Y" onclick="offChk('<%=vo.rsch_val_no%>', '1');" 
            	<%if("Y".equals(vo.non_season)){%>checked<%}%>/></td>
            <td>
            	<label for="offDist_<%=vo.rsch_val_no%>" class="blind">비유통 체크</label>
            	<input type="checkbox" id="offDist_<%=vo.rsch_val_no%>" name="offDist" class="chbig" title="비유통 체크" value="Y" onclick="offChk('<%=vo.rsch_val_no%>', '2');"
            	<%if("Y".equals(vo.non_distri)){%>checked<%}%>/></td>
            <td>
            	<%=vo.item_comp_no %>
            </td>
            <td>
              <label for="rschSel_<%=vo.rsch_val_no%>" class="blind">조사자 선택</label>
              <select id="rschSel_<%=vo.rsch_val_no%>" name="rschSel">
                <option value="">선택</option>
                <%if(vo.t_nu_no.length() > 0){
                	String[] nu_no	=	vo.t_nu_no.split(",");
                	String[] nu_nm	=	vo.t_nu_nm.split(",");
                	for(int j=0; j<nu_no.length; j++){
                		out.print(printOption(nu_no[j], nu_nm[j], vo.nu_no));
                	}
                }
                %>
              </select>
            </td>
            <td class="padR5 padL5">
              <table class="table_skin02 mag0 th-pd1 td-pd1 rsch_price">
                <caption>조사가1~5에 대한 조사처 및 브랜드 정보 입력</caption>
                <colgroup>
                  <col style="width:15%" />
                  <col style="width:17%" span="5" />
                </colgroup>
                <thead>
                  <tr>
                    <th scope="col">구분</th>
                    <th scope="col">조사가1</th>
                    <th scope="col">조사가2</th>
                    <th scope="col">조사가3</th>
                    <th scope="col">조사가4</th>
                    <th scope="col">조사가5</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <th scope="row" class="bg_green">조사가</th>
                    <td><label><input type="text" name="rschVal1" id="rschVal1_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val1%>" title="조사가1 가격" /></label></td>
                    <td><label><input type="text" name="rschVal2" id="rschVal2_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val2%>" title="조사가2 가격" /></label></td>
                    <td><label><input type="text" name="rschVal3" id="rschVal3_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val3%>" title="조사가3 가격" /></label></td>
                    <td><label><input type="text" name="rschVal4" id="rschVal4_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val4%>" title="조사가4 가격" /></label></td>
                    <td><label><input type="text" name="rschVal5" id="rschVal5_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val5%>" title="조사가5 가격" /></label></td>
                  </tr>
                  <tr>
                    <th scope="row" class="bg_green">조사처</th>
                    <td><label><input type="text" name="rschLoc1" id="rschLoc1_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc1%>" title="조사가1 조사처" /></label></td>
                    <td><label><input type="text" name="rschLoc2" id="rschLoc2_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc2%>" title="조사가2 조사처" /></label></td>
                    <td><label><input type="text" name="rschLoc3" id="rschLoc3_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc3%>" title="조사가3 조사처" /></label></td>
                    <td><label><input type="text" name="rschLoc4" id="rschLoc4_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc4%>" title="조사가4 조사처" /></label></td>
                    <td><label><input type="text" name="rschLoc5" id="rschLoc5_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc5%>" title="조사가5 조사처" /></label></td>
                  </tr>
                  <tr>
                    <th scope="row" class="bg_green">브랜드</th>
                    <td><label><input type="text" name="rschCom1" id="rschCom1_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com1%>" title="조사가1 브랜드" /></label></td>
                    <td><label><input type="text" name="rschCom2" id="rschCom2_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com2%>" title="조사가2 브랜드" /></label></td>
                    <td><label><input type="text" name="rschCom3" id="rschCom3_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com3%>" title="조사가3 브랜드" /></label></td>
                    <td><label><input type="text" name="rschCom4" id="rschCom4_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com4%>" title="조사가4 브랜드" /></label></td>
                    <td><label><input type="text" name="rschCom5" id="rschCom5_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com5%>" title="조사가5 브랜드" /></label></td>
                  </tr>
      		
                </tbody>
              </table>
            </td>
            <td class="btn_mingroup">
            <!-- 사유 링크 : 조사자, 조사팀장이 입력한 사유 -->
            <%if(!"".equals(vo.rsch_reason)){%>
              <a href="javascript:;" class="reasonView_open openLayer" onclick="viewPopup('<%=vo.rsch_reason%>');" id="resViewBtn" title="사유보기"><span class="red u fb dp_block magB5">*사유보기</span></a>
            <%}%>
            <!--//사유 끝 -->
              <button type="button" class="btn darkMblue initialism slide_open openLayer" onclick="submissionRsch('<%=vo.rsch_val_no%>', '1');">검토</button>
              <button type="button" class="btn green" onclick="submissionRsch('<%=vo.rsch_val_no%>', '0');">마감</button>
              <button type="button" class="btn red returnInput_open openLayer" onclick="returnPopup('<%=vo.rsch_val_no%>');">반려</button>
              <button type="button" class="btn white" onclick="careerRsch('<%=vo.item_no%>')">이력</button>
            </td>
          </tr>
          <%}
          }else{
            	out.print("<tr>");
              	out.print("<td colspan=\"12\"> 검토 대상이 없습니다. </td>");
              	out.print("</tr>");
          }%>
        </tbody>
      </table>

    <%}//검토목록 end
    
    //마감완료 품목
    else if(actType == 1){%>
    <table class="tbl_rsrch tr-even">
         <caption>조사완료 품목 : 구분, 식품코드, 식품명, 상세식품명, 식품설명, 단위, 비계절, 비유통, 비교그룹, 조사자, 조사가 정보, 검증/제출</caption>
         <colgroup>
           <col style="width:50px"/>
           <col style="width:6%" />
           <col style="width:6%"/>
           <col style="width:8%"/>
           <col style="width:14%" />
           <col style="width:30px"/>
           <col style="width:30px"/>
           <col style="width:30px"/>
           <col style="width:30px"/>
           <col style="width:8%"/>
           <col />
           <col style="width:64px;" />
         </colgroup>
         <thead>
           <tr>
             <th scope="row">품목<br />구분</th>
             <th scope="row">식품코드</th>
             <th scope="row">식품명</th>
             <th scope="row">상세식품명</th>
             <th scope="row">식품설명</th>
             <th scope="row">단위</th>
             <th scope="row">비계절</th>
             <th scope="row">비유통</th>
             <th scope="row">비교그룹</th>
             <th scope="row">조사자</th>
             <th scope="row">조사가 정보</th>
             <th scope="row">상태</th>
           </tr>
         </thead>
         <tbody>
         <%if(rschList != null && rschList.size() > 0){
         	for(int i=0; i<rschList.size(); i++){
         		FoodVO vo	=	rschList.get(i);
         		%>
         		<tr>
	             <td><span class="wid_cate"><%=vo.cat_nm%>-<%=vo.food_cat_index%></span></td>
	             <td><%=vo.food_code%></td>
	             <td><a href="#" class="dp_block"><span class="blue fb"><%=vo.nm_food%></span></a></td>
	             <td><span class="wid_ndetail"><%=vo.dt_nm%></span></td>
	             <td><span class="wid_expl"><%=vo.ex_nm%></span></td>
	             <td><%=vo.unit_nm%></td>
	             <td><%=vo.non_season%></td>
	             <td><%=vo.non_distri%></td>
	             <td><%=vo.item_comp_no%></td>
	             <td><%=vo.nu_nm%></td>
	             <td class="padR5 padL5">
	               <table class="table_skin02 mag0 th-pd1 td-pd1 rsch_price">
	                 <caption>조사가1~5에 대한 조사처 및 브랜드 정보 입력</caption>
	                 <colgroup>
	                   <col style="width:15%">
	                   <col style="width:17%" span="5">
	                 </colgroup>
	                 <thead>
	                   <tr>
	                     <th scope="col">구분</th>
	                     <th scope="col">조사가1</th>
	                     <th scope="col">조사가2</th>
	                     <th scope="col">조사가3</th>
	                     <th scope="col">조사가4</th>
	                     <th scope="col">조사가5</th>
	                   </tr>
	                 </thead>
	                 <tbody>
	                   <tr>
	                     <th scope="row" class="bg_green">조사가</th>
	                     <td><%=vo.rsch_val1%></td>
	                     <td><%=vo.rsch_val2%></td>
	                     <td><%=vo.rsch_val3%></td>
	                     <td><%=vo.rsch_val4%></td>
	                     <td><%=vo.rsch_val5%></td>
	                   </tr>
	                   <tr>
	                     <th scope="row" class="bg_green">조사처</th>
	                     <td><%=vo.rsch_loc1%></td>
	                     <td><%=vo.rsch_loc2%></td>
	                     <td><%=vo.rsch_loc3%></td>
	                     <td><%=vo.rsch_loc4%></td>
	                     <td><%=vo.rsch_loc5%></td>
	                   </tr>
	                   <tr>
	                     <th scope="row" class="bg_green">브랜드</th>
	                     <td><%=vo.rsch_com1%></td>
	                     <td><%=vo.rsch_com2%></td>
	                     <td><%=vo.rsch_com3%></td>
	                     <td><%=vo.rsch_com4%></td>
	                     <td><%=vo.rsch_com5%></td>
	                   </tr>
	                 </tbody>
	               </table>
	             </td>
	             <td class="btn_mingroup"><span class="wid_state">마감완료</span></td>
	           </tr>
         		<%
         	}
         }else{
        	 out.print("<tr>");
        	 out.print("<td colspan=\"12\">마감 내역이 없습니다.</td>");
        	 out.print("</tr>");
         }
         %>
         </tbody>
       </table>
       
    <%}
    //조사팀장 미조사 목록
    else if(actType == 2){%>
      <table class="tbl_rsrch tr-even">
        <caption>미조사 품목 입력 : 구분, 식품코드, 식품명, 상세식품명, 식품설명, 단위, 비계절, 비유통, 비교그룹, 조사자, 조사가 정보, 검증/제출</caption>
        <colgroup>
          <col style="width:50px"/>
          <col style="width:6%" />
          <col style="width:6%"/>
          <col style="width:8%"/>
          <col style="width:14%" />
          <col style="width:30px"/>
          <col style="width:30px"/>
          <col style="width:30px"/>
          <col style="width:30px"/>
          <col style="width:8%"/>
          <col />
          <col style="width:64px;" />
        </colgroup>
        <thead>
          <tr>
            <th scope="row">품목<br />구분</th>
            <th scope="row">식품코드</th>
            <th scope="row">식품명</th>
            <th scope="row">상세식품명</th>
            <th scope="row">식품설명</th>
            <th scope="row">단위</th>
            <th scope="row">비계절</th>
            <th scope="row">비유통</th>
            <th scope="row">비교그룹</th>
            <th scope="row">조사자</th>
            <th scope="row">조사가 정보</th>
            <th scope="row">검증/제출</th>
          </tr>
        </thead>
        <tbody>
        <%
        if(rschList != null && rschList.size() > 0){
        	for(int i=0; i<rschList.size(); i++){	
        	FoodVO vo			=	rschList.get(i);
        	String classTxt		=	"";
        	
       		//관리자반려 또는 팀장반려일 경우 tr태그에 class를 추가한다.
       		if("RR".equals(vo.sts_flag) || "RT".equals(vo.sts_flag)){
       			classTxt	=	" class=\"rch_return\"";
       		}
        	%>
          <tr<%=classTxt%>>
            <td>
            <span class="wid_cate"><%=vo.cat_nm%>-<%=vo.food_cat_index%></span></td>
            <td><%=vo.food_code%></td>
            <td><a href="#" class="dp_block"><span class="blue fb"><%=vo.nm_food%></span></a></td>
            <td><span class="wid_ndetail"><%=vo.dt_nm%></span></td>
            <td><span class="wid_expl"><%=vo.ex_nm%></span></td>
            <td><%=vo.unit_nm%></td>
            <td>
            	<label for="offSeason_<%=vo.rsch_val_no%>" class="blind">비계절 체크</label>
            	<input type="checkbox" id="offSeason_<%=vo.rsch_val_no%>" name="offSeason" class="chbig" title="비계절 체크" value="Y" onclick="offChk('<%=vo.rsch_val_no%>', '1');"
            	<%if("Y".equals(vo.non_season)){%>checked<%}%>/></td>
            <td>
            	<label for="offDist_<%=vo.rsch_val_no%>" class="blind">비유통 체크</label>
            	<input type="checkbox" id="offDist_<%=vo.rsch_val_no%>" name="offDist" class="chbig" title="비유통 체크" value="Y" onclick="offChk('<%=vo.rsch_val_no%>', '2');"
            	<%if("Y".equals(vo.non_distri)){%>checked<%}%>/></td>
            <td><%=vo.item_comp_no%></td>
            <td>
              <label for="rschSel_<%=vo.rsch_val_no%>" class="blind">조사자 선택</label>
              <select id="rschSel_<%=vo.rsch_val_no%>" name="rschSel">
                <option value="">선택</option>
                <%if(vo.t_nu_no.length() > 0){
                	String[] nu_no	=	vo.t_nu_no.split(",");
                	String[] nu_nm	=	vo.t_nu_nm.split(",");
                	for(int j=0; j<nu_no.length; j++){
                		out.print(printOption(nu_no[j], nu_nm[j], vo.nu_no));
                	}
                }
                %>
              </select>
            </td>
            <td class="padR5 padL5">
              <table class="table_skin02 mag0 th-pd1 td-pd1 rsch_price">
                <caption>조사가1~5에 대한 조사처 및 브랜드 정보 입력</caption>
                <colgroup>
                  <col style="width:15%" />
                  <col style="width:17%" span="5" />
                </colgroup>
                <thead>
                  <tr>
                    <th scope="col">구분</th>
                    <th scope="col">조사가1</th>
                    <th scope="col">조사가2</th>
                    <th scope="col">조사가3</th>
                    <th scope="col">조사가4</th>
                    <th scope="col">조사가5</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <th scope="row" class="bg_green">조사가</th>
                    <td><label><input type="text" name="rschVal1" id="rschVal1_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val1%>" title="조사가1 가격" /></label></td>
                    <td><label><input type="text" name="rschVal2" id="rschVal2_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val2%>" title="조사가2 가격" /></label></td>
                    <td><label><input type="text" name="rschVal3" id="rschVal3_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val3%>" title="조사가3 가격" /></label></td>
                    <td><label><input type="text" name="rschVal4" id="rschVal4_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val4%>" title="조사가4 가격" /></label></td>
                    <td><label><input type="text" name="rschVal5" id="rschVal5_<%=vo.rsch_val_no%>" value="<%=vo.rsch_val5%>" title="조사가5 가격" /></label></td>
                  </tr>
                  <tr>
                    <th scope="row" class="bg_green">조사처</th>
                    <td><label><input type="text" name="rschLoc1" id="rschLoc1_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc1%>" title="조사가1 조사처" /></label></td>
                    <td><label><input type="text" name="rschLoc2" id="rschLoc2_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc2%>" title="조사가2 조사처" /></label></td>
                    <td><label><input type="text" name="rschLoc3" id="rschLoc3_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc3%>" title="조사가3 조사처" /></label></td>
                    <td><label><input type="text" name="rschLoc4" id="rschLoc4_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc4%>" title="조사가4 조사처" /></label></td>
                    <td><label><input type="text" name="rschLoc5" id="rschLoc5_<%=vo.rsch_val_no%>" value="<%=vo.rsch_loc5%>" title="조사가5 조사처" /></label></td>
                  </tr>
                  <tr>
                    <th scope="row" class="bg_green">브랜드</th>
                    <td><label><input type="text" name="rschCom1" id="rschCom1_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com1%>" title="조사가1 브랜드" /></label></td>
                    <td><label><input type="text" name="rschCom2" id="rschCom2_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com2%>" title="조사가2 브랜드" /></label></td>
                    <td><label><input type="text" name="rschCom3" id="rschCom3_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com3%>" title="조사가3 브랜드" /></label></td>
                    <td><label><input type="text" name="rschCom4" id="rschCom4_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com4%>" title="조사가4 브랜드" /></label></td>
                    <td><label><input type="text" name="rschCom5" id="rschCom5_<%=vo.rsch_val_no%>" value="<%=vo.rsch_com5%>" title="조사가5 브랜드" /></label></td>
                  </tr>
      		
                </tbody>
              </table>
            </td>
            <td class="btn_mingroup">
            <!-- 반려 사유 링크 : 팀장에 의해 반려되었을 경우 -->
            <%if("RT".equals(vo.sts_flag)){%>
              <a href="javascript:;" class="returnView_open openLayer" id="resViewBtn" title="반려된 사유보기" onclick="returnViewPopup('<%=vo.t_rj_reason%>');"><span class="red u fb dp_block magB5">*반려됨<br />(사유보기)</span></a>
            <%}else if("RR".equals(vo.sts_flag)){%>
              <a href="javascript:;" class="returnView_open openLayer" id="resViewBtn" title="반려된 사유보기" onclick="returnViewPopup('<%=vo.rj_reason%>');"><span class="red u fb dp_block magB5">*반려됨<br />(사유보기)</span></a>
            <%} %>
            <!--//반려 사유 끝 -->
              <button type="button" class="btn darkMblue initialism slide_open openLayer" onclick="submissionRsch('<%=vo.rsch_val_no%>', '1');">검증</button>
              <button type="button" class="btn green" onclick="submissionRsch('<%=vo.rsch_val_no%>', '0');">제출</button>
              <button type="button" class="btn white" onclick="careerRsch('<%=vo.item_no%>')">이력</button>
            </td>
          </tr>
          <%}
          }else{
            	out.print("<tr>");
              	out.print("<td colspan=\"12\"> 조사 대상이 없습니다. </td>");
              	out.print("</tr>");
          }%>
        </tbody>
      </table>

    <%}%>
    <!-- paging -->
   	<%if(pagingVO.getTotalCount() > 0){%>
		<div class="pageing">
			<%=pagingVO.getHtml()%>
		</div>
	<%}%>
	<!-- //paging -->
  </section>
</div>
       
	
<%}
%>


<%/*************************************** STR Modal part ****************************************/%>
<button type="button" onclick="inputPopup();" style="display:none;" class="reasonInput_open openLayer" id="reasonClick">사유입력</button>
<!-- 사유 입력 모달 -->
  <div id="reasonInput" class="modal" style="display:none">
    <div class="topbar">
      <h3>사유 입력</h3>
    </div>
    <div class="inner">
      <form name="reasonForm" id="reasonForm" method="post">
      	<input type="hidden" id="rschValNo" value="">
        <!-- 빈번한 입력사유 자동 노출 영역 -->
        <p class="red fb c padT5 padB5" id="reasonInput_p"></p>
        <!-- //빈번 사유 끝 -->
        <div class="sel_input magT10">
          <select name="reasonSel" id="reasonSel" title="사유를 선택해주세요." onchange="reasonChk(this.value);">
            <option value="">직접입력</option>
            <option value="취급업체 소수">취급업체 소수</option>
          </select>
          <textarea placeholder="구체적인 사유를 입력하세요." class="magT5 wps_100 h050" name="reason" id="reason"></textarea>
        </div>
        <div class="btn_area c mg_b5">
          <input type="button" class="btn small edge darkMblue" value="확인" onclick="if(confirm('정말 제출하시겠습니까?')){submissionRsch('0', '3');}">
        </div>
      </form>
      <a href="javascript:modalClose('reasonInput');" class="btn_cancel" id="inputModalClose" title="창닫기"><img src="/img/art/layer_close.png" alt="창닫기"></a>
    </div>
  </div>
<!-- //사유 입력 모달 끝 -->
<!-- 사유 보기 모달 -->
  <div id="reasonView" class="modal" style="display:none;">
    <div class="topbar">
      <h3>사유 보기</h3>
    </div>
    <div class="inner">
      <!-- 빈번한 사유 자동 노출 영역 -->
      <p class="red fb c padT5 padB5" id="reasonView_p"></p>
      <!-- //빈번 사유 끝 -->
      <textarea class="magT5 wps_100 h050" readonly id="reasonView_txt"></textarea>
    <a href="javascript:modalClose('reasonView')" class="btn_cancel" id="viewModalClose" title="창닫기"><img src="/img/art/layer_close.png" alt="창닫기"></a>
    </div>
  </div>
<!-- //사유 보기 모달 끝 -->
<!-- //반려 모달 -->
<div id="returnInput" class="modal" style="display:none;">
    <div class="topbar">
      <h3>반려 사유 입력</h3>
    </div>
    <div class="inner">
      <form name="returnForm" id="returnForm" method="post">
      <input type="hidden" id="rschValNoR" value="">
        <div class="sel_input magT10">
          <label for="reselDirect" class="blind">직접입력 선택</label>
          <select name="reSelDirect" id="reselDirect" title="반려사유를 선택해주세요." onchange="returnChk(this.value);">
            <option value="">직접입력</option>
            <option value="조사가격재확인">조사가격재확인</option>
            <option value="계절식품 여부 재확인">계절식품 여부 재확인</option>
            <option value="비유통식품 여부 재확인">비유통식품 여부 재확인</option>
          </select>
          <label for="returnWrite" class="blind">사유 입력</label>
          <textarea placeholder="반려 사유를 구체적으로 입력하세요." id="returnWrite" name="returnWrite" class="magT5 wps_100 h050"></textarea>
        </div>
        <div class="btn_area c mg_b5">
          <input type="button" class="btn small edge darkMblue" value="확인" onclick="if(confirm('정말 반려하시겠습니까?')){submissionRsch('0', '3');}">
        </div>
      </form>
      <a href="javascript:modalClose('returnInput');" class="btn_cancel" id="returnModalClose" title="창닫기"><img src="/img/art/layer_close.png" alt="창닫기"></a>
    </div>
  </div>
<!-- //반려 모달 끝 -->
<!-- //반려 사유 보기 모달 -->
  <div id="returnView" class="modal" style="display:none;">
    <div class="topbar">
      <h3>반려사유 보기</h3>
    </div>
    <div class="inner">
      <!-- 빈번한 사유 자동 노출 영역 -->
      <p class="red fb c padT5 padB5" id="returnView_p"></p>
      <!-- //빈번 사유 끝 -->
    <a href="javascript:modalClose('returnView')" class="btn_cancel" id="viewModalClose" title="창닫기"><img src="/img/art/layer_close.png" alt="창닫기"></a>
    </div>
  </div>
<!-- //반려 사유 보기 모달 끝 -->
<%/*************************************** END Modal part ****************************************/%>
<div id="errorMsg">
</div>
<%}%>