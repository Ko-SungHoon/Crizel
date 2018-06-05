<%
/**
*   PURPOSE :   상시프로그램 insert action page
*   CREATE  :   20180212_mon    Ji
*   MODIFY  :   20180302_fri    Ji  실서버 이전
*   MODIFY  :   20180404_wed    Ji  학년 처리 추가 column name ETC2, 인솔자명(SCH_LEAD_NM)/인솔자(SCH_LEAD_TEL) 연락처 추가
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

String listPage		= "DOM_000000126002003005";		//	실서버 : DOM_000002001002003002 , 테스트 : DOM_000000126002003005
String confirmPage	= "DOM_000000126002003008";		//	실서버 : DOM_000002001002003004 , 테스트 : DOM_000000126002003008
String viewPage 	= "DOM_000000126002003006";		//	실서버 : DOM_000002001002003005 , 테스트 : DOM_000000126002003006

SessionManager sessionManager   =   new SessionManager(request);

/* dataType */
String dataType         =   parseNull(request.getParameter("dataType"));    //insert, modify, delete, cancel

/* Session Chk */
if (sessionManager.getName().trim().equals("") || sessionManager.getId().trim().equals("") || sessionManager.getName().trim().length() < 1 || sessionManager.getId().trim().length() < 1 || !sessionManager.getGroupId().equals("GRP_000009")) {
	if (sessionManager.isRoleAdmin() || "gne_wwoof2002".equals(sessionManager.getId()) || "gne_dream1".equals(sessionManager.getId()) || "gne_dream2".equals(sessionManager.getId())) {
	} else {
        out.println("<script>");
        out.println("alert('로그인 정보 저장 시간초과 입니다. 다시 로그인 하세요.');");
        if (dataType.equals("app")) {
            out.println("location.href='http://www.gne.go.kr/iam/login/login.sko';");
        }
        out.println("location.href='/index.gne?menuCd="+listPage+"';");
        out.println("</script>");
        return;
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
        
        String proNo          	=   parseNull(request.getParameter("proNo"));
        String req_per        	=   parseNull(request.getParameter("req_per"));
        String etc2           	=   parseNull(request.getParameter("etc2"));
        int req_total_cnt       =   0;
        req_total_cnt = Integer.parseInt(req_per);
        String sch_mng_name     =   parseNull(request.getParameter("sch_mng_name"));
        String sch_mng_tel      =   parseNull(request.getParameter("sch_mng_tel"));
        String sch_mng_mail     =   parseNull(request.getParameter("sch_mng_mail"));
        String sch_lead_name    =   parseNull(request.getParameter("sch_lead_name"));
        String sch_lead_tel     =   parseNull(request.getParameter("sch_lead_tel"));
        
        //total chk
        if (req_total_cnt < 1) {
            out.println("<script>");
            out.println("alert('신청인원이 없습니다. 다시 신청하세요.');");
            out.println("location.href='/index.gne?menuCd="+listPage+"';");
            out.println("</script>");
            return;
        }
        
        int lastInsNo   =   0;
        
        //insert
        try {
            //last req no selecting
            sql         =   new StringBuffer();
            sql.append("    SELECT NVL(MAX(REQ_NO)+1,1) FROM ART_REQ_ALWAY");
            lastInsNo   =   jdbcTemplate.queryForObject(
                                sql.toString(),
                                Integer.class
						    );
            
            //insert ART_REQ_ALWAY
            sql         =   new StringBuffer();
            sql_str     =   "INSERT INTO ART_REQ_ALWAY";
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
            sql_str     +=  " , SCH_LEAD_NM ";
            sql_str     +=  " , SCH_LEAD_TEL ";
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
            sql_str     +=  " , ? ";//SCH_LEAD_NM
            sql_str     +=  " , ? ";//SCH_LEAD_TEL
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
                    , sch_lead_name
                    , sch_lead_tel
            };
            result = jdbcTemplate.update(
					sql.toString()
					, insObj
            );
            
            //프로그램 별 신청 insert 하기
                result       =   0;
                
                sql         =   new StringBuffer();
                sql_str     =   "INSERT INTO ART_REQ_ALWAY_CNT ";
                sql_str     +=  " ( ";
                sql_str     +=  " REQ_NO ";
                sql_str     +=  " , PRO_NO ";
                sql_str     +=  " , PRO_NAME ";
                sql_str     +=  " , REQ_PER ";
                sql_str     +=  " , REQ_DATE ";
                sql_str     +=  " , ETC2 ";
                sql_str     +=  " ) ";
                sql_str     +=  " VALUES ( ";
                sql_str     +=  " ? ";
                sql_str     +=  " , ? ";
                sql_str     +=  " , (SELECT PRO_NAME FROM ART_PRO_ALWAY WHERE PRO_NO = ? ) ";
                sql_str     +=  " , ? ";
                sql_str     +=  " , ? ";
                sql_str     +=  " , ? ";
                sql_str     +=  " ) ";
                sql.append(sql_str);
                
                result = jdbcTemplate.update(sql_str, lastInsNo, proNo, proNo, req_per, req_date, etc2);
            
        }catch(Exception e){
            out.println(e.toString());
        }finally{
            if(result > 0){
                out.println("<script>");
                out.println("alert('정상적으로 처리되었습니다.');");
                out.println("location.href='/index.gne?menuCd="+viewPage+"';");
                out.println("</script>");
            } else {
                out.println("<script>");
                out.println("alert('저장되지 않았습니다. 관리자에게 문의하세요.');");
                //out.println("location.href='/index.gne?menuCd="+listPage+"';");
                out.println("</script>");
            }
        }
        
/** 신청 update & insert **/
    } else if (dataType.equals("mod")) {
        
        String proNo          	=   parseNull(request.getParameter("proNo"));
        String req_per        	=   parseNull(request.getParameter("req_per"));
        String etc2           	=   parseNull(request.getParameter("etc2"));
        int req_total_cnt       =   0;
        req_total_cnt   +=  Integer.parseInt(req_per);
        String sch_mng_name     =   parseNull(request.getParameter("sch_mng_name"));
        String sch_mng_tel      =   parseNull(request.getParameter("sch_mng_tel"));
        String sch_mng_mail     =   parseNull(request.getParameter("sch_mng_mail"));
        String sch_lead_name    =   parseNull(request.getParameter("sch_lead_name"));
        String sch_lead_tel     =   parseNull(request.getParameter("sch_lead_tel"));
        
        req_total_cnt           =   0;
        req_total_cnt   +=  Integer.parseInt(req_per);
        
        List<ProData> proDataList   =   null;
        
        //0th total chk
        if (req_total_cnt < 1) {
            out.println("<script>");
            out.println("alert('신청인원이 없습니다. 다시 수정하세요.');");
            out.println("location.href='/index.gne?menuCd="+viewPage+"&pro_no="+proNo+"';");
            out.println("</script>");
            return;
        }
        
        try {
            //1st ART_REQ_ALWAY_CNT 모든 pro_no 삭제
            sql     =   new StringBuffer();
            sql.append(" DELETE FROM ART_REQ_ALWAY_CNT WHERE REQ_NO = ? ");

            result  =   jdbcTemplate.update(sql.toString(), new Object[]{req_no});
            
            //2nd proNo 다시 insert
            if (result > 0) {
                result  =   0;

                sql     =   new StringBuffer();
                sql_str     =   "INSERT INTO ART_REQ_ALWAY_CNT ";
                sql_str     +=  " ( ";
                sql_str     +=  " REQ_NO ";
                sql_str     +=  " , PRO_NO ";
                sql_str     +=  " , PRO_NAME ";
                sql_str     +=  " , REQ_PER ";
                sql_str     +=  " , REQ_DATE ";
                sql_str     +=  " , ETC2 ";
                sql_str     +=  " ) ";
                sql_str     +=  " VALUES ( ";
                sql_str     +=  " ? ";
                sql_str     +=  " , ? ";
                sql_str     +=  " , (SELECT PRO_NAME FROM ART_PRO_ALWAY WHERE PRO_NO = ? ) ";
                sql_str     +=  " , ? ";
                sql_str     +=  " , ? ";
                sql_str     +=  " , ? ";
                sql_str     +=  " ) ";
                sql.append(sql_str);
                
                result = jdbcTemplate.update(sql_str, req_no, proNo, proNo, req_per, req_date, etc2);
            }

            //3rd ART_REQ_ALWAY update
            if (result > 0) {
                
                result  =   0;
                
                sql     =   new StringBuffer();
                sql_str =   " UPDATE ART_REQ_ALWAY SET ";
                sql_str +=  " SCH_MNG_NM = ? ";
                sql_str +=  " , SCH_MNG_TEL = ? ";
                sql_str +=  " , SCH_MNG_MAIL = ? ";
                sql_str +=  " , MOD_DATE = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') ";
                sql_str +=  " , REG_IP = ? ";
                sql_str +=  " , REQ_CNT = ? ";
                sql_str +=  " , SCH_LEAD_NM = ? ";
                sql_str +=  " , SCH_LEAD_TEL = ? ";
                sql_str +=  " WHERE REQ_NO = ? ";
                sql.append(sql_str);
                
                insObj = new Object[]{
                    sch_mng_name
                    , sch_mng_tel
                    , sch_mng_mail
                    , request.getRemoteAddr()
                    , req_total_cnt
                    , sch_lead_name
                    , sch_lead_tel
                    , req_no
                };
                
                result = jdbcTemplate.update(
                    sql.toString()
                    , insObj
                );
            }
            
        } catch(Exception e) {
            out.println(e.toString());
        } finally {
            if(result > 0){
                out.println("<script>");
                out.println("alert('정상적으로 처리되었습니다.');");
                out.println("location.href='/index.gne?menuCd="+confirmPage+"&req_no="+ req_no +"&req_date="+ req_date +"&pro_no="+proNo+"';");
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
            sql_str =   " UPDATE ART_REQ_ALWAY SET ";
            sql_str +=  " APPLY_FLAG    =   'Y' ";
            sql_str +=  " , MOD_DATE = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') ";
            sql_str +=  " , APPLY_DATE = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24MISS') ";
            sql_str +=  " WHERE REQ_NO = ? ";
            sql.append(sql_str);
            
            result  =   jdbcTemplate.update(sql.toString(), new Object[]{req_no});
            
        }catch(Exception e){
            out.println(e.toString());
        }finally{
            if (result > 0) {
                out.println("<script>");
                out.println("alert('정상적으로 처리되었습니다.');");
                out.println("location.href='/program/art/admin/alwaysReq.jsp';");
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
            sql_str     =   " UPDATE ART_REQ_ALWAY SET                                  ";
            sql_str     +=  " APPLY_FLAG = ?                                            ";
            sql_str     +=  " , MOD_DATE = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')    ";
            sql_str     +=  " , APPLY_DATE = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24MISS')    ";
            sql_str     +=  " WHERE REQ_NO = ?                                          ";
            sql.append(sql_str);

            result      =   jdbcTemplate.update(sql.toString(), new Object[]{canAdmin, req_no});
        
        }catch(Exception e){
            out.println(e.toString());
        }finally{
            if (result > 0) {
                out.println("<script>");
                out.println("alert('정상적으로 처리되었습니다.');");
                if (canAdmin.equals("A")) out.println("location.href='/program/art/admin/alwaysReq.jsp';");
                else out.println("location.href='/index.gne?menuCd="+viewPage+"';");
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
    out.println("location.href='/index.gne?menuCd="+viewPage+"';");
    out.println("</script>");
    return;
}

%>