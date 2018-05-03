<%
/**
*	PURPOSE	:	전입학 / 신규학교, 학교정보 수정
*	CREATE	:	20180201_thur	JMG
*	MODIFY	:	....
*/

%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>

<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");
SessionManager sessionManager = new SessionManager(request);

Connection conn         =   null;
PreparedStatement pstmt =   null;
ResultSet rs            =   null;
StringBuffer sql        =   null;

String sql_str          =   "";
String sql_where        =   "";
int result              =   0;

//탭정보
String tabName          =   "";
String ordered          =   "";
String tabNo          	=   parseNull(request.getParameter("goTab"));
String popType			=	parseNull(request.getParameter("popType"));

try {
    sqlMapClient.startTransaction();
    conn    =   sqlMapClient.getCurrentConnection();

	if("tabMod".equals(popType)){
		sql     =   new StringBuffer();
	    sql_str =   "SELECT TABNAME, ORDERED FROM TORG_TAB WHERE TABNO = ? ";
	    sql.append(sql_str);
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, tabNo);
	    rs      =   pstmt.executeQuery();
		if(rs.next()){
			tabName	=	rs.getString("TABNAME");
			ordered	=	rs.getString("ORDERED");
		}
	}

} catch (Exception e) {
    e.printStackTrace();
    alertBack(out, "처리중 오류가 발생하였습니다." + e.getMessage());
} finally {
    if (rs != null) try { rs.close(); } catch (SQLException se) {}
    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
    if (conn != null) try { conn.close(); } catch (SQLException se) {}
    sqlMapClient.endTransaction();
}

%>

<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 탭 정보 수정</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
		<link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css" />
		<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />

        <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
		<script>
			function tabModify(){
				document.modifyForm.action="/program/transfer/admin/tra_sch_act.jsp?actType=tabMod";
				document.modifyForm.submit();
			}
		</script>
	</head>
    <body>
		<div id="right_view">
			<div class="top_view">
				<p class="location"><strong>탭 정보 수정</strong></p>
			</div>
            <div id="content">
                <div class="searchBox">
                    <form id="modifyForm" name="modifyForm" method="post">
                    	<input type="hidden" name="tabNo" value="<%=tabNo%>">
                        <table class="bbs_list2">
                        	<caption>탭 정보 수정 페이지입니다.</caption>
                        	<colgroup>
                        		<col style="width:20%;"/>
                        		<col style="width:80%;"/>
                        	</colgroup>
                        	<thead>
                        		<tr>
                        			<th scope="col" colspan="2">텝 정보 수정 페이지</th>
                        		</tr>
                        	</thead>
                        	<tbody>
                        		<tr>
                        			<th scope="col"><label for="tabName">탭이름</label></th>
                        			<td>
                                        <input type="text" name="tabName" id="tabName" value="<%=parseNull(tabName)%>">
                        			</td>
                        		</tr>
                        		<tr>
                        			<th scope="col"><label for="ordered">순서</label></th>
                        			<td>
                        				<input type="text" name="ordered" id="ordered" value="<%=parseNull(ordered)%>">
                        			</td>
                        		</tr>
							</tbody>
						</table>
                        <div class="btn_area txt_c">
	                        <a href="javascript:tabModify();" class="btn edge small darkMblue">수정</a>&nbsp;
	                        <a href="javascript:window.close();" class="btn edge small mako">닫기</a>
						</div>
                    </form>
                </div>
	        </div>
        </div>
    </body>
</html>
