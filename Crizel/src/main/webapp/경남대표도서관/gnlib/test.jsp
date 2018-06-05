<%@page import="org.springframework.web.context.WebApplicationContext"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource" %>

<%!
	private class MrCodeVo {
		public int no;
		public String code;
		public String val1;
		public String val2;
		public String val3;
	}
	
	private class MrCdoeVoMapper implements RowMapper<MrCodeVo> {
		public MrCodeVo mapRow(ResultSet rs, int rowNum) throws SQLException {
			MrCodeVo vo = new MrCodeVo();
			vo.code = rs.getString("code");
			vo.val1 = rs.getString("val1");
			vo.val2 = rs.getString("val2");
			vo.val3 = rs.getString("val3");
			return vo;
		}
	}
%>

<%
	WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
	DataSource dataSource = (DataSource) context.getBean("dataSource");
	JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

	MrCodeVo mrCodeVo = jdbcTemplate.queryForObject(
		"select no, code, val1, val2, val3 from mr_code where no = ?",
		new Object[]{1},
		new MrCdoeVoMapper()
	);

	out.println( mrCodeVo.code );
%>

<%= dataSource %>
<%= jdbcTemplate %>