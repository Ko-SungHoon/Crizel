<%
/**
*	PURPOSE	:	전입학 / 정현원 및 학교관리 action jsp
*	CREATE	:	20180119_fri	JMG
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

String actType	=   parseNull(request.getParameter("actType"));		//액션 타입
String tabName	=	parseNull(request.getParameter("tabName"));		//탭 이름
String orgNo	=	parseNull(request.getParameter("orgNo"));		//학교코드
String tabNo	=	parseNull(request.getParameter("tabNo"));		//탭번호

String goTab	=	parseNull(request.getParameter("goTab"));	
String ordered	=	parseNull(request.getParameter("ordered"));

boolean adminChk	=	sessionManager.isRoleAdmin();

/* if(!adminChk){
 */	%>
<!-- 	<script>alert('관리자권한이 없습니다. \n다시 로그인해주세요.'); location.href='/iam/main/index.sko';</script>
 --><%/* } */

//정현원 및 외국어 수정 part
String[] orgNumNo   =   request.getParameterValues("orgNumNo");
String[] fixNum     =   request.getParameterValues("fixNum");
String[] currNum    =   request.getParameterValues("currNum");
String[] fcode      =   request.getParameterValues("fcode");
String[] fcode2     =   request.getParameterValues("fcode2");
String[] fcode3     =   request.getParameterValues("fcode3");

//학교 정보 수정
String recType	=   parseNull(request.getParameter("recType"));		//액션 타입
//학교 정보
String schNo        =   parseNull(request.getParameter("schNo"));
String orgName      =   parseNull(request.getParameter("orgName"));
String orgDifName   =   "";
boolean orgNameChg  =   false;
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

//탭 추가
if (actType.equals("newTab")) {
    
	try {
	    sqlMapClient.startTransaction();
	    conn    =   sqlMapClient.getCurrentConnection();
	
	    //insert
	    sql     =   new StringBuffer();
	    sql_str =   " INSERT INTO TORG_TAB ";
	    sql_str +=  " (TABNO, TABNAME, REG_DATE, REG_TIME, USEYN) ";
	    sql_str +=  " VALUES ((SELECT NVL(MAX(TABNO), '0')+1 FROM TORG_TAB), ";
	    sql_str +=	" ?, TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'), 'Y') ";
	    sql.append(sql_str);
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, tabName);
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
	        outHtml +=  "<script>alert('정상적으로 추가되었습니다.');";
	        outHtml +=  "location.href='/program/transfer/admin/tra_sch_list.jsp';</script>";
	        out.println(outHtml);
            return;
	    }
	}
} else if("sel".equals(actType)) { 
	
	try {
	    sqlMapClient.startTransaction();
	    conn    =   sqlMapClient.getCurrentConnection();
	
	    //학교 추가
	    sql     =   new StringBuffer();
	    sql_str =   " UPDATE TORG_INFO SET TABNO = ? ";
	    sql_str	+=	" WHERE ORGNO = ? ";
	    sql.append(sql_str);
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, tabNo);
	    pstmt.setString(2, orgNo);
	    result  =   pstmt.executeUpdate();
		
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	            
	    
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
	        outHtml +=  "<script>alert('정상적으로 추가되었습니다.');";
	        outHtml +=  "opener.location.reload();window.close();</script>";
	        out.println(outHtml);
            return;
	    }
	}

} else if("delTab".equals(actType)){
	
	if(!"".equals(tabNo)){
		try {
		    sqlMapClient.startTransaction();
		    conn    =   sqlMapClient.getCurrentConnection();
		
		    //탭 삭제
		    sql     =   new StringBuffer();
		    sql_str =   " UPDATE TORG_TAB SET USEYN = 'N' ";
		    sql_str	+=	" WHERE TABNO = ? ";
		    sql.append(sql_str);
		    pstmt	=	conn.prepareStatement(sql.toString());
		    pstmt.setString(1, tabNo);
		    result  =   pstmt.executeUpdate();
		    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
		    
		    //학교 삭제
		    sql     =   new StringBuffer();
		    sql_str =   " UPDATE TORG_INFO SET TABNO = NULL ";
		    sql_str	+=	" WHERE TABNO = ? ";
		    sql.append(sql_str);
		    pstmt	=	conn.prepareStatement(sql.toString());
		    pstmt.setString(1, tabNo);
		    pstmt.executeUpdate();
		    
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
		        outHtml +=  "location.href='/program/transfer/admin/tra_sch_list.jsp';</script>";
		        out.println(outHtml);
		    } else {
		    	outHtml +=  "<script>alert('처리중 오류가 발생하였습니다.');";
		        outHtml +=  "location.href='/program/transfer/admin/tra_sch_list.jsp';</script>";
		        out.println(outHtml);
		    }
		}
	} else {
	    outHtml  =  "";
		outHtml	+=	"<script>alert('탭번호 파라미터가 없습니다.');";
		outHtml +=	"history.back();</script>";
		out.println(outHtml);
        return;
	}
	
} else if("delSch".equals(actType)){
	if(!"".equals(orgNo)){
		try {
		    sqlMapClient.startTransaction();
		    conn    =   sqlMapClient.getCurrentConnection();
		
		    //학교 삭제
		    sql     =   new StringBuffer();
		    sql_str =   " UPDATE TORG_INFO SET TABNO = NULL ";
		    sql_str	+=	" WHERE ORGNO = ? ";
		    sql.append(sql_str);
		    pstmt	=	conn.prepareStatement(sql.toString());
		    pstmt.setString(1, orgNo);
		    result = pstmt.executeUpdate();
		    
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
		        outHtml +=  "location.href='/program/transfer/admin/tra_sch_list.jsp';</script>";
		        out.println(outHtml);
		    } else {
		    	outHtml +=  "<script>alert('처리중 오류가 발생하였습니다.');";
		        outHtml +=  "location.href='/program/transfer/admin/tra_sch_list.jsp';</script>";
		        out.println(outHtml);
		    }
		}
	} else {
	    outHtml  =  "";
		outHtml	+=	"<script>alert('탭번호 파라미터가 없습니다.');";
		outHtml +=	"history.back();</script>";
		out.println(outHtml);
        return;
	}
