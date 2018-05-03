<%@page import="javax.print.attribute.ResolutionSyntax"%>
<%
/**
*	PURPOSE	:	전입학 / 전입학 배정원서 목록 / 보기 페이지
*	CREATE	:	20180122_mon	JMG
*	MODIFY	:	....
*/

%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@ include file="/program/class/UtilClass.jsp"%>

<%!
public static String strToDate(String date, String type){
	String str = "";
	if(type.equals("yyyy년MM월dd일")){
		if(date.length() == 8){
			str	=	date.substring(0, 4) + "년 " + date.substring(4, 6) + "월 " + date.substring(6, 8) + "일" ;
		}
	}else if(type.equals("yyyy/MM/dd")){
		if(date.length() == 8){
			str	=	date.substring(0, 4) + "/" + date.substring(4, 6) + "/" + date.substring(6, 8);
		}
	}
	return str;
}

public static String returnGubun(String str){
	String returnStr	=	"";

	if("SH_NORMAL".equals(str)){
		returnStr	=	"종합고등학교 보통과";
	}else if("SH_SPE_PURPOSE".equals(str)){
		returnStr	=	"특수목적 고등학교";
	}else if("SH_SELF_PUBLIC".equals(str)){
		returnStr	=	"자율형 공립 고등학교";
	}else if("SH_VOCATIONAL".equals(str)){
		returnStr	=	"종합고등학교 실업과";
	}else if("SH_SPECIAL".equals(str)){
		returnStr	=	"특성화 고등학교";
	}else if("NH_NIGHT".equals(str)){
		returnStr	=	"일반계고등학교 야간부";
	}else if("SH_SELF_PRIVATE".equals(str)){
		returnStr	=	"자율형 사립 고등학교";
	}else if("NH_DAY".equals(str)){
		returnStr	=	"일반계고등학교 주간부";
	}else{
		returnStr	=	str;
	}

	return returnStr;
}

public static String cancelType(String stateCd){
	String returnStr	=	"";
	String[] strArr		=	null;
	String str			=	"";

	if(stateCd.indexOf("CANCEL") > -1){
		strArr				=	stateCd.split("_");

		if(strArr != null && strArr.length > 1){
			str		=	strArr[0];
			if("MW".equals(str)){
				returnStr	=	"신청자 ";
			}else if("TR".equals(str)){
				returnStr	=	"도교육청 담당자 ";
			}else if("SCH".equals(str)){
				returnStr	=	"재적 학교 담당자 ";
			}else if("SYS".equals(str)){
				returnStr	=	"시스템 ";
			}else{
				returnStr	=	stateCd;
			}
		}
	}
	return returnStr;
}
%>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");
SessionManager sessionManager = new SessionManager(request);

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
StringBuffer sql = null;

String outHtml  	=   "";

boolean adminChk	=	sessionManager.isRoleAdmin();

/* if(!adminChk){
 */	%>
	<!-- <script>alert('관리자권한이 없습니다. \n다시 로그인해주세요.'); location.href='/iam/main/index.sko';</script> -->
<%/* } */

//파라미터
String transferNo		=	parseNull(request.getParameter("transferNo"));
String categorySearch	=	parseNull(request.getParameter("categorySearch"));
String typeSearch		=	parseNull(request.getParameter("typeSearch"));
String typeSearchDetail	=	parseNull(request.getParameter("typeSearchDetail"));
String stNameParam		=	parseNull(request.getParameter("stName"));
String stGradeParam		=	parseNull(request.getParameter("stGrade"));
String stClassParam		=	parseNull(request.getParameter("stClass"));
String listSize			=	parseNull(request.getParameter("listSize"));
String pageNo			=	parseNull(request.getParameter("pageNo"));

//취소 사유
String reason			=	"";
String stateCd			=	"";
String canceler			=	"";

//특이사항
String special			=	"";

//지원자(학생) 정보
String schName			=	"";
String stName			=	"";
String gender			=	"";
String fName			=	"";
String midSchName		=	"";
String midSchClass		=	"";
String fUseYn			=	"";
String fUseYnStr		=	"";

