<%
/**
*	PURPOSE	:	ajax 통신을 통한 동적 select 박스 구성을 위한 jsp 파일
*	CREATE	:	20171108_wedns	JI
*	MODIFY	:	....
*/
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>

<%
	response.setCharacterEncoding("UTF-8");
	request.setCharacterEncoding("UTF-8");
	SessionManager sessionManager = new SessionManager(request);

	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	StringBuffer sql = null;
	String sql_str	=	"";

	int key = 0;
	int result = 0;
	List<Map<String, Object>> dataList = null;

	//	parameters
	String group_seq	=	parseNull(request.getParameter("group_seq"));	//group_seq
	//String group_lv		=	parseNull(request.getParameter("group_lv"));	//group_lv
	
	//	1차 그룹 리스트 call
	try {

		sqlMapClient.startTransaction();
		conn = sqlMapClient.getCurrentConnection();

		sql	=	new StringBuffer();
		sql_str	+=	"SELECT * FROM NOTE_GROUP_LIST WHERE PARENT_SEQ = '" + group_seq  + "' ORDER BY GROUP_SEQ ASC";
		sql.append(sql_str);
		pstmt = conn.prepareStatement(sql.toString());
		rs = pstmt.executeQuery();
		dataList = getResultMapRows(rs);

		String outHtml	=	"";
		if (dataList != null && dataList.size() > 0) {
			for (int i = 0; i < dataList.size(); i++) {
				Map<String, Object> dataMap	=	dataList.get(i);
				outHtml	+=	"<option value=" + parseNull((String)dataMap.get("GROUP_SEQ")) + ">";
				outHtml +=	parseNull((String)dataMap.get("GROUP_NM"));
				outHtml +=	"</option>";
			}
		}
		out.println(outHtml);

	} catch (Exception e) {
		%>
		<%=e.toString() %>
		<%
		e.printStackTrace();
		sqlMapClient.endTransaction();
		//alertBack(out, "처리중 오류가 발생하였습니다.");
	} finally {
		if (rs != null) try { rs.close(); } catch (SQLException se) {}
		if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
		if (conn != null) try { conn.close(); } catch (SQLException se) {}
		sqlMapClient.endTransaction();
	}
%>