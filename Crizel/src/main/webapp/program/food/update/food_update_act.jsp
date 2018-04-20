<%
/**
*   PURPOSE :   업데이트 요청 - 액션
*   CREATE  :   20180323_fri    Ko
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%!

	private String failReturn () {
		String retPage	=	null;
		retPage	+=	"<script>";
		retPage	+=	"alert('오류가 발생하였습니다. 관리자에게 문의하세요.');";
		retPage	+=	"history.back();";
		retPage	+=	"</script>";
		return retPage;
	}

	private String sucPopReturn () {
		String retPage	=	null;
		retPage	+=	"<script>";
		retPage	+=	"opener.location.reload();";
		retPage	+=	"window.close();";
		retPage	+=	"</script>";
		return retPage;
	}

	private List<String> splitComma (String splitString) {
		String[] retArr	=	splitString.split(",");
		List<String> retList	=	new ArrayList<>();
		if (retArr != null && retArr.length > 0) {
			for (int i = 0; i < retArr.length; i++) {
				retList.add(retArr[i]);
			}
		} else {
			retList = null;
		}
		return retList;
	}

%>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

String mode			= 	parseNull(request.getParameter("mode"));

String upd_flag		= 	parseNull(request.getParameter("upd_flag"));
String sts_flag		= 	parseNull(request.getParameter("sts_flag"));

String upd_no		= 	parseNull(request.getParameter("upd_no"));	//업데이트 번호

String item_no		=	parseNull(request.getParameter("item_no"));
String s_item_no	=	parseNull(request.getParameter("s_item_no"));
String cat_nm		=	parseNull(request.getParameter("cat_nm"));
String n_item_code	=	parseNull(request.getParameter("n_item_code"));
String n_item_nm	=	parseNull(request.getParameter("n_item_nm"));
String n_item_dt_nm	=	parseNull(request.getParameter("n_item_dt_nm"));
String n_item_expl	=	parseNull(request.getParameter("n_item_expl"));
String n_item_unit	=	parseNull(request.getParameter("n_item_unit"));
String upd_reason	=	parseNull(request.getParameter("upd_reason"));

/*반영 미반영*/
String rjc_reason	=	parseNull(request.getParameter("rjc_reason"));

/*새로운 이름*/
List<Object[]> batch 			=	null;
Object[] batchData				=	null;
int[] batchResult				=	null;
List<String> n_item_nm_arc		=	null;
List<String> n_item_dt_nm_arc	=	null;
List<String> n_item_expl_arc	=	null;

List<Object> setValue			=	null;
Object[] setObject				=	null;

int temp_item_no	=	0;

int st_nm_no		=	0;
int st_dt_nm_no		=	0;
int st_ex_no		=	0;
int st_unit_no		=	0;

int item_comp_no	=	0;

StringBuffer sql 	= null;
int result 			= 0;

