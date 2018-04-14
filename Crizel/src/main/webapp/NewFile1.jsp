<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>
<%@page import="java.io.*,java.util.*"%>
<%@ page import="egovframework.rfc3.iam.security.userdetails.util.EgovUserDetailsHelper"%>

<%
if(!EgovUserDetailsHelper.isRole("ROLE_ADMIN") ) {
  return;
}
%>

<%!
    private class TableInfo {
      public String col1;
      public String col2;
      public String col3;
      public String col4;
      public String col5;
      public String col6;
      public String col7;
    }


%>

<%
  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

  String query = "select * from user_tables";
  List<TableInfo> tableList = jdbcTemplate.query(query, new RowMapper<TableInfo>() {
      public TableInfo mapRow(ResultSet rs, int rowNum) throws SQLException {
        TableInfo table = new TableInfo();
        int idx = 1;
        table.col1 = rs.getString(idx++);
        table.col2 = rs.getString(idx++);
        table.col3 = rs.getString(idx++);
        table.col4 = rs.getString(idx++);
        table.col5 = rs.getString(idx++);
        table.col6 = rs.getString(idx++);
        table.col7 = rs.getString(idx++);
        return table;
      }
    }
  );

  List<TableInfo> seqList = jdbcTemplate.query("select * from user_sequences", new RowMapper<TableInfo>() {
      public TableInfo mapRow(ResultSet rs, int rowNum) throws SQLException {
        TableInfo table = new TableInfo();
        int idx = 1;
        table.col1 = rs.getString(idx++);
        table.col2 = rs.getString(idx++);
        table.col3 = rs.getString(idx++);
        table.col4 = rs.getString(idx++);
        table.col5 = rs.getString(idx++);
        table.col6 = rs.getString(idx++);
        table.col7 = rs.getString(idx++);
        return table;
      }
    }
  );

%>
<style type="text/css">
  th, td { font-size:12px; }
</style>

<h3>Sequence</h3>

<table>
  <tr>
    <th>col1</th>
    <th>col2</th>
    <th>col3</th>
    <th>col4</th>
    <th>col5</th>
    <th>col6</th>
    <th>col7</th>
  </tr>
  <% for(TableInfo tab : seqList ) { %>
  <tr>
    <td><%= tab.col1 %></td>
    <td><%= tab.col2 %></td>
    <td><%= tab.col3 %></td>
    <td><%= tab.col4 %></td>
    <td><%= tab.col5 %></td>
    <td><%= tab.col6 %></td>
    <td><%= tab.col7 %></td>
  </tr>
  <% } %>
</table>         


<h3>Table List</h3>

<table>
  <tr>
    <th>col1</th>
    <th>col2</th>
    <th>col3</th>
    <th>col4</th>
    <th>col5</th>
    <th>col6</th>
    <th>col7</th>
  </tr>
  <% for(TableInfo tab : tableList) { %>
  <tr>
    <td><a href="/index.lib?contentsSid=189&tablename=<%= tab.col1 %>"><%= tab.col1 %></a></td>
    <td><%= tab.col2 %></td>
    <td><%= tab.col3 %></td>
    <td><%= tab.col4 %></td>
    <td><%= tab.col5 %></td>
    <td><%= tab.col6 %></td>
    <td><%= tab.col7 %></td>
  </tr>
  <% } %>
</table>         


                                                               