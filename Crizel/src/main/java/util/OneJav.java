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


public class OneJav {
	/*public static void main(String[] args) throws Exception {
		OneJav oj = new OneJav();
		String addr			= "/torrent/mudr032";
		
		oj.getList("http://www.onejav.com/2018/04/16");
		
		//oj.getView("http://www.onejav.com/" + addr);
		
	}*/
	
	public List<Map<String,Object>> getList(String addr){
		String URL 						= addr;
        Document doc 					= null;
        List<Map<String,Object>> list 	= new ArrayList<Map<String,Object>>();
        Map<String,Object> map			= null;
        
        Elements imgElem 				= null;
        Elements linkElem 				= null;
        
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
		
		imgElem = doc.select(".card.mb-3 .image");
		linkElem = doc.select(".card.mb-3 .title.is-4.is-spaced a");
		
		for(int i=0; i<imgElem.size(); i++){
			map = new HashMap<String,Object>();
			Element img = imgElem.get(i);
			Element link = linkElem.get(i);
			
			map.put("img", img.attr("src"));
			map.put("addr", "http://www.onejav.com/" + getView("http://www.onejav.com/" + link.attr("href")));
			map.put("title", link.text());
			
			list.add(map);
		}
		
        return list;
	}
	
	public String getView(String addr){
		String URL 						= addr;
        Document doc 					= null;
        Elements linkElem 				= null;
        
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
        
        linkElem = doc.select(".button.is-primary.is-fullwidth");
        
		Element link = linkElem.get(0);
        
		addr = link.attr("href");
		
        return addr;
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
