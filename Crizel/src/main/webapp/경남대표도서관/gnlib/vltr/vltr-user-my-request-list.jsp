<%@page contentType="text/html;charset=utf-8"%>

<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>

<%! //GSND_VOLUNTEER_REQUEST
  public class GsndVolunteerMyRequest {
    String vltrno;
    String vltrdate;
    String vltrtime1;
    String vltrtime2;
    String vltrloc;

    String vltrstcd;
    String userid;
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

  private class GsndVolunteerMyRequestMapper implements RowMapper<GsndVolunteerMyRequest> {
    public GsndVolunteerMyRequest mapRow(ResultSet rs, int rowNum) throws SQLException {
      GsndVolunteerMyRequest vo = new GsndVolunteerMyRequest();
      vo.vltrno = rs.getString("VLTRNO");
      vo.vltrdate = rs.getString("VLTRDATE");
      vo.vltrtime1 = rs.getString("VLTRTIME1");
      vo.vltrtime2 = rs.getString("VLTRTIME2");
      vo.vltrloc = rs.getString("VLTRLOC");

      vo.vltrno = rs.getString("VLTRNO");
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
%>

<%
  String userid = "userid";

  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

  String queryRequestList = "";
  queryRequestList += " SELECT A1.VLTRNO, A1.VLTRDATE, A1.VLTRTIME1, A1.VLTRTIME2, A1.VLTRLOC ";
  queryRequestList += " , USERID, VLTRSTCD, BIRTHDAY, USERNAME, EMAIL, TEL1, TEL2, TEL3, HP1, HP2, HP3 ";
  queryRequestList += " , ZIPCD, ADDR1, ADDR2, SCHLNM, SCHLGRD, A2.REGDATE, A2.REGTIME ";
  queryRequestList += " FROM GSND_VOLUNTEER_WORK A1, GSND_VOLUNTEER_REQUEST A2 ";
  queryRequestList += " WHERE A1.VLTRNO = A2.VLTRNO ";
  queryRequestList += "   AND A2.USERID = ? ";
  queryRequestList += " ORDER BY VLTRDATE DESC ";

  List<GsndVolunteerMyRequest> list = jdbcTemplate.query(queryRequestList, new Object[]{userid}, new GsndVolunteerMyRequestMapper() );
%>

<table class="tb_board">
  <caption>자원봉사 신청 목록</caption>
  <thead>
    <tr>
      <th>번호</th>
      <th>자원봉사 일자</th>
      <th>자원봉사 시간</th>
      <th>자원봉사 장소</th>
      <th>신청일자</th>
      <th>처리상태</th>
      <th>비고</th>
    </tr>
  </thead>
  <tbody>
    <%  int i = 1; for(GsndVolunteerMyRequest entity : list) {%>
    <tr>
      <td><%= i++ %></td>
      <td><%= entity.vltrdate %></td>
      <td><%= entity.vltrtime1 %> ~ <%= entity.vltrtime2 %></td>
      <td><%= entity.vltrloc %></td>
      <td><%= entity.regdate %> <%= entity.regtime %></td>
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
        <% if(!"CANCEL_ADMIN".equals(entity.vltrstcd) && !"CANCEL_USER".equals(entity.vltrstcd) ) { %>
        <button type="button" class="btn_type1 btn_type_s color1" onclick="vltrUserProcess('<%= entity.vltrno%>', 'CANCEL_USER');">취소</button>
        <% } %>
      </td>
    </tr>
    <%  } %>

    <% if( list.size() == 0 ) { %>
    <tr>
      <td colspan="6" align="center">등록된 내역이 없습니다.</td>
    </tr>
    <% } %>
  </tbody>
</table>

<script language="javascript">
  function vltrUserProcess(vltrno, vltrstcd) {
    $.ajax({
      method: 'POST',
      url: "index.lib?contentsSid=125",
      data: {vltreqmode: 'CHANGE_STATECD', vltrno: vltrno, vltrstcd: vltrstcd}
    }).done(function( msg ) {
      alert("처리 되었습니다.");
      location.reload();
    });
  }
</script>