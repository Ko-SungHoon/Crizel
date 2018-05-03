<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");
SessionManager sessionManager = new SessionManager(request);

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

String command 		  = parseNull(request.getParameter("command"));         //insert or update
String e_seq          = parseNull(request.getParameter("e_seq"));           //SEQ
String emplyr_nm      = parseNull(request.getParameter("emplyr_nm"));       //이름
String position_nm    = parseNull(request.getParameter("position_nm"));     //직급,직위

String in_office_cd      = parseNull(request.getParameter("in_office_cd"));      //조직도 고유id 3레벨
String in_office_nm      = parseNull(request.getParameter("in_office_nm"));      //조직도 고유id 3레벨


String office_nm      = parseNull(request.getParameter("office_nm"));      //조직이름
String office_pt_memo = parseNull(request.getParameter("office_pt_memo")); //업무소개
String office_tel     = parseNull(request.getParameter("office_tel"));     //행정전화번호
String agent_id       = parseNull(request.getParameter("agent_id"));       //업무대행자id
String agen_nm        = parseNull(request.getParameter("agen_nm"));        //업무대행자이름
String standard_dt    = parseNull(request.getParameter("standard_dt"));    //기준일자
String reg_dt         = parseNull(request.getParameter("reg_dt"));         //등록일자
String reg_id         = parseNull(request.getParameter("reg_id"));         //등록자
String mod_dt         = parseNull(request.getParameter("mod_dt"));         //수정일자
String mod_id         = parseNull(request.getParameter("mod_id"));         //수정자
String sort_order     = parseNull(request.getParameter("sort_order"));     //정렬순서
String office_dp      = parseNull(request.getParameter("office_dp"));      //조직차수


String chk_obj      = parseNull(request.getParameter("chk_obj"));      //선택삭제하기 위한 데이터값


int key = 0;
int result = 0;

List<Map<String, Object>> dataList = null;


