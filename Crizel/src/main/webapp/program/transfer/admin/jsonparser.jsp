<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.io.IOException"%>
<%@ page import ="org.jsoup.Jsoup"%>
<%@ page import ="org.jsoup.nodes.Document"%>
<%@ page import ="org.jsoup.select.Elements"%>

<%@ page import ="org.json.simple.JSONObject"%>
<%@ page import ="org.json.simple.parser.JSONParser"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP</title>
</head>
<body>

<%!
    /*public static class rawHoliday {
        public int totalResult;
        public int page;
        public int count;
        public HashMap<rawHolidayData> results;
    }

    public static class rawHolidayData {
        public String year;
        public String month;
        public String day;
        public String type;
        public String name;
    }*/

%>

<%

response.addHeader("Access-Control-Allow-Origin", "*");
response.addHeader("TDCProjectKey", "61816f66-5e21-42aa-9d76-eed601aa42d5");
request.setCharacterEncoding("UTF-8");

String packageName  =   "";
String targetList   =   "";
String targetType   =   "";
int msgType         =   1;

String title    =   "제목";
String body    =   "본문";

JSONObject sendData =   new JSONObject();
sendData.put("title", title);
sendData.put("body", body);

URL url     =   new URL("https://apis.sktelecom.com/v1/eventday/days?month=&year=&type=h&day=");
HttpURLConnection connection    =   (HttpURLConnection) url.openConnection();
connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
connection.setRequestMethod("POST");
connection.setDoOutput(true);

DataOutputStream wr =   new DataOutputStream(connection.getOutputStream());

int responseCode    =   connection.getResponseCode();
if (responseCode != 200) {
    
}
    
/*String keyName          =   "TDCProjectKey";
String TDCProjectKey    =   "61816f66-5e21-42aa-9d76-eed601aa42d5";
String requestUrl       =   "https://apis.sktelecom.com/v1/eventday/days?month=&year=&type=h&day=";

try {

    Document document = Jsoup.connect(requestUrl)
    .userAgent("Mozilla")
    .ignoreContentType(true)
    .header(keyName, TDCProjectKey)
    .header("referer", "https://developers.sktelecom.com/projects/project_53742147/services/EventDay/Analytics/")
    .header("Accept", "application/json")
    .get();

    Elements elem = document.select("body");

    String json = "";

    //JSONParser jsonParser   =   new JSONParser();
//    JSONObject jsonObject   =   (JSONObject) jsonParser.parse
    
    for (org.jsoup.nodes.Element e : elem) {
        json += e.text();
    }
    
    JSONParser parser   =   new JSONParser();
    Object obj  =   parser.parse(json);
    JSONObject jsobObj  =   (JSONObject) obj;

    String totalCnt =   (String) jsonJob.get("totalResult");

    //out.println("<br>totalCnt :: "+totalCnt+"<br>");

    out.println(json);

} catch (IOException e) {

    e.printStackTrace();

}*/


 

%>

</body>

</html> 