<%@page contentType="text/html;charset=utf-8"%>
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>

<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>

    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/jquery.form/4.2.2/jquery.form.min.js" integrity="sha384-FzT3vTVGXqf7wRfy8k4BiyzvbNfeYjK+frTVqZeNDFl8woCbF0CYG6g2fMEFFo/i" crossorigin="anonymous"></script>

    <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">
    <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>

<%!
  private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-ddHH:mm");

  private boolean isRcrtBefore(GsndMyLectureRegister entity) {
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
  private boolean isRcrtAble(GsndMyLectureRegister entity) {
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
  private boolean isRcrtOver(GsndMyLectureRegister entity) {
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
  private boolean isLecturing(GsndMyLectureRegister entity) {
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
  private boolean isLectureOver(GsndMyLectureRegister entity) {
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
  private String printLectureStatus(GsndMyLectureRegister entity) {
    if(isRcrtAble(entity)) return "모집중";

    if(isLecturing(entity)) return "교육중";

    if(isLectureOver(entity)) return "교육 종료";

    if(isRcrtOver(entity)) return "모집 종료";

    return "";
  }

  private class GsndMyLectureRegister {
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
    public String lectdesc;
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

    public String userid;
    public String username;
    public String usertel1;
    public String usertel2;
    public String usertel3;
    public String rgst_method;
    public String regdate;
    public String regtime;

    public int getRgstTotal() {
      return this.rgst_visit + this.rgst_online + this.rgst_tel;
    }

    public String printRgstMethod() {
      if( "VISIT".equals(rgst_method) ) return "방문접수";
      if( "ONLINE".equals(rgst_method) ) return "온라인접수";
      if( "TEl".equals(rgst_method) ) return "전화접수";
      
      return "";
    }
  }

  private class GsndMyLectureRegisterMapper implements RowMapper<GsndMyLectureRegister> {
    public GsndMyLectureRegister mapRow(ResultSet rs, int rowNum) throws SQLException {
      GsndMyLectureRegister vo = new GsndMyLectureRegister();
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
      vo.lectdesc = rs.getString("lectdesc");
      vo.rcrt_sdate = rs.getString("rcrt_sdate");
      vo.rcrt_stime = rs.getString("rcrt_stime");
      vo.rcrt_edate = rs.getString("rcrt_edate");
      vo.rcrt_etime = rs.getString("rcrt_etime");
      vo.rcrt_method = rs.getString("rcrt_method");
      vo.rcrt_total = rs.getInt("rcrt_total");
      vo.rcrt_online = rs.getInt("rcrt_online");
      vo.rcrt_add = rs.getInt("rcrt_add");

      vo.rgst_visit = rs.getInt("rgst_visit");
      vo.rgst_online = rs.getInt("rgst_online");
      vo.rgst_tel = rs.getInt("rgst_tel");

      vo.userid = rs.getString("userid");
      vo.username = rs.getString("username");
      vo.usertel1 = rs.getString("usertel1");
      vo.usertel2 = rs.getString("usertel2");
      vo.usertel3 = rs.getString("usertel3");
      vo.rgst_method = rs.getString("rcrt_method");
      vo.regdate = rs.getString("regdate");
      vo.regtime = rs.getString("regtime");
      
      return vo;
    }
  }

%>

<%
  String userid = EgovUserDetailsHelper.getId();

  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

  StringBuilder query = new StringBuilder();
  query.append(" SELECT A1.LECTNO, A1.TITLE, A1.COURSE, A1.LECTURER, A1.ATTENDEE, A1.CHARGE, A1.CHARGETEL ");
  query.append(" 	, A1.LECTSDATE, A1.LECTEDATE, A1.TUITION, A1.LECTLOC, A1.STATUS, A1.LECTDESC ");
  query.append(" 	, A1.RCRT_SDATE, A1.RCRT_STIME, A1.RCRT_EDATE, A1.RCRT_ETIME, A1.RCRT_METHOD ");
  query.append(" 	, A1.RCRT_TOTAL, A1.RCRT_ONLINE, A1.RCRT_ADD ");
  query.append(" 	, A2.USERID, A2.USERNAME, A2.USERTEL1, A2.USERTEL2, A2.USERTEL3, A2.RGST_METHOD, A2.REGDATE, A2.REGTIME ");
  query.append("  , (SELECT COUNT(*) FROM GSND_LECTURE_REGISTER WHERE LECTNO = A1.LECTNO AND RGST_METHOD='VISIT') RGST_VISIT");
  query.append("  , (SELECT COUNT(*) FROM GSND_LECTURE_REGISTER WHERE LECTNO = A1.LECTNO AND RGST_METHOD='ONLINE') RGST_ONLINE");
  query.append("  , (SELECT COUNT(*) FROM GSND_LECTURE_REGISTER WHERE LECTNO = A1.LECTNO AND RGST_METHOD='TEL') RGST_TEL");
  query.append(" FROM GSND_LECTURE A1, GSND_LECTURE_REGISTER A2 ");
  query.append(" WHERE A1.LECTNO = A2.LECTNO ");
  query.append("   AND A2.USERID = ? ");
  query.append(" ORDER BY A2.REGDATE DESC, A2.REGTIME DESC ");

  List<GsndMyLectureRegister> list = jdbcTemplate.query(query.toString(), new Object[]{ userid }, new GsndMyLectureRegisterMapper() );
%>

<h4 class="bl_h4">수강신청 내역</h4>
<table class="tb_board lecture">
  <thead>
    <tr>
      <th>번호</th>
      <th>강좌 정보</th>
      <th>강의 장소</th>
      <th>접수 정보</th>
      <th>등록일자</th>
      <th>등록시간</th>
      <th>비고</th>
    </tr>
  </thead>
  <tbody>
    <% int i=1; for(GsndMyLectureRegister entity : list) { %>
    <tr align="center">
      <td><%= i++ %></td>
      <td align="left">
        <div>[<%= printLectureStatus(entity) %>] <%= entity.title %></div>
        <div>모집기간: <%= entity.rcrt_sdate %> ~ <%= entity.rcrt_edate %></div>
        <div>교육기간: <%= entity.lectsdate %> ~ <%= entity.lectedate %></div>
      </td>
      <td><%= entity.lectloc %></td>
      <td><%= entity.username %> (<%= entity.userid %>)</td>
      <td><%= entity.regdate %></td>
      <td><%= entity.regtime %></td>
      <td>
      <% if(isRcrtAble(entity)) { %>
        <button type="button" class="btn medium color1" onclick="cancelLectureRegister('<%= entity.lectno %>')">접수취소</button>
      <% } %>
       </td>
    </tr>
    <% } %>
  </tbody>
</table>

<script language="javascript">
  function cancelLectureRegister(lectno) {
    if( confirm('수강신청을 취소하시겠습니까?') ) {
      $.ajax({
        url:'rgst-action.jsp',
        data: {'lectno': lectno, 'rgstmode': 'CANCEL_REGISTER'}
      }).done(function() {
        location.reload();
      });
    }
  }
</script>