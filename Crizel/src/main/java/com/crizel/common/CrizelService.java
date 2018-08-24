package com.crizel.common;

import java.awt.Image;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseWheelEvent;
import java.awt.event.MouseWheelListener;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.xml.parsers.ParserConfigurationException;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.xml.sax.SAXException;

import com.crizel.common.util.Nico;


@Service("service")
public class CrizelService {
	@Autowired
	CrizelDao dao;
	
	private static JLabel label;
	private static List<Image> imageList;
	private static int index;
	
	@Autowired
	public CrizelService(CrizelDao dao) {
		super();
		this.dao = dao;
	}

	public List<Object> list(String day) {
		return dao.list(day);
	}

	public List<Map<String,Object>> listDetail(String keyword, String type, String site, String mode) throws Exception {
		return dao.listDetail(keyword,type,site,mode);
	}

	public void listInsert(CrizelVo vo) {
		dao.listInsert(vo);
		
	}
	public void aniDelete(CrizelVo vo) {
		dao.aniDelete(vo);
	}
	public CrizelVo login(CrizelVo vo) {		
		return dao.login(vo);
		
	}
		
	public void register(CrizelVo vo) {
		dao.register(vo);	
		
	}
	public String registerCheck(String re_id) {
		return dao.registerCheck(re_id);
	}
	
	public List<Object> yes24(String keyword, String pageNumber) throws IOException {
		List<Object> list = new ArrayList<Object>();
		Map<String,Object> map = null;
		
		keyword = URLEncoder.encode(parseNull(keyword), "EUC-KR");
		pageNumber = pageNumber==null?"1":pageNumber;
        
		String URL = "http://www.yes24.com/searchcorner/Search?domain=ALL&query="+keyword+"&PageNumber="+pageNumber;
        Document doc = Jsoup.connect(URL).get();
        
        Elements div = doc.select(".goodsList.goodsList_list");
        
        if(div.size()>0){
        	Element elem = doc.select(".goodsList.goodsList_list").get(0);
            Elements elem2 = null;
            
            elem2 = elem.select(".goods_name.goods_icon a strong");
            for(int i=0; i<elem2.size(); i++){
            	map = new HashMap<String,Object>();
            	elem2 = elem.select(".goods_name.goods_icon a");
            	if(elem2.size() > i) map.put("addr", elem2.get(i).attr("href"));
            	
            	elem2 = elem.select(".goods_name.goods_icon a strong");
            	if(elem2.size() > i) map.put("name", elem2.get(i).text());
            	
            	elem2 = elem.select(".goods_price strong");
            	if(elem2.size() > i) map.put("price", elem2.get(i).text());
            	
            	elem2 = elem.select(".goods_img img");
            	if(elem2.size() > i) map.put("img", elem2.get(i).attr("src"));
            	
            	list.add(map);
            }
        }
        
		return list;
	}
	
	public List<Object> yes24Page(String keyword, String pageNumber) throws IOException {
		List<Object> list = new ArrayList<Object>();		
		keyword = URLEncoder.encode(parseNull(keyword), "EUC-KR");
		
		String URL = "http://www.yes24.com/searchcorner/Search?domain=ALL&query="+keyword+"&PageNumber="+pageNumber;
        Document doc = Jsoup.connect(URL).get();
        
        Elements div = doc.select(".goodsList.goodsList_list");
        if(div.size()>0){
        	Element elem = doc.select(".pagen.pat30.pab15").get(0);
    		Elements elem2 = elem.select("a");
            for(int i=0; i<elem2.size(); i++){
            	if("첫페이지".equals(elem2.get(i).text()) || "마지막페이지".equals(elem2.get(i).text())){
            		continue;
            	}else if("이전페이지".equals(elem2.get(i).text())){
            		list.add(Integer.parseInt(elem2.get(2).text())-2);
            	}else if("다음페이지".equals(elem2.get(i).text())){
            		list.add(Integer.parseInt(elem2.get(elem2.size()-3).text())+1);
            	}else{
            		list.add(elem2.get(i).text());
            	}
            }
        }
		return list;
	}
	
