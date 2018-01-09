package util;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;

public class BattleGround {
	
	public Map<String, Object> pubg(String nickname, String region, String mode) throws IOException{
		Map<String, Object> returnMap = new HashMap<String, Object>();
		String URL = "https://api.pubgtracker.com/v2/profile/pc/" + nickname + "?region="+region + "&mode=" + mode;
		Document doc = Jsoup.connect(URL)
                .header("TRN-Api-Key", "a6b21ff8-9eb5-4d85-ba9e-4d6a67143290")
                .userAgent("Mozilla")
                .ignoreContentType(true)
				.get();
		String text = "";
		
		Elements elem = null;
		elem = doc.select("body");	
		for (org.jsoup.nodes.Element e : elem) {
			text += e.text();
        }
		
		InputStream is = new ByteArrayInputStream(text.getBytes("UTF-8"));
		InputStreamReader isr = new InputStreamReader(is, "UTF-8");
		JSONObject jobj = (JSONObject) JSONValue.parse(isr);
		nickname = (String)jobj.get("nickname");
		
		Map<String,Object> krjpMap_solo = new HashMap<String,Object>();
		Map<String,Object> krjpMap_duo = new HashMap<String,Object>();
		Map<String,Object> krjpMap_squad = new HashMap<String,Object>();
		
		Map<String,Object> aggMap_solo = new HashMap<String,Object>();
		Map<String,Object> aggMap_duo = new HashMap<String,Object>();
		Map<String,Object> aggMap_squad = new HashMap<String,Object>();

		/*Array로 받을 경우*/ 
		JSONArray bodyArray = (JSONArray) jobj.get("stats");
		
		if(bodyArray != null && bodyArray.size() > 0){
			for (int i = 0; i < bodyArray.size(); i++) {
				JSONObject data = (JSONObject) bodyArray.get(i);
				JSONArray arr2 = (JSONArray) data.get("stats");
				for (int j = 0; j < arr2.size(); j++) {
					JSONObject data2 = (JSONObject) arr2.get(j);
					if("krjp".equals(data.get("region").toString())){
						if("solo".equals(data.get("mode").toString())){
							krjpMap_solo.putAll(toMap(data2.keySet().toString(), data2.values().toString()));
						}else if("duo".equals(data.get("mode").toString())){
							krjpMap_duo.putAll(toMap(data2.keySet().toString(), data2.values().toString()));
						}else if("squad".equals(data.get("mode").toString())){
							krjpMap_squad.putAll(toMap(data2.keySet().toString(), data2.values().toString()));
						}
					}else if("agg".equals(data.get("region").toString())){
						if("solo".equals(data.get("mode").toString())){
							aggMap_solo.putAll(toMap(data2.keySet().toString(), data2.values().toString()));
						}else if("duo".equals(data.get("mode").toString())){
							aggMap_duo.putAll(toMap(data2.keySet().toString(), data2.values().toString()));
						}else if("squad".equals(data.get("mode").toString())){
							aggMap_squad.putAll(toMap(data2.keySet().toString(), data2.values().toString()));
						}
					}
				}
			}
			returnMap.put("searchResult", "Y");
			returnMap.put("nickname", nickname);
			
			if("krjp".equals(region)){
				if("solo".equals(mode)){
					returnMap.put("resultMap", krjpMap_solo);
				}else if("duo".equals(mode)){
					returnMap.put("resultMap", krjpMap_duo);
				}else if("squad".equals(mode)){
					returnMap.put("resultMap", krjpMap_squad);
				}
			}else if("agg".equals(region)){
				if("solo".equals(mode)){
					returnMap.put("resultMap", aggMap_solo);
				}else if("duo".equals(mode)){
					returnMap.put("resultMap", aggMap_duo);
				}else if("squad".equals(mode)){
					returnMap.put("resultMap", aggMap_squad);
				}
			}
			
		}else{
			returnMap.put("searchResult", "N");
		}
		return returnMap;
	}
	
	public static Map<String,Object> toMap(String keySet, String values){
		Map<String,Object> map = new HashMap<String,Object>();
		
		String[] arrKey = keySet.replace("[","").replace("]", "").replace(" ", "").split(",");
		String[] arrVal = values.replace("[","").replace("]", "").replace(" ", "").split(",");
		String key = "";
		String val = "";
		String keyName = arrVal[0];
		for(int k=0; k<arrKey.length; k++){
			if(arrKey[k] != null && !"".equals(arrKey[k])){key = arrKey[k];}
			if(arrVal[k] != null && !"".equals(arrVal[k])){val = arrVal[k];}
			if(!"".equals(key) && !"".equals(val)){
				if("value".equals(key)){
					map.put(keyName, val);
				}else{
					map.put(keyName + "_" + key, val);
				}
				
				System.out.println(keyName + "_" + key + " ~ " + map.get("VehicleDestroys_field") + " ~ " + val);
				continue;
			}
		}
		System.out.println("*******************************************************");
		return map;		
	}
	
	public static String parseNull(String value){
		return value==null?"":value;
	}
	
	public static String parseNull(Object object){
		String value = "";
		if(object != null){
			value = object.toString();
		}
		return value;
	}

}
