<%
/**
*   PURPOSE :   업데이트 요청 등록 jsp
*   CREATE  :   20180412_thur    JI
*   MODIFY  :   ...
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

String mode			=   parseNull(request.getParameter("mode"));

String s_item_no    =   parseNull(request.getParameter("s_item_no"));
String cat_no       =   parseNull(request.getParameter("cat_no"));
String foodName     =   parseNull(request.getParameter("foodName"));
String n_cat_no     =   parseNull(request.getParameter("n_cat_no"));
String n_item_nm    =   parseNull(request.getParameter("n_item_nm"));
String n_item_code  =   parseNull(request.getParameter("n_item_code"));
String n_item_dt_nm =   parseNull(request.getParameter("n_item_dt_nm"));
String n_item_expl  =   parseNull(request.getParameter("n_item_expl"));
String n_item_unit  =   parseNull(request.getParameter("n_item_unit"));

String selRequester =   parseNull(request.getParameter("selRequester"));
String upd_reason   =   parseNull(request.getParameter("upd_reason"));


Object[] setObj         = null;
List<String> setList	= new ArrayList<String>();

StringBuffer sql 	=   null;
int result 			=   0;

out.println("s_item_no ::  "+ s_item_no + "<br>");
out.println("cat_no ::  "+ cat_no + "<br>");
out.println("foodName ::  "+ foodName + "<br>");
out.println("n_item_nm ::  "+ n_item_nm + "<br>");
out.println("n_item_code ::  "+ n_item_code + "<br>");
out.println("n_item_dt_nm ::  "+ n_item_dt_nm + "<br>");
out.println("n_item_expl ::  "+ n_item_expl + "<br>");
out.println("n_item_unit ::  "+ n_item_unit + "<br>");

out.println("selRequester ::  "+ selRequester + "<br>");
out.println("upd_reason ::  "+ upd_reason + "<br>");

try{

    sql =   new StringBuffer();
    sql.append(" INSERT INTO FOOD_UPDATE ");
    sql.append(" (UPD_NO,       ");
    sql.append(" SCH_NO,        ");
    sql.append(" NU_NO,         ");
    sql.append(" S_ITEM_NO,     ");
    sql.append(" N_CAT_NO,      ");
    sql.append(" N_ITEM_NM,     ");
    sql.append(" N_ITEM_CODE,   ");
    sql.append(" N_ITEM_DT_NM,  ");
    sql.append(" N_ITEM_EXPL,   ");
    sql.append(" N_ITEM_UNIT,   ");
    sql.append(" UPD_FLAG,      ");
    sql.append(" UPD_REASON,    ");
    sql.append(" STS_FLAG,      ");
    sql.append(" REG_DATE,      ");
    sql.append(" SHOW_FLAG      ");
    sql.append(" )              ");
    sql.append(" VALUES (       ");
    sql.append(" (SELECT NVL(MAX(UPD_NO)+1, 1) FROM FOOD_UPDATE),   ");  //UPD_NO
    sql.append(" (SELECT SCH_NO FROM FOOD_SCH_NU WHERE NU_NO = ?),  ");  //SCH_NO
    sql.append(" ?,             ");  //NU_NO
    sql.append(" ?,             ");  //S_ITEM_NO
    if ("mod".equals(mode) || "del".equals(mode)) {
        sql.append(" (SELECT B.CAT_NO FROM FOOD_ITEM_PRE A JOIN FOOD_ST_ITEM B ON A.ITEM_NO = B.ITEM_NO WHERE S_ITEM_NO = ?),");  //N_CAT_NO
    } else if ("add".equals(mode)) {
        sql.append(" ?,         ");  //N_CAT_NO
    }
    sql.append(" ?,             ");  //N_ITEM_CODE
    sql.append(" ?,             ");  //N_ITEM_NM
    sql.append(" ?,             ");  //N_ITEM_DT_NM
    sql.append(" ?,             ");  //N_ITEM_EXPL
    sql.append(" ?,             ");  //N_ITEM_UNIT
    sql.append(" ?,             ");  //UPD_FLAG
    sql.append(" ?,             ");  //UPD_REASON
    sql.append(" ?,             ");  //STS_FLAG
    sql.append(" SYSDATE,       ");  //REG_DATE
    sql.append(" 'Y'            ");  //SHOW_FLAG
    sql.append(" )              ");

    //변경
    if ("mod".equals(mode)) {
        setObj  =   new Object[] {
            selRequester,
            selRequester,
            s_item_no,
            s_item_no,
            n_item_nm,
            n_item_code,
            n_item_dt_nm,
            n_item_expl,
            n_item_unit,
            "M",
            upd_reason,
            "N",
        };

    //추가
    } else if ("add".equals(mode)) {
        setObj  =   new Object[] {
            selRequester,
            selRequester,
            "-1",
            n_cat_no,
            n_item_nm,
            n_item_code,
            n_item_dt_nm,
            n_item_expl,
            n_item_unit,
            "A",
            upd_reason,
            "N",
        };

    //삭제
    } else if ("del".equals(mode)) {
        setObj  =   new Object[] {
            selRequester,
            selRequester,
            s_item_no,
            s_item_no,
            n_item_nm,
            n_item_code,
            n_item_dt_nm,
            n_item_expl,
            n_item_unit,
            "D",
            upd_reason,
            "N",
        };
    }

    result  =   jdbcTemplate.update(sql.toString(), setObj);

    if (result > 0) {
        out.println("<script>");
        out.println("alert('정상적으로 처리되었습니다.');");
        out.println("window.opener.location.reload();");
        out.println("window.close();");
        out.println("</script>");
    } else {
        out.println("<script>");
        out.println("alert('오류 입니다. 관리자에게 문의하세요.');");
        out.println("history.back();");
        out.println("</script>");
    }


}catch(Exception e){
	out.println(e.toString());
}

%>