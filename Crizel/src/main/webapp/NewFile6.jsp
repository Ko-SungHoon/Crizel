<%@ page import="java.util.Collections"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/food/food_util.jsp"%>
<%@ include file="/program/food/foodVO.jsp"%>
<%
/**
* PURPOSE : 조사가격입력 액션 page
*	MODIFY	:	20180425	KO		최저가 기능 제거
*/
%>
<%!//순서코드 비교를 위해 알파벳을 숫자로 변환
	public int codeToNumber(String code) {
		int number = 0;
		if ("A".equals(code)) {
			number = 1;
		} else if ("B".equals(code)) {
			number = 2;
		} else if ("C".equals(code)) {
			number = 3;
		} else if ("D".equals(code)) {
			number = 4;
		} else if ("E".equals(code)) {
			number = 5;
		} else if ("F".equals(code)) {
			number = 6;
		} else if ("G".equals(code)) {
			number = 7;
		} else if ("H".equals(code)) {
			number = 8;
		} else if ("I".equals(code)) {
			number = 9;
		} else if ("J".equals(code)) {
			number = 10;
		} else if ("K".equals(code)) {
			number = 11;
		} else if ("L".equals(code)) {
			number = 12;
		} else if ("M".equals(code)) {
			number = 13;
		} else if ("N".equals(code)) {
			number = 14;
		} else if ("O".equals(code)) {
			number = 15;
		} else if ("P".equals(code)) {
			number = 16;
		} else if ("Q".equals(code)) {
			number = 17;
		} else if ("R".equals(code)) {
			number = 18;
		} else if ("S".equals(code)) {
			number = 19;
		} else if ("T".equals(code)) {
			number = 20;
		} else if ("U".equals(code)) {
			number = 21;
		} else if ("V".equals(code)) {
			number = 22;
		} else if ("W".equals(code)) {
			number = 23;
		} else if ("X".equals(code)) {
			number = 24;
		} else if ("Y".equals(code)) {
			number = 25;
		} else if ("Z".equals(code)) {
			number = 26;
		} else {
			number = 0;
		}
		return number;
	}

	//text가 빈값이 아닐 경우, ','를 붙이고 + value 한다.
	public String appendComma(String text, String value) {
		if (text.length() > 0) {
			text += ",";
		}
		text += value;
		return text;
	}%>


<%
/**
*	CREATE	:	20180411 JMG
*	MODIFY	:	
*/

request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");
SessionManager sManager =	new SessionManager(request); 

int viewYN			=	0;		//1일경우 페이지 정상 작동
String moveUrl		=	"";		//이동페이지
String moveUrlMain	=	"";		//메인페이지

//2차 로그인 여부
if("Y".equals(session.getAttribute("foodLoginChk"))){
	viewYN	=	1;
}else{
	out.print("<script> 						\n");
	out.print("alert('2차 로그인 후 이용하실 수 있습니다.');	\n");
	out.print("window.close(); 					\n");
	out.print("</script> 						\n");
}

