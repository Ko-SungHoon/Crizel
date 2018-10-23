package com.crizel.directory;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DirectoryView {
	public Map<String,Object> directory(String path){
		Map<String,Object> map = null;
		try{
			if("".equals(path)){
				path = "E:/";
			}
			File file = new File(path);
			
			List<Map<String,Object>> directoryList	= new ArrayList<Map<String,Object>>();
			List<Map<String,Object>> fileList	  	= new ArrayList<Map<String,Object>>();
			
			Map<String,Object> directoryMap = null;
			Map<String,Object> fileMap = null;
			
			if(file.listFiles() != null){
				for(File ob : file.listFiles()){
					if(ob.isDirectory()){
						directoryMap = new HashMap<String,Object>();
						directoryMap.put("name", ob.getName());
						directoryMap.put("path", ob.getPath().replace("\\", "/"));
						directoryList.add(directoryMap);
					}else{
						fileMap = new HashMap<String,Object>();
						fileMap.put("name", ob.getName());
						
						if(ob.getName().split("\\.").length>=2){
							if("jpg".equals(ob.getName().split("\\.")[1]) || "JPG".equals(ob.getName().split("\\.")[1])
									|| "png".equals(ob.getName().split("\\.")[1]) || "PNG".equals(ob.getName().split("\\.")[1])
									|| "jpeg".equals(ob.getName().split("\\.")[1]) || "JPEG".equals(ob.getName().split("\\.")[1])
									|| "bmp".equals(ob.getName().split("\\.")[1]) || "BMP".equals(ob.getName().split("\\.")[1])
									|| "gif".equals(ob.getName().split("\\.")[1]) || "GIF".equals(ob.getName().split("\\.")[1])
											){
										fileMap.put("type", "img");
									}else if("ogg".equals(ob.getName().split("\\.")[1]) || "OGG".equals(ob.getName().split("\\.")[1])
											|| "mp4".equals(ob.getName().split("\\.")[1]) || "MP4".equals(ob.getName().split("\\.")[1])
											|| "mkv".equals(ob.getName().split("\\.")[1]) || "MKV".equals(ob.getName().split("\\.")[1])
											|| "webm".equals(ob.getName().split("\\.")[1]) || "WEBM".equals(ob.getName().split("\\.")[1])
											){
										fileMap.put("type", "video");
									}else if("mp3".equals(ob.getName().split("\\.")[1]) || "MP3".equals(ob.getName().split("\\.")[1])
											|| "ogg".equals(ob.getName().split("\\.")[1]) || "OGG".equals(ob.getName().split("\\.")[1])
											|| "wma".equals(ob.getName().split("\\.")[1]) || "WMA".equals(ob.getName().split("\\.")[1])
											|| "flac".equals(ob.getName().split("\\.")[1]) || "FLAC".equals(ob.getName().split("\\.")[1])
											){
										fileMap.put("type", "music");
									}else{
										fileMap.put("type", "file");
									}
						}else{
							fileMap.put("type", "file");
						}
						fileList.add(fileMap);
					}
				}
			}
			
			try{
				Collections.sort(fileList, new Comparator<Map<String,Object>>() {
			        public int compare(Map<String, Object> o1, Map<String, Object> o2) {
			            return extractInt(o1.get("name").toString()) - extractInt(o2.get("name").toString());
			        }
			        int extractInt(String s) {
			            String num = s.replaceAll("\\D", "");
			            // return 0 if no digits found
			            return num.isEmpty() ? 0 : Integer.parseInt(num);
			        }
			    });
			}catch(Exception e){
				System.out.println("정렬 에러 : " + e.toString());
			}
			
			map = new HashMap<String,Object>();
			map.put("folder", directoryList);
			map.put("file", fileList);
		}catch(Exception e){
			System.out.println("디렉토리 전체 에러 : " + e.toString());
		}
		return map;
	}
	
	public List<String> directAllImg(String path) throws Exception{
		Map<String,Object> map = directory(path);
		List<String> list = (List<String>)map.get("file"); 
		List<String> imgList = new ArrayList<String>();
		
		for(String ob : list){
			if(extCheck(ob)){
				imgList.add(URLEncoder.encode(path + ob, "UTF-8"));
			}
		}
		
		return imgList;
	}
	
	public boolean extCheck(String value){
		int index = value.lastIndexOf(".");
		int length = value.length();
		String ext = value.substring(index+1, length).toUpperCase();
		
		if("JPG".equals(ext) || "PNG".equals(ext) ||"GIF".equals(ext) ||"JPEG".equals(ext) ||"BMF".equals(ext) ){
			return true;
		}else{
			return false;
		}
	}
}
