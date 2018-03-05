<%
/**
*   PURPOSE :   악기 추가 action page
*   CREATE  :   20180130_tue    Ko
*   MODIFY  :   ....
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ page import="java.io.File, java.io.IOException, com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.util.Enumeration"%>
<%
/** 파라미터 UTF-8처리 **/
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");
String root = request.getSession().getServletContext().getRealPath("/");
String directory = "/program/art/upload/";
MultipartRequest mr = new MultipartRequest(request, root+directory, 10*1024*1024, "UTF-8", new DefaultFileRenamePolicy());

String mode			= parseNull(mr.getParameter("mode"));

StringBuffer sql 		= null;
Object[] setObj 		= null;
int result 				= 0;

if("insert".equals(mode)){	//******************************** 추가 **************************************************************
	Enumeration files 	= mr.getFileNames();
	String file1		= (String)files.nextElement();
	String real_img 	= mr.getOriginalFileName(file1);
	String save_img 	= mr.getFilesystemName(file1);
	
	String inst_cat_nm 	= parseNull(mr.getParameter("inst_cat_nm"));
	String inst_name 	= parseNull(mr.getParameter("inst_name"));
	String inst_memo 	= parseNull(mr.getParameter("inst_memo"));
	String curr_cnt 	= parseNull(mr.getParameter("curr_cnt"));
	String max_cnt 		= parseNull(mr.getParameter("max_cnt"));
	String inst_size 	= parseNull(mr.getParameter("inst_size"));
	String inst_model 	= parseNull(mr.getParameter("inst_model"));
	String inst_pic	 	= directory + save_img;
	String inst_lca	 	= parseNull(mr.getParameter("inst_lca"));
	String reg_id		= parseNull(mr.getParameter("reg_id"));
	String reg_ip		= parseNull(mr.getParameter("reg_ip"));
	String show_flag	= parseNull(mr.getParameter("show_flag"));

	try{
		sql = new StringBuffer();
		sql.append("INSERT INTO ART_INST_MNG(									");
		sql.append("						INST_NO,							");
		sql.append("						INST_CAT,							");
		sql.append("						INST_CAT_NM,						");
		sql.append("						INST_NAME,							");
		sql.append("						INST_MEMO,							");
		sql.append("						CURR_CNT,							");
		sql.append("						MAX_CNT,							");
		sql.append("						INST_SIZE,							");
		sql.append("						INST_MODEL,							");
		sql.append("						INST_PIC,							");
		sql.append("						INST_LCA,							");
		sql.append("						REG_ID,								");
		sql.append("						REG_IP,								");
		sql.append("						REG_DATE,							");
		sql.append("						MOD_DATE,							");
		sql.append("						SHOW_FLAG,							");
		sql.append("						DEL_FLAG							");
		sql.append("						)									");
		sql.append("VALUES(														");
		sql.append("						(SELECT NVL(MAX(INST_NO)+1, 1)		");		//INST_NO
		sql.append("						FROM ART_INST_MNG),					");
		sql.append("						'ART_INST_MNG',						");		//INST_CAT
		sql.append("						?,									");		//INST_CAT_NM
		sql.append("						?,									");		//INST_NAME
		sql.append("						?,									");		//INST_MEMO
		sql.append("						?,									");		//CURR_CNT
		sql.append("						?,									");		//MAX_CNT
		sql.append("						?,									");		//INST_SIZE
		sql.append("						?,									");		//INST_MODEL
		sql.append("						?,									");		//INST_PIC
		sql.append("						?,									");		//INST_LCA
		sql.append("						?,									");		//REG_ID
		sql.append("						?,									");		//REG_IP
		sql.append("						TO_CHAR(SYSDATE, 'YYYY-MM-DD'),		");		//REG_DATE
		sql.append("						TO_CHAR(SYSDATE, 'YYYY-MM-DD'),		");		//MOD_DATE
		sql.append("						?,									");		//SHOW_FLAG
		sql.append("						'N'									");		//DEL_FLAG
		sql.append("		)													");
		
		setObj = new Object[]{
								inst_cat_nm,
								inst_name,
								inst_memo,
								curr_cnt,
								max_cnt,
								inst_size,
								inst_model,
								inst_pic,
								inst_lca,
								reg_id,
								reg_ip,
								show_flag
							};
		
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
			out.println("location.replace('/program/art/insAdmin/instInsertPopup.jsp');");
			out.println("</script>");
		}
	}
}else if("delete".equals(mode)){		//******************************** 삭제 **************************************************************
	String inst_no 	= parseNull(request.getParameter("inst_no"));

	try{
		sql = new StringBuffer();
		sql.append("UPDATE ART_INST_MNG				");
		sql.append("	SET		DEL_FLAG = 'Y'		");
		sql.append("WHERE INST_NO = ?				");
		
		setObj = new Object[]{
						inst_no
							};
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
			out.println("location.replace('/program/art/admin/instMng.jsp');");
			out.println("</script>");
		}
	}
}else if("update".equals(mode)){		//******************************** 수정 **************************************************************
	String inst_pic	 	= parseNull(mr.getParameter("inst_pic"));
	if(mr.getFile("inst_pic") != null){
		Enumeration files 	= mr.getFileNames();
		String file1		= (String)files.nextElement();
		String real_img 	= mr.getOriginalFileName(file1);
		String save_img 	= mr.getFilesystemName(file1);
		inst_pic	 	= directory + save_img;
	}
	String inst_no	 	= parseNull(mr.getParameter("inst_no"));
	String inst_cat_nm 	= parseNull(mr.getParameter("inst_cat_nm"));
	String inst_name 	= parseNull(mr.getParameter("inst_name"));
	String inst_memo 	= parseNull(mr.getParameter("inst_memo"));
	String curr_cnt 	= parseNull(mr.getParameter("curr_cnt"));
	String max_cnt 		= parseNull(mr.getParameter("max_cnt"));
	String inst_size 	= parseNull(mr.getParameter("inst_size"));
	String inst_model 	= parseNull(mr.getParameter("inst_model"));
	String inst_lca	 	= parseNull(mr.getParameter("inst_lca"));
	String reg_id		= parseNull(mr.getParameter("reg_id"));
	String reg_ip		= parseNull(mr.getParameter("reg_ip"));
	String show_flag	= parseNull(mr.getParameter("show_flag"));
	
	try{
		sql = new StringBuffer();
		sql.append("UPDATE ART_INST_MNG											");
		sql.append("	SET	INST_CAT_NM 	= ?,								");
		sql.append("		INST_NAME 		= ?,								");
		sql.append("		INST_MEMO 		= ?,								");
		sql.append("		CURR_CNT 		= ?,								");
		sql.append("		MAX_CNT 		= ?,								");
		sql.append("		MOD_DATE 		= TO_CHAR(SYSDATE, 'YYYY-MM-DD'),	");
		sql.append("		INST_SIZE 		= ?,								");
		sql.append("		INST_MODEL 		= ?,								");
		sql.append("		INST_PIC 		= ?,								");
		sql.append("		INST_LCA 		= ?,								");
		sql.append("		SHOW_FLAG 		= ?									");
		sql.append("WHERE INST_NO 			= ?									");
		
		setObj = new Object[]{
								inst_cat_nm,
								inst_name,
								inst_memo,
								curr_cnt,
								max_cnt,
								inst_size,
								inst_model,
								inst_pic,
								inst_lca,
								show_flag,
								inst_no
							};
		
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
			out.println("location.replace('/program/art/insAdmin/instInsertPopup.jsp?mode=update&inst_no="+inst_no+"');");
			out.println("</script>");
		}
	}
}
%>