//보호자 인적사항
String ptTel			=	"";
String ptHp				=	"";
String infoSearchYn		=	"";
String ptName			=	"";
String preAddr			=	"";
String currAddr			=	"";
String preZipCode		=	"";
String currZipCode		=	"";

//학적정보
String stSdate			=	"";
String stEdate			=	"";
String gubun			=	"";
String stGrade			=	"";
String stClass			=	"";
String schTel			=	"";
String schFax			=	"";

//도교육청 담당자
String mgName			=	"";
String mgPosition		=	"";
String mgDuty			=	"";
String mgTel			=	"";
String receiptYear		=	"";
String receiptNum		=	"";

//배정학교
String trSchName	=	"";
String trSchNo		=	"";
String[] hopeSch	=	new String[3];

List<Map<String, Object>> hopeList	=	null;

if(!"".equals(transferNo)){
	try {
	    sqlMapClient.startTransaction();
	    conn    =   sqlMapClient.getCurrentConnection();

	    sql     	=   new StringBuffer();

	    //희망학교
	    sql.append(" SELECT ORGNO, SCHNAME FROM TTRANS_HOPESCH WHERE TRANSFERNO = ? ORDER BY ORDERED ");
	    pstmt		=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, transferNo);
	    sql			=	new StringBuffer();
	    rs			=	pstmt.executeQuery();
	    hopeList	=	getResultMapRows(rs);

	    if (rs != null) try { rs.close(); } catch (SQLException se) {}
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}

	    sql     	=   new StringBuffer();

	    //배정원서 정보
	    sql.append(" SELECT A.KIND, A.SCHNAME, A.STNAME, A.STGRADE, A.RECEIPTYEAR, A.RECEIPTNUM, 					");
	    sql.append(" A.STCLASS, A.APPLYDATE, A.APPLYTIME, B.STATECD, A.TRANSFERNO, A.STSEX, B.REASON, 				");
	    sql.append(" A.FCODE, A.FNAME, A.MIDSCHNAME, A.MIDSCH3CLASS, A.PTNAME, A.PREADDR, A.CURRADDR, 				");
	    sql.append(" A.PREZIPCODE, A.CURRZIPCODE, A.TRSCHNAME, A.TRSCHNO, A.PTTEL, A.PTHP, A.STSDATE, A.STEDATE, 	");
	    sql.append(" A.MGNAME, A.MGPOSITION, A.MGDUTY, A.MGTEL, A.GUBUN, A.SCHTEL, A.SCHFAX, A.INFOSEARCHYN, 		");
		sql.append(" A.SPECIAL, C.CODE, C.CODENAME, A.FUSEYN, B.NAME ");
	    sql.append(" FROM TTRANSFER A, TTRANS_STATE B, TCODE C WHERE 1=1 AND C.PCODE = 'SPECIALDT' AND A.SPECIAL = C.CODE ");
	    sql.append(" AND A.TRANSFERNO = B.TRANSFERNO AND B.ORDERED = 1 AND A.TRANSFERNO = ? ");
	    pstmt		=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, transferNo);

	    rs			=	pstmt.executeQuery();
	   	if(rs.next()){
	   		schName			=	rs.getString("SCHNAME");
	   		stName			=	rs.getString("STNAME");
	   		gender			=	rs.getString("STSEX");
	   		reason			=	rs.getString("REASON");
	   		fName			=	rs.getString("FNAME");
	   		midSchName		=	rs.getString("MIDSCHNAME");
	   		midSchClass		=	rs.getString("MIDSCH3CLASS");
	   		ptName			=	rs.getString("PTNAME");
	   		preAddr			=	rs.getString("PREADDR");
	   		currAddr		=	rs.getString("CURRADDR");
	   		preZipCode		=	rs.getString("PREZIPCODE");
	   		currZipCode		=	rs.getString("CURRZIPCODE");
	   		receiptYear		=	rs.getString("RECEIPTYEAR");
	   		receiptNum		=	rs.getString("RECEIPTNUM");
	   		ptTel			=	rs.getString("PTTEL");
	   		ptHp			=	rs.getString("PTHP");
	   		trSchName		=	rs.getString("TRSCHNAME");
	   		infoSearchYn	=	rs.getString("INFOSEARCHYN");
	   		stSdate			= 	rs.getString("STSDATE");
	   		stEdate			=	rs.getString("STEDATE");
	   		mgName			=	rs.getString("MGNAME");
	   		mgPosition		=	rs.getString("MGPOSITION");
	   		mgDuty			=	rs.getString("MGDUTY");
	   		mgTel			=	rs.getString("MGTEL");
	   		gubun			=	rs.getString("GUBUN");
	   		stGrade			=	rs.getString("STGRADE");
	   		stClass			=	rs.getString("STCLASS");
	   		schTel			=	rs.getString("SCHTEL");
	   		schFax			=	rs.getString("SCHFAX");
	   		special			=	rs.getString("CODENAME");
	   		fUseYn			=	rs.getString("FUSEYN");
	   		stateCd			=	rs.getString("STATECD");
	   		canceler		=	rs.getString("NAME");
	   		trSchNo			=	rs.getString("TRSCHNO");
	   	}
	   	if(!"".equals(parseNull(receiptNum))){
		   	int lengthCnt	=	receiptNum.length();
			if(lengthCnt < 4){
				for(int j=0; j<(4-lengthCnt); j++){
					receiptNum = "0" + receiptNum;
				}
			}
	   	}

	   	if(!"".equals(parseNull(fUseYn))){
	   		if("Y".equals(fUseYn))	fUseYnStr	=	"제2외국어를 고려하여 배정희망.";
	   		else 					fUseYnStr	=	"제2외국어와 관계없이 배정희망.";
	   	}

	} catch (Exception e) {
	    e.printStackTrace();
	    alertBack(out, "처리중 오류가 발생하였습니다."+e.getMessage());
	} finally {
	    if (rs != null) try { rs.close(); } catch (SQLException se) {}
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	    if (conn != null) try { conn.close(); } catch (SQLException se) {}
	    sqlMapClient.endTransaction();
	}
}else{
	out.println("<script>");
    out.println("alert('파라미터 값 이상입니다. 관리자에게 문의하세요.');");
    out.println("window.close();");
    out.println("</script>");
}
%>