	public String parseNull(String value){
		if(value == null){
			value = "";
		}		
		return value;
	}
	public List<CrizelVo> json(String keyword) {
		return dao.json(keyword);
	}
	public List<Map<String, Object>> comic(String type, String keyword, String list, String img){
		List<Map<String,Object>> comicList = new ArrayList<Map<String,Object>>();
        Map<String,Object> comicMap = null;
        try{
        	String URL = "";
            if("A".equals(type)){
            	URL = "http://marumaru.in/?r=home&mod=search&keyword="+keyword;			
            }else if("B".equals(type)){
            	URL = "http://marumaru.in/"+list;
            }else{
            	URL = img;
            }
            
        	Document doc = Jsoup.connect(URL)
            		.userAgent("Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36")
    				.header("Accept-Encoding", "gzip")
    				.header("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8")
    				.header("Host", "wasabisyrup.com")
					.followRedirects(true)
					.get();
            Elements elem = null;
            
            if("A".equals(type)){
            	elem = doc.select(".postbox .subject");		
            }else if("B".equals(type)){
            	elem = doc.select(".content a");
            }else{
            	elem = doc.select(".lz-lazyload");
            }
            
            for (org.jsoup.nodes.Element e : elem) {
            	comicMap = new HashMap<String,Object>();
            	if("A".equals(type)){
            		if(!"".equals(parseNull(e.text()))){comicMap.put("title", e.text());}
            		if(!"".equals(parseNull(e.attr("href")))){comicMap.put("addr", e.attr("href"));}
                }else if("B".equals(type)){
                	if(!"".equals(parseNull(e.text()))){comicMap.put("title", e.text());}
            		if(!"".equals(parseNull(e.attr("href")))){comicMap.put("addr", e.attr("href"));}
                }
            	comicList.add(comicMap);
            }
            
        }catch(Exception e){
        	System.out.println("에러 : " + e.toString());
        }
        
		return comicList;
	}
	
	public void comicDown(String addr, String type) {
		if("A".equals(type)){
			List<Map<String,Object>> comicList = new ArrayList<Map<String,Object>>();
	        Map<String,Object> comicMap = null;
	        
			try{
	        	String URL = "http://marumaru.in/" + addr;
	        	String title = "";
	        	String sub_title = "";
	        	Document doc = Jsoup.connect(URL)
	            		.userAgent("Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36")
	            		.header("charset", "utf-8")
	    				.header("Accept-Encoding", "gzip")
	    				.data("pass", "qndxkr")
						.followRedirects(true)
						.get();
	            Elements elem = null;
	            
	            elem = doc.select(".content a");
	            
	            for (org.jsoup.nodes.Element e : elem) {
	            	comicMap = new HashMap<String,Object>();
	            	if(!"".equals(parseNull(e.text()))){comicMap.put("title", e.text());}
            		if(!"".equals(parseNull(e.attr("href")))){comicMap.put("addr", e.attr("href"));}
	            	comicList.add(comicMap);
	            }
	            
	            for(Map<String, Object> ob : comicList){
	            	URL = ob.get("addr").toString();
	            	doc = Jsoup.connect(URL)
		            		.userAgent("Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36")
		            		.header("charset", "utf-8")
		    				.header("Accept-Encoding", "gzip")
		    				.data("pass", "qndxkr")
							.followRedirects(true)
							.get();
	            	
	            	elem = doc.select(".title-subject");
		            for (org.jsoup.nodes.Element e : elem) {
		            	title = e.text();
		            }
		            
		            elem = doc.select(".article-title");
		            for (org.jsoup.nodes.Element e : elem) {
		            	sub_title = e.attr("title");
		            }
		            
		            elem = doc.select(".lz-lazyload");
		            String downDir = "D:/" + title + "/" + sub_title + "/";
		            
		            File desti = new File(downDir);
		          	if(!desti.exists()){
		          		desti.mkdirs();
		          	}

					System.out.println("-------Download Start------");
		            for (org.jsoup.nodes.Element e : elem) {
		            	fileUrlDownload("http://wasabisyrup.com" + e.attr("data-src"), downDir);
		            }
					System.out.println("-------Download End--------");
	            }
	            
	        }catch(Exception e){
	        	System.out.println("에러 : " + e.toString());
	        }
		}else{
			try{
	        	String URL = addr;
	        	String title = "";
	        	String sub_title = "";
	        	Document doc = Jsoup.connect(URL)
	            		.userAgent("Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36")
	            		.header("charset", "utf-8")
	    				.header("Accept-Encoding", "gzip")
	    				.data("pass", "qndxkr")
						.followRedirects(true)
						.get();
	            Elements elem = null;
	            
	            elem = doc.select(".title-subject");
	            for (org.jsoup.nodes.Element e : elem) {
	            	title = e.text();
	            }
	            
	            elem = doc.select(".article-title");
	            for (org.jsoup.nodes.Element e : elem) {
	            	sub_title = e.attr("title");
	            }
	            
	            elem = doc.select(".lz-lazyload");
	            String downDir = "D:/" + title + "/" + sub_title + "/";
	            
	            File desti = new File(downDir);
	          	if(!desti.exists()){
	          		desti.mkdirs();
	          	}

				System.out.println("-------Download Start------");
	            for (org.jsoup.nodes.Element e : elem) {
	            	fileUrlDownload("http://wasabisyrup.com" + e.attr("data-src"), downDir);
	            }
				System.out.println("-------Download End--------");
	        }catch(Exception e){
	        	System.out.println("에러 : " + e.toString());
	        }
		}
	}
	
	
	
