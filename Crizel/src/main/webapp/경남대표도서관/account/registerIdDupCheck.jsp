<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.Enumeration"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.InputStreamReader"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");

String addr = "http://bs.gyeongnam.go.kr:9090/kdotapi/ksearchapi/usercheck";
Enumeration enumeration = request.getParameterNames();
int cnt = 0;
String key = "";
String value = "";
while(enumeration.hasMoreElements()){
	key = (String) enumeration.nextElement();
	value = request.getParameter(key);
	if(cnt == 0){
		addr += "?" + key + "=" + URLEncoder.encode(value, "UTF-8");
	}else{
		addr += "&" + key + "=" + URLEncoder.encode(value, "UTF-8");
	}
	cnt++;
}

InputStreamReader isr 	= null;
URL url 				= null;
HttpURLConnection conn 	= null;
String result_info 		= "";
JSONArray user_data 	= null;
JSONObject data			= new JSONObject();
JSONObject search_count	= null;
String user_key			= "";

try{
	url = new URL(addr);
	conn = (HttpURLConnection) url.openConnection();
	isr = new InputStreamReader(conn.getInputStream());
	JSONObject object = (JSONObject) JSONValue.parse(isr);
	
	result_info = (String)object.get("RESULT_INFO");
	user_data = (JSONArray) object.get("USER_DATA");
	search_count = (JSONObject) user_data.get(0);
	
	data.put("RESULT_INFO", result_info);
	data.put("SEARCH_COUNT", search_count.get("SEARCH_COUNT").toString());
	
	out.println(data);
	
}catch(Exception e){
}
%>