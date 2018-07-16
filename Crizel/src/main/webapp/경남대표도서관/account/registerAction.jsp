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

String addr = "http://bs.gyeongnam.go.kr:9090/kdotapi/ksearchapi/userinfoinsert";
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
JSONObject data			= null;
JSONObject data2		= null;
String user_key			= "";

try{
	url = new URL(addr);
	conn = (HttpURLConnection) url.openConnection();
	isr = new InputStreamReader(conn.getInputStream());
	JSONObject object = (JSONObject) JSONValue.parse(isr);
	
	result_info = (String)object.get("RESULT_INFO");
	
	if("SUCCESS".equals(result_info)){
		out.println("<script>");
		out.println("alert('가입이 완료되었습니다.');");
		out.println("location.replace('index.jsp');");
		out.println("</script>");
	}else{
		out.println("<script>");
		out.println("alert('처리 중 오류가 발생하였습니다.');");
		out.println("history.go(-1);");
		out.println("</script>");
	}
}catch(Exception e){
	out.println("<script>");
	out.println("alert('처리 중 오류가 발생하였습니다.');");
	out.println("history.go(-1);");
	out.println("</script>");
}
%>