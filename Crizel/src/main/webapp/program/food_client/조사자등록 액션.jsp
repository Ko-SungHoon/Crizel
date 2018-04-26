<%
/**
*   PURPOSE :   로그인 session chk content page
*   CREATE  :   20180326_mon    JUNG
*   MODIFY  :   20180416_mon    JI      관리자 session 확인 추가
**/
%>

<%@ page import="java.util.Arrays"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/food/food_util.jsp" %>
<%@ include file="/program/food/foodVO.jsp" %>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");
SessionManager sManager =	new SessionManager(request);

String foodRole		= 	"ROLE_000094";		//운영서버:ROLE_000094 , 테스트서버:ROLE_000012

String moveUrlMain	=	"/index.gne?menuCd=DOM_000002101000000000";		//메인페이지 (그 외)			운영서버:DOM_000002101000000000, 테스트서버:DOM_000000127000000000
String moveUrlMy	=	"/index.gne?menuCd=DOM_000002101007000000";		//마이페이지 (로그인 성공시)		운영서버:DOM_000002101007000000, 테스트서버:DOM_000000127007000000
int actType			=	Integer.parseInt(parseNull(request.getParameter("actType"), "0"));	//0 : 신규신청, 1 : 정보수정, 2 : 2차로그인, 3 : 영양사 삭제

//세션 체크 (로그인 여부 및 승인여부)
if("".equals(sManager.getId()) || session.getAttribute("foodUserChk")==null){
	out.print("<script>                         \n");
	out.print("alert('비정상적인 접근입니다.');   \n");
	out.print("window.close(); 					\n");
	out.print("</script> 						\n");
}
//정보 수정
if(actType == 1){
	if(!"Y".equals(session.getAttribute("foodLoginChk"))){
		out.print("<script> 						              \n");
		out.print("alert('2차 로그인 후 이용하실 수 있습니다.');    \n");
		out.print("history.back(); 					              \n");
		out.print("</script> 						              \n");
	}
}
//2차 로그인
else if(actType == 2){
	if("N".equals(session.getAttribute("foodUserChk"))){
		out.print("<script> 					          \n");
		out.print("alert('승인대기중인 계정입니다.');		\n");
		out.print("history.back(); 				          \n");
		out.print("</script> 					          \n");
	}else if("S".equals(session.getAttribute("foodUserChk"))){
		out.print("<script> 					          \n");
		out.print("alert('승인신청하지 않은 계정입니다.');	\n");
		out.print("history.back(); 				          \n");
		out.print("</script> 					          \n");
	}
}
//신규 등록 신청
else if(actType == 0){
	if("Y".equals(session.getAttribute("foodUserChk"))){
		out.print("<script> 					          \n");
		out.print("alert('이미 승인된 계정입니다.');		\n");
		out.print("history.back(); 				          \n");
		out.print("</script> 					          \n");
	}else if("N".equals(session.getAttribute("foodUserChk"))){
		out.print("<script> 					          \n");
		out.print("alert('승인 대기중인 계정입니다.');	    \n");
		out.print("history.back(); 				          \n");
		out.print("</script> 					          \n");
	}
}
Connection conn 		= null;
PreparedStatement pstmt = null;
int key					= 0;

StringBuffer sql 		= 	null;
String resultMsg		=	"";
int resultCnt 			=	0;

FoodVO foodVO				=	new FoodVO();
List<FoodVO> nuList			=	null;
List<FoodVO> userNmList		=	null;
List<FoodVO> searchList		=	null;
List<Object[]> batchList	=	null;	//batch시 사용할 리스트
int[] batchSuccess			=	null;	//batch success count
List<String> setWhere		=	new ArrayList<String>();
Object[] setObject			=	null;

//parameter
String[] nuName		=	request.getParameterValues("nuName");
String[] nuTel		=	request.getParameterValues("nuTel");
String[] nuMail		=	request.getParameterValues("nuMail");
String[] nuNo		=	request.getParameterValues("nuNo");

