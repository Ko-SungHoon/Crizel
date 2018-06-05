<%@page contentType="text/html;charset=utf-8"%>

<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper" %>

<%!
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
      public String lectdesc;
      public String rcrt_sdate;
      public String rcrt_stime;
      public String rcrt_edate;
      public String rcrt_etime;
      public String rcrt_method;
      public int rcrt_total;
      public int rcrt_online;
      public int rcrt_add;
    }

    private class GsndLectureFile {
      public int lectfileno;
      public int lectno;
      public String filename;
      public long filesize;
      public String realname;
      public String regdate;
      public String regtime;
    }

    private class GsndLectureRegister {
      public String lectno;
      public String userid;
      public String username;
      public String usertel1;
      public String usertel2;
      public String usertel3;
      public String rgst_method;
      public String regdate;
      public String regtime;

      public String printRgstMethod() {
        if( "VISIT".equals(rgst_method) ) return "방문접수";
        if( "ONLINE".equals(rgst_method) ) return "온라인접수";
        if( "TEl".equals(rgst_method) ) return "전화접수";
        
        return "";
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
        vo.lectdesc = rs.getString("lectdesc");
        vo.rcrt_sdate = rs.getString("rcrt_sdate");
        vo.rcrt_stime = rs.getString("rcrt_stime");
        vo.rcrt_edate = rs.getString("rcrt_edate");
        vo.rcrt_etime = rs.getString("rcrt_etime");
        vo.rcrt_method = rs.getString("rcrt_method");
        vo.rcrt_total = rs.getInt("rcrt_total");
        vo.rcrt_online = rs.getInt("rcrt_online");
        vo.rcrt_add = rs.getInt("rcrt_Add");
        return vo;
      }
    }

    private class GsndLectureRegisterMapper implements RowMapper<GsndLectureRegister> {
      public GsndLectureRegister mapRow(ResultSet rs, int rowNum) throws SQLException {
        GsndLectureRegister vo = new GsndLectureRegister();
        vo.lectno = rs.getString("lectno");
        vo.userid = rs.getString("userid");
        vo.username = rs.getString("username");
        vo.usertel1 = rs.getString("usertel1");
        vo.usertel2 = rs.getString("usertel2");
        vo.usertel3 = rs.getString("usertel3");
        vo.rgst_method = rs.getString("rgst_method");
        vo.regdate = rs.getString("regdate");
        vo.regtime = rs.getString("regtime");
        return vo;
      }
    }
%>

<%
  String lectno = request.getParameter("lectno");
  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
  
  StringBuilder query = new StringBuilder();
  query.append(" SELECT A1.* FROM GSND_LECTURE A1 WHERE LECTNO = ? ");

  GsndLecture entity = jdbcTemplate.queryForObject(query.toString(), new Object[]{ lectno }, new GsndLectureMapper() );
  
  List<GsndLectureFile> lectFiles = jdbcTemplate.query(
    "SELECT * FROM GSND_LECTURE_FILE WHERE LECTNO = ?", 
    new Object[]{lectno}, 
    new RowMapper<GsndLectureFile>() {
      public GsndLectureFile mapRow(ResultSet rs, int rowNum) throws SQLException {
        GsndLectureFile lectfile = new GsndLectureFile();
        int idx = 1;
        lectfile.lectfileno = rs.getInt(idx++);
        lectfile.lectno = rs.getInt(idx++);
        lectfile.filename = rs.getString(idx++);
        lectfile.filesize = rs.getLong(idx++);
        lectfile.realname = rs.getString(idx++);
        lectfile.regdate = rs.getString(idx++);
        lectfile.regtime = rs.getString(idx++);
        return lectfile;
      }
    });

%>

