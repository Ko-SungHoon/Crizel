<%
/**
*   PURPOSE :   구분 - 액션
*   CREATE  :   20180322_thu    Ko
*   MODIFY  :   단위 삭제 시 사용여부 확인 후 삭제    20180323_fri    JI
*   MODIFY  :   화폐 단위는 수정 불가 및 타입 수정 불가    20180323_fri    JI
*	MODIFY  :   batch 방식 변경 20180424_tue    KO
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ page import="org.springframework.jdbc.core.*" %>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

String mode				= parseNull(request.getParameter("mode"));           //처리 구분

String cat_no           = parseNull(request.getParameter("cat_no"));         //구분 번호
String cat_nm			= parseNull(request.getParameter("cat_nm"));         //식품구분명
String show_flag		= parseNull(request.getParameter("show_flag"), "Y"); //노출여부
String unit_no			= parseNull(request.getParameter("unit_no"));        //단위 번호
String unit_val			= parseNull(request.getParameter("unit_val"));       //단위 수치
String unit_nm			= parseNull(request.getParameter("unit_nm"));        //단위 명
String unit_type		= parseNull(request.getParameter("unit_type"));      //P=화폐, F=식품

String[] unit_nm_arr 	= request.getParameterValues("unit_nm_arr");
String[] unit_no_arr 	= request.getParameterValues("unit_no_arr");
//String[] unit_type_arr 	= request.getParameterValues("unit_type_arr");

Connection conn 		= null;
PreparedStatement pstmt = null;
StringBuffer sql 		= null;
int result 				= 0;
int key					= 0;

try{
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

/** CAT PART **/
	if("catInsert".equals(mode)){
		sql = new StringBuffer();
		sql.append("INSERT INTO FOOD_ST_CAT(													");
		sql.append("	CAT_NO, CAT_NM, REG_DATE, MOD_DATE, SHOW_FLAG, UNIT_NO, UNIT_VAL		");
		sql.append(")																			");
		sql.append("VALUES(																		");
		sql.append("	(SELECT NVL(MAX(CAT_NO)+1, 1) FROM FOOD_ST_CAT )						");
		sql.append("	, ?																		");
		sql.append("	, SYSDATE																");
		sql.append("	, SYSDATE																");
		sql.append("	, ?																		");
		sql.append("	, ?																		");
		sql.append("	, ?																		");
		sql.append(")																			");
		result = jdbcTemplate.update(sql.toString(), cat_nm, show_flag, unit_no, unit_val);
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_cat_popup.jsp');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}
	}
	//구분 노출, 숨김(소속 식품이 있는 지 확인 후 숨김 처리)
    else if("catDelete".equals(mode)){
        
        int cat_food_cnt    =   0;
        //숨김. 소속 식품 확인해야 함.
        if ("N".equals(show_flag)) {
            sql =   new StringBuffer();
            sql.append("SELECT NVL(COUNT(*), 0) FROM FOOD_ST_ITEM WHERE CAT_NO = ? AND SHOW_FLAG = 'Y' ");
            cat_food_cnt    =   jdbcTemplate.queryForObject(sql.toString(), new Object[]{cat_no}, Integer.class);
        }
        if ("N".equals(show_flag) && cat_food_cnt > 0) {
            out.println("<script>");
            out.println("alert('등록된 식품이 있어 숨김처리 할 수 없습니다. 다시한번 확인하세요.');");
            out.println("location.replace('food_cat_popup.jsp');");
            out.println("opener.location.reload();");
            out.println("</script>");
        } else {
            sql =   new StringBuffer();
            sql.append("UPDATE FOOD_ST_CAT SET SHOW_FLAG = ? WHERE CAT_NO = ? ");
            result  =   jdbcTemplate.update(sql.toString(), show_flag, cat_no);
            if (result>0) {
                out.println("<script>");
                out.println("alert('정상적으로 처리되었습니다.');");
                out.println("location.replace('food_cat_popup.jsp');");
                out.println("opener.location.reload();");
                out.println("</script>");
            }//END IF
        }
        
    }
    //구분. 정보 업데이트
    else if("catUpdate".equals(mode)){
                
        sql =   new StringBuffer();
        sql.append("UPDATE FOOD_ST_CAT SET ");
        sql.append(" CAT_NM = ? ");
        sql.append(" , UNIT_NO = ? ");
        sql.append(" , UNIT_VAL = ? ");
        sql.append(" , MOD_DATE = SYSDATE ");
        sql.append(" WHERE CAT_NO = ? ");
        result  =   jdbcTemplate.update(sql.toString(), cat_nm, unit_no, unit_val, cat_no);
        if (result > 0) {
            out.println("<script>");
            out.println("alert('정상적으로 처리되었습니다.');");
            out.println("location.replace('food_cat_popup.jsp');");
            out.println("opener.location.reload();");
            out.println("</script>");
        } else {
            out.println(sql.toString());
        }
        
    }
