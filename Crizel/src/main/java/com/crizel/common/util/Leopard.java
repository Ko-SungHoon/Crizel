package com.crizel.common.util;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;


public class Leopard {
	public static void main(String[] args) throws Exception {
		Leopard lp = new Leopard();
		String addr		= "http://leopard-raws.org/?search=";
		String keyword	= "boruto";
		
		lp.getList(addr + URLEncoder.encode(keyword, "UTF-8"));
		
		//System.out.println(oj.getView("http://www.onejav.com/" + addr));
		
		
	}
	
	public List<Map<String,Object>> getList(String addr){
		String URL 						= addr;
        Document doc 					= null;
        List<Map<String,Object>> list 	= new ArrayList<Map<String,Object>>();
        Map<String,Object> map			= null;
        
        Elements linkElem 				= null;
        
		try {
			doc = Jsoup.connect(URL)
					.userAgent("Mozilla")
					.header("charset", "utf-8")
    				.header("Accept-Encoding", "gzip")
					.get();
			//System.out.println(doc);
			
			linkElem = doc.select("#torrents .bigblock .torrent_name a");
			
			for(int i=0; i<linkElem.size(); i++){
				map = new HashMap<String,Object>();
				Element link = linkElem.get(i);
				
				map.put("link", "http://leopard-raws.org/" + link.attr("href"));
				map.put("title", link.text());
				
				//System.out.println("http://leopard-raws.org/" + link.attr("href") + " ~ " + link.text());
				
				list.add(map);
			}
		} catch (Exception e) {
			System.out.println(e);
		}
        return list;
	}
}
