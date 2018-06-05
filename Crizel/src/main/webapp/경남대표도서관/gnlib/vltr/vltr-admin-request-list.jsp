<%@page contentType="text/html;charset=utf-8"%>

<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>

<%! //GSND_VOLUNTEER_REQUEST
  public class GsndVolunteerRequest {
    String vltreqno;
    String vltrno;
    String userid;
    String vltrstcd;
    String username;
    String birthday;
    String email;
    String tel1;
    String tel2;
    String tel3;
    String hp1;
    String hp2;
    String hp3;
    String zipcd;
    String addr1;
    String addr2;
    String schlnm;
    String schlgrd;
    String regdate;
    String regtime;
  }

  private class GsndVolunteerRequestMapper implements RowMapper<GsndVolunteerRequest> {
    public GsndVolunteerRequest mapRow(ResultSet rs, int rowNum) throws SQLException {
      GsndVolunteerRequest vo = new GsndVolunteerRequest();
      vo.vltreqno = rs.getString("vltreqno");
      vo.vltrno = rs.getString("vltrno");
      vo.userid = rs.getString("userid");
      vo.vltrstcd = rs.getString("vltrstcd");
      vo.username = rs.getString("username");
      vo.birthday = rs.getString("birthday");
      vo.email = rs.getString("email");
      vo.tel1 = rs.getString("tel1");
      vo.tel2 = rs.getString("tel2");
      vo.tel3 = rs.getString("tel3");
      vo.hp1 = rs.getString("hp1");
      vo.hp2 = rs.getString("hp2");
      vo.hp3 = rs.getString("hp3");
      vo.zipcd = rs.getString("zipcd");
      vo.addr1 = rs.getString("addr1");
      vo.addr2 = rs.getString("addr2");
      vo.schlnm = rs.getString("schlnm");
      vo.schlgrd = rs.getString("schlgrd");
      vo.regdate = rs.getString("regdate");
      vo.regtime = rs.getString("regtime");
      return vo;
    }
  }

  public class GsndVolunteerWork {
    String vltrno;
    String vltrdate;
    String vltrtime1;
    String vltrtime2;
    String vltrloc;
    int vltrcnt;
    String regdate;
    String regtime;
    String moddate;
    String modtime;

    int vltreqcnt;

    boolean isFull() {
      return vltreqcnt >= vltrcnt;
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

      vo.vltreqcnt = rs.getInt("VLTREQCNT");
      return vo;
    }
  }

%>

<%
  String vltrno = (request.getParameter("vltrno") == null ) ? "" : request.getParameter("vltrno");

  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

  String queryWork = "SELECT A1.*, (SELECT COUNT(*) FROM GSND_VOLUNTEER_REQUEST B1 WHERE B1.VLTRNO = A1.VLTRNO AND VLTRSTCD NOT IN('CANCEL_ADMIN', 'CANCEL_USER') ) VLTREQCNT FROM GSND_VOLUNTEER_WORK A1 WHERE VLTRNO = ?";
  GsndVolunteerWork work = jdbcTemplate.queryForObject(queryWork, new Object[]{vltrno}, new GsndVolunteerWorkMapper() );

  String queryRequest = "SELECT * FROM GSND_VOLUNTEER_REQUEST WHERE VLTRNO = ?";
  List<GsndVolunteerRequest> list = jdbcTemplate.query(queryRequest, new Object[]{vltrno}, new GsndVolunteerRequestMapper() );
%>

<!--
<%= work.vltrdate %>
<%= work.vltrtime1 %> ~ <%= work.vltrtime2 %>
<%= work.vltrloc %>
-->
<h4 class="bl_h4">접수 목록</h4>

<table class="tb_board lecture">
  <caption>자원봉사 신청자 목록</caption>
  <thead>
    <tr>
      <th>번호</th>
      <th>신청자</th>
      <th>연락처</th>
      <th>주소</th>
      <th>등록일자</th>
      <th>상태</th>
      <th>처리</th>
    </tr>
  </thead>
  <tbody>
    <%  int i = 1; for(GsndVolunteerRequest entity : list) {%>
    <tr>
      <td><%= i++ %></td>
      <td>
	<%= entity.username %><BR/>(<%= entity.birthday %>)<br>
        <%= entity.email%><BR>
	<%= (entity.schlnm == null) ? "": entity.schlnm%><%= (entity.schlgrd == null) ? "": entity.schlgrd %>
      </td>
      <td>
        <%= entity.tel1 %>-<%= entity.tel2 %>-<%= entity.tel3 %><br>
        <%= entity.hp1 %>-<%= entity.hp2 %>-<%= entity.hp3 %>
      </td>
      <td align="left">(<%= entity.zipcd %>)<BR><%= entity.addr1 %><BR><%= entity.addr2 %></td>
      <td><%= entity.regdate %><br><%= entity.regtime %></td>
      <td>
	<% if( "RECEIVE".equals(entity.vltrstcd)) { %>
	접수
	<% } else if("APPROVAL".equals(entity.vltrstcd)) { %>
	승인
	<% } else if("ATTEND".equals(entity.vltrstcd)) { %>
	출석
	<% } else if("ABSENCE".equals(entity.vltrstcd)) { %>
	결석
	<% } else if("CANCEL_ADMIN".equals(entity.vltrstcd)) { %>
	관리자 취소
	<% } else if("CANCEL_USER".equals(entity.vltrstcd)) { %>
	사용자 취소
	<% } %>
      </td>
      <td>
        <% if( "RECEIVE".equals(entity.vltrstcd)) { %>
        <button type="button" class="btn_type1 btn_type_s color1" onclick="vltrAdminProcess('<%= entity.vltreqno%>', '<%= entity.vltrno%>', '<%= entity.userid%>', 'APPROVAL');">승인</button>
        <button type="button" class="btn_type1 btn_type_s color1" onclick="vltrAdminProcess('<%= entity.vltreqno%>', '<%= entity.vltrno%>', '<%= entity.userid%>', 'CANCEL_ADMIN');">거부</button>
        <% } else if("APPROVAL".equals(entity.vltrstcd)) { %>
        <button type="button" class="btn_type1 btn_type_s color1" onclick="vltrAdminProcess('<%= entity.vltreqno%>', '<%= entity.vltrno%>', '<%= entity.userid%>', 'ATTEND');">출석</button>
        <button type="button" class="btn_type1 btn_type_s color1" onclick="vltrAdminProcess('<%= entity.vltreqno%>', '<%= entity.vltrno%>', '<%= entity.userid%>', 'ABSENCE');">결석</button>
        <% } %>
      </td>
    </tr>
    <%  } %>

    <% if(list.size() == 0 ) {%>
    <tr>
      <td colspan="9" align="center">신청 내역이 없습니다.</td>
    </tr>
    <% } %>
  </tbody>
