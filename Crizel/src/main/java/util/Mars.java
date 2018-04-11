package util;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;


public class Mars {
	/*
	public static void main(String[] args) {
		Mars mars = new Mars();
		
		https://5siri.com/xe/
		https://5siri.com/xe/index.php?mid=korean
		https://5siri.com/xe/index.php?mid=manko
		https://5siri.com/xe/index.php?mid=anime	
			
			
		//mars.getList("https://5siri.com/xe/index.php?mid=manko");
		//mars.getView("https://5siri.com/xe/index.php?mid=manko&document_srl=6207347");
	}
	*/
	
	public List<Map<String,Object>> getList(String addr){
		String URL 						= addr;
        Document doc 					= null;
        Elements cateElem				= null;
        Elements titleElem				= null;
        Elements imgElem				= null;
        List<Map<String,Object>> list 	= new ArrayList<Map<String,Object>>();
        Map<String,Object> map			= null;
        
		try {
			doc = Jsoup.connect(URL).get();
			//System.out.println(doc);
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		
		cateElem 	= doc.select(".bd_lst.bd_tb_lst.bd_tb tr .cate span");
		titleElem 	= doc.select(".bd_lst.bd_tb_lst.bd_tb tr .title .hx.bubble.no_bubble.only_img");
		imgElem		= doc.select(".bd_lst.bd_tb_lst.bd_tb tr .title .hx.bubble.no_bubble.only_img img");
        
        for(int i=0; i<cateElem.size(); i++){
        	map = new HashMap<String,Object>();
        	
        	Element cate = cateElem.get(i);
        	Element title = titleElem.get(i);
        	Element img = imgElem.get(i);
        	
        	map.put("cate", cate.text());
        	map.put("img", img.attr("src"));
        	map.put("title", title.text());
        	map.put("addr", title.attr("href"));
        	list.add(map);
        }
        return list;
	}
	
	
	public List<Map<String,Object>> getView(String addr){
		String URL 						= addr;
        Document doc 					= null;
        Elements fileElem				= null;
        List<Map<String,Object>> list 	= new ArrayList<Map<String,Object>>();
        Map<String,Object> map			= null;
        
		try {
			doc = Jsoup.connect(URL).get();
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		
		fileElem 	= doc.select(".rd_fnt.rd_file ul li a");
        
        for(int i=0; i<fileElem.size(); i++){
        	map = new HashMap<String,Object>();
        	
        	Element file = fileElem.get(i);
        	
        	map.put("addr", file.attr("href"));
        	map.put("text", file.text());

        	list.add(map);
        }
        return list;
	}
	

}
