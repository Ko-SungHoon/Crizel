<%@page import="java.io.InputStream"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URLConnection"%>
<%@page import="javax.xml.parsers.DocumentBuilder"%>
<%@page import="javax.xml.parsers.DocumentBuilderFactory"%>
<%@page import="org.w3c.dom.Document"%>
<%@page import="org.w3c.dom.Node"%>
<%@page import="org.w3c.dom.NodeList"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>TEST</title>
</head>
<body>
<%!
public Document parseXML(InputStream stream) throws Exception {
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
%>
<%
response.setCharacterEncoding("utf-8");
request.setCharacterEncoding("utf-8");
URL url = new URL("http://libapi.gne.go.kr/FN/Manager/OpenApi.do?USERID=WEB&className=action.lnk.LnkUserCertify&vType=WEBID&vData=5818&vUserName=");
URLConnection connection = url.openConnection(); 
Document doc = parseXML(connection.getInputStream());
NodeList descNodes = doc.getElementsByTagName("result");

for(int i=0; i<descNodes.getLength();i++){
    for(Node node = descNodes.item(i).getFirstChild(); node!=null; node=node.getNextSibling()){
    	out.println(node.getNodeName() + " ~ " + node.getTextContent() + "<br>");
    }
}

%>
</body>
</html>