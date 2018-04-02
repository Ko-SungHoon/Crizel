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

String zone_no 		= parseNull(request.getParameter("zone_no"));

StringBuffer sql 		= null;
Object[] setObj			= null;
List<FoodVO> teamList	=	null;

try {
	sql = new StringBuffer();
	sql.append("SELECT *					");
	sql.append("FROM FOOD_TEAM				");
	sql.append("WHERE ZONE_NO = ?			");
	sql.append("	AND SHOW_FLAG = 'Y'		");
	sql.append("ORDER BY ORDER1, TEAM_NM	");
	teamList = jdbcTemplate.query(sql.toString(), new FoodList(), zone_no);
} catch (Exception e) {
    out.println(e.toString());
	e.printStackTrace();
	//alertBack(out, "처리중 오류가 발생하였습니다.");
}
%>
	<option value="">팀선택</option>
<%
if(teamList != null && teamList.size() > 0){
	for(FoodVO ob : teamList){
%>
	<option value="<%=ob.team_no%>"><%=ob.team_nm %></option>
<%
	}
}
%>	
                                                                                                            