<div class="con">
    <form id="lectViewForm" action="lect-write-do.jsp" method="post">
        <input type="hidden" name="lectno" value="<%= entity.lectno%>">
        <div class="board">
            <fieldset>
                <legend>게시글 입력</legend>
                <table class="board_view">
                    <caption>게시글에 대한 정보 입력</caption>
                    <colgroup>
                      <col style="width:20%">
                      <col style="width:30%">
                      <col style="width:20%">
                      <col style="width:30%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row" class="topline">
                                <label for="title">강좌명</label>
                            </th>
                            <td colspan="3" class="topline">
                              <%=entity.title%>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="lecturer">강사</label></th>
                            <td><%=entity.lecturer%></td>
                            <th scope="row"><label for="attendee">교육대상</label></th>
                            <td><%=entity.attendee%></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="lectsdate">교육일시</label></th>
                            <td>
                              <%=entity.lectsdate%>
                              ~
                              <%=entity.lectedate%>
                            </td>
                            <th scope="row"><label for="course">교육과정</label></th>
                            <td><%=entity.course%></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="lectloc">강의장소</label></th>
                            <td><%=entity.lectloc%></td>
                            <th scope="row"><label for="tuition">수강료</label></th>
                            <td><%=entity.tuition%></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="charge">담당자</label></th>
                            <td><%=entity.charge%></td>
                            <th scope="row"><label for="chargetel">담당자 연락처</label></th>
                            <td><%=entity.chargetel%></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="rcrt_total">모집인원</label></th>
                            <td>
                              <%=entity.rcrt_total%>명
                              (온라인:<%=entity.rcrt_online%>명)
                            </td>
                            <th scope="row"><label for="rcrt_method">접수방법</label></th>
                            <td>
							<div class="etc_ico">
							<p class="badge_guide">
								<%if(entity.rcrt_method != null && entity.rcrt_method.indexOf("RCRT_ONLINE") != -1) { %><span class="badge_i ca1">온라인접수</span> <%	} %>
								<%if(entity.rcrt_method != null && entity.rcrt_method.indexOf("RCRT_VISIT") != -1) { %><span class="badge_i ca2">방문접수</span> <%	} %>
								<%if(entity.rcrt_method != null && entity.rcrt_method.indexOf("RCRT_TEL") != -1) { %><span class="badge_i ca3">전화접수</span> <%	} %>
							</p>
							</div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="rcrt_sdate">모집기간</label></th>
                            <td colspan="3">
                              <%=entity.rcrt_sdate%>
                              <%=entity.rcrt_stime%>
                              ~
                              <%=entity.rcrt_edate%>
                              <%=entity.rcrt_etime%>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="lectdesc">강의소개</label></th>
                            <td colspan="3" height="200" valign="top">
                                <%=entity.lectdesc.replaceAll("\n", "<br>")%>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="file1">첨부파일</label></th>
                            <td colspan="3">

                            <% if(lectFiles.size() == 0) { %>
                              <div>첨부된 파일이 없습니다.</div>
                            <% } %>

                            <% for(GsndLectureFile lectfile : lectFiles) {%>
                                <div id="uploadfield">
                                    <p class="file">
                                        <a href="<%=request.getContextPath() %>/gnlib/lect/lect-download.jsp?lectno=<%= lectfile.lectno %>&lectfileno=<%= lectfile.lectfileno %>"><%= lectfile.filename %></a>
                                        <span class="file_size">(파일크기: <%= (lectfile.filesize / 1024) %> kb)</span>
                                    </p>
                                </div>
                            <% } %>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- 버튼 영역 -->
                <div class="btn_area">
                    <button type="button" class="btn medium color1" onclick="openDialogLectureRegister('<%= entity.lectno %>')">수강신청</button>
                    <button type="button" class="btn medium white" onclick="loadLectList()">목록</button>

                    <% if(EgovUserDetailsHelper.isRole("ROLE_ADMIN")) { %>
                    <!-- 수정, 삭제 -->
                    <button type="button" class="btn medium white" onclick="loadLectModify(<%= entity.lectno %>)">수정</button>
                    <button type="button" id="btnLectDelete" class="btn medium white">삭제</button>
                    <% } %>
                </div>
                <!-- //버튼 영역 끝 -->
            </fieldset>
        </div>
        <!-- //board_write -->
    </form>


    <% 
      if(EgovUserDetailsHelper.isRole("ROLE_ADMIN")) { 
        String queryRegisters = "SELECT * FROM GSND_LECTURE_REGISTER WHERE LECTNO = ? ORDER BY REGDATE, REGTIME";
        List<GsndLectureRegister> rgstList = jdbcTemplate.query(queryRegisters, new Object[]{ lectno }, new GsndLectureRegisterMapper() );
    %>
    <div>
      <h4 class="bl_h4">수강신청 내역</h4>
      <table class="tb_board lecture">
        <thead>
          <tr>
            <th>번호</th>
            <th>이름(아이디)</th>
            <th>등록방법</th>
            <th>등록일자</th>
            <th>등록시간</th>
            <th>비고</th>
          </tr>
        </thead>
        <tbody>
          <% int i=1; for(GsndLectureRegister rgst : rgstList) { %>
          <tr>
            <td><%= i++ %></td>
            <td><%= rgst.username %> (<%= rgst.userid %>)</td>
            <td><%= rgst.printRgstMethod() %></td>
            <td><%= rgst.regdate %></td>
            <td><%= rgst.regtime %></td>
            <td></td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>
    <% } %>
    <!-- 레이어 콘텐츠 -->
</div>

<script language="javascript">
  $(function() {
    $("#btnLectDelete").click(function(){
      if( confirm("강좌를 삭제 하시겠습니까?") ) {
        $.ajax({
          url:"<%= request.getContextPath() %>/gnlib/lect/lect-delete-do.jsp?lectno=<%= entity.lectno %>"
        }).done(function(data){
          loadLectList();
        });
      }
    });
  });
</script>
