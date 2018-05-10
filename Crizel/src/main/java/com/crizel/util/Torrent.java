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

public class Torrent {
	public static void main(String[] args) {
		Torrent t1 = new Torrent();
		
		//t1.getList("https://manstorrent.com/bbs/board.php?bo_table=javcensored&page=1");
		t1.getList();
	}
	
	public List<Map<String,Object>> getList(){
		String[] URL 					= {"https://manstorrent.com/bbs/board.php?bo_table=javcensored&page=1"
										,  "https://manstorrent.com/bbs/board.php?bo_table=javcensored&page=2"
										,  "https://manstorrent.com/bbs/board.php?bo_table=javcensored&page=3"
										};
        Document doc 					= null;
        Elements elem					= null;
		List<Map<String,Object>> list 	= new ArrayList<Map<String,Object>>();
        Map<String,Object> map 			= null;
        List<String> hrefList 			= null;
        List<String> textList 			= null;
        List<String> timeList 			= null;
        List<String> imgList			= null;
        
        for(String ob : URL){
        	try {
    			doc = Jsoup.connect(ob).get();
    		} catch (IOException e1) {
    			e1.printStackTrace();
    		}
            elem = doc.select(".table.div-table.list-pc.bg-white tbody tr .list-subject a");
            
            hrefList = new ArrayList<String>();
            textList = new ArrayList<String>();
            for (org.jsoup.nodes.Element e : elem) {
            	map = new HashMap<String,Object>();     
            	if(e.text()!=null && !"".equals(e.text())){
            		hrefList.add(e.attr("href"));
            		textList.add(e.text());
            	}
    		}
            
            timeList = new ArrayList<String>();
            elem = doc.select(".table.div-table.list-pc.bg-white tbody tr .text-center.en.font-11");
            for (org.jsoup.nodes.Element e : elem) {
            	map = new HashMap<String,Object>();     
            	if(e.text()!=null && !"".equals(e.text())){
            		if(e.text().indexOf("전") > 0){
                    	timeList.add(e.text());
            		}
            	}
    		}

            elem = doc.select(".table.div-table.list-pc.bg-white tbody tr .list-img.text-center img");
            
            imgList = new ArrayList<String>();
            for (org.jsoup.nodes.Element e : elem) {
            	imgList.add(e.attr("src"));
    		}
            
            for(int i=0; i<hrefList.size(); i++){
            	map = new HashMap<String, Object>();
            	map.put("href", hrefList.get(i));
            	map.put("text", textList.get(i));
            	map.put("time", timeList.get(i));
            	map.put("magnet", getMagnet(hrefList.get(i)).get("magnet"));
            	map.put("img", getMagnet(hrefList.get(i)).get("img"));
            	list.add(map);
            }
        }
		return list;
	}
	
	public Map<String,Object> getMagnet(String addr){
		Map<String,Object> map			= new HashMap<String,Object>();
		String URL 						= null;
        Document doc 					= null;
        Elements elem					= null;
        	
        URL 			= addr;
        
		try {
			doc = Jsoup.connect(URL).get();
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		
		elem = doc.select(".view-wrap a");
		
		for (org.jsoup.nodes.Element e : elem) {
			if(e.text()!=null && !"".equals(e.text())){
				if("_blank".equals(e.attr("target"))){
					map.put("magnet", e.attr("href"));
					break;
				}
			}
		}
		
		elem = doc.select(".view-wrap img");
		if(elem.size()>0){
			map.put("img", elem.get(0).attr("src"));
		}
		
		return map;
	}
}
