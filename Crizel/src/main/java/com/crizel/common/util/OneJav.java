package com.crizel.common.util;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;


public class OneJav {
	/*public static void main(String[] args) throws Exception {
		OneJav oj = new OneJav();
		//String addr			= "/torrent/mudr032";
		String addr 		= "http://onejav.com/2018/08/28?page=";
		
		List<Map<String,Object>> list = oj.getList(addr, 1, oj.getPageCount(addr));
		
		for(Map<String,Object> ob : list){
			System.out.println("title : " + ob.get("title"));
			System.out.println("addr : " + ob.get("addr"));
			System.out.println("img : " + ob.get("img"));
			System.out.println("name : " + ob.get("name"));
			System.out.println("name_link : " + ob.get("name_link") + "\n");
		}
		
		//oj.test("http://onejav.com/2018/08/28?page=1");
		
	}*/
	
	public List<Map<String,Object>> getList(String addr, int page, int pageCount, String day){
		String URL 						= addr + "?page=" + Integer.toString(page);
        Document doc 					= null;
        List<Map<String,Object>> list 	= new ArrayList<Map<String,Object>>();
        Map<String,Object> map			= null;

        Elements nameElem 				= null;
        Elements imgElem 				= null;
        Elements linkElem 				= null;
        
		try {
			//System.out.println("===시작===");
			doc = Jsoup.connect(URL)
					.userAgent("Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36")
					.header("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8")
					.header("Accept-Encoding", "gzip, deflate, br")
					.header("Accept-Language", "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7")
					.header("Cache-Control", "max-age=0")
					.header("Connection", "keep-alive")
					.header("Host", "onejav.com")
					.header("Upgrade-Insecure-Requests", "1")
            		.timeout(1000 * 60 * 60)
					.get();
			//System.out.println(doc);
			
			nameElem	= doc.select(".card.mb-3 .panel .panel-block");
			imgElem 	= doc.select(".card.mb-3 .image");
			linkElem 	= doc.select(".card.mb-3 .title.is-4.is-spaced a");
			
			for(int i=0; i<imgElem.size(); i++){
				map = new HashMap<String,Object>();
				Element name = nameElem!=null && nameElem.size()>i?nameElem.get(i):null;
				Element img = imgElem!=null && imgElem.size()>i?imgElem.get(i):null;
				Element link = linkElem!=null && linkElem.size()>i?linkElem.get(i):null;
				
				map.put("img", img!=null?img.attr("src"):"");
				map.put("addr", link!=null?"https://onejav.com/" + getView("https://onejav.com/" + link.attr("href")):"");
				map.put("title", link!=null?link.text():"");
				map.put("name", name!=null?name.text():"");
				map.put("name_link", name!=null?"https://onejav.com/" + name.attr("href"):"");
				map.put("day", day);
				
				list.add(map);
			}
			//System.out.println("===종료===");
			
			if(pageCount>page){
				//System.out.println("===다음 페이지로===");
				//System.out.println("현재 페이지 : " + page);
				list.addAll(getList(addr, page+1, pageCount, day));
			}
			
		} catch (Exception e) {
			System.out.println("ERR : " + e.toString());
			list = null;
		}
        return list;
	}
	
	public String getView(String addr){
		String URL 						= addr;
        Document doc 					= null;
        Elements linkElem 				= null;
        
        try {
			doc = Jsoup.connect(URL)
					.userAgent("Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36")
					.header("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8")
					.header("Accept-Encoding", "gzip, deflate, br")
					.header("Accept-Language", "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7")
					.header("Cache-Control", "max-age=0")
					.header("Connection", "keep-alive")
					.header("Host", "onejav.com")
					.header("Upgrade-Insecure-Requests", "1")
            		.timeout(1000 * 60 * 60)
					.get();
			//System.out.println(doc);
		} catch (IOException e) {
			System.out.println("ERR : " + e.toString());
		}
        
        linkElem = doc.select(".button.is-primary.is-fullwidth");
        
		Element link = linkElem.get(0);
        
		addr = link.attr("href");
		
        return addr;
	}

	
	public int getPageCount(String addr){
		String URL 						= addr;
        Document doc 					= null;
		Elements pagingElem	 			= null;
        
		try {
			doc = Jsoup.connect(URL)
					.userAgent("Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36")
					.header("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8")
					.header("Accept-Encoding", "gzip, deflate, br")
					.header("Accept-Language", "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7")
					.header("Cache-Control", "max-age=0")
					.header("Connection", "keep-alive")
					.header("Host", "onejav.com")
					.header("Upgrade-Insecure-Requests", "1")
            		.timeout(1000 * 60 * 60)
					.get();
			//System.out.println(doc);
			pagingElem = doc.select(".pagination-list li");
			
		}catch(Exception e){
			System.out.println("ERR : " + e.toString());
		}
		
		return pagingElem!=null?pagingElem.size():0;
	}
	
	/*public void ImageStream(String fileValue, HttpServletRequest request, HttpServletResponse response) {
		URL url = new URL("http://wasabisyrup.com/storage/gallery/fPuCwwdez5o/pic_022 copy_b8AfeYsUeSI.jpg");
		
		InputStream is = null;
		OutputStream os = null;
		int read;
		try {
			response.setContentType("image/jpg");
			response.setHeader("Accept-Ranges", "bytes");
			
			is = new BufferedInputStream(url.openStream());
			os = response.getOutputStream();

			int bufferSize = 8*1024;
			byte buf[] = new byte[bufferSize];
			
			while ((read = is.read(buf, 0, 4096)) != -1) {
				os.write(buf, 0, read);
			}
			
			os.flush();
			os.close();
			is.close();
			
		} catch (Exception e) {
			e.toString();
		}
		
	}*/
}
