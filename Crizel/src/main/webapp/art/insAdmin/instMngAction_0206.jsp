<%
/**
*   PURPOSE :   악기 승인관리 action page
*   CREATE  :   20180202_fri    Ko
*   MODIFY  :   ....
**/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ page import="java.io.File, java.io.IOException, com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.util.Enumeration"%>
<%!
private class InsVO{
	public int req_no;
	public String inst_cat;
	public String inst_cat_nm;
	public int inst_no;
	public String inst_nm;
	public int inst_req_cnt;
	
	public String inst_name;
	
	public int curr_cnt;
	public int max_cnt;
}

private class InsVOMapper implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
    	vo.inst_cat			= rs.getString("INST_CAT");
    	vo.inst_cat_nm		= rs.getString("INST_CAT_NM");
    	vo.inst_name		= rs.getString("INST_NAME");
        return vo;
    }
}

private class InsVOMapper2 implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
    	vo.curr_cnt			= rs.getInt("CURR_CNT");
    	vo.max_cnt			= rs.getInt("MAX_CNT");
        return vo;
    }
}
%>
<%
String mode				= parseNull(request.getParameter("mode"));

StringBuffer sql 		= null;
Object[] setObj 		= null;
InsVO vo			 	= new InsVO();
int result 				= 0;

