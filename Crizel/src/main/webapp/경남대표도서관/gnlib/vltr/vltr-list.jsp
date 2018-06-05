<%@page contentType="text/html;charset=utf-8"%>

<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>

<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>

<%! //GSND_VOLUNTEER_WORK
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
  String vltrdate = (request.getParameter("vltrdate") == null ) ? "" : request.getParameter("vltrdate");

  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

  String query = "SELECT A1.*, (SELECT COUNT(*) FROM GSND_VOLUNTEER_REQUEST B1 WHERE B1.VLTRNO = A1.VLTRNO AND VLTRSTCD NOT IN ('CANCEL_ADMIN', 'CANCEL_USER')) VLTREQCNT FROM GSND_VOLUNTEER_WORK A1 WHERE VLTRDATE = ?";
  List<GsndVolunteerWork> list = jdbcTemplate.query(query, new Object[]{vltrdate}, new GsndVolunteerWorkMapper() );

%>
<table class="car_table board_write">
  <caption>자원봉사 신청 안내표 입니다. 시간, 장소, 신청현황, 신청하기 여부를 내용을 안내합니다.</caption>
  <colgroup>
    <col style="width:30%;">
    <col style="width:20%;">
    <col style="width:25%;">
    <col style="width:25%;">
  </colgroup>
  <tbody>
    <tr>
      <th scope="row">시간</th>
      <th scope="row">장소</th>
      <th scope="row">신청현황</th>
      <th scope="row">신청하기</th>
    </tr>
    <%  for( GsndVolunteerWork entity : list) { %>
      <tr class="center">
        <td><%= entity.vltrtime1 %> ~ <%= entity.vltrtime2 %></td>
        <td><%= entity.vltrloc %></td>
        <td><%= entity.vltreqcnt %>/<%= entity.vltrcnt %></td>
        <td>
          <% if( !entity.isFull() ) { %>
            <% if(EgovUserDetailsHelper.isRole("ROLE_USER")) {%>
          <button type="button" class="btn_type1 btn_type_s color1" onclick="loadVltrRequestForm('<%= entity.vltrno %>', '<%= entity.vltrdate %>', '<%= entity.vltrtime1 %>', '<%= entity.vltrtime2 %>', '<%= entity.vltrloc %>')">신청</button>
            <% } else { %>
          <button type="button" class="btn_type1 btn_type_s color1" onclick="alert('로그인을 해야 자원봉사 신청이 가능합니다.')">신청</button>
            <% } %>
          <%  } %>

          <% if(EgovUserDetailsHelper.isRole("ROLE_ADMIN")) {%>
          <button type="button" class="btn_type1 btn_type_s color1" onclick="loadVltrRequestList('<%= entity.vltrno %>', '<%= entity.vltrdate %>', '<%= entity.vltrtime1 %>', '<%= entity.vltrtime2 %>', '<%= entity.vltrloc %>', '<%= entity.vltrcnt %>')">신청목록</button>
          <button type="button" class="btn_type1 btn_type_s color1" onclick="openVltrWorkModifyForm('<%= entity.vltrno %>', '<%= entity.vltrdate %>', '<%= entity.vltrtime1 %>', '<%= entity.vltrtime2 %>', '<%= entity.vltrloc %>', '<%= entity.vltrcnt %>')">수정</button>
          <button type="button" class="btn_type1 btn_type_s color1" onclick="confirmVltrWorkDelete('<%= entity.vltrno %>', '<%= entity.vltrdate %>')">삭제</button>
          <% } %>
          <!--<a href="#" class="btn_type1 btn_type_s">신청취소</a>-->
        </td>
      </tr>
    <% } %>

    <% if(list.size() == 0) { %>
      <tr>
        <td colspan="4" align="center">등록된 자원봉사 시간이 없습니다.</td>
      </tr>
    <% } %>
  </tbody>
</table>
