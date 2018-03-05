package util;

import java.io.File;
import java.util.ArrayList;
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
		
		map = new HashMap<String,Object>();
		map.put("folder", directoryList);
		map.put("file", fileList);
		
		return map;
	}
}
