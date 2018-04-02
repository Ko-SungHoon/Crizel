<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

String sch_no 		= parseNull(request.getParameter("sch_no"));
String sch_app_flag	= parseNull(request.getParameter("sch_app_flag"));
String returnVal	= "NO";

StringBuffer sql 		= null;
int result 				= 0;

try {
    //일괄승인
    if (sch_no.contains(",")) {
        
        String sch_no_arr[] =   sch_no.split(",");
        int sch_no_cnt      =   sch_no_arr.length;
        
        for (int i = 0; i < sch_no_arr.length; i++) {
            sql = new StringBuffer();
            sql.append("UPDATE FOOD_SCH_TB SET			");
            sql.append("	  SCH_APP_FLAG = ?			");
            if("Y".equals(sch_app_flag)){
                sql.append("	, APP_DATE = SYSDATE	");
            }else{
                sql.append("	, APP_DATE = NULL		");
            }
            sql.append("WHERE SCH_NO = ?				");
            result  +=  jdbcTemplate.update(sql.toString(),
                    new Object[]{sch_app_flag, sch_no_arr[i]}
                    );
        }
        
        if (result == sch_no_cnt) {
            returnVal = "OK";
        }
    //단건 승인
    } else {
        sql = new StringBuffer();
        sql.append("UPDATE FOOD_SCH_TB SET			");
        sql.append("	  SCH_APP_FLAG = ?			");
        if("Y".equals(sch_app_flag)){
            sql.append("	, APP_DATE = SYSDATE	");
        }else{
            sql.append("	, APP_DATE = NULL		");
        }
        sql.append("WHERE SCH_NO = ?				");
        result = jdbcTemplate.update(sql.toString(),
                new Object[]{sch_app_flag, sch_no}
                );

        if(result > 0){
            returnVal = "OK";
        }
    }
	
} catch (Exception e) {
    out.println(e.toString());
	e.printStackTrace();
	//alertBack(out, "처리중 오류가 발생하였습니다.");
}
%>      
<%=returnVal%>                                                                                                  
