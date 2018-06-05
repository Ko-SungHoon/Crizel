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

  StringBuilder  sql = new StringBuilder("INSERT INTO GSND_LECTURE( LECTNO");
  sql.append("  , TITLE, COURSE, LECTURER, ATTENDEE, CHARGE");        //5
  sql.append("  , CHARGETEL, LECTSDATE, LECTEDATE, TUITION, LECTLOC");    //5
  sql.append("  , LECTDESC");      //1
  sql.append("  , RCRT_SDATE, RCRT_STIME, RCRT_EDATE, RCRT_ETIME");   //4
  sql.append("  , RCRT_METHOD, RCRT_TOTAL, RCRT_ONLINE");   //4
  sql.append("  , REGDATE, REGTIME "); // 2
  sql.append(" )");
  sql.append("VALUES(SEQ_GSND_LECTURE_LECTNO.NEXTVAL");
  sql.append("  , ?, ?, ?, ?, ?");
  sql.append("  , ?, ?, ?, ?, ?");
  sql.append("  , ?");
  sql.append("  , ?, ?, ?, ?");
  sql.append("  , ?, ?, ?");
  sql.append("  , TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS')");
  sql.append(")");

  jdbcTemplate.update(sql.toString()
    , new Object[]{
        params.get("title"), params.get("course"), params.get("lecturer"), params.get("attendee"), params.get("charge")
      , params.get("chargetel"), params.get("lectsdate"), params.get("lectedate"), params.get("tuition"), params.get("lectloc")
      , params.get("lectdesc")
      , params.get("rcrt_sdate"), params.get("rcrt_stime"), params.get("rcrt_edate"), params.get("rcrt_etime")
      , params.get("rcrt_method"), params.get("rcrt_total"), params.get("rcrt_online")
    }
  );
  
  for(GsndLectureFile lectFile : files) {
    jdbcTemplate.update("INSERT INTO GSND_LECTURE_FILE VALUES(SEQ_GSND_LECTURE_FILENO.NEXTVAL, SEQ_GSND_LECTURE_LECTNO.CURRVAL, ?, ?, ?, TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'))"
      , new Object[]{ lectFile.filename, lectFile.filesize, lectFile.realname }
    );
  }
%>