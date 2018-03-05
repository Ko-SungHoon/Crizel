<%
/**
*   PURPOSE :   프로그램/악기 분류 code table 등록/수정/삭제 action page
*   CREATE  :   20180130_tue    Ko
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

if("alway".equals(type)){
	code_tbl 	= "ART_PRO_ALWAY";
	code_name 	= "ART_PRO_ALWAY";
	code_col	= "PRO_CAT_NM";
}else if("deep".equals(type)){
	code_tbl 	= "ART_PRO_DEEP";
	code_name 	= "ART_PRO_DEEP";
	code_col	= "PRO_CAT_NM";
}else if("inst".equals(type)){
	code_tbl 	= "ART_INST_MNG";
	code_name 	= "ART_INST_MNG";
	code_col	= "INST_CAT_NM";
}

StringBuffer sql 		= null;
Object[] setObj 		= null;
int result 				= 0;

if("insert".equals(mode)){	//******************************** 추가 **************************************************************
	String code_val1 	= parseNull(request.getParameter("code_val1"));
	try{
		sql = new StringBuffer();
		sql.append("INSERT INTO ART_PRO_CODE(									");
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
		sql.append("						FROM ART_PRO_CODE),					");
		sql.append("						?,									");		//CODE_TBL
		sql.append("						?,									");		//CODE_COL
		sql.append("						?,									");		//CODE_NAME
		sql.append("						?,									");		//CODE_VAL1
		sql.append("						'',									");		//CODE_VAL2
		sql.append("						'',									");		//CODE_VAL3
		sql.append("						(SELECT NVL(MAX(ORDER1)+1, 1)		");		//ORDER1
		sql.append("						FROM ART_PRO_CODE					");
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
			out.println("location.replace('/program/art/admin/programCodePopup.jsp?type="+type+"');");
			out.println("</script>");
			
		}
	}
}else if("delete".equals(mode)){		//******************************** 삭제 **************************************************************
	String artcode_no	= parseNull(request.getParameter("artcode_no"));

	try{
		sql = new StringBuffer();
		sql.append("DELETE FROM ART_PRO_CODE					");
		sql.append("WHERE ARTCODE_NO = ?						");
		
		setObj = new Object[]{artcode_no};
		
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
			out.println("location.replace('/program/art/admin/programCodePopup.jsp?type="+type+"');");
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
	    
		sql = new StringBuffer();
		sql.append("UPDATE ART_PRO_CODE					");
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
			out.println("location.replace('/program/art/admin/programCodePopup.jsp?type="+type+"');");
			out.println("</script>");
			
		}
	}
}


%>