foodVO.sch_id		=	sManager.getId();
foodVO.sch_no		=	parseNull(request.getParameter("schNo"));
foodVO.sch_org_sid	=	parseNull(request.getParameter("schOrgSid"));
foodVO.sch_addr		=	parseNull(request.getParameter("schAddr"));
foodVO.sch_nm		=	parseNull(request.getParameter("schName"));
foodVO.sch_tel		=	parseNull(request.getParameter("schTel"));
foodVO.sch_type		=	parseNull(request.getParameter("schType"));
foodVO.sch_area		=	parseNull(request.getParameter("schArea"));
foodVO.sch_gen		=	parseNull(request.getParameter("coedu"));
foodVO.sch_found	=	parseNull(request.getParameter("schFound"));
foodVO.zone_no		=	parseNull(request.getParameter("zoneNo"));
foodVO.team_no		=	parseNull(request.getParameter("teamNo"));
foodVO.nu_no		=	parseNull(request.getParameter("nuNo"));
foodVO.sch_pw		=	parseNull(request.getParameter("schPw"));
foodVO.sch_pw		=	encryptPass(foodVO.sch_pw);
foodVO.area_no		=	parseNull(request.getParameter("areaNo"));
foodVO.jo_no		=	parseNull(request.getParameter("joNo"));
String currentPw	=	parseNull(request.getParameter("currentPw")); 	//정보 수정시 기존 비밀번호
String sch_pw_chk	=	"";												//비밀번호 체크용 변수

String schName		=	sManager.getName();
String groupId		=	sManager.getGroupId();
String userCheck	= 	(String)session.getAttribute("foodUserChk");

