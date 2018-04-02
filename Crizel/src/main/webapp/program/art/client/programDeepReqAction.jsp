<%
/**
*   PURPOSE :   심화프로그램 insert action page
*   CREATE  :   20180222_thur    Ji
*   MODIFY  :   ....
**/
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.rfc3.user.web.SessionManager" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ page import="org.springframework.jdbc.core.*" %>

<%!

    private class ReqData {
        public int req_no;
        
        public int req_per;
        public String apply_flag;
    }

    private class ReqDataList implements RowMapper<ReqData> {
        public ReqData mapRow(ResultSet rs, int rowNum) throws SQLException {
            ReqData reqData     =   new ReqData();
            
            reqData.req_no      =   rs.getInt("REQ_NO");
            
            reqData.apply_flag  =   rs.getString("APPLY_FLAG");
            
            return reqData;
        }
    }

%>
    
<%
    
/** 파라미터 UTF-8처리 **/
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

SessionManager sessionManager   =   new SessionManager(request);

/* Session Chk */
if (sessionManager.getName().trim().equals("") || sessionManager.getId().trim().equals("") || sessionManager.getName().trim().length() < 1 || sessionManager.getId().trim().length() < 1) {
    out.println("<script>");
    out.println("alert('로그인 정보 저장 시간초과 입니다. 다시 로그인 하세요.');");
    out.println("history.back();");
    out.println("</script>");
}

/* default data parameter */
String dataType         =   parseNull(request.getParameter("dataType"), "");    //insert, modify, delete, cancel
String pro_no           =   parseNull(request.getParameter("pro_no"), "");
String req_no           =   parseNull(request.getParameter("req_no"), "");       //only use => modify, delete, cancel

String canAdmin         =   parseNull(request.getParameter("canAdmin"), "C");    //admin cancel flag A=admin, C=client

/* info data */
String req_per          =   parseNull(request.getParameter("req_per"), "0");         //신청인원
//신청인원 0 일때 차단
if (("ins".equals(dataType) || "mod".equals(dataType)) && Integer.parseInt(req_per) < 1) {
    out.println("<script>");
    out.println("alert('신청인원은 무조건 1명 이상입니다.');");
    out.println("history.back();");
    out.println("</script>");
    return;
}
String req_group        =   parseNull(request.getParameter("req_group"), "");       //신청 그룹
String req_user_nm      =   parseNull(request.getParameter("req_user_nm"), "");     //신청자 명
String req_user_tel     =   parseNull(request.getParameter("req_user_tel"), "");    //신청자 전화
String req_user_mail    =   parseNull(request.getParameter("req_user_mail"), "");   //신청자 메일
String req_mot          =   parseNull(request.getParameter("req_mot"), "");         //지원동기

Connection conn         =   null;
PreparedStatement pstmt =   null;

StringBuffer sql 		=   null;
String sql_str          =   null;
Object[] insObj 		=   null;
int result 				=   0;
int count 				=   0;

//insert 후 입력한 req_no value
ReqData reqData         =   null;