if(viewYN == 1){
	JSONObject	obj		=	new JSONObject();
	Connection conn 			= null;
	PreparedStatement pstmt 	= null;
	int key						= 0;
	StringBuffer sql 	= 	null;
	String sqlWhere		=	"";
	String resultMsg	=	"";
	String returnType	=	"";			//사유입력 타입
	int resultCnt 		=	0;
	int cnt				= 	0;
	
	//parameter
	List<Object[]> batchList	=	null;
	int[] batchSuccess			=	null;
	
	List<FoodVO> cList	=	null;	
	List<FoodVO> rList	=	null;
	FoodVO foodVO		=	new FoodVO();
	FoodVO dataVO		=	new FoodVO();
	FoodVO preDataVO	=	new FoodVO();
	FoodVO inputChkVO	=	new FoodVO();
	
	int actType			=	Integer.parseInt(parseNull(request.getParameter("actType"), "0"));	//0 : 제출(마감), 1 : 검증(검토), 2 : 재검증(재검토), 3 : 사유제출(반려), 4 : 이력
	boolean actChk		=	true;		//검증 boolean
	
	foodVO.rsch_val_no	=	parseNull(request.getParameter("number"));
	String[] rschValArr	=	request.getParameterValues("rschVal");				//조사가
	String[] rschLocArr	=	request.getParameterValues("rschLoc");				//조사처
	String[] rschComArr	=	request.getParameterValues("rschCom");				//조사업체
	
	foodVO.sch_no		=	parseNull(request.getParameter("schNo"));			//학교번호
	foodVO.non_season	=	parseNull(request.getParameter("offSeason"), "N");	//비계절
	foodVO.non_distri	=	parseNull(request.getParameter("offDist"), "N");	//비유통
	foodVO.nu_no		=	parseNull(request.getParameter("rschSel"));			//조사자
	foodVO.rsch_year	=	parseNull(request.getParameter("rschYear"));		//현재 조사의 년도
	foodVO.rsch_month	=	parseNull(request.getParameter("rschMonth"));		//현재 조사의 월
	foodVO.rsch_reason	=	parseNull(request.getParameter("reason"));			//사유
	foodVO.zone_no		=	parseNull(request.getParameter("zoneNo"));			//권역
	foodVO.team_no		=	parseNull(request.getParameter("teamNo"));			//팀
	foodVO.sch_grade	=	parseNull(request.getParameter("userType"));		//R : 조사자, T : 조사팀장
	foodVO.t_rj_reason	=	parseNull(request.getParameter("returnWrite"));		//반려사유
	String rCondition	=	parseNull(request.getParameter("rCondition"));		//사유입력 발생조건
	
	foodVO.rsch_no		=	parseNull(request.getParameter("rschNo"));		// 조사번호
	String preRschNo	=	"";												// 이전조사
	
	int avgVal			=	0;		//최저값, 최고값을 제외한 나머지 3개중 평균값
	int minVal			=	0;		//최저값, 최고값을 제외한 나머지 3개중 최저값
	int maxVal			=	0;		//최저값, 최고값을 제외한 나머지 3개중 최고값
	int midVal			=	0;		//중앙값
	
	int highNLowMin		=	0;		//전월 최저값 * 최저가비율%
	int highNLowAvr		=	0;		//전월 평균값 * 평균가비율%
	int highNLow		=	0;		//최고값과 최저값 차이
	
	String rt_ip		= 	parseNull(request.getParameter("rt_ip"));	//반려 아이피
		
	//최저값, 최고값, 평균값 구하기 start
	List<Integer> vals	=	new ArrayList<Integer>();	//조사가를 담을 리스트
	List<Integer> valsF	=	new ArrayList<Integer>();	//조사가에서 최고, 최저값을 빼고 담을 리스트
	
	if(rschValArr != null && rschValArr.length > 0){
		for(int i=0; i<rschValArr.length; i++){
			if(/* !"0".equals(rschValArr[i]) &&  */!"".equals(rschValArr[i])){
				vals.add(Integer.parseInt(rschValArr[i]));
			}
		}
		
		if(vals.size() > 0){
			
			Collections.sort(vals);		//리스트 오름차순 정렬
			
			//조사가가 3개 이상일 경우
			if(vals.size() >= 3){
				for(int i =0; i<vals.size(); i++){
					//조사가가 5개 이상일 경우
					if(vals.size() >= 5){
						//최저가, 최고가를 제외
						if(i != 0 && i != vals.size()-1){
							valsF.add(vals.get(i));
							avgVal	+=	vals.get(i);
						}
					}
					//조사가가 3개 이상일 경우
					else if(vals.size() >= 3){
						valsF.add(vals.get(i));
						avgVal	+=	vals.get(i);
					}
				}
				minVal	=	valsF.get(0);			//최저값
				midVal	=	valsF.get(1);			//중앙값
				maxVal	=	valsF.get(2);			//최고값
				avgVal	=	avgVal / valsF.size();	//평균값
			}
			//조사가가 1개일 경우
			else{
				minVal	=	vals.get(0);			//최저값
				midVal	=	vals.get(0);			//중앙값
				maxVal	=	vals.get(0);			//최고값
				avgVal	=	vals.get(0);			//평균값
			}
		}else{
			minVal	=	0;
			midVal	=	0;
			maxVal	=	0;
			minVal	=	0;
		}
	}
	//최저값, 최고값, 평균값 구하기 end
	
	//현재 개시된 조사와 비교할 이전조사 년, 월 구하기 start
	String preYear		=	"";
	String preMonth		=	"";
	
	SimpleDateFormat sdf	=	new SimpleDateFormat("yyyyMM");
	Calendar cal			=	Calendar.getInstance();
	Date date				=	sdf.parse(foodVO.rsch_year + foodVO.rsch_month);
	cal.setTime(date);
	cal.add(Calendar.MONTH, -1);
	
	preYear		=	Integer.toString(cal.get(Calendar.YEAR));
	if(Integer.toString(cal.get(Calendar.MONTH)).length() == 1){
		preMonth	=	"0" + Integer.toString(cal.get(Calendar.MONTH)+1);
	}
	else{
		preMonth	=	Integer.toString(cal.get(Calendar.MONTH)+1);
	}
	//현재 개시된 조사와 비교할 이전조사 년, 월 구하기 end
	
	try{
		sqlMapClient.startTransaction();
		conn	=	sqlMapClient.getCurrentConnection();
		
		sql		=	new StringBuffer();
		sql.append(" SELECT 					\n");
		sql.append(" VAL.ITEM_NO,				\n");
		sql.append(" VAL.STS_FLAG, 				\n");
		sql.append(" PRE.ITEM_GRP_NO,			\n");
		sql.append(" PRE.ITEM_GRP_ORDER,		\n");
		sql.append(" PRE.ITEM_COMP_NO,			\n");
		sql.append(" PRE.ITEM_COMP_VAL,			\n");
		sql.append(" PRE.LOW_RATIO,				\n");
		sql.append(" PRE.AVR_RATIO,				\n");
		sql.append(" PRE.LB_RATIO				\n");
		sql.append(" FROM FOOD_RSCH_VAL VAL		\n");
		sql.append(" LEFT JOIN 			 		\n");
		sql.append(" FOOD_ITEM_PRE PRE ON 		\n");
		sql.append(" VAL.ITEM_NO = PRE.ITEM_NO	\n");
		sql.append(" WHERE VAL.RSCH_VAL_NO = ? 	\n");
		sql.append(" AND PRE.SHOW_FLAG = 'Y'	\n");
				
		try{
			dataVO	=	jdbcTemplate.queryForObject(sql.toString(), new FoodList(), new Object[]{foodVO.rsch_val_no});
		}catch(Exception e){
			dataVO	=	new FoodVO();
		}
		
		//조사자 start
		if("R".equals(foodVO.sch_grade)){	
			
			//제출 start
			if(actType == 0){
				
				//검증(RS)이 된 상태일 때 작동 start
				if("RS".equals(dataVO.sts_flag)){
					
					//비계절 start
					if("Y".equals(foodVO.non_season)){			
						
						sql		=	new StringBuffer();
						sql.append(" UPDATE FOOD_RSCH_VAL SET 		\n");
						sql.append(" NU_NO	= ?,		 			\n");
						sql.append(" NON_SEASON	= 'Y', 				\n");
						sql.append(" NON_DISTRI	= 'N', 				\n");
						sql.append(" STS_FLAG	= 'SR', 			\n");
						sql.append(" RSCH_REASON = '비계절 식품입니다',	\n");
						sql.append(" T_RJ_REASON = '',				\n");
						sql.append(" RJ_REASON = '',				\n");
						sql.append(" RSCH_VAL1 = '',				\n");
						sql.append(" RSCH_VAL2 = '',				\n");
						sql.append(" RSCH_VAL3 = '',				\n");
						sql.append(" RSCH_VAL4 = '',				\n");
						sql.append(" RSCH_VAL5 = '',				\n");
						sql.append(" RSCH_LOC1 = '',				\n");
						sql.append(" RSCH_LOC2 = '',				\n");
						sql.append(" RSCH_LOC3 = '',				\n");
						sql.append(" RSCH_LOC4 = '',				\n");
						sql.append(" RSCH_LOC5 = '',				\n");
						sql.append(" RSCH_COM1 = '',				\n");
						sql.append(" RSCH_COM2 = '',				\n");
						sql.append(" RSCH_COM3 = '',				\n");
						sql.append(" RSCH_COM4 = '',				\n");
						sql.append(" RSCH_COM5 = '',				\n");
						//sql.append(" LOW_VAL = '', 					\n");
						sql.append(" AVR_VAL = '', 					\n");
						sql.append(" CENTER_VAL = '',				\n");
						sql.append(" RSCH_DATE = SYSDATE			\n");
						sql.append(" WHERE RSCH_VAL_NO = ? 			\n");
						
						resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{
								foodVO.nu_no, foodVO.rsch_val_no
						});

					}//비계절 end
					
					//비유통 start
					else if("Y".equals(foodVO.non_distri)){	
						
						sql		=	new StringBuffer();
						sql.append(" UPDATE FOOD_RSCH_VAL SET 		\n");
						sql.append(" NU_NO	= ?,		 			\n");
						sql.append(" NON_DISTRI	= 'Y',		 		\n");
						sql.append(" NON_SEASON	= 'N',		 		\n");
						sql.append(" STS_FLAG	= 'SR',		 		\n");
						sql.append(" RSCH_REASON = '비유통 식품입니다',	\n");
						sql.append(" T_RJ_REASON = '',		 		\n");
						sql.append(" RJ_REASON = '',		 		\n");
						sql.append(" RSCH_VAL1 = '',				\n");
						sql.append(" RSCH_VAL2 = '',				\n");
						sql.append(" RSCH_VAL3 = '',				\n");
						sql.append(" RSCH_VAL4 = '',				\n");
						sql.append(" RSCH_VAL5 = '',				\n");
						sql.append(" RSCH_LOC1 = '',				\n");
						sql.append(" RSCH_LOC2 = '',				\n");
						sql.append(" RSCH_LOC3 = '',				\n");
						sql.append(" RSCH_LOC4 = '',				\n");
						sql.append(" RSCH_LOC5 = '',				\n");
						sql.append(" RSCH_COM1 = '',				\n");
						sql.append(" RSCH_COM2 = '',				\n");
						sql.append(" RSCH_COM3 = '',				\n");
						sql.append(" RSCH_COM4 = '',				\n");
						sql.append(" RSCH_COM5 = '',				\n");
						//sql.append(" LOW_VAL = '', 					\n");
						sql.append(" AVR_VAL = '', 					\n");
						sql.append(" CENTER_VAL = '',				\n");
						sql.append(" RSCH_DATE = SYSDATE			\n");
						sql.append(" WHERE RSCH_VAL_NO = ?	 		\n");
						
						resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{
								foodVO.nu_no, foodVO.rsch_val_no
						});

					}//비유통 end
					//그 외
					else{
						sql		=	new StringBuffer();
						sql.append(" UPDATE FOOD_RSCH_VAL 		\n");
						sql.append(" SET 						\n");
						sql.append(" NU_NO = ?,					\n");	
						sql.append(" NON_SEASON = 'N',			\n");			
						sql.append(" NON_DISTRI = 'N',			\n");			
						sql.append(" RSCH_REASON = '',			\n");			
						sql.append(" T_RJ_REASON = '',			\n");			
						sql.append(" RJ_REASON = '',			\n");			
						sql.append(" STS_FLAG = 'SR',			\n");			
						sql.append(" RSCH_VAL1 = ?, 			\n");
						sql.append(" RSCH_VAL2 = ?, 			\n");
						sql.append(" RSCH_VAL3 = ?, 			\n");
						sql.append(" RSCH_VAL4 = ?, 			\n");
						sql.append(" RSCH_VAL5 = ?, 			\n");
						sql.append(" RSCH_LOC1 = ?, 			\n");
						sql.append(" RSCH_LOC2 = ?, 			\n");
						sql.append(" RSCH_LOC3 = ?, 			\n");
						sql.append(" RSCH_LOC4 = ?, 			\n");
						sql.append(" RSCH_LOC5 = ?, 			\n");
						sql.append(" RSCH_COM1 = ?, 			\n");
						sql.append(" RSCH_COM2 = ?, 			\n");
						sql.append(" RSCH_COM3 = ?, 			\n");
						sql.append(" RSCH_COM4 = ?, 			\n");
						sql.append(" RSCH_COM5 = ?,				\n");
						//sql.append(" LOW_VAL = ?, 				\n");
						sql.append(" AVR_VAL = ?, 				\n");
						sql.append(" CENTER_VAL = ?,			\n");
						sql.append(" RSCH_DATE = SYSDATE		\n");
						sql.append(" WHERE RSCH_VAL_NO = ? 		\n");
						
						resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{
								foodVO.nu_no,
								rschValArr[0], rschValArr[1], rschValArr[2], rschValArr[3], rschValArr[4],
								rschLocArr[0], rschLocArr[1], rschLocArr[2], rschLocArr[3], rschLocArr[4],
								rschComArr[0], rschComArr[1], rschComArr[2], rschComArr[3], rschComArr[4],
								/* minVal, */ avgVal, midVal,
								foodVO.rsch_val_no
						});
	
						//이력 저장
						
						//이력 저장
					}
					
					if(resultCnt > 0){
						obj.put("resultMsg", "정상적으로 제출되었습니다.");
						obj.put("chkCode", "");
					}
					
				}//검증이 된 상태일 때 작동 end
				
				else{
					obj.put("resultMsg", "검증 후 제출가능합니다.");
					obj.put("chkCode", "");
				}
			}
			//조사 검증
			else if(actType == 1){
				
				//비교그룹이 빈값이 아닐 때
				if(!"".equals(dataVO.item_comp_no) && !"".equals(dataVO.item_comp_val)){
					
					//비교그룹순서 A의 데이터가 들어가있는지 확인한다.
					sql		=	new StringBuffer();
					sql.append(" SELECT 						\n");
					sql.append(" (SELECT 					 	\n");
					sql.append(" CAT_NM 					 	\n");
					sql.append(" FROM FOOD_ST_CAT			 	\n");
					sql.append(" WHERE CAT_NO = ITEM.CAT_NO) 	\n");
					sql.append(" AS CAT_NM,						\n");
					sql.append(" ITEM.FOOD_CAT_INDEX,		 	\n");
					sql.append(" PRE.ITEM_COMP_VAL,				\n");
					sql.append(" VAL.STS_FLAG, 					\n");
					sql.append(" VAL.AVR_VAL, 					\n");
					sql.append(" PRE.ITEM_NM 					\n");
					sql.append(" FROM FOOD_ITEM_PRE PRE 		\n");
					sql.append(" LEFT JOIN 						\n");
					sql.append(" FOOD_RSCH_VAL VAL 				\n");
					sql.append(" ON PRE.ITEM_NO = VAL.ITEM_NO 	\n");
					sql.append(" LEFT JOIN 						\n");
					sql.append(" FOOD_ST_ITEM ITEM 				\n");		
					sql.append(" ON ITEM.ITEM_NO = VAL.ITEM_NO	\n");		
					sql.append(" WHERE PRE.ITEM_COMP_NO = ?		\n");
					sql.append(" AND VAL.RSCH_NO = ?			\n");
					sql.append(" AND VAL.SCH_NO = (				\n");
					sql.append(" 	SELECT SCH_NO FROM			\n");
					sql.append(" 	FOOD_RSCH_VAL WHERE			\n");
					sql.append(" 	RSCH_VAL_NO = ?)			\n");
					sql.append(" ORDER BY PRE.ITEM_COMP_VAL 	\n");	
						
					cList	=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{dataVO.item_comp_no, foodVO.rsch_no, foodVO.rsch_val_no});
				
					if(cList != null && cList.size() > 0){
						for(int i=0; i<cList.size(); i++){
							//비교그룹순서가 자기보다 낮은 알파뱃이 제출되었는지 확인
							if(!"Y".equals(cList.get(i).sts_flag) && !"SS".equals(cList.get(i).sts_flag) && !"RC".equals(cList.get(i).sts_flag) && !"SR".equals(cList.get(i).sts_flag)){
								if(codeToNumber(dataVO.item_comp_val) > codeToNumber(cList.get(i).item_comp_val)){
									obj.put("resultMsg", cList.get(i).cat_nm + "-" + cList.get(i).food_cat_index + "부터 입력해주세요.");
									obj.put("chkCode", "");
									actChk	=	false;
									break;
								}
							}
							
							//비교그룹순서 대비 조사가 평균 비교
							else{
								//비교할 대상의 평균값이 빈값이 아닐 때
								if(!"".equals(cList.get(i).avr_val) && avgVal != 0){
									if(codeToNumber(dataVO.item_comp_val) > codeToNumber(cList.get(i).item_comp_val)){
										if(avgVal < Integer.parseInt(cList.get(i).avr_val)){
											obj.put("resultMsg", cList.get(i).cat_nm + "-" + cList.get(i).food_cat_index + " "+ cList.get(i).item_nm +"보다 조사가가 낮습니다.");
											obj.put("chkCode", "1");
											actChk	=	false;
											break;
										}
									}
								}
							}
						}
					}
				}
				
				if(actChk	==	true){
					//비유통, 비계절 둘다 아닐 때 start
					if(!"Y".equals(foodVO.non_season) && !"Y".equals(foodVO.non_distri)){
						
						sql		=	new StringBuffer();
						sql.append(" SELECT 						\n");
						sql.append(" RSCH_NO 						\n");
						sql.append(" FROM FOOD_RSCH_TB				\n");
						sql.append(" WHERE RSCH_YEAR = ?			\n");
						sql.append(" AND RSCH_MONTH = ?				\n");
						sql.append(" AND STS_FLAG = 'Y'				\n");
						sql.append(" AND SHOW_FLAG = 'Y'			\n");
						sql.append(" AND ROWNUM = 1 				\n");						
						sql.append(" ORDER BY END_DATE DESC, 		\n");	
						sql.append(" RSCH_NO DESC					\n");
			
						try{
							preRschNo	=	jdbcTemplate.queryForObject(sql.toString(), String.class, new Object[]{
									preYear, preMonth
							});
						}catch(Exception e){
							preRschNo	=	"";
						}
						
						if(!"".equals(preRschNo)){
							sql		=	new StringBuffer();
							sql.append(" SELECT 														\n");
							sql.append(" VAL.AVR_VAL,													\n");
							sql.append(" VAL.RSCH_VAL_NO												\n");
							sql.append(" FROM FOOD_RSCH_VAL VAL 										\n");
							sql.append(" LEFT JOIN FOOD_RSCH_TB TB ON VAL.RSCH_NO = TB.RSCH_NO			\n");
							sql.append(" WHERE TB.RSCH_NO = ? AND VAL.ITEM_NO = ?						\n");
							sql.append(" ORDER BY END_DATE DESC											\n");
							
							try{
								preDataVO	=	jdbcTemplate.queryForObject(sql.toString(), new FoodList(), new Object[]{
										preRschNo, dataVO.item_no
								});
								
							}catch(Exception e){
								preDataVO	=	new FoodVO();
							}
						}
						
						//전월 데이터가 있을 경우
						if(preDataVO != null && preDataVO.avr_val != null && !"".equals(preDataVO.avr_val)){
							/* 
							//전월 최저가와 비교
							highNLowMin	=	(int)(Integer.parseInt(preDataVO.low_val) * (Integer.parseInt(dataVO.low_ratio) / 100.0));
							
							if((Integer.parseInt(preDataVO.low_val) + highNLow) > minVal || 
									((Integer.parseInt(preDataVO.low_val) - highNLow) < minVal )){
								resultMsg	=	appendComma(resultMsg, "전월 최저가 비율보다 " + Integer.parseInt(dataVO.low_ratio) + "% 미만 또는 초과입니다.");
								returnType	=	appendComma(returnType, "1");
								obj.put("resultMsg", resultMsg);
								obj.put("chkCode", returnType);
								actChk		=	false;	
							}
													
							//전월 평균가와 비교
							else if((Integer.parseInt(preDataVO.avr_val) + highNLow) > avgVal ||
									((Integer.parseInt(preDataVO.avr_val) - highNLow) < avgVal)){
								resultMsg	=	appendComma(resultMsg, "전월 평균가 비율보다 " + Integer.parseInt(dataVO.avr_ratio) + "% 미만 또는 초과입니다.");
								returnType	=	appendComma(returnType, "2");
								obj.put("resultMsg", resultMsg);
								obj.put("chkCode", returnType);
								actChk		=	false;
							}
							 */
							//전월 평균가와 비교
							highNLowAvr	=	(int)(Integer.parseInt(preDataVO.avr_val) * (Integer.parseInt(dataVO.avr_ratio) / 100.0));
							if((Integer.parseInt(preDataVO.avr_val) + highNLowAvr) <= avgVal ||
									((Integer.parseInt(preDataVO.avr_val) - highNLowAvr) >= avgVal)){
								resultMsg	=	appendComma(resultMsg, "전월대비 조사가(평균가) 차이가 " + Integer.parseInt(dataVO.avr_ratio) + "% 이상입니다.");
								returnType	=	appendComma(returnType, "2");
								obj.put("resultMsg", resultMsg);
								obj.put("chkCode", returnType);
								actChk		=	false;
							}
						}
						
						//최저,최고값 비율
						highNLow	=	(int)(maxVal * (Integer.parseInt(dataVO.lb_ratio) / 100.0));
						if((maxVal - highNLow) >= minVal){
							resultMsg	=	appendComma(resultMsg, "최저값이 최고값의 " + Integer.parseInt(dataVO.lb_ratio) + "% 보다 낮습니다.");
							returnType	=	appendComma(returnType, "3");
							obj.put("resultMsg", resultMsg);
							obj.put("chkCode", returnType);
							actChk		=	false;
						}
					}//비유통, 비계절 둘다 아닐 때 end
				}
				
				if(actChk){
					
					//비계절일 때
					if("Y".equals(foodVO.non_season)){
						sql		=	new StringBuffer();
						sql.append(" UPDATE FOOD_RSCH_VAL SET 	\n");
						sql.append(" STS_FLAG = 'RS', 			\n");
						sql.append(" NON_SEASON = 'Y', 			\n");
						sql.append(" NON_DISTRI = 'N', 			\n");
						sql.append(" RSCH_VAL1 = '', 			\n");
						sql.append(" RSCH_VAL2 = '', 			\n");
						sql.append(" RSCH_VAL3 = '', 			\n");
						sql.append(" RSCH_VAL4 = '', 			\n");
						sql.append(" RSCH_VAL5 = '', 			\n");
						sql.append(" RSCH_LOC1 = '', 			\n");
						sql.append(" RSCH_LOC2 = '', 			\n");
						sql.append(" RSCH_LOC3 = '', 			\n");
						sql.append(" RSCH_LOC4 = '', 			\n");
						sql.append(" RSCH_LOC5 = '', 			\n");
						sql.append(" RSCH_COM1 = '', 			\n");
						sql.append(" RSCH_COM2 = '', 			\n");
						sql.append(" RSCH_COM3 = '', 			\n");
						sql.append(" RSCH_COM4 = '', 			\n");
						sql.append(" RSCH_COM5 = '', 			\n");
						sql.append(" NU_NO	 = ?,	 			\n");
						sql.append(" RSCH_DATE = SYSDATE		\n");
						sql.append(" WHERE RSCH_VAL_NO = ? 		\n");
						
						resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{
								foodVO.nu_no, foodVO.rsch_val_no
						}); 
					}
					
					//비유통일 때
					else if("Y".equals(foodVO.non_distri)){
						
						sql		=	new StringBuffer();
						sql.append(" UPDATE FOOD_RSCH_VAL SET 	\n");
						sql.append(" STS_FLAG = 'RS', 			\n");
						sql.append(" NON_SEASON = 'N', 			\n");
						sql.append(" NON_DISTRI = 'Y', 			\n");
						sql.append(" RSCH_VAL1 = '', 			\n");
						sql.append(" RSCH_VAL2 = '', 			\n");
						sql.append(" RSCH_VAL3 = '', 			\n");
						sql.append(" RSCH_VAL4 = '', 			\n");
						sql.append(" RSCH_VAL5 = '', 			\n");
						sql.append(" RSCH_LOC1 = '', 			\n");
						sql.append(" RSCH_LOC2 = '', 			\n");
						sql.append(" RSCH_LOC3 = '', 			\n");
						sql.append(" RSCH_LOC4 = '', 			\n");
						sql.append(" RSCH_LOC5 = '', 			\n");
						sql.append(" RSCH_COM1 = '', 			\n");
						sql.append(" RSCH_COM2 = '', 			\n");
						sql.append(" RSCH_COM3 = '', 			\n");
						sql.append(" RSCH_COM4 = '', 			\n");
						sql.append(" RSCH_COM5 = '', 			\n");
						sql.append(" NU_NO	 = ?,	 			\n");
						sql.append(" RSCH_DATE = SYSDATE		\n");
						sql.append(" WHERE RSCH_VAL_NO = ? 		\n");
						
						resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{
								foodVO.nu_no, foodVO.rsch_val_no
						}); 
					}
						
					//비유통, 비계절 둘다 아닐 때 start
					else{
						//조사가가 비어있지 않고, 3개 이상일 때
						if(vals != null && vals.size() >= 3){
							sql		=	new StringBuffer();
							sql.append(" UPDATE FOOD_RSCH_VAL SET 	\n");
							sql.append(" STS_FLAG = 'RS', 			\n");
							sql.append(" NON_SEASON = 'N', 			\n");
							sql.append(" NON_DISTRI = 'N', 			\n");
							sql.append(" RSCH_VAL1 = ?, 			\n");
							sql.append(" RSCH_VAL2 = ?, 			\n");
							sql.append(" RSCH_VAL3 = ?, 			\n");
							sql.append(" RSCH_VAL4 = ?, 			\n");
							sql.append(" RSCH_VAL5 = ?, 			\n");
							sql.append(" RSCH_LOC1 = ?, 			\n");
							sql.append(" RSCH_LOC2 = ?, 			\n");
							sql.append(" RSCH_LOC3 = ?, 			\n");
							sql.append(" RSCH_LOC4 = ?, 			\n");
							sql.append(" RSCH_LOC5 = ?, 			\n");
							sql.append(" RSCH_COM1 = ?, 			\n");
							sql.append(" RSCH_COM2 = ?, 			\n");
							sql.append(" RSCH_COM3 = ?, 			\n");
							sql.append(" RSCH_COM4 = ?, 			\n");
							sql.append(" RSCH_COM5 = ?,	 			\n");
							sql.append(" NU_NO	 = ?,	 			\n");
							sql.append(" RSCH_DATE = SYSDATE		\n");
							sql.append(" WHERE RSCH_VAL_NO = ? 		\n");
							
							resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{
									rschValArr[0], rschValArr[1], rschValArr[2], rschValArr[3], rschValArr[4],
									rschLocArr[0], rschLocArr[1], rschLocArr[2], rschLocArr[3], rschLocArr[4],
									rschComArr[0], rschComArr[1], rschComArr[2], rschComArr[3], rschComArr[4],
									foodVO.nu_no, foodVO.rsch_val_no
							}); 
						}
					}
					
					if(resultCnt > 0){
						obj.put("resultMsg", "검증 완료되었습니다. 제출버튼을 클릭해주세요.");
						obj.put("chkCode", "");
					}else{
						if(vals != null && vals.size() == 1){
							resultMsg	=	appendComma(resultMsg, "조사가 정보가 하나입니다.");
							returnType	=	appendComma(returnType, "0");
							obj.put("resultMsg", resultMsg);
							obj.put("chkCode", returnType);
						}else{
							obj.put("resultMsg", resultCnt);
							obj.put("resultMsg", "검증에 오류가 발생하였습니다. 관리자게에 문의해주세요.");
							obj.put("chkCode", "");
						}
						
					}
				}
			}
			
			//재검증 (검증당시의 데이터와 제출당시의 데이터 일치여부)
			else if(actType == 2){
			
				sql		=	new StringBuffer();
				sql.append(" SELECT 									\n");
				sql.append(" COUNT(RSCH_VAL_NO) 						\n");
				sql.append(" FROM FOOD_RSCH_VAL 						\n");
				sql.append(" WHERE 										\n");
				
				if("".equals(rschValArr[0])){
					sql.append(" (RSCH_VAL1 = ? OR RSCH_VAL1 IS NULL)		\n");
				}
				else{
					sql.append(" RSCH_VAL1 = ? 							\n");
				}
				
				if("".equals(rschValArr[1])){
					sql.append(" AND (RSCH_VAL2 = ? OR RSCH_VAL2 IS NULL)	\n");
				}
				else{
					sql.append(" AND RSCH_VAL2 = ? 						\n");
				}
				
				if("".equals(rschValArr[2])){
					sql.append(" AND (RSCH_VAL3 = ? OR RSCH_VAL3 IS NULL)	\n");
				}		
				else{
					sql.append(" AND RSCH_VAL3 = ? 						\n");
				}
				
				if("".equals(rschValArr[3])){
					sql.append(" AND (RSCH_VAL4 = ? OR RSCH_VAL4 IS NULL)	\n");
				}
				else{
					sql.append(" AND RSCH_VAL4 = ? 						\n");
				}
				
				if("".equals(rschValArr[4])){
					sql.append(" AND (RSCH_VAL5 = ? OR RSCH_VAL5 IS NULL)	\n");
				}
				else{
					sql.append(" AND RSCH_VAL5 = ? 						\n");
				}
				
				sql.append(" AND RSCH_VAL_NO = ?						\n");
				sql.append(" AND STS_FLAG = 'RS'						\n");
				
				cnt		=	jdbcTemplate.queryForInt(sql.toString(), new Object[]{
						rschValArr[0], rschValArr[1], rschValArr[2], rschValArr[3], rschValArr[4], 
						foodVO.rsch_val_no
				});
				
				if(cnt == 0){
					obj.put("resultMsg", "검증 당시의 데이터와 일치하지 않습니다. 재검증 해주시기 바랍니다.");
				}
			}
			
			//사유제출
			else if(actType == 3){
				sql		=	new StringBuffer();
				sql.append(" UPDATE FOOD_RSCH_VAL SET 	\n");
				sql.append(" STS_FLAG = 'SR', 			\n");
				sql.append(" NON_SEASON = 'N', 			\n");
				sql.append(" NON_DISTRI = 'N', 			\n");
				sql.append(" T_RJ_REASON = '', 			\n");
				sql.append(" RJ_REASON = '', 			\n");
				sql.append(" RSCH_VAL1 = ?, 			\n");
				sql.append(" RSCH_VAL2 = ?, 			\n");
				sql.append(" RSCH_VAL3 = ?, 			\n");
				sql.append(" RSCH_VAL4 = ?, 			\n");
				sql.append(" RSCH_VAL5 = ?, 			\n");
				sql.append(" RSCH_LOC1 = ?, 			\n");
				sql.append(" RSCH_LOC2 = ?, 			\n");
				sql.append(" RSCH_LOC3 = ?, 			\n");
				sql.append(" RSCH_LOC4 = ?, 			\n");
				sql.append(" RSCH_LOC5 = ?, 			\n");
				sql.append(" RSCH_COM1 = ?, 			\n");
				sql.append(" RSCH_COM2 = ?, 			\n");
				sql.append(" RSCH_COM3 = ?, 			\n");
				sql.append(" RSCH_COM4 = ?, 			\n");
				sql.append(" RSCH_COM5 = ?,				\n");
				//sql.append(" LOW_VAL = ?,				\n");
				sql.append(" AVR_VAL = ?, 				\n");
				sql.append(" CENTER_VAL = ?,			\n");
				sql.append(" RSCH_REASON = ?, 			\n");
				sql.append(" NU_NO = ?, 				\n");
				sql.append(" RSCH_DATE = SYSDATE		\n");
				sql.append(" WHERE RSCH_VAL_NO = ? 		\n");
				
				resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{
						rschValArr[0], rschValArr[1], rschValArr[2], rschValArr[3], rschValArr[4],
						rschLocArr[0], rschLocArr[1], rschLocArr[2], rschLocArr[3], rschLocArr[4],
						rschComArr[0], rschComArr[1], rschComArr[2], rschComArr[3], rschComArr[4],
						/* minVal, */ avgVal, midVal, rCondition + "|" +  foodVO.rsch_reason,
						foodVO.nu_no, foodVO.rsch_val_no
				}); 
				
				if(resultCnt > 0){
					obj.put("resultMsg", "정상적으로 제출되었습니다.");
					obj.put("chkCode", "");
				}
			}
		}//조사자 end
		
		//조사팀장
		else if("T".equals(foodVO.sch_grade)){
		
			//마감 start
			if(actType == 0){
				
				//검토(RC)가 된 상태일 때 작동 start
				if("RC".equals(dataVO.sts_flag)){
					
					//비계절 start
					if("Y".equals(foodVO.non_season)){			
						
						sql		=	new StringBuffer();
						sql.append(" UPDATE FOOD_RSCH_VAL SET 	\n");
						sql.append(" NU_NO	= ?,		 		\n");
						sql.append(" NON_SEASON	= 'Y', 			\n");
						sql.append(" NON_DISTRI	= 'N', 			\n");
						sql.append(" STS_FLAG	= 'SS', 		\n");
						sql.append(" T_RJ_REASON = '',			\n");
						sql.append(" RJ_REASON = '',			\n");
						sql.append(" RSCH_VAL1 = '',			\n");
						sql.append(" RSCH_VAL2 = '',			\n");
						sql.append(" RSCH_VAL3 = '',			\n");
						sql.append(" RSCH_VAL4 = '',			\n");
						sql.append(" RSCH_VAL5 = '',			\n");
						sql.append(" RSCH_LOC1 = '',			\n");
						sql.append(" RSCH_LOC2 = '',			\n");
						sql.append(" RSCH_LOC3 = '',			\n");
						sql.append(" RSCH_LOC4 = '',			\n");
						sql.append(" RSCH_LOC5 = '',			\n");
						sql.append(" RSCH_COM1 = '',			\n");
						sql.append(" RSCH_COM2 = '',			\n");
						sql.append(" RSCH_COM3 = '',			\n");
						sql.append(" RSCH_COM4 = '',			\n");
						sql.append(" RSCH_COM5 = '',			\n");
						//sql.append(" LOW_VAL = '', 				\n");
						sql.append(" AVR_VAL = '', 				\n");
						sql.append(" CENTER_VAL = '',			\n");
						sql.append(" RSCH_T_DATE = SYSDATE		\n");
						sql.append(" WHERE RSCH_VAL_NO = ? 		\n");
						
						resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{
								foodVO.nu_no, foodVO.rsch_val_no
						});

					}//비계절 end
					
					//비유통 start
					else if("Y".equals(foodVO.non_distri)){	
						
						sql		=	new StringBuffer();
						sql.append(" UPDATE FOOD_RSCH_VAL SET 	\n");
						sql.append(" NU_NO	= ?,		 		\n");
						sql.append(" NON_DISTRI	= 'Y',		 	\n");
						sql.append(" NON_SEASON	= 'N',		 	\n");
						sql.append(" STS_FLAG	= 'SS',		 	\n");
						sql.append(" T_RJ_REASON = '', 			\n");
						sql.append(" RJ_REASON = '', 			\n");
						sql.append(" RSCH_VAL1 = '',			\n");
						sql.append(" RSCH_VAL2 = '',			\n");
						sql.append(" RSCH_VAL3 = '',			\n");
						sql.append(" RSCH_VAL4 = '',			\n");
						sql.append(" RSCH_VAL5 = '',			\n");
						sql.append(" RSCH_LOC1 = '',			\n");
						sql.append(" RSCH_LOC2 = '',			\n");
						sql.append(" RSCH_LOC3 = '',			\n");
						sql.append(" RSCH_LOC4 = '',			\n");
						sql.append(" RSCH_LOC5 = '',			\n");
						sql.append(" RSCH_COM1 = '',			\n");
						sql.append(" RSCH_COM2 = '',			\n");
						sql.append(" RSCH_COM3 = '',			\n");
						sql.append(" RSCH_COM4 = '',			\n");
						sql.append(" RSCH_COM5 = '',			\n");
						//sql.append(" LOW_VAL = '', 				\n");
						sql.append(" AVR_VAL = '', 				\n");
						sql.append(" CENTER_VAL = '',			\n");
						sql.append(" RSCH_T_DATE = SYSDATE		\n");
						sql.append(" WHERE RSCH_VAL_NO = ?	 	\n");
						
						resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{
								foodVO.nu_no, foodVO.rsch_val_no
						});

					}//비유통 end
					//그 외
					else{
						sql		=	new StringBuffer();
						sql.append(" UPDATE FOOD_RSCH_VAL 		\n");
						sql.append(" SET 						\n");
						sql.append(" NU_NO = ?,					\n");	
						sql.append(" NON_SEASON = 'N',			\n");			
						sql.append(" NON_DISTRI = 'N',			\n");			
						sql.append(" T_RJ_REASON = '',			\n");			
						sql.append(" RJ_REASON = '',			\n");			
						sql.append(" STS_FLAG = 'SS',			\n");			
						sql.append(" RSCH_VAL1 = ?, 			\n");
						sql.append(" RSCH_VAL2 = ?, 			\n");
						sql.append(" RSCH_VAL3 = ?, 			\n");
						sql.append(" RSCH_VAL4 = ?, 			\n");
						sql.append(" RSCH_VAL5 = ?, 			\n");
						sql.append(" RSCH_LOC1 = ?, 			\n");
						sql.append(" RSCH_LOC2 = ?, 			\n");
						sql.append(" RSCH_LOC3 = ?, 			\n");
						sql.append(" RSCH_LOC4 = ?, 			\n");
						sql.append(" RSCH_LOC5 = ?, 			\n");
						sql.append(" RSCH_COM1 = ?, 			\n");
						sql.append(" RSCH_COM2 = ?, 			\n");
						sql.append(" RSCH_COM3 = ?, 			\n");
						sql.append(" RSCH_COM4 = ?, 			\n");
						sql.append(" RSCH_COM5 = ?,				\n");
						//sql.append(" LOW_VAL = ?, 				\n");
						sql.append(" AVR_VAL = ?, 				\n");
						sql.append(" CENTER_VAL = ?,			\n");
						sql.append(" RSCH_T_DATE = SYSDATE		\n");
						sql.append(" WHERE RSCH_VAL_NO = ? 		\n");
						
						resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{
								foodVO.nu_no,
								rschValArr[0], rschValArr[1], rschValArr[2], rschValArr[3], rschValArr[4],
								rschLocArr[0], rschLocArr[1], rschLocArr[2], rschLocArr[3], rschLocArr[4],
								rschComArr[0], rschComArr[1], rschComArr[2], rschComArr[3], rschComArr[4],
								/* minVal, */ avgVal, midVal,
								foodVO.rsch_val_no
						});
	
						//이력 저장
						
						//이력 저장
					}
					
					if(resultCnt > 0){
						obj.put("resultMsg", "정상적으로 마감되었습니다.");
						obj.put("chkCode", "");
					}
					
				}//검토가 된 상태일 때 작동 end
				
				else{
					obj.put("resultMsg", "검토 후 마감가능합니다.");
					obj.put("chkCode", "");
				}
			}
			//검토
			else if(actType == 1){
				
				//조사자가 제출했을 당시의 데이터와 일치여부 확인
				sql		=	new StringBuffer();
				sql.append(" SELECT 									\n");
				sql.append(" COUNT(RSCH_VAL_NO) 						\n");
				sql.append(" FROM FOOD_RSCH_VAL 						\n");
				sql.append(" WHERE 										\n");
				
				if("".equals(rschValArr[0])){
					sql.append(" (RSCH_VAL1 = ? OR RSCH_VAL1 IS NULL)		\n");
				}
				else{
					sql.append(" RSCH_VAL1 = ? 							\n");
				}
				
				if("".equals(rschValArr[1])){
					sql.append(" AND (RSCH_VAL2 = ? OR RSCH_VAL2 IS NULL)	\n");
				}
				else{
					sql.append(" AND RSCH_VAL2 = ? 						\n");
				}
				
				if("".equals(rschValArr[2])){
					sql.append(" AND (RSCH_VAL3 = ? OR RSCH_VAL3 IS NULL)	\n");
				}		
				else{
					sql.append(" AND RSCH_VAL3 = ? 						\n");
				}
				
				if("".equals(rschValArr[3])){
					sql.append(" AND (RSCH_VAL4 = ? OR RSCH_VAL4 IS NULL)	\n");
				}
				else{
					sql.append(" AND RSCH_VAL4 = ? 						\n");
				}
				
				if("".equals(rschValArr[4])){
					sql.append(" AND (RSCH_VAL5 = ? OR RSCH_VAL5 IS NULL)	\n");
				}
				else{
					sql.append(" AND RSCH_VAL5 = ? 						\n");
				}
				
				sql.append(" AND RSCH_VAL_NO = ?						\n");
				sql.append(" AND (STS_FLAG = 'SR' OR STS_FLAG = 'RC')	\n");
				
				cnt		=	jdbcTemplate.queryForInt(sql.toString(), new Object[]{
						rschValArr[0], rschValArr[1], rschValArr[2], rschValArr[3], rschValArr[4], 
						foodVO.rsch_val_no
				});
				
				//제출당시의 데이터와 불일치 할 경우 최고/최저가 비율 등 재확인
				if(cnt == 0){
					//비교그룹이 빈값이 아닐 때
					if(!"".equals(dataVO.item_comp_no) && !"".equals(dataVO.item_comp_val)){
						
						//비교그룹순서 A의 데이터가 들어가있는지 확인한다.
						sql		=	new StringBuffer();
						sql.append(" SELECT 						\n");
						sql.append(" (SELECT 					 	\n");
						sql.append(" CAT_NM 					 	\n");
						sql.append(" FROM FOOD_ST_CAT			 	\n");
						sql.append(" WHERE CAT_NO = ITEM.CAT_NO) 	\n");
						sql.append(" AS CAT_NM,						\n");
						sql.append(" ITEM.FOOD_CAT_INDEX,		 	\n");
						sql.append(" PRE.ITEM_COMP_VAL,				\n");
						sql.append(" VAL.STS_FLAG, 					\n");
						sql.append(" VAL.AVR_VAL, 					\n");
						sql.append(" PRE.ITEM_NM 					\n");
						sql.append(" FROM FOOD_ITEM_PRE PRE 		\n");
						sql.append(" LEFT JOIN 						\n");
						sql.append(" FOOD_RSCH_VAL VAL 				\n");
						sql.append(" ON PRE.ITEM_NO = VAL.ITEM_NO 	\n");
						sql.append(" LEFT JOIN 						\n");
						sql.append(" FOOD_ST_ITEM ITEM 				\n");		
						sql.append(" ON ITEM.ITEM_NO = VAL.ITEM_NO	\n");		
						sql.append(" WHERE PRE.ITEM_COMP_NO = ?		\n");
						sql.append(" AND VAL.RSCH_NO = ?			\n");
						sql.append(" AND VAL.SCH_NO = (				\n");
						sql.append(" 	SELECT SCH_NO FROM			\n");
						sql.append(" 	FOOD_RSCH_VAL WHERE			\n");
						sql.append(" 	RSCH_VAL_NO = ?)			\n");
						sql.append(" ORDER BY PRE.ITEM_COMP_VAL 	\n");
							
						cList	=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{dataVO.item_comp_no, foodVO.rsch_no, foodVO.rsch_val_no});
					
						if(cList != null && cList.size() > 0){
							for(int i=0; i<cList.size(); i++){
								
								//비교그룹순서가 자기보다 낮은 알파뱃이 마감되었는지 확인
								if("SR".equals(cList.get(i).sts_flag) || "RC".equals(cList.get(i).sts_flag)){
									if(codeToNumber(dataVO.item_comp_val) > codeToNumber(cList.get(i).item_comp_val)){
										obj.put("resultMsg", cList.get(i).cat_nm + "-" + cList.get(i).food_cat_index + "부터 마감해주세요.");
										obj.put("chkCode", "");
										actChk	=	false;
										break;
									}
								}
								//비교그룹순서 대비 조사가 평균 비교
								else{
									if(!"".equals(cList.get(i).avr_val) && avgVal != 0){
										if(codeToNumber(dataVO.item_comp_val) > codeToNumber(cList.get(i).item_comp_val)){
											if(avgVal < Integer.parseInt(cList.get(i).avr_val)){
												obj.put("resultMsg", cList.get(i).cat_nm + "-" + cList.get(i).food_cat_index + " " + cList.get(i).item_nm + "의 보다 조사가가 낮습니다.");
												obj.put("chkCode", "");
												actChk	=	false;
												break;
											}
										}
									}
								}
							}
						}
					}
					
					if(actChk	==	true){
						//비유통, 비계절 둘다 아닐 때 start
						if(!"Y".equals(foodVO.non_season) && !"Y".equals(foodVO.non_distri)){
							
							//전월데이터 확인
							sql		=	new StringBuffer();
							sql.append(" SELECT 						\n");
							sql.append(" RSCH_NO 						\n");
							sql.append(" FROM FOOD_RSCH_TB				\n");
							sql.append(" WHERE RSCH_YEAR = ?			\n");
							sql.append(" AND RSCH_MONTH = ?				\n");
							sql.append(" AND STS_FLAG = 'Y'				\n");
							sql.append(" AND SHOW_FLAG = 'Y'			\n");
							sql.append(" AND ROWNUM = 1 				\n");						
							sql.append(" ORDER BY END_DATE DESC, 		\n");	
							sql.append(" RSCH_NO DESC					\n");
				
							try{
								preRschNo	=	jdbcTemplate.queryForObject(sql.toString(), String.class, new Object[]{
									preYear, preMonth
								});
							}catch(Exception e){
								preRschNo	=	"";
							}
							
							if(!"".equals(preRschNo)){
							
								sql		=	new StringBuffer();
								sql.append(" SELECT 														\n");
								sql.append(" VAL.AVR_VAL,													\n");
								sql.append(" VAL.RSCH_VAL_NO												\n");
								sql.append(" FROM FOOD_RSCH_VAL VAL 										\n");
								sql.append(" LEFT JOIN FOOD_RSCH_TB TB ON VAL.RSCH_NO = TB.RSCH_NO			\n");
								sql.append(" WHERE TB.RSCH_NO = ? AND VAL.ITEM_NO = ?						\n");
								sql.append(" ORDER BY END_DATE DESC											\n");
								try{
									preDataVO	=	jdbcTemplate.queryForObject(sql.toString(), new FoodList(), new Object[]{
											preRschNo, dataVO.item_no
									});
									
								}catch(Exception e){
									preDataVO	=	new FoodVO();
								}
							}
							//전월 데이터가 있을 경우
							if(preDataVO != null && preDataVO.avr_val != null && !"".equals(preDataVO.avr_val)){
								//전월 평균가와 비교
								
								highNLowAvr	=	(int)(Integer.parseInt(preDataVO.avr_val) * (Integer.parseInt(dataVO.avr_ratio) / 100.0));
								if((Integer.parseInt(preDataVO.avr_val) + highNLowAvr) <= avgVal ||
										((Integer.parseInt(preDataVO.avr_val) - highNLowAvr) >= avgVal)){
									resultMsg	=	appendComma(resultMsg, "전월대비 조사가(평균가) 차이가 " + Integer.parseInt(dataVO.avr_ratio) + "% 이상입니다." + (Integer.parseInt(preDataVO.avr_val) + highNLowAvr));
									returnType	=	appendComma(returnType, "2");
									obj.put("resultMsg", resultMsg);
									obj.put("chkCode", returnType);
									actChk		=	false;
								}
								/* 
								//전월 최저가와 비교
								highNLowMin	=	(int)(Integer.parseInt(preDataVO.low_val) * (Integer.parseInt(dataVO.low_ratio) / 100.0));
								highNLowAvr	=	(int)(Integer.parseInt(preDataVO.avr_val) * (Integer.parseInt(dataVO.avr_ratio) / 100.0));
								
								if((Integer.parseInt(preDataVO.low_val) + highNLow) > minVal || 
										((Integer.parseInt(preDataVO.low_val) - highNLow) < minVal )){
									resultMsg	=	appendComma(resultMsg, "전월 최저가 비율보다 " + Integer.parseInt(dataVO.low_ratio) + "% 미만 또는 초과입니다.");
									returnType	=	appendComma(returnType, "1");
									obj.put("resultMsg", resultMsg);
									obj.put("chkCode", returnType);
									actChk		=	false;	
								}
														
								//전월 평균가와 비교
								else if((Integer.parseInt(preDataVO.avr_val) + highNLow) > avgVal ||
										((Integer.parseInt(preDataVO.avr_val) - highNLow) < avgVal)){
									resultMsg	=	appendComma(resultMsg, "전월 평균가 비율보다 " + Integer.parseInt(dataVO.avr_ratio) + "% 미만 또는 초과입니다.");
									returnType	=	appendComma(returnType, "2");
									obj.put("resultMsg", resultMsg);
									obj.put("chkCode", returnType);
									actChk		=	false;
								}
								 */
							}
							
							//최저,최고값 비율
							highNLow	=	(int)(maxVal * (Integer.parseInt(dataVO.lb_ratio) / 100.0));
							if((maxVal - highNLow) >= minVal){
								resultMsg	=	appendComma(resultMsg, "최저값이 최고값의 " + Integer.parseInt(dataVO.lb_ratio) + "% 보다 낮습니다.");
								returnType	=	appendComma(returnType, "3");
								obj.put("resultMsg", resultMsg);
								obj.put("chkCode", returnType);
								actChk		=	false;
							}
						}//비유통, 비계절 둘다 아닐 때 end
					}
					
					if(actChk){
						
						//비계절일 때
						if("Y".equals(foodVO.non_season)){
							sql		=	new StringBuffer();
							sql.append(" UPDATE FOOD_RSCH_VAL SET 	\n");
							sql.append(" STS_FLAG = 'RC', 			\n");
							sql.append(" NON_SEASON = 'Y', 			\n");
							sql.append(" NON_DISTRI = 'N', 			\n");
							sql.append(" RSCH_VAL1 = '', 			\n");
							sql.append(" RSCH_VAL2 = '', 			\n");
							sql.append(" RSCH_VAL3 = '', 			\n");
							sql.append(" RSCH_VAL4 = '', 			\n");
							sql.append(" RSCH_VAL5 = '', 			\n");
							sql.append(" RSCH_LOC1 = '', 			\n");
							sql.append(" RSCH_LOC2 = '', 			\n");
							sql.append(" RSCH_LOC3 = '', 			\n");
							sql.append(" RSCH_LOC4 = '', 			\n");
							sql.append(" RSCH_LOC5 = '', 			\n");
							sql.append(" RSCH_COM1 = '', 			\n");
							sql.append(" RSCH_COM2 = '', 			\n");
							sql.append(" RSCH_COM3 = '', 			\n");
							sql.append(" RSCH_COM4 = '', 			\n");
							sql.append(" RSCH_COM5 = '', 			\n");
							sql.append(" NU_NO	 = ?,	 			\n");
							sql.append(" RSCH_T_DATE = SYSDATE		\n");
							sql.append(" WHERE RSCH_VAL_NO = ? 		\n");
							
							resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{
									foodVO.nu_no, foodVO.rsch_val_no
							}); 
						}
						
						//비유통일 때
						else if("Y".equals(foodVO.non_distri)){
							
							sql		=	new StringBuffer();
							sql.append(" UPDATE FOOD_RSCH_VAL SET 	\n");
							sql.append(" STS_FLAG = 'RC', 			\n");
							sql.append(" NON_SEASON = 'N', 			\n");
							sql.append(" NON_DISTRI = 'Y', 			\n");
							sql.append(" RSCH_VAL1 = '', 			\n");
							sql.append(" RSCH_VAL2 = '', 			\n");
							sql.append(" RSCH_VAL3 = '', 			\n");
							sql.append(" RSCH_VAL4 = '', 			\n");
							sql.append(" RSCH_VAL5 = '', 			\n");
							sql.append(" RSCH_LOC1 = '', 			\n");
							sql.append(" RSCH_LOC2 = '', 			\n");
							sql.append(" RSCH_LOC3 = '', 			\n");
							sql.append(" RSCH_LOC4 = '', 			\n");
							sql.append(" RSCH_LOC5 = '', 			\n");
							sql.append(" RSCH_COM1 = '', 			\n");
							sql.append(" RSCH_COM2 = '', 			\n");
							sql.append(" RSCH_COM3 = '', 			\n");
							sql.append(" RSCH_COM4 = '', 			\n");
							sql.append(" RSCH_COM5 = '', 			\n");
							sql.append(" NU_NO	 = ?,	 			\n");
							sql.append(" RSCH_T_DATE = SYSDATE		\n");
							sql.append(" WHERE RSCH_VAL_NO = ? 		\n");
							
							resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{
									foodVO.nu_no, foodVO.rsch_val_no
							}); 
						}
							
						//비유통, 비계절 둘다 아닐 때 start
						else{
							sql		=	new StringBuffer();
							sql.append(" UPDATE FOOD_RSCH_VAL SET 	\n");
							sql.append(" STS_FLAG = 'RC', 			\n");
							sql.append(" NON_SEASON = 'N', 			\n");
							sql.append(" NON_DISTRI = 'N', 			\n");
							sql.append(" RSCH_VAL1 = ?, 			\n");
							sql.append(" RSCH_VAL2 = ?, 			\n");
							sql.append(" RSCH_VAL3 = ?, 			\n");
							sql.append(" RSCH_VAL4 = ?, 			\n");
							sql.append(" RSCH_VAL5 = ?, 			\n");
							sql.append(" RSCH_LOC1 = ?, 			\n");
							sql.append(" RSCH_LOC2 = ?, 			\n");
							sql.append(" RSCH_LOC3 = ?, 			\n");
							sql.append(" RSCH_LOC4 = ?, 			\n");
							sql.append(" RSCH_LOC5 = ?, 			\n");
							sql.append(" RSCH_COM1 = ?, 			\n");
							sql.append(" RSCH_COM2 = ?, 			\n");
							sql.append(" RSCH_COM3 = ?, 			\n");
							sql.append(" RSCH_COM4 = ?, 			\n");
							sql.append(" RSCH_COM5 = ?,	 			\n");
							sql.append(" NU_NO	 = ?,	 			\n");
							sql.append(" RSCH_T_DATE = SYSDATE		\n");
							sql.append(" WHERE RSCH_VAL_NO = ? 		\n");
							
							resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{
									rschValArr[0], rschValArr[1], rschValArr[2], rschValArr[3], rschValArr[4],
									rschLocArr[0], rschLocArr[1], rschLocArr[2], rschLocArr[3], rschLocArr[4],
									rschComArr[0], rschComArr[1], rschComArr[2], rschComArr[3], rschComArr[4],
									foodVO.nu_no, foodVO.rsch_val_no
							}); 
						}
						
						if(resultCnt > 0){
							obj.put("resultMsg", "검토 완료되었습니다. 마감버튼을 클릭해주세요.");
							obj.put("chkCode", "");
						}else{
							obj.put("resultMsg", "검토에 오류가 발생하였습니다. 관리자게에 문의해주세요.");
							obj.put("chkCode", "");
						}
					}
				}
				
				//제출당시와 값의 변화가 없을시 바로 검토
				else{
					
					//비교그룹이 빈값이 아닐 때
					if(!"".equals(dataVO.item_comp_no) && !"".equals(dataVO.item_comp_val)){
						
						//비교그룹순서 A의 데이터가 들어가있는지 확인한다.
						sql		=	new StringBuffer();
						sql.append(" SELECT 						\n");
						sql.append(" (SELECT 					 	\n");
						sql.append(" CAT_NM 					 	\n");
						sql.append(" FROM FOOD_ST_CAT			 	\n");
						sql.append(" WHERE CAT_NO = ITEM.CAT_NO) 	\n");
						sql.append(" AS CAT_NM,						\n");
						sql.append(" ITEM.FOOD_CAT_INDEX,		 	\n");
						sql.append(" PRE.ITEM_COMP_VAL,				\n");
						sql.append(" VAL.STS_FLAG, 					\n");
						sql.append(" VAL.AVR_VAL 					\n");
						sql.append(" FROM FOOD_ITEM_PRE PRE 		\n");
						sql.append(" LEFT JOIN 						\n");
						sql.append(" FOOD_RSCH_VAL VAL 				\n");
						sql.append(" ON PRE.ITEM_NO = VAL.ITEM_NO 	\n");
						sql.append(" LEFT JOIN 						\n");
						sql.append(" FOOD_ST_ITEM ITEM 				\n");		
						sql.append(" ON ITEM.ITEM_NO = VAL.ITEM_NO	\n");		
						sql.append(" WHERE PRE.ITEM_COMP_NO = ?		\n");
						sql.append(" AND VAL.RSCH_NO = ?			\n");
						sql.append(" AND VAL.SCH_NO = ?				\n");
						sql.append(" ORDER BY PRE.ITEM_COMP_VAL 	\n");	
							
						cList	=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{dataVO.item_comp_no, foodVO.rsch_no, foodVO.sch_no});
					
						if(cList != null && cList.size() > 0){
							for(int i=0; i<cList.size(); i++){
								
								//비교그룹순서가 자기보다 낮은 알파뱃이 마감되었는지 확인
								if("SR".equals(cList.get(i).sts_flag) || "RC".equals(cList.get(i).sts_flag)){
									if(codeToNumber(dataVO.item_comp_val) > codeToNumber(cList.get(i).item_comp_val)){
										obj.put("resultMsg", cList.get(i).cat_nm + "-" + cList.get(i).food_cat_index + "부터 마감해주세요.");
										obj.put("chkCode", "");
										actChk	=	false;
										break;
									}
								}
							}
						}
					}
					
					if(actChk == true){
						sql		=	new StringBuffer();
						sql.append(" UPDATE FOOD_RSCH_VAL SET 	\n");
						sql.append(" STS_FLAG = 'RC', 			\n");
						sql.append(" RSCH_T_DATE = SYSDATE 		\n");
						sql.append(" WHERE RSCH_VAL_NO = ? 		\n");
						
						resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{
								foodVO.rsch_val_no	
						});
						
						obj.put("resultMsg", "검토 완료되었습니다. 마감버튼을 클릭해주세요.");
						obj.put("chkCode", "");
					}
				}
			}
			
			//재검토 (검토당시의 데이터와 제출시의 데이터 일치 여부)
			else if(actType == 2){
			
				sql		=	new StringBuffer();
				sql.append(" SELECT 									\n");
				sql.append(" COUNT(RSCH_VAL_NO) 						\n");
				sql.append(" FROM FOOD_RSCH_VAL 						\n");
				sql.append(" WHERE 										\n");
				
				if("".equals(rschValArr[0])){
					sql.append(" (RSCH_VAL1 = ? OR RSCH_VAL1 IS NULL)		\n");
				}
				else{
					sql.append(" RSCH_VAL1 = ? 							\n");
				}
				
				if("".equals(rschValArr[1])){
					sql.append(" AND (RSCH_VAL2 = ? OR RSCH_VAL2 IS NULL)	\n");
				}
				else{
					sql.append(" AND RSCH_VAL2 = ? 						\n");
				}
				
				if("".equals(rschValArr[2])){
					sql.append(" AND (RSCH_VAL3 = ? OR RSCH_VAL3 IS NULL)	\n");
				}		
				else{
					sql.append(" AND RSCH_VAL3 = ? 						\n");
				}
				
				if("".equals(rschValArr[3])){
					sql.append(" AND (RSCH_VAL4 = ? OR RSCH_VAL4 IS NULL)	\n");
				}
				else{
					sql.append(" AND RSCH_VAL4 = ? 						\n");
				}
				
				if("".equals(rschValArr[4])){
					sql.append(" AND (RSCH_VAL5 = ? OR RSCH_VAL5 IS NULL)	\n");
				}
				else{
					sql.append(" AND RSCH_VAL5 = ? 						\n");
				}
				
				sql.append(" AND RSCH_VAL_NO = ?						\n");
				sql.append(" AND STS_FLAG = 'RC'						\n");
				
				cnt		=	jdbcTemplate.queryForInt(sql.toString(), new Object[]{
						rschValArr[0], rschValArr[1], rschValArr[2], rschValArr[3], rschValArr[4], 
						foodVO.rsch_val_no
				});
				
				if(cnt == 0){
					obj.put("resultMsg", "검토 당시의 데이터와 일치하지 않습니다. 재검토 해주시기 바랍니다.");
				}
			}
			
			//반려
			else if(actType == 3){
				if(!"".equals(dataVO.item_comp_no) && !"".equals(dataVO.item_comp_val)){
					sql		=	new StringBuffer();
					sql.append(" SELECT  						\n");
					sql.append(" VAL.RSCH_VAL_NO				\n");
					sql.append(" FROM FOOD_RSCH_VAL VAL 		\n");
					sql.append(" LEFT JOIN  					\n");
					sql.append(" FOOD_ITEM_PRE PRE 				\n");
					sql.append(" ON VAL.ITEM_NO = PRE.ITEM_NO 	\n");
					sql.append(" WHERE PRE.ITEM_COMP_NO = ?	 	\n");
					//sql.append(" AND (VAL.STS_FLAG = 'SR' OR	\n");
					//sql.append(" VAL.STS_FLAG = 'RC')		 	\n");
					
					rList	=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{
							dataVO.item_comp_no
					});
					
					sql		=	new StringBuffer();
					sql.append(" UPDATE FOOD_RSCH_VAL SET 		\n");
					sql.append(" STS_FLAG = 'RT', 				\n");
					sql.append(" T_RJ_REASON = ?, 				\n");
					sql.append(" RJ_DATE = SYSDATE				\n");
					sql.append(" , RT_IP = ?					\n");
					sql.append(" , RT_ID = ?					\n");
					sql.append(" WHERE RSCH_VAL_NO = ? 			\n");
					sql.append(" AND ZONE_NO = ?				\n");
					sql.append(" AND TEAM_NO = ?				\n");
					sql.append(" AND RSCH_NO = ?				\n");
					pstmt = conn.prepareStatement(sql.toString());
					for(int i=0; i<rList.size(); i++){
						key = 0;
						pstmt.setString(++key,  foodVO.t_rj_reason);
						pstmt.setString(++key,  rt_ip);
						pstmt.setString(++key, 	sManager.getId());
						pstmt.setString(++key,  foodVO.zone_no);
						pstmt.setString(++key,  foodVO.team_no);
						pstmt.setString(++key,  rList.get(i).rsch_val_no);
						pstmt.setString(++key, foodVO.rsch_no);
						pstmt.addBatch();
					}
					
					batchSuccess	=	null;
					batchSuccess	=	pstmt.executeBatch();
					if(pstmt!=null){pstmt.close();}
					
					if(batchSuccess.length > 0){
						obj.put("resultMsg", "정상적으로 반려되었습니다.");
						obj.put("chkCode", "");
					}else{
						obj.put("resultMsg", "반려중 오류가 발생하였습니다. 관리자에게 문의하세요.");
						obj.put("chkCode", "");
					}

					/* batchList	=	new ArrayList<Object[]>();
					
					for(int i=0; i<rList.size(); i++){
						Object[] ob	=	new Object[]{foodVO.t_rj_reason, rList.get(i).rsch_val_no};
						batchList.add(ob);
					}
					
					batchSuccess	=	null;
					batchSuccess	=	jdbcTemplate.batchUpdate(sql.toString(), batchList); */
				} else {
					sql		=	new StringBuffer();
					sql.append(" UPDATE FOOD_RSCH_VAL SET 		\n");
					sql.append(" STS_FLAG = 'RT', 				\n");
					sql.append(" T_RJ_REASON = ?, 				\n");
					sql.append(" RJ_DATE = SYSDATE				\n");
					sql.append(" , RT_IP = ?					\n");
					sql.append(" , RT_ID = ?					\n");
					sql.append(" WHERE RSCH_VAL_NO = ? 			\n");
					sql.append(" AND ZONE_NO = ?				\n");
					sql.append(" AND TEAM_NO = ?				\n");
					sql.append(" AND RSCH_NO = ?				\n");
					
					resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{
							foodVO.t_rj_reason
							, rt_ip
							, sManager.getId()
							, foodVO.zone_no
							, foodVO.team_no
							, foodVO.rsch_no
							});
					
					if(resultCnt > 0){
						obj.put("resultMsg", "정상적으로 반려되었습니다.");
						obj.put("chkCode", "");
					}else{
						obj.put("resultMsg", "반려중 오류가 발생하였습니다. 관리자에게 문의하세요.");
						obj.put("chkCode", "");
					}
				}				
			}
			//그외의 actType
			else{
				obj.put("resultMsg", "잘못된 액션타입입니다.");
				obj.put("chkCode", "");
			}
			
		}//조사팀장 end

	}catch(Exception e){
		if(actType == 0)		obj.put("resultMsg", "0");
		else if(actType	== 1)	obj.put("resultMsg", "1");
		else if(actType == 2)	obj.put("resultMsg", "2");
		else if(actType == 3)	obj.put("resultMsg", "3");
		
	}finally{
		if("R".equals(foodVO.sch_grade)){		//조사자일 때
			out.print(obj);
			
		}else if("T".equals(foodVO.sch_grade)){	//조사팀장일 때
			out.print(obj);
		}
		if(pstmt!=null){pstmt.close();}
		if(conn!=null){conn.close();}
		sqlMapClient.endTransaction();

	}
%>
<%}%>