<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

String srchSdate 		= parseNull(request.getParameter("srchSdate"));
String srchEdate 		= parseNull(request.getParameter("srchEdate"));

StringBuffer sql 			= null;
Object[] setObj				= null;
List<FoodVO> rschList		= null;
String html					= null;

try {
	sql = new StringBuffer();
	sql.append("SELECT * 					");
	sql.append("FROM FOOD_RSCH_TB TB		");
	sql.append("WHERE ((TB.STR_DATE >= TO_DATE(?, 'YY/MM/DD') AND TB.STR_DATE <= TO_DATE(?, 'YY/MM/DD'))			");
	sql.append("		OR (TB.END_DATE >= TO_DATE(?, 'YY/MM/DD') AND TB.END_DATE <= TO_DATE(?, 'YY/MM/DD')))		");
	sql.append("ORDER BY RSCH_NO DESC		");
	rschList = jdbcTemplate.query(sql.toString(), new FoodList(), srchSdate, srchEdate, srchSdate, srchEdate);
	
	if(rschList!=null && rschList.size()>0){
		html = new String();
		html += "<option value=''>조사 선택</option>";
		for(FoodVO ob : rschList){
			html += "<option value='"+ob.rsch_no+"'>"+ob.rsch_nm+"</option>";
		}
	}else{
		html = new String();
		html += "<option value=''>조사 선택</option>";
	}
	
	out.println(html);
	
} catch (Exception e) {
    out.println(e.toString());
	e.printStackTrace();
}
%>	
                                                                                                            