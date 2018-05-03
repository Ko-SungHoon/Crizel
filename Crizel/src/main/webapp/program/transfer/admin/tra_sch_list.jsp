<%
/**
*	PURPOSE	:	전입학 / 정현원 및 학교관리
*	CREATE	:	20180118_thur	JI
*	MODIFY	:	20180119_fri	JMG
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

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

String sql_str	=	"";
String outHtml  =   "";

//탭 관련 변수
String goTab	=	parseNull(request.getParameter("goTab"), "");		//현재 탭
String tabName	=	"";
String tabNo	=	"";
String useYn	=	"";
String tabChk	=	"Y";

//학교 관련 변수
String orgNo	=	"";
String orgName	=	"";
String gender	=	"";
String genderKor=	"";
String orgNumNo =   "";
String fixNum   =   "";
String currNum  =   "";
String schGrade =   "";
String shortInNum   =   "";
String shortOutNum  =   "";
String waitNum  =   "";
String fcode1   =   "";
String fcode2   =   "";
String fcode3   =   "";

List<Map<String, Object>> tabList	=	null;			//탭 목록
List<Map<String, Object>> schoolList	=	null;		//탭별 학교리스트
List<Map<String, Object>> foreignList	=	null;		//제2외국어 리스트

boolean adminChk	=	sessionManager.isRoleAdmin();

/* if(!adminChk){
 */	%>
<!-- 	<script>alert('관리자권한이 없습니다. \n다시 로그인해주세요.'); location.href='/iam/main/index.sko';</script>
 --><%/* } */

