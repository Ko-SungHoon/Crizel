package com.crizel.common;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;


public class Music {
	public Map<String,Object> music(String URL) throws IOException{
		Map<String, Object> map = new HashMap<String,Object>();
		List<String> href = new ArrayList<String>();
		List<String> src = new ArrayList<String>();
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		String page = "";
		
        Document doc = Jsoup
        		.connect(URL)
        		.userAgent("Mozilla")
        		.get();
        
        //System.out.println(doc);
        
        Elements elem = doc.select(".td-ss-main-content .td-block-span6 .td-module-thumb a");
        for (org.jsoup.nodes.Element e : elem) {
        	href.add(e.attr("href"));
		}
        
        elem = doc.select(".td-ss-main-content .td-block-span6 .td-module-thumb a img");
        for (org.jsoup.nodes.Element e : elem) {
        	src.add(e.attr("src"));
		}
        
        elem = doc.select(".page-nav.td-pb-padding-side");
        for (org.jsoup.nodes.Element e : elem) {
        	page += e.html();
		}
        
        for(int i=0; i<href.size(); i++){
        	Map<String,Object> listMap = new HashMap<String,Object>();
        	listMap.put("href", href.get(i));
        	listMap.put("src", src.get(i));
        	list.add(listMap);
        }
        
        map.put("list", list);
        map.put("page", page.replace("\n", ""));
        
        return map;
	}
}