try{
	//접수완료 처리
	if("acc".equals(mode)){
		if (upd_no != null && upd_no.length() > 0) {

			sql	=	new StringBuffer();
			sql.append(" UPDATE FOOD_UPDATE SET ");
			sql.append(" STS_FLAG = 'Y',		");
			sql.append(" MOD_DATE = SYSDATE		");
			sql.append(" WHERE UPD_NO = ?		");
			result	=	jdbcTemplate.update(sql.toString(), new Object[]{upd_no});

			if (result > 0) {
				out.println("<script>");
				out.println("alert('정상적으로 처리되었습니다.');");
				out.println("location.href='food_update_list.jsp'");
				out.println("</script>");
			} else {
				out.println(failReturn());
			}

		} else {
			out.println(failReturn());
		}
	//반영 처리
	} else if ("A".equals(mode)) {
/************** 추가 반영 처리 ************/
		//변경 반영 처리
		if ("M".equals(upd_flag)) {

			//0th. 변경 식품명, 상세식품명, 식품설명 "," 로 자르기
			n_item_nm_arc		=	new ArrayList<>();
			n_item_nm_arc		=	splitComma(n_item_nm);
			n_item_dt_nm_arc	=	new ArrayList<>();
			n_item_dt_nm_arc	=	splitComma(n_item_dt_nm);
			n_item_expl_arc		=	new ArrayList<>();
			n_item_expl_arc		=	splitComma(n_item_expl);

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
			sql.append(" 	FOOD_CAT_INDEX													");
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
			sql.append(" 	(SELECT FOOD_CAT_INDEX FROM FOOD_ST_ITEM WHERE ITEM_NO = ?)		");	//FOOD_CAT_INDEX
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

			if (result > 0) {
				result	=	0;

				//1st. 변경 식품명 조회
				sql	=	new StringBuffer();
				sql.append(" SELECT NVL(MAX(NM_NO)+1, 1) FROM FOOD_ST_NM ");
				st_nm_no	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class);
				//1-1st. 변경 신규일 경우 등록
				if ((n_item_nm_arc.get(0) != null && n_item_nm_arc.get(0).trim().length() > 0)
					&& (n_item_nm_arc != null && n_item_nm_arc.size() > 0)) {
					sql	=	new StringBuffer();
					sql.append(" MERGE INTO FOOD_ST_NM USING DUAL								");
					sql.append(" 	ON(NM_FOOD = ?)												");
					sql.append(" 	WHEN NOT MATCHED THEN										");
					sql.append(" 		INSERT(													");
					sql.append(" 			NM_NO, CAT_NO, NM_FOOD, SHOW_FLAG, REG_DATE 		");
					sql.append(" 		) VALUES (												");
					sql.append(" 			?,													");
					sql.append(" 			(SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ?),	");
					sql.append(" 			?, 'Y', SYSDATE										");
					sql.append(" 		)														");
					batch = new ArrayList<Object[]>();
					if (n_item_nm_arc != null && n_item_nm_arc.size() > 0) {
						for (int i = 0; i < n_item_nm_arc.size(); i++) {
							batchData	=	new Object[] {
								n_item_nm_arc.get(i).trim(), st_nm_no++,
								cat_nm, n_item_nm_arc.get(i).trim()};
							batch.add(batchData);
						}
					}
					batchResult	=	jdbcTemplate.batchUpdate(sql.toString(), batch);
				}
				//2nd. 변경 상세식품명 조회
				if ((n_item_dt_nm_arc.get(0) != null && n_item_dt_nm_arc.get(0).trim().length() > 0) 
					&& (n_item_dt_nm_arc != null && n_item_dt_nm_arc.size() > 0)) {
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
					sql.append(" 			(SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ?),	");
					sql.append(" 			?, 'Y', SYSDATE											");
					sql.append(" 		)															");
					batch	=	new ArrayList<Object[]>();
					if (n_item_dt_nm_arc != null && n_item_dt_nm_arc.size() > 0) {
						for (int i = 0; i < n_item_dt_nm_arc.size(); i++) {
							batchData	=	new Object[] {
								n_item_dt_nm_arc.get(i).trim(), st_dt_nm_no++,
								cat_nm, n_item_dt_nm_arc.get(i).trim()
							};
							batch.add(batchData);
						}
					}
					batchResult	=	jdbcTemplate.batchUpdate(sql.toString(), batch);
				}
				//3rd. 변경 식품설명 조회
				if ((n_item_expl_arc.get(0) != null && n_item_expl_arc.get(0).trim().length() > 0) 
					&& (n_item_expl_arc != null && n_item_expl_arc.size() > 0)) {
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
					sql.append(" 		(SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ?),	");
					sql.append(" 		?, 'Y', SYSDATE										");
					sql.append(" 		)													");
					batch	=	new ArrayList<Object[]>();
					if (n_item_expl_arc != null && n_item_expl_arc.size() > 0) {
						for (int i = 0; i < n_item_expl_arc.size(); i++) {
							batchData	=	new Object[] {
								n_item_expl_arc.get(i).trim(), st_ex_no++,
								cat_nm, n_item_expl_arc.get(i).trim()
							};
							batch.add(batchData);
						}
					}
					batchResult	=	jdbcTemplate.batchUpdate(sql.toString(), batch);
				}
				//4th. 변경 단위 조회
				//4-1st. 신규일 경우 등록
				if (n_item_unit != null && n_item_unit.trim().length() > 0) {
					sql	=	new StringBuffer();
					sql.append(" MERGE INTO FOOD_ST_UNIT USING DUAL								");
					sql.append(" 	ON (UNIT_NM = ?)											");
					sql.append(" 	WHEN NOT MATCHED THEN										");
					sql.append(" 		INSERT (												");
					sql.append(" 			UNIT_NO, UNIT_NM, UNIT_TYPE, SHOW_FLAG, REG_DATE	");
					sql.append(" 		) VALUES (												");
					sql.append(" 		(SELECT NVL(MAX(UNIT_NO)+1, 1) FROM FOOD_ST_UNIT),		");
					sql.append(" 		?,														");
					sql.append(" 		'F', 'Y', SYSDATE										");
					sql.append(" 		)														");
					result	=	jdbcTemplate.update(sql.toString(), new Object[]{n_item_unit, n_item_unit});
				}
				//5th. FOOD_ST_ITEM update
				//변수 setting
				setValue	=	new ArrayList<Object>();
				sql	=	new StringBuffer();
				sql.append(" UPDATE FOOD_ST_ITEM SET											");
				sql.append(" MOD_DATE = SYSDATE													");
				sql.append(" , FOOD_UNIT = (SELECT UNIT_NO FROM FOOD_ST_UNIT WHERE UNIT_NM = ?)	");
				sql.append(" , FOOD_CODE = ?													");
				setValue.add(n_item_unit);
				setValue.add(n_item_code);
				//nm_food 1 ~ n_item_nm_arc.size()
				for(int i = 0; i < n_item_nm_arc.size(); i++) {
					if (n_item_nm_arc.size() > i 
						&& (n_item_nm_arc.get(i) != null && n_item_nm_arc.get(i).trim().length() > 0)) {
						sql.append(" , FOOD_NM_"+(i+1)+" = (SELECT NM_NO FROM FOOD_ST_NM WHERE NM_FOOD = ?)		");
						setValue.add(n_item_nm_arc.get(i).trim());
					}
				}
				//dt_nm 1 ~ n_item_dt_nm_arc.size()
				for(int i = 0; i < n_item_dt_nm_arc.size(); i++) {
					if(n_item_dt_nm_arc.size() > i 
						&& (n_item_dt_nm_arc.get(i) != null && n_item_dt_nm_arc.get(i).trim().length() > 0)) {
						sql.append(" , FOOD_DT_"+(i+1)+" = (SELECT DT_NO FROM FOOD_ST_DT_NM WHERE DT_NM = ?)	");
						setValue.add(n_item_dt_nm_arc.get(i).trim());
					}
				}
				//ex_nm 1 ~ n_item_expl_arc.size()
				for(int i = 0; i < n_item_expl_arc.size(); i++) {
					if (n_item_expl_arc.size() > i && (n_item_expl_arc.get(i) != null && n_item_expl_arc.get(i).trim().length() > 0)) {
						sql.append(" , FOOD_EP_"+(i+1)+" = (SELECT EX_NO FROM FOOD_ST_EXPL WHERE EX_NM = ?)		");
						setValue.add(n_item_expl_arc.get(i).trim());
					}
				}

				sql.append(" WHERE ITEM_NO = ?													");
				setValue.add(s_item_no);
				setObject	=	new Object[setValue.size()];
				for(int i=0; i < setValue.size(); i++){
					setObject[i]	=	setValue.get(i);
				}
				setValue.add(s_item_no);
				result	=	jdbcTemplate.update(sql.toString(), setObject);

				if (result > 0) {
					result	=	0;

					sql	=	new StringBuffer();
					sql.append(" UPDATE FOOD_ITEM_PRE SET							");
					sql.append(" ITEM_NM = 											");
					sql.append(" 	(SELECT NM_FOOD FROM FOOD_ST_NM WHERE NM_NO	= (	");
					sql.append(" 		SELECT FOOD_NM_1 FROM FOOD_ST_ITEM 			");
					sql.append(" 		WHERE ITEM_NO = ?							");
					sql.append(" 	))												");
					sql.append(" WHERE ITEM_NO = ?									");
					result	=	jdbcTemplate.update(sql.toString(), new Object[]{s_item_no, s_item_no});

					sql	=	new StringBuffer();
					sql.append(" UPDATE FOOD_UPDATE		");
					sql.append(" SET					");
					sql.append(" STS_FLAG = 'A',		");
					sql.append(" STS_DATE = SYSDATE		");
					sql.append(" WHERE UPD_NO = ?		");
					result	=	jdbcTemplate.update(sql.toString(), new Object[]{upd_no});

					if (result > 0) {
						out.println(sucPopReturn());
					} else {
						out.println(failReturn());
					}
				} else {out.println(failReturn());}
			} else {
				out.println(failReturn());
			}
/************** 추가 반영 처리 ************/
		//추가 반영 처리
		} else if ("A".equals(upd_flag)) {
			//0th. 식품명, 상세식품명, 식품설명 "," 로 자르기
			n_item_nm_arc		=	new ArrayList<>();
			n_item_nm_arc		=	splitComma(n_item_nm);
			n_item_dt_nm_arc	=	new ArrayList<>();
			n_item_dt_nm_arc	=	splitComma(n_item_dt_nm);
			n_item_expl_arc		=	new ArrayList<>();
			n_item_expl_arc		=	splitComma(n_item_expl);
			//1st. 신규 식품명 조회
			sql	=	new StringBuffer();
			sql.append(" SELECT NVL(MAX(NM_NO)+1, 1) FROM FOOD_ST_NM ");
			st_nm_no	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class);
			//1-1st. 신규일 경우 등록
			sql	=	new StringBuffer();
			sql.append(" MERGE INTO FOOD_ST_NM USING DUAL								");
			sql.append(" 	ON(NM_FOOD = ?)												");
			sql.append(" 	WHEN NOT MATCHED THEN										");
			sql.append(" 		INSERT(													");
			sql.append(" 			NM_NO, CAT_NO, NM_FOOD, SHOW_FLAG, REG_DATE 		");
			sql.append(" 		) VALUES (												");
			sql.append(" 			?,													");
			sql.append(" 			(SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ?),	");
			sql.append(" 			?, 'Y', SYSDATE										");
			sql.append(" 		)														");
			batch = new ArrayList<Object[]>();
			if (n_item_nm_arc != null && n_item_nm_arc.size() > 0) {
				for (int i = 0; i < n_item_nm_arc.size(); i++) {
					batchData	=	new Object[] {
						n_item_nm_arc.get(i).trim(), st_nm_no++,
						cat_nm, n_item_nm_arc.get(i).trim()};
					batch.add(batchData);
				}
			}
			batchResult	=	jdbcTemplate.batchUpdate(sql.toString(), batch);
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
			sql.append(" 			(SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ?),		");
			sql.append(" 			?, 'Y', SYSDATE											");
			sql.append(" 		)															");
			batch	=	new ArrayList<Object[]>();
			if (n_item_dt_nm_arc != null && n_item_dt_nm_arc.size() > 0) {
				for (int i = 0; i < n_item_dt_nm_arc.size(); i++) {
					batchData	=	new Object[] {
						n_item_dt_nm_arc.get(i).trim(), st_dt_nm_no++,
						cat_nm, n_item_dt_nm_arc.get(i).trim()
					};
					batch.add(batchData);
				}
			}
			batchResult	=	jdbcTemplate.batchUpdate(sql.toString(), batch);
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
			sql.append(" 		(SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ?),	");
			sql.append(" 		?, 'Y', SYSDATE										");
			sql.append(" 		)													");
			batch	=	new ArrayList<Object[]>();
			if (n_item_expl_arc != null && n_item_expl_arc.size() > 0) {
				for (int i = 0; i < n_item_expl_arc.size(); i++) {
					batchData	=	new Object[] {
						n_item_expl_arc.get(i).trim(), st_ex_no++,
						cat_nm, n_item_expl_arc.get(i).trim()
					};
					batch.add(batchData);
				}
			}
			batchResult	=	jdbcTemplate.batchUpdate(sql.toString(), batch);
			
			//4th. 신규 단위 조회
			//4-1st. 신규일 경우 등록
			sql	=	new StringBuffer();
			sql.append(" MERGE INTO FOOD_ST_UNIT USING DUAL								");
			sql.append(" 	ON (UNIT_NM = ?)											");
			sql.append(" 	WHEN NOT MATCHED THEN										");
			sql.append(" 		INSERT (												");
			sql.append(" 			UNIT_NO, UNIT_NM, UNIT_TYPE, SHOW_FLAG, REG_DATE	");
			sql.append(" 		) VALUES (												");
			sql.append(" 		(SELECT NVL(MAX(UNIT_NO)+1, 1) FROM FOOD_ST_UNIT),		");
			sql.append(" 		?,														");
			sql.append(" 		'F', 'Y', SYSDATE										");
			sql.append(" 		)														");
			result	=	jdbcTemplate.update(sql.toString(), new Object[]{n_item_unit, n_item_unit});
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
			sql.append("	, (SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ?)		");	// CAT_NO
			sql.append("	, (SELECT NM_NO FROM FOOD_ST_NM WHERE NM_FOOD = ?)		"); // FOOD_NM_1
			sql.append("	, (SELECT NM_NO FROM FOOD_ST_NM WHERE NM_FOOD = ?)		"); // FOOD_NM_2
			sql.append("	, (SELECT NM_NO FROM FOOD_ST_NM WHERE NM_FOOD = ?)		"); // FOOD_NM_3
			sql.append("	, (SELECT NM_NO FROM FOOD_ST_NM WHERE NM_FOOD = ?)		"); // FOOD_NM_4
			sql.append("	, (SELECT NM_NO FROM FOOD_ST_NM WHERE NM_FOOD = ?)		"); // FOOD_NM_5
			sql.append("	, (SELECT UNIT_NO FROM FOOD_ST_UNIT WHERE UNIT_NM = ?)	");	// FOOD_UNIT
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
			sql.append("	FROM FOOD_ST_ITEM WHERE CAT_NO = (						");
			sql.append("		SELECT CAT_NO FROM FOOD_ST_CAT WHERE CAT_NM = ?))	");
			sql.append(" )															");
			
			//변수 setting
			setValue	=	new ArrayList<Object>();
			setValue.add(cat_nm);
			//nm_food 1 ~ 5
			for(int i = 0; i < 5; i++) {
				if (n_item_nm_arc.size() > i && (n_item_nm_arc.get(i) != null && n_item_nm_arc.get(i).length() > 0)) {
					setValue.add(n_item_nm_arc.get(i).trim());
				} else {setValue.add("");}
			}
			setValue.add(n_item_unit);
			//dt_nm 1 ~ 10
			for(int i = 0; i < 10; i++) {
				if(n_item_dt_nm_arc.size() > i && (n_item_dt_nm_arc.get(i) != null && n_item_dt_nm_arc.get(i).length() > 0)) {
					setValue.add(n_item_dt_nm_arc.get(i).trim());
				} else {setValue.add("");}
			}
			//ex_nm 1 ~ 25
			for(int i = 0; i < 25; i++) {
				if (n_item_expl_arc.size() > i && (n_item_expl_arc.get(i) != null && n_item_expl_arc.get(i).length() > 0)) {
					setValue.add(n_item_expl_arc.get(i).trim());
				} else {setValue.add("");}
			}
			setValue.add(n_item_code);
			setValue.add(cat_nm);
			setObject	=	new Object[setValue.size()];
			for(int i=0; i<setValue.size(); i++){
				setObject[i]	=	setValue.get(i);
			}

			result	=	jdbcTemplate.update(sql.toString(), setObject);

			//7th. 업데이트 요청 테이블 업데이트
			sql	=	new StringBuffer();
			sql.append(" UPDATE FOOD_UPDATE		");
			sql.append(" SET					");
			sql.append(" STS_FLAG = 'A',		");
			sql.append(" STS_DATE = SYSDATE		");
			sql.append(" WHERE UPD_NO = ?		");
			result	=	jdbcTemplate.update(sql.toString(), new Object[]{upd_no});

			if (result > 0) {
				out.println(sucPopReturn());
			} else {
				out.println(failReturn());
			}
/************** 삭제 반영 처리 ************/
		//삭제 반영 처리
		} else if ("D".equals(upd_flag)) {
			//1st. 비교그룹군 인지 확인 후 재 질의
			sql	=	new StringBuffer();
			sql.append(" SELECT ITEM_COMP_NO 	");
			sql.append(" FROM FOOD_ITEM_PRE		");
			sql.append(" WHERE S_ITEM_NO = ?	");
			item_comp_no	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class, new Object[]{s_item_no});
			//2nd. 아이템 상태 처리
			sql	=	new StringBuffer();
			sql.append(" UPDATE	FOOD_ITEM_PRE		");
			sql.append(" SET						");
			sql.append(" SHOW_FLAG = 'N',			");
			sql.append(" MOD_DATE = SYSDATE			");
			sql.append(" WHERE ITEM_COMP_NO = ?		");
			sql.append(" OR S_ITEM_NO = ?			");
			result	=	jdbcTemplate.update(sql.toString(), new Object[]{item_comp_no, s_item_no});

			//3rd. 업데이트 테이블 처리
			if (result > 0) {
				sql	=	new StringBuffer();
				sql.append(" UPDATE FOOD_UPDATE		");
				sql.append(" SET					");
				sql.append(" STS_FLAG = 'A',		");
				sql.append(" STS_FATE = SYSDATE		");
				sql.append(" WHERE UPD_NO = ?		");
				result	=	jdbcTemplate.update(sql.toString(), new Object[]{upd_no});
			}

			if (result > 0) {
				out.println(sucPopReturn());
			//fail
			} else {
				sql	=	new StringBuffer();
				sql.append(" UPDATE FOOD_UPDATE		");
				sql.append(" SET					");
				sql.append(" STS_FLAG = 'Y',		");
				sql.append(" STS_DATE = NULL,		");
				sql.append(" RJC_REASON = NULL		");
				sql.append(" WHERE UPD_NO = ?		");
				jdbcTemplate.update(sql.toString(), new Object[]{upd_no});

				sql	=	new StringBuffer();
				sql.append(" UPDATE	FOOD_ITEM_PRE		");
				sql.append(" SET						");
				sql.append(" SHOW_FLAG = 'Y',			");
				sql.append(" MOD_DATE = NULL			");
				sql.append(" WHERE ITEM_COMP_NO = ?		");
				sql.append(" OR S_ITEM_NO = ?			");
				jdbcTemplate.update(sql.toString(), new Object[]{item_comp_no, s_item_no});

				out.println(failReturn());
			}
		}

	//미반영 처리
	} else if ("R".equals(mode)) {
		sql	=	new StringBuffer();
		sql.append(" UPDATE FOOD_UPDATE		");
		sql.append(" SET					");
		sql.append(" STS_FLAG = 'R',		");
		sql.append(" STS_DATE = SYSDATE,	");
		sql.append(" RJC_REASON = ?			");
		sql.append(" WHERE UPD_NO = ?		");
		result	=	jdbcTemplate.update(sql.toString(), new Object[]{rjc_reason, upd_no});
		if (result > 0) {
			out.println(sucPopReturn());
		} else {
			sql	=	new StringBuffer();
			sql.append(" UPDATE FOOD_UPDATE		");
			sql.append(" SET					");
			sql.append(" STS_FLAG = 'Y',		");
			sql.append(" STS_DATE = NULL,		");
			sql.append(" RJC_REASON = NULL		");
			sql.append(" WHERE UPD_NO = ?		");
			jdbcTemplate.update(sql.toString(), new Object[]{upd_no});

			out.println(failReturn());
		}
	}
	
}catch(Exception e){
	out.println(e.toString());
}

%>