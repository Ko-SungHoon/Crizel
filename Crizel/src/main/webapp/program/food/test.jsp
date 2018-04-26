<%@page import="java.lang.reflect.Method"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/program/class/UtilClass.jsp"%>
<%@ include file="/program/class/PagingClass.jsp"%>
<%@page import="org.springframework.jdbc.core.*" %>
<%!
private class TestVO{
	public String tran_pr;
	public String tran_msg;
}

private class TestList implements RowMapper<TestVO> {
    public TestVO mapRow(ResultSet rs, int rowNum) throws SQLException {
    	TestVO vo = new TestVO();
    	vo.tran_pr			= rs.getString("TRAN_PR");
    	vo.tran_msg			= rs.getString("TRAN_MSG");
        return vo;
    }
}
%>

<%
StringBuffer sql = new StringBuffer();
List<TestVO> list = null;
Object[] value 	= null;
List<Object[]> batch = null;

/* int[] a = {1,2,3,4,5};
String[] b = {"A", "B", "C", "D", "E"};

batch = new ArrayList<Object[]>();
sql = new StringBuffer();
sql.append("INSERT INTO TEST(TEST_ID, TEST_A)	");
sql.append("VALUES(?, ?)						");
for(int i=0; i<5; i++){
	value = new Object[]{
			a[i]
			, b[i]			
	};
	batch.add(value);
} */

for(Method ob : jdbcTemplate.getClass().getMethods()){
	out.println(ob.getName() + " \t\t " + ob.toGenericString() + "<br>");
}

%>
