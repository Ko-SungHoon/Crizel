<%@page contentType="text/html;charset=utf-8"%>

<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="java.util.*, java.io.*, java.sql.*"%>
<%@page import="javax.sql.DataSource" %>

<%!
  private class GsndLectureFile {
    public int lectfileno;
    public String filename;
    public long filesize;
    public String realname;
  }
%>

<%
  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

  String fileQuery = "SELECT * FROM GSND_LECTURE_FILE WHERE LECTNO = ?";
  List<GsndLectureFile> lectFiles = jdbcTemplate.query(fileQuery, 
    new Object[]{ request.getParameter("lectno")}, 
    new RowMapper<GsndLectureFile>() {
      public GsndLectureFile mapRow(ResultSet rs, int rowNum) throws SQLException {
        GsndLectureFile lectfile = new GsndLectureFile();
        lectfile.lectfileno = rs.getInt("lectfileno");
        lectfile.filename = rs.getString("filename");
        lectfile.filesize = rs.getLong("filesize");
        lectfile.realname = rs.getString("realname");
        return lectfile;
      }
    });
  for(GsndLectureFile lectFile : lectFiles) {
    new File(request.getServletContext().getRealPath("/upload_data/lecture/"), lectFile.realname).delete();
  }

  jdbcTemplate.update("DELETE FROM GSND_LECTURE_REGISTER  WHERE LECTNO = ?", request.getParameter("lectno"));
  jdbcTemplate.update("DELETE FROM GSND_LECTURE_FILE  WHERE LECTNO = ?", request.getParameter("lectno"));
  jdbcTemplate.update("DELETE FROM GSND_LECTURE WHERE LECTNO = ?", request.getParameter("lectno"));

  response.sendRedirect("lect-list.jsp");
%>