<%@page contentType="text/html;charset=utf-8"%>

<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper"%>

<%!
  private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-ddHH:mm");

  private boolean isRcrtBefore(GsndLecture entity) {
    boolean result = false;
    try {
      java.util.Date now = Calendar.getInstance().getTime();
      java.util.Date rcrt_sdate = sdf.parse(entity.rcrt_sdate + entity.rcrt_stime);
      result = now.before(rcrt_sdate);
    } catch(Exception e) {
      System.out.println(e);
    }
    return result;
  }

  // 수강 접수 여부
  private boolean isRcrtAble(GsndLecture entity) {
    boolean result = false;
    try {
      java.util.Date now = Calendar.getInstance().getTime();
      java.util.Date rcrt_sdate = sdf.parse(entity.rcrt_sdate + entity.rcrt_stime);
      java.util.Date rcrt_edate = sdf.parse(entity.rcrt_edate + entity.rcrt_etime);
      result = now.after(rcrt_sdate) && now.before(rcrt_edate);
    } catch(Exception e) {
      System.out.println(e);
    }
    return result;
  }

  // 수강 접수 종료
  private boolean isRcrtOver(GsndLecture entity) {
    boolean result = false;
    try {
      java.util.Date now = Calendar.getInstance().getTime();
      java.util.Date lectsdate = sdf.parse(entity.lectsdate + entity.rcrt_stime);
      java.util.Date rcrt_edate = sdf.parse(entity.rcrt_edate + entity.rcrt_etime);
      result = now.after(rcrt_edate) && now.before(lectsdate);
    } catch(Exception e) {
      System.out.println(e);
    }
    return result;
  }

  // 강의중 여부
  private boolean isLecturing(GsndLecture entity) {
    boolean result = false;
    try {
      java.util.Date now = Calendar.getInstance().getTime();
      java.util.Date lectsdate = sdf.parse(entity.lectsdate + "00:00");
      java.util.Date lectedate = sdf.parse(entity.lectedate + "24:00");
      result = now.after(lectsdate) && now.before(lectedate);
    } catch(Exception e) {
      System.out.println(e);
    }
    return result;
  }

  // 강의 종료 여부
  private boolean isLectureOver(GsndLecture entity) {
    boolean result = false;
    try {
      java.util.Date now = Calendar.getInstance().getTime();
      java.util.Date lectedate = sdf.parse(entity.lectedate + "18:00");
      result = now.after(lectedate);
    } catch(Exception e) {
      System.out.println(e);
    }
    return result;
  }
 
  // 강좌 상태 출력
  private String printLectureStatus(GsndLecture entity) {
    if(isRcrtAble(entity)) return "모집중";

    if(isLecturing(entity)) return "교육중";

    if(isLectureOver(entity)) return "교육 종료";

    if(isRcrtOver(entity)) return "모집 종료";

    return "";
  }

  private class GsndLecture {
    public String lectno;
    public String title;
    public String course;
    public String lecturer;
    public String attendee;
    public String charge;
    public String chargetel;
    public String lectsdate;
    public String lectedate;
    public String tuition;
    public String lectloc;
    public String status;
    public String rcrt_sdate;
    public String rcrt_stime;
    public String rcrt_edate;
    public String rcrt_etime;
    public String rcrt_method;
    public int rcrt_total;
    public int rcrt_online;
    public int rcrt_add;
    public int rgst_visit;
    public int rgst_online;
    public int rgst_tel;

    public int getRgstTotal() {
      return this.rgst_visit + this.rgst_online + this.rgst_tel;
    }
  }

  private class GsndLectureMapper implements RowMapper<GsndLecture> {
    public GsndLecture mapRow(ResultSet rs, int rowNum) throws SQLException {
      GsndLecture vo = new GsndLecture();
      vo.lectno = rs.getString("lectno");
      vo.title = rs.getString("title");
      vo.course = rs.getString("course");
      vo.lecturer = rs.getString("lecturer");
      vo.attendee = rs.getString("attendee");
      vo.charge = rs.getString("charge");
      vo.chargetel = rs.getString("chargetel");
      vo.lectsdate = rs.getString("lectsdate");
      vo.lectedate = rs.getString("lectedate");
      vo.tuition = rs.getString("tuition");
      vo.lectloc = rs.getString("lectloc");
      vo.status = rs.getString("status");
      vo.rcrt_sdate = rs.getString("rcrt_sdate");
      vo.rcrt_stime = rs.getString("rcrt_stime");
      vo.rcrt_edate = rs.getString("rcrt_edate");
      vo.rcrt_etime = rs.getString("rcrt_etime");
      vo.rcrt_method = rs.getString("rcrt_method");
      vo.rcrt_total = rs.getInt("rcrt_total");
      vo.rcrt_online = rs.getInt("rcrt_online");
      vo.rcrt_add = rs.getInt("rcrt_Add");
      vo.rgst_visit = rs.getInt("rgst_visit");
      vo.rgst_online = rs.getInt("rgst_online");
      vo.rgst_tel = rs.getInt("rgst_tel");
      return vo;
    }
  }
