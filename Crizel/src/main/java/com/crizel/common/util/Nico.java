package com.crizel.common.util;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;

public class Nico {
	public Object data(String keyword, String type, String URL) {
		String replaceStr = URL;
		Document doc = null;
		Elements elem = null;
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		String video = "";
		
		if("A".equals(type)){
			/*받아 온 키워드를 인코딩해서 변환한다*/
			try {
				keyword = URLEncoder.encode(keyword, "UTF-8");
			} catch (UnsupportedEncodingException e) {
				System.out.println(e.toString());
			}
			/*키워드로 검색한 목록을 출력한다*/
			URL = "http://www.nicovideo.jp/search/" + keyword + "?track=nicouni_search_keyword";
			doc = docCreate(URL);
			elem = doc.select(".item .itemContent .itemTitle a");
			for (org.jsoup.nodes.Element e : elem) {
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("title", e.text());
				map.put("addr", "http://www.nicovideo.jp" + e.attr("href"));
				list.add(map);
	        }
			return list;
		}else{
			/*목록에서 선택 한 페이지 내 정보를 출력한다*/
			replaceStr = URL.split("/")[URL.split("/").length-1];								//URL 중 sm32153958 같은 고유 번호를 찾아낸다
			doc = docCreate(URL);
			elem = doc.select("script");														//자바스크립트
			for (org.jsoup.nodes.Element e : elem) {
				if(e.attr("src").length() != e.attr("src").replace(replaceStr, "").length()){	//고유번호가 포함되어 있는 자바스크립트를 골라낸다
					URL = e.attr("src");
				}
	        }
			
			/*상세페이지 내에서 찾아낸 자바스크립트를 열어서 영상 주소를 받아온다*/
			doc = docCreate(URL);
			String a = doc.toString();					
			String[] b = a.split("'");				// ' 을 기준으로 전체 페이지를 나눈다
			for(String ob : b){
				if(ob.contains("http")){			// ' 을 기준으로 나눈 텍스트 중 http가 포함되어 있으면 영상 주소이기에 찾아낸다
					video = ob;
				}
			}
			return video;
		}
	}
	
	public static Document docCreate(String URL){
		Document doc = null;
		try {
			doc = Jsoup.connect(URL)
					.userAgent("Mozilla")
			        .ignoreContentType(true)
					.get();
		} catch (IOException e) {
			System.out.println(e.toString());
			e.printStackTrace();
		}
		
		return doc;
	}
}
