
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

Connection conn         =   null;
PreparedStatement pstmt =   null;
ResultSet rs            =   null;
StringBuffer sql        =   null;
String sql_str          =   "";
String sql_where        =   "";
int key                 =   0;
int result              =   0;
String outHtml			=	"";

String schNameParam	=	parseNull(request.getParameter("schName"));
String schName		=	"";
String schNo		=   "";

List<Map<String, Object>> searchList	=	null;
try {

	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	if(!"".equals(schNameParam)){
	    //제2외국어 리스트 호출
	    sql        =   new StringBuffer();
		sql_str    =   " SELECT ROWNUM, ORGNAME, ORGNO FROM TORG_INFO WHERE ROWNUM > 0 AND ROWNUM <= 50 AND ORGNAME LIKE '%' || ? || '%' ORDER BY ORGNO ";
		sql.append(sql_str);
		pstmt      =   conn.prepareStatement(sql.toString());
		pstmt.setString(1, schNameParam);
		rs         	=   pstmt.executeQuery();
		searchList	=	getResultMapRows(rs);	
	}
} catch (Exception e) {
    out.println(e.toString());
	e.printStackTrace();
	//alertBack(out, "처리중 오류가 발생하였습니다.");
} finally {
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	if (conn != null) try { conn.close(); } catch (SQLException se) {}
	sqlMapClient.endTransaction();
}
%>

<%
if(searchList != null && searchList.size() > 0){
	%>
	<div style="background-color:#F6F6F6; width:200px; overflow: auto; height:100px;">
		<ul>
		<%
		for(int i=0; i<searchList.size(); i++){
			Map<String, Object> map	=	searchList.get(i);
			schName	=	(String)map.get("ORGNAME");
			schNo	=	(String)map.get("ORGNO");
			%>
			<li id="searchResult<%=i+1%>"><a href="javascript:selInput('<%=schName%>');"><%=schName%></a></li>
			<%
		}%>
		</ul>
	</div>
	<%
	}
%>
                                                                                                            