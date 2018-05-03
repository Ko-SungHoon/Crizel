<%
/**
*   PURPOSE :   주제별마을학교 프로그램 insert action page
*   CREATE  :   20180314_wed	JI
*   MODIFY  :   ....
**/
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%
/** 파라미터 UTF-8처리 **/
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String mode			= parseNull(request.getParameter("mode"));

StringBuffer sql 		= null;
Object[] setObj 		= null;
int result 				= 0;

if("insert".equals(mode)){	//******************************** 추가 **************************************************************
	String appstr_date 	= parseNull(request.getParameter("appstr_date"));
	String append_date 	= parseNull(request.getParameter("append_date"));
	String prostr_date 	= parseNull(request.getParameter("prostr_date"));
	String proend_date 	= parseNull(request.getParameter("proend_date"));
	String pro_cat_nm 	= parseNull(request.getParameter("pro_cat_nm"));
	String pro_name 	= parseNull(request.getParameter("pro_name"));
	String max_per 		= parseNull(request.getParameter("max_per"));
	String show_flag 	= parseNull(request.getParameter("show_flag"));
	String pro_memo 	= parseNull(request.getParameter("pro_memo"));
	String reg_id	 	= parseNull(request.getParameter("reg_id"));
	String reg_ip	 	= parseNull(request.getParameter("reg_ip"));
	String pro_tch_name	= parseNull(request.getParameter("pro_tch_name"));
	String ob_employee	= parseNull(request.getParameter("ob_employee"));
	String ob_student	= parseNull(request.getParameter("ob_student"));
	String ob_citizen	= parseNull(request.getParameter("ob_citizen"));
	String pro_time     = parseNull(request.getParameter("pro_time"));
	
	try{
		sql = new StringBuffer();
		sql.append("INSERT INTO HAPPY_PRO_TOWN(									");
		sql.append("	PRO_NO,													");
		sql.append("	PRO_CAT,												");
		sql.append("	PRO_CAT_NM,												");
		sql.append("	PRO_NAME,												");
		sql.append("	PRO_TCH_NAME,											");
		sql.append("	PRO_TCH_TEL,											");
		sql.append("	PRO_MEMO,												");
		sql.append("	APPSTR_DATE,											");
		sql.append("	APPEND_DATE,											");
		sql.append("	PROSTR_DATE,											");
		sql.append("	PROEND_DATE,											");
		sql.append("	CURR_PER,												");
		sql.append("	MAX_PER,												");
		sql.append("	REG_ID,													");
		sql.append("	REG_IP,													");
		sql.append("	REG_DATE,												");
		sql.append("	MOD_DATE,												");
		sql.append("	SHOW_FLAG,												");
		sql.append("	DEL_FLAG,												");
		sql.append("	OB_EMPLOYEE,											");
		sql.append("	OB_STUDENT,												");
		sql.append("	OB_CITIZEN,												");
		sql.append("	PRO_TIME												");
		sql.append("						)									");
		sql.append("VALUES(														");
		sql.append("						(SELECT NVL(MAX(PRO_NO)+1, 1)		");		//PRO_NO
		sql.append("						FROM HAPPY_PRO_TOWN),				");
		sql.append("						'HAPPY_PRO_TOWN',					");		//PRO_CAT
		sql.append("						?,									");		//PRO_CAT_NM
		sql.append("						?,									");		//PRO_NAME
		sql.append("						?,									");		//PRO_TCH_NAME
		sql.append("						'',									");		//PRO_TCH_TEL
		sql.append("						?,									");		//PRO_MEMO
		sql.append("						?,									");		//APPSTR_DATE
		sql.append("						?,									");		//APPEND_DATE
		sql.append("						?,									");		//PROSTR_DATE
		sql.append("						?,									");		//PROEND_DATE
		sql.append("						0,									");		//CURR_PER
		sql.append("						?,									");		//MAX_PER
		sql.append("						?,									");		//REG_ID
		sql.append("						?,									");		//REG_IP
		sql.append("						TO_CHAR(SYSDATE, 'YYYY-MM-DD'),		");		//REG_DATE
		sql.append("						TO_CHAR(SYSDATE, 'YYYY-MM-DD'),		");		//MOD_DATE
		sql.append("						?,									");		//SHOW_FLAG
		sql.append("						'N',								");		//DEL_FLAG
		sql.append("						?,									");		//OB_EMPLOYEE
		sql.append("						?,									");		//OB_STUDENT
		sql.append("						?,									");		//OB_CITIZEN
		sql.append("						?									");		//PRO_TIME
		sql.append("		)													");
		
		setObj = new Object[]{
								pro_cat_nm,
								pro_name,
								pro_tch_name,
								pro_memo,
								appstr_date,
								append_date,
								prostr_date,
								proend_date,
								max_per,
								reg_id,
								reg_ip,
								show_flag,
								ob_employee,
								ob_student,
								ob_citizen,
                                pro_time
							};
		
		result = jdbcTemplate.update(
					sql.toString(), 
					setObj
				);
	}catch(Exception e){
		out.println(e.toString());
	}finally{
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("opener.location.reload();");
			out.println("window.close();");
			//out.println("location.replace('/program/happysch/admin/programTownInsertPopup.jsp');");
			out.println("</script>");
		}
	}
}else if("delete".equals(mode)){		//******************************** 삭제 **************************************************************
	String pro_no 	= parseNull(request.getParameter("pro_no"));

	try{
		sql = new StringBuffer();
		sql.append("UPDATE HAPPY_PRO_TOWN			");
		sql.append("	SET		DEL_FLAG = 'Y'		");
		sql.append("WHERE PRO_NO = ?				");
		
		setObj = new Object[]{
							pro_no
							};
		result = jdbcTemplate.update(
					sql.toString(), 
					setObj
				);
	}catch(Exception e){
		out.println(e.toString());
	}finally{
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('/program/happysch/admin/townMng.jsp');");
			out.println("</script>");
		}		
	}
}else if("update".equals(mode)){		//******************************** 수정 **************************************************************
	String pro_no 		= parseNull(request.getParameter("pro_no"));
	String appstr_date 	= parseNull(request.getParameter("appstr_date"));
	String append_date 	= parseNull(request.getParameter("append_date"));
	String prostr_date 	= parseNull(request.getParameter("prostr_date"));
	String proend_date 	= parseNull(request.getParameter("proend_date"));
	String pro_cat_nm 	= parseNull(request.getParameter("pro_cat_nm"));
	String pro_name 	= parseNull(request.getParameter("pro_name"));
	String max_per 		= parseNull(request.getParameter("max_per"));
	String show_flag 	= parseNull(request.getParameter("show_flag"));
	String pro_memo 	= parseNull(request.getParameter("pro_memo"));
	String reg_id	 	= parseNull(request.getParameter("reg_id"));
	String reg_ip	 	= parseNull(request.getParameter("reg_ip"));
	String pro_tch_name	= parseNull(request.getParameter("pro_tch_name"));
	String ob_employee	= parseNull(request.getParameter("ob_employee"));
	String ob_student	= parseNull(request.getParameter("ob_student"));
	String ob_citizen	= parseNull(request.getParameter("ob_citizen"));
    String pro_time     = parseNull(request.getParameter("pro_time"));
	
	try{
		sql = new StringBuffer();
		sql.append("UPDATE HAPPY_PRO_TOWN										");
		sql.append("	SET														");
		sql.append("		PRO_CAT_NM		= ?,								");
		sql.append("		APPSTR_DATE		= ?,								");
		sql.append("		APPEND_DATE		= ?,								");
		sql.append("		PROSTR_DATE		= ?,								");
		sql.append("		PROEND_DATE		= ?,								");
		sql.append("		PRO_NAME 		= ?,								");
		sql.append("		PRO_TCH_NAME 	= ?,								");
		sql.append("		PRO_MEMO	 	= ?,								");
		sql.append("		MOD_DATE 		= TO_CHAR(SYSDATE, 'YYYY-MM-DD'),	");
		sql.append("		SHOW_FLAG 		= ?,								");
		sql.append("		MAX_PER 		= ?,								");
		sql.append("		OB_EMPLOYEE 	= ?,								");
		sql.append("		OB_STUDENT 		= ?,								");
		sql.append("		OB_CITIZEN 		= ?,								");
		sql.append("		PRO_TIME 		= ?									");
		sql.append("WHERE PRO_NO 			= ?									");
		
		setObj = new Object[]{
								pro_cat_nm,
								appstr_date,
								append_date,
								prostr_date,
								proend_date,
								pro_name,
								pro_tch_name,
								pro_memo,
								show_flag,
								max_per,
								ob_employee,
								ob_student,
								ob_citizen,
								pro_time,
								pro_no
							};
		
		result = jdbcTemplate.update(
					sql.toString(), 
					setObj
				);
	}catch(Exception e){
		out.println(e.toString());
	}finally{
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("opener.location.reload();");
			out.println("window.close();");
			//out.println("location.replace('/program/happysch/admin/programTownInsertPopup.jsp?mode=update&pro_no="+pro_no+"');");
			out.println("</script>");
		}
	}
}
%>