//정현원 및 외국어 수정
} else if("modSch".equals(actType)){
    
    if (orgNumNo.length > 0) {
        //정원내, 정원외 연산 part
        List<String> shortInNumData    =   new ArrayList<String>();
        List<String> shortOutNumData   =   new ArrayList<String>();
        for (int j = 0; j < orgNumNo.length; j++) {
            
            shortInNumData.add(Integer.toString(Integer.parseInt(fixNum[j]) - Integer.parseInt(currNum[j])));
            shortOutNumData.add(Double.toString((int)(Double.parseDouble(fixNum[j]) / 100 * 5) + (Integer.parseInt(fixNum[j]) - Integer.parseInt(currNum[j]))));
        }
        String[] shortInNum    =   new String[shortInNumData.size()];
        String[] shortOutNum   =   new String[shortOutNumData.size()];
        shortInNumData.toArray(shortInNum);
        shortOutNumData.toArray(shortOutNum);
        
        try {
		    sqlMapClient.startTransaction();
		    conn    =   sqlMapClient.getCurrentConnection();
            
            sql     =   new StringBuffer();
            sql_str =   " UPDATE TORG_NUM_PERSON SET ";
            sql_str +=  " FIXNUM = ? ";
            sql_str +=  " , CURRNUM = ? ";
            sql_str +=  " , FCODE = ? ";
            sql_str +=  " , FCODE2 = ? ";
            sql_str +=  " , FCODE3 = ? ";
            sql_str +=  " , SHORTINNUM = ? ";
            sql_str +=  " , SHORTOUTNUM = ? ";
            sql_str +=  " WHERE ORGNUMNO = ? ";
            sql.append(sql_str);
            pstmt   =   conn.prepareStatement(sql.toString());
            
            for (int i = 0; i < orgNumNo.length; i++) {
                
                pstmt.setString(1, fixNum[i]);
                pstmt.setString(2, currNum[i]);
                pstmt.setString(3, fcode[i]);
                pstmt.setString(4, fcode2[i]);
                pstmt.setString(5, fcode3[i]);
                pstmt.setString(6, shortInNum[i]);
                pstmt.setString(7, shortOutNum[i]);
                pstmt.setString(8, orgNumNo[i]);    //WHERE
                
                pstmt.addBatch();
            }
            int[] count =   pstmt.executeBatch();
            result      =   count.length;
            
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
		        outHtml +=  "location.href='/program/transfer/admin/tra_sch_list.jsp?goTab="+ tabNo +"';</script>";
		        out.println(outHtml);
		    } else {
		    	outHtml +=  "<script>alert('처리중 오류가 발생하였습니다.');";
		        outHtml +=  "history.back();</script>";
		        out.println(outHtml);
		    }
		}
    } else {
        outHtml  =  "";
		outHtml	+=	"<script>alert('학교가 확인되지 않습니다.');";
		outHtml +=	"history.back();</script>";
        return;
    }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//학교 정보 수정
} else if("mod".equals(recType)){

    if (schNo != null && schNo.length() > 0) {
    
        try {
            sqlMapClient.startTransaction();
            conn    =   sqlMapClient.getCurrentConnection();

            //학교명 변경 확인
            sql     =   new StringBuffer();
            sql_str =   "SELECT ORGNAME FROM TORG_INFO WHERE ORGNO = ?";
            sql.append(sql_str);
            pstmt   =   conn.prepareStatement(sql.toString());
            pstmt.setString(1, schNo);
            rs      =   pstmt.executeQuery();
            if (rs.next()) {
                orgDifName  =   rs.getString("ORGNAME");
            }
            if (!orgDifName.equals(orgName)) {orgNameChg =   true;}
            
            //관할 리스트
            sql     =   new StringBuffer();
            sql_str =   " UPDATE TORG_INFO SET ";
            sql_str +=  " ORGNAME = ? ";
            sql_str +=  " , SCHKIND = ? ";
            sql_str +=  " , PORGNO = ? ";
            sql_str +=  " , BUILDDATE = ? ";
            sql_str +=  " , HOMEPAGE = ? ";
            sql_str +=  " , ZIPCODE = ? ";
            sql_str +=  " , ADDR = ? ";
            sql_str +=  " , TEL = ? ";
            sql_str +=  " , FAX = ? ";
            if (sex != null && sex.length() > 0 && schType != null && schType.length() > 0) {
                sql_str +=  " , SEX = ? ";
                sql_str +=  " , SCHTYPE = ? ";
            }
            sql_str +=  " WHERE ORGNO = ? ";

            sql.append(sql_str);
            pstmt	=	conn.prepareStatement(sql.toString());
            pstmt.setString(1, orgName);
            pstmt.setString(2, schKind);
            pstmt.setString(3, porgNo);
            pstmt.setString(4, buildDate);
            pstmt.setString(5, homepage);
            pstmt.setString(6, zipCode);
            pstmt.setString(7, addr);
            pstmt.setString(8, tel);
            pstmt.setString(9, fax);
            if (sex != null && sex.length() > 0 && schType != null && schType.length() > 0) {
                pstmt.setString(10, sex);
                pstmt.setString(11, schType);

                pstmt.setString(12, schNo);
            } else {
                pstmt.setString(10, schNo);
            }
            result  =   pstmt.executeUpdate();

            if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
            
            //학교명 변경 확인
            if (orgNameChg) {
                result  =   0;
                sql     =   new StringBuffer();
                sql_str =   "INSERT INTO TORG_NAME_HISTORY ";
                sql_str +=  " (NAMEHISNO, ORGNO, PRENAME, SDATE, REGDATE, REGTIME, REGIP) ";
                sql_str +=  " VALUES ";
                sql_str +=  " ((SELECT MAX(NAMEHISNO)+1 FROM TORG_NAME_HISTORY), ?, ?, TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'), ?) ";
                sql.append(sql_str);
                pstmt   =   conn.prepareStatement(sql.toString());
                pstmt.setString(1, schNo);
                pstmt.setString(2, orgDifName);
                pstmt.setString(3, request.getRemoteAddr());
                result  =   pstmt.executeUpdate();
                if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
            }
            
            if ((preName != null && preName.length > 0) && (sDate != null && sDate.length > 0)) {
                for (int i = 0; i < preName.length; i++) {
                    
                    if ((nameHisNo[i] != null && nameHisNo[i].trim().length() > 0) && (preName[i] != null && preName[i].trim().length() > 0)) {
                        result  =   0;
                        sql     =   new StringBuffer();
                        sql_str =   "UPDATE TORG_NAME_HISTORY SET ";
                        sql_str +=  " PRENAME = ?, SDATE = ?, EDATE = ? ";
                        sql_str +=  " WHERE NAMEHISNO = ? ";
                        sql.append(sql_str);
                        pstmt   =   conn.prepareStatement(sql.toString());
                        pstmt.setString(1, preName[i]);
                        pstmt.setString(2, sDate[i]);
                        pstmt.setString(3, eDate[i]);
                        pstmt.setString(4, nameHisNo[i]);
                        result  =   pstmt.executeUpdate();
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
                    } else {
                        if (preName[i] != null && preName[i].trim().length() > 0) {
                            result  =   0;
                            sql_str =   "INSERT INTO TORG_NAME_HISTORY ";
                            sql_str +=  " (NAMEHISNO, ORGNO, PRENAME, SDATE, EDATE, REGDATE, REGTIME, REGIP) ";
                            sql_str +=  " VALUES ";
                            sql_str +=  " ((SELECT MAX(NAMEHISNO)+1 FROM TORG_NAME_HISTORY), ?, ?, ?, ?, TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'), ?) ";
                            sql.append(sql_str);
                            pstmt   =   conn.prepareStatement(sql.toString());
                            pstmt.setString(1, schNo);
                            pstmt.setString(2, preName[i]);
                            pstmt.setString(3, sDate[i]);
                            pstmt.setString(4, eDate[i]);
                            pstmt.setString(5, request.getRemoteAddr());
                            result  =   pstmt.executeUpdate();
                            if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
                        }
                    }
                }
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
		        outHtml +=  "location.href='/program/transfer/admin/tra_sch_pop.jsp?schNo="+ schNo +"';</script>";
		        out.println(outHtml);
		    } else {
		    	outHtml +=  "<script>alert('처리중 오류가 발생하였습니다.');";
		        outHtml +=  "history.back();</script>";
		        out.println(outHtml);
		    }
		}
        
    } else {
        out.println("<script>");
        out.println("alert('학교 정보가 확인되지 않습니다.');");
        out.println("history.back();");
        out.println("</script>");
    }
//학교 정보 입력
} else if("new".equals(recType)){
    
    if ((orgName != null && orgName.length() > 0) && (schKind != null && schKind.length() > 0)) {
        
        try {
            sqlMapClient.startTransaction();
            conn    =   sqlMapClient.getCurrentConnection();
            
            //1차 학교 정보 insert
            sql     =   new StringBuffer();
            sql_str =   "INSERT INTO TORG_INFO ";
            sql_str +=  "(ORGNO, ORGNAME, SCHKIND, PORGNO, BUILDDATE, HOMEPAGE, ZIPCODE, ADDR, TEL, FAX, SEX, SCHTYPE, ORGTYPE, USEYN) ";
            sql_str +=  " VALUES ";
            sql_str +=  " ( ";
            sql_str +=  " (SELECT MAX(ORGNO) + 1 FROM TORG_INFO) ";
            sql_str +=  " , ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";
            sql_str +=  " ) ";
            sql.append(sql_str);
            pstmt	=	conn.prepareStatement(sql.toString());
            pstmt.setString(1, orgName);
            pstmt.setString(2, schKind);
            pstmt.setString(3, porgNo);
            pstmt.setString(4, buildDate);
            pstmt.setString(5, homepage);
            pstmt.setString(6, zipCode);
            pstmt.setString(7, addr);
            pstmt.setString(8, tel);
            pstmt.setString(9, fax);
            pstmt.setString(10, sex);
            pstmt.setString(11, schType);
            pstmt.setString(12, "SCHOOL");
            pstmt.setString(13, "Y");
            result  =   pstmt.executeUpdate();
            
            if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
            
            //고등학교일 때 TORG_NUM_PERSON
            if (schKind.equals("STH") && result == 1) {
                result  =   0;  //result 초기화
                //get the last number
                String  lastNum =   "";
                sql     =   new StringBuffer();
                sql_str =   "SELECT MAX(ORGNO) AS LASTNUM FROM TORG_INFO";
                sql.append(sql_str);
                pstmt   =   conn.prepareStatement(sql.toString());
                rs      =   pstmt.executeQuery();
                if (rs.next()) {lastNum =   rs.getString("LASTNUM");}
                
                if (sex == null && sex.length() < 1) {sex = "M";}
                
                //insert TORG_NUM_PERSON
                sql     =   new StringBuffer();
                sql_str =   "INSERT ALL ";
                sql_str +=  " INTO TORG_NUM_PERSON (ORGNUMNO, ORGNO, USERNO, GRADE, SEX, REGDATE, REGTIME, REGIP) ";
                sql_str +=  " VALUES ((SELECT MAX(ORGNUMNO) + 1 FROM TORG_NUM_PERSON), ?, '-1', '1', ?, TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'), ?) ";
                sql_str +=  " INTO TORG_NUM_PERSON (ORGNUMNO, ORGNO, USERNO, GRADE, SEX, REGDATE, REGTIME, REGIP) ";
                sql_str +=  " VALUES ((SELECT MAX(ORGNUMNO) + 2 FROM TORG_NUM_PERSON), ?, '-1', '2', ?, TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'), ?) ";
                sql_str +=  " INTO TORG_NUM_PERSON (ORGNUMNO, ORGNO, USERNO, GRADE, SEX, REGDATE, REGTIME, REGIP) ";
                sql_str +=  " VALUES ((SELECT MAX(ORGNUMNO) + 3 FROM TORG_NUM_PERSON), ?, '-1', '3', ?, TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'), ?) ";
                sql_str +=  " SELECT * FROM DUAL ";
                sql.append(sql_str);
                pstmt   =   conn.prepareStatement(sql.toString());
                pstmt.setString(1, lastNum);
                pstmt.setString(2, sex);
                pstmt.setString(3, (String)request.getRemoteAddr());
                pstmt.setString(4, lastNum);
                pstmt.setString(5, sex);
                pstmt.setString(6, (String)request.getRemoteAddr());
                pstmt.setString(7, lastNum);
                pstmt.setString(8, sex);
                pstmt.setString(9, (String)request.getRemoteAddr());
                result  =   pstmt.executeUpdate();
            }
            
        } catch (Exception e) {
		    e.printStackTrace();
		    alertBack(out, "처리중 오류가 발생하였습니다.1"+e.getMessage());
		} finally {
		
		    if (rs != null) try { rs.close(); } catch (SQLException se) {}
		    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
		    if (conn != null) try { conn.close(); } catch (SQLException se) {}
		    sqlMapClient.endTransaction();
		
		    outHtml  =   "";
		    if (result > 0) {
		        outHtml +=  "<script>alert('정상적으로 등록되었습니다.');";
		        outHtml +=  "location.href='/program/transfer/admin/tra_sch_pop.jsp?schNo="+ schNo +"';</script>";
		        out.println(outHtml);
		    } else {
		    	outHtml +=  "<script>alert('처리중 오류가 발생하였습니다.2');";
		        outHtml +=  "history.back();</script>";
		        out.println(outHtml);
		    }
		}
    } else {
        out.println("<script>");
        out.println("alert('학교명, 급별 구분은 반드시 입력해야 합니다.');");
        out.println("history.back();");
        out.println("</script>");
    }
    
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
} else if("tabMod".equals(actType)){
	try {
	    sqlMapClient.startTransaction();
	    conn    =   sqlMapClient.getCurrentConnection();
	
	    //탭 수정
	    sql     =   new StringBuffer();
	    sql_str =   " UPDATE TORG_TAB SET TABNAME = ?, ORDERED = ? ";
	    sql_str	+=	" WHERE TABNO = ? ";
	    sql.append(sql_str);
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, tabName);
	    pstmt.setString(2, ordered);
	    pstmt.setString(3, tabNo);
	    result  =   pstmt.executeUpdate();
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	    
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
	        outHtml +=  "opener.location.reload(); window.close();</script>";
	        out.println(outHtml);
	    } else {
	    	outHtml +=  "<script>alert('처리중 오류가 발생하였습니다.');";
	        outHtml +=  "history.back();</script>";
	        out.println(outHtml);
	    }
	}
} else if("del".equals(recType)) {
	try {
	    sqlMapClient.startTransaction();
	    conn    =   sqlMapClient.getCurrentConnection();
	
	    //탭 수정
	    sql     =   new StringBuffer();
	    sql_str =   " UPDATE TORG_INFO SET USEYN = 'N' WHERE ORGNO = ? ";
	    sql.append(sql_str);
	    pstmt	=	conn.prepareStatement(sql.toString());
	    pstmt.setString(1, schNo);
	    result  =   pstmt.executeUpdate();
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException se) {}
	    
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
	        outHtml +=  "opener.location.reload(); window.close();</script>";
	        out.println(outHtml);
	    } else {
	    	outHtml +=  "<script>alert('처리중 오류가 발생하였습니다.');";
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

