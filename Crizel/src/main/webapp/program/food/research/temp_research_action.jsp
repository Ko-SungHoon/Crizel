<%
/**
*   PURPOSE :   회원신청 - 액션
*   CREATE  :   20180319_mon    Ko
*   MODIFY  :   비밀번호 리셋 20180327_tue    JI
*	MODIFY  :   영양사 다중 추가 20180409_mon    KO
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

String mode			= parseNull(request.getParameter("mode"), "insert");

String sch_no		= parseNull(request.getParameter("sch_no"));
String sch_org_sid	= parseNull(request.getParameter("sch_org_sid"));
String sch_id 		= parseNull(request.getParameter("sch_id"));
String sch_pw		= parseNull(request.getParameter("sch_pw"));
String sch_nm		= parseNull(request.getParameter("sch_nm"));
String sch_type		= parseNull(request.getParameter("sch_type"));
String sch_addr		= parseNull(request.getParameter("sch_addr"));
String sch_area		= parseNull(request.getParameter("sch_area"));
String sch_found	= parseNull(request.getParameter("sch_found"));
String sch_tel		= parseNull(request.getParameter("sch_tel"));
String sch_grade	= parseNull(request.getParameter("sch_grade"));
String zone_no		= parseNull(request.getParameter("zone_no"));
String cat_no		= parseNull(request.getParameter("cat_no"));
String team_no		= parseNull(request.getParameter("team_no"));
String jo_no		= parseNull(request.getParameter("jo_no"));
String area_no		= parseNull(request.getParameter("area_no"));
String sch_gen		= parseNull(request.getParameter("sch_gen"));
String sch_fax 		= parseNull(request.getParameter("sch_fax"));
String sch_post 	= parseNull(request.getParameter("sch_post"));
String sch_url 		= parseNull(request.getParameter("sch_url"));
String show_flag 	= parseNull(request.getParameter("show_flag"), "Y");
String sch_lv 		= parseNull(request.getParameter("sch_lv"));

String[] nu_no 		= request.getParameterValues("nu_no");
String[] nu_nm		= request.getParameterValues("nu_nm");
String[] nu_mail	= request.getParameterValues("nu_mail");
String[] nu_tel		= request.getParameterValues("nu_tel");

int max_nu_no		= 0;

StringBuffer sql 			= null;
List<Object[]> batch 		= null;
Object[] value				= null;
int result 					= 0;

try{
	
	if("insert".equals(mode)){
		sql = new StringBuffer();
		sql.append("SELECT NVL(MAX(SCH_NO)+1, 1) FROM FOOD_SCH_TB");
		sch_no = jdbcTemplate.queryForObject(sql.toString(), String.class);
		
		sql = new StringBuffer();
		sql.append("INSERT INTO FOOD_SCH_TB(		");
		sql.append("	SCH_NO,						");	// 학교 고유번호
		sql.append("	SCH_ORG_SID,				");	// 학교 정보 테이블 번호
		sql.append("	SCH_TYPE,					");	// 학교 유형
		sql.append("	SCH_ID,						");	// 학교ID
		sql.append("	SCH_NM,						");	// 학교명
		sql.append("	SCH_TEL,					");	// 학교 전화
		sql.append("	SCH_FAX,					");	// 학교 팩스
		sql.append("	SCH_AREA,					");	// 학교 지역
		sql.append("	SCH_POST,					");	// 우편번호
		sql.append("	SCH_ADDR,					");	// 학교 주소
		sql.append("	SCH_FOUND,					");	// 학교 설립 형태
		sql.append("	SCH_URL,					");	// 홈페이지 주소
		sql.append("	SCH_GEN,					");	// 남녀공학 여부
		sql.append("	SHOW_FLAG,					");	// 노출여부
		sql.append("	REG_DATE,					");	// 등록 날짜시간
		sql.append("	ZONE_NO,					");	// 권역 번호
		sql.append("	CAT_NO,						");	// 품목 번호
		sql.append("	TEAM_NO,					");	// 팀 번호
		sql.append("	JO_NO,						");	// 조 번호
		sql.append("	AREA_NO,					");	// 지역 번호
		sql.append("	SCH_GRADE,					");	// 팀장 여부 'R' = researcher, 'T' = 'super visor'
		sql.append("	SCH_LV,						");	// 팀 등급(여분)
		sql.append("	SCH_PW,						");	// 비밀번호
		sql.append("	SCH_APP_FLAG,				");	// 승인여부
		sql.append("	APP_DATE,					");	// 승인일시
		sql.append("	MOD_DATE,					");	// 수정일시
		sql.append("	ETC1,						");	// 여분1
		sql.append("	ETC2,						");	// 여분2
		sql.append("	ETC3						");	// 여분3
		sql.append(")								");
		sql.append("VALUES(														");
		sql.append("	?,														"); // SCH_NO
		sql.append("	?,														"); // SCH_ORG_SID
		sql.append("	?,														");	// SCH_TYPE
		sql.append("	?,														");	// SCH_ID
		sql.append("	?,														");	// SCH_NM
		sql.append("	?,														");	// SCH_TEL
		sql.append("	'',														"); // SCH_FAX
		sql.append("	?,														");	// SCH_AREA
		sql.append("	'',														"); // SCH_POST
		sql.append("	?,														");	// SCH_ADDR
		sql.append("	?,														");	// SCH_FOUND
		sql.append("	'',														");	// SCH_URL
		sql.append("	?,														");	// SCH_GEN
		sql.append("	'Y',													"); // SHOW_FLAG
		sql.append("	SYSDATE,												"); // REG_DATE
		sql.append("	?,														"); // ZONE_NO
		sql.append("	?,														"); // CAT_NO
		sql.append("	?,														"); // TEAM_NO
		sql.append("	?,														"); // JO_NO
		sql.append("	?,														"); // AREA_NO
		sql.append("	?,														");	// SCH_GRADE
		sql.append("	'',														"); // SCH_LV
		sql.append("	?,														");	// SCH_PW
		sql.append("	'N',													");	// SCH_APP_FLAG
		sql.append("	null,													");	// APP_DATE
		sql.append("	SYSDATE,												");	// MOD_DATE
		sql.append("	'',														"); // ETC1
		sql.append("	'',														"); // ETC2
		sql.append("	''														"); // ETC3
		sql.append(")															");
		
		result = jdbcTemplate.update(sql.toString(), new Object[]{
			  sch_no, sch_org_sid, sch_type, sch_id, sch_nm, sch_tel, sch_area, sch_addr
			, sch_found, sch_gen, zone_no, cat_no, team_no, jo_no, area_no, sch_grade, sch_pw
		});

		if(nu_nm!=null && nu_nm.length>0){
			sql = new StringBuffer();
			sql.append("INSERT INTO FOOD_SCH_NU(	");
			sql.append("	NU_NO,					");
			sql.append("	SCH_NO,					");
			sql.append("	NU_NM,					");
			sql.append("	NU_TEL,					");
			sql.append("	NU_MAIL,				");
			sql.append("	SHOW_FLAG				");
			sql.append(")							");
			sql.append("VALUES(														");
			sql.append("	(SELECT NVL(MAX(NU_NO)+1,1) FROM FOOD_SCH_NU),			");
			sql.append("	?,														");
			sql.append("	?,														");
			sql.append("	?,														");
			sql.append("	?,														");
			sql.append("	'Y'														");
			sql.append(")															");
			batch = new ArrayList<Object[]>();
			for(int i=0; i<nu_nm.length; i++){
				value = new Object[]{
						sch_no
						, nu_nm[i]
						, nu_tel[i]
						, nu_mail[i]
				};
				batch.add(value);
			}
			result = jdbcTemplate.batchUpdate(sql.toString(), batch).length;
		}
		
		if(result > 0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('/program/food/research/temp_research_form.jsp')");
			out.println("</script>");
		}
	}else if("update".equals(mode)){
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_SCH_TB SET			");
		sql.append("	SCH_TYPE 	= ?,			");	// 학교 유형(유치원, 초등학교, 중학교, 고등학교)
		sql.append("	SCH_NM 		= ?,			");	// 학교명
		sql.append("	SCH_TEL 	= ?,			");	// 학교 전화
		sql.append("	SCH_FAX 	= ?,			");	// 학교 팩스
		sql.append("	SCH_AREA 	= ?,			");	// 학교 지역
		sql.append("	SCH_POST 	= ?,			");	// 우편번호
		sql.append("	SCH_ADDR 	= ?,			");	// 학교 주소
		sql.append("	SCH_FOUND 	= ?,			");	// 학교 설립 형태
		sql.append("	SCH_URL 	= ?,			");	// 홈페이지 주소
		sql.append("	SCH_GEN 	= ?,			");	// 남녀공학 여부
		sql.append("	SHOW_FLAG 	= ?,			");	// 노출여부
		sql.append("	ZONE_NO 	= ?,			");	// 권역 번호
		sql.append("	CAT_NO 		= ?,			");	// 품목번호
		sql.append("	TEAM_NO 	= ?,			");	// 팀 번호
		sql.append("	JO_NO	 	= ?,			");	// 조 번호
		sql.append("	AREA_NO	 	= ?,			");	// 지역 번호
		sql.append("	SCH_GRADE 	= ?,			");	// 팀장 여부 'R' = researcher, 'T' = 'super visor'
		//sql.append("	SCH_PW 		= ?,			");	// 비밀번호
		sql.append("	SCH_LV 		= ?,			");	// 팀 등급(여분)
		sql.append("	MOD_DATE	= SYSDATE		");	// 수정일시
		sql.append("WHERE SCH_NO 	= ?				");
		result = jdbcTemplate.update(sql.toString(), new Object[]{
			sch_type, sch_nm, sch_tel, sch_fax, sch_area, sch_post, sch_addr, sch_found, sch_url, sch_gen,
			show_flag, zone_no, cat_no, team_no, jo_no, area_no, sch_grade, 
			//sch_pw,
			sch_lv, sch_no
		});
		
		if(nu_nm!=null && nu_nm.length>0){
			// 현재 모든 영양사의 show_flag를 N으로 설정
			sql = new StringBuffer();
			sql.append("UPDATE FOOD_SCH_NU SET		");
			sql.append("	SHOW_FLAG = 'N'			");
			sql.append("WHERE SCH_NO = ?			");
			jdbcTemplate.update(sql.toString(), sch_no);
			
			sql = new StringBuffer();
			sql.append("SELECT NVL(MAX(NU_NO)+1,1) FROM FOOD_SCH_NU					");
			max_nu_no = jdbcTemplate.queryForObject(sql.toString(), Integer.class); 

			sql = new StringBuffer();
			sql.append("MERGE INTO FOOD_SCH_NU USING DUAL									");
			sql.append("	ON(NU_NO = ?)													");
			sql.append("	WHEN MATCHED THEN												");
			sql.append("		UPDATE SET													");
			sql.append("			NU_NM		= ?											");
			sql.append("			, NU_TEL	= ?											");
			sql.append("			, NU_MAIL	= ?											");
			sql.append("			, SHOW_FLAG	= ?											");
			sql.append("	WHEN NOT MATCHED THEN											");
			sql.append("		INSERT(														");
			sql.append("				NU_NO, SCH_NO, NU_NM, NU_TEL, NU_MAIL, SHOW_FLAG	");
			sql.append("				)													");
			sql.append("		VALUES(														");
			sql.append("				?, ?, ?, ?, ?, ?									");
			sql.append("				)													");
			batch = new ArrayList<Object[]>();
			for(int i=0; i<nu_nm.length; i++){
				// i가 nu_no 배열의 갯수보다 적을때는 nu_no에 배열값을 넣고
				// 그렇지 않을 경우(추가 insert) nu_no에 -1값을 주어 매칭되는 데이터가 없게 처리
				if(i<nu_no.length){
					value = new Object[]{
							nu_no[i] , nu_nm[i] , nu_tel[i] , nu_mail[i] , show_flag
							, max_nu_no , sch_no , nu_nm[i] , nu_tel[i] , nu_mail[i] , show_flag
					};
				}else{
					value = new Object[]{
							-1 , nu_nm[i] , nu_tel[i] , nu_mail[i] , show_flag
							, max_nu_no , sch_no , nu_nm[i] , nu_tel[i] , nu_mail[i] , show_flag
					};
				}
				batch.add(value);
			}
			result = jdbcTemplate.batchUpdate(sql.toString(), batch).length;
		}
		
		/* // show_flag 값이 N인 데이터를 삭제
		sql = new StringBuffer();
		sql.append("DELETE FROM FOOD_SCH_NU WHERE SCH_NO = ? AND SHOW_FLAG = 'N'	");
		jdbcTemplate.update(sql.toString(), sch_no); */
		
		
		if(result > 0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('/program/food/research/food_research_view.jsp?sch_no="+sch_no+"')");
			out.println("</script>");
		}
        
    //비밀번호 초기화
	} else if ("reset".equals(mode)) {
        
        sql     =   new StringBuffer();
        sql.append("UPDATE FOOD_SCH_TB SET              ");
        sql.append("    SCH_PW      =   'gkrryrmqtlr'   ");
        sql.append("WHERE SCH_NO    =   ?               ");
        result  =   jdbcTemplate.update(sql.toString(), new Object[]{sch_no});
        if (result > 0) {
            out.println("<script>");
			out.println("alert('비밀번호가 학교급식 으로 변경되었습니다. ');");
			out.println("location.replace('/program/food/research/food_research_view.jsp?sch_no="+sch_no+"')");
			out.println("</script>");
        }
    }
	
	
	
}catch(Exception e){
	out.println(e.toString());
}

%>