<%@page contentType="text/html;charset=utf-8"%>

<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>


<%@ page import = "java.io.*,java.util.*, java.text.*, javax.servlet.*" %>
<%@ page import = "javax.servlet.http.*" %>
<%@ page import = "org.apache.commons.fileupload.*" %>
<%@ page import = "org.apache.commons.fileupload.disk.*" %>
<%@ page import = "org.apache.commons.fileupload.servlet.*" %>
<%@ page import = "org.apache.commons.io.output.*" %>

<%!
  private class GsndLectureFile {
    public int lectfileno;
    public String filename;
    public long filesize;
    public String realname;
    
    public GsndLectureFile() {}

    public GsndLectureFile(String filename, long filesize, String realname) {
      this.filename = filename;
      this.filesize = filesize;
      this.realname = realname;
    }
  }
%>

<%
  int maxFileSize = 5000 * 1024;

  DiskFileItemFactory factory = new DiskFileItemFactory();

  // Configure a repository (to ensure a secure temp location is used)
  ServletContext servletContext = this.getServletConfig().getServletContext();
//  File repository = (File) servletContext.getAttribute("javax.servlet.context.tempdir");
  Calendar now = Calendar.getInstance();
  SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM");
  String subPath = sdf.format(now.getTime());
  File repository = new File(request.getServletContext().getRealPath("/upload_data/lecture/" + subPath));
  if( !repository.exists() ) {
    repository.mkdirs();
  }
  
  factory.setRepository(repository);

  // Create a new file upload handler
  ServletFileUpload upload = new ServletFileUpload(factory);
  upload.setHeaderEncoding("utf-8");
  upload.setSizeMax(maxFileSize);

  // Parse the request
  List<FileItem> items = upload.parseRequest(request);

  Map<String, String> params = new HashMap<String, String>();

  List<GsndLectureFile> files = new ArrayList<GsndLectureFile>();
  for (FileItem item : items) {
    if (item.isFormField()) {
      String name = item.getFieldName();
      String value = item.getString("UTF-8");
      if( params.containsKey(name) ) {
        value = params.get(name) + "," + value;
      }
      params.put(name, value);
    } else {
      String fieldName = item.getFieldName();
      String fileName = item.getName();
      long sizeInBytes = item.getSize();

      if( sizeInBytes > 0 ) {
        String realName = System.currentTimeMillis() + "-" + fileName;
        item.write(new File(repository,  realName));
        item.delete();

        files.add( new GsndLectureFile( fileName, sizeInBytes, subPath + "/" + realName));
      }
    }
  }

  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

  StringBuilder  sql = new StringBuilder("UPDATE GSND_LECTURE SET ");
  sql.append(" TITLE = ? ");
  sql.append(" , COURSE = ? ");
  sql.append(" , LECTURER = ? ");
  sql.append(" , ATTENDEE = ? ");
  sql.append(" , CHARGE = ? ");
  sql.append(" , CHARGETEL = ? ");
  sql.append(" , LECTSDATE = ? ");
  sql.append(" , LECTEDATE = ? ");
  sql.append(" , TUITION = ? ");
  sql.append(" , LECTLOC = ? ");
  sql.append(" , LECTDESC = ? ");
  sql.append(" , RCRT_SDATE = ? ");
  sql.append(" , RCRT_STIME = ? ");
  sql.append(" , RCRT_EDATE = ? ");
  sql.append(" , RCRT_ETIME = ? ");
  sql.append(" , RCRT_METHOD = ? ");
  sql.append(" , RCRT_TOTAL = ? ");
  sql.append(" , RCRT_ONLINE = ? ");
  sql.append(" WHERE LECTNO = ? ");

  System.out.println(params.get("rcrt_method"));

  jdbcTemplate.update(sql.toString()
    , new Object[]{
        params.get("title"), params.get("course"), params.get("lecturer"), params.get("attendee"), params.get("charge")
      , params.get("chargetel"), params.get("lectsdate"), params.get("lectedate"), params.get("tuition"), params.get("lectloc")
      , params.get("lectdesc")
      , params.get("rcrt_sdate"), params.get("rcrt_stime"), params.get("rcrt_edate"), params.get("rcrt_etime")
      , params.get("rcrt_method"), params.get("rcrt_total"), params.get("rcrt_online")
      , params.get("lectno")
    }
  );
  
  for(GsndLectureFile lectFile : files) {
    jdbcTemplate.update("INSERT INTO GSND_LECTURE_FILE VALUES(SEQ_GSND_LECTURE_FILENO.NEXTVAL, ?, ?, ?, ?, TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'))"
      , new Object[]{ params.get("lectno"), lectFile.filename, lectFile.filesize, lectFile.realname }
    );
  }

  // delete check file
  if( params.get("delfileno") != null ) {
    String[] delfiles = params.get("delfileno").split(",");

    for(String fno : delfiles) {
      String fileQuery = "SELECT * FROM GSND_LECTURE_FILE WHERE LECTNO = ? AND LECTFILENO = ?";
      GsndLectureFile lectFile = jdbcTemplate.queryForObject(fileQuery, 
        new Object[]{params.get("lectno"), fno}, 
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
      new File(request.getServletContext().getRealPath("/upload_data/lecture/"), lectFile.realname).delete();

      jdbcTemplate.update("DELETE FROM GSND_LECTURE_FILE WHERE LECTNO = ? AND LECTFILENO IN (?)"
        , new Object[] {params.get("lectno"), fno}
      );
    }
  }
%>