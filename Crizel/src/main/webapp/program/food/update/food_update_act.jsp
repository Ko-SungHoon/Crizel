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

String s_item_no	=	parseNull(request.getParameter("s_item_no"));
String cat_nm		=	parseNull(request.getParameter("cat_nm"));
String n_item_code	=	parseNull(request.getParameter("n_item_code"));
String n_item_nm	=	parseNull(request.getParameter("n_item_nm"));
String n_item_dt_nm	=	parseNull(request.getParameter("n_item_dt_nm"));
String n_item_expl	=	parseNull(request.getParameter("n_item_expl"));
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

int st_nm_no		=	0;

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
		//변경 반영 처리
		if ("M".equals(upd_flag)) {


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
			//1-1st. 신규일 경우 등록 및 번호 추출
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
					batchData	=	new Object[] {n_item_nm_arc.get(i).trim(), st_nm_no++,
												cat_nm, n_item_nm_arc.get(i).trim()};
					batch.add(batchData);
				}
			}
			batchResult	=	jdbcTemplate.batchUpdate(sql.toString(), batch);
			
			//2nd. 신규 상세식품명 조회
			//2-1st. 신규일 경우 등록 및 번호 추출
			//3rd. 신규 식품설명 조회
			//3-1st. 신규일 경우 등록 및 번호 추출
			//4th. 신규 단위 조회
			//4-1st. 신규일 경우 등록 및 번호 추출
			//6th. 품목구분별 마지막 번호 추출 및 신규 등록
			//7th. item_pre 테이블 등록(비율은 기본 값으로...)

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