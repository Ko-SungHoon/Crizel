<%@ page import="javax.xml.parsers.*, org.xml.sax.*, org.xml.sax.helpers.*, org.w3c.dom.*, java.io.*"%>

<%!
public class xparser {
  String displayStrings[] = new String[100];
  int numberDisplayLines = 0;

  public String[] displayDocument(String uri) {
    try {
      DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
      DocumentBuilder db = null;
    try {
      db = dbf.newDocumentBuilder();
    } 
    catch (ParserConfigurationException pce) {}

    Document document = null;
    document = db.parse(uri);

    numberDisplayLines = 0;
    display(document, "");
    } catch (Exception e) {
        e.printStackTrace(System.err);
    }
    return displayStrings;
  } 

  public void display(Node node, String indent) {
    if (node == null) {
        return;
    }
    int type = node.getNodeType();
    switch (type) {
        case Node.DOCUMENT_NODE: {
            display(((Document)node).getDocumentElement(), "");
            break;
        }
        case Node.ELEMENT_NODE: {
            if ("dhsOpenEmpInfoList".equals(node.getNodeName()) 
                || "dhsOpenEmpInfo".equals(node.getNodeName())
                || "empWantedTitle".equals(node.getNodeName())
                || "empSeqno".equals(node.getNodeName())
                || "empWantedEndt".equals(node.getNodeName())
            ) {
                int length = (node.getAttributes() != null) ? node.getAttributes().getLength() : 0;
                numberDisplayLines++;
                NodeList childNodes = node.getChildNodes();
                if (childNodes != null) {
                    length = childNodes.getLength();
                    for (int i = 0; i < length; i++ ) {
                        display(childNodes.item(i), indent);
                    }
                }
            }
            break;
        }
        case Node.CDATA_SECTION_NODE: {
            displayStrings[numberDisplayLines] = indent;
            displayStrings[numberDisplayLines] += "&lt;![CDATA[";
            displayStrings[numberDisplayLines] += node.getNodeValue();
            displayStrings[numberDisplayLines] += "]]&gt;";
            numberDisplayLines++;
            break;
        }
        case Node.TEXT_NODE: {
            displayStrings[numberDisplayLines] = indent;
            String newText = node.getNodeValue().trim();
            if(newText.indexOf("\n") < 0 && newText.length() > 0) {
                if("empSeqno".equals(node.getParentNode().getNodeName())) {
                    displayStrings[numberDisplayLines] += "<li><a target='_blank' href=http://www.work.go.kr/empInfo/empInfoSrch/list/popup/popDhsOpenEmpInfoDetail.do?empSeqno=";
                    displayStrings[numberDisplayLines] += newText;
                    displayStrings[numberDisplayLines] += ">";
                }
                if("empWantedTitle".equals(node.getParentNode().getNodeName())) {
                    displayStrings[numberDisplayLines] += newText;
                    displayStrings[numberDisplayLines] += "</a>";
                }
                if("empWantedEndt".equals(node.getParentNode().getNodeName())) {
                    displayStrings[numberDisplayLines] += "<span class='date'>";
                    newText = newText.substring(0,4)+"-"+newText.substring(4,6)+"-"+newText.substring(6,8);
                    displayStrings[numberDisplayLines] += newText;
                    displayStrings[numberDisplayLines] += "</span></li>";
                }
            }
            break;
        }
        case Node.PROCESSING_INSTRUCTION_NODE: {    
            displayStrings[numberDisplayLines] = indent;
            displayStrings[numberDisplayLines] += "&lt;?";
            displayStrings[numberDisplayLines] += node.getNodeName();
            String text = node.getNodeValue();
            if (text != null && text.length() > 0) {
                displayStrings[numberDisplayLines] += text;
            }
            displayStrings[numberDisplayLines] += "?&gt;";
            numberDisplayLines++;
            break;
        }    
    }
  } 
}
%>