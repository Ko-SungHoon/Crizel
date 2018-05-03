<%
/**
*   PURPOSE :   구분 - 액션
*   CREATE  :   20180322_thu    Ko
*   MODIFY  :   단위 삭제 시 사용여부 확인 후 삭제    20180323_fri    JI
*   MODIFY  :   화폐 단위는 수정 불가 및 타입 수정 불가    20180323_fri    JI
*	MODIFY  :   batch 방식 변경 20180424_tue    KO
*	MODIFY	:	20180502_wed	JI	아이템 추가 및 아이템 수정
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ page import="org.springframework.jdbc.core.*" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%!

	private List<String> splitComma (String splitString) {
		String[] retArr	=	splitString.split(",");
		List<String> retList	=	new ArrayList<String>(retArr.length);
		if (retArr != null && retArr.length > 0) {
			for (String val: retArr) {
				retList.add(val.trim());
			}
		} else {
			retList	=	null;
		}
		return retList;
	}

%>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

String mode				= parseNull(request.getParameter("mode"));           //처리 구분

String cat_no           = parseNull(request.getParameter("cat_no"));         //구분 번호
String cat_nm			= parseNull(request.getParameter("cat_nm"));         //식품구분명
String show_flag		= parseNull(request.getParameter("show_flag"), "Y"); //노출여부
String unit_no			= parseNull(request.getParameter("unit_no"));        //단위 번호
String unit_val			= parseNull(request.getParameter("unit_val"));       //단위 수치
String unit_nm			= parseNull(request.getParameter("unit_nm"));        //단위 명
String unit_type		= parseNull(request.getParameter("unit_type"));      //P=화폐, F=식품

String item_no			=	parseNull(request.getParameter("item_no"));		//식품 번호
String food_code		=	parseNull(request.getParameter("food_code"));	//식품코드
String nm_food			=	parseNull(request.getParameter("nm_food"));		//식품명
String dt_nm			=	parseNull(request.getParameter("dt_nm"));		//상세식품명
String ex_nm			=	parseNull(request.getParameter("ex_nm"));		//식품설명
String low_ratio		=	parseNull(request.getParameter("low_ratio"));	//최저가 비율
String avr_ratio		=	parseNull(request.getParameter("avr_ratio"));	//평균가 비율
String lb_ratio			=	parseNull(request.getParameter("lb_ratio"));	//최저/최고 비율

out.println("mode : " + mode);
out.println("nm_food : " + nm_food);

String[] unit_nm_arr 	= request.getParameterValues("unit_nm_arr");
String[] unit_no_arr 	= request.getParameterValues("unit_no_arr");
//String[] unit_type_arr 	= request.getParameterValues("unit_type_arr");

/*새로운 이름*/
List<Object[]> batch 		=	null;
Object[] batchData			=	null;
int[] batchResult			=	null;
List<String> nm_food_arc	=	null;
List<String> dt_nm_arc		=	null;
List<String> ex_nm_arc		=	null;

List<Object> setValue		=	null;
Object[] setObject			=	null;

Connection conn 		= null;
PreparedStatement pstmt = null;
StringBuffer sql 		= null;
int result 				= 0;
int key					= 0;

int temp_item_no	=	0;
int st_nm_no		=	0;
int st_dt_nm_no		=	0;
int st_ex_no		=	0;
int st_unit_no		=	0;

