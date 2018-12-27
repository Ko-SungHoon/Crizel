package com.crizel.girls;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;

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
		elem = doc.select("img");
        for (Element e : elem) {
        	if(getCurrentImage(e.attr("src"))){
        		list.add(e.attr("src"));
        	}
		}
		return list;
	}
	
	public static boolean getCurrentImage(String addr) {
		boolean a = false;
		try {
			URL url = new URL(addr);
			InputStream is = url.openStream();
			BufferedImage bi = ImageIO.read(is);
			if (bi.getWidth() >= 200) {
				a = true;
			}
		} catch (Exception e) {
			System.out.println("ERR : " + e.toString());
			a = false;
		}
		return a;
	}
}
