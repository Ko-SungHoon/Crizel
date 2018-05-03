<%
/**
*	PURPOSE	:	전입학 / 정현원 및 학교관리 action jsp
*	CREATE	:	20180123_mon	JMG
*	MODIFY	:	....
*/
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp" %>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>

<%!
public static double shortNum(double fixNum, double currNum, int type){
	double returnVal	=	0;
	if(type == 1){
		returnVal	=	fixNum - currNum;
	}else{
		returnVal	=	((fixNum * 5)/100)+(fixNum - currNum);
	}
return returnVal;
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

int chkResult   =   0;
int result 		= 	0;

String outHtml  =   "";

boolean adminChk	=	sessionManager.isRoleAdmin();

/* if(!adminChk){
 */	%>
	<!-- <script>alert('관리자권한이 없습니다. \n다시 로그인해주세요.'); location.href='/iam/main/index.sko';</script> -->
<%/* } */

//파라미터
String actType		=   parseNull(request.getParameter("actType"));		//액션 타입
String transferNo	=	parseNull(request.getParameter("transferNo"));
String stateCd		=	parseNull(request.getParameter("cancelType"));	//수정할 stateCd
String stateCdParam =	parseNull(request.getParameter("stateCd"));		//이전 stateCd
String canceler		=	parseNull(sessionManager.getName());
String cancelerIp	=	parseNull(request.getRemoteAddr());
String cancelerId	=	parseNull(sessionManager.getId());
String reason		=	parseNull(request.getParameter("reason"));
String orgNo		=	parseNull(request.getParameter("trSchNo"));
String stGrade		=	parseNull(request.getParameter("stGrade"));

double fixNum		=	0;
double currNum		=	0;

//취소처리 액션
if (actType.equals("cancel")) {
	try {
	    sqlMapClient.startTransaction();
	    conn    =   sqlMapClient.getCurrentConnection();
	
	    //기존 ordered값 1추가
	    sql     =   new StringBuffer();
	    sql.append(" UPDATE TTRANS_STATE SET ORDERED = ORDERED + 1 	");
	    sql.append(" WHERE TRANSFERNO = ? AND ORDERED IS NOT NULL	");
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, transferNo);
	    pstmt.executeUpdate();            
	    
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	    
	    sql		=	new StringBuffer();
	    sql.append(" INSERT INTO TTRANS_STATE(TRANSFERNO, STATECD, REGDATE, REGTIME, REGIP, NAME, ORDERED, REASON) 	");
	    sql.append(" VALUES(?, ?, TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'), ?, ?, '1', ?) 		");
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, transferNo);
	    pstmt.setString(2, stateCd);
	    pstmt.setString(3, cancelerIp);
	    pstmt.setString(4, canceler);
	    pstmt.setString(5, reason);
	    result  =   pstmt.executeUpdate(); 
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}

	    
	    sql	= new StringBuffer();
	  	sql.append(" SELECT FIXNUM, CURRNUM, SHORTINNUM, SHORTOUTNUM FROM TORG_NUM_PERSON ");
	  	sql.append(" WHERE ORGNO = ? AND GRADE = ?  ");
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, orgNo);
	    pstmt.setString(2, stGrade);
	    rs	=	pstmt.executeQuery();
	    if(rs.next()){
	    	fixNum		=	rs.getDouble("FIXNUM");
	    	currNum		=	rs.getDouble("CURRNUM");
	    }
	    
	    if("TR_L_APPROVAL".equals(stateCdParam)){
		    sql		=	new StringBuffer();
		    sql.append(" UPDATE TORG_NUM_PERSON SET CURRNUM = CURRNUM-1, SHORTINNUM = ?, SHORTOUTNUM = ? ");
		    sql.append(" WHERE ORGNO = ? AND GRADE = ? ");
		    pstmt	=	conn.prepareStatement(sql.toString());
		    pstmt.setInt(1, (int)shortNum(fixNum, currNum-1, 1));
		    pstmt.setInt(2, (int)shortNum(fixNum, currNum-1, 2));
		    pstmt.setString(3, orgNo);
		    pstmt.setString(4, stGrade);
		    pstmt.executeUpdate();
		    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	    }

	} catch (Exception e) {
	    e.printStackTrace();
	    alertBack(out, "처리중 오류가 발생하였습니다."+e.getMessage()); 
	} finally {
	
	    if (rs != null) try { rs.close(); } catch (SQLException se) {}
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	    if (conn != null) try { conn.close(); } catch (SQLException se) {}
	    sqlMapClient.endTransaction();
	
	    outHtml  =   "";
	    if (result > 0) {
	        outHtml +=  "<script>alert('정상적으로 처리되었습니다.');";
	        outHtml +=  "location.href='/program/transfer/admin/tra_req_view.jsp?transferNo="+ transferNo +"';</script>";
	        out.println(outHtml);
	    }else{
	    	outHtml +=	"<script>alert('처리중 오류가 발생하였습니다.');";
	    	outHtml +=	"history.back();</script>";
	        out.println(outHtml);
	    }
	}
} else {
    out.println("<script>");
    out.println("alert('파라미터 값 이상입니다. 관리자에게 문의하세요.');");
    out.println("history.back();");
    out.println("</script>");
}
%>