try {
    sqlMapClient.startTransaction();
    conn    =   sqlMapClient.getCurrentConnection();

    //탭
    sql     =   new StringBuffer();
    sql_str =   "SELECT TABNAME, TABNO, USEYN FROM TORG_TAB WHERE USEYN !='N' ORDER BY ORDERED, TABNO ";
    sql.append(sql_str);
    pstmt	=	conn.prepareStatement(sql.toString());
    rs      =   pstmt.executeQuery();
    tabList	=	getResultMapRows(rs);

    if(tabList == null || tabList.size() < 1){
    	tabChk	= "N";
    }

    if (rs != null) try { rs.close(); } catch (SQLException se) {}
    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}

    //첫 페이지 보여주기
    if("".equals(goTab) && "Y".equals(tabChk)){		//사용여부가 Y인 테이블이 하나이상 존재하고 goTab이 빈값일 떄
    	sql     =   new StringBuffer();
        sql_str =   " SELECT * FROM ( ";
        sql_str +=	" SELECT A.*, ROWNUM AS RNUM FROM ( ";
        sql_str +=  " SELECT TABNO FROM TORG_TAB ";
        sql_str +=	" WHERE USEYN != 'N' ORDER BY ORDERED, REG_DATE, TABNO ";
        sql_str +=	" )A WHERE ROWNUM <= 1 ";
        sql_str +=	" ) WHERE RNUM > 0 ";
        sql.append(sql_str);
        pstmt	=	conn.prepareStatement(sql.toString());
        rs      =   pstmt.executeQuery();
        if(rs.next())	goTab = rs.getString("TABNO");

        if (rs != null) try { rs.close(); } catch (SQLException se) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
    }

    //제2외국어 리스트 호출
    sql		=	new StringBuffer();
    sql_str	=	"SELECT * FROM TFOREIGN_CODE ORDER BY ORDERED, FCODE";
    sql.append(sql_str);
    pstmt		=	conn.prepareStatement(sql.toString());
    rs			=	pstmt.executeQuery();
    foreignList	=	getResultMapRows(rs);

    if (rs != null) try { rs.close(); } catch (SQLException se) {}
    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}

    //학교 리스트 호출
    sql		=	new StringBuffer();
    sql_str	=	"SELECT NUM.ORGNUMNO, INFO.ORGNO, INFO.ORGNAME, INFO.SEX,          					";
    sql_str +=	"INFO.TABNO, COUNT(*)OVER(PARTITION BY INFO.ORGNO) AS ROWSPAN			";
    sql_str +=	", NUM.GRADE, NUM.FIXNUM, NUM.CURRNUM, NUM.SHORTINNUM, NUM.SHORTOUTNUM  ";
    sql_str +=	", NUM.WAITNUM, NUM.FCODE, NUM.FCODE2, NUM.FCODE3                  	 	";
    sql_str +=	"FROM TORG_INFO INFO INNER JOIN (SELECT * FROM TORG_NUM_PERSON ORDER BY GRADE) NUM   ";
    sql_str	+=	"ON INFO.ORGNO = NUM.ORGNO 												";
    sql_str +=	"WHERE INFO.TABNO = ?                                					";
    sql_str +=	"AND INFO.USEYN != 'N' 			         								";
    sql_str +=	"ORDER BY INFO.ORGNAME, NUM.GRADE 			         					";

    sql.append(sql_str);
    pstmt		=	conn.prepareStatement(sql.toString());
    pstmt.setString(1, goTab);
    rs			=	pstmt.executeQuery();
    schoolList	=	getResultMapRows(rs);

} catch (Exception e) {
    e.printStackTrace();
    alertBack(out, "처리중 오류가 발생하였습니다."+e.getMessage());
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
		<title>RFC관리자 > 정현원 및 학교관리</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />

		<script>
	        function newTab(){		//새 탭
	        	var actType = "newTab";
	        	if(document.tabForm.tabName.value.trim() == ""){
	        		alert("지역명을 입력해주세요.");
	        		document.tabForm.tabName.focus();
	        		return false;
	        	}
	        	return true;
	        }

	        function schoolAdd(goTab){	//학교 추가
	        	var moveUrl = "/program/transfer/admin/tra_sch_ins.jsp?tabNo=" + goTab;
	        	if(goTab != ''){
	        		window.open(moveUrl, "학교 매칭", "width=800px, height=650px, toolbar=no, menubar=no, scrollbars=yes");
	        	}else{
	        		alert("탭이 선택되지 않았습니다.");
	        		return;
	        	}
	        }

	        function tabModify(goTab){	//탭 정보수정
	        	var moveUrl	= "/program/transfer/admin/tra_sch_tabMod.jsp?goTab=" + goTab + "&popType=tabMod";
	        	if(goTab != ''){
	        		window.open(moveUrl, "탭 정보 수정", "width=400px, height=300px, toolbar=no, menubar=no, scrollbars=no");
	        	}else{
	        		alert("탭이 선택되지 않았습니다.");
	        		return;
	        	}
	        }

	        function delTab(tabNo){		//탭 삭제
	        	var actType = "delTab";
	        	if(confirm("정말 탭을 삭제하시겠습니까? \n삭제해도 실제 학교데이터는 사라지지 않습니다.")==true){
	        		location.href="/program/transfer/admin/tra_sch_act.jsp?actType=" + actType + "&tabNo=" + tabNo;
	        	}
	        }

	        function delSch(orgNo){		//학교삭제
	        	var actType	= "delSch";
	        	if(confirm("정말 학교를 삭제하시겠습니까? \n삭제해도 실제 학교데이터는 사라지지 않습니다.")==true){
	        		location.href="/program/transfer/admin/tra_sch_act.jsp?actType=" + actType + "&orgNo=" + orgNo;
	        	}
	        }

            //학교 정보 수정 팝업
            function modifySchInfo(schNo) {
                if (schNo) {
                    var moveUrl = "/program/transfer/admin/tra_sch_pop.jsp?schNo=" + schNo;
                    window.open(moveUrl, "학교 정보 수정", "width=800px, height=650px, toolbar=no, menubar=no, scrollbars=yes");
                } else {
                    var moveUrl = "/program/transfer/admin/tra_sch_pop.jsp";
                    window.open(moveUrl, "신규 학교 등록", "width=800px, height=650px, toolbar=no, menubar=no, scrollbars=yes");
                }
            }
		</script>
	</head>

    <body>
		<div id="right_view">
            <div class="top_view">
				<p class="location"><strong>정현원 및 학교관리</strong></p>
                <p class="loc_admin">
                    <a href="/iam/main/index.sko?lang=en_US" target="_top" class="white">ENGLISH</a> <span class="yellow">[<%=sessionManager.getSgroupNm() %>]<%=sessionManager.getName() %></span>님 안녕하세요.
                    <a href="/j_spring_security_logout?returnUrl=/iam/login/login_init.sko"><img src="/images/egovframework/rfc3/iam/images/logout.gif" alt="logout"  class="log_img"/></a>
                </p>
			</div>
            <div id="content">
            	<div class="searchBox" style="margin-bottom:5px;">
            		<form id="tabForm" name="tabForm" method="post" action="/program/transfer/admin/tra_sch_act.jsp?actType=newTab"
            		onsubmit="return newTab();">
            			<label for="tabName" class="blind">새 지역</label>
            			<input type="text" name="tabName" id="tabName" value="">
            			<input type="submit" title="새 탭 " class="btn small edge mako" value="탭 추가">

                        <input type="button" onclick="javascript:modifySchInfo();" class="btn small edge mako" value="신규 학교 등록" >
            		</form>
            	</div>

                <div class="listArea" style="border-top: 1px solid;">
                <div class="tabBox" style="margin-top:5px;">
				<%
           		if(tabList != null && tabList.size() > 0){
           			for(int i=0; i<tabList.size(); i++){
           				Map<String, Object> map	=	tabList.get(i);
           				tabName =   parseNull((String)map.get("TABNAME"));
           				tabNo	=   parseNull((String)map.get("TABNO"));
           				useYn	=   parseNull((String)map.get("USEYN"));

                        if (goTab.equals(tabNo)) {
                        %>
                            <span class="btn small edge white">
                                <a href="/program/transfer/admin/tra_sch_list.jsp?goTab=<%=tabNo%>"
                                title="<%=tabName%>"><%=tabName%></a>
                                &nbsp;
                                <a href="javascript:delTab('<%=tabNo%>');" title="<%=tabName%> 삭제" class="fb">x</a>
                            </span>
                        <%
                        } else {
           				%>
           				<span class="btn small edge mako">
           					<a href="/program/transfer/admin/tra_sch_list.jsp?goTab=<%=tabNo%>" style="color:white;"
           					title="<%=tabName%>"><%=tabName%></a>
           					&nbsp;
           					<a href="javascript:delTab('<%=tabNo%>');" title="<%=tabName%> 삭제" style="color:white;">x</a>
           				</span>
           				<%
                        }
           			}
           		}
               	%>
               	<%if(!"".equals(goTab) && tabChk != "N"){ %>
                  <div class="f_r btn_area">
                    <input type="button" onclick="javascript:tabModify('<%=goTab%>');" class="btn small edge darkMblue"
                    value="현재탭 정보수정">
                    <input type="button" onclick="javascript:schoolAdd('<%=goTab%>');" class="btn small edge green"
                    value="현재탭 학교추가">
                  </div>
            		<%}%>
            	</div>

                    <form action="/program/transfer/admin/tra_sch_act.jsp?tabNo=<%=goTab %>" id="postForm" name="postForm" method="post">
                    <input type="hidden" name="actType" id="actType" value="modSch">
                    <table class="bbs_list">
                        <colgroup>
	                        <col style="width:20%;">
	                        <col style="width:7%;">
	                        <col style="width:7%;">
	                        <col style="width:8%;">
	                        <col style="width:8%;">
	                        <col style="width:8%;">
	                        <col style="width:8%;">
	                        <col style="width:8%;">
	                        <col style="width:18%;">
	                        <col style="width:8%;">
                        </colgroup>
                        <thead>
	                        <tr>
		                        <th scope="col" rowspan="2">학교명</th>
		                        <th scope="col" rowspan="2">구분</th>
		                        <th scope="col" rowspan="2">학년</th>
		                        <th scope="col" rowspan="2">정원(A)</th>
		                        <th scope="col" rowspan="2">현원(B)</th>
		                        <th scope="col" colspan="2">결원</th>
		                        <th scope="col" rowspan="2">대기자</th>
		                        <th scope="col" rowspan="2">제2외국어 과목</th>
		                        <th scope="col" rowspan="2">삭제</th>
	                        </tr>
	                        <tr>
	                        	<th scope="col">정원내<br/>(C=A-B)</th>
	                        	<th scope="col">정원외<br/>(A*5%+C)</th>
	                        </tr>
                        </thead>
                        <tbody>
                       	<%
		           		if(schoolList != null && schoolList.size() > 0){
		           			String dupCheckOrgNo 	= "";
		           			String rowspan 			= "";
		           			for(int i=0; i<schoolList.size(); i++){
		           				Map<String, Object> map	=	schoolList.get(i);
		           				orgNo	=   parseNull((String)map.get("ORGNO"));
		           				orgName	=   parseNull((String)map.get("ORGNAME"));
		           				gender	=   parseNull((String)map.get("SEX"));
		           				orgNumNo=   parseNull((String)map.get("ORGNUMNO"));
		           				rowspan	=   parseNull((String)map.get("ROWSPAN"));
                                schGrade=   parseNull((String)map.get("GRADE"));
                                fixNum  =   parseNull((String)map.get("FIXNUM"));
                                currNum =   parseNull((String)map.get("CURRNUM"));
                                shortInNum  =   parseNull((String)map.get("SHORTINNUM"));
                                shortOutNum =   parseNull((String)map.get("SHORTOUTNUM"));
                                waitNum =   parseNull((String)map.get("WAITNUM"));
                                fcode1  =   parseNull((String)map.get("FCODE"));
                                fcode2  =   parseNull((String)map.get("FCODE2"));
                                fcode3  =   parseNull((String)map.get("FCODE3"));

		           				if("F".equals(gender)){
		           					genderKor = "여";
		           				}else if("M".equals(gender)){
		           					genderKor = "남";
		           				}else{
		           					genderKor = "공학";
		           				}
		           				%>
                       			<tr>
                       				<%
                       				if(!dupCheckOrgNo.equals(orgNo)){
                       				%>
                       				<td rowspan="<%=rowspan%>"><a href="javascript:modifySchInfo(<%=orgNo %>);"><%=orgName%></a></td>
                       				<td rowspan="<%=rowspan%>"><%=genderKor%></td>
                       				<%
                       				}
                       				%>
			           				<td><input type="hidden" name="orgNumNo" id="orgNumNo" value="<%=orgNumNo %>"><%=schGrade %></td>
			           				<td><input type="text" name="fixNum" id="fixNum" value="<%=fixNum %>"></td>
			           				<td><input type="text" name="currNum" id="currNum" value="<%=currNum %>"></td>
			           				<td><%=shortInNum %></td>
			           				<td><%=Integer.parseInt(shortInNum) + Integer.parseInt(shortOutNum)%></td>
			           				<td><%=waitNum %></td>
			           				<td>
                                        <select name="fcode" id="fcode">
                                        <option value="-1">---선택---</option>
                                        <% for (int j=0; j<foreignList.size(); j++) {
                                            Map<String, Object> dataMap	=	foreignList.get(j);%>
                                            <option value='<%=parseNull((String)dataMap.get("FCODE")) %>'
                                            <%if (fcode1 != null && fcode1.length() > 0 && fcode1.equals(parseNull((String)dataMap.get("FCODE")))) {out.println("selected");}%>
                                            ><%=parseNull((String)dataMap.get("FNAME")) %></option>
                                        <%}%>
                                        </select><br>
                                        <select name="fcode2" id="fcode2">
                                        <option value="-1">---선택---</option>
                                        <% for (int k=0; k<foreignList.size(); k++) {
                                            Map<String, Object> dataMap2	=	foreignList.get(k);%>
                                            <option value='<%=parseNull((String)dataMap2.get("FCODE")) %>'
                                            <%if (fcode1 != null && fcode1.length() > 0 && fcode2.equals(parseNull((String)dataMap2.get("FCODE")))) {out.println("selected");}%>
                                            ><%=parseNull((String)dataMap2.get("FNAME")) %></option>
                                        <%}%>
                                        </select><br>
                                        <select name="fcode3" id="fcode3">
                                        <option value="-1">---선택---</option>
                                        <% for (int l=0; l<foreignList.size(); l++) {
                                            Map<String, Object> dataMap3	=	foreignList.get(l);%>
                                            <option value='<%=parseNull((String)dataMap3.get("FCODE")) %>'
                                            <%if (fcode1 != null && fcode1.length() > 0 && fcode3.equals(parseNull((String)dataMap3.get("FCODE")))) {out.println("selected");}%>
                                            ><%=parseNull((String)dataMap3.get("FNAME")) %></option>
                                        <%}%>
                                        </select>
                                    </td>
			           				<%
                       				if(!dupCheckOrgNo.equals(orgNo)){
                       					dupCheckOrgNo = orgNo;
                       				%>
			           				<td rowspan="<%=rowspan%>"><a href="javascript:delSch('<%=orgNo%>');" title="학교 삭제" class="btn small edge red">삭제</a></td>
                       				<%
                       				}
                       				%>
		           				</tr>
		           				<%
		           			}
		           		} else {
		           			%>
		           			<tr>
		           				<td colspan="10">목록이 존재하지 않습니다. </td>
		           			</tr>
		           			<%
		           		}
		               	%>
                        </tbody>
                    </table>
                    <div class="btn_area txt_c">
                      <input type="submit" class="btn medium edge darkMblue" title="적용" value="적용">
                    </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>
