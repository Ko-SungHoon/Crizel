<%
/**
*	PURPOSE	:	전입학 / 제2외국어 관리 수정페이지
*	CREATE	:	20180116_thur	JMG
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
int key                 =   0;
int result              =   0;

boolean adminChk	=	sessionManager.isRoleAdmin();

/* if(!adminChk){ */
	%>
	<!-- <script>alert('관리자권한이 없습니다. \n다시 로그인해주세요.'); location.href='/iam/main/index.sko';</script> -->
<%/* } */

//foreignList variables
String foreignCode	=	parseNull(request.getParameter("foreignCode"), "");
String fcode		=	"";
String fname    	=   "";
String useyn    	=   "";
String order    	=   "";

List<Map<String, Object>> foreignList   =	null;

if(!"".equals(foreignCode)){

	try {

		sqlMapClient.startTransaction();
		conn = sqlMapClient.getCurrentConnection();

		//제2외국어 수정페이지
		sql		   =    new StringBuffer();
		sql_str    =	"SELECT FCODE, FNAME, USEYN, ORDERED FROM TFOREIGN_CODE WHERE FCODE = ? ";
		sql.append(sql_str);
		pstmt	   =	conn.prepareStatement(sql.toString());
		pstmt.setString(1, foreignCode);
		rs		   =	pstmt.executeQuery();
		if(rs.next())	{
			fcode = rs.getString("FCODE");
			fname = rs.getString("FNAME");
			useyn = rs.getString("USEYN");
			order = rs.getString("ORDERED");
		}
		if (rs != null) try { rs.close(); } catch (SQLException se) {}
		if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}

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
} else {
	out.println("<script>");
    out.println("alert('파라미터 값 이상입니다. 관리자에게 문의하세요.');");
    out.println("window.close();");
    out.println("</script>");
}
%>


<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 제2외국어관리</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
		<link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css" />
		<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />

		<script>
			function modifyAct(fcode){				//수정
				var foreign_type = "mod";
				if(confirm("수정하시겠습니까?")==true){
					if(document.modifyForm.foreignName.value == ""){
						alert("외국어 명은 필수값입니다.");
						document.modifyForm.foreignName.focus();
					}

					document.modifyForm.foreignCode.value = fcode;
					document.modifyForm.foreign_type.value = foreign_type;
					document.modifyForm.submit();
				}
			}

			function cancelMod(){					//취소
				if(confirm("취소하시겠습니까?")==true){
					window.close();
				}else{
					return;
				}
			}
		</script>
	</head>

    <body>
		<div id="right_view">
			<div class="top_view">
				<p class="location"><strong>제2외국어관리(수정)</strong></p>
			</div>
            <div id="content">
                <div class="searchBox">
                    <form id="modifyForm" name="modifyForm" method="post" action="/program/transfer/admin/tra_foreign_act.jsp">
                    	<input type="hidden" name="foreignCode" value="" />
                    	<input type="hidden" name="foreign_type" value="" />
                        <table class="bbs_list2">
                        	<caption>제2외국어관리 수정페이지입니다.</caption>
                        	<colgroup>
                        		<col style="width:20%;"/>
                        		<col style="width:80%;"/>
                        	</colgroup>
                        	<thead>
                        		<tr>
                        			<th scope="col" colspan="2">제2외국어 수정페이지</th>
                        		</tr>
                        	</thead>
                        	<tbody>
                        		<tr>
                        			<th scope="col"><label for="fcode">코드명</label></th>
                        			<td><input type="text" name="fcode" id="fcode" value="<%=parseNull(fcode, "")%>" readonly />
                        			</td>
                        		</tr>
                        		<tr>
                        			<th scope="col"><label for="foreignName">외국어명</label></th>
                        			<td><input type="text" name="foreignName" id="foreignName" value="<%=parseNull(fname, "")%>" />
                        			</td>
                        		</tr>
                        		<tr>
                        			<th scope="col"><label for="order">순서</label></th>
                        			<td><input type="text" name="order" id="order" value="<%=parseNull(order, "")%>" />
                        			</td>
                        		</tr>
                        		<tr>
                        			<th scope="col"><label for="useYn">사용여부</label></th>
                        			<td>
                        				<label><input type="radio" name="useYn" value="Y" <%if(parseNull(useyn).equals("Y")){%>checked<%}%>>사용</label>
                        				&nbsp;&nbsp;&nbsp;
                        				<label><input type="radio" name="useYn" value="N" <%if(parseNull(useyn).equals("N")){%>checked<%}%>>미사용</label>
                        			</td>
                        		</tr>
                        	</tbody>
                        </table>
                        <div class="btn_area txt_c">
	                        <a href="javascript:modifyAct('<%=foreignCode%>')" class="btn edge small darkMblue">수정</a>&nbsp;
	                        <a href="javascript:cancelMod();" class="btn edge small mako">취소</a>
												</div>
                    </form>
                </div>
	        </div>
        </div>
    </body>
</html>