/** END CAT PART **/
/** UNIT PART **/
	//단위 등록
	else if("unitInsert".equals(mode)){
		sql = new StringBuffer();
		sql.append("INSERT INTO FOOD_ST_UNIT(												");
		sql.append("	UNIT_NO, UNIT_NM, UNIT_TYPE, SHOW_FLAG, REG_DATE, MOD_DATE			");
		sql.append(")																		");
		sql.append("VALUES(																	");
		sql.append("	(SELECT NVL(MAX(UNIT_NO)+1, 1) FROM FOOD_ST_UNIT )					");
		sql.append("	, ?																	");
		sql.append("	, ?																	");
		sql.append("	, ?																	");
		sql.append("	, SYSDATE															");
		sql.append("	, SYSDATE															");
		sql.append(")																		");
		result = jdbcTemplate.update(sql.toString(), unit_nm, unit_type, show_flag);
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_unit_popup.jsp');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}
	}else if("unitUpdate".equals(mode)){
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_ST_UNIT SET	");
		sql.append("	  UNIT_NM = ?		");
		//sql.append("	, UNIT_TYPE = ?		");
		sql.append("WHERE UNIT_NO = ?		");
		
		pstmt = conn.prepareStatement(sql.toString());
		if(unit_no_arr!=null){
			for(int i=0; i<unit_no_arr.length; i++){
				key = 0;
				pstmt.setString(++key,  unit_nm_arr[i]);
				pstmt.setString(++key,  unit_no_arr[i]);
				pstmt.addBatch();
			}
		}
		int[] batchResult = pstmt.executeBatch();
		if(pstmt!=null){pstmt.close();}
		
		/* List<Object[]> batch = new ArrayList<Object[]>();
		if(unit_no_arr!=null){
			for(int i=0; i<unit_no_arr.length; i++){
				Object[] value = new Object[]{
						unit_nm_arr[i],
						//unit_type_arr[i],
						unit_no_arr[i]
				};
				batch.add(value);
			}
		}
		int[] batchResult = jdbcTemplate.batchUpdate(sql.toString(), batch); */
		result = batchResult.length;
		
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("window.close();");
			out.println("opener.location.reload();");
			out.println("</script>");
		}
	}else if("unitDelete".equals(mode)){
        
        int unit_cnt    =   0;
        sql =   new StringBuffer();
        sql.append("SELECT NVL(COUNT(*), 0) FROM FOOD_ST_CAT WHERE UNIT_NO = ? ");
        unit_cnt    =   jdbcTemplate.queryForObject(sql.toString(), new Object[]{unit_no}, Integer.class);
        
        if (unit_cnt > 0) {
            out.println("<script>");
			out.println("alert('해당 단위는 사용 중이라 삭제 할 수 없습니다.');");
			out.println("location.replace('food_unit_popup.jsp');");
			out.println("opener.location.reload();");
			out.println("</script>");
			sqlMapClient.endTransaction();
            return;
        }
        
		sql = new StringBuffer();
		sql.append("UPDATE FOOD_ST_UNIT SET		");
		sql.append("	SHOW_FLAG = 'N'			");
		sql.append("WHERE UNIT_NO = ?			");
		result = jdbcTemplate.update(sql.toString(), unit_no);
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('food_unit_popup.jsp');");
			out.println("opener.location.reload();");
			out.println("</script>");
		}
	}
}catch(Exception e){
	if(pstmt!=null){pstmt.close();}
	if(conn!=null){conn.close();}
	sqlMapClient.endTransaction();
	out.println(e.toString());
}finally {
	if(pstmt!=null){pstmt.close();}
	if(conn!=null){conn.close();}
	sqlMapClient.endTransaction();
}


%>

