<%@page import="org.jsoup.Jsoup"%>
<%@page import="org.jsoup.nodes.Document"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.URL"%>
<%
try{
	String keyword = URLEncoder.encode("�������� ������ ���Ͽ�", "UTF-8");
	String addr = "";
	addr = "http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/bookandnonbooksearch?manage_code=MA&search_title="+keyword+"&search_type=detail&display=10&pageno=1";
	//addr = "http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/newbooklist?manage_code=MA&display=10&pageno=1&startdate=20180201&enddate=20180601";
	URL url = new URL(addr);

	InputStreamReader isr = new InputStreamReader(url.openConnection().getInputStream(), "UTF-8");

	JSONObject object = (JSONObject) JSONValue.parse(isr);

	JSONArray head = (JSONArray) object.get("LIST_DATA");

	//out.println(head);
	
	for(int i=0; i<head.size(); i++){
		JSONObject data = (JSONObject)head.get(i);
		out.println("TITLE_INFO : " + data.get("TITLE_INFO") + "<br>");
		out.println("LOAN_CHECK : " + data.get("LOAN_CHECK") + "<br>");
		out.println("BOOK_STATUS : " + data.get("BOOK_STATUS") + "<br><br>");
	}
}catch(Exception e){
	out.println(e.toString());
}

try{
	String keyword = URLEncoder.encode("�� �ΰ�����", "UTF-8");
	String addr = "";
	addr = "http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/bookandnonbooksearch?manage_code=MA&search_title="+keyword+"&search_type=detail&display=10&pageno=1";
	//addr = "http://lib.gyeongnam.go.kr/kdotapi/ksearchapi/newbooklist?manage_code=MA&display=10&pageno=1&startdate=20180201&enddate=20180601";
	URL url = new URL(addr);
	
	Document doc = Jsoup.connect(addr).get();
	out.println(doc);

	InputStreamReader isr = new InputStreamReader(url.openConnection().getInputStream(), "UTF-8");

	JSONObject object = (JSONObject) JSONValue.parse(isr);

	JSONArray head = (JSONArray) object.get("LIST_DATA");

	//out.println(head);
	
	for(int i=0; i<head.size(); i++){
		JSONObject data = (JSONObject)head.get(i);
		out.println("TITLE_INFO : " + data.get("TITLE_INFO") + "<br>");
		out.println("LOAN_CHECK : " + data.get("LOAN_CHECK") + "<br>");
		out.println("BOOK_STATUS : " + data.get("BOOK_STATUS") + "<br><br>");
	}
}catch(Exception e){
	out.println(e.toString());
}

%>

         