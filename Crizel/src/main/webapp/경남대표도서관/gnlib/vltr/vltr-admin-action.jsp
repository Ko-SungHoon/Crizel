<%@page contentType="text/html;charset=utf-8"%>

<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>

<%
  String vltrmode = (request.getParameter("vltrmode") == null ) ? "" : request.getParameter("vltrmode");

  String vltrno = (request.getParameter("vltrno") == null ) ? "" : request.getParameter("vltrno");
  String vltrdate = (request.getParameter("vltrdate") == null ) ? "" : request.getParameter("vltrdate");
  String vltrtime1 = (request.getParameter("vltrtime1") == null ) ? "" : request.getParameter("vltrtime1");
  String vltrtime2 = (request.getParameter("vltrtime2") == null ) ? "" : request.getParameter("vltrtime2");
  String vltrloc = (request.getParameter("vltrloc") == null ) ? "" : request.getParameter("vltrloc");
  String vltrcnt = (request.getParameter("vltrcnt") == null ) ? "" : request.getParameter("vltrcnt");

  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

  if("WRITE".equals(vltrmode)) {
    String query = "INSERT INTO GSND_VOLUNTEER_WORK VALUES(SEQ_GSND_VLTRNO.NEXTVAL, ?, ?, ?, ?, ?, TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'), TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'))";
    jdbcTemplate.update(query, new Object[]{ vltrdate, vltrtime1, vltrtime2, vltrloc, vltrcnt });
  } else if("MODIFY".equals(vltrmode)) {
    String query = "UPDATE GSND_VOLUNTEER_WORK SET VLTRTIME1 = ?, VLTRTIME2 = ?, VLTRLOC = ?, VLTRCNT = ?, MODDATE=TO_CHAR(SYSDATE, 'YYYYMMDD'), MODTIME=TO_CHAR(SYSDATE, 'HH24MISS') WHERE VLTRNO = ?";
    jdbcTemplate.update(query, new Object[]{ vltrtime1, vltrtime2, vltrloc, vltrcnt, vltrno });
  } else if("DELETE".equals(vltrmode)) {
    jdbcTemplate.update("DELETE FROM GSND_VOLUNTEER_REQUEST WHERE VLTRNO = ?", vltrno);
    jdbcTemplate.update("DELETE FROM GSND_VOLUNTEER_WORK WHERE VLTRNO = ?", vltrno);
  } else if("REQUEST_PROCESS".equals(vltrmode) ) {
    String userid = (request.getParameter("userid") == null ) ? "" : request.getParameter("userid");
    String vltrstcd = (request.getParameter("vltrstcd") == null ) ? "" : request.getParameter("vltrstcd");

    out.println( vltrstcd +" "+ vltrno +" "+ userid );

    int rows = jdbcTemplate.update("UPDATE GSND_VOLUNTEER_REQUEST SET VLTRSTCD = ? WHERE VLTRNO = ? AND USERID = ?", vltrstcd, vltrno, userid);
  }
%>
