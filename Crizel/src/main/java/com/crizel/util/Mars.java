package com.crizel.util;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;


public class Mars {

	public static void main(String[] args) throws UnsupportedEncodingException {
		Mars mars = new Mars();
			
		//mars.getList("https://5siri.com/xe/index.php?mid=manko");
		//mars.getView("https://5siri.com/xe/index.php?mid=manko&document_srl=6398924");
	}
	
	
	public List<Map<String,Object>> getList(String addr) throws UnsupportedEncodingException{
		String URL 						= addr;
        Document doc 					= null;
        Elements cateElem				= null;
        Elements titleElem				= null;
        Elements imgElem				= null;
        List<Map<String,Object>> list 	= new ArrayList<Map<String,Object>>();
        Map<String,Object> map			= null;
        
		try {
			doc = Jsoup.connect(URL)
					.cookie("adult", "true")
					.cookie("lpopup", "no")
					.cookie("SSID","0p269ov6rk96dhr9sjc8gotkpk")
					.cookie("rx_sesskey1","5elA3FBJREeSqqlVmUqAclaY")
					.cookie("rx_sesskey2","muRy2JLB7jVXbMDEjFxW5ISo")
					.cookie("rx_uatype","qD8DlZkrHBNLQKFxc05QSg")
					.get();
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
        	map.put("addr", URLEncoder.encode(title.attr("href"), "UTF-8"));
        	map.put("addrLink", title.attr("href"));
        	list.add(map);
        	
        }
        return list;
	}
	
	
	public Map<String,Object> getView(String addr){
		String URL 							= addr;
        Document doc 						= null;
        Elements fileElem					= null;
        Elements imgElem					= null;
        List<Map<String,Object>> list 		= new ArrayList<Map<String,Object>>();
        List<String> imgList				= new ArrayList<String>();
        Map<String,Object> fileMap	 		= new HashMap<String, Object>();
        Map<String,Object> map				= null;
        
		try {
			doc = Jsoup.connect(URL)
					.cookie("adult", "true")
					.cookie("lpopup", "no")
					.get();
			//System.out.println(doc.toString().substring(0,59999));
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		
		fileElem 	= doc.select(".rd_fnt.rd_file ul li a");
		imgElem 	= doc.select("article img");
        
        for(int i=0; i<fileElem.size(); i++){
        	map = new HashMap<String,Object>();
        	
        	Element file = fileElem.get(i);
        	
        	map.put("addr", file.attr("href"));
        	map.put("text", file.text());

        	list.add(map);
        }
        
        fileMap.put("list", list);        
        
        for(int i=0; i<imgElem.size(); i++){
        	Element img = imgElem.get(i);
        	//imgList.add("https://5siri.com/" + img.attr("src"));
        	imgList.add("https://5siri.com/" + img.attr("src").substring(img.attr("src").indexOf("xe"), img.attr("src").length()));
        }
        
        fileMap.put("imgList", imgList);
        
        
        return fileMap;
	}
	

}
