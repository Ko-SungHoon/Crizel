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

String mode			= parseNull(request.getParameter("mode"));
String zone_no 		= parseNull(request.getParameter("zone_no"));
String cat_no 		= parseNull(request.getParameter("cat_no"));
String team_no 		= parseNull(request.getParameter("team_no"));

StringBuffer sql 			= null;
Object[] setObj				= null;
List<FoodVO> teamList		= null;
List<FoodVO> joList			= null;
List<FoodVO> catList		= null;
List<FoodVO> regTeamList	= null;

try {
	if("team".equals(mode)){
		sql = new StringBuffer();
		sql.append("SELECT FOOD_TEAM.*,					");
		sql.append("	(SELECT CAT_NM FROM FOOD_ST_CAT	");
		sql.append("	WHERE CAT_NO = FOOD_TEAM.CAT_NO	");
		sql.append("	) AS CAT_NM						");
		sql.append("FROM FOOD_TEAM						");
		sql.append("WHERE ZONE_NO = ? 					");
		if(!"".equals(cat_no)){
			sql.append("AND CAT_NO = ?					");
		}
		sql.append("	AND SHOW_FLAG = 'Y'				");
		sql.append("ORDER BY ORDER1, TEAM_NM			");
		if("".equals(cat_no)){
			teamList = jdbcTemplate.query(sql.toString(), new FoodList(), zone_no);
		}else{
			teamList = jdbcTemplate.query(sql.toString(), new FoodList(), zone_no, cat_no);
		}
		
		
		if(teamList != null && teamList.size() > 0){
			for(FoodVO ob : teamList){
				out.println("<option value='" + ob.team_no + "'>"+ ob.cat_nm + "-" + ob.team_nm +"</option>");
			}
		}
	}else if("jo".equals(mode)){
		sql = new StringBuffer();
		sql.append("SELECT *					");
		sql.append("FROM FOOD_JO				");
		sql.append("WHERE   TEAM_NO = ?			");
		sql.append("ORDER BY JO_NM				");
		joList = jdbcTemplate.query(sql.toString(), new FoodList(), team_no);
		
		if(joList != null && joList.size() > 0){
			for(FoodVO ob : joList){
				out.println("<option value='" + ob.jo_no + "'>"+ ob.jo_nm +"</option>");
			}
		}
	}else if("cat".equals(mode)){
		sql = new StringBuffer();
		sql.append("SELECT * FROM FOOD_ST_CAT WHERE SHOW_FLAG = 'Y' ORDER BY CAT_NM		");
		catList = jdbcTemplate.query(sql.toString(), new FoodList());
		if(catList != null && catList.size() > 0){
			for(FoodVO ob : catList){
				out.println("<option value='" + ob.cat_no + "'>"+ ob.cat_nm +"</option>");
			}
		}
	}else if("reg_team".equals(mode)){
		
		sql	=	new StringBuffer();
		sql.append(" SELECT								\n");
		sql.append(" TEAM.TEAM_NO,						\n");
		sql.append(" TEAM.TEAM_NM,						\n");
		sql.append(" CAT.CAT_NO,						\n");
		sql.append(" CAT.CAT_NM							\n");
		sql.append(" FROM FOOD_TEAM	TEAM				\n");
		sql.append(" LEFT JOIN FOOD_ST_CAT CAT			\n");
		sql.append(" ON TEAM.CAT_NO = CAT.CAT_NO		\n");
		sql.append(" WHERE ZONE_NO = ?					\n");
		sql.append(" AND TEAM.SHOW_FLAG = 'Y' 			\n");
		sql.append(" AND CAT.SHOW_FLAG = 'Y' 			\n");
		sql.append(" ORDER BY ORDER1, ORDER2, ORDER3	\n");
		
		regTeamList	=	jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{zone_no});
		
		if(regTeamList != null && regTeamList.size() > 0){
			for(FoodVO ob : regTeamList){
				out.println("<option value='" + ob.team_no + "'>" + ob.cat_nm + " " + ob.team_nm + "</option>");
			}
		}
	}
	
} catch (Exception e) {
    out.println(e.toString());
	e.printStackTrace();
	//alertBack(out, "처리중 오류가 발생하였습니다.");
}
%>	
                                                                                                            