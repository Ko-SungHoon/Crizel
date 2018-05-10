<%
/**
*	PURPOSE	:	조사가격조회 page
*	CREATE	:	20180321_wed	JUNG
*	MODIFY	:	20180416_mon	JI		관리자 session 접속 허용
*	MODIFY	:	20180416_mon	JI		이력 팝업 open
*	MODIFY	:	20180419_thur	JI		최저가 최고가 비율 bool flag 설정
*	MODIFY	:	20180425_wed	KO		최저가 삭제 및 비교그룹 출력, 학교급식 관리자 권한 추가
**/
%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="java.text.*" %>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ include file="/program/class/PagingClass.jsp" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%!
	private String moneyComma (String money) {
		DecimalFormat df	=	new DecimalFormat("###,###");
		String rtnMoney	=	null;
		if (!"-".equals(money.trim()) || money != null) {
			return money;
		} else {
			rtnMoney	=	df.format(Integer.parseInt(money));
			return rtnMoney;
		}
	}
%>	

<%
String foodRole		= 	"ROLE_000094";		//운영서버:ROLE_000094 , 테스트서버:ROLE_000012

request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");
SessionManager sManager =	new SessionManager(request);

int viewYN			=	0;		//1일경우 페이지 정상 작동
String moveUrl		=	"/index.gne?contentsSid=2299";					//액션페이지	운영서버:2299, 테스트서버:648
String moveUrlMain	=	"/index.gne?menuCd=DOM_000002101000000000";		//메인페이지	운영서버:DOM_000002101000000000, 테스트서버:DOM_000000127000000000

//2차 로그인 여부
if("Y".equals(session.getAttribute("foodLoginChk")) || sManager.isRoleAdmin() || sManager.isRole(foodRole)){
	viewYN	=	1;
}else{
	out.print("<script> 							\n");
	out.print("alert('2차 로그인 후 이용하실 수 있습니다.');		\n");
	out.print("location.href='" + moveUrlMain + "';	\n");
	out.print("</script> 							\n");
	return;
}

