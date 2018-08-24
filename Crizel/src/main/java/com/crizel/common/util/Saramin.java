package com.crizel.common.util;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


public class Saramin {

	public List<Map<String,Object>> getList() throws Exception {
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		
		URL url = new URL("http://api.saramin.co.kr/job-search?job_type=1&loc_cd=110120&job_category=404");
        URLConnection connection = url.openConnection(); 
        DocumentBuilderFactory objDocumentBuilderFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder objDocumentBuilder = objDocumentBuilderFactory.newDocumentBuilder();
        Document doc = objDocumentBuilder.parse(connection.getInputStream());

		Element element = (Element) doc.getDocumentElement();
		NodeList nodeList = element.getElementsByTagName("job");
		Node node = null;
		
		for(int i=0; i<nodeList.getLength(); i++){
			Map<String,Object> map = new HashMap<String,Object>();
			node = nodeList.item(i);
			element = (Element) node;
			map.put("url", getTagValue("url", element));
			for(int j=0; j<getNodeList("company", element).getLength(); j++){
				node = nodeList.item(i);
				element = (Element) node;
				map.put("name", getTagValue("name", element));
			}
			for(int j=0; j<getNodeList("position", element).getLength(); j++){
				node = nodeList.item(i);
				element = (Element) node;
				map.put("job-category", getTagValue("job-category", element));
				map.put("salary", getTagValue("salary", element));
			}
			list.add(map);
		}
		return list;
	}
	
	private static String getTagValue(String tag, Element eElement) {
	    NodeList nlList = eElement.getElementsByTagName(tag).item(0).getChildNodes();
	    Node nValue = (Node) nlList.item(0);
	    if(nValue == null) 
	        return null;
	    return nValue.getNodeValue();
	}
	
	private static NodeList getNodeList(String tag, Element element) {
		NodeList nodeList = element.getElementsByTagName(tag);
		return nodeList;
	}
}
