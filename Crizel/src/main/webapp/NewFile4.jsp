<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="com.ibm.icu.text.SimpleDateFormat"%>
<%
SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHH:mm");
Date now 	= Calendar.getInstance().getTime();
Date a 		= sdf.parse("2018052511:42");
out.println(now + "<br>");
out.println("a after : " + now.after(a) + "<br>");
out.println("a before : " + now.before(a) + "<br>");
%>