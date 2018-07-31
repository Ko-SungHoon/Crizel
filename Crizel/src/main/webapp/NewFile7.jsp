<!DOCTYPE html>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.Arrays"%>
<%@page import="org.w3c.dom.NamedNodeMap"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.math.BigInteger"%>
<%@page import="java.security.SecureRandom"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URLConnection"%>

<%@page import="javax.xml.parsers.DocumentBuilder"%>
<%@page import="javax.xml.parsers.DocumentBuilderFactory"%>

<%@page import="org.w3c.dom.Document"%>
<%@page import="org.w3c.dom.Node"%>
<%@page import="org.w3c.dom.NodeList"%>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%!
public static Document parseXML(InputStream stream) throws Exception {
    DocumentBuilderFactory objDocumentBuilderFactory = null;
    DocumentBuilder objDocumentBuilder = null;
    Document doc = null;
    try{
        objDocumentBuilderFactory = DocumentBuilderFactory.newInstance();
        objDocumentBuilder = objDocumentBuilderFactory.newDocumentBuilder();
        doc = objDocumentBuilder.parse(stream);
    }catch(Exception e){
        throw e;
    }       
    return doc;
}

public String generateState()
{
    SecureRandom random = new SecureRandom();
    return new BigInteger(130, random).toString(32);
}
%>
<%
response.setCharacterEncoding("UTF-8");
request.setCharacterEncoding("UTF-8");

//상태 토큰으로 사용할 랜덤 문자열 생성
String state = generateState();
//세션 또는 별도의 저장 공간에 상태 토큰을 저장
session.setAttribute("state", state);

String addr = "http://libapi.gne.go.kr/FN/Manager/OpenApi.do";
addr += "?USERID=WEB";
addr += "&className=action.lnk.LnkCheckDupUser";
/* addr += "&vType=0001";
addr += "&vUserName=" + URLEncoder.encode("고성훈", "UTF-8");
addr += "&vBirthDay=19910210";
addr += "&vMobileNo=01029105941"; */
addr += "&vType=0003";
addr += "&vId=" + URLEncoder.encode("MC0GCCqGSIb3DQIJAyEAlt1t9DxLJVIfmk/lydqgz7FubLVp0mvaOwmh8iXCo74=", "UTF-8");

URL url = new URL(addr);
URLConnection connection = url.openConnection(); 
Document doc = parseXML(connection.getInputStream());
NodeList descNodes = doc.getElementsByTagName("code");

out.println("code : " + descNodes + "<br>");

for(int i=0; i<descNodes.getLength();i++){
    for(Node node = descNodes.item(i).getFirstChild(); node!=null; node=node.getNextSibling()){
    	out.println(node.getTextContent() + "<br>");
    }
    out.println("<br>");
}
 

%>
</body>
</html>