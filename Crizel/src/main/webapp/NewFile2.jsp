<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="egovframework.rfc3.iam.manager.ViewManager"%>
<%@page import="egovframework.rfc3.user.web.SessionManager"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper"%>

<%!
  // 수강 접수 여부
  private boolean isRcrtAble(GsndStoryTelling entity) {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHH:mm");
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

  private class GsndStoryTelling {
    public String stno;
    public String title;
    public String lecturer;
    public String attendee;
    public String charge;
    public String chargetel;
    public String stdate;
    public String sttime;
    public String stloc;
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

  private class GsndStoryTellingMapper implements RowMapper<GsndStoryTelling> {
    public GsndStoryTelling mapRow(ResultSet rs, int rowNum) throws SQLException {
      GsndStoryTelling vo = new GsndStoryTelling();
      vo.stno = rs.getString("stno");
      vo.title = rs.getString("title");
      vo.lecturer = rs.getString("lecturer");
      vo.attendee = rs.getString("attendee");
      vo.charge = rs.getString("charge");
      vo.chargetel = rs.getString("chargetel");
      vo.stdate = rs.getString("stdate");
      vo.sttime = rs.getString("sttime");
      vo.stloc = rs.getString("stloc");
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
  
 class SMSService {
	private final JdbcTemplate jdbcTemplate;
	
	private String queryRegister = ""
			+ " INSERT INTO NURI_MSG_DATA(MSG_SEQ, CUR_STATE, REQ_DATE, CALL_TO, CALL_FROM, SMS_TXT, MSG_TYPE) "
			+ " SELECT MSG_DATA_SEQ.NEXTVAL, 0, SYSDATE, USERTEL1||USERTEL2||USERTEL3, '0552544867', '['|| SUBSTR(TITLE,1, 7) || '..' ||']신청완료 ['|| STLOC ||']로 '|| SUBSTR(STDATE,5,2)|| '.' || SUBSTR(STDATE,7) ||'에 참석바랍니다.', 4 "
			+ " FROM GSND_STORY_TELLING A1,GSND_STORY_TELLING_REGISTER A2 "
			+ " WHERE A1.STNO = A2.STNO " 
			+ "   AND A2.STNO = ? AND A2.USERID = ?";
	
	private String queryCancel = ""
			+ " INSERT INTO NURI_MSG_DATA(MSG_SEQ, CUR_STATE, REQ_DATE, CALL_TO, CALL_FROM, SMS_TXT, MSG_TYPE) "
			+ " SELECT MSG_DATA_SEQ.NEXTVAL, 0, SYSDATE, USERTEL1||USERTEL2||USERTEL3, '0552544867', '['|| SUBSTR(TITLE, 1, 24) ||'] 신청이 취소되었습니다.', 4  "
			+ " FROM GSND_STORY_TELLING A1, GSND_STORY_TELLING_REGISTER A2 "
			+ " WHERE A1.STNO = A2.STNO AND A2.STNO = ? AND A2.USERID = ?";
	
	SMSService(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}
	
	void sendRegister(String lectno, String userid) {
		jdbcTemplate.update(queryRegister, lectno, userid);
	}
	
	void sendCancel(String lectno, String userid) {
		jdbcTemplate.update(queryCancel, lectno, userid);
	}
}  
  
%>


<%
try{
	
  SessionManager sessionManager = new SessionManager(request);
  ViewManager viewManager = new ViewManager(request, response);

  String rgstmode = (request.getParameter("rgstmode") == null ) ? "" : request.getParameter("rgstmode");

  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
  SMSService smsService = new SMSService(jdbcTemplate);

  boolean isAdmin = sessionManager.isRoleAdmin() || viewManager.isGranted(request, "DOM_000000203006000000", "WRITE");
  String userid = (isAdmin ) ? request.getParameter("userid") : EgovUserDetailsHelper.getId();
  String username = (isAdmin ) ? request.getParameter("username") : EgovUserDetailsHelper.getName();
  String stno = (request.getParameter("stno") == null ) ? "" : request.getParameter("stno");
  String rgstmethod = (request.getParameter("rgstmethod") == null ) ? "" : request.getParameter("rgstmethod");


  if("REGISTER".equals(rgstmode)) {
    // 등록
  
    // 총원 확인
    StringBuilder query = new StringBuilder();
    query.append(" SELECT C1.*  ");
    query.append("     , (SELECT COUNT(*) FROM GSND_STORY_TELLING_REGISTER WHERE STNO = C1.STNO AND RGST_METHOD='VISIT' AND STATECD = 'RGST') RGST_VISIT");
    query.append("     , (SELECT COUNT(*) FROM GSND_STORY_TELLING_REGISTER WHERE STNO = C1.STNO AND RGST_METHOD='ONLINE' AND STATECD = 'RGST') RGST_ONLINE");
    query.append("     , (SELECT COUNT(*) FROM GSND_STORY_TELLING_REGISTER WHERE STNO = C1.STNO AND RGST_METHOD='TEL' AND STATECD = 'RGST') RGST_TEL");
    query.append(" FROM GSND_STORY_TELLING C1 ");
    query.append(" WHERE STNO = ? ");

    GsndStoryTelling entity = jdbcTemplate.queryForObject(query.toString(), new Object[]{stno}, new GsndStoryTellingMapper() );

    // 접수 인원 체크
    if(entity.getRgstTotal() >= entity.rcrt_total) {
      out.println("더이상 수강생을 접수 받을 수 없습니다.");
      return;
    }


    // 온라인 접수 가능 체크
    if("ONLINE".equals(rgstmethod) && entity.rgst_online >= entity.rcrt_online) {
      out.println("<span style='color:#FF0000;'><b>[접수 실패] 온라인으로 더이상 수강생을 접수 받을 수 없습니다.</b></span>");
      return;
    }

    // 모집 기간 체크
    if(! isRcrtAble(entity)) {
      out.println("<span style='color:#FF0000;'><b>[접수 실패] 수강생 모집 기간이 아닙니다.</b></span>");
      return;
    }

    // 중복 등록 제거
    int cnt = jdbcTemplate.queryForInt("SELECT COUNT(*) FROM GSND_STORY_TELLING_REGISTER WHERE STATECD = 'RGST' AND STNO = ? AND USERID = ?", stno, userid);
    if( cnt != 0 ) {
      out.println("<span style='color:#FF0000;'><b>[접수 실패] 이미 수강 신청 한 강좌 입니다.</b></span>");
      return;
    }

    // 기존 취소 신청 내역 삭제 
    jdbcTemplate.update("DELETE FROM GSND_STORY_TELLING_REGISTER WHERE STNO = ? AND USERID = ?", stno, userid);

    String usertel1 = (request.getParameter("usertel1") == null ) ? "" : request.getParameter("usertel1");
    String usertel2 = (request.getParameter("usertel2") == null ) ? "" : request.getParameter("usertel2");
    String usertel3 = (request.getParameter("usertel3") == null ) ? "" : request.getParameter("usertel3");

    String queryInsert = "INSERT INTO GSND_STORY_TELLING_REGISTER(STNO, USERID, USERNAME, USERTEL1, USERTEL2, USERTEL3, RGST_METHOD, REGDATE, REGTIME, STATECD) VALUES(?, ?, ?, ?, ?, ?, ?, TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'), 'RGST')";
    jdbcTemplate.update(queryInsert, stno, userid, username, usertel1, usertel2, usertel3, rgstmethod);
    smsService.sendRegister(stno, userid);
    out.println("접수 신청을 완료 하였습니다.");
  } else if("CANCEL_REGISTER".equals(rgstmode)) {
    String queryCancel = "UPDATE GSND_STORY_TELLING_REGISTER SET STATECD = 'CNCL_USER', MODDATE = TO_CHAR(SYSDATE, 'YYYYMMDD'), MODTIME = TO_CHAR(SYSDATE, 'HH24MISS') WHERE STNO = ? AND USERID = ?";
    jdbcTemplate.update(queryCancel, stno, userid);
    smsService.sendCancel(stno, userid);
    out.println("접수를 취소 하였습니다.");
  } else if("ADMIN_CANCEL_REGISTER".equals(rgstmode)) {
    String queryCancel = "UPDATE GSND_STORY_TELLING_REGISTER SET STATECD = 'CNCL_ADMIN', MODDATE = TO_CHAR(SYSDATE, 'YYYYMMDD'), MODTIME = TO_CHAR(SYSDATE, 'HH24MISS') WHERE STNO = ? AND USERID = ?";
    jdbcTemplate.update(queryCancel, stno, userid);
    smsService.sendCancel(stno, userid);
    out.println("접수를 취소 하였습니다.");
  }
}catch(Exception e){
 out.println(e);
}
%>                                             