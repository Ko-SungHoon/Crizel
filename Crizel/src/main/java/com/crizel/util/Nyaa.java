package com.crizel.util;

import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class Nyaa {

	/*public static void main(String[] args) throws Exception {
		Nyaa nyaa = new Nyaa();
		
		List<Map<String,Object>> list = nyaa.NyaaList("1_0", "idol");
		
		for(Map<String,Object> ob : list){
			System.out.print("title : " + ob.get("title") + "\t");
			System.out.print("link : " + ob.get("link") + "\t");
			System.out.print("size : " + ob.get("size") + "\t");
			System.out.println("pubDate : " + ob.get("pubDate") + "\t");
			
		}
	}*/
	
	public String pubDataStr(String val) throws ParseException{
		String[] valArr = val.split(" ");
		
		SimpleDateFormat sdft 	= new SimpleDateFormat ("dd MMM yyyy", new Locale("en", "US"));
		SimpleDateFormat sdft2 	= new SimpleDateFormat ("yyyy-MM-dd");
		
		val = valArr[1] + " " + valArr[2] + " " + valArr[3];
		
		val = sdft2.format(sdft.parse(val));
		
		return val;
	}
	
	public List<Map<String,Object>> NyaaList(String type, String keyword) throws Exception{
		Map<String,Object> map 			= null;
		List<Map<String,Object>> list 	= new ArrayList<Map<String,Object>>();
		
		/*
		 * https://nyaa.si/?f=0&c=1_0&q=idol			비디오
		 * https://nyaa.si/?f=0&c=2_0&q=idol			오디오
		 * https://nyaa.si/?f=0&c=4_0&q=idol			라이브
		 * https://nyaa.si/?f=0&c=5_0&q=idol			사진
		 */
		
    	URL url = new URL("https://nyaa.si/?page=rss&q=" + URLEncoder.encode(keyword, "UTF-8") + "&c=" + type + "&f=0");
        URLConnection connection = url.openConnection(); 
        Document doc = parseXML(connection.getInputStream());
		NodeList descNodes = doc.getElementsByTagName("item");
		
		for(int i=0; i<descNodes.getLength();i++){
			map = new HashMap<String,Object>();
		    for(Node node = descNodes.item(i).getFirstChild(); node!=null; node=node.getNextSibling()){
		    	
		    	if("title".equals(node.getNodeName())){
		    		map.put("title", node.getTextContent());
		    	}else if("link".equals(node.getNodeName())){
		    		map.put("link", node.getTextContent());
		    	}else if("nyaa:size".equals(node.getNodeName())){
		    		map.put("size", node.getTextContent());
		    	}else if("pubDate".equals(node.getNodeName())){
		    		map.put("pubDate", pubDataStr(node.getTextContent()));
		    	}
		    }
		    list.add(map);
		}
		
		return list;
	}
	
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
}