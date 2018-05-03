<%
/**
*	PURPOSE	:	전입학 / 신규학교, 학교정보 수정
*	CREATE	:	20180125_thur	JI
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

String pageTitle        =   "신규학교 추가";
boolean newSchBool      =   false;

//get the parameter schNo
String schNo            =	parseNull(request.getParameter("schNo"), "");

String orgName          =   "";
String schKind          =   "";
String sex              =   "";
String schtype          =   "";
String porgNo           =   "";
String buildDate        =   "";
String homepage         =   "";
String zipCode          =   "";
String addr             =   "";
String tel              =   "";
String fax              =   "";

List<Map<String, Object>> porgList  =   null;
List<Map<String, Object>> orgList   =   null;
List<Map<String, Object>> nameList   =   null;

//modify school info edit
if (schNo != null && schNo.length() > 0) {
    pageTitle           =   "학교정보 수정";
    newSchBool          =   false;
//new create school
} else {
    pageTitle           =   "신규학교 추가";
    newSchBool          =   true;
}

try {
    sqlMapClient.startTransaction();
    conn    =   sqlMapClient.getCurrentConnection();

    //관할 리스트
    sql     =   new StringBuffer();
    sql_str =   "SELECT * FROM TPORG ORDER BY PORGNO";
    sql.append(sql_str);
    pstmt	=	conn.prepareStatement(sql.toString());
    rs      =   pstmt.executeQuery();
    porgList	=	getResultMapRows(rs);
    if (rs != null) try { rs.close(); } catch (SQLException se) {}
    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}

    if (!newSchBool && schNo != null && schNo.length() > 0) {
        sql     =   new StringBuffer();
        sql_str =   "SELECT TORG_INFO.* FROM TORG_INFO WHERE ORGNO = ?";
        sql.append(sql_str);
        pstmt   =   conn.prepareStatement(sql.toString());
        pstmt.setString(1, schNo);
        rs      =   pstmt.executeQuery();
        if (rs.next()) {
            orgName     =   parseNull(rs.getString("ORGNAME"));
            schKind     =   parseNull(rs.getString("SCHKIND"));
            sex         =   parseNull(rs.getString("SEX"));
            schtype     =   parseNull(rs.getString("SCHTYPE"));
            porgNo      =   parseNull(rs.getString("PORGNO"));
            buildDate   =   parseNull(rs.getString("BUILDDATE"));
            homepage    =   parseNull(rs.getString("HOMEPAGE"));
            zipCode     =   parseNull(rs.getString("ZIPCODE"));
            addr        =   parseNull(rs.getString("ADDR"));
            tel         =   parseNull(rs.getString("TEL"));
            fax         =   parseNull(rs.getString("FAX"));
        }

        //select from 이름 변경이력
        sql         =   new StringBuffer();
        sql_str     =   "SELECT * FROM TORG_NAME_HISTORY WHERE ORGNO = ? ORDER BY SDATE";
        sql.append(sql_str);
        pstmt       =   conn.prepareStatement(sql.toString());
        pstmt.setString(1, schNo);
        rs          =   pstmt.executeQuery();
        nameList    =   getResultMapRows(rs);
        if (rs != null) try { rs.close(); } catch (SQLException se) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}

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
		<title>RFC관리자 > 학교정보관리</title>
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
            //신규 학교
			function newSch () {
                var form    =   $("#modifyForm");
                $("#recType").val("new");

                form.submit();
            }
            //학교 정보 수정
            function modSch () {
                var form    =   $("#modifyForm");
                form.submit();
            }
            //학교 이력 추가
            function addSchName () {
                $("#nodata").css("display", "none");
                var appendData  =   "<tr class='isdata'><td><input type='hidden' name='nameHisNo' value='' /><input type='text' name='preName' value='' />                                          </td><td><input type='text' name='sDate' value='' /></td><td><input type='text' name='eDate' value='' /></td></tr>";

                var preName     =   $("input[name='preName']");
                var sDate       =   $("input[name='sDate']");
                var eDate       =   $("input[name='eDate']");
                var i   =   0;
                for (i = 0; i < preName.length; i++) {
                    if (preName.eq(i).val().trim().length < 1) {
                        alert("이전 학교명이 비었습니다.");
                        preName.eq(i).focus();
                        return;
                    }
                }
                $("#topdata").append(appendData);
            }

            function goPopup(inputType){
        		// 주소검색을 수행할 팝업 페이지를 호출합니다.
        		// 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(http://www.juso.go.kr/addrlink/addrLinkUrl.do)를 호출하게 됩니다.
        		var pop = window.open("/program/transfer/admin/jusoPopup.jsp?inputType=" + inputType,"pop","width=570,height=420, scrollbars=yes, resizable=yes");

        		// 모바일 웹인 경우, 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(http://www.juso.go.kr/addrlink/addrMobileLinkUrl.do)를 호출하게 됩니다.
        	    //var pop = window.open("/popup/jusoPopup.jsp","pop","scrollbars=yes, resizable=yes");
        	}

        	function jusoCallBack(roadFullAddr, zipNo, inputType){
        		var returnAddr	=	$("#addr");
        		var returnZip	=	$("#zipCode");

        		// 팝업페이지에서 주소입력한 정보를 받아서, 현 페이지에 정보를 등록합니다.
        		returnAddr.val(roadFullAddr);
        		returnZip.val(zipNo);
        	}

           /*  //본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
            function postCode(type) {
                var txt_addr	=	"";
                new daum.Postcode({
                    oncomplete: function(data) {
                        // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                        // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
                        // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                        var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
                        var extraRoadAddr = ''; // 도로명 조합형 주소 변수

                        // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                        // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                        if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                            extraRoadAddr += data.bname;
                        }
                        // 건물명이 있고, 공동주택일 경우 추가한다.
                        if(data.buildingName !== '' && data.apartment === 'Y'){
                           extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                        }
                        // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                        if(extraRoadAddr !== ''){
                            extraRoadAddr = ' (' + extraRoadAddr + ')';
                        }
                        // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
                        if(fullRoadAddr !== ''){
                            fullRoadAddr += extraRoadAddr;
                        }

                        // 우편번호와 주소 정보를 해당 필드에 넣는다.
                        document.getElementById(type + "zipcode").value = data.zonecode; //5자리 새우편번호 사용
                        document.getElementById(type + "addr").value = fullRoadAddr;

                    }
                }).open();

            } */

            function delSch(){
            	var form	=	$("#modifyForm");
            	if(confirm("정말 삭제하시겠습니까?")==true){
            		$("#recType").val("del");
                	form.submit();
            	}else{
            		return;
            	}
            }

            $(function () {
                $(".schKind").click(function () {
                    var schKindVal  =   $(this).val();
                    if (schKindVal == 'STH') {
                        $('.highSch').show();
                    } else {
                        $('.highSch').hide();
                    }
                });
            });

		</script>
	</head>

    <body>
		<div id="right_view">
			<div class="top_view">
				<p class="location"><strong><%=pageTitle %></strong></p>
			</div>
            <div id="content">
                <div class="searchBox">
                    <form id="modifyForm" name="modifyForm" method="post" action="/program/transfer/admin/tra_sch_act.jsp">
                    	<input type="hidden" name="recType" id="recType" value="mod" />
                        <input type="hidden" name="schNo" id="schNo" value="<%=schNo %>" />
                        <table class="bbs_list2">
                        	<caption><%=pageTitle %> 페이지입니다.</caption>
                        	<colgroup>
                        		<col style="width:20%;"/>
                        		<col style="width:80%;"/>
                        	</colgroup>
                        	<thead>
                        		<tr>
                        			<th scope="col" colspan="2"><%=pageTitle %> 페이지</th>
                        		</tr>
                        	</thead>
                        	<tbody>
                        		<tr>
                        			<th scope="col"><label for="orgName">학교명</label></th>
                        			<td>
                                        <%if(schNo != null && schNo.length() > 0) {%>
                                        <input type="text" name="orgName" id="orgName" value="<%=orgName %>" required /><br>
                                        <%} else {%>
                                        <input type="text" name="orgName" id="orgName" value="" required />
                                        <%}%>
                                        <br><span>* 학교명은 25자 내외로 입력해주세요.</span>
                        			</td>
                        		</tr>
                        		<tr>
                        			<th scope="col"><label for="schKind">급별 구분</label></th>
                        			<td>
                        				<label><input type="radio" name="schKind" class="schKind" value="STE" <%if("STE".equals(schKind)){out.println("checked=checked");}%> required> 초등학교</label>&nbsp;&nbsp;
                        				<label><input type="radio" name="schKind" class="schKind" value="STM" <%if("STM".equals(schKind)){out.println("checked=checked");}%> required> 중학교</label>&nbsp;&nbsp;
                        				<label><input type="radio" name="schKind" class="schKind" value="STH" <%if("STH".equals(schKind)){out.println("checked=checked");}%> required> 고등학교</label>&nbsp;&nbsp;
                        				<label><input type="radio" name="schKind" class="schKind" value="STS" <%if("STS".equals(schKind)){out.println("checked=checked");}%> required> 특수학교</label>
                        			</td>
                        		</tr>
                                <%if ("STH".equals(schKind)) {%>
                                <tr class="highSch">
                        			<th scope="col"><label for="sex">남녀별 구분</label></th>
                        			<td>
                        				<label><input type="radio" name="sex" value="M" <%if("M".equals(sex)){out.println("checked=checked");}%>> 남자</label>&nbsp;&nbsp;
                        				<label><input type="radio" name="sex" value="F" <%if("F".equals(sex)){out.println("checked=checked");}%>> 여자</label>&nbsp;&nbsp;
                        				<label><input type="radio" name="sex" value="C" <%if("C".equals(sex)){out.println("checked=checked");}%>> 공학</label>
                        			</td>
                        		</tr>
                                <tr class="highSch">
                        			<th scope="col"><label for="schtype">적용 지역별 구분</label></th>
                        			<td>
                        				<label><input type="radio" name="schtype" value="APPSCH" <%if("APPSCH".equals(schtype)){out.println("checked=checked");}%>> 적용</label>&nbsp;&nbsp;
                        				<label><input type="radio" name="schtype" value="NAPPSCH" <%if("NAPPSCH".equals(schtype)){out.println("checked=checked");}%>> 비적용</label>&nbsp;&nbsp;
                        				<label><input type="radio" name="schtype" value="TECHSCH" <%if("TECHSCH".equals(schtype)){out.println("checked=checked");}%>> 전문계</label>&nbsp;&nbsp;
                        				<label><input type="radio" name="schtype" value="LIFESCH" <%if("LIFESCH".equals(schtype)){out.println("checked=checked");}%>> 평생교육</label>
                        			</td>
                        		</tr>
                                <%} else {%>
                                <tr class="highSch" style="display:none;">
                        			<th scope="col"><label for="sex">남녀별 구분</label></th>
                        			<td>
                        				<label><input type="radio" name="sex" value="M"> 남자</label>&nbsp;&nbsp;
                        				<label><input type="radio" name="sex" value="F"> 여자</label>&nbsp;&nbsp;
                        				<label><input type="radio" name="sex" value="C"> 공학</label>
                        			</td>
                        		</tr>
                                <tr class="highSch" style="display:none;">
                        			<th scope="col"><label for="schtype">적용 지역별 구분</label></th>
                        			<td>
                        				<label><input type="radio" name="schtype" value="APPSCH" > 적용</label>&nbsp;&nbsp;
                        				<label><input type="radio" name="schtype" value="NAPPSCH" > 비적용</label>&nbsp;&nbsp;
                        				<label><input type="radio" name="schtype" value="TECHSCH" > 전문계</label>&nbsp;&nbsp;
                        				<label><input type="radio" name="schtype" value="LIFESCH" > 평생교육</label>
                        			</td>
                        		</tr>
                                <%}%>
                        		<tr>
                        			<th scope="col"><label for="porgNo">관할기관</label></th>
                        			<td>
                                        <select name="porgNo" id="porgNo" required>
                                        <%
                                        for (int i = 0; i < porgList.size(); i++) {
                                            Map<String, Object> dataMap	=	porgList.get(i);
                                            if (parseNull((String)dataMap.get("PORGNO")).equals(porgNo)) {
                                                out.println("<option value='"+ parseNull((String)dataMap.get("PORGNO")) +"' selected='selected' >"+ parseNull((String)dataMap.get("PORG_NM")) +"</option>");
                                            } else {
                                                out.println("<option value='"+ parseNull((String)dataMap.get("PORGNO")) +"'>"+ parseNull((String)dataMap.get("PORG_NM")) +"</option>");
                                            }
                                        }
                                        %>
                                        </select>
                        			</td>
                        		</tr>
                        		<tr>
                        			<th scope="col"><label for="buildDate">설립일자</label></th>
                        			<td>
                                        <input type="text" name="buildDate" id="buildDate" value="<%=buildDate %>" />
                        			</td>
                        		</tr>
                                <tr>
                        			<th scope="col"><label for="homepage">홈페이지</label></th>
                        			<td>
                                        <input type="text" name="homepage" id="homepage" value="<%=homepage %>" />
                        			</td>
                        		</tr>
                                <tr>
                                    <th scope="col"><label for="zipCode">주소</label></th>
                                    <td>
                                        <input type="text" id="zipCode" name="zipCode" value="<%=zipCode %>" required>
                                        <span><input type="button" value="우편번호검색" onclick="javascript:goPopup();" class="btn small edge mako"></span>
                                        <br><input type="text" id="addr" name="addr" value="<%=addr %>" class="wps_90" required>
                                    </td>
                                </tr>
                                <tr>
                        			<th scope="col"><label for="tel">전화</label></th>
                        			<td>
                                        <input type="text" name="tel" id="tel" value="<%=tel %>" />
                        			</td>
                        		</tr>
                                <tr>
                        			<th scope="col"><label for="fax">팩스</label></th>
                        			<td>
                                        <input type="text" name="fax" id="fax" value="<%=fax %>" />
                        			</td>
                        		</tr>
                                <%if (!newSchBool) {%>
                                <tr>
                        			<th scope="col"><label for="fax">변경이력</label></th>
                        			<td>
                                        <div class="infoCaption">
                                            <ul class="list_num" align="left">
                                                <li><i>1</i><strong>학교명 변경이력을 관리하기 위한 부분입니다.</strong></li>
                                                <li><i>2</i>정보 추가 버튼을 클릭하시면 변경이력 정보를 추가적으로 입력할 수 있습니다.</li>
                                                <li><i>3</i>변경이력 순서는 자동으로 시작일을 기준으로 정렬이 됩니다.</li>
                                                <li><i>4</i>시작일과 종료일은 정확한 형식으로 입력 바랍니다. 예)20180101</li>
                                                <li><i>5</i>잘못된 입력 시 민원화면에서 올바른 날짜 정보가 보이지 않게 됩니다.</li>
                                            </ul>
                                        </div>
                                        <div class="school_changeName_his" align="left">
                                            <%if (nameList !=null && nameList.size() > 0) {
                                                for (int i = 0; i < nameList.size(); i++) {
                                                    Map<String, Object> hisMap = nameList.get(i);
                                                    out.println(parseNull((String)hisMap.get("PRENAME")) + " ▶ ");
                                                }
                                                out.println(orgName + "(현재)");
                                            }%>
                                        </div>
                                        <div>
                                            <table class="bbs_list" id="topdata">
                                                <tr>
                                                    <th>이전 학교명</th>
                                                    <th>시작일</th>
                                                    <th>종료일</th>
                                                </tr>
                                                <%if (nameList !=null && nameList.size() > 0) {
                                                    for (int i = 0; i < nameList.size(); i++) {
                                                        Map<String, Object> nameMap	=	nameList.get(i);
                                                        String nameHisNo    =   parseNull((String)nameMap.get("NAMEHISNO"));
                                                        String preName      =   parseNull((String)nameMap.get("PRENAME"));
                                                        String sDate        =   parseNull((String)nameMap.get("SDATE"));
                                                        String eDate        =   parseNull((String)nameMap.get("EDATE"));
                                                %>
                                                <tr class="isdata">
                                                    <td>
                                                        <input type="hidden" name="nameHisNo" value="<%=nameHisNo %>" />
                                                        <input type="text" name="preName" value="<%=preName %>" />
                                                    </td>
                                                    <td><input type="text" name="sDate" value="<%=sDate %>" /></td>
                                                    <td><input type="text" name="eDate" value="<%=eDate %>" /></td>
                                                </tr>
                                                <%  }   //end for
                                                } else {%>
                                                <tr id="nodata">
                                                    <td colspan="3">변경이력이 존재하지 않습니다.</td>
                                                </tr>
                                                <%}%>
                                            </table>
                                            <a href="javascript:addSchName();" class="btn edge small mako">+ 변경 이력 추가</a>&nbsp;
                                        </div>
                        			</td>
                        		</tr>
                                <%}%>
                        	</tbody>
                        </table>
                        <div>
                        </div>
                        <div style="text-align:center;">
                            <% if (newSchBool) { %>
	                        <a href="javascript:newSch ();" class="btn edge small darkMblue">추가</a>&nbsp;
                            <%} else {%>
	                        <a href="javascript:modSch ();" class="btn edge small darkMblue">수정</a>&nbsp;
	                        <a href="javascript:delSch();" class="btn edge small red">삭제</a>&nbsp;
                            <%}%>
	                        <a href="javascript:window.close();" class="btn edge small mako">닫기</a>
						</div>
                    </form>
                </div>
	        </div>
        </div>
    </body>
</html>