//insert
if ("ins".equals(dataType)) {
    
    //신청 입력하기
    sql     =   new StringBuffer();
    sql_str =   " INSERT INTO ART_REQ_DEEP ";
    sql_str +=  " ( ";
    sql_str +=  " REQ_NO ";
    sql_str +=  " , PRO_NO ";
    sql_str +=  " , REQ_USER_ID ";
    sql_str +=  " , REQ_USER_NM ";
    sql_str +=  " , REQ_USER_TEL ";
    sql_str +=  " , REQ_USER_MAIL ";
    sql_str +=  " , REG_DATE ";
    sql_str +=  " , REG_IP ";
    sql_str +=  " , APPLY_FLAG ";
    sql_str +=  " , REQ_PER ";
    sql_str +=  " , REQ_GROUP ";
    sql_str +=  " , REQ_MOT ";
    sql_str +=  " ) ";
    
    sql_str +=  " VALUES ( ";
    sql_str +=  " (SELECT NVL(MAX(REQ_NO) + 1, 1) FROM ART_REQ_DEEP) "; //REQ_NO
    sql_str +=  " , ? ";    //PRO_NO
    sql_str +=  " , ? ";    //REQ_USER_ID
    sql_str +=  " , ? ";    //REQ_USER_NM
    sql_str +=  " , ? ";    //REQ_USER_TEL
    sql_str +=  " , ? ";    //REQ_USER_MAIL
    sql_str +=  " , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') ";    //REG_DATE
    sql_str +=  " , ? ";    //REG_IP
    sql_str +=  " , 'N' ";  //APPLY_FLAG
    sql_str +=  " , ? ";    //REQ_PER
    sql_str +=  " , ? ";    //REQ_GROUP
    sql_str +=  " , ? ";    //REQ_MOT
    sql_str +=  " ) ";
    sql.append(sql_str);
    
    insObj = new Object[]{
        pro_no,
        sessionManager.getId(),
        req_user_nm,
        req_user_tel,
        req_user_mail,
        request.getRemoteAddr(),
        req_per,
        req_group,
        req_mot
    };
    
    result  =   jdbcTemplate.update(sql.toString(), insObj);
    
    //방금 입력한 REQ_NO 추출
    sql     =   new StringBuffer();
    sql.append(" SELECT MAX(REQ_NO) AS REQ_NO, COUNT(REQ_NO) AS APPLY_FLAG FROM ART_REQ_DEEP ");
    
    reqData =   jdbcTemplate.queryForObject(sql.toString(), new ReqDataList());
    
    if(result > 0){
        out.println("<script>");
        out.println("alert('정상적으로 처리되었습니다.');");
        out.println("location.href='/index.gne?menuCd=DOM_000002001002004005&req_no="+ reqData.req_no +"';");
        out.println("</script>");
    } else {
        out.println("<script>");
        out.println("alert('저장되지 않았습니다. 관리자에게 문의하세요.');");
        out.println("location.href='/index.gne?menuCd=DOM_000002001002004002';");
        out.println("</script>");
    }

//update
} else if ("mod".equals(dataType)) {
    
    sql     =   new StringBuffer();
    sql_str =   " UPDATE ART_REQ_DEEP SET ";
    sql_str +=  " REQ_USER_NM = ? ";
    sql_str +=  " , REQ_USER_TEL = ? ";
    sql_str +=  " , REQ_USER_MAIL = ? ";
    sql_str +=  " , MOD_DATE = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') ";
    sql_str +=  " , REQ_GROUP = ? ";
    sql_str +=  " , REQ_MOT = ? ";
    sql_str +=  " , REQ_PER = ? ";
    sql_str +=  " WHERE REQ_NO = ? ";
    sql.append(sql_str);
    
    insObj = new Object[]{
        req_user_nm,
        req_user_tel,
        req_user_mail,
        req_group,
        req_mot,
        req_per,
        req_no
    };
    
    result  =   jdbcTemplate.update(sql.toString(), insObj);
    if(result > 0){
        out.println("<script>");
        out.println("alert('정상적으로 처리되었습니다.');");
        out.println("location.href='/index.gne?menuCd=DOM_000002001002004005&req_no="+ req_no +"';");
        out.println("</script>");
    } else {
        out.println("<script>");
        out.println("alert('저장되지 않았습니다. 관리자에게 문의하세요.');");
        out.println("history.back();");
        out.println("</script>");
    }

//apply
} else if ("app".equals(dataType)) {
    
    //1st. 프로그램 CURR_PER update 하기
    sql     =   new StringBuffer();
    sql_str =   " UPDATE ART_PRO_DEEP SET ";
    sql_str +=  " CURR_PER = ( ";
    sql_str +=  "   (SELECT CURR_PER FROM ART_PRO_DEEP WHERE PRO_NO = (SELECT PRO_NO FROM ART_REQ_DEEP WHERE REQ_NO = ?)) ";
    sql_str +=  "   + (SELECT REQ_PER FROM ART_REQ_DEEP WHERE REQ_NO = ?) ";
    sql_str +=  " ) ";
    sql_str +=  " WHERE PRO_NO = (SELECT PRO_NO FROM ART_REQ_DEEP WHERE REQ_NO = ?) ";
    sql.append(sql_str);
    result  =   jdbcTemplate.update(sql.toString(), new Object[]{req_no, req_no, req_no});
    
    //2nd. ART_REQ_DEEP apply_flag 변경
    if (result > 0) {
        result  =   0;
        
        sql     =   new StringBuffer();
        sql_str =   " UPDATE ART_REQ_DEEP SET ";
        sql_str +=  " APPLY_FLAG = 'Y' ";
        sql_str +=  " , APPLY_DATE = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') ";
        sql_str +=  " , MOD_DATE = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') ";
        sql_str +=  " WHERE REQ_NO = ?";
        sql.append(sql_str);
        result  =   jdbcTemplate.update(sql.toString(), new Object[]{req_no});
    }
    
    if(result > 0){
        out.println("<script>");
        out.println("alert('정상적으로 처리되었습니다.');");
        out.println("location.href='/program/art/admin/deepReq.jsp';");
        out.println("</script>");
    } else {
        out.println("<script>");
        out.println("alert('처리되지 않았습니다. 관리자에게 문의하세요.');");
        out.println("history.back();");
        out.println("</script>");
    }
    
//cancel
} else if ("can".equals(dataType)) {
    
    //1st. 취소 자료 승인여부 확인
    sql     =   new StringBuffer();
    sql.append(" SELECT * FROM ART_REQ_DEEP WHERE REQ_NO = ? ");
    reqData =   jdbcTemplate.queryForObject(sql.toString(), new Object[]{req_no},  new ReqDataList());
    
    //2nd. APPLY_FLAG = 'Y' 일 경우 program curr_per 수정하기
    if ("Y".equals(reqData.apply_flag)) {
        sql =   new StringBuffer();
        sql_str =   " UPDATE ART_PRO_DEEP SET ";
        sql_str +=  " CURR_PER = GREATEST( ";
        sql_str +=  "   (SELECT CURR_PER FROM ART_PRO_DEEP WHERE PRO_NO = (SELECT PRO_NO FROM ART_REQ_DEEP WHERE REQ_NO = ?)) ";
        sql_str +=  "   - (SELECT REQ_PER FROM ART_REQ_DEEP WHERE REQ_NO = ?) ";
        sql_str +=  " , 0) ";
        sql_str +=  " WHERE PRO_NO = (SELECT PRO_NO FROM ART_REQ_DEEP WHERE REQ_NO = ?) ";
        sql.append(sql_str);
        result  =   jdbcTemplate.update(sql.toString(), new Object[]{req_no, req_no, req_no});
        if (result > 0){}
        else {
            out.println("<script>");
            out.println("alert('인원정보 갱신 문제가 발생했습니다. 관리자에게 문의하세요.');");
            out.println("history.back();");
            out.println("</script>");
        }
    }
    
    result  =   0;
    
    //3rd. 신청 취소 update
    sql     =   new StringBuffer();
    sql_str =   " UPDATE ART_REQ_DEEP SET ";
    sql_str +=  " APPLY_FLAG = ? ";
    sql_str +=  " , APPLY_DATE = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') ";
    sql_str +=  " , MOD_DATE = TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') ";
    sql_str +=  " WHERE REQ_NO = ? ";
    sql.append(sql_str);
    insObj = new Object[]{
        canAdmin,
        req_no
    };
    result  =   jdbcTemplate.update(sql.toString(), insObj);
    
    if(result > 0){
        out.println("<script>");
        out.println("alert('정상적으로 처리되었습니다.');");
        if ("A".equals(canAdmin)) {
            out.println("location.href='/program/art/admin/deepReq.jsp';");
        } else {
            out.println("location.href='/index.gne?menuCd=DOM_000002001002004005&req_no="+ req_no +"';");
        }
        out.println("</script>");
    } else {
        out.println("<script>");
        out.println("alert('저장되지 않았습니다. 관리자에게 문의하세요.');");
        out.println("history.back();");
        out.println("</script>");
    }    
    
//fail
} else {

    //type 을 못 받았을 경우
    out.println("<script>");
    out.println("alert('파라미터 값이 부정확 합니다.');");
    out.println("history.back();");
    out.println("</script>");
    return;
    
}



    
%>