<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>RFC관리자 > 전입학 배정원서 목록 > 배정원서 보기</title>
		<script type='text/javascript' src='/js/egovframework/rfc3/iam/common.js'></script>
		<script type='text/javascript' src='/js/jquery.js'></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/jquery-ui.min.js"></script>
		<script type="text/javascript" src="/program/excel/common/js/common.js"></script>
		<link href="/css/egovframework/rfc3/iam/admin_common.css" rel="stylesheet" type="text/css" />
		<link type="text/css" rel="stylesheet" href="/program/excel/common/css/jquery-ui.css" />
		<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
	</head>
	<script>
		//문자수 체크
		$(function(){
			 $('#reason').keyup(function (e){
		          var content = $(this).val();
		          $(this).height(((content.split('\n').length + 1) * 1.5) + 'em');
		          $('#counter').html(content.length + '/100');
		      });
		      $('#reason').keyup();
		});

		function goList(){
			document.postForm.action="/program/transfer/admin/tra_req_list.jsp";
			document.postForm.submit();
		}

		function goCancel(){
			$("#cancel_window").css("display","");
		}

		function closeCancel(){
			$("#cancel_window").css("display","none");
		}

		function goPrint(){
			var moveUrl	=	"/program/transfer/admin/tra_req_print.jsp";
			window.open(moveUrl, "인쇄페이지", "width=800px, height=1000px, toolbar=no, menubar=no, scrollbars=no")
		}

		function cancelAct(){
			if(document.cancelForm.cancelType.value == ""){
				alert("취소 상태를 선택해주세요.");
				document.cancelForm.cancelType.focus();
				return false;
			}

			if(document.cancelForm.reason.value.trim() == ""){
				alert("취소 사유를 입력해주세요.");
				document.cancelForm.reason.focus();
				return false;
			}

			if(document.cancelForm.reason.value.length > 100){
				alert("취소 사유는 100글자를 초과할 수 없습니다.");
				document.cancelForm.reason.focus();
				return false;
			}

			if(confirm("정말 취소처리 하시겠습니까?") == true){
				return true;
			}else{
				return false;
			}
		}
	</script>
    <body>
		<div id="right_view">
			<div class="top_view">
				<p class="location"><strong>배정원서 보기</strong></p>
			</div>
            <div id="content">
							<div class="btn_area">
								<input type="button" class="btn small edge mako " value="목록" onclick="javascript:goList();">
		            <%if(stateCd.indexOf("CANCEL") < 0){%>
		            <input type="button" class="btn small edge white" value="취소처리" onclick="javascript:goCancel();">
		            <%} %>
		            <input type="button" class="btn small edge green" value="배정원서 출력" onclick="javscript:goPrint();">
							</div>
            <div id="cancel_window" style="display:none;">
	            <form name="cancelForm" id="cancelForm" method="post" onsubmit="return cancelAct();"
	            action="/program/transfer/admin/tra_req_act.jsp?actType=cancel">
	            	<input type="hidden" name="transferNo" value="<%=transferNo%>">
	            	<input type="hidden" name="trSchNo" value="<%=trSchNo %>">
	            	<input type="hidden" name="stGrade" value="<%=stGrade%>">
	            	<input type="hidden" name="stateCd" value="<%=stateCd %>">
	            	<label for="cancelType">취소 상태</label> :
	            	<select name="cancelType" id="cancelType" title="취소상태를 선택해주세요.">
	            		<option value="">- 취소 상태 -</option>
	            		<option value="MW_CANCEL">신청자에 의한 취소</option>
	            		<option value="TR_CANCEL">도교육청 담당자에 의한 취소</option>
	            		<option value="SCH_CANCEL">재적 학교 담당자에 의한 취소</option>
	            		<option value="SYS_CANCEL">시스템에 의한 취소</option>
	            	</select>
	            	<textarea rows="3" cols="50" name="reason" id="reason"></textarea><span id="counter"></span>
	            	<input type="submit" value="완료">
	            	<input type="button" value="취소" onclick="javascript:closeCancel();">
	            </form>
            </div>
                <div class="listArea" style="width:80%;">
               		<form id="postForm" name="postForm" method="post">
	               		<input type="hidden" name="stName" value="<%=stNameParam%>">
	               		<input type="hidden" name="stGrade" value="<%=stGradeParam%>">
	               		<input type="hidden" name="stClass" value="<%=stClassParam%>">
	               		<input type="hidden" name="listSize" value="<%=listSize%>">
	               		<input type="hidden" name="typeSearch" value="<%=typeSearch%>">
	               		<input type="hidden" name="typeSearchDetail" value="<%=typeSearchDetail%>">
	               		<input type="hidden" name="categorySearch" value="<%=categorySearch%>">
	               		<input type="hidden" name="pageNo" value="<%=pageNo %>">
	                    <table class="bbs_list">
	                    	<caption>배정원서입니다.</caption>
	                        <colgroup>
		                        <col style="width:20%;">
		                        <col style="width:30%;">
		                        <col style="width:20%;">
		                        <col style="width:30%;">
		                        <col>
	                        </colgroup>
	                        <thead>
		                        <tr>
			                        <th scope="col"	colspan="4">작성된 배정원서</th>
	                     	   </tr>
	                        </thead>
	                        <tbody>
	                        	<%if(parseNull(stateCd).indexOf("CANCEL") > -1){%>
	                        	<tr>
	                        		<th scope="row" colspan="4">취소이유</th>
	                        	</tr>
	                        	<tr>
	                        		<td colspan="4">
	                        		<%=cancelType(parseNull(stateCd))%><%=parseNull(canceler)%>님에 의해 아래와 같은 이유로 취소되었습니다.
	                        		<br/><%=parseNull(reason) %>
	                        		</td>
	                        	</tr>
	                        	<%} %>
	                        	<tr>
	                        		<th scope="row" colspan="4">특이사항</th>
	                        	</tr>
	                   			<tr>
	                   				<th scope="row">특이사항</th>
	                   				<td colspan="3"><%=parseNull(special) %></td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row" colspan="4">지원자(학생) 정보</th>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">현재 재학교</th>
	                   				<td colspan="3"><%=schName%></td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">학생 이름</th>
	                   				<td><%=stName%></td>
	                   				<th scope="row">주민등록번호</th>
	                   				<td></td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">성 별</th>
	                   				<td><%if("F".equals(gender)){%>여<%}else if("M".equals(gender)){%>남<%}%></td>
	                   				<th scope="row" rowspan="3">희망학교</th>
	                   				<td rowspan="3">
	                   				<%
	                   					if(hopeList != null && hopeList.size() > 0){
	                   						for(int i=0; i<hopeList.size(); i++){
	                   							Map<String, Object> map = hopeList.get(i);
	                   							hopeSch[i] = (String)map.get("SCHNAME");
	                   							%>
	                   							선택 <%=i+1%> : <%=hopeSch[i].toString()%><br/>
	                   							<%
	                   						}
	                   					}
	                   				%>
	                   				</td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">제2외국어</th>
	                   				<td><%=parseNull(fName)%></td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">제2외국어 반영유무</th>
	                   				<td><%=parseNull(fUseYnStr)%></td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">졸업 중학교 정보</th>
	                   				<td colspan="3"><%=parseNull(midSchName)%>중학교 (3학년 <%=parseNull(midSchClass)%>반)</td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row" colspan="4">보호자 인적사항</th>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">성 명</th>
	                   				<td><%=parseNull(ptName)%></td>
	                   				<th scope="row">주민등록번호</th>
	                   				<td></td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">전주소</th>
	                   				<td colspan="3">(<%=parseNull(preZipCode)%>) <%=parseNull(preAddr)%></td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">현주소</th>
	                   				<td colspan="3">(<%=parseNull(currZipCode)%>) <%=parseNull(currAddr)%></td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">연락처</th>
	                   				<td colspan="3"><%=parseNull(ptTel)%></td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">휴대폰</th>
	                   				<td colspan="3"><%=parseNull(ptHp)%></td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">동의유무</th>
	                   				<td colspan="3">
	                   				<%
	                   				if("Y".equals(parseNull(infoSearchYn))){
	                   			   		%>
	                   			   		행정정보 공동이용망을 통한 담당공무원의 정보 확인에 동의 하였습니다.
	                   			   		<%
	                   			   	}
	                   				%>
	                   				</td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row" colspan="4">학적정보</th>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">입학일자</th>
	                   				<td><%=strToDate(parseNull(stSdate), "yyyy년MM월dd일") %></td>
	                   				<th scope="row">최종재학일자</th>
	                   				<td><%=strToDate(parseNull(stEdate), "yyyy년MM월dd일") %></td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">재학구분</th>
	                   				<td colspan="3"><%=returnGubun(parseNull(gubun))%></td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">학년/반</th>
	                   				<td colspan="3"><%=parseNull(stGrade)%>학년 <%=parseNull(stClass)%>반</td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">학교연락처</th>
	                   				<td><%=parseNull(schTel) %></td>
	                   				<th scope="row">학교FAX</th>
	                   				<td><%=parseNull(schFax) %></td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row" colspan="4">도교육청 담당자</th>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">처리자 이름</th>
	                   				<td><%=parseNull(mgName) %></td>
	                   				<th scope="row">처리자 전화번호</th>
	                   				<td><%=parseNull(mgTel) %></td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">처리자 소속</th>
	                   				<td><%=parseNull(mgPosition)%></td>
	                   				<th scope="row">처리자 직위</th>
	                   				<td><%=parseNull(mgDuty)%></td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">접수번호</th>
	                   				<td colspan="3"><%=parseNull(receiptYear)+parseNull(receiptNum)%></td>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row" colspan="4">배정 된 학교정보</th>
	                   			</tr>
	                   			<tr>
	                   				<th scope="row">배정학교 이름</th>
	                   				<td colspan="3"><%=parseNull(trSchName) %></td>
	                   			</tr>
	                        </tbody>
	                        <tfoot>
	                        	<tr>
	                        		<th colspan="4">경상남도 교육감 귀하</th>
	                        	</tr>
	                        </tfoot>
	                    </table>
                    </form>
                </div>
            </div>

        </div>
    </body>
</html>