try{
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

	//신규 신청
	if(actType == 0){			
		sql		=	new StringBuffer();
		sql.append(" SELECT 							\n");
		sql.append(" NVL(MAX(SCH_NO), 0)+1 AS SCH_NO 	\n");
		sql.append(" FROM FOOD_SCH_TB  					\n");
		
		foodVO.sch_no	=	jdbcTemplate.queryForObject(sql.toString(), String.class);
		
		sql		=	new StringBuffer();		
		sql.append(" INSERT INTO FOOD_SCH_TB ( 			\n");
		sql.append(" SCH_NO, 							\n");
		sql.append(" SCH_ORG_SID,				 		\n");
		sql.append(" SCH_TYPE,					 		\n");
		sql.append(" SCH_ID,							\n");	
		sql.append(" SCH_NM,					 		\n");
		sql.append(" SCH_TEL,				 			\n");
		sql.append(" SCH_AREA,				 			\n");
		sql.append(" SCH_ADDR,				 			\n");
		sql.append(" SCH_FOUND,				 			\n");
		sql.append(" SCH_GEN,				 			\n");
		sql.append(" REG_DATE,				 			\n");
		sql.append(" ZONE_NO,				 			\n");
		sql.append(" TEAM_NO,				 			\n");
		sql.append(" SCH_GRADE,				 			\n");
		sql.append(" SCH_PW,				 			\n");
		sql.append(" AREA_NO,					 		\n");
		sql.append(" JO_NO,						 		\n");
		sql.append(" SCH_APP_FLAG,				 		\n");
		sql.append(" MOD_DATE    )			 			\n");
		
		sql.append(" VALUES (									\n");
		sql.append(" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE,		\n");
		sql.append(" ?, ?, 'R', ?, ?, ?, 'N', SYSDATE		)			\n");
		
		resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{
			foodVO.sch_no,  foodVO.sch_org_sid, foodVO.sch_type, sManager.getId(), foodVO.sch_nm,
			foodVO.sch_tel, foodVO.sch_area,    foodVO.sch_addr,  foodVO.sch_found,
			foodVO.sch_gen, foodVO.zone_no,     foodVO.team_no,  foodVO.sch_pw, foodVO.area_no,
			foodVO.jo_no
		});
		
		if(resultCnt > 0){
			
			//nu_no 최대값 + 1 구하기
			sql		= 	new StringBuffer();
			sql.append(" SELECT   						\n");
			sql.append(" NVL(MAX(NU_NO), 0)+1 AS NU_NO	\n");
			sql.append(" FROM FOOD_SCH_NU				\n");
			
			foodVO.nu_no	=	jdbcTemplate.queryForObject(sql.toString(), String.class);
			
			//영양사 insert
			sql		=	new StringBuffer();
			sql.append(" INSERT INTO FOOD_SCH_NU (			\n");
			sql.append(" NU_NO, 							\n");
			sql.append(" SCH_NO, 							\n");
			sql.append(" NU_NM, 							\n");
			sql.append(" NU_TEL, 							\n");
			sql.append(" NU_MAIL, 							\n");
			sql.append(" SHOW_FLAG 	)						\n");
			sql.append(" VALUES ( 							\n");
			sql.append(" ?, ?, ?, ?, ?, 'Y'	)				\n");	
			
			pstmt = conn.prepareStatement(sql.toString());
			
			if(nuName != null && nuName.length > 0 && nuTel != null && nuTel.length > 0 && nuMail != null && nuMail.length > 0){
				for(int i=0; i<nuName.length; i++){
					key = 0;
					pstmt.setInt(++key,  Integer.parseInt(foodVO.nu_no)+i);
					pstmt.setString(++key,  foodVO.sch_no);
					pstmt.setString(++key,  nuName[i]);
					pstmt.setString(++key,  nuTel[i]);
					pstmt.setString(++key,  nuMail[i]);
					pstmt.addBatch();
				}
				batchSuccess = pstmt.executeBatch();
			}
			
			if(pstmt!=null){pstmt.close();}
			
			
			/* batchList	=	new ArrayList<Object[]>();
			
			if(nuName != null && nuName.length > 0 && nuTel != null && nuTel.length > 0 && nuMail != null && nuMail.length > 0){
				for(int i=0; i<nuName.length; i++){
					Object[] ob	=	new Object[]{ Integer.parseInt(foodVO.nu_no)+i, foodVO.sch_no, nuName[i], nuTel[i], nuMail[i] };
					batchList.add(ob);
				}
			}
			batchSuccess	=	null;
			batchSuccess = jdbcTemplate.batchUpdate(sql.toString(), batchList); */
		}
	}
	//정보수정
	else if(actType == 1){
		//sch_no(학교구분코드)가 빈값이 아닐 경우
		if(!"".equals(foodVO.sch_no)){
			
			//기존 비밀번호 일치여부 확인
			sql		=	new StringBuffer();
			sql.append(" SELECT				 	\n");
			sql.append(" COUNT(SCH_NO)			\n");
			sql.append(" FROM FOOD_SCH_TB 		\n");
			sql.append(" WHERE SCH_ID = ? 		\n");
			sql.append(" AND SCH_PW = ? 		\n");
			
			resultCnt	=	jdbcTemplate.queryForInt(sql.toString(), new Object[]{foodVO.sch_id, currentPw});
			
			if(resultCnt > 0){
				
				//학교정보 수정
				sql		=	new StringBuffer();
				sql.append(" UPDATE FOOD_SCH_TB		\n");
				sql.append(" SET					\n");				
				sql.append(" SCH_NM = ?,			\n");
				sql.append(" SCH_TYPE = ?,			\n");
				sql.append(" SCH_TEL = ?,			\n");
				sql.append(" SCH_ADDR = ?,			\n");
				sql.append(" ZONE_NO = ?, 			\n");
				sql.append(" TEAM_NO = ?,			\n");
				sql.append(" AREA_NO = ?,			\n");
				sql.append(" JO_NO = ?				\n");
				sql.append(" WHERE SCH_NO = ?   	\n");
				
				resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{
					foodVO.sch_nm, foodVO.sch_type, foodVO.sch_tel, foodVO.sch_addr, 
					foodVO.zone_no, foodVO.team_no, foodVO.area_no, foodVO.jo_no, foodVO.sch_no	
				});
				
				if(resultCnt > 0){
					if("GRP_000009".equals(groupId)){
						//영양사 수정
						//기존 영양사 delete
						sql		= 	new StringBuffer();
						sql.append(" UPDATE FOOD_SCH_NU				\n");
						sql.append(" SET SHOW_FLAG = 'N'			\n");
						sql.append(" WHERE SCH_NO = ?				\n");
						
						resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{foodVO.sch_no});
						
						//nu_no 최대값 + 1 구하기
						sql		= 	new StringBuffer();
						sql.append(" SELECT   						\n");
						sql.append(" NVL(MAX(NU_NO), 0)+1 AS NU_NO	\n");
						sql.append(" FROM FOOD_SCH_NU				\n");
						
						foodVO.nu_no	=	jdbcTemplate.queryForObject(sql.toString(), String.class);
						
						//영양사 새로 추가
						sql		=	new StringBuffer();
						sql.append(" INSERT INTO FOOD_SCH_NU (	\n");
						sql.append(" NU_NO, 					\n");
						sql.append(" SCH_NO,					\n");
						sql.append(" NU_NM, 					\n");
						sql.append(" NU_TEL,					\n");
						sql.append(" NU_MAIL )					\n");
						sql.append(" VALUES (					\n");
						sql.append(" ?, ?, ?, ?, ?	)			\n");
						
						pstmt = conn.prepareStatement(sql.toString());
						int num = 0;
						for(int i=0; i<nuName.length; i++){
							key = 0;
							pstmt.setInt(++key,  Integer.parseInt(foodVO.nu_no) + num);
							pstmt.setString(++key,  foodVO.sch_no);
							pstmt.setString(++key,  nuName[i]);
							pstmt.setString(++key,  nuTel[i]);
							pstmt.setString(++key,  nuMail[i]);
							pstmt.addBatch();
							num = num + 1;
						}
						batchSuccess = pstmt.executeBatch();
						if(pstmt!=null){pstmt.close();}

						
						/* batchList	=	new ArrayList<Object[]>();
						int num = 0;
						
						for(int i=0; i<nuName.length; i++){
							Object[] ob	=	new Object[]{Integer.parseInt(foodVO.nu_no) + num, foodVO.sch_no, nuName[i], nuTel[i], nuMail[i]};
							batchList.add(ob);
							num = num + 1;
							
						}
						batchSuccess	=	null;
						batchSuccess	= 	jdbcTemplate.batchUpdate(sql.toString(), batchList); */
													
						
						/* //영양사 정보 수정
						sql		=	new StringBuffer();
						sql.append(" UPDATE FOOD_SCH_NU 	\n");
						sql.append(" SET 					\n");
						sql.append(" NU_NM = ?, 			\n");
						sql.append(" NU_TEL = ?,			\n");
						sql.append(" NU_MAIL = ?			\n");
						sql.append(" WHERE NU_NO = ? 		\n");
						
						batchList	=	new ArrayList<Object[]>();
						
							for(int i=0; i<nuNo.length; i++){
								Object[] ob	=	new Object[]{nuName[i], nuTel[i], nuMail[i], nuNo[i]};
								batchList.add(ob);
							}
						
						batchSuccess	=	null;
						batchSuccess	= 	jdbcTemplate.batchUpdate(sql.toString(), batchList); 
					
						if(nuNo.length < nuName.length){
							//nu_no 최대값 + 1 구하기
							sql		= 	new StringBuffer();
							sql.append(" SELECT   						\n");
							sql.append(" NVL(MAX(NU_NO), 0)+1 AS NU_NO	\n");
							sql.append(" FROM FOOD_SCH_NU				\n");
							
							foodVO.nu_no	=	jdbcTemplate.queryForObject(sql.toString(), String.class);
							
							//정보수정시 영양사 신규 추가 
							sql		=	new StringBuffer();
							sql.append(" INSERT INTO FOOD_SCH_NU (	\n");
							sql.append(" NU_NO, 					\n");
							sql.append(" SCH_NO,					\n");
							sql.append(" NU_NM, 					\n");
							sql.append(" NU_TEL,					\n");
							sql.append(" NU_MAIL )					\n");
							sql.append(" VALUES (					\n");
							sql.append(" ?, ?, ?, ?, ?	)			\n");
							
							batchList	=	new ArrayList<Object[]>();
							
							for(int i=(nuName.length - nuNo.length); i<nuName.length; i++){
								int num = 0;
								Object[] ob	=	new Object[]{Integer.parseInt(foodVO.nu_no) + num, foodVO.sch_no, nuName[i], nuTel[i], nuMail[i]};
								batchList.add(ob);
								num = num + 1;
							}
							batchSuccess	=	null;
							batchSuccess	= 	jdbcTemplate.batchUpdate(sql.toString(), batchList);
						}*/
					}
				}
			}
			//기존 비밀번호가 일치하지 않을 경우
			else{
				resultMsg	=	"<script>							\n";
				resultMsg	+=	"alert('기존 비밀번호가 일치하지 않습니다.');		\n";
				resultMsg	+=	"history.back();					\n";
				resultMsg	+=	"</script>							\n";
			}
		}
		//sch_no가 비어있을 경우
		else{
			resultMsg	=	"<script>						\n";
			resultMsg	+=	"alert('학교코드가 존재하지 않습니다.');	\n";
			resultMsg	+=	"history.back();				\n";
			resultMsg	+=	"</script>						\n";
		}
	}
	
	//2차 로그인
	else if(actType == 2){
		sql		=	new StringBuffer();
		sql.append(" SELECT				 	\n");
		sql.append(" SCH_PW					\n");
		sql.append(" FROM FOOD_SCH_TB 		\n");
		sql.append(" WHERE SCH_ID = ? 		\n");
		
		sch_pw_chk	=	jdbcTemplate.queryForObject(sql.toString(), String.class, new Object[]{foodVO.sch_id});
	}
	
	//영양사 삭제
	else if(actType == 3){
		sql		=	new StringBuffer();
		sql.append(" DELETE FOOD_SCH_NU	 	\n");
		sql.append(" WHERE NU_NO = ? 		\n");
		
		resultCnt	=	jdbcTemplate.update(sql.toString(), new Object[]{ foodVO.nu_no });
	}
}catch(Exception e){
	if(pstmt!=null){pstmt.close();}
	if(conn!=null){conn.close();}
	sqlMapClient.endTransaction();
	alert(out, e.toString());
}finally{
	if(pstmt!=null){pstmt.close();}
	if(conn!=null){conn.close();}
	sqlMapClient.endTransaction();
	//신규 신청일 시
	if(actType == 0){
		out.print("<script>alert('승인신청이 완료되었습니다.'); location.href=\"" + moveUrlMain + "\"; </script>");
	}
	
	//정보 수정일 시
	else if(actType == 1){
		if(resultCnt > 0){
			resultMsg	=	"<script>								\n";
			resultMsg	+=	"alert('정상적으로 처리되었습니다.');				\n";
			resultMsg	+=	"location.href=\"" + moveUrlMain + "\"	\n";
			resultMsg	+=	"</script>								\n";
			session.removeAttribute("foodLoginChk");
			out.print(resultMsg);
		}else{
			out.print(resultMsg);
		}
	}
	
	//2차 로그인
	else if(actType == 2){
		
		//정보가 있을 시
		if(!"".equals(parseNull(sch_pw_chk))){
			//정상 로그인
            /** 관리자의 경우 session set 하기 **/
			if(sch_pw_chk.equals(foodVO.sch_pw) || sManager.isRoleAdmin() || sManager.isRole(foodRole) ){
				resultMsg	=	"<script>								\n";
				resultMsg	+=	"location.href=\"" + moveUrlMy + "\"; 	\n";
				resultMsg	+=	"</script>								\n";
				session.setAttribute("foodLoginChk", "Y");		//로그인 확인
				out.print(resultMsg);
			}
			//패스워드 불일치
			else{
				resultMsg	=	"<script>  						\n";
				resultMsg	+=	"alert('패스워드가 일치하지 않습니다.');	\n";
				resultMsg	+=	"history.back();				\n";
				resultMsg	+=	"</script>						\n";
				out.print(resultMsg);
			}			
		}
		//정보가 없을 시
		else{
			resultMsg	=	"<script>								\n";
			resultMsg	+=	"alert('승인되지 않은 계정입니다.');				\n";
			resultMsg	+=	"location.href=\"" + moveUrlMain + "\";	\n";
			resultMsg	+=	"</script>								\n";
			out.print(resultMsg);
		}
	}
	
	//영양사 삭제 시
	else if(actType == 3){
		if(resultCnt > 0){
			out.print("정상적으로 삭제되었습니다.");
		}else{
			out.print("오류가 발생하였습니다. 관리자에게 문의해주세요.");
		}
	}
}
%>