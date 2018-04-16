package util;
import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;


public class Maru {
	/*public static void main(String[] args) throws Exception {
		Maru mr = new Maru();
		String keyword 		= "원펀맨";
		String comicHref	= "/b/manga/65484";
		String viewHref		= "http://wasabisyrup.com/archives/dV2kjMEzbzs";
		
		//mr.getList("http://marumaru.in/?r=home&mod=search&keyword=" + URLEncoder.encode(keyword, "UTF-8"));
		
		//mr.getComic("http://marumaru.in/" + comicHref);
		
		mr.getView(viewHref);
		
	}*/
	
	public List<Map<String,Object>> getList(String addr){
		String URL 						= addr;
        Document doc 					= null;
        List<Map<String,Object>> list 	= new ArrayList<Map<String,Object>>();
        Map<String,Object> map			= null;
        
        Elements hrefElem 				= null;
        Elements titleElem 				= null;
        
		try {
			doc = Jsoup.connect(URL)
					.userAgent("Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36")
            		.header("charset", "utf-8")
    				.header("Accept-Encoding", "gzip")
					.get();
			//System.out.println(doc);
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		
		hrefElem = doc.select("#s_post .postbox a");
		titleElem = doc.select("#s_post .postbox a .sbjbox b");
		
		for(int i=0; i<hrefElem.size(); i++){
			map = new HashMap<String,Object>();
			Element href = hrefElem.get(i);
			Element title = titleElem.get(i);
			
			map.put("addr", href.attr("href"));
			map.put("title", title.text());
			list.add(map);
		}
		
        return list;
	}
	
	public List<Map<String,Object>> getComic(String addr){
		String URL 						= addr;
        Document doc 					= null;
        List<Map<String,Object>> list 	= new ArrayList<Map<String,Object>>();
        Map<String,Object> map			= null;
        
        Elements hrefElem 				= null;
        
        try {
			doc = Jsoup.connect(URL)
					.userAgent("Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36")
            		.header("charset", "utf-8")
    				.header("Accept-Encoding", "gzip")
					.get();
			//System.out.println(doc);
		} catch (IOException e1) {
			e1.printStackTrace();
		}
        
        hrefElem = doc.select("#vContent a");
        
        for(int i=0; i<hrefElem.size(); i++){
			map = new HashMap<String,Object>();
			Element href = hrefElem.get(i);
			
			map.put("addr", href.attr("href"));
			map.put("title", href.text());
			list.add(map);
		}
        
        return list;
	}
	
	
	public List<String> getView(String addr){
		String URL 						= addr;
        Document doc 					= null;
        List<String> list 				= new ArrayList<String>();
        
        Elements imgElem 				= null;
        
        try {
			doc = Jsoup.connect(URL)
					.userAgent("Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36")
            		.header("charset", "utf-8")
    				.header("Accept-Encoding", "gzip")
					.get();
			//System.out.println(doc);
		} catch (IOException e1) {
			e1.printStackTrace();
		}
        
        imgElem = doc.select(".gallery-template img");
        
        for(int i=0; i<imgElem.size(); i++){
			Element img = imgElem.get(i);
			list.add("http://wasabisyrup.com/" + img.attr("data-src"));
		}
        
        return list;
	}
	
	public void ImageStream(String addr, HttpServletRequest request, HttpServletResponse response) throws Exception {
		URL url = new URL(addr);
		URLConnection uc = url.openConnection();
		uc.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36");
		uc.setRequestProperty("charset", "utf-8");
		uc.setRequestProperty("Accept-Encoding", "gzip");
		
		InputStream is = null;
		OutputStream os = null;
		int read;
		try {
			response.setContentType("image/jpg");
			response.setHeader("Accept-Ranges", "bytes");
			
			is = new BufferedInputStream(uc.getInputStream());
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
			System.out.println(e.toString());
		}
		
	}
}