if(viewYN == 1){

	StringBuffer sql 	= 	null;
	String sqlWhere		=	"";
	int resultCnt 		=	0;
	int cnt				= 	0;
	
	List<FoodVO> zoneList	=	null;
	List<FoodVO> cateList	=	null;
	List<FoodVO> searchList	=	null;
	List<String> setWhere	=	new ArrayList<String>();
	List<FoodVO> rschList	=	null;
	HashMap<Integer, String> valMap	=	null;
	int valMapCnt	=	0;
	int minVal		=	0;
	int useMinVal   =   0;
	int minNo		=	0;
	int maxVal		=	0;
	int useMaxVal   =   0;
	int maxNo		=	0;
	Boolean lbRatioBool =   true;
	
	Object[] setObject 		= 	null;

	//parameter
	FoodVO foodVO		=	new FoodVO();
	Paging pagingVO		=	new Paging();
		
	String srchSdate	=	parseNull(request.getParameter("srchSdate"));
	String srchEdate	=	parseNull(request.getParameter("srchEdate"));
	String zoneType		=	parseNull(request.getParameter("zoneType"));
	String foodItem		=	parseNull(request.getParameter("foodItem"));
	String foodName		=	parseNull(request.getParameter("foodName"));
	String keywordCate 	=	parseNull(request.getParameter("keywordCate"));
	String keywordInp	=	parseNull(request.getParameter("keywordInp"));
	String rsch_no		= 	parseNull(request.getParameter("rsch_no"));
	int pageNo			=	Integer.parseInt(parseNull(request.getParameter("pageNo"), "1"));
	
	String[] keyCateOp	=	{"title", "detail"};
	String[] keyCateTxt =	{"조사명", "식품설명"};
	
	//검색어 where
	if(!"".equals(keywordInp)){
		
		//제목 where
		if("title".equals(keywordCate))	{
			sqlWhere	+=	" AND TB.RSCH_NM LIKE '%' ||?|| '%' 	\n";
			setWhere.add(keywordInp);
		}
		
		//식품 상세설명 where
		else if("detail".equals(keywordCate)){
			sqlWhere	+=	" AND (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', EX_NM)			\n";
			sqlWhere	+=	" ORDER BY EX_NM).EXTRACT('//text()').GETSTRINGVAL(), 2)		\n";
			sqlWhere	+=	" EX_NM															\n";
			sqlWhere	+=	" FROM FOOD_ST_EXPL												\n";
			sqlWhere	+=	" WHERE EX_NO IN(												\n";
			sqlWhere	+=	" FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5,		\n";
			sqlWhere	+=	" FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10, 		\n";
			sqlWhere	+=	" FOOD_EP_11, FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15,	\n";
			sqlWhere	+=	" FOOD_EP_16, FOOD_EP_17, FOOD_EP_18, FOOD_EP_19, FOOD_EP_20,	\n";
			sqlWhere	+=	" FOOD_EP_21, FOOD_EP_22, FOOD_EP_23, FOOD_EP_24, FOOD_EP_25))	\n";
			sqlWhere	+=	" LIKE '%' ||?|| '%'											\n";
			setWhere.add(keywordInp);
		}
		pagingVO.setParams("keywordCate", keywordCate);
		pagingVO.setParams("keywordInp", keywordInp);
	}
	
	//날짜검색
	
	if(!"".equals(srchSdate) && !"".equals(srchEdate)){
		sqlWhere	+=	" AND ((TB.STR_DATE >= TO_DATE(?, 'YY/MM/DD') AND TB.STR_DATE <= TO_DATE(?, 'YY/MM/DD')) 	\n";
		sqlWhere	+=	" OR (TB.END_DATE >= TO_DATE(?, 'YY/MM/DD') AND TB.END_DATE <= TO_DATE(?, 'YY/MM/DD'))) 	\n";
		
		setWhere.add(srchSdate);
		setWhere.add(srchEdate);
		setWhere.add(srchSdate);
		setWhere.add(srchEdate);
		
		pagingVO.setParams("srchSdate", srchSdate);
		pagingVO.setParams("srchEdate", srchEdate);
	}
		
	try{
		//권역 목록
		sql		=	new StringBuffer();
		sql.append(" SELECT  				\n");
		sql.append(" ZONE_NO,  				\n");
		sql.append(" ZONE_NM				\n");
		sql.append(" FROM FOOD_ZONE  		\n");
		sql.append(" WHERE SHOW_FLAG = 'Y'  \n");		
		
		zoneList	=	jdbcTemplate.query(sql.toString(), new FoodList());
		
		//권역선택 where
		if(zoneList != null && zoneList.size() > 0 && !"".equals(zoneType)){
			for(int i=0; i<zoneList.size(); i++){
				if(zoneList.get(i).zone_no.equals(zoneType)){
					sqlWhere	+=	" AND SCH.ZONE_NO = ? 			\n";
					setWhere.add(zoneType);
					pagingVO.setParams("zoneType", zoneType);
				}
			}
		}
		
		//월별조사 where
		if(!"".equals(rsch_no)){
			sqlWhere += "AND TB.RSCH_NO = ?			";
			setWhere.add(rsch_no);
			pagingVO.setParams("rsch_no", rsch_no);
		}

		//카테고리 목록
		sql		=	new StringBuffer();
		sql.append(" SELECT  				\n");
		sql.append(" CAT_NO,  				\n");
		sql.append(" CAT_NM  				\n");
		sql.append(" FROM FOOD_ST_CAT  		\n");
		sql.append(" WHERE SHOW_FLAG = 'Y'  \n");		
		
		cateList	=	jdbcTemplate.query(sql.toString(), new FoodList());
		
		//품목구분 where
		if(cateList != null && cateList.size() > 0){
			if(!"".equals(foodItem)){
				for(int i=0; i<cateList.size(); i++){
					if(cateList.get(i).cat_no.equals(foodItem)){
						sqlWhere	+=	" AND ITEM.CAT_NO = ? 				\n";
						setWhere.add(foodItem);
						pagingVO.setParams("foodItem", foodItem);
					}
				}
			}
		}
				
		//품목 검색 where
		sqlWhere	+=	" AND (SELECT SUBSTR(XMLAGG(XMLELEMENT(COL, ',', NM_FOOD)	\n";
		sqlWhere	+=	" ORDER BY NM_FOOD).EXTRACT('//text()').GETSTRINGVAL(),2)	\n";
		sqlWhere	+=	" NM_FOOD													\n";
		sqlWhere	+=	" FROM FOOD_ST_NM											\n";
		sqlWhere	+=	" WHERE NM_NO IN (											\n";
		sqlWhere	+=	" FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5))	\n";
		sqlWhere	+=	" LIKE '%' ||?|| '%'										\n";
		
		setWhere.add(foodName);
		pagingVO.setParams("foodName", foodName);
		
		//검색카운트
		sql		=	new StringBuffer();
		sql.append(" SELECT COUNT(PRE.ITEM_NO) AS CNT 								\n");
		sql.append(" FROM FOOD_ITEM_PRE PRE		  									\n");
		sql.append(" LEFT JOIN FOOD_ST_ITEM ITEM ON PRE.S_ITEM_NO = ITEM.ITEM_NO	\n");
		sql.append(" LEFT JOIN FOOD_RSCH_VAL VAL ON VAL.ITEM_NO = ITEM.ITEM_NO		\n");
		sql.append(" LEFT JOIN FOOD_RSCH_TB TB ON VAL.RSCH_NO = TB.RSCH_NO			\n");
		sql.append(" LEFT JOIN FOOD_SCH_TB SCH ON VAL.SCH_NO = SCH.SCH_NO			\n");
		sql.append(" LEFT JOIN FOOD_SCH_NU NU ON VAL.NU_NO = NU.NU_NO				\n");
		sql.append(" WHERE TB.SHOW_FLAG = 'Y'										\n");
/* 		sql.append(" AND VAL.STS_FLAG = 'Y'											\n");
 */		sql.append(sqlWhere);
				
		if(setWhere != null && setWhere.size() > 0){
			setObject	=	new Object[setWhere.size()];
			for(int i=0; i<setWhere.size(); i++){
				setObject[i]	=	setWhere.get(i);
			}
		}
		
		cnt		=	jdbcTemplate.queryForInt(sql.toString(), setObject);
		
		//페이징 set
		pagingVO.setTotalCount(cnt);
		pagingVO.setPageNo(pageNo);
		pagingVO.setPageSize(20);
		pagingVO.makePaging();
		
		//검색목록
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
		sql.append(" VAL.LOW_VAL,	 												\n");
		sql.append(" VAL.AVR_VAL,	 												\n");
		sql.append(" VAL.CENTER_VAL, 												\n");
		sql.append(" ( 	SELECT														\n");
		sql.append(" 		ROUND(AVG(AVR_VAL), 0)									\n");
		sql.append(" 	FROM FOOD_RSCH_VAL											\n");
		sql.append(" 	WHERE RSCH_NO = VAL.RSCH_NO									\n");
		sql.append(" 		AND ITEM_NO = VAL.ITEM_NO								\n");
		sql.append(" ) AS ZONE_AVR_VAL,												\n");

		sql.append(" ( 	SELECT														\n");
		sql.append(" 		COUNT(AVR_VAL)											\n");
		sql.append(" 	FROM FOOD_RSCH_VAL											\n");
		sql.append(" 	WHERE RSCH_NO = VAL.RSCH_NO									\n");
		sql.append(" 		AND ITEM_NO = VAL.ITEM_NO								\n");
		sql.append(" ) AS ZONE_AVR_CNT,												\n");

		sql.append(" TB.RSCH_NM,	 												\n");
		sql.append(" SCH.ZONE_NO,	 												\n");
		sql.append(" ZONE.ZONE_NM,	 												\n");
		sql.append(" ITEM.FOOD_CAT_INDEX,											\n");
		sql.append(" VAL.RSCH_VAL1,													\n");
		sql.append(" VAL.RSCH_VAL2,													\n");
		sql.append(" VAL.RSCH_VAL3,													\n");
		sql.append(" VAL.RSCH_VAL4,													\n");
		sql.append(" VAL.RSCH_VAL5,													\n");
		sql.append(" VAL.RSCH_REASON												\n");
		sql.append("    , (                        									\n");
		sql.append("        CASE                                                    \n");
		sql.append("        WHEN (                                                  \n");
		sql.append("            VAL.LOW_VAL / ((SELECT Z.LOW_VAL                    \n");
		sql.append("            FROM (SELECT * FROM FOOD_RSCH_VAL                   \n");
		sql.append("                ORDER BY RSCH_VAL_NO DESC) Z                    \n");
		sql.append("            WHERE Z.RSCH_VAL_NO < VAL.RSCH_VAL_NO               \n");
		sql.append("                AND Z.RSCH_NO < VAL.RSCH_NO                     \n");
		sql.append("                AND Z.ITEM_NO = VAL.ITEM_NO                     \n");
		sql.append("                AND Z.ZONE_NO = VAL.ZONE_NO                     \n");
		sql.append("                AND ROWNUM = 1) + VAL.LOW_VAL) * 100            \n");
		sql.append("        ) IS NULL                                               \n");
		sql.append("        THEN 'Y'                                                \n");
		sql.append("        WHEN (                                                  \n");
		sql.append("            VAL.LOW_VAL / ((SELECT Z.LOW_VAL                    \n");
		sql.append("            FROM (SELECT * FROM FOOD_RSCH_VAL                   \n");
		sql.append("                ORDER BY RSCH_VAL_NO DESC) Z                    \n");
		sql.append("            WHERE Z.RSCH_VAL_NO < VAL.RSCH_VAL_NO               \n");
		sql.append("                AND Z.RSCH_NO < VAL.RSCH_NO                     \n");
		sql.append("                AND Z.ITEM_NO = VAL.ITEM_NO                     \n");
		sql.append("                AND Z.ZONE_NO = VAL.ZONE_NO                     \n");
		sql.append("                AND ROWNUM = 1) + VAL.LOW_VAL) * 100            \n");
		sql.append("        ) < PRE.LOW_RATIO                                       \n");
		sql.append("        THEN 'N'                                                \n");
		sql.append("        ELSE 'Y'                                                \n");
		sql.append("        END                                                     \n");
		sql.append("    ) AS LOW_FLAG            									\n");
		sql.append("    , (															\n");
		sql.append("		CASE			 										\n");
		sql.append("        WHEN (			 										\n");
		sql.append("			VAL.AVR_VAL / ((SELECT Z.LOW_VAL			 		\n");
		sql.append("            FROM (SELECT * FROM FOOD_RSCH_VAL					\n");
		sql.append("            	ORDER BY RSCH_VAL_NO DESC) Z					\n");
		sql.append("            WHERE Z.RSCH_VAL_NO < VAL.RSCH_VAL_NO				\n");
		sql.append("            	AND Z.RSCH_NO < VAL.RSCH_NO						\n");
		sql.append("            	AND Z.ITEM_NO = VAL.ITEM_NO						\n");
		sql.append("            	AND Z.ZONE_NO = VAL.ZONE_NO						\n");
		sql.append("            	AND ROWNUM = 1) + VAL.LOW_VAL) * 100			\n");
		sql.append("            ) IS NULL											\n");
		sql.append("		THEN 'Y'												\n");
		sql.append("        WHEN (													\n");
		sql.append("        	VAL.LOW_VAL / ((SELECT Z.LOW_VAL					\n");
		sql.append("            FROM (SELECT * FROM FOOD_RSCH_VAL					\n");
		sql.append("            	ORDER BY RSCH_VAL_NO DESC) Z					\n");
		sql.append("            WHERE Z.RSCH_VAL_NO < VAL.RSCH_VAL_NO				\n");
		sql.append("            	AND Z.RSCH_NO < VAL.RSCH_NO						\n");
		sql.append("            	AND Z.ITEM_NO = VAL.ITEM_NO						\n");
		sql.append("            	AND ROWNUM = 1) + VAL.LOW_VAL) * 100			\n");
		sql.append("		) < PRE.LOW_RATIO										\n");
		sql.append("        THEN 'N'												\n");
		sql.append("        ELSE 'Y'												\n");
		sql.append("        END														\n");
		sql.append("		) AS AVR_FLAG											\n");

		sql.append(" FROM FOOD_ITEM_PRE PRE 										\n");
		sql.append(" LEFT JOIN FOOD_ST_ITEM ITEM ON PRE.S_ITEM_NO = ITEM.ITEM_NO	\n");
		sql.append(" LEFT JOIN FOOD_RSCH_VAL VAL ON VAL.ITEM_NO = ITEM.ITEM_NO		\n");
		sql.append(" LEFT JOIN FOOD_RSCH_TB TB ON VAL.RSCH_NO = TB.RSCH_NO			\n");
		sql.append(" LEFT JOIN FOOD_SCH_TB SCH ON VAL.SCH_NO = SCH.SCH_NO			\n");
		sql.append(" LEFT JOIN FOOD_SCH_NU NU ON VAL.NU_NO = NU.NU_NO				\n");
		sql.append(" LEFT JOIN FOOD_ZONE ZONE ON VAL.ZONE_NO = ZONE.ZONE_NO			\n");
		
		sql.append(" WHERE TB.SHOW_FLAG = 'Y'										\n");
 		sql.append(" AND TB.STS_FLAG = 'Y'											\n");		
		sql.append(sqlWhere);
		sql.append(" ORDER BY TB.RSCH_NO DESC, PRE.ITEM_NO							\n");
		sql.append(" )A WHERE ROWNUM <= ?											\n");
		sql.append(" ) WHERE RNUM > ?												\n");
		
		setWhere.add(Integer.toString(pagingVO.getEndRowNo()));		//ROWNUM
		setWhere.add(Integer.toString(pagingVO.getStartRowNo()));	//RNUM
		
		if(setWhere != null && setWhere.size() > 0){
			setObject	=	new Object[setWhere.size()];
			for(int i=0; i<setWhere.size(); i++){
				setObject[i]	=	setWhere.get(i);
			}
		}
		
		searchList		=	jdbcTemplate.query(sql.toString(), new FoodList(), setObject);			
		
		
		
		
		// 월별조사 리스트
		sql = new StringBuffer();
		sql.append("SELECT * 					");
		sql.append("FROM FOOD_RSCH_TB TB		");
		sql.append("WHERE TB.SHOW_FLAG = 'Y'	");
		if(!"".equals(srchSdate) && !"".equals(srchEdate)){
			sql.append("AND ((TB.STR_DATE >= TO_DATE(?, 'YY/MM/DD') AND TB.STR_DATE <= TO_DATE(?, 'YY/MM/DD'))			");
			sql.append("		OR (TB.END_DATE >= TO_DATE(?, 'YY/MM/DD') AND TB.END_DATE <= TO_DATE(?, 'YY/MM/DD')))		");
		}
		sql.append("ORDER BY RSCH_NO DESC		");
		
		if(!"".equals(srchSdate) && !"".equals(srchEdate)){
			rschList = jdbcTemplate.query(sql.toString(), new FoodList(), srchSdate, srchEdate, srchSdate, srchEdate );
		}else{
			rschList = jdbcTemplate.query(sql.toString(), new FoodList());
		}
		
		
		
	}catch(Exception e){
		alert(out, e.toString());
	}finally{

	}
%>

<script type="text/javascript">

	$(function() {
		$("#srchSdate").datepicker({
		showButtonPanel: true,
		buttonImageOnly: true,
		currentText: '오늘 날짜',
		closeText: '닫기',
		dateFormat: "y/mm/dd",
		monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		dayNamesMin: ['일','월','화','수','목','금','토'],
		changeMonth: true, //월변경가능
		changeYear: true, //년변경가능
		showMonthAfterYear: true, //년 뒤에 월 표시
		showOn: "both",
		buttonImage: '/jquery/icon_calendar.gif',
		buttonImageOnly: true
		});

		$("#srchEdate").datepicker({
		showButtonPanel: true,
		buttonImageOnly: true,
		currentText: '오늘 날짜',
		closeText: '닫기',
		dateFormat: "y/mm/dd",
		monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		dayNamesMin: ['일','월','화','수','목','금','토'],
		changeMonth: true, //월변경가능
		changeYear: true, //년변경가능
		showMonthAfterYear: true, //년 뒤에 월 표시
		showOn: "both",
		buttonImage: '/jquery/icon_calendar.gif',
		buttonImageOnly: true
		});

		$('img.ui-datepicker-trigger').css({'cursor':'pointer', 'margin-left':'-22px', 'margin-top':'1px'});
		
		//기간검색 시작날짜가 종료날짜보다 클경우
		
		//open popup item history
		$(".openItem").click(function () {
			var index	=	$(".openItem").index(this);
			var item_no	=	$(".openItem").eq(index).data("value");
			
			var send_url	=	"/index.gne?menuCd=DOM_000002101003001000&item_no=" + item_no;
			var param		=	{item_no: item_no};
			newWin(send_url, "식품이력 page", 1500, 1000);
		});

		$("#rschDwExcel").click(function (){
			var sendForm	=	$("#foodSrch");
			sendForm.attr("action", "/program/food/research/food_research_val_excel.jsp");
			sendForm.submit();
			sendForm.attr("action", "/index.gne?menuCd=DOM_000002101003000000");
		});
		
		
		$("#srchSdate").change(function(){rschSearch();});
		$("#srchEdate").change(function(){rschSearch();});
		
	});
	
	function rschSearch(){
		var srchSdate = $("#srchSdate").val();
		var srchEdate = $("#srchEdate").val();
		
		if(srchSdate != "" && srchEdate != ""){
			$.ajax({
				type : "POST",
				url : "/program/food/research/rschSearch.jsp",
				data : {
					"srchSdate"	: srchSdate,
					"srchEdate"	: srchEdate   
					},
				async : false,
				success : function(data){
					$("#rsch_no").html(data.trim());
				},
				error : function(request, status, error){
					alert("처리중 오류가 발생하였습니다.");
				}
			});
		}
	}
	
	

	//search Submit Check
	function submitChk(){
		//기간검색 유효성검사
		if($("#srchSdate").val() != "" && $("#srchEdate").val() != ""){
			if($("#srchSdate").val() > $("#srchEdate").val()){
				alert("조사시작일이 종료일보다 클 수 없습니다.");
				$("#srchSdate").focus();
				return false;
			}
		}
		//기간검색 시 시작일,종료일 둘중 하나라도 빈값이 아닐 경우
		else if(($("#srchSdate").val() != "" && $("#srchEdate").val() == "") || 
				($("#srchEdate").val() != "" && $("#srchSdate").val() == "")){
			alert("기간검색시 반드시 시작일과 종료일을 둘다 입력하셔야 합니다.");
			$("#srchEdate").focus();
			return false;
		}
		else{
			return true;
		}
	}

	function newWin(url, title, w, h){
        var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
        var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

        var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
        var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

        var left = ((width / 2) - (w / 2)) + dualScreenLeft;
        var top = ((height / 2) - (h / 2)) + dualScreenTop;
        var newWindow = window.open(url, title, 'scrollbars=yes, resizable=yes, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
    }

</script>
<!-- 배너링크 include -->
{CNT:2305}			<!-- 운영서버:2305, 테스트서버:669 -->
<!-- // 배너 include -->

<section>
	<h3 class="blind">거래실례가격 검색조건</h3>
	<form id="foodSrch" name="foodSrch" method="post" onsubmit="return submitChk();">
    <fieldset class="search_wrap">
      <legend>조사가격 조회 검색조건</legend>
      <table class="bbs_list1 td-l mag0">
        <caption>조사가격 조회 검색조건 : 기간검색, 권역, 품목구분/식품명, 검색어 입력란</caption>
        <colgroup>
          <col style="width:15%" />
          <col style="width:33%"/>
          <col style="width:15%" />
          <col />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row">기간검색</th>
            <td><label for="srchSdate" class="blind">시작날짜 선택</label>
            <input type="text" id="srchSdate" name="srchSdate" value="<%=srchSdate%>" class="datepicker calendar" style="ime-mode:disabled;">
            ~
            <label for="srchEdate" class="blind">종류날짜 선택</label>
            <input type="text" id="srchEdate" name="srchEdate" value="<%=srchEdate%>" class="datepicker calendar" style="ime-mode:disabled;"></td>
            <th scope="row"><label for="rsch_no">조사/권역</label></th>
            <td>
           	<select id="rsch_no" name="rsch_no">
             	<option value="">조사 선택</option>
             <%
               if(rschList != null && rschList.size() > 0){
               	for(int i=0; i<rschList.size(); i++){
               		out.print(printOption(rschList.get(i).rsch_no, rschList.get(i).rsch_nm, rsch_no));
               	}
               }
               %>
             </select>
             
              <select name="zoneType" id="zoneType" title="권역을 선택해주세요." class="wps_30">
                <option value="">권역 전체</option>
                <%
                if(zoneList != null && zoneList.size() > 0){
                	for(int i=0; i<zoneList.size(); i++){
                		out.print(printOption(zoneList.get(i).zone_no, zoneList.get(i).zone_nm, zoneType));
                	}
                }
                %>
              </select>
            </td>
          </tr>
          <tr>
            <th scope="row">품목구분/식품명</th>
            <td>
              <label for="foodItem" class="blind">품목구분</label>
              <select name="foodItem" id="foodItem" title="품목을 선택해주세요." class="wps_30">
                <option value="">품목 전체</option>
                <%
                if(cateList != null && cateList.size() > 0){
                	for(int i=0; i<cateList.size(); i++){
                		out.print(printOption(cateList.get(i).cat_no, cateList.get(i).cat_nm, foodItem));
                	}
                }
                %>
              </select>
              <label for="foodName" class="blind">품목구분</label>
              <input type="text" id="foodName" name="foodName" value="<%=foodName%>" class="wps_60" />
            </td>
            <th scope="row">검색어</th>
            <td>
              <label for="keywordCate" class="blind">검색어</label>
              <select name="keywordCate" id="keywordCate" title="검색어분류를 선택해주세요." class="wps_30">
                <option value="">분류 선택</option>
                <%
                	for(int i=0; i<keyCateOp.length; i++){
                		out.print(printOption(keyCateOp[i], keyCateTxt[i], keywordCate));
                	}
                %>
              </select>
              <label for="keywordInp" class="blind">키워드 입력</label>
              <input type="text" id="keywordInp" name="keywordInp" value="<%=keywordInp%>" class="wps_60" />
            </td>
          </tr>
        </tbody>
      </table>
    </fieldset>
    <div class="btn_area c magT10">
      <button type="submit" class="btn medium darkMblue fb w_150">검 색</button>
    </div>
	</form>
</section>

<div class="btn_area l magB5" style="float:left;">
	검색항목 수 : <%=cnt%>
</div>
<div class="btn_area r magB5">
	<button type="button" id="rschDwExcel" class="btn small edge white fb"><i class="ico_xls"></i>엑셀다운로드</button>
</div>
<table class="tbl_rsrch td-pd1">
	<caption>품목구분별 거래실례가격 정보 조회 : 권역, 조사명, 조사날짜, 식품코드, 식품명, 상세식품명, 식품설명, 단위, 적용단가, 비교그룹, 평균가, 중앙가, 세권역통합평균가, 조사자, 소속, 조사가1~3 등</caption>
	<colgroup>
		<col style="width:7%" />
		<col style="width:4%" />
		<col style="width:8%" />
		<col style="width:8%" />
		<col style="width:10%" />
		<col style="width:18%" />
		<col style="width:2%" />
		<col style="width:6.1%" />
		<col style="width:6.1%" />
		<col style="width:6.1%" />
		<col />
		<col style="width:6.1%" />
		<col style="width:6.1%" />
		<col style="width:6.1%" />
		<col style="width:6.1%" />
	</colgroup>
	<thead>
	<tr>
		<th scope="col">품목구분</th>
		<th scope="col">권역</th>
		<th scope="col">조사명</th>
		<th scope="col">식품명</th>
		<th scope="col">상세 식품명</th>
		<th scope="col">식품설명</th>
		<th scope="col">단위</th>
		<th scope="col">비교그룹</th>
		<th scope="col">평균가</th>
		<th scope="col">중앙가</th>
		<th scope="col">세권역<br />통합평균가</th>
		<th scope="col">조사가1</th>
		<th scope="col">조사가2</th>
		<th scope="col">조사가3</th>
		<th scope="col">비고</th>
	</tr>
	</thead>
	<tbody>
  	<%
  	if(searchList != null && searchList.size()>0){
  		for(int i=0; i<searchList.size(); i++){
  			FoodVO vo	=	searchList.get(i);
  			String classTxt		=	"";
  			if(!"".equals(parseNull(vo.rsch_reason)))	classTxt	=	" class = \"rch_return\"";
  			%>
  			<tr<%=classTxt%>>
				<td><%=vo.cat_nm%>-<%=vo.food_cat_index%></td>
				<td><%=vo.zone_nm%></td>
				<td><%=vo.rsch_nm%></td>
				<td>
					<a href="javascript:;" class="openItem" data-value="<%=vo.item_no %>">
						<span class="blue fb"><%=vo.nm_food%></span>
					</a>
				</td>
				<td><%=vo.dt_nm%></td>
				<td><%=vo.ex_nm%></td>
				<td><%=vo.unit_nm%></td>
				<%-- <td><%if ("N".equals(vo.low_flag)){%><span class="fb red" title="최저가 비율 초과"><%}%>
					<%=moneyComma(parseNull(vo.low_val, " - ")) %>
				</td> --%>
				<td><%=parseNull(vo.item_comp_no, " - ")%></td>
				<td><%if ("N".equals(vo.avr_flag)){%><span class="fb red"><%}%>
					<%=parseNull(vo.avr_val, " - ") %>
				</td>
				<td><%=parseNull(vo.center_val, " - ") %></td>
				<td><%
					if ("3".equals(vo.zone_avr_cnt)) {
						out.println(parseNull(vo.zone_avr_val, " - "));
					} else {
						out.println(" - ");
					}
				%></td>
				<%/*조사가 정렬 출력*/
					valMap	=	new HashMap<Integer, String>();
					valMap.put(1, parseNull(vo.rsch_val1, "-"));
					valMap.put(2, parseNull(vo.rsch_val2, "-"));
					valMap.put(3, parseNull(vo.rsch_val3, "-"));
					valMap.put(4, parseNull(vo.rsch_val4, "-"));
					valMap.put(5, parseNull(vo.rsch_val5, "-"));
					valMapCnt	=	0;	//초기화
					for (int j = 1; j <= valMap.size(); j++) {
						if (!"-".equals(valMap.get(j))) {
							valMapCnt++;
						}
					}
					//가격 유무 여부 확인
					if (valMapCnt > 0) {
						if (valMapCnt == 5) {
							//5개의 값이 모두 같을 경우 산정하기....
							int duplCnt	=	0;
							for (int j = 1; j <= valMap.size(); j++) {
								if (valMap.get(1).equals(valMap.get(j))) {
									duplCnt++;
								}
							}

							//최고값 최저값
							int strNo	=	0;
							for (int j = 1; j <= valMap.size(); j++) {
								if (!"-".equals(valMap.get(j)) && strNo == 0) {
									strNo	=	j;
									minVal	=	Integer.parseInt(valMap.get(j));
									maxVal	=	Integer.parseInt(valMap.get(j));
								}
								if (!"-".equals(valMap.get(j)) && minVal < Integer.parseInt(valMap.get(j))) {
									minVal	=	minVal;
								} else if (!"-".equals(valMap.get(j)) && minVal >= Integer.parseInt(valMap.get(j))) {
									minVal	=	Integer.parseInt(valMap.get(j));
									if (duplCnt == valMap.size()) {minNo	=	j - 1;} 
									else {minNo	=	j;}
								}
								//최고값 index
								if (!"-".equals(valMap.get(j)) && maxVal > Integer.parseInt(valMap.get(j))) {
									maxVal	=	maxVal;
								} else if (!"-".equals(valMap.get(j)) && maxVal <= Integer.parseInt(valMap.get(j))) {
									maxVal	=	Integer.parseInt(valMap.get(j));
									maxNo	=	j;
								}
							}
							for (int j = 1; j <= valMap.size(); j++) {
								if (j != minNo && j != maxNo) {%>
									<td><span><%=valMap.get(j) %></span></td>
							<%	
									useMaxVal   =   Integer.parseInt(valMap.get(j));
                                    useMinVal   =   Integer.parseInt(valMap.get(j));
                                    if (useMaxVal < Integer.parseInt(valMap.get(j))) {
                                        useMaxVal   =   Integer.parseInt(valMap.get(j));
                                    }
                                    if (useMinVal > Integer.parseInt(valMap.get(j))) {
                                        useMinVal   =   Integer.parseInt(valMap.get(j));
                                    }
                                    lbRatioBool =   lbRatioBool(useMinVal, useMaxVal, vo.lb_ratio);
								}
							}

						//가격이 3개 일 경우
						} else if (valMapCnt == 3) {
							for (int j = 1; j <= valMap.size(); j++) {
								if (!"-".equals(valMap.get(j))) {%>
									<td><span><%=valMap.get(j) %></span></td>
							<%
									useMaxVal   =   Integer.parseInt(valMap.get(j));
									useMinVal   =   Integer.parseInt(valMap.get(j));
									if (useMaxVal < Integer.parseInt(valMap.get(j))) {
										useMaxVal   =   Integer.parseInt(valMap.get(j));
									}
									if (useMinVal > Integer.parseInt(valMap.get(j))) {
										useMinVal   =   Integer.parseInt(valMap.get(j));
									}
									lbRatioBool =   lbRatioBool(useMinVal, useMaxVal, vo.lb_ratio);
								}
							}%>

						<%//가격이 1개일 경우... 혹시 모르니...
						} else if (valMapCnt == 1) {%>
							<td><span>
							<%for (int j = 1; j <= valMap.size(); j++) {
								if (!"-".equals(valMap.get(j))) {
									out.println(valMap.get(j));
							}}%>
							</span></td>
							<td><span> - </span></td>
							<td><span> - </span></td>
						<%}
					} else {%>
						<td><span> - </span></td>
						<td><span> - </span></td>
						<td><span> - </span></td>
					<%}
				%>
				<td><%=parseNull(vo.rsch_reason ," - ")%></td>
		    </tr>
  			<%
  		}/*END FOR*/
  	}/*END IF*/else{%>
  		<tr>
  			<td colspan="15" style="text-align:center;">내역이 없습니다.</td>
  		</tr>
  		<%
  	}%>
    
  </tbody>
</table>

<!-- paging -->
<div class="pageing">
	<%if(pagingVO.getTotalCount() > 0) {
		out.print(pagingVO.getHtml());	
	}%>
</div>

<%}%>