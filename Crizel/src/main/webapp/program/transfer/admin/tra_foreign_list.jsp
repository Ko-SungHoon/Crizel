<%
/**
*	PURPOSE	:	전입학 / 제2외국어관리
*	CREATE	:	20180118_thur	JI
*	MODIFY	:	20180118_thur	JMG
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

String pageTitle = "제2외국어";

//foreignList variables
String fnum     =   "";
String fcode    =   "";
String fname    =   "";
String useyn    =   "";
String order    =   "";

List<Map<String, Object>> foreignList   =	null;

boolean adminChk	=	sessionManager.isRoleAdmin();

/* if(!adminChk){ */
	%>
	<!-- <script>alert('관리자권한이 없습니다. \n다시 로그인해주세요.'); location.href='/iam/main/index.sko';</script> -->
<%/* } */

try {

	sqlMapClient.startTransaction();
	conn = sqlMapClient.getCurrentConnection();

    //제2외국어 리스트 호출
    sql        =   new StringBuffer();
	sql_str    =   "SELECT ROWNUM, A.* FROM (SELECT ROWNUM, FCODE, FNAME, USEYN, ORDERED FROM TFOREIGN_CODE ORDER BY ORDERED, ROWNUM, FCODE) A";
	sql.append(sql_str);
	pstmt      =   conn.prepareStatement(sql.toString());
	rs         =   pstmt.executeQuery();
	foreignList    =   getResultMapRows(rs);
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
			function foreignMod(fcode, fname){		//수정
        		var foreign_type = "mod";
				var moveUrl = "/program/transfer/admin/tra_foreign_reg.jsp?foreignCode=" + fcode;
				window.open(moveUrl, "제2외국어 수정페이지", "width=450px, height=400px, toolbar=no, menubar=no, scrollbars=no");

			}

        	function foreignDel(fcode, fname){		//삭제
        		var foreign_type = "del";
        		if(confirm("정말 " + fname + "를 삭제하시겠습니까?")==true){
        			location.href = "/program/transfer/admin/tra_foreign_act.jsp?foreign_type=" + foreign_type + "&foreignCode=" + fcode;
        		}else{
        			return;
        		}
        	}
		</script>
	</head>

    <body>
		<div id="right_view">
			<div class="top_view">
				<p class="location"><strong>제2외국어관리</strong></p>
                <p class="loc_admin">
                    <a href="/iam/main/index.sko?lang=en_US" target="_top" class="white">ENGLISH</a> <span class="yellow">[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span>님 안녕하세요.
                    <a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
                </p>
			</div>
            <div id="content">
                <div class="searchBox">
                    <form id="foreignForm" action="./tra_foreign_act.jsp" method="post">
                        <input type="hidden" name="foreign_type" id="foreign_type" value="add">
                        <fieldset>
						<legend>기관 검색</legend>
						<div class="boxinner">
							<legend>제2외국어 등록 input</legend>
                            <span>
                                <label for="foreignCode">코드명</label>
                                <input name="foreignCode" id="foreignCode" type="text" value="">
                            </span>
                            <span>
                                <label for="foreignName">외국어명</label>
                                <input name="foreignName" id="foreignName" type="text" value="">
                                <input class="btn small edge mako" type="submit" value="제2 외국어 등록하기">
                            </span>
                        </div>
                        </fieldset>
                    </form>
                </div>

                <div class="listArea">
				<form id="postForm" name="postForm" method="post">
					<fieldset>
					<legend>교원 목록 결과</legend>
					<table class="bbs_list">
                        <colgroup>
                        <col class="wps_5">
                        <col class="wps_10">
                        <col class="wps_10">
                        <col>
                        <col>
                        <col>
                        </colgroup>
                        <thead>
                        <tr>
                        <th scope="col">번호</th>
                        <th scope="col">순서</th>
                        <th scope="col">코드명</th>
                        <th scope="col">제2외국어명</th>
                        <th scope="col">사용 여부</th>
                        <th scope="col">관리</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                        //	spreading dataList info
                        if (foreignList != null && foreignList.size() > 0) {
                            for (int i = 0; i < foreignList.size(); i++) {
                                Map<String, Object> dataMap =   foreignList.get(i);
                                fnum    =   parseNull((String)dataMap.get("ROWNUM"));
                                fcode   =   parseNull((String)dataMap.get("FCODE"));
                                fname   =   parseNull((String)dataMap.get("FNAME"));
                                useyn   =   parseNull((String)dataMap.get("USEYN"));
                                order   =   parseNull((String)dataMap.get("ORDERED"));
                                %>
                            <tr>
                            <td><%=fnum %></td>
                            <td><%=order %></td>
                            <td><%=fcode %></td>
                            <td><%=fname %></td>
                            <td><%=useyn %></td>
                            <td>
	                            <a class="btn edge small darkMblue" onclick="foreignMod('<%=fcode %>', '<%=fname%>');">수정</a>
	                            &nbsp;
	                            <a class="btn edge small mako" onclick="foreignDel('<%=fcode %>', '<%=fname%>');">삭제</a>
                            </td>
                            </tr>
                        <%
                            }
                        } else {
                        %>
                            <tr>
                            <td colspan="6"></td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>

                    </fieldset>
                </form>
            </div>
        	</div>
        </div>
    </body>
</html>
