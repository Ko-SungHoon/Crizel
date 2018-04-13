package util;

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
		
		if("".equals(path)){
			path = "d:/";
		}
		File file = new File(path);
		
		List<Map<String,Object>> directoryList	= new ArrayList<Map<String,Object>>();
		List<String> fileList	  	= new ArrayList<String>();
		
		Map<String,Object> directoryMap = null;
		
		if(file.listFiles() != null){
			for(File ob : file.listFiles()){
				if(ob.isDirectory()){
					directoryMap = new HashMap<String,Object>();
					directoryMap.put("name", ob.getName());
					directoryMap.put("path", ob.getPath().replace("\\", "/"));
					directoryList.add(directoryMap);
				}else{
					fileList.add(ob.getName());
				}
			}
		}
		
		try{
			Collections.sort(fileList, new Comparator<String>() {
		        public int compare(String o1, String o2) {
		            return extractInt(o1) - extractInt(o2);
		        }
		        int extractInt(String s) {
		            String num = s.replaceAll("\\D", "");
		            // return 0 if no digits found
		            return num.isEmpty() ? 0 : Integer.parseInt(num);
		        }
		    });
		}catch(Exception e){
			System.out.println(e.toString());
		}
		
		map = new HashMap<String,Object>();
		map.put("folder", directoryList);
		map.put("file", fileList);
		
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
