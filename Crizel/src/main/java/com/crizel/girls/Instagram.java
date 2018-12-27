package com.crizel.girls;
import java.awt.image.BufferedImage;
import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import javax.imageio.ImageIO;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class Instagram {
	public static void main(String[] args) {
		Instagram in = new Instagram();
		in.getList("https://www.instagram.com/ayoungshinn/");
	}
	
	public List<Object> getList(String addr){		
		List<Object> imgList 	= new ArrayList<Object>();
		String URL 				= null;
        Document doc 			= null;
        Elements elem			= null;
        URL 					= addr;
        String jsonStr			= "";
		
		try {
			doc = Jsoup.connect(URL)
					.userAgent("Mozilla")
					.get();
			
			elem = doc.select("script");
			
			for (Element e : elem) {
				if(e.html().length() != e.html().replace("window._sharedData = {", "").length()){
					jsonStr = e.html().substring(e.html().indexOf("{")-1, e.html().lastIndexOf("}")+1); 
				}
			}
			
			JSONParser parser = new JSONParser();
		    Object obj = parser.parse( jsonStr );
		    JSONObject object = (JSONObject) obj;
			JSONObject entry_data = (JSONObject) object.get("entry_data");
			JSONArray ProfilePage = (JSONArray) entry_data.get("ProfilePage");
			JSONObject ProfilePage_0 = (JSONObject) ProfilePage.get(0);
			JSONObject graphql = (JSONObject) ProfilePage_0.get("graphql");
			JSONObject user = (JSONObject) graphql.get("user");
			JSONObject edge_owner_to_timeline_media = (JSONObject) user.get("edge_owner_to_timeline_media");
			JSONArray edges = (JSONArray) edge_owner_to_timeline_media.get("edges");
			
			for(int i=0; i<edges.size(); i++){
				JSONObject node = (JSONObject)((JSONObject)edges.get(i)).get("node");
				//System.out.println(node.get("display_url").toString());
				imgList.add(node.get("display_url").toString());
			}
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		return imgList;
	}
}