if("insert".equals(mode)){	//******************************** 추가 **************************************************************
	String req_no 		= parseNull(request.getParameter("req_no"));
	String req_id		= parseNull(request.getParameter("req_id"));
	String req_group	= parseNull(request.getParameter("req_group"));
	String req_mng_nm	= parseNull(request.getParameter("req_mng_nm"));
	String req_mng_tel	= parseNull(request.getParameter("req_mng_tel"));
	String req_inst_cnt	= parseNull(request.getParameter("req_inst_cnt"));
	String req_memo		= parseNull(request.getParameter("req_memo"));
	String reg_id		= parseNull(request.getParameter("reg_id"));
	String reg_ip		= parseNull(request.getParameter("reg_ip"));
	String reg_date		= parseNull(request.getParameter("reg_date"));
	String show_flag	= parseNull(request.getParameter("show_flag"), "Y");
	
	//String req_no		= parseNull(request.getParameter("req_no"));
	String inst_cat		= parseNull(request.getParameter("inst_cat"));
	String inst_cat_nm	= parseNull(request.getParameter("inst_cat_nm"));
	String inst_no		= parseNull(request.getParameter("inst_no"));
	String inst_nm		= parseNull(request.getParameter("inst_nm"));
	String inst_req_cnt	= parseNull(request.getParameter("inst_req_cnt"));
	
	int now_cnt = 0;
	int sum = 0;

	try{
		sql = new StringBuffer();
		sql.append("SELECT											");
		sql.append("	CURR_CNT,									");
		sql.append("	MAX_CNT										");
		sql.append("FROM ART_INST_MNG								");
		sql.append("WHERE INST_NO = ").append(inst_no).append("		");
		vo = jdbcTemplate.queryForObject(
					sql.toString(), 
					new InsVOMapper2()
				);
		
		now_cnt = vo.curr_cnt + Integer.parseInt(req_inst_cnt);
		if(vo.max_cnt < now_cnt){
			out.println("<script>");
			out.println("alert('대여가능한 악기 총량보다 신청 한 수량이 많습니다.');");
			out.println("opener.location.reload();");
			out.println("location.replace('/program/art/insAdmin/instMngPopup.jsp');");
			out.println("</script>");
		}else{
			sql = new StringBuffer();
			sql.append("SELECT NVL(MAX(REQ_NO)+1, 1)		");
			sql.append("FROM ART_INST_REQ		 			");
			req_no = jdbcTemplate.queryForObject(
					sql.toString(),
					String.class
				);
			
			sql = new StringBuffer();
			sql.append("INSERT INTO ART_INST_REQ(									");
			sql.append("						REQ_NO,								");
			sql.append("						REQ_ID,								");
			sql.append("						REQ_GROUP,							");
			sql.append("						REQ_MNG_NM,							");
			sql.append("						REQ_MNG_TEL,						");
			sql.append("						REQ_INST_CNT,						");
			sql.append("						REQ_MEMO,							");
			sql.append("						REG_ID,								");
			sql.append("						REG_IP,								");
			sql.append("						REG_DATE,							");
			sql.append("						SHOW_FLAG,							");
			sql.append("						APPLY_FLAG,							");
			sql.append("						APPLY_DATE							");
			sql.append("						)									");
			sql.append("VALUES(														");
			sql.append("						?,									");		//REQ_NO
			sql.append("						?,									");		//REQ_ID
			sql.append("						?,									");		//REQ_GROUP
			sql.append("						?,									");		//REQ_MNG_NM
			sql.append("						?,									");		//REQ_MNG_TEL
			sql.append("						?,									");		//REQ_INST_CNT
			sql.append("						?,									");		//REQ_MEMO
			sql.append("						?,									");		//REG_ID
			sql.append("						?,									");		//REG_IP
			sql.append("						TO_CHAR(SYSDATE, 'YYYY-MM-DD'),		");		//REG_DATE
			sql.append("						?,									");		//SHOW_FLAG
			sql.append("						'Y',								");		//APPLY_FLAG
			sql.append("						''									");		//APPLY_DATE
			sql.append("		)													");		
			
			setObj = new Object[]{
									req_no,
									req_id,
									req_group,
									req_mng_nm,
									req_mng_tel,
									req_inst_cnt,
									req_memo,
									reg_id,
									reg_ip,
									show_flag
								};
			
			result = jdbcTemplate.update(
						sql.toString(), 
						setObj
					);
			
			sql = new StringBuffer();
			sql.append("SELECT											");
			sql.append("	INST_CAT,									");
			sql.append("	INST_CAT_NM,								");
			sql.append("	INST_NAME									");
			sql.append("FROM ART_INST_MNG								");
			sql.append("WHERE INST_NO = ").append(inst_no).append("		");
			vo = jdbcTemplate.queryForObject(
						sql.toString(), 
						new InsVOMapper()
					);

			if(result>0){
			sql = new StringBuffer();
			sql.append("INSERT INTO ART_INST_REQ_CNT(									");
			sql.append("						REQ_NO,								");
			sql.append("						INST_CAT,							");
			sql.append("						INST_CAT_NM,						");
			sql.append("						INST_NO,							");
			sql.append("						INST_NM,							");
			sql.append("						INST_REQ_CNT						");
			sql.append("						)									");
			sql.append("VALUES(														");
			sql.append("						?,									");		//REQ_NO
			sql.append("						?,									");		//INST_CAT
			sql.append("						?,									");		//INST_CAT_NM
			sql.append("						?,									");		//INST_NO
			sql.append("						?,									");		//INST_NM
			sql.append("						?									");		//INST_REQ_CNT
			sql.append("		)													");		
			
			setObj = new Object[]{
									req_no,
									vo.inst_cat,
									vo.inst_cat_nm,
									inst_no,
									vo.inst_name,
									req_inst_cnt
								};
			
			result = jdbcTemplate.update(
						sql.toString(), 
						setObj
					);
			}
			if(result > 0){
				sql = new StringBuffer();
				sql.append("SELECT SUM(INST_REQ_CNT)		");
				sql.append("FROM ART_INST_REQ_CNT		 	");
				sql.append("WHERE INST_NO = ?		 		");
				sum = jdbcTemplate.queryForObject(
						sql.toString(),
						new Object[]{inst_no},
						Integer.class
					);
				
				sql = new StringBuffer();
				sql.append("UPDATE ART_INST_MNG SET			");
				sql.append("	CURR_CNT 		= ?			");
				sql.append("WHERE INST_NO 		= ?			");
				
				setObj = new Object[]{
										sum,
										inst_no
									};
				result = jdbcTemplate.update(
							sql.toString(), 
							setObj
						);	
			}
		}
	}catch(Exception e){
		out.println(e.toString());
	}finally{
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("opener.location.reload();");
			out.println("location.replace('/program/art/insAdmin/instMngPopup.jsp');");
			out.println("</script>");
		}
	}
		
		
		
}else if("delete".equals(mode)){		//******************************** 삭제 **************************************************************
	
}else if("update".equals(mode)){		//******************************** 수정 **************************************************************
	String req_no 		= parseNull(request.getParameter("req_no"));
	String req_id		= parseNull(request.getParameter("req_id"));
	String req_group	= parseNull(request.getParameter("req_group"));
	String req_mng_nm	= parseNull(request.getParameter("req_mng_nm"));
	String req_mng_tel	= parseNull(request.getParameter("req_mng_tel"));
	String req_inst_cnt	= parseNull(request.getParameter("req_inst_cnt"));
	String req_memo		= parseNull(request.getParameter("req_memo"));
	String reg_ip		= parseNull(request.getParameter("reg_ip"));
	String reg_date		= parseNull(request.getParameter("reg_date"));
	String show_flag	= parseNull(request.getParameter("show_flag"), "Y");
	
	//String req_no		= parseNull(request.getParameter("req_no"));
	String inst_cat		= parseNull(request.getParameter("inst_cat"));
	String inst_cat_nm	= parseNull(request.getParameter("inst_cat_nm"));
	String inst_no		= parseNull(request.getParameter("inst_no"));
	String inst_nm		= parseNull(request.getParameter("inst_nm"));
	String inst_req_cnt	= parseNull(request.getParameter("inst_req_cnt"));
	
	int now_cnt = 0;		//대여가 가능한지 체크하기 위한 변수
	int now_cnt2 = 0;		//현재 신청중인 악기 수
	int sum = 0;
	
	try{
		sql = new StringBuffer();
		sql.append("SELECT											");		
		sql.append("	CURR_CNT,									");		//선택한 악기의 현재 대여량
		sql.append("	MAX_CNT										");		//선택한 악기의 최대 대여량
		sql.append("FROM ART_INST_MNG								");
		sql.append("WHERE INST_NO = ").append(inst_no).append("		");
		vo = jdbcTemplate.queryForObject(
					sql.toString(), 
					new InsVOMapper2()
				);
		
		sql = new StringBuffer();
		sql.append("SELECT											");
		sql.append("	REQ_INST_CNT								");		//신청한 악기대여 수
		sql.append("FROM ART_INST_REQ								");
		sql.append("WHERE REQ_NO = ").append(req_no).append("		");
		now_cnt2 = jdbcTemplate.queryForObject(
					sql.toString(), 
					Integer.class
				);
		
		now_cnt = vo.curr_cnt + Integer.parseInt(req_inst_cnt) - now_cnt2;		//악기현재대여량 + 악기 대여량 - 현재악기 대여량
		if(vo.max_cnt < now_cnt){
			out.println("<script>");
			out.println("alert('대여가능한 악기 총량보다 신청 한 수량이 많습니다.');");
			out.println("opener.location.reload();");
			out.println("location.replace('/program/art/insAdmin/instMngPopup.jsp?mode=update&req_no="+req_no+"');");
			out.println("</script>");
		}else{
			sql = new StringBuffer();
			sql.append("UPDATE ART_INST_REQ SET			");
			sql.append("	REQ_ID 			= ?,		");
			sql.append("	REQ_GROUP 		= ?,		");
			sql.append("	REQ_MNG_NM 		= ?,		");
			sql.append("	REQ_MNG_TEL 	= ?,		");
			sql.append("	REQ_INST_CNT 	= ?,		");
			sql.append("	REQ_MEMO	 	= ?,		");
			sql.append("	REG_IP 			= ?,		");
			sql.append("	SHOW_FLAG 		= ?			");
			sql.append("WHERE REQ_NO 		= ?			");
			
			setObj = new Object[]{
									req_id,
									req_group,
									req_mng_nm,
									req_mng_tel,
									req_inst_cnt,
									req_memo,
									reg_ip,
									show_flag,
									req_no
								};
			
			result = jdbcTemplate.update(
						sql.toString(), 
						setObj
					);
			
			sql = new StringBuffer();
			sql.append("SELECT											");
			sql.append("	INST_CAT,									");
			sql.append("	INST_CAT_NM,								");
			sql.append("	INST_NAME									");
			sql.append("FROM ART_INST_MNG								");
			sql.append("WHERE INST_NO = ").append(inst_no).append("		");
			vo = jdbcTemplate.queryForObject(
						sql.toString(), 
						new InsVOMapper()
					);

			if(result>0){
			sql = new StringBuffer();
			sql.append("UPDATE ART_INST_REQ_CNT SET		");
			sql.append("	INST_CAT 		= ?,		");
			sql.append("	INST_CAT_NM 	= ?,		");
			sql.append("	INST_NO 		= ?,		");
			sql.append("	INST_NM 		= ?,		");
			sql.append("	INST_REQ_CNT 	= ?			");
			sql.append("WHERE REQ_NO 		= ?			");
			
			setObj = new Object[]{
									vo.inst_cat,
									vo.inst_cat_nm,
									inst_no,
									vo.inst_name,
									req_inst_cnt,
									req_no
								};
			
			result = jdbcTemplate.update(
						sql.toString(), 
						setObj
					);
			}
			
			if(result > 0){
				sql = new StringBuffer();
				sql.append("SELECT SUM(INST_REQ_CNT)		");
				sql.append("FROM ART_INST_REQ_CNT		 	");
				sql.append("WHERE INST_NO = ?		 		");
				sum = jdbcTemplate.queryForObject(
						sql.toString(),
						new Object[]{inst_no},
						Integer.class
					);
				
				sql = new StringBuffer();
				sql.append("UPDATE ART_INST_MNG SET			");
				sql.append("	CURR_CNT 		= ?			");
				sql.append("WHERE INST_NO 		= ?			");
				
				setObj = new Object[]{
										sum,
										inst_no
									};
				result = jdbcTemplate.update(
							sql.toString(), 
							setObj
						);	
			}
		}
	}catch(Exception e){
		out.println(e.toString());
	}finally{
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("opener.location.reload();");
			out.println("location.replace('/program/art/insAdmin/instMngPopup.jsp?mode=update&req_no="+req_no+"');");
			out.println("</script>");
		}
	}
}else if("apply".equals(mode)){		//******************************** 승인 **************************************************************
	String req_no 		= parseNull(request.getParameter("req_no"));
	String apply_flag	= parseNull(request.getParameter("apply_flag"));
	
	try{
		sql = new StringBuffer();
		sql.append("UPDATE ART_INST_REQ SET									");
		sql.append("	APPLY_FLAG 		= ?,								");
		sql.append("	APPLY_DATE 		= TO_CHAR(SYSDATE,'YYYY-MM-DD')		");
		sql.append("WHERE REQ_NO 		= ?									");

		setObj = new Object[]{
				apply_flag,
				req_no
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
			out.println("location.replace('/index.gne?menuCd=DOM_000000126006002002');");
			out.println("</script>");
		}
	}
	
}
%>
