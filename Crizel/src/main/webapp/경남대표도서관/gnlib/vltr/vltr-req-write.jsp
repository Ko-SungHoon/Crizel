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
      return vo;
    }
  }
%>

<%
  String vltrno = (request.getParameter("vltrno") == null ) ? "" : request.getParameter("vltrno");

  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

  String query = "SELECT A1.* FROM GSND_VOLUNTEER_WORK A1 WHERE VLTRNO = ?";
  GsndVolunteerWork vltrWork = jdbcTemplate.queryForObject(query, new Object[]{vltrno}, new GsndVolunteerWorkMapper() );

%>    <!--자원봉사 신청 등록-->

    <form action="vltr-req-write-do.jsp">
        <div class="board">
            <table class="board_write">
                <caption>자원봉사 신청 등록 항목입니다.</caption>
                <colgroup>
                    <col style="width:20%;">
                    <col style="width:30%;">
                    <col style="width:20%;">
                    <col style="width:30%;">
                </colgroup>
                <tbody>
                    <tr class="topline">
                        <th scope="row"><span class="c_red">*</span>신청일시</th>
                        <td><%= vltrWork.vltrdate %> <%= vltrWork.vltrtime1 %> ~ <%= vltrWork.vltrtime2 %> </td>
                        <th scope="row"><span class="c_red">*</span>성명</th>
                        <td><%= EgovUserDetailsHelper.getName() %></td>
                    </tr>
                    <tr>
                        <th scope="row">
                            <span class="c_red">*</span><label for="email">이메일</label>
                        </th>
                        <td>
                            <input type="text" name="email" id="email" style="width:90%;" value="<%= EgovUserDetailsHelper.getEmail() %>">
                        </td>
                        <th scope="row">
                            <span class="c_red">*</span><label for="tel">전화번호</label>
                        </th>
                        <td>
                            <input type="text" name="tel" id="tel" style="width:90%;">
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">
                            <span class="c_red">*</span><label for="data">생년월일</label>
                        </th>
                        <td>
                            <input type="text" name="data" id="data" style="width:90%;">
                        </td>
                        <th scope="row">
                            <span class="c_red">*</span><label for="phone">휴대전화번호</label>
                        </th>
                        <td>
                            <input type="text" name="phone" id="phone" style="width:90%;">
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><span class="c_red">*</span>주소</th>
                        <td colspan="3">
                            <div class="tb_bo">
                                <label class="blind" for="postCode">우편번호</label>
                                <input name="postCode" id="postCode" type="text" class="postCode">
                                <a title="새 창" class="btn_type1 btn_type_s1" href="#">우편번호 검색</a>
                            </div>
                            <div class="input_mo">
                                <label class="blind" for="road">주소</label>
                                <input name="road" id="road" type="text" style="width: 40%;">
                                <label class="blind" for="road">주소</label>
                                <input name="road" id="road" type="text" style="width: 50%;">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">
                            <label for="school_name">학교명</label>
                        </th>
                        <td>
                            <input type="text" name="school_name" id="school_name" style="width:90%;">
                        </td>
                        <th scope="row">
                            <label for="grade_class">학년 / 반</label>
                        </th>
                        <td>
                            <input type="text" name="grade_class" id="grade_class" style="width:90%;">
                        </td>
                    </tr>
                </tbody>
            </table>

            <!-- 버튼 영역 -->
            <div class="btn_area center">
                <button type="button" class="btn medium color1 openlayer">신청하기</button>
            </div>
            <!-- //버튼 영역 끝 -->
        </div>
    </form>