try{
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

/** CAT PART **/
	if("catInsert".equals(mode)){
		sql = new StringBuffer();
		sql.append("INSERT INTO FOOD_ST_CAT(													");
		sql.append("	CAT_NO, CAT_NM, REG_DATE, MOD_DATE, SHOW_FLAG, UNIT_VAL					");
		sql.append(")																			");
		sql.append("VALUES(																		");
		sql.append("	(SELECT NVL(MAX(CAT_NO)+1, 1) FROM FOOD_ST_CAT )						");
		sql.append("	, ?																		");
		sql.append("	, SYSDATE																");
		sql.append("	, SYSDATE																");
		sql.append("	, ?																		");
		sql.append("	, 50																	");
		sql.append(")																			");
		result = jdbcTemplate.update(sql.toString(), cat_nm, show_flag);
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_cat_popup.jsp');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}
	}
	//구분 노출, 숨김(소속 식품이 있는 지 확인 후 숨김 처리)
    else if("catDelete".equals(mode)){
        
        int cat_food_cnt    =   0;
        //숨김. 소속 식품 확인해야 함.
        if ("N".equals(show_flag)) {
            sql =   new StringBuffer();
            sql.append("SELECT NVL(COUNT(*), 0) FROM FOOD_ST_ITEM WHERE CAT_NO = ? AND SHOW_FLAG = 'Y' ");
            cat_food_cnt    =   jdbcTemplate.queryForObject(sql.toString(), new Object[]{cat_no}, Integer.class);
        }
        if ("N".equals(show_flag) && cat_food_cnt > 0) {
            out.println("<script>");
            out.println("alert('등록된 식품이 있어 숨김처리 할 수 없습니다. 다시한번 확인하세요.');");
            out.println("location.replace('food_cat_popup.jsp');");
            out.println("opener.location.reload();");
            out.println("</script>");
        } else {
            sql =   new StringBuffer();
            sql.append("UPDATE FOOD_ST_CAT SET SHOW_FLAG = ? WHERE CAT_NO = ? ");
            result  =   jdbcTemplate.update(sql.toString(), show_flag, cat_no);
            if (result>0) {
                out.println("<script>");
                out.println("alert('정상적으로 처리되었습니다.');");
                out.println("location.replace('food_cat_popup.jsp');");
                out.println("opener.location.reload();");
                out.println("</script>");
            }//END IF
        }
        
    }
    //구분. 정보 업데이트
    else if("catUpdate".equals(mode)){
                
        sql =   new StringBuffer();
        sql.append("UPDATE FOOD_ST_CAT SET ");
        sql.append(" CAT_NM = ? ");
        /*sql.append(" , UNIT_NO = ? ");
        sql.append(" , UNIT_VAL = ? ");*/
        sql.append(" , MOD_DATE = SYSDATE ");
        sql.append(" WHERE CAT_NO = ? ");
        result  =   jdbcTemplate.update(sql.toString(), cat_nm, /*unit_no, unit_val,*/ cat_no);
        if (result > 0) {
            out.println("<script>");
            out.println("alert('정상적으로 처리되었습니다.');");
            out.println("location.replace('food_cat_popup.jsp');");
            out.println("opener.location.reload();");
            out.println("</script>");
        } else {
            out.println(sql.toString());
        }
    }
/** END CAT PART **/
/** UNIT PART **/
	//단위 등록
	else if("unitInsert".equals(mode)){
		sql = new StringBuffer();
		sql.append("INSERT INTO FOOD_ST_UNIT(												");
		sql.append("	UNIT_NO, UNIT_NM, UNIT_TYPE, SHOW_FLAG, REG_DATE, MOD_DATE			");
		sql.append(")																		");
		sql.append("VALUES(																	");
		sql.append("	(SELECT NVL(MAX(UNIT_NO)+1, 1) FROM FOOD_ST_UNIT )					");
		sql.append("	, ?																	");
		sql.append("	, ?																	");
		sql.append("	, ?																	");
		sql.append("	, SYSDATE															");
		sql.append("	, SYSDATE															");
		sql.append(")																		");
		result = jdbcTemplate.update(sql.toString(), unit_nm, unit_type, show_flag);
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_unit_popup.jsp');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}
	}else if("unitUpdate".equals(mode)){
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_ST_UNIT SET	");
		sql.append("	  UNIT_NM = ?		");
		//sql.append("	, UNIT_TYPE = ?		");
		sql.append("WHERE UNIT_NO = ?		");
		
		pstmt = conn.prepareStatement(sql.toString());
		if(unit_no_arr!=null){
			for(int i=0; i<unit_no_arr.length; i++){
				key = 0;
				pstmt.setString(++key,  unit_nm_arr[i]);
				pstmt.setString(++key,  unit_no_arr[i]);
				pstmt.addBatch();
			}
		}
		batchResult = pstmt.executeBatch();
		if(pstmt!=null){pstmt.close();}
		
		/* List<Object[]> batch = new ArrayList<Object[]>();
		if(unit_no_arr!=null){
			for(int i=0; i<unit_no_arr.length; i++){
				Object[] value = new Object[]{
						unit_nm_arr[i],
						//unit_type_arr[i],
						unit_no_arr[i]
				};
				batch.add(value);
			}
		}
		int[] batchResult = jdbcTemplate.batchUpdate(sql.toString(), batch); */
		result = batchResult.length;
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("window.close();");
			out.println("opener.location.reload();");
			out.println("</script>");
		}
	}else if("unitDelete".equals(mode)){
        
        int unit_cnt    =   0;
        sql =   new StringBuffer();
        sql.append("SELECT NVL(COUNT(*), 0) FROM FOOD_ST_CAT WHERE UNIT_NO = ? ");
        unit_cnt    =   jdbcTemplate.queryForObject(sql.toString(), new Object[]{unit_no}, Integer.class);
        
        if (unit_cnt > 0) {
            out.println("<script>");
			out.println("alert('해당 단위는 사용 중이라 삭제 할 수 없습니다.');");
			out.println("location.replace('food_unit_popup.jsp');");
			out.println("opener.location.reload();");
			out.println("</script>");
			sqlMapClient.endTransaction();
            return;
        }
        
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_ST_UNIT SET		");
		sql.append("	SHOW_FLAG = 'N'			");
		sql.append("WHERE UNIT_NO = ?			");
		result = jdbcTemplate.update(sql.toString(), unit_no);
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_unit_popup.jsp');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}
///////////////////////////////////////////////////////////////////////////////////////////
	//식품 추가
	}else if("itemInsert".equals(mode)){

		//0th. 식품명, 상세식품명, 식품설명 "," 로 자르기
		nm_food_arc		=	new ArrayList<String>();
		nm_food_arc		=	splitComma(nm_food);
		dt_nm_arc		=	new ArrayList<String>();
		dt_nm_arc		=	splitComma(dt_nm);
		ex_nm_arc		=	new ArrayList<String>();
		ex_nm_arc		=	splitComma(ex_nm);
		//1st. 신규 식품명 조회
		sql	=	new StringBuffer();
		sql.append(" SELECT NVL(MAX(NM_NO)+1, 1) FROM FOOD_ST_NM ");
		st_nm_no	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class);

		//1-1st. 신규일 경우 등록
		sql	=	new StringBuffer();
		sql.append(" MERGE INTO FOOD_ST_NM USING DUAL								");
		sql.append(" 	ON(NM_FOOD = ?)												");	//NM_FOOD
		sql.append(" 	WHEN NOT MATCHED THEN										");
		sql.append(" 		INSERT(													");
		sql.append(" 			NM_NO, CAT_NO, NM_FOOD, SHOW_FLAG, REG_DATE 		");
		sql.append(" 		) VALUES (												");
		sql.append(" 			?,													");	//NM_NO
		sql.append(" 			?,													");	//CAT_NO
		sql.append(" 			?, 'Y', SYSDATE										");	//NM_FOOD, SHOW_FLAG, REG_DATE
		sql.append(" 		)														");
		pstmt = conn.prepareStatement(sql.toString());
		if (nm_food_arc != null && nm_food_arc.size() > 0) {
			for (int i = 0; i < nm_food_arc.size(); i++) {
				key = 0;
				pstmt.setString(++key,  nm_food_arc.get(i).trim());
				pstmt.setInt(++key,  st_nm_no++);
				pstmt.setString(++key,  cat_nm);
				pstmt.setString(++key,  nm_food_arc.get(i).trim());
				pstmt.addBatch();
			}
		}
		batchResult	=	pstmt.executeBatch();
		if(pstmt!=null){pstmt.close();}

		//2nd. 신규 상세식품명 조회
		sql	=	new StringBuffer();
		sql.append(" SELECT NVL(MAX(DT_NO)+1, 1) FROM FOOD_ST_DT_NM ");
		st_dt_nm_no	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class);
		//2-1st. 신규일 경우 등록
		sql	=	new StringBuffer();
		sql.append(" MERGE INTO FOOD_ST_DT_NM USING DUAL								");
		sql.append(" 	ON (DT_NM = ?)													");
		sql.append(" 	WHEN NOT MATCHED THEN											");
		sql.append(" 		INSERT (													");
		sql.append(" 			DT_NO, CAT_NO, DT_NM, SHOW_FLAG, REG_DATE				");
		sql.append(" 		) VALUES (													");
		sql.append(" 			?, 														");
		sql.append(" 			?,														");
		sql.append(" 			?, 'Y', SYSDATE											");
		sql.append(" 		)															");
		pstmt = conn.prepareStatement(sql.toString());
		if (dt_nm_arc != null && dt_nm_arc.size() > 0) {
			for (int i = 0; i < dt_nm_arc.size(); i++) {
				key = 0;
				pstmt.setString(++key,  dt_nm_arc.get(i).trim());
				pstmt.setInt(++key,  st_dt_nm_no++);
				pstmt.setString(++key,  cat_nm);
				pstmt.setString(++key,  dt_nm_arc.get(i).trim());
				pstmt.addBatch();
			}
		}
		batchResult	=	pstmt.executeBatch();
		if(pstmt!=null){pstmt.close();}

		//3rd. 신규 식품설명 조회
		sql	=	new StringBuffer();
		sql.append(" SELECT NVL(MAX(EX_NO)+1, 1) FROM FOOD_ST_EXPL ");
		st_ex_no	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class);
		//3-1st. 신규일 경우 등록
		sql	=	new StringBuffer();
		sql.append(" MERGE INTO FOOD_ST_EXPL USING DUAL							");
		sql.append(" 	ON (EX_NM = ?)											");
		sql.append(" 	WHEN NOT MATCHED THEN									");
		sql.append(" 		INSERT (											");
		sql.append(" 			EX_NO, CAT_NO, EX_NM, SHOW_FLAG, REG_DATE		");
		sql.append(" 		) VALUES (											");
		sql.append(" 		?,													");
		sql.append(" 		?,													");
		sql.append(" 		?, 'Y', SYSDATE										");
		sql.append(" 		)													");
		pstmt = conn.prepareStatement(sql.toString());
		if (ex_nm_arc != null && ex_nm_arc.size() > 0) {
			for (int i = 0; i < ex_nm_arc.size(); i++) {
				key = 0;
				pstmt.setString(++key,  ex_nm_arc.get(i).trim());
				pstmt.setInt(++key,  st_ex_no++);
				pstmt.setString(++key,  cat_nm);
				pstmt.setString(++key,  ex_nm_arc.get(i).trim());
				pstmt.addBatch();
			}
		}
		batchResult	=	pstmt.executeBatch();
		if(pstmt!=null){pstmt.close();}

		//6th. 품목구분별 마지막 번호 추출 및 신규 등록
		sql	=	new StringBuffer();
		sql.append(" INSERT INTO FOOD_ST_ITEM (									");
		sql.append("	ITEM_NO,												");
		sql.append("	CAT_NO,													");
		sql.append("	FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5,	");
		sql.append("	FOOD_UNIT,												");
		sql.append("	FOOD_DT_1 , FOOD_DT_2 , FOOD_DT_3 , FOOD_DT_4, 			");
		sql.append("	FOOD_DT_5 , FOOD_DT_6 , FOOD_DT_7, FOOD_DT_8,  			");
		sql.append("	FOOD_DT_9 , FOOD_DT_10, 								");
		sql.append("	FOOD_EP_1 , FOOD_EP_2 , FOOD_EP_3 , FOOD_EP_4, 			");
		sql.append("	FOOD_EP_5 , FOOD_EP_6 , FOOD_EP_7 , FOOD_EP_8, 			");
		sql.append("	FOOD_EP_9 , FOOD_EP_10 , FOOD_EP_11 , FOOD_EP_12, 		");
		sql.append("	FOOD_EP_13 , FOOD_EP_14 , FOOD_EP_15 , FOOD_EP_16,	 	");
		sql.append("	FOOD_EP_17 , FOOD_EP_18 , FOOD_EP_19 , FOOD_EP_20,	 	");
		sql.append("	FOOD_EP_21 , FOOD_EP_22 , FOOD_EP_23 , FOOD_EP_24,	 	");
		sql.append("	FOOD_EP_25, 											");
		sql.append("	FOOD_CODE, 												");
		sql.append("	REG_DATE,	 											");
		sql.append("	SHOW_FLAG,	 											");
		sql.append("	FOOD_CAT_INDEX											");
		sql.append(" ) VALUES (													");

		sql.append("	(SELECT NVL(MAX(ITEM_NO)+1, 1) FROM FOOD_ST_ITEM)		");	// ITEM_NO
		sql.append("	, ?														");	// CAT_NO
		sql.append("	, (SELECT NM_NO FROM FOOD_ST_NM WHERE NM_FOOD = ?)		"); // FOOD_NM_1
		sql.append("	, (SELECT NM_NO FROM FOOD_ST_NM WHERE NM_FOOD = ?)		"); // FOOD_NM_2
		sql.append("	, (SELECT NM_NO FROM FOOD_ST_NM WHERE NM_FOOD = ?)		"); // FOOD_NM_3
		sql.append("	, (SELECT NM_NO FROM FOOD_ST_NM WHERE NM_FOOD = ?)		"); // FOOD_NM_4
		sql.append("	, (SELECT NM_NO FROM FOOD_ST_NM WHERE NM_FOOD = ?)		"); // FOOD_NM_5
		sql.append("	, ?														");	// FOOD_UNIT
		sql.append("	, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");	// FOOD_DT 1
		sql.append("	, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");	// FOOD_DT 2
		sql.append("	, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");	// FOOD_DT 3
		sql.append("	, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");	// FOOD_DT 4
		sql.append("	, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");	// FOOD_DT 5
		sql.append("	, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");	// FOOD_DT 6
		sql.append("	, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");	// FOOD_DT 7
		sql.append("	, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");	// FOOD_DT 8
		sql.append("	, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");	// FOOD_DT 9
		sql.append("	, (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)		");	// FOOD_DT 10
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_1
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_2
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_3
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_4
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_5
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_6
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_7
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_8
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_9
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_10
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_11
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_12
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_13
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_14
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_15
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_16
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_17
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_18
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_19
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_20
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_21
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_22
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_23
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_24
		sql.append("	, (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");	// FOOD_EP_25
		sql.append("	, ?														");	// FOOD_CODE
		sql.append("	, SYSDATE												"); // REG_DATE
		sql.append("	, 'Y'													");	// SHOW_FLAG
		sql.append("	, (SELECT NVL(MAX(FOOD_CAT_INDEX)+1, 1)					");	// FOOD_CAT_INDEX
		sql.append("	FROM FOOD_ST_ITEM WHERE CAT_NO = ?)						");
		sql.append(" )															");

		//변수 setting
		setValue	=	new ArrayList<Object>();
		setValue.add(cat_nm);
		//nm_food 1 ~ 5
		for(int i = 0; i < 5; i++) {
			if (nm_food_arc.size() > i && (nm_food_arc.get(i) != null && nm_food_arc.get(i).length() > 0)) {
				setValue.add(nm_food_arc.get(i).trim());
			} else {setValue.add("");}
		}
		setValue.add(unit_no);
		//dt_nm 1 ~ 10
		for(int i = 0; i < 10; i++) {
			if(dt_nm_arc.size() > i && (dt_nm_arc.get(i) != null && dt_nm_arc.get(i).length() > 0)) {
				setValue.add(dt_nm_arc.get(i).trim());
			} else {setValue.add("");}
		}
		//ex_nm 1 ~ 25
		for(int i = 0; i < 25; i++) {
			if (ex_nm_arc.size() > i && (ex_nm_arc.get(i) != null && ex_nm_arc.get(i).length() > 0)) {
				setValue.add(ex_nm_arc.get(i).trim());
			} else {setValue.add("");}
		}
		setValue.add(food_code);
		setValue.add(cat_nm);
		setObject	=	new Object[setValue.size()];
		for(int i=0; i<setValue.size(); i++){
			setObject[i]	=	setValue.get(i);
		}

		result	=	jdbcTemplate.update(sql.toString(), setObject);

		//6-1st. 공개식품 등록
		sql	=	new StringBuffer();
		sql.append(" SELECT	MAX(ITEM_NO) FROM FOOD_ST_ITEM	");
		temp_item_no	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class);

		sql	=	new StringBuffer();
		sql.append(" INSERT INTO FOOD_ITEM_PRE										");
		sql.append(" (																");
		sql.append(" 	S_ITEM_NO													");
		sql.append(" 	, ITEM_NO													");
		sql.append(" 	, ITEM_NM													");
		sql.append(" 	, ITEM_GRP_NO												");
		sql.append(" 	, ITEM_GRP_ORDER											");
		sql.append(" 	, REG_DATE													");
		sql.append(" 	, SHOW_FLAG													");
		sql.append(" 	, FILE_NO													");
		sql.append(" 	, LOW_RATIO													");
		sql.append(" 	, AVR_RATIO													");
		sql.append(" 	, LB_RATIO													");
		sql.append(" ) VALUES (														");
		sql.append(" 	(SELECT MAX(S_ITEM_NO)+1 FROM FOOD_ITEM_PRE)				");	//S_ITEM_NO
		sql.append(" 	, ?															");	//ITEM_NO
		sql.append(" 	, (SELECT B.NM_FOOD FROM FOOD_ST_ITEM A JOIN FOOD_ST_NM B	");	//ITEM_NM
		sql.append(" 		ON A.FOOD_NM_1 = B.NM_NO WHERE A.ITEM_NO = ?)			");
		sql.append(" 	, (SELECT MAX(ITEM_GRP_NO)+1 FROM FOOD_ITEM_PRE)			");//ITEM_GROUP_NO
		sql.append(" 	, 1															");//ITEM_GROUP_ORDER
		sql.append(" 	, SYSDATE													");//REG_DATE
		sql.append(" 	, 'Y'														");//SHOW_FLAG
		sql.append(" 	, -1														");//FILE_NO
		sql.append(" 	, ?															");//LOW_RATIO
		sql.append(" 	, ?															");//AVR_RATIO
		sql.append(" 	, ?															");//LB_RATIO
		sql.append(" )																");
		result	=	jdbcTemplate.update(sql.toString(), new Object[]{temp_item_no, temp_item_no, low_ratio, avr_ratio, lb_ratio});

		if (result > 0) {
			out.println("<script>");
            out.println("alert('정상적으로 처리되었습니다.');");
            out.println("window.close();");
            out.println("opener.location.reload();");
            out.println("</script>");
		} else {
			out.println("<script>");
            out.println("alert('오류가 발생했습니다. 다시 한번 확인 하세요.');");
            out.println("history.back();");
            out.println("</script>");
		}


