package com.crizel.util;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class Twitter {
	public static void main(String[] args) {
		Twitter t1 = new Twitter();
		//t1.getList("https://twitter.com/uesaka_official");
		t1.getList("https://twitter.com/sunflower930316");
	}
	
	public List<Object> getList(String addr){
		String URL 			= addr;
        Document doc 		= null;
        Elements elem		= null;
		List<Object> list 	= new ArrayList<Object>();
        
		try {
			doc = Jsoup.connect(URL).get();
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		elem = doc.select("div.AdaptiveMedia-photoContainer img");
        for (Element e : elem) {
        	//System.out.println(e.attr("src"));
        	list.add(e.attr("src"));
		}
		return list;
	}
}
