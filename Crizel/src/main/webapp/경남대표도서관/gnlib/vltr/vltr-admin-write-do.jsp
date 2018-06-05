<%@page contentType="text/html;charset=utf-8"%>

<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>

<%
  String vltrdate = (request.getParameter("vltrdate") == null ) ? "" : request.getParameter("vltrdate");
  String vltrtime1 = (request.getParameter("vltrtime1") == null ) ? "" : request.getParameter("vltrtime1");
  String vltrtime2 = (request.getParameter("vltrtime2") == null ) ? "" : request.getParameter("vltrtime2");
  String vltrloc = (request.getParameter("vltrloc") == null ) ? "" : request.getParameter("vltrloc");
  String vltrcnt = (request.getParameter("vltrcnt") == null ) ? "" : request.getParameter("vltrcnt");

  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

  String query = "INSERT INTO GSND_VOLUNTEER_WORK VALUES(SEQ_GSND_VLTRNO.NEXTVAL, ?, ?, ?, ?, ?, TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'), TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'))";
  jdbcTemplate.update(query, new Object[]{ vltrdate, vltrtime1, vltrtime2, vltrloc, vltrcnt });
%>