///////////////////////////////////////////////////////////////////////////////////////////
	//식품 수정
	}else if("itemUpdate".equals(mode)){
		
		//item_no
		//cat_nm = cat_no
		//params
		//cat_nm
		//food_code
		//nm_food
		//dt_nm
		//ex_nm
		//low_ratio
		//avr_ratio
		//lb_ratio

		//0th. 식품명, 상세식품명, 식품설명 "," 로 자르기
		nm_food_arc		=	new ArrayList<String>();
		nm_food_arc		=	splitComma(nm_food);
		dt_nm_arc		=	new ArrayList<String>();
		dt_nm_arc		=	splitComma(dt_nm);
		ex_nm_arc		=	new ArrayList<String>();
		ex_nm_arc		=	splitComma(ex_nm);

		//0th. 로그 테이블 insert
		sql	=	new StringBuffer();
		sql.append(" INSERT INTO FOOD_ST_ITEM_LOG										");
		sql.append(" (																	");
		sql.append(" 	ITEM_NO,														");
		sql.append(" 	CAT_NO,															");
		sql.append(" 	FOOD_NM_1, FOOD_NM_2, FOOD_NM_3, FOOD_NM_4, FOOD_NM_5,			");
		sql.append(" 	FOOD_UNIT,														");
		sql.append(" 	FOOD_DT_1, FOOD_DT_2, FOOD_DT_3, FOOD_DT_4, FOOD_DT_5,			");
		sql.append(" 	FOOD_DT_6, FOOD_DT_7, FOOD_DT_8, FOOD_DT_9, FOOD_DT_10,			");
		sql.append(" 	FOOD_EP_1, FOOD_EP_2, FOOD_EP_3, FOOD_EP_4, FOOD_EP_5,			");
		sql.append(" 	FOOD_EP_6, FOOD_EP_7, FOOD_EP_8, FOOD_EP_9, FOOD_EP_10,			");
		sql.append(" 	FOOD_EP_11, FOOD_EP_12, FOOD_EP_13, FOOD_EP_14, FOOD_EP_15,		");
		sql.append(" 	FOOD_EP_16, FOOD_EP_17, FOOD_EP_18, FOOD_EP_19, FOOD_EP_20,		");
		sql.append(" 	FOOD_EP_21, FOOD_EP_22, FOOD_EP_23, FOOD_EP_24, FOOD_EP_25,		");
		sql.append(" 	FOOD_CODE,														");
		sql.append(" 	REG_DATE,														");
		sql.append(" 	UPDATE_FLAG,													");
		sql.append(" 	FOOD_CAT_INDEX,													");
		sql.append(" 	UPD_NO															");
		sql.append(" ) VALUES (															");
		sql.append(" 	?,																");	//ITEM_NO
		sql.append(" 	(SELECT CAT_NO FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//CAT_NO
		sql.append(" 	(SELECT FOOD_NM_1 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_NM_1
		sql.append(" 	(SELECT FOOD_NM_2 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_NM_2
		sql.append(" 	(SELECT FOOD_NM_3 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_NM_3
		sql.append(" 	(SELECT FOOD_NM_4 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_NM_4
		sql.append(" 	(SELECT FOOD_NM_5 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_NM_5
		sql.append(" 	(SELECT FOOD_UNIT FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_UNIT
		sql.append(" 	(SELECT FOOD_DT_1 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_DT_1
		sql.append(" 	(SELECT FOOD_DT_2 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_DT_2
		sql.append(" 	(SELECT FOOD_DT_3 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_DT_3
		sql.append(" 	(SELECT FOOD_DT_4 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_DT_4
		sql.append(" 	(SELECT FOOD_DT_5 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_DT_5
		sql.append(" 	(SELECT FOOD_DT_6 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_DT_6
		sql.append(" 	(SELECT FOOD_DT_7 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_DT_7
		sql.append(" 	(SELECT FOOD_DT_8 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_DT_8
		sql.append(" 	(SELECT FOOD_DT_9 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_DT_9
		sql.append(" 	(SELECT FOOD_DT_10 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),		");	//FOOD_DT_10
		sql.append(" 	(SELECT FOOD_EP_1 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_EP_1
		sql.append(" 	(SELECT FOOD_EP_2 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_EP_2
		sql.append(" 	(SELECT FOOD_EP_3 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_EP_3
		sql.append(" 	(SELECT FOOD_EP_4 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_EP_4
		sql.append(" 	(SELECT FOOD_EP_5 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_EP_5
		sql.append(" 	(SELECT FOOD_EP_6 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_EP_6
		sql.append(" 	(SELECT FOOD_EP_7 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_EP_7
		sql.append(" 	(SELECT FOOD_EP_8 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_EP_8
		sql.append(" 	(SELECT FOOD_EP_9 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_EP_9
		sql.append(" 	(SELECT FOOD_EP_10 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),		");	//FOOD_EP_10
		sql.append(" 	(SELECT FOOD_EP_11 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),		");	//FOOD_EP_11
		sql.append(" 	(SELECT FOOD_EP_12 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),		");	//FOOD_EP_12
		sql.append(" 	(SELECT FOOD_EP_13 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),		");	//FOOD_EP_13
		sql.append(" 	(SELECT FOOD_EP_14 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),		");	//FOOD_EP_14
		sql.append(" 	(SELECT FOOD_EP_15 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),		");	//FOOD_EP_15
		sql.append(" 	(SELECT FOOD_EP_16 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),		");	//FOOD_EP_16
		sql.append(" 	(SELECT FOOD_EP_17 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),		");	//FOOD_EP_17
		sql.append(" 	(SELECT FOOD_EP_18 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),		");	//FOOD_EP_18
		sql.append(" 	(SELECT FOOD_EP_19 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),		");	//FOOD_EP_19
		sql.append(" 	(SELECT FOOD_EP_20 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),		");	//FOOD_EP_20
		sql.append(" 	(SELECT FOOD_EP_21 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),		");	//FOOD_EP_21
		sql.append(" 	(SELECT FOOD_EP_22 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),		");	//FOOD_EP_22
		sql.append(" 	(SELECT FOOD_EP_23 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),		");	//FOOD_EP_23
		sql.append(" 	(SELECT FOOD_EP_24 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),		");	//FOOD_EP_24
		sql.append(" 	(SELECT FOOD_EP_25 FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),		");	//FOOD_EP_25
		sql.append(" 	(SELECT FOOD_CODE FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),			");	//FOOD_CODE
		sql.append(" 	SYSDATE,														");	//REG_DATE
		sql.append(" 	'Y',															");	//UPDATE_FLAG
		sql.append(" 	(SELECT FOOD_CAT_INDEX FROM FOOD_ST_ITEM WHERE ITEM_NO = ?),	");	//FOOD_CAT_INDEX
		sql.append(" 	-1																");	//UPD_NO
		sql.append(" )																	");
		
		result	=	jdbcTemplate.update(sql.toString(), new Object[]{
			item_no, item_no, item_no, item_no, item_no,
			item_no, item_no, item_no, item_no, item_no,
			item_no, item_no, item_no, item_no, item_no,
			item_no, item_no, item_no, item_no, item_no,
			item_no, item_no, item_no, item_no, item_no,
			item_no, item_no, item_no, item_no, item_no,
			item_no, item_no, item_no, item_no, item_no,
			item_no, item_no, item_no, item_no, item_no,
			item_no, item_no, item_no, item_no, item_no
		});

		//1-1st. 신규일 경우 등록
		if (result > 0) {

			result	=	0;

			//1st. 신규 식품명 조회
			sql	=	new StringBuffer();
			sql.append(" SELECT NVL(MAX(NM_NO)+1, 1) FROM FOOD_ST_NM ");
			st_nm_no	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class);

			//1-1st. 신규일 경우 등록
			sql	=	new StringBuffer();
			sql.append(" MERGE INTO FOOD_ST_NM USING DUAL								");
			sql.append(" 	ON(NM_FOOD = ?)												");	//NM_FOOD
			sql.append(" 	WHEN NOT MATCHED THEN										");
			sql.append(" 		INSERT(													");
			sql.append(" 			NM_NO, CAT_NO, NM_FOOD, SHOW_FLAG, REG_DATE 		");
			sql.append(" 		) VALUES (												");
			sql.append(" 			?,													");	//NM_NO
			sql.append(" 			?,													");	//CAT_NO
			sql.append(" 			?, 'Y', SYSDATE										");	//NM_FOOD, SHOW_FLAG, REG_DATE
			sql.append(" 		)														");
			pstmt = conn.prepareStatement(sql.toString());
			if (nm_food_arc != null && nm_food_arc.size() > 0) {
				for (int i = 0; i < nm_food_arc.size(); i++) {
					key = 0;
					pstmt.setString(++key,  nm_food_arc.get(i).trim());
					pstmt.setInt(++key,  st_nm_no++);
					pstmt.setString(++key,  cat_nm);
					pstmt.setString(++key,  nm_food_arc.get(i).trim());
					pstmt.addBatch();
				}
			}
			batchResult	=	pstmt.executeBatch();
			if(pstmt!=null){pstmt.close();}

			//2nd. 신규 상세식품명 조회
			sql	=	new StringBuffer();
			sql.append(" SELECT NVL(MAX(DT_NO)+1, 1) FROM FOOD_ST_DT_NM ");
			st_dt_nm_no	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class);
			//2-1st. 신규일 경우 등록
			sql	=	new StringBuffer();
			sql.append(" MERGE INTO FOOD_ST_DT_NM USING DUAL								");
			sql.append(" 	ON (DT_NM = ?)													");
			sql.append(" 	WHEN NOT MATCHED THEN											");
			sql.append(" 		INSERT (													");
			sql.append(" 			DT_NO, CAT_NO, DT_NM, SHOW_FLAG, REG_DATE				");
			sql.append(" 		) VALUES (													");
			sql.append(" 			?, 														");
			sql.append(" 			?,														");
			sql.append(" 			?, 'Y', SYSDATE											");
			sql.append(" 		)															");
			pstmt = conn.prepareStatement(sql.toString());
			if (dt_nm_arc != null && dt_nm_arc.size() > 0) {
				for (int i = 0; i < dt_nm_arc.size(); i++) {
					key = 0;
					pstmt.setString(++key,  dt_nm_arc.get(i).trim());
					pstmt.setInt(++key,  st_dt_nm_no++);
					pstmt.setString(++key,  cat_nm);
					pstmt.setString(++key,  dt_nm_arc.get(i).trim());
					pstmt.addBatch();
				}
			}
			batchResult	=	pstmt.executeBatch();
			if(pstmt!=null){pstmt.close();}

			//3rd. 신규 식품설명 조회
			sql	=	new StringBuffer();
			sql.append(" SELECT NVL(MAX(EX_NO)+1, 1) FROM FOOD_ST_EXPL ");
			st_ex_no	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class);
			//3-1st. 신규일 경우 등록
			sql	=	new StringBuffer();
			sql.append(" MERGE INTO FOOD_ST_EXPL USING DUAL							");
			sql.append(" 	ON (EX_NM = ?)											");
			sql.append(" 	WHEN NOT MATCHED THEN									");
			sql.append(" 		INSERT (											");
			sql.append(" 			EX_NO, CAT_NO, EX_NM, SHOW_FLAG, REG_DATE		");
			sql.append(" 		) VALUES (											");
			sql.append(" 		?,													");
			sql.append(" 		?,													");
			sql.append(" 		?, 'Y', SYSDATE										");
			sql.append(" 		)													");
			pstmt = conn.prepareStatement(sql.toString());
			if (ex_nm_arc != null && ex_nm_arc.size() > 0) {
				for (int i = 0; i < ex_nm_arc.size(); i++) {
					key = 0;
					pstmt.setString(++key,  ex_nm_arc.get(i).trim());
					pstmt.setInt(++key,  st_ex_no++);
					pstmt.setString(++key,  cat_nm);
					pstmt.setString(++key,  ex_nm_arc.get(i).trim());
					pstmt.addBatch();
				}
			}
			batchResult	=	pstmt.executeBatch();
			if(pstmt!=null){pstmt.close();}

			//5th. FOOD_ST_ITEM update
			//변수 setting
			setValue	=	new ArrayList<Object>();
			sql	=	new StringBuffer();
			sql.append(" UPDATE FOOD_ST_ITEM SET											");
			sql.append(" MOD_DATE = SYSDATE													");
			/*유닛이 있을 경우에만*/
			if (!"".equals(unit_no) || unit_no != null) {
				sql.append(" , FOOD_UNIT = ?	");
				setValue.add(unit_no);
			}
			/*코드가 있을 경우에만*/
			if (!"".equals(food_code) || food_code != null) {
				sql.append(" , FOOD_CODE = ?													");
				setValue.add(food_code);
			}
			//nm_food 1 ~ nm_food_arc.size()
			for(int i = 0; i < nm_food_arc.size(); i++) {
				if (nm_food_arc.size() > i 
					&& (nm_food_arc.get(i) != null && nm_food_arc.get(i).trim().length() > 0)) {
					sql.append(" , FOOD_NM_"+(i+1)+" = (SELECT NM_NO FROM FOOD_ST_NM WHERE NM_FOOD = ?)		");
					setValue.add(nm_food_arc.get(i).trim());
				}
			}
			//dt_nm 1 ~ dt_nm_arc.size()
			for(int i = 0; i < dt_nm_arc.size(); i++) {
				if(dt_nm_arc.size() > i 
					&& (dt_nm_arc.get(i) != null && dt_nm_arc.get(i).trim().length() > 0)) {
					sql.append(" , FOOD_DT_"+(i+1)+" = (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)	");
					setValue.add(dt_nm_arc.get(i).trim());
				}
			}
			//ex_nm 1 ~ ex_nm_arc.size()
			for(int i = 0; i < ex_nm_arc.size(); i++) {
				if (ex_nm_arc.size() > i && (ex_nm_arc.get(i) != null && ex_nm_arc.get(i).trim().length() > 0)) {
					sql.append(" , FOOD_EP_"+(i+1)+" = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
					setValue.add(ex_nm_arc.get(i).trim());
				}
			}

			sql.append(" WHERE ITEM_NO = ?													");
			setValue.add(item_no);
			setObject	=	new Object[setValue.size()];
			for(int i=0; i < setValue.size(); i++){
				setObject[i]	=	setValue.get(i);
			}
			//setValue.add(item_no);
			result	=	jdbcTemplate.update(sql.toString(), setObject);

			if (result > 0) {
				result	=	0;
				sql	=	new StringBuffer();
				sql.append(" UPDATE FOOD_ITEM_PRE SET							");
				sql.append(" ITEM_NM = 											");
				sql.append(" 	(SELECT NM_FOOD FROM FOOD_ST_NM WHERE NM_NO	= (	");
				sql.append(" 		SELECT FOOD_NM_1 FROM FOOD_ST_ITEM 			");
				sql.append(" 		WHERE ITEM_NO = ?							");
				sql.append(" 	)),												");
				sql.append(" MOD_DATE = SYSDATE									");
				sql.append(" WHERE ITEM_NO = ?									");
				result	=	jdbcTemplate.update(sql.toString(), new Object[]{item_no, item_no});

				if (result > 0) {
					out.println("<script>");
					out.println("alert('정상적으로 처리되었습니다.');");
					out.println("window.close();");
					out.println("opener.location.reload();");
					out.println("</script>");
				} else {
					out.println("<script>");
					out.println("alert('오류가 발생했습니다. 다시 한번 확인 하세요.');");
					out.println("history.back();");
					out.println("</script>");
				}
			}//END IF
			 else {
				out.println("<script>");
				out.println("alert('오류가 발생했습니다. 다시 한번 확인 하세요.');");
				out.println("history.back();");
				out.println("</script>");
			}

		}//END IF
		else {
			out.println("<script>");
			out.println("alert('오류가 발생했습니다. 다시 한번 확인 하세요.');");
			out.println("history.back();");
			out.println("</script>");
		}
	}

}catch(Exception e){
	if(pstmt!=null){pstmt.close();}
	if(conn!=null){conn.close();}
	sqlMapClient.endTransaction();
	out.println(e.toString());
}finally {
	if(pstmt!=null){pstmt.close();}
	if(conn!=null){conn.close();}
	sqlMapClient.endTransaction();
}


%>

