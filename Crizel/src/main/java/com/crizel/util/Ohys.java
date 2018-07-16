package com.crizel.util;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class Ohys {
	public static void main(String[] args) throws Exception {
		Ohys ohys = new Ohys();
		String addr		= "";
		String keyword	= "comic";
		String type		= "video";
		
		if("video".equals(type)){
			addr = "https://torrents.ohys.net/download/rss.php?dir=new&q=" + URLEncoder.encode(keyword, "UTF-8");
		}else if("audio".equals(type)){
			addr = "https://www.nyaa.se/?page=rss&cats=3_0&term=" + URLEncoder.encode(keyword, "UTF-8");
		}else{
			addr = "https://sukebei.nyaa.se/?page=rss&term=" + URLEncoder.encode(keyword, "UTF-8");
		}
		
		ohys.getList(addr);
	}
	
	public List<Map<String,Object>> getList(String addr) throws Exception{
		DocumentBuilderFactory factory2 = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder 		= factory2.newDocumentBuilder();
		Document doc					= null;
		NodeList list 					= null;
		NodeList list2 					= null;
		List<Map<String,Object>> a 		= new ArrayList<Map<String,Object>>();
        Map<String,Object> map			= null;
        int i 							= 0;
        Element element, element2;
		String content, content2;
        
		try {
			doc = builder.parse(addr);
			//System.out.println(doc);
			
			list = doc.getElementsByTagName("title");
			list2 = doc.getElementsByTagName("link");
			
			i = 0;
			
			while (list.item(i) != null) {
				map = new HashMap<String, Object>();
				element = (Element) list.item(i);
				content = element.getTextContent();

				element2 = (Element) list2.item(i);
				content2 = element2.getTextContent();

				map.put("title", content);
				map.put("link", content2);

				a.add(map);

				i++;
			}
			
		} catch (Exception e) {
			System.out.println(e);
		}
        return a;
	}
}
