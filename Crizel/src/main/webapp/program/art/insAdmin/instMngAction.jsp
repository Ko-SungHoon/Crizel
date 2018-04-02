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
	
	public int req_inst_cnt;
	
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

private class InsVOMapper3 implements RowMapper<InsVO> {
    public InsVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	InsVO vo = new InsVO();
    	vo.inst_no			= rs.getInt("INST_NO");
    	vo.req_inst_cnt		= rs.getInt("INST_REQ_CNT");
        return vo;
    }
}

%>
<%
/** 파라미터 UTF-8처리 **/
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String mode				= parseNull(request.getParameter("mode"));

StringBuffer sql 		= null;
Object[] setObj 		= null;
InsVO vo			 	= new InsVO();
int result 				= 0;

String req_no 			= parseNull(request.getParameter("req_no"));
String req_id			= parseNull(request.getParameter("req_id"));
String req_group		= parseNull(request.getParameter("req_group"));
String req_mng_nm		= parseNull(request.getParameter("req_mng_nm"));
String req_mng_tel		= parseNull(request.getParameter("req_mng_tel"));
String req_mng_mail		= parseNull(request.getParameter("req_mng_mail"));
String req_inst_cnt[]	= request.getParameterValues("req_inst_cnt");
String req_memo			= parseNull(request.getParameter("req_memo"));
String reg_id			= parseNull(request.getParameter("reg_id"));
String reg_ip			= parseNull(request.getParameter("reg_ip"));
String reg_date			= parseNull(request.getParameter("reg_date"));
String show_flag		= parseNull(request.getParameter("show_flag"), "Y");
String apply_flag		= parseNull(request.getParameter("apply_flag"));

//String req_no			= parseNull(request.getParameter("req_no"));
String inst_cat			= parseNull(request.getParameter("inst_cat"));
String inst_cat_nm[]	= request.getParameterValues("inst_cat_nm");
String inst_no[]		= request.getParameterValues("inst_no");
String inst_nm			= parseNull(request.getParameter("inst_nm"));
String inst_req_cnt		= parseNull(request.getParameter("inst_req_cnt"));

boolean countCheck 		= false;
int count 				= inst_no.length;

String pageType = parseNull(request.getParameter("pageType"), "admin");

String listPage 	= "DOM_000002001003003000";		//악기대여신청 - 목록
//String listPage 	= "DOM_000000126003003000";		//테스트서버

String writePage 	= "DOM_000002001003003001";		//악기대여신청 - 등록/수정
//String writePage 	= "DOM_000000126003003001";		//테스트서버

String viewPage 	= "DOM_000002001003003002";		//악기대여신청 - 상세페이지
//String viewPage 	= "DOM_000000126003003002";		//테스트서버

