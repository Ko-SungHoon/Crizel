<%
/**
*	PURPOSE	:	전입학 / 제2외국어 등록 수정 action jsp
*	CREATE	:	20180118_thur	JI
*	MODIFY	:	20180118_thur	JMG
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
String sql_str	=	"";
int key 		= 	0;
int chkResult   =   0;
int result 		= 	0;
String outHtml  =   "";
String resultMsg= 	"";

String foreign_type =   parseNull(request.getParameter("foreign_type"));
String foreign_code =   parseNull(request.getParameter("foreignCode"));		//fcode 검색할 값
String foreign_name =   parseNull(request.getParameter("foreignName"));

String fcode		=	parseNull(request.getParameter("fcode"));			//fcode 수정될 값
String useYn		=	parseNull(request.getParameter("useYn"));
String order		=	parseNull(request.getParameter("order"));

boolean adminChk	=	sessionManager.isRoleAdmin();

/* if(!adminChk){ */
	%>
	<!-- <script>alert('관리자권한이 없습니다. \n다시 로그인해주세요.'); location.href='/iam/main/index.sko';</script> -->
<%/* } */

//추가
if (foreign_type.equals("add")) {
    
    if ((foreign_code != null && foreign_code.trim().length() > 0) && (foreign_name != null && foreign_name.trim().length() > 0)) {
        
        try {

            sqlMapClient.startTransaction();
            conn    =   sqlMapClient.getCurrentConnection();

            //find exist code, name
            sql     =   new StringBuffer();
            sql_str =   "SELECT * FROM TFOREIGN_CODE WHERE FCODE = ? OR FNAME = ? ";
            sql.append(sql_str);
            pstmt	=	conn.prepareStatement(sql.toString());
            pstmt.setString(1, foreign_code);
            pstmt.setString(2, foreign_name);
            
            rs      =   pstmt.executeQuery();
            if (rs.next()) {
                outHtml  =   "";
                outHtml +=  "<script>alert('중복된 코드나 외국어명입니다. 다시 입력하세요.');";
                outHtml +=  "history.back();</script>";
                out.println(outHtml);
                return;
            }
            if (rs != null) try { rs.close(); } catch (SQLException se) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
            
            
            //insert
            sql     =   new StringBuffer();
            sql_str =   "INSERT INTO TFOREIGN_CODE ";
            sql_str +=  " (FCODE, FNAME, USEYN, REGDATE, REGTIME) ";
            sql_str +=  " VALUES(?, ?, 'Y', TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'))";
            sql.append(sql_str);
            pstmt	=	conn.prepareStatement(sql.toString());
            pstmt.setString(1, foreign_code);
            pstmt.setString(2, foreign_name);
            
            result  =   pstmt.executeUpdate();            
            
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
                outHtml +=  "<script>alert('정상적으로 등록되었습니다.');";
                outHtml +=  "location.href='./tra_foreign_list.jsp'</script>";
                out.println(outHtml);
            }
        }
    //none parameter
    } else {
        out.println("<script>");
        out.println("alert('코드명과 외국어명을 반드시 입력하세요.');");
        out.println("history.back();");
        out.println("</script>");
        return;
    }
    
//수정
} else if (foreign_type.equals("mod")) {
    
    try {
			chkResult = 0;    	
            sqlMapClient.startTransaction();
            conn    =   sqlMapClient.getCurrentConnection();
            
            sql     =   new StringBuffer();
            
            sql_str =	" SELECT FNAME FROM TFOREIGN_CODE \n";
            sql_str +=	" WHERE FNAME = ? AND FCODE != ? ";
            sql.append(sql_str);
            pstmt	=	 conn.prepareStatement(sql.toString());
            pstmt.setString(1, foreign_name);
            pstmt.setString(2, fcode);
            
            rs  	=	 pstmt.executeQuery();
            if(rs.next())	{
            	resultMsg = "외국어명";
            	chkResult += 1;
            }
            if (rs != null) try { rs.close(); } catch (SQLException se) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
            
            
            sql     =   new StringBuffer();
            
            sql_str =	" SELECT ORDERED FROM TFOREIGN_CODE \n";
            sql_str +=	" WHERE ORDERED = ? AND FCODE != ? ";
            sql.append(sql_str);
            pstmt	=	 conn.prepareStatement(sql.toString());
            pstmt.setString(1, order);
            pstmt.setString(2, fcode);
            
            rs  	=	 pstmt.executeQuery();
            if(rs.next())	{
            	resultMsg = "순서";
            	chkResult += 1;
            }
            if (rs != null) try { rs.close(); } catch (SQLException se) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
            
            if(chkResult == 0){
	            //update 
				sql     =   new StringBuffer();
	            sql_str =	" UPDATE TFOREIGN_CODE SET \n";
	            sql_str	+=	" FNAME = ?, USEYN = ?, ORDERED = ? \n";
	            sql_str +=	" WHERE FCODE = ? ";
	            sql.append(sql_str);
	            pstmt	=	 conn.prepareStatement(sql.toString());
	            pstmt.setString(1, foreign_name);
	            pstmt.setString(2, useYn);
	            pstmt.setString(3, order);
	            pstmt.setString(4, fcode);
	            
	            result  =	 pstmt.executeUpdate();
	            if (rs != null) try { rs.close(); } catch (SQLException se) {}
	            if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	            
            } else {
            	outHtml = "";
            	outHtml +=  "<script>alert('" + resultMsg + "에 중복된 값이 존재합니다.');";
                outHtml +=  "history.back();</script>";
                out.println(outHtml);
                result = -9;
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
                outHtml +=  "<script>alert('정상적으로 수정되었습니다.');";
                outHtml +=  "opener.location.reload();window.close();</script>";
                out.println(outHtml);
            } else if(result == -9) {
            	//중복체크시
            } else {
                outHtml +=  "<script>alert('처리 중 오류가 발생하였습니다.');";
                outHtml +=  "history.back();</script>";
                out.println(outHtml);
            }
        }
    
} else if("del".equals(foreign_type)){
	 try {

         sqlMapClient.startTransaction();
         conn    =   sqlMapClient.getCurrentConnection();
         sql     =   new StringBuffer();

         //delete
         sql_str =	 "DELETE TFOREIGN_CODE WHERE FCODE = ? ";
         sql.append(sql_str);
         pstmt	 =	 conn.prepareStatement(sql.toString());
         pstmt.setString(1, foreign_code);
         result  =	 pstmt.executeUpdate();
         
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
             outHtml +=  "<script>alert('정상적으로 삭제되었습니다.');";
             outHtml +=  "location.href='./tra_foreign_list.jsp'</script>";
             out.println(outHtml);
         } else {
             outHtml +=  "<script>alert('처리 중 오류가 발생하였습니다.');";
             outHtml +=  "history.back();</script>";
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

