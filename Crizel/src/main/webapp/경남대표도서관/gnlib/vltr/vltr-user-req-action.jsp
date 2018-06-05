<%@page contentType="text/html;charset=utf-8"%>

<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>

<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>

<%! //GSND_VOLUNTEER_WORK
  public class GsndVolunteerWork {
    public String vltrno;
    public String vltrdate;
    private String vltrtime1;
    private String vltrtime2;
    private String vltrloc;
    private int vltrcnt;
    private String regdate;
    private String regtime;
    private String moddate;
    private String modtime;

    private int reqcnt;

    public boolean isFull() {
      return reqcnt >= vltrcnt;
    }
  }

  private class GsndVolunteerWorkMapper implements RowMapper<GsndVolunteerWork> {
    public GsndVolunteerWork mapRow(ResultSet rs, int rowNum) throws SQLException {
      GsndVolunteerWork vo = new GsndVolunteerWork();
      vo.vltrno = rs.getString("VLTRNO");
      vo.vltrdate = rs.getString("VLTRDATE");
      vo.vltrtime1 = rs.getString("VLTRTIME1");
      vo.vltrtime2 = rs.getString("VLTRTIME2");
      vo.vltrloc = rs.getString("VLTRLOC");
      vo.vltrcnt = rs.getInt("VLTRCNT");
      vo.regdate = rs.getString("REGDATE");
      vo.regtime = rs.getString("REGTIME");
      vo.moddate = rs.getString("MODDATE");
      vo.modtime = rs.getString("MODTIME");

      vo.reqcnt = rs.getInt("REQCNT");
      return vo;
    }
  }
%>

<%
  // from session
  String userid = EgovUserDetailsHelper.getId();
  String username = EgovUserDetailsHelper.getName();

  String vltreqmode = (request.getParameter("vltreqmode") == null ) ? "" : request.getParameter("vltreqmode");
  String vltreqno = (request.getParameter("vltreqno") == null ) ? "" : request.getParameter("vltreqno");
  String vltrno = (request.getParameter("vltrno") == null ) ? "" : request.getParameter("vltrno");
  String birthday = (request.getParameter("birthday") == null ) ? "" : request.getParameter("birthday");
  String email = (request.getParameter("email") == null ) ? "" : request.getParameter("email");
  String tel1 = (request.getParameter("tel1") == null ) ? "" : request.getParameter("tel1");
  String tel2 = (request.getParameter("tel2") == null ) ? "" : request.getParameter("tel2");
  String tel3 = (request.getParameter("tel3") == null ) ? "" : request.getParameter("tel3");
  String hp1 = (request.getParameter("hp1") == null ) ? "" : request.getParameter("hp1");
  String hp2 = (request.getParameter("hp2") == null ) ? "" : request.getParameter("hp2");
  String hp3 = (request.getParameter("hp3") == null ) ? "" : request.getParameter("hp3");
  String zipcd = (request.getParameter("zipcd") == null ) ? "" : request.getParameter("zipcd");
  String addr1 = (request.getParameter("addr1") == null ) ? "" : request.getParameter("addr1");
  String addr2 = (request.getParameter("addr2") == null ) ? "" : request.getParameter("addr2");
  String schlnm = (request.getParameter("schlnm") == null ) ? "" : request.getParameter("schlnm");
  String schlgrd = (request.getParameter("schlgrd") == null ) ? "" : request.getParameter("schlgrd");

  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

  if("REQUEST".equals(vltreqmode)) {
    // insert
    String querySelectWork = "SELECT A1.*, (SELECT COUNT(*) FROM GSND_VOLUNTEER_REQUEST WHERE VLTRNO = A1.VLTRNO AND VLTRSTCD NOT IN ('CANCEL_USER', 'CANCEL_ADMIN') ) REQCNT FROM GSND_VOLUNTEER_WORK A1 WHERE VLTRNO = ?";
    GsndVolunteerWork vltrWork = jdbcTemplate.queryForObject(querySelectWork, new Object[]{vltrno}, new GsndVolunteerWorkMapper() );

    if( vltrWork.isFull() ) {
      out.println("자원봉사 인원이 충분해 더 이상 접수할 수 없습니다.");
    } else {
      String query = "INSERT INTO GSND_VOLUNTEER_REQUEST VALUES(SEQ_GSND_VLTREQNO.NEXTVAL, ?, ?, 'RECEIVE', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'))";
      jdbcTemplate.update(query, new Object[]{ vltrno, userid, username, birthday, email, tel1, tel2, tel3, hp1, hp2, hp3, zipcd, addr1, addr2, schlnm, schlgrd });
      out.println("자원봉사 접수 되었습니다.");
    }
  } else if("MODIFY".equals(vltreqmode)) {
    // update
    String query = "UPDATE GSND_VOLUNTEER_REQUEST SET EMAIL = ?, TEL1 = ?, TEL2 = ?, TEL3 = ?, HP1 = ?, HP2 = ?, HP3 = ?, ZIPCD = ?, ADDR1 = ?, ADDR2 = ?, SCHLNM = ?, SCHLGRD = ? WHERE VLTREQNO = ? AND USERID = ?";
    int rows = jdbcTemplate.update(query, new Object[]{ email, tel1, tel2, tel3, hp1, hp2, hp3, zipcd, addr1, addr2, schlnm, schlgrd, vltreqno, userid });
    out.println("자원봉사 정보를 수정 했습니다.");
  } else if("DELETE".equals(vltreqmode)) {
    // delete
    String queryRequest = "DELETE FROM GSND_VOLUNTEER_REQUEST WHERE VLTREQNO = ? AND USERID = ?";
    int rows = jdbcTemplate.update(queryRequest, new Object[]{ vltreqno, userid });
    out.println("자원봉사 정보를 삭제 했습니다.");
  } else if("CHANGE_STATECD".equals(vltreqmode)) {
    String vltrstcd = (request.getParameter("vltrstcd") == null ) ? "" : request.getParameter("vltrstcd");
    int rows = jdbcTemplate.update("UPDATE GSND_VOLUNTEER_REQUEST SET VLTRSTCD = ? WHERE VLTEQRNO = ? AND USERID = ?", vltrstcd, vltreqno, userid);
  }
%>
