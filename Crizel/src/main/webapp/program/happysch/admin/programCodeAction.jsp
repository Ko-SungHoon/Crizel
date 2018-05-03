<%
/**
*   PURPOSE :   프로그램 분류 code table 등록/수정/삭제 action page
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
String type			= parseNull(request.getParameter("type"));

String code_tbl 	= "";
String code_name 	= "";
String code_col		= "";

if("sch".equals(type)){
	code_tbl 	= "HAPPY_PRO_SCH";
	code_name 	= "HAPPY_PRO_SCH";
	code_col	= "PRO_CAT_NM";
}else if("local".equals(type)){
	code_tbl 	= "HAPPY_PRO_LOCAL";
	code_name 	= "HAPPY_PRO_LOCAL";
	code_col	= "PRO_CAT_NM";
}else if("town".equals(type)){
	code_tbl 	= "HAPPY_PRO_TOWN";
	code_name 	= "HAPPY_PRO_TOWN";
	code_col	= "PRO_CAT_NM";
}

StringBuffer sql 		= null;
Object[] setObj 		= null;
int result 				= 0;

if("insert".equals(mode)){	//******************************** 추가 **************************************************************
	String code_val1 	= parseNull(request.getParameter("code_val1"));
	try{
		sql = new StringBuffer();
		sql.append("INSERT INTO HAPPY_PRO_CODE(									");
		sql.append("						ARTCODE_NO,							");
		sql.append("						CODE_TBL,							");
		sql.append("						CODE_COL,							");
		sql.append("						CODE_NAME,							");
		sql.append("						CODE_VAL1,							");
		sql.append("						CODE_VAL2,							");
		sql.append("						CODE_VAL3,							");
		sql.append("						ORDER1,								");
		sql.append("						ORDER2,								");
		sql.append("						ORDER3								");
		sql.append("						)									");
		sql.append("VALUES(														");
		sql.append("						(SELECT NVL(MAX(ARTCODE_NO)+1, 1)	");		//ARTCODE_NO
		sql.append("						FROM HAPPY_PRO_CODE),				");
		sql.append("						?,									");		//CODE_TBL
		sql.append("						?,									");		//CODE_COL
		sql.append("						?,									");		//CODE_NAME
		sql.append("						?,									");		//CODE_VAL1
		sql.append("						'',									");		//CODE_VAL2
		sql.append("						'',									");		//CODE_VAL3
		sql.append("						(SELECT NVL(MAX(ORDER1)+1, 1)		");		//ORDER1
		sql.append("						FROM HAPPY_PRO_CODE					");
		sql.append("						WHERE CODE_NAME = ?),				");
		sql.append("						0,									");		//ORDER2
		sql.append("						0									");		//ORDER3
		sql.append("		)													");
		
		setObj = new Object[]{code_tbl, code_col, code_name, code_val1, code_name};
		
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
			out.println("location.replace('/program/happysch/admin/programCodePopup.jsp?type="+type+"');");
			out.println("</script>");
			
		}
	}
}else if("delete".equals(mode)){		//******************************** 삭제 **************************************************************
	String artcode_no	= parseNull(request.getParameter("artcode_no"));

	Connection conn = null;
	PreparedStatement pstmt = null;
	
	try{
		sqlMapClient.startTransaction();
	    conn    =   sqlMapClient.getCurrentConnection();
	
		//해당 테이블 찾기
		String proTable	=	"";
		sql	=	new StringBuffer();
		sql.append("SELECT CODE_TBL FROM HAPPY_PRO_CODE WHERE ARTCODE_NO = "+ artcode_no +" ");
		proTable =	jdbcTemplate.queryForObject(sql.toString(), String.class);

		//해당 테이블에서 사용 유무 확인
		int catCnt	=	0;
		sql	=	new StringBuffer();
		sql.append("SELECT NVL(COUNT(*), 0) FROM "+proTable+" ");
		sql.append(" WHERE PRO_CAT_NM = (SELECT CODE_VAL1 FROM HAPPY_PRO_CODE WHERE ARTCODE_NO = "+ artcode_no +") ");
		catCnt	=	jdbcTemplate.queryForObject(sql.toString(), Integer.class);

		//사용하지 않을 경우에만 삭제
		if (catCnt < 1) {
			sql = new StringBuffer();
			sql.append("DELETE FROM HAPPY_PRO_CODE	");
			sql.append("WHERE ARTCODE_NO = ?		");
			
			setObj = new Object[]{artcode_no};
			
			result = jdbcTemplate.update(
						sql.toString(), 
						setObj
					);
		} 

	}catch(Exception e){
		out.println(e.toString());
	}finally{
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("opener.location.reload();");
			out.println("location.replace('/program/happysch/admin/programCodePopup.jsp?type="+type+"');");
			out.println("</script>");
		} else {
			out.println("<script>");
			out.println("alert('해당 분류는 사용 중에 있어 삭제 할 수 없습니다.');");
			out.println("opener.location.reload();");
			out.println("location.replace('/program/happysch/admin/programCodePopup.jsp?type="+type+"');");
			out.println("</script>");
		}
	}
}else if("update".equals(mode)){		//******************************** 수정 **************************************************************
	String[] artcode_no 	= request.getParameterValues("artcode_no");
	String[] order1 		= request.getParameterValues("order1");
	String[] code_val1 		= request.getParameterValues("code_val1");
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	
	try{
		sqlMapClient.startTransaction();
	    conn    =   sqlMapClient.getCurrentConnection();

		/* cate name 을 쓰고 있는 pro_table pro_cat_nm 수정하기	JI */
		String proTable	=	null;
		for (int j = 0; j < artcode_no.length; j++) {
			proTable	=	"";
			sql	=	new StringBuffer();
			sql.append("SELECT CODE_TBL FROM HAPPY_PRO_CODE WHERE ARTCODE_NO = ? ");
			proTable =   jdbcTemplate.queryForObject(sql.toString(), new Object[]{artcode_no[j]}, String.class);

			out.println(proTable + "<br>");

			sql		=	new StringBuffer();
			sql.append(" UPDATE "+proTable+" SET PRO_CAT_NM = '"+code_val1[j]+"' ");
			sql.append(" WHERE PRO_CAT_NM = (SELECT CODE_VAL1 FROM HAPPY_PRO_CODE WHERE ARTCODE_NO = "+artcode_no[j]+") ");
			result	=	jdbcTemplate.update(sql.toString()/*, new Object[]{proTable, code_val1[j], artcode_no[j]}*/);
		}/*END FOR*/

		if (result > 0) {
			result	=	0;

			sql = new StringBuffer();
			sql.append("UPDATE HAPPY_PRO_CODE				");
			sql.append("SET	CODE_VAL1 	= ?,				");
			sql.append("	ORDER1 		= ?					");
			sql.append("WHERE ARTCODE_NO = ?				");
			pstmt   =   conn.prepareStatement(sql.toString());
			for (int i = 0; i < artcode_no.length; i++) {
				pstmt.setString(1, code_val1[i]);
				pstmt.setString(2, order1[i]);
				pstmt.setString(3, artcode_no[i]);
				pstmt.addBatch();
			}
			int[] count =   pstmt.executeBatch();
			result      =   count.length;
		}//END IF
		
	}catch(Exception e){
		out.println(e.toString());
		sqlMapClient.endTransaction();
	}finally{
		if(conn!=null){conn.close();}
		if(pstmt!=null){pstmt.close();}
		sqlMapClient.endTransaction();
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("opener.location.reload();");
			out.println("location.replace('/program/happysch/admin/programCodePopup.jsp?type="+type+"');");
			out.println("</script>");
			
		}
	}
}


%>