try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	
	if("insert".equals(command)){
		int empCnt = 0;
		
		//학교정보 입력
		key = 0;
		sql = new StringBuffer();
		sql.append("INSERT INTO DIVISION_WORK ");
		sql.append("(   ");
		sql.append("      E_SEQ           \n");
		sql.append("    , EMPLYR_NM       \n");
		sql.append("    , POSITION_NM     \n");
		sql.append("    , OFFICE_CD       \n");
		sql.append("    , OFFICE_NM       \n");
		sql.append("    , OFFICE_DP       \n");
		sql.append("    , OFFICE_PT_MEMO  \n");
		sql.append("    , OFFICE_TEL      \n");
		sql.append("    , AGENT_ID        \n");
		sql.append("    , AGEN_NM         \n");
		sql.append("    , STANDARD_DT     \n");
		sql.append("    , REG_DT          \n");
		sql.append("    , REG_ID          \n");
		sql.append("    , MOD_DT          \n");
		sql.append("    , MOD_ID          \n");
		sql.append("    , SORT_ORDER      \n");
		sql.append(")   ");
		sql.append(" VALUES ");
		sql.append("(   ");
		sql.append("      DIVISION_WORK_SEQ.NEXTVAL               \n"); // E_SEQ
		sql.append("    , '"+emplyr_nm+"'               \n"); // emplyr_nm
		sql.append("    , '"+position_nm+"'               \n"); // position_nm
		sql.append("    , '"+in_office_cd+"'               \n"); // office_cd
		sql.append("    , '"+in_office_nm+"'               \n"); // office_nm
		sql.append("    , 3               \n"); // office_dp
		sql.append("    , '"+office_pt_memo+"'              \n"); // office_pt_memo
		sql.append("    , '"+office_tel+"'               	\n"); // office_tel
		sql.append("    , ''               					\n"); // agent_id
		sql.append("    , '"+agen_nm+"'               		\n"); // agen_nm
		sql.append("    , '"+standard_dt+"'                 \n"); // standard_dt
		sql.append("    , TO_CHAR(SYSDATE,'YYYYMMDD')       \n"); // reg_dt
		sql.append("    , '"+sessionManager.getId()+"'      \n"); // reg_id
		sql.append("    , TO_CHAR(SYSDATE,'YYYYMMDD')       \n"); // mod_dt
		sql.append("    , '"+sessionManager.getId()+"'      \n"); // mod_id
		sql.append("    , '"+sort_order+"'                  \n"); // sort_order
		sql.append(")   ");
		pstmt = conn.prepareStatement(sql.toString());
		result = pstmt.executeUpdate();
		
		sql = new StringBuffer();
		sql.append(" UPDATE DIVISION_WORK SET ");
		sql.append("    STANDARD_DT = '"+standard_dt+"'               \n"); // 해당 부서의 기준일자를 전부 변경한다.
		//sql.append(" WHERE OFFICE_CD = '"+in_office_cd+"' ");
		sql.append(" WHERE OFFICE_CD LIKE '%'||SUBSTR('"+in_office_cd+"',1,10)||'%' ");
		
		pstmt = conn.prepareStatement(sql.toString());
		result = pstmt.executeUpdate();
		
		
		if(result > 0){
			sqlMapClient.commitTransaction();
		}
		
	}else if("update".equals(command)){
		key = 0;
		//학교정보 수정
		
		sql = new StringBuffer();
		sql.append(" UPDATE DIVISION_WORK SET ");
		sql.append("    EMPLYR_NM = '"+emplyr_nm+"'  ");
		sql.append("  , POSITION_NM = '"+position_nm+"'  ");
		sql.append("  , OFFICE_CD = '"+in_office_cd+"'  ");
		sql.append("  , OFFICE_NM = '"+in_office_nm+"'  ");
		sql.append("  , OFFICE_DP = 3  ");
		sql.append("  , OFFICE_PT_MEMO = '"+office_pt_memo+"'  ");
		sql.append("  , OFFICE_TEL = '"+office_tel+"'  ");
		sql.append("  , AGEN_NM = '"+agen_nm+"'  ");
		sql.append("  , SORT_ORDER = '"+sort_order+"'  ");
		sql.append("  , STANDARD_DT = '"+standard_dt+"'  ");
		sql.append("WHERE E_SEQ = '"+e_seq+"' ");	
		//sql.append("AND STANDARD_DT = '"+standard_dt+"' ");	
		pstmt = conn.prepareStatement(sql.toString());
		result = pstmt.executeUpdate();
		
		sql = new StringBuffer();
		sql.append(" UPDATE DIVISION_WORK SET ");
		sql.append("    STANDARD_DT = '"+standard_dt+"'               \n"); // 해당 부서의 기준일자를 전부 변경한다.
		//sql.append(" WHERE OFFICE_CD = '"+in_office_cd+"' ");
		sql.append(" WHERE OFFICE_CD LIKE '%'||SUBSTR('"+in_office_cd+"',1,10)||'%' ");
		
		pstmt = conn.prepareStatement(sql.toString());
		result = pstmt.executeUpdate();
		
		if(result > 0){
			sqlMapClient.commitTransaction();
		}
	}else if("delete".equals(command)){
		String[] idArr = chk_obj.split(",");	//선택값 파싱
		
		for(int i=0;i<idArr.length;i++){
			sql = new StringBuffer();
			sql.append(" DELETE FROM DIVISION_WORK ");
			sql.append("WHERE E_SEQ = '"+idArr[i]+"' ");
			
			pstmt = conn.prepareStatement(sql.toString());
			result = pstmt.executeUpdate();
		}
		
		if(result > 0){
			sqlMapClient.commitTransaction();
		}
	}
	
} catch (Exception e) {
	e.printStackTrace();
	sqlMapClient.endTransaction();
	alertBack(out, "처리중 오류가 발생하였습니다."+e.getMessage()); 
	//out.print(e.getMessage());
	
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
	if("delete".equals(command)){
		if(result>0){
			out.println("<script type=\"text/javascript\">");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("location.href='./list.jsp'");
			out.println("</script>");
		}else{
			out.println("<script type=\"text/javascript\">");
			out.println("alert('처리 중 오류가 발생하였습니다.');");
			out.println("location.href='./list.jsp'");
			out.println("</script>");
		} 
	}else{
		if(result>0){
			out.println("<script type=\"text/javascript\">");
			out.println("alert('정상적으로 처리되었습니다.');");
			out.println("opener.location.reload();");
			out.println("window.close();");
			out.println("</script>");
		}else{
			out.println("<script type=\"text/javascript\">");
			out.println("alert('처리 중 오류가 발생하였습니다.');");
			out.println("opener.location.reload();");
			out.println("window.close();");
			out.println("</script>");
		} 
	}
}

%>