%>


<%
  String rgstmode = (request.getParameter("rgstmode") == null ) ? "" : request.getParameter("rgstmode");

  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

  String userid = EgovUserDetailsHelper.getId();
  String username = EgovUserDetailsHelper.getName();
  String lectno = (request.getParameter("lectno") == null ) ? "" : request.getParameter("lectno");
  String rgstmethod = (request.getParameter("rgstmethod") == null ) ? "" : request.getParameter("rgstmethod");


  if("REGISTER".equals(rgstmode)) {
    // 등록
  
    // 총원 확인
    StringBuilder query = new StringBuilder();
    query.append(" SELECT C1.*  ");
    query.append("     , (SELECT COUNT(*) FROM GSND_LECTURE_REGISTER WHERE LECTNO = C1.LECTNO AND RGST_METHOD='VISIT') RGST_VISIT");
    query.append("     , (SELECT COUNT(*) FROM GSND_LECTURE_REGISTER WHERE LECTNO = C1.LECTNO AND RGST_METHOD='ONLINE') RGST_ONLINE");
    query.append("     , (SELECT COUNT(*) FROM GSND_LECTURE_REGISTER WHERE LECTNO = C1.LECTNO AND RGST_METHOD='TEL') RGST_TEL");
    query.append(" FROM GSND_LECTURE C1 ");
    query.append(" WHERE LECTNO = ? ");

    GsndLecture entity = jdbcTemplate.queryForObject(query.toString(), new Object[]{lectno}, new GsndLectureMapper() );

    // 접수 인원 체크
    if(entity.getRgstTotal() >= entity.rcrt_total) {
      out.println("더이상 수강생을 접수 받을 수 없습니다.");
      return;
    }


    // 온라인 접수 가능 체크
    if("ONLINE".equals(rgstmethod) && entity.rgst_online >= entity.rcrt_online) {
      out.println("온라인으로 더이상 수강생을 접수 받을 수 없습니다.");
      return;
    }

    // 모집 기간 체크
    if(! isRcrtAble(entity)) {
      out.println("수강생 모집 기간이 아닙니다.");
      return;
    }

    // 중복 등록 제거
    String queryCheck = "SELECT COUNT(*) FROM GSND_LECTURE_REGISTER WHERE LECTNO = ?, USERID = ?";
    int cnt = jdbcTemplate.queryForInt("SELECT COUNT(*) FROM GSND_LECTURE_REGISTER WHERE LECTNO = ? AND USERID = ?", lectno, userid);
    if( cnt != 0 ) {
      out.println("이미 수강 신청 한 강좌 입니다.");
      return;
    }

    String usertel1 = (request.getParameter("usertel1") == null ) ? "" : request.getParameter("usertel1");
    String usertel2 = (request.getParameter("usertel2") == null ) ? "" : request.getParameter("usertel2");
    String usertel3 = (request.getParameter("usertel3") == null ) ? "" : request.getParameter("usertel3");

    String queryInsert = "INSERT INTO GSND_LECTURE_REGISTER(LECTNO, USERID, USERNAME, USERTEL1, USERTEL2, USERTEL3, RGST_METHOD, REGDATE, REGTIME) VALUES(?, ?, ?, ?, ?, ?, ?, TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'))";

    jdbcTemplate.update(queryInsert, lectno, userid, username, usertel1, usertel2, usertel3, rgstmethod);
    out.println("수강신청을 접수하였습니다.");
  } else if("FAMILY_REGISTER".equals(rgstmode)) {
    //가족 등록
  } else if("CANCEL_REGISTER".equals(rgstmode)) {
    String queryCancel = "DELETE FROM GSND_LECTURE_REGISTER WHERE LECTNO = ? AND USERID = ?";
    jdbcTemplate.update(queryCancel, lectno, userid);
    out.println("수강신청을 취소 하였습니다.");
  }
%>