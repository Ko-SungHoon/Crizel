<%
/**
*   PURPOSE :   학교연계 프로그램 insert action page
*   CREATE  :   20180314_wed    JI
*   MODIFY  :   ...
**/
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>

<%!

    private class ProData {
        public int pro_no;
        
    }

    private class ProDataList implements RowMapper<ProData> {
        public ProData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProData proData     =   new ProData();
            
            proData.pro_no      =   rs.getInt("PRO_NO");
            
            return proData;
        }
    }
    
%>
    
<%

/** 파라미터 UTF-8처리 **/
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

SessionManager sessionManager   =   new SessionManager(request);

/* dataType */
String dataType         =   parseNull(request.getParameter("dataType"));    //insert, modify, delete, cancel

/* Session Chk */
if (sessionManager.getName().trim().equals("") || sessionManager.getId().trim().equals("") || sessionManager.getName().trim().length() < 1 || sessionManager.getId().trim().length() < 1 || !sessionManager.getGroupId().equals("GRP_000009") || !sessionManager.getGroupId().equals("GRP_000008") || !sessionManager.getGroupId().equals("GRP_000007") || !sessionManager.getGroupId().equals("GRP_000006") || !sessionManager.getGroupId().equals("GRP_000005")) {
	if (sessionManager.isRoleAdmin() || "gne_koke007".equals(sessionManager.getId()) || sessionManager.getGroupId().equals("GRP_000009") || sessionManager.getGroupId().equals("GRP_000008") || sessionManager.getGroupId().equals("GRP_000007") || sessionManager.getGroupId().equals("GRP_000006") || sessionManager.getGroupId().equals("GRP_000005")) {
	} else {
        out.println("<script>");
        out.println("alert('로그인 정보 저장 시간초과 입니다. 다시 로그인 하세요.');");
        out.println("location.href='/index.gne?menuCd=DOM_000000139008002002';");
        if (dataType.equals("app")) {
            out.println("location.href='http://www.gne.go.kr/iam/login/login.sko';");
        }
        out.println("</script>");
    }
}


String req_no           =   parseNull(request.getParameter("reqNo"));       //only use => modify, delete, cancel

String canAdmin         =   parseNull(request.getParameter("canAdmin"), "C");    //admin cancel flag

/* set values */
String req_date         =   parseNull(request.getParameter("req_date"));
String aft_flag         =   parseNull(request.getParameter("aft_flag"));

Connection conn = null;
PreparedStatement pstmt = null;

StringBuffer sql 		=    null;
String sql_str          =    null;
Object[] insObj 		=    null;
int result 				=    0;
int count 				=    0;