	final static int size = 1024;
	
	public static void fileUrlReadAndDownload(String fileAddress, String localFileName, String downloadDir) {
		OutputStream outStream = null;
		URLConnection uCon = null;
		InputStream is = null;
		try {
			int byteRead;
			int byteWritten = 0;
			URL Url = new URL(fileAddress);
			outStream = new BufferedOutputStream(new FileOutputStream(downloadDir + "\\" + localFileName));
			uCon = Url.openConnection();
			uCon.addRequestProperty("User-Agent", "Mozilla/4.0");
			is = uCon.getInputStream();
			byte[] buf = new byte[size];
			while ((byteRead = is.read(buf)) != -1) {
				outStream.write(buf, 0, byteRead);
				byteWritten += byteRead;
			}
			System.out.println("Download Successfully.");
			System.out.println("File name : " + localFileName);
			System.out.println("of bytes  : " + byteWritten);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				is.close();
				outStream.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	public static void fileUrlDownload(String fileAddress, String downloadDir) {
		int slashIndex = fileAddress.lastIndexOf('/');
		int periodIndex = fileAddress.lastIndexOf('.');
		// 파일 어드레스에서 마지막에 있는 파일이름을 취득
		String fileName = fileAddress.substring(slashIndex + 1);
		if (periodIndex >= 1 && slashIndex >= 0
				&& slashIndex < fileAddress.length() - 1) {
			fileUrlReadAndDownload(fileAddress, fileName, downloadDir);
		} else {
			System.err.println("path or file name NG.");
		}
	}
	
	
	public void comicView(String addr) {
        List<String> imgList = new ArrayList<String>();
        
        try{
        	String URL = addr;
        	Document doc = Jsoup.connect(URL)
            		.userAgent("Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36")
            		.header("charset", "utf-8")
    				.header("Accept-Encoding", "gzip")
    				.data("pass", "qndxkr")
					.followRedirects(true)
					.get();
            Elements elem = null;
            
            elem = doc.select(".lz-lazyload");
            
            for (org.jsoup.nodes.Element e : elem) {
            	imgList.add("http://wasabisyrup.com" + e.attr("data-src"));
            }
            
            if(imgList!=null && imgList.size()>0){
            	Image image = null;
            	imageList = new ArrayList<Image>();
        		
        		URLConnection uCon = null;
        		InputStream is = null;
        		
                try {
                	for(int i=0; i<imgList.size(); i++){
        	        	URL url = new URL(imgList.get(i));
        	        	uCon = url.openConnection();
        				uCon.addRequestProperty("User-Agent", "Mozilla/4.0");
        				is = uCon.getInputStream();
        	            image = ImageIO.read(is);
        	            imageList.add(image);
                	}
                } catch (IOException ee) {
                	ee.printStackTrace();
                }
                
                int width = imageList.get(0).getWidth(null);
                int height = imageList.get(0).getHeight(null);
                final int size = imageList.size();
                index = 0;
                
        		JFrame frame = new JFrame();
                frame.setBounds(10, 10, (int)(width*0.7), (int)(height*0.7));
                label = new JLabel(new ImageIcon(imageList.get(index)));
                frame.addKeyListener(new KeyListener() {
                    public void keyPressed(KeyEvent e) { 
                    	if(e.getKeyCode() == 37 || e.getKeyCode() == 38){
                    		if(index > 0){
                    			index--;
                        		label.setIcon(new ImageIcon(imageList.get(index)));
                    		}else if(index == 0){
                    			index--;
                    			label.setIcon(null);
                    			label.setText("첫 페이지");
                    		}else{
                    			index = size-1;
                    			label.setIcon(new ImageIcon(imageList.get(index)));
                    		}
                    	}else if(e.getKeyCode() == 39 || e.getKeyCode() == 40){
                    		if(index < size-1){
                    			index++;
                        		label.setIcon(new ImageIcon(imageList.get(index)));
                    		}else if(index == size-1){
                    			index++;
                    			label.setIcon(null);
                    			label.setText("마지막 페이지");
                    		}else{
                    			index = 0;
                    			label.setIcon(new ImageIcon(imageList.get(index)));
                    		}
                    	}else if(e.getKeyCode() == 27){
                    		System.exit(0);
                    	}
                    }
                    public void keyReleased(KeyEvent e) { 
                    }
                    public void keyTyped(KeyEvent e) { 
                    }
                });
                
                frame.addMouseWheelListener(new MouseWheelListener() {
        			@Override
        			public void mouseWheelMoved(MouseWheelEvent e) {
        				if(e.getWheelRotation() == -1){
        					if(index > 0){
                    			index--;
                        		label.setIcon(new ImageIcon(imageList.get(index)));
                    		}else if(index == 0){
                    			index--;
                    			label.setIcon(null);
                    			label.setText("첫 페이지");
                    		}else{
                    			index = size-1;
                    			label.setIcon(new ImageIcon(imageList.get(index)));
                    		}
                    	}else if(e.getWheelRotation() == 1){
                    		if(index < size-1){
                    			index++;
                        		label.setIcon(new ImageIcon(imageList.get(index)));
                    		}else if(index == size-1){
                    			index++;
                    			label.setIcon(null);
                    			label.setText("마지막 페이지");
                    		}else{
                    			index = 0;
                    			label.setIcon(new ImageIcon(imageList.get(index)));
                    		}
                    	}
        			}
        		});
                
                frame.add(label);
                frame.pack();
                frame.setFocusable(true);
                frame.setLocationRelativeTo(null);
                frame.setVisible(true);
            }
        }catch(Exception e){
        	System.out.println("에러 : " + e.toString());
        }
	}

	public Object nico(String keyword, String type, String url) {
		Nico nico = new Nico();
		return nico.data(keyword, type, url);
	}

	public List<Object> comicList() {
		return dao.comicList();
	}

	public void comicInsert(CrizelVo vo) {
		dao.comicInsert(vo);
	}

	public void comicDelete(CrizelVo vo) {
		dao.comicDelete(vo);
	}

	public void comicViewCheck(Map<String, Object> map) {
		dao.comicViewCheck(map);
	}

	public List<Map<String, Object>> comicViewList(String addr) {
		return dao.comicViewList(addr);
	}

	public String lastTitle(String ani_id) {
		return dao.lastTitle(ani_id);
	}

	public void lastTitleInsert(Map<String, Object> map) {
		dao.lastTitleInsert(map);
	}

	public CrizelVo aniInfo(String ani_id) {
		return dao.aniInfo(ani_id);
	}

	public void listUpdate(CrizelVo vo) {
		dao.listUpdate(vo);
	}

}
