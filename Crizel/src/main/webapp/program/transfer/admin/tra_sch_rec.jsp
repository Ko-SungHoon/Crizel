<%
/**
*	PURPOSE	:	전입학 / 신규 학교 등록, 학교 정보 수정 jsp
*	CREATE	:	20180126_fri	JI
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

int chkResult   =   0;
int result 		= 	0;

String sql_str	=	"";
String outHtml  =   "";
String resultMsg= 	"";

String recType	=   parseNull(request.getParameter("recType"));		//액션 타입
//학교 정보
String schNo        =   parseNull(request.getParameter("schNo"));
String orgName      =   parseNull(request.getParameter("orgName"));
String schKind      =   parseNull(request.getParameter("schKind"));
String sex          =   parseNull(request.getParameter("sex"));
String schType      =   parseNull(request.getParameter("schtype"));
String porgNo       =   parseNull(request.getParameter("porgNo"));
String buildDate    =   parseNull(request.getParameter("buildDate"));
String homepage     =   parseNull(request.getParameter("homepage"));
String zipCode      =   parseNull(request.getParameter("zipCode"));
String addr         =   parseNull(request.getParameter("addr"));
String tel          =   parseNull(request.getParameter("tel"));
String fax          =   parseNull(request.getParameter("fax"));

//학교 이름 변경 내역
String[] nameHisNo  =   request.getParameterValues("nameHisNo");
String[] preName    =   request.getParameterValues("preName");
String[] sDate      =   request.getParameterValues("sDate");
String[] eDate      =   request.getParameterValues("eDate");

boolean adminChk	=	sessionManager.isRoleAdmin();

/* if(!adminChk){
 */	%>
<!-- 	<script>alert('관리자권한이 없습니다. \n다시 로그인해주세요.'); location.href='/iam/main/index.sko';</script>
 --><%/* } */

//학교 정보 수정
if (recType.equals("mod")) {
    
    out.println(schNo+ "<br>");
    out.println(orgName+ "<br>");
    out.println(schKind+ "<br>");
    out.println(sex+ "<br>");
    out.println(schType+ "<br>");
    out.println(porgNo+ "<br>");
    out.println(buildDate+ "<br>");
    out.println(homepage+ "<br>");
    out.println(zipCode+ "<br>");
    out.println(addr+ "<br>");
    out.println(tel+ "<br>");
    out.println(fax+ "<br>");
    
    try {
        sqlMapClient.startTransaction();
		conn    =   sqlMapClient.getCurrentConnection();

        //관할 리스트
        sql     =   new StringBuffer();
        sql_str =   " UPDATE TORG_INFO SET ";
        sql_str +=  " ORGNAME = ? ";
        sql_str +=  " WHERE ORGNO = ? ";
        
        sql.append(sql_str);
        pstmt	=	conn.prepareStatement(sql.toString());
        pstmt.setString(1, orgName);
        pstmt.setString(2, schNo);
        result  =   pstmt.executeUpdate();

        /*if (preName.length > 0) {
            for (int i = 0; i < preName.length; i++) {
                out.println("<script>");
                out.println("console.log('시작')");
                out.println("console.log("+ nameHisNo +")");
                out.println("console.log("+ preName +")");
                out.println("console.log('끝')");
                out.println("</script>");
            }
        }*/

    } catch (Exception e) {
        e.printStackTrace();
        alertBack(out, "처리중 오류가 발생하였습니다."+e.getMessage());
    } finally {

        if (rs != null) try { rs.close(); } catch (SQLException se) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
        if (conn != null) try { conn.close(); } catch (SQLException se) {}
        sqlMapClient.endTransaction();

        if (result > 0) {
            outHtml =   "<script>";
            outHtml =   "alert('정보 수정이 완료되었습니다.');";
            outHtml =   "location.href='/program/transfer/admin/tra_sch_pop.jsp?schNo='"+ schNo +"'";
            outHtml =   "</script>";
        } else {
            outHtml =   "<script>";
            outHtml =   "alert('처리 중 오류가 발생하였습니다.');";
            outHtml =   "history.back();";
            outHtml =   "</script>";
        }
    }
    
//신규 학교 등록
} else {
    
    //torg_info insert
    
    //torg_person
    
    //torg_name_history
    
    
}


%>