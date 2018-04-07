<%
/**
*   PURPOSE :   조사자 조사식품 추가/삭제 - 액션
*   CREATE  :   20180406_fri    JI
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

String mode		=   parseNull(request.getParameter("mode"), "");
String item_no	=   parseNull(request.getParameter("item_no"));
String sch_id	=   parseNull(request.getParameter("sch_id"));
String sch_no	=   parseNull(request.getParameter("sch_no"));

StringBuffer sql    =   null;
int result 			=   0;
int chk_cnt         =   0;
int item_comp_no    =   0;

List<FoodVO> foodCompList   =   null;

if (mode != null && mode.length() > 0) {

    //조사식품 추가
    if ("add".equals(mode)) {
        //중복 추가인지 확인
        sql = new StringBuffer();
        sql.append("SELECT NVL(COUNT(*), 0)             ");
        sql.append("FROM FOOD_RSCH_ITEM                 ");
        sql.append("WHERE ITEM_NO = ?                   ");
        sql.append("    AND SCH_NO =                    ");
        sql.append("    (SELECT SCH_NO FROM FOOD_SCH_TB ");
        sql.append("    WHERE SCH_ID = ?)               ");
        chk_cnt =   jdbcTemplate.queryForObject(sql.toString(), Integer.class, new Object[]{item_no, sch_id});

        if (chk_cnt > 0) {
            out.println("<script>");
            out.println("alert(\"중복된 식품은 등록할 수 없습니다.\");");
            out.println("history.back();");
            out.println("</script>");
            return;
        }

        //비교 식품인지 확인 후 insert
        sql =   new StringBuffer();
        sql.append("SELECT NVL(COUNT(*),0)      ");
        sql.append("FROM FOOD_ITEM_PRE          ");
        sql.append("WHERE ITEM_COMP_NO =        ");
        sql.append("    (SELECT ITEM_COMP_NO    ");
        sql.append("    FROM FOOD_ITEM_PRE      ");
        sql.append("    WHERE ITEM_NO = ?)      ");
        chk_cnt =   jdbcTemplate.queryForObject(sql.toString(), Integer.class, new Object[]{item_no});

        if (chk_cnt > 0) {

            sql =   new StringBuffer();
            sql.append("SELECT                      ");
            sql.append("    ITEM_NO                 ");
            sql.append("FROM FOOD_ITEM_PRE          ");
            sql.append("WHERE ITEM_COMP_NO =        ");
            sql.append("    (SELECT ITEM_COMP_NO    ");
            sql.append("    FROM FOOD_ITEM_PRE      ");
            sql.append("    WHERE ITEM_NO = ?)      ");
            foodCompList    =   jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{item_no});
            for (FoodVO vo : foodCompList) {
                result  =   0;
                sql =   new StringBuffer();
                sql.append("INSERT INTO FOOD_RSCH_ITEM                          ");
                sql.append("(   RSCH_ITEM_NO,                                   ");
                sql.append("    ITEM_NO,                                        ");
                sql.append("    SCH_NO,                                         ");
                sql.append("    NU_NO,                                          ");
                sql.append("    FILE_NO,                                        ");
                sql.append("    REG_YEAR,                                       ");
                sql.append("    REG_MON                                         ");
                sql.append(")                                                   ");
                sql.append("VALUES(                                             ");
                sql.append("    (SELECT NVL(MAX(RSCH_ITEM_NO) + 1, 1)           "); //RSCH_ITEM_NO
                sql.append("    FROM FOOD_RSCH_ITEM),                           ");
                sql.append("    ?,                                              "); //ITEM_NO
                sql.append("    (SELECT SCH_NO FROM FOOD_SCH_TB                 "); //SCH_NO
                sql.append("    WHERE SCH_ID = ?),                              ");
                sql.append("    (SELECT NVL(MIN(NU_NO), 1)                      "); //NU_NO
                sql.append("    FROM FOOD_SCH_NU WHERE SCH_NO =                 ");
                sql.append("    (SELECT SCH_NO FROM FOOD_SCH_TB                 ");
                sql.append("    WHERE SCH_ID = ?) ),                            ");
                sql.append("    (SELECT MAX(FILE_NO)                            "); //FILE_NO
                sql.append("    FROM FOOD_UP_FILE WHERE SUC_FLAG = 'Y'),        ");
                sql.append("    (SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL),  "); //REG_YEAR
                sql.append("    (SELECT EXTRACT(MONTH FROM SYSDATE) FROM DUAL)  "); //REG_MONTH
                sql.append(")                                                   ");
                result  =   jdbcTemplate.update(sql.toString(), new Object[]{vo.item_no, sch_id, sch_id});
            }

        } else {

            sql =   new StringBuffer();
            sql.append("INSERT INTO FOOD_RSCH_ITEM                          ");
            sql.append("(   RSCH_ITEM_NO,                                   ");
            sql.append("    ITEM_NO,                                        ");
            sql.append("    SCH_NO,                                         ");
            sql.append("    NU_NO,                                          ");
            sql.append("    FILE_NO,                                        ");
            sql.append("    REG_YEAR,                                       ");
            sql.append("    REG_MON                                         ");
            sql.append(")                                                   ");
            sql.append("VALUES(                                             ");
            sql.append("    (SELECT NVL(MAX(RSCH_ITEM_NO) + 1, 1)           "); //RSCH_ITEM_NO
            sql.append("    FROM FOOD_RSCH_ITEM),                           ");
            sql.append("    ?,                                              "); //ITEM_NO
            sql.append("    (SELECT SCH_NO FROM FOOD_SCH_TB                 "); //SCH_NO
            sql.append("    WHERE SCH_ID = ?),                              ");
            sql.append("    (SELECT NVL(MIN(NU_NO), 1)                      "); //NU_NO
            sql.append("    FROM FOOD_SCH_NU WHERE SCH_NO =                 ");
            sql.append("    (SELECT SCH_NO FROM FOOD_SCH_TB                 ");
            sql.append("    WHERE SCH_ID = ?) ),                            ");
            sql.append("    (SELECT MAX(FILE_NO)                            "); //FILE_NO
            sql.append("    FROM FOOD_UP_FILE WHERE SUC_FLAG = 'Y'),        ");
            sql.append("    (SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL),  "); //REG_YEAR
            sql.append("    (SELECT EXTRACT(MONTH FROM SYSDATE) FROM DUAL)  "); //REG_MONTH
            sql.append(")                                                   ");
            result  =   jdbcTemplate.update(sql.toString(), new Object[]{item_no, sch_id, sch_id});

        }
        if (result > 0) {
            out.println("<script>");
            out.println("alert(\"정상적으로 처리되었습니다.\");");
            out.println("opener.location.reload();");
            out.println("window.close();");
            out.println("</script>");
        } else {
            out.println("<script>");
            out.println("alert(\" 오류가 발생하였습니다. 관리자에게 문의하세요.\");");
            out.println("history.back();");
            out.println("</script>");
        }


    //조사식품 삭제
    } else if ("del".equals(mode)) {

        //1st. 비교 그룹 군 확인
        sql =   new StringBuffer();
        sql.append("SELECT                  ");
        sql.append("NVL(ITEM_COMP_NO, 0)    ");
        sql.append("FROM FOOD_ITEM_PRE      ");
        sql.append("WHERE ITEM_NO = ?       ");
        item_comp_no    =   jdbcTemplate.queryForObject(sql.toString(), Integer.class, new Object[]{item_no});

        //2nd. 비교 그룹군 확인
        if (item_comp_no > 0) {

            sql =   new StringBuffer();
            sql.append("SELECT                  ");
            sql.append("    ITEM_NO             ");
            sql.append("FROM FOOD_ITEM_PRE      ");
            sql.append("WHERE ITEM_COMP_NO = ?  ");
            foodCompList    =   jdbcTemplate.query(sql.toString(), new FoodList(), new Object[]{item_comp_no});

            for (FoodVO vo : foodCompList) {
                result  =   0;
                sql =   new StringBuffer();
                sql.append("DELETE                          ");
                sql.append("FROM FOOD_RSCH_ITEM             ");
                sql.append("WHERE ITEM_NO = ? AND SCH_NO = ?");
                result  =   jdbcTemplate.update(sql.toString(), new Object[]{vo.item_no, sch_no});
            }

        } else {
            sql =   new StringBuffer();
            sql.append("DELETE                              ");
            sql.append("FROM FOOD_RSCH_ITEM                 ");
            sql.append("WHERE ITEM_NO = ? AND SCH_NO = ?    ");
            result      =   jdbcTemplate.update(sql.toString(), new Object[]{item_no, sch_no});
        }

        if (result > 0) {
            out.println("<script>");
            out.println("alert(\"정상적으로 처리되었습니다.\");");
            out.println("location.href=\"food_research_view.jsp?sch_no="+sch_no+"\"");
            out.println("</script>");
        } else {
            out.println("<script>");
            out.println("alert(\" 오류가 발생하였습니다. 관리자에게 문의하세요.\");");
            out.println("history.back();");
            out.println("</script>");
        }

    }

} else {
    out.println("<script>");
    out.println("alert(\"파라미터 이상입니다. 관리자에게 문의하세요.\");");
    out.println("history.back();");
    out.println("</script>");
    return;
}

%>