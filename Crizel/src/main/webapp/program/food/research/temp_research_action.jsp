<%
/**
*   PURPOSE :   회원신청 - 액션
*   CREATE  :   20180319_mon    Ko
*   MODIFY  :   비밀번호 리셋 20180327_tue    JI
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
String nu_nm		= parseNull(request.getParameter("nu_nm"));
String sch_tel		= parseNull(request.getParameter("sch_tel"));
String nu_tel		= parseNull(request.getParameter("nu_tel"));
String sch_grade	= parseNull(request.getParameter("sch_grade"));
String nu_mail		= parseNull(request.getParameter("nu_mail"));
String zone_no		= parseNull(request.getParameter("zone_no"));
String team_no		= parseNull(request.getParameter("team_no"));
String jo_no		= parseNull(request.getParameter("jo_no"));
String area_no		= parseNull(request.getParameter("area_no"));
String sch_gen		= parseNull(request.getParameter("sch_gen"));
String sch_fax 		= parseNull(request.getParameter("sch_fax"));
String sch_post 	= parseNull(request.getParameter("sch_post"));
String sch_url 		= parseNull(request.getParameter("sch_url"));
String show_flag 	= parseNull(request.getParameter("show_flag"), "Y");
String sch_lv 		= parseNull(request.getParameter("sch_lv"));
String nu_no 		= parseNull(request.getParameter("nu_no"));

StringBuffer sql 	= null;
int result 			= 0;

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
			, sch_found, sch_gen, zone_no, team_no, jo_no, area_no, sch_grade, sch_pw
		});
		
		
		if(result > 0){
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
			
			result = jdbcTemplate.update(sql.toString(), new Object[]{
				sch_no, nu_nm, nu_tel, nu_mail
			});
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
			show_flag, zone_no, team_no, jo_no, area_no, sch_grade, 
			//sch_pw,
			sch_lv, sch_no
		});
		
		if(result > 0){
			sql = new StringBuffer();
			sql.append("UPDATE FOOD_SCH_NU SET 		");
			sql.append("	NU_NM		= ?,		");
			sql.append("	NU_TEL		= ?,		");
			sql.append("	NU_MAIL		= ?,		");
			sql.append("	SHOW_FLAG	= ?			");
			sql.append("WHERE NU_NO		= ?			");
			
			result = jdbcTemplate.update(sql.toString(), new Object[]{
				nu_nm, nu_tel, nu_mail, show_flag, nu_no
			});
		}
		
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