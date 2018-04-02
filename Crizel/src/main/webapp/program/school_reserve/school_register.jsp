<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

String schoolPage = "DOM_000001201007003000";		//학교정보 페이지
//String schoolPage = "DOM_000000106007003000";		//테스트서버

String admin_yn  	= parseNull(request.getParameter("admin_yn"));
String school_id  	= parseNull(request.getParameter("school_id"));
String school_name  = parseNull(request.getParameter("school_name"));
String school_area  = parseNull(request.getParameter("school_area"));
String school_addr  = parseNull(request.getParameter("school_addr")); 
String school_tel  	= parseNull(request.getParameter("school_tel")); 
String school_url  	= parseNull(request.getParameter("school_url")); 
String charge_dept  = parseNull(request.getParameter("charge_dept"));
String dept_tel  	= parseNull(request.getParameter("dept_tel"));
String charge_name  = parseNull(request.getParameter("charge_name"));
String charge_name2	= parseNull(request.getParameter("charge_name2"));
String charge_phone	= parseNull(request.getParameter("charge_phone"));
String account  	= parseNull(request.getParameter("account"));
String area_type  	= parseNull(request.getParameter("area_type"));
String charge_id  	= parseNull(request.getParameter("charge_id"));
String command 		= parseNull(request.getParameter("command"));
String school_type	= parseNull(request.getParameter("school_type"));

int key = 0;
int result = 0;

List<Map<String, Object>> dataList = null;

if("".equals(area_type) || area_type ==null){
	area_type = "N";
}

try {
	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();	
	
	key = 0;
	sql = new StringBuffer();
	sql.append("SELECT * FROM RESERVE_SCHOOL WHERE CHARGE_ID = ?  ");
	pstmt = conn.prepareStatement(sql.toString());
	pstmt.setString(++key, charge_id);
	rs = pstmt.executeQuery();
	if(rs.next()){
		if("insert".equals(command)){
			out.println("<script>alert('이미 등록된 정보가 있습니다.'); history.go(-1);</script>");
		}
	}
	
	if("insert".equals(command)){
		//학교정보 입력
		key = 0;
		sql = new StringBuffer();
		sql.append("INSERT INTO RESERVE_SCHOOL(SCHOOL_ID, SCHOOL_NAME, SCHOOL_AREA, SCHOOL_ADDR, SCHOOL_TEL, SCHOOL_URL, CHARGE_DEPT,    ");
		sql.append(" 	 DEPT_TEL, CHARGE_NAME, CHARGE_PHONE, ACCOUNT, AREA_TYPE, CHARGE_ID, SCHOOL_APPROVAL, CHARGE_NAME2, SCHOOL_TYPE  ) ");
		sql.append("VALUES(SCHOOL_ID_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'W', ?, ?) ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(++key, school_name);
		pstmt.setString(++key, school_area);
		pstmt.setString(++key, school_addr);
		pstmt.setString(++key, school_tel);
		pstmt.setString(++key, school_url);
		pstmt.setString(++key, charge_dept);
		pstmt.setString(++key, dept_tel);
		pstmt.setString(++key, charge_name);
		pstmt.setString(++key, charge_phone);
		pstmt.setString(++key, account);
		pstmt.setString(++key, area_type);
		pstmt.setString(++key, charge_id);
		pstmt.setString(++key, charge_name2);
		pstmt.setString(++key, school_type);
		result = pstmt.executeUpdate();
		if(result > 0){
			sqlMapClient.commitTransaction();
		}
		
	}else if("update".equals(command)){
		key = 0;
		//학교정보 수정
		sql = new StringBuffer();
		sql.append("UPDATE RESERVE_SCHOOL SET SCHOOL_NAME=?, SCHOOL_AREA=?, SCHOOL_ADDR=?, SCHOOL_TEL=?, SCHOOL_URL=?, CHARGE_DEPT=?, DEPT_TEL=?, ");
		sql.append(" 	 CHARGE_NAME=?, CHARGE_PHONE=?, ACCOUNT=?, AREA_TYPE=?, CHARGE_ID=?, CHARGE_NAME2 = ?, SCHOOL_TYPE = ? ");
		sql.append("WHERE SCHOOL_ID = ? ");
		pstmt = conn.prepareStatement(sql.toString());
		pstmt.setString(++key, school_name);
		pstmt.setString(++key, school_area);
		pstmt.setString(++key, school_addr);
		pstmt.setString(++key, school_tel);
		pstmt.setString(++key, school_url);
		pstmt.setString(++key, charge_dept);
		pstmt.setString(++key, dept_tel);
		pstmt.setString(++key, charge_name);
		pstmt.setString(++key, charge_phone);
		pstmt.setString(++key, account);
		pstmt.setString(++key, area_type);
		pstmt.setString(++key, charge_id);
		pstmt.setString(++key, charge_name2);
		pstmt.setString(++key, school_type);
		pstmt.setString(++key, school_id);
		result = pstmt.executeUpdate();
		if(result > 0){
			sqlMapClient.commitTransaction();
		}
		
	}
	
} catch (Exception e) {
	e.printStackTrace();
	sqlMapClient.endTransaction();
	//alertBack(out, "처리중 오류가 발생하였습니다.");  
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
	
	if(result>0){
		out.println("<script type=\"text/javascript\">");
		out.println("alert('정상적으로 처리되었습니다.');");
		if("".equals(admin_yn)){
			out.println("location.replace('/index.gne?menuCd=" + schoolPage + "&charge_id="+charge_id+"');");
		}else{
			out.println("opener.location.reload();");
			out.println("window.close();");
		}
		out.println("</script>");
	}else{
		out.println("<script type=\"text/javascript\">");
		out.println("alert('처리 중 오류가 발생하였습니다.');");
		if("".equals(admin_yn)){
			out.println("location.replace('/index.gne?menuCd=" + schoolPage + "&charge_id="+charge_id+"');");
			//out.println("location.replace('/index.gne?menuCd=" + schoolPage + "&charge_id="+charge_id+"');");		//테스트서버
		}else{
			out.println("opener.location.reload();");
			out.println("window.close();");
		}
		out.println("</script>");
	} 
 	
	
}

%>