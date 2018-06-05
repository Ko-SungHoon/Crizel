<%@page contentType="APPLICATION/OCTET-STREAM"%>
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>
<%@page import="java.io.*,java.util.*"%>

<%!
    private class GsndLectureFile {
      public int lectfileno;
      public int lectno;
      public String filename;
      public long filesize;
      public String realname;
      public String regdate;
      public String regtime;
    }
%>
<%
  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
  
  String fileQuery = "SELECT * FROM GSND_LECTURE_FILE WHERE LECTNO = ? AND LECTFILENO = ?";
  GsndLectureFile lectFile = jdbcTemplate.queryForObject(fileQuery, 
    new Object[]{request.getParameter("lectno"), request.getParameter("lectfileno")}, 
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

  File uploadFile = new File(request.getServletContext().getRealPath("/upload_data/lecture/" + lectFile.realname));
  if( uploadFile.exists() ) {
    String filename = new String(lectFile.filename.getBytes("EUC-KR"), "8859_1");
    FileInputStream in = new FileInputStream(uploadFile);
    OutputStream os = null;
    try {
      response.reset();
      response.setHeader("Content-Disposition", "attachment; filename=\""+ filename + "\"");
      os = response.getOutputStream();
      byte b [] = new byte[1024];
      int data = 0;
      while((data=(in.read(b, 0, b.length))) != -1) {
        os.write(b, 0, data);
      }
    } finally {
      if(in != null ) in.close();
      if(os != null) os.close();
    }
    out.println("<script language='javascript'>alert('File Not Exists!');</script>");
  }
%>