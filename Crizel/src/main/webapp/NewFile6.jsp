<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.jdbc.core.*, org.springframework.dao.*" %>
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
    private class TableDesc {
      public String col1;
      public String col2;
      public String col3;
      public String col4;
      public String col5;
      public String col6;
      public String col7;
      public String col8;
      public String col9;
      public String col10;
      public String col11;
      public String col12;
      public String col13;
      public String col14;
      public String col15;
    }

    private class TableColInfo {
      String name;
      String type;
      int typecode;
      boolean autoincrement;
    }
%>

<%
try {
%>


<%
  String tablename = request.getParameter("tablename");

  WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
  DataSource dataSource = (DataSource) context.getBean("dataSource");
  JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

  String query = "SELECT * FROM " + tablename;
  List<TableDesc> tableDescList = jdbcTemplate.query(query, new RowMapper<TableDesc>() {
      public TableDesc mapRow(ResultSet rs, int rowNum) throws SQLException {
        TableDesc desc = new TableDesc();
        int colCnt = rs.getMetaData().getColumnCount();
        int idx = 1;
        desc.col1 = rs.getString(idx++);
        desc.col2 = (colCnt < idx) ? "" : rs.getString(idx++);
        desc.col3 = (colCnt < idx) ? "" : rs.getString(idx++);
        desc.col4 = (colCnt < idx) ? "" : rs.getString(idx++);
        desc.col5 = (colCnt < idx) ? "" : rs.getString(idx++);
        desc.col6 = (colCnt < idx) ? "" : rs.getString(idx++);
        desc.col7 = (colCnt < idx) ? "" : rs.getString(idx++);
        desc.col8 = (colCnt < idx) ? "" : rs.getString(idx++);
        desc.col9 = (colCnt < idx) ? "" : rs.getString(idx++);
        desc.col10 = (colCnt < idx) ? "" : rs.getString(idx++);
        desc.col11 = (colCnt < idx) ? "" : rs.getString(idx++);
        desc.col12 = (colCnt < idx) ? "" : rs.getString(idx++);
        desc.col13 = (colCnt < idx) ? "" : rs.getString(idx++);
        desc.col14 = (colCnt < idx) ? "" : rs.getString(idx++);
        desc.col15 = (colCnt < idx) ? "" : rs.getString(idx++);
        return desc;
      }
    }
  );

  List<TableColInfo> tableColInfoList = jdbcTemplate.query(query, new ResultSetExtractor<List<TableColInfo>>() {
    public List<TableColInfo> extractData(ResultSet rs) throws SQLException, DataAccessException {
      List<TableColInfo> columns = new ArrayList<TableColInfo>();
      ResultSetMetaData rsmd = rs.getMetaData();
      int columnCount = rsmd.getColumnCount();
      for (int i = 1; i <= columnCount; i++) {
        TableColInfo column = new TableColInfo();
        column.name = rsmd.getColumnName(i);
        column.autoincrement = rsmd.isAutoIncrement(i);
        column.type = rsmd.getColumnTypeName(i);
        column.typecode = rsmd.getColumnType(i);
        columns.add(column);
      }
      return columns;
    }
  });
%>

<style type="text/css">
  th, td { font-size:12px; }
</style>

<h4><%= tablename %> 테이블</h4>

<table bgcolor="#c0c0c0" cellpadding="2" cellspacing="1">
  <tr bgcolor="#dfdfdf">
    <th>순서</th>
    <th>컬럼명</th>
    <th>컬럼타입</th>
    <th></th>
  </tr>
  <% int i=1; for( TableColInfo colinfo : tableColInfoList ) { %>
  <tr bgcolor="#ffffff">
    <td><%= i++ %></td>
    <td><%= colinfo.name%></td>
    <td><%= colinfo.type%></td>
    <td><%= colinfo.autoincrement%></td>
  </tr>
  <% } %>
</table>

<br><br>

<table bgcolor="#c0c0c0" cellpadding="2" cellspacing="1">
  <tr bgcolor="#dfdfdf">
    <th>col1</th>
    <th>col2</th>
    <th>col3</th>
    <th>col4</th>
    <th>col5</th>
    <th>col6</th>
    <th>col7</th>
    <th>col8</th>
    <th>col9</th>
    <th>col10</th>
    <th>col11</th>
    <th>col12</th>
    <th>col13</th>
    <th>col14</th>
    <th>col15</th>
  </tr>
  <% for(TableDesc desc : tableDescList) { %>
  <tr bgcolor="#ffffff">
    <td><%= desc.col1 %></td>
    <td><%= desc.col2 %></td>
    <td><%= desc.col3 %></td>
    <td><%= desc.col4 %></td>
    <td><%= desc.col5 %></td>
    <td><%= desc.col6 %></td>
    <td><%= desc.col7 %></td>
    <td><%= desc.col8 %></td>
    <td><%= desc.col9 %></td>
    <td><%= desc.col10 %></td>
    <td><%= desc.col11 %></td>
    <td><%= desc.col12 %></td>
    <td><%= desc.col13 %></td>
    <td><%= desc.col14 %></td>
    <td><%= desc.col15 %></td>
  </tr>
  <% } %>
</table>

















<% } catch(Exception e) { out.println(e); } %>                             