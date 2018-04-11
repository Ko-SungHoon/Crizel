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
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

String mode			= parseNull(request.getParameter("mode"));

String sts_flag		= parseNull(request.getParameter("sts_flag"));

String upd_no		= parseNull(request.getParameter("upd_no"));	//업데이트 번호

String s_item_no	= parseNull(request.getParameter("s_item_no"));
String cat_nm		= parseNull(request.getParameter("cat_nm"));
String n_item_code	= parseNull(request.getParameter("n_item_code"));
String n_item_nm	= parseNull(request.getParameter("n_item_nm"));
String n_item_dt_nm	= parseNull(request.getParameter("n_item_dt_nm"));
String n_item_expl	= parseNull(request.getParameter("n_item_expl"));
String upd_reason	= parseNull(request.getParameter("upd_reason"));

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
				out.println("alert('오류가 발생하였습니다. 관리자에게 문의하세요.');");
				out.println("location.href='food_update_list.jsp'");
				out.println("</script>");
			} else {
				out.println("<script>");
				out.println("alert('오류가 발생하였습니다. 관리자에게 문의하세요.');");
				out.println("history.back();");
				out.println("</script>");
			}

		} else {
			out.println("<script>");
			out.println("alert('비정상적인 값입니다. 다시 확인 후 시도하세요.');");
			out.println("history.back();");
			out.println("</script>");
		}
	//반영 처리
	} else if ("".equals(mode)) {

	//미반영 처리
	} else if ("".equals(mode)) {

	}
	
}catch(Exception e){
	out.println(e.toString());
}

%>