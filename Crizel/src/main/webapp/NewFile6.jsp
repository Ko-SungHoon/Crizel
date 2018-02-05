<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.io.IOException"%>
<%@ page import ="org.jsoup.Jsoup"%>
<%@ page import ="org.jsoup.nodes.Document"%>
<%@ page import ="org.jsoup.select.Elements"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP</title>
</head>
<body>
<%
try {
	Document document = Jsoup.connect("https://apis.sktelecom.com/v1/eventday/days?month=&year=&type=h&day=")
						.userAgent("Mozilla")
						.ignoreContentType(true)
						.header("TDCProjectKey", "61816f66-5e21-42aa-9d76-eed601aa42d5")
						.header("referer", "https://developers.sktelecom.com/projects/project_53742147/services/EventDay/Analytics/")
						.header("Accept", "application/json")
						.get();

	Elements elem = document.select("body");
	String json = "";
  		for (org.jsoup.nodes.Element e : elem) {
   	 		json += e.text();
		}
    out.println(json);

} catch (IOException e) {
	e.printStackTrace();
}
%>
</body>
</html> 