if("insert".equals(mode)){	//******************************** 추가 **************************************************************
	int now_cnt = 0;
	int sum = 0;

	try{
		
		for(int i=0; i<inst_no.length; i++){
			sql = new StringBuffer();
			sql.append("SELECT												");
			sql.append("	CURR_CNT,										");
			sql.append("	MAX_CNT											");
			sql.append("FROM ART_INST_MNG									");
			sql.append("WHERE INST_NO = ?									");
			vo = jdbcTemplate.queryForObject(
						sql.toString(), 
						new InsVOMapper2(),
						new Object[]{inst_no[i]}
					);
			now_cnt = vo.curr_cnt + Integer.parseInt(req_inst_cnt[i]);
			if(vo.max_cnt < now_cnt){
				out.println("<script>");
				out.println("alert('대여가능한 악기 총량보다 신청 한 수량이 많습니다.');");
				if("admin".equals(pageType)){
					out.println("opener.location.reload();");
				}
				out.println("location.replace('/program/art/insAdmin/instMngPopup.jsp');");
				out.println("</script>");
				return;
			}else{
				countCheck = true;
			}
		}
		
		if(countCheck){
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
			sql.append("						REQ_MNG_MAIL,						");
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
			sql.append("						?,									");		//REQ_MNG_MAIL
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
									req_mng_mail,
									req_inst_cnt[0],
									req_memo,
									reg_id,
									reg_ip,
									show_flag
								};
			
			result = jdbcTemplate.update(
						sql.toString(), 
						setObj
					);
			
			for(int i=0; i<count; i++){
				sql = new StringBuffer();
				sql.append("SELECT											");
				sql.append("	INST_CAT,									");
				sql.append("	INST_CAT_NM,								");
				sql.append("	INST_NAME									");
				sql.append("FROM ART_INST_MNG								");
				sql.append("WHERE INST_NO = ?								");
				vo = jdbcTemplate.queryForObject(
							sql.toString(), 
							new InsVOMapper(),
							new Object[]{inst_no[i]}
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
										inst_no[i],
										vo.inst_name,
										req_inst_cnt[i]
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
							new Object[]{inst_no[i]},
							Integer.class
						);
					
					sql = new StringBuffer();
					sql.append("UPDATE ART_INST_MNG SET			");
					sql.append("	CURR_CNT 		= ?			");
					sql.append("WHERE INST_NO 		= ?			");
					
					setObj = new Object[]{
											sum,
											inst_no[i]
										};
					result = jdbcTemplate.update(
								sql.toString(), 
								setObj
							);	
				}
			}
		}
		
	}catch(Exception e){
		out.println(e.toString());
	}finally{
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			if("admin".equals(pageType)){
				out.println("opener.location.reload();");
			}
			out.println("window.close();");
			//out.println("location.replace('/program/art/insAdmin/instMngPopup.jsp');");
			out.println("</script>");
		}
	}
		
		
		
}else if("delete".equals(mode)){		//******************************** 삭제 **************************************************************
	
}else if("update".equals(mode)){		//******************************** 수정 **************************************************************
	int now_cnt = 0;		//대여가 가능한지 체크하기 위한 변수
	int now_cnt2 = 0;		//현재 신청중인 악기 수
	int sum = 0;
	
	try{
		for(int i=0; i<count; i++){
			sql = new StringBuffer();
			sql.append("SELECT												");		
			sql.append("	CURR_CNT,										");		//선택한 악기의 현재 대여량
			sql.append("	MAX_CNT											");		//선택한 악기의 최대 대여량
			sql.append("FROM ART_INST_MNG									");
			sql.append("WHERE INST_NO = ").append(inst_no[i]).append("		");
			vo = jdbcTemplate.queryForObject(
						sql.toString(), 
						new InsVOMapper2()
					);
			
			sql = new StringBuffer();
			sql.append("SELECT NVL(SUM(INST_REQ_CNT),0)						");
			sql.append("FROM ART_INST_REQ A LEFT JOIN ART_INST_REQ_CNT B	");		//신청한 악기대여 수
			sql.append("ON A.REQ_NO = B.REQ_NO								");
			sql.append("WHERE A.REQ_NO = ? AND A.APPLY_FLAG = 'Y'			");
			now_cnt2 = jdbcTemplate.queryForObject(
						sql.toString(), 
						new Object[]{req_no},
						Integer.class
					);
			
			now_cnt = vo.curr_cnt + Integer.parseInt(req_inst_cnt[i]) - now_cnt2;		//악기현재대여량 + 악기 대여량 - 현재악기 대여량
			
			/* out.println("<script>");
			out.println("alert('대여중 : "+vo.curr_cnt+" , 대여량 : "+req_inst_cnt[i]+", 내가한거 : "+now_cnt2+" = "+now_cnt+"');");
			out.println("</script>"); */
			
			if(vo.max_cnt < now_cnt){
				out.println("<script>");
				out.println("alert('대여가능한 악기 총량보다 신청 한 수량이 많습니다.');");
				if("admin".equals(pageType)){
					out.println("opener.location.reload();");
					out.println("location.replace('/program/art/insAdmin/instMngPopup.jsp?mode=update&req_no="+req_no+"');");
				}else{
					out.println("location.replace('/index.gne?menuCd=" + viewPage + "&mode=update&req_no="+req_no+"');");
				}
				out.println("</script>");
				countCheck = false;
				return;
			}else{
				countCheck = true;
			}
		}
		
		if(countCheck){
			sql = new StringBuffer();
			sql.append("UPDATE ART_INST_REQ SET			");
			sql.append("	REQ_ID 			= ?,		");
			sql.append("	REQ_GROUP 		= ?,		");
			sql.append("	REQ_MNG_NM 		= ?,		");
			sql.append("	REQ_MNG_TEL 	= ?,		");
			sql.append("	REQ_MNG_MAIL 	= ?,		");
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
									req_mng_mail,
									req_inst_cnt[0],
									req_memo,
									reg_ip,
									show_flag,
									req_no
								};
			
			result = jdbcTemplate.update(
						sql.toString(), 
						setObj
					);
			
			for(int i=0; i<count; i++){
				sql = new StringBuffer();
				sql.append("SELECT												");
				sql.append("	INST_CAT,										");
				sql.append("	INST_CAT_NM,									");
				sql.append("	INST_NAME										");
				sql.append("FROM ART_INST_MNG									");
				sql.append("WHERE INST_NO = ").append(inst_no[i]).append("		");
				vo = jdbcTemplate.queryForObject(
							sql.toString(), 
							new InsVOMapper()
						);

				if(result>0){
				/* sql = new StringBuffer();
				sql.append("UPDATE ART_INST_REQ_CNT SET			");
				sql.append("	INST_REQ_CNT 	= ?				");
				sql.append("WHERE REQ_NO = ? AND INST_NM = ?	");
				
				setObj = new Object[]{
										req_inst_cnt[i],
										req_no,
										vo.inst_name,
									}; */
									
				sql = new StringBuffer();
				sql.append("MERGE INTO ART_INST_REQ_CNT USING DUAL										");
				sql.append("	ON (REQ_NO = ? AND INST_NO = ?)											");
				sql.append("	WHEN MATCHED THEN														");
				sql.append("		UPDATE SET															");
				sql.append("			INST_REQ_CNT = ?												");
				sql.append("	WHEN NOT MATCHED THEN													");
				sql.append("	INSERT(REQ_NO, INST_CAT, INST_NO, INST_CAT_NM, INST_NM, INST_REQ_CNT)	");
				sql.append("	VALUES(?, ?, ?, ?, ?, ?)												");
				
				setObj = new Object[]{
										req_no,
										inst_no[i],
										req_inst_cnt[i],
										req_no,
										vo.inst_cat,
										inst_no[i],
										vo.inst_cat_nm,
										vo.inst_name,
										req_inst_cnt[i]
									};					
				result = jdbcTemplate.update(
							sql.toString(), 
							setObj
						);
				}
				
				if("Y".equals(apply_flag)){
					sql = new StringBuffer();
					sql.append("SELECT SUM(INST_REQ_CNT)		");
					sql.append("FROM ART_INST_REQ_CNT		 	");
					sql.append("WHERE INST_NO = ?		 		");
					sum = jdbcTemplate.queryForObject(
							sql.toString(),
							new Object[]{inst_no[i]},
							Integer.class
						);
					
					sql = new StringBuffer();
					sql.append("UPDATE ART_INST_MNG SET			");
					sql.append("	CURR_CNT 		= ?			");
					sql.append("WHERE INST_NO 		= ?			");
					
					setObj = new Object[]{
											sum,
											inst_no[i]
										};
					result = jdbcTemplate.update(
								sql.toString(), 
								setObj
							);	 
				}
			}
		}
	}catch(Exception e){
		out.println(e.toString());
	}finally{
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			if("admin".equals(pageType)){
				out.println("opener.location.reload();");
				out.println("location.replace('/program/art/insAdmin/instMngPopup.jsp?mode=update&req_no="+req_no+"');");
			}else{
				out.println("location.replace('/index.gne?menuCd=" + writePage + "&mode=update&req_no="+req_no+"');");
			}
			out.println("</script>");
		}
	}
}else if("apply".equals(mode)){		//******************************** 승인 **************************************************************
	int now_cnt 			= 0;
	int now_cnt2 			= 0;		//현재 신청중인 악기 수
	int sum 				= 0;
	List<InsVO> list 		= null;
	InsVO vo2 				= null;
	List<InsVO> instNoList 	= null;

	try{
		if("Y".equals(apply_flag)){
			sql = new StringBuffer();
			sql.append("SELECT INST_NO, INST_REQ_CNT	");
			sql.append("FROM ART_INST_REQ_CNT			");
			sql.append("WHERE REQ_NO = ?				");
			instNoList = jdbcTemplate.query(
							sql.toString(),
							new Object[]{req_no},
							new InsVOMapper3()
						);
			
			inst_no 		= new String[instNoList.size()];
			req_inst_cnt 	= new String[instNoList.size()];
			
			for(int i=0; i<instNoList.size(); i++){
				InsVO ob 			= instNoList.get(i);
				inst_no[i] 			= Integer.toString(ob.inst_no); 
				req_inst_cnt[i]		= Integer.toString(ob.req_inst_cnt);
			}
			for(int i=0; i<inst_no.length; i++){
				sql = new StringBuffer();
				sql.append("SELECT												");
				sql.append("	CURR_CNT,										");
				sql.append("	MAX_CNT											");
				sql.append("FROM ART_INST_MNG									");
				sql.append("WHERE INST_NO = ?									");
				vo = jdbcTemplate.queryForObject(
							sql.toString(), 
							new InsVOMapper2(),
							new Object[]{inst_no[i]}
						);
				now_cnt = vo.curr_cnt + Integer.parseInt(req_inst_cnt[i]);
				if(vo.max_cnt < now_cnt){
					out.println("<script>");
					out.println("alert('대여가능한 악기 총량보다 신청 한 수량이 많습니다.');");
					if("C".equals(apply_flag)){				//사용자 페이지에서 신청취소
						out.println("location.replace('/index.gne?menuCd=" + listPage + "');");		//악기대여 신청 목록
					}else{
						if("admin".equals(pageType)){			//관리자메뉴에서 신청취소
							out.println("location.replace('/program/art/admin/instReq.jsp');");	//관리자메뉴 - 신청관리
						}else{								//사용자 페이지에서 관리자가 신청취소
							out.println("location.replace('/index.gne?menuCd=" + listPage + "');");	//악기대여 신청 목록
						}
					}
					out.println("</script>");
					return;
				}else{
					countCheck = true;
				}
			}
		}
		
		sql = new StringBuffer();
		sql.append("SELECT A.INST_NO, B.INST_REQ_CNT					");
		sql.append("FROM ART_INST_MNG A LEFT JOIN ART_INST_REQ_CNT B	");
		sql.append("ON A.INST_NO = B.INST_NO							");
		sql.append("WHERE B.REQ_NO = ?									");
		list = jdbcTemplate.query(
					sql.toString(),
					new Object[]{req_no},
					new InsVOMapper3()
				);
		
		for(int i=0; i<list.size(); i++){
			vo2 = list.get(i);
			sql = new StringBuffer();
			sql.append("UPDATE ART_INST_REQ SET									");
			sql.append("	APPLY_FLAG 		= ?,								");
			sql.append("	APPLY_DATE 		= TO_CHAR(SYSDATE,'YYYY-MM-DD')		");
			if("C".equals(apply_flag) || "A".equals(apply_flag) || "R".equals(apply_flag)){
				if("C".equals(apply_flag) || "A".equals(apply_flag)){
					sql.append("	,SHOW_FLAG 		='N'								");
				}
				sql.append("	,REQ_INST_CNT	= 0									");
			}
			
			sql.append("WHERE REQ_NO 		= ?									");
			
			setObj = new Object[]{
					apply_flag,
					req_no
					};
			
			result = jdbcTemplate.update(
						sql.toString(), 
						setObj
					);
			
			sql = new StringBuffer();
			sql.append("SELECT NVL(SUM(INST_REQ_CNT),0)							");
			sql.append("FROM ART_INST_REQ_CNT A LEFT JOIN ART_INST_REQ B		");
			sql.append("ON A.REQ_NO = B.REQ_NO							 		");
			sql.append("WHERE INST_NO = ? AND B.APPLY_FLAG = 'Y'		 		");
			sum = jdbcTemplate.queryForObject(
					sql.toString(),
					new Object[]{vo2.inst_no},
					Integer.class
				);
			
			sql = new StringBuffer();
			sql.append("UPDATE ART_INST_MNG SET			");
			sql.append("	CURR_CNT 		= ?			");
			sql.append("WHERE INST_NO 		= ?			");
			
			setObj = new Object[]{
						sum,
						vo2.inst_no
								};
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
			if("C".equals(apply_flag)){				//사용자 페이지에서 신청취소
				out.println("location.replace('/index.gne?menuCd=" + listPage + "');");		//악기대여 신청 목록
			}else{
				if("admin".equals(pageType)){			//관리자메뉴에서 신청취소
					out.println("location.replace('/program/art/admin/instReq.jsp');");	//관리자메뉴 - 신청관리
				}else{								//사용자 페이지에서 관리자가 신청취소
					out.println("location.replace('/index.gne?menuCd=" + listPage + "');");	//악기대여 신청 목록
				}
			}
			out.println("</script>");
			
		}
	}
	
}else if("clientInsert".equals(mode)){		//******************************** 사용자 승인신청 **************************************************************
	int now_cnt = 0;
	int sum = 0;
	
	try{
		for(int i=0; i<inst_no.length; i++){
			sql = new StringBuffer();
			sql.append("SELECT												");
			sql.append("	CURR_CNT,										");
			sql.append("	MAX_CNT											");
			sql.append("FROM ART_INST_MNG									");
			sql.append("WHERE INST_NO = ").append(inst_no[i]).append("		");
			vo = jdbcTemplate.queryForObject(
						sql.toString(), 
						new InsVOMapper2()
					);
			now_cnt = vo.curr_cnt + Integer.parseInt(req_inst_cnt[i]);
			if(vo.max_cnt < now_cnt){
				out.println("<script>");
				out.println("alert('대여가능한 악기 총량보다 신청 한 수량이 많습니다.');");
				out.println("location.replace('/index.gne?menuCd=" + listPage + "');");
				out.println("</script>");
				return;
			}else{
				countCheck = true;
			}
		}
		
		if(countCheck){
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
			sql.append("						REQ_MNG_MAIL,						");
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
			sql.append("						?,									");		//REQ_MNG_MAIL
			sql.append("						?,									");		//REQ_INST_CNT
			sql.append("						?,									");		//REQ_MEMO
			sql.append("						?,									");		//REG_ID
			sql.append("						?,									");		//REG_IP
			sql.append("						TO_CHAR(SYSDATE, 'YYYY-MM-DD'),		");		//REG_DATE
			sql.append("						?,									");		//SHOW_FLAG
			sql.append("						'N',								");		//APPLY_FLAG
			sql.append("						''									");		//APPLY_DATE
			sql.append("		)													");		
			
			setObj = new Object[]{
									req_no,
									req_id,
									req_group,
									req_mng_nm,
									req_mng_tel,
									req_mng_mail,
									req_inst_cnt[0],
									req_memo,
									reg_id,
									reg_ip,
									show_flag
								};
			
			result = jdbcTemplate.update(
						sql.toString(), 
						setObj
					);
			
			for(int i=0; i<count; i++){
				sql = new StringBuffer();	
				sql.append("SELECT												");
				sql.append("	INST_CAT,										");
				sql.append("	INST_CAT_NM,									");
				sql.append("	INST_NAME										");
				sql.append("FROM ART_INST_MNG									");
				sql.append("WHERE INST_NO = ").append(inst_no[i]).append("		");
				vo = jdbcTemplate.queryForObject(
							sql.toString(), 
							new InsVOMapper()
						);

				if(result>0){
					sql = new StringBuffer();
					sql.append("INSERT INTO ART_INST_REQ_CNT(								");
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
											inst_no[i],
											vo.inst_name,
											req_inst_cnt[i]
										};
					
					result = jdbcTemplate.update(
								sql.toString(), 
								setObj
							);
				}
			}
		}
	}catch(Exception e){
		out.println(e.toString());
	}finally{
		if(result>0){
			out.println("<script>");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.replace('/index.gne?menuCd=" + listPage + "');");
			out.println("</script>");
		}
	}
}
%>
