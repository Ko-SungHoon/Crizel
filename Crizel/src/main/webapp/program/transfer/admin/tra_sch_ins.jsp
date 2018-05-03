<%
/**
*	PURPOSE	:	전입학 / 학교 매칭 페이지
*	CREATE	:	20180119_fri	JMG
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

//paging
Paging paging 			=	new Paging();
String pageNo			=	parseNull(request.getParameter("pageNo"), "1");	
int totalCount			=	0;

Connection conn         =   null;
PreparedStatement pstmt =   null;
ResultSet rs            =   null;
StringBuffer sql        =   null;

String sql_str          =   "";
String sql_where        =   "";
int result              =   0;

String rNum				=	"";
String orgNo			=	"";
String orgName			=	"";
String orgArea			=	"";
String tabNo			=	parseNull(request.getParameter("tabNo"));
String tabName			=	"";
String schName			=	parseNull(request.getParameter("schName"));

List<Map<String, Object>> schoolList   =	null;

boolean adminChk	=	sessionManager.isRoleAdmin();

/* if(!adminChk){
 */	%>
<!-- 	<script>alert('관리자권한이 없습니다. \n다시 로그인해주세요.'); location.href='/iam/main/index.sko';</script>
 --><%/* } */

try {

	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();
	
	//현재탭이 어떤탭인지 
	sql		   	=    new StringBuffer();	
	sql_str    	=	" SELECT TABNAME FROM TORG_TAB WHERE TABNO = ?";
	sql.append(sql_str);
	pstmt		=	conn.prepareStatement(sql.toString());
	pstmt.setString(1, tabNo);
	rs			=	pstmt.executeQuery();
	if(rs.next())	tabName  =   rs.getString("TABNAME");
	
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	
	//학교리스트 개수
	sql		   	=    new StringBuffer();
	sql_where	=	" WHERE ORGTYPE = 'SCHOOL' AND USEYN = 'Y' AND SCHTYPE IN ('APPSCH', 'NAPPSCH', 'TECHSCH', 'LIFESCH') ";
	sql_where	+=	" AND TABNO IS NULL ";
	
	if(!"".equals(schName)){
		sql_where	+=	" AND ORGNAME LIKE '%'|| ? ||'%' ";
		paging.setParams("schName", schName);
	}
	sql_str    	=	" SELECT COUNT(*) AS CNT FROM TORG_INFO " + sql_where;
	sql.append(sql_str);
	pstmt		=	conn.prepareStatement(sql.toString());
	if(!"".equals(schName)){
		pstmt.setString(1, schName);
	}	
	rs			=	pstmt.executeQuery();
	if(rs.next())	totalCount	= rs.getInt("CNT");
	
	
	if (rs != null) try { rs.close(); } catch (SQLException se) {}
	if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	
	paging.setPageNo(Integer.parseInt(pageNo));
	paging.setTotalCount(totalCount);
	
	//학교리스트 불러오기
	sql		   	=    new StringBuffer();
	
	sql_str    	=	" SELECT * FROM (								\n"
				+	" SELECT ROWNUM AS RNUM, A.* FROM ( 			\n"
				+	" SELECT ORGNO, ORGNAME, ORGAREA FROM	 		\n"
				+	" TORG_INFO " + sql_where + "					\n" 
				+ 	" ORDER BY ORGNO, ORGNAME, ORGAREA				\n"
				+	" )A WHERE ROWNUM <=" + paging.getEndRowNo() + "\n"
				+	" )WHERE RNUM > " + paging.getStartRowNo() + " 	\n";
	sql.append(sql_str);
	pstmt	   	=	conn.prepareStatement(sql.toString());
	if(!"".equals(schName)){
		pstmt.setString(1, schName);
	}
	rs		   	=	pstmt.executeQuery();
	schoolList 	=	getResultMapRows(rs);
		
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


<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 정현원 및 학교관리 > 학교 추가</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
		<link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css" />
		<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
		
		<script>
			function selectSch(orgNo, tabNo){				//학교 선택
				var actType	=	"sel";
				var tabName =	"<%=tabName%>";
				if(confirm(tabName + "에 해당 학교를 추가하시겠습니까?")==true){
					document.selectForm.action		= 	"/program/transfer/admin/tra_sch_act.jsp?actType=" + actType;
					document.selectForm.orgNo.value	=	orgNo;
					document.selectForm.tabNo.value	=	tabNo;
					document.selectForm.submit();
				}
			}						
		</script>
	</head>

    <body>
		<div id="right_view">
			<div class="top_view">
				<p class="location"><strong><%=tabName %> 학교 추가</strong></p>
			</div>
            <div id="content">
            	<div class="searchBox">
            		<form id="searchForm" name="searchForm" method="post">
            			<label for="schName">학교검색</label>
            			<input type="text" name="schName" id="schName" value="">
            			<input type="submit" value="검색" class="btn small edge mako"> 
            		</form>
            	</div>
                <div class="searchBox">
                    <form id="selectForm" name="selectForm" method="post">
                    	<input type="hidden" name="orgNo" value="" />
                    	<input type="hidden" name="tabNo" value="" />
                        <table class="bbs_list">
                        	<caption>학교 추가 페이지입니다.</caption>
                        	<colgroup>
                        		<col style="width:10%;"/>
                        		<col style="width:10%;"/>
								<col />
                        		<col style="width:30%;"/>
                        		<col style="width:10%;"/>
                        	</colgroup>
                        	<thead>
                        		<tr>
                        			<th scope="col">번호</th>
                        			<th scope="col">학교코드</th>
                        			<th scope="col">학교명</th>
                        			<th scope="col">지역</th>
                        			<th scope="col">선택</th>
                        		</tr>
                        	</thead>
                        	<tbody>
                        		<%
                        		if(schoolList != null && schoolList.size() > 0){
                        			for(int i=0; i<schoolList.size(); i++){
                        				Map<String, Object> map = schoolList.get(i);
                        				rNum		=	(String)map.get("RNUM");
                        				orgNo		=	(String)map.get("ORGNO");
                        				orgName		=	(String)map.get("ORGNAME");
                        				orgArea		=	(String)map.get("ORGAREA");
                        				%>
                        				<tr>
		                        			<td><%=rNum%></td>
		                        			<td><%=orgNo%></td>
		                        			<td><%=orgName%></td>
		                        			<td><%=orgArea%></td>
		                        			<td><a href="javascript:selectSch('<%=orgNo%>', '<%=tabNo%>');">선택</a></td>
		                        		</tr>
                        				<%
                        			}
                        		} else {
                        			%>
                        			<tr>
                        				<td colspan="5">목록이 존재하지 않습니다.</td>
                        			</tr>
                        			<%
                        		}
                        		%>
                        		
                        	</tbody>
                        </table>
                    </form>
                     <% if(paging.getTotalCount() > 0) { %>
		                <div class="page_area"><p style="text-align:center;" id="btn_g"><%=paging.getHtml("1")%></p></div>
		             <% } %>
		             <div style="text-align:center;">
	                        <a href="javascript:window.close();" class="btn edge small mako">취소</a>
					</div>
                </div>
	        </div>
        </div>
    </body>
</html>