if (dataType != null && dataType.length() > 0) {
    
//session 주기 체크
    
    /** 신청 insert **/
    if (dataType.equals("ins")) {
        
        String[] proNo          =   request.getParameterValues("proNo");
        String[] req_per        =   request.getParameterValues("req_per");
        int req_total_cnt       =   0;
        for (int i = 0; i < req_per.length; i++) {req_total_cnt   +=  Integer.parseInt(req_per[i]);}
        String sch_mng_name     =   parseNull(request.getParameter("sch_mng_name"));
        String sch_mng_tel      =   parseNull(request.getParameter("sch_mng_tel"));
        String sch_mng_mail     =   parseNull(request.getParameter("sch_mng_mail"));
        
        //total chk
        if (req_total_cnt < 1) {
            out.println("<script>");
            out.println("alert('신청인원이 없습니다. 다시 신청하세요.');");
            out.println("location.href='/index.gne?menuCd=DOM_000000139008002002';");
            out.println("</script>");
            return;
        }
        
        int lastInsNo   =   0;
        
        //insert
        try {
            //last req no selecting
            sql         =   new StringBuffer();
            sql.append("    SELECT NVL(MAX(REQ_NO)+1,1) FROM HAPPY_REQ_SCH");
            lastInsNo   =   jdbcTemplate.queryForObject(
                                sql.toString(),
                                Integer.class
						    );
            
            //insert HAPPY_REQ_SCH
            sql         =   new StringBuffer();
            sql_str     =   "INSERT INTO HAPPY_REQ_SCH";
            sql_str     +=  " ( REQ_NO ";
            sql_str     +=  " , REQ_SCH_ID ";
            sql_str     +=  " , SCH_MNG_NM ";
            sql_str     +=  " , SCH_MNG_TEL ";
            sql_str     +=  " , SCH_MNG_MAIL ";
            sql_str     +=  " , REG_DATE ";
            sql_str     +=  " , REG_IP ";
            sql_str     +=  " , APPLY_FLAG ";
            sql_str     +=  " , REQ_CNT ";
            sql_str     +=  " , REQ_DATE ";
            sql_str     +=  " , REQ_AFT_FLAG ";
            sql_str     +=  " , REQ_SCH_NM ";
            sql_str     +=  " , REQ_SCH_GRADE ";
            sql_str     +=  " , REQ_SCH_GROUP ";
            sql_str     +=  " ) ";
            sql_str     +=  " VALUES ";
            sql_str     +=  " ( ";
            sql_str     +=  " ? ";//REQ_NO
            sql_str     +=  " , ? ";//REQ_SCH_ID
            sql_str     +=  " , ? ";//SCH_MNG_NM
            sql_str     +=  " , ? ";//SCH_MNG_TEL
            sql_str     +=  " , ? ";//SCH_MNG_MAIL
            sql_str     +=  " , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') ";//REG_DATE
            sql_str     +=  " , ? ";//REG_IP
            sql_str     +=  " , 'N' ";//APPLY_FLAG
            sql_str     +=  " , ? ";//REQ_CNT
            sql_str     +=  " , ? ";//REQ_DATE
            sql_str     +=  " , ? ";//REQ_AFT_FLAG
            sql_str     +=  " , ? ";//REQ_SCH_NM
            sql_str     +=  " , NULL ";//REQ_SCH_GRADE
            sql_str     +=  " , NULL ";//REQ_SCH_GROUP
            sql_str     +=  " ) ";//
            sql.append(sql_str);
            
            insObj = new Object[]{
                    lastInsNo
                    , sessionManager.getId()
                    , sch_mng_name
                    , sch_mng_tel
                    , sch_mng_mail
                    , request.getRemoteAddr()
                    , req_total_cnt
                    , req_date
                    , aft_flag
                    , sessionManager.getName()
            };
            result = jdbcTemplate.update(
					sql.toString()
					, insObj
            );
            
            //프로그램 별 신청 insert 하기
            if (proNo.length > 0 && req_total_cnt > 0) {
                sqlMapClient.startTransaction();
                conn    =   sqlMapClient.getCurrentConnection();
                
                result       =   0;
                
                sql         =   new StringBuffer();
                sql_str     =   "INSERT INTO HAPPY_REQ_SCH_CNT ";
                sql_str     +=  " ( ";
                sql_str     +=  " REQ_NO ";
                sql_str     +=  " , PRO_NO ";
                sql_str     +=  " , PRO_NAME ";
                sql_str     +=  " , REQ_PER ";
                sql_str     +=  " , REQ_DATE ";
                sql_str     +=  " ) ";
                sql_str     +=  " VALUES ( ";
                sql_str     +=  " ? ";
                sql_str     +=  " , ? ";
                sql_str     +=  " , (SELECT PRO_NAME FROM HAPPY_PRO_SCH WHERE PRO_NO = ? ) ";
                sql_str     +=  " , ? ";
                sql_str     +=  " , ? ";
                sql_str     +=  " ) ";
                sql.append(sql_str);
                pstmt       =   conn.prepareStatement(sql.toString());
                
                for (int i = 0; i < proNo.length; i++) {
                    //if (Integer.parseInt(req_per[i]) > 0) {
                        pstmt.setInt(1, lastInsNo);
                        pstmt.setString(2, proNo[i]);
                        pstmt.setString(3, proNo[i]);
                        pstmt.setString(4, req_per[i]);
                        pstmt.setString(5, req_date);
                        pstmt.addBatch();
                    //}
                }
                
                int[] batchCount 	=   pstmt.executeBatch();
				result      		=   batchCount.length;
            }
            
        }catch(Exception e){
            if(conn!=null){conn.close();}
            if(pstmt!=null){pstmt.close();}
            sqlMapClient.endTransaction();

            out.println(e.toString());
        }finally{
            if(conn!=null){conn.close();}
            if(pstmt!=null){pstmt.close();}
            sqlMapClient.endTransaction();

            if(result > 0){
                out.println("<script>");
                out.println("alert('정상적으로 처리되었습니다.');");
                out.println("location.href='/index.gne?menuCd=DOM_000000139008002003';");
                out.println("</script>");
            } else {
                out.println("<script>");
                out.println("alert('저장되지 않았습니다. 관리자에게 문의하세요.');");
                out.println("location.href='/index.gne?menuCd=DOM_000000139008002002';");
                out.println("</script>");
            }
        }
        
/** 신청 update & insert **/
    } else if (dataType.equals("mod")) {
        
        String[] proNo          =   request.getParameterValues("proNo");
        String[] req_per        =   request.getParameterValues("req_per");
        int req_total_cnt       =   0;
        for (int i = 0; i < req_per.length; i++) {req_total_cnt   +=  Integer.parseInt(req_per[i]);}
        String sch_mng_name     =   parseNull(request.getParameter("sch_mng_name"));
        String sch_mng_tel      =   parseNull(request.getParameter("sch_mng_tel"));
        String sch_mng_mail     =   parseNull(request.getParameter("sch_mng_mail"));
        
        req_total_cnt           =   0;
        for (int i = 0; i < req_per.length; i++) {req_total_cnt   +=  Integer.parseInt(req_per[i]);}
        
        List<ProData> proDataList   =   null;
        
        //0th total chk
        if (req_total_cnt < 1) {
            out.println("<script>");
            out.println("alert('신청인원이 없습니다. 다시 수정하세요.');");
            out.println("location.href='/index.gne?menuCd=DOM_000000139008002003';");
            out.println("</script>");
            return;
        }
        
        try {
            sqlMapClient.startTransaction();
            conn    =   sqlMapClient.getCurrentConnection();
            
            //1st HAPPY_REQ_SCH_CNT 모든 pro_no 삭제
            sql     =   new StringBuffer();
            sql.append(" DELETE FROM HAPPY_REQ_SCH_CNT WHERE REQ_NO = ? ");

            result  =   jdbcTemplate.update(sql.toString(), new Object[]{req_no});
            
            //2nd proNo 다시 insert
            if (result > 0) {
                result  =   0;

                sql     =   new StringBuffer();
                sql_str     =   "INSERT INTO HAPPY_REQ_SCH_CNT ";
                sql_str     +=  " ( ";
                sql_str     +=  " REQ_NO ";
                sql_str     +=  " , PRO_NO ";
                sql_str     +=  " , PRO_NAME ";
                sql_str     +=  " , REQ_PER ";
                sql_str     +=  " , REQ_DATE ";
                sql_str     +=  " ) ";
                sql_str     +=  " VALUES ( ";
                sql_str     +=  " ? ";
                sql_str     +=  " , ? ";
                sql_str     +=  " , (SELECT PRO_NAME FROM HAPPY_PRO_SCH WHERE PRO_NO = ? ) ";
                sql_str     +=  " , ? ";
                sql_str     +=  " , ? ";
                sql_str     +=  " ) ";
                sql.append(sql_str);
                pstmt       =   conn.prepareStatement(sql.toString());

                for (int i = 0; i < proNo.length; i++) {
                    //if (Integer.parseInt(req_per[i]) > 0) {
                        pstmt.setString(1, req_no);
                        pstmt.setString(2, proNo[i]);
                        pstmt.setString(3, proNo[i]);
                        pstmt.setString(4, req_per[i]);
                        pstmt.setString(5, req_date);
                        pstmt.addBatch();
                    //}
                }

                int[] batchCount 	=   pstmt.executeBatch();
                result      		=   batchCount.length;

            }

            //3rd HAPPY_REQ_SCH update
            if (result > 0) {
                
                result  =   0;
                
                sql     =   new StringBuffer();
                sql_str =   " UPDATE HAPPY_REQ_SCH SET ";
                sql_str +=  " SCH_MNG_NM = ? ";
                sql_str +=  " , SCH_MNG_TEL = ? ";
                sql_str +=  " , SCH_MNG_MAIL = ? ";
                sql_str +=  " , MOD_DATE = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') ";
                sql_str +=  " , REG_IP = ? ";
                sql_str +=  " , REQ_CNT = ? ";
                sql_str +=  " WHERE REQ_NO = ? ";
                sql.append(sql_str);
                
                insObj = new Object[]{
                    sch_mng_name
                    , sch_mng_tel
                    , sch_mng_mail
                    , request.getRemoteAddr()
                    , req_total_cnt
                    , req_no
                };
                
                result = jdbcTemplate.update(
                    sql.toString()
                    , insObj
                );
            }
            
        } catch(Exception e) {
            if(conn!=null){conn.close();}
            if(pstmt!=null){pstmt.close();}
            sqlMapClient.endTransaction();

            out.println(e.toString());
        } finally {
            if(conn!=null){conn.close();}
            if(pstmt!=null){pstmt.close();}
            sqlMapClient.endTransaction();

            if(result > 0){
                out.println("<script>");
                out.println("alert('정상적으로 처리되었습니다.');");
                out.println("location.href='/index.gne?menuCd=DOM_000000139008002005&req_no="+ req_no +"&req_date="+ req_date +"';");
                out.println("</script>");
            } else {
                out.println("<script>");
                out.println("alert('저장되지 않았습니다. 관리자에게 문의하세요.');");
                out.println("history.back();");
                out.println("</script>");
            }
        }
        
        
/** 승인 approval **/
    } else if (dataType.equals("app")) {
        
        try {
            
            sql     =   new StringBuffer();
            sql_str =   " UPDATE HAPPY_REQ_SCH SET ";
            sql_str +=  " APPLY_FLAG    =   'Y' ";
            sql_str +=  " , MOD_DATE = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') ";
            sql_str +=  " , APPLY_DATE = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24MISS') ";
            sql_str +=  " WHERE REQ_NO = ? ";
            sql.append(sql_str);
            
            result  =   jdbcTemplate.update(sql.toString(), new Object[]{req_no});
            
        }catch(Exception e){
            if(conn!=null){conn.close();}
            if(pstmt!=null){pstmt.close();}
            sqlMapClient.endTransaction();

            out.println(e.toString());
        }finally{
            if(conn!=null){conn.close();}
            if(pstmt!=null){pstmt.close();}
            sqlMapClient.endTransaction();
            
            if (result > 0) {
                out.println("<script>");
                out.println("alert('정상적으로 처리되었습니다.');");
                out.println("location.href='/program/happysch/admin/schReq.jsp';");
                out.println("</script>");
            } else {
                out.println("<script>");
                out.println("alert('처리되지 않았습니다. 관리자에게 문의하세요.');");
                out.println("history.back();");
                out.println("</script>");
            }
        }
        
/** 취소 신청 cancel (사용자 & 관리자) **/
    } else if (dataType.equals("can")) {
        
        try {
        
            sql         =   new StringBuffer();
            sql_str     =   " UPDATE HAPPY_REQ_SCH SET ";
            sql_str     +=  " APPLY_FLAG = ? ";
            sql_str     +=  " , MOD_DATE = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') ";
            sql_str     +=  " , APPLY_DATE = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24MISS') ";
            sql_str     +=  " WHERE REQ_NO = ? ";
            sql.append(sql_str);

            insObj = new Object[]{
                canAdmin
                , req_no
            };

            result      =   jdbcTemplate.update(sql.toString(), insObj);
        
        }catch(Exception e){
            if(conn!=null){conn.close();}
            if(pstmt!=null){pstmt.close();}
            sqlMapClient.endTransaction();

            out.println(e.toString());
        }finally{
            if(conn!=null){conn.close();}
            if(pstmt!=null){pstmt.close();}
            sqlMapClient.endTransaction();
            
            if (result > 0) {
                out.println("<script>");
                out.println("alert('정상적으로 처리되었습니다.');");
                if (canAdmin.equals("A")) out.println("location.href='/program/happysch/admin/schReq.jsp';");
                else out.println("location.href='/index.gne?menuCd=DOM_000000139008002003';");
                out.println("</script>");
            } else {
                out.println("<script>");
                out.println("alert('처리되지 않았습니다. 관리자에게 문의하세요.');");
                out.println("history.back();");
                out.println("</script>");
            }
        }
    }
    
} else {
    //type 을 못 받았을 경우
    out.println("<script>");
    out.println("alert('파라미터 값이 부정확 합니다.');");
    out.println("location.href='/index.gne?menuCd=DOM_000000139008002003';");
    out.println("</script>");
    return;